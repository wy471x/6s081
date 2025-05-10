
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
    80000016:	249050ef          	jal	80005a5e <start>

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
    8000005e:	44c080e7          	jalr	1100(ra) # 800064a6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	4ec080e7          	jalr	1260(ra) # 8000655a <release>
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
    8000008e:	ea2080e7          	jalr	-350(ra) # 80005f2c <panic>

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
    800000fa:	320080e7          	jalr	800(ra) # 80006416 <initlock>
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
    80000132:	378080e7          	jalr	888(ra) # 800064a6 <acquire>
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
    8000014a:	414080e7          	jalr	1044(ra) # 8000655a <release>

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
    80000174:	3ea080e7          	jalr	1002(ra) # 8000655a <release>
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
    80000324:	c90080e7          	jalr	-880(ra) # 80000fb0 <cpuid>
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
    80000340:	c74080e7          	jalr	-908(ra) # 80000fb0 <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	c28080e7          	jalr	-984(ra) # 80005f76 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00002097          	auipc	ra,0x2
    80000362:	95a080e7          	jalr	-1702(ra) # 80001cb8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	0ae080e7          	jalr	174(ra) # 80005414 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	206080e7          	jalr	518(ra) # 80001574 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	ac6080e7          	jalr	-1338(ra) # 80005e3c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	e00080e7          	jalr	-512(ra) # 8000617e <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	be8080e7          	jalr	-1048(ra) # 80005f76 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	bd8080e7          	jalr	-1064(ra) # 80005f76 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	bc8080e7          	jalr	-1080(ra) # 80005f76 <printf>
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
    800003d2:	b26080e7          	jalr	-1242(ra) # 80000ef4 <procinit>
    trapinit();      // trap vectors
    800003d6:	00002097          	auipc	ra,0x2
    800003da:	8ba080e7          	jalr	-1862(ra) # 80001c90 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00002097          	auipc	ra,0x2
    800003e2:	8da080e7          	jalr	-1830(ra) # 80001cb8 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	014080e7          	jalr	20(ra) # 800053fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	026080e7          	jalr	38(ra) # 80005414 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	124080e7          	jalr	292(ra) # 8000251a <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	7b0080e7          	jalr	1968(ra) # 80002bae <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	754080e7          	jalr	1876(ra) # 80003b5a <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	126080e7          	jalr	294(ra) # 80005534 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	f22080e7          	jalr	-222(ra) # 80001338 <userinit>
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
    80000484:	aac080e7          	jalr	-1364(ra) # 80005f2c <panic>
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
    800005a6:	00006097          	auipc	ra,0x6
    800005aa:	986080e7          	jalr	-1658(ra) # 80005f2c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00006097          	auipc	ra,0x6
    800005ba:	976080e7          	jalr	-1674(ra) # 80005f2c <panic>
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
    80000602:	00006097          	auipc	ra,0x6
    80000606:	92a080e7          	jalr	-1750(ra) # 80005f2c <panic>

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
    800006ce:	788080e7          	jalr	1928(ra) # 80000e52 <proc_mapstacks>
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
    8000074c:	7e4080e7          	jalr	2020(ra) # 80005f2c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	7d4080e7          	jalr	2004(ra) # 80005f2c <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	7c4080e7          	jalr	1988(ra) # 80005f2c <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	7b4080e7          	jalr	1972(ra) # 80005f2c <panic>
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
    80000870:	6c0080e7          	jalr	1728(ra) # 80005f2c <panic>

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
    800009bc:	574080e7          	jalr	1396(ra) # 80005f2c <panic>
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
    80000a9a:	496080e7          	jalr	1174(ra) # 80005f2c <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	486080e7          	jalr	1158(ra) # 80005f2c <panic>
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
    80000b14:	41c080e7          	jalr	1052(ra) # 80005f2c <panic>

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

0000000080000cee <print_table>:

void print_table(pagetable_t pagetable, int level)
{
    80000cee:	711d                	addi	sp,sp,-96
    80000cf0:	ec86                	sd	ra,88(sp)
    80000cf2:	e8a2                	sd	s0,80(sp)
    80000cf4:	e4a6                	sd	s1,72(sp)
    80000cf6:	e0ca                	sd	s2,64(sp)
    80000cf8:	fc4e                	sd	s3,56(sp)
    80000cfa:	f852                	sd	s4,48(sp)
    80000cfc:	f456                	sd	s5,40(sp)
    80000cfe:	f05a                	sd	s6,32(sp)
    80000d00:	ec5e                	sd	s7,24(sp)
    80000d02:	e862                	sd	s8,16(sp)
    80000d04:	e466                	sd	s9,8(sp)
    80000d06:	e06a                	sd	s10,0(sp)
    80000d08:	1080                	addi	s0,sp,96
    80000d0a:	892e                	mv	s2,a1
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000d0c:	8b2a                	mv	s6,a0
    80000d0e:	4a01                	li	s4,0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d10:	4c05                	li	s8,1
      print_table((pagetable_t)child, level + 1);
    } else if(pte & PTE_V){
      for (int j = 0; j < level; j++){
        printf(" ..");
      }
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d12:	00007d17          	auipc	s10,0x7
    80000d16:	44ed0d13          	addi	s10,s10,1102 # 80008160 <etext+0x160>
      for (int j = 0; j < level; j++){
    80000d1a:	4c81                	li	s9,0
        printf(" ..");
    80000d1c:	00007a97          	auipc	s5,0x7
    80000d20:	43ca8a93          	addi	s5,s5,1084 # 80008158 <etext+0x158>
  for(int i = 0; i < 512; i++){
    80000d24:	20000b93          	li	s7,512
    80000d28:	a085                	j	80000d88 <print_table+0x9a>
      for (int j = 0; j < level; j++){
    80000d2a:	01205b63          	blez	s2,80000d40 <print_table+0x52>
    80000d2e:	84e6                	mv	s1,s9
        printf(" ..");
    80000d30:	8556                	mv	a0,s5
    80000d32:	00005097          	auipc	ra,0x5
    80000d36:	244080e7          	jalr	580(ra) # 80005f76 <printf>
      for (int j = 0; j < level; j++){
    80000d3a:	2485                	addiw	s1,s1,1
    80000d3c:	fe991ae3          	bne	s2,s1,80000d30 <print_table+0x42>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d40:	00a9d493          	srli	s1,s3,0xa
    80000d44:	04b2                	slli	s1,s1,0xc
    80000d46:	86a6                	mv	a3,s1
    80000d48:	864e                	mv	a2,s3
    80000d4a:	85d2                	mv	a1,s4
    80000d4c:	00007517          	auipc	a0,0x7
    80000d50:	41450513          	addi	a0,a0,1044 # 80008160 <etext+0x160>
    80000d54:	00005097          	auipc	ra,0x5
    80000d58:	222080e7          	jalr	546(ra) # 80005f76 <printf>
      print_table((pagetable_t)child, level + 1);
    80000d5c:	0019059b          	addiw	a1,s2,1
    80000d60:	8526                	mv	a0,s1
    80000d62:	00000097          	auipc	ra,0x0
    80000d66:	f8c080e7          	jalr	-116(ra) # 80000cee <print_table>
    80000d6a:	a819                	j	80000d80 <print_table+0x92>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000d6c:	00a9d693          	srli	a3,s3,0xa
    80000d70:	06b2                	slli	a3,a3,0xc
    80000d72:	864e                	mv	a2,s3
    80000d74:	85d2                	mv	a1,s4
    80000d76:	856a                	mv	a0,s10
    80000d78:	00005097          	auipc	ra,0x5
    80000d7c:	1fe080e7          	jalr	510(ra) # 80005f76 <printf>
  for(int i = 0; i < 512; i++){
    80000d80:	2a05                	addiw	s4,s4,1
    80000d82:	0b21                	addi	s6,s6,8 # 1008 <_entry-0x7fffeff8>
    80000d84:	037a0763          	beq	s4,s7,80000db2 <print_table+0xc4>
    pte_t pte = pagetable[i];
    80000d88:	000b3983          	ld	s3,0(s6)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d8c:	00f9f793          	andi	a5,s3,15
    80000d90:	f9878de3          	beq	a5,s8,80000d2a <print_table+0x3c>
    } else if(pte & PTE_V){
    80000d94:	0019f793          	andi	a5,s3,1
    80000d98:	d7e5                	beqz	a5,80000d80 <print_table+0x92>
      for (int j = 0; j < level; j++){
    80000d9a:	fd2059e3          	blez	s2,80000d6c <print_table+0x7e>
    80000d9e:	84e6                	mv	s1,s9
        printf(" ..");
    80000da0:	8556                	mv	a0,s5
    80000da2:	00005097          	auipc	ra,0x5
    80000da6:	1d4080e7          	jalr	468(ra) # 80005f76 <printf>
      for (int j = 0; j < level; j++){
    80000daa:	2485                	addiw	s1,s1,1
    80000dac:	fe991ae3          	bne	s2,s1,80000da0 <print_table+0xb2>
    80000db0:	bf75                	j	80000d6c <print_table+0x7e>
    }
  }
}
    80000db2:	60e6                	ld	ra,88(sp)
    80000db4:	6446                	ld	s0,80(sp)
    80000db6:	64a6                	ld	s1,72(sp)
    80000db8:	6906                	ld	s2,64(sp)
    80000dba:	79e2                	ld	s3,56(sp)
    80000dbc:	7a42                	ld	s4,48(sp)
    80000dbe:	7aa2                	ld	s5,40(sp)
    80000dc0:	7b02                	ld	s6,32(sp)
    80000dc2:	6be2                	ld	s7,24(sp)
    80000dc4:	6c42                	ld	s8,16(sp)
    80000dc6:	6ca2                	ld	s9,8(sp)
    80000dc8:	6d02                	ld	s10,0(sp)
    80000dca:	6125                	addi	sp,sp,96
    80000dcc:	8082                	ret

0000000080000dce <vmprint>:

void vmprint(pagetable_t pagetable)
{
    80000dce:	7139                	addi	sp,sp,-64
    80000dd0:	fc06                	sd	ra,56(sp)
    80000dd2:	f822                	sd	s0,48(sp)
    80000dd4:	f426                	sd	s1,40(sp)
    80000dd6:	f04a                	sd	s2,32(sp)
    80000dd8:	ec4e                	sd	s3,24(sp)
    80000dda:	e852                	sd	s4,16(sp)
    80000ddc:	e456                	sd	s5,8(sp)
    80000dde:	e05a                	sd	s6,0(sp)
    80000de0:	0080                	addi	s0,sp,64
    80000de2:	892a                	mv	s2,a0
  printf("page table %p\n", pagetable);
    80000de4:	85aa                	mv	a1,a0
    80000de6:	00007517          	auipc	a0,0x7
    80000dea:	39250513          	addi	a0,a0,914 # 80008178 <etext+0x178>
    80000dee:	00005097          	auipc	ra,0x5
    80000df2:	188080e7          	jalr	392(ra) # 80005f76 <printf>
  //       }
  //     }
  //   }
  // }
  // recursive method.
  for (int i = 0; i < 512; i++){
    80000df6:	4481                	li	s1,0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80000df8:	4a05                	li	s4,1
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      printf("..%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000dfa:	00007b17          	auipc	s6,0x7
    80000dfe:	38eb0b13          	addi	s6,s6,910 # 80008188 <etext+0x188>
  for (int i = 0; i < 512; i++){
    80000e02:	20000993          	li	s3,512
    80000e06:	a029                	j	80000e10 <vmprint+0x42>
    80000e08:	2485                	addiw	s1,s1,1
    80000e0a:	0921                	addi	s2,s2,8
    80000e0c:	03348963          	beq	s1,s3,80000e3e <vmprint+0x70>
    pte_t pte = pagetable[i];
    80000e10:	00093603          	ld	a2,0(s2)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0) {
    80000e14:	00f67793          	andi	a5,a2,15
    80000e18:	ff4798e3          	bne	a5,s4,80000e08 <vmprint+0x3a>
      uint64 child = PTE2PA(pte);
    80000e1c:	00a65a93          	srli	s5,a2,0xa
    80000e20:	0ab2                	slli	s5,s5,0xc
      printf("..%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80000e22:	86d6                	mv	a3,s5
    80000e24:	85a6                	mv	a1,s1
    80000e26:	855a                	mv	a0,s6
    80000e28:	00005097          	auipc	ra,0x5
    80000e2c:	14e080e7          	jalr	334(ra) # 80005f76 <printf>
      print_table((pagetable_t)child, 2);
    80000e30:	4589                	li	a1,2
    80000e32:	8556                	mv	a0,s5
    80000e34:	00000097          	auipc	ra,0x0
    80000e38:	eba080e7          	jalr	-326(ra) # 80000cee <print_table>
    80000e3c:	b7f1                	j	80000e08 <vmprint+0x3a>
    } else if(pte & PTE_V){
      
    }
  }
}
    80000e3e:	70e2                	ld	ra,56(sp)
    80000e40:	7442                	ld	s0,48(sp)
    80000e42:	74a2                	ld	s1,40(sp)
    80000e44:	7902                	ld	s2,32(sp)
    80000e46:	69e2                	ld	s3,24(sp)
    80000e48:	6a42                	ld	s4,16(sp)
    80000e4a:	6aa2                	ld	s5,8(sp)
    80000e4c:	6b02                	ld	s6,0(sp)
    80000e4e:	6121                	addi	sp,sp,64
    80000e50:	8082                	ret

0000000080000e52 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000e52:	7139                	addi	sp,sp,-64
    80000e54:	fc06                	sd	ra,56(sp)
    80000e56:	f822                	sd	s0,48(sp)
    80000e58:	f426                	sd	s1,40(sp)
    80000e5a:	f04a                	sd	s2,32(sp)
    80000e5c:	ec4e                	sd	s3,24(sp)
    80000e5e:	e852                	sd	s4,16(sp)
    80000e60:	e456                	sd	s5,8(sp)
    80000e62:	e05a                	sd	s6,0(sp)
    80000e64:	0080                	addi	s0,sp,64
    80000e66:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80000e68:	00008497          	auipc	s1,0x8
    80000e6c:	61848493          	addi	s1,s1,1560 # 80009480 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000e70:	8b26                	mv	s6,s1
    80000e72:	ff4df937          	lui	s2,0xff4df
    80000e76:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000e7a:	0936                	slli	s2,s2,0xd
    80000e7c:	6f590913          	addi	s2,s2,1781
    80000e80:	0936                	slli	s2,s2,0xd
    80000e82:	bd390913          	addi	s2,s2,-1069
    80000e86:	0932                	slli	s2,s2,0xc
    80000e88:	7a790913          	addi	s2,s2,1959
    80000e8c:	010009b7          	lui	s3,0x1000
    80000e90:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000e92:	09ba                	slli	s3,s3,0xe
  for (p = proc; p < &proc[NPROC]; p++)
    80000e94:	0000ea97          	auipc	s5,0xe
    80000e98:	1eca8a93          	addi	s5,s5,492 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000e9c:	fffff097          	auipc	ra,0xfffff
    80000ea0:	27e080e7          	jalr	638(ra) # 8000011a <kalloc>
    80000ea4:	862a                	mv	a2,a0
    if (pa == 0)
    80000ea6:	cd1d                	beqz	a0,80000ee4 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int)(p - proc));
    80000ea8:	416485b3          	sub	a1,s1,s6
    80000eac:	8591                	srai	a1,a1,0x4
    80000eae:	032585b3          	mul	a1,a1,s2
    80000eb2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000eb6:	4719                	li	a4,6
    80000eb8:	6685                	lui	a3,0x1
    80000eba:	40b985b3          	sub	a1,s3,a1
    80000ebe:	8552                	mv	a0,s4
    80000ec0:	fffff097          	auipc	ra,0xfffff
    80000ec4:	71a080e7          	jalr	1818(ra) # 800005da <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80000ec8:	17048493          	addi	s1,s1,368
    80000ecc:	fd5498e3          	bne	s1,s5,80000e9c <proc_mapstacks+0x4a>
  }
}
    80000ed0:	70e2                	ld	ra,56(sp)
    80000ed2:	7442                	ld	s0,48(sp)
    80000ed4:	74a2                	ld	s1,40(sp)
    80000ed6:	7902                	ld	s2,32(sp)
    80000ed8:	69e2                	ld	s3,24(sp)
    80000eda:	6a42                	ld	s4,16(sp)
    80000edc:	6aa2                	ld	s5,8(sp)
    80000ede:	6b02                	ld	s6,0(sp)
    80000ee0:	6121                	addi	sp,sp,64
    80000ee2:	8082                	ret
      panic("kalloc");
    80000ee4:	00007517          	auipc	a0,0x7
    80000ee8:	2bc50513          	addi	a0,a0,700 # 800081a0 <etext+0x1a0>
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	040080e7          	jalr	64(ra) # 80005f2c <panic>

0000000080000ef4 <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000ef4:	7139                	addi	sp,sp,-64
    80000ef6:	fc06                	sd	ra,56(sp)
    80000ef8:	f822                	sd	s0,48(sp)
    80000efa:	f426                	sd	s1,40(sp)
    80000efc:	f04a                	sd	s2,32(sp)
    80000efe:	ec4e                	sd	s3,24(sp)
    80000f00:	e852                	sd	s4,16(sp)
    80000f02:	e456                	sd	s5,8(sp)
    80000f04:	e05a                	sd	s6,0(sp)
    80000f06:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000f08:	00007597          	auipc	a1,0x7
    80000f0c:	2a058593          	addi	a1,a1,672 # 800081a8 <etext+0x1a8>
    80000f10:	00008517          	auipc	a0,0x8
    80000f14:	14050513          	addi	a0,a0,320 # 80009050 <pid_lock>
    80000f18:	00005097          	auipc	ra,0x5
    80000f1c:	4fe080e7          	jalr	1278(ra) # 80006416 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f20:	00007597          	auipc	a1,0x7
    80000f24:	29058593          	addi	a1,a1,656 # 800081b0 <etext+0x1b0>
    80000f28:	00008517          	auipc	a0,0x8
    80000f2c:	14050513          	addi	a0,a0,320 # 80009068 <wait_lock>
    80000f30:	00005097          	auipc	ra,0x5
    80000f34:	4e6080e7          	jalr	1254(ra) # 80006416 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000f38:	00008497          	auipc	s1,0x8
    80000f3c:	54848493          	addi	s1,s1,1352 # 80009480 <proc>
  {
    initlock(&p->lock, "proc");
    80000f40:	00007b17          	auipc	s6,0x7
    80000f44:	280b0b13          	addi	s6,s6,640 # 800081c0 <etext+0x1c0>
    p->kstack = KSTACK((int)(p - proc));
    80000f48:	8aa6                	mv	s5,s1
    80000f4a:	ff4df937          	lui	s2,0xff4df
    80000f4e:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000f52:	0936                	slli	s2,s2,0xd
    80000f54:	6f590913          	addi	s2,s2,1781
    80000f58:	0936                	slli	s2,s2,0xd
    80000f5a:	bd390913          	addi	s2,s2,-1069
    80000f5e:	0932                	slli	s2,s2,0xc
    80000f60:	7a790913          	addi	s2,s2,1959
    80000f64:	010009b7          	lui	s3,0x1000
    80000f68:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000f6a:	09ba                	slli	s3,s3,0xe
  for (p = proc; p < &proc[NPROC]; p++)
    80000f6c:	0000ea17          	auipc	s4,0xe
    80000f70:	114a0a13          	addi	s4,s4,276 # 8000f080 <tickslock>
    initlock(&p->lock, "proc");
    80000f74:	85da                	mv	a1,s6
    80000f76:	8526                	mv	a0,s1
    80000f78:	00005097          	auipc	ra,0x5
    80000f7c:	49e080e7          	jalr	1182(ra) # 80006416 <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80000f80:	415487b3          	sub	a5,s1,s5
    80000f84:	8791                	srai	a5,a5,0x4
    80000f86:	032787b3          	mul	a5,a5,s2
    80000f8a:	00d7979b          	slliw	a5,a5,0xd
    80000f8e:	40f987b3          	sub	a5,s3,a5
    80000f92:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80000f94:	17048493          	addi	s1,s1,368
    80000f98:	fd449ee3          	bne	s1,s4,80000f74 <procinit+0x80>
  }
}
    80000f9c:	70e2                	ld	ra,56(sp)
    80000f9e:	7442                	ld	s0,48(sp)
    80000fa0:	74a2                	ld	s1,40(sp)
    80000fa2:	7902                	ld	s2,32(sp)
    80000fa4:	69e2                	ld	s3,24(sp)
    80000fa6:	6a42                	ld	s4,16(sp)
    80000fa8:	6aa2                	ld	s5,8(sp)
    80000faa:	6b02                	ld	s6,0(sp)
    80000fac:	6121                	addi	sp,sp,64
    80000fae:	8082                	ret

0000000080000fb0 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000fb0:	1141                	addi	sp,sp,-16
    80000fb2:	e422                	sd	s0,8(sp)
    80000fb4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000fb6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000fb8:	2501                	sext.w	a0,a0
    80000fba:	6422                	ld	s0,8(sp)
    80000fbc:	0141                	addi	sp,sp,16
    80000fbe:	8082                	ret

0000000080000fc0 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000fc0:	1141                	addi	sp,sp,-16
    80000fc2:	e422                	sd	s0,8(sp)
    80000fc4:	0800                	addi	s0,sp,16
    80000fc6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000fc8:	2781                	sext.w	a5,a5
    80000fca:	079e                	slli	a5,a5,0x7
  return c;
}
    80000fcc:	00008517          	auipc	a0,0x8
    80000fd0:	0b450513          	addi	a0,a0,180 # 80009080 <cpus>
    80000fd4:	953e                	add	a0,a0,a5
    80000fd6:	6422                	ld	s0,8(sp)
    80000fd8:	0141                	addi	sp,sp,16
    80000fda:	8082                	ret

0000000080000fdc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	1000                	addi	s0,sp,32
  push_off();
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	474080e7          	jalr	1140(ra) # 8000645a <push_off>
    80000fee:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000ff0:	2781                	sext.w	a5,a5
    80000ff2:	079e                	slli	a5,a5,0x7
    80000ff4:	00008717          	auipc	a4,0x8
    80000ff8:	05c70713          	addi	a4,a4,92 # 80009050 <pid_lock>
    80000ffc:	97ba                	add	a5,a5,a4
    80000ffe:	7b84                	ld	s1,48(a5)
  pop_off();
    80001000:	00005097          	auipc	ra,0x5
    80001004:	4fa080e7          	jalr	1274(ra) # 800064fa <pop_off>
  return p;
}
    80001008:	8526                	mv	a0,s1
    8000100a:	60e2                	ld	ra,24(sp)
    8000100c:	6442                	ld	s0,16(sp)
    8000100e:	64a2                	ld	s1,8(sp)
    80001010:	6105                	addi	sp,sp,32
    80001012:	8082                	ret

0000000080001014 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001014:	1141                	addi	sp,sp,-16
    80001016:	e406                	sd	ra,8(sp)
    80001018:	e022                	sd	s0,0(sp)
    8000101a:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	fc0080e7          	jalr	-64(ra) # 80000fdc <myproc>
    80001024:	00005097          	auipc	ra,0x5
    80001028:	536080e7          	jalr	1334(ra) # 8000655a <release>

  if (first)
    8000102c:	00008797          	auipc	a5,0x8
    80001030:	8747a783          	lw	a5,-1932(a5) # 800088a0 <first.1>
    80001034:	eb89                	bnez	a5,80001046 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80001036:	00001097          	auipc	ra,0x1
    8000103a:	c9a080e7          	jalr	-870(ra) # 80001cd0 <usertrapret>
}
    8000103e:	60a2                	ld	ra,8(sp)
    80001040:	6402                	ld	s0,0(sp)
    80001042:	0141                	addi	sp,sp,16
    80001044:	8082                	ret
    first = 0;
    80001046:	00008797          	auipc	a5,0x8
    8000104a:	8407ad23          	sw	zero,-1958(a5) # 800088a0 <first.1>
    fsinit(ROOTDEV);
    8000104e:	4505                	li	a0,1
    80001050:	00002097          	auipc	ra,0x2
    80001054:	ade080e7          	jalr	-1314(ra) # 80002b2e <fsinit>
    80001058:	bff9                	j	80001036 <forkret+0x22>

000000008000105a <allocpid>:
{
    8000105a:	1101                	addi	sp,sp,-32
    8000105c:	ec06                	sd	ra,24(sp)
    8000105e:	e822                	sd	s0,16(sp)
    80001060:	e426                	sd	s1,8(sp)
    80001062:	e04a                	sd	s2,0(sp)
    80001064:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001066:	00008917          	auipc	s2,0x8
    8000106a:	fea90913          	addi	s2,s2,-22 # 80009050 <pid_lock>
    8000106e:	854a                	mv	a0,s2
    80001070:	00005097          	auipc	ra,0x5
    80001074:	436080e7          	jalr	1078(ra) # 800064a6 <acquire>
  pid = nextpid;
    80001078:	00008797          	auipc	a5,0x8
    8000107c:	82c78793          	addi	a5,a5,-2004 # 800088a4 <nextpid>
    80001080:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001082:	0014871b          	addiw	a4,s1,1
    80001086:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001088:	854a                	mv	a0,s2
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	4d0080e7          	jalr	1232(ra) # 8000655a <release>
}
    80001092:	8526                	mv	a0,s1
    80001094:	60e2                	ld	ra,24(sp)
    80001096:	6442                	ld	s0,16(sp)
    80001098:	64a2                	ld	s1,8(sp)
    8000109a:	6902                	ld	s2,0(sp)
    8000109c:	6105                	addi	sp,sp,32
    8000109e:	8082                	ret

00000000800010a0 <proc_pagetable>:
{
    800010a0:	1101                	addi	sp,sp,-32
    800010a2:	ec06                	sd	ra,24(sp)
    800010a4:	e822                	sd	s0,16(sp)
    800010a6:	e426                	sd	s1,8(sp)
    800010a8:	e04a                	sd	s2,0(sp)
    800010aa:	1000                	addi	s0,sp,32
    800010ac:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800010ae:	fffff097          	auipc	ra,0xfffff
    800010b2:	726080e7          	jalr	1830(ra) # 800007d4 <uvmcreate>
    800010b6:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800010b8:	c525                	beqz	a0,80001120 <proc_pagetable+0x80>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    800010ba:	4729                	li	a4,10
    800010bc:	00006697          	auipc	a3,0x6
    800010c0:	f4468693          	addi	a3,a3,-188 # 80007000 <_trampoline>
    800010c4:	6605                	lui	a2,0x1
    800010c6:	040005b7          	lui	a1,0x4000
    800010ca:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010cc:	05b2                	slli	a1,a1,0xc
    800010ce:	fffff097          	auipc	ra,0xfffff
    800010d2:	46c080e7          	jalr	1132(ra) # 8000053a <mappages>
    800010d6:	04054c63          	bltz	a0,8000112e <proc_pagetable+0x8e>
  p->usyscall->pid = p->pid;
    800010da:	16893783          	ld	a5,360(s2)
    800010de:	03092703          	lw	a4,48(s2)
    800010e2:	c398                	sw	a4,0(a5)
  if (mappages(pagetable, USYSCALL, PGSIZE,
    800010e4:	4749                	li	a4,18
    800010e6:	16893683          	ld	a3,360(s2)
    800010ea:	6605                	lui	a2,0x1
    800010ec:	040005b7          	lui	a1,0x4000
    800010f0:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800010f2:	05b2                	slli	a1,a1,0xc
    800010f4:	8526                	mv	a0,s1
    800010f6:	fffff097          	auipc	ra,0xfffff
    800010fa:	444080e7          	jalr	1092(ra) # 8000053a <mappages>
    800010fe:	04054063          	bltz	a0,8000113e <proc_pagetable+0x9e>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001102:	4719                	li	a4,6
    80001104:	05893683          	ld	a3,88(s2)
    80001108:	6605                	lui	a2,0x1
    8000110a:	020005b7          	lui	a1,0x2000
    8000110e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001110:	05b6                	slli	a1,a1,0xd
    80001112:	8526                	mv	a0,s1
    80001114:	fffff097          	auipc	ra,0xfffff
    80001118:	426080e7          	jalr	1062(ra) # 8000053a <mappages>
    8000111c:	02054963          	bltz	a0,8000114e <proc_pagetable+0xae>
}
    80001120:	8526                	mv	a0,s1
    80001122:	60e2                	ld	ra,24(sp)
    80001124:	6442                	ld	s0,16(sp)
    80001126:	64a2                	ld	s1,8(sp)
    80001128:	6902                	ld	s2,0(sp)
    8000112a:	6105                	addi	sp,sp,32
    8000112c:	8082                	ret
    uvmfree(pagetable, 0);
    8000112e:	4581                	li	a1,0
    80001130:	8526                	mv	a0,s1
    80001132:	00000097          	auipc	ra,0x0
    80001136:	8a8080e7          	jalr	-1880(ra) # 800009da <uvmfree>
    return 0;
    8000113a:	4481                	li	s1,0
    8000113c:	b7d5                	j	80001120 <proc_pagetable+0x80>
    uvmfree(pagetable, 0);
    8000113e:	4581                	li	a1,0
    80001140:	8526                	mv	a0,s1
    80001142:	00000097          	auipc	ra,0x0
    80001146:	898080e7          	jalr	-1896(ra) # 800009da <uvmfree>
    return 0;
    8000114a:	4481                	li	s1,0
    8000114c:	bfd1                	j	80001120 <proc_pagetable+0x80>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000114e:	4681                	li	a3,0
    80001150:	4605                	li	a2,1
    80001152:	040005b7          	lui	a1,0x4000
    80001156:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001158:	05b2                	slli	a1,a1,0xc
    8000115a:	8526                	mv	a0,s1
    8000115c:	fffff097          	auipc	ra,0xfffff
    80001160:	5a4080e7          	jalr	1444(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80001164:	4581                	li	a1,0
    80001166:	8526                	mv	a0,s1
    80001168:	00000097          	auipc	ra,0x0
    8000116c:	872080e7          	jalr	-1934(ra) # 800009da <uvmfree>
    return 0;
    80001170:	4481                	li	s1,0
    80001172:	b77d                	j	80001120 <proc_pagetable+0x80>

0000000080001174 <proc_freepagetable>:
{
    80001174:	1101                	addi	sp,sp,-32
    80001176:	ec06                	sd	ra,24(sp)
    80001178:	e822                	sd	s0,16(sp)
    8000117a:	e426                	sd	s1,8(sp)
    8000117c:	e04a                	sd	s2,0(sp)
    8000117e:	1000                	addi	s0,sp,32
    80001180:	84aa                	mv	s1,a0
    80001182:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001184:	4681                	li	a3,0
    80001186:	4605                	li	a2,1
    80001188:	040005b7          	lui	a1,0x4000
    8000118c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000118e:	05b2                	slli	a1,a1,0xc
    80001190:	fffff097          	auipc	ra,0xfffff
    80001194:	570080e7          	jalr	1392(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001198:	4681                	li	a3,0
    8000119a:	4605                	li	a2,1
    8000119c:	040005b7          	lui	a1,0x4000
    800011a0:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800011a2:	05b2                	slli	a1,a1,0xc
    800011a4:	8526                	mv	a0,s1
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	55a080e7          	jalr	1370(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011ae:	4681                	li	a3,0
    800011b0:	4605                	li	a2,1
    800011b2:	020005b7          	lui	a1,0x2000
    800011b6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011b8:	05b6                	slli	a1,a1,0xd
    800011ba:	8526                	mv	a0,s1
    800011bc:	fffff097          	auipc	ra,0xfffff
    800011c0:	544080e7          	jalr	1348(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    800011c4:	85ca                	mv	a1,s2
    800011c6:	8526                	mv	a0,s1
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	812080e7          	jalr	-2030(ra) # 800009da <uvmfree>
}
    800011d0:	60e2                	ld	ra,24(sp)
    800011d2:	6442                	ld	s0,16(sp)
    800011d4:	64a2                	ld	s1,8(sp)
    800011d6:	6902                	ld	s2,0(sp)
    800011d8:	6105                	addi	sp,sp,32
    800011da:	8082                	ret

00000000800011dc <freeproc>:
{
    800011dc:	1101                	addi	sp,sp,-32
    800011de:	ec06                	sd	ra,24(sp)
    800011e0:	e822                	sd	s0,16(sp)
    800011e2:	e426                	sd	s1,8(sp)
    800011e4:	1000                	addi	s0,sp,32
    800011e6:	84aa                	mv	s1,a0
  if (p->trapframe)
    800011e8:	6d28                	ld	a0,88(a0)
    800011ea:	c509                	beqz	a0,800011f4 <freeproc+0x18>
    kfree((void *)p->trapframe);
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	e30080e7          	jalr	-464(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011f4:	0404bc23          	sd	zero,88(s1)
  if (p->usyscall)
    800011f8:	1684b503          	ld	a0,360(s1)
    800011fc:	c509                	beqz	a0,80001206 <freeproc+0x2a>
    kfree((void *)p->usyscall);
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	e1e080e7          	jalr	-482(ra) # 8000001c <kfree>
  if (p->pagetable)
    80001206:	68a8                	ld	a0,80(s1)
    80001208:	c511                	beqz	a0,80001214 <freeproc+0x38>
    proc_freepagetable(p->pagetable, p->sz);
    8000120a:	64ac                	ld	a1,72(s1)
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	f68080e7          	jalr	-152(ra) # 80001174 <proc_freepagetable>
  p->pagetable = 0;
    80001214:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001218:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000121c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001220:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001224:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001228:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000122c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001230:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001234:	0004ac23          	sw	zero,24(s1)
}
    80001238:	60e2                	ld	ra,24(sp)
    8000123a:	6442                	ld	s0,16(sp)
    8000123c:	64a2                	ld	s1,8(sp)
    8000123e:	6105                	addi	sp,sp,32
    80001240:	8082                	ret

0000000080001242 <allocproc>:
{
    80001242:	1101                	addi	sp,sp,-32
    80001244:	ec06                	sd	ra,24(sp)
    80001246:	e822                	sd	s0,16(sp)
    80001248:	e426                	sd	s1,8(sp)
    8000124a:	e04a                	sd	s2,0(sp)
    8000124c:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    8000124e:	00008497          	auipc	s1,0x8
    80001252:	23248493          	addi	s1,s1,562 # 80009480 <proc>
    80001256:	0000e917          	auipc	s2,0xe
    8000125a:	e2a90913          	addi	s2,s2,-470 # 8000f080 <tickslock>
    acquire(&p->lock);
    8000125e:	8526                	mv	a0,s1
    80001260:	00005097          	auipc	ra,0x5
    80001264:	246080e7          	jalr	582(ra) # 800064a6 <acquire>
    if (p->state == UNUSED)
    80001268:	4c9c                	lw	a5,24(s1)
    8000126a:	cf81                	beqz	a5,80001282 <allocproc+0x40>
      release(&p->lock);
    8000126c:	8526                	mv	a0,s1
    8000126e:	00005097          	auipc	ra,0x5
    80001272:	2ec080e7          	jalr	748(ra) # 8000655a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001276:	17048493          	addi	s1,s1,368
    8000127a:	ff2492e3          	bne	s1,s2,8000125e <allocproc+0x1c>
  return 0;
    8000127e:	4481                	li	s1,0
    80001280:	a08d                	j	800012e2 <allocproc+0xa0>
  p->pid = allocpid();
    80001282:	00000097          	auipc	ra,0x0
    80001286:	dd8080e7          	jalr	-552(ra) # 8000105a <allocpid>
    8000128a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000128c:	4785                	li	a5,1
    8000128e:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	e8a080e7          	jalr	-374(ra) # 8000011a <kalloc>
    80001298:	892a                	mv	s2,a0
    8000129a:	eca8                	sd	a0,88(s1)
    8000129c:	c931                	beqz	a0,800012f0 <allocproc+0xae>
  if ((p->usyscall = (struct usyscall *)kalloc()) == 0)
    8000129e:	fffff097          	auipc	ra,0xfffff
    800012a2:	e7c080e7          	jalr	-388(ra) # 8000011a <kalloc>
    800012a6:	892a                	mv	s2,a0
    800012a8:	16a4b423          	sd	a0,360(s1)
    800012ac:	cd31                	beqz	a0,80001308 <allocproc+0xc6>
  p->pagetable = proc_pagetable(p);
    800012ae:	8526                	mv	a0,s1
    800012b0:	00000097          	auipc	ra,0x0
    800012b4:	df0080e7          	jalr	-528(ra) # 800010a0 <proc_pagetable>
    800012b8:	892a                	mv	s2,a0
    800012ba:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    800012bc:	c135                	beqz	a0,80001320 <allocproc+0xde>
  memset(&p->context, 0, sizeof(p->context));
    800012be:	07000613          	li	a2,112
    800012c2:	4581                	li	a1,0
    800012c4:	06048513          	addi	a0,s1,96
    800012c8:	fffff097          	auipc	ra,0xfffff
    800012cc:	eb2080e7          	jalr	-334(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    800012d0:	00000797          	auipc	a5,0x0
    800012d4:	d4478793          	addi	a5,a5,-700 # 80001014 <forkret>
    800012d8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012da:	60bc                	ld	a5,64(s1)
    800012dc:	6705                	lui	a4,0x1
    800012de:	97ba                	add	a5,a5,a4
    800012e0:	f4bc                	sd	a5,104(s1)
}
    800012e2:	8526                	mv	a0,s1
    800012e4:	60e2                	ld	ra,24(sp)
    800012e6:	6442                	ld	s0,16(sp)
    800012e8:	64a2                	ld	s1,8(sp)
    800012ea:	6902                	ld	s2,0(sp)
    800012ec:	6105                	addi	sp,sp,32
    800012ee:	8082                	ret
    freeproc(p);
    800012f0:	8526                	mv	a0,s1
    800012f2:	00000097          	auipc	ra,0x0
    800012f6:	eea080e7          	jalr	-278(ra) # 800011dc <freeproc>
    release(&p->lock);
    800012fa:	8526                	mv	a0,s1
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	25e080e7          	jalr	606(ra) # 8000655a <release>
    return 0;
    80001304:	84ca                	mv	s1,s2
    80001306:	bff1                	j	800012e2 <allocproc+0xa0>
    freeproc(p);
    80001308:	8526                	mv	a0,s1
    8000130a:	00000097          	auipc	ra,0x0
    8000130e:	ed2080e7          	jalr	-302(ra) # 800011dc <freeproc>
    release(&p->lock);
    80001312:	8526                	mv	a0,s1
    80001314:	00005097          	auipc	ra,0x5
    80001318:	246080e7          	jalr	582(ra) # 8000655a <release>
    return 0;
    8000131c:	84ca                	mv	s1,s2
    8000131e:	b7d1                	j	800012e2 <allocproc+0xa0>
    freeproc(p);
    80001320:	8526                	mv	a0,s1
    80001322:	00000097          	auipc	ra,0x0
    80001326:	eba080e7          	jalr	-326(ra) # 800011dc <freeproc>
    release(&p->lock);
    8000132a:	8526                	mv	a0,s1
    8000132c:	00005097          	auipc	ra,0x5
    80001330:	22e080e7          	jalr	558(ra) # 8000655a <release>
    return 0;
    80001334:	84ca                	mv	s1,s2
    80001336:	b775                	j	800012e2 <allocproc+0xa0>

0000000080001338 <userinit>:
{
    80001338:	1101                	addi	sp,sp,-32
    8000133a:	ec06                	sd	ra,24(sp)
    8000133c:	e822                	sd	s0,16(sp)
    8000133e:	e426                	sd	s1,8(sp)
    80001340:	1000                	addi	s0,sp,32
  p = allocproc();
    80001342:	00000097          	auipc	ra,0x0
    80001346:	f00080e7          	jalr	-256(ra) # 80001242 <allocproc>
    8000134a:	84aa                	mv	s1,a0
  initproc = p;
    8000134c:	00008797          	auipc	a5,0x8
    80001350:	cca7b223          	sd	a0,-828(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001354:	03400613          	li	a2,52
    80001358:	00007597          	auipc	a1,0x7
    8000135c:	55858593          	addi	a1,a1,1368 # 800088b0 <initcode>
    80001360:	6928                	ld	a0,80(a0)
    80001362:	fffff097          	auipc	ra,0xfffff
    80001366:	4a0080e7          	jalr	1184(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    8000136a:	6785                	lui	a5,0x1
    8000136c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    8000136e:	6cb8                	ld	a4,88(s1)
    80001370:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001374:	6cb8                	ld	a4,88(s1)
    80001376:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001378:	4641                	li	a2,16
    8000137a:	00007597          	auipc	a1,0x7
    8000137e:	e4e58593          	addi	a1,a1,-434 # 800081c8 <etext+0x1c8>
    80001382:	15848513          	addi	a0,s1,344
    80001386:	fffff097          	auipc	ra,0xfffff
    8000138a:	f36080e7          	jalr	-202(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    8000138e:	00007517          	auipc	a0,0x7
    80001392:	e4a50513          	addi	a0,a0,-438 # 800081d8 <etext+0x1d8>
    80001396:	00002097          	auipc	ra,0x2
    8000139a:	1de080e7          	jalr	478(ra) # 80003574 <namei>
    8000139e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013a2:	478d                	li	a5,3
    800013a4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013a6:	8526                	mv	a0,s1
    800013a8:	00005097          	auipc	ra,0x5
    800013ac:	1b2080e7          	jalr	434(ra) # 8000655a <release>
}
    800013b0:	60e2                	ld	ra,24(sp)
    800013b2:	6442                	ld	s0,16(sp)
    800013b4:	64a2                	ld	s1,8(sp)
    800013b6:	6105                	addi	sp,sp,32
    800013b8:	8082                	ret

00000000800013ba <growproc>:
{
    800013ba:	1101                	addi	sp,sp,-32
    800013bc:	ec06                	sd	ra,24(sp)
    800013be:	e822                	sd	s0,16(sp)
    800013c0:	e426                	sd	s1,8(sp)
    800013c2:	e04a                	sd	s2,0(sp)
    800013c4:	1000                	addi	s0,sp,32
    800013c6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800013c8:	00000097          	auipc	ra,0x0
    800013cc:	c14080e7          	jalr	-1004(ra) # 80000fdc <myproc>
    800013d0:	892a                	mv	s2,a0
  sz = p->sz;
    800013d2:	652c                	ld	a1,72(a0)
    800013d4:	0005879b          	sext.w	a5,a1
  if (n > 0)
    800013d8:	00904f63          	bgtz	s1,800013f6 <growproc+0x3c>
  else if (n < 0)
    800013dc:	0204cd63          	bltz	s1,80001416 <growproc+0x5c>
  p->sz = sz;
    800013e0:	1782                	slli	a5,a5,0x20
    800013e2:	9381                	srli	a5,a5,0x20
    800013e4:	04f93423          	sd	a5,72(s2)
  return 0;
    800013e8:	4501                	li	a0,0
}
    800013ea:	60e2                	ld	ra,24(sp)
    800013ec:	6442                	ld	s0,16(sp)
    800013ee:	64a2                	ld	s1,8(sp)
    800013f0:	6902                	ld	s2,0(sp)
    800013f2:	6105                	addi	sp,sp,32
    800013f4:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    800013f6:	00f4863b          	addw	a2,s1,a5
    800013fa:	1602                	slli	a2,a2,0x20
    800013fc:	9201                	srli	a2,a2,0x20
    800013fe:	1582                	slli	a1,a1,0x20
    80001400:	9181                	srli	a1,a1,0x20
    80001402:	6928                	ld	a0,80(a0)
    80001404:	fffff097          	auipc	ra,0xfffff
    80001408:	4b8080e7          	jalr	1208(ra) # 800008bc <uvmalloc>
    8000140c:	0005079b          	sext.w	a5,a0
    80001410:	fbe1                	bnez	a5,800013e0 <growproc+0x26>
      return -1;
    80001412:	557d                	li	a0,-1
    80001414:	bfd9                	j	800013ea <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001416:	00f4863b          	addw	a2,s1,a5
    8000141a:	1602                	slli	a2,a2,0x20
    8000141c:	9201                	srli	a2,a2,0x20
    8000141e:	1582                	slli	a1,a1,0x20
    80001420:	9181                	srli	a1,a1,0x20
    80001422:	6928                	ld	a0,80(a0)
    80001424:	fffff097          	auipc	ra,0xfffff
    80001428:	450080e7          	jalr	1104(ra) # 80000874 <uvmdealloc>
    8000142c:	0005079b          	sext.w	a5,a0
    80001430:	bf45                	j	800013e0 <growproc+0x26>

0000000080001432 <fork>:
{
    80001432:	7139                	addi	sp,sp,-64
    80001434:	fc06                	sd	ra,56(sp)
    80001436:	f822                	sd	s0,48(sp)
    80001438:	f04a                	sd	s2,32(sp)
    8000143a:	e456                	sd	s5,8(sp)
    8000143c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000143e:	00000097          	auipc	ra,0x0
    80001442:	b9e080e7          	jalr	-1122(ra) # 80000fdc <myproc>
    80001446:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    80001448:	00000097          	auipc	ra,0x0
    8000144c:	dfa080e7          	jalr	-518(ra) # 80001242 <allocproc>
    80001450:	12050063          	beqz	a0,80001570 <fork+0x13e>
    80001454:	e852                	sd	s4,16(sp)
    80001456:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001458:	048ab603          	ld	a2,72(s5)
    8000145c:	692c                	ld	a1,80(a0)
    8000145e:	050ab503          	ld	a0,80(s5)
    80001462:	fffff097          	auipc	ra,0xfffff
    80001466:	5b2080e7          	jalr	1458(ra) # 80000a14 <uvmcopy>
    8000146a:	04054a63          	bltz	a0,800014be <fork+0x8c>
    8000146e:	f426                	sd	s1,40(sp)
    80001470:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001472:	048ab783          	ld	a5,72(s5)
    80001476:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    8000147a:	058ab683          	ld	a3,88(s5)
    8000147e:	87b6                	mv	a5,a3
    80001480:	058a3703          	ld	a4,88(s4)
    80001484:	12068693          	addi	a3,a3,288
    80001488:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000148c:	6788                	ld	a0,8(a5)
    8000148e:	6b8c                	ld	a1,16(a5)
    80001490:	6f90                	ld	a2,24(a5)
    80001492:	01073023          	sd	a6,0(a4)
    80001496:	e708                	sd	a0,8(a4)
    80001498:	eb0c                	sd	a1,16(a4)
    8000149a:	ef10                	sd	a2,24(a4)
    8000149c:	02078793          	addi	a5,a5,32
    800014a0:	02070713          	addi	a4,a4,32
    800014a4:	fed792e3          	bne	a5,a3,80001488 <fork+0x56>
  np->trapframe->a0 = 0;
    800014a8:	058a3783          	ld	a5,88(s4)
    800014ac:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    800014b0:	0d0a8493          	addi	s1,s5,208
    800014b4:	0d0a0913          	addi	s2,s4,208
    800014b8:	150a8993          	addi	s3,s5,336
    800014bc:	a015                	j	800014e0 <fork+0xae>
    freeproc(np);
    800014be:	8552                	mv	a0,s4
    800014c0:	00000097          	auipc	ra,0x0
    800014c4:	d1c080e7          	jalr	-740(ra) # 800011dc <freeproc>
    release(&np->lock);
    800014c8:	8552                	mv	a0,s4
    800014ca:	00005097          	auipc	ra,0x5
    800014ce:	090080e7          	jalr	144(ra) # 8000655a <release>
    return -1;
    800014d2:	597d                	li	s2,-1
    800014d4:	6a42                	ld	s4,16(sp)
    800014d6:	a071                	j	80001562 <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    800014d8:	04a1                	addi	s1,s1,8
    800014da:	0921                	addi	s2,s2,8
    800014dc:	01348b63          	beq	s1,s3,800014f2 <fork+0xc0>
    if (p->ofile[i])
    800014e0:	6088                	ld	a0,0(s1)
    800014e2:	d97d                	beqz	a0,800014d8 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800014e4:	00002097          	auipc	ra,0x2
    800014e8:	708080e7          	jalr	1800(ra) # 80003bec <filedup>
    800014ec:	00a93023          	sd	a0,0(s2)
    800014f0:	b7e5                	j	800014d8 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800014f2:	150ab503          	ld	a0,336(s5)
    800014f6:	00002097          	auipc	ra,0x2
    800014fa:	86e080e7          	jalr	-1938(ra) # 80002d64 <idup>
    800014fe:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001502:	4641                	li	a2,16
    80001504:	158a8593          	addi	a1,s5,344
    80001508:	158a0513          	addi	a0,s4,344
    8000150c:	fffff097          	auipc	ra,0xfffff
    80001510:	db0080e7          	jalr	-592(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001514:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001518:	8552                	mv	a0,s4
    8000151a:	00005097          	auipc	ra,0x5
    8000151e:	040080e7          	jalr	64(ra) # 8000655a <release>
  acquire(&wait_lock);
    80001522:	00008497          	auipc	s1,0x8
    80001526:	b4648493          	addi	s1,s1,-1210 # 80009068 <wait_lock>
    8000152a:	8526                	mv	a0,s1
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	f7a080e7          	jalr	-134(ra) # 800064a6 <acquire>
  np->parent = p;
    80001534:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001538:	8526                	mv	a0,s1
    8000153a:	00005097          	auipc	ra,0x5
    8000153e:	020080e7          	jalr	32(ra) # 8000655a <release>
  acquire(&np->lock);
    80001542:	8552                	mv	a0,s4
    80001544:	00005097          	auipc	ra,0x5
    80001548:	f62080e7          	jalr	-158(ra) # 800064a6 <acquire>
  np->state = RUNNABLE;
    8000154c:	478d                	li	a5,3
    8000154e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001552:	8552                	mv	a0,s4
    80001554:	00005097          	auipc	ra,0x5
    80001558:	006080e7          	jalr	6(ra) # 8000655a <release>
  return pid;
    8000155c:	74a2                	ld	s1,40(sp)
    8000155e:	69e2                	ld	s3,24(sp)
    80001560:	6a42                	ld	s4,16(sp)
}
    80001562:	854a                	mv	a0,s2
    80001564:	70e2                	ld	ra,56(sp)
    80001566:	7442                	ld	s0,48(sp)
    80001568:	7902                	ld	s2,32(sp)
    8000156a:	6aa2                	ld	s5,8(sp)
    8000156c:	6121                	addi	sp,sp,64
    8000156e:	8082                	ret
    return -1;
    80001570:	597d                	li	s2,-1
    80001572:	bfc5                	j	80001562 <fork+0x130>

0000000080001574 <scheduler>:
{
    80001574:	7139                	addi	sp,sp,-64
    80001576:	fc06                	sd	ra,56(sp)
    80001578:	f822                	sd	s0,48(sp)
    8000157a:	f426                	sd	s1,40(sp)
    8000157c:	f04a                	sd	s2,32(sp)
    8000157e:	ec4e                	sd	s3,24(sp)
    80001580:	e852                	sd	s4,16(sp)
    80001582:	e456                	sd	s5,8(sp)
    80001584:	e05a                	sd	s6,0(sp)
    80001586:	0080                	addi	s0,sp,64
    80001588:	8792                	mv	a5,tp
  int id = r_tp();
    8000158a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000158c:	00779a93          	slli	s5,a5,0x7
    80001590:	00008717          	auipc	a4,0x8
    80001594:	ac070713          	addi	a4,a4,-1344 # 80009050 <pid_lock>
    80001598:	9756                	add	a4,a4,s5
    8000159a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000159e:	00008717          	auipc	a4,0x8
    800015a2:	aea70713          	addi	a4,a4,-1302 # 80009088 <cpus+0x8>
    800015a6:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    800015a8:	498d                	li	s3,3
        p->state = RUNNING;
    800015aa:	4b11                	li	s6,4
        c->proc = p;
    800015ac:	079e                	slli	a5,a5,0x7
    800015ae:	00008a17          	auipc	s4,0x8
    800015b2:	aa2a0a13          	addi	s4,s4,-1374 # 80009050 <pid_lock>
    800015b6:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    800015b8:	0000e917          	auipc	s2,0xe
    800015bc:	ac890913          	addi	s2,s2,-1336 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015c0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015c4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015c8:	10079073          	csrw	sstatus,a5
    800015cc:	00008497          	auipc	s1,0x8
    800015d0:	eb448493          	addi	s1,s1,-332 # 80009480 <proc>
    800015d4:	a811                	j	800015e8 <scheduler+0x74>
      release(&p->lock);
    800015d6:	8526                	mv	a0,s1
    800015d8:	00005097          	auipc	ra,0x5
    800015dc:	f82080e7          	jalr	-126(ra) # 8000655a <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800015e0:	17048493          	addi	s1,s1,368
    800015e4:	fd248ee3          	beq	s1,s2,800015c0 <scheduler+0x4c>
      acquire(&p->lock);
    800015e8:	8526                	mv	a0,s1
    800015ea:	00005097          	auipc	ra,0x5
    800015ee:	ebc080e7          	jalr	-324(ra) # 800064a6 <acquire>
      if (p->state == RUNNABLE)
    800015f2:	4c9c                	lw	a5,24(s1)
    800015f4:	ff3791e3          	bne	a5,s3,800015d6 <scheduler+0x62>
        p->state = RUNNING;
    800015f8:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015fc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001600:	06048593          	addi	a1,s1,96
    80001604:	8556                	mv	a0,s5
    80001606:	00000097          	auipc	ra,0x0
    8000160a:	620080e7          	jalr	1568(ra) # 80001c26 <swtch>
        c->proc = 0;
    8000160e:	020a3823          	sd	zero,48(s4)
    80001612:	b7d1                	j	800015d6 <scheduler+0x62>

0000000080001614 <sched>:
{
    80001614:	7179                	addi	sp,sp,-48
    80001616:	f406                	sd	ra,40(sp)
    80001618:	f022                	sd	s0,32(sp)
    8000161a:	ec26                	sd	s1,24(sp)
    8000161c:	e84a                	sd	s2,16(sp)
    8000161e:	e44e                	sd	s3,8(sp)
    80001620:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001622:	00000097          	auipc	ra,0x0
    80001626:	9ba080e7          	jalr	-1606(ra) # 80000fdc <myproc>
    8000162a:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    8000162c:	00005097          	auipc	ra,0x5
    80001630:	e00080e7          	jalr	-512(ra) # 8000642c <holding>
    80001634:	c93d                	beqz	a0,800016aa <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001636:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001638:	2781                	sext.w	a5,a5
    8000163a:	079e                	slli	a5,a5,0x7
    8000163c:	00008717          	auipc	a4,0x8
    80001640:	a1470713          	addi	a4,a4,-1516 # 80009050 <pid_lock>
    80001644:	97ba                	add	a5,a5,a4
    80001646:	0a87a703          	lw	a4,168(a5)
    8000164a:	4785                	li	a5,1
    8000164c:	06f71763          	bne	a4,a5,800016ba <sched+0xa6>
  if (p->state == RUNNING)
    80001650:	4c98                	lw	a4,24(s1)
    80001652:	4791                	li	a5,4
    80001654:	06f70b63          	beq	a4,a5,800016ca <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001658:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000165c:	8b89                	andi	a5,a5,2
  if (intr_get())
    8000165e:	efb5                	bnez	a5,800016da <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001660:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001662:	00008917          	auipc	s2,0x8
    80001666:	9ee90913          	addi	s2,s2,-1554 # 80009050 <pid_lock>
    8000166a:	2781                	sext.w	a5,a5
    8000166c:	079e                	slli	a5,a5,0x7
    8000166e:	97ca                	add	a5,a5,s2
    80001670:	0ac7a983          	lw	s3,172(a5)
    80001674:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001676:	2781                	sext.w	a5,a5
    80001678:	079e                	slli	a5,a5,0x7
    8000167a:	00008597          	auipc	a1,0x8
    8000167e:	a0e58593          	addi	a1,a1,-1522 # 80009088 <cpus+0x8>
    80001682:	95be                	add	a1,a1,a5
    80001684:	06048513          	addi	a0,s1,96
    80001688:	00000097          	auipc	ra,0x0
    8000168c:	59e080e7          	jalr	1438(ra) # 80001c26 <swtch>
    80001690:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001692:	2781                	sext.w	a5,a5
    80001694:	079e                	slli	a5,a5,0x7
    80001696:	993e                	add	s2,s2,a5
    80001698:	0b392623          	sw	s3,172(s2)
}
    8000169c:	70a2                	ld	ra,40(sp)
    8000169e:	7402                	ld	s0,32(sp)
    800016a0:	64e2                	ld	s1,24(sp)
    800016a2:	6942                	ld	s2,16(sp)
    800016a4:	69a2                	ld	s3,8(sp)
    800016a6:	6145                	addi	sp,sp,48
    800016a8:	8082                	ret
    panic("sched p->lock");
    800016aa:	00007517          	auipc	a0,0x7
    800016ae:	b3650513          	addi	a0,a0,-1226 # 800081e0 <etext+0x1e0>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	87a080e7          	jalr	-1926(ra) # 80005f2c <panic>
    panic("sched locks");
    800016ba:	00007517          	auipc	a0,0x7
    800016be:	b3650513          	addi	a0,a0,-1226 # 800081f0 <etext+0x1f0>
    800016c2:	00005097          	auipc	ra,0x5
    800016c6:	86a080e7          	jalr	-1942(ra) # 80005f2c <panic>
    panic("sched running");
    800016ca:	00007517          	auipc	a0,0x7
    800016ce:	b3650513          	addi	a0,a0,-1226 # 80008200 <etext+0x200>
    800016d2:	00005097          	auipc	ra,0x5
    800016d6:	85a080e7          	jalr	-1958(ra) # 80005f2c <panic>
    panic("sched interruptible");
    800016da:	00007517          	auipc	a0,0x7
    800016de:	b3650513          	addi	a0,a0,-1226 # 80008210 <etext+0x210>
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	84a080e7          	jalr	-1974(ra) # 80005f2c <panic>

00000000800016ea <yield>:
{
    800016ea:	1101                	addi	sp,sp,-32
    800016ec:	ec06                	sd	ra,24(sp)
    800016ee:	e822                	sd	s0,16(sp)
    800016f0:	e426                	sd	s1,8(sp)
    800016f2:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	8e8080e7          	jalr	-1816(ra) # 80000fdc <myproc>
    800016fc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016fe:	00005097          	auipc	ra,0x5
    80001702:	da8080e7          	jalr	-600(ra) # 800064a6 <acquire>
  p->state = RUNNABLE;
    80001706:	478d                	li	a5,3
    80001708:	cc9c                	sw	a5,24(s1)
  sched();
    8000170a:	00000097          	auipc	ra,0x0
    8000170e:	f0a080e7          	jalr	-246(ra) # 80001614 <sched>
  release(&p->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	e46080e7          	jalr	-442(ra) # 8000655a <release>
}
    8000171c:	60e2                	ld	ra,24(sp)
    8000171e:	6442                	ld	s0,16(sp)
    80001720:	64a2                	ld	s1,8(sp)
    80001722:	6105                	addi	sp,sp,32
    80001724:	8082                	ret

0000000080001726 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001726:	7179                	addi	sp,sp,-48
    80001728:	f406                	sd	ra,40(sp)
    8000172a:	f022                	sd	s0,32(sp)
    8000172c:	ec26                	sd	s1,24(sp)
    8000172e:	e84a                	sd	s2,16(sp)
    80001730:	e44e                	sd	s3,8(sp)
    80001732:	1800                	addi	s0,sp,48
    80001734:	89aa                	mv	s3,a0
    80001736:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001738:	00000097          	auipc	ra,0x0
    8000173c:	8a4080e7          	jalr	-1884(ra) # 80000fdc <myproc>
    80001740:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    80001742:	00005097          	auipc	ra,0x5
    80001746:	d64080e7          	jalr	-668(ra) # 800064a6 <acquire>
  release(lk);
    8000174a:	854a                	mv	a0,s2
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	e0e080e7          	jalr	-498(ra) # 8000655a <release>

  // Go to sleep.
  p->chan = chan;
    80001754:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001758:	4789                	li	a5,2
    8000175a:	cc9c                	sw	a5,24(s1)

  sched();
    8000175c:	00000097          	auipc	ra,0x0
    80001760:	eb8080e7          	jalr	-328(ra) # 80001614 <sched>

  // Tidy up.
  p->chan = 0;
    80001764:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001768:	8526                	mv	a0,s1
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	df0080e7          	jalr	-528(ra) # 8000655a <release>
  acquire(lk);
    80001772:	854a                	mv	a0,s2
    80001774:	00005097          	auipc	ra,0x5
    80001778:	d32080e7          	jalr	-718(ra) # 800064a6 <acquire>
}
    8000177c:	70a2                	ld	ra,40(sp)
    8000177e:	7402                	ld	s0,32(sp)
    80001780:	64e2                	ld	s1,24(sp)
    80001782:	6942                	ld	s2,16(sp)
    80001784:	69a2                	ld	s3,8(sp)
    80001786:	6145                	addi	sp,sp,48
    80001788:	8082                	ret

000000008000178a <wait>:
{
    8000178a:	715d                	addi	sp,sp,-80
    8000178c:	e486                	sd	ra,72(sp)
    8000178e:	e0a2                	sd	s0,64(sp)
    80001790:	fc26                	sd	s1,56(sp)
    80001792:	f84a                	sd	s2,48(sp)
    80001794:	f44e                	sd	s3,40(sp)
    80001796:	f052                	sd	s4,32(sp)
    80001798:	ec56                	sd	s5,24(sp)
    8000179a:	e85a                	sd	s6,16(sp)
    8000179c:	e45e                	sd	s7,8(sp)
    8000179e:	e062                	sd	s8,0(sp)
    800017a0:	0880                	addi	s0,sp,80
    800017a2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	838080e7          	jalr	-1992(ra) # 80000fdc <myproc>
    800017ac:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017ae:	00008517          	auipc	a0,0x8
    800017b2:	8ba50513          	addi	a0,a0,-1862 # 80009068 <wait_lock>
    800017b6:	00005097          	auipc	ra,0x5
    800017ba:	cf0080e7          	jalr	-784(ra) # 800064a6 <acquire>
    havekids = 0;
    800017be:	4b81                	li	s7,0
        if (np->state == ZOMBIE)
    800017c0:	4a15                	li	s4,5
        havekids = 1;
    800017c2:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    800017c4:	0000e997          	auipc	s3,0xe
    800017c8:	8bc98993          	addi	s3,s3,-1860 # 8000f080 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    800017cc:	00008c17          	auipc	s8,0x8
    800017d0:	89cc0c13          	addi	s8,s8,-1892 # 80009068 <wait_lock>
    800017d4:	a87d                	j	80001892 <wait+0x108>
          pid = np->pid;
    800017d6:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017da:	000b0e63          	beqz	s6,800017f6 <wait+0x6c>
    800017de:	4691                	li	a3,4
    800017e0:	02c48613          	addi	a2,s1,44
    800017e4:	85da                	mv	a1,s6
    800017e6:	05093503          	ld	a0,80(s2)
    800017ea:	fffff097          	auipc	ra,0xfffff
    800017ee:	32e080e7          	jalr	814(ra) # 80000b18 <copyout>
    800017f2:	04054163          	bltz	a0,80001834 <wait+0xaa>
          freeproc(np);
    800017f6:	8526                	mv	a0,s1
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	9e4080e7          	jalr	-1564(ra) # 800011dc <freeproc>
          release(&np->lock);
    80001800:	8526                	mv	a0,s1
    80001802:	00005097          	auipc	ra,0x5
    80001806:	d58080e7          	jalr	-680(ra) # 8000655a <release>
          release(&wait_lock);
    8000180a:	00008517          	auipc	a0,0x8
    8000180e:	85e50513          	addi	a0,a0,-1954 # 80009068 <wait_lock>
    80001812:	00005097          	auipc	ra,0x5
    80001816:	d48080e7          	jalr	-696(ra) # 8000655a <release>
}
    8000181a:	854e                	mv	a0,s3
    8000181c:	60a6                	ld	ra,72(sp)
    8000181e:	6406                	ld	s0,64(sp)
    80001820:	74e2                	ld	s1,56(sp)
    80001822:	7942                	ld	s2,48(sp)
    80001824:	79a2                	ld	s3,40(sp)
    80001826:	7a02                	ld	s4,32(sp)
    80001828:	6ae2                	ld	s5,24(sp)
    8000182a:	6b42                	ld	s6,16(sp)
    8000182c:	6ba2                	ld	s7,8(sp)
    8000182e:	6c02                	ld	s8,0(sp)
    80001830:	6161                	addi	sp,sp,80
    80001832:	8082                	ret
            release(&np->lock);
    80001834:	8526                	mv	a0,s1
    80001836:	00005097          	auipc	ra,0x5
    8000183a:	d24080e7          	jalr	-732(ra) # 8000655a <release>
            release(&wait_lock);
    8000183e:	00008517          	auipc	a0,0x8
    80001842:	82a50513          	addi	a0,a0,-2006 # 80009068 <wait_lock>
    80001846:	00005097          	auipc	ra,0x5
    8000184a:	d14080e7          	jalr	-748(ra) # 8000655a <release>
            return -1;
    8000184e:	59fd                	li	s3,-1
    80001850:	b7e9                	j	8000181a <wait+0x90>
    for (np = proc; np < &proc[NPROC]; np++)
    80001852:	17048493          	addi	s1,s1,368
    80001856:	03348463          	beq	s1,s3,8000187e <wait+0xf4>
      if (np->parent == p)
    8000185a:	7c9c                	ld	a5,56(s1)
    8000185c:	ff279be3          	bne	a5,s2,80001852 <wait+0xc8>
        acquire(&np->lock);
    80001860:	8526                	mv	a0,s1
    80001862:	00005097          	auipc	ra,0x5
    80001866:	c44080e7          	jalr	-956(ra) # 800064a6 <acquire>
        if (np->state == ZOMBIE)
    8000186a:	4c9c                	lw	a5,24(s1)
    8000186c:	f74785e3          	beq	a5,s4,800017d6 <wait+0x4c>
        release(&np->lock);
    80001870:	8526                	mv	a0,s1
    80001872:	00005097          	auipc	ra,0x5
    80001876:	ce8080e7          	jalr	-792(ra) # 8000655a <release>
        havekids = 1;
    8000187a:	8756                	mv	a4,s5
    8000187c:	bfd9                	j	80001852 <wait+0xc8>
    if (!havekids || p->killed)
    8000187e:	c305                	beqz	a4,8000189e <wait+0x114>
    80001880:	02892783          	lw	a5,40(s2)
    80001884:	ef89                	bnez	a5,8000189e <wait+0x114>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80001886:	85e2                	mv	a1,s8
    80001888:	854a                	mv	a0,s2
    8000188a:	00000097          	auipc	ra,0x0
    8000188e:	e9c080e7          	jalr	-356(ra) # 80001726 <sleep>
    havekids = 0;
    80001892:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++)
    80001894:	00008497          	auipc	s1,0x8
    80001898:	bec48493          	addi	s1,s1,-1044 # 80009480 <proc>
    8000189c:	bf7d                	j	8000185a <wait+0xd0>
      release(&wait_lock);
    8000189e:	00007517          	auipc	a0,0x7
    800018a2:	7ca50513          	addi	a0,a0,1994 # 80009068 <wait_lock>
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	cb4080e7          	jalr	-844(ra) # 8000655a <release>
      return -1;
    800018ae:	59fd                	li	s3,-1
    800018b0:	b7ad                	j	8000181a <wait+0x90>

00000000800018b2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800018b2:	7139                	addi	sp,sp,-64
    800018b4:	fc06                	sd	ra,56(sp)
    800018b6:	f822                	sd	s0,48(sp)
    800018b8:	f426                	sd	s1,40(sp)
    800018ba:	f04a                	sd	s2,32(sp)
    800018bc:	ec4e                	sd	s3,24(sp)
    800018be:	e852                	sd	s4,16(sp)
    800018c0:	e456                	sd	s5,8(sp)
    800018c2:	0080                	addi	s0,sp,64
    800018c4:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    800018c6:	00008497          	auipc	s1,0x8
    800018ca:	bba48493          	addi	s1,s1,-1094 # 80009480 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    800018ce:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    800018d0:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    800018d2:	0000d917          	auipc	s2,0xd
    800018d6:	7ae90913          	addi	s2,s2,1966 # 8000f080 <tickslock>
    800018da:	a811                	j	800018ee <wakeup+0x3c>
      }
      release(&p->lock);
    800018dc:	8526                	mv	a0,s1
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	c7c080e7          	jalr	-900(ra) # 8000655a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    800018e6:	17048493          	addi	s1,s1,368
    800018ea:	03248663          	beq	s1,s2,80001916 <wakeup+0x64>
    if (p != myproc())
    800018ee:	fffff097          	auipc	ra,0xfffff
    800018f2:	6ee080e7          	jalr	1774(ra) # 80000fdc <myproc>
    800018f6:	fea488e3          	beq	s1,a0,800018e6 <wakeup+0x34>
      acquire(&p->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	baa080e7          	jalr	-1110(ra) # 800064a6 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    80001904:	4c9c                	lw	a5,24(s1)
    80001906:	fd379be3          	bne	a5,s3,800018dc <wakeup+0x2a>
    8000190a:	709c                	ld	a5,32(s1)
    8000190c:	fd4798e3          	bne	a5,s4,800018dc <wakeup+0x2a>
        p->state = RUNNABLE;
    80001910:	0154ac23          	sw	s5,24(s1)
    80001914:	b7e1                	j	800018dc <wakeup+0x2a>
    }
  }
}
    80001916:	70e2                	ld	ra,56(sp)
    80001918:	7442                	ld	s0,48(sp)
    8000191a:	74a2                	ld	s1,40(sp)
    8000191c:	7902                	ld	s2,32(sp)
    8000191e:	69e2                	ld	s3,24(sp)
    80001920:	6a42                	ld	s4,16(sp)
    80001922:	6aa2                	ld	s5,8(sp)
    80001924:	6121                	addi	sp,sp,64
    80001926:	8082                	ret

0000000080001928 <reparent>:
{
    80001928:	7179                	addi	sp,sp,-48
    8000192a:	f406                	sd	ra,40(sp)
    8000192c:	f022                	sd	s0,32(sp)
    8000192e:	ec26                	sd	s1,24(sp)
    80001930:	e84a                	sd	s2,16(sp)
    80001932:	e44e                	sd	s3,8(sp)
    80001934:	e052                	sd	s4,0(sp)
    80001936:	1800                	addi	s0,sp,48
    80001938:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000193a:	00008497          	auipc	s1,0x8
    8000193e:	b4648493          	addi	s1,s1,-1210 # 80009480 <proc>
      pp->parent = initproc;
    80001942:	00007a17          	auipc	s4,0x7
    80001946:	6cea0a13          	addi	s4,s4,1742 # 80009010 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    8000194a:	0000d997          	auipc	s3,0xd
    8000194e:	73698993          	addi	s3,s3,1846 # 8000f080 <tickslock>
    80001952:	a029                	j	8000195c <reparent+0x34>
    80001954:	17048493          	addi	s1,s1,368
    80001958:	01348d63          	beq	s1,s3,80001972 <reparent+0x4a>
    if (pp->parent == p)
    8000195c:	7c9c                	ld	a5,56(s1)
    8000195e:	ff279be3          	bne	a5,s2,80001954 <reparent+0x2c>
      pp->parent = initproc;
    80001962:	000a3503          	ld	a0,0(s4)
    80001966:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001968:	00000097          	auipc	ra,0x0
    8000196c:	f4a080e7          	jalr	-182(ra) # 800018b2 <wakeup>
    80001970:	b7d5                	j	80001954 <reparent+0x2c>
}
    80001972:	70a2                	ld	ra,40(sp)
    80001974:	7402                	ld	s0,32(sp)
    80001976:	64e2                	ld	s1,24(sp)
    80001978:	6942                	ld	s2,16(sp)
    8000197a:	69a2                	ld	s3,8(sp)
    8000197c:	6a02                	ld	s4,0(sp)
    8000197e:	6145                	addi	sp,sp,48
    80001980:	8082                	ret

0000000080001982 <exit>:
{
    80001982:	7179                	addi	sp,sp,-48
    80001984:	f406                	sd	ra,40(sp)
    80001986:	f022                	sd	s0,32(sp)
    80001988:	ec26                	sd	s1,24(sp)
    8000198a:	e84a                	sd	s2,16(sp)
    8000198c:	e44e                	sd	s3,8(sp)
    8000198e:	e052                	sd	s4,0(sp)
    80001990:	1800                	addi	s0,sp,48
    80001992:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001994:	fffff097          	auipc	ra,0xfffff
    80001998:	648080e7          	jalr	1608(ra) # 80000fdc <myproc>
    8000199c:	89aa                	mv	s3,a0
  if (p == initproc)
    8000199e:	00007797          	auipc	a5,0x7
    800019a2:	6727b783          	ld	a5,1650(a5) # 80009010 <initproc>
    800019a6:	0d050493          	addi	s1,a0,208
    800019aa:	15050913          	addi	s2,a0,336
    800019ae:	02a79363          	bne	a5,a0,800019d4 <exit+0x52>
    panic("init exiting");
    800019b2:	00007517          	auipc	a0,0x7
    800019b6:	87650513          	addi	a0,a0,-1930 # 80008228 <etext+0x228>
    800019ba:	00004097          	auipc	ra,0x4
    800019be:	572080e7          	jalr	1394(ra) # 80005f2c <panic>
      fileclose(f);
    800019c2:	00002097          	auipc	ra,0x2
    800019c6:	27c080e7          	jalr	636(ra) # 80003c3e <fileclose>
      p->ofile[fd] = 0;
    800019ca:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    800019ce:	04a1                	addi	s1,s1,8
    800019d0:	01248563          	beq	s1,s2,800019da <exit+0x58>
    if (p->ofile[fd])
    800019d4:	6088                	ld	a0,0(s1)
    800019d6:	f575                	bnez	a0,800019c2 <exit+0x40>
    800019d8:	bfdd                	j	800019ce <exit+0x4c>
  begin_op();
    800019da:	00002097          	auipc	ra,0x2
    800019de:	d9a080e7          	jalr	-614(ra) # 80003774 <begin_op>
  iput(p->cwd);
    800019e2:	1509b503          	ld	a0,336(s3)
    800019e6:	00001097          	auipc	ra,0x1
    800019ea:	57a080e7          	jalr	1402(ra) # 80002f60 <iput>
  end_op();
    800019ee:	00002097          	auipc	ra,0x2
    800019f2:	e00080e7          	jalr	-512(ra) # 800037ee <end_op>
  p->cwd = 0;
    800019f6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800019fa:	00007497          	auipc	s1,0x7
    800019fe:	66e48493          	addi	s1,s1,1646 # 80009068 <wait_lock>
    80001a02:	8526                	mv	a0,s1
    80001a04:	00005097          	auipc	ra,0x5
    80001a08:	aa2080e7          	jalr	-1374(ra) # 800064a6 <acquire>
  reparent(p);
    80001a0c:	854e                	mv	a0,s3
    80001a0e:	00000097          	auipc	ra,0x0
    80001a12:	f1a080e7          	jalr	-230(ra) # 80001928 <reparent>
  wakeup(p->parent);
    80001a16:	0389b503          	ld	a0,56(s3)
    80001a1a:	00000097          	auipc	ra,0x0
    80001a1e:	e98080e7          	jalr	-360(ra) # 800018b2 <wakeup>
  acquire(&p->lock);
    80001a22:	854e                	mv	a0,s3
    80001a24:	00005097          	auipc	ra,0x5
    80001a28:	a82080e7          	jalr	-1406(ra) # 800064a6 <acquire>
  p->xstate = status;
    80001a2c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a30:	4795                	li	a5,5
    80001a32:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a36:	8526                	mv	a0,s1
    80001a38:	00005097          	auipc	ra,0x5
    80001a3c:	b22080e7          	jalr	-1246(ra) # 8000655a <release>
  sched();
    80001a40:	00000097          	auipc	ra,0x0
    80001a44:	bd4080e7          	jalr	-1068(ra) # 80001614 <sched>
  panic("zombie exit");
    80001a48:	00006517          	auipc	a0,0x6
    80001a4c:	7f050513          	addi	a0,a0,2032 # 80008238 <etext+0x238>
    80001a50:	00004097          	auipc	ra,0x4
    80001a54:	4dc080e7          	jalr	1244(ra) # 80005f2c <panic>

0000000080001a58 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001a58:	7179                	addi	sp,sp,-48
    80001a5a:	f406                	sd	ra,40(sp)
    80001a5c:	f022                	sd	s0,32(sp)
    80001a5e:	ec26                	sd	s1,24(sp)
    80001a60:	e84a                	sd	s2,16(sp)
    80001a62:	e44e                	sd	s3,8(sp)
    80001a64:	1800                	addi	s0,sp,48
    80001a66:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001a68:	00008497          	auipc	s1,0x8
    80001a6c:	a1848493          	addi	s1,s1,-1512 # 80009480 <proc>
    80001a70:	0000d997          	auipc	s3,0xd
    80001a74:	61098993          	addi	s3,s3,1552 # 8000f080 <tickslock>
  {
    acquire(&p->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	00005097          	auipc	ra,0x5
    80001a7e:	a2c080e7          	jalr	-1492(ra) # 800064a6 <acquire>
    if (p->pid == pid)
    80001a82:	589c                	lw	a5,48(s1)
    80001a84:	01278d63          	beq	a5,s2,80001a9e <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	00005097          	auipc	ra,0x5
    80001a8e:	ad0080e7          	jalr	-1328(ra) # 8000655a <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a92:	17048493          	addi	s1,s1,368
    80001a96:	ff3491e3          	bne	s1,s3,80001a78 <kill+0x20>
  }
  return -1;
    80001a9a:	557d                	li	a0,-1
    80001a9c:	a829                	j	80001ab6 <kill+0x5e>
      p->killed = 1;
    80001a9e:	4785                	li	a5,1
    80001aa0:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    80001aa2:	4c98                	lw	a4,24(s1)
    80001aa4:	4789                	li	a5,2
    80001aa6:	00f70f63          	beq	a4,a5,80001ac4 <kill+0x6c>
      release(&p->lock);
    80001aaa:	8526                	mv	a0,s1
    80001aac:	00005097          	auipc	ra,0x5
    80001ab0:	aae080e7          	jalr	-1362(ra) # 8000655a <release>
      return 0;
    80001ab4:	4501                	li	a0,0
}
    80001ab6:	70a2                	ld	ra,40(sp)
    80001ab8:	7402                	ld	s0,32(sp)
    80001aba:	64e2                	ld	s1,24(sp)
    80001abc:	6942                	ld	s2,16(sp)
    80001abe:	69a2                	ld	s3,8(sp)
    80001ac0:	6145                	addi	sp,sp,48
    80001ac2:	8082                	ret
        p->state = RUNNABLE;
    80001ac4:	478d                	li	a5,3
    80001ac6:	cc9c                	sw	a5,24(s1)
    80001ac8:	b7cd                	j	80001aaa <kill+0x52>

0000000080001aca <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001aca:	7179                	addi	sp,sp,-48
    80001acc:	f406                	sd	ra,40(sp)
    80001ace:	f022                	sd	s0,32(sp)
    80001ad0:	ec26                	sd	s1,24(sp)
    80001ad2:	e84a                	sd	s2,16(sp)
    80001ad4:	e44e                	sd	s3,8(sp)
    80001ad6:	e052                	sd	s4,0(sp)
    80001ad8:	1800                	addi	s0,sp,48
    80001ada:	84aa                	mv	s1,a0
    80001adc:	892e                	mv	s2,a1
    80001ade:	89b2                	mv	s3,a2
    80001ae0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ae2:	fffff097          	auipc	ra,0xfffff
    80001ae6:	4fa080e7          	jalr	1274(ra) # 80000fdc <myproc>
  if (user_dst)
    80001aea:	c08d                	beqz	s1,80001b0c <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80001aec:	86d2                	mv	a3,s4
    80001aee:	864e                	mv	a2,s3
    80001af0:	85ca                	mv	a1,s2
    80001af2:	6928                	ld	a0,80(a0)
    80001af4:	fffff097          	auipc	ra,0xfffff
    80001af8:	024080e7          	jalr	36(ra) # 80000b18 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001afc:	70a2                	ld	ra,40(sp)
    80001afe:	7402                	ld	s0,32(sp)
    80001b00:	64e2                	ld	s1,24(sp)
    80001b02:	6942                	ld	s2,16(sp)
    80001b04:	69a2                	ld	s3,8(sp)
    80001b06:	6a02                	ld	s4,0(sp)
    80001b08:	6145                	addi	sp,sp,48
    80001b0a:	8082                	ret
    memmove((char *)dst, src, len);
    80001b0c:	000a061b          	sext.w	a2,s4
    80001b10:	85ce                	mv	a1,s3
    80001b12:	854a                	mv	a0,s2
    80001b14:	ffffe097          	auipc	ra,0xffffe
    80001b18:	6c2080e7          	jalr	1730(ra) # 800001d6 <memmove>
    return 0;
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	bff9                	j	80001afc <either_copyout+0x32>

0000000080001b20 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b20:	7179                	addi	sp,sp,-48
    80001b22:	f406                	sd	ra,40(sp)
    80001b24:	f022                	sd	s0,32(sp)
    80001b26:	ec26                	sd	s1,24(sp)
    80001b28:	e84a                	sd	s2,16(sp)
    80001b2a:	e44e                	sd	s3,8(sp)
    80001b2c:	e052                	sd	s4,0(sp)
    80001b2e:	1800                	addi	s0,sp,48
    80001b30:	892a                	mv	s2,a0
    80001b32:	84ae                	mv	s1,a1
    80001b34:	89b2                	mv	s3,a2
    80001b36:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	4a4080e7          	jalr	1188(ra) # 80000fdc <myproc>
  if (user_src)
    80001b40:	c08d                	beqz	s1,80001b62 <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    80001b42:	86d2                	mv	a3,s4
    80001b44:	864e                	mv	a2,s3
    80001b46:	85ca                	mv	a1,s2
    80001b48:	6928                	ld	a0,80(a0)
    80001b4a:	fffff097          	auipc	ra,0xfffff
    80001b4e:	05a080e7          	jalr	90(ra) # 80000ba4 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80001b52:	70a2                	ld	ra,40(sp)
    80001b54:	7402                	ld	s0,32(sp)
    80001b56:	64e2                	ld	s1,24(sp)
    80001b58:	6942                	ld	s2,16(sp)
    80001b5a:	69a2                	ld	s3,8(sp)
    80001b5c:	6a02                	ld	s4,0(sp)
    80001b5e:	6145                	addi	sp,sp,48
    80001b60:	8082                	ret
    memmove(dst, (char *)src, len);
    80001b62:	000a061b          	sext.w	a2,s4
    80001b66:	85ce                	mv	a1,s3
    80001b68:	854a                	mv	a0,s2
    80001b6a:	ffffe097          	auipc	ra,0xffffe
    80001b6e:	66c080e7          	jalr	1644(ra) # 800001d6 <memmove>
    return 0;
    80001b72:	8526                	mv	a0,s1
    80001b74:	bff9                	j	80001b52 <either_copyin+0x32>

0000000080001b76 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001b76:	715d                	addi	sp,sp,-80
    80001b78:	e486                	sd	ra,72(sp)
    80001b7a:	e0a2                	sd	s0,64(sp)
    80001b7c:	fc26                	sd	s1,56(sp)
    80001b7e:	f84a                	sd	s2,48(sp)
    80001b80:	f44e                	sd	s3,40(sp)
    80001b82:	f052                	sd	s4,32(sp)
    80001b84:	ec56                	sd	s5,24(sp)
    80001b86:	e85a                	sd	s6,16(sp)
    80001b88:	e45e                	sd	s7,8(sp)
    80001b8a:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001b8c:	00006517          	auipc	a0,0x6
    80001b90:	48c50513          	addi	a0,a0,1164 # 80008018 <etext+0x18>
    80001b94:	00004097          	auipc	ra,0x4
    80001b98:	3e2080e7          	jalr	994(ra) # 80005f76 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001b9c:	00008497          	auipc	s1,0x8
    80001ba0:	a3c48493          	addi	s1,s1,-1476 # 800095d8 <proc+0x158>
    80001ba4:	0000d917          	auipc	s2,0xd
    80001ba8:	63490913          	addi	s2,s2,1588 # 8000f1d8 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bac:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bae:	00006997          	auipc	s3,0x6
    80001bb2:	69a98993          	addi	s3,s3,1690 # 80008248 <etext+0x248>
    printf("%d %s %s", p->pid, state, p->name);
    80001bb6:	00006a97          	auipc	s5,0x6
    80001bba:	69aa8a93          	addi	s5,s5,1690 # 80008250 <etext+0x250>
    printf("\n");
    80001bbe:	00006a17          	auipc	s4,0x6
    80001bc2:	45aa0a13          	addi	s4,s4,1114 # 80008018 <etext+0x18>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bc6:	00007b97          	auipc	s7,0x7
    80001bca:	b82b8b93          	addi	s7,s7,-1150 # 80008748 <states.0>
    80001bce:	a00d                	j	80001bf0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bd0:	ed86a583          	lw	a1,-296(a3)
    80001bd4:	8556                	mv	a0,s5
    80001bd6:	00004097          	auipc	ra,0x4
    80001bda:	3a0080e7          	jalr	928(ra) # 80005f76 <printf>
    printf("\n");
    80001bde:	8552                	mv	a0,s4
    80001be0:	00004097          	auipc	ra,0x4
    80001be4:	396080e7          	jalr	918(ra) # 80005f76 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001be8:	17048493          	addi	s1,s1,368
    80001bec:	03248263          	beq	s1,s2,80001c10 <procdump+0x9a>
    if (p->state == UNUSED)
    80001bf0:	86a6                	mv	a3,s1
    80001bf2:	ec04a783          	lw	a5,-320(s1)
    80001bf6:	dbed                	beqz	a5,80001be8 <procdump+0x72>
      state = "???";
    80001bf8:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bfa:	fcfb6be3          	bltu	s6,a5,80001bd0 <procdump+0x5a>
    80001bfe:	02079713          	slli	a4,a5,0x20
    80001c02:	01d75793          	srli	a5,a4,0x1d
    80001c06:	97de                	add	a5,a5,s7
    80001c08:	6390                	ld	a2,0(a5)
    80001c0a:	f279                	bnez	a2,80001bd0 <procdump+0x5a>
      state = "???";
    80001c0c:	864e                	mv	a2,s3
    80001c0e:	b7c9                	j	80001bd0 <procdump+0x5a>
  }
}
    80001c10:	60a6                	ld	ra,72(sp)
    80001c12:	6406                	ld	s0,64(sp)
    80001c14:	74e2                	ld	s1,56(sp)
    80001c16:	7942                	ld	s2,48(sp)
    80001c18:	79a2                	ld	s3,40(sp)
    80001c1a:	7a02                	ld	s4,32(sp)
    80001c1c:	6ae2                	ld	s5,24(sp)
    80001c1e:	6b42                	ld	s6,16(sp)
    80001c20:	6ba2                	ld	s7,8(sp)
    80001c22:	6161                	addi	sp,sp,80
    80001c24:	8082                	ret

0000000080001c26 <swtch>:
    80001c26:	00153023          	sd	ra,0(a0)
    80001c2a:	00253423          	sd	sp,8(a0)
    80001c2e:	e900                	sd	s0,16(a0)
    80001c30:	ed04                	sd	s1,24(a0)
    80001c32:	03253023          	sd	s2,32(a0)
    80001c36:	03353423          	sd	s3,40(a0)
    80001c3a:	03453823          	sd	s4,48(a0)
    80001c3e:	03553c23          	sd	s5,56(a0)
    80001c42:	05653023          	sd	s6,64(a0)
    80001c46:	05753423          	sd	s7,72(a0)
    80001c4a:	05853823          	sd	s8,80(a0)
    80001c4e:	05953c23          	sd	s9,88(a0)
    80001c52:	07a53023          	sd	s10,96(a0)
    80001c56:	07b53423          	sd	s11,104(a0)
    80001c5a:	0005b083          	ld	ra,0(a1)
    80001c5e:	0085b103          	ld	sp,8(a1)
    80001c62:	6980                	ld	s0,16(a1)
    80001c64:	6d84                	ld	s1,24(a1)
    80001c66:	0205b903          	ld	s2,32(a1)
    80001c6a:	0285b983          	ld	s3,40(a1)
    80001c6e:	0305ba03          	ld	s4,48(a1)
    80001c72:	0385ba83          	ld	s5,56(a1)
    80001c76:	0405bb03          	ld	s6,64(a1)
    80001c7a:	0485bb83          	ld	s7,72(a1)
    80001c7e:	0505bc03          	ld	s8,80(a1)
    80001c82:	0585bc83          	ld	s9,88(a1)
    80001c86:	0605bd03          	ld	s10,96(a1)
    80001c8a:	0685bd83          	ld	s11,104(a1)
    80001c8e:	8082                	ret

0000000080001c90 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c90:	1141                	addi	sp,sp,-16
    80001c92:	e406                	sd	ra,8(sp)
    80001c94:	e022                	sd	s0,0(sp)
    80001c96:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c98:	00006597          	auipc	a1,0x6
    80001c9c:	5f058593          	addi	a1,a1,1520 # 80008288 <etext+0x288>
    80001ca0:	0000d517          	auipc	a0,0xd
    80001ca4:	3e050513          	addi	a0,a0,992 # 8000f080 <tickslock>
    80001ca8:	00004097          	auipc	ra,0x4
    80001cac:	76e080e7          	jalr	1902(ra) # 80006416 <initlock>
}
    80001cb0:	60a2                	ld	ra,8(sp)
    80001cb2:	6402                	ld	s0,0(sp)
    80001cb4:	0141                	addi	sp,sp,16
    80001cb6:	8082                	ret

0000000080001cb8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cb8:	1141                	addi	sp,sp,-16
    80001cba:	e422                	sd	s0,8(sp)
    80001cbc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cbe:	00003797          	auipc	a5,0x3
    80001cc2:	68278793          	addi	a5,a5,1666 # 80005340 <kernelvec>
    80001cc6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cca:	6422                	ld	s0,8(sp)
    80001ccc:	0141                	addi	sp,sp,16
    80001cce:	8082                	ret

0000000080001cd0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cd0:	1141                	addi	sp,sp,-16
    80001cd2:	e406                	sd	ra,8(sp)
    80001cd4:	e022                	sd	s0,0(sp)
    80001cd6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cd8:	fffff097          	auipc	ra,0xfffff
    80001cdc:	304080e7          	jalr	772(ra) # 80000fdc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ce4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001cea:	00005697          	auipc	a3,0x5
    80001cee:	31668693          	addi	a3,a3,790 # 80007000 <_trampoline>
    80001cf2:	00005717          	auipc	a4,0x5
    80001cf6:	30e70713          	addi	a4,a4,782 # 80007000 <_trampoline>
    80001cfa:	8f15                	sub	a4,a4,a3
    80001cfc:	040007b7          	lui	a5,0x4000
    80001d00:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d02:	07b2                	slli	a5,a5,0xc
    80001d04:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d06:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d0a:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d0c:	18002673          	csrr	a2,satp
    80001d10:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d12:	6d30                	ld	a2,88(a0)
    80001d14:	6138                	ld	a4,64(a0)
    80001d16:	6585                	lui	a1,0x1
    80001d18:	972e                	add	a4,a4,a1
    80001d1a:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d1c:	6d38                	ld	a4,88(a0)
    80001d1e:	00000617          	auipc	a2,0x0
    80001d22:	14060613          	addi	a2,a2,320 # 80001e5e <usertrap>
    80001d26:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d28:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d2a:	8612                	mv	a2,tp
    80001d2c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d32:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d36:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d3a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d3e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d40:	6f18                	ld	a4,24(a4)
    80001d42:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d46:	692c                	ld	a1,80(a0)
    80001d48:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d4a:	00005717          	auipc	a4,0x5
    80001d4e:	34670713          	addi	a4,a4,838 # 80007090 <userret>
    80001d52:	8f15                	sub	a4,a4,a3
    80001d54:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d56:	577d                	li	a4,-1
    80001d58:	177e                	slli	a4,a4,0x3f
    80001d5a:	8dd9                	or	a1,a1,a4
    80001d5c:	02000537          	lui	a0,0x2000
    80001d60:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d62:	0536                	slli	a0,a0,0xd
    80001d64:	9782                	jalr	a5
}
    80001d66:	60a2                	ld	ra,8(sp)
    80001d68:	6402                	ld	s0,0(sp)
    80001d6a:	0141                	addi	sp,sp,16
    80001d6c:	8082                	ret

0000000080001d6e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d6e:	1101                	addi	sp,sp,-32
    80001d70:	ec06                	sd	ra,24(sp)
    80001d72:	e822                	sd	s0,16(sp)
    80001d74:	e426                	sd	s1,8(sp)
    80001d76:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d78:	0000d497          	auipc	s1,0xd
    80001d7c:	30848493          	addi	s1,s1,776 # 8000f080 <tickslock>
    80001d80:	8526                	mv	a0,s1
    80001d82:	00004097          	auipc	ra,0x4
    80001d86:	724080e7          	jalr	1828(ra) # 800064a6 <acquire>
  ticks++;
    80001d8a:	00007517          	auipc	a0,0x7
    80001d8e:	28e50513          	addi	a0,a0,654 # 80009018 <ticks>
    80001d92:	411c                	lw	a5,0(a0)
    80001d94:	2785                	addiw	a5,a5,1
    80001d96:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	b1a080e7          	jalr	-1254(ra) # 800018b2 <wakeup>
  release(&tickslock);
    80001da0:	8526                	mv	a0,s1
    80001da2:	00004097          	auipc	ra,0x4
    80001da6:	7b8080e7          	jalr	1976(ra) # 8000655a <release>
}
    80001daa:	60e2                	ld	ra,24(sp)
    80001dac:	6442                	ld	s0,16(sp)
    80001dae:	64a2                	ld	s1,8(sp)
    80001db0:	6105                	addi	sp,sp,32
    80001db2:	8082                	ret

0000000080001db4 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001db4:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001db8:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001dba:	0a07d163          	bgez	a5,80001e5c <devintr+0xa8>
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001dc6:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001dca:	46a5                	li	a3,9
    80001dcc:	00d70c63          	beq	a4,a3,80001de4 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001dd0:	577d                	li	a4,-1
    80001dd2:	177e                	slli	a4,a4,0x3f
    80001dd4:	0705                	addi	a4,a4,1
    return 0;
    80001dd6:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dd8:	06e78163          	beq	a5,a4,80001e3a <devintr+0x86>
  }
}
    80001ddc:	60e2                	ld	ra,24(sp)
    80001dde:	6442                	ld	s0,16(sp)
    80001de0:	6105                	addi	sp,sp,32
    80001de2:	8082                	ret
    80001de4:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001de6:	00003097          	auipc	ra,0x3
    80001dea:	666080e7          	jalr	1638(ra) # 8000544c <plic_claim>
    80001dee:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001df0:	47a9                	li	a5,10
    80001df2:	00f50963          	beq	a0,a5,80001e04 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001df6:	4785                	li	a5,1
    80001df8:	00f50b63          	beq	a0,a5,80001e0e <devintr+0x5a>
    return 1;
    80001dfc:	4505                	li	a0,1
    } else if(irq){
    80001dfe:	ec89                	bnez	s1,80001e18 <devintr+0x64>
    80001e00:	64a2                	ld	s1,8(sp)
    80001e02:	bfe9                	j	80001ddc <devintr+0x28>
      uartintr();
    80001e04:	00004097          	auipc	ra,0x4
    80001e08:	5c2080e7          	jalr	1474(ra) # 800063c6 <uartintr>
    if(irq)
    80001e0c:	a839                	j	80001e2a <devintr+0x76>
      virtio_disk_intr();
    80001e0e:	00004097          	auipc	ra,0x4
    80001e12:	b12080e7          	jalr	-1262(ra) # 80005920 <virtio_disk_intr>
    if(irq)
    80001e16:	a811                	j	80001e2a <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e18:	85a6                	mv	a1,s1
    80001e1a:	00006517          	auipc	a0,0x6
    80001e1e:	47650513          	addi	a0,a0,1142 # 80008290 <etext+0x290>
    80001e22:	00004097          	auipc	ra,0x4
    80001e26:	154080e7          	jalr	340(ra) # 80005f76 <printf>
      plic_complete(irq);
    80001e2a:	8526                	mv	a0,s1
    80001e2c:	00003097          	auipc	ra,0x3
    80001e30:	644080e7          	jalr	1604(ra) # 80005470 <plic_complete>
    return 1;
    80001e34:	4505                	li	a0,1
    80001e36:	64a2                	ld	s1,8(sp)
    80001e38:	b755                	j	80001ddc <devintr+0x28>
    if(cpuid() == 0){
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	176080e7          	jalr	374(ra) # 80000fb0 <cpuid>
    80001e42:	c901                	beqz	a0,80001e52 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e44:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e48:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e4a:	14479073          	csrw	sip,a5
    return 2;
    80001e4e:	4509                	li	a0,2
    80001e50:	b771                	j	80001ddc <devintr+0x28>
      clockintr();
    80001e52:	00000097          	auipc	ra,0x0
    80001e56:	f1c080e7          	jalr	-228(ra) # 80001d6e <clockintr>
    80001e5a:	b7ed                	j	80001e44 <devintr+0x90>
}
    80001e5c:	8082                	ret

0000000080001e5e <usertrap>:
{
    80001e5e:	1101                	addi	sp,sp,-32
    80001e60:	ec06                	sd	ra,24(sp)
    80001e62:	e822                	sd	s0,16(sp)
    80001e64:	e426                	sd	s1,8(sp)
    80001e66:	e04a                	sd	s2,0(sp)
    80001e68:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e6e:	1007f793          	andi	a5,a5,256
    80001e72:	e3ad                	bnez	a5,80001ed4 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e74:	00003797          	auipc	a5,0x3
    80001e78:	4cc78793          	addi	a5,a5,1228 # 80005340 <kernelvec>
    80001e7c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	15c080e7          	jalr	348(ra) # 80000fdc <myproc>
    80001e88:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e8a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e8c:	14102773          	csrr	a4,sepc
    80001e90:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e92:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e96:	47a1                	li	a5,8
    80001e98:	04f71c63          	bne	a4,a5,80001ef0 <usertrap+0x92>
    if(p->killed)
    80001e9c:	551c                	lw	a5,40(a0)
    80001e9e:	e3b9                	bnez	a5,80001ee4 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001ea0:	6cb8                	ld	a4,88(s1)
    80001ea2:	6f1c                	ld	a5,24(a4)
    80001ea4:	0791                	addi	a5,a5,4
    80001ea6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eac:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb0:	10079073          	csrw	sstatus,a5
    syscall();
    80001eb4:	00000097          	auipc	ra,0x0
    80001eb8:	2e0080e7          	jalr	736(ra) # 80002194 <syscall>
  if(p->killed)
    80001ebc:	549c                	lw	a5,40(s1)
    80001ebe:	ebc1                	bnez	a5,80001f4e <usertrap+0xf0>
  usertrapret();
    80001ec0:	00000097          	auipc	ra,0x0
    80001ec4:	e10080e7          	jalr	-496(ra) # 80001cd0 <usertrapret>
}
    80001ec8:	60e2                	ld	ra,24(sp)
    80001eca:	6442                	ld	s0,16(sp)
    80001ecc:	64a2                	ld	s1,8(sp)
    80001ece:	6902                	ld	s2,0(sp)
    80001ed0:	6105                	addi	sp,sp,32
    80001ed2:	8082                	ret
    panic("usertrap: not from user mode");
    80001ed4:	00006517          	auipc	a0,0x6
    80001ed8:	3dc50513          	addi	a0,a0,988 # 800082b0 <etext+0x2b0>
    80001edc:	00004097          	auipc	ra,0x4
    80001ee0:	050080e7          	jalr	80(ra) # 80005f2c <panic>
      exit(-1);
    80001ee4:	557d                	li	a0,-1
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	a9c080e7          	jalr	-1380(ra) # 80001982 <exit>
    80001eee:	bf4d                	j	80001ea0 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001ef0:	00000097          	auipc	ra,0x0
    80001ef4:	ec4080e7          	jalr	-316(ra) # 80001db4 <devintr>
    80001ef8:	892a                	mv	s2,a0
    80001efa:	c501                	beqz	a0,80001f02 <usertrap+0xa4>
  if(p->killed)
    80001efc:	549c                	lw	a5,40(s1)
    80001efe:	c3a1                	beqz	a5,80001f3e <usertrap+0xe0>
    80001f00:	a815                	j	80001f34 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f02:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f06:	5890                	lw	a2,48(s1)
    80001f08:	00006517          	auipc	a0,0x6
    80001f0c:	3c850513          	addi	a0,a0,968 # 800082d0 <etext+0x2d0>
    80001f10:	00004097          	auipc	ra,0x4
    80001f14:	066080e7          	jalr	102(ra) # 80005f76 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f18:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f1c:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f20:	00006517          	auipc	a0,0x6
    80001f24:	3e050513          	addi	a0,a0,992 # 80008300 <etext+0x300>
    80001f28:	00004097          	auipc	ra,0x4
    80001f2c:	04e080e7          	jalr	78(ra) # 80005f76 <printf>
    p->killed = 1;
    80001f30:	4785                	li	a5,1
    80001f32:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f34:	557d                	li	a0,-1
    80001f36:	00000097          	auipc	ra,0x0
    80001f3a:	a4c080e7          	jalr	-1460(ra) # 80001982 <exit>
  if(which_dev == 2)
    80001f3e:	4789                	li	a5,2
    80001f40:	f8f910e3          	bne	s2,a5,80001ec0 <usertrap+0x62>
    yield();
    80001f44:	fffff097          	auipc	ra,0xfffff
    80001f48:	7a6080e7          	jalr	1958(ra) # 800016ea <yield>
    80001f4c:	bf95                	j	80001ec0 <usertrap+0x62>
  int which_dev = 0;
    80001f4e:	4901                	li	s2,0
    80001f50:	b7d5                	j	80001f34 <usertrap+0xd6>

0000000080001f52 <kerneltrap>:
{
    80001f52:	7179                	addi	sp,sp,-48
    80001f54:	f406                	sd	ra,40(sp)
    80001f56:	f022                	sd	s0,32(sp)
    80001f58:	ec26                	sd	s1,24(sp)
    80001f5a:	e84a                	sd	s2,16(sp)
    80001f5c:	e44e                	sd	s3,8(sp)
    80001f5e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f60:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f64:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f68:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f6c:	1004f793          	andi	a5,s1,256
    80001f70:	cb85                	beqz	a5,80001fa0 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f72:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f76:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f78:	ef85                	bnez	a5,80001fb0 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f7a:	00000097          	auipc	ra,0x0
    80001f7e:	e3a080e7          	jalr	-454(ra) # 80001db4 <devintr>
    80001f82:	cd1d                	beqz	a0,80001fc0 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f84:	4789                	li	a5,2
    80001f86:	06f50a63          	beq	a0,a5,80001ffa <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f8a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f8e:	10049073          	csrw	sstatus,s1
}
    80001f92:	70a2                	ld	ra,40(sp)
    80001f94:	7402                	ld	s0,32(sp)
    80001f96:	64e2                	ld	s1,24(sp)
    80001f98:	6942                	ld	s2,16(sp)
    80001f9a:	69a2                	ld	s3,8(sp)
    80001f9c:	6145                	addi	sp,sp,48
    80001f9e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fa0:	00006517          	auipc	a0,0x6
    80001fa4:	38050513          	addi	a0,a0,896 # 80008320 <etext+0x320>
    80001fa8:	00004097          	auipc	ra,0x4
    80001fac:	f84080e7          	jalr	-124(ra) # 80005f2c <panic>
    panic("kerneltrap: interrupts enabled");
    80001fb0:	00006517          	auipc	a0,0x6
    80001fb4:	39850513          	addi	a0,a0,920 # 80008348 <etext+0x348>
    80001fb8:	00004097          	auipc	ra,0x4
    80001fbc:	f74080e7          	jalr	-140(ra) # 80005f2c <panic>
    printf("scause %p\n", scause);
    80001fc0:	85ce                	mv	a1,s3
    80001fc2:	00006517          	auipc	a0,0x6
    80001fc6:	3a650513          	addi	a0,a0,934 # 80008368 <etext+0x368>
    80001fca:	00004097          	auipc	ra,0x4
    80001fce:	fac080e7          	jalr	-84(ra) # 80005f76 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fd2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fd6:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fda:	00006517          	auipc	a0,0x6
    80001fde:	39e50513          	addi	a0,a0,926 # 80008378 <etext+0x378>
    80001fe2:	00004097          	auipc	ra,0x4
    80001fe6:	f94080e7          	jalr	-108(ra) # 80005f76 <printf>
    panic("kerneltrap");
    80001fea:	00006517          	auipc	a0,0x6
    80001fee:	3a650513          	addi	a0,a0,934 # 80008390 <etext+0x390>
    80001ff2:	00004097          	auipc	ra,0x4
    80001ff6:	f3a080e7          	jalr	-198(ra) # 80005f2c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ffa:	fffff097          	auipc	ra,0xfffff
    80001ffe:	fe2080e7          	jalr	-30(ra) # 80000fdc <myproc>
    80002002:	d541                	beqz	a0,80001f8a <kerneltrap+0x38>
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	fd8080e7          	jalr	-40(ra) # 80000fdc <myproc>
    8000200c:	4d18                	lw	a4,24(a0)
    8000200e:	4791                	li	a5,4
    80002010:	f6f71de3          	bne	a4,a5,80001f8a <kerneltrap+0x38>
    yield();
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	6d6080e7          	jalr	1750(ra) # 800016ea <yield>
    8000201c:	b7bd                	j	80001f8a <kerneltrap+0x38>

000000008000201e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    8000201e:	1101                	addi	sp,sp,-32
    80002020:	ec06                	sd	ra,24(sp)
    80002022:	e822                	sd	s0,16(sp)
    80002024:	e426                	sd	s1,8(sp)
    80002026:	1000                	addi	s0,sp,32
    80002028:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	fb2080e7          	jalr	-78(ra) # 80000fdc <myproc>
  switch (n) {
    80002032:	4795                	li	a5,5
    80002034:	0497e163          	bltu	a5,s1,80002076 <argraw+0x58>
    80002038:	048a                	slli	s1,s1,0x2
    8000203a:	00006717          	auipc	a4,0x6
    8000203e:	73e70713          	addi	a4,a4,1854 # 80008778 <states.0+0x30>
    80002042:	94ba                	add	s1,s1,a4
    80002044:	409c                	lw	a5,0(s1)
    80002046:	97ba                	add	a5,a5,a4
    80002048:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000204a:	6d3c                	ld	a5,88(a0)
    8000204c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6105                	addi	sp,sp,32
    80002056:	8082                	ret
    return p->trapframe->a1;
    80002058:	6d3c                	ld	a5,88(a0)
    8000205a:	7fa8                	ld	a0,120(a5)
    8000205c:	bfcd                	j	8000204e <argraw+0x30>
    return p->trapframe->a2;
    8000205e:	6d3c                	ld	a5,88(a0)
    80002060:	63c8                	ld	a0,128(a5)
    80002062:	b7f5                	j	8000204e <argraw+0x30>
    return p->trapframe->a3;
    80002064:	6d3c                	ld	a5,88(a0)
    80002066:	67c8                	ld	a0,136(a5)
    80002068:	b7dd                	j	8000204e <argraw+0x30>
    return p->trapframe->a4;
    8000206a:	6d3c                	ld	a5,88(a0)
    8000206c:	6bc8                	ld	a0,144(a5)
    8000206e:	b7c5                	j	8000204e <argraw+0x30>
    return p->trapframe->a5;
    80002070:	6d3c                	ld	a5,88(a0)
    80002072:	6fc8                	ld	a0,152(a5)
    80002074:	bfe9                	j	8000204e <argraw+0x30>
  panic("argraw");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	32a50513          	addi	a0,a0,810 # 800083a0 <etext+0x3a0>
    8000207e:	00004097          	auipc	ra,0x4
    80002082:	eae080e7          	jalr	-338(ra) # 80005f2c <panic>

0000000080002086 <fetchaddr>:
{
    80002086:	1101                	addi	sp,sp,-32
    80002088:	ec06                	sd	ra,24(sp)
    8000208a:	e822                	sd	s0,16(sp)
    8000208c:	e426                	sd	s1,8(sp)
    8000208e:	e04a                	sd	s2,0(sp)
    80002090:	1000                	addi	s0,sp,32
    80002092:	84aa                	mv	s1,a0
    80002094:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002096:	fffff097          	auipc	ra,0xfffff
    8000209a:	f46080e7          	jalr	-186(ra) # 80000fdc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    8000209e:	653c                	ld	a5,72(a0)
    800020a0:	02f4f863          	bgeu	s1,a5,800020d0 <fetchaddr+0x4a>
    800020a4:	00848713          	addi	a4,s1,8
    800020a8:	02e7e663          	bltu	a5,a4,800020d4 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020ac:	46a1                	li	a3,8
    800020ae:	8626                	mv	a2,s1
    800020b0:	85ca                	mv	a1,s2
    800020b2:	6928                	ld	a0,80(a0)
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	af0080e7          	jalr	-1296(ra) # 80000ba4 <copyin>
    800020bc:	00a03533          	snez	a0,a0
    800020c0:	40a00533          	neg	a0,a0
}
    800020c4:	60e2                	ld	ra,24(sp)
    800020c6:	6442                	ld	s0,16(sp)
    800020c8:	64a2                	ld	s1,8(sp)
    800020ca:	6902                	ld	s2,0(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret
    return -1;
    800020d0:	557d                	li	a0,-1
    800020d2:	bfcd                	j	800020c4 <fetchaddr+0x3e>
    800020d4:	557d                	li	a0,-1
    800020d6:	b7fd                	j	800020c4 <fetchaddr+0x3e>

00000000800020d8 <fetchstr>:
{
    800020d8:	7179                	addi	sp,sp,-48
    800020da:	f406                	sd	ra,40(sp)
    800020dc:	f022                	sd	s0,32(sp)
    800020de:	ec26                	sd	s1,24(sp)
    800020e0:	e84a                	sd	s2,16(sp)
    800020e2:	e44e                	sd	s3,8(sp)
    800020e4:	1800                	addi	s0,sp,48
    800020e6:	892a                	mv	s2,a0
    800020e8:	84ae                	mv	s1,a1
    800020ea:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020ec:	fffff097          	auipc	ra,0xfffff
    800020f0:	ef0080e7          	jalr	-272(ra) # 80000fdc <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800020f4:	86ce                	mv	a3,s3
    800020f6:	864a                	mv	a2,s2
    800020f8:	85a6                	mv	a1,s1
    800020fa:	6928                	ld	a0,80(a0)
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	b36080e7          	jalr	-1226(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80002104:	00054763          	bltz	a0,80002112 <fetchstr+0x3a>
  return strlen(buf);
    80002108:	8526                	mv	a0,s1
    8000210a:	ffffe097          	auipc	ra,0xffffe
    8000210e:	1e4080e7          	jalr	484(ra) # 800002ee <strlen>
}
    80002112:	70a2                	ld	ra,40(sp)
    80002114:	7402                	ld	s0,32(sp)
    80002116:	64e2                	ld	s1,24(sp)
    80002118:	6942                	ld	s2,16(sp)
    8000211a:	69a2                	ld	s3,8(sp)
    8000211c:	6145                	addi	sp,sp,48
    8000211e:	8082                	ret

0000000080002120 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002120:	1101                	addi	sp,sp,-32
    80002122:	ec06                	sd	ra,24(sp)
    80002124:	e822                	sd	s0,16(sp)
    80002126:	e426                	sd	s1,8(sp)
    80002128:	1000                	addi	s0,sp,32
    8000212a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000212c:	00000097          	auipc	ra,0x0
    80002130:	ef2080e7          	jalr	-270(ra) # 8000201e <argraw>
    80002134:	c088                	sw	a0,0(s1)
  return 0;
}
    80002136:	4501                	li	a0,0
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6105                	addi	sp,sp,32
    80002140:	8082                	ret

0000000080002142 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002142:	1101                	addi	sp,sp,-32
    80002144:	ec06                	sd	ra,24(sp)
    80002146:	e822                	sd	s0,16(sp)
    80002148:	e426                	sd	s1,8(sp)
    8000214a:	1000                	addi	s0,sp,32
    8000214c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	ed0080e7          	jalr	-304(ra) # 8000201e <argraw>
    80002156:	e088                	sd	a0,0(s1)
  return 0;
}
    80002158:	4501                	li	a0,0
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6105                	addi	sp,sp,32
    80002162:	8082                	ret

0000000080002164 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002164:	1101                	addi	sp,sp,-32
    80002166:	ec06                	sd	ra,24(sp)
    80002168:	e822                	sd	s0,16(sp)
    8000216a:	e426                	sd	s1,8(sp)
    8000216c:	e04a                	sd	s2,0(sp)
    8000216e:	1000                	addi	s0,sp,32
    80002170:	84ae                	mv	s1,a1
    80002172:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002174:	00000097          	auipc	ra,0x0
    80002178:	eaa080e7          	jalr	-342(ra) # 8000201e <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    8000217c:	864a                	mv	a2,s2
    8000217e:	85a6                	mv	a1,s1
    80002180:	00000097          	auipc	ra,0x0
    80002184:	f58080e7          	jalr	-168(ra) # 800020d8 <fetchstr>
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	64a2                	ld	s1,8(sp)
    8000218e:	6902                	ld	s2,0(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <syscall>:



void
syscall(void)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	e426                	sd	s1,8(sp)
    8000219c:	e04a                	sd	s2,0(sp)
    8000219e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	e3c080e7          	jalr	-452(ra) # 80000fdc <myproc>
    800021a8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021aa:	05853903          	ld	s2,88(a0)
    800021ae:	0a893783          	ld	a5,168(s2)
    800021b2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021b6:	37fd                	addiw	a5,a5,-1
    800021b8:	4775                	li	a4,29
    800021ba:	00f76f63          	bltu	a4,a5,800021d8 <syscall+0x44>
    800021be:	00369713          	slli	a4,a3,0x3
    800021c2:	00006797          	auipc	a5,0x6
    800021c6:	5ce78793          	addi	a5,a5,1486 # 80008790 <syscalls>
    800021ca:	97ba                	add	a5,a5,a4
    800021cc:	639c                	ld	a5,0(a5)
    800021ce:	c789                	beqz	a5,800021d8 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800021d0:	9782                	jalr	a5
    800021d2:	06a93823          	sd	a0,112(s2)
    800021d6:	a839                	j	800021f4 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021d8:	15848613          	addi	a2,s1,344
    800021dc:	588c                	lw	a1,48(s1)
    800021de:	00006517          	auipc	a0,0x6
    800021e2:	1ca50513          	addi	a0,a0,458 # 800083a8 <etext+0x3a8>
    800021e6:	00004097          	auipc	ra,0x4
    800021ea:	d90080e7          	jalr	-624(ra) # 80005f76 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021ee:	6cbc                	ld	a5,88(s1)
    800021f0:	577d                	li	a4,-1
    800021f2:	fbb8                	sd	a4,112(a5)
  }
}
    800021f4:	60e2                	ld	ra,24(sp)
    800021f6:	6442                	ld	s0,16(sp)
    800021f8:	64a2                	ld	s1,8(sp)
    800021fa:	6902                	ld	s2,0(sp)
    800021fc:	6105                	addi	sp,sp,32
    800021fe:	8082                	ret

0000000080002200 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002200:	1101                	addi	sp,sp,-32
    80002202:	ec06                	sd	ra,24(sp)
    80002204:	e822                	sd	s0,16(sp)
    80002206:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002208:	fec40593          	addi	a1,s0,-20
    8000220c:	4501                	li	a0,0
    8000220e:	00000097          	auipc	ra,0x0
    80002212:	f12080e7          	jalr	-238(ra) # 80002120 <argint>
    return -1;
    80002216:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002218:	00054963          	bltz	a0,8000222a <sys_exit+0x2a>
  exit(n);
    8000221c:	fec42503          	lw	a0,-20(s0)
    80002220:	fffff097          	auipc	ra,0xfffff
    80002224:	762080e7          	jalr	1890(ra) # 80001982 <exit>
  return 0;  // not reached
    80002228:	4781                	li	a5,0
}
    8000222a:	853e                	mv	a0,a5
    8000222c:	60e2                	ld	ra,24(sp)
    8000222e:	6442                	ld	s0,16(sp)
    80002230:	6105                	addi	sp,sp,32
    80002232:	8082                	ret

0000000080002234 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002234:	1141                	addi	sp,sp,-16
    80002236:	e406                	sd	ra,8(sp)
    80002238:	e022                	sd	s0,0(sp)
    8000223a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	da0080e7          	jalr	-608(ra) # 80000fdc <myproc>
}
    80002244:	5908                	lw	a0,48(a0)
    80002246:	60a2                	ld	ra,8(sp)
    80002248:	6402                	ld	s0,0(sp)
    8000224a:	0141                	addi	sp,sp,16
    8000224c:	8082                	ret

000000008000224e <sys_fork>:

uint64
sys_fork(void)
{
    8000224e:	1141                	addi	sp,sp,-16
    80002250:	e406                	sd	ra,8(sp)
    80002252:	e022                	sd	s0,0(sp)
    80002254:	0800                	addi	s0,sp,16
  return fork();
    80002256:	fffff097          	auipc	ra,0xfffff
    8000225a:	1dc080e7          	jalr	476(ra) # 80001432 <fork>
}
    8000225e:	60a2                	ld	ra,8(sp)
    80002260:	6402                	ld	s0,0(sp)
    80002262:	0141                	addi	sp,sp,16
    80002264:	8082                	ret

0000000080002266 <sys_wait>:

uint64
sys_wait(void)
{
    80002266:	1101                	addi	sp,sp,-32
    80002268:	ec06                	sd	ra,24(sp)
    8000226a:	e822                	sd	s0,16(sp)
    8000226c:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000226e:	fe840593          	addi	a1,s0,-24
    80002272:	4501                	li	a0,0
    80002274:	00000097          	auipc	ra,0x0
    80002278:	ece080e7          	jalr	-306(ra) # 80002142 <argaddr>
    8000227c:	87aa                	mv	a5,a0
    return -1;
    8000227e:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002280:	0007c863          	bltz	a5,80002290 <sys_wait+0x2a>
  return wait(p);
    80002284:	fe843503          	ld	a0,-24(s0)
    80002288:	fffff097          	auipc	ra,0xfffff
    8000228c:	502080e7          	jalr	1282(ra) # 8000178a <wait>
}
    80002290:	60e2                	ld	ra,24(sp)
    80002292:	6442                	ld	s0,16(sp)
    80002294:	6105                	addi	sp,sp,32
    80002296:	8082                	ret

0000000080002298 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002298:	7179                	addi	sp,sp,-48
    8000229a:	f406                	sd	ra,40(sp)
    8000229c:	f022                	sd	s0,32(sp)
    8000229e:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022a0:	fdc40593          	addi	a1,s0,-36
    800022a4:	4501                	li	a0,0
    800022a6:	00000097          	auipc	ra,0x0
    800022aa:	e7a080e7          	jalr	-390(ra) # 80002120 <argint>
    800022ae:	87aa                	mv	a5,a0
    return -1;
    800022b0:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    800022b2:	0207c263          	bltz	a5,800022d6 <sys_sbrk+0x3e>
    800022b6:	ec26                	sd	s1,24(sp)
  
  addr = myproc()->sz;
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	d24080e7          	jalr	-732(ra) # 80000fdc <myproc>
    800022c0:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800022c2:	fdc42503          	lw	a0,-36(s0)
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	0f4080e7          	jalr	244(ra) # 800013ba <growproc>
    800022ce:	00054863          	bltz	a0,800022de <sys_sbrk+0x46>
    return -1;
  return addr;
    800022d2:	8526                	mv	a0,s1
    800022d4:	64e2                	ld	s1,24(sp)
}
    800022d6:	70a2                	ld	ra,40(sp)
    800022d8:	7402                	ld	s0,32(sp)
    800022da:	6145                	addi	sp,sp,48
    800022dc:	8082                	ret
    return -1;
    800022de:	557d                	li	a0,-1
    800022e0:	64e2                	ld	s1,24(sp)
    800022e2:	bfd5                	j	800022d6 <sys_sbrk+0x3e>

00000000800022e4 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022e4:	7139                	addi	sp,sp,-64
    800022e6:	fc06                	sd	ra,56(sp)
    800022e8:	f822                	sd	s0,48(sp)
    800022ea:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    800022ec:	fcc40593          	addi	a1,s0,-52
    800022f0:	4501                	li	a0,0
    800022f2:	00000097          	auipc	ra,0x0
    800022f6:	e2e080e7          	jalr	-466(ra) # 80002120 <argint>
    return -1;
    800022fa:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022fc:	06054b63          	bltz	a0,80002372 <sys_sleep+0x8e>
    80002300:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002302:	0000d517          	auipc	a0,0xd
    80002306:	d7e50513          	addi	a0,a0,-642 # 8000f080 <tickslock>
    8000230a:	00004097          	auipc	ra,0x4
    8000230e:	19c080e7          	jalr	412(ra) # 800064a6 <acquire>
  ticks0 = ticks;
    80002312:	00007917          	auipc	s2,0x7
    80002316:	d0692903          	lw	s2,-762(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    8000231a:	fcc42783          	lw	a5,-52(s0)
    8000231e:	c3a1                	beqz	a5,8000235e <sys_sleep+0x7a>
    80002320:	f426                	sd	s1,40(sp)
    80002322:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002324:	0000d997          	auipc	s3,0xd
    80002328:	d5c98993          	addi	s3,s3,-676 # 8000f080 <tickslock>
    8000232c:	00007497          	auipc	s1,0x7
    80002330:	cec48493          	addi	s1,s1,-788 # 80009018 <ticks>
    if(myproc()->killed){
    80002334:	fffff097          	auipc	ra,0xfffff
    80002338:	ca8080e7          	jalr	-856(ra) # 80000fdc <myproc>
    8000233c:	551c                	lw	a5,40(a0)
    8000233e:	ef9d                	bnez	a5,8000237c <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002340:	85ce                	mv	a1,s3
    80002342:	8526                	mv	a0,s1
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	3e2080e7          	jalr	994(ra) # 80001726 <sleep>
  while(ticks - ticks0 < n){
    8000234c:	409c                	lw	a5,0(s1)
    8000234e:	412787bb          	subw	a5,a5,s2
    80002352:	fcc42703          	lw	a4,-52(s0)
    80002356:	fce7efe3          	bltu	a5,a4,80002334 <sys_sleep+0x50>
    8000235a:	74a2                	ld	s1,40(sp)
    8000235c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000235e:	0000d517          	auipc	a0,0xd
    80002362:	d2250513          	addi	a0,a0,-734 # 8000f080 <tickslock>
    80002366:	00004097          	auipc	ra,0x4
    8000236a:	1f4080e7          	jalr	500(ra) # 8000655a <release>
  return 0;
    8000236e:	4781                	li	a5,0
    80002370:	7902                	ld	s2,32(sp)
}
    80002372:	853e                	mv	a0,a5
    80002374:	70e2                	ld	ra,56(sp)
    80002376:	7442                	ld	s0,48(sp)
    80002378:	6121                	addi	sp,sp,64
    8000237a:	8082                	ret
      release(&tickslock);
    8000237c:	0000d517          	auipc	a0,0xd
    80002380:	d0450513          	addi	a0,a0,-764 # 8000f080 <tickslock>
    80002384:	00004097          	auipc	ra,0x4
    80002388:	1d6080e7          	jalr	470(ra) # 8000655a <release>
      return -1;
    8000238c:	57fd                	li	a5,-1
    8000238e:	74a2                	ld	s1,40(sp)
    80002390:	7902                	ld	s2,32(sp)
    80002392:	69e2                	ld	s3,24(sp)
    80002394:	bff9                	j	80002372 <sys_sleep+0x8e>

0000000080002396 <sys_pgaccess>:


// #ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002396:	7139                	addi	sp,sp,-64
    80002398:	fc06                	sd	ra,56(sp)
    8000239a:	f822                	sd	s0,48(sp)
    8000239c:	0080                	addi	s0,sp,64
  // lab pgtbl: your code here.
  // parse first user page address
  uint64 addr;
  if(argaddr(0, &addr) < 0)
    8000239e:	fd840593          	addi	a1,s0,-40
    800023a2:	4501                	li	a0,0
    800023a4:	00000097          	auipc	ra,0x0
    800023a8:	d9e080e7          	jalr	-610(ra) # 80002142 <argaddr>
    800023ac:	0e054763          	bltz	a0,8000249a <sys_pgaccess+0x104>
    return -1;
  // parse number of pages
  int num_pages;
  if(argint(1, &num_pages) < 0)
    800023b0:	fd440593          	addi	a1,s0,-44
    800023b4:	4505                	li	a0,1
    800023b6:	00000097          	auipc	ra,0x0
    800023ba:	d6a080e7          	jalr	-662(ra) # 80002120 <argint>
    800023be:	0e054063          	bltz	a0,8000249e <sys_pgaccess+0x108>
    return -1;
  uint64 target_addr;
  if(argaddr(2, &target_addr) < 0)
    800023c2:	fc840593          	addi	a1,s0,-56
    800023c6:	4509                	li	a0,2
    800023c8:	00000097          	auipc	ra,0x0
    800023cc:	d7a080e7          	jalr	-646(ra) # 80002142 <argaddr>
    800023d0:	0c054963          	bltz	a0,800024a2 <sys_pgaccess+0x10c>
    return -1;
  // calculate the number of pages have been accessed.
  uint64 mask = 0;
    800023d4:	fc043023          	sd	zero,-64(s0)
  for(int i = 0; i < num_pages; i++) {
    800023d8:	fd442783          	lw	a5,-44(s0)
    800023dc:	08f05863          	blez	a5,8000246c <sys_pgaccess+0xd6>
    800023e0:	f426                	sd	s1,40(sp)
    800023e2:	f04a                	sd	s2,32(sp)
    800023e4:	4481                	li	s1,0
    uint64 *pte = walk(myproc()->pagetable, addr + i * PGSIZE, 0);
    if(*pte & PTE_A) {
      mask |= (1 << i);
    800023e6:	4905                	li	s2,1
    800023e8:	a801                	j	800023f8 <sys_pgaccess+0x62>
  for(int i = 0; i < num_pages; i++) {
    800023ea:	fd442783          	lw	a5,-44(s0)
    800023ee:	0485                	addi	s1,s1,1
    800023f0:	0004871b          	sext.w	a4,s1
    800023f4:	02f75d63          	bge	a4,a5,8000242e <sys_pgaccess+0x98>
    uint64 *pte = walk(myproc()->pagetable, addr + i * PGSIZE, 0);
    800023f8:	fffff097          	auipc	ra,0xfffff
    800023fc:	be4080e7          	jalr	-1052(ra) # 80000fdc <myproc>
    80002400:	00c49593          	slli	a1,s1,0xc
    80002404:	4601                	li	a2,0
    80002406:	fd843783          	ld	a5,-40(s0)
    8000240a:	95be                	add	a1,a1,a5
    8000240c:	6928                	ld	a0,80(a0)
    8000240e:	ffffe097          	auipc	ra,0xffffe
    80002412:	044080e7          	jalr	68(ra) # 80000452 <walk>
    if(*pte & PTE_A) {
    80002416:	611c                	ld	a5,0(a0)
    80002418:	0407f793          	andi	a5,a5,64
    8000241c:	d7f9                	beqz	a5,800023ea <sys_pgaccess+0x54>
      mask |= (1 << i);
    8000241e:	0099173b          	sllw	a4,s2,s1
    80002422:	fc043783          	ld	a5,-64(s0)
    80002426:	8fd9                	or	a5,a5,a4
    80002428:	fcf43023          	sd	a5,-64(s0)
    8000242c:	bf7d                	j	800023ea <sys_pgaccess+0x54>
    }
  }
  // clear the accessed bit
  for(int i = 0; i < num_pages; i++) {
    8000242e:	06f05363          	blez	a5,80002494 <sys_pgaccess+0xfe>
    80002432:	4481                	li	s1,0
    uint64 *pte = walk(myproc()->pagetable, addr + i * PGSIZE, 1);
    80002434:	fffff097          	auipc	ra,0xfffff
    80002438:	ba8080e7          	jalr	-1112(ra) # 80000fdc <myproc>
    8000243c:	00c49593          	slli	a1,s1,0xc
    80002440:	4605                	li	a2,1
    80002442:	fd843783          	ld	a5,-40(s0)
    80002446:	95be                	add	a1,a1,a5
    80002448:	6928                	ld	a0,80(a0)
    8000244a:	ffffe097          	auipc	ra,0xffffe
    8000244e:	008080e7          	jalr	8(ra) # 80000452 <walk>
    *pte &= ~PTE_A;
    80002452:	611c                	ld	a5,0(a0)
    80002454:	fbf7f793          	andi	a5,a5,-65
    80002458:	e11c                	sd	a5,0(a0)
  for(int i = 0; i < num_pages; i++) {
    8000245a:	0485                	addi	s1,s1,1
    8000245c:	fd442703          	lw	a4,-44(s0)
    80002460:	0004879b          	sext.w	a5,s1
    80002464:	fce7c8e3          	blt	a5,a4,80002434 <sys_pgaccess+0x9e>
    80002468:	74a2                	ld	s1,40(sp)
    8000246a:	7902                	ld	s2,32(sp)
  }
  
  if(copyout(myproc()->pagetable, target_addr, (char *)&mask, sizeof(mask)) < 0) {
    8000246c:	fffff097          	auipc	ra,0xfffff
    80002470:	b70080e7          	jalr	-1168(ra) # 80000fdc <myproc>
    80002474:	46a1                	li	a3,8
    80002476:	fc040613          	addi	a2,s0,-64
    8000247a:	fc843583          	ld	a1,-56(s0)
    8000247e:	6928                	ld	a0,80(a0)
    80002480:	ffffe097          	auipc	ra,0xffffe
    80002484:	698080e7          	jalr	1688(ra) # 80000b18 <copyout>
    80002488:	41f5551b          	sraiw	a0,a0,0x1f
    return -1;
  }
  return 0;
}
    8000248c:	70e2                	ld	ra,56(sp)
    8000248e:	7442                	ld	s0,48(sp)
    80002490:	6121                	addi	sp,sp,64
    80002492:	8082                	ret
    80002494:	74a2                	ld	s1,40(sp)
    80002496:	7902                	ld	s2,32(sp)
    80002498:	bfd1                	j	8000246c <sys_pgaccess+0xd6>
    return -1;
    8000249a:	557d                	li	a0,-1
    8000249c:	bfc5                	j	8000248c <sys_pgaccess+0xf6>
    return -1;
    8000249e:	557d                	li	a0,-1
    800024a0:	b7f5                	j	8000248c <sys_pgaccess+0xf6>
    return -1;
    800024a2:	557d                	li	a0,-1
    800024a4:	b7e5                	j	8000248c <sys_pgaccess+0xf6>

00000000800024a6 <sys_kill>:
// #endif

uint64
sys_kill(void)
{
    800024a6:	1101                	addi	sp,sp,-32
    800024a8:	ec06                	sd	ra,24(sp)
    800024aa:	e822                	sd	s0,16(sp)
    800024ac:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800024ae:	fec40593          	addi	a1,s0,-20
    800024b2:	4501                	li	a0,0
    800024b4:	00000097          	auipc	ra,0x0
    800024b8:	c6c080e7          	jalr	-916(ra) # 80002120 <argint>
    800024bc:	87aa                	mv	a5,a0
    return -1;
    800024be:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    800024c0:	0007c863          	bltz	a5,800024d0 <sys_kill+0x2a>
  return kill(pid);
    800024c4:	fec42503          	lw	a0,-20(s0)
    800024c8:	fffff097          	auipc	ra,0xfffff
    800024cc:	590080e7          	jalr	1424(ra) # 80001a58 <kill>
}
    800024d0:	60e2                	ld	ra,24(sp)
    800024d2:	6442                	ld	s0,16(sp)
    800024d4:	6105                	addi	sp,sp,32
    800024d6:	8082                	ret

00000000800024d8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024d8:	1101                	addi	sp,sp,-32
    800024da:	ec06                	sd	ra,24(sp)
    800024dc:	e822                	sd	s0,16(sp)
    800024de:	e426                	sd	s1,8(sp)
    800024e0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024e2:	0000d517          	auipc	a0,0xd
    800024e6:	b9e50513          	addi	a0,a0,-1122 # 8000f080 <tickslock>
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	fbc080e7          	jalr	-68(ra) # 800064a6 <acquire>
  xticks = ticks;
    800024f2:	00007497          	auipc	s1,0x7
    800024f6:	b264a483          	lw	s1,-1242(s1) # 80009018 <ticks>
  release(&tickslock);
    800024fa:	0000d517          	auipc	a0,0xd
    800024fe:	b8650513          	addi	a0,a0,-1146 # 8000f080 <tickslock>
    80002502:	00004097          	auipc	ra,0x4
    80002506:	058080e7          	jalr	88(ra) # 8000655a <release>
  return xticks;
}
    8000250a:	02049513          	slli	a0,s1,0x20
    8000250e:	9101                	srli	a0,a0,0x20
    80002510:	60e2                	ld	ra,24(sp)
    80002512:	6442                	ld	s0,16(sp)
    80002514:	64a2                	ld	s1,8(sp)
    80002516:	6105                	addi	sp,sp,32
    80002518:	8082                	ret

000000008000251a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000251a:	7179                	addi	sp,sp,-48
    8000251c:	f406                	sd	ra,40(sp)
    8000251e:	f022                	sd	s0,32(sp)
    80002520:	ec26                	sd	s1,24(sp)
    80002522:	e84a                	sd	s2,16(sp)
    80002524:	e44e                	sd	s3,8(sp)
    80002526:	e052                	sd	s4,0(sp)
    80002528:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000252a:	00006597          	auipc	a1,0x6
    8000252e:	e9e58593          	addi	a1,a1,-354 # 800083c8 <etext+0x3c8>
    80002532:	0000d517          	auipc	a0,0xd
    80002536:	b6650513          	addi	a0,a0,-1178 # 8000f098 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	edc080e7          	jalr	-292(ra) # 80006416 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002542:	00015797          	auipc	a5,0x15
    80002546:	b5678793          	addi	a5,a5,-1194 # 80017098 <bcache+0x8000>
    8000254a:	00015717          	auipc	a4,0x15
    8000254e:	db670713          	addi	a4,a4,-586 # 80017300 <bcache+0x8268>
    80002552:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002556:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000255a:	0000d497          	auipc	s1,0xd
    8000255e:	b5648493          	addi	s1,s1,-1194 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002562:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002564:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002566:	00006a17          	auipc	s4,0x6
    8000256a:	e6aa0a13          	addi	s4,s4,-406 # 800083d0 <etext+0x3d0>
    b->next = bcache.head.next;
    8000256e:	2b893783          	ld	a5,696(s2)
    80002572:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002574:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002578:	85d2                	mv	a1,s4
    8000257a:	01048513          	addi	a0,s1,16
    8000257e:	00001097          	auipc	ra,0x1
    80002582:	4b2080e7          	jalr	1202(ra) # 80003a30 <initsleeplock>
    bcache.head.next->prev = b;
    80002586:	2b893783          	ld	a5,696(s2)
    8000258a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000258c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002590:	45848493          	addi	s1,s1,1112
    80002594:	fd349de3          	bne	s1,s3,8000256e <binit+0x54>
  }
}
    80002598:	70a2                	ld	ra,40(sp)
    8000259a:	7402                	ld	s0,32(sp)
    8000259c:	64e2                	ld	s1,24(sp)
    8000259e:	6942                	ld	s2,16(sp)
    800025a0:	69a2                	ld	s3,8(sp)
    800025a2:	6a02                	ld	s4,0(sp)
    800025a4:	6145                	addi	sp,sp,48
    800025a6:	8082                	ret

00000000800025a8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025a8:	7179                	addi	sp,sp,-48
    800025aa:	f406                	sd	ra,40(sp)
    800025ac:	f022                	sd	s0,32(sp)
    800025ae:	ec26                	sd	s1,24(sp)
    800025b0:	e84a                	sd	s2,16(sp)
    800025b2:	e44e                	sd	s3,8(sp)
    800025b4:	1800                	addi	s0,sp,48
    800025b6:	892a                	mv	s2,a0
    800025b8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800025ba:	0000d517          	auipc	a0,0xd
    800025be:	ade50513          	addi	a0,a0,-1314 # 8000f098 <bcache>
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	ee4080e7          	jalr	-284(ra) # 800064a6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025ca:	00015497          	auipc	s1,0x15
    800025ce:	d864b483          	ld	s1,-634(s1) # 80017350 <bcache+0x82b8>
    800025d2:	00015797          	auipc	a5,0x15
    800025d6:	d2e78793          	addi	a5,a5,-722 # 80017300 <bcache+0x8268>
    800025da:	02f48f63          	beq	s1,a5,80002618 <bread+0x70>
    800025de:	873e                	mv	a4,a5
    800025e0:	a021                	j	800025e8 <bread+0x40>
    800025e2:	68a4                	ld	s1,80(s1)
    800025e4:	02e48a63          	beq	s1,a4,80002618 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025e8:	449c                	lw	a5,8(s1)
    800025ea:	ff279ce3          	bne	a5,s2,800025e2 <bread+0x3a>
    800025ee:	44dc                	lw	a5,12(s1)
    800025f0:	ff3799e3          	bne	a5,s3,800025e2 <bread+0x3a>
      b->refcnt++;
    800025f4:	40bc                	lw	a5,64(s1)
    800025f6:	2785                	addiw	a5,a5,1
    800025f8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025fa:	0000d517          	auipc	a0,0xd
    800025fe:	a9e50513          	addi	a0,a0,-1378 # 8000f098 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	f58080e7          	jalr	-168(ra) # 8000655a <release>
      acquiresleep(&b->lock);
    8000260a:	01048513          	addi	a0,s1,16
    8000260e:	00001097          	auipc	ra,0x1
    80002612:	45c080e7          	jalr	1116(ra) # 80003a6a <acquiresleep>
      return b;
    80002616:	a8b9                	j	80002674 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002618:	00015497          	auipc	s1,0x15
    8000261c:	d304b483          	ld	s1,-720(s1) # 80017348 <bcache+0x82b0>
    80002620:	00015797          	auipc	a5,0x15
    80002624:	ce078793          	addi	a5,a5,-800 # 80017300 <bcache+0x8268>
    80002628:	00f48863          	beq	s1,a5,80002638 <bread+0x90>
    8000262c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000262e:	40bc                	lw	a5,64(s1)
    80002630:	cf81                	beqz	a5,80002648 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002632:	64a4                	ld	s1,72(s1)
    80002634:	fee49de3          	bne	s1,a4,8000262e <bread+0x86>
  panic("bget: no buffers");
    80002638:	00006517          	auipc	a0,0x6
    8000263c:	da050513          	addi	a0,a0,-608 # 800083d8 <etext+0x3d8>
    80002640:	00004097          	auipc	ra,0x4
    80002644:	8ec080e7          	jalr	-1812(ra) # 80005f2c <panic>
      b->dev = dev;
    80002648:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000264c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002650:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002654:	4785                	li	a5,1
    80002656:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002658:	0000d517          	auipc	a0,0xd
    8000265c:	a4050513          	addi	a0,a0,-1472 # 8000f098 <bcache>
    80002660:	00004097          	auipc	ra,0x4
    80002664:	efa080e7          	jalr	-262(ra) # 8000655a <release>
      acquiresleep(&b->lock);
    80002668:	01048513          	addi	a0,s1,16
    8000266c:	00001097          	auipc	ra,0x1
    80002670:	3fe080e7          	jalr	1022(ra) # 80003a6a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002674:	409c                	lw	a5,0(s1)
    80002676:	cb89                	beqz	a5,80002688 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002678:	8526                	mv	a0,s1
    8000267a:	70a2                	ld	ra,40(sp)
    8000267c:	7402                	ld	s0,32(sp)
    8000267e:	64e2                	ld	s1,24(sp)
    80002680:	6942                	ld	s2,16(sp)
    80002682:	69a2                	ld	s3,8(sp)
    80002684:	6145                	addi	sp,sp,48
    80002686:	8082                	ret
    virtio_disk_rw(b, 0);
    80002688:	4581                	li	a1,0
    8000268a:	8526                	mv	a0,s1
    8000268c:	00003097          	auipc	ra,0x3
    80002690:	006080e7          	jalr	6(ra) # 80005692 <virtio_disk_rw>
    b->valid = 1;
    80002694:	4785                	li	a5,1
    80002696:	c09c                	sw	a5,0(s1)
  return b;
    80002698:	b7c5                	j	80002678 <bread+0xd0>

000000008000269a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000269a:	1101                	addi	sp,sp,-32
    8000269c:	ec06                	sd	ra,24(sp)
    8000269e:	e822                	sd	s0,16(sp)
    800026a0:	e426                	sd	s1,8(sp)
    800026a2:	1000                	addi	s0,sp,32
    800026a4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026a6:	0541                	addi	a0,a0,16
    800026a8:	00001097          	auipc	ra,0x1
    800026ac:	45c080e7          	jalr	1116(ra) # 80003b04 <holdingsleep>
    800026b0:	cd01                	beqz	a0,800026c8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026b2:	4585                	li	a1,1
    800026b4:	8526                	mv	a0,s1
    800026b6:	00003097          	auipc	ra,0x3
    800026ba:	fdc080e7          	jalr	-36(ra) # 80005692 <virtio_disk_rw>
}
    800026be:	60e2                	ld	ra,24(sp)
    800026c0:	6442                	ld	s0,16(sp)
    800026c2:	64a2                	ld	s1,8(sp)
    800026c4:	6105                	addi	sp,sp,32
    800026c6:	8082                	ret
    panic("bwrite");
    800026c8:	00006517          	auipc	a0,0x6
    800026cc:	d2850513          	addi	a0,a0,-728 # 800083f0 <etext+0x3f0>
    800026d0:	00004097          	auipc	ra,0x4
    800026d4:	85c080e7          	jalr	-1956(ra) # 80005f2c <panic>

00000000800026d8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	e04a                	sd	s2,0(sp)
    800026e2:	1000                	addi	s0,sp,32
    800026e4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026e6:	01050913          	addi	s2,a0,16
    800026ea:	854a                	mv	a0,s2
    800026ec:	00001097          	auipc	ra,0x1
    800026f0:	418080e7          	jalr	1048(ra) # 80003b04 <holdingsleep>
    800026f4:	c925                	beqz	a0,80002764 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800026f6:	854a                	mv	a0,s2
    800026f8:	00001097          	auipc	ra,0x1
    800026fc:	3c8080e7          	jalr	968(ra) # 80003ac0 <releasesleep>

  acquire(&bcache.lock);
    80002700:	0000d517          	auipc	a0,0xd
    80002704:	99850513          	addi	a0,a0,-1640 # 8000f098 <bcache>
    80002708:	00004097          	auipc	ra,0x4
    8000270c:	d9e080e7          	jalr	-610(ra) # 800064a6 <acquire>
  b->refcnt--;
    80002710:	40bc                	lw	a5,64(s1)
    80002712:	37fd                	addiw	a5,a5,-1
    80002714:	0007871b          	sext.w	a4,a5
    80002718:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000271a:	e71d                	bnez	a4,80002748 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000271c:	68b8                	ld	a4,80(s1)
    8000271e:	64bc                	ld	a5,72(s1)
    80002720:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002722:	68b8                	ld	a4,80(s1)
    80002724:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002726:	00015797          	auipc	a5,0x15
    8000272a:	97278793          	addi	a5,a5,-1678 # 80017098 <bcache+0x8000>
    8000272e:	2b87b703          	ld	a4,696(a5)
    80002732:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002734:	00015717          	auipc	a4,0x15
    80002738:	bcc70713          	addi	a4,a4,-1076 # 80017300 <bcache+0x8268>
    8000273c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000273e:	2b87b703          	ld	a4,696(a5)
    80002742:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002744:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002748:	0000d517          	auipc	a0,0xd
    8000274c:	95050513          	addi	a0,a0,-1712 # 8000f098 <bcache>
    80002750:	00004097          	auipc	ra,0x4
    80002754:	e0a080e7          	jalr	-502(ra) # 8000655a <release>
}
    80002758:	60e2                	ld	ra,24(sp)
    8000275a:	6442                	ld	s0,16(sp)
    8000275c:	64a2                	ld	s1,8(sp)
    8000275e:	6902                	ld	s2,0(sp)
    80002760:	6105                	addi	sp,sp,32
    80002762:	8082                	ret
    panic("brelse");
    80002764:	00006517          	auipc	a0,0x6
    80002768:	c9450513          	addi	a0,a0,-876 # 800083f8 <etext+0x3f8>
    8000276c:	00003097          	auipc	ra,0x3
    80002770:	7c0080e7          	jalr	1984(ra) # 80005f2c <panic>

0000000080002774 <bpin>:

void
bpin(struct buf *b) {
    80002774:	1101                	addi	sp,sp,-32
    80002776:	ec06                	sd	ra,24(sp)
    80002778:	e822                	sd	s0,16(sp)
    8000277a:	e426                	sd	s1,8(sp)
    8000277c:	1000                	addi	s0,sp,32
    8000277e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002780:	0000d517          	auipc	a0,0xd
    80002784:	91850513          	addi	a0,a0,-1768 # 8000f098 <bcache>
    80002788:	00004097          	auipc	ra,0x4
    8000278c:	d1e080e7          	jalr	-738(ra) # 800064a6 <acquire>
  b->refcnt++;
    80002790:	40bc                	lw	a5,64(s1)
    80002792:	2785                	addiw	a5,a5,1
    80002794:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002796:	0000d517          	auipc	a0,0xd
    8000279a:	90250513          	addi	a0,a0,-1790 # 8000f098 <bcache>
    8000279e:	00004097          	auipc	ra,0x4
    800027a2:	dbc080e7          	jalr	-580(ra) # 8000655a <release>
}
    800027a6:	60e2                	ld	ra,24(sp)
    800027a8:	6442                	ld	s0,16(sp)
    800027aa:	64a2                	ld	s1,8(sp)
    800027ac:	6105                	addi	sp,sp,32
    800027ae:	8082                	ret

00000000800027b0 <bunpin>:

void
bunpin(struct buf *b) {
    800027b0:	1101                	addi	sp,sp,-32
    800027b2:	ec06                	sd	ra,24(sp)
    800027b4:	e822                	sd	s0,16(sp)
    800027b6:	e426                	sd	s1,8(sp)
    800027b8:	1000                	addi	s0,sp,32
    800027ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027bc:	0000d517          	auipc	a0,0xd
    800027c0:	8dc50513          	addi	a0,a0,-1828 # 8000f098 <bcache>
    800027c4:	00004097          	auipc	ra,0x4
    800027c8:	ce2080e7          	jalr	-798(ra) # 800064a6 <acquire>
  b->refcnt--;
    800027cc:	40bc                	lw	a5,64(s1)
    800027ce:	37fd                	addiw	a5,a5,-1
    800027d0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027d2:	0000d517          	auipc	a0,0xd
    800027d6:	8c650513          	addi	a0,a0,-1850 # 8000f098 <bcache>
    800027da:	00004097          	auipc	ra,0x4
    800027de:	d80080e7          	jalr	-640(ra) # 8000655a <release>
}
    800027e2:	60e2                	ld	ra,24(sp)
    800027e4:	6442                	ld	s0,16(sp)
    800027e6:	64a2                	ld	s1,8(sp)
    800027e8:	6105                	addi	sp,sp,32
    800027ea:	8082                	ret

00000000800027ec <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027ec:	1101                	addi	sp,sp,-32
    800027ee:	ec06                	sd	ra,24(sp)
    800027f0:	e822                	sd	s0,16(sp)
    800027f2:	e426                	sd	s1,8(sp)
    800027f4:	e04a                	sd	s2,0(sp)
    800027f6:	1000                	addi	s0,sp,32
    800027f8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027fa:	00d5d59b          	srliw	a1,a1,0xd
    800027fe:	00015797          	auipc	a5,0x15
    80002802:	f767a783          	lw	a5,-138(a5) # 80017774 <sb+0x1c>
    80002806:	9dbd                	addw	a1,a1,a5
    80002808:	00000097          	auipc	ra,0x0
    8000280c:	da0080e7          	jalr	-608(ra) # 800025a8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002810:	0074f713          	andi	a4,s1,7
    80002814:	4785                	li	a5,1
    80002816:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000281a:	14ce                	slli	s1,s1,0x33
    8000281c:	90d9                	srli	s1,s1,0x36
    8000281e:	00950733          	add	a4,a0,s1
    80002822:	05874703          	lbu	a4,88(a4)
    80002826:	00e7f6b3          	and	a3,a5,a4
    8000282a:	c69d                	beqz	a3,80002858 <bfree+0x6c>
    8000282c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000282e:	94aa                	add	s1,s1,a0
    80002830:	fff7c793          	not	a5,a5
    80002834:	8f7d                	and	a4,a4,a5
    80002836:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000283a:	00001097          	auipc	ra,0x1
    8000283e:	112080e7          	jalr	274(ra) # 8000394c <log_write>
  brelse(bp);
    80002842:	854a                	mv	a0,s2
    80002844:	00000097          	auipc	ra,0x0
    80002848:	e94080e7          	jalr	-364(ra) # 800026d8 <brelse>
}
    8000284c:	60e2                	ld	ra,24(sp)
    8000284e:	6442                	ld	s0,16(sp)
    80002850:	64a2                	ld	s1,8(sp)
    80002852:	6902                	ld	s2,0(sp)
    80002854:	6105                	addi	sp,sp,32
    80002856:	8082                	ret
    panic("freeing free block");
    80002858:	00006517          	auipc	a0,0x6
    8000285c:	ba850513          	addi	a0,a0,-1112 # 80008400 <etext+0x400>
    80002860:	00003097          	auipc	ra,0x3
    80002864:	6cc080e7          	jalr	1740(ra) # 80005f2c <panic>

0000000080002868 <balloc>:
{
    80002868:	711d                	addi	sp,sp,-96
    8000286a:	ec86                	sd	ra,88(sp)
    8000286c:	e8a2                	sd	s0,80(sp)
    8000286e:	e4a6                	sd	s1,72(sp)
    80002870:	e0ca                	sd	s2,64(sp)
    80002872:	fc4e                	sd	s3,56(sp)
    80002874:	f852                	sd	s4,48(sp)
    80002876:	f456                	sd	s5,40(sp)
    80002878:	f05a                	sd	s6,32(sp)
    8000287a:	ec5e                	sd	s7,24(sp)
    8000287c:	e862                	sd	s8,16(sp)
    8000287e:	e466                	sd	s9,8(sp)
    80002880:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002882:	00015797          	auipc	a5,0x15
    80002886:	eda7a783          	lw	a5,-294(a5) # 8001775c <sb+0x4>
    8000288a:	cbc1                	beqz	a5,8000291a <balloc+0xb2>
    8000288c:	8baa                	mv	s7,a0
    8000288e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002890:	00015b17          	auipc	s6,0x15
    80002894:	ec8b0b13          	addi	s6,s6,-312 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002898:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000289a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000289c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000289e:	6c89                	lui	s9,0x2
    800028a0:	a831                	j	800028bc <balloc+0x54>
    brelse(bp);
    800028a2:	854a                	mv	a0,s2
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	e34080e7          	jalr	-460(ra) # 800026d8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028ac:	015c87bb          	addw	a5,s9,s5
    800028b0:	00078a9b          	sext.w	s5,a5
    800028b4:	004b2703          	lw	a4,4(s6)
    800028b8:	06eaf163          	bgeu	s5,a4,8000291a <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    800028bc:	41fad79b          	sraiw	a5,s5,0x1f
    800028c0:	0137d79b          	srliw	a5,a5,0x13
    800028c4:	015787bb          	addw	a5,a5,s5
    800028c8:	40d7d79b          	sraiw	a5,a5,0xd
    800028cc:	01cb2583          	lw	a1,28(s6)
    800028d0:	9dbd                	addw	a1,a1,a5
    800028d2:	855e                	mv	a0,s7
    800028d4:	00000097          	auipc	ra,0x0
    800028d8:	cd4080e7          	jalr	-812(ra) # 800025a8 <bread>
    800028dc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028de:	004b2503          	lw	a0,4(s6)
    800028e2:	000a849b          	sext.w	s1,s5
    800028e6:	8762                	mv	a4,s8
    800028e8:	faa4fde3          	bgeu	s1,a0,800028a2 <balloc+0x3a>
      m = 1 << (bi % 8);
    800028ec:	00777693          	andi	a3,a4,7
    800028f0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028f4:	41f7579b          	sraiw	a5,a4,0x1f
    800028f8:	01d7d79b          	srliw	a5,a5,0x1d
    800028fc:	9fb9                	addw	a5,a5,a4
    800028fe:	4037d79b          	sraiw	a5,a5,0x3
    80002902:	00f90633          	add	a2,s2,a5
    80002906:	05864603          	lbu	a2,88(a2)
    8000290a:	00c6f5b3          	and	a1,a3,a2
    8000290e:	cd91                	beqz	a1,8000292a <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002910:	2705                	addiw	a4,a4,1
    80002912:	2485                	addiw	s1,s1,1
    80002914:	fd471ae3          	bne	a4,s4,800028e8 <balloc+0x80>
    80002918:	b769                	j	800028a2 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000291a:	00006517          	auipc	a0,0x6
    8000291e:	afe50513          	addi	a0,a0,-1282 # 80008418 <etext+0x418>
    80002922:	00003097          	auipc	ra,0x3
    80002926:	60a080e7          	jalr	1546(ra) # 80005f2c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000292a:	97ca                	add	a5,a5,s2
    8000292c:	8e55                	or	a2,a2,a3
    8000292e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002932:	854a                	mv	a0,s2
    80002934:	00001097          	auipc	ra,0x1
    80002938:	018080e7          	jalr	24(ra) # 8000394c <log_write>
        brelse(bp);
    8000293c:	854a                	mv	a0,s2
    8000293e:	00000097          	auipc	ra,0x0
    80002942:	d9a080e7          	jalr	-614(ra) # 800026d8 <brelse>
  bp = bread(dev, bno);
    80002946:	85a6                	mv	a1,s1
    80002948:	855e                	mv	a0,s7
    8000294a:	00000097          	auipc	ra,0x0
    8000294e:	c5e080e7          	jalr	-930(ra) # 800025a8 <bread>
    80002952:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002954:	40000613          	li	a2,1024
    80002958:	4581                	li	a1,0
    8000295a:	05850513          	addi	a0,a0,88
    8000295e:	ffffe097          	auipc	ra,0xffffe
    80002962:	81c080e7          	jalr	-2020(ra) # 8000017a <memset>
  log_write(bp);
    80002966:	854a                	mv	a0,s2
    80002968:	00001097          	auipc	ra,0x1
    8000296c:	fe4080e7          	jalr	-28(ra) # 8000394c <log_write>
  brelse(bp);
    80002970:	854a                	mv	a0,s2
    80002972:	00000097          	auipc	ra,0x0
    80002976:	d66080e7          	jalr	-666(ra) # 800026d8 <brelse>
}
    8000297a:	8526                	mv	a0,s1
    8000297c:	60e6                	ld	ra,88(sp)
    8000297e:	6446                	ld	s0,80(sp)
    80002980:	64a6                	ld	s1,72(sp)
    80002982:	6906                	ld	s2,64(sp)
    80002984:	79e2                	ld	s3,56(sp)
    80002986:	7a42                	ld	s4,48(sp)
    80002988:	7aa2                	ld	s5,40(sp)
    8000298a:	7b02                	ld	s6,32(sp)
    8000298c:	6be2                	ld	s7,24(sp)
    8000298e:	6c42                	ld	s8,16(sp)
    80002990:	6ca2                	ld	s9,8(sp)
    80002992:	6125                	addi	sp,sp,96
    80002994:	8082                	ret

0000000080002996 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002996:	7179                	addi	sp,sp,-48
    80002998:	f406                	sd	ra,40(sp)
    8000299a:	f022                	sd	s0,32(sp)
    8000299c:	ec26                	sd	s1,24(sp)
    8000299e:	e84a                	sd	s2,16(sp)
    800029a0:	e44e                	sd	s3,8(sp)
    800029a2:	1800                	addi	s0,sp,48
    800029a4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029a6:	47ad                	li	a5,11
    800029a8:	04b7ff63          	bgeu	a5,a1,80002a06 <bmap+0x70>
    800029ac:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800029ae:	ff45849b          	addiw	s1,a1,-12
    800029b2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800029b6:	0ff00793          	li	a5,255
    800029ba:	0ae7e463          	bltu	a5,a4,80002a62 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800029be:	08052583          	lw	a1,128(a0)
    800029c2:	c5b5                	beqz	a1,80002a2e <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800029c4:	00092503          	lw	a0,0(s2)
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	be0080e7          	jalr	-1056(ra) # 800025a8 <bread>
    800029d0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029d2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029d6:	02049713          	slli	a4,s1,0x20
    800029da:	01e75593          	srli	a1,a4,0x1e
    800029de:	00b784b3          	add	s1,a5,a1
    800029e2:	0004a983          	lw	s3,0(s1)
    800029e6:	04098e63          	beqz	s3,80002a42 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029ea:	8552                	mv	a0,s4
    800029ec:	00000097          	auipc	ra,0x0
    800029f0:	cec080e7          	jalr	-788(ra) # 800026d8 <brelse>
    return addr;
    800029f4:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800029f6:	854e                	mv	a0,s3
    800029f8:	70a2                	ld	ra,40(sp)
    800029fa:	7402                	ld	s0,32(sp)
    800029fc:	64e2                	ld	s1,24(sp)
    800029fe:	6942                	ld	s2,16(sp)
    80002a00:	69a2                	ld	s3,8(sp)
    80002a02:	6145                	addi	sp,sp,48
    80002a04:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002a06:	02059793          	slli	a5,a1,0x20
    80002a0a:	01e7d593          	srli	a1,a5,0x1e
    80002a0e:	00b504b3          	add	s1,a0,a1
    80002a12:	0504a983          	lw	s3,80(s1)
    80002a16:	fe0990e3          	bnez	s3,800029f6 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002a1a:	4108                	lw	a0,0(a0)
    80002a1c:	00000097          	auipc	ra,0x0
    80002a20:	e4c080e7          	jalr	-436(ra) # 80002868 <balloc>
    80002a24:	0005099b          	sext.w	s3,a0
    80002a28:	0534a823          	sw	s3,80(s1)
    80002a2c:	b7e9                	j	800029f6 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002a2e:	4108                	lw	a0,0(a0)
    80002a30:	00000097          	auipc	ra,0x0
    80002a34:	e38080e7          	jalr	-456(ra) # 80002868 <balloc>
    80002a38:	0005059b          	sext.w	a1,a0
    80002a3c:	08b92023          	sw	a1,128(s2)
    80002a40:	b751                	j	800029c4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a42:	00092503          	lw	a0,0(s2)
    80002a46:	00000097          	auipc	ra,0x0
    80002a4a:	e22080e7          	jalr	-478(ra) # 80002868 <balloc>
    80002a4e:	0005099b          	sext.w	s3,a0
    80002a52:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a56:	8552                	mv	a0,s4
    80002a58:	00001097          	auipc	ra,0x1
    80002a5c:	ef4080e7          	jalr	-268(ra) # 8000394c <log_write>
    80002a60:	b769                	j	800029ea <bmap+0x54>
  panic("bmap: out of range");
    80002a62:	00006517          	auipc	a0,0x6
    80002a66:	9ce50513          	addi	a0,a0,-1586 # 80008430 <etext+0x430>
    80002a6a:	00003097          	auipc	ra,0x3
    80002a6e:	4c2080e7          	jalr	1218(ra) # 80005f2c <panic>

0000000080002a72 <iget>:
{
    80002a72:	7179                	addi	sp,sp,-48
    80002a74:	f406                	sd	ra,40(sp)
    80002a76:	f022                	sd	s0,32(sp)
    80002a78:	ec26                	sd	s1,24(sp)
    80002a7a:	e84a                	sd	s2,16(sp)
    80002a7c:	e44e                	sd	s3,8(sp)
    80002a7e:	e052                	sd	s4,0(sp)
    80002a80:	1800                	addi	s0,sp,48
    80002a82:	89aa                	mv	s3,a0
    80002a84:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a86:	00015517          	auipc	a0,0x15
    80002a8a:	cf250513          	addi	a0,a0,-782 # 80017778 <itable>
    80002a8e:	00004097          	auipc	ra,0x4
    80002a92:	a18080e7          	jalr	-1512(ra) # 800064a6 <acquire>
  empty = 0;
    80002a96:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a98:	00015497          	auipc	s1,0x15
    80002a9c:	cf848493          	addi	s1,s1,-776 # 80017790 <itable+0x18>
    80002aa0:	00016697          	auipc	a3,0x16
    80002aa4:	78068693          	addi	a3,a3,1920 # 80019220 <log>
    80002aa8:	a039                	j	80002ab6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aaa:	02090b63          	beqz	s2,80002ae0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002aae:	08848493          	addi	s1,s1,136
    80002ab2:	02d48a63          	beq	s1,a3,80002ae6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002ab6:	449c                	lw	a5,8(s1)
    80002ab8:	fef059e3          	blez	a5,80002aaa <iget+0x38>
    80002abc:	4098                	lw	a4,0(s1)
    80002abe:	ff3716e3          	bne	a4,s3,80002aaa <iget+0x38>
    80002ac2:	40d8                	lw	a4,4(s1)
    80002ac4:	ff4713e3          	bne	a4,s4,80002aaa <iget+0x38>
      ip->ref++;
    80002ac8:	2785                	addiw	a5,a5,1
    80002aca:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002acc:	00015517          	auipc	a0,0x15
    80002ad0:	cac50513          	addi	a0,a0,-852 # 80017778 <itable>
    80002ad4:	00004097          	auipc	ra,0x4
    80002ad8:	a86080e7          	jalr	-1402(ra) # 8000655a <release>
      return ip;
    80002adc:	8926                	mv	s2,s1
    80002ade:	a03d                	j	80002b0c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002ae0:	f7f9                	bnez	a5,80002aae <iget+0x3c>
      empty = ip;
    80002ae2:	8926                	mv	s2,s1
    80002ae4:	b7e9                	j	80002aae <iget+0x3c>
  if(empty == 0)
    80002ae6:	02090c63          	beqz	s2,80002b1e <iget+0xac>
  ip->dev = dev;
    80002aea:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002aee:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002af2:	4785                	li	a5,1
    80002af4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002af8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002afc:	00015517          	auipc	a0,0x15
    80002b00:	c7c50513          	addi	a0,a0,-900 # 80017778 <itable>
    80002b04:	00004097          	auipc	ra,0x4
    80002b08:	a56080e7          	jalr	-1450(ra) # 8000655a <release>
}
    80002b0c:	854a                	mv	a0,s2
    80002b0e:	70a2                	ld	ra,40(sp)
    80002b10:	7402                	ld	s0,32(sp)
    80002b12:	64e2                	ld	s1,24(sp)
    80002b14:	6942                	ld	s2,16(sp)
    80002b16:	69a2                	ld	s3,8(sp)
    80002b18:	6a02                	ld	s4,0(sp)
    80002b1a:	6145                	addi	sp,sp,48
    80002b1c:	8082                	ret
    panic("iget: no inodes");
    80002b1e:	00006517          	auipc	a0,0x6
    80002b22:	92a50513          	addi	a0,a0,-1750 # 80008448 <etext+0x448>
    80002b26:	00003097          	auipc	ra,0x3
    80002b2a:	406080e7          	jalr	1030(ra) # 80005f2c <panic>

0000000080002b2e <fsinit>:
fsinit(int dev) {
    80002b2e:	7179                	addi	sp,sp,-48
    80002b30:	f406                	sd	ra,40(sp)
    80002b32:	f022                	sd	s0,32(sp)
    80002b34:	ec26                	sd	s1,24(sp)
    80002b36:	e84a                	sd	s2,16(sp)
    80002b38:	e44e                	sd	s3,8(sp)
    80002b3a:	1800                	addi	s0,sp,48
    80002b3c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b3e:	4585                	li	a1,1
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	a68080e7          	jalr	-1432(ra) # 800025a8 <bread>
    80002b48:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b4a:	00015997          	auipc	s3,0x15
    80002b4e:	c0e98993          	addi	s3,s3,-1010 # 80017758 <sb>
    80002b52:	02000613          	li	a2,32
    80002b56:	05850593          	addi	a1,a0,88
    80002b5a:	854e                	mv	a0,s3
    80002b5c:	ffffd097          	auipc	ra,0xffffd
    80002b60:	67a080e7          	jalr	1658(ra) # 800001d6 <memmove>
  brelse(bp);
    80002b64:	8526                	mv	a0,s1
    80002b66:	00000097          	auipc	ra,0x0
    80002b6a:	b72080e7          	jalr	-1166(ra) # 800026d8 <brelse>
  if(sb.magic != FSMAGIC)
    80002b6e:	0009a703          	lw	a4,0(s3)
    80002b72:	102037b7          	lui	a5,0x10203
    80002b76:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b7a:	02f71263          	bne	a4,a5,80002b9e <fsinit+0x70>
  initlog(dev, &sb);
    80002b7e:	00015597          	auipc	a1,0x15
    80002b82:	bda58593          	addi	a1,a1,-1062 # 80017758 <sb>
    80002b86:	854a                	mv	a0,s2
    80002b88:	00001097          	auipc	ra,0x1
    80002b8c:	b54080e7          	jalr	-1196(ra) # 800036dc <initlog>
}
    80002b90:	70a2                	ld	ra,40(sp)
    80002b92:	7402                	ld	s0,32(sp)
    80002b94:	64e2                	ld	s1,24(sp)
    80002b96:	6942                	ld	s2,16(sp)
    80002b98:	69a2                	ld	s3,8(sp)
    80002b9a:	6145                	addi	sp,sp,48
    80002b9c:	8082                	ret
    panic("invalid file system");
    80002b9e:	00006517          	auipc	a0,0x6
    80002ba2:	8ba50513          	addi	a0,a0,-1862 # 80008458 <etext+0x458>
    80002ba6:	00003097          	auipc	ra,0x3
    80002baa:	386080e7          	jalr	902(ra) # 80005f2c <panic>

0000000080002bae <iinit>:
{
    80002bae:	7179                	addi	sp,sp,-48
    80002bb0:	f406                	sd	ra,40(sp)
    80002bb2:	f022                	sd	s0,32(sp)
    80002bb4:	ec26                	sd	s1,24(sp)
    80002bb6:	e84a                	sd	s2,16(sp)
    80002bb8:	e44e                	sd	s3,8(sp)
    80002bba:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002bbc:	00006597          	auipc	a1,0x6
    80002bc0:	8b458593          	addi	a1,a1,-1868 # 80008470 <etext+0x470>
    80002bc4:	00015517          	auipc	a0,0x15
    80002bc8:	bb450513          	addi	a0,a0,-1100 # 80017778 <itable>
    80002bcc:	00004097          	auipc	ra,0x4
    80002bd0:	84a080e7          	jalr	-1974(ra) # 80006416 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002bd4:	00015497          	auipc	s1,0x15
    80002bd8:	bcc48493          	addi	s1,s1,-1076 # 800177a0 <itable+0x28>
    80002bdc:	00016997          	auipc	s3,0x16
    80002be0:	65498993          	addi	s3,s3,1620 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002be4:	00006917          	auipc	s2,0x6
    80002be8:	89490913          	addi	s2,s2,-1900 # 80008478 <etext+0x478>
    80002bec:	85ca                	mv	a1,s2
    80002bee:	8526                	mv	a0,s1
    80002bf0:	00001097          	auipc	ra,0x1
    80002bf4:	e40080e7          	jalr	-448(ra) # 80003a30 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bf8:	08848493          	addi	s1,s1,136
    80002bfc:	ff3498e3          	bne	s1,s3,80002bec <iinit+0x3e>
}
    80002c00:	70a2                	ld	ra,40(sp)
    80002c02:	7402                	ld	s0,32(sp)
    80002c04:	64e2                	ld	s1,24(sp)
    80002c06:	6942                	ld	s2,16(sp)
    80002c08:	69a2                	ld	s3,8(sp)
    80002c0a:	6145                	addi	sp,sp,48
    80002c0c:	8082                	ret

0000000080002c0e <ialloc>:
{
    80002c0e:	7139                	addi	sp,sp,-64
    80002c10:	fc06                	sd	ra,56(sp)
    80002c12:	f822                	sd	s0,48(sp)
    80002c14:	f426                	sd	s1,40(sp)
    80002c16:	f04a                	sd	s2,32(sp)
    80002c18:	ec4e                	sd	s3,24(sp)
    80002c1a:	e852                	sd	s4,16(sp)
    80002c1c:	e456                	sd	s5,8(sp)
    80002c1e:	e05a                	sd	s6,0(sp)
    80002c20:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c22:	00015717          	auipc	a4,0x15
    80002c26:	b4272703          	lw	a4,-1214(a4) # 80017764 <sb+0xc>
    80002c2a:	4785                	li	a5,1
    80002c2c:	04e7f863          	bgeu	a5,a4,80002c7c <ialloc+0x6e>
    80002c30:	8aaa                	mv	s5,a0
    80002c32:	8b2e                	mv	s6,a1
    80002c34:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002c36:	00015a17          	auipc	s4,0x15
    80002c3a:	b22a0a13          	addi	s4,s4,-1246 # 80017758 <sb>
    80002c3e:	00495593          	srli	a1,s2,0x4
    80002c42:	018a2783          	lw	a5,24(s4)
    80002c46:	9dbd                	addw	a1,a1,a5
    80002c48:	8556                	mv	a0,s5
    80002c4a:	00000097          	auipc	ra,0x0
    80002c4e:	95e080e7          	jalr	-1698(ra) # 800025a8 <bread>
    80002c52:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c54:	05850993          	addi	s3,a0,88
    80002c58:	00f97793          	andi	a5,s2,15
    80002c5c:	079a                	slli	a5,a5,0x6
    80002c5e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c60:	00099783          	lh	a5,0(s3)
    80002c64:	c785                	beqz	a5,80002c8c <ialloc+0x7e>
    brelse(bp);
    80002c66:	00000097          	auipc	ra,0x0
    80002c6a:	a72080e7          	jalr	-1422(ra) # 800026d8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c6e:	0905                	addi	s2,s2,1
    80002c70:	00ca2703          	lw	a4,12(s4)
    80002c74:	0009079b          	sext.w	a5,s2
    80002c78:	fce7e3e3          	bltu	a5,a4,80002c3e <ialloc+0x30>
  panic("ialloc: no inodes");
    80002c7c:	00006517          	auipc	a0,0x6
    80002c80:	80450513          	addi	a0,a0,-2044 # 80008480 <etext+0x480>
    80002c84:	00003097          	auipc	ra,0x3
    80002c88:	2a8080e7          	jalr	680(ra) # 80005f2c <panic>
      memset(dip, 0, sizeof(*dip));
    80002c8c:	04000613          	li	a2,64
    80002c90:	4581                	li	a1,0
    80002c92:	854e                	mv	a0,s3
    80002c94:	ffffd097          	auipc	ra,0xffffd
    80002c98:	4e6080e7          	jalr	1254(ra) # 8000017a <memset>
      dip->type = type;
    80002c9c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ca0:	8526                	mv	a0,s1
    80002ca2:	00001097          	auipc	ra,0x1
    80002ca6:	caa080e7          	jalr	-854(ra) # 8000394c <log_write>
      brelse(bp);
    80002caa:	8526                	mv	a0,s1
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	a2c080e7          	jalr	-1492(ra) # 800026d8 <brelse>
      return iget(dev, inum);
    80002cb4:	0009059b          	sext.w	a1,s2
    80002cb8:	8556                	mv	a0,s5
    80002cba:	00000097          	auipc	ra,0x0
    80002cbe:	db8080e7          	jalr	-584(ra) # 80002a72 <iget>
}
    80002cc2:	70e2                	ld	ra,56(sp)
    80002cc4:	7442                	ld	s0,48(sp)
    80002cc6:	74a2                	ld	s1,40(sp)
    80002cc8:	7902                	ld	s2,32(sp)
    80002cca:	69e2                	ld	s3,24(sp)
    80002ccc:	6a42                	ld	s4,16(sp)
    80002cce:	6aa2                	ld	s5,8(sp)
    80002cd0:	6b02                	ld	s6,0(sp)
    80002cd2:	6121                	addi	sp,sp,64
    80002cd4:	8082                	ret

0000000080002cd6 <iupdate>:
{
    80002cd6:	1101                	addi	sp,sp,-32
    80002cd8:	ec06                	sd	ra,24(sp)
    80002cda:	e822                	sd	s0,16(sp)
    80002cdc:	e426                	sd	s1,8(sp)
    80002cde:	e04a                	sd	s2,0(sp)
    80002ce0:	1000                	addi	s0,sp,32
    80002ce2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002ce4:	415c                	lw	a5,4(a0)
    80002ce6:	0047d79b          	srliw	a5,a5,0x4
    80002cea:	00015597          	auipc	a1,0x15
    80002cee:	a865a583          	lw	a1,-1402(a1) # 80017770 <sb+0x18>
    80002cf2:	9dbd                	addw	a1,a1,a5
    80002cf4:	4108                	lw	a0,0(a0)
    80002cf6:	00000097          	auipc	ra,0x0
    80002cfa:	8b2080e7          	jalr	-1870(ra) # 800025a8 <bread>
    80002cfe:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d00:	05850793          	addi	a5,a0,88
    80002d04:	40d8                	lw	a4,4(s1)
    80002d06:	8b3d                	andi	a4,a4,15
    80002d08:	071a                	slli	a4,a4,0x6
    80002d0a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002d0c:	04449703          	lh	a4,68(s1)
    80002d10:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002d14:	04649703          	lh	a4,70(s1)
    80002d18:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002d1c:	04849703          	lh	a4,72(s1)
    80002d20:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002d24:	04a49703          	lh	a4,74(s1)
    80002d28:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002d2c:	44f8                	lw	a4,76(s1)
    80002d2e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002d30:	03400613          	li	a2,52
    80002d34:	05048593          	addi	a1,s1,80
    80002d38:	00c78513          	addi	a0,a5,12
    80002d3c:	ffffd097          	auipc	ra,0xffffd
    80002d40:	49a080e7          	jalr	1178(ra) # 800001d6 <memmove>
  log_write(bp);
    80002d44:	854a                	mv	a0,s2
    80002d46:	00001097          	auipc	ra,0x1
    80002d4a:	c06080e7          	jalr	-1018(ra) # 8000394c <log_write>
  brelse(bp);
    80002d4e:	854a                	mv	a0,s2
    80002d50:	00000097          	auipc	ra,0x0
    80002d54:	988080e7          	jalr	-1656(ra) # 800026d8 <brelse>
}
    80002d58:	60e2                	ld	ra,24(sp)
    80002d5a:	6442                	ld	s0,16(sp)
    80002d5c:	64a2                	ld	s1,8(sp)
    80002d5e:	6902                	ld	s2,0(sp)
    80002d60:	6105                	addi	sp,sp,32
    80002d62:	8082                	ret

0000000080002d64 <idup>:
{
    80002d64:	1101                	addi	sp,sp,-32
    80002d66:	ec06                	sd	ra,24(sp)
    80002d68:	e822                	sd	s0,16(sp)
    80002d6a:	e426                	sd	s1,8(sp)
    80002d6c:	1000                	addi	s0,sp,32
    80002d6e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d70:	00015517          	auipc	a0,0x15
    80002d74:	a0850513          	addi	a0,a0,-1528 # 80017778 <itable>
    80002d78:	00003097          	auipc	ra,0x3
    80002d7c:	72e080e7          	jalr	1838(ra) # 800064a6 <acquire>
  ip->ref++;
    80002d80:	449c                	lw	a5,8(s1)
    80002d82:	2785                	addiw	a5,a5,1
    80002d84:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d86:	00015517          	auipc	a0,0x15
    80002d8a:	9f250513          	addi	a0,a0,-1550 # 80017778 <itable>
    80002d8e:	00003097          	auipc	ra,0x3
    80002d92:	7cc080e7          	jalr	1996(ra) # 8000655a <release>
}
    80002d96:	8526                	mv	a0,s1
    80002d98:	60e2                	ld	ra,24(sp)
    80002d9a:	6442                	ld	s0,16(sp)
    80002d9c:	64a2                	ld	s1,8(sp)
    80002d9e:	6105                	addi	sp,sp,32
    80002da0:	8082                	ret

0000000080002da2 <ilock>:
{
    80002da2:	1101                	addi	sp,sp,-32
    80002da4:	ec06                	sd	ra,24(sp)
    80002da6:	e822                	sd	s0,16(sp)
    80002da8:	e426                	sd	s1,8(sp)
    80002daa:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002dac:	c10d                	beqz	a0,80002dce <ilock+0x2c>
    80002dae:	84aa                	mv	s1,a0
    80002db0:	451c                	lw	a5,8(a0)
    80002db2:	00f05e63          	blez	a5,80002dce <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002db6:	0541                	addi	a0,a0,16
    80002db8:	00001097          	auipc	ra,0x1
    80002dbc:	cb2080e7          	jalr	-846(ra) # 80003a6a <acquiresleep>
  if(ip->valid == 0){
    80002dc0:	40bc                	lw	a5,64(s1)
    80002dc2:	cf99                	beqz	a5,80002de0 <ilock+0x3e>
}
    80002dc4:	60e2                	ld	ra,24(sp)
    80002dc6:	6442                	ld	s0,16(sp)
    80002dc8:	64a2                	ld	s1,8(sp)
    80002dca:	6105                	addi	sp,sp,32
    80002dcc:	8082                	ret
    80002dce:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002dd0:	00005517          	auipc	a0,0x5
    80002dd4:	6c850513          	addi	a0,a0,1736 # 80008498 <etext+0x498>
    80002dd8:	00003097          	auipc	ra,0x3
    80002ddc:	154080e7          	jalr	340(ra) # 80005f2c <panic>
    80002de0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002de2:	40dc                	lw	a5,4(s1)
    80002de4:	0047d79b          	srliw	a5,a5,0x4
    80002de8:	00015597          	auipc	a1,0x15
    80002dec:	9885a583          	lw	a1,-1656(a1) # 80017770 <sb+0x18>
    80002df0:	9dbd                	addw	a1,a1,a5
    80002df2:	4088                	lw	a0,0(s1)
    80002df4:	fffff097          	auipc	ra,0xfffff
    80002df8:	7b4080e7          	jalr	1972(ra) # 800025a8 <bread>
    80002dfc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dfe:	05850593          	addi	a1,a0,88
    80002e02:	40dc                	lw	a5,4(s1)
    80002e04:	8bbd                	andi	a5,a5,15
    80002e06:	079a                	slli	a5,a5,0x6
    80002e08:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002e0a:	00059783          	lh	a5,0(a1)
    80002e0e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002e12:	00259783          	lh	a5,2(a1)
    80002e16:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002e1a:	00459783          	lh	a5,4(a1)
    80002e1e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002e22:	00659783          	lh	a5,6(a1)
    80002e26:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002e2a:	459c                	lw	a5,8(a1)
    80002e2c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002e2e:	03400613          	li	a2,52
    80002e32:	05b1                	addi	a1,a1,12
    80002e34:	05048513          	addi	a0,s1,80
    80002e38:	ffffd097          	auipc	ra,0xffffd
    80002e3c:	39e080e7          	jalr	926(ra) # 800001d6 <memmove>
    brelse(bp);
    80002e40:	854a                	mv	a0,s2
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	896080e7          	jalr	-1898(ra) # 800026d8 <brelse>
    ip->valid = 1;
    80002e4a:	4785                	li	a5,1
    80002e4c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e4e:	04449783          	lh	a5,68(s1)
    80002e52:	c399                	beqz	a5,80002e58 <ilock+0xb6>
    80002e54:	6902                	ld	s2,0(sp)
    80002e56:	b7bd                	j	80002dc4 <ilock+0x22>
      panic("ilock: no type");
    80002e58:	00005517          	auipc	a0,0x5
    80002e5c:	64850513          	addi	a0,a0,1608 # 800084a0 <etext+0x4a0>
    80002e60:	00003097          	auipc	ra,0x3
    80002e64:	0cc080e7          	jalr	204(ra) # 80005f2c <panic>

0000000080002e68 <iunlock>:
{
    80002e68:	1101                	addi	sp,sp,-32
    80002e6a:	ec06                	sd	ra,24(sp)
    80002e6c:	e822                	sd	s0,16(sp)
    80002e6e:	e426                	sd	s1,8(sp)
    80002e70:	e04a                	sd	s2,0(sp)
    80002e72:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e74:	c905                	beqz	a0,80002ea4 <iunlock+0x3c>
    80002e76:	84aa                	mv	s1,a0
    80002e78:	01050913          	addi	s2,a0,16
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	00001097          	auipc	ra,0x1
    80002e82:	c86080e7          	jalr	-890(ra) # 80003b04 <holdingsleep>
    80002e86:	cd19                	beqz	a0,80002ea4 <iunlock+0x3c>
    80002e88:	449c                	lw	a5,8(s1)
    80002e8a:	00f05d63          	blez	a5,80002ea4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e8e:	854a                	mv	a0,s2
    80002e90:	00001097          	auipc	ra,0x1
    80002e94:	c30080e7          	jalr	-976(ra) # 80003ac0 <releasesleep>
}
    80002e98:	60e2                	ld	ra,24(sp)
    80002e9a:	6442                	ld	s0,16(sp)
    80002e9c:	64a2                	ld	s1,8(sp)
    80002e9e:	6902                	ld	s2,0(sp)
    80002ea0:	6105                	addi	sp,sp,32
    80002ea2:	8082                	ret
    panic("iunlock");
    80002ea4:	00005517          	auipc	a0,0x5
    80002ea8:	60c50513          	addi	a0,a0,1548 # 800084b0 <etext+0x4b0>
    80002eac:	00003097          	auipc	ra,0x3
    80002eb0:	080080e7          	jalr	128(ra) # 80005f2c <panic>

0000000080002eb4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002eb4:	7179                	addi	sp,sp,-48
    80002eb6:	f406                	sd	ra,40(sp)
    80002eb8:	f022                	sd	s0,32(sp)
    80002eba:	ec26                	sd	s1,24(sp)
    80002ebc:	e84a                	sd	s2,16(sp)
    80002ebe:	e44e                	sd	s3,8(sp)
    80002ec0:	1800                	addi	s0,sp,48
    80002ec2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ec4:	05050493          	addi	s1,a0,80
    80002ec8:	08050913          	addi	s2,a0,128
    80002ecc:	a021                	j	80002ed4 <itrunc+0x20>
    80002ece:	0491                	addi	s1,s1,4
    80002ed0:	01248d63          	beq	s1,s2,80002eea <itrunc+0x36>
    if(ip->addrs[i]){
    80002ed4:	408c                	lw	a1,0(s1)
    80002ed6:	dde5                	beqz	a1,80002ece <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002ed8:	0009a503          	lw	a0,0(s3)
    80002edc:	00000097          	auipc	ra,0x0
    80002ee0:	910080e7          	jalr	-1776(ra) # 800027ec <bfree>
      ip->addrs[i] = 0;
    80002ee4:	0004a023          	sw	zero,0(s1)
    80002ee8:	b7dd                	j	80002ece <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002eea:	0809a583          	lw	a1,128(s3)
    80002eee:	ed99                	bnez	a1,80002f0c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ef0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ef4:	854e                	mv	a0,s3
    80002ef6:	00000097          	auipc	ra,0x0
    80002efa:	de0080e7          	jalr	-544(ra) # 80002cd6 <iupdate>
}
    80002efe:	70a2                	ld	ra,40(sp)
    80002f00:	7402                	ld	s0,32(sp)
    80002f02:	64e2                	ld	s1,24(sp)
    80002f04:	6942                	ld	s2,16(sp)
    80002f06:	69a2                	ld	s3,8(sp)
    80002f08:	6145                	addi	sp,sp,48
    80002f0a:	8082                	ret
    80002f0c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002f0e:	0009a503          	lw	a0,0(s3)
    80002f12:	fffff097          	auipc	ra,0xfffff
    80002f16:	696080e7          	jalr	1686(ra) # 800025a8 <bread>
    80002f1a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002f1c:	05850493          	addi	s1,a0,88
    80002f20:	45850913          	addi	s2,a0,1112
    80002f24:	a021                	j	80002f2c <itrunc+0x78>
    80002f26:	0491                	addi	s1,s1,4
    80002f28:	01248b63          	beq	s1,s2,80002f3e <itrunc+0x8a>
      if(a[j])
    80002f2c:	408c                	lw	a1,0(s1)
    80002f2e:	dde5                	beqz	a1,80002f26 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002f30:	0009a503          	lw	a0,0(s3)
    80002f34:	00000097          	auipc	ra,0x0
    80002f38:	8b8080e7          	jalr	-1864(ra) # 800027ec <bfree>
    80002f3c:	b7ed                	j	80002f26 <itrunc+0x72>
    brelse(bp);
    80002f3e:	8552                	mv	a0,s4
    80002f40:	fffff097          	auipc	ra,0xfffff
    80002f44:	798080e7          	jalr	1944(ra) # 800026d8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f48:	0809a583          	lw	a1,128(s3)
    80002f4c:	0009a503          	lw	a0,0(s3)
    80002f50:	00000097          	auipc	ra,0x0
    80002f54:	89c080e7          	jalr	-1892(ra) # 800027ec <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f58:	0809a023          	sw	zero,128(s3)
    80002f5c:	6a02                	ld	s4,0(sp)
    80002f5e:	bf49                	j	80002ef0 <itrunc+0x3c>

0000000080002f60 <iput>:
{
    80002f60:	1101                	addi	sp,sp,-32
    80002f62:	ec06                	sd	ra,24(sp)
    80002f64:	e822                	sd	s0,16(sp)
    80002f66:	e426                	sd	s1,8(sp)
    80002f68:	1000                	addi	s0,sp,32
    80002f6a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f6c:	00015517          	auipc	a0,0x15
    80002f70:	80c50513          	addi	a0,a0,-2036 # 80017778 <itable>
    80002f74:	00003097          	auipc	ra,0x3
    80002f78:	532080e7          	jalr	1330(ra) # 800064a6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f7c:	4498                	lw	a4,8(s1)
    80002f7e:	4785                	li	a5,1
    80002f80:	02f70263          	beq	a4,a5,80002fa4 <iput+0x44>
  ip->ref--;
    80002f84:	449c                	lw	a5,8(s1)
    80002f86:	37fd                	addiw	a5,a5,-1
    80002f88:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f8a:	00014517          	auipc	a0,0x14
    80002f8e:	7ee50513          	addi	a0,a0,2030 # 80017778 <itable>
    80002f92:	00003097          	auipc	ra,0x3
    80002f96:	5c8080e7          	jalr	1480(ra) # 8000655a <release>
}
    80002f9a:	60e2                	ld	ra,24(sp)
    80002f9c:	6442                	ld	s0,16(sp)
    80002f9e:	64a2                	ld	s1,8(sp)
    80002fa0:	6105                	addi	sp,sp,32
    80002fa2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002fa4:	40bc                	lw	a5,64(s1)
    80002fa6:	dff9                	beqz	a5,80002f84 <iput+0x24>
    80002fa8:	04a49783          	lh	a5,74(s1)
    80002fac:	ffe1                	bnez	a5,80002f84 <iput+0x24>
    80002fae:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002fb0:	01048913          	addi	s2,s1,16
    80002fb4:	854a                	mv	a0,s2
    80002fb6:	00001097          	auipc	ra,0x1
    80002fba:	ab4080e7          	jalr	-1356(ra) # 80003a6a <acquiresleep>
    release(&itable.lock);
    80002fbe:	00014517          	auipc	a0,0x14
    80002fc2:	7ba50513          	addi	a0,a0,1978 # 80017778 <itable>
    80002fc6:	00003097          	auipc	ra,0x3
    80002fca:	594080e7          	jalr	1428(ra) # 8000655a <release>
    itrunc(ip);
    80002fce:	8526                	mv	a0,s1
    80002fd0:	00000097          	auipc	ra,0x0
    80002fd4:	ee4080e7          	jalr	-284(ra) # 80002eb4 <itrunc>
    ip->type = 0;
    80002fd8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fdc:	8526                	mv	a0,s1
    80002fde:	00000097          	auipc	ra,0x0
    80002fe2:	cf8080e7          	jalr	-776(ra) # 80002cd6 <iupdate>
    ip->valid = 0;
    80002fe6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fea:	854a                	mv	a0,s2
    80002fec:	00001097          	auipc	ra,0x1
    80002ff0:	ad4080e7          	jalr	-1324(ra) # 80003ac0 <releasesleep>
    acquire(&itable.lock);
    80002ff4:	00014517          	auipc	a0,0x14
    80002ff8:	78450513          	addi	a0,a0,1924 # 80017778 <itable>
    80002ffc:	00003097          	auipc	ra,0x3
    80003000:	4aa080e7          	jalr	1194(ra) # 800064a6 <acquire>
    80003004:	6902                	ld	s2,0(sp)
    80003006:	bfbd                	j	80002f84 <iput+0x24>

0000000080003008 <iunlockput>:
{
    80003008:	1101                	addi	sp,sp,-32
    8000300a:	ec06                	sd	ra,24(sp)
    8000300c:	e822                	sd	s0,16(sp)
    8000300e:	e426                	sd	s1,8(sp)
    80003010:	1000                	addi	s0,sp,32
    80003012:	84aa                	mv	s1,a0
  iunlock(ip);
    80003014:	00000097          	auipc	ra,0x0
    80003018:	e54080e7          	jalr	-428(ra) # 80002e68 <iunlock>
  iput(ip);
    8000301c:	8526                	mv	a0,s1
    8000301e:	00000097          	auipc	ra,0x0
    80003022:	f42080e7          	jalr	-190(ra) # 80002f60 <iput>
}
    80003026:	60e2                	ld	ra,24(sp)
    80003028:	6442                	ld	s0,16(sp)
    8000302a:	64a2                	ld	s1,8(sp)
    8000302c:	6105                	addi	sp,sp,32
    8000302e:	8082                	ret

0000000080003030 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003030:	1141                	addi	sp,sp,-16
    80003032:	e422                	sd	s0,8(sp)
    80003034:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003036:	411c                	lw	a5,0(a0)
    80003038:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000303a:	415c                	lw	a5,4(a0)
    8000303c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000303e:	04451783          	lh	a5,68(a0)
    80003042:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003046:	04a51783          	lh	a5,74(a0)
    8000304a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000304e:	04c56783          	lwu	a5,76(a0)
    80003052:	e99c                	sd	a5,16(a1)
}
    80003054:	6422                	ld	s0,8(sp)
    80003056:	0141                	addi	sp,sp,16
    80003058:	8082                	ret

000000008000305a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000305a:	457c                	lw	a5,76(a0)
    8000305c:	0ed7ef63          	bltu	a5,a3,8000315a <readi+0x100>
{
    80003060:	7159                	addi	sp,sp,-112
    80003062:	f486                	sd	ra,104(sp)
    80003064:	f0a2                	sd	s0,96(sp)
    80003066:	eca6                	sd	s1,88(sp)
    80003068:	fc56                	sd	s5,56(sp)
    8000306a:	f85a                	sd	s6,48(sp)
    8000306c:	f45e                	sd	s7,40(sp)
    8000306e:	f062                	sd	s8,32(sp)
    80003070:	1880                	addi	s0,sp,112
    80003072:	8baa                	mv	s7,a0
    80003074:	8c2e                	mv	s8,a1
    80003076:	8ab2                	mv	s5,a2
    80003078:	84b6                	mv	s1,a3
    8000307a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000307c:	9f35                	addw	a4,a4,a3
    return 0;
    8000307e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003080:	0ad76c63          	bltu	a4,a3,80003138 <readi+0xde>
    80003084:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003086:	00e7f463          	bgeu	a5,a4,8000308e <readi+0x34>
    n = ip->size - off;
    8000308a:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000308e:	0c0b0463          	beqz	s6,80003156 <readi+0xfc>
    80003092:	e8ca                	sd	s2,80(sp)
    80003094:	e0d2                	sd	s4,64(sp)
    80003096:	ec66                	sd	s9,24(sp)
    80003098:	e86a                	sd	s10,16(sp)
    8000309a:	e46e                	sd	s11,8(sp)
    8000309c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000309e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030a2:	5cfd                	li	s9,-1
    800030a4:	a82d                	j	800030de <readi+0x84>
    800030a6:	020a1d93          	slli	s11,s4,0x20
    800030aa:	020ddd93          	srli	s11,s11,0x20
    800030ae:	05890613          	addi	a2,s2,88
    800030b2:	86ee                	mv	a3,s11
    800030b4:	963a                	add	a2,a2,a4
    800030b6:	85d6                	mv	a1,s5
    800030b8:	8562                	mv	a0,s8
    800030ba:	fffff097          	auipc	ra,0xfffff
    800030be:	a10080e7          	jalr	-1520(ra) # 80001aca <either_copyout>
    800030c2:	05950d63          	beq	a0,s9,8000311c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030c6:	854a                	mv	a0,s2
    800030c8:	fffff097          	auipc	ra,0xfffff
    800030cc:	610080e7          	jalr	1552(ra) # 800026d8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d0:	013a09bb          	addw	s3,s4,s3
    800030d4:	009a04bb          	addw	s1,s4,s1
    800030d8:	9aee                	add	s5,s5,s11
    800030da:	0769f863          	bgeu	s3,s6,8000314a <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030de:	000ba903          	lw	s2,0(s7)
    800030e2:	00a4d59b          	srliw	a1,s1,0xa
    800030e6:	855e                	mv	a0,s7
    800030e8:	00000097          	auipc	ra,0x0
    800030ec:	8ae080e7          	jalr	-1874(ra) # 80002996 <bmap>
    800030f0:	0005059b          	sext.w	a1,a0
    800030f4:	854a                	mv	a0,s2
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	4b2080e7          	jalr	1202(ra) # 800025a8 <bread>
    800030fe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003100:	3ff4f713          	andi	a4,s1,1023
    80003104:	40ed07bb          	subw	a5,s10,a4
    80003108:	413b06bb          	subw	a3,s6,s3
    8000310c:	8a3e                	mv	s4,a5
    8000310e:	2781                	sext.w	a5,a5
    80003110:	0006861b          	sext.w	a2,a3
    80003114:	f8f679e3          	bgeu	a2,a5,800030a6 <readi+0x4c>
    80003118:	8a36                	mv	s4,a3
    8000311a:	b771                	j	800030a6 <readi+0x4c>
      brelse(bp);
    8000311c:	854a                	mv	a0,s2
    8000311e:	fffff097          	auipc	ra,0xfffff
    80003122:	5ba080e7          	jalr	1466(ra) # 800026d8 <brelse>
      tot = -1;
    80003126:	59fd                	li	s3,-1
      break;
    80003128:	6946                	ld	s2,80(sp)
    8000312a:	6a06                	ld	s4,64(sp)
    8000312c:	6ce2                	ld	s9,24(sp)
    8000312e:	6d42                	ld	s10,16(sp)
    80003130:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003132:	0009851b          	sext.w	a0,s3
    80003136:	69a6                	ld	s3,72(sp)
}
    80003138:	70a6                	ld	ra,104(sp)
    8000313a:	7406                	ld	s0,96(sp)
    8000313c:	64e6                	ld	s1,88(sp)
    8000313e:	7ae2                	ld	s5,56(sp)
    80003140:	7b42                	ld	s6,48(sp)
    80003142:	7ba2                	ld	s7,40(sp)
    80003144:	7c02                	ld	s8,32(sp)
    80003146:	6165                	addi	sp,sp,112
    80003148:	8082                	ret
    8000314a:	6946                	ld	s2,80(sp)
    8000314c:	6a06                	ld	s4,64(sp)
    8000314e:	6ce2                	ld	s9,24(sp)
    80003150:	6d42                	ld	s10,16(sp)
    80003152:	6da2                	ld	s11,8(sp)
    80003154:	bff9                	j	80003132 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003156:	89da                	mv	s3,s6
    80003158:	bfe9                	j	80003132 <readi+0xd8>
    return 0;
    8000315a:	4501                	li	a0,0
}
    8000315c:	8082                	ret

000000008000315e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000315e:	457c                	lw	a5,76(a0)
    80003160:	10d7ee63          	bltu	a5,a3,8000327c <writei+0x11e>
{
    80003164:	7159                	addi	sp,sp,-112
    80003166:	f486                	sd	ra,104(sp)
    80003168:	f0a2                	sd	s0,96(sp)
    8000316a:	e8ca                	sd	s2,80(sp)
    8000316c:	fc56                	sd	s5,56(sp)
    8000316e:	f85a                	sd	s6,48(sp)
    80003170:	f45e                	sd	s7,40(sp)
    80003172:	f062                	sd	s8,32(sp)
    80003174:	1880                	addi	s0,sp,112
    80003176:	8b2a                	mv	s6,a0
    80003178:	8c2e                	mv	s8,a1
    8000317a:	8ab2                	mv	s5,a2
    8000317c:	8936                	mv	s2,a3
    8000317e:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003180:	00e687bb          	addw	a5,a3,a4
    80003184:	0ed7ee63          	bltu	a5,a3,80003280 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003188:	00043737          	lui	a4,0x43
    8000318c:	0ef76c63          	bltu	a4,a5,80003284 <writei+0x126>
    80003190:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003192:	0c0b8d63          	beqz	s7,8000326c <writei+0x10e>
    80003196:	eca6                	sd	s1,88(sp)
    80003198:	e4ce                	sd	s3,72(sp)
    8000319a:	ec66                	sd	s9,24(sp)
    8000319c:	e86a                	sd	s10,16(sp)
    8000319e:	e46e                	sd	s11,8(sp)
    800031a0:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800031a2:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800031a6:	5cfd                	li	s9,-1
    800031a8:	a091                	j	800031ec <writei+0x8e>
    800031aa:	02099d93          	slli	s11,s3,0x20
    800031ae:	020ddd93          	srli	s11,s11,0x20
    800031b2:	05848513          	addi	a0,s1,88
    800031b6:	86ee                	mv	a3,s11
    800031b8:	8656                	mv	a2,s5
    800031ba:	85e2                	mv	a1,s8
    800031bc:	953a                	add	a0,a0,a4
    800031be:	fffff097          	auipc	ra,0xfffff
    800031c2:	962080e7          	jalr	-1694(ra) # 80001b20 <either_copyin>
    800031c6:	07950263          	beq	a0,s9,8000322a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031ca:	8526                	mv	a0,s1
    800031cc:	00000097          	auipc	ra,0x0
    800031d0:	780080e7          	jalr	1920(ra) # 8000394c <log_write>
    brelse(bp);
    800031d4:	8526                	mv	a0,s1
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	502080e7          	jalr	1282(ra) # 800026d8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031de:	01498a3b          	addw	s4,s3,s4
    800031e2:	0129893b          	addw	s2,s3,s2
    800031e6:	9aee                	add	s5,s5,s11
    800031e8:	057a7663          	bgeu	s4,s7,80003234 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031ec:	000b2483          	lw	s1,0(s6)
    800031f0:	00a9559b          	srliw	a1,s2,0xa
    800031f4:	855a                	mv	a0,s6
    800031f6:	fffff097          	auipc	ra,0xfffff
    800031fa:	7a0080e7          	jalr	1952(ra) # 80002996 <bmap>
    800031fe:	0005059b          	sext.w	a1,a0
    80003202:	8526                	mv	a0,s1
    80003204:	fffff097          	auipc	ra,0xfffff
    80003208:	3a4080e7          	jalr	932(ra) # 800025a8 <bread>
    8000320c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000320e:	3ff97713          	andi	a4,s2,1023
    80003212:	40ed07bb          	subw	a5,s10,a4
    80003216:	414b86bb          	subw	a3,s7,s4
    8000321a:	89be                	mv	s3,a5
    8000321c:	2781                	sext.w	a5,a5
    8000321e:	0006861b          	sext.w	a2,a3
    80003222:	f8f674e3          	bgeu	a2,a5,800031aa <writei+0x4c>
    80003226:	89b6                	mv	s3,a3
    80003228:	b749                	j	800031aa <writei+0x4c>
      brelse(bp);
    8000322a:	8526                	mv	a0,s1
    8000322c:	fffff097          	auipc	ra,0xfffff
    80003230:	4ac080e7          	jalr	1196(ra) # 800026d8 <brelse>
  }

  if(off > ip->size)
    80003234:	04cb2783          	lw	a5,76(s6)
    80003238:	0327fc63          	bgeu	a5,s2,80003270 <writei+0x112>
    ip->size = off;
    8000323c:	052b2623          	sw	s2,76(s6)
    80003240:	64e6                	ld	s1,88(sp)
    80003242:	69a6                	ld	s3,72(sp)
    80003244:	6ce2                	ld	s9,24(sp)
    80003246:	6d42                	ld	s10,16(sp)
    80003248:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000324a:	855a                	mv	a0,s6
    8000324c:	00000097          	auipc	ra,0x0
    80003250:	a8a080e7          	jalr	-1398(ra) # 80002cd6 <iupdate>

  return tot;
    80003254:	000a051b          	sext.w	a0,s4
    80003258:	6a06                	ld	s4,64(sp)
}
    8000325a:	70a6                	ld	ra,104(sp)
    8000325c:	7406                	ld	s0,96(sp)
    8000325e:	6946                	ld	s2,80(sp)
    80003260:	7ae2                	ld	s5,56(sp)
    80003262:	7b42                	ld	s6,48(sp)
    80003264:	7ba2                	ld	s7,40(sp)
    80003266:	7c02                	ld	s8,32(sp)
    80003268:	6165                	addi	sp,sp,112
    8000326a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000326c:	8a5e                	mv	s4,s7
    8000326e:	bff1                	j	8000324a <writei+0xec>
    80003270:	64e6                	ld	s1,88(sp)
    80003272:	69a6                	ld	s3,72(sp)
    80003274:	6ce2                	ld	s9,24(sp)
    80003276:	6d42                	ld	s10,16(sp)
    80003278:	6da2                	ld	s11,8(sp)
    8000327a:	bfc1                	j	8000324a <writei+0xec>
    return -1;
    8000327c:	557d                	li	a0,-1
}
    8000327e:	8082                	ret
    return -1;
    80003280:	557d                	li	a0,-1
    80003282:	bfe1                	j	8000325a <writei+0xfc>
    return -1;
    80003284:	557d                	li	a0,-1
    80003286:	bfd1                	j	8000325a <writei+0xfc>

0000000080003288 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003288:	1141                	addi	sp,sp,-16
    8000328a:	e406                	sd	ra,8(sp)
    8000328c:	e022                	sd	s0,0(sp)
    8000328e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003290:	4639                	li	a2,14
    80003292:	ffffd097          	auipc	ra,0xffffd
    80003296:	fb8080e7          	jalr	-72(ra) # 8000024a <strncmp>
}
    8000329a:	60a2                	ld	ra,8(sp)
    8000329c:	6402                	ld	s0,0(sp)
    8000329e:	0141                	addi	sp,sp,16
    800032a0:	8082                	ret

00000000800032a2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800032a2:	7139                	addi	sp,sp,-64
    800032a4:	fc06                	sd	ra,56(sp)
    800032a6:	f822                	sd	s0,48(sp)
    800032a8:	f426                	sd	s1,40(sp)
    800032aa:	f04a                	sd	s2,32(sp)
    800032ac:	ec4e                	sd	s3,24(sp)
    800032ae:	e852                	sd	s4,16(sp)
    800032b0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800032b2:	04451703          	lh	a4,68(a0)
    800032b6:	4785                	li	a5,1
    800032b8:	00f71a63          	bne	a4,a5,800032cc <dirlookup+0x2a>
    800032bc:	892a                	mv	s2,a0
    800032be:	89ae                	mv	s3,a1
    800032c0:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800032c2:	457c                	lw	a5,76(a0)
    800032c4:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032c6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032c8:	e79d                	bnez	a5,800032f6 <dirlookup+0x54>
    800032ca:	a8a5                	j	80003342 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800032cc:	00005517          	auipc	a0,0x5
    800032d0:	1ec50513          	addi	a0,a0,492 # 800084b8 <etext+0x4b8>
    800032d4:	00003097          	auipc	ra,0x3
    800032d8:	c58080e7          	jalr	-936(ra) # 80005f2c <panic>
      panic("dirlookup read");
    800032dc:	00005517          	auipc	a0,0x5
    800032e0:	1f450513          	addi	a0,a0,500 # 800084d0 <etext+0x4d0>
    800032e4:	00003097          	auipc	ra,0x3
    800032e8:	c48080e7          	jalr	-952(ra) # 80005f2c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032ec:	24c1                	addiw	s1,s1,16
    800032ee:	04c92783          	lw	a5,76(s2)
    800032f2:	04f4f763          	bgeu	s1,a5,80003340 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f6:	4741                	li	a4,16
    800032f8:	86a6                	mv	a3,s1
    800032fa:	fc040613          	addi	a2,s0,-64
    800032fe:	4581                	li	a1,0
    80003300:	854a                	mv	a0,s2
    80003302:	00000097          	auipc	ra,0x0
    80003306:	d58080e7          	jalr	-680(ra) # 8000305a <readi>
    8000330a:	47c1                	li	a5,16
    8000330c:	fcf518e3          	bne	a0,a5,800032dc <dirlookup+0x3a>
    if(de.inum == 0)
    80003310:	fc045783          	lhu	a5,-64(s0)
    80003314:	dfe1                	beqz	a5,800032ec <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003316:	fc240593          	addi	a1,s0,-62
    8000331a:	854e                	mv	a0,s3
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	f6c080e7          	jalr	-148(ra) # 80003288 <namecmp>
    80003324:	f561                	bnez	a0,800032ec <dirlookup+0x4a>
      if(poff)
    80003326:	000a0463          	beqz	s4,8000332e <dirlookup+0x8c>
        *poff = off;
    8000332a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000332e:	fc045583          	lhu	a1,-64(s0)
    80003332:	00092503          	lw	a0,0(s2)
    80003336:	fffff097          	auipc	ra,0xfffff
    8000333a:	73c080e7          	jalr	1852(ra) # 80002a72 <iget>
    8000333e:	a011                	j	80003342 <dirlookup+0xa0>
  return 0;
    80003340:	4501                	li	a0,0
}
    80003342:	70e2                	ld	ra,56(sp)
    80003344:	7442                	ld	s0,48(sp)
    80003346:	74a2                	ld	s1,40(sp)
    80003348:	7902                	ld	s2,32(sp)
    8000334a:	69e2                	ld	s3,24(sp)
    8000334c:	6a42                	ld	s4,16(sp)
    8000334e:	6121                	addi	sp,sp,64
    80003350:	8082                	ret

0000000080003352 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003352:	711d                	addi	sp,sp,-96
    80003354:	ec86                	sd	ra,88(sp)
    80003356:	e8a2                	sd	s0,80(sp)
    80003358:	e4a6                	sd	s1,72(sp)
    8000335a:	e0ca                	sd	s2,64(sp)
    8000335c:	fc4e                	sd	s3,56(sp)
    8000335e:	f852                	sd	s4,48(sp)
    80003360:	f456                	sd	s5,40(sp)
    80003362:	f05a                	sd	s6,32(sp)
    80003364:	ec5e                	sd	s7,24(sp)
    80003366:	e862                	sd	s8,16(sp)
    80003368:	e466                	sd	s9,8(sp)
    8000336a:	1080                	addi	s0,sp,96
    8000336c:	84aa                	mv	s1,a0
    8000336e:	8b2e                	mv	s6,a1
    80003370:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003372:	00054703          	lbu	a4,0(a0)
    80003376:	02f00793          	li	a5,47
    8000337a:	02f70263          	beq	a4,a5,8000339e <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000337e:	ffffe097          	auipc	ra,0xffffe
    80003382:	c5e080e7          	jalr	-930(ra) # 80000fdc <myproc>
    80003386:	15053503          	ld	a0,336(a0)
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	9da080e7          	jalr	-1574(ra) # 80002d64 <idup>
    80003392:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003394:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003398:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000339a:	4b85                	li	s7,1
    8000339c:	a875                	j	80003458 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000339e:	4585                	li	a1,1
    800033a0:	4505                	li	a0,1
    800033a2:	fffff097          	auipc	ra,0xfffff
    800033a6:	6d0080e7          	jalr	1744(ra) # 80002a72 <iget>
    800033aa:	8a2a                	mv	s4,a0
    800033ac:	b7e5                	j	80003394 <namex+0x42>
      iunlockput(ip);
    800033ae:	8552                	mv	a0,s4
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	c58080e7          	jalr	-936(ra) # 80003008 <iunlockput>
      return 0;
    800033b8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800033ba:	8552                	mv	a0,s4
    800033bc:	60e6                	ld	ra,88(sp)
    800033be:	6446                	ld	s0,80(sp)
    800033c0:	64a6                	ld	s1,72(sp)
    800033c2:	6906                	ld	s2,64(sp)
    800033c4:	79e2                	ld	s3,56(sp)
    800033c6:	7a42                	ld	s4,48(sp)
    800033c8:	7aa2                	ld	s5,40(sp)
    800033ca:	7b02                	ld	s6,32(sp)
    800033cc:	6be2                	ld	s7,24(sp)
    800033ce:	6c42                	ld	s8,16(sp)
    800033d0:	6ca2                	ld	s9,8(sp)
    800033d2:	6125                	addi	sp,sp,96
    800033d4:	8082                	ret
      iunlock(ip);
    800033d6:	8552                	mv	a0,s4
    800033d8:	00000097          	auipc	ra,0x0
    800033dc:	a90080e7          	jalr	-1392(ra) # 80002e68 <iunlock>
      return ip;
    800033e0:	bfe9                	j	800033ba <namex+0x68>
      iunlockput(ip);
    800033e2:	8552                	mv	a0,s4
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	c24080e7          	jalr	-988(ra) # 80003008 <iunlockput>
      return 0;
    800033ec:	8a4e                	mv	s4,s3
    800033ee:	b7f1                	j	800033ba <namex+0x68>
  len = path - s;
    800033f0:	40998633          	sub	a2,s3,s1
    800033f4:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800033f8:	099c5863          	bge	s8,s9,80003488 <namex+0x136>
    memmove(name, s, DIRSIZ);
    800033fc:	4639                	li	a2,14
    800033fe:	85a6                	mv	a1,s1
    80003400:	8556                	mv	a0,s5
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	dd4080e7          	jalr	-556(ra) # 800001d6 <memmove>
    8000340a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000340c:	0004c783          	lbu	a5,0(s1)
    80003410:	01279763          	bne	a5,s2,8000341e <namex+0xcc>
    path++;
    80003414:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003416:	0004c783          	lbu	a5,0(s1)
    8000341a:	ff278de3          	beq	a5,s2,80003414 <namex+0xc2>
    ilock(ip);
    8000341e:	8552                	mv	a0,s4
    80003420:	00000097          	auipc	ra,0x0
    80003424:	982080e7          	jalr	-1662(ra) # 80002da2 <ilock>
    if(ip->type != T_DIR){
    80003428:	044a1783          	lh	a5,68(s4)
    8000342c:	f97791e3          	bne	a5,s7,800033ae <namex+0x5c>
    if(nameiparent && *path == '\0'){
    80003430:	000b0563          	beqz	s6,8000343a <namex+0xe8>
    80003434:	0004c783          	lbu	a5,0(s1)
    80003438:	dfd9                	beqz	a5,800033d6 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000343a:	4601                	li	a2,0
    8000343c:	85d6                	mv	a1,s5
    8000343e:	8552                	mv	a0,s4
    80003440:	00000097          	auipc	ra,0x0
    80003444:	e62080e7          	jalr	-414(ra) # 800032a2 <dirlookup>
    80003448:	89aa                	mv	s3,a0
    8000344a:	dd41                	beqz	a0,800033e2 <namex+0x90>
    iunlockput(ip);
    8000344c:	8552                	mv	a0,s4
    8000344e:	00000097          	auipc	ra,0x0
    80003452:	bba080e7          	jalr	-1094(ra) # 80003008 <iunlockput>
    ip = next;
    80003456:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003458:	0004c783          	lbu	a5,0(s1)
    8000345c:	01279763          	bne	a5,s2,8000346a <namex+0x118>
    path++;
    80003460:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003462:	0004c783          	lbu	a5,0(s1)
    80003466:	ff278de3          	beq	a5,s2,80003460 <namex+0x10e>
  if(*path == 0)
    8000346a:	cb9d                	beqz	a5,800034a0 <namex+0x14e>
  while(*path != '/' && *path != 0)
    8000346c:	0004c783          	lbu	a5,0(s1)
    80003470:	89a6                	mv	s3,s1
  len = path - s;
    80003472:	4c81                	li	s9,0
    80003474:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003476:	01278963          	beq	a5,s2,80003488 <namex+0x136>
    8000347a:	dbbd                	beqz	a5,800033f0 <namex+0x9e>
    path++;
    8000347c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000347e:	0009c783          	lbu	a5,0(s3)
    80003482:	ff279ce3          	bne	a5,s2,8000347a <namex+0x128>
    80003486:	b7ad                	j	800033f0 <namex+0x9e>
    memmove(name, s, len);
    80003488:	2601                	sext.w	a2,a2
    8000348a:	85a6                	mv	a1,s1
    8000348c:	8556                	mv	a0,s5
    8000348e:	ffffd097          	auipc	ra,0xffffd
    80003492:	d48080e7          	jalr	-696(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003496:	9cd6                	add	s9,s9,s5
    80003498:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000349c:	84ce                	mv	s1,s3
    8000349e:	b7bd                	j	8000340c <namex+0xba>
  if(nameiparent){
    800034a0:	f00b0de3          	beqz	s6,800033ba <namex+0x68>
    iput(ip);
    800034a4:	8552                	mv	a0,s4
    800034a6:	00000097          	auipc	ra,0x0
    800034aa:	aba080e7          	jalr	-1350(ra) # 80002f60 <iput>
    return 0;
    800034ae:	4a01                	li	s4,0
    800034b0:	b729                	j	800033ba <namex+0x68>

00000000800034b2 <dirlink>:
{
    800034b2:	7139                	addi	sp,sp,-64
    800034b4:	fc06                	sd	ra,56(sp)
    800034b6:	f822                	sd	s0,48(sp)
    800034b8:	f04a                	sd	s2,32(sp)
    800034ba:	ec4e                	sd	s3,24(sp)
    800034bc:	e852                	sd	s4,16(sp)
    800034be:	0080                	addi	s0,sp,64
    800034c0:	892a                	mv	s2,a0
    800034c2:	8a2e                	mv	s4,a1
    800034c4:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800034c6:	4601                	li	a2,0
    800034c8:	00000097          	auipc	ra,0x0
    800034cc:	dda080e7          	jalr	-550(ra) # 800032a2 <dirlookup>
    800034d0:	ed25                	bnez	a0,80003548 <dirlink+0x96>
    800034d2:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034d4:	04c92483          	lw	s1,76(s2)
    800034d8:	c49d                	beqz	s1,80003506 <dirlink+0x54>
    800034da:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034dc:	4741                	li	a4,16
    800034de:	86a6                	mv	a3,s1
    800034e0:	fc040613          	addi	a2,s0,-64
    800034e4:	4581                	li	a1,0
    800034e6:	854a                	mv	a0,s2
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	b72080e7          	jalr	-1166(ra) # 8000305a <readi>
    800034f0:	47c1                	li	a5,16
    800034f2:	06f51163          	bne	a0,a5,80003554 <dirlink+0xa2>
    if(de.inum == 0)
    800034f6:	fc045783          	lhu	a5,-64(s0)
    800034fa:	c791                	beqz	a5,80003506 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034fc:	24c1                	addiw	s1,s1,16
    800034fe:	04c92783          	lw	a5,76(s2)
    80003502:	fcf4ede3          	bltu	s1,a5,800034dc <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003506:	4639                	li	a2,14
    80003508:	85d2                	mv	a1,s4
    8000350a:	fc240513          	addi	a0,s0,-62
    8000350e:	ffffd097          	auipc	ra,0xffffd
    80003512:	d72080e7          	jalr	-654(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003516:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000351a:	4741                	li	a4,16
    8000351c:	86a6                	mv	a3,s1
    8000351e:	fc040613          	addi	a2,s0,-64
    80003522:	4581                	li	a1,0
    80003524:	854a                	mv	a0,s2
    80003526:	00000097          	auipc	ra,0x0
    8000352a:	c38080e7          	jalr	-968(ra) # 8000315e <writei>
    8000352e:	872a                	mv	a4,a0
    80003530:	47c1                	li	a5,16
  return 0;
    80003532:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003534:	02f71863          	bne	a4,a5,80003564 <dirlink+0xb2>
    80003538:	74a2                	ld	s1,40(sp)
}
    8000353a:	70e2                	ld	ra,56(sp)
    8000353c:	7442                	ld	s0,48(sp)
    8000353e:	7902                	ld	s2,32(sp)
    80003540:	69e2                	ld	s3,24(sp)
    80003542:	6a42                	ld	s4,16(sp)
    80003544:	6121                	addi	sp,sp,64
    80003546:	8082                	ret
    iput(ip);
    80003548:	00000097          	auipc	ra,0x0
    8000354c:	a18080e7          	jalr	-1512(ra) # 80002f60 <iput>
    return -1;
    80003550:	557d                	li	a0,-1
    80003552:	b7e5                	j	8000353a <dirlink+0x88>
      panic("dirlink read");
    80003554:	00005517          	auipc	a0,0x5
    80003558:	f8c50513          	addi	a0,a0,-116 # 800084e0 <etext+0x4e0>
    8000355c:	00003097          	auipc	ra,0x3
    80003560:	9d0080e7          	jalr	-1584(ra) # 80005f2c <panic>
    panic("dirlink");
    80003564:	00005517          	auipc	a0,0x5
    80003568:	08c50513          	addi	a0,a0,140 # 800085f0 <etext+0x5f0>
    8000356c:	00003097          	auipc	ra,0x3
    80003570:	9c0080e7          	jalr	-1600(ra) # 80005f2c <panic>

0000000080003574 <namei>:

struct inode*
namei(char *path)
{
    80003574:	1101                	addi	sp,sp,-32
    80003576:	ec06                	sd	ra,24(sp)
    80003578:	e822                	sd	s0,16(sp)
    8000357a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000357c:	fe040613          	addi	a2,s0,-32
    80003580:	4581                	li	a1,0
    80003582:	00000097          	auipc	ra,0x0
    80003586:	dd0080e7          	jalr	-560(ra) # 80003352 <namex>
}
    8000358a:	60e2                	ld	ra,24(sp)
    8000358c:	6442                	ld	s0,16(sp)
    8000358e:	6105                	addi	sp,sp,32
    80003590:	8082                	ret

0000000080003592 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003592:	1141                	addi	sp,sp,-16
    80003594:	e406                	sd	ra,8(sp)
    80003596:	e022                	sd	s0,0(sp)
    80003598:	0800                	addi	s0,sp,16
    8000359a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000359c:	4585                	li	a1,1
    8000359e:	00000097          	auipc	ra,0x0
    800035a2:	db4080e7          	jalr	-588(ra) # 80003352 <namex>
}
    800035a6:	60a2                	ld	ra,8(sp)
    800035a8:	6402                	ld	s0,0(sp)
    800035aa:	0141                	addi	sp,sp,16
    800035ac:	8082                	ret

00000000800035ae <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800035ae:	1101                	addi	sp,sp,-32
    800035b0:	ec06                	sd	ra,24(sp)
    800035b2:	e822                	sd	s0,16(sp)
    800035b4:	e426                	sd	s1,8(sp)
    800035b6:	e04a                	sd	s2,0(sp)
    800035b8:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800035ba:	00016917          	auipc	s2,0x16
    800035be:	c6690913          	addi	s2,s2,-922 # 80019220 <log>
    800035c2:	01892583          	lw	a1,24(s2)
    800035c6:	02892503          	lw	a0,40(s2)
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	fde080e7          	jalr	-34(ra) # 800025a8 <bread>
    800035d2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035d4:	02c92603          	lw	a2,44(s2)
    800035d8:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035da:	00c05f63          	blez	a2,800035f8 <write_head+0x4a>
    800035de:	00016717          	auipc	a4,0x16
    800035e2:	c7270713          	addi	a4,a4,-910 # 80019250 <log+0x30>
    800035e6:	87aa                	mv	a5,a0
    800035e8:	060a                	slli	a2,a2,0x2
    800035ea:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800035ec:	4314                	lw	a3,0(a4)
    800035ee:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800035f0:	0711                	addi	a4,a4,4
    800035f2:	0791                	addi	a5,a5,4
    800035f4:	fec79ce3          	bne	a5,a2,800035ec <write_head+0x3e>
  }
  bwrite(buf);
    800035f8:	8526                	mv	a0,s1
    800035fa:	fffff097          	auipc	ra,0xfffff
    800035fe:	0a0080e7          	jalr	160(ra) # 8000269a <bwrite>
  brelse(buf);
    80003602:	8526                	mv	a0,s1
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	0d4080e7          	jalr	212(ra) # 800026d8 <brelse>
}
    8000360c:	60e2                	ld	ra,24(sp)
    8000360e:	6442                	ld	s0,16(sp)
    80003610:	64a2                	ld	s1,8(sp)
    80003612:	6902                	ld	s2,0(sp)
    80003614:	6105                	addi	sp,sp,32
    80003616:	8082                	ret

0000000080003618 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003618:	00016797          	auipc	a5,0x16
    8000361c:	c347a783          	lw	a5,-972(a5) # 8001924c <log+0x2c>
    80003620:	0af05d63          	blez	a5,800036da <install_trans+0xc2>
{
    80003624:	7139                	addi	sp,sp,-64
    80003626:	fc06                	sd	ra,56(sp)
    80003628:	f822                	sd	s0,48(sp)
    8000362a:	f426                	sd	s1,40(sp)
    8000362c:	f04a                	sd	s2,32(sp)
    8000362e:	ec4e                	sd	s3,24(sp)
    80003630:	e852                	sd	s4,16(sp)
    80003632:	e456                	sd	s5,8(sp)
    80003634:	e05a                	sd	s6,0(sp)
    80003636:	0080                	addi	s0,sp,64
    80003638:	8b2a                	mv	s6,a0
    8000363a:	00016a97          	auipc	s5,0x16
    8000363e:	c16a8a93          	addi	s5,s5,-1002 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003642:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003644:	00016997          	auipc	s3,0x16
    80003648:	bdc98993          	addi	s3,s3,-1060 # 80019220 <log>
    8000364c:	a00d                	j	8000366e <install_trans+0x56>
    brelse(lbuf);
    8000364e:	854a                	mv	a0,s2
    80003650:	fffff097          	auipc	ra,0xfffff
    80003654:	088080e7          	jalr	136(ra) # 800026d8 <brelse>
    brelse(dbuf);
    80003658:	8526                	mv	a0,s1
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	07e080e7          	jalr	126(ra) # 800026d8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003662:	2a05                	addiw	s4,s4,1
    80003664:	0a91                	addi	s5,s5,4
    80003666:	02c9a783          	lw	a5,44(s3)
    8000366a:	04fa5e63          	bge	s4,a5,800036c6 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000366e:	0189a583          	lw	a1,24(s3)
    80003672:	014585bb          	addw	a1,a1,s4
    80003676:	2585                	addiw	a1,a1,1
    80003678:	0289a503          	lw	a0,40(s3)
    8000367c:	fffff097          	auipc	ra,0xfffff
    80003680:	f2c080e7          	jalr	-212(ra) # 800025a8 <bread>
    80003684:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003686:	000aa583          	lw	a1,0(s5)
    8000368a:	0289a503          	lw	a0,40(s3)
    8000368e:	fffff097          	auipc	ra,0xfffff
    80003692:	f1a080e7          	jalr	-230(ra) # 800025a8 <bread>
    80003696:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003698:	40000613          	li	a2,1024
    8000369c:	05890593          	addi	a1,s2,88
    800036a0:	05850513          	addi	a0,a0,88
    800036a4:	ffffd097          	auipc	ra,0xffffd
    800036a8:	b32080e7          	jalr	-1230(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    800036ac:	8526                	mv	a0,s1
    800036ae:	fffff097          	auipc	ra,0xfffff
    800036b2:	fec080e7          	jalr	-20(ra) # 8000269a <bwrite>
    if(recovering == 0)
    800036b6:	f80b1ce3          	bnez	s6,8000364e <install_trans+0x36>
      bunpin(dbuf);
    800036ba:	8526                	mv	a0,s1
    800036bc:	fffff097          	auipc	ra,0xfffff
    800036c0:	0f4080e7          	jalr	244(ra) # 800027b0 <bunpin>
    800036c4:	b769                	j	8000364e <install_trans+0x36>
}
    800036c6:	70e2                	ld	ra,56(sp)
    800036c8:	7442                	ld	s0,48(sp)
    800036ca:	74a2                	ld	s1,40(sp)
    800036cc:	7902                	ld	s2,32(sp)
    800036ce:	69e2                	ld	s3,24(sp)
    800036d0:	6a42                	ld	s4,16(sp)
    800036d2:	6aa2                	ld	s5,8(sp)
    800036d4:	6b02                	ld	s6,0(sp)
    800036d6:	6121                	addi	sp,sp,64
    800036d8:	8082                	ret
    800036da:	8082                	ret

00000000800036dc <initlog>:
{
    800036dc:	7179                	addi	sp,sp,-48
    800036de:	f406                	sd	ra,40(sp)
    800036e0:	f022                	sd	s0,32(sp)
    800036e2:	ec26                	sd	s1,24(sp)
    800036e4:	e84a                	sd	s2,16(sp)
    800036e6:	e44e                	sd	s3,8(sp)
    800036e8:	1800                	addi	s0,sp,48
    800036ea:	892a                	mv	s2,a0
    800036ec:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036ee:	00016497          	auipc	s1,0x16
    800036f2:	b3248493          	addi	s1,s1,-1230 # 80019220 <log>
    800036f6:	00005597          	auipc	a1,0x5
    800036fa:	dfa58593          	addi	a1,a1,-518 # 800084f0 <etext+0x4f0>
    800036fe:	8526                	mv	a0,s1
    80003700:	00003097          	auipc	ra,0x3
    80003704:	d16080e7          	jalr	-746(ra) # 80006416 <initlock>
  log.start = sb->logstart;
    80003708:	0149a583          	lw	a1,20(s3)
    8000370c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000370e:	0109a783          	lw	a5,16(s3)
    80003712:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003714:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003718:	854a                	mv	a0,s2
    8000371a:	fffff097          	auipc	ra,0xfffff
    8000371e:	e8e080e7          	jalr	-370(ra) # 800025a8 <bread>
  log.lh.n = lh->n;
    80003722:	4d30                	lw	a2,88(a0)
    80003724:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003726:	00c05f63          	blez	a2,80003744 <initlog+0x68>
    8000372a:	87aa                	mv	a5,a0
    8000372c:	00016717          	auipc	a4,0x16
    80003730:	b2470713          	addi	a4,a4,-1244 # 80019250 <log+0x30>
    80003734:	060a                	slli	a2,a2,0x2
    80003736:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003738:	4ff4                	lw	a3,92(a5)
    8000373a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000373c:	0791                	addi	a5,a5,4
    8000373e:	0711                	addi	a4,a4,4
    80003740:	fec79ce3          	bne	a5,a2,80003738 <initlog+0x5c>
  brelse(buf);
    80003744:	fffff097          	auipc	ra,0xfffff
    80003748:	f94080e7          	jalr	-108(ra) # 800026d8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000374c:	4505                	li	a0,1
    8000374e:	00000097          	auipc	ra,0x0
    80003752:	eca080e7          	jalr	-310(ra) # 80003618 <install_trans>
  log.lh.n = 0;
    80003756:	00016797          	auipc	a5,0x16
    8000375a:	ae07ab23          	sw	zero,-1290(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    8000375e:	00000097          	auipc	ra,0x0
    80003762:	e50080e7          	jalr	-432(ra) # 800035ae <write_head>
}
    80003766:	70a2                	ld	ra,40(sp)
    80003768:	7402                	ld	s0,32(sp)
    8000376a:	64e2                	ld	s1,24(sp)
    8000376c:	6942                	ld	s2,16(sp)
    8000376e:	69a2                	ld	s3,8(sp)
    80003770:	6145                	addi	sp,sp,48
    80003772:	8082                	ret

0000000080003774 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003774:	1101                	addi	sp,sp,-32
    80003776:	ec06                	sd	ra,24(sp)
    80003778:	e822                	sd	s0,16(sp)
    8000377a:	e426                	sd	s1,8(sp)
    8000377c:	e04a                	sd	s2,0(sp)
    8000377e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003780:	00016517          	auipc	a0,0x16
    80003784:	aa050513          	addi	a0,a0,-1376 # 80019220 <log>
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	d1e080e7          	jalr	-738(ra) # 800064a6 <acquire>
  while(1){
    if(log.committing){
    80003790:	00016497          	auipc	s1,0x16
    80003794:	a9048493          	addi	s1,s1,-1392 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003798:	4979                	li	s2,30
    8000379a:	a039                	j	800037a8 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000379c:	85a6                	mv	a1,s1
    8000379e:	8526                	mv	a0,s1
    800037a0:	ffffe097          	auipc	ra,0xffffe
    800037a4:	f86080e7          	jalr	-122(ra) # 80001726 <sleep>
    if(log.committing){
    800037a8:	50dc                	lw	a5,36(s1)
    800037aa:	fbed                	bnez	a5,8000379c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800037ac:	5098                	lw	a4,32(s1)
    800037ae:	2705                	addiw	a4,a4,1
    800037b0:	0027179b          	slliw	a5,a4,0x2
    800037b4:	9fb9                	addw	a5,a5,a4
    800037b6:	0017979b          	slliw	a5,a5,0x1
    800037ba:	54d4                	lw	a3,44(s1)
    800037bc:	9fb5                	addw	a5,a5,a3
    800037be:	00f95963          	bge	s2,a5,800037d0 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800037c2:	85a6                	mv	a1,s1
    800037c4:	8526                	mv	a0,s1
    800037c6:	ffffe097          	auipc	ra,0xffffe
    800037ca:	f60080e7          	jalr	-160(ra) # 80001726 <sleep>
    800037ce:	bfe9                	j	800037a8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037d0:	00016517          	auipc	a0,0x16
    800037d4:	a5050513          	addi	a0,a0,-1456 # 80019220 <log>
    800037d8:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800037da:	00003097          	auipc	ra,0x3
    800037de:	d80080e7          	jalr	-640(ra) # 8000655a <release>
      break;
    }
  }
}
    800037e2:	60e2                	ld	ra,24(sp)
    800037e4:	6442                	ld	s0,16(sp)
    800037e6:	64a2                	ld	s1,8(sp)
    800037e8:	6902                	ld	s2,0(sp)
    800037ea:	6105                	addi	sp,sp,32
    800037ec:	8082                	ret

00000000800037ee <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037ee:	7139                	addi	sp,sp,-64
    800037f0:	fc06                	sd	ra,56(sp)
    800037f2:	f822                	sd	s0,48(sp)
    800037f4:	f426                	sd	s1,40(sp)
    800037f6:	f04a                	sd	s2,32(sp)
    800037f8:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037fa:	00016497          	auipc	s1,0x16
    800037fe:	a2648493          	addi	s1,s1,-1498 # 80019220 <log>
    80003802:	8526                	mv	a0,s1
    80003804:	00003097          	auipc	ra,0x3
    80003808:	ca2080e7          	jalr	-862(ra) # 800064a6 <acquire>
  log.outstanding -= 1;
    8000380c:	509c                	lw	a5,32(s1)
    8000380e:	37fd                	addiw	a5,a5,-1
    80003810:	0007891b          	sext.w	s2,a5
    80003814:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003816:	50dc                	lw	a5,36(s1)
    80003818:	e7b9                	bnez	a5,80003866 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000381a:	06091163          	bnez	s2,8000387c <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000381e:	00016497          	auipc	s1,0x16
    80003822:	a0248493          	addi	s1,s1,-1534 # 80019220 <log>
    80003826:	4785                	li	a5,1
    80003828:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000382a:	8526                	mv	a0,s1
    8000382c:	00003097          	auipc	ra,0x3
    80003830:	d2e080e7          	jalr	-722(ra) # 8000655a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003834:	54dc                	lw	a5,44(s1)
    80003836:	06f04763          	bgtz	a5,800038a4 <end_op+0xb6>
    acquire(&log.lock);
    8000383a:	00016497          	auipc	s1,0x16
    8000383e:	9e648493          	addi	s1,s1,-1562 # 80019220 <log>
    80003842:	8526                	mv	a0,s1
    80003844:	00003097          	auipc	ra,0x3
    80003848:	c62080e7          	jalr	-926(ra) # 800064a6 <acquire>
    log.committing = 0;
    8000384c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003850:	8526                	mv	a0,s1
    80003852:	ffffe097          	auipc	ra,0xffffe
    80003856:	060080e7          	jalr	96(ra) # 800018b2 <wakeup>
    release(&log.lock);
    8000385a:	8526                	mv	a0,s1
    8000385c:	00003097          	auipc	ra,0x3
    80003860:	cfe080e7          	jalr	-770(ra) # 8000655a <release>
}
    80003864:	a815                	j	80003898 <end_op+0xaa>
    80003866:	ec4e                	sd	s3,24(sp)
    80003868:	e852                	sd	s4,16(sp)
    8000386a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000386c:	00005517          	auipc	a0,0x5
    80003870:	c8c50513          	addi	a0,a0,-884 # 800084f8 <etext+0x4f8>
    80003874:	00002097          	auipc	ra,0x2
    80003878:	6b8080e7          	jalr	1720(ra) # 80005f2c <panic>
    wakeup(&log);
    8000387c:	00016497          	auipc	s1,0x16
    80003880:	9a448493          	addi	s1,s1,-1628 # 80019220 <log>
    80003884:	8526                	mv	a0,s1
    80003886:	ffffe097          	auipc	ra,0xffffe
    8000388a:	02c080e7          	jalr	44(ra) # 800018b2 <wakeup>
  release(&log.lock);
    8000388e:	8526                	mv	a0,s1
    80003890:	00003097          	auipc	ra,0x3
    80003894:	cca080e7          	jalr	-822(ra) # 8000655a <release>
}
    80003898:	70e2                	ld	ra,56(sp)
    8000389a:	7442                	ld	s0,48(sp)
    8000389c:	74a2                	ld	s1,40(sp)
    8000389e:	7902                	ld	s2,32(sp)
    800038a0:	6121                	addi	sp,sp,64
    800038a2:	8082                	ret
    800038a4:	ec4e                	sd	s3,24(sp)
    800038a6:	e852                	sd	s4,16(sp)
    800038a8:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800038aa:	00016a97          	auipc	s5,0x16
    800038ae:	9a6a8a93          	addi	s5,s5,-1626 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800038b2:	00016a17          	auipc	s4,0x16
    800038b6:	96ea0a13          	addi	s4,s4,-1682 # 80019220 <log>
    800038ba:	018a2583          	lw	a1,24(s4)
    800038be:	012585bb          	addw	a1,a1,s2
    800038c2:	2585                	addiw	a1,a1,1
    800038c4:	028a2503          	lw	a0,40(s4)
    800038c8:	fffff097          	auipc	ra,0xfffff
    800038cc:	ce0080e7          	jalr	-800(ra) # 800025a8 <bread>
    800038d0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038d2:	000aa583          	lw	a1,0(s5)
    800038d6:	028a2503          	lw	a0,40(s4)
    800038da:	fffff097          	auipc	ra,0xfffff
    800038de:	cce080e7          	jalr	-818(ra) # 800025a8 <bread>
    800038e2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038e4:	40000613          	li	a2,1024
    800038e8:	05850593          	addi	a1,a0,88
    800038ec:	05848513          	addi	a0,s1,88
    800038f0:	ffffd097          	auipc	ra,0xffffd
    800038f4:	8e6080e7          	jalr	-1818(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    800038f8:	8526                	mv	a0,s1
    800038fa:	fffff097          	auipc	ra,0xfffff
    800038fe:	da0080e7          	jalr	-608(ra) # 8000269a <bwrite>
    brelse(from);
    80003902:	854e                	mv	a0,s3
    80003904:	fffff097          	auipc	ra,0xfffff
    80003908:	dd4080e7          	jalr	-556(ra) # 800026d8 <brelse>
    brelse(to);
    8000390c:	8526                	mv	a0,s1
    8000390e:	fffff097          	auipc	ra,0xfffff
    80003912:	dca080e7          	jalr	-566(ra) # 800026d8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003916:	2905                	addiw	s2,s2,1
    80003918:	0a91                	addi	s5,s5,4
    8000391a:	02ca2783          	lw	a5,44(s4)
    8000391e:	f8f94ee3          	blt	s2,a5,800038ba <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003922:	00000097          	auipc	ra,0x0
    80003926:	c8c080e7          	jalr	-884(ra) # 800035ae <write_head>
    install_trans(0); // Now install writes to home locations
    8000392a:	4501                	li	a0,0
    8000392c:	00000097          	auipc	ra,0x0
    80003930:	cec080e7          	jalr	-788(ra) # 80003618 <install_trans>
    log.lh.n = 0;
    80003934:	00016797          	auipc	a5,0x16
    80003938:	9007ac23          	sw	zero,-1768(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000393c:	00000097          	auipc	ra,0x0
    80003940:	c72080e7          	jalr	-910(ra) # 800035ae <write_head>
    80003944:	69e2                	ld	s3,24(sp)
    80003946:	6a42                	ld	s4,16(sp)
    80003948:	6aa2                	ld	s5,8(sp)
    8000394a:	bdc5                	j	8000383a <end_op+0x4c>

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
    8000395a:	00016917          	auipc	s2,0x16
    8000395e:	8c690913          	addi	s2,s2,-1850 # 80019220 <log>
    80003962:	854a                	mv	a0,s2
    80003964:	00003097          	auipc	ra,0x3
    80003968:	b42080e7          	jalr	-1214(ra) # 800064a6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000396c:	02c92603          	lw	a2,44(s2)
    80003970:	47f5                	li	a5,29
    80003972:	06c7c563          	blt	a5,a2,800039dc <log_write+0x90>
    80003976:	00016797          	auipc	a5,0x16
    8000397a:	8c67a783          	lw	a5,-1850(a5) # 8001923c <log+0x1c>
    8000397e:	37fd                	addiw	a5,a5,-1
    80003980:	04f65e63          	bge	a2,a5,800039dc <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003984:	00016797          	auipc	a5,0x16
    80003988:	8bc7a783          	lw	a5,-1860(a5) # 80019240 <log+0x20>
    8000398c:	06f05063          	blez	a5,800039ec <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003990:	4781                	li	a5,0
    80003992:	06c05563          	blez	a2,800039fc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003996:	44cc                	lw	a1,12(s1)
    80003998:	00016717          	auipc	a4,0x16
    8000399c:	8b870713          	addi	a4,a4,-1864 # 80019250 <log+0x30>
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
    800039b4:	00016797          	auipc	a5,0x16
    800039b8:	86c78793          	addi	a5,a5,-1940 # 80019220 <log>
    800039bc:	97b2                	add	a5,a5,a2
    800039be:	44d8                	lw	a4,12(s1)
    800039c0:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039c2:	8526                	mv	a0,s1
    800039c4:	fffff097          	auipc	ra,0xfffff
    800039c8:	db0080e7          	jalr	-592(ra) # 80002774 <bpin>
    log.lh.n++;
    800039cc:	00016717          	auipc	a4,0x16
    800039d0:	85470713          	addi	a4,a4,-1964 # 80019220 <log>
    800039d4:	575c                	lw	a5,44(a4)
    800039d6:	2785                	addiw	a5,a5,1
    800039d8:	d75c                	sw	a5,44(a4)
    800039da:	a82d                	j	80003a14 <log_write+0xc8>
    panic("too big a transaction");
    800039dc:	00005517          	auipc	a0,0x5
    800039e0:	b2c50513          	addi	a0,a0,-1236 # 80008508 <etext+0x508>
    800039e4:	00002097          	auipc	ra,0x2
    800039e8:	548080e7          	jalr	1352(ra) # 80005f2c <panic>
    panic("log_write outside of trans");
    800039ec:	00005517          	auipc	a0,0x5
    800039f0:	b3450513          	addi	a0,a0,-1228 # 80008520 <etext+0x520>
    800039f4:	00002097          	auipc	ra,0x2
    800039f8:	538080e7          	jalr	1336(ra) # 80005f2c <panic>
  log.lh.block[i] = b->blockno;
    800039fc:	00878693          	addi	a3,a5,8
    80003a00:	068a                	slli	a3,a3,0x2
    80003a02:	00016717          	auipc	a4,0x16
    80003a06:	81e70713          	addi	a4,a4,-2018 # 80019220 <log>
    80003a0a:	9736                	add	a4,a4,a3
    80003a0c:	44d4                	lw	a3,12(s1)
    80003a0e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003a10:	faf609e3          	beq	a2,a5,800039c2 <log_write+0x76>
  }
  release(&log.lock);
    80003a14:	00016517          	auipc	a0,0x16
    80003a18:	80c50513          	addi	a0,a0,-2036 # 80019220 <log>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	b3e080e7          	jalr	-1218(ra) # 8000655a <release>
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
    80003a44:	b0058593          	addi	a1,a1,-1280 # 80008540 <etext+0x540>
    80003a48:	0521                	addi	a0,a0,8
    80003a4a:	00003097          	auipc	ra,0x3
    80003a4e:	9cc080e7          	jalr	-1588(ra) # 80006416 <initlock>
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
    80003a82:	a28080e7          	jalr	-1496(ra) # 800064a6 <acquire>
  while (lk->locked) {
    80003a86:	409c                	lw	a5,0(s1)
    80003a88:	cb89                	beqz	a5,80003a9a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a8a:	85ca                	mv	a1,s2
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	ffffe097          	auipc	ra,0xffffe
    80003a92:	c98080e7          	jalr	-872(ra) # 80001726 <sleep>
  while (lk->locked) {
    80003a96:	409c                	lw	a5,0(s1)
    80003a98:	fbed                	bnez	a5,80003a8a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a9a:	4785                	li	a5,1
    80003a9c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a9e:	ffffd097          	auipc	ra,0xffffd
    80003aa2:	53e080e7          	jalr	1342(ra) # 80000fdc <myproc>
    80003aa6:	591c                	lw	a5,48(a0)
    80003aa8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003aaa:	854a                	mv	a0,s2
    80003aac:	00003097          	auipc	ra,0x3
    80003ab0:	aae080e7          	jalr	-1362(ra) # 8000655a <release>
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
    80003ad8:	9d2080e7          	jalr	-1582(ra) # 800064a6 <acquire>
  lk->locked = 0;
    80003adc:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ae0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	ffffe097          	auipc	ra,0xffffe
    80003aea:	dcc080e7          	jalr	-564(ra) # 800018b2 <wakeup>
  release(&lk->lk);
    80003aee:	854a                	mv	a0,s2
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	a6a080e7          	jalr	-1430(ra) # 8000655a <release>
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
    80003b1c:	98e080e7          	jalr	-1650(ra) # 800064a6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b20:	409c                	lw	a5,0(s1)
    80003b22:	ef91                	bnez	a5,80003b3e <holdingsleep+0x3a>
    80003b24:	4481                	li	s1,0
  release(&lk->lk);
    80003b26:	854a                	mv	a0,s2
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	a32080e7          	jalr	-1486(ra) # 8000655a <release>
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
    80003b48:	498080e7          	jalr	1176(ra) # 80000fdc <myproc>
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
    80003b66:	9ee58593          	addi	a1,a1,-1554 # 80008550 <etext+0x550>
    80003b6a:	00015517          	auipc	a0,0x15
    80003b6e:	7fe50513          	addi	a0,a0,2046 # 80019368 <ftable>
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	8a4080e7          	jalr	-1884(ra) # 80006416 <initlock>
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
    80003b8c:	00015517          	auipc	a0,0x15
    80003b90:	7dc50513          	addi	a0,a0,2012 # 80019368 <ftable>
    80003b94:	00003097          	auipc	ra,0x3
    80003b98:	912080e7          	jalr	-1774(ra) # 800064a6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b9c:	00015497          	auipc	s1,0x15
    80003ba0:	7e448493          	addi	s1,s1,2020 # 80019380 <ftable+0x18>
    80003ba4:	00016717          	auipc	a4,0x16
    80003ba8:	77c70713          	addi	a4,a4,1916 # 8001a320 <ftable+0xfb8>
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
    80003bb8:	00015517          	auipc	a0,0x15
    80003bbc:	7b050513          	addi	a0,a0,1968 # 80019368 <ftable>
    80003bc0:	00003097          	auipc	ra,0x3
    80003bc4:	99a080e7          	jalr	-1638(ra) # 8000655a <release>
  return 0;
    80003bc8:	4481                	li	s1,0
    80003bca:	a819                	j	80003be0 <filealloc+0x5e>
      f->ref = 1;
    80003bcc:	4785                	li	a5,1
    80003bce:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bd0:	00015517          	auipc	a0,0x15
    80003bd4:	79850513          	addi	a0,a0,1944 # 80019368 <ftable>
    80003bd8:	00003097          	auipc	ra,0x3
    80003bdc:	982080e7          	jalr	-1662(ra) # 8000655a <release>
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
    80003bf8:	00015517          	auipc	a0,0x15
    80003bfc:	77050513          	addi	a0,a0,1904 # 80019368 <ftable>
    80003c00:	00003097          	auipc	ra,0x3
    80003c04:	8a6080e7          	jalr	-1882(ra) # 800064a6 <acquire>
  if(f->ref < 1)
    80003c08:	40dc                	lw	a5,4(s1)
    80003c0a:	02f05263          	blez	a5,80003c2e <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003c0e:	2785                	addiw	a5,a5,1
    80003c10:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003c12:	00015517          	auipc	a0,0x15
    80003c16:	75650513          	addi	a0,a0,1878 # 80019368 <ftable>
    80003c1a:	00003097          	auipc	ra,0x3
    80003c1e:	940080e7          	jalr	-1728(ra) # 8000655a <release>
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
    80003c32:	92a50513          	addi	a0,a0,-1750 # 80008558 <etext+0x558>
    80003c36:	00002097          	auipc	ra,0x2
    80003c3a:	2f6080e7          	jalr	758(ra) # 80005f2c <panic>

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
    80003c4a:	00015517          	auipc	a0,0x15
    80003c4e:	71e50513          	addi	a0,a0,1822 # 80019368 <ftable>
    80003c52:	00003097          	auipc	ra,0x3
    80003c56:	854080e7          	jalr	-1964(ra) # 800064a6 <acquire>
  if(f->ref < 1)
    80003c5a:	40dc                	lw	a5,4(s1)
    80003c5c:	04f05c63          	blez	a5,80003cb4 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003c60:	37fd                	addiw	a5,a5,-1
    80003c62:	0007871b          	sext.w	a4,a5
    80003c66:	c0dc                	sw	a5,4(s1)
    80003c68:	06e04263          	bgtz	a4,80003ccc <fileclose+0x8e>
    80003c6c:	f04a                	sd	s2,32(sp)
    80003c6e:	ec4e                	sd	s3,24(sp)
    80003c70:	e852                	sd	s4,16(sp)
    80003c72:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c74:	0004a903          	lw	s2,0(s1)
    80003c78:	0094ca83          	lbu	s5,9(s1)
    80003c7c:	0104ba03          	ld	s4,16(s1)
    80003c80:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c84:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c88:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c8c:	00015517          	auipc	a0,0x15
    80003c90:	6dc50513          	addi	a0,a0,1756 # 80019368 <ftable>
    80003c94:	00003097          	auipc	ra,0x3
    80003c98:	8c6080e7          	jalr	-1850(ra) # 8000655a <release>

  if(ff.type == FD_PIPE){
    80003c9c:	4785                	li	a5,1
    80003c9e:	04f90463          	beq	s2,a5,80003ce6 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ca2:	3979                	addiw	s2,s2,-2
    80003ca4:	4785                	li	a5,1
    80003ca6:	0527fb63          	bgeu	a5,s2,80003cfc <fileclose+0xbe>
    80003caa:	7902                	ld	s2,32(sp)
    80003cac:	69e2                	ld	s3,24(sp)
    80003cae:	6a42                	ld	s4,16(sp)
    80003cb0:	6aa2                	ld	s5,8(sp)
    80003cb2:	a02d                	j	80003cdc <fileclose+0x9e>
    80003cb4:	f04a                	sd	s2,32(sp)
    80003cb6:	ec4e                	sd	s3,24(sp)
    80003cb8:	e852                	sd	s4,16(sp)
    80003cba:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003cbc:	00005517          	auipc	a0,0x5
    80003cc0:	8a450513          	addi	a0,a0,-1884 # 80008560 <etext+0x560>
    80003cc4:	00002097          	auipc	ra,0x2
    80003cc8:	268080e7          	jalr	616(ra) # 80005f2c <panic>
    release(&ftable.lock);
    80003ccc:	00015517          	auipc	a0,0x15
    80003cd0:	69c50513          	addi	a0,a0,1692 # 80019368 <ftable>
    80003cd4:	00003097          	auipc	ra,0x3
    80003cd8:	886080e7          	jalr	-1914(ra) # 8000655a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003cdc:	70e2                	ld	ra,56(sp)
    80003cde:	7442                	ld	s0,48(sp)
    80003ce0:	74a2                	ld	s1,40(sp)
    80003ce2:	6121                	addi	sp,sp,64
    80003ce4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ce6:	85d6                	mv	a1,s5
    80003ce8:	8552                	mv	a0,s4
    80003cea:	00000097          	auipc	ra,0x0
    80003cee:	3a2080e7          	jalr	930(ra) # 8000408c <pipeclose>
    80003cf2:	7902                	ld	s2,32(sp)
    80003cf4:	69e2                	ld	s3,24(sp)
    80003cf6:	6a42                	ld	s4,16(sp)
    80003cf8:	6aa2                	ld	s5,8(sp)
    80003cfa:	b7cd                	j	80003cdc <fileclose+0x9e>
    begin_op();
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	a78080e7          	jalr	-1416(ra) # 80003774 <begin_op>
    iput(ff.ip);
    80003d04:	854e                	mv	a0,s3
    80003d06:	fffff097          	auipc	ra,0xfffff
    80003d0a:	25a080e7          	jalr	602(ra) # 80002f60 <iput>
    end_op();
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	ae0080e7          	jalr	-1312(ra) # 800037ee <end_op>
    80003d16:	7902                	ld	s2,32(sp)
    80003d18:	69e2                	ld	s3,24(sp)
    80003d1a:	6a42                	ld	s4,16(sp)
    80003d1c:	6aa2                	ld	s5,8(sp)
    80003d1e:	bf7d                	j	80003cdc <fileclose+0x9e>

0000000080003d20 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003d20:	715d                	addi	sp,sp,-80
    80003d22:	e486                	sd	ra,72(sp)
    80003d24:	e0a2                	sd	s0,64(sp)
    80003d26:	fc26                	sd	s1,56(sp)
    80003d28:	f44e                	sd	s3,40(sp)
    80003d2a:	0880                	addi	s0,sp,80
    80003d2c:	84aa                	mv	s1,a0
    80003d2e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d30:	ffffd097          	auipc	ra,0xffffd
    80003d34:	2ac080e7          	jalr	684(ra) # 80000fdc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d38:	409c                	lw	a5,0(s1)
    80003d3a:	37f9                	addiw	a5,a5,-2
    80003d3c:	4705                	li	a4,1
    80003d3e:	04f76863          	bltu	a4,a5,80003d8e <filestat+0x6e>
    80003d42:	f84a                	sd	s2,48(sp)
    80003d44:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d46:	6c88                	ld	a0,24(s1)
    80003d48:	fffff097          	auipc	ra,0xfffff
    80003d4c:	05a080e7          	jalr	90(ra) # 80002da2 <ilock>
    stati(f->ip, &st);
    80003d50:	fb840593          	addi	a1,s0,-72
    80003d54:	6c88                	ld	a0,24(s1)
    80003d56:	fffff097          	auipc	ra,0xfffff
    80003d5a:	2da080e7          	jalr	730(ra) # 80003030 <stati>
    iunlock(f->ip);
    80003d5e:	6c88                	ld	a0,24(s1)
    80003d60:	fffff097          	auipc	ra,0xfffff
    80003d64:	108080e7          	jalr	264(ra) # 80002e68 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d68:	46e1                	li	a3,24
    80003d6a:	fb840613          	addi	a2,s0,-72
    80003d6e:	85ce                	mv	a1,s3
    80003d70:	05093503          	ld	a0,80(s2)
    80003d74:	ffffd097          	auipc	ra,0xffffd
    80003d78:	da4080e7          	jalr	-604(ra) # 80000b18 <copyout>
    80003d7c:	41f5551b          	sraiw	a0,a0,0x1f
    80003d80:	7942                	ld	s2,48(sp)
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
    80003d90:	bfcd                	j	80003d82 <filestat+0x62>

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
    80003dc6:	fe0080e7          	jalr	-32(ra) # 80002da2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003dca:	874a                	mv	a4,s2
    80003dcc:	5094                	lw	a3,32(s1)
    80003dce:	864e                	mv	a2,s3
    80003dd0:	4585                	li	a1,1
    80003dd2:	6c88                	ld	a0,24(s1)
    80003dd4:	fffff097          	auipc	ra,0xfffff
    80003dd8:	286080e7          	jalr	646(ra) # 8000305a <readi>
    80003ddc:	892a                	mv	s2,a0
    80003dde:	00a05563          	blez	a0,80003de8 <fileread+0x56>
      f->off += r;
    80003de2:	509c                	lw	a5,32(s1)
    80003de4:	9fa9                	addw	a5,a5,a0
    80003de6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003de8:	6c88                	ld	a0,24(s1)
    80003dea:	fffff097          	auipc	ra,0xfffff
    80003dee:	07e080e7          	jalr	126(ra) # 80002e68 <iunlock>
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
    80003e08:	3fa080e7          	jalr	1018(ra) # 800041fe <piperead>
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
    80003e26:	00015717          	auipc	a4,0x15
    80003e2a:	4a270713          	addi	a4,a4,1186 # 800192c8 <devsw>
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
    80003e44:	73050513          	addi	a0,a0,1840 # 80008570 <etext+0x570>
    80003e48:	00002097          	auipc	ra,0x2
    80003e4c:	0e4080e7          	jalr	228(ra) # 80005f2c <panic>
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
    80003e68:	12078963          	beqz	a5,80003f9a <filewrite+0x136>
{
    80003e6c:	715d                	addi	sp,sp,-80
    80003e6e:	e486                	sd	ra,72(sp)
    80003e70:	e0a2                	sd	s0,64(sp)
    80003e72:	f84a                	sd	s2,48(sp)
    80003e74:	f052                	sd	s4,32(sp)
    80003e76:	e85a                	sd	s6,16(sp)
    80003e78:	0880                	addi	s0,sp,80
    80003e7a:	892a                	mv	s2,a0
    80003e7c:	8b2e                	mv	s6,a1
    80003e7e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e80:	411c                	lw	a5,0(a0)
    80003e82:	4705                	li	a4,1
    80003e84:	02e78763          	beq	a5,a4,80003eb2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e88:	470d                	li	a4,3
    80003e8a:	02e78a63          	beq	a5,a4,80003ebe <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e8e:	4709                	li	a4,2
    80003e90:	0ee79863          	bne	a5,a4,80003f80 <filewrite+0x11c>
    80003e94:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e96:	0cc05463          	blez	a2,80003f5e <filewrite+0xfa>
    80003e9a:	fc26                	sd	s1,56(sp)
    80003e9c:	ec56                	sd	s5,24(sp)
    80003e9e:	e45e                	sd	s7,8(sp)
    80003ea0:	e062                	sd	s8,0(sp)
    int i = 0;
    80003ea2:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003ea4:	6b85                	lui	s7,0x1
    80003ea6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003eaa:	6c05                	lui	s8,0x1
    80003eac:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003eb0:	a851                	j	80003f44 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003eb2:	6908                	ld	a0,16(a0)
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	248080e7          	jalr	584(ra) # 800040fc <pipewrite>
    80003ebc:	a85d                	j	80003f72 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ebe:	02451783          	lh	a5,36(a0)
    80003ec2:	03079693          	slli	a3,a5,0x30
    80003ec6:	92c1                	srli	a3,a3,0x30
    80003ec8:	4725                	li	a4,9
    80003eca:	0cd76a63          	bltu	a4,a3,80003f9e <filewrite+0x13a>
    80003ece:	0792                	slli	a5,a5,0x4
    80003ed0:	00015717          	auipc	a4,0x15
    80003ed4:	3f870713          	addi	a4,a4,1016 # 800192c8 <devsw>
    80003ed8:	97ba                	add	a5,a5,a4
    80003eda:	679c                	ld	a5,8(a5)
    80003edc:	c3f9                	beqz	a5,80003fa2 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003ede:	4505                	li	a0,1
    80003ee0:	9782                	jalr	a5
    80003ee2:	a841                	j	80003f72 <filewrite+0x10e>
      if(n1 > max)
    80003ee4:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003ee8:	00000097          	auipc	ra,0x0
    80003eec:	88c080e7          	jalr	-1908(ra) # 80003774 <begin_op>
      ilock(f->ip);
    80003ef0:	01893503          	ld	a0,24(s2)
    80003ef4:	fffff097          	auipc	ra,0xfffff
    80003ef8:	eae080e7          	jalr	-338(ra) # 80002da2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003efc:	8756                	mv	a4,s5
    80003efe:	02092683          	lw	a3,32(s2)
    80003f02:	01698633          	add	a2,s3,s6
    80003f06:	4585                	li	a1,1
    80003f08:	01893503          	ld	a0,24(s2)
    80003f0c:	fffff097          	auipc	ra,0xfffff
    80003f10:	252080e7          	jalr	594(ra) # 8000315e <writei>
    80003f14:	84aa                	mv	s1,a0
    80003f16:	00a05763          	blez	a0,80003f24 <filewrite+0xc0>
        f->off += r;
    80003f1a:	02092783          	lw	a5,32(s2)
    80003f1e:	9fa9                	addw	a5,a5,a0
    80003f20:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f24:	01893503          	ld	a0,24(s2)
    80003f28:	fffff097          	auipc	ra,0xfffff
    80003f2c:	f40080e7          	jalr	-192(ra) # 80002e68 <iunlock>
      end_op();
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	8be080e7          	jalr	-1858(ra) # 800037ee <end_op>

      if(r != n1){
    80003f38:	029a9563          	bne	s5,s1,80003f62 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003f3c:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f40:	0149da63          	bge	s3,s4,80003f54 <filewrite+0xf0>
      int n1 = n - i;
    80003f44:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f48:	0004879b          	sext.w	a5,s1
    80003f4c:	f8fbdce3          	bge	s7,a5,80003ee4 <filewrite+0x80>
    80003f50:	84e2                	mv	s1,s8
    80003f52:	bf49                	j	80003ee4 <filewrite+0x80>
    80003f54:	74e2                	ld	s1,56(sp)
    80003f56:	6ae2                	ld	s5,24(sp)
    80003f58:	6ba2                	ld	s7,8(sp)
    80003f5a:	6c02                	ld	s8,0(sp)
    80003f5c:	a039                	j	80003f6a <filewrite+0x106>
    int i = 0;
    80003f5e:	4981                	li	s3,0
    80003f60:	a029                	j	80003f6a <filewrite+0x106>
    80003f62:	74e2                	ld	s1,56(sp)
    80003f64:	6ae2                	ld	s5,24(sp)
    80003f66:	6ba2                	ld	s7,8(sp)
    80003f68:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003f6a:	033a1e63          	bne	s4,s3,80003fa6 <filewrite+0x142>
    80003f6e:	8552                	mv	a0,s4
    80003f70:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f72:	60a6                	ld	ra,72(sp)
    80003f74:	6406                	ld	s0,64(sp)
    80003f76:	7942                	ld	s2,48(sp)
    80003f78:	7a02                	ld	s4,32(sp)
    80003f7a:	6b42                	ld	s6,16(sp)
    80003f7c:	6161                	addi	sp,sp,80
    80003f7e:	8082                	ret
    80003f80:	fc26                	sd	s1,56(sp)
    80003f82:	f44e                	sd	s3,40(sp)
    80003f84:	ec56                	sd	s5,24(sp)
    80003f86:	e45e                	sd	s7,8(sp)
    80003f88:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003f8a:	00004517          	auipc	a0,0x4
    80003f8e:	5f650513          	addi	a0,a0,1526 # 80008580 <etext+0x580>
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	f9a080e7          	jalr	-102(ra) # 80005f2c <panic>
    return -1;
    80003f9a:	557d                	li	a0,-1
}
    80003f9c:	8082                	ret
      return -1;
    80003f9e:	557d                	li	a0,-1
    80003fa0:	bfc9                	j	80003f72 <filewrite+0x10e>
    80003fa2:	557d                	li	a0,-1
    80003fa4:	b7f9                	j	80003f72 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003fa6:	557d                	li	a0,-1
    80003fa8:	79a2                	ld	s3,40(sp)
    80003faa:	b7e1                	j	80003f72 <filewrite+0x10e>

0000000080003fac <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003fac:	7179                	addi	sp,sp,-48
    80003fae:	f406                	sd	ra,40(sp)
    80003fb0:	f022                	sd	s0,32(sp)
    80003fb2:	ec26                	sd	s1,24(sp)
    80003fb4:	e052                	sd	s4,0(sp)
    80003fb6:	1800                	addi	s0,sp,48
    80003fb8:	84aa                	mv	s1,a0
    80003fba:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fbc:	0005b023          	sd	zero,0(a1)
    80003fc0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fc4:	00000097          	auipc	ra,0x0
    80003fc8:	bbe080e7          	jalr	-1090(ra) # 80003b82 <filealloc>
    80003fcc:	e088                	sd	a0,0(s1)
    80003fce:	cd49                	beqz	a0,80004068 <pipealloc+0xbc>
    80003fd0:	00000097          	auipc	ra,0x0
    80003fd4:	bb2080e7          	jalr	-1102(ra) # 80003b82 <filealloc>
    80003fd8:	00aa3023          	sd	a0,0(s4)
    80003fdc:	c141                	beqz	a0,8000405c <pipealloc+0xb0>
    80003fde:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fe0:	ffffc097          	auipc	ra,0xffffc
    80003fe4:	13a080e7          	jalr	314(ra) # 8000011a <kalloc>
    80003fe8:	892a                	mv	s2,a0
    80003fea:	c13d                	beqz	a0,80004050 <pipealloc+0xa4>
    80003fec:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003fee:	4985                	li	s3,1
    80003ff0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ff4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ff8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003ffc:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004000:	00004597          	auipc	a1,0x4
    80004004:	59058593          	addi	a1,a1,1424 # 80008590 <etext+0x590>
    80004008:	00002097          	auipc	ra,0x2
    8000400c:	40e080e7          	jalr	1038(ra) # 80006416 <initlock>
  (*f0)->type = FD_PIPE;
    80004010:	609c                	ld	a5,0(s1)
    80004012:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004016:	609c                	ld	a5,0(s1)
    80004018:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000401c:	609c                	ld	a5,0(s1)
    8000401e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004022:	609c                	ld	a5,0(s1)
    80004024:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004028:	000a3783          	ld	a5,0(s4)
    8000402c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004030:	000a3783          	ld	a5,0(s4)
    80004034:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004038:	000a3783          	ld	a5,0(s4)
    8000403c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004040:	000a3783          	ld	a5,0(s4)
    80004044:	0127b823          	sd	s2,16(a5)
  return 0;
    80004048:	4501                	li	a0,0
    8000404a:	6942                	ld	s2,16(sp)
    8000404c:	69a2                	ld	s3,8(sp)
    8000404e:	a03d                	j	8000407c <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004050:	6088                	ld	a0,0(s1)
    80004052:	c119                	beqz	a0,80004058 <pipealloc+0xac>
    80004054:	6942                	ld	s2,16(sp)
    80004056:	a029                	j	80004060 <pipealloc+0xb4>
    80004058:	6942                	ld	s2,16(sp)
    8000405a:	a039                	j	80004068 <pipealloc+0xbc>
    8000405c:	6088                	ld	a0,0(s1)
    8000405e:	c50d                	beqz	a0,80004088 <pipealloc+0xdc>
    fileclose(*f0);
    80004060:	00000097          	auipc	ra,0x0
    80004064:	bde080e7          	jalr	-1058(ra) # 80003c3e <fileclose>
  if(*f1)
    80004068:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000406c:	557d                	li	a0,-1
  if(*f1)
    8000406e:	c799                	beqz	a5,8000407c <pipealloc+0xd0>
    fileclose(*f1);
    80004070:	853e                	mv	a0,a5
    80004072:	00000097          	auipc	ra,0x0
    80004076:	bcc080e7          	jalr	-1076(ra) # 80003c3e <fileclose>
  return -1;
    8000407a:	557d                	li	a0,-1
}
    8000407c:	70a2                	ld	ra,40(sp)
    8000407e:	7402                	ld	s0,32(sp)
    80004080:	64e2                	ld	s1,24(sp)
    80004082:	6a02                	ld	s4,0(sp)
    80004084:	6145                	addi	sp,sp,48
    80004086:	8082                	ret
  return -1;
    80004088:	557d                	li	a0,-1
    8000408a:	bfcd                	j	8000407c <pipealloc+0xd0>

000000008000408c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000408c:	1101                	addi	sp,sp,-32
    8000408e:	ec06                	sd	ra,24(sp)
    80004090:	e822                	sd	s0,16(sp)
    80004092:	e426                	sd	s1,8(sp)
    80004094:	e04a                	sd	s2,0(sp)
    80004096:	1000                	addi	s0,sp,32
    80004098:	84aa                	mv	s1,a0
    8000409a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000409c:	00002097          	auipc	ra,0x2
    800040a0:	40a080e7          	jalr	1034(ra) # 800064a6 <acquire>
  if(writable){
    800040a4:	02090d63          	beqz	s2,800040de <pipeclose+0x52>
    pi->writeopen = 0;
    800040a8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800040ac:	21848513          	addi	a0,s1,536
    800040b0:	ffffe097          	auipc	ra,0xffffe
    800040b4:	802080e7          	jalr	-2046(ra) # 800018b2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800040b8:	2204b783          	ld	a5,544(s1)
    800040bc:	eb95                	bnez	a5,800040f0 <pipeclose+0x64>
    release(&pi->lock);
    800040be:	8526                	mv	a0,s1
    800040c0:	00002097          	auipc	ra,0x2
    800040c4:	49a080e7          	jalr	1178(ra) # 8000655a <release>
    kfree((char*)pi);
    800040c8:	8526                	mv	a0,s1
    800040ca:	ffffc097          	auipc	ra,0xffffc
    800040ce:	f52080e7          	jalr	-174(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800040d2:	60e2                	ld	ra,24(sp)
    800040d4:	6442                	ld	s0,16(sp)
    800040d6:	64a2                	ld	s1,8(sp)
    800040d8:	6902                	ld	s2,0(sp)
    800040da:	6105                	addi	sp,sp,32
    800040dc:	8082                	ret
    pi->readopen = 0;
    800040de:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040e2:	21c48513          	addi	a0,s1,540
    800040e6:	ffffd097          	auipc	ra,0xffffd
    800040ea:	7cc080e7          	jalr	1996(ra) # 800018b2 <wakeup>
    800040ee:	b7e9                	j	800040b8 <pipeclose+0x2c>
    release(&pi->lock);
    800040f0:	8526                	mv	a0,s1
    800040f2:	00002097          	auipc	ra,0x2
    800040f6:	468080e7          	jalr	1128(ra) # 8000655a <release>
}
    800040fa:	bfe1                	j	800040d2 <pipeclose+0x46>

00000000800040fc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040fc:	711d                	addi	sp,sp,-96
    800040fe:	ec86                	sd	ra,88(sp)
    80004100:	e8a2                	sd	s0,80(sp)
    80004102:	e4a6                	sd	s1,72(sp)
    80004104:	e0ca                	sd	s2,64(sp)
    80004106:	fc4e                	sd	s3,56(sp)
    80004108:	f852                	sd	s4,48(sp)
    8000410a:	f456                	sd	s5,40(sp)
    8000410c:	1080                	addi	s0,sp,96
    8000410e:	84aa                	mv	s1,a0
    80004110:	8aae                	mv	s5,a1
    80004112:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004114:	ffffd097          	auipc	ra,0xffffd
    80004118:	ec8080e7          	jalr	-312(ra) # 80000fdc <myproc>
    8000411c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000411e:	8526                	mv	a0,s1
    80004120:	00002097          	auipc	ra,0x2
    80004124:	386080e7          	jalr	902(ra) # 800064a6 <acquire>
  while(i < n){
    80004128:	0d405563          	blez	s4,800041f2 <pipewrite+0xf6>
    8000412c:	f05a                	sd	s6,32(sp)
    8000412e:	ec5e                	sd	s7,24(sp)
    80004130:	e862                	sd	s8,16(sp)
  int i = 0;
    80004132:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004134:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004136:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000413a:	21c48b93          	addi	s7,s1,540
    8000413e:	a089                	j	80004180 <pipewrite+0x84>
      release(&pi->lock);
    80004140:	8526                	mv	a0,s1
    80004142:	00002097          	auipc	ra,0x2
    80004146:	418080e7          	jalr	1048(ra) # 8000655a <release>
      return -1;
    8000414a:	597d                	li	s2,-1
    8000414c:	7b02                	ld	s6,32(sp)
    8000414e:	6be2                	ld	s7,24(sp)
    80004150:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004152:	854a                	mv	a0,s2
    80004154:	60e6                	ld	ra,88(sp)
    80004156:	6446                	ld	s0,80(sp)
    80004158:	64a6                	ld	s1,72(sp)
    8000415a:	6906                	ld	s2,64(sp)
    8000415c:	79e2                	ld	s3,56(sp)
    8000415e:	7a42                	ld	s4,48(sp)
    80004160:	7aa2                	ld	s5,40(sp)
    80004162:	6125                	addi	sp,sp,96
    80004164:	8082                	ret
      wakeup(&pi->nread);
    80004166:	8562                	mv	a0,s8
    80004168:	ffffd097          	auipc	ra,0xffffd
    8000416c:	74a080e7          	jalr	1866(ra) # 800018b2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004170:	85a6                	mv	a1,s1
    80004172:	855e                	mv	a0,s7
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	5b2080e7          	jalr	1458(ra) # 80001726 <sleep>
  while(i < n){
    8000417c:	05495c63          	bge	s2,s4,800041d4 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004180:	2204a783          	lw	a5,544(s1)
    80004184:	dfd5                	beqz	a5,80004140 <pipewrite+0x44>
    80004186:	0289a783          	lw	a5,40(s3)
    8000418a:	fbdd                	bnez	a5,80004140 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000418c:	2184a783          	lw	a5,536(s1)
    80004190:	21c4a703          	lw	a4,540(s1)
    80004194:	2007879b          	addiw	a5,a5,512
    80004198:	fcf707e3          	beq	a4,a5,80004166 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000419c:	4685                	li	a3,1
    8000419e:	01590633          	add	a2,s2,s5
    800041a2:	faf40593          	addi	a1,s0,-81
    800041a6:	0509b503          	ld	a0,80(s3)
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	9fa080e7          	jalr	-1542(ra) # 80000ba4 <copyin>
    800041b2:	05650263          	beq	a0,s6,800041f6 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041b6:	21c4a783          	lw	a5,540(s1)
    800041ba:	0017871b          	addiw	a4,a5,1
    800041be:	20e4ae23          	sw	a4,540(s1)
    800041c2:	1ff7f793          	andi	a5,a5,511
    800041c6:	97a6                	add	a5,a5,s1
    800041c8:	faf44703          	lbu	a4,-81(s0)
    800041cc:	00e78c23          	sb	a4,24(a5)
      i++;
    800041d0:	2905                	addiw	s2,s2,1
    800041d2:	b76d                	j	8000417c <pipewrite+0x80>
    800041d4:	7b02                	ld	s6,32(sp)
    800041d6:	6be2                	ld	s7,24(sp)
    800041d8:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800041da:	21848513          	addi	a0,s1,536
    800041de:	ffffd097          	auipc	ra,0xffffd
    800041e2:	6d4080e7          	jalr	1748(ra) # 800018b2 <wakeup>
  release(&pi->lock);
    800041e6:	8526                	mv	a0,s1
    800041e8:	00002097          	auipc	ra,0x2
    800041ec:	372080e7          	jalr	882(ra) # 8000655a <release>
  return i;
    800041f0:	b78d                	j	80004152 <pipewrite+0x56>
  int i = 0;
    800041f2:	4901                	li	s2,0
    800041f4:	b7dd                	j	800041da <pipewrite+0xde>
    800041f6:	7b02                	ld	s6,32(sp)
    800041f8:	6be2                	ld	s7,24(sp)
    800041fa:	6c42                	ld	s8,16(sp)
    800041fc:	bff9                	j	800041da <pipewrite+0xde>

00000000800041fe <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041fe:	715d                	addi	sp,sp,-80
    80004200:	e486                	sd	ra,72(sp)
    80004202:	e0a2                	sd	s0,64(sp)
    80004204:	fc26                	sd	s1,56(sp)
    80004206:	f84a                	sd	s2,48(sp)
    80004208:	f44e                	sd	s3,40(sp)
    8000420a:	f052                	sd	s4,32(sp)
    8000420c:	ec56                	sd	s5,24(sp)
    8000420e:	0880                	addi	s0,sp,80
    80004210:	84aa                	mv	s1,a0
    80004212:	892e                	mv	s2,a1
    80004214:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	dc6080e7          	jalr	-570(ra) # 80000fdc <myproc>
    8000421e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004220:	8526                	mv	a0,s1
    80004222:	00002097          	auipc	ra,0x2
    80004226:	284080e7          	jalr	644(ra) # 800064a6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000422a:	2184a703          	lw	a4,536(s1)
    8000422e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004232:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004236:	02f71663          	bne	a4,a5,80004262 <piperead+0x64>
    8000423a:	2244a783          	lw	a5,548(s1)
    8000423e:	cb9d                	beqz	a5,80004274 <piperead+0x76>
    if(pr->killed){
    80004240:	028a2783          	lw	a5,40(s4)
    80004244:	e38d                	bnez	a5,80004266 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004246:	85a6                	mv	a1,s1
    80004248:	854e                	mv	a0,s3
    8000424a:	ffffd097          	auipc	ra,0xffffd
    8000424e:	4dc080e7          	jalr	1244(ra) # 80001726 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004252:	2184a703          	lw	a4,536(s1)
    80004256:	21c4a783          	lw	a5,540(s1)
    8000425a:	fef700e3          	beq	a4,a5,8000423a <piperead+0x3c>
    8000425e:	e85a                	sd	s6,16(sp)
    80004260:	a819                	j	80004276 <piperead+0x78>
    80004262:	e85a                	sd	s6,16(sp)
    80004264:	a809                	j	80004276 <piperead+0x78>
      release(&pi->lock);
    80004266:	8526                	mv	a0,s1
    80004268:	00002097          	auipc	ra,0x2
    8000426c:	2f2080e7          	jalr	754(ra) # 8000655a <release>
      return -1;
    80004270:	59fd                	li	s3,-1
    80004272:	a0a5                	j	800042da <piperead+0xdc>
    80004274:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004276:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004278:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000427a:	05505463          	blez	s5,800042c2 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    8000427e:	2184a783          	lw	a5,536(s1)
    80004282:	21c4a703          	lw	a4,540(s1)
    80004286:	02f70e63          	beq	a4,a5,800042c2 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000428a:	0017871b          	addiw	a4,a5,1
    8000428e:	20e4ac23          	sw	a4,536(s1)
    80004292:	1ff7f793          	andi	a5,a5,511
    80004296:	97a6                	add	a5,a5,s1
    80004298:	0187c783          	lbu	a5,24(a5)
    8000429c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042a0:	4685                	li	a3,1
    800042a2:	fbf40613          	addi	a2,s0,-65
    800042a6:	85ca                	mv	a1,s2
    800042a8:	050a3503          	ld	a0,80(s4)
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	86c080e7          	jalr	-1940(ra) # 80000b18 <copyout>
    800042b4:	01650763          	beq	a0,s6,800042c2 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042b8:	2985                	addiw	s3,s3,1
    800042ba:	0905                	addi	s2,s2,1
    800042bc:	fd3a91e3          	bne	s5,s3,8000427e <piperead+0x80>
    800042c0:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042c2:	21c48513          	addi	a0,s1,540
    800042c6:	ffffd097          	auipc	ra,0xffffd
    800042ca:	5ec080e7          	jalr	1516(ra) # 800018b2 <wakeup>
  release(&pi->lock);
    800042ce:	8526                	mv	a0,s1
    800042d0:	00002097          	auipc	ra,0x2
    800042d4:	28a080e7          	jalr	650(ra) # 8000655a <release>
    800042d8:	6b42                	ld	s6,16(sp)
  return i;
}
    800042da:	854e                	mv	a0,s3
    800042dc:	60a6                	ld	ra,72(sp)
    800042de:	6406                	ld	s0,64(sp)
    800042e0:	74e2                	ld	s1,56(sp)
    800042e2:	7942                	ld	s2,48(sp)
    800042e4:	79a2                	ld	s3,40(sp)
    800042e6:	7a02                	ld	s4,32(sp)
    800042e8:	6ae2                	ld	s5,24(sp)
    800042ea:	6161                	addi	sp,sp,80
    800042ec:	8082                	ret

00000000800042ee <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042ee:	df010113          	addi	sp,sp,-528
    800042f2:	20113423          	sd	ra,520(sp)
    800042f6:	20813023          	sd	s0,512(sp)
    800042fa:	ffa6                	sd	s1,504(sp)
    800042fc:	fbca                	sd	s2,496(sp)
    800042fe:	0c00                	addi	s0,sp,528
    80004300:	892a                	mv	s2,a0
    80004302:	dea43c23          	sd	a0,-520(s0)
    80004306:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000430a:	ffffd097          	auipc	ra,0xffffd
    8000430e:	cd2080e7          	jalr	-814(ra) # 80000fdc <myproc>
    80004312:	84aa                	mv	s1,a0

  begin_op();
    80004314:	fffff097          	auipc	ra,0xfffff
    80004318:	460080e7          	jalr	1120(ra) # 80003774 <begin_op>

  if((ip = namei(path)) == 0){
    8000431c:	854a                	mv	a0,s2
    8000431e:	fffff097          	auipc	ra,0xfffff
    80004322:	256080e7          	jalr	598(ra) # 80003574 <namei>
    80004326:	c135                	beqz	a0,8000438a <exec+0x9c>
    80004328:	f3d2                	sd	s4,480(sp)
    8000432a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000432c:	fffff097          	auipc	ra,0xfffff
    80004330:	a76080e7          	jalr	-1418(ra) # 80002da2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004334:	04000713          	li	a4,64
    80004338:	4681                	li	a3,0
    8000433a:	e5040613          	addi	a2,s0,-432
    8000433e:	4581                	li	a1,0
    80004340:	8552                	mv	a0,s4
    80004342:	fffff097          	auipc	ra,0xfffff
    80004346:	d18080e7          	jalr	-744(ra) # 8000305a <readi>
    8000434a:	04000793          	li	a5,64
    8000434e:	00f51a63          	bne	a0,a5,80004362 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004352:	e5042703          	lw	a4,-432(s0)
    80004356:	464c47b7          	lui	a5,0x464c4
    8000435a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000435e:	02f70c63          	beq	a4,a5,80004396 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004362:	8552                	mv	a0,s4
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	ca4080e7          	jalr	-860(ra) # 80003008 <iunlockput>
    end_op();
    8000436c:	fffff097          	auipc	ra,0xfffff
    80004370:	482080e7          	jalr	1154(ra) # 800037ee <end_op>
  }
  return -1;
    80004374:	557d                	li	a0,-1
    80004376:	7a1e                	ld	s4,480(sp)
}
    80004378:	20813083          	ld	ra,520(sp)
    8000437c:	20013403          	ld	s0,512(sp)
    80004380:	74fe                	ld	s1,504(sp)
    80004382:	795e                	ld	s2,496(sp)
    80004384:	21010113          	addi	sp,sp,528
    80004388:	8082                	ret
    end_op();
    8000438a:	fffff097          	auipc	ra,0xfffff
    8000438e:	464080e7          	jalr	1124(ra) # 800037ee <end_op>
    return -1;
    80004392:	557d                	li	a0,-1
    80004394:	b7d5                	j	80004378 <exec+0x8a>
    80004396:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004398:	8526                	mv	a0,s1
    8000439a:	ffffd097          	auipc	ra,0xffffd
    8000439e:	d06080e7          	jalr	-762(ra) # 800010a0 <proc_pagetable>
    800043a2:	8b2a                	mv	s6,a0
    800043a4:	32050163          	beqz	a0,800046c6 <exec+0x3d8>
    800043a8:	f7ce                	sd	s3,488(sp)
    800043aa:	efd6                	sd	s5,472(sp)
    800043ac:	e7de                	sd	s7,456(sp)
    800043ae:	e3e2                	sd	s8,448(sp)
    800043b0:	ff66                	sd	s9,440(sp)
    800043b2:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043b4:	e7042d03          	lw	s10,-400(s0)
    800043b8:	e8845783          	lhu	a5,-376(s0)
    800043bc:	14078563          	beqz	a5,80004506 <exec+0x218>
    800043c0:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043c2:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043c4:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    800043c6:	6c85                	lui	s9,0x1
    800043c8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043cc:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800043d0:	6a85                	lui	s5,0x1
    800043d2:	a0b5                	j	8000443e <exec+0x150>
      panic("loadseg: address should exist");
    800043d4:	00004517          	auipc	a0,0x4
    800043d8:	1c450513          	addi	a0,a0,452 # 80008598 <etext+0x598>
    800043dc:	00002097          	auipc	ra,0x2
    800043e0:	b50080e7          	jalr	-1200(ra) # 80005f2c <panic>
    if(sz - i < PGSIZE)
    800043e4:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043e6:	8726                	mv	a4,s1
    800043e8:	012c06bb          	addw	a3,s8,s2
    800043ec:	4581                	li	a1,0
    800043ee:	8552                	mv	a0,s4
    800043f0:	fffff097          	auipc	ra,0xfffff
    800043f4:	c6a080e7          	jalr	-918(ra) # 8000305a <readi>
    800043f8:	2501                	sext.w	a0,a0
    800043fa:	28a49a63          	bne	s1,a0,8000468e <exec+0x3a0>
  for(i = 0; i < sz; i += PGSIZE){
    800043fe:	012a893b          	addw	s2,s5,s2
    80004402:	03397563          	bgeu	s2,s3,8000442c <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004406:	02091593          	slli	a1,s2,0x20
    8000440a:	9181                	srli	a1,a1,0x20
    8000440c:	95de                	add	a1,a1,s7
    8000440e:	855a                	mv	a0,s6
    80004410:	ffffc097          	auipc	ra,0xffffc
    80004414:	0e8080e7          	jalr	232(ra) # 800004f8 <walkaddr>
    80004418:	862a                	mv	a2,a0
    if(pa == 0)
    8000441a:	dd4d                	beqz	a0,800043d4 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000441c:	412984bb          	subw	s1,s3,s2
    80004420:	0004879b          	sext.w	a5,s1
    80004424:	fcfcf0e3          	bgeu	s9,a5,800043e4 <exec+0xf6>
    80004428:	84d6                	mv	s1,s5
    8000442a:	bf6d                	j	800043e4 <exec+0xf6>
    sz = sz1;
    8000442c:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004430:	2d85                	addiw	s11,s11,1
    80004432:	038d0d1b          	addiw	s10,s10,56
    80004436:	e8845783          	lhu	a5,-376(s0)
    8000443a:	06fddf63          	bge	s11,a5,800044b8 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000443e:	2d01                	sext.w	s10,s10
    80004440:	03800713          	li	a4,56
    80004444:	86ea                	mv	a3,s10
    80004446:	e1840613          	addi	a2,s0,-488
    8000444a:	4581                	li	a1,0
    8000444c:	8552                	mv	a0,s4
    8000444e:	fffff097          	auipc	ra,0xfffff
    80004452:	c0c080e7          	jalr	-1012(ra) # 8000305a <readi>
    80004456:	03800793          	li	a5,56
    8000445a:	20f51463          	bne	a0,a5,80004662 <exec+0x374>
    if(ph.type != ELF_PROG_LOAD)
    8000445e:	e1842783          	lw	a5,-488(s0)
    80004462:	4705                	li	a4,1
    80004464:	fce796e3          	bne	a5,a4,80004430 <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004468:	e4043603          	ld	a2,-448(s0)
    8000446c:	e3843783          	ld	a5,-456(s0)
    80004470:	1ef66d63          	bltu	a2,a5,8000466a <exec+0x37c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004474:	e2843783          	ld	a5,-472(s0)
    80004478:	963e                	add	a2,a2,a5
    8000447a:	1ef66c63          	bltu	a2,a5,80004672 <exec+0x384>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000447e:	85a6                	mv	a1,s1
    80004480:	855a                	mv	a0,s6
    80004482:	ffffc097          	auipc	ra,0xffffc
    80004486:	43a080e7          	jalr	1082(ra) # 800008bc <uvmalloc>
    8000448a:	e0a43423          	sd	a0,-504(s0)
    8000448e:	1e050663          	beqz	a0,8000467a <exec+0x38c>
    if((ph.vaddr % PGSIZE) != 0)
    80004492:	e2843b83          	ld	s7,-472(s0)
    80004496:	df043783          	ld	a5,-528(s0)
    8000449a:	00fbf7b3          	and	a5,s7,a5
    8000449e:	1e079663          	bnez	a5,8000468a <exec+0x39c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044a2:	e2042c03          	lw	s8,-480(s0)
    800044a6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044aa:	00098463          	beqz	s3,800044b2 <exec+0x1c4>
    800044ae:	4901                	li	s2,0
    800044b0:	bf99                	j	80004406 <exec+0x118>
    sz = sz1;
    800044b2:	e0843483          	ld	s1,-504(s0)
    800044b6:	bfad                	j	80004430 <exec+0x142>
    800044b8:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800044ba:	8552                	mv	a0,s4
    800044bc:	fffff097          	auipc	ra,0xfffff
    800044c0:	b4c080e7          	jalr	-1204(ra) # 80003008 <iunlockput>
  end_op();
    800044c4:	fffff097          	auipc	ra,0xfffff
    800044c8:	32a080e7          	jalr	810(ra) # 800037ee <end_op>
  p = myproc();
    800044cc:	ffffd097          	auipc	ra,0xffffd
    800044d0:	b10080e7          	jalr	-1264(ra) # 80000fdc <myproc>
    800044d4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800044d6:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800044da:	6985                	lui	s3,0x1
    800044dc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800044de:	99a6                	add	s3,s3,s1
    800044e0:	77fd                	lui	a5,0xfffff
    800044e2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044e6:	6609                	lui	a2,0x2
    800044e8:	964e                	add	a2,a2,s3
    800044ea:	85ce                	mv	a1,s3
    800044ec:	855a                	mv	a0,s6
    800044ee:	ffffc097          	auipc	ra,0xffffc
    800044f2:	3ce080e7          	jalr	974(ra) # 800008bc <uvmalloc>
    800044f6:	892a                	mv	s2,a0
    800044f8:	e0a43423          	sd	a0,-504(s0)
    800044fc:	e519                	bnez	a0,8000450a <exec+0x21c>
  if(pagetable)
    800044fe:	e1343423          	sd	s3,-504(s0)
    80004502:	4a01                	li	s4,0
    80004504:	a271                	j	80004690 <exec+0x3a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004506:	4481                	li	s1,0
    80004508:	bf4d                	j	800044ba <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000450a:	75f9                	lui	a1,0xffffe
    8000450c:	95aa                	add	a1,a1,a0
    8000450e:	855a                	mv	a0,s6
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	5d6080e7          	jalr	1494(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004518:	7bfd                	lui	s7,0xfffff
    8000451a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000451c:	e0043783          	ld	a5,-512(s0)
    80004520:	6388                	ld	a0,0(a5)
    80004522:	c52d                	beqz	a0,8000458c <exec+0x29e>
    80004524:	e9040993          	addi	s3,s0,-368
    80004528:	f9040c13          	addi	s8,s0,-112
    8000452c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000452e:	ffffc097          	auipc	ra,0xffffc
    80004532:	dc0080e7          	jalr	-576(ra) # 800002ee <strlen>
    80004536:	0015079b          	addiw	a5,a0,1
    8000453a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000453e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004542:	15796063          	bltu	s2,s7,80004682 <exec+0x394>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004546:	e0043d03          	ld	s10,-512(s0)
    8000454a:	000d3a03          	ld	s4,0(s10)
    8000454e:	8552                	mv	a0,s4
    80004550:	ffffc097          	auipc	ra,0xffffc
    80004554:	d9e080e7          	jalr	-610(ra) # 800002ee <strlen>
    80004558:	0015069b          	addiw	a3,a0,1
    8000455c:	8652                	mv	a2,s4
    8000455e:	85ca                	mv	a1,s2
    80004560:	855a                	mv	a0,s6
    80004562:	ffffc097          	auipc	ra,0xffffc
    80004566:	5b6080e7          	jalr	1462(ra) # 80000b18 <copyout>
    8000456a:	10054e63          	bltz	a0,80004686 <exec+0x398>
    ustack[argc] = sp;
    8000456e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004572:	0485                	addi	s1,s1,1
    80004574:	008d0793          	addi	a5,s10,8
    80004578:	e0f43023          	sd	a5,-512(s0)
    8000457c:	008d3503          	ld	a0,8(s10)
    80004580:	c909                	beqz	a0,80004592 <exec+0x2a4>
    if(argc >= MAXARG)
    80004582:	09a1                	addi	s3,s3,8
    80004584:	fb8995e3          	bne	s3,s8,8000452e <exec+0x240>
  ip = 0;
    80004588:	4a01                	li	s4,0
    8000458a:	a219                	j	80004690 <exec+0x3a2>
  sp = sz;
    8000458c:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004590:	4481                	li	s1,0
  ustack[argc] = 0;
    80004592:	00349793          	slli	a5,s1,0x3
    80004596:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    8000459a:	97a2                	add	a5,a5,s0
    8000459c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800045a0:	00148693          	addi	a3,s1,1
    800045a4:	068e                	slli	a3,a3,0x3
    800045a6:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045aa:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800045ae:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800045b2:	f57966e3          	bltu	s2,s7,800044fe <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045b6:	e9040613          	addi	a2,s0,-368
    800045ba:	85ca                	mv	a1,s2
    800045bc:	855a                	mv	a0,s6
    800045be:	ffffc097          	auipc	ra,0xffffc
    800045c2:	55a080e7          	jalr	1370(ra) # 80000b18 <copyout>
    800045c6:	10054263          	bltz	a0,800046ca <exec+0x3dc>
  p->trapframe->a1 = sp;
    800045ca:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800045ce:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045d2:	df843783          	ld	a5,-520(s0)
    800045d6:	0007c703          	lbu	a4,0(a5)
    800045da:	cf11                	beqz	a4,800045f6 <exec+0x308>
    800045dc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045de:	02f00693          	li	a3,47
    800045e2:	a039                	j	800045f0 <exec+0x302>
      last = s+1;
    800045e4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045e8:	0785                	addi	a5,a5,1
    800045ea:	fff7c703          	lbu	a4,-1(a5)
    800045ee:	c701                	beqz	a4,800045f6 <exec+0x308>
    if(*s == '/')
    800045f0:	fed71ce3          	bne	a4,a3,800045e8 <exec+0x2fa>
    800045f4:	bfc5                	j	800045e4 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800045f6:	4641                	li	a2,16
    800045f8:	df843583          	ld	a1,-520(s0)
    800045fc:	158a8513          	addi	a0,s5,344
    80004600:	ffffc097          	auipc	ra,0xffffc
    80004604:	cbc080e7          	jalr	-836(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004608:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000460c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004610:	e0843783          	ld	a5,-504(s0)
    80004614:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004618:	058ab783          	ld	a5,88(s5)
    8000461c:	e6843703          	ld	a4,-408(s0)
    80004620:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004622:	058ab783          	ld	a5,88(s5)
    80004626:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000462a:	85e6                	mv	a1,s9
    8000462c:	ffffd097          	auipc	ra,0xffffd
    80004630:	b48080e7          	jalr	-1208(ra) # 80001174 <proc_freepagetable>
  if(p->pid==1) vmprint(p->pagetable);
    80004634:	030aa703          	lw	a4,48(s5)
    80004638:	4785                	li	a5,1
    8000463a:	00f70d63          	beq	a4,a5,80004654 <exec+0x366>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000463e:	0004851b          	sext.w	a0,s1
    80004642:	79be                	ld	s3,488(sp)
    80004644:	7a1e                	ld	s4,480(sp)
    80004646:	6afe                	ld	s5,472(sp)
    80004648:	6b5e                	ld	s6,464(sp)
    8000464a:	6bbe                	ld	s7,456(sp)
    8000464c:	6c1e                	ld	s8,448(sp)
    8000464e:	7cfa                	ld	s9,440(sp)
    80004650:	7d5a                	ld	s10,432(sp)
    80004652:	b31d                	j	80004378 <exec+0x8a>
  if(p->pid==1) vmprint(p->pagetable);
    80004654:	050ab503          	ld	a0,80(s5)
    80004658:	ffffc097          	auipc	ra,0xffffc
    8000465c:	776080e7          	jalr	1910(ra) # 80000dce <vmprint>
    80004660:	bff9                	j	8000463e <exec+0x350>
    80004662:	e0943423          	sd	s1,-504(s0)
    80004666:	7dba                	ld	s11,424(sp)
    80004668:	a025                	j	80004690 <exec+0x3a2>
    8000466a:	e0943423          	sd	s1,-504(s0)
    8000466e:	7dba                	ld	s11,424(sp)
    80004670:	a005                	j	80004690 <exec+0x3a2>
    80004672:	e0943423          	sd	s1,-504(s0)
    80004676:	7dba                	ld	s11,424(sp)
    80004678:	a821                	j	80004690 <exec+0x3a2>
    8000467a:	e0943423          	sd	s1,-504(s0)
    8000467e:	7dba                	ld	s11,424(sp)
    80004680:	a801                	j	80004690 <exec+0x3a2>
  ip = 0;
    80004682:	4a01                	li	s4,0
    80004684:	a031                	j	80004690 <exec+0x3a2>
    80004686:	4a01                	li	s4,0
  if(pagetable)
    80004688:	a021                	j	80004690 <exec+0x3a2>
    8000468a:	7dba                	ld	s11,424(sp)
    8000468c:	a011                	j	80004690 <exec+0x3a2>
    8000468e:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004690:	e0843583          	ld	a1,-504(s0)
    80004694:	855a                	mv	a0,s6
    80004696:	ffffd097          	auipc	ra,0xffffd
    8000469a:	ade080e7          	jalr	-1314(ra) # 80001174 <proc_freepagetable>
  return -1;
    8000469e:	557d                	li	a0,-1
  if(ip){
    800046a0:	000a1b63          	bnez	s4,800046b6 <exec+0x3c8>
    800046a4:	79be                	ld	s3,488(sp)
    800046a6:	7a1e                	ld	s4,480(sp)
    800046a8:	6afe                	ld	s5,472(sp)
    800046aa:	6b5e                	ld	s6,464(sp)
    800046ac:	6bbe                	ld	s7,456(sp)
    800046ae:	6c1e                	ld	s8,448(sp)
    800046b0:	7cfa                	ld	s9,440(sp)
    800046b2:	7d5a                	ld	s10,432(sp)
    800046b4:	b1d1                	j	80004378 <exec+0x8a>
    800046b6:	79be                	ld	s3,488(sp)
    800046b8:	6afe                	ld	s5,472(sp)
    800046ba:	6b5e                	ld	s6,464(sp)
    800046bc:	6bbe                	ld	s7,456(sp)
    800046be:	6c1e                	ld	s8,448(sp)
    800046c0:	7cfa                	ld	s9,440(sp)
    800046c2:	7d5a                	ld	s10,432(sp)
    800046c4:	b979                	j	80004362 <exec+0x74>
    800046c6:	6b5e                	ld	s6,464(sp)
    800046c8:	b969                	j	80004362 <exec+0x74>
  sz = sz1;
    800046ca:	e0843983          	ld	s3,-504(s0)
    800046ce:	bd05                	j	800044fe <exec+0x210>

00000000800046d0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046d0:	7179                	addi	sp,sp,-48
    800046d2:	f406                	sd	ra,40(sp)
    800046d4:	f022                	sd	s0,32(sp)
    800046d6:	ec26                	sd	s1,24(sp)
    800046d8:	e84a                	sd	s2,16(sp)
    800046da:	1800                	addi	s0,sp,48
    800046dc:	892e                	mv	s2,a1
    800046de:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800046e0:	fdc40593          	addi	a1,s0,-36
    800046e4:	ffffe097          	auipc	ra,0xffffe
    800046e8:	a3c080e7          	jalr	-1476(ra) # 80002120 <argint>
    800046ec:	04054063          	bltz	a0,8000472c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046f0:	fdc42703          	lw	a4,-36(s0)
    800046f4:	47bd                	li	a5,15
    800046f6:	02e7ed63          	bltu	a5,a4,80004730 <argfd+0x60>
    800046fa:	ffffd097          	auipc	ra,0xffffd
    800046fe:	8e2080e7          	jalr	-1822(ra) # 80000fdc <myproc>
    80004702:	fdc42703          	lw	a4,-36(s0)
    80004706:	01a70793          	addi	a5,a4,26
    8000470a:	078e                	slli	a5,a5,0x3
    8000470c:	953e                	add	a0,a0,a5
    8000470e:	611c                	ld	a5,0(a0)
    80004710:	c395                	beqz	a5,80004734 <argfd+0x64>
    return -1;
  if(pfd)
    80004712:	00090463          	beqz	s2,8000471a <argfd+0x4a>
    *pfd = fd;
    80004716:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000471a:	4501                	li	a0,0
  if(pf)
    8000471c:	c091                	beqz	s1,80004720 <argfd+0x50>
    *pf = f;
    8000471e:	e09c                	sd	a5,0(s1)
}
    80004720:	70a2                	ld	ra,40(sp)
    80004722:	7402                	ld	s0,32(sp)
    80004724:	64e2                	ld	s1,24(sp)
    80004726:	6942                	ld	s2,16(sp)
    80004728:	6145                	addi	sp,sp,48
    8000472a:	8082                	ret
    return -1;
    8000472c:	557d                	li	a0,-1
    8000472e:	bfcd                	j	80004720 <argfd+0x50>
    return -1;
    80004730:	557d                	li	a0,-1
    80004732:	b7fd                	j	80004720 <argfd+0x50>
    80004734:	557d                	li	a0,-1
    80004736:	b7ed                	j	80004720 <argfd+0x50>

0000000080004738 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004738:	1101                	addi	sp,sp,-32
    8000473a:	ec06                	sd	ra,24(sp)
    8000473c:	e822                	sd	s0,16(sp)
    8000473e:	e426                	sd	s1,8(sp)
    80004740:	1000                	addi	s0,sp,32
    80004742:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004744:	ffffd097          	auipc	ra,0xffffd
    80004748:	898080e7          	jalr	-1896(ra) # 80000fdc <myproc>
    8000474c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000474e:	0d050793          	addi	a5,a0,208
    80004752:	4501                	li	a0,0
    80004754:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004756:	6398                	ld	a4,0(a5)
    80004758:	cb19                	beqz	a4,8000476e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000475a:	2505                	addiw	a0,a0,1
    8000475c:	07a1                	addi	a5,a5,8
    8000475e:	fed51ce3          	bne	a0,a3,80004756 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004762:	557d                	li	a0,-1
}
    80004764:	60e2                	ld	ra,24(sp)
    80004766:	6442                	ld	s0,16(sp)
    80004768:	64a2                	ld	s1,8(sp)
    8000476a:	6105                	addi	sp,sp,32
    8000476c:	8082                	ret
      p->ofile[fd] = f;
    8000476e:	01a50793          	addi	a5,a0,26
    80004772:	078e                	slli	a5,a5,0x3
    80004774:	963e                	add	a2,a2,a5
    80004776:	e204                	sd	s1,0(a2)
      return fd;
    80004778:	b7f5                	j	80004764 <fdalloc+0x2c>

000000008000477a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000477a:	715d                	addi	sp,sp,-80
    8000477c:	e486                	sd	ra,72(sp)
    8000477e:	e0a2                	sd	s0,64(sp)
    80004780:	fc26                	sd	s1,56(sp)
    80004782:	f84a                	sd	s2,48(sp)
    80004784:	f44e                	sd	s3,40(sp)
    80004786:	f052                	sd	s4,32(sp)
    80004788:	ec56                	sd	s5,24(sp)
    8000478a:	0880                	addi	s0,sp,80
    8000478c:	8aae                	mv	s5,a1
    8000478e:	8a32                	mv	s4,a2
    80004790:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004792:	fb040593          	addi	a1,s0,-80
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	dfc080e7          	jalr	-516(ra) # 80003592 <nameiparent>
    8000479e:	892a                	mv	s2,a0
    800047a0:	12050c63          	beqz	a0,800048d8 <create+0x15e>
    return 0;

  ilock(dp);
    800047a4:	ffffe097          	auipc	ra,0xffffe
    800047a8:	5fe080e7          	jalr	1534(ra) # 80002da2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800047ac:	4601                	li	a2,0
    800047ae:	fb040593          	addi	a1,s0,-80
    800047b2:	854a                	mv	a0,s2
    800047b4:	fffff097          	auipc	ra,0xfffff
    800047b8:	aee080e7          	jalr	-1298(ra) # 800032a2 <dirlookup>
    800047bc:	84aa                	mv	s1,a0
    800047be:	c539                	beqz	a0,8000480c <create+0x92>
    iunlockput(dp);
    800047c0:	854a                	mv	a0,s2
    800047c2:	fffff097          	auipc	ra,0xfffff
    800047c6:	846080e7          	jalr	-1978(ra) # 80003008 <iunlockput>
    ilock(ip);
    800047ca:	8526                	mv	a0,s1
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	5d6080e7          	jalr	1494(ra) # 80002da2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047d4:	4789                	li	a5,2
    800047d6:	02fa9463          	bne	s5,a5,800047fe <create+0x84>
    800047da:	0444d783          	lhu	a5,68(s1)
    800047de:	37f9                	addiw	a5,a5,-2
    800047e0:	17c2                	slli	a5,a5,0x30
    800047e2:	93c1                	srli	a5,a5,0x30
    800047e4:	4705                	li	a4,1
    800047e6:	00f76c63          	bltu	a4,a5,800047fe <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800047ea:	8526                	mv	a0,s1
    800047ec:	60a6                	ld	ra,72(sp)
    800047ee:	6406                	ld	s0,64(sp)
    800047f0:	74e2                	ld	s1,56(sp)
    800047f2:	7942                	ld	s2,48(sp)
    800047f4:	79a2                	ld	s3,40(sp)
    800047f6:	7a02                	ld	s4,32(sp)
    800047f8:	6ae2                	ld	s5,24(sp)
    800047fa:	6161                	addi	sp,sp,80
    800047fc:	8082                	ret
    iunlockput(ip);
    800047fe:	8526                	mv	a0,s1
    80004800:	fffff097          	auipc	ra,0xfffff
    80004804:	808080e7          	jalr	-2040(ra) # 80003008 <iunlockput>
    return 0;
    80004808:	4481                	li	s1,0
    8000480a:	b7c5                	j	800047ea <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000480c:	85d6                	mv	a1,s5
    8000480e:	00092503          	lw	a0,0(s2)
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	3fc080e7          	jalr	1020(ra) # 80002c0e <ialloc>
    8000481a:	84aa                	mv	s1,a0
    8000481c:	c139                	beqz	a0,80004862 <create+0xe8>
  ilock(ip);
    8000481e:	ffffe097          	auipc	ra,0xffffe
    80004822:	584080e7          	jalr	1412(ra) # 80002da2 <ilock>
  ip->major = major;
    80004826:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000482a:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    8000482e:	4985                	li	s3,1
    80004830:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004834:	8526                	mv	a0,s1
    80004836:	ffffe097          	auipc	ra,0xffffe
    8000483a:	4a0080e7          	jalr	1184(ra) # 80002cd6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000483e:	033a8a63          	beq	s5,s3,80004872 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004842:	40d0                	lw	a2,4(s1)
    80004844:	fb040593          	addi	a1,s0,-80
    80004848:	854a                	mv	a0,s2
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	c68080e7          	jalr	-920(ra) # 800034b2 <dirlink>
    80004852:	06054b63          	bltz	a0,800048c8 <create+0x14e>
  iunlockput(dp);
    80004856:	854a                	mv	a0,s2
    80004858:	ffffe097          	auipc	ra,0xffffe
    8000485c:	7b0080e7          	jalr	1968(ra) # 80003008 <iunlockput>
  return ip;
    80004860:	b769                	j	800047ea <create+0x70>
    panic("create: ialloc");
    80004862:	00004517          	auipc	a0,0x4
    80004866:	d5650513          	addi	a0,a0,-682 # 800085b8 <etext+0x5b8>
    8000486a:	00001097          	auipc	ra,0x1
    8000486e:	6c2080e7          	jalr	1730(ra) # 80005f2c <panic>
    dp->nlink++;  // for ".."
    80004872:	04a95783          	lhu	a5,74(s2)
    80004876:	2785                	addiw	a5,a5,1
    80004878:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000487c:	854a                	mv	a0,s2
    8000487e:	ffffe097          	auipc	ra,0xffffe
    80004882:	458080e7          	jalr	1112(ra) # 80002cd6 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004886:	40d0                	lw	a2,4(s1)
    80004888:	00004597          	auipc	a1,0x4
    8000488c:	d4058593          	addi	a1,a1,-704 # 800085c8 <etext+0x5c8>
    80004890:	8526                	mv	a0,s1
    80004892:	fffff097          	auipc	ra,0xfffff
    80004896:	c20080e7          	jalr	-992(ra) # 800034b2 <dirlink>
    8000489a:	00054f63          	bltz	a0,800048b8 <create+0x13e>
    8000489e:	00492603          	lw	a2,4(s2)
    800048a2:	00004597          	auipc	a1,0x4
    800048a6:	d2e58593          	addi	a1,a1,-722 # 800085d0 <etext+0x5d0>
    800048aa:	8526                	mv	a0,s1
    800048ac:	fffff097          	auipc	ra,0xfffff
    800048b0:	c06080e7          	jalr	-1018(ra) # 800034b2 <dirlink>
    800048b4:	f80557e3          	bgez	a0,80004842 <create+0xc8>
      panic("create dots");
    800048b8:	00004517          	auipc	a0,0x4
    800048bc:	d2050513          	addi	a0,a0,-736 # 800085d8 <etext+0x5d8>
    800048c0:	00001097          	auipc	ra,0x1
    800048c4:	66c080e7          	jalr	1644(ra) # 80005f2c <panic>
    panic("create: dirlink");
    800048c8:	00004517          	auipc	a0,0x4
    800048cc:	d2050513          	addi	a0,a0,-736 # 800085e8 <etext+0x5e8>
    800048d0:	00001097          	auipc	ra,0x1
    800048d4:	65c080e7          	jalr	1628(ra) # 80005f2c <panic>
    return 0;
    800048d8:	84aa                	mv	s1,a0
    800048da:	bf01                	j	800047ea <create+0x70>

00000000800048dc <sys_dup>:
{
    800048dc:	7179                	addi	sp,sp,-48
    800048de:	f406                	sd	ra,40(sp)
    800048e0:	f022                	sd	s0,32(sp)
    800048e2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048e4:	fd840613          	addi	a2,s0,-40
    800048e8:	4581                	li	a1,0
    800048ea:	4501                	li	a0,0
    800048ec:	00000097          	auipc	ra,0x0
    800048f0:	de4080e7          	jalr	-540(ra) # 800046d0 <argfd>
    return -1;
    800048f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048f6:	02054763          	bltz	a0,80004924 <sys_dup+0x48>
    800048fa:	ec26                	sd	s1,24(sp)
    800048fc:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800048fe:	fd843903          	ld	s2,-40(s0)
    80004902:	854a                	mv	a0,s2
    80004904:	00000097          	auipc	ra,0x0
    80004908:	e34080e7          	jalr	-460(ra) # 80004738 <fdalloc>
    8000490c:	84aa                	mv	s1,a0
    return -1;
    8000490e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004910:	00054f63          	bltz	a0,8000492e <sys_dup+0x52>
  filedup(f);
    80004914:	854a                	mv	a0,s2
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	2d6080e7          	jalr	726(ra) # 80003bec <filedup>
  return fd;
    8000491e:	87a6                	mv	a5,s1
    80004920:	64e2                	ld	s1,24(sp)
    80004922:	6942                	ld	s2,16(sp)
}
    80004924:	853e                	mv	a0,a5
    80004926:	70a2                	ld	ra,40(sp)
    80004928:	7402                	ld	s0,32(sp)
    8000492a:	6145                	addi	sp,sp,48
    8000492c:	8082                	ret
    8000492e:	64e2                	ld	s1,24(sp)
    80004930:	6942                	ld	s2,16(sp)
    80004932:	bfcd                	j	80004924 <sys_dup+0x48>

0000000080004934 <sys_read>:
{
    80004934:	7179                	addi	sp,sp,-48
    80004936:	f406                	sd	ra,40(sp)
    80004938:	f022                	sd	s0,32(sp)
    8000493a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000493c:	fe840613          	addi	a2,s0,-24
    80004940:	4581                	li	a1,0
    80004942:	4501                	li	a0,0
    80004944:	00000097          	auipc	ra,0x0
    80004948:	d8c080e7          	jalr	-628(ra) # 800046d0 <argfd>
    return -1;
    8000494c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000494e:	04054163          	bltz	a0,80004990 <sys_read+0x5c>
    80004952:	fe440593          	addi	a1,s0,-28
    80004956:	4509                	li	a0,2
    80004958:	ffffd097          	auipc	ra,0xffffd
    8000495c:	7c8080e7          	jalr	1992(ra) # 80002120 <argint>
    return -1;
    80004960:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004962:	02054763          	bltz	a0,80004990 <sys_read+0x5c>
    80004966:	fd840593          	addi	a1,s0,-40
    8000496a:	4505                	li	a0,1
    8000496c:	ffffd097          	auipc	ra,0xffffd
    80004970:	7d6080e7          	jalr	2006(ra) # 80002142 <argaddr>
    return -1;
    80004974:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004976:	00054d63          	bltz	a0,80004990 <sys_read+0x5c>
  return fileread(f, p, n);
    8000497a:	fe442603          	lw	a2,-28(s0)
    8000497e:	fd843583          	ld	a1,-40(s0)
    80004982:	fe843503          	ld	a0,-24(s0)
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	40c080e7          	jalr	1036(ra) # 80003d92 <fileread>
    8000498e:	87aa                	mv	a5,a0
}
    80004990:	853e                	mv	a0,a5
    80004992:	70a2                	ld	ra,40(sp)
    80004994:	7402                	ld	s0,32(sp)
    80004996:	6145                	addi	sp,sp,48
    80004998:	8082                	ret

000000008000499a <sys_write>:
{
    8000499a:	7179                	addi	sp,sp,-48
    8000499c:	f406                	sd	ra,40(sp)
    8000499e:	f022                	sd	s0,32(sp)
    800049a0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049a2:	fe840613          	addi	a2,s0,-24
    800049a6:	4581                	li	a1,0
    800049a8:	4501                	li	a0,0
    800049aa:	00000097          	auipc	ra,0x0
    800049ae:	d26080e7          	jalr	-730(ra) # 800046d0 <argfd>
    return -1;
    800049b2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049b4:	04054163          	bltz	a0,800049f6 <sys_write+0x5c>
    800049b8:	fe440593          	addi	a1,s0,-28
    800049bc:	4509                	li	a0,2
    800049be:	ffffd097          	auipc	ra,0xffffd
    800049c2:	762080e7          	jalr	1890(ra) # 80002120 <argint>
    return -1;
    800049c6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049c8:	02054763          	bltz	a0,800049f6 <sys_write+0x5c>
    800049cc:	fd840593          	addi	a1,s0,-40
    800049d0:	4505                	li	a0,1
    800049d2:	ffffd097          	auipc	ra,0xffffd
    800049d6:	770080e7          	jalr	1904(ra) # 80002142 <argaddr>
    return -1;
    800049da:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049dc:	00054d63          	bltz	a0,800049f6 <sys_write+0x5c>
  return filewrite(f, p, n);
    800049e0:	fe442603          	lw	a2,-28(s0)
    800049e4:	fd843583          	ld	a1,-40(s0)
    800049e8:	fe843503          	ld	a0,-24(s0)
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	478080e7          	jalr	1144(ra) # 80003e64 <filewrite>
    800049f4:	87aa                	mv	a5,a0
}
    800049f6:	853e                	mv	a0,a5
    800049f8:	70a2                	ld	ra,40(sp)
    800049fa:	7402                	ld	s0,32(sp)
    800049fc:	6145                	addi	sp,sp,48
    800049fe:	8082                	ret

0000000080004a00 <sys_close>:
{
    80004a00:	1101                	addi	sp,sp,-32
    80004a02:	ec06                	sd	ra,24(sp)
    80004a04:	e822                	sd	s0,16(sp)
    80004a06:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a08:	fe040613          	addi	a2,s0,-32
    80004a0c:	fec40593          	addi	a1,s0,-20
    80004a10:	4501                	li	a0,0
    80004a12:	00000097          	auipc	ra,0x0
    80004a16:	cbe080e7          	jalr	-834(ra) # 800046d0 <argfd>
    return -1;
    80004a1a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a1c:	02054463          	bltz	a0,80004a44 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a20:	ffffc097          	auipc	ra,0xffffc
    80004a24:	5bc080e7          	jalr	1468(ra) # 80000fdc <myproc>
    80004a28:	fec42783          	lw	a5,-20(s0)
    80004a2c:	07e9                	addi	a5,a5,26
    80004a2e:	078e                	slli	a5,a5,0x3
    80004a30:	953e                	add	a0,a0,a5
    80004a32:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a36:	fe043503          	ld	a0,-32(s0)
    80004a3a:	fffff097          	auipc	ra,0xfffff
    80004a3e:	204080e7          	jalr	516(ra) # 80003c3e <fileclose>
  return 0;
    80004a42:	4781                	li	a5,0
}
    80004a44:	853e                	mv	a0,a5
    80004a46:	60e2                	ld	ra,24(sp)
    80004a48:	6442                	ld	s0,16(sp)
    80004a4a:	6105                	addi	sp,sp,32
    80004a4c:	8082                	ret

0000000080004a4e <sys_fstat>:
{
    80004a4e:	1101                	addi	sp,sp,-32
    80004a50:	ec06                	sd	ra,24(sp)
    80004a52:	e822                	sd	s0,16(sp)
    80004a54:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a56:	fe840613          	addi	a2,s0,-24
    80004a5a:	4581                	li	a1,0
    80004a5c:	4501                	li	a0,0
    80004a5e:	00000097          	auipc	ra,0x0
    80004a62:	c72080e7          	jalr	-910(ra) # 800046d0 <argfd>
    return -1;
    80004a66:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a68:	02054563          	bltz	a0,80004a92 <sys_fstat+0x44>
    80004a6c:	fe040593          	addi	a1,s0,-32
    80004a70:	4505                	li	a0,1
    80004a72:	ffffd097          	auipc	ra,0xffffd
    80004a76:	6d0080e7          	jalr	1744(ra) # 80002142 <argaddr>
    return -1;
    80004a7a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a7c:	00054b63          	bltz	a0,80004a92 <sys_fstat+0x44>
  return filestat(f, st);
    80004a80:	fe043583          	ld	a1,-32(s0)
    80004a84:	fe843503          	ld	a0,-24(s0)
    80004a88:	fffff097          	auipc	ra,0xfffff
    80004a8c:	298080e7          	jalr	664(ra) # 80003d20 <filestat>
    80004a90:	87aa                	mv	a5,a0
}
    80004a92:	853e                	mv	a0,a5
    80004a94:	60e2                	ld	ra,24(sp)
    80004a96:	6442                	ld	s0,16(sp)
    80004a98:	6105                	addi	sp,sp,32
    80004a9a:	8082                	ret

0000000080004a9c <sys_link>:
{
    80004a9c:	7169                	addi	sp,sp,-304
    80004a9e:	f606                	sd	ra,296(sp)
    80004aa0:	f222                	sd	s0,288(sp)
    80004aa2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aa4:	08000613          	li	a2,128
    80004aa8:	ed040593          	addi	a1,s0,-304
    80004aac:	4501                	li	a0,0
    80004aae:	ffffd097          	auipc	ra,0xffffd
    80004ab2:	6b6080e7          	jalr	1718(ra) # 80002164 <argstr>
    return -1;
    80004ab6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ab8:	12054663          	bltz	a0,80004be4 <sys_link+0x148>
    80004abc:	08000613          	li	a2,128
    80004ac0:	f5040593          	addi	a1,s0,-176
    80004ac4:	4505                	li	a0,1
    80004ac6:	ffffd097          	auipc	ra,0xffffd
    80004aca:	69e080e7          	jalr	1694(ra) # 80002164 <argstr>
    return -1;
    80004ace:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004ad0:	10054a63          	bltz	a0,80004be4 <sys_link+0x148>
    80004ad4:	ee26                	sd	s1,280(sp)
  begin_op();
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	c9e080e7          	jalr	-866(ra) # 80003774 <begin_op>
  if((ip = namei(old)) == 0){
    80004ade:	ed040513          	addi	a0,s0,-304
    80004ae2:	fffff097          	auipc	ra,0xfffff
    80004ae6:	a92080e7          	jalr	-1390(ra) # 80003574 <namei>
    80004aea:	84aa                	mv	s1,a0
    80004aec:	c949                	beqz	a0,80004b7e <sys_link+0xe2>
  ilock(ip);
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	2b4080e7          	jalr	692(ra) # 80002da2 <ilock>
  if(ip->type == T_DIR){
    80004af6:	04449703          	lh	a4,68(s1)
    80004afa:	4785                	li	a5,1
    80004afc:	08f70863          	beq	a4,a5,80004b8c <sys_link+0xf0>
    80004b00:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004b02:	04a4d783          	lhu	a5,74(s1)
    80004b06:	2785                	addiw	a5,a5,1
    80004b08:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b0c:	8526                	mv	a0,s1
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	1c8080e7          	jalr	456(ra) # 80002cd6 <iupdate>
  iunlock(ip);
    80004b16:	8526                	mv	a0,s1
    80004b18:	ffffe097          	auipc	ra,0xffffe
    80004b1c:	350080e7          	jalr	848(ra) # 80002e68 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b20:	fd040593          	addi	a1,s0,-48
    80004b24:	f5040513          	addi	a0,s0,-176
    80004b28:	fffff097          	auipc	ra,0xfffff
    80004b2c:	a6a080e7          	jalr	-1430(ra) # 80003592 <nameiparent>
    80004b30:	892a                	mv	s2,a0
    80004b32:	cd35                	beqz	a0,80004bae <sys_link+0x112>
  ilock(dp);
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	26e080e7          	jalr	622(ra) # 80002da2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b3c:	00092703          	lw	a4,0(s2)
    80004b40:	409c                	lw	a5,0(s1)
    80004b42:	06f71163          	bne	a4,a5,80004ba4 <sys_link+0x108>
    80004b46:	40d0                	lw	a2,4(s1)
    80004b48:	fd040593          	addi	a1,s0,-48
    80004b4c:	854a                	mv	a0,s2
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	964080e7          	jalr	-1692(ra) # 800034b2 <dirlink>
    80004b56:	04054763          	bltz	a0,80004ba4 <sys_link+0x108>
  iunlockput(dp);
    80004b5a:	854a                	mv	a0,s2
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	4ac080e7          	jalr	1196(ra) # 80003008 <iunlockput>
  iput(ip);
    80004b64:	8526                	mv	a0,s1
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	3fa080e7          	jalr	1018(ra) # 80002f60 <iput>
  end_op();
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	c80080e7          	jalr	-896(ra) # 800037ee <end_op>
  return 0;
    80004b76:	4781                	li	a5,0
    80004b78:	64f2                	ld	s1,280(sp)
    80004b7a:	6952                	ld	s2,272(sp)
    80004b7c:	a0a5                	j	80004be4 <sys_link+0x148>
    end_op();
    80004b7e:	fffff097          	auipc	ra,0xfffff
    80004b82:	c70080e7          	jalr	-912(ra) # 800037ee <end_op>
    return -1;
    80004b86:	57fd                	li	a5,-1
    80004b88:	64f2                	ld	s1,280(sp)
    80004b8a:	a8a9                	j	80004be4 <sys_link+0x148>
    iunlockput(ip);
    80004b8c:	8526                	mv	a0,s1
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	47a080e7          	jalr	1146(ra) # 80003008 <iunlockput>
    end_op();
    80004b96:	fffff097          	auipc	ra,0xfffff
    80004b9a:	c58080e7          	jalr	-936(ra) # 800037ee <end_op>
    return -1;
    80004b9e:	57fd                	li	a5,-1
    80004ba0:	64f2                	ld	s1,280(sp)
    80004ba2:	a089                	j	80004be4 <sys_link+0x148>
    iunlockput(dp);
    80004ba4:	854a                	mv	a0,s2
    80004ba6:	ffffe097          	auipc	ra,0xffffe
    80004baa:	462080e7          	jalr	1122(ra) # 80003008 <iunlockput>
  ilock(ip);
    80004bae:	8526                	mv	a0,s1
    80004bb0:	ffffe097          	auipc	ra,0xffffe
    80004bb4:	1f2080e7          	jalr	498(ra) # 80002da2 <ilock>
  ip->nlink--;
    80004bb8:	04a4d783          	lhu	a5,74(s1)
    80004bbc:	37fd                	addiw	a5,a5,-1
    80004bbe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bc2:	8526                	mv	a0,s1
    80004bc4:	ffffe097          	auipc	ra,0xffffe
    80004bc8:	112080e7          	jalr	274(ra) # 80002cd6 <iupdate>
  iunlockput(ip);
    80004bcc:	8526                	mv	a0,s1
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	43a080e7          	jalr	1082(ra) # 80003008 <iunlockput>
  end_op();
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	c18080e7          	jalr	-1000(ra) # 800037ee <end_op>
  return -1;
    80004bde:	57fd                	li	a5,-1
    80004be0:	64f2                	ld	s1,280(sp)
    80004be2:	6952                	ld	s2,272(sp)
}
    80004be4:	853e                	mv	a0,a5
    80004be6:	70b2                	ld	ra,296(sp)
    80004be8:	7412                	ld	s0,288(sp)
    80004bea:	6155                	addi	sp,sp,304
    80004bec:	8082                	ret

0000000080004bee <sys_unlink>:
{
    80004bee:	7151                	addi	sp,sp,-240
    80004bf0:	f586                	sd	ra,232(sp)
    80004bf2:	f1a2                	sd	s0,224(sp)
    80004bf4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004bf6:	08000613          	li	a2,128
    80004bfa:	f3040593          	addi	a1,s0,-208
    80004bfe:	4501                	li	a0,0
    80004c00:	ffffd097          	auipc	ra,0xffffd
    80004c04:	564080e7          	jalr	1380(ra) # 80002164 <argstr>
    80004c08:	1a054a63          	bltz	a0,80004dbc <sys_unlink+0x1ce>
    80004c0c:	eda6                	sd	s1,216(sp)
  begin_op();
    80004c0e:	fffff097          	auipc	ra,0xfffff
    80004c12:	b66080e7          	jalr	-1178(ra) # 80003774 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c16:	fb040593          	addi	a1,s0,-80
    80004c1a:	f3040513          	addi	a0,s0,-208
    80004c1e:	fffff097          	auipc	ra,0xfffff
    80004c22:	974080e7          	jalr	-1676(ra) # 80003592 <nameiparent>
    80004c26:	84aa                	mv	s1,a0
    80004c28:	cd71                	beqz	a0,80004d04 <sys_unlink+0x116>
  ilock(dp);
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	178080e7          	jalr	376(ra) # 80002da2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c32:	00004597          	auipc	a1,0x4
    80004c36:	99658593          	addi	a1,a1,-1642 # 800085c8 <etext+0x5c8>
    80004c3a:	fb040513          	addi	a0,s0,-80
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	64a080e7          	jalr	1610(ra) # 80003288 <namecmp>
    80004c46:	14050c63          	beqz	a0,80004d9e <sys_unlink+0x1b0>
    80004c4a:	00004597          	auipc	a1,0x4
    80004c4e:	98658593          	addi	a1,a1,-1658 # 800085d0 <etext+0x5d0>
    80004c52:	fb040513          	addi	a0,s0,-80
    80004c56:	ffffe097          	auipc	ra,0xffffe
    80004c5a:	632080e7          	jalr	1586(ra) # 80003288 <namecmp>
    80004c5e:	14050063          	beqz	a0,80004d9e <sys_unlink+0x1b0>
    80004c62:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c64:	f2c40613          	addi	a2,s0,-212
    80004c68:	fb040593          	addi	a1,s0,-80
    80004c6c:	8526                	mv	a0,s1
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	634080e7          	jalr	1588(ra) # 800032a2 <dirlookup>
    80004c76:	892a                	mv	s2,a0
    80004c78:	12050263          	beqz	a0,80004d9c <sys_unlink+0x1ae>
  ilock(ip);
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	126080e7          	jalr	294(ra) # 80002da2 <ilock>
  if(ip->nlink < 1)
    80004c84:	04a91783          	lh	a5,74(s2)
    80004c88:	08f05563          	blez	a5,80004d12 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c8c:	04491703          	lh	a4,68(s2)
    80004c90:	4785                	li	a5,1
    80004c92:	08f70963          	beq	a4,a5,80004d24 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004c96:	4641                	li	a2,16
    80004c98:	4581                	li	a1,0
    80004c9a:	fc040513          	addi	a0,s0,-64
    80004c9e:	ffffb097          	auipc	ra,0xffffb
    80004ca2:	4dc080e7          	jalr	1244(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ca6:	4741                	li	a4,16
    80004ca8:	f2c42683          	lw	a3,-212(s0)
    80004cac:	fc040613          	addi	a2,s0,-64
    80004cb0:	4581                	li	a1,0
    80004cb2:	8526                	mv	a0,s1
    80004cb4:	ffffe097          	auipc	ra,0xffffe
    80004cb8:	4aa080e7          	jalr	1194(ra) # 8000315e <writei>
    80004cbc:	47c1                	li	a5,16
    80004cbe:	0af51b63          	bne	a0,a5,80004d74 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004cc2:	04491703          	lh	a4,68(s2)
    80004cc6:	4785                	li	a5,1
    80004cc8:	0af70f63          	beq	a4,a5,80004d86 <sys_unlink+0x198>
  iunlockput(dp);
    80004ccc:	8526                	mv	a0,s1
    80004cce:	ffffe097          	auipc	ra,0xffffe
    80004cd2:	33a080e7          	jalr	826(ra) # 80003008 <iunlockput>
  ip->nlink--;
    80004cd6:	04a95783          	lhu	a5,74(s2)
    80004cda:	37fd                	addiw	a5,a5,-1
    80004cdc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ce0:	854a                	mv	a0,s2
    80004ce2:	ffffe097          	auipc	ra,0xffffe
    80004ce6:	ff4080e7          	jalr	-12(ra) # 80002cd6 <iupdate>
  iunlockput(ip);
    80004cea:	854a                	mv	a0,s2
    80004cec:	ffffe097          	auipc	ra,0xffffe
    80004cf0:	31c080e7          	jalr	796(ra) # 80003008 <iunlockput>
  end_op();
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	afa080e7          	jalr	-1286(ra) # 800037ee <end_op>
  return 0;
    80004cfc:	4501                	li	a0,0
    80004cfe:	64ee                	ld	s1,216(sp)
    80004d00:	694e                	ld	s2,208(sp)
    80004d02:	a84d                	j	80004db4 <sys_unlink+0x1c6>
    end_op();
    80004d04:	fffff097          	auipc	ra,0xfffff
    80004d08:	aea080e7          	jalr	-1302(ra) # 800037ee <end_op>
    return -1;
    80004d0c:	557d                	li	a0,-1
    80004d0e:	64ee                	ld	s1,216(sp)
    80004d10:	a055                	j	80004db4 <sys_unlink+0x1c6>
    80004d12:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004d14:	00004517          	auipc	a0,0x4
    80004d18:	8e450513          	addi	a0,a0,-1820 # 800085f8 <etext+0x5f8>
    80004d1c:	00001097          	auipc	ra,0x1
    80004d20:	210080e7          	jalr	528(ra) # 80005f2c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d24:	04c92703          	lw	a4,76(s2)
    80004d28:	02000793          	li	a5,32
    80004d2c:	f6e7f5e3          	bgeu	a5,a4,80004c96 <sys_unlink+0xa8>
    80004d30:	e5ce                	sd	s3,200(sp)
    80004d32:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d36:	4741                	li	a4,16
    80004d38:	86ce                	mv	a3,s3
    80004d3a:	f1840613          	addi	a2,s0,-232
    80004d3e:	4581                	li	a1,0
    80004d40:	854a                	mv	a0,s2
    80004d42:	ffffe097          	auipc	ra,0xffffe
    80004d46:	318080e7          	jalr	792(ra) # 8000305a <readi>
    80004d4a:	47c1                	li	a5,16
    80004d4c:	00f51c63          	bne	a0,a5,80004d64 <sys_unlink+0x176>
    if(de.inum != 0)
    80004d50:	f1845783          	lhu	a5,-232(s0)
    80004d54:	e7b5                	bnez	a5,80004dc0 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d56:	29c1                	addiw	s3,s3,16
    80004d58:	04c92783          	lw	a5,76(s2)
    80004d5c:	fcf9ede3          	bltu	s3,a5,80004d36 <sys_unlink+0x148>
    80004d60:	69ae                	ld	s3,200(sp)
    80004d62:	bf15                	j	80004c96 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004d64:	00004517          	auipc	a0,0x4
    80004d68:	8ac50513          	addi	a0,a0,-1876 # 80008610 <etext+0x610>
    80004d6c:	00001097          	auipc	ra,0x1
    80004d70:	1c0080e7          	jalr	448(ra) # 80005f2c <panic>
    80004d74:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004d76:	00004517          	auipc	a0,0x4
    80004d7a:	8b250513          	addi	a0,a0,-1870 # 80008628 <etext+0x628>
    80004d7e:	00001097          	auipc	ra,0x1
    80004d82:	1ae080e7          	jalr	430(ra) # 80005f2c <panic>
    dp->nlink--;
    80004d86:	04a4d783          	lhu	a5,74(s1)
    80004d8a:	37fd                	addiw	a5,a5,-1
    80004d8c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d90:	8526                	mv	a0,s1
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	f44080e7          	jalr	-188(ra) # 80002cd6 <iupdate>
    80004d9a:	bf0d                	j	80004ccc <sys_unlink+0xde>
    80004d9c:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d9e:	8526                	mv	a0,s1
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	268080e7          	jalr	616(ra) # 80003008 <iunlockput>
  end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	a46080e7          	jalr	-1466(ra) # 800037ee <end_op>
  return -1;
    80004db0:	557d                	li	a0,-1
    80004db2:	64ee                	ld	s1,216(sp)
}
    80004db4:	70ae                	ld	ra,232(sp)
    80004db6:	740e                	ld	s0,224(sp)
    80004db8:	616d                	addi	sp,sp,240
    80004dba:	8082                	ret
    return -1;
    80004dbc:	557d                	li	a0,-1
    80004dbe:	bfdd                	j	80004db4 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004dc0:	854a                	mv	a0,s2
    80004dc2:	ffffe097          	auipc	ra,0xffffe
    80004dc6:	246080e7          	jalr	582(ra) # 80003008 <iunlockput>
    goto bad;
    80004dca:	694e                	ld	s2,208(sp)
    80004dcc:	69ae                	ld	s3,200(sp)
    80004dce:	bfc1                	j	80004d9e <sys_unlink+0x1b0>

0000000080004dd0 <sys_open>:

uint64
sys_open(void)
{
    80004dd0:	7131                	addi	sp,sp,-192
    80004dd2:	fd06                	sd	ra,184(sp)
    80004dd4:	f922                	sd	s0,176(sp)
    80004dd6:	f526                	sd	s1,168(sp)
    80004dd8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004dda:	08000613          	li	a2,128
    80004dde:	f5040593          	addi	a1,s0,-176
    80004de2:	4501                	li	a0,0
    80004de4:	ffffd097          	auipc	ra,0xffffd
    80004de8:	380080e7          	jalr	896(ra) # 80002164 <argstr>
    return -1;
    80004dec:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004dee:	0c054463          	bltz	a0,80004eb6 <sys_open+0xe6>
    80004df2:	f4c40593          	addi	a1,s0,-180
    80004df6:	4505                	li	a0,1
    80004df8:	ffffd097          	auipc	ra,0xffffd
    80004dfc:	328080e7          	jalr	808(ra) # 80002120 <argint>
    80004e00:	0a054b63          	bltz	a0,80004eb6 <sys_open+0xe6>
    80004e04:	f14a                	sd	s2,160(sp)

  begin_op();
    80004e06:	fffff097          	auipc	ra,0xfffff
    80004e0a:	96e080e7          	jalr	-1682(ra) # 80003774 <begin_op>

  if(omode & O_CREATE){
    80004e0e:	f4c42783          	lw	a5,-180(s0)
    80004e12:	2007f793          	andi	a5,a5,512
    80004e16:	cfc5                	beqz	a5,80004ece <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e18:	4681                	li	a3,0
    80004e1a:	4601                	li	a2,0
    80004e1c:	4589                	li	a1,2
    80004e1e:	f5040513          	addi	a0,s0,-176
    80004e22:	00000097          	auipc	ra,0x0
    80004e26:	958080e7          	jalr	-1704(ra) # 8000477a <create>
    80004e2a:	892a                	mv	s2,a0
    if(ip == 0){
    80004e2c:	c959                	beqz	a0,80004ec2 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e2e:	04491703          	lh	a4,68(s2)
    80004e32:	478d                	li	a5,3
    80004e34:	00f71763          	bne	a4,a5,80004e42 <sys_open+0x72>
    80004e38:	04695703          	lhu	a4,70(s2)
    80004e3c:	47a5                	li	a5,9
    80004e3e:	0ce7ef63          	bltu	a5,a4,80004f1c <sys_open+0x14c>
    80004e42:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e44:	fffff097          	auipc	ra,0xfffff
    80004e48:	d3e080e7          	jalr	-706(ra) # 80003b82 <filealloc>
    80004e4c:	89aa                	mv	s3,a0
    80004e4e:	c965                	beqz	a0,80004f3e <sys_open+0x16e>
    80004e50:	00000097          	auipc	ra,0x0
    80004e54:	8e8080e7          	jalr	-1816(ra) # 80004738 <fdalloc>
    80004e58:	84aa                	mv	s1,a0
    80004e5a:	0c054d63          	bltz	a0,80004f34 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e5e:	04491703          	lh	a4,68(s2)
    80004e62:	478d                	li	a5,3
    80004e64:	0ef70a63          	beq	a4,a5,80004f58 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e68:	4789                	li	a5,2
    80004e6a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e6e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e72:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e76:	f4c42783          	lw	a5,-180(s0)
    80004e7a:	0017c713          	xori	a4,a5,1
    80004e7e:	8b05                	andi	a4,a4,1
    80004e80:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e84:	0037f713          	andi	a4,a5,3
    80004e88:	00e03733          	snez	a4,a4
    80004e8c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e90:	4007f793          	andi	a5,a5,1024
    80004e94:	c791                	beqz	a5,80004ea0 <sys_open+0xd0>
    80004e96:	04491703          	lh	a4,68(s2)
    80004e9a:	4789                	li	a5,2
    80004e9c:	0cf70563          	beq	a4,a5,80004f66 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004ea0:	854a                	mv	a0,s2
    80004ea2:	ffffe097          	auipc	ra,0xffffe
    80004ea6:	fc6080e7          	jalr	-58(ra) # 80002e68 <iunlock>
  end_op();
    80004eaa:	fffff097          	auipc	ra,0xfffff
    80004eae:	944080e7          	jalr	-1724(ra) # 800037ee <end_op>
    80004eb2:	790a                	ld	s2,160(sp)
    80004eb4:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	70ea                	ld	ra,184(sp)
    80004eba:	744a                	ld	s0,176(sp)
    80004ebc:	74aa                	ld	s1,168(sp)
    80004ebe:	6129                	addi	sp,sp,192
    80004ec0:	8082                	ret
      end_op();
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	92c080e7          	jalr	-1748(ra) # 800037ee <end_op>
      return -1;
    80004eca:	790a                	ld	s2,160(sp)
    80004ecc:	b7ed                	j	80004eb6 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004ece:	f5040513          	addi	a0,s0,-176
    80004ed2:	ffffe097          	auipc	ra,0xffffe
    80004ed6:	6a2080e7          	jalr	1698(ra) # 80003574 <namei>
    80004eda:	892a                	mv	s2,a0
    80004edc:	c90d                	beqz	a0,80004f0e <sys_open+0x13e>
    ilock(ip);
    80004ede:	ffffe097          	auipc	ra,0xffffe
    80004ee2:	ec4080e7          	jalr	-316(ra) # 80002da2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ee6:	04491703          	lh	a4,68(s2)
    80004eea:	4785                	li	a5,1
    80004eec:	f4f711e3          	bne	a4,a5,80004e2e <sys_open+0x5e>
    80004ef0:	f4c42783          	lw	a5,-180(s0)
    80004ef4:	d7b9                	beqz	a5,80004e42 <sys_open+0x72>
      iunlockput(ip);
    80004ef6:	854a                	mv	a0,s2
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	110080e7          	jalr	272(ra) # 80003008 <iunlockput>
      end_op();
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	8ee080e7          	jalr	-1810(ra) # 800037ee <end_op>
      return -1;
    80004f08:	54fd                	li	s1,-1
    80004f0a:	790a                	ld	s2,160(sp)
    80004f0c:	b76d                	j	80004eb6 <sys_open+0xe6>
      end_op();
    80004f0e:	fffff097          	auipc	ra,0xfffff
    80004f12:	8e0080e7          	jalr	-1824(ra) # 800037ee <end_op>
      return -1;
    80004f16:	54fd                	li	s1,-1
    80004f18:	790a                	ld	s2,160(sp)
    80004f1a:	bf71                	j	80004eb6 <sys_open+0xe6>
    iunlockput(ip);
    80004f1c:	854a                	mv	a0,s2
    80004f1e:	ffffe097          	auipc	ra,0xffffe
    80004f22:	0ea080e7          	jalr	234(ra) # 80003008 <iunlockput>
    end_op();
    80004f26:	fffff097          	auipc	ra,0xfffff
    80004f2a:	8c8080e7          	jalr	-1848(ra) # 800037ee <end_op>
    return -1;
    80004f2e:	54fd                	li	s1,-1
    80004f30:	790a                	ld	s2,160(sp)
    80004f32:	b751                	j	80004eb6 <sys_open+0xe6>
      fileclose(f);
    80004f34:	854e                	mv	a0,s3
    80004f36:	fffff097          	auipc	ra,0xfffff
    80004f3a:	d08080e7          	jalr	-760(ra) # 80003c3e <fileclose>
    iunlockput(ip);
    80004f3e:	854a                	mv	a0,s2
    80004f40:	ffffe097          	auipc	ra,0xffffe
    80004f44:	0c8080e7          	jalr	200(ra) # 80003008 <iunlockput>
    end_op();
    80004f48:	fffff097          	auipc	ra,0xfffff
    80004f4c:	8a6080e7          	jalr	-1882(ra) # 800037ee <end_op>
    return -1;
    80004f50:	54fd                	li	s1,-1
    80004f52:	790a                	ld	s2,160(sp)
    80004f54:	69ea                	ld	s3,152(sp)
    80004f56:	b785                	j	80004eb6 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004f58:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f5c:	04691783          	lh	a5,70(s2)
    80004f60:	02f99223          	sh	a5,36(s3)
    80004f64:	b739                	j	80004e72 <sys_open+0xa2>
    itrunc(ip);
    80004f66:	854a                	mv	a0,s2
    80004f68:	ffffe097          	auipc	ra,0xffffe
    80004f6c:	f4c080e7          	jalr	-180(ra) # 80002eb4 <itrunc>
    80004f70:	bf05                	j	80004ea0 <sys_open+0xd0>

0000000080004f72 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f72:	7175                	addi	sp,sp,-144
    80004f74:	e506                	sd	ra,136(sp)
    80004f76:	e122                	sd	s0,128(sp)
    80004f78:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f7a:	ffffe097          	auipc	ra,0xffffe
    80004f7e:	7fa080e7          	jalr	2042(ra) # 80003774 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f82:	08000613          	li	a2,128
    80004f86:	f7040593          	addi	a1,s0,-144
    80004f8a:	4501                	li	a0,0
    80004f8c:	ffffd097          	auipc	ra,0xffffd
    80004f90:	1d8080e7          	jalr	472(ra) # 80002164 <argstr>
    80004f94:	02054963          	bltz	a0,80004fc6 <sys_mkdir+0x54>
    80004f98:	4681                	li	a3,0
    80004f9a:	4601                	li	a2,0
    80004f9c:	4585                	li	a1,1
    80004f9e:	f7040513          	addi	a0,s0,-144
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	7d8080e7          	jalr	2008(ra) # 8000477a <create>
    80004faa:	cd11                	beqz	a0,80004fc6 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fac:	ffffe097          	auipc	ra,0xffffe
    80004fb0:	05c080e7          	jalr	92(ra) # 80003008 <iunlockput>
  end_op();
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	83a080e7          	jalr	-1990(ra) # 800037ee <end_op>
  return 0;
    80004fbc:	4501                	li	a0,0
}
    80004fbe:	60aa                	ld	ra,136(sp)
    80004fc0:	640a                	ld	s0,128(sp)
    80004fc2:	6149                	addi	sp,sp,144
    80004fc4:	8082                	ret
    end_op();
    80004fc6:	fffff097          	auipc	ra,0xfffff
    80004fca:	828080e7          	jalr	-2008(ra) # 800037ee <end_op>
    return -1;
    80004fce:	557d                	li	a0,-1
    80004fd0:	b7fd                	j	80004fbe <sys_mkdir+0x4c>

0000000080004fd2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004fd2:	7135                	addi	sp,sp,-160
    80004fd4:	ed06                	sd	ra,152(sp)
    80004fd6:	e922                	sd	s0,144(sp)
    80004fd8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fda:	ffffe097          	auipc	ra,0xffffe
    80004fde:	79a080e7          	jalr	1946(ra) # 80003774 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fe2:	08000613          	li	a2,128
    80004fe6:	f7040593          	addi	a1,s0,-144
    80004fea:	4501                	li	a0,0
    80004fec:	ffffd097          	auipc	ra,0xffffd
    80004ff0:	178080e7          	jalr	376(ra) # 80002164 <argstr>
    80004ff4:	04054a63          	bltz	a0,80005048 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004ff8:	f6c40593          	addi	a1,s0,-148
    80004ffc:	4505                	li	a0,1
    80004ffe:	ffffd097          	auipc	ra,0xffffd
    80005002:	122080e7          	jalr	290(ra) # 80002120 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005006:	04054163          	bltz	a0,80005048 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    8000500a:	f6840593          	addi	a1,s0,-152
    8000500e:	4509                	li	a0,2
    80005010:	ffffd097          	auipc	ra,0xffffd
    80005014:	110080e7          	jalr	272(ra) # 80002120 <argint>
     argint(1, &major) < 0 ||
    80005018:	02054863          	bltz	a0,80005048 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000501c:	f6841683          	lh	a3,-152(s0)
    80005020:	f6c41603          	lh	a2,-148(s0)
    80005024:	458d                	li	a1,3
    80005026:	f7040513          	addi	a0,s0,-144
    8000502a:	fffff097          	auipc	ra,0xfffff
    8000502e:	750080e7          	jalr	1872(ra) # 8000477a <create>
     argint(2, &minor) < 0 ||
    80005032:	c919                	beqz	a0,80005048 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	fd4080e7          	jalr	-44(ra) # 80003008 <iunlockput>
  end_op();
    8000503c:	ffffe097          	auipc	ra,0xffffe
    80005040:	7b2080e7          	jalr	1970(ra) # 800037ee <end_op>
  return 0;
    80005044:	4501                	li	a0,0
    80005046:	a031                	j	80005052 <sys_mknod+0x80>
    end_op();
    80005048:	ffffe097          	auipc	ra,0xffffe
    8000504c:	7a6080e7          	jalr	1958(ra) # 800037ee <end_op>
    return -1;
    80005050:	557d                	li	a0,-1
}
    80005052:	60ea                	ld	ra,152(sp)
    80005054:	644a                	ld	s0,144(sp)
    80005056:	610d                	addi	sp,sp,160
    80005058:	8082                	ret

000000008000505a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000505a:	7135                	addi	sp,sp,-160
    8000505c:	ed06                	sd	ra,152(sp)
    8000505e:	e922                	sd	s0,144(sp)
    80005060:	e14a                	sd	s2,128(sp)
    80005062:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005064:	ffffc097          	auipc	ra,0xffffc
    80005068:	f78080e7          	jalr	-136(ra) # 80000fdc <myproc>
    8000506c:	892a                	mv	s2,a0
  
  begin_op();
    8000506e:	ffffe097          	auipc	ra,0xffffe
    80005072:	706080e7          	jalr	1798(ra) # 80003774 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005076:	08000613          	li	a2,128
    8000507a:	f6040593          	addi	a1,s0,-160
    8000507e:	4501                	li	a0,0
    80005080:	ffffd097          	auipc	ra,0xffffd
    80005084:	0e4080e7          	jalr	228(ra) # 80002164 <argstr>
    80005088:	04054d63          	bltz	a0,800050e2 <sys_chdir+0x88>
    8000508c:	e526                	sd	s1,136(sp)
    8000508e:	f6040513          	addi	a0,s0,-160
    80005092:	ffffe097          	auipc	ra,0xffffe
    80005096:	4e2080e7          	jalr	1250(ra) # 80003574 <namei>
    8000509a:	84aa                	mv	s1,a0
    8000509c:	c131                	beqz	a0,800050e0 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	d04080e7          	jalr	-764(ra) # 80002da2 <ilock>
  if(ip->type != T_DIR){
    800050a6:	04449703          	lh	a4,68(s1)
    800050aa:	4785                	li	a5,1
    800050ac:	04f71163          	bne	a4,a5,800050ee <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050b0:	8526                	mv	a0,s1
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	db6080e7          	jalr	-586(ra) # 80002e68 <iunlock>
  iput(p->cwd);
    800050ba:	15093503          	ld	a0,336(s2)
    800050be:	ffffe097          	auipc	ra,0xffffe
    800050c2:	ea2080e7          	jalr	-350(ra) # 80002f60 <iput>
  end_op();
    800050c6:	ffffe097          	auipc	ra,0xffffe
    800050ca:	728080e7          	jalr	1832(ra) # 800037ee <end_op>
  p->cwd = ip;
    800050ce:	14993823          	sd	s1,336(s2)
  return 0;
    800050d2:	4501                	li	a0,0
    800050d4:	64aa                	ld	s1,136(sp)
}
    800050d6:	60ea                	ld	ra,152(sp)
    800050d8:	644a                	ld	s0,144(sp)
    800050da:	690a                	ld	s2,128(sp)
    800050dc:	610d                	addi	sp,sp,160
    800050de:	8082                	ret
    800050e0:	64aa                	ld	s1,136(sp)
    end_op();
    800050e2:	ffffe097          	auipc	ra,0xffffe
    800050e6:	70c080e7          	jalr	1804(ra) # 800037ee <end_op>
    return -1;
    800050ea:	557d                	li	a0,-1
    800050ec:	b7ed                	j	800050d6 <sys_chdir+0x7c>
    iunlockput(ip);
    800050ee:	8526                	mv	a0,s1
    800050f0:	ffffe097          	auipc	ra,0xffffe
    800050f4:	f18080e7          	jalr	-232(ra) # 80003008 <iunlockput>
    end_op();
    800050f8:	ffffe097          	auipc	ra,0xffffe
    800050fc:	6f6080e7          	jalr	1782(ra) # 800037ee <end_op>
    return -1;
    80005100:	557d                	li	a0,-1
    80005102:	64aa                	ld	s1,136(sp)
    80005104:	bfc9                	j	800050d6 <sys_chdir+0x7c>

0000000080005106 <sys_exec>:

uint64
sys_exec(void)
{
    80005106:	7121                	addi	sp,sp,-448
    80005108:	ff06                	sd	ra,440(sp)
    8000510a:	fb22                	sd	s0,432(sp)
    8000510c:	f34a                	sd	s2,416(sp)
    8000510e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005110:	08000613          	li	a2,128
    80005114:	f5040593          	addi	a1,s0,-176
    80005118:	4501                	li	a0,0
    8000511a:	ffffd097          	auipc	ra,0xffffd
    8000511e:	04a080e7          	jalr	74(ra) # 80002164 <argstr>
    return -1;
    80005122:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005124:	0e054a63          	bltz	a0,80005218 <sys_exec+0x112>
    80005128:	e4840593          	addi	a1,s0,-440
    8000512c:	4505                	li	a0,1
    8000512e:	ffffd097          	auipc	ra,0xffffd
    80005132:	014080e7          	jalr	20(ra) # 80002142 <argaddr>
    80005136:	0e054163          	bltz	a0,80005218 <sys_exec+0x112>
    8000513a:	f726                	sd	s1,424(sp)
    8000513c:	ef4e                	sd	s3,408(sp)
    8000513e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005140:	10000613          	li	a2,256
    80005144:	4581                	li	a1,0
    80005146:	e5040513          	addi	a0,s0,-432
    8000514a:	ffffb097          	auipc	ra,0xffffb
    8000514e:	030080e7          	jalr	48(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005152:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005156:	89a6                	mv	s3,s1
    80005158:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000515a:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000515e:	00391513          	slli	a0,s2,0x3
    80005162:	e4040593          	addi	a1,s0,-448
    80005166:	e4843783          	ld	a5,-440(s0)
    8000516a:	953e                	add	a0,a0,a5
    8000516c:	ffffd097          	auipc	ra,0xffffd
    80005170:	f1a080e7          	jalr	-230(ra) # 80002086 <fetchaddr>
    80005174:	02054a63          	bltz	a0,800051a8 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005178:	e4043783          	ld	a5,-448(s0)
    8000517c:	c7b1                	beqz	a5,800051c8 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000517e:	ffffb097          	auipc	ra,0xffffb
    80005182:	f9c080e7          	jalr	-100(ra) # 8000011a <kalloc>
    80005186:	85aa                	mv	a1,a0
    80005188:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000518c:	cd11                	beqz	a0,800051a8 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000518e:	6605                	lui	a2,0x1
    80005190:	e4043503          	ld	a0,-448(s0)
    80005194:	ffffd097          	auipc	ra,0xffffd
    80005198:	f44080e7          	jalr	-188(ra) # 800020d8 <fetchstr>
    8000519c:	00054663          	bltz	a0,800051a8 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    800051a0:	0905                	addi	s2,s2,1
    800051a2:	09a1                	addi	s3,s3,8
    800051a4:	fb491de3          	bne	s2,s4,8000515e <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051a8:	f5040913          	addi	s2,s0,-176
    800051ac:	6088                	ld	a0,0(s1)
    800051ae:	c12d                	beqz	a0,80005210 <sys_exec+0x10a>
    kfree(argv[i]);
    800051b0:	ffffb097          	auipc	ra,0xffffb
    800051b4:	e6c080e7          	jalr	-404(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051b8:	04a1                	addi	s1,s1,8
    800051ba:	ff2499e3          	bne	s1,s2,800051ac <sys_exec+0xa6>
  return -1;
    800051be:	597d                	li	s2,-1
    800051c0:	74ba                	ld	s1,424(sp)
    800051c2:	69fa                	ld	s3,408(sp)
    800051c4:	6a5a                	ld	s4,400(sp)
    800051c6:	a889                	j	80005218 <sys_exec+0x112>
      argv[i] = 0;
    800051c8:	0009079b          	sext.w	a5,s2
    800051cc:	078e                	slli	a5,a5,0x3
    800051ce:	fd078793          	addi	a5,a5,-48
    800051d2:	97a2                	add	a5,a5,s0
    800051d4:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800051d8:	e5040593          	addi	a1,s0,-432
    800051dc:	f5040513          	addi	a0,s0,-176
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	10e080e7          	jalr	270(ra) # 800042ee <exec>
    800051e8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051ea:	f5040993          	addi	s3,s0,-176
    800051ee:	6088                	ld	a0,0(s1)
    800051f0:	cd01                	beqz	a0,80005208 <sys_exec+0x102>
    kfree(argv[i]);
    800051f2:	ffffb097          	auipc	ra,0xffffb
    800051f6:	e2a080e7          	jalr	-470(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051fa:	04a1                	addi	s1,s1,8
    800051fc:	ff3499e3          	bne	s1,s3,800051ee <sys_exec+0xe8>
    80005200:	74ba                	ld	s1,424(sp)
    80005202:	69fa                	ld	s3,408(sp)
    80005204:	6a5a                	ld	s4,400(sp)
    80005206:	a809                	j	80005218 <sys_exec+0x112>
  return ret;
    80005208:	74ba                	ld	s1,424(sp)
    8000520a:	69fa                	ld	s3,408(sp)
    8000520c:	6a5a                	ld	s4,400(sp)
    8000520e:	a029                	j	80005218 <sys_exec+0x112>
  return -1;
    80005210:	597d                	li	s2,-1
    80005212:	74ba                	ld	s1,424(sp)
    80005214:	69fa                	ld	s3,408(sp)
    80005216:	6a5a                	ld	s4,400(sp)
}
    80005218:	854a                	mv	a0,s2
    8000521a:	70fa                	ld	ra,440(sp)
    8000521c:	745a                	ld	s0,432(sp)
    8000521e:	791a                	ld	s2,416(sp)
    80005220:	6139                	addi	sp,sp,448
    80005222:	8082                	ret

0000000080005224 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005224:	7139                	addi	sp,sp,-64
    80005226:	fc06                	sd	ra,56(sp)
    80005228:	f822                	sd	s0,48(sp)
    8000522a:	f426                	sd	s1,40(sp)
    8000522c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000522e:	ffffc097          	auipc	ra,0xffffc
    80005232:	dae080e7          	jalr	-594(ra) # 80000fdc <myproc>
    80005236:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005238:	fd840593          	addi	a1,s0,-40
    8000523c:	4501                	li	a0,0
    8000523e:	ffffd097          	auipc	ra,0xffffd
    80005242:	f04080e7          	jalr	-252(ra) # 80002142 <argaddr>
    return -1;
    80005246:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005248:	0e054063          	bltz	a0,80005328 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    8000524c:	fc840593          	addi	a1,s0,-56
    80005250:	fd040513          	addi	a0,s0,-48
    80005254:	fffff097          	auipc	ra,0xfffff
    80005258:	d58080e7          	jalr	-680(ra) # 80003fac <pipealloc>
    return -1;
    8000525c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000525e:	0c054563          	bltz	a0,80005328 <sys_pipe+0x104>
  fd0 = -1;
    80005262:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005266:	fd043503          	ld	a0,-48(s0)
    8000526a:	fffff097          	auipc	ra,0xfffff
    8000526e:	4ce080e7          	jalr	1230(ra) # 80004738 <fdalloc>
    80005272:	fca42223          	sw	a0,-60(s0)
    80005276:	08054c63          	bltz	a0,8000530e <sys_pipe+0xea>
    8000527a:	fc843503          	ld	a0,-56(s0)
    8000527e:	fffff097          	auipc	ra,0xfffff
    80005282:	4ba080e7          	jalr	1210(ra) # 80004738 <fdalloc>
    80005286:	fca42023          	sw	a0,-64(s0)
    8000528a:	06054963          	bltz	a0,800052fc <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000528e:	4691                	li	a3,4
    80005290:	fc440613          	addi	a2,s0,-60
    80005294:	fd843583          	ld	a1,-40(s0)
    80005298:	68a8                	ld	a0,80(s1)
    8000529a:	ffffc097          	auipc	ra,0xffffc
    8000529e:	87e080e7          	jalr	-1922(ra) # 80000b18 <copyout>
    800052a2:	02054063          	bltz	a0,800052c2 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052a6:	4691                	li	a3,4
    800052a8:	fc040613          	addi	a2,s0,-64
    800052ac:	fd843583          	ld	a1,-40(s0)
    800052b0:	0591                	addi	a1,a1,4
    800052b2:	68a8                	ld	a0,80(s1)
    800052b4:	ffffc097          	auipc	ra,0xffffc
    800052b8:	864080e7          	jalr	-1948(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052bc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052be:	06055563          	bgez	a0,80005328 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800052c2:	fc442783          	lw	a5,-60(s0)
    800052c6:	07e9                	addi	a5,a5,26
    800052c8:	078e                	slli	a5,a5,0x3
    800052ca:	97a6                	add	a5,a5,s1
    800052cc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800052d0:	fc042783          	lw	a5,-64(s0)
    800052d4:	07e9                	addi	a5,a5,26
    800052d6:	078e                	slli	a5,a5,0x3
    800052d8:	00f48533          	add	a0,s1,a5
    800052dc:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800052e0:	fd043503          	ld	a0,-48(s0)
    800052e4:	fffff097          	auipc	ra,0xfffff
    800052e8:	95a080e7          	jalr	-1702(ra) # 80003c3e <fileclose>
    fileclose(wf);
    800052ec:	fc843503          	ld	a0,-56(s0)
    800052f0:	fffff097          	auipc	ra,0xfffff
    800052f4:	94e080e7          	jalr	-1714(ra) # 80003c3e <fileclose>
    return -1;
    800052f8:	57fd                	li	a5,-1
    800052fa:	a03d                	j	80005328 <sys_pipe+0x104>
    if(fd0 >= 0)
    800052fc:	fc442783          	lw	a5,-60(s0)
    80005300:	0007c763          	bltz	a5,8000530e <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005304:	07e9                	addi	a5,a5,26
    80005306:	078e                	slli	a5,a5,0x3
    80005308:	97a6                	add	a5,a5,s1
    8000530a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000530e:	fd043503          	ld	a0,-48(s0)
    80005312:	fffff097          	auipc	ra,0xfffff
    80005316:	92c080e7          	jalr	-1748(ra) # 80003c3e <fileclose>
    fileclose(wf);
    8000531a:	fc843503          	ld	a0,-56(s0)
    8000531e:	fffff097          	auipc	ra,0xfffff
    80005322:	920080e7          	jalr	-1760(ra) # 80003c3e <fileclose>
    return -1;
    80005326:	57fd                	li	a5,-1
}
    80005328:	853e                	mv	a0,a5
    8000532a:	70e2                	ld	ra,56(sp)
    8000532c:	7442                	ld	s0,48(sp)
    8000532e:	74a2                	ld	s1,40(sp)
    80005330:	6121                	addi	sp,sp,64
    80005332:	8082                	ret
	...

0000000080005340 <kernelvec>:
    80005340:	7111                	addi	sp,sp,-256
    80005342:	e006                	sd	ra,0(sp)
    80005344:	e40a                	sd	sp,8(sp)
    80005346:	e80e                	sd	gp,16(sp)
    80005348:	ec12                	sd	tp,24(sp)
    8000534a:	f016                	sd	t0,32(sp)
    8000534c:	f41a                	sd	t1,40(sp)
    8000534e:	f81e                	sd	t2,48(sp)
    80005350:	fc22                	sd	s0,56(sp)
    80005352:	e0a6                	sd	s1,64(sp)
    80005354:	e4aa                	sd	a0,72(sp)
    80005356:	e8ae                	sd	a1,80(sp)
    80005358:	ecb2                	sd	a2,88(sp)
    8000535a:	f0b6                	sd	a3,96(sp)
    8000535c:	f4ba                	sd	a4,104(sp)
    8000535e:	f8be                	sd	a5,112(sp)
    80005360:	fcc2                	sd	a6,120(sp)
    80005362:	e146                	sd	a7,128(sp)
    80005364:	e54a                	sd	s2,136(sp)
    80005366:	e94e                	sd	s3,144(sp)
    80005368:	ed52                	sd	s4,152(sp)
    8000536a:	f156                	sd	s5,160(sp)
    8000536c:	f55a                	sd	s6,168(sp)
    8000536e:	f95e                	sd	s7,176(sp)
    80005370:	fd62                	sd	s8,184(sp)
    80005372:	e1e6                	sd	s9,192(sp)
    80005374:	e5ea                	sd	s10,200(sp)
    80005376:	e9ee                	sd	s11,208(sp)
    80005378:	edf2                	sd	t3,216(sp)
    8000537a:	f1f6                	sd	t4,224(sp)
    8000537c:	f5fa                	sd	t5,232(sp)
    8000537e:	f9fe                	sd	t6,240(sp)
    80005380:	bd3fc0ef          	jal	80001f52 <kerneltrap>
    80005384:	6082                	ld	ra,0(sp)
    80005386:	6122                	ld	sp,8(sp)
    80005388:	61c2                	ld	gp,16(sp)
    8000538a:	7282                	ld	t0,32(sp)
    8000538c:	7322                	ld	t1,40(sp)
    8000538e:	73c2                	ld	t2,48(sp)
    80005390:	7462                	ld	s0,56(sp)
    80005392:	6486                	ld	s1,64(sp)
    80005394:	6526                	ld	a0,72(sp)
    80005396:	65c6                	ld	a1,80(sp)
    80005398:	6666                	ld	a2,88(sp)
    8000539a:	7686                	ld	a3,96(sp)
    8000539c:	7726                	ld	a4,104(sp)
    8000539e:	77c6                	ld	a5,112(sp)
    800053a0:	7866                	ld	a6,120(sp)
    800053a2:	688a                	ld	a7,128(sp)
    800053a4:	692a                	ld	s2,136(sp)
    800053a6:	69ca                	ld	s3,144(sp)
    800053a8:	6a6a                	ld	s4,152(sp)
    800053aa:	7a8a                	ld	s5,160(sp)
    800053ac:	7b2a                	ld	s6,168(sp)
    800053ae:	7bca                	ld	s7,176(sp)
    800053b0:	7c6a                	ld	s8,184(sp)
    800053b2:	6c8e                	ld	s9,192(sp)
    800053b4:	6d2e                	ld	s10,200(sp)
    800053b6:	6dce                	ld	s11,208(sp)
    800053b8:	6e6e                	ld	t3,216(sp)
    800053ba:	7e8e                	ld	t4,224(sp)
    800053bc:	7f2e                	ld	t5,232(sp)
    800053be:	7fce                	ld	t6,240(sp)
    800053c0:	6111                	addi	sp,sp,256
    800053c2:	10200073          	sret
    800053c6:	00000013          	nop
    800053ca:	00000013          	nop
    800053ce:	0001                	nop

00000000800053d0 <timervec>:
    800053d0:	34051573          	csrrw	a0,mscratch,a0
    800053d4:	e10c                	sd	a1,0(a0)
    800053d6:	e510                	sd	a2,8(a0)
    800053d8:	e914                	sd	a3,16(a0)
    800053da:	6d0c                	ld	a1,24(a0)
    800053dc:	7110                	ld	a2,32(a0)
    800053de:	6194                	ld	a3,0(a1)
    800053e0:	96b2                	add	a3,a3,a2
    800053e2:	e194                	sd	a3,0(a1)
    800053e4:	4589                	li	a1,2
    800053e6:	14459073          	csrw	sip,a1
    800053ea:	6914                	ld	a3,16(a0)
    800053ec:	6510                	ld	a2,8(a0)
    800053ee:	610c                	ld	a1,0(a0)
    800053f0:	34051573          	csrrw	a0,mscratch,a0
    800053f4:	30200073          	mret
	...

00000000800053fa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053fa:	1141                	addi	sp,sp,-16
    800053fc:	e422                	sd	s0,8(sp)
    800053fe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005400:	0c0007b7          	lui	a5,0xc000
    80005404:	4705                	li	a4,1
    80005406:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005408:	0c0007b7          	lui	a5,0xc000
    8000540c:	c3d8                	sw	a4,4(a5)
}
    8000540e:	6422                	ld	s0,8(sp)
    80005410:	0141                	addi	sp,sp,16
    80005412:	8082                	ret

0000000080005414 <plicinithart>:

void
plicinithart(void)
{
    80005414:	1141                	addi	sp,sp,-16
    80005416:	e406                	sd	ra,8(sp)
    80005418:	e022                	sd	s0,0(sp)
    8000541a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000541c:	ffffc097          	auipc	ra,0xffffc
    80005420:	b94080e7          	jalr	-1132(ra) # 80000fb0 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005424:	0085171b          	slliw	a4,a0,0x8
    80005428:	0c0027b7          	lui	a5,0xc002
    8000542c:	97ba                	add	a5,a5,a4
    8000542e:	40200713          	li	a4,1026
    80005432:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005436:	00d5151b          	slliw	a0,a0,0xd
    8000543a:	0c2017b7          	lui	a5,0xc201
    8000543e:	97aa                	add	a5,a5,a0
    80005440:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005444:	60a2                	ld	ra,8(sp)
    80005446:	6402                	ld	s0,0(sp)
    80005448:	0141                	addi	sp,sp,16
    8000544a:	8082                	ret

000000008000544c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000544c:	1141                	addi	sp,sp,-16
    8000544e:	e406                	sd	ra,8(sp)
    80005450:	e022                	sd	s0,0(sp)
    80005452:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005454:	ffffc097          	auipc	ra,0xffffc
    80005458:	b5c080e7          	jalr	-1188(ra) # 80000fb0 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000545c:	00d5151b          	slliw	a0,a0,0xd
    80005460:	0c2017b7          	lui	a5,0xc201
    80005464:	97aa                	add	a5,a5,a0
  return irq;
}
    80005466:	43c8                	lw	a0,4(a5)
    80005468:	60a2                	ld	ra,8(sp)
    8000546a:	6402                	ld	s0,0(sp)
    8000546c:	0141                	addi	sp,sp,16
    8000546e:	8082                	ret

0000000080005470 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005470:	1101                	addi	sp,sp,-32
    80005472:	ec06                	sd	ra,24(sp)
    80005474:	e822                	sd	s0,16(sp)
    80005476:	e426                	sd	s1,8(sp)
    80005478:	1000                	addi	s0,sp,32
    8000547a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000547c:	ffffc097          	auipc	ra,0xffffc
    80005480:	b34080e7          	jalr	-1228(ra) # 80000fb0 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005484:	00d5151b          	slliw	a0,a0,0xd
    80005488:	0c2017b7          	lui	a5,0xc201
    8000548c:	97aa                	add	a5,a5,a0
    8000548e:	c3c4                	sw	s1,4(a5)
}
    80005490:	60e2                	ld	ra,24(sp)
    80005492:	6442                	ld	s0,16(sp)
    80005494:	64a2                	ld	s1,8(sp)
    80005496:	6105                	addi	sp,sp,32
    80005498:	8082                	ret

000000008000549a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000549a:	1141                	addi	sp,sp,-16
    8000549c:	e406                	sd	ra,8(sp)
    8000549e:	e022                	sd	s0,0(sp)
    800054a0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054a2:	479d                	li	a5,7
    800054a4:	06a7c863          	blt	a5,a0,80005514 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800054a8:	00016717          	auipc	a4,0x16
    800054ac:	b5870713          	addi	a4,a4,-1192 # 8001b000 <disk>
    800054b0:	972a                	add	a4,a4,a0
    800054b2:	6789                	lui	a5,0x2
    800054b4:	97ba                	add	a5,a5,a4
    800054b6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800054ba:	e7ad                	bnez	a5,80005524 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054bc:	00451793          	slli	a5,a0,0x4
    800054c0:	00018717          	auipc	a4,0x18
    800054c4:	b4070713          	addi	a4,a4,-1216 # 8001d000 <disk+0x2000>
    800054c8:	6314                	ld	a3,0(a4)
    800054ca:	96be                	add	a3,a3,a5
    800054cc:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800054d0:	6314                	ld	a3,0(a4)
    800054d2:	96be                	add	a3,a3,a5
    800054d4:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800054d8:	6314                	ld	a3,0(a4)
    800054da:	96be                	add	a3,a3,a5
    800054dc:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800054e0:	6318                	ld	a4,0(a4)
    800054e2:	97ba                	add	a5,a5,a4
    800054e4:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    800054e8:	00016717          	auipc	a4,0x16
    800054ec:	b1870713          	addi	a4,a4,-1256 # 8001b000 <disk>
    800054f0:	972a                	add	a4,a4,a0
    800054f2:	6789                	lui	a5,0x2
    800054f4:	97ba                	add	a5,a5,a4
    800054f6:	4705                	li	a4,1
    800054f8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054fc:	00018517          	auipc	a0,0x18
    80005500:	b1c50513          	addi	a0,a0,-1252 # 8001d018 <disk+0x2018>
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	3ae080e7          	jalr	942(ra) # 800018b2 <wakeup>
}
    8000550c:	60a2                	ld	ra,8(sp)
    8000550e:	6402                	ld	s0,0(sp)
    80005510:	0141                	addi	sp,sp,16
    80005512:	8082                	ret
    panic("free_desc 1");
    80005514:	00003517          	auipc	a0,0x3
    80005518:	12450513          	addi	a0,a0,292 # 80008638 <etext+0x638>
    8000551c:	00001097          	auipc	ra,0x1
    80005520:	a10080e7          	jalr	-1520(ra) # 80005f2c <panic>
    panic("free_desc 2");
    80005524:	00003517          	auipc	a0,0x3
    80005528:	12450513          	addi	a0,a0,292 # 80008648 <etext+0x648>
    8000552c:	00001097          	auipc	ra,0x1
    80005530:	a00080e7          	jalr	-1536(ra) # 80005f2c <panic>

0000000080005534 <virtio_disk_init>:
{
    80005534:	1141                	addi	sp,sp,-16
    80005536:	e406                	sd	ra,8(sp)
    80005538:	e022                	sd	s0,0(sp)
    8000553a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000553c:	00003597          	auipc	a1,0x3
    80005540:	11c58593          	addi	a1,a1,284 # 80008658 <etext+0x658>
    80005544:	00018517          	auipc	a0,0x18
    80005548:	be450513          	addi	a0,a0,-1052 # 8001d128 <disk+0x2128>
    8000554c:	00001097          	auipc	ra,0x1
    80005550:	eca080e7          	jalr	-310(ra) # 80006416 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005554:	100017b7          	lui	a5,0x10001
    80005558:	4398                	lw	a4,0(a5)
    8000555a:	2701                	sext.w	a4,a4
    8000555c:	747277b7          	lui	a5,0x74727
    80005560:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005564:	0ef71f63          	bne	a4,a5,80005662 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005568:	100017b7          	lui	a5,0x10001
    8000556c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000556e:	439c                	lw	a5,0(a5)
    80005570:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005572:	4705                	li	a4,1
    80005574:	0ee79763          	bne	a5,a4,80005662 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005578:	100017b7          	lui	a5,0x10001
    8000557c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000557e:	439c                	lw	a5,0(a5)
    80005580:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005582:	4709                	li	a4,2
    80005584:	0ce79f63          	bne	a5,a4,80005662 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005588:	100017b7          	lui	a5,0x10001
    8000558c:	47d8                	lw	a4,12(a5)
    8000558e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005590:	554d47b7          	lui	a5,0x554d4
    80005594:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005598:	0cf71563          	bne	a4,a5,80005662 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000559c:	100017b7          	lui	a5,0x10001
    800055a0:	4705                	li	a4,1
    800055a2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a4:	470d                	li	a4,3
    800055a6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055a8:	10001737          	lui	a4,0x10001
    800055ac:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055ae:	c7ffe737          	lui	a4,0xc7ffe
    800055b2:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055b6:	8ef9                	and	a3,a3,a4
    800055b8:	10001737          	lui	a4,0x10001
    800055bc:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055be:	472d                	li	a4,11
    800055c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c2:	473d                	li	a4,15
    800055c4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800055c6:	100017b7          	lui	a5,0x10001
    800055ca:	6705                	lui	a4,0x1
    800055cc:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055ce:	100017b7          	lui	a5,0x10001
    800055d2:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055d6:	100017b7          	lui	a5,0x10001
    800055da:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800055de:	439c                	lw	a5,0(a5)
    800055e0:	2781                	sext.w	a5,a5
  if(max == 0)
    800055e2:	cbc1                	beqz	a5,80005672 <virtio_disk_init+0x13e>
  if(max < NUM)
    800055e4:	471d                	li	a4,7
    800055e6:	08f77e63          	bgeu	a4,a5,80005682 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055ea:	100017b7          	lui	a5,0x10001
    800055ee:	4721                	li	a4,8
    800055f0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055f2:	6609                	lui	a2,0x2
    800055f4:	4581                	li	a1,0
    800055f6:	00016517          	auipc	a0,0x16
    800055fa:	a0a50513          	addi	a0,a0,-1526 # 8001b000 <disk>
    800055fe:	ffffb097          	auipc	ra,0xffffb
    80005602:	b7c080e7          	jalr	-1156(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005606:	00016697          	auipc	a3,0x16
    8000560a:	9fa68693          	addi	a3,a3,-1542 # 8001b000 <disk>
    8000560e:	00c6d713          	srli	a4,a3,0xc
    80005612:	2701                	sext.w	a4,a4
    80005614:	100017b7          	lui	a5,0x10001
    80005618:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000561a:	00018797          	auipc	a5,0x18
    8000561e:	9e678793          	addi	a5,a5,-1562 # 8001d000 <disk+0x2000>
    80005622:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005624:	00016717          	auipc	a4,0x16
    80005628:	a5c70713          	addi	a4,a4,-1444 # 8001b080 <disk+0x80>
    8000562c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000562e:	00017717          	auipc	a4,0x17
    80005632:	9d270713          	addi	a4,a4,-1582 # 8001c000 <disk+0x1000>
    80005636:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005638:	4705                	li	a4,1
    8000563a:	00e78c23          	sb	a4,24(a5)
    8000563e:	00e78ca3          	sb	a4,25(a5)
    80005642:	00e78d23          	sb	a4,26(a5)
    80005646:	00e78da3          	sb	a4,27(a5)
    8000564a:	00e78e23          	sb	a4,28(a5)
    8000564e:	00e78ea3          	sb	a4,29(a5)
    80005652:	00e78f23          	sb	a4,30(a5)
    80005656:	00e78fa3          	sb	a4,31(a5)
}
    8000565a:	60a2                	ld	ra,8(sp)
    8000565c:	6402                	ld	s0,0(sp)
    8000565e:	0141                	addi	sp,sp,16
    80005660:	8082                	ret
    panic("could not find virtio disk");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	00650513          	addi	a0,a0,6 # 80008668 <etext+0x668>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	8c2080e7          	jalr	-1854(ra) # 80005f2c <panic>
    panic("virtio disk has no queue 0");
    80005672:	00003517          	auipc	a0,0x3
    80005676:	01650513          	addi	a0,a0,22 # 80008688 <etext+0x688>
    8000567a:	00001097          	auipc	ra,0x1
    8000567e:	8b2080e7          	jalr	-1870(ra) # 80005f2c <panic>
    panic("virtio disk max queue too short");
    80005682:	00003517          	auipc	a0,0x3
    80005686:	02650513          	addi	a0,a0,38 # 800086a8 <etext+0x6a8>
    8000568a:	00001097          	auipc	ra,0x1
    8000568e:	8a2080e7          	jalr	-1886(ra) # 80005f2c <panic>

0000000080005692 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005692:	7159                	addi	sp,sp,-112
    80005694:	f486                	sd	ra,104(sp)
    80005696:	f0a2                	sd	s0,96(sp)
    80005698:	eca6                	sd	s1,88(sp)
    8000569a:	e8ca                	sd	s2,80(sp)
    8000569c:	e4ce                	sd	s3,72(sp)
    8000569e:	e0d2                	sd	s4,64(sp)
    800056a0:	fc56                	sd	s5,56(sp)
    800056a2:	f85a                	sd	s6,48(sp)
    800056a4:	f45e                	sd	s7,40(sp)
    800056a6:	f062                	sd	s8,32(sp)
    800056a8:	ec66                	sd	s9,24(sp)
    800056aa:	1880                	addi	s0,sp,112
    800056ac:	8a2a                	mv	s4,a0
    800056ae:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056b0:	00c52c03          	lw	s8,12(a0)
    800056b4:	001c1c1b          	slliw	s8,s8,0x1
    800056b8:	1c02                	slli	s8,s8,0x20
    800056ba:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    800056be:	00018517          	auipc	a0,0x18
    800056c2:	a6a50513          	addi	a0,a0,-1430 # 8001d128 <disk+0x2128>
    800056c6:	00001097          	auipc	ra,0x1
    800056ca:	de0080e7          	jalr	-544(ra) # 800064a6 <acquire>
  for(int i = 0; i < 3; i++){
    800056ce:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056d0:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056d2:	00016b97          	auipc	s7,0x16
    800056d6:	92eb8b93          	addi	s7,s7,-1746 # 8001b000 <disk>
    800056da:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    800056dc:	4a8d                	li	s5,3
    800056de:	a88d                	j	80005750 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    800056e0:	00fb8733          	add	a4,s7,a5
    800056e4:	975a                	add	a4,a4,s6
    800056e6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056ea:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056ec:	0207c563          	bltz	a5,80005716 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800056f0:	2905                	addiw	s2,s2,1
    800056f2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056f4:	1b590163          	beq	s2,s5,80005896 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800056f8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056fa:	00018717          	auipc	a4,0x18
    800056fe:	91e70713          	addi	a4,a4,-1762 # 8001d018 <disk+0x2018>
    80005702:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005704:	00074683          	lbu	a3,0(a4)
    80005708:	fee1                	bnez	a3,800056e0 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000570a:	2785                	addiw	a5,a5,1
    8000570c:	0705                	addi	a4,a4,1
    8000570e:	fe979be3          	bne	a5,s1,80005704 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005712:	57fd                	li	a5,-1
    80005714:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005716:	03205163          	blez	s2,80005738 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000571a:	f9042503          	lw	a0,-112(s0)
    8000571e:	00000097          	auipc	ra,0x0
    80005722:	d7c080e7          	jalr	-644(ra) # 8000549a <free_desc>
      for(int j = 0; j < i; j++)
    80005726:	4785                	li	a5,1
    80005728:	0127d863          	bge	a5,s2,80005738 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000572c:	f9442503          	lw	a0,-108(s0)
    80005730:	00000097          	auipc	ra,0x0
    80005734:	d6a080e7          	jalr	-662(ra) # 8000549a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005738:	00018597          	auipc	a1,0x18
    8000573c:	9f058593          	addi	a1,a1,-1552 # 8001d128 <disk+0x2128>
    80005740:	00018517          	auipc	a0,0x18
    80005744:	8d850513          	addi	a0,a0,-1832 # 8001d018 <disk+0x2018>
    80005748:	ffffc097          	auipc	ra,0xffffc
    8000574c:	fde080e7          	jalr	-34(ra) # 80001726 <sleep>
  for(int i = 0; i < 3; i++){
    80005750:	f9040613          	addi	a2,s0,-112
    80005754:	894e                	mv	s2,s3
    80005756:	b74d                	j	800056f8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005758:	00018717          	auipc	a4,0x18
    8000575c:	8a873703          	ld	a4,-1880(a4) # 8001d000 <disk+0x2000>
    80005760:	973e                	add	a4,a4,a5
    80005762:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005766:	00016897          	auipc	a7,0x16
    8000576a:	89a88893          	addi	a7,a7,-1894 # 8001b000 <disk>
    8000576e:	00018717          	auipc	a4,0x18
    80005772:	89270713          	addi	a4,a4,-1902 # 8001d000 <disk+0x2000>
    80005776:	6314                	ld	a3,0(a4)
    80005778:	96be                	add	a3,a3,a5
    8000577a:	00c6d583          	lhu	a1,12(a3)
    8000577e:	0015e593          	ori	a1,a1,1
    80005782:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005786:	f9842683          	lw	a3,-104(s0)
    8000578a:	630c                	ld	a1,0(a4)
    8000578c:	97ae                	add	a5,a5,a1
    8000578e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005792:	20050593          	addi	a1,a0,512
    80005796:	0592                	slli	a1,a1,0x4
    80005798:	95c6                	add	a1,a1,a7
    8000579a:	57fd                	li	a5,-1
    8000579c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057a0:	00469793          	slli	a5,a3,0x4
    800057a4:	00073803          	ld	a6,0(a4)
    800057a8:	983e                	add	a6,a6,a5
    800057aa:	6689                	lui	a3,0x2
    800057ac:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    800057b0:	96b2                	add	a3,a3,a2
    800057b2:	96c6                	add	a3,a3,a7
    800057b4:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800057b8:	6314                	ld	a3,0(a4)
    800057ba:	96be                	add	a3,a3,a5
    800057bc:	4605                	li	a2,1
    800057be:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057c0:	6314                	ld	a3,0(a4)
    800057c2:	96be                	add	a3,a3,a5
    800057c4:	4809                	li	a6,2
    800057c6:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800057ca:	6314                	ld	a3,0(a4)
    800057cc:	97b6                	add	a5,a5,a3
    800057ce:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057d2:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    800057d6:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057da:	6714                	ld	a3,8(a4)
    800057dc:	0026d783          	lhu	a5,2(a3)
    800057e0:	8b9d                	andi	a5,a5,7
    800057e2:	0786                	slli	a5,a5,0x1
    800057e4:	96be                	add	a3,a3,a5
    800057e6:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057ea:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057ee:	6718                	ld	a4,8(a4)
    800057f0:	00275783          	lhu	a5,2(a4)
    800057f4:	2785                	addiw	a5,a5,1
    800057f6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057fa:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057fe:	100017b7          	lui	a5,0x10001
    80005802:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005806:	004a2783          	lw	a5,4(s4)
    8000580a:	02c79163          	bne	a5,a2,8000582c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000580e:	00018917          	auipc	s2,0x18
    80005812:	91a90913          	addi	s2,s2,-1766 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005816:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005818:	85ca                	mv	a1,s2
    8000581a:	8552                	mv	a0,s4
    8000581c:	ffffc097          	auipc	ra,0xffffc
    80005820:	f0a080e7          	jalr	-246(ra) # 80001726 <sleep>
  while(b->disk == 1) {
    80005824:	004a2783          	lw	a5,4(s4)
    80005828:	fe9788e3          	beq	a5,s1,80005818 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000582c:	f9042903          	lw	s2,-112(s0)
    80005830:	20090713          	addi	a4,s2,512
    80005834:	0712                	slli	a4,a4,0x4
    80005836:	00015797          	auipc	a5,0x15
    8000583a:	7ca78793          	addi	a5,a5,1994 # 8001b000 <disk>
    8000583e:	97ba                	add	a5,a5,a4
    80005840:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005844:	00017997          	auipc	s3,0x17
    80005848:	7bc98993          	addi	s3,s3,1980 # 8001d000 <disk+0x2000>
    8000584c:	00491713          	slli	a4,s2,0x4
    80005850:	0009b783          	ld	a5,0(s3)
    80005854:	97ba                	add	a5,a5,a4
    80005856:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000585a:	854a                	mv	a0,s2
    8000585c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005860:	00000097          	auipc	ra,0x0
    80005864:	c3a080e7          	jalr	-966(ra) # 8000549a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005868:	8885                	andi	s1,s1,1
    8000586a:	f0ed                	bnez	s1,8000584c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000586c:	00018517          	auipc	a0,0x18
    80005870:	8bc50513          	addi	a0,a0,-1860 # 8001d128 <disk+0x2128>
    80005874:	00001097          	auipc	ra,0x1
    80005878:	ce6080e7          	jalr	-794(ra) # 8000655a <release>
}
    8000587c:	70a6                	ld	ra,104(sp)
    8000587e:	7406                	ld	s0,96(sp)
    80005880:	64e6                	ld	s1,88(sp)
    80005882:	6946                	ld	s2,80(sp)
    80005884:	69a6                	ld	s3,72(sp)
    80005886:	6a06                	ld	s4,64(sp)
    80005888:	7ae2                	ld	s5,56(sp)
    8000588a:	7b42                	ld	s6,48(sp)
    8000588c:	7ba2                	ld	s7,40(sp)
    8000588e:	7c02                	ld	s8,32(sp)
    80005890:	6ce2                	ld	s9,24(sp)
    80005892:	6165                	addi	sp,sp,112
    80005894:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005896:	f9042503          	lw	a0,-112(s0)
    8000589a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000589e:	00015597          	auipc	a1,0x15
    800058a2:	76258593          	addi	a1,a1,1890 # 8001b000 <disk>
    800058a6:	20050793          	addi	a5,a0,512
    800058aa:	0792                	slli	a5,a5,0x4
    800058ac:	97ae                	add	a5,a5,a1
    800058ae:	01903733          	snez	a4,s9
    800058b2:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    800058b6:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800058ba:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058be:	00017717          	auipc	a4,0x17
    800058c2:	74270713          	addi	a4,a4,1858 # 8001d000 <disk+0x2000>
    800058c6:	6314                	ld	a3,0(a4)
    800058c8:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058ca:	6789                	lui	a5,0x2
    800058cc:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800058d0:	97b2                	add	a5,a5,a2
    800058d2:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058d4:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058d6:	631c                	ld	a5,0(a4)
    800058d8:	97b2                	add	a5,a5,a2
    800058da:	46c1                	li	a3,16
    800058dc:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058de:	631c                	ld	a5,0(a4)
    800058e0:	97b2                	add	a5,a5,a2
    800058e2:	4685                	li	a3,1
    800058e4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800058e8:	f9442783          	lw	a5,-108(s0)
    800058ec:	6314                	ld	a3,0(a4)
    800058ee:	96b2                	add	a3,a3,a2
    800058f0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058f4:	0792                	slli	a5,a5,0x4
    800058f6:	6314                	ld	a3,0(a4)
    800058f8:	96be                	add	a3,a3,a5
    800058fa:	058a0593          	addi	a1,s4,88
    800058fe:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005900:	6318                	ld	a4,0(a4)
    80005902:	973e                	add	a4,a4,a5
    80005904:	40000693          	li	a3,1024
    80005908:	c714                	sw	a3,8(a4)
  if(write)
    8000590a:	e40c97e3          	bnez	s9,80005758 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000590e:	00017717          	auipc	a4,0x17
    80005912:	6f273703          	ld	a4,1778(a4) # 8001d000 <disk+0x2000>
    80005916:	973e                	add	a4,a4,a5
    80005918:	4689                	li	a3,2
    8000591a:	00d71623          	sh	a3,12(a4)
    8000591e:	b5a1                	j	80005766 <virtio_disk_rw+0xd4>

0000000080005920 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005920:	1101                	addi	sp,sp,-32
    80005922:	ec06                	sd	ra,24(sp)
    80005924:	e822                	sd	s0,16(sp)
    80005926:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005928:	00018517          	auipc	a0,0x18
    8000592c:	80050513          	addi	a0,a0,-2048 # 8001d128 <disk+0x2128>
    80005930:	00001097          	auipc	ra,0x1
    80005934:	b76080e7          	jalr	-1162(ra) # 800064a6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005938:	100017b7          	lui	a5,0x10001
    8000593c:	53b8                	lw	a4,96(a5)
    8000593e:	8b0d                	andi	a4,a4,3
    80005940:	100017b7          	lui	a5,0x10001
    80005944:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005946:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000594a:	00017797          	auipc	a5,0x17
    8000594e:	6b678793          	addi	a5,a5,1718 # 8001d000 <disk+0x2000>
    80005952:	6b94                	ld	a3,16(a5)
    80005954:	0207d703          	lhu	a4,32(a5)
    80005958:	0026d783          	lhu	a5,2(a3)
    8000595c:	06f70563          	beq	a4,a5,800059c6 <virtio_disk_intr+0xa6>
    80005960:	e426                	sd	s1,8(sp)
    80005962:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005964:	00015917          	auipc	s2,0x15
    80005968:	69c90913          	addi	s2,s2,1692 # 8001b000 <disk>
    8000596c:	00017497          	auipc	s1,0x17
    80005970:	69448493          	addi	s1,s1,1684 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005974:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005978:	6898                	ld	a4,16(s1)
    8000597a:	0204d783          	lhu	a5,32(s1)
    8000597e:	8b9d                	andi	a5,a5,7
    80005980:	078e                	slli	a5,a5,0x3
    80005982:	97ba                	add	a5,a5,a4
    80005984:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005986:	20078713          	addi	a4,a5,512
    8000598a:	0712                	slli	a4,a4,0x4
    8000598c:	974a                	add	a4,a4,s2
    8000598e:	03074703          	lbu	a4,48(a4)
    80005992:	e731                	bnez	a4,800059de <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005994:	20078793          	addi	a5,a5,512
    80005998:	0792                	slli	a5,a5,0x4
    8000599a:	97ca                	add	a5,a5,s2
    8000599c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000599e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059a2:	ffffc097          	auipc	ra,0xffffc
    800059a6:	f10080e7          	jalr	-240(ra) # 800018b2 <wakeup>

    disk.used_idx += 1;
    800059aa:	0204d783          	lhu	a5,32(s1)
    800059ae:	2785                	addiw	a5,a5,1
    800059b0:	17c2                	slli	a5,a5,0x30
    800059b2:	93c1                	srli	a5,a5,0x30
    800059b4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059b8:	6898                	ld	a4,16(s1)
    800059ba:	00275703          	lhu	a4,2(a4)
    800059be:	faf71be3          	bne	a4,a5,80005974 <virtio_disk_intr+0x54>
    800059c2:	64a2                	ld	s1,8(sp)
    800059c4:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800059c6:	00017517          	auipc	a0,0x17
    800059ca:	76250513          	addi	a0,a0,1890 # 8001d128 <disk+0x2128>
    800059ce:	00001097          	auipc	ra,0x1
    800059d2:	b8c080e7          	jalr	-1140(ra) # 8000655a <release>
}
    800059d6:	60e2                	ld	ra,24(sp)
    800059d8:	6442                	ld	s0,16(sp)
    800059da:	6105                	addi	sp,sp,32
    800059dc:	8082                	ret
      panic("virtio_disk_intr status");
    800059de:	00003517          	auipc	a0,0x3
    800059e2:	cea50513          	addi	a0,a0,-790 # 800086c8 <etext+0x6c8>
    800059e6:	00000097          	auipc	ra,0x0
    800059ea:	546080e7          	jalr	1350(ra) # 80005f2c <panic>

00000000800059ee <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800059ee:	1141                	addi	sp,sp,-16
    800059f0:	e422                	sd	s0,8(sp)
    800059f2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059f4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059f8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059fc:	0037979b          	slliw	a5,a5,0x3
    80005a00:	02004737          	lui	a4,0x2004
    80005a04:	97ba                	add	a5,a5,a4
    80005a06:	0200c737          	lui	a4,0x200c
    80005a0a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    80005a0c:	6318                	ld	a4,0(a4)
    80005a0e:	000f4637          	lui	a2,0xf4
    80005a12:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005a16:	9732                	add	a4,a4,a2
    80005a18:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a1a:	00259693          	slli	a3,a1,0x2
    80005a1e:	96ae                	add	a3,a3,a1
    80005a20:	068e                	slli	a3,a3,0x3
    80005a22:	00018717          	auipc	a4,0x18
    80005a26:	5de70713          	addi	a4,a4,1502 # 8001e000 <timer_scratch>
    80005a2a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a2c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a2e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a30:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a34:	00000797          	auipc	a5,0x0
    80005a38:	99c78793          	addi	a5,a5,-1636 # 800053d0 <timervec>
    80005a3c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a40:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a44:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a48:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a4c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a50:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a54:	30479073          	csrw	mie,a5
}
    80005a58:	6422                	ld	s0,8(sp)
    80005a5a:	0141                	addi	sp,sp,16
    80005a5c:	8082                	ret

0000000080005a5e <start>:
{
    80005a5e:	1141                	addi	sp,sp,-16
    80005a60:	e406                	sd	ra,8(sp)
    80005a62:	e022                	sd	s0,0(sp)
    80005a64:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a66:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a6a:	7779                	lui	a4,0xffffe
    80005a6c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005a70:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a72:	6705                	lui	a4,0x1
    80005a74:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a78:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a7a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a7e:	ffffb797          	auipc	a5,0xffffb
    80005a82:	89a78793          	addi	a5,a5,-1894 # 80000318 <main>
    80005a86:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a8a:	4781                	li	a5,0
    80005a8c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a90:	67c1                	lui	a5,0x10
    80005a92:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a94:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a98:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a9c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005aa0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005aa4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005aa8:	57fd                	li	a5,-1
    80005aaa:	83a9                	srli	a5,a5,0xa
    80005aac:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005ab0:	47bd                	li	a5,15
    80005ab2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005ab6:	00000097          	auipc	ra,0x0
    80005aba:	f38080e7          	jalr	-200(ra) # 800059ee <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005abe:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ac2:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ac4:	823e                	mv	tp,a5
  asm volatile("mret");
    80005ac6:	30200073          	mret
}
    80005aca:	60a2                	ld	ra,8(sp)
    80005acc:	6402                	ld	s0,0(sp)
    80005ace:	0141                	addi	sp,sp,16
    80005ad0:	8082                	ret

0000000080005ad2 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005ad2:	715d                	addi	sp,sp,-80
    80005ad4:	e486                	sd	ra,72(sp)
    80005ad6:	e0a2                	sd	s0,64(sp)
    80005ad8:	f84a                	sd	s2,48(sp)
    80005ada:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005adc:	04c05663          	blez	a2,80005b28 <consolewrite+0x56>
    80005ae0:	fc26                	sd	s1,56(sp)
    80005ae2:	f44e                	sd	s3,40(sp)
    80005ae4:	f052                	sd	s4,32(sp)
    80005ae6:	ec56                	sd	s5,24(sp)
    80005ae8:	8a2a                	mv	s4,a0
    80005aea:	84ae                	mv	s1,a1
    80005aec:	89b2                	mv	s3,a2
    80005aee:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005af0:	5afd                	li	s5,-1
    80005af2:	4685                	li	a3,1
    80005af4:	8626                	mv	a2,s1
    80005af6:	85d2                	mv	a1,s4
    80005af8:	fbf40513          	addi	a0,s0,-65
    80005afc:	ffffc097          	auipc	ra,0xffffc
    80005b00:	024080e7          	jalr	36(ra) # 80001b20 <either_copyin>
    80005b04:	03550463          	beq	a0,s5,80005b2c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005b08:	fbf44503          	lbu	a0,-65(s0)
    80005b0c:	00000097          	auipc	ra,0x0
    80005b10:	7de080e7          	jalr	2014(ra) # 800062ea <uartputc>
  for(i = 0; i < n; i++){
    80005b14:	2905                	addiw	s2,s2,1
    80005b16:	0485                	addi	s1,s1,1
    80005b18:	fd299de3          	bne	s3,s2,80005af2 <consolewrite+0x20>
    80005b1c:	894e                	mv	s2,s3
    80005b1e:	74e2                	ld	s1,56(sp)
    80005b20:	79a2                	ld	s3,40(sp)
    80005b22:	7a02                	ld	s4,32(sp)
    80005b24:	6ae2                	ld	s5,24(sp)
    80005b26:	a039                	j	80005b34 <consolewrite+0x62>
    80005b28:	4901                	li	s2,0
    80005b2a:	a029                	j	80005b34 <consolewrite+0x62>
    80005b2c:	74e2                	ld	s1,56(sp)
    80005b2e:	79a2                	ld	s3,40(sp)
    80005b30:	7a02                	ld	s4,32(sp)
    80005b32:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005b34:	854a                	mv	a0,s2
    80005b36:	60a6                	ld	ra,72(sp)
    80005b38:	6406                	ld	s0,64(sp)
    80005b3a:	7942                	ld	s2,48(sp)
    80005b3c:	6161                	addi	sp,sp,80
    80005b3e:	8082                	ret

0000000080005b40 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b40:	711d                	addi	sp,sp,-96
    80005b42:	ec86                	sd	ra,88(sp)
    80005b44:	e8a2                	sd	s0,80(sp)
    80005b46:	e4a6                	sd	s1,72(sp)
    80005b48:	e0ca                	sd	s2,64(sp)
    80005b4a:	fc4e                	sd	s3,56(sp)
    80005b4c:	f852                	sd	s4,48(sp)
    80005b4e:	f456                	sd	s5,40(sp)
    80005b50:	f05a                	sd	s6,32(sp)
    80005b52:	1080                	addi	s0,sp,96
    80005b54:	8aaa                	mv	s5,a0
    80005b56:	8a2e                	mv	s4,a1
    80005b58:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b5a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b5e:	00020517          	auipc	a0,0x20
    80005b62:	5e250513          	addi	a0,a0,1506 # 80026140 <cons>
    80005b66:	00001097          	auipc	ra,0x1
    80005b6a:	940080e7          	jalr	-1728(ra) # 800064a6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b6e:	00020497          	auipc	s1,0x20
    80005b72:	5d248493          	addi	s1,s1,1490 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b76:	00020917          	auipc	s2,0x20
    80005b7a:	66290913          	addi	s2,s2,1634 # 800261d8 <cons+0x98>
  while(n > 0){
    80005b7e:	0d305463          	blez	s3,80005c46 <consoleread+0x106>
    while(cons.r == cons.w){
    80005b82:	0984a783          	lw	a5,152(s1)
    80005b86:	09c4a703          	lw	a4,156(s1)
    80005b8a:	0af71963          	bne	a4,a5,80005c3c <consoleread+0xfc>
      if(myproc()->killed){
    80005b8e:	ffffb097          	auipc	ra,0xffffb
    80005b92:	44e080e7          	jalr	1102(ra) # 80000fdc <myproc>
    80005b96:	551c                	lw	a5,40(a0)
    80005b98:	e7ad                	bnez	a5,80005c02 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005b9a:	85a6                	mv	a1,s1
    80005b9c:	854a                	mv	a0,s2
    80005b9e:	ffffc097          	auipc	ra,0xffffc
    80005ba2:	b88080e7          	jalr	-1144(ra) # 80001726 <sleep>
    while(cons.r == cons.w){
    80005ba6:	0984a783          	lw	a5,152(s1)
    80005baa:	09c4a703          	lw	a4,156(s1)
    80005bae:	fef700e3          	beq	a4,a5,80005b8e <consoleread+0x4e>
    80005bb2:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005bb4:	00020717          	auipc	a4,0x20
    80005bb8:	58c70713          	addi	a4,a4,1420 # 80026140 <cons>
    80005bbc:	0017869b          	addiw	a3,a5,1
    80005bc0:	08d72c23          	sw	a3,152(a4)
    80005bc4:	07f7f693          	andi	a3,a5,127
    80005bc8:	9736                	add	a4,a4,a3
    80005bca:	01874703          	lbu	a4,24(a4)
    80005bce:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005bd2:	4691                	li	a3,4
    80005bd4:	04db8a63          	beq	s7,a3,80005c28 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005bd8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bdc:	4685                	li	a3,1
    80005bde:	faf40613          	addi	a2,s0,-81
    80005be2:	85d2                	mv	a1,s4
    80005be4:	8556                	mv	a0,s5
    80005be6:	ffffc097          	auipc	ra,0xffffc
    80005bea:	ee4080e7          	jalr	-284(ra) # 80001aca <either_copyout>
    80005bee:	57fd                	li	a5,-1
    80005bf0:	04f50a63          	beq	a0,a5,80005c44 <consoleread+0x104>
      break;

    dst++;
    80005bf4:	0a05                	addi	s4,s4,1
    --n;
    80005bf6:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005bf8:	47a9                	li	a5,10
    80005bfa:	06fb8163          	beq	s7,a5,80005c5c <consoleread+0x11c>
    80005bfe:	6be2                	ld	s7,24(sp)
    80005c00:	bfbd                	j	80005b7e <consoleread+0x3e>
        release(&cons.lock);
    80005c02:	00020517          	auipc	a0,0x20
    80005c06:	53e50513          	addi	a0,a0,1342 # 80026140 <cons>
    80005c0a:	00001097          	auipc	ra,0x1
    80005c0e:	950080e7          	jalr	-1712(ra) # 8000655a <release>
        return -1;
    80005c12:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005c14:	60e6                	ld	ra,88(sp)
    80005c16:	6446                	ld	s0,80(sp)
    80005c18:	64a6                	ld	s1,72(sp)
    80005c1a:	6906                	ld	s2,64(sp)
    80005c1c:	79e2                	ld	s3,56(sp)
    80005c1e:	7a42                	ld	s4,48(sp)
    80005c20:	7aa2                	ld	s5,40(sp)
    80005c22:	7b02                	ld	s6,32(sp)
    80005c24:	6125                	addi	sp,sp,96
    80005c26:	8082                	ret
      if(n < target){
    80005c28:	0009871b          	sext.w	a4,s3
    80005c2c:	01677a63          	bgeu	a4,s6,80005c40 <consoleread+0x100>
        cons.r--;
    80005c30:	00020717          	auipc	a4,0x20
    80005c34:	5af72423          	sw	a5,1448(a4) # 800261d8 <cons+0x98>
    80005c38:	6be2                	ld	s7,24(sp)
    80005c3a:	a031                	j	80005c46 <consoleread+0x106>
    80005c3c:	ec5e                	sd	s7,24(sp)
    80005c3e:	bf9d                	j	80005bb4 <consoleread+0x74>
    80005c40:	6be2                	ld	s7,24(sp)
    80005c42:	a011                	j	80005c46 <consoleread+0x106>
    80005c44:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005c46:	00020517          	auipc	a0,0x20
    80005c4a:	4fa50513          	addi	a0,a0,1274 # 80026140 <cons>
    80005c4e:	00001097          	auipc	ra,0x1
    80005c52:	90c080e7          	jalr	-1780(ra) # 8000655a <release>
  return target - n;
    80005c56:	413b053b          	subw	a0,s6,s3
    80005c5a:	bf6d                	j	80005c14 <consoleread+0xd4>
    80005c5c:	6be2                	ld	s7,24(sp)
    80005c5e:	b7e5                	j	80005c46 <consoleread+0x106>

0000000080005c60 <consputc>:
{
    80005c60:	1141                	addi	sp,sp,-16
    80005c62:	e406                	sd	ra,8(sp)
    80005c64:	e022                	sd	s0,0(sp)
    80005c66:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c68:	10000793          	li	a5,256
    80005c6c:	00f50a63          	beq	a0,a5,80005c80 <consputc+0x20>
    uartputc_sync(c);
    80005c70:	00000097          	auipc	ra,0x0
    80005c74:	59c080e7          	jalr	1436(ra) # 8000620c <uartputc_sync>
}
    80005c78:	60a2                	ld	ra,8(sp)
    80005c7a:	6402                	ld	s0,0(sp)
    80005c7c:	0141                	addi	sp,sp,16
    80005c7e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c80:	4521                	li	a0,8
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	58a080e7          	jalr	1418(ra) # 8000620c <uartputc_sync>
    80005c8a:	02000513          	li	a0,32
    80005c8e:	00000097          	auipc	ra,0x0
    80005c92:	57e080e7          	jalr	1406(ra) # 8000620c <uartputc_sync>
    80005c96:	4521                	li	a0,8
    80005c98:	00000097          	auipc	ra,0x0
    80005c9c:	574080e7          	jalr	1396(ra) # 8000620c <uartputc_sync>
    80005ca0:	bfe1                	j	80005c78 <consputc+0x18>

0000000080005ca2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005ca2:	1101                	addi	sp,sp,-32
    80005ca4:	ec06                	sd	ra,24(sp)
    80005ca6:	e822                	sd	s0,16(sp)
    80005ca8:	e426                	sd	s1,8(sp)
    80005caa:	1000                	addi	s0,sp,32
    80005cac:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005cae:	00020517          	auipc	a0,0x20
    80005cb2:	49250513          	addi	a0,a0,1170 # 80026140 <cons>
    80005cb6:	00000097          	auipc	ra,0x0
    80005cba:	7f0080e7          	jalr	2032(ra) # 800064a6 <acquire>

  switch(c){
    80005cbe:	47d5                	li	a5,21
    80005cc0:	0af48563          	beq	s1,a5,80005d6a <consoleintr+0xc8>
    80005cc4:	0297c963          	blt	a5,s1,80005cf6 <consoleintr+0x54>
    80005cc8:	47a1                	li	a5,8
    80005cca:	0ef48c63          	beq	s1,a5,80005dc2 <consoleintr+0x120>
    80005cce:	47c1                	li	a5,16
    80005cd0:	10f49f63          	bne	s1,a5,80005dee <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005cd4:	ffffc097          	auipc	ra,0xffffc
    80005cd8:	ea2080e7          	jalr	-350(ra) # 80001b76 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005cdc:	00020517          	auipc	a0,0x20
    80005ce0:	46450513          	addi	a0,a0,1124 # 80026140 <cons>
    80005ce4:	00001097          	auipc	ra,0x1
    80005ce8:	876080e7          	jalr	-1930(ra) # 8000655a <release>
}
    80005cec:	60e2                	ld	ra,24(sp)
    80005cee:	6442                	ld	s0,16(sp)
    80005cf0:	64a2                	ld	s1,8(sp)
    80005cf2:	6105                	addi	sp,sp,32
    80005cf4:	8082                	ret
  switch(c){
    80005cf6:	07f00793          	li	a5,127
    80005cfa:	0cf48463          	beq	s1,a5,80005dc2 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cfe:	00020717          	auipc	a4,0x20
    80005d02:	44270713          	addi	a4,a4,1090 # 80026140 <cons>
    80005d06:	0a072783          	lw	a5,160(a4)
    80005d0a:	09872703          	lw	a4,152(a4)
    80005d0e:	9f99                	subw	a5,a5,a4
    80005d10:	07f00713          	li	a4,127
    80005d14:	fcf764e3          	bltu	a4,a5,80005cdc <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005d18:	47b5                	li	a5,13
    80005d1a:	0cf48d63          	beq	s1,a5,80005df4 <consoleintr+0x152>
      consputc(c);
    80005d1e:	8526                	mv	a0,s1
    80005d20:	00000097          	auipc	ra,0x0
    80005d24:	f40080e7          	jalr	-192(ra) # 80005c60 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d28:	00020797          	auipc	a5,0x20
    80005d2c:	41878793          	addi	a5,a5,1048 # 80026140 <cons>
    80005d30:	0a07a703          	lw	a4,160(a5)
    80005d34:	0017069b          	addiw	a3,a4,1
    80005d38:	0006861b          	sext.w	a2,a3
    80005d3c:	0ad7a023          	sw	a3,160(a5)
    80005d40:	07f77713          	andi	a4,a4,127
    80005d44:	97ba                	add	a5,a5,a4
    80005d46:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005d4a:	47a9                	li	a5,10
    80005d4c:	0cf48b63          	beq	s1,a5,80005e22 <consoleintr+0x180>
    80005d50:	4791                	li	a5,4
    80005d52:	0cf48863          	beq	s1,a5,80005e22 <consoleintr+0x180>
    80005d56:	00020797          	auipc	a5,0x20
    80005d5a:	4827a783          	lw	a5,1154(a5) # 800261d8 <cons+0x98>
    80005d5e:	0807879b          	addiw	a5,a5,128
    80005d62:	f6f61de3          	bne	a2,a5,80005cdc <consoleintr+0x3a>
    80005d66:	863e                	mv	a2,a5
    80005d68:	a86d                	j	80005e22 <consoleintr+0x180>
    80005d6a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005d6c:	00020717          	auipc	a4,0x20
    80005d70:	3d470713          	addi	a4,a4,980 # 80026140 <cons>
    80005d74:	0a072783          	lw	a5,160(a4)
    80005d78:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d7c:	00020497          	auipc	s1,0x20
    80005d80:	3c448493          	addi	s1,s1,964 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005d84:	4929                	li	s2,10
    80005d86:	02f70a63          	beq	a4,a5,80005dba <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d8a:	37fd                	addiw	a5,a5,-1
    80005d8c:	07f7f713          	andi	a4,a5,127
    80005d90:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d92:	01874703          	lbu	a4,24(a4)
    80005d96:	03270463          	beq	a4,s2,80005dbe <consoleintr+0x11c>
      cons.e--;
    80005d9a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d9e:	10000513          	li	a0,256
    80005da2:	00000097          	auipc	ra,0x0
    80005da6:	ebe080e7          	jalr	-322(ra) # 80005c60 <consputc>
    while(cons.e != cons.w &&
    80005daa:	0a04a783          	lw	a5,160(s1)
    80005dae:	09c4a703          	lw	a4,156(s1)
    80005db2:	fcf71ce3          	bne	a4,a5,80005d8a <consoleintr+0xe8>
    80005db6:	6902                	ld	s2,0(sp)
    80005db8:	b715                	j	80005cdc <consoleintr+0x3a>
    80005dba:	6902                	ld	s2,0(sp)
    80005dbc:	b705                	j	80005cdc <consoleintr+0x3a>
    80005dbe:	6902                	ld	s2,0(sp)
    80005dc0:	bf31                	j	80005cdc <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005dc2:	00020717          	auipc	a4,0x20
    80005dc6:	37e70713          	addi	a4,a4,894 # 80026140 <cons>
    80005dca:	0a072783          	lw	a5,160(a4)
    80005dce:	09c72703          	lw	a4,156(a4)
    80005dd2:	f0f705e3          	beq	a4,a5,80005cdc <consoleintr+0x3a>
      cons.e--;
    80005dd6:	37fd                	addiw	a5,a5,-1
    80005dd8:	00020717          	auipc	a4,0x20
    80005ddc:	40f72423          	sw	a5,1032(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005de0:	10000513          	li	a0,256
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	e7c080e7          	jalr	-388(ra) # 80005c60 <consputc>
    80005dec:	bdc5                	j	80005cdc <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005dee:	ee0487e3          	beqz	s1,80005cdc <consoleintr+0x3a>
    80005df2:	b731                	j	80005cfe <consoleintr+0x5c>
      consputc(c);
    80005df4:	4529                	li	a0,10
    80005df6:	00000097          	auipc	ra,0x0
    80005dfa:	e6a080e7          	jalr	-406(ra) # 80005c60 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005dfe:	00020797          	auipc	a5,0x20
    80005e02:	34278793          	addi	a5,a5,834 # 80026140 <cons>
    80005e06:	0a07a703          	lw	a4,160(a5)
    80005e0a:	0017069b          	addiw	a3,a4,1
    80005e0e:	0006861b          	sext.w	a2,a3
    80005e12:	0ad7a023          	sw	a3,160(a5)
    80005e16:	07f77713          	andi	a4,a4,127
    80005e1a:	97ba                	add	a5,a5,a4
    80005e1c:	4729                	li	a4,10
    80005e1e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e22:	00020797          	auipc	a5,0x20
    80005e26:	3ac7ad23          	sw	a2,954(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005e2a:	00020517          	auipc	a0,0x20
    80005e2e:	3ae50513          	addi	a0,a0,942 # 800261d8 <cons+0x98>
    80005e32:	ffffc097          	auipc	ra,0xffffc
    80005e36:	a80080e7          	jalr	-1408(ra) # 800018b2 <wakeup>
    80005e3a:	b54d                	j	80005cdc <consoleintr+0x3a>

0000000080005e3c <consoleinit>:

void
consoleinit(void)
{
    80005e3c:	1141                	addi	sp,sp,-16
    80005e3e:	e406                	sd	ra,8(sp)
    80005e40:	e022                	sd	s0,0(sp)
    80005e42:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e44:	00003597          	auipc	a1,0x3
    80005e48:	89c58593          	addi	a1,a1,-1892 # 800086e0 <etext+0x6e0>
    80005e4c:	00020517          	auipc	a0,0x20
    80005e50:	2f450513          	addi	a0,a0,756 # 80026140 <cons>
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	5c2080e7          	jalr	1474(ra) # 80006416 <initlock>

  uartinit();
    80005e5c:	00000097          	auipc	ra,0x0
    80005e60:	354080e7          	jalr	852(ra) # 800061b0 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e64:	00013797          	auipc	a5,0x13
    80005e68:	46478793          	addi	a5,a5,1124 # 800192c8 <devsw>
    80005e6c:	00000717          	auipc	a4,0x0
    80005e70:	cd470713          	addi	a4,a4,-812 # 80005b40 <consoleread>
    80005e74:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e76:	00000717          	auipc	a4,0x0
    80005e7a:	c5c70713          	addi	a4,a4,-932 # 80005ad2 <consolewrite>
    80005e7e:	ef98                	sd	a4,24(a5)
}
    80005e80:	60a2                	ld	ra,8(sp)
    80005e82:	6402                	ld	s0,0(sp)
    80005e84:	0141                	addi	sp,sp,16
    80005e86:	8082                	ret

0000000080005e88 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e88:	7179                	addi	sp,sp,-48
    80005e8a:	f406                	sd	ra,40(sp)
    80005e8c:	f022                	sd	s0,32(sp)
    80005e8e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e90:	c219                	beqz	a2,80005e96 <printint+0xe>
    80005e92:	08054963          	bltz	a0,80005f24 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e96:	2501                	sext.w	a0,a0
    80005e98:	4881                	li	a7,0
    80005e9a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e9e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ea0:	2581                	sext.w	a1,a1
    80005ea2:	00003617          	auipc	a2,0x3
    80005ea6:	9e660613          	addi	a2,a2,-1562 # 80008888 <digits>
    80005eaa:	883a                	mv	a6,a4
    80005eac:	2705                	addiw	a4,a4,1
    80005eae:	02b577bb          	remuw	a5,a0,a1
    80005eb2:	1782                	slli	a5,a5,0x20
    80005eb4:	9381                	srli	a5,a5,0x20
    80005eb6:	97b2                	add	a5,a5,a2
    80005eb8:	0007c783          	lbu	a5,0(a5)
    80005ebc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005ec0:	0005079b          	sext.w	a5,a0
    80005ec4:	02b5553b          	divuw	a0,a0,a1
    80005ec8:	0685                	addi	a3,a3,1
    80005eca:	feb7f0e3          	bgeu	a5,a1,80005eaa <printint+0x22>

  if(sign)
    80005ece:	00088c63          	beqz	a7,80005ee6 <printint+0x5e>
    buf[i++] = '-';
    80005ed2:	fe070793          	addi	a5,a4,-32
    80005ed6:	00878733          	add	a4,a5,s0
    80005eda:	02d00793          	li	a5,45
    80005ede:	fef70823          	sb	a5,-16(a4)
    80005ee2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ee6:	02e05b63          	blez	a4,80005f1c <printint+0x94>
    80005eea:	ec26                	sd	s1,24(sp)
    80005eec:	e84a                	sd	s2,16(sp)
    80005eee:	fd040793          	addi	a5,s0,-48
    80005ef2:	00e784b3          	add	s1,a5,a4
    80005ef6:	fff78913          	addi	s2,a5,-1
    80005efa:	993a                	add	s2,s2,a4
    80005efc:	377d                	addiw	a4,a4,-1
    80005efe:	1702                	slli	a4,a4,0x20
    80005f00:	9301                	srli	a4,a4,0x20
    80005f02:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f06:	fff4c503          	lbu	a0,-1(s1)
    80005f0a:	00000097          	auipc	ra,0x0
    80005f0e:	d56080e7          	jalr	-682(ra) # 80005c60 <consputc>
  while(--i >= 0)
    80005f12:	14fd                	addi	s1,s1,-1
    80005f14:	ff2499e3          	bne	s1,s2,80005f06 <printint+0x7e>
    80005f18:	64e2                	ld	s1,24(sp)
    80005f1a:	6942                	ld	s2,16(sp)
}
    80005f1c:	70a2                	ld	ra,40(sp)
    80005f1e:	7402                	ld	s0,32(sp)
    80005f20:	6145                	addi	sp,sp,48
    80005f22:	8082                	ret
    x = -xx;
    80005f24:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f28:	4885                	li	a7,1
    x = -xx;
    80005f2a:	bf85                	j	80005e9a <printint+0x12>

0000000080005f2c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f2c:	1101                	addi	sp,sp,-32
    80005f2e:	ec06                	sd	ra,24(sp)
    80005f30:	e822                	sd	s0,16(sp)
    80005f32:	e426                	sd	s1,8(sp)
    80005f34:	1000                	addi	s0,sp,32
    80005f36:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f38:	00020797          	auipc	a5,0x20
    80005f3c:	2c07a423          	sw	zero,712(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005f40:	00002517          	auipc	a0,0x2
    80005f44:	7a850513          	addi	a0,a0,1960 # 800086e8 <etext+0x6e8>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	02e080e7          	jalr	46(ra) # 80005f76 <printf>
  printf(s);
    80005f50:	8526                	mv	a0,s1
    80005f52:	00000097          	auipc	ra,0x0
    80005f56:	024080e7          	jalr	36(ra) # 80005f76 <printf>
  printf("\n");
    80005f5a:	00002517          	auipc	a0,0x2
    80005f5e:	0be50513          	addi	a0,a0,190 # 80008018 <etext+0x18>
    80005f62:	00000097          	auipc	ra,0x0
    80005f66:	014080e7          	jalr	20(ra) # 80005f76 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f6a:	4785                	li	a5,1
    80005f6c:	00003717          	auipc	a4,0x3
    80005f70:	0af72823          	sw	a5,176(a4) # 8000901c <panicked>
  for(;;)
    80005f74:	a001                	j	80005f74 <panic+0x48>

0000000080005f76 <printf>:
{
    80005f76:	7131                	addi	sp,sp,-192
    80005f78:	fc86                	sd	ra,120(sp)
    80005f7a:	f8a2                	sd	s0,112(sp)
    80005f7c:	e8d2                	sd	s4,80(sp)
    80005f7e:	f06a                	sd	s10,32(sp)
    80005f80:	0100                	addi	s0,sp,128
    80005f82:	8a2a                	mv	s4,a0
    80005f84:	e40c                	sd	a1,8(s0)
    80005f86:	e810                	sd	a2,16(s0)
    80005f88:	ec14                	sd	a3,24(s0)
    80005f8a:	f018                	sd	a4,32(s0)
    80005f8c:	f41c                	sd	a5,40(s0)
    80005f8e:	03043823          	sd	a6,48(s0)
    80005f92:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f96:	00020d17          	auipc	s10,0x20
    80005f9a:	26ad2d03          	lw	s10,618(s10) # 80026200 <pr+0x18>
  if(locking)
    80005f9e:	040d1463          	bnez	s10,80005fe6 <printf+0x70>
  if (fmt == 0)
    80005fa2:	040a0b63          	beqz	s4,80005ff8 <printf+0x82>
  va_start(ap, fmt);
    80005fa6:	00840793          	addi	a5,s0,8
    80005faa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fae:	000a4503          	lbu	a0,0(s4)
    80005fb2:	18050b63          	beqz	a0,80006148 <printf+0x1d2>
    80005fb6:	f4a6                	sd	s1,104(sp)
    80005fb8:	f0ca                	sd	s2,96(sp)
    80005fba:	ecce                	sd	s3,88(sp)
    80005fbc:	e4d6                	sd	s5,72(sp)
    80005fbe:	e0da                	sd	s6,64(sp)
    80005fc0:	fc5e                	sd	s7,56(sp)
    80005fc2:	f862                	sd	s8,48(sp)
    80005fc4:	f466                	sd	s9,40(sp)
    80005fc6:	ec6e                	sd	s11,24(sp)
    80005fc8:	4981                	li	s3,0
    if(c != '%'){
    80005fca:	02500b13          	li	s6,37
    switch(c){
    80005fce:	07000b93          	li	s7,112
  consputc('x');
    80005fd2:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fd4:	00003a97          	auipc	s5,0x3
    80005fd8:	8b4a8a93          	addi	s5,s5,-1868 # 80008888 <digits>
    switch(c){
    80005fdc:	07300c13          	li	s8,115
    80005fe0:	06400d93          	li	s11,100
    80005fe4:	a0b1                	j	80006030 <printf+0xba>
    acquire(&pr.lock);
    80005fe6:	00020517          	auipc	a0,0x20
    80005fea:	20250513          	addi	a0,a0,514 # 800261e8 <pr>
    80005fee:	00000097          	auipc	ra,0x0
    80005ff2:	4b8080e7          	jalr	1208(ra) # 800064a6 <acquire>
    80005ff6:	b775                	j	80005fa2 <printf+0x2c>
    80005ff8:	f4a6                	sd	s1,104(sp)
    80005ffa:	f0ca                	sd	s2,96(sp)
    80005ffc:	ecce                	sd	s3,88(sp)
    80005ffe:	e4d6                	sd	s5,72(sp)
    80006000:	e0da                	sd	s6,64(sp)
    80006002:	fc5e                	sd	s7,56(sp)
    80006004:	f862                	sd	s8,48(sp)
    80006006:	f466                	sd	s9,40(sp)
    80006008:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    8000600a:	00002517          	auipc	a0,0x2
    8000600e:	6ee50513          	addi	a0,a0,1774 # 800086f8 <etext+0x6f8>
    80006012:	00000097          	auipc	ra,0x0
    80006016:	f1a080e7          	jalr	-230(ra) # 80005f2c <panic>
      consputc(c);
    8000601a:	00000097          	auipc	ra,0x0
    8000601e:	c46080e7          	jalr	-954(ra) # 80005c60 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006022:	2985                	addiw	s3,s3,1
    80006024:	013a07b3          	add	a5,s4,s3
    80006028:	0007c503          	lbu	a0,0(a5)
    8000602c:	10050563          	beqz	a0,80006136 <printf+0x1c0>
    if(c != '%'){
    80006030:	ff6515e3          	bne	a0,s6,8000601a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80006034:	2985                	addiw	s3,s3,1
    80006036:	013a07b3          	add	a5,s4,s3
    8000603a:	0007c783          	lbu	a5,0(a5)
    8000603e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006042:	10078b63          	beqz	a5,80006158 <printf+0x1e2>
    switch(c){
    80006046:	05778a63          	beq	a5,s7,8000609a <printf+0x124>
    8000604a:	02fbf663          	bgeu	s7,a5,80006076 <printf+0x100>
    8000604e:	09878863          	beq	a5,s8,800060de <printf+0x168>
    80006052:	07800713          	li	a4,120
    80006056:	0ce79563          	bne	a5,a4,80006120 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000605a:	f8843783          	ld	a5,-120(s0)
    8000605e:	00878713          	addi	a4,a5,8
    80006062:	f8e43423          	sd	a4,-120(s0)
    80006066:	4605                	li	a2,1
    80006068:	85e6                	mv	a1,s9
    8000606a:	4388                	lw	a0,0(a5)
    8000606c:	00000097          	auipc	ra,0x0
    80006070:	e1c080e7          	jalr	-484(ra) # 80005e88 <printint>
      break;
    80006074:	b77d                	j	80006022 <printf+0xac>
    switch(c){
    80006076:	09678f63          	beq	a5,s6,80006114 <printf+0x19e>
    8000607a:	0bb79363          	bne	a5,s11,80006120 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    8000607e:	f8843783          	ld	a5,-120(s0)
    80006082:	00878713          	addi	a4,a5,8
    80006086:	f8e43423          	sd	a4,-120(s0)
    8000608a:	4605                	li	a2,1
    8000608c:	45a9                	li	a1,10
    8000608e:	4388                	lw	a0,0(a5)
    80006090:	00000097          	auipc	ra,0x0
    80006094:	df8080e7          	jalr	-520(ra) # 80005e88 <printint>
      break;
    80006098:	b769                	j	80006022 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000609a:	f8843783          	ld	a5,-120(s0)
    8000609e:	00878713          	addi	a4,a5,8
    800060a2:	f8e43423          	sd	a4,-120(s0)
    800060a6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800060aa:	03000513          	li	a0,48
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	bb2080e7          	jalr	-1102(ra) # 80005c60 <consputc>
  consputc('x');
    800060b6:	07800513          	li	a0,120
    800060ba:	00000097          	auipc	ra,0x0
    800060be:	ba6080e7          	jalr	-1114(ra) # 80005c60 <consputc>
    800060c2:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060c4:	03c95793          	srli	a5,s2,0x3c
    800060c8:	97d6                	add	a5,a5,s5
    800060ca:	0007c503          	lbu	a0,0(a5)
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	b92080e7          	jalr	-1134(ra) # 80005c60 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060d6:	0912                	slli	s2,s2,0x4
    800060d8:	34fd                	addiw	s1,s1,-1
    800060da:	f4ed                	bnez	s1,800060c4 <printf+0x14e>
    800060dc:	b799                	j	80006022 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800060de:	f8843783          	ld	a5,-120(s0)
    800060e2:	00878713          	addi	a4,a5,8
    800060e6:	f8e43423          	sd	a4,-120(s0)
    800060ea:	6384                	ld	s1,0(a5)
    800060ec:	cc89                	beqz	s1,80006106 <printf+0x190>
      for(; *s; s++)
    800060ee:	0004c503          	lbu	a0,0(s1)
    800060f2:	d905                	beqz	a0,80006022 <printf+0xac>
        consputc(*s);
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	b6c080e7          	jalr	-1172(ra) # 80005c60 <consputc>
      for(; *s; s++)
    800060fc:	0485                	addi	s1,s1,1
    800060fe:	0004c503          	lbu	a0,0(s1)
    80006102:	f96d                	bnez	a0,800060f4 <printf+0x17e>
    80006104:	bf39                	j	80006022 <printf+0xac>
        s = "(null)";
    80006106:	00002497          	auipc	s1,0x2
    8000610a:	5ea48493          	addi	s1,s1,1514 # 800086f0 <etext+0x6f0>
      for(; *s; s++)
    8000610e:	02800513          	li	a0,40
    80006112:	b7cd                	j	800060f4 <printf+0x17e>
      consputc('%');
    80006114:	855a                	mv	a0,s6
    80006116:	00000097          	auipc	ra,0x0
    8000611a:	b4a080e7          	jalr	-1206(ra) # 80005c60 <consputc>
      break;
    8000611e:	b711                	j	80006022 <printf+0xac>
      consputc('%');
    80006120:	855a                	mv	a0,s6
    80006122:	00000097          	auipc	ra,0x0
    80006126:	b3e080e7          	jalr	-1218(ra) # 80005c60 <consputc>
      consputc(c);
    8000612a:	8526                	mv	a0,s1
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	b34080e7          	jalr	-1228(ra) # 80005c60 <consputc>
      break;
    80006134:	b5fd                	j	80006022 <printf+0xac>
    80006136:	74a6                	ld	s1,104(sp)
    80006138:	7906                	ld	s2,96(sp)
    8000613a:	69e6                	ld	s3,88(sp)
    8000613c:	6aa6                	ld	s5,72(sp)
    8000613e:	6b06                	ld	s6,64(sp)
    80006140:	7be2                	ld	s7,56(sp)
    80006142:	7c42                	ld	s8,48(sp)
    80006144:	7ca2                	ld	s9,40(sp)
    80006146:	6de2                	ld	s11,24(sp)
  if(locking)
    80006148:	020d1263          	bnez	s10,8000616c <printf+0x1f6>
}
    8000614c:	70e6                	ld	ra,120(sp)
    8000614e:	7446                	ld	s0,112(sp)
    80006150:	6a46                	ld	s4,80(sp)
    80006152:	7d02                	ld	s10,32(sp)
    80006154:	6129                	addi	sp,sp,192
    80006156:	8082                	ret
    80006158:	74a6                	ld	s1,104(sp)
    8000615a:	7906                	ld	s2,96(sp)
    8000615c:	69e6                	ld	s3,88(sp)
    8000615e:	6aa6                	ld	s5,72(sp)
    80006160:	6b06                	ld	s6,64(sp)
    80006162:	7be2                	ld	s7,56(sp)
    80006164:	7c42                	ld	s8,48(sp)
    80006166:	7ca2                	ld	s9,40(sp)
    80006168:	6de2                	ld	s11,24(sp)
    8000616a:	bff9                	j	80006148 <printf+0x1d2>
    release(&pr.lock);
    8000616c:	00020517          	auipc	a0,0x20
    80006170:	07c50513          	addi	a0,a0,124 # 800261e8 <pr>
    80006174:	00000097          	auipc	ra,0x0
    80006178:	3e6080e7          	jalr	998(ra) # 8000655a <release>
}
    8000617c:	bfc1                	j	8000614c <printf+0x1d6>

000000008000617e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000617e:	1101                	addi	sp,sp,-32
    80006180:	ec06                	sd	ra,24(sp)
    80006182:	e822                	sd	s0,16(sp)
    80006184:	e426                	sd	s1,8(sp)
    80006186:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006188:	00020497          	auipc	s1,0x20
    8000618c:	06048493          	addi	s1,s1,96 # 800261e8 <pr>
    80006190:	00002597          	auipc	a1,0x2
    80006194:	57858593          	addi	a1,a1,1400 # 80008708 <etext+0x708>
    80006198:	8526                	mv	a0,s1
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	27c080e7          	jalr	636(ra) # 80006416 <initlock>
  pr.locking = 1;
    800061a2:	4785                	li	a5,1
    800061a4:	cc9c                	sw	a5,24(s1)
}
    800061a6:	60e2                	ld	ra,24(sp)
    800061a8:	6442                	ld	s0,16(sp)
    800061aa:	64a2                	ld	s1,8(sp)
    800061ac:	6105                	addi	sp,sp,32
    800061ae:	8082                	ret

00000000800061b0 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800061b0:	1141                	addi	sp,sp,-16
    800061b2:	e406                	sd	ra,8(sp)
    800061b4:	e022                	sd	s0,0(sp)
    800061b6:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800061b8:	100007b7          	lui	a5,0x10000
    800061bc:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061c0:	10000737          	lui	a4,0x10000
    800061c4:	f8000693          	li	a3,-128
    800061c8:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061cc:	468d                	li	a3,3
    800061ce:	10000637          	lui	a2,0x10000
    800061d2:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061d6:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061da:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800061de:	10000737          	lui	a4,0x10000
    800061e2:	461d                	li	a2,7
    800061e4:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061e8:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061ec:	00002597          	auipc	a1,0x2
    800061f0:	52458593          	addi	a1,a1,1316 # 80008710 <etext+0x710>
    800061f4:	00020517          	auipc	a0,0x20
    800061f8:	01450513          	addi	a0,a0,20 # 80026208 <uart_tx_lock>
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	21a080e7          	jalr	538(ra) # 80006416 <initlock>
}
    80006204:	60a2                	ld	ra,8(sp)
    80006206:	6402                	ld	s0,0(sp)
    80006208:	0141                	addi	sp,sp,16
    8000620a:	8082                	ret

000000008000620c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000620c:	1101                	addi	sp,sp,-32
    8000620e:	ec06                	sd	ra,24(sp)
    80006210:	e822                	sd	s0,16(sp)
    80006212:	e426                	sd	s1,8(sp)
    80006214:	1000                	addi	s0,sp,32
    80006216:	84aa                	mv	s1,a0
  push_off();
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	242080e7          	jalr	578(ra) # 8000645a <push_off>

  if(panicked){
    80006220:	00003797          	auipc	a5,0x3
    80006224:	dfc7a783          	lw	a5,-516(a5) # 8000901c <panicked>
    80006228:	eb85                	bnez	a5,80006258 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000622a:	10000737          	lui	a4,0x10000
    8000622e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006230:	00074783          	lbu	a5,0(a4)
    80006234:	0207f793          	andi	a5,a5,32
    80006238:	dfe5                	beqz	a5,80006230 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000623a:	0ff4f513          	zext.b	a0,s1
    8000623e:	100007b7          	lui	a5,0x10000
    80006242:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80006246:	00000097          	auipc	ra,0x0
    8000624a:	2b4080e7          	jalr	692(ra) # 800064fa <pop_off>
}
    8000624e:	60e2                	ld	ra,24(sp)
    80006250:	6442                	ld	s0,16(sp)
    80006252:	64a2                	ld	s1,8(sp)
    80006254:	6105                	addi	sp,sp,32
    80006256:	8082                	ret
    for(;;)
    80006258:	a001                	j	80006258 <uartputc_sync+0x4c>

000000008000625a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000625a:	00003797          	auipc	a5,0x3
    8000625e:	dc67b783          	ld	a5,-570(a5) # 80009020 <uart_tx_r>
    80006262:	00003717          	auipc	a4,0x3
    80006266:	dc673703          	ld	a4,-570(a4) # 80009028 <uart_tx_w>
    8000626a:	06f70f63          	beq	a4,a5,800062e8 <uartstart+0x8e>
{
    8000626e:	7139                	addi	sp,sp,-64
    80006270:	fc06                	sd	ra,56(sp)
    80006272:	f822                	sd	s0,48(sp)
    80006274:	f426                	sd	s1,40(sp)
    80006276:	f04a                	sd	s2,32(sp)
    80006278:	ec4e                	sd	s3,24(sp)
    8000627a:	e852                	sd	s4,16(sp)
    8000627c:	e456                	sd	s5,8(sp)
    8000627e:	e05a                	sd	s6,0(sp)
    80006280:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006282:	10000937          	lui	s2,0x10000
    80006286:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006288:	00020a97          	auipc	s5,0x20
    8000628c:	f80a8a93          	addi	s5,s5,-128 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80006290:	00003497          	auipc	s1,0x3
    80006294:	d9048493          	addi	s1,s1,-624 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006298:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000629c:	00003997          	auipc	s3,0x3
    800062a0:	d8c98993          	addi	s3,s3,-628 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062a4:	00094703          	lbu	a4,0(s2)
    800062a8:	02077713          	andi	a4,a4,32
    800062ac:	c705                	beqz	a4,800062d4 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062ae:	01f7f713          	andi	a4,a5,31
    800062b2:	9756                	add	a4,a4,s5
    800062b4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800062b8:	0785                	addi	a5,a5,1
    800062ba:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800062bc:	8526                	mv	a0,s1
    800062be:	ffffb097          	auipc	ra,0xffffb
    800062c2:	5f4080e7          	jalr	1524(ra) # 800018b2 <wakeup>
    WriteReg(THR, c);
    800062c6:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800062ca:	609c                	ld	a5,0(s1)
    800062cc:	0009b703          	ld	a4,0(s3)
    800062d0:	fcf71ae3          	bne	a4,a5,800062a4 <uartstart+0x4a>
  }
}
    800062d4:	70e2                	ld	ra,56(sp)
    800062d6:	7442                	ld	s0,48(sp)
    800062d8:	74a2                	ld	s1,40(sp)
    800062da:	7902                	ld	s2,32(sp)
    800062dc:	69e2                	ld	s3,24(sp)
    800062de:	6a42                	ld	s4,16(sp)
    800062e0:	6aa2                	ld	s5,8(sp)
    800062e2:	6b02                	ld	s6,0(sp)
    800062e4:	6121                	addi	sp,sp,64
    800062e6:	8082                	ret
    800062e8:	8082                	ret

00000000800062ea <uartputc>:
{
    800062ea:	7179                	addi	sp,sp,-48
    800062ec:	f406                	sd	ra,40(sp)
    800062ee:	f022                	sd	s0,32(sp)
    800062f0:	e052                	sd	s4,0(sp)
    800062f2:	1800                	addi	s0,sp,48
    800062f4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062f6:	00020517          	auipc	a0,0x20
    800062fa:	f1250513          	addi	a0,a0,-238 # 80026208 <uart_tx_lock>
    800062fe:	00000097          	auipc	ra,0x0
    80006302:	1a8080e7          	jalr	424(ra) # 800064a6 <acquire>
  if(panicked){
    80006306:	00003797          	auipc	a5,0x3
    8000630a:	d167a783          	lw	a5,-746(a5) # 8000901c <panicked>
    8000630e:	c391                	beqz	a5,80006312 <uartputc+0x28>
    for(;;)
    80006310:	a001                	j	80006310 <uartputc+0x26>
    80006312:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006314:	00003717          	auipc	a4,0x3
    80006318:	d1473703          	ld	a4,-748(a4) # 80009028 <uart_tx_w>
    8000631c:	00003797          	auipc	a5,0x3
    80006320:	d047b783          	ld	a5,-764(a5) # 80009020 <uart_tx_r>
    80006324:	02078793          	addi	a5,a5,32
    80006328:	02e79f63          	bne	a5,a4,80006366 <uartputc+0x7c>
    8000632c:	e84a                	sd	s2,16(sp)
    8000632e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006330:	00020997          	auipc	s3,0x20
    80006334:	ed898993          	addi	s3,s3,-296 # 80026208 <uart_tx_lock>
    80006338:	00003497          	auipc	s1,0x3
    8000633c:	ce848493          	addi	s1,s1,-792 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006340:	00003917          	auipc	s2,0x3
    80006344:	ce890913          	addi	s2,s2,-792 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006348:	85ce                	mv	a1,s3
    8000634a:	8526                	mv	a0,s1
    8000634c:	ffffb097          	auipc	ra,0xffffb
    80006350:	3da080e7          	jalr	986(ra) # 80001726 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006354:	00093703          	ld	a4,0(s2)
    80006358:	609c                	ld	a5,0(s1)
    8000635a:	02078793          	addi	a5,a5,32
    8000635e:	fee785e3          	beq	a5,a4,80006348 <uartputc+0x5e>
    80006362:	6942                	ld	s2,16(sp)
    80006364:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006366:	00020497          	auipc	s1,0x20
    8000636a:	ea248493          	addi	s1,s1,-350 # 80026208 <uart_tx_lock>
    8000636e:	01f77793          	andi	a5,a4,31
    80006372:	97a6                	add	a5,a5,s1
    80006374:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006378:	0705                	addi	a4,a4,1
    8000637a:	00003797          	auipc	a5,0x3
    8000637e:	cae7b723          	sd	a4,-850(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006382:	00000097          	auipc	ra,0x0
    80006386:	ed8080e7          	jalr	-296(ra) # 8000625a <uartstart>
      release(&uart_tx_lock);
    8000638a:	8526                	mv	a0,s1
    8000638c:	00000097          	auipc	ra,0x0
    80006390:	1ce080e7          	jalr	462(ra) # 8000655a <release>
    80006394:	64e2                	ld	s1,24(sp)
}
    80006396:	70a2                	ld	ra,40(sp)
    80006398:	7402                	ld	s0,32(sp)
    8000639a:	6a02                	ld	s4,0(sp)
    8000639c:	6145                	addi	sp,sp,48
    8000639e:	8082                	ret

00000000800063a0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800063a0:	1141                	addi	sp,sp,-16
    800063a2:	e422                	sd	s0,8(sp)
    800063a4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800063a6:	100007b7          	lui	a5,0x10000
    800063aa:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800063ac:	0007c783          	lbu	a5,0(a5)
    800063b0:	8b85                	andi	a5,a5,1
    800063b2:	cb81                	beqz	a5,800063c2 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800063b4:	100007b7          	lui	a5,0x10000
    800063b8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800063bc:	6422                	ld	s0,8(sp)
    800063be:	0141                	addi	sp,sp,16
    800063c0:	8082                	ret
    return -1;
    800063c2:	557d                	li	a0,-1
    800063c4:	bfe5                	j	800063bc <uartgetc+0x1c>

00000000800063c6 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800063c6:	1101                	addi	sp,sp,-32
    800063c8:	ec06                	sd	ra,24(sp)
    800063ca:	e822                	sd	s0,16(sp)
    800063cc:	e426                	sd	s1,8(sp)
    800063ce:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800063d0:	54fd                	li	s1,-1
    800063d2:	a029                	j	800063dc <uartintr+0x16>
      break;
    consoleintr(c);
    800063d4:	00000097          	auipc	ra,0x0
    800063d8:	8ce080e7          	jalr	-1842(ra) # 80005ca2 <consoleintr>
    int c = uartgetc();
    800063dc:	00000097          	auipc	ra,0x0
    800063e0:	fc4080e7          	jalr	-60(ra) # 800063a0 <uartgetc>
    if(c == -1)
    800063e4:	fe9518e3          	bne	a0,s1,800063d4 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063e8:	00020497          	auipc	s1,0x20
    800063ec:	e2048493          	addi	s1,s1,-480 # 80026208 <uart_tx_lock>
    800063f0:	8526                	mv	a0,s1
    800063f2:	00000097          	auipc	ra,0x0
    800063f6:	0b4080e7          	jalr	180(ra) # 800064a6 <acquire>
  uartstart();
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	e60080e7          	jalr	-416(ra) # 8000625a <uartstart>
  release(&uart_tx_lock);
    80006402:	8526                	mv	a0,s1
    80006404:	00000097          	auipc	ra,0x0
    80006408:	156080e7          	jalr	342(ra) # 8000655a <release>
}
    8000640c:	60e2                	ld	ra,24(sp)
    8000640e:	6442                	ld	s0,16(sp)
    80006410:	64a2                	ld	s1,8(sp)
    80006412:	6105                	addi	sp,sp,32
    80006414:	8082                	ret

0000000080006416 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006416:	1141                	addi	sp,sp,-16
    80006418:	e422                	sd	s0,8(sp)
    8000641a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000641c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000641e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006422:	00053823          	sd	zero,16(a0)
}
    80006426:	6422                	ld	s0,8(sp)
    80006428:	0141                	addi	sp,sp,16
    8000642a:	8082                	ret

000000008000642c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000642c:	411c                	lw	a5,0(a0)
    8000642e:	e399                	bnez	a5,80006434 <holding+0x8>
    80006430:	4501                	li	a0,0
  return r;
}
    80006432:	8082                	ret
{
    80006434:	1101                	addi	sp,sp,-32
    80006436:	ec06                	sd	ra,24(sp)
    80006438:	e822                	sd	s0,16(sp)
    8000643a:	e426                	sd	s1,8(sp)
    8000643c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000643e:	6904                	ld	s1,16(a0)
    80006440:	ffffb097          	auipc	ra,0xffffb
    80006444:	b80080e7          	jalr	-1152(ra) # 80000fc0 <mycpu>
    80006448:	40a48533          	sub	a0,s1,a0
    8000644c:	00153513          	seqz	a0,a0
}
    80006450:	60e2                	ld	ra,24(sp)
    80006452:	6442                	ld	s0,16(sp)
    80006454:	64a2                	ld	s1,8(sp)
    80006456:	6105                	addi	sp,sp,32
    80006458:	8082                	ret

000000008000645a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000645a:	1101                	addi	sp,sp,-32
    8000645c:	ec06                	sd	ra,24(sp)
    8000645e:	e822                	sd	s0,16(sp)
    80006460:	e426                	sd	s1,8(sp)
    80006462:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006464:	100024f3          	csrr	s1,sstatus
    80006468:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000646c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000646e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006472:	ffffb097          	auipc	ra,0xffffb
    80006476:	b4e080e7          	jalr	-1202(ra) # 80000fc0 <mycpu>
    8000647a:	5d3c                	lw	a5,120(a0)
    8000647c:	cf89                	beqz	a5,80006496 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000647e:	ffffb097          	auipc	ra,0xffffb
    80006482:	b42080e7          	jalr	-1214(ra) # 80000fc0 <mycpu>
    80006486:	5d3c                	lw	a5,120(a0)
    80006488:	2785                	addiw	a5,a5,1
    8000648a:	dd3c                	sw	a5,120(a0)
}
    8000648c:	60e2                	ld	ra,24(sp)
    8000648e:	6442                	ld	s0,16(sp)
    80006490:	64a2                	ld	s1,8(sp)
    80006492:	6105                	addi	sp,sp,32
    80006494:	8082                	ret
    mycpu()->intena = old;
    80006496:	ffffb097          	auipc	ra,0xffffb
    8000649a:	b2a080e7          	jalr	-1238(ra) # 80000fc0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000649e:	8085                	srli	s1,s1,0x1
    800064a0:	8885                	andi	s1,s1,1
    800064a2:	dd64                	sw	s1,124(a0)
    800064a4:	bfe9                	j	8000647e <push_off+0x24>

00000000800064a6 <acquire>:
{
    800064a6:	1101                	addi	sp,sp,-32
    800064a8:	ec06                	sd	ra,24(sp)
    800064aa:	e822                	sd	s0,16(sp)
    800064ac:	e426                	sd	s1,8(sp)
    800064ae:	1000                	addi	s0,sp,32
    800064b0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800064b2:	00000097          	auipc	ra,0x0
    800064b6:	fa8080e7          	jalr	-88(ra) # 8000645a <push_off>
  if(holding(lk))
    800064ba:	8526                	mv	a0,s1
    800064bc:	00000097          	auipc	ra,0x0
    800064c0:	f70080e7          	jalr	-144(ra) # 8000642c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064c4:	4705                	li	a4,1
  if(holding(lk))
    800064c6:	e115                	bnez	a0,800064ea <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064c8:	87ba                	mv	a5,a4
    800064ca:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800064ce:	2781                	sext.w	a5,a5
    800064d0:	ffe5                	bnez	a5,800064c8 <acquire+0x22>
  __sync_synchronize();
    800064d2:	0ff0000f          	fence
  lk->cpu = mycpu();
    800064d6:	ffffb097          	auipc	ra,0xffffb
    800064da:	aea080e7          	jalr	-1302(ra) # 80000fc0 <mycpu>
    800064de:	e888                	sd	a0,16(s1)
}
    800064e0:	60e2                	ld	ra,24(sp)
    800064e2:	6442                	ld	s0,16(sp)
    800064e4:	64a2                	ld	s1,8(sp)
    800064e6:	6105                	addi	sp,sp,32
    800064e8:	8082                	ret
    panic("acquire");
    800064ea:	00002517          	auipc	a0,0x2
    800064ee:	22e50513          	addi	a0,a0,558 # 80008718 <etext+0x718>
    800064f2:	00000097          	auipc	ra,0x0
    800064f6:	a3a080e7          	jalr	-1478(ra) # 80005f2c <panic>

00000000800064fa <pop_off>:

void
pop_off(void)
{
    800064fa:	1141                	addi	sp,sp,-16
    800064fc:	e406                	sd	ra,8(sp)
    800064fe:	e022                	sd	s0,0(sp)
    80006500:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006502:	ffffb097          	auipc	ra,0xffffb
    80006506:	abe080e7          	jalr	-1346(ra) # 80000fc0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000650a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000650e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006510:	e78d                	bnez	a5,8000653a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006512:	5d3c                	lw	a5,120(a0)
    80006514:	02f05b63          	blez	a5,8000654a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006518:	37fd                	addiw	a5,a5,-1
    8000651a:	0007871b          	sext.w	a4,a5
    8000651e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006520:	eb09                	bnez	a4,80006532 <pop_off+0x38>
    80006522:	5d7c                	lw	a5,124(a0)
    80006524:	c799                	beqz	a5,80006532 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006526:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000652a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000652e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006532:	60a2                	ld	ra,8(sp)
    80006534:	6402                	ld	s0,0(sp)
    80006536:	0141                	addi	sp,sp,16
    80006538:	8082                	ret
    panic("pop_off - interruptible");
    8000653a:	00002517          	auipc	a0,0x2
    8000653e:	1e650513          	addi	a0,a0,486 # 80008720 <etext+0x720>
    80006542:	00000097          	auipc	ra,0x0
    80006546:	9ea080e7          	jalr	-1558(ra) # 80005f2c <panic>
    panic("pop_off");
    8000654a:	00002517          	auipc	a0,0x2
    8000654e:	1ee50513          	addi	a0,a0,494 # 80008738 <etext+0x738>
    80006552:	00000097          	auipc	ra,0x0
    80006556:	9da080e7          	jalr	-1574(ra) # 80005f2c <panic>

000000008000655a <release>:
{
    8000655a:	1101                	addi	sp,sp,-32
    8000655c:	ec06                	sd	ra,24(sp)
    8000655e:	e822                	sd	s0,16(sp)
    80006560:	e426                	sd	s1,8(sp)
    80006562:	1000                	addi	s0,sp,32
    80006564:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006566:	00000097          	auipc	ra,0x0
    8000656a:	ec6080e7          	jalr	-314(ra) # 8000642c <holding>
    8000656e:	c115                	beqz	a0,80006592 <release+0x38>
  lk->cpu = 0;
    80006570:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006574:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006578:	0f50000f          	fence	iorw,ow
    8000657c:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006580:	00000097          	auipc	ra,0x0
    80006584:	f7a080e7          	jalr	-134(ra) # 800064fa <pop_off>
}
    80006588:	60e2                	ld	ra,24(sp)
    8000658a:	6442                	ld	s0,16(sp)
    8000658c:	64a2                	ld	s1,8(sp)
    8000658e:	6105                	addi	sp,sp,32
    80006590:	8082                	ret
    panic("release");
    80006592:	00002517          	auipc	a0,0x2
    80006596:	1ae50513          	addi	a0,a0,430 # 80008740 <etext+0x740>
    8000659a:	00000097          	auipc	ra,0x0
    8000659e:	992080e7          	jalr	-1646(ra) # 80005f2c <panic>
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
