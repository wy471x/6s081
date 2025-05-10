
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
    80000016:	7c8050ef          	jal	800057de <start>

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
    8000005e:	1cc080e7          	jalr	460(ra) # 80006226 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	26c080e7          	jalr	620(ra) # 800062da <release>
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
    8000008e:	c22080e7          	jalr	-990(ra) # 80005cac <panic>

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
    800000fa:	0a0080e7          	jalr	160(ra) # 80006196 <initlock>
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
    80000132:	0f8080e7          	jalr	248(ra) # 80006226 <acquire>
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
    8000014a:	194080e7          	jalr	404(ra) # 800062da <release>

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
    80000174:	16a080e7          	jalr	362(ra) # 800062da <release>
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
    80000324:	b2c080e7          	jalr	-1236(ra) # 80000e4c <cpuid>
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
    80000340:	b10080e7          	jalr	-1264(ra) # 80000e4c <cpuid>
    80000344:	85aa                	mv	a1,a0
    80000346:	00008517          	auipc	a0,0x8
    8000034a:	cf250513          	addi	a0,a0,-782 # 80008038 <etext+0x38>
    8000034e:	00006097          	auipc	ra,0x6
    80000352:	9a8080e7          	jalr	-1624(ra) # 80005cf6 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	7f6080e7          	jalr	2038(ra) # 80001b54 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	e2e080e7          	jalr	-466(ra) # 80005194 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	0a2080e7          	jalr	162(ra) # 80001410 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	846080e7          	jalr	-1978(ra) # 80005bbc <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	b80080e7          	jalr	-1152(ra) # 80005efe <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	968080e7          	jalr	-1688(ra) # 80005cf6 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	958080e7          	jalr	-1704(ra) # 80005cf6 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	948080e7          	jalr	-1720(ra) # 80005cf6 <printf>
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
    800003d2:	9c2080e7          	jalr	-1598(ra) # 80000d90 <procinit>
    trapinit();      // trap vectors
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	756080e7          	jalr	1878(ra) # 80001b2c <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	776080e7          	jalr	1910(ra) # 80001b54 <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	d94080e7          	jalr	-620(ra) # 8000517a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	da6080e7          	jalr	-602(ra) # 80005194 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	ebe080e7          	jalr	-322(ra) # 800022b4 <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	54a080e7          	jalr	1354(ra) # 80002948 <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	4ee080e7          	jalr	1262(ra) # 800038f4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	ea6080e7          	jalr	-346(ra) # 800052b4 <virtio_disk_init>
    userinit();      // first user process
    80000416:	00001097          	auipc	ra,0x1
    8000041a:	dbe080e7          	jalr	-578(ra) # 800011d4 <userinit>
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
    80000484:	82c080e7          	jalr	-2004(ra) # 80005cac <panic>
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
    800005aa:	706080e7          	jalr	1798(ra) # 80005cac <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00005097          	auipc	ra,0x5
    800005ba:	6f6080e7          	jalr	1782(ra) # 80005cac <panic>
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
    80000606:	6aa080e7          	jalr	1706(ra) # 80005cac <panic>

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
    8000074c:	564080e7          	jalr	1380(ra) # 80005cac <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	554080e7          	jalr	1364(ra) # 80005cac <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	544080e7          	jalr	1348(ra) # 80005cac <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	534080e7          	jalr	1332(ra) # 80005cac <panic>
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
    80000870:	440080e7          	jalr	1088(ra) # 80005cac <panic>

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
    800009bc:	2f4080e7          	jalr	756(ra) # 80005cac <panic>
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
    80000a9a:	216080e7          	jalr	534(ra) # 80005cac <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	206080e7          	jalr	518(ra) # 80005cac <panic>
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
    80000b14:	19c080e7          	jalr	412(ra) # 80005cac <panic>

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
void proc_mapstacks(pagetable_t kpgtbl)
{
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

  for (p = proc; p < &proc[NPROC]; p++)
    80000d04:	00008497          	auipc	s1,0x8
    80000d08:	77c48493          	addi	s1,s1,1916 # 80009480 <proc>
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80000d0c:	8b26                	mv	s6,s1
    80000d0e:	ff4df937          	lui	s2,0xff4df
    80000d12:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000d16:	0936                	slli	s2,s2,0xd
    80000d18:	6f590913          	addi	s2,s2,1781
    80000d1c:	0936                	slli	s2,s2,0xd
    80000d1e:	bd390913          	addi	s2,s2,-1069
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	7a790913          	addi	s2,s2,1959
    80000d28:	010009b7          	lui	s3,0x1000
    80000d2c:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000d2e:	09ba                	slli	s3,s3,0xe
  for (p = proc; p < &proc[NPROC]; p++)
    80000d30:	0000ea97          	auipc	s5,0xe
    80000d34:	350a8a93          	addi	s5,s5,848 # 8000f080 <tickslock>
    char *pa = kalloc();
    80000d38:	fffff097          	auipc	ra,0xfffff
    80000d3c:	3e2080e7          	jalr	994(ra) # 8000011a <kalloc>
    80000d40:	862a                	mv	a2,a0
    if (pa == 0)
    80000d42:	cd1d                	beqz	a0,80000d80 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int)(p - proc));
    80000d44:	416485b3          	sub	a1,s1,s6
    80000d48:	8591                	srai	a1,a1,0x4
    80000d4a:	032585b3          	mul	a1,a1,s2
    80000d4e:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d52:	4719                	li	a4,6
    80000d54:	6685                	lui	a3,0x1
    80000d56:	40b985b3          	sub	a1,s3,a1
    80000d5a:	8552                	mv	a0,s4
    80000d5c:	00000097          	auipc	ra,0x0
    80000d60:	87e080e7          	jalr	-1922(ra) # 800005da <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++)
    80000d64:	17048493          	addi	s1,s1,368
    80000d68:	fd5498e3          	bne	s1,s5,80000d38 <proc_mapstacks+0x4a>
  }
}
    80000d6c:	70e2                	ld	ra,56(sp)
    80000d6e:	7442                	ld	s0,48(sp)
    80000d70:	74a2                	ld	s1,40(sp)
    80000d72:	7902                	ld	s2,32(sp)
    80000d74:	69e2                	ld	s3,24(sp)
    80000d76:	6a42                	ld	s4,16(sp)
    80000d78:	6aa2                	ld	s5,8(sp)
    80000d7a:	6b02                	ld	s6,0(sp)
    80000d7c:	6121                	addi	sp,sp,64
    80000d7e:	8082                	ret
      panic("kalloc");
    80000d80:	00007517          	auipc	a0,0x7
    80000d84:	3d850513          	addi	a0,a0,984 # 80008158 <etext+0x158>
    80000d88:	00005097          	auipc	ra,0x5
    80000d8c:	f24080e7          	jalr	-220(ra) # 80005cac <panic>

0000000080000d90 <procinit>:

// initialize the proc table at boot time.
void procinit(void)
{
    80000d90:	7139                	addi	sp,sp,-64
    80000d92:	fc06                	sd	ra,56(sp)
    80000d94:	f822                	sd	s0,48(sp)
    80000d96:	f426                	sd	s1,40(sp)
    80000d98:	f04a                	sd	s2,32(sp)
    80000d9a:	ec4e                	sd	s3,24(sp)
    80000d9c:	e852                	sd	s4,16(sp)
    80000d9e:	e456                	sd	s5,8(sp)
    80000da0:	e05a                	sd	s6,0(sp)
    80000da2:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80000da4:	00007597          	auipc	a1,0x7
    80000da8:	3bc58593          	addi	a1,a1,956 # 80008160 <etext+0x160>
    80000dac:	00008517          	auipc	a0,0x8
    80000db0:	2a450513          	addi	a0,a0,676 # 80009050 <pid_lock>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	3e2080e7          	jalr	994(ra) # 80006196 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbc:	00007597          	auipc	a1,0x7
    80000dc0:	3ac58593          	addi	a1,a1,940 # 80008168 <etext+0x168>
    80000dc4:	00008517          	auipc	a0,0x8
    80000dc8:	2a450513          	addi	a0,a0,676 # 80009068 <wait_lock>
    80000dcc:	00005097          	auipc	ra,0x5
    80000dd0:	3ca080e7          	jalr	970(ra) # 80006196 <initlock>
  for (p = proc; p < &proc[NPROC]; p++)
    80000dd4:	00008497          	auipc	s1,0x8
    80000dd8:	6ac48493          	addi	s1,s1,1708 # 80009480 <proc>
  {
    initlock(&p->lock, "proc");
    80000ddc:	00007b17          	auipc	s6,0x7
    80000de0:	39cb0b13          	addi	s6,s6,924 # 80008178 <etext+0x178>
    p->kstack = KSTACK((int)(p - proc));
    80000de4:	8aa6                	mv	s5,s1
    80000de6:	ff4df937          	lui	s2,0xff4df
    80000dea:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4b877d>
    80000dee:	0936                	slli	s2,s2,0xd
    80000df0:	6f590913          	addi	s2,s2,1781
    80000df4:	0936                	slli	s2,s2,0xd
    80000df6:	bd390913          	addi	s2,s2,-1069
    80000dfa:	0932                	slli	s2,s2,0xc
    80000dfc:	7a790913          	addi	s2,s2,1959
    80000e00:	010009b7          	lui	s3,0x1000
    80000e04:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000e06:	09ba                	slli	s3,s3,0xe
  for (p = proc; p < &proc[NPROC]; p++)
    80000e08:	0000ea17          	auipc	s4,0xe
    80000e0c:	278a0a13          	addi	s4,s4,632 # 8000f080 <tickslock>
    initlock(&p->lock, "proc");
    80000e10:	85da                	mv	a1,s6
    80000e12:	8526                	mv	a0,s1
    80000e14:	00005097          	auipc	ra,0x5
    80000e18:	382080e7          	jalr	898(ra) # 80006196 <initlock>
    p->kstack = KSTACK((int)(p - proc));
    80000e1c:	415487b3          	sub	a5,s1,s5
    80000e20:	8791                	srai	a5,a5,0x4
    80000e22:	032787b3          	mul	a5,a5,s2
    80000e26:	00d7979b          	slliw	a5,a5,0xd
    80000e2a:	40f987b3          	sub	a5,s3,a5
    80000e2e:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++)
    80000e30:	17048493          	addi	s1,s1,368
    80000e34:	fd449ee3          	bne	s1,s4,80000e10 <procinit+0x80>
  }
}
    80000e38:	70e2                	ld	ra,56(sp)
    80000e3a:	7442                	ld	s0,48(sp)
    80000e3c:	74a2                	ld	s1,40(sp)
    80000e3e:	7902                	ld	s2,32(sp)
    80000e40:	69e2                	ld	s3,24(sp)
    80000e42:	6a42                	ld	s4,16(sp)
    80000e44:	6aa2                	ld	s5,8(sp)
    80000e46:	6b02                	ld	s6,0(sp)
    80000e48:	6121                	addi	sp,sp,64
    80000e4a:	8082                	ret

0000000080000e4c <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e422                	sd	s0,8(sp)
    80000e50:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e52:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e54:	2501                	sext.w	a0,a0
    80000e56:	6422                	ld	s0,8(sp)
    80000e58:	0141                	addi	sp,sp,16
    80000e5a:	8082                	ret

0000000080000e5c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000e5c:	1141                	addi	sp,sp,-16
    80000e5e:	e422                	sd	s0,8(sp)
    80000e60:	0800                	addi	s0,sp,16
    80000e62:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e64:	2781                	sext.w	a5,a5
    80000e66:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e68:	00008517          	auipc	a0,0x8
    80000e6c:	21850513          	addi	a0,a0,536 # 80009080 <cpus>
    80000e70:	953e                	add	a0,a0,a5
    80000e72:	6422                	ld	s0,8(sp)
    80000e74:	0141                	addi	sp,sp,16
    80000e76:	8082                	ret

0000000080000e78 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000e78:	1101                	addi	sp,sp,-32
    80000e7a:	ec06                	sd	ra,24(sp)
    80000e7c:	e822                	sd	s0,16(sp)
    80000e7e:	e426                	sd	s1,8(sp)
    80000e80:	1000                	addi	s0,sp,32
  push_off();
    80000e82:	00005097          	auipc	ra,0x5
    80000e86:	358080e7          	jalr	856(ra) # 800061da <push_off>
    80000e8a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e8c:	2781                	sext.w	a5,a5
    80000e8e:	079e                	slli	a5,a5,0x7
    80000e90:	00008717          	auipc	a4,0x8
    80000e94:	1c070713          	addi	a4,a4,448 # 80009050 <pid_lock>
    80000e98:	97ba                	add	a5,a5,a4
    80000e9a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e9c:	00005097          	auipc	ra,0x5
    80000ea0:	3de080e7          	jalr	990(ra) # 8000627a <pop_off>
  return p;
}
    80000ea4:	8526                	mv	a0,s1
    80000ea6:	60e2                	ld	ra,24(sp)
    80000ea8:	6442                	ld	s0,16(sp)
    80000eaa:	64a2                	ld	s1,8(sp)
    80000eac:	6105                	addi	sp,sp,32
    80000eae:	8082                	ret

0000000080000eb0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000eb0:	1141                	addi	sp,sp,-16
    80000eb2:	e406                	sd	ra,8(sp)
    80000eb4:	e022                	sd	s0,0(sp)
    80000eb6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eb8:	00000097          	auipc	ra,0x0
    80000ebc:	fc0080e7          	jalr	-64(ra) # 80000e78 <myproc>
    80000ec0:	00005097          	auipc	ra,0x5
    80000ec4:	41a080e7          	jalr	1050(ra) # 800062da <release>

  if (first)
    80000ec8:	00008797          	auipc	a5,0x8
    80000ecc:	9987a783          	lw	a5,-1640(a5) # 80008860 <first.1>
    80000ed0:	eb89                	bnez	a5,80000ee2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed2:	00001097          	auipc	ra,0x1
    80000ed6:	c9a080e7          	jalr	-870(ra) # 80001b6c <usertrapret>
}
    80000eda:	60a2                	ld	ra,8(sp)
    80000edc:	6402                	ld	s0,0(sp)
    80000ede:	0141                	addi	sp,sp,16
    80000ee0:	8082                	ret
    first = 0;
    80000ee2:	00008797          	auipc	a5,0x8
    80000ee6:	9607af23          	sw	zero,-1666(a5) # 80008860 <first.1>
    fsinit(ROOTDEV);
    80000eea:	4505                	li	a0,1
    80000eec:	00002097          	auipc	ra,0x2
    80000ef0:	9dc080e7          	jalr	-1572(ra) # 800028c8 <fsinit>
    80000ef4:	bff9                	j	80000ed2 <forkret+0x22>

0000000080000ef6 <allocpid>:
{
    80000ef6:	1101                	addi	sp,sp,-32
    80000ef8:	ec06                	sd	ra,24(sp)
    80000efa:	e822                	sd	s0,16(sp)
    80000efc:	e426                	sd	s1,8(sp)
    80000efe:	e04a                	sd	s2,0(sp)
    80000f00:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f02:	00008917          	auipc	s2,0x8
    80000f06:	14e90913          	addi	s2,s2,334 # 80009050 <pid_lock>
    80000f0a:	854a                	mv	a0,s2
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	31a080e7          	jalr	794(ra) # 80006226 <acquire>
  pid = nextpid;
    80000f14:	00008797          	auipc	a5,0x8
    80000f18:	95078793          	addi	a5,a5,-1712 # 80008864 <nextpid>
    80000f1c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f1e:	0014871b          	addiw	a4,s1,1
    80000f22:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f24:	854a                	mv	a0,s2
    80000f26:	00005097          	auipc	ra,0x5
    80000f2a:	3b4080e7          	jalr	948(ra) # 800062da <release>
}
    80000f2e:	8526                	mv	a0,s1
    80000f30:	60e2                	ld	ra,24(sp)
    80000f32:	6442                	ld	s0,16(sp)
    80000f34:	64a2                	ld	s1,8(sp)
    80000f36:	6902                	ld	s2,0(sp)
    80000f38:	6105                	addi	sp,sp,32
    80000f3a:	8082                	ret

0000000080000f3c <proc_pagetable>:
{
    80000f3c:	1101                	addi	sp,sp,-32
    80000f3e:	ec06                	sd	ra,24(sp)
    80000f40:	e822                	sd	s0,16(sp)
    80000f42:	e426                	sd	s1,8(sp)
    80000f44:	e04a                	sd	s2,0(sp)
    80000f46:	1000                	addi	s0,sp,32
    80000f48:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f4a:	00000097          	auipc	ra,0x0
    80000f4e:	88a080e7          	jalr	-1910(ra) # 800007d4 <uvmcreate>
    80000f52:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000f54:	c525                	beqz	a0,80000fbc <proc_pagetable+0x80>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f56:	4729                	li	a4,10
    80000f58:	00006697          	auipc	a3,0x6
    80000f5c:	0a868693          	addi	a3,a3,168 # 80007000 <_trampoline>
    80000f60:	6605                	lui	a2,0x1
    80000f62:	040005b7          	lui	a1,0x4000
    80000f66:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f68:	05b2                	slli	a1,a1,0xc
    80000f6a:	fffff097          	auipc	ra,0xfffff
    80000f6e:	5d0080e7          	jalr	1488(ra) # 8000053a <mappages>
    80000f72:	04054c63          	bltz	a0,80000fca <proc_pagetable+0x8e>
  p->usyscall->pid = p->pid;
    80000f76:	16893783          	ld	a5,360(s2)
    80000f7a:	03092703          	lw	a4,48(s2)
    80000f7e:	c398                	sw	a4,0(a5)
  if (mappages(pagetable, USYSCALL, PGSIZE,
    80000f80:	4749                	li	a4,18
    80000f82:	16893683          	ld	a3,360(s2)
    80000f86:	6605                	lui	a2,0x1
    80000f88:	040005b7          	lui	a1,0x4000
    80000f8c:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80000f8e:	05b2                	slli	a1,a1,0xc
    80000f90:	8526                	mv	a0,s1
    80000f92:	fffff097          	auipc	ra,0xfffff
    80000f96:	5a8080e7          	jalr	1448(ra) # 8000053a <mappages>
    80000f9a:	04054063          	bltz	a0,80000fda <proc_pagetable+0x9e>
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f9e:	4719                	li	a4,6
    80000fa0:	05893683          	ld	a3,88(s2)
    80000fa4:	6605                	lui	a2,0x1
    80000fa6:	020005b7          	lui	a1,0x2000
    80000faa:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fac:	05b6                	slli	a1,a1,0xd
    80000fae:	8526                	mv	a0,s1
    80000fb0:	fffff097          	auipc	ra,0xfffff
    80000fb4:	58a080e7          	jalr	1418(ra) # 8000053a <mappages>
    80000fb8:	02054963          	bltz	a0,80000fea <proc_pagetable+0xae>
}
    80000fbc:	8526                	mv	a0,s1
    80000fbe:	60e2                	ld	ra,24(sp)
    80000fc0:	6442                	ld	s0,16(sp)
    80000fc2:	64a2                	ld	s1,8(sp)
    80000fc4:	6902                	ld	s2,0(sp)
    80000fc6:	6105                	addi	sp,sp,32
    80000fc8:	8082                	ret
    uvmfree(pagetable, 0);
    80000fca:	4581                	li	a1,0
    80000fcc:	8526                	mv	a0,s1
    80000fce:	00000097          	auipc	ra,0x0
    80000fd2:	a0c080e7          	jalr	-1524(ra) # 800009da <uvmfree>
    return 0;
    80000fd6:	4481                	li	s1,0
    80000fd8:	b7d5                	j	80000fbc <proc_pagetable+0x80>
    uvmfree(pagetable, 0);
    80000fda:	4581                	li	a1,0
    80000fdc:	8526                	mv	a0,s1
    80000fde:	00000097          	auipc	ra,0x0
    80000fe2:	9fc080e7          	jalr	-1540(ra) # 800009da <uvmfree>
    return 0;
    80000fe6:	4481                	li	s1,0
    80000fe8:	bfd1                	j	80000fbc <proc_pagetable+0x80>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fea:	4681                	li	a3,0
    80000fec:	4605                	li	a2,1
    80000fee:	040005b7          	lui	a1,0x4000
    80000ff2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff4:	05b2                	slli	a1,a1,0xc
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	708080e7          	jalr	1800(ra) # 80000700 <uvmunmap>
    uvmfree(pagetable, 0);
    80001000:	4581                	li	a1,0
    80001002:	8526                	mv	a0,s1
    80001004:	00000097          	auipc	ra,0x0
    80001008:	9d6080e7          	jalr	-1578(ra) # 800009da <uvmfree>
    return 0;
    8000100c:	4481                	li	s1,0
    8000100e:	b77d                	j	80000fbc <proc_pagetable+0x80>

0000000080001010 <proc_freepagetable>:
{
    80001010:	1101                	addi	sp,sp,-32
    80001012:	ec06                	sd	ra,24(sp)
    80001014:	e822                	sd	s0,16(sp)
    80001016:	e426                	sd	s1,8(sp)
    80001018:	e04a                	sd	s2,0(sp)
    8000101a:	1000                	addi	s0,sp,32
    8000101c:	84aa                	mv	s1,a0
    8000101e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001020:	4681                	li	a3,0
    80001022:	4605                	li	a2,1
    80001024:	040005b7          	lui	a1,0x4000
    80001028:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000102a:	05b2                	slli	a1,a1,0xc
    8000102c:	fffff097          	auipc	ra,0xfffff
    80001030:	6d4080e7          	jalr	1748(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001034:	4681                	li	a3,0
    80001036:	4605                	li	a2,1
    80001038:	040005b7          	lui	a1,0x4000
    8000103c:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    8000103e:	05b2                	slli	a1,a1,0xc
    80001040:	8526                	mv	a0,s1
    80001042:	fffff097          	auipc	ra,0xfffff
    80001046:	6be080e7          	jalr	1726(ra) # 80000700 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000104a:	4681                	li	a3,0
    8000104c:	4605                	li	a2,1
    8000104e:	020005b7          	lui	a1,0x2000
    80001052:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001054:	05b6                	slli	a1,a1,0xd
    80001056:	8526                	mv	a0,s1
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	6a8080e7          	jalr	1704(ra) # 80000700 <uvmunmap>
  uvmfree(pagetable, sz);
    80001060:	85ca                	mv	a1,s2
    80001062:	8526                	mv	a0,s1
    80001064:	00000097          	auipc	ra,0x0
    80001068:	976080e7          	jalr	-1674(ra) # 800009da <uvmfree>
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
  if (p->trapframe)
    80001084:	6d28                	ld	a0,88(a0)
    80001086:	c509                	beqz	a0,80001090 <freeproc+0x18>
    kfree((void *)p->trapframe);
    80001088:	fffff097          	auipc	ra,0xfffff
    8000108c:	f94080e7          	jalr	-108(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001090:	0404bc23          	sd	zero,88(s1)
  if (p->usyscall)
    80001094:	1684b503          	ld	a0,360(s1)
    80001098:	c509                	beqz	a0,800010a2 <freeproc+0x2a>
    kfree((void *)p->usyscall);
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	f82080e7          	jalr	-126(ra) # 8000001c <kfree>
  if (p->pagetable)
    800010a2:	68a8                	ld	a0,80(s1)
    800010a4:	c511                	beqz	a0,800010b0 <freeproc+0x38>
    proc_freepagetable(p->pagetable, p->sz);
    800010a6:	64ac                	ld	a1,72(s1)
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	f68080e7          	jalr	-152(ra) # 80001010 <proc_freepagetable>
  p->pagetable = 0;
    800010b0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800010b4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800010b8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800010bc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800010c0:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800010c4:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800010c8:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800010cc:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800010d0:	0004ac23          	sw	zero,24(s1)
}
    800010d4:	60e2                	ld	ra,24(sp)
    800010d6:	6442                	ld	s0,16(sp)
    800010d8:	64a2                	ld	s1,8(sp)
    800010da:	6105                	addi	sp,sp,32
    800010dc:	8082                	ret

00000000800010de <allocproc>:
{
    800010de:	1101                	addi	sp,sp,-32
    800010e0:	ec06                	sd	ra,24(sp)
    800010e2:	e822                	sd	s0,16(sp)
    800010e4:	e426                	sd	s1,8(sp)
    800010e6:	e04a                	sd	s2,0(sp)
    800010e8:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++)
    800010ea:	00008497          	auipc	s1,0x8
    800010ee:	39648493          	addi	s1,s1,918 # 80009480 <proc>
    800010f2:	0000e917          	auipc	s2,0xe
    800010f6:	f8e90913          	addi	s2,s2,-114 # 8000f080 <tickslock>
    acquire(&p->lock);
    800010fa:	8526                	mv	a0,s1
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	12a080e7          	jalr	298(ra) # 80006226 <acquire>
    if (p->state == UNUSED)
    80001104:	4c9c                	lw	a5,24(s1)
    80001106:	cf81                	beqz	a5,8000111e <allocproc+0x40>
      release(&p->lock);
    80001108:	8526                	mv	a0,s1
    8000110a:	00005097          	auipc	ra,0x5
    8000110e:	1d0080e7          	jalr	464(ra) # 800062da <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001112:	17048493          	addi	s1,s1,368
    80001116:	ff2492e3          	bne	s1,s2,800010fa <allocproc+0x1c>
  return 0;
    8000111a:	4481                	li	s1,0
    8000111c:	a08d                	j	8000117e <allocproc+0xa0>
  p->pid = allocpid();
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	dd8080e7          	jalr	-552(ra) # 80000ef6 <allocpid>
    80001126:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001128:	4785                	li	a5,1
    8000112a:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    8000112c:	fffff097          	auipc	ra,0xfffff
    80001130:	fee080e7          	jalr	-18(ra) # 8000011a <kalloc>
    80001134:	892a                	mv	s2,a0
    80001136:	eca8                	sd	a0,88(s1)
    80001138:	c931                	beqz	a0,8000118c <allocproc+0xae>
  if ((p->usyscall = (struct usyscall *)kalloc()) == 0)
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	fe0080e7          	jalr	-32(ra) # 8000011a <kalloc>
    80001142:	892a                	mv	s2,a0
    80001144:	16a4b423          	sd	a0,360(s1)
    80001148:	cd31                	beqz	a0,800011a4 <allocproc+0xc6>
  p->pagetable = proc_pagetable(p);
    8000114a:	8526                	mv	a0,s1
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	df0080e7          	jalr	-528(ra) # 80000f3c <proc_pagetable>
    80001154:	892a                	mv	s2,a0
    80001156:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0)
    80001158:	c135                	beqz	a0,800011bc <allocproc+0xde>
  memset(&p->context, 0, sizeof(p->context));
    8000115a:	07000613          	li	a2,112
    8000115e:	4581                	li	a1,0
    80001160:	06048513          	addi	a0,s1,96
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	016080e7          	jalr	22(ra) # 8000017a <memset>
  p->context.ra = (uint64)forkret;
    8000116c:	00000797          	auipc	a5,0x0
    80001170:	d4478793          	addi	a5,a5,-700 # 80000eb0 <forkret>
    80001174:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001176:	60bc                	ld	a5,64(s1)
    80001178:	6705                	lui	a4,0x1
    8000117a:	97ba                	add	a5,a5,a4
    8000117c:	f4bc                	sd	a5,104(s1)
}
    8000117e:	8526                	mv	a0,s1
    80001180:	60e2                	ld	ra,24(sp)
    80001182:	6442                	ld	s0,16(sp)
    80001184:	64a2                	ld	s1,8(sp)
    80001186:	6902                	ld	s2,0(sp)
    80001188:	6105                	addi	sp,sp,32
    8000118a:	8082                	ret
    freeproc(p);
    8000118c:	8526                	mv	a0,s1
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	eea080e7          	jalr	-278(ra) # 80001078 <freeproc>
    release(&p->lock);
    80001196:	8526                	mv	a0,s1
    80001198:	00005097          	auipc	ra,0x5
    8000119c:	142080e7          	jalr	322(ra) # 800062da <release>
    return 0;
    800011a0:	84ca                	mv	s1,s2
    800011a2:	bff1                	j	8000117e <allocproc+0xa0>
    freeproc(p);
    800011a4:	8526                	mv	a0,s1
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	ed2080e7          	jalr	-302(ra) # 80001078 <freeproc>
    release(&p->lock);
    800011ae:	8526                	mv	a0,s1
    800011b0:	00005097          	auipc	ra,0x5
    800011b4:	12a080e7          	jalr	298(ra) # 800062da <release>
    return 0;
    800011b8:	84ca                	mv	s1,s2
    800011ba:	b7d1                	j	8000117e <allocproc+0xa0>
    freeproc(p);
    800011bc:	8526                	mv	a0,s1
    800011be:	00000097          	auipc	ra,0x0
    800011c2:	eba080e7          	jalr	-326(ra) # 80001078 <freeproc>
    release(&p->lock);
    800011c6:	8526                	mv	a0,s1
    800011c8:	00005097          	auipc	ra,0x5
    800011cc:	112080e7          	jalr	274(ra) # 800062da <release>
    return 0;
    800011d0:	84ca                	mv	s1,s2
    800011d2:	b775                	j	8000117e <allocproc+0xa0>

00000000800011d4 <userinit>:
{
    800011d4:	1101                	addi	sp,sp,-32
    800011d6:	ec06                	sd	ra,24(sp)
    800011d8:	e822                	sd	s0,16(sp)
    800011da:	e426                	sd	s1,8(sp)
    800011dc:	1000                	addi	s0,sp,32
  p = allocproc();
    800011de:	00000097          	auipc	ra,0x0
    800011e2:	f00080e7          	jalr	-256(ra) # 800010de <allocproc>
    800011e6:	84aa                	mv	s1,a0
  initproc = p;
    800011e8:	00008797          	auipc	a5,0x8
    800011ec:	e2a7b423          	sd	a0,-472(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011f0:	03400613          	li	a2,52
    800011f4:	00007597          	auipc	a1,0x7
    800011f8:	67c58593          	addi	a1,a1,1660 # 80008870 <initcode>
    800011fc:	6928                	ld	a0,80(a0)
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	604080e7          	jalr	1540(ra) # 80000802 <uvminit>
  p->sz = PGSIZE;
    80001206:	6785                	lui	a5,0x1
    80001208:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;     // user program counter
    8000120a:	6cb8                	ld	a4,88(s1)
    8000120c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE; // user stack pointer
    80001210:	6cb8                	ld	a4,88(s1)
    80001212:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001214:	4641                	li	a2,16
    80001216:	00007597          	auipc	a1,0x7
    8000121a:	f6a58593          	addi	a1,a1,-150 # 80008180 <etext+0x180>
    8000121e:	15848513          	addi	a0,s1,344
    80001222:	fffff097          	auipc	ra,0xfffff
    80001226:	09a080e7          	jalr	154(ra) # 800002bc <safestrcpy>
  p->cwd = namei("/");
    8000122a:	00007517          	auipc	a0,0x7
    8000122e:	f6650513          	addi	a0,a0,-154 # 80008190 <etext+0x190>
    80001232:	00002097          	auipc	ra,0x2
    80001236:	0dc080e7          	jalr	220(ra) # 8000330e <namei>
    8000123a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000123e:	478d                	li	a5,3
    80001240:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001242:	8526                	mv	a0,s1
    80001244:	00005097          	auipc	ra,0x5
    80001248:	096080e7          	jalr	150(ra) # 800062da <release>
}
    8000124c:	60e2                	ld	ra,24(sp)
    8000124e:	6442                	ld	s0,16(sp)
    80001250:	64a2                	ld	s1,8(sp)
    80001252:	6105                	addi	sp,sp,32
    80001254:	8082                	ret

0000000080001256 <growproc>:
{
    80001256:	1101                	addi	sp,sp,-32
    80001258:	ec06                	sd	ra,24(sp)
    8000125a:	e822                	sd	s0,16(sp)
    8000125c:	e426                	sd	s1,8(sp)
    8000125e:	e04a                	sd	s2,0(sp)
    80001260:	1000                	addi	s0,sp,32
    80001262:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001264:	00000097          	auipc	ra,0x0
    80001268:	c14080e7          	jalr	-1004(ra) # 80000e78 <myproc>
    8000126c:	892a                	mv	s2,a0
  sz = p->sz;
    8000126e:	652c                	ld	a1,72(a0)
    80001270:	0005879b          	sext.w	a5,a1
  if (n > 0)
    80001274:	00904f63          	bgtz	s1,80001292 <growproc+0x3c>
  else if (n < 0)
    80001278:	0204cd63          	bltz	s1,800012b2 <growproc+0x5c>
  p->sz = sz;
    8000127c:	1782                	slli	a5,a5,0x20
    8000127e:	9381                	srli	a5,a5,0x20
    80001280:	04f93423          	sd	a5,72(s2)
  return 0;
    80001284:	4501                	li	a0,0
}
    80001286:	60e2                	ld	ra,24(sp)
    80001288:	6442                	ld	s0,16(sp)
    8000128a:	64a2                	ld	s1,8(sp)
    8000128c:	6902                	ld	s2,0(sp)
    8000128e:	6105                	addi	sp,sp,32
    80001290:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0)
    80001292:	00f4863b          	addw	a2,s1,a5
    80001296:	1602                	slli	a2,a2,0x20
    80001298:	9201                	srli	a2,a2,0x20
    8000129a:	1582                	slli	a1,a1,0x20
    8000129c:	9181                	srli	a1,a1,0x20
    8000129e:	6928                	ld	a0,80(a0)
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	61c080e7          	jalr	1564(ra) # 800008bc <uvmalloc>
    800012a8:	0005079b          	sext.w	a5,a0
    800012ac:	fbe1                	bnez	a5,8000127c <growproc+0x26>
      return -1;
    800012ae:	557d                	li	a0,-1
    800012b0:	bfd9                	j	80001286 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800012b2:	00f4863b          	addw	a2,s1,a5
    800012b6:	1602                	slli	a2,a2,0x20
    800012b8:	9201                	srli	a2,a2,0x20
    800012ba:	1582                	slli	a1,a1,0x20
    800012bc:	9181                	srli	a1,a1,0x20
    800012be:	6928                	ld	a0,80(a0)
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	5b4080e7          	jalr	1460(ra) # 80000874 <uvmdealloc>
    800012c8:	0005079b          	sext.w	a5,a0
    800012cc:	bf45                	j	8000127c <growproc+0x26>

00000000800012ce <fork>:
{
    800012ce:	7139                	addi	sp,sp,-64
    800012d0:	fc06                	sd	ra,56(sp)
    800012d2:	f822                	sd	s0,48(sp)
    800012d4:	f04a                	sd	s2,32(sp)
    800012d6:	e456                	sd	s5,8(sp)
    800012d8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800012da:	00000097          	auipc	ra,0x0
    800012de:	b9e080e7          	jalr	-1122(ra) # 80000e78 <myproc>
    800012e2:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0)
    800012e4:	00000097          	auipc	ra,0x0
    800012e8:	dfa080e7          	jalr	-518(ra) # 800010de <allocproc>
    800012ec:	12050063          	beqz	a0,8000140c <fork+0x13e>
    800012f0:	e852                	sd	s4,16(sp)
    800012f2:	8a2a                	mv	s4,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800012f4:	048ab603          	ld	a2,72(s5)
    800012f8:	692c                	ld	a1,80(a0)
    800012fa:	050ab503          	ld	a0,80(s5)
    800012fe:	fffff097          	auipc	ra,0xfffff
    80001302:	716080e7          	jalr	1814(ra) # 80000a14 <uvmcopy>
    80001306:	04054a63          	bltz	a0,8000135a <fork+0x8c>
    8000130a:	f426                	sd	s1,40(sp)
    8000130c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000130e:	048ab783          	ld	a5,72(s5)
    80001312:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001316:	058ab683          	ld	a3,88(s5)
    8000131a:	87b6                	mv	a5,a3
    8000131c:	058a3703          	ld	a4,88(s4)
    80001320:	12068693          	addi	a3,a3,288
    80001324:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001328:	6788                	ld	a0,8(a5)
    8000132a:	6b8c                	ld	a1,16(a5)
    8000132c:	6f90                	ld	a2,24(a5)
    8000132e:	01073023          	sd	a6,0(a4)
    80001332:	e708                	sd	a0,8(a4)
    80001334:	eb0c                	sd	a1,16(a4)
    80001336:	ef10                	sd	a2,24(a4)
    80001338:	02078793          	addi	a5,a5,32
    8000133c:	02070713          	addi	a4,a4,32
    80001340:	fed792e3          	bne	a5,a3,80001324 <fork+0x56>
  np->trapframe->a0 = 0;
    80001344:	058a3783          	ld	a5,88(s4)
    80001348:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    8000134c:	0d0a8493          	addi	s1,s5,208
    80001350:	0d0a0913          	addi	s2,s4,208
    80001354:	150a8993          	addi	s3,s5,336
    80001358:	a015                	j	8000137c <fork+0xae>
    freeproc(np);
    8000135a:	8552                	mv	a0,s4
    8000135c:	00000097          	auipc	ra,0x0
    80001360:	d1c080e7          	jalr	-740(ra) # 80001078 <freeproc>
    release(&np->lock);
    80001364:	8552                	mv	a0,s4
    80001366:	00005097          	auipc	ra,0x5
    8000136a:	f74080e7          	jalr	-140(ra) # 800062da <release>
    return -1;
    8000136e:	597d                	li	s2,-1
    80001370:	6a42                	ld	s4,16(sp)
    80001372:	a071                	j	800013fe <fork+0x130>
  for (i = 0; i < NOFILE; i++)
    80001374:	04a1                	addi	s1,s1,8
    80001376:	0921                	addi	s2,s2,8
    80001378:	01348b63          	beq	s1,s3,8000138e <fork+0xc0>
    if (p->ofile[i])
    8000137c:	6088                	ld	a0,0(s1)
    8000137e:	d97d                	beqz	a0,80001374 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001380:	00002097          	auipc	ra,0x2
    80001384:	606080e7          	jalr	1542(ra) # 80003986 <filedup>
    80001388:	00a93023          	sd	a0,0(s2)
    8000138c:	b7e5                	j	80001374 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000138e:	150ab503          	ld	a0,336(s5)
    80001392:	00001097          	auipc	ra,0x1
    80001396:	76c080e7          	jalr	1900(ra) # 80002afe <idup>
    8000139a:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000139e:	4641                	li	a2,16
    800013a0:	158a8593          	addi	a1,s5,344
    800013a4:	158a0513          	addi	a0,s4,344
    800013a8:	fffff097          	auipc	ra,0xfffff
    800013ac:	f14080e7          	jalr	-236(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    800013b0:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    800013b4:	8552                	mv	a0,s4
    800013b6:	00005097          	auipc	ra,0x5
    800013ba:	f24080e7          	jalr	-220(ra) # 800062da <release>
  acquire(&wait_lock);
    800013be:	00008497          	auipc	s1,0x8
    800013c2:	caa48493          	addi	s1,s1,-854 # 80009068 <wait_lock>
    800013c6:	8526                	mv	a0,s1
    800013c8:	00005097          	auipc	ra,0x5
    800013cc:	e5e080e7          	jalr	-418(ra) # 80006226 <acquire>
  np->parent = p;
    800013d0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800013d4:	8526                	mv	a0,s1
    800013d6:	00005097          	auipc	ra,0x5
    800013da:	f04080e7          	jalr	-252(ra) # 800062da <release>
  acquire(&np->lock);
    800013de:	8552                	mv	a0,s4
    800013e0:	00005097          	auipc	ra,0x5
    800013e4:	e46080e7          	jalr	-442(ra) # 80006226 <acquire>
  np->state = RUNNABLE;
    800013e8:	478d                	li	a5,3
    800013ea:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013ee:	8552                	mv	a0,s4
    800013f0:	00005097          	auipc	ra,0x5
    800013f4:	eea080e7          	jalr	-278(ra) # 800062da <release>
  return pid;
    800013f8:	74a2                	ld	s1,40(sp)
    800013fa:	69e2                	ld	s3,24(sp)
    800013fc:	6a42                	ld	s4,16(sp)
}
    800013fe:	854a                	mv	a0,s2
    80001400:	70e2                	ld	ra,56(sp)
    80001402:	7442                	ld	s0,48(sp)
    80001404:	7902                	ld	s2,32(sp)
    80001406:	6aa2                	ld	s5,8(sp)
    80001408:	6121                	addi	sp,sp,64
    8000140a:	8082                	ret
    return -1;
    8000140c:	597d                	li	s2,-1
    8000140e:	bfc5                	j	800013fe <fork+0x130>

0000000080001410 <scheduler>:
{
    80001410:	7139                	addi	sp,sp,-64
    80001412:	fc06                	sd	ra,56(sp)
    80001414:	f822                	sd	s0,48(sp)
    80001416:	f426                	sd	s1,40(sp)
    80001418:	f04a                	sd	s2,32(sp)
    8000141a:	ec4e                	sd	s3,24(sp)
    8000141c:	e852                	sd	s4,16(sp)
    8000141e:	e456                	sd	s5,8(sp)
    80001420:	e05a                	sd	s6,0(sp)
    80001422:	0080                	addi	s0,sp,64
    80001424:	8792                	mv	a5,tp
  int id = r_tp();
    80001426:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001428:	00779a93          	slli	s5,a5,0x7
    8000142c:	00008717          	auipc	a4,0x8
    80001430:	c2470713          	addi	a4,a4,-988 # 80009050 <pid_lock>
    80001434:	9756                	add	a4,a4,s5
    80001436:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000143a:	00008717          	auipc	a4,0x8
    8000143e:	c4e70713          	addi	a4,a4,-946 # 80009088 <cpus+0x8>
    80001442:	9aba                	add	s5,s5,a4
      if (p->state == RUNNABLE)
    80001444:	498d                	li	s3,3
        p->state = RUNNING;
    80001446:	4b11                	li	s6,4
        c->proc = p;
    80001448:	079e                	slli	a5,a5,0x7
    8000144a:	00008a17          	auipc	s4,0x8
    8000144e:	c06a0a13          	addi	s4,s4,-1018 # 80009050 <pid_lock>
    80001452:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001454:	0000e917          	auipc	s2,0xe
    80001458:	c2c90913          	addi	s2,s2,-980 # 8000f080 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000145c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001460:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001464:	10079073          	csrw	sstatus,a5
    80001468:	00008497          	auipc	s1,0x8
    8000146c:	01848493          	addi	s1,s1,24 # 80009480 <proc>
    80001470:	a811                	j	80001484 <scheduler+0x74>
      release(&p->lock);
    80001472:	8526                	mv	a0,s1
    80001474:	00005097          	auipc	ra,0x5
    80001478:	e66080e7          	jalr	-410(ra) # 800062da <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000147c:	17048493          	addi	s1,s1,368
    80001480:	fd248ee3          	beq	s1,s2,8000145c <scheduler+0x4c>
      acquire(&p->lock);
    80001484:	8526                	mv	a0,s1
    80001486:	00005097          	auipc	ra,0x5
    8000148a:	da0080e7          	jalr	-608(ra) # 80006226 <acquire>
      if (p->state == RUNNABLE)
    8000148e:	4c9c                	lw	a5,24(s1)
    80001490:	ff3791e3          	bne	a5,s3,80001472 <scheduler+0x62>
        p->state = RUNNING;
    80001494:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001498:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000149c:	06048593          	addi	a1,s1,96
    800014a0:	8556                	mv	a0,s5
    800014a2:	00000097          	auipc	ra,0x0
    800014a6:	620080e7          	jalr	1568(ra) # 80001ac2 <swtch>
        c->proc = 0;
    800014aa:	020a3823          	sd	zero,48(s4)
    800014ae:	b7d1                	j	80001472 <scheduler+0x62>

00000000800014b0 <sched>:
{
    800014b0:	7179                	addi	sp,sp,-48
    800014b2:	f406                	sd	ra,40(sp)
    800014b4:	f022                	sd	s0,32(sp)
    800014b6:	ec26                	sd	s1,24(sp)
    800014b8:	e84a                	sd	s2,16(sp)
    800014ba:	e44e                	sd	s3,8(sp)
    800014bc:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014be:	00000097          	auipc	ra,0x0
    800014c2:	9ba080e7          	jalr	-1606(ra) # 80000e78 <myproc>
    800014c6:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    800014c8:	00005097          	auipc	ra,0x5
    800014cc:	ce4080e7          	jalr	-796(ra) # 800061ac <holding>
    800014d0:	c93d                	beqz	a0,80001546 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014d2:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    800014d4:	2781                	sext.w	a5,a5
    800014d6:	079e                	slli	a5,a5,0x7
    800014d8:	00008717          	auipc	a4,0x8
    800014dc:	b7870713          	addi	a4,a4,-1160 # 80009050 <pid_lock>
    800014e0:	97ba                	add	a5,a5,a4
    800014e2:	0a87a703          	lw	a4,168(a5)
    800014e6:	4785                	li	a5,1
    800014e8:	06f71763          	bne	a4,a5,80001556 <sched+0xa6>
  if (p->state == RUNNING)
    800014ec:	4c98                	lw	a4,24(s1)
    800014ee:	4791                	li	a5,4
    800014f0:	06f70b63          	beq	a4,a5,80001566 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014f4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014f8:	8b89                	andi	a5,a5,2
  if (intr_get())
    800014fa:	efb5                	bnez	a5,80001576 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014fc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014fe:	00008917          	auipc	s2,0x8
    80001502:	b5290913          	addi	s2,s2,-1198 # 80009050 <pid_lock>
    80001506:	2781                	sext.w	a5,a5
    80001508:	079e                	slli	a5,a5,0x7
    8000150a:	97ca                	add	a5,a5,s2
    8000150c:	0ac7a983          	lw	s3,172(a5)
    80001510:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001512:	2781                	sext.w	a5,a5
    80001514:	079e                	slli	a5,a5,0x7
    80001516:	00008597          	auipc	a1,0x8
    8000151a:	b7258593          	addi	a1,a1,-1166 # 80009088 <cpus+0x8>
    8000151e:	95be                	add	a1,a1,a5
    80001520:	06048513          	addi	a0,s1,96
    80001524:	00000097          	auipc	ra,0x0
    80001528:	59e080e7          	jalr	1438(ra) # 80001ac2 <swtch>
    8000152c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000152e:	2781                	sext.w	a5,a5
    80001530:	079e                	slli	a5,a5,0x7
    80001532:	993e                	add	s2,s2,a5
    80001534:	0b392623          	sw	s3,172(s2)
}
    80001538:	70a2                	ld	ra,40(sp)
    8000153a:	7402                	ld	s0,32(sp)
    8000153c:	64e2                	ld	s1,24(sp)
    8000153e:	6942                	ld	s2,16(sp)
    80001540:	69a2                	ld	s3,8(sp)
    80001542:	6145                	addi	sp,sp,48
    80001544:	8082                	ret
    panic("sched p->lock");
    80001546:	00007517          	auipc	a0,0x7
    8000154a:	c5250513          	addi	a0,a0,-942 # 80008198 <etext+0x198>
    8000154e:	00004097          	auipc	ra,0x4
    80001552:	75e080e7          	jalr	1886(ra) # 80005cac <panic>
    panic("sched locks");
    80001556:	00007517          	auipc	a0,0x7
    8000155a:	c5250513          	addi	a0,a0,-942 # 800081a8 <etext+0x1a8>
    8000155e:	00004097          	auipc	ra,0x4
    80001562:	74e080e7          	jalr	1870(ra) # 80005cac <panic>
    panic("sched running");
    80001566:	00007517          	auipc	a0,0x7
    8000156a:	c5250513          	addi	a0,a0,-942 # 800081b8 <etext+0x1b8>
    8000156e:	00004097          	auipc	ra,0x4
    80001572:	73e080e7          	jalr	1854(ra) # 80005cac <panic>
    panic("sched interruptible");
    80001576:	00007517          	auipc	a0,0x7
    8000157a:	c5250513          	addi	a0,a0,-942 # 800081c8 <etext+0x1c8>
    8000157e:	00004097          	auipc	ra,0x4
    80001582:	72e080e7          	jalr	1838(ra) # 80005cac <panic>

0000000080001586 <yield>:
{
    80001586:	1101                	addi	sp,sp,-32
    80001588:	ec06                	sd	ra,24(sp)
    8000158a:	e822                	sd	s0,16(sp)
    8000158c:	e426                	sd	s1,8(sp)
    8000158e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001590:	00000097          	auipc	ra,0x0
    80001594:	8e8080e7          	jalr	-1816(ra) # 80000e78 <myproc>
    80001598:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	c8c080e7          	jalr	-884(ra) # 80006226 <acquire>
  p->state = RUNNABLE;
    800015a2:	478d                	li	a5,3
    800015a4:	cc9c                	sw	a5,24(s1)
  sched();
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	f0a080e7          	jalr	-246(ra) # 800014b0 <sched>
  release(&p->lock);
    800015ae:	8526                	mv	a0,s1
    800015b0:	00005097          	auipc	ra,0x5
    800015b4:	d2a080e7          	jalr	-726(ra) # 800062da <release>
}
    800015b8:	60e2                	ld	ra,24(sp)
    800015ba:	6442                	ld	s0,16(sp)
    800015bc:	64a2                	ld	s1,8(sp)
    800015be:	6105                	addi	sp,sp,32
    800015c0:	8082                	ret

00000000800015c2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800015c2:	7179                	addi	sp,sp,-48
    800015c4:	f406                	sd	ra,40(sp)
    800015c6:	f022                	sd	s0,32(sp)
    800015c8:	ec26                	sd	s1,24(sp)
    800015ca:	e84a                	sd	s2,16(sp)
    800015cc:	e44e                	sd	s3,8(sp)
    800015ce:	1800                	addi	s0,sp,48
    800015d0:	89aa                	mv	s3,a0
    800015d2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015d4:	00000097          	auipc	ra,0x0
    800015d8:	8a4080e7          	jalr	-1884(ra) # 80000e78 <myproc>
    800015dc:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
    800015de:	00005097          	auipc	ra,0x5
    800015e2:	c48080e7          	jalr	-952(ra) # 80006226 <acquire>
  release(lk);
    800015e6:	854a                	mv	a0,s2
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	cf2080e7          	jalr	-782(ra) # 800062da <release>

  // Go to sleep.
  p->chan = chan;
    800015f0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015f4:	4789                	li	a5,2
    800015f6:	cc9c                	sw	a5,24(s1)

  sched();
    800015f8:	00000097          	auipc	ra,0x0
    800015fc:	eb8080e7          	jalr	-328(ra) # 800014b0 <sched>

  // Tidy up.
  p->chan = 0;
    80001600:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001604:	8526                	mv	a0,s1
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	cd4080e7          	jalr	-812(ra) # 800062da <release>
  acquire(lk);
    8000160e:	854a                	mv	a0,s2
    80001610:	00005097          	auipc	ra,0x5
    80001614:	c16080e7          	jalr	-1002(ra) # 80006226 <acquire>
}
    80001618:	70a2                	ld	ra,40(sp)
    8000161a:	7402                	ld	s0,32(sp)
    8000161c:	64e2                	ld	s1,24(sp)
    8000161e:	6942                	ld	s2,16(sp)
    80001620:	69a2                	ld	s3,8(sp)
    80001622:	6145                	addi	sp,sp,48
    80001624:	8082                	ret

0000000080001626 <wait>:
{
    80001626:	715d                	addi	sp,sp,-80
    80001628:	e486                	sd	ra,72(sp)
    8000162a:	e0a2                	sd	s0,64(sp)
    8000162c:	fc26                	sd	s1,56(sp)
    8000162e:	f84a                	sd	s2,48(sp)
    80001630:	f44e                	sd	s3,40(sp)
    80001632:	f052                	sd	s4,32(sp)
    80001634:	ec56                	sd	s5,24(sp)
    80001636:	e85a                	sd	s6,16(sp)
    80001638:	e45e                	sd	s7,8(sp)
    8000163a:	e062                	sd	s8,0(sp)
    8000163c:	0880                	addi	s0,sp,80
    8000163e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001640:	00000097          	auipc	ra,0x0
    80001644:	838080e7          	jalr	-1992(ra) # 80000e78 <myproc>
    80001648:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000164a:	00008517          	auipc	a0,0x8
    8000164e:	a1e50513          	addi	a0,a0,-1506 # 80009068 <wait_lock>
    80001652:	00005097          	auipc	ra,0x5
    80001656:	bd4080e7          	jalr	-1068(ra) # 80006226 <acquire>
    havekids = 0;
    8000165a:	4b81                	li	s7,0
        if (np->state == ZOMBIE)
    8000165c:	4a15                	li	s4,5
        havekids = 1;
    8000165e:	4a85                	li	s5,1
    for (np = proc; np < &proc[NPROC]; np++)
    80001660:	0000e997          	auipc	s3,0xe
    80001664:	a2098993          	addi	s3,s3,-1504 # 8000f080 <tickslock>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80001668:	00008c17          	auipc	s8,0x8
    8000166c:	a00c0c13          	addi	s8,s8,-1536 # 80009068 <wait_lock>
    80001670:	a87d                	j	8000172e <wait+0x108>
          pid = np->pid;
    80001672:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001676:	000b0e63          	beqz	s6,80001692 <wait+0x6c>
    8000167a:	4691                	li	a3,4
    8000167c:	02c48613          	addi	a2,s1,44
    80001680:	85da                	mv	a1,s6
    80001682:	05093503          	ld	a0,80(s2)
    80001686:	fffff097          	auipc	ra,0xfffff
    8000168a:	492080e7          	jalr	1170(ra) # 80000b18 <copyout>
    8000168e:	04054163          	bltz	a0,800016d0 <wait+0xaa>
          freeproc(np);
    80001692:	8526                	mv	a0,s1
    80001694:	00000097          	auipc	ra,0x0
    80001698:	9e4080e7          	jalr	-1564(ra) # 80001078 <freeproc>
          release(&np->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	00005097          	auipc	ra,0x5
    800016a2:	c3c080e7          	jalr	-964(ra) # 800062da <release>
          release(&wait_lock);
    800016a6:	00008517          	auipc	a0,0x8
    800016aa:	9c250513          	addi	a0,a0,-1598 # 80009068 <wait_lock>
    800016ae:	00005097          	auipc	ra,0x5
    800016b2:	c2c080e7          	jalr	-980(ra) # 800062da <release>
}
    800016b6:	854e                	mv	a0,s3
    800016b8:	60a6                	ld	ra,72(sp)
    800016ba:	6406                	ld	s0,64(sp)
    800016bc:	74e2                	ld	s1,56(sp)
    800016be:	7942                	ld	s2,48(sp)
    800016c0:	79a2                	ld	s3,40(sp)
    800016c2:	7a02                	ld	s4,32(sp)
    800016c4:	6ae2                	ld	s5,24(sp)
    800016c6:	6b42                	ld	s6,16(sp)
    800016c8:	6ba2                	ld	s7,8(sp)
    800016ca:	6c02                	ld	s8,0(sp)
    800016cc:	6161                	addi	sp,sp,80
    800016ce:	8082                	ret
            release(&np->lock);
    800016d0:	8526                	mv	a0,s1
    800016d2:	00005097          	auipc	ra,0x5
    800016d6:	c08080e7          	jalr	-1016(ra) # 800062da <release>
            release(&wait_lock);
    800016da:	00008517          	auipc	a0,0x8
    800016de:	98e50513          	addi	a0,a0,-1650 # 80009068 <wait_lock>
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	bf8080e7          	jalr	-1032(ra) # 800062da <release>
            return -1;
    800016ea:	59fd                	li	s3,-1
    800016ec:	b7e9                	j	800016b6 <wait+0x90>
    for (np = proc; np < &proc[NPROC]; np++)
    800016ee:	17048493          	addi	s1,s1,368
    800016f2:	03348463          	beq	s1,s3,8000171a <wait+0xf4>
      if (np->parent == p)
    800016f6:	7c9c                	ld	a5,56(s1)
    800016f8:	ff279be3          	bne	a5,s2,800016ee <wait+0xc8>
        acquire(&np->lock);
    800016fc:	8526                	mv	a0,s1
    800016fe:	00005097          	auipc	ra,0x5
    80001702:	b28080e7          	jalr	-1240(ra) # 80006226 <acquire>
        if (np->state == ZOMBIE)
    80001706:	4c9c                	lw	a5,24(s1)
    80001708:	f74785e3          	beq	a5,s4,80001672 <wait+0x4c>
        release(&np->lock);
    8000170c:	8526                	mv	a0,s1
    8000170e:	00005097          	auipc	ra,0x5
    80001712:	bcc080e7          	jalr	-1076(ra) # 800062da <release>
        havekids = 1;
    80001716:	8756                	mv	a4,s5
    80001718:	bfd9                	j	800016ee <wait+0xc8>
    if (!havekids || p->killed)
    8000171a:	c305                	beqz	a4,8000173a <wait+0x114>
    8000171c:	02892783          	lw	a5,40(s2)
    80001720:	ef89                	bnez	a5,8000173a <wait+0x114>
    sleep(p, &wait_lock); // DOC: wait-sleep
    80001722:	85e2                	mv	a1,s8
    80001724:	854a                	mv	a0,s2
    80001726:	00000097          	auipc	ra,0x0
    8000172a:	e9c080e7          	jalr	-356(ra) # 800015c2 <sleep>
    havekids = 0;
    8000172e:	875e                	mv	a4,s7
    for (np = proc; np < &proc[NPROC]; np++)
    80001730:	00008497          	auipc	s1,0x8
    80001734:	d5048493          	addi	s1,s1,-688 # 80009480 <proc>
    80001738:	bf7d                	j	800016f6 <wait+0xd0>
      release(&wait_lock);
    8000173a:	00008517          	auipc	a0,0x8
    8000173e:	92e50513          	addi	a0,a0,-1746 # 80009068 <wait_lock>
    80001742:	00005097          	auipc	ra,0x5
    80001746:	b98080e7          	jalr	-1128(ra) # 800062da <release>
      return -1;
    8000174a:	59fd                	li	s3,-1
    8000174c:	b7ad                	j	800016b6 <wait+0x90>

000000008000174e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000174e:	7139                	addi	sp,sp,-64
    80001750:	fc06                	sd	ra,56(sp)
    80001752:	f822                	sd	s0,48(sp)
    80001754:	f426                	sd	s1,40(sp)
    80001756:	f04a                	sd	s2,32(sp)
    80001758:	ec4e                	sd	s3,24(sp)
    8000175a:	e852                	sd	s4,16(sp)
    8000175c:	e456                	sd	s5,8(sp)
    8000175e:	0080                	addi	s0,sp,64
    80001760:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001762:	00008497          	auipc	s1,0x8
    80001766:	d1e48493          	addi	s1,s1,-738 # 80009480 <proc>
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
    8000176a:	4989                	li	s3,2
      {
        p->state = RUNNABLE;
    8000176c:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++)
    8000176e:	0000e917          	auipc	s2,0xe
    80001772:	91290913          	addi	s2,s2,-1774 # 8000f080 <tickslock>
    80001776:	a811                	j	8000178a <wakeup+0x3c>
      }
      release(&p->lock);
    80001778:	8526                	mv	a0,s1
    8000177a:	00005097          	auipc	ra,0x5
    8000177e:	b60080e7          	jalr	-1184(ra) # 800062da <release>
  for (p = proc; p < &proc[NPROC]; p++)
    80001782:	17048493          	addi	s1,s1,368
    80001786:	03248663          	beq	s1,s2,800017b2 <wakeup+0x64>
    if (p != myproc())
    8000178a:	fffff097          	auipc	ra,0xfffff
    8000178e:	6ee080e7          	jalr	1774(ra) # 80000e78 <myproc>
    80001792:	fea488e3          	beq	s1,a0,80001782 <wakeup+0x34>
      acquire(&p->lock);
    80001796:	8526                	mv	a0,s1
    80001798:	00005097          	auipc	ra,0x5
    8000179c:	a8e080e7          	jalr	-1394(ra) # 80006226 <acquire>
      if (p->state == SLEEPING && p->chan == chan)
    800017a0:	4c9c                	lw	a5,24(s1)
    800017a2:	fd379be3          	bne	a5,s3,80001778 <wakeup+0x2a>
    800017a6:	709c                	ld	a5,32(s1)
    800017a8:	fd4798e3          	bne	a5,s4,80001778 <wakeup+0x2a>
        p->state = RUNNABLE;
    800017ac:	0154ac23          	sw	s5,24(s1)
    800017b0:	b7e1                	j	80001778 <wakeup+0x2a>
    }
  }
}
    800017b2:	70e2                	ld	ra,56(sp)
    800017b4:	7442                	ld	s0,48(sp)
    800017b6:	74a2                	ld	s1,40(sp)
    800017b8:	7902                	ld	s2,32(sp)
    800017ba:	69e2                	ld	s3,24(sp)
    800017bc:	6a42                	ld	s4,16(sp)
    800017be:	6aa2                	ld	s5,8(sp)
    800017c0:	6121                	addi	sp,sp,64
    800017c2:	8082                	ret

00000000800017c4 <reparent>:
{
    800017c4:	7179                	addi	sp,sp,-48
    800017c6:	f406                	sd	ra,40(sp)
    800017c8:	f022                	sd	s0,32(sp)
    800017ca:	ec26                	sd	s1,24(sp)
    800017cc:	e84a                	sd	s2,16(sp)
    800017ce:	e44e                	sd	s3,8(sp)
    800017d0:	e052                	sd	s4,0(sp)
    800017d2:	1800                	addi	s0,sp,48
    800017d4:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800017d6:	00008497          	auipc	s1,0x8
    800017da:	caa48493          	addi	s1,s1,-854 # 80009480 <proc>
      pp->parent = initproc;
    800017de:	00008a17          	auipc	s4,0x8
    800017e2:	832a0a13          	addi	s4,s4,-1998 # 80009010 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++)
    800017e6:	0000e997          	auipc	s3,0xe
    800017ea:	89a98993          	addi	s3,s3,-1894 # 8000f080 <tickslock>
    800017ee:	a029                	j	800017f8 <reparent+0x34>
    800017f0:	17048493          	addi	s1,s1,368
    800017f4:	01348d63          	beq	s1,s3,8000180e <reparent+0x4a>
    if (pp->parent == p)
    800017f8:	7c9c                	ld	a5,56(s1)
    800017fa:	ff279be3          	bne	a5,s2,800017f0 <reparent+0x2c>
      pp->parent = initproc;
    800017fe:	000a3503          	ld	a0,0(s4)
    80001802:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001804:	00000097          	auipc	ra,0x0
    80001808:	f4a080e7          	jalr	-182(ra) # 8000174e <wakeup>
    8000180c:	b7d5                	j	800017f0 <reparent+0x2c>
}
    8000180e:	70a2                	ld	ra,40(sp)
    80001810:	7402                	ld	s0,32(sp)
    80001812:	64e2                	ld	s1,24(sp)
    80001814:	6942                	ld	s2,16(sp)
    80001816:	69a2                	ld	s3,8(sp)
    80001818:	6a02                	ld	s4,0(sp)
    8000181a:	6145                	addi	sp,sp,48
    8000181c:	8082                	ret

000000008000181e <exit>:
{
    8000181e:	7179                	addi	sp,sp,-48
    80001820:	f406                	sd	ra,40(sp)
    80001822:	f022                	sd	s0,32(sp)
    80001824:	ec26                	sd	s1,24(sp)
    80001826:	e84a                	sd	s2,16(sp)
    80001828:	e44e                	sd	s3,8(sp)
    8000182a:	e052                	sd	s4,0(sp)
    8000182c:	1800                	addi	s0,sp,48
    8000182e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001830:	fffff097          	auipc	ra,0xfffff
    80001834:	648080e7          	jalr	1608(ra) # 80000e78 <myproc>
    80001838:	89aa                	mv	s3,a0
  if (p == initproc)
    8000183a:	00007797          	auipc	a5,0x7
    8000183e:	7d67b783          	ld	a5,2006(a5) # 80009010 <initproc>
    80001842:	0d050493          	addi	s1,a0,208
    80001846:	15050913          	addi	s2,a0,336
    8000184a:	02a79363          	bne	a5,a0,80001870 <exit+0x52>
    panic("init exiting");
    8000184e:	00007517          	auipc	a0,0x7
    80001852:	99250513          	addi	a0,a0,-1646 # 800081e0 <etext+0x1e0>
    80001856:	00004097          	auipc	ra,0x4
    8000185a:	456080e7          	jalr	1110(ra) # 80005cac <panic>
      fileclose(f);
    8000185e:	00002097          	auipc	ra,0x2
    80001862:	17a080e7          	jalr	378(ra) # 800039d8 <fileclose>
      p->ofile[fd] = 0;
    80001866:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++)
    8000186a:	04a1                	addi	s1,s1,8
    8000186c:	01248563          	beq	s1,s2,80001876 <exit+0x58>
    if (p->ofile[fd])
    80001870:	6088                	ld	a0,0(s1)
    80001872:	f575                	bnez	a0,8000185e <exit+0x40>
    80001874:	bfdd                	j	8000186a <exit+0x4c>
  begin_op();
    80001876:	00002097          	auipc	ra,0x2
    8000187a:	c98080e7          	jalr	-872(ra) # 8000350e <begin_op>
  iput(p->cwd);
    8000187e:	1509b503          	ld	a0,336(s3)
    80001882:	00001097          	auipc	ra,0x1
    80001886:	478080e7          	jalr	1144(ra) # 80002cfa <iput>
  end_op();
    8000188a:	00002097          	auipc	ra,0x2
    8000188e:	cfe080e7          	jalr	-770(ra) # 80003588 <end_op>
  p->cwd = 0;
    80001892:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001896:	00007497          	auipc	s1,0x7
    8000189a:	7d248493          	addi	s1,s1,2002 # 80009068 <wait_lock>
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	986080e7          	jalr	-1658(ra) # 80006226 <acquire>
  reparent(p);
    800018a8:	854e                	mv	a0,s3
    800018aa:	00000097          	auipc	ra,0x0
    800018ae:	f1a080e7          	jalr	-230(ra) # 800017c4 <reparent>
  wakeup(p->parent);
    800018b2:	0389b503          	ld	a0,56(s3)
    800018b6:	00000097          	auipc	ra,0x0
    800018ba:	e98080e7          	jalr	-360(ra) # 8000174e <wakeup>
  acquire(&p->lock);
    800018be:	854e                	mv	a0,s3
    800018c0:	00005097          	auipc	ra,0x5
    800018c4:	966080e7          	jalr	-1690(ra) # 80006226 <acquire>
  p->xstate = status;
    800018c8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800018cc:	4795                	li	a5,5
    800018ce:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800018d2:	8526                	mv	a0,s1
    800018d4:	00005097          	auipc	ra,0x5
    800018d8:	a06080e7          	jalr	-1530(ra) # 800062da <release>
  sched();
    800018dc:	00000097          	auipc	ra,0x0
    800018e0:	bd4080e7          	jalr	-1068(ra) # 800014b0 <sched>
  panic("zombie exit");
    800018e4:	00007517          	auipc	a0,0x7
    800018e8:	90c50513          	addi	a0,a0,-1780 # 800081f0 <etext+0x1f0>
    800018ec:	00004097          	auipc	ra,0x4
    800018f0:	3c0080e7          	jalr	960(ra) # 80005cac <panic>

00000000800018f4 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800018f4:	7179                	addi	sp,sp,-48
    800018f6:	f406                	sd	ra,40(sp)
    800018f8:	f022                	sd	s0,32(sp)
    800018fa:	ec26                	sd	s1,24(sp)
    800018fc:	e84a                	sd	s2,16(sp)
    800018fe:	e44e                	sd	s3,8(sp)
    80001900:	1800                	addi	s0,sp,48
    80001902:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
    80001904:	00008497          	auipc	s1,0x8
    80001908:	b7c48493          	addi	s1,s1,-1156 # 80009480 <proc>
    8000190c:	0000d997          	auipc	s3,0xd
    80001910:	77498993          	addi	s3,s3,1908 # 8000f080 <tickslock>
  {
    acquire(&p->lock);
    80001914:	8526                	mv	a0,s1
    80001916:	00005097          	auipc	ra,0x5
    8000191a:	910080e7          	jalr	-1776(ra) # 80006226 <acquire>
    if (p->pid == pid)
    8000191e:	589c                	lw	a5,48(s1)
    80001920:	01278d63          	beq	a5,s2,8000193a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001924:	8526                	mv	a0,s1
    80001926:	00005097          	auipc	ra,0x5
    8000192a:	9b4080e7          	jalr	-1612(ra) # 800062da <release>
  for (p = proc; p < &proc[NPROC]; p++)
    8000192e:	17048493          	addi	s1,s1,368
    80001932:	ff3491e3          	bne	s1,s3,80001914 <kill+0x20>
  }
  return -1;
    80001936:	557d                	li	a0,-1
    80001938:	a829                	j	80001952 <kill+0x5e>
      p->killed = 1;
    8000193a:	4785                	li	a5,1
    8000193c:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING)
    8000193e:	4c98                	lw	a4,24(s1)
    80001940:	4789                	li	a5,2
    80001942:	00f70f63          	beq	a4,a5,80001960 <kill+0x6c>
      release(&p->lock);
    80001946:	8526                	mv	a0,s1
    80001948:	00005097          	auipc	ra,0x5
    8000194c:	992080e7          	jalr	-1646(ra) # 800062da <release>
      return 0;
    80001950:	4501                	li	a0,0
}
    80001952:	70a2                	ld	ra,40(sp)
    80001954:	7402                	ld	s0,32(sp)
    80001956:	64e2                	ld	s1,24(sp)
    80001958:	6942                	ld	s2,16(sp)
    8000195a:	69a2                	ld	s3,8(sp)
    8000195c:	6145                	addi	sp,sp,48
    8000195e:	8082                	ret
        p->state = RUNNABLE;
    80001960:	478d                	li	a5,3
    80001962:	cc9c                	sw	a5,24(s1)
    80001964:	b7cd                	j	80001946 <kill+0x52>

0000000080001966 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001966:	7179                	addi	sp,sp,-48
    80001968:	f406                	sd	ra,40(sp)
    8000196a:	f022                	sd	s0,32(sp)
    8000196c:	ec26                	sd	s1,24(sp)
    8000196e:	e84a                	sd	s2,16(sp)
    80001970:	e44e                	sd	s3,8(sp)
    80001972:	e052                	sd	s4,0(sp)
    80001974:	1800                	addi	s0,sp,48
    80001976:	84aa                	mv	s1,a0
    80001978:	892e                	mv	s2,a1
    8000197a:	89b2                	mv	s3,a2
    8000197c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	4fa080e7          	jalr	1274(ra) # 80000e78 <myproc>
  if (user_dst)
    80001986:	c08d                	beqz	s1,800019a8 <either_copyout+0x42>
  {
    return copyout(p->pagetable, dst, src, len);
    80001988:	86d2                	mv	a3,s4
    8000198a:	864e                	mv	a2,s3
    8000198c:	85ca                	mv	a1,s2
    8000198e:	6928                	ld	a0,80(a0)
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	188080e7          	jalr	392(ra) # 80000b18 <copyout>
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001998:	70a2                	ld	ra,40(sp)
    8000199a:	7402                	ld	s0,32(sp)
    8000199c:	64e2                	ld	s1,24(sp)
    8000199e:	6942                	ld	s2,16(sp)
    800019a0:	69a2                	ld	s3,8(sp)
    800019a2:	6a02                	ld	s4,0(sp)
    800019a4:	6145                	addi	sp,sp,48
    800019a6:	8082                	ret
    memmove((char *)dst, src, len);
    800019a8:	000a061b          	sext.w	a2,s4
    800019ac:	85ce                	mv	a1,s3
    800019ae:	854a                	mv	a0,s2
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	826080e7          	jalr	-2010(ra) # 800001d6 <memmove>
    return 0;
    800019b8:	8526                	mv	a0,s1
    800019ba:	bff9                	j	80001998 <either_copyout+0x32>

00000000800019bc <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019bc:	7179                	addi	sp,sp,-48
    800019be:	f406                	sd	ra,40(sp)
    800019c0:	f022                	sd	s0,32(sp)
    800019c2:	ec26                	sd	s1,24(sp)
    800019c4:	e84a                	sd	s2,16(sp)
    800019c6:	e44e                	sd	s3,8(sp)
    800019c8:	e052                	sd	s4,0(sp)
    800019ca:	1800                	addi	s0,sp,48
    800019cc:	892a                	mv	s2,a0
    800019ce:	84ae                	mv	s1,a1
    800019d0:	89b2                	mv	s3,a2
    800019d2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	4a4080e7          	jalr	1188(ra) # 80000e78 <myproc>
  if (user_src)
    800019dc:	c08d                	beqz	s1,800019fe <either_copyin+0x42>
  {
    return copyin(p->pagetable, dst, src, len);
    800019de:	86d2                	mv	a3,s4
    800019e0:	864e                	mv	a2,s3
    800019e2:	85ca                	mv	a1,s2
    800019e4:	6928                	ld	a0,80(a0)
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	1be080e7          	jalr	446(ra) # 80000ba4 <copyin>
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800019ee:	70a2                	ld	ra,40(sp)
    800019f0:	7402                	ld	s0,32(sp)
    800019f2:	64e2                	ld	s1,24(sp)
    800019f4:	6942                	ld	s2,16(sp)
    800019f6:	69a2                	ld	s3,8(sp)
    800019f8:	6a02                	ld	s4,0(sp)
    800019fa:	6145                	addi	sp,sp,48
    800019fc:	8082                	ret
    memmove(dst, (char *)src, len);
    800019fe:	000a061b          	sext.w	a2,s4
    80001a02:	85ce                	mv	a1,s3
    80001a04:	854a                	mv	a0,s2
    80001a06:	ffffe097          	auipc	ra,0xffffe
    80001a0a:	7d0080e7          	jalr	2000(ra) # 800001d6 <memmove>
    return 0;
    80001a0e:	8526                	mv	a0,s1
    80001a10:	bff9                	j	800019ee <either_copyin+0x32>

0000000080001a12 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80001a12:	715d                	addi	sp,sp,-80
    80001a14:	e486                	sd	ra,72(sp)
    80001a16:	e0a2                	sd	s0,64(sp)
    80001a18:	fc26                	sd	s1,56(sp)
    80001a1a:	f84a                	sd	s2,48(sp)
    80001a1c:	f44e                	sd	s3,40(sp)
    80001a1e:	f052                	sd	s4,32(sp)
    80001a20:	ec56                	sd	s5,24(sp)
    80001a22:	e85a                	sd	s6,16(sp)
    80001a24:	e45e                	sd	s7,8(sp)
    80001a26:	0880                	addi	s0,sp,80
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    80001a28:	00006517          	auipc	a0,0x6
    80001a2c:	5f050513          	addi	a0,a0,1520 # 80008018 <etext+0x18>
    80001a30:	00004097          	auipc	ra,0x4
    80001a34:	2c6080e7          	jalr	710(ra) # 80005cf6 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a38:	00008497          	auipc	s1,0x8
    80001a3c:	ba048493          	addi	s1,s1,-1120 # 800095d8 <proc+0x158>
    80001a40:	0000d917          	auipc	s2,0xd
    80001a44:	79890913          	addi	s2,s2,1944 # 8000f1d8 <bcache+0x140>
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a48:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a4a:	00006997          	auipc	s3,0x6
    80001a4e:	7b698993          	addi	s3,s3,1974 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a52:	00006a97          	auipc	s5,0x6
    80001a56:	7b6a8a93          	addi	s5,s5,1974 # 80008208 <etext+0x208>
    printf("\n");
    80001a5a:	00006a17          	auipc	s4,0x6
    80001a5e:	5bea0a13          	addi	s4,s4,1470 # 80008018 <etext+0x18>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a62:	00007b97          	auipc	s7,0x7
    80001a66:	c9eb8b93          	addi	s7,s7,-866 # 80008700 <states.0>
    80001a6a:	a00d                	j	80001a8c <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a6c:	ed86a583          	lw	a1,-296(a3)
    80001a70:	8556                	mv	a0,s5
    80001a72:	00004097          	auipc	ra,0x4
    80001a76:	284080e7          	jalr	644(ra) # 80005cf6 <printf>
    printf("\n");
    80001a7a:	8552                	mv	a0,s4
    80001a7c:	00004097          	auipc	ra,0x4
    80001a80:	27a080e7          	jalr	634(ra) # 80005cf6 <printf>
  for (p = proc; p < &proc[NPROC]; p++)
    80001a84:	17048493          	addi	s1,s1,368
    80001a88:	03248263          	beq	s1,s2,80001aac <procdump+0x9a>
    if (p->state == UNUSED)
    80001a8c:	86a6                	mv	a3,s1
    80001a8e:	ec04a783          	lw	a5,-320(s1)
    80001a92:	dbed                	beqz	a5,80001a84 <procdump+0x72>
      state = "???";
    80001a94:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a96:	fcfb6be3          	bltu	s6,a5,80001a6c <procdump+0x5a>
    80001a9a:	02079713          	slli	a4,a5,0x20
    80001a9e:	01d75793          	srli	a5,a4,0x1d
    80001aa2:	97de                	add	a5,a5,s7
    80001aa4:	6390                	ld	a2,0(a5)
    80001aa6:	f279                	bnez	a2,80001a6c <procdump+0x5a>
      state = "???";
    80001aa8:	864e                	mv	a2,s3
    80001aaa:	b7c9                	j	80001a6c <procdump+0x5a>
  }
}
    80001aac:	60a6                	ld	ra,72(sp)
    80001aae:	6406                	ld	s0,64(sp)
    80001ab0:	74e2                	ld	s1,56(sp)
    80001ab2:	7942                	ld	s2,48(sp)
    80001ab4:	79a2                	ld	s3,40(sp)
    80001ab6:	7a02                	ld	s4,32(sp)
    80001ab8:	6ae2                	ld	s5,24(sp)
    80001aba:	6b42                	ld	s6,16(sp)
    80001abc:	6ba2                	ld	s7,8(sp)
    80001abe:	6161                	addi	sp,sp,80
    80001ac0:	8082                	ret

0000000080001ac2 <swtch>:
    80001ac2:	00153023          	sd	ra,0(a0)
    80001ac6:	00253423          	sd	sp,8(a0)
    80001aca:	e900                	sd	s0,16(a0)
    80001acc:	ed04                	sd	s1,24(a0)
    80001ace:	03253023          	sd	s2,32(a0)
    80001ad2:	03353423          	sd	s3,40(a0)
    80001ad6:	03453823          	sd	s4,48(a0)
    80001ada:	03553c23          	sd	s5,56(a0)
    80001ade:	05653023          	sd	s6,64(a0)
    80001ae2:	05753423          	sd	s7,72(a0)
    80001ae6:	05853823          	sd	s8,80(a0)
    80001aea:	05953c23          	sd	s9,88(a0)
    80001aee:	07a53023          	sd	s10,96(a0)
    80001af2:	07b53423          	sd	s11,104(a0)
    80001af6:	0005b083          	ld	ra,0(a1)
    80001afa:	0085b103          	ld	sp,8(a1)
    80001afe:	6980                	ld	s0,16(a1)
    80001b00:	6d84                	ld	s1,24(a1)
    80001b02:	0205b903          	ld	s2,32(a1)
    80001b06:	0285b983          	ld	s3,40(a1)
    80001b0a:	0305ba03          	ld	s4,48(a1)
    80001b0e:	0385ba83          	ld	s5,56(a1)
    80001b12:	0405bb03          	ld	s6,64(a1)
    80001b16:	0485bb83          	ld	s7,72(a1)
    80001b1a:	0505bc03          	ld	s8,80(a1)
    80001b1e:	0585bc83          	ld	s9,88(a1)
    80001b22:	0605bd03          	ld	s10,96(a1)
    80001b26:	0685bd83          	ld	s11,104(a1)
    80001b2a:	8082                	ret

0000000080001b2c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b2c:	1141                	addi	sp,sp,-16
    80001b2e:	e406                	sd	ra,8(sp)
    80001b30:	e022                	sd	s0,0(sp)
    80001b32:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b34:	00006597          	auipc	a1,0x6
    80001b38:	70c58593          	addi	a1,a1,1804 # 80008240 <etext+0x240>
    80001b3c:	0000d517          	auipc	a0,0xd
    80001b40:	54450513          	addi	a0,a0,1348 # 8000f080 <tickslock>
    80001b44:	00004097          	auipc	ra,0x4
    80001b48:	652080e7          	jalr	1618(ra) # 80006196 <initlock>
}
    80001b4c:	60a2                	ld	ra,8(sp)
    80001b4e:	6402                	ld	s0,0(sp)
    80001b50:	0141                	addi	sp,sp,16
    80001b52:	8082                	ret

0000000080001b54 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b54:	1141                	addi	sp,sp,-16
    80001b56:	e422                	sd	s0,8(sp)
    80001b58:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b5a:	00003797          	auipc	a5,0x3
    80001b5e:	56678793          	addi	a5,a5,1382 # 800050c0 <kernelvec>
    80001b62:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b66:	6422                	ld	s0,8(sp)
    80001b68:	0141                	addi	sp,sp,16
    80001b6a:	8082                	ret

0000000080001b6c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b6c:	1141                	addi	sp,sp,-16
    80001b6e:	e406                	sd	ra,8(sp)
    80001b70:	e022                	sd	s0,0(sp)
    80001b72:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b74:	fffff097          	auipc	ra,0xfffff
    80001b78:	304080e7          	jalr	772(ra) # 80000e78 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b7c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b80:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b82:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b86:	00005697          	auipc	a3,0x5
    80001b8a:	47a68693          	addi	a3,a3,1146 # 80007000 <_trampoline>
    80001b8e:	00005717          	auipc	a4,0x5
    80001b92:	47270713          	addi	a4,a4,1138 # 80007000 <_trampoline>
    80001b96:	8f15                	sub	a4,a4,a3
    80001b98:	040007b7          	lui	a5,0x4000
    80001b9c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b9e:	07b2                	slli	a5,a5,0xc
    80001ba0:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ba2:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ba6:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ba8:	18002673          	csrr	a2,satp
    80001bac:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bae:	6d30                	ld	a2,88(a0)
    80001bb0:	6138                	ld	a4,64(a0)
    80001bb2:	6585                	lui	a1,0x1
    80001bb4:	972e                	add	a4,a4,a1
    80001bb6:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bb8:	6d38                	ld	a4,88(a0)
    80001bba:	00000617          	auipc	a2,0x0
    80001bbe:	14060613          	addi	a2,a2,320 # 80001cfa <usertrap>
    80001bc2:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bc4:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bc6:	8612                	mv	a2,tp
    80001bc8:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bca:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bce:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bd2:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bd6:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bda:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bdc:	6f18                	ld	a4,24(a4)
    80001bde:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001be2:	692c                	ld	a1,80(a0)
    80001be4:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001be6:	00005717          	auipc	a4,0x5
    80001bea:	4aa70713          	addi	a4,a4,1194 # 80007090 <userret>
    80001bee:	8f15                	sub	a4,a4,a3
    80001bf0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001bf2:	577d                	li	a4,-1
    80001bf4:	177e                	slli	a4,a4,0x3f
    80001bf6:	8dd9                	or	a1,a1,a4
    80001bf8:	02000537          	lui	a0,0x2000
    80001bfc:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bfe:	0536                	slli	a0,a0,0xd
    80001c00:	9782                	jalr	a5
}
    80001c02:	60a2                	ld	ra,8(sp)
    80001c04:	6402                	ld	s0,0(sp)
    80001c06:	0141                	addi	sp,sp,16
    80001c08:	8082                	ret

0000000080001c0a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c0a:	1101                	addi	sp,sp,-32
    80001c0c:	ec06                	sd	ra,24(sp)
    80001c0e:	e822                	sd	s0,16(sp)
    80001c10:	e426                	sd	s1,8(sp)
    80001c12:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c14:	0000d497          	auipc	s1,0xd
    80001c18:	46c48493          	addi	s1,s1,1132 # 8000f080 <tickslock>
    80001c1c:	8526                	mv	a0,s1
    80001c1e:	00004097          	auipc	ra,0x4
    80001c22:	608080e7          	jalr	1544(ra) # 80006226 <acquire>
  ticks++;
    80001c26:	00007517          	auipc	a0,0x7
    80001c2a:	3f250513          	addi	a0,a0,1010 # 80009018 <ticks>
    80001c2e:	411c                	lw	a5,0(a0)
    80001c30:	2785                	addiw	a5,a5,1
    80001c32:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c34:	00000097          	auipc	ra,0x0
    80001c38:	b1a080e7          	jalr	-1254(ra) # 8000174e <wakeup>
  release(&tickslock);
    80001c3c:	8526                	mv	a0,s1
    80001c3e:	00004097          	auipc	ra,0x4
    80001c42:	69c080e7          	jalr	1692(ra) # 800062da <release>
}
    80001c46:	60e2                	ld	ra,24(sp)
    80001c48:	6442                	ld	s0,16(sp)
    80001c4a:	64a2                	ld	s1,8(sp)
    80001c4c:	6105                	addi	sp,sp,32
    80001c4e:	8082                	ret

0000000080001c50 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c50:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c54:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c56:	0a07d163          	bgez	a5,80001cf8 <devintr+0xa8>
{
    80001c5a:	1101                	addi	sp,sp,-32
    80001c5c:	ec06                	sd	ra,24(sp)
    80001c5e:	e822                	sd	s0,16(sp)
    80001c60:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c62:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c66:	46a5                	li	a3,9
    80001c68:	00d70c63          	beq	a4,a3,80001c80 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c6c:	577d                	li	a4,-1
    80001c6e:	177e                	slli	a4,a4,0x3f
    80001c70:	0705                	addi	a4,a4,1
    return 0;
    80001c72:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c74:	06e78163          	beq	a5,a4,80001cd6 <devintr+0x86>
  }
}
    80001c78:	60e2                	ld	ra,24(sp)
    80001c7a:	6442                	ld	s0,16(sp)
    80001c7c:	6105                	addi	sp,sp,32
    80001c7e:	8082                	ret
    80001c80:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c82:	00003097          	auipc	ra,0x3
    80001c86:	54a080e7          	jalr	1354(ra) # 800051cc <plic_claim>
    80001c8a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c8c:	47a9                	li	a5,10
    80001c8e:	00f50963          	beq	a0,a5,80001ca0 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c92:	4785                	li	a5,1
    80001c94:	00f50b63          	beq	a0,a5,80001caa <devintr+0x5a>
    return 1;
    80001c98:	4505                	li	a0,1
    } else if(irq){
    80001c9a:	ec89                	bnez	s1,80001cb4 <devintr+0x64>
    80001c9c:	64a2                	ld	s1,8(sp)
    80001c9e:	bfe9                	j	80001c78 <devintr+0x28>
      uartintr();
    80001ca0:	00004097          	auipc	ra,0x4
    80001ca4:	4a6080e7          	jalr	1190(ra) # 80006146 <uartintr>
    if(irq)
    80001ca8:	a839                	j	80001cc6 <devintr+0x76>
      virtio_disk_intr();
    80001caa:	00004097          	auipc	ra,0x4
    80001cae:	9f6080e7          	jalr	-1546(ra) # 800056a0 <virtio_disk_intr>
    if(irq)
    80001cb2:	a811                	j	80001cc6 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb4:	85a6                	mv	a1,s1
    80001cb6:	00006517          	auipc	a0,0x6
    80001cba:	59250513          	addi	a0,a0,1426 # 80008248 <etext+0x248>
    80001cbe:	00004097          	auipc	ra,0x4
    80001cc2:	038080e7          	jalr	56(ra) # 80005cf6 <printf>
      plic_complete(irq);
    80001cc6:	8526                	mv	a0,s1
    80001cc8:	00003097          	auipc	ra,0x3
    80001ccc:	528080e7          	jalr	1320(ra) # 800051f0 <plic_complete>
    return 1;
    80001cd0:	4505                	li	a0,1
    80001cd2:	64a2                	ld	s1,8(sp)
    80001cd4:	b755                	j	80001c78 <devintr+0x28>
    if(cpuid() == 0){
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	176080e7          	jalr	374(ra) # 80000e4c <cpuid>
    80001cde:	c901                	beqz	a0,80001cee <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ce0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ce4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ce6:	14479073          	csrw	sip,a5
    return 2;
    80001cea:	4509                	li	a0,2
    80001cec:	b771                	j	80001c78 <devintr+0x28>
      clockintr();
    80001cee:	00000097          	auipc	ra,0x0
    80001cf2:	f1c080e7          	jalr	-228(ra) # 80001c0a <clockintr>
    80001cf6:	b7ed                	j	80001ce0 <devintr+0x90>
}
    80001cf8:	8082                	ret

0000000080001cfa <usertrap>:
{
    80001cfa:	1101                	addi	sp,sp,-32
    80001cfc:	ec06                	sd	ra,24(sp)
    80001cfe:	e822                	sd	s0,16(sp)
    80001d00:	e426                	sd	s1,8(sp)
    80001d02:	e04a                	sd	s2,0(sp)
    80001d04:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d06:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d0a:	1007f793          	andi	a5,a5,256
    80001d0e:	e3ad                	bnez	a5,80001d70 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d10:	00003797          	auipc	a5,0x3
    80001d14:	3b078793          	addi	a5,a5,944 # 800050c0 <kernelvec>
    80001d18:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d1c:	fffff097          	auipc	ra,0xfffff
    80001d20:	15c080e7          	jalr	348(ra) # 80000e78 <myproc>
    80001d24:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d26:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d28:	14102773          	csrr	a4,sepc
    80001d2c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d2e:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d32:	47a1                	li	a5,8
    80001d34:	04f71c63          	bne	a4,a5,80001d8c <usertrap+0x92>
    if(p->killed)
    80001d38:	551c                	lw	a5,40(a0)
    80001d3a:	e3b9                	bnez	a5,80001d80 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001d3c:	6cb8                	ld	a4,88(s1)
    80001d3e:	6f1c                	ld	a5,24(a4)
    80001d40:	0791                	addi	a5,a5,4
    80001d42:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d44:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d48:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d4c:	10079073          	csrw	sstatus,a5
    syscall();
    80001d50:	00000097          	auipc	ra,0x0
    80001d54:	2e0080e7          	jalr	736(ra) # 80002030 <syscall>
  if(p->killed)
    80001d58:	549c                	lw	a5,40(s1)
    80001d5a:	ebc1                	bnez	a5,80001dea <usertrap+0xf0>
  usertrapret();
    80001d5c:	00000097          	auipc	ra,0x0
    80001d60:	e10080e7          	jalr	-496(ra) # 80001b6c <usertrapret>
}
    80001d64:	60e2                	ld	ra,24(sp)
    80001d66:	6442                	ld	s0,16(sp)
    80001d68:	64a2                	ld	s1,8(sp)
    80001d6a:	6902                	ld	s2,0(sp)
    80001d6c:	6105                	addi	sp,sp,32
    80001d6e:	8082                	ret
    panic("usertrap: not from user mode");
    80001d70:	00006517          	auipc	a0,0x6
    80001d74:	4f850513          	addi	a0,a0,1272 # 80008268 <etext+0x268>
    80001d78:	00004097          	auipc	ra,0x4
    80001d7c:	f34080e7          	jalr	-204(ra) # 80005cac <panic>
      exit(-1);
    80001d80:	557d                	li	a0,-1
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	a9c080e7          	jalr	-1380(ra) # 8000181e <exit>
    80001d8a:	bf4d                	j	80001d3c <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	ec4080e7          	jalr	-316(ra) # 80001c50 <devintr>
    80001d94:	892a                	mv	s2,a0
    80001d96:	c501                	beqz	a0,80001d9e <usertrap+0xa4>
  if(p->killed)
    80001d98:	549c                	lw	a5,40(s1)
    80001d9a:	c3a1                	beqz	a5,80001dda <usertrap+0xe0>
    80001d9c:	a815                	j	80001dd0 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d9e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001da2:	5890                	lw	a2,48(s1)
    80001da4:	00006517          	auipc	a0,0x6
    80001da8:	4e450513          	addi	a0,a0,1252 # 80008288 <etext+0x288>
    80001dac:	00004097          	auipc	ra,0x4
    80001db0:	f4a080e7          	jalr	-182(ra) # 80005cf6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001db4:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db8:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dbc:	00006517          	auipc	a0,0x6
    80001dc0:	4fc50513          	addi	a0,a0,1276 # 800082b8 <etext+0x2b8>
    80001dc4:	00004097          	auipc	ra,0x4
    80001dc8:	f32080e7          	jalr	-206(ra) # 80005cf6 <printf>
    p->killed = 1;
    80001dcc:	4785                	li	a5,1
    80001dce:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001dd0:	557d                	li	a0,-1
    80001dd2:	00000097          	auipc	ra,0x0
    80001dd6:	a4c080e7          	jalr	-1460(ra) # 8000181e <exit>
  if(which_dev == 2)
    80001dda:	4789                	li	a5,2
    80001ddc:	f8f910e3          	bne	s2,a5,80001d5c <usertrap+0x62>
    yield();
    80001de0:	fffff097          	auipc	ra,0xfffff
    80001de4:	7a6080e7          	jalr	1958(ra) # 80001586 <yield>
    80001de8:	bf95                	j	80001d5c <usertrap+0x62>
  int which_dev = 0;
    80001dea:	4901                	li	s2,0
    80001dec:	b7d5                	j	80001dd0 <usertrap+0xd6>

0000000080001dee <kerneltrap>:
{
    80001dee:	7179                	addi	sp,sp,-48
    80001df0:	f406                	sd	ra,40(sp)
    80001df2:	f022                	sd	s0,32(sp)
    80001df4:	ec26                	sd	s1,24(sp)
    80001df6:	e84a                	sd	s2,16(sp)
    80001df8:	e44e                	sd	s3,8(sp)
    80001dfa:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dfc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e00:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e04:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e08:	1004f793          	andi	a5,s1,256
    80001e0c:	cb85                	beqz	a5,80001e3c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e0e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e12:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e14:	ef85                	bnez	a5,80001e4c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e16:	00000097          	auipc	ra,0x0
    80001e1a:	e3a080e7          	jalr	-454(ra) # 80001c50 <devintr>
    80001e1e:	cd1d                	beqz	a0,80001e5c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e20:	4789                	li	a5,2
    80001e22:	06f50a63          	beq	a0,a5,80001e96 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e26:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2a:	10049073          	csrw	sstatus,s1
}
    80001e2e:	70a2                	ld	ra,40(sp)
    80001e30:	7402                	ld	s0,32(sp)
    80001e32:	64e2                	ld	s1,24(sp)
    80001e34:	6942                	ld	s2,16(sp)
    80001e36:	69a2                	ld	s3,8(sp)
    80001e38:	6145                	addi	sp,sp,48
    80001e3a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e3c:	00006517          	auipc	a0,0x6
    80001e40:	49c50513          	addi	a0,a0,1180 # 800082d8 <etext+0x2d8>
    80001e44:	00004097          	auipc	ra,0x4
    80001e48:	e68080e7          	jalr	-408(ra) # 80005cac <panic>
    panic("kerneltrap: interrupts enabled");
    80001e4c:	00006517          	auipc	a0,0x6
    80001e50:	4b450513          	addi	a0,a0,1204 # 80008300 <etext+0x300>
    80001e54:	00004097          	auipc	ra,0x4
    80001e58:	e58080e7          	jalr	-424(ra) # 80005cac <panic>
    printf("scause %p\n", scause);
    80001e5c:	85ce                	mv	a1,s3
    80001e5e:	00006517          	auipc	a0,0x6
    80001e62:	4c250513          	addi	a0,a0,1218 # 80008320 <etext+0x320>
    80001e66:	00004097          	auipc	ra,0x4
    80001e6a:	e90080e7          	jalr	-368(ra) # 80005cf6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e6e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e72:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e76:	00006517          	auipc	a0,0x6
    80001e7a:	4ba50513          	addi	a0,a0,1210 # 80008330 <etext+0x330>
    80001e7e:	00004097          	auipc	ra,0x4
    80001e82:	e78080e7          	jalr	-392(ra) # 80005cf6 <printf>
    panic("kerneltrap");
    80001e86:	00006517          	auipc	a0,0x6
    80001e8a:	4c250513          	addi	a0,a0,1218 # 80008348 <etext+0x348>
    80001e8e:	00004097          	auipc	ra,0x4
    80001e92:	e1e080e7          	jalr	-482(ra) # 80005cac <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	fe2080e7          	jalr	-30(ra) # 80000e78 <myproc>
    80001e9e:	d541                	beqz	a0,80001e26 <kerneltrap+0x38>
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	fd8080e7          	jalr	-40(ra) # 80000e78 <myproc>
    80001ea8:	4d18                	lw	a4,24(a0)
    80001eaa:	4791                	li	a5,4
    80001eac:	f6f71de3          	bne	a4,a5,80001e26 <kerneltrap+0x38>
    yield();
    80001eb0:	fffff097          	auipc	ra,0xfffff
    80001eb4:	6d6080e7          	jalr	1750(ra) # 80001586 <yield>
    80001eb8:	b7bd                	j	80001e26 <kerneltrap+0x38>

0000000080001eba <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eba:	1101                	addi	sp,sp,-32
    80001ebc:	ec06                	sd	ra,24(sp)
    80001ebe:	e822                	sd	s0,16(sp)
    80001ec0:	e426                	sd	s1,8(sp)
    80001ec2:	1000                	addi	s0,sp,32
    80001ec4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	fb2080e7          	jalr	-78(ra) # 80000e78 <myproc>
  switch (n) {
    80001ece:	4795                	li	a5,5
    80001ed0:	0497e163          	bltu	a5,s1,80001f12 <argraw+0x58>
    80001ed4:	048a                	slli	s1,s1,0x2
    80001ed6:	00007717          	auipc	a4,0x7
    80001eda:	85a70713          	addi	a4,a4,-1958 # 80008730 <states.0+0x30>
    80001ede:	94ba                	add	s1,s1,a4
    80001ee0:	409c                	lw	a5,0(s1)
    80001ee2:	97ba                	add	a5,a5,a4
    80001ee4:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ee6:	6d3c                	ld	a5,88(a0)
    80001ee8:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eea:	60e2                	ld	ra,24(sp)
    80001eec:	6442                	ld	s0,16(sp)
    80001eee:	64a2                	ld	s1,8(sp)
    80001ef0:	6105                	addi	sp,sp,32
    80001ef2:	8082                	ret
    return p->trapframe->a1;
    80001ef4:	6d3c                	ld	a5,88(a0)
    80001ef6:	7fa8                	ld	a0,120(a5)
    80001ef8:	bfcd                	j	80001eea <argraw+0x30>
    return p->trapframe->a2;
    80001efa:	6d3c                	ld	a5,88(a0)
    80001efc:	63c8                	ld	a0,128(a5)
    80001efe:	b7f5                	j	80001eea <argraw+0x30>
    return p->trapframe->a3;
    80001f00:	6d3c                	ld	a5,88(a0)
    80001f02:	67c8                	ld	a0,136(a5)
    80001f04:	b7dd                	j	80001eea <argraw+0x30>
    return p->trapframe->a4;
    80001f06:	6d3c                	ld	a5,88(a0)
    80001f08:	6bc8                	ld	a0,144(a5)
    80001f0a:	b7c5                	j	80001eea <argraw+0x30>
    return p->trapframe->a5;
    80001f0c:	6d3c                	ld	a5,88(a0)
    80001f0e:	6fc8                	ld	a0,152(a5)
    80001f10:	bfe9                	j	80001eea <argraw+0x30>
  panic("argraw");
    80001f12:	00006517          	auipc	a0,0x6
    80001f16:	44650513          	addi	a0,a0,1094 # 80008358 <etext+0x358>
    80001f1a:	00004097          	auipc	ra,0x4
    80001f1e:	d92080e7          	jalr	-622(ra) # 80005cac <panic>

0000000080001f22 <fetchaddr>:
{
    80001f22:	1101                	addi	sp,sp,-32
    80001f24:	ec06                	sd	ra,24(sp)
    80001f26:	e822                	sd	s0,16(sp)
    80001f28:	e426                	sd	s1,8(sp)
    80001f2a:	e04a                	sd	s2,0(sp)
    80001f2c:	1000                	addi	s0,sp,32
    80001f2e:	84aa                	mv	s1,a0
    80001f30:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	f46080e7          	jalr	-186(ra) # 80000e78 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f3a:	653c                	ld	a5,72(a0)
    80001f3c:	02f4f863          	bgeu	s1,a5,80001f6c <fetchaddr+0x4a>
    80001f40:	00848713          	addi	a4,s1,8
    80001f44:	02e7e663          	bltu	a5,a4,80001f70 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f48:	46a1                	li	a3,8
    80001f4a:	8626                	mv	a2,s1
    80001f4c:	85ca                	mv	a1,s2
    80001f4e:	6928                	ld	a0,80(a0)
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	c54080e7          	jalr	-940(ra) # 80000ba4 <copyin>
    80001f58:	00a03533          	snez	a0,a0
    80001f5c:	40a00533          	neg	a0,a0
}
    80001f60:	60e2                	ld	ra,24(sp)
    80001f62:	6442                	ld	s0,16(sp)
    80001f64:	64a2                	ld	s1,8(sp)
    80001f66:	6902                	ld	s2,0(sp)
    80001f68:	6105                	addi	sp,sp,32
    80001f6a:	8082                	ret
    return -1;
    80001f6c:	557d                	li	a0,-1
    80001f6e:	bfcd                	j	80001f60 <fetchaddr+0x3e>
    80001f70:	557d                	li	a0,-1
    80001f72:	b7fd                	j	80001f60 <fetchaddr+0x3e>

0000000080001f74 <fetchstr>:
{
    80001f74:	7179                	addi	sp,sp,-48
    80001f76:	f406                	sd	ra,40(sp)
    80001f78:	f022                	sd	s0,32(sp)
    80001f7a:	ec26                	sd	s1,24(sp)
    80001f7c:	e84a                	sd	s2,16(sp)
    80001f7e:	e44e                	sd	s3,8(sp)
    80001f80:	1800                	addi	s0,sp,48
    80001f82:	892a                	mv	s2,a0
    80001f84:	84ae                	mv	s1,a1
    80001f86:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f88:	fffff097          	auipc	ra,0xfffff
    80001f8c:	ef0080e7          	jalr	-272(ra) # 80000e78 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f90:	86ce                	mv	a3,s3
    80001f92:	864a                	mv	a2,s2
    80001f94:	85a6                	mv	a1,s1
    80001f96:	6928                	ld	a0,80(a0)
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	c9a080e7          	jalr	-870(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80001fa0:	00054763          	bltz	a0,80001fae <fetchstr+0x3a>
  return strlen(buf);
    80001fa4:	8526                	mv	a0,s1
    80001fa6:	ffffe097          	auipc	ra,0xffffe
    80001faa:	348080e7          	jalr	840(ra) # 800002ee <strlen>
}
    80001fae:	70a2                	ld	ra,40(sp)
    80001fb0:	7402                	ld	s0,32(sp)
    80001fb2:	64e2                	ld	s1,24(sp)
    80001fb4:	6942                	ld	s2,16(sp)
    80001fb6:	69a2                	ld	s3,8(sp)
    80001fb8:	6145                	addi	sp,sp,48
    80001fba:	8082                	ret

0000000080001fbc <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fbc:	1101                	addi	sp,sp,-32
    80001fbe:	ec06                	sd	ra,24(sp)
    80001fc0:	e822                	sd	s0,16(sp)
    80001fc2:	e426                	sd	s1,8(sp)
    80001fc4:	1000                	addi	s0,sp,32
    80001fc6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fc8:	00000097          	auipc	ra,0x0
    80001fcc:	ef2080e7          	jalr	-270(ra) # 80001eba <argraw>
    80001fd0:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fd2:	4501                	li	a0,0
    80001fd4:	60e2                	ld	ra,24(sp)
    80001fd6:	6442                	ld	s0,16(sp)
    80001fd8:	64a2                	ld	s1,8(sp)
    80001fda:	6105                	addi	sp,sp,32
    80001fdc:	8082                	ret

0000000080001fde <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	1000                	addi	s0,sp,32
    80001fe8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fea:	00000097          	auipc	ra,0x0
    80001fee:	ed0080e7          	jalr	-304(ra) # 80001eba <argraw>
    80001ff2:	e088                	sd	a0,0(s1)
  return 0;
}
    80001ff4:	4501                	li	a0,0
    80001ff6:	60e2                	ld	ra,24(sp)
    80001ff8:	6442                	ld	s0,16(sp)
    80001ffa:	64a2                	ld	s1,8(sp)
    80001ffc:	6105                	addi	sp,sp,32
    80001ffe:	8082                	ret

0000000080002000 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002000:	1101                	addi	sp,sp,-32
    80002002:	ec06                	sd	ra,24(sp)
    80002004:	e822                	sd	s0,16(sp)
    80002006:	e426                	sd	s1,8(sp)
    80002008:	e04a                	sd	s2,0(sp)
    8000200a:	1000                	addi	s0,sp,32
    8000200c:	84ae                	mv	s1,a1
    8000200e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002010:	00000097          	auipc	ra,0x0
    80002014:	eaa080e7          	jalr	-342(ra) # 80001eba <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002018:	864a                	mv	a2,s2
    8000201a:	85a6                	mv	a1,s1
    8000201c:	00000097          	auipc	ra,0x0
    80002020:	f58080e7          	jalr	-168(ra) # 80001f74 <fetchstr>
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	64a2                	ld	s1,8(sp)
    8000202a:	6902                	ld	s2,0(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret

0000000080002030 <syscall>:



void
syscall(void)
{
    80002030:	1101                	addi	sp,sp,-32
    80002032:	ec06                	sd	ra,24(sp)
    80002034:	e822                	sd	s0,16(sp)
    80002036:	e426                	sd	s1,8(sp)
    80002038:	e04a                	sd	s2,0(sp)
    8000203a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000203c:	fffff097          	auipc	ra,0xfffff
    80002040:	e3c080e7          	jalr	-452(ra) # 80000e78 <myproc>
    80002044:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002046:	05853903          	ld	s2,88(a0)
    8000204a:	0a893783          	ld	a5,168(s2)
    8000204e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002052:	37fd                	addiw	a5,a5,-1
    80002054:	4775                	li	a4,29
    80002056:	00f76f63          	bltu	a4,a5,80002074 <syscall+0x44>
    8000205a:	00369713          	slli	a4,a3,0x3
    8000205e:	00006797          	auipc	a5,0x6
    80002062:	6ea78793          	addi	a5,a5,1770 # 80008748 <syscalls>
    80002066:	97ba                	add	a5,a5,a4
    80002068:	639c                	ld	a5,0(a5)
    8000206a:	c789                	beqz	a5,80002074 <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    8000206c:	9782                	jalr	a5
    8000206e:	06a93823          	sd	a0,112(s2)
    80002072:	a839                	j	80002090 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002074:	15848613          	addi	a2,s1,344
    80002078:	588c                	lw	a1,48(s1)
    8000207a:	00006517          	auipc	a0,0x6
    8000207e:	2e650513          	addi	a0,a0,742 # 80008360 <etext+0x360>
    80002082:	00004097          	auipc	ra,0x4
    80002086:	c74080e7          	jalr	-908(ra) # 80005cf6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000208a:	6cbc                	ld	a5,88(s1)
    8000208c:	577d                	li	a4,-1
    8000208e:	fbb8                	sd	a4,112(a5)
  }
}
    80002090:	60e2                	ld	ra,24(sp)
    80002092:	6442                	ld	s0,16(sp)
    80002094:	64a2                	ld	s1,8(sp)
    80002096:	6902                	ld	s2,0(sp)
    80002098:	6105                	addi	sp,sp,32
    8000209a:	8082                	ret

000000008000209c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000209c:	1101                	addi	sp,sp,-32
    8000209e:	ec06                	sd	ra,24(sp)
    800020a0:	e822                	sd	s0,16(sp)
    800020a2:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800020a4:	fec40593          	addi	a1,s0,-20
    800020a8:	4501                	li	a0,0
    800020aa:	00000097          	auipc	ra,0x0
    800020ae:	f12080e7          	jalr	-238(ra) # 80001fbc <argint>
    return -1;
    800020b2:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020b4:	00054963          	bltz	a0,800020c6 <sys_exit+0x2a>
  exit(n);
    800020b8:	fec42503          	lw	a0,-20(s0)
    800020bc:	fffff097          	auipc	ra,0xfffff
    800020c0:	762080e7          	jalr	1890(ra) # 8000181e <exit>
  return 0;  // not reached
    800020c4:	4781                	li	a5,0
}
    800020c6:	853e                	mv	a0,a5
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret

00000000800020d0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020d0:	1141                	addi	sp,sp,-16
    800020d2:	e406                	sd	ra,8(sp)
    800020d4:	e022                	sd	s0,0(sp)
    800020d6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	da0080e7          	jalr	-608(ra) # 80000e78 <myproc>
}
    800020e0:	5908                	lw	a0,48(a0)
    800020e2:	60a2                	ld	ra,8(sp)
    800020e4:	6402                	ld	s0,0(sp)
    800020e6:	0141                	addi	sp,sp,16
    800020e8:	8082                	ret

00000000800020ea <sys_fork>:

uint64
sys_fork(void)
{
    800020ea:	1141                	addi	sp,sp,-16
    800020ec:	e406                	sd	ra,8(sp)
    800020ee:	e022                	sd	s0,0(sp)
    800020f0:	0800                	addi	s0,sp,16
  return fork();
    800020f2:	fffff097          	auipc	ra,0xfffff
    800020f6:	1dc080e7          	jalr	476(ra) # 800012ce <fork>
}
    800020fa:	60a2                	ld	ra,8(sp)
    800020fc:	6402                	ld	s0,0(sp)
    800020fe:	0141                	addi	sp,sp,16
    80002100:	8082                	ret

0000000080002102 <sys_wait>:

uint64
sys_wait(void)
{
    80002102:	1101                	addi	sp,sp,-32
    80002104:	ec06                	sd	ra,24(sp)
    80002106:	e822                	sd	s0,16(sp)
    80002108:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    8000210a:	fe840593          	addi	a1,s0,-24
    8000210e:	4501                	li	a0,0
    80002110:	00000097          	auipc	ra,0x0
    80002114:	ece080e7          	jalr	-306(ra) # 80001fde <argaddr>
    80002118:	87aa                	mv	a5,a0
    return -1;
    8000211a:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    8000211c:	0007c863          	bltz	a5,8000212c <sys_wait+0x2a>
  return wait(p);
    80002120:	fe843503          	ld	a0,-24(s0)
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	502080e7          	jalr	1282(ra) # 80001626 <wait>
}
    8000212c:	60e2                	ld	ra,24(sp)
    8000212e:	6442                	ld	s0,16(sp)
    80002130:	6105                	addi	sp,sp,32
    80002132:	8082                	ret

0000000080002134 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002134:	7179                	addi	sp,sp,-48
    80002136:	f406                	sd	ra,40(sp)
    80002138:	f022                	sd	s0,32(sp)
    8000213a:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    8000213c:	fdc40593          	addi	a1,s0,-36
    80002140:	4501                	li	a0,0
    80002142:	00000097          	auipc	ra,0x0
    80002146:	e7a080e7          	jalr	-390(ra) # 80001fbc <argint>
    8000214a:	87aa                	mv	a5,a0
    return -1;
    8000214c:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    8000214e:	0207c263          	bltz	a5,80002172 <sys_sbrk+0x3e>
    80002152:	ec26                	sd	s1,24(sp)
  
  addr = myproc()->sz;
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	d24080e7          	jalr	-732(ra) # 80000e78 <myproc>
    8000215c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000215e:	fdc42503          	lw	a0,-36(s0)
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	0f4080e7          	jalr	244(ra) # 80001256 <growproc>
    8000216a:	00054863          	bltz	a0,8000217a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000216e:	8526                	mv	a0,s1
    80002170:	64e2                	ld	s1,24(sp)
}
    80002172:	70a2                	ld	ra,40(sp)
    80002174:	7402                	ld	s0,32(sp)
    80002176:	6145                	addi	sp,sp,48
    80002178:	8082                	ret
    return -1;
    8000217a:	557d                	li	a0,-1
    8000217c:	64e2                	ld	s1,24(sp)
    8000217e:	bfd5                	j	80002172 <sys_sbrk+0x3e>

0000000080002180 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002180:	7139                	addi	sp,sp,-64
    80002182:	fc06                	sd	ra,56(sp)
    80002184:	f822                	sd	s0,48(sp)
    80002186:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    80002188:	fcc40593          	addi	a1,s0,-52
    8000218c:	4501                	li	a0,0
    8000218e:	00000097          	auipc	ra,0x0
    80002192:	e2e080e7          	jalr	-466(ra) # 80001fbc <argint>
    return -1;
    80002196:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002198:	06054b63          	bltz	a0,8000220e <sys_sleep+0x8e>
    8000219c:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    8000219e:	0000d517          	auipc	a0,0xd
    800021a2:	ee250513          	addi	a0,a0,-286 # 8000f080 <tickslock>
    800021a6:	00004097          	auipc	ra,0x4
    800021aa:	080080e7          	jalr	128(ra) # 80006226 <acquire>
  ticks0 = ticks;
    800021ae:	00007917          	auipc	s2,0x7
    800021b2:	e6a92903          	lw	s2,-406(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021b6:	fcc42783          	lw	a5,-52(s0)
    800021ba:	c3a1                	beqz	a5,800021fa <sys_sleep+0x7a>
    800021bc:	f426                	sd	s1,40(sp)
    800021be:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021c0:	0000d997          	auipc	s3,0xd
    800021c4:	ec098993          	addi	s3,s3,-320 # 8000f080 <tickslock>
    800021c8:	00007497          	auipc	s1,0x7
    800021cc:	e5048493          	addi	s1,s1,-432 # 80009018 <ticks>
    if(myproc()->killed){
    800021d0:	fffff097          	auipc	ra,0xfffff
    800021d4:	ca8080e7          	jalr	-856(ra) # 80000e78 <myproc>
    800021d8:	551c                	lw	a5,40(a0)
    800021da:	ef9d                	bnez	a5,80002218 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    800021dc:	85ce                	mv	a1,s3
    800021de:	8526                	mv	a0,s1
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	3e2080e7          	jalr	994(ra) # 800015c2 <sleep>
  while(ticks - ticks0 < n){
    800021e8:	409c                	lw	a5,0(s1)
    800021ea:	412787bb          	subw	a5,a5,s2
    800021ee:	fcc42703          	lw	a4,-52(s0)
    800021f2:	fce7efe3          	bltu	a5,a4,800021d0 <sys_sleep+0x50>
    800021f6:	74a2                	ld	s1,40(sp)
    800021f8:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800021fa:	0000d517          	auipc	a0,0xd
    800021fe:	e8650513          	addi	a0,a0,-378 # 8000f080 <tickslock>
    80002202:	00004097          	auipc	ra,0x4
    80002206:	0d8080e7          	jalr	216(ra) # 800062da <release>
  return 0;
    8000220a:	4781                	li	a5,0
    8000220c:	7902                	ld	s2,32(sp)
}
    8000220e:	853e                	mv	a0,a5
    80002210:	70e2                	ld	ra,56(sp)
    80002212:	7442                	ld	s0,48(sp)
    80002214:	6121                	addi	sp,sp,64
    80002216:	8082                	ret
      release(&tickslock);
    80002218:	0000d517          	auipc	a0,0xd
    8000221c:	e6850513          	addi	a0,a0,-408 # 8000f080 <tickslock>
    80002220:	00004097          	auipc	ra,0x4
    80002224:	0ba080e7          	jalr	186(ra) # 800062da <release>
      return -1;
    80002228:	57fd                	li	a5,-1
    8000222a:	74a2                	ld	s1,40(sp)
    8000222c:	7902                	ld	s2,32(sp)
    8000222e:	69e2                	ld	s3,24(sp)
    80002230:	bff9                	j	8000220e <sys_sleep+0x8e>

0000000080002232 <sys_pgaccess>:


// #ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002232:	1141                	addi	sp,sp,-16
    80002234:	e422                	sd	s0,8(sp)
    80002236:	0800                	addi	s0,sp,16
  // lab pgtbl: your code here.
  return 0;
}
    80002238:	4501                	li	a0,0
    8000223a:	6422                	ld	s0,8(sp)
    8000223c:	0141                	addi	sp,sp,16
    8000223e:	8082                	ret

0000000080002240 <sys_kill>:
// #endif

uint64
sys_kill(void)
{
    80002240:	1101                	addi	sp,sp,-32
    80002242:	ec06                	sd	ra,24(sp)
    80002244:	e822                	sd	s0,16(sp)
    80002246:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002248:	fec40593          	addi	a1,s0,-20
    8000224c:	4501                	li	a0,0
    8000224e:	00000097          	auipc	ra,0x0
    80002252:	d6e080e7          	jalr	-658(ra) # 80001fbc <argint>
    80002256:	87aa                	mv	a5,a0
    return -1;
    80002258:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000225a:	0007c863          	bltz	a5,8000226a <sys_kill+0x2a>
  return kill(pid);
    8000225e:	fec42503          	lw	a0,-20(s0)
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	692080e7          	jalr	1682(ra) # 800018f4 <kill>
}
    8000226a:	60e2                	ld	ra,24(sp)
    8000226c:	6442                	ld	s0,16(sp)
    8000226e:	6105                	addi	sp,sp,32
    80002270:	8082                	ret

0000000080002272 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002272:	1101                	addi	sp,sp,-32
    80002274:	ec06                	sd	ra,24(sp)
    80002276:	e822                	sd	s0,16(sp)
    80002278:	e426                	sd	s1,8(sp)
    8000227a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000227c:	0000d517          	auipc	a0,0xd
    80002280:	e0450513          	addi	a0,a0,-508 # 8000f080 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	fa2080e7          	jalr	-94(ra) # 80006226 <acquire>
  xticks = ticks;
    8000228c:	00007497          	auipc	s1,0x7
    80002290:	d8c4a483          	lw	s1,-628(s1) # 80009018 <ticks>
  release(&tickslock);
    80002294:	0000d517          	auipc	a0,0xd
    80002298:	dec50513          	addi	a0,a0,-532 # 8000f080 <tickslock>
    8000229c:	00004097          	auipc	ra,0x4
    800022a0:	03e080e7          	jalr	62(ra) # 800062da <release>
  return xticks;
}
    800022a4:	02049513          	slli	a0,s1,0x20
    800022a8:	9101                	srli	a0,a0,0x20
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	64a2                	ld	s1,8(sp)
    800022b0:	6105                	addi	sp,sp,32
    800022b2:	8082                	ret

00000000800022b4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800022b4:	7179                	addi	sp,sp,-48
    800022b6:	f406                	sd	ra,40(sp)
    800022b8:	f022                	sd	s0,32(sp)
    800022ba:	ec26                	sd	s1,24(sp)
    800022bc:	e84a                	sd	s2,16(sp)
    800022be:	e44e                	sd	s3,8(sp)
    800022c0:	e052                	sd	s4,0(sp)
    800022c2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800022c4:	00006597          	auipc	a1,0x6
    800022c8:	0bc58593          	addi	a1,a1,188 # 80008380 <etext+0x380>
    800022cc:	0000d517          	auipc	a0,0xd
    800022d0:	dcc50513          	addi	a0,a0,-564 # 8000f098 <bcache>
    800022d4:	00004097          	auipc	ra,0x4
    800022d8:	ec2080e7          	jalr	-318(ra) # 80006196 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022dc:	00015797          	auipc	a5,0x15
    800022e0:	dbc78793          	addi	a5,a5,-580 # 80017098 <bcache+0x8000>
    800022e4:	00015717          	auipc	a4,0x15
    800022e8:	01c70713          	addi	a4,a4,28 # 80017300 <bcache+0x8268>
    800022ec:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022f0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022f4:	0000d497          	auipc	s1,0xd
    800022f8:	dbc48493          	addi	s1,s1,-580 # 8000f0b0 <bcache+0x18>
    b->next = bcache.head.next;
    800022fc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022fe:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002300:	00006a17          	auipc	s4,0x6
    80002304:	088a0a13          	addi	s4,s4,136 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    80002308:	2b893783          	ld	a5,696(s2)
    8000230c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000230e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002312:	85d2                	mv	a1,s4
    80002314:	01048513          	addi	a0,s1,16
    80002318:	00001097          	auipc	ra,0x1
    8000231c:	4b2080e7          	jalr	1202(ra) # 800037ca <initsleeplock>
    bcache.head.next->prev = b;
    80002320:	2b893783          	ld	a5,696(s2)
    80002324:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002326:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000232a:	45848493          	addi	s1,s1,1112
    8000232e:	fd349de3          	bne	s1,s3,80002308 <binit+0x54>
  }
}
    80002332:	70a2                	ld	ra,40(sp)
    80002334:	7402                	ld	s0,32(sp)
    80002336:	64e2                	ld	s1,24(sp)
    80002338:	6942                	ld	s2,16(sp)
    8000233a:	69a2                	ld	s3,8(sp)
    8000233c:	6a02                	ld	s4,0(sp)
    8000233e:	6145                	addi	sp,sp,48
    80002340:	8082                	ret

0000000080002342 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002342:	7179                	addi	sp,sp,-48
    80002344:	f406                	sd	ra,40(sp)
    80002346:	f022                	sd	s0,32(sp)
    80002348:	ec26                	sd	s1,24(sp)
    8000234a:	e84a                	sd	s2,16(sp)
    8000234c:	e44e                	sd	s3,8(sp)
    8000234e:	1800                	addi	s0,sp,48
    80002350:	892a                	mv	s2,a0
    80002352:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002354:	0000d517          	auipc	a0,0xd
    80002358:	d4450513          	addi	a0,a0,-700 # 8000f098 <bcache>
    8000235c:	00004097          	auipc	ra,0x4
    80002360:	eca080e7          	jalr	-310(ra) # 80006226 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002364:	00015497          	auipc	s1,0x15
    80002368:	fec4b483          	ld	s1,-20(s1) # 80017350 <bcache+0x82b8>
    8000236c:	00015797          	auipc	a5,0x15
    80002370:	f9478793          	addi	a5,a5,-108 # 80017300 <bcache+0x8268>
    80002374:	02f48f63          	beq	s1,a5,800023b2 <bread+0x70>
    80002378:	873e                	mv	a4,a5
    8000237a:	a021                	j	80002382 <bread+0x40>
    8000237c:	68a4                	ld	s1,80(s1)
    8000237e:	02e48a63          	beq	s1,a4,800023b2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002382:	449c                	lw	a5,8(s1)
    80002384:	ff279ce3          	bne	a5,s2,8000237c <bread+0x3a>
    80002388:	44dc                	lw	a5,12(s1)
    8000238a:	ff3799e3          	bne	a5,s3,8000237c <bread+0x3a>
      b->refcnt++;
    8000238e:	40bc                	lw	a5,64(s1)
    80002390:	2785                	addiw	a5,a5,1
    80002392:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002394:	0000d517          	auipc	a0,0xd
    80002398:	d0450513          	addi	a0,a0,-764 # 8000f098 <bcache>
    8000239c:	00004097          	auipc	ra,0x4
    800023a0:	f3e080e7          	jalr	-194(ra) # 800062da <release>
      acquiresleep(&b->lock);
    800023a4:	01048513          	addi	a0,s1,16
    800023a8:	00001097          	auipc	ra,0x1
    800023ac:	45c080e7          	jalr	1116(ra) # 80003804 <acquiresleep>
      return b;
    800023b0:	a8b9                	j	8000240e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023b2:	00015497          	auipc	s1,0x15
    800023b6:	f964b483          	ld	s1,-106(s1) # 80017348 <bcache+0x82b0>
    800023ba:	00015797          	auipc	a5,0x15
    800023be:	f4678793          	addi	a5,a5,-186 # 80017300 <bcache+0x8268>
    800023c2:	00f48863          	beq	s1,a5,800023d2 <bread+0x90>
    800023c6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800023c8:	40bc                	lw	a5,64(s1)
    800023ca:	cf81                	beqz	a5,800023e2 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023cc:	64a4                	ld	s1,72(s1)
    800023ce:	fee49de3          	bne	s1,a4,800023c8 <bread+0x86>
  panic("bget: no buffers");
    800023d2:	00006517          	auipc	a0,0x6
    800023d6:	fbe50513          	addi	a0,a0,-66 # 80008390 <etext+0x390>
    800023da:	00004097          	auipc	ra,0x4
    800023de:	8d2080e7          	jalr	-1838(ra) # 80005cac <panic>
      b->dev = dev;
    800023e2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023e6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023ea:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023ee:	4785                	li	a5,1
    800023f0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023f2:	0000d517          	auipc	a0,0xd
    800023f6:	ca650513          	addi	a0,a0,-858 # 8000f098 <bcache>
    800023fa:	00004097          	auipc	ra,0x4
    800023fe:	ee0080e7          	jalr	-288(ra) # 800062da <release>
      acquiresleep(&b->lock);
    80002402:	01048513          	addi	a0,s1,16
    80002406:	00001097          	auipc	ra,0x1
    8000240a:	3fe080e7          	jalr	1022(ra) # 80003804 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000240e:	409c                	lw	a5,0(s1)
    80002410:	cb89                	beqz	a5,80002422 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002412:	8526                	mv	a0,s1
    80002414:	70a2                	ld	ra,40(sp)
    80002416:	7402                	ld	s0,32(sp)
    80002418:	64e2                	ld	s1,24(sp)
    8000241a:	6942                	ld	s2,16(sp)
    8000241c:	69a2                	ld	s3,8(sp)
    8000241e:	6145                	addi	sp,sp,48
    80002420:	8082                	ret
    virtio_disk_rw(b, 0);
    80002422:	4581                	li	a1,0
    80002424:	8526                	mv	a0,s1
    80002426:	00003097          	auipc	ra,0x3
    8000242a:	fec080e7          	jalr	-20(ra) # 80005412 <virtio_disk_rw>
    b->valid = 1;
    8000242e:	4785                	li	a5,1
    80002430:	c09c                	sw	a5,0(s1)
  return b;
    80002432:	b7c5                	j	80002412 <bread+0xd0>

0000000080002434 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002434:	1101                	addi	sp,sp,-32
    80002436:	ec06                	sd	ra,24(sp)
    80002438:	e822                	sd	s0,16(sp)
    8000243a:	e426                	sd	s1,8(sp)
    8000243c:	1000                	addi	s0,sp,32
    8000243e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002440:	0541                	addi	a0,a0,16
    80002442:	00001097          	auipc	ra,0x1
    80002446:	45c080e7          	jalr	1116(ra) # 8000389e <holdingsleep>
    8000244a:	cd01                	beqz	a0,80002462 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000244c:	4585                	li	a1,1
    8000244e:	8526                	mv	a0,s1
    80002450:	00003097          	auipc	ra,0x3
    80002454:	fc2080e7          	jalr	-62(ra) # 80005412 <virtio_disk_rw>
}
    80002458:	60e2                	ld	ra,24(sp)
    8000245a:	6442                	ld	s0,16(sp)
    8000245c:	64a2                	ld	s1,8(sp)
    8000245e:	6105                	addi	sp,sp,32
    80002460:	8082                	ret
    panic("bwrite");
    80002462:	00006517          	auipc	a0,0x6
    80002466:	f4650513          	addi	a0,a0,-186 # 800083a8 <etext+0x3a8>
    8000246a:	00004097          	auipc	ra,0x4
    8000246e:	842080e7          	jalr	-1982(ra) # 80005cac <panic>

0000000080002472 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002472:	1101                	addi	sp,sp,-32
    80002474:	ec06                	sd	ra,24(sp)
    80002476:	e822                	sd	s0,16(sp)
    80002478:	e426                	sd	s1,8(sp)
    8000247a:	e04a                	sd	s2,0(sp)
    8000247c:	1000                	addi	s0,sp,32
    8000247e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002480:	01050913          	addi	s2,a0,16
    80002484:	854a                	mv	a0,s2
    80002486:	00001097          	auipc	ra,0x1
    8000248a:	418080e7          	jalr	1048(ra) # 8000389e <holdingsleep>
    8000248e:	c925                	beqz	a0,800024fe <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002490:	854a                	mv	a0,s2
    80002492:	00001097          	auipc	ra,0x1
    80002496:	3c8080e7          	jalr	968(ra) # 8000385a <releasesleep>

  acquire(&bcache.lock);
    8000249a:	0000d517          	auipc	a0,0xd
    8000249e:	bfe50513          	addi	a0,a0,-1026 # 8000f098 <bcache>
    800024a2:	00004097          	auipc	ra,0x4
    800024a6:	d84080e7          	jalr	-636(ra) # 80006226 <acquire>
  b->refcnt--;
    800024aa:	40bc                	lw	a5,64(s1)
    800024ac:	37fd                	addiw	a5,a5,-1
    800024ae:	0007871b          	sext.w	a4,a5
    800024b2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800024b4:	e71d                	bnez	a4,800024e2 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800024b6:	68b8                	ld	a4,80(s1)
    800024b8:	64bc                	ld	a5,72(s1)
    800024ba:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800024bc:	68b8                	ld	a4,80(s1)
    800024be:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800024c0:	00015797          	auipc	a5,0x15
    800024c4:	bd878793          	addi	a5,a5,-1064 # 80017098 <bcache+0x8000>
    800024c8:	2b87b703          	ld	a4,696(a5)
    800024cc:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024ce:	00015717          	auipc	a4,0x15
    800024d2:	e3270713          	addi	a4,a4,-462 # 80017300 <bcache+0x8268>
    800024d6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024d8:	2b87b703          	ld	a4,696(a5)
    800024dc:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024de:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024e2:	0000d517          	auipc	a0,0xd
    800024e6:	bb650513          	addi	a0,a0,-1098 # 8000f098 <bcache>
    800024ea:	00004097          	auipc	ra,0x4
    800024ee:	df0080e7          	jalr	-528(ra) # 800062da <release>
}
    800024f2:	60e2                	ld	ra,24(sp)
    800024f4:	6442                	ld	s0,16(sp)
    800024f6:	64a2                	ld	s1,8(sp)
    800024f8:	6902                	ld	s2,0(sp)
    800024fa:	6105                	addi	sp,sp,32
    800024fc:	8082                	ret
    panic("brelse");
    800024fe:	00006517          	auipc	a0,0x6
    80002502:	eb250513          	addi	a0,a0,-334 # 800083b0 <etext+0x3b0>
    80002506:	00003097          	auipc	ra,0x3
    8000250a:	7a6080e7          	jalr	1958(ra) # 80005cac <panic>

000000008000250e <bpin>:

void
bpin(struct buf *b) {
    8000250e:	1101                	addi	sp,sp,-32
    80002510:	ec06                	sd	ra,24(sp)
    80002512:	e822                	sd	s0,16(sp)
    80002514:	e426                	sd	s1,8(sp)
    80002516:	1000                	addi	s0,sp,32
    80002518:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000251a:	0000d517          	auipc	a0,0xd
    8000251e:	b7e50513          	addi	a0,a0,-1154 # 8000f098 <bcache>
    80002522:	00004097          	auipc	ra,0x4
    80002526:	d04080e7          	jalr	-764(ra) # 80006226 <acquire>
  b->refcnt++;
    8000252a:	40bc                	lw	a5,64(s1)
    8000252c:	2785                	addiw	a5,a5,1
    8000252e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002530:	0000d517          	auipc	a0,0xd
    80002534:	b6850513          	addi	a0,a0,-1176 # 8000f098 <bcache>
    80002538:	00004097          	auipc	ra,0x4
    8000253c:	da2080e7          	jalr	-606(ra) # 800062da <release>
}
    80002540:	60e2                	ld	ra,24(sp)
    80002542:	6442                	ld	s0,16(sp)
    80002544:	64a2                	ld	s1,8(sp)
    80002546:	6105                	addi	sp,sp,32
    80002548:	8082                	ret

000000008000254a <bunpin>:

void
bunpin(struct buf *b) {
    8000254a:	1101                	addi	sp,sp,-32
    8000254c:	ec06                	sd	ra,24(sp)
    8000254e:	e822                	sd	s0,16(sp)
    80002550:	e426                	sd	s1,8(sp)
    80002552:	1000                	addi	s0,sp,32
    80002554:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002556:	0000d517          	auipc	a0,0xd
    8000255a:	b4250513          	addi	a0,a0,-1214 # 8000f098 <bcache>
    8000255e:	00004097          	auipc	ra,0x4
    80002562:	cc8080e7          	jalr	-824(ra) # 80006226 <acquire>
  b->refcnt--;
    80002566:	40bc                	lw	a5,64(s1)
    80002568:	37fd                	addiw	a5,a5,-1
    8000256a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000256c:	0000d517          	auipc	a0,0xd
    80002570:	b2c50513          	addi	a0,a0,-1236 # 8000f098 <bcache>
    80002574:	00004097          	auipc	ra,0x4
    80002578:	d66080e7          	jalr	-666(ra) # 800062da <release>
}
    8000257c:	60e2                	ld	ra,24(sp)
    8000257e:	6442                	ld	s0,16(sp)
    80002580:	64a2                	ld	s1,8(sp)
    80002582:	6105                	addi	sp,sp,32
    80002584:	8082                	ret

0000000080002586 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002586:	1101                	addi	sp,sp,-32
    80002588:	ec06                	sd	ra,24(sp)
    8000258a:	e822                	sd	s0,16(sp)
    8000258c:	e426                	sd	s1,8(sp)
    8000258e:	e04a                	sd	s2,0(sp)
    80002590:	1000                	addi	s0,sp,32
    80002592:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002594:	00d5d59b          	srliw	a1,a1,0xd
    80002598:	00015797          	auipc	a5,0x15
    8000259c:	1dc7a783          	lw	a5,476(a5) # 80017774 <sb+0x1c>
    800025a0:	9dbd                	addw	a1,a1,a5
    800025a2:	00000097          	auipc	ra,0x0
    800025a6:	da0080e7          	jalr	-608(ra) # 80002342 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800025aa:	0074f713          	andi	a4,s1,7
    800025ae:	4785                	li	a5,1
    800025b0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800025b4:	14ce                	slli	s1,s1,0x33
    800025b6:	90d9                	srli	s1,s1,0x36
    800025b8:	00950733          	add	a4,a0,s1
    800025bc:	05874703          	lbu	a4,88(a4)
    800025c0:	00e7f6b3          	and	a3,a5,a4
    800025c4:	c69d                	beqz	a3,800025f2 <bfree+0x6c>
    800025c6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800025c8:	94aa                	add	s1,s1,a0
    800025ca:	fff7c793          	not	a5,a5
    800025ce:	8f7d                	and	a4,a4,a5
    800025d0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025d4:	00001097          	auipc	ra,0x1
    800025d8:	112080e7          	jalr	274(ra) # 800036e6 <log_write>
  brelse(bp);
    800025dc:	854a                	mv	a0,s2
    800025de:	00000097          	auipc	ra,0x0
    800025e2:	e94080e7          	jalr	-364(ra) # 80002472 <brelse>
}
    800025e6:	60e2                	ld	ra,24(sp)
    800025e8:	6442                	ld	s0,16(sp)
    800025ea:	64a2                	ld	s1,8(sp)
    800025ec:	6902                	ld	s2,0(sp)
    800025ee:	6105                	addi	sp,sp,32
    800025f0:	8082                	ret
    panic("freeing free block");
    800025f2:	00006517          	auipc	a0,0x6
    800025f6:	dc650513          	addi	a0,a0,-570 # 800083b8 <etext+0x3b8>
    800025fa:	00003097          	auipc	ra,0x3
    800025fe:	6b2080e7          	jalr	1714(ra) # 80005cac <panic>

0000000080002602 <balloc>:
{
    80002602:	711d                	addi	sp,sp,-96
    80002604:	ec86                	sd	ra,88(sp)
    80002606:	e8a2                	sd	s0,80(sp)
    80002608:	e4a6                	sd	s1,72(sp)
    8000260a:	e0ca                	sd	s2,64(sp)
    8000260c:	fc4e                	sd	s3,56(sp)
    8000260e:	f852                	sd	s4,48(sp)
    80002610:	f456                	sd	s5,40(sp)
    80002612:	f05a                	sd	s6,32(sp)
    80002614:	ec5e                	sd	s7,24(sp)
    80002616:	e862                	sd	s8,16(sp)
    80002618:	e466                	sd	s9,8(sp)
    8000261a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000261c:	00015797          	auipc	a5,0x15
    80002620:	1407a783          	lw	a5,320(a5) # 8001775c <sb+0x4>
    80002624:	cbc1                	beqz	a5,800026b4 <balloc+0xb2>
    80002626:	8baa                	mv	s7,a0
    80002628:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000262a:	00015b17          	auipc	s6,0x15
    8000262e:	12eb0b13          	addi	s6,s6,302 # 80017758 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002632:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002634:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002636:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002638:	6c89                	lui	s9,0x2
    8000263a:	a831                	j	80002656 <balloc+0x54>
    brelse(bp);
    8000263c:	854a                	mv	a0,s2
    8000263e:	00000097          	auipc	ra,0x0
    80002642:	e34080e7          	jalr	-460(ra) # 80002472 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002646:	015c87bb          	addw	a5,s9,s5
    8000264a:	00078a9b          	sext.w	s5,a5
    8000264e:	004b2703          	lw	a4,4(s6)
    80002652:	06eaf163          	bgeu	s5,a4,800026b4 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002656:	41fad79b          	sraiw	a5,s5,0x1f
    8000265a:	0137d79b          	srliw	a5,a5,0x13
    8000265e:	015787bb          	addw	a5,a5,s5
    80002662:	40d7d79b          	sraiw	a5,a5,0xd
    80002666:	01cb2583          	lw	a1,28(s6)
    8000266a:	9dbd                	addw	a1,a1,a5
    8000266c:	855e                	mv	a0,s7
    8000266e:	00000097          	auipc	ra,0x0
    80002672:	cd4080e7          	jalr	-812(ra) # 80002342 <bread>
    80002676:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002678:	004b2503          	lw	a0,4(s6)
    8000267c:	000a849b          	sext.w	s1,s5
    80002680:	8762                	mv	a4,s8
    80002682:	faa4fde3          	bgeu	s1,a0,8000263c <balloc+0x3a>
      m = 1 << (bi % 8);
    80002686:	00777693          	andi	a3,a4,7
    8000268a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000268e:	41f7579b          	sraiw	a5,a4,0x1f
    80002692:	01d7d79b          	srliw	a5,a5,0x1d
    80002696:	9fb9                	addw	a5,a5,a4
    80002698:	4037d79b          	sraiw	a5,a5,0x3
    8000269c:	00f90633          	add	a2,s2,a5
    800026a0:	05864603          	lbu	a2,88(a2)
    800026a4:	00c6f5b3          	and	a1,a3,a2
    800026a8:	cd91                	beqz	a1,800026c4 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026aa:	2705                	addiw	a4,a4,1
    800026ac:	2485                	addiw	s1,s1,1
    800026ae:	fd471ae3          	bne	a4,s4,80002682 <balloc+0x80>
    800026b2:	b769                	j	8000263c <balloc+0x3a>
  panic("balloc: out of blocks");
    800026b4:	00006517          	auipc	a0,0x6
    800026b8:	d1c50513          	addi	a0,a0,-740 # 800083d0 <etext+0x3d0>
    800026bc:	00003097          	auipc	ra,0x3
    800026c0:	5f0080e7          	jalr	1520(ra) # 80005cac <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026c4:	97ca                	add	a5,a5,s2
    800026c6:	8e55                	or	a2,a2,a3
    800026c8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026cc:	854a                	mv	a0,s2
    800026ce:	00001097          	auipc	ra,0x1
    800026d2:	018080e7          	jalr	24(ra) # 800036e6 <log_write>
        brelse(bp);
    800026d6:	854a                	mv	a0,s2
    800026d8:	00000097          	auipc	ra,0x0
    800026dc:	d9a080e7          	jalr	-614(ra) # 80002472 <brelse>
  bp = bread(dev, bno);
    800026e0:	85a6                	mv	a1,s1
    800026e2:	855e                	mv	a0,s7
    800026e4:	00000097          	auipc	ra,0x0
    800026e8:	c5e080e7          	jalr	-930(ra) # 80002342 <bread>
    800026ec:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026ee:	40000613          	li	a2,1024
    800026f2:	4581                	li	a1,0
    800026f4:	05850513          	addi	a0,a0,88
    800026f8:	ffffe097          	auipc	ra,0xffffe
    800026fc:	a82080e7          	jalr	-1406(ra) # 8000017a <memset>
  log_write(bp);
    80002700:	854a                	mv	a0,s2
    80002702:	00001097          	auipc	ra,0x1
    80002706:	fe4080e7          	jalr	-28(ra) # 800036e6 <log_write>
  brelse(bp);
    8000270a:	854a                	mv	a0,s2
    8000270c:	00000097          	auipc	ra,0x0
    80002710:	d66080e7          	jalr	-666(ra) # 80002472 <brelse>
}
    80002714:	8526                	mv	a0,s1
    80002716:	60e6                	ld	ra,88(sp)
    80002718:	6446                	ld	s0,80(sp)
    8000271a:	64a6                	ld	s1,72(sp)
    8000271c:	6906                	ld	s2,64(sp)
    8000271e:	79e2                	ld	s3,56(sp)
    80002720:	7a42                	ld	s4,48(sp)
    80002722:	7aa2                	ld	s5,40(sp)
    80002724:	7b02                	ld	s6,32(sp)
    80002726:	6be2                	ld	s7,24(sp)
    80002728:	6c42                	ld	s8,16(sp)
    8000272a:	6ca2                	ld	s9,8(sp)
    8000272c:	6125                	addi	sp,sp,96
    8000272e:	8082                	ret

0000000080002730 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002730:	7179                	addi	sp,sp,-48
    80002732:	f406                	sd	ra,40(sp)
    80002734:	f022                	sd	s0,32(sp)
    80002736:	ec26                	sd	s1,24(sp)
    80002738:	e84a                	sd	s2,16(sp)
    8000273a:	e44e                	sd	s3,8(sp)
    8000273c:	1800                	addi	s0,sp,48
    8000273e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002740:	47ad                	li	a5,11
    80002742:	04b7ff63          	bgeu	a5,a1,800027a0 <bmap+0x70>
    80002746:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002748:	ff45849b          	addiw	s1,a1,-12
    8000274c:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002750:	0ff00793          	li	a5,255
    80002754:	0ae7e463          	bltu	a5,a4,800027fc <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002758:	08052583          	lw	a1,128(a0)
    8000275c:	c5b5                	beqz	a1,800027c8 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000275e:	00092503          	lw	a0,0(s2)
    80002762:	00000097          	auipc	ra,0x0
    80002766:	be0080e7          	jalr	-1056(ra) # 80002342 <bread>
    8000276a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000276c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002770:	02049713          	slli	a4,s1,0x20
    80002774:	01e75593          	srli	a1,a4,0x1e
    80002778:	00b784b3          	add	s1,a5,a1
    8000277c:	0004a983          	lw	s3,0(s1)
    80002780:	04098e63          	beqz	s3,800027dc <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002784:	8552                	mv	a0,s4
    80002786:	00000097          	auipc	ra,0x0
    8000278a:	cec080e7          	jalr	-788(ra) # 80002472 <brelse>
    return addr;
    8000278e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002790:	854e                	mv	a0,s3
    80002792:	70a2                	ld	ra,40(sp)
    80002794:	7402                	ld	s0,32(sp)
    80002796:	64e2                	ld	s1,24(sp)
    80002798:	6942                	ld	s2,16(sp)
    8000279a:	69a2                	ld	s3,8(sp)
    8000279c:	6145                	addi	sp,sp,48
    8000279e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800027a0:	02059793          	slli	a5,a1,0x20
    800027a4:	01e7d593          	srli	a1,a5,0x1e
    800027a8:	00b504b3          	add	s1,a0,a1
    800027ac:	0504a983          	lw	s3,80(s1)
    800027b0:	fe0990e3          	bnez	s3,80002790 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800027b4:	4108                	lw	a0,0(a0)
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	e4c080e7          	jalr	-436(ra) # 80002602 <balloc>
    800027be:	0005099b          	sext.w	s3,a0
    800027c2:	0534a823          	sw	s3,80(s1)
    800027c6:	b7e9                	j	80002790 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800027c8:	4108                	lw	a0,0(a0)
    800027ca:	00000097          	auipc	ra,0x0
    800027ce:	e38080e7          	jalr	-456(ra) # 80002602 <balloc>
    800027d2:	0005059b          	sext.w	a1,a0
    800027d6:	08b92023          	sw	a1,128(s2)
    800027da:	b751                	j	8000275e <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800027dc:	00092503          	lw	a0,0(s2)
    800027e0:	00000097          	auipc	ra,0x0
    800027e4:	e22080e7          	jalr	-478(ra) # 80002602 <balloc>
    800027e8:	0005099b          	sext.w	s3,a0
    800027ec:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800027f0:	8552                	mv	a0,s4
    800027f2:	00001097          	auipc	ra,0x1
    800027f6:	ef4080e7          	jalr	-268(ra) # 800036e6 <log_write>
    800027fa:	b769                	j	80002784 <bmap+0x54>
  panic("bmap: out of range");
    800027fc:	00006517          	auipc	a0,0x6
    80002800:	bec50513          	addi	a0,a0,-1044 # 800083e8 <etext+0x3e8>
    80002804:	00003097          	auipc	ra,0x3
    80002808:	4a8080e7          	jalr	1192(ra) # 80005cac <panic>

000000008000280c <iget>:
{
    8000280c:	7179                	addi	sp,sp,-48
    8000280e:	f406                	sd	ra,40(sp)
    80002810:	f022                	sd	s0,32(sp)
    80002812:	ec26                	sd	s1,24(sp)
    80002814:	e84a                	sd	s2,16(sp)
    80002816:	e44e                	sd	s3,8(sp)
    80002818:	e052                	sd	s4,0(sp)
    8000281a:	1800                	addi	s0,sp,48
    8000281c:	89aa                	mv	s3,a0
    8000281e:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002820:	00015517          	auipc	a0,0x15
    80002824:	f5850513          	addi	a0,a0,-168 # 80017778 <itable>
    80002828:	00004097          	auipc	ra,0x4
    8000282c:	9fe080e7          	jalr	-1538(ra) # 80006226 <acquire>
  empty = 0;
    80002830:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002832:	00015497          	auipc	s1,0x15
    80002836:	f5e48493          	addi	s1,s1,-162 # 80017790 <itable+0x18>
    8000283a:	00017697          	auipc	a3,0x17
    8000283e:	9e668693          	addi	a3,a3,-1562 # 80019220 <log>
    80002842:	a039                	j	80002850 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002844:	02090b63          	beqz	s2,8000287a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002848:	08848493          	addi	s1,s1,136
    8000284c:	02d48a63          	beq	s1,a3,80002880 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002850:	449c                	lw	a5,8(s1)
    80002852:	fef059e3          	blez	a5,80002844 <iget+0x38>
    80002856:	4098                	lw	a4,0(s1)
    80002858:	ff3716e3          	bne	a4,s3,80002844 <iget+0x38>
    8000285c:	40d8                	lw	a4,4(s1)
    8000285e:	ff4713e3          	bne	a4,s4,80002844 <iget+0x38>
      ip->ref++;
    80002862:	2785                	addiw	a5,a5,1
    80002864:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002866:	00015517          	auipc	a0,0x15
    8000286a:	f1250513          	addi	a0,a0,-238 # 80017778 <itable>
    8000286e:	00004097          	auipc	ra,0x4
    80002872:	a6c080e7          	jalr	-1428(ra) # 800062da <release>
      return ip;
    80002876:	8926                	mv	s2,s1
    80002878:	a03d                	j	800028a6 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000287a:	f7f9                	bnez	a5,80002848 <iget+0x3c>
      empty = ip;
    8000287c:	8926                	mv	s2,s1
    8000287e:	b7e9                	j	80002848 <iget+0x3c>
  if(empty == 0)
    80002880:	02090c63          	beqz	s2,800028b8 <iget+0xac>
  ip->dev = dev;
    80002884:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002888:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000288c:	4785                	li	a5,1
    8000288e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002892:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002896:	00015517          	auipc	a0,0x15
    8000289a:	ee250513          	addi	a0,a0,-286 # 80017778 <itable>
    8000289e:	00004097          	auipc	ra,0x4
    800028a2:	a3c080e7          	jalr	-1476(ra) # 800062da <release>
}
    800028a6:	854a                	mv	a0,s2
    800028a8:	70a2                	ld	ra,40(sp)
    800028aa:	7402                	ld	s0,32(sp)
    800028ac:	64e2                	ld	s1,24(sp)
    800028ae:	6942                	ld	s2,16(sp)
    800028b0:	69a2                	ld	s3,8(sp)
    800028b2:	6a02                	ld	s4,0(sp)
    800028b4:	6145                	addi	sp,sp,48
    800028b6:	8082                	ret
    panic("iget: no inodes");
    800028b8:	00006517          	auipc	a0,0x6
    800028bc:	b4850513          	addi	a0,a0,-1208 # 80008400 <etext+0x400>
    800028c0:	00003097          	auipc	ra,0x3
    800028c4:	3ec080e7          	jalr	1004(ra) # 80005cac <panic>

00000000800028c8 <fsinit>:
fsinit(int dev) {
    800028c8:	7179                	addi	sp,sp,-48
    800028ca:	f406                	sd	ra,40(sp)
    800028cc:	f022                	sd	s0,32(sp)
    800028ce:	ec26                	sd	s1,24(sp)
    800028d0:	e84a                	sd	s2,16(sp)
    800028d2:	e44e                	sd	s3,8(sp)
    800028d4:	1800                	addi	s0,sp,48
    800028d6:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028d8:	4585                	li	a1,1
    800028da:	00000097          	auipc	ra,0x0
    800028de:	a68080e7          	jalr	-1432(ra) # 80002342 <bread>
    800028e2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028e4:	00015997          	auipc	s3,0x15
    800028e8:	e7498993          	addi	s3,s3,-396 # 80017758 <sb>
    800028ec:	02000613          	li	a2,32
    800028f0:	05850593          	addi	a1,a0,88
    800028f4:	854e                	mv	a0,s3
    800028f6:	ffffe097          	auipc	ra,0xffffe
    800028fa:	8e0080e7          	jalr	-1824(ra) # 800001d6 <memmove>
  brelse(bp);
    800028fe:	8526                	mv	a0,s1
    80002900:	00000097          	auipc	ra,0x0
    80002904:	b72080e7          	jalr	-1166(ra) # 80002472 <brelse>
  if(sb.magic != FSMAGIC)
    80002908:	0009a703          	lw	a4,0(s3)
    8000290c:	102037b7          	lui	a5,0x10203
    80002910:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002914:	02f71263          	bne	a4,a5,80002938 <fsinit+0x70>
  initlog(dev, &sb);
    80002918:	00015597          	auipc	a1,0x15
    8000291c:	e4058593          	addi	a1,a1,-448 # 80017758 <sb>
    80002920:	854a                	mv	a0,s2
    80002922:	00001097          	auipc	ra,0x1
    80002926:	b54080e7          	jalr	-1196(ra) # 80003476 <initlog>
}
    8000292a:	70a2                	ld	ra,40(sp)
    8000292c:	7402                	ld	s0,32(sp)
    8000292e:	64e2                	ld	s1,24(sp)
    80002930:	6942                	ld	s2,16(sp)
    80002932:	69a2                	ld	s3,8(sp)
    80002934:	6145                	addi	sp,sp,48
    80002936:	8082                	ret
    panic("invalid file system");
    80002938:	00006517          	auipc	a0,0x6
    8000293c:	ad850513          	addi	a0,a0,-1320 # 80008410 <etext+0x410>
    80002940:	00003097          	auipc	ra,0x3
    80002944:	36c080e7          	jalr	876(ra) # 80005cac <panic>

0000000080002948 <iinit>:
{
    80002948:	7179                	addi	sp,sp,-48
    8000294a:	f406                	sd	ra,40(sp)
    8000294c:	f022                	sd	s0,32(sp)
    8000294e:	ec26                	sd	s1,24(sp)
    80002950:	e84a                	sd	s2,16(sp)
    80002952:	e44e                	sd	s3,8(sp)
    80002954:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002956:	00006597          	auipc	a1,0x6
    8000295a:	ad258593          	addi	a1,a1,-1326 # 80008428 <etext+0x428>
    8000295e:	00015517          	auipc	a0,0x15
    80002962:	e1a50513          	addi	a0,a0,-486 # 80017778 <itable>
    80002966:	00004097          	auipc	ra,0x4
    8000296a:	830080e7          	jalr	-2000(ra) # 80006196 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000296e:	00015497          	auipc	s1,0x15
    80002972:	e3248493          	addi	s1,s1,-462 # 800177a0 <itable+0x28>
    80002976:	00017997          	auipc	s3,0x17
    8000297a:	8ba98993          	addi	s3,s3,-1862 # 80019230 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000297e:	00006917          	auipc	s2,0x6
    80002982:	ab290913          	addi	s2,s2,-1358 # 80008430 <etext+0x430>
    80002986:	85ca                	mv	a1,s2
    80002988:	8526                	mv	a0,s1
    8000298a:	00001097          	auipc	ra,0x1
    8000298e:	e40080e7          	jalr	-448(ra) # 800037ca <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002992:	08848493          	addi	s1,s1,136
    80002996:	ff3498e3          	bne	s1,s3,80002986 <iinit+0x3e>
}
    8000299a:	70a2                	ld	ra,40(sp)
    8000299c:	7402                	ld	s0,32(sp)
    8000299e:	64e2                	ld	s1,24(sp)
    800029a0:	6942                	ld	s2,16(sp)
    800029a2:	69a2                	ld	s3,8(sp)
    800029a4:	6145                	addi	sp,sp,48
    800029a6:	8082                	ret

00000000800029a8 <ialloc>:
{
    800029a8:	7139                	addi	sp,sp,-64
    800029aa:	fc06                	sd	ra,56(sp)
    800029ac:	f822                	sd	s0,48(sp)
    800029ae:	f426                	sd	s1,40(sp)
    800029b0:	f04a                	sd	s2,32(sp)
    800029b2:	ec4e                	sd	s3,24(sp)
    800029b4:	e852                	sd	s4,16(sp)
    800029b6:	e456                	sd	s5,8(sp)
    800029b8:	e05a                	sd	s6,0(sp)
    800029ba:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800029bc:	00015717          	auipc	a4,0x15
    800029c0:	da872703          	lw	a4,-600(a4) # 80017764 <sb+0xc>
    800029c4:	4785                	li	a5,1
    800029c6:	04e7f863          	bgeu	a5,a4,80002a16 <ialloc+0x6e>
    800029ca:	8aaa                	mv	s5,a0
    800029cc:	8b2e                	mv	s6,a1
    800029ce:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029d0:	00015a17          	auipc	s4,0x15
    800029d4:	d88a0a13          	addi	s4,s4,-632 # 80017758 <sb>
    800029d8:	00495593          	srli	a1,s2,0x4
    800029dc:	018a2783          	lw	a5,24(s4)
    800029e0:	9dbd                	addw	a1,a1,a5
    800029e2:	8556                	mv	a0,s5
    800029e4:	00000097          	auipc	ra,0x0
    800029e8:	95e080e7          	jalr	-1698(ra) # 80002342 <bread>
    800029ec:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029ee:	05850993          	addi	s3,a0,88
    800029f2:	00f97793          	andi	a5,s2,15
    800029f6:	079a                	slli	a5,a5,0x6
    800029f8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029fa:	00099783          	lh	a5,0(s3)
    800029fe:	c785                	beqz	a5,80002a26 <ialloc+0x7e>
    brelse(bp);
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	a72080e7          	jalr	-1422(ra) # 80002472 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a08:	0905                	addi	s2,s2,1
    80002a0a:	00ca2703          	lw	a4,12(s4)
    80002a0e:	0009079b          	sext.w	a5,s2
    80002a12:	fce7e3e3          	bltu	a5,a4,800029d8 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002a16:	00006517          	auipc	a0,0x6
    80002a1a:	a2250513          	addi	a0,a0,-1502 # 80008438 <etext+0x438>
    80002a1e:	00003097          	auipc	ra,0x3
    80002a22:	28e080e7          	jalr	654(ra) # 80005cac <panic>
      memset(dip, 0, sizeof(*dip));
    80002a26:	04000613          	li	a2,64
    80002a2a:	4581                	li	a1,0
    80002a2c:	854e                	mv	a0,s3
    80002a2e:	ffffd097          	auipc	ra,0xffffd
    80002a32:	74c080e7          	jalr	1868(ra) # 8000017a <memset>
      dip->type = type;
    80002a36:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	00001097          	auipc	ra,0x1
    80002a40:	caa080e7          	jalr	-854(ra) # 800036e6 <log_write>
      brelse(bp);
    80002a44:	8526                	mv	a0,s1
    80002a46:	00000097          	auipc	ra,0x0
    80002a4a:	a2c080e7          	jalr	-1492(ra) # 80002472 <brelse>
      return iget(dev, inum);
    80002a4e:	0009059b          	sext.w	a1,s2
    80002a52:	8556                	mv	a0,s5
    80002a54:	00000097          	auipc	ra,0x0
    80002a58:	db8080e7          	jalr	-584(ra) # 8000280c <iget>
}
    80002a5c:	70e2                	ld	ra,56(sp)
    80002a5e:	7442                	ld	s0,48(sp)
    80002a60:	74a2                	ld	s1,40(sp)
    80002a62:	7902                	ld	s2,32(sp)
    80002a64:	69e2                	ld	s3,24(sp)
    80002a66:	6a42                	ld	s4,16(sp)
    80002a68:	6aa2                	ld	s5,8(sp)
    80002a6a:	6b02                	ld	s6,0(sp)
    80002a6c:	6121                	addi	sp,sp,64
    80002a6e:	8082                	ret

0000000080002a70 <iupdate>:
{
    80002a70:	1101                	addi	sp,sp,-32
    80002a72:	ec06                	sd	ra,24(sp)
    80002a74:	e822                	sd	s0,16(sp)
    80002a76:	e426                	sd	s1,8(sp)
    80002a78:	e04a                	sd	s2,0(sp)
    80002a7a:	1000                	addi	s0,sp,32
    80002a7c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a7e:	415c                	lw	a5,4(a0)
    80002a80:	0047d79b          	srliw	a5,a5,0x4
    80002a84:	00015597          	auipc	a1,0x15
    80002a88:	cec5a583          	lw	a1,-788(a1) # 80017770 <sb+0x18>
    80002a8c:	9dbd                	addw	a1,a1,a5
    80002a8e:	4108                	lw	a0,0(a0)
    80002a90:	00000097          	auipc	ra,0x0
    80002a94:	8b2080e7          	jalr	-1870(ra) # 80002342 <bread>
    80002a98:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a9a:	05850793          	addi	a5,a0,88
    80002a9e:	40d8                	lw	a4,4(s1)
    80002aa0:	8b3d                	andi	a4,a4,15
    80002aa2:	071a                	slli	a4,a4,0x6
    80002aa4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002aa6:	04449703          	lh	a4,68(s1)
    80002aaa:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002aae:	04649703          	lh	a4,70(s1)
    80002ab2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ab6:	04849703          	lh	a4,72(s1)
    80002aba:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002abe:	04a49703          	lh	a4,74(s1)
    80002ac2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ac6:	44f8                	lw	a4,76(s1)
    80002ac8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002aca:	03400613          	li	a2,52
    80002ace:	05048593          	addi	a1,s1,80
    80002ad2:	00c78513          	addi	a0,a5,12
    80002ad6:	ffffd097          	auipc	ra,0xffffd
    80002ada:	700080e7          	jalr	1792(ra) # 800001d6 <memmove>
  log_write(bp);
    80002ade:	854a                	mv	a0,s2
    80002ae0:	00001097          	auipc	ra,0x1
    80002ae4:	c06080e7          	jalr	-1018(ra) # 800036e6 <log_write>
  brelse(bp);
    80002ae8:	854a                	mv	a0,s2
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	988080e7          	jalr	-1656(ra) # 80002472 <brelse>
}
    80002af2:	60e2                	ld	ra,24(sp)
    80002af4:	6442                	ld	s0,16(sp)
    80002af6:	64a2                	ld	s1,8(sp)
    80002af8:	6902                	ld	s2,0(sp)
    80002afa:	6105                	addi	sp,sp,32
    80002afc:	8082                	ret

0000000080002afe <idup>:
{
    80002afe:	1101                	addi	sp,sp,-32
    80002b00:	ec06                	sd	ra,24(sp)
    80002b02:	e822                	sd	s0,16(sp)
    80002b04:	e426                	sd	s1,8(sp)
    80002b06:	1000                	addi	s0,sp,32
    80002b08:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b0a:	00015517          	auipc	a0,0x15
    80002b0e:	c6e50513          	addi	a0,a0,-914 # 80017778 <itable>
    80002b12:	00003097          	auipc	ra,0x3
    80002b16:	714080e7          	jalr	1812(ra) # 80006226 <acquire>
  ip->ref++;
    80002b1a:	449c                	lw	a5,8(s1)
    80002b1c:	2785                	addiw	a5,a5,1
    80002b1e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002b20:	00015517          	auipc	a0,0x15
    80002b24:	c5850513          	addi	a0,a0,-936 # 80017778 <itable>
    80002b28:	00003097          	auipc	ra,0x3
    80002b2c:	7b2080e7          	jalr	1970(ra) # 800062da <release>
}
    80002b30:	8526                	mv	a0,s1
    80002b32:	60e2                	ld	ra,24(sp)
    80002b34:	6442                	ld	s0,16(sp)
    80002b36:	64a2                	ld	s1,8(sp)
    80002b38:	6105                	addi	sp,sp,32
    80002b3a:	8082                	ret

0000000080002b3c <ilock>:
{
    80002b3c:	1101                	addi	sp,sp,-32
    80002b3e:	ec06                	sd	ra,24(sp)
    80002b40:	e822                	sd	s0,16(sp)
    80002b42:	e426                	sd	s1,8(sp)
    80002b44:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b46:	c10d                	beqz	a0,80002b68 <ilock+0x2c>
    80002b48:	84aa                	mv	s1,a0
    80002b4a:	451c                	lw	a5,8(a0)
    80002b4c:	00f05e63          	blez	a5,80002b68 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002b50:	0541                	addi	a0,a0,16
    80002b52:	00001097          	auipc	ra,0x1
    80002b56:	cb2080e7          	jalr	-846(ra) # 80003804 <acquiresleep>
  if(ip->valid == 0){
    80002b5a:	40bc                	lw	a5,64(s1)
    80002b5c:	cf99                	beqz	a5,80002b7a <ilock+0x3e>
}
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	64a2                	ld	s1,8(sp)
    80002b64:	6105                	addi	sp,sp,32
    80002b66:	8082                	ret
    80002b68:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002b6a:	00006517          	auipc	a0,0x6
    80002b6e:	8e650513          	addi	a0,a0,-1818 # 80008450 <etext+0x450>
    80002b72:	00003097          	auipc	ra,0x3
    80002b76:	13a080e7          	jalr	314(ra) # 80005cac <panic>
    80002b7a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b7c:	40dc                	lw	a5,4(s1)
    80002b7e:	0047d79b          	srliw	a5,a5,0x4
    80002b82:	00015597          	auipc	a1,0x15
    80002b86:	bee5a583          	lw	a1,-1042(a1) # 80017770 <sb+0x18>
    80002b8a:	9dbd                	addw	a1,a1,a5
    80002b8c:	4088                	lw	a0,0(s1)
    80002b8e:	fffff097          	auipc	ra,0xfffff
    80002b92:	7b4080e7          	jalr	1972(ra) # 80002342 <bread>
    80002b96:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b98:	05850593          	addi	a1,a0,88
    80002b9c:	40dc                	lw	a5,4(s1)
    80002b9e:	8bbd                	andi	a5,a5,15
    80002ba0:	079a                	slli	a5,a5,0x6
    80002ba2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ba4:	00059783          	lh	a5,0(a1)
    80002ba8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002bac:	00259783          	lh	a5,2(a1)
    80002bb0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002bb4:	00459783          	lh	a5,4(a1)
    80002bb8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002bbc:	00659783          	lh	a5,6(a1)
    80002bc0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002bc4:	459c                	lw	a5,8(a1)
    80002bc6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002bc8:	03400613          	li	a2,52
    80002bcc:	05b1                	addi	a1,a1,12
    80002bce:	05048513          	addi	a0,s1,80
    80002bd2:	ffffd097          	auipc	ra,0xffffd
    80002bd6:	604080e7          	jalr	1540(ra) # 800001d6 <memmove>
    brelse(bp);
    80002bda:	854a                	mv	a0,s2
    80002bdc:	00000097          	auipc	ra,0x0
    80002be0:	896080e7          	jalr	-1898(ra) # 80002472 <brelse>
    ip->valid = 1;
    80002be4:	4785                	li	a5,1
    80002be6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002be8:	04449783          	lh	a5,68(s1)
    80002bec:	c399                	beqz	a5,80002bf2 <ilock+0xb6>
    80002bee:	6902                	ld	s2,0(sp)
    80002bf0:	b7bd                	j	80002b5e <ilock+0x22>
      panic("ilock: no type");
    80002bf2:	00006517          	auipc	a0,0x6
    80002bf6:	86650513          	addi	a0,a0,-1946 # 80008458 <etext+0x458>
    80002bfa:	00003097          	auipc	ra,0x3
    80002bfe:	0b2080e7          	jalr	178(ra) # 80005cac <panic>

0000000080002c02 <iunlock>:
{
    80002c02:	1101                	addi	sp,sp,-32
    80002c04:	ec06                	sd	ra,24(sp)
    80002c06:	e822                	sd	s0,16(sp)
    80002c08:	e426                	sd	s1,8(sp)
    80002c0a:	e04a                	sd	s2,0(sp)
    80002c0c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c0e:	c905                	beqz	a0,80002c3e <iunlock+0x3c>
    80002c10:	84aa                	mv	s1,a0
    80002c12:	01050913          	addi	s2,a0,16
    80002c16:	854a                	mv	a0,s2
    80002c18:	00001097          	auipc	ra,0x1
    80002c1c:	c86080e7          	jalr	-890(ra) # 8000389e <holdingsleep>
    80002c20:	cd19                	beqz	a0,80002c3e <iunlock+0x3c>
    80002c22:	449c                	lw	a5,8(s1)
    80002c24:	00f05d63          	blez	a5,80002c3e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002c28:	854a                	mv	a0,s2
    80002c2a:	00001097          	auipc	ra,0x1
    80002c2e:	c30080e7          	jalr	-976(ra) # 8000385a <releasesleep>
}
    80002c32:	60e2                	ld	ra,24(sp)
    80002c34:	6442                	ld	s0,16(sp)
    80002c36:	64a2                	ld	s1,8(sp)
    80002c38:	6902                	ld	s2,0(sp)
    80002c3a:	6105                	addi	sp,sp,32
    80002c3c:	8082                	ret
    panic("iunlock");
    80002c3e:	00006517          	auipc	a0,0x6
    80002c42:	82a50513          	addi	a0,a0,-2006 # 80008468 <etext+0x468>
    80002c46:	00003097          	auipc	ra,0x3
    80002c4a:	066080e7          	jalr	102(ra) # 80005cac <panic>

0000000080002c4e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c4e:	7179                	addi	sp,sp,-48
    80002c50:	f406                	sd	ra,40(sp)
    80002c52:	f022                	sd	s0,32(sp)
    80002c54:	ec26                	sd	s1,24(sp)
    80002c56:	e84a                	sd	s2,16(sp)
    80002c58:	e44e                	sd	s3,8(sp)
    80002c5a:	1800                	addi	s0,sp,48
    80002c5c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c5e:	05050493          	addi	s1,a0,80
    80002c62:	08050913          	addi	s2,a0,128
    80002c66:	a021                	j	80002c6e <itrunc+0x20>
    80002c68:	0491                	addi	s1,s1,4
    80002c6a:	01248d63          	beq	s1,s2,80002c84 <itrunc+0x36>
    if(ip->addrs[i]){
    80002c6e:	408c                	lw	a1,0(s1)
    80002c70:	dde5                	beqz	a1,80002c68 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002c72:	0009a503          	lw	a0,0(s3)
    80002c76:	00000097          	auipc	ra,0x0
    80002c7a:	910080e7          	jalr	-1776(ra) # 80002586 <bfree>
      ip->addrs[i] = 0;
    80002c7e:	0004a023          	sw	zero,0(s1)
    80002c82:	b7dd                	j	80002c68 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c84:	0809a583          	lw	a1,128(s3)
    80002c88:	ed99                	bnez	a1,80002ca6 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c8a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c8e:	854e                	mv	a0,s3
    80002c90:	00000097          	auipc	ra,0x0
    80002c94:	de0080e7          	jalr	-544(ra) # 80002a70 <iupdate>
}
    80002c98:	70a2                	ld	ra,40(sp)
    80002c9a:	7402                	ld	s0,32(sp)
    80002c9c:	64e2                	ld	s1,24(sp)
    80002c9e:	6942                	ld	s2,16(sp)
    80002ca0:	69a2                	ld	s3,8(sp)
    80002ca2:	6145                	addi	sp,sp,48
    80002ca4:	8082                	ret
    80002ca6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ca8:	0009a503          	lw	a0,0(s3)
    80002cac:	fffff097          	auipc	ra,0xfffff
    80002cb0:	696080e7          	jalr	1686(ra) # 80002342 <bread>
    80002cb4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002cb6:	05850493          	addi	s1,a0,88
    80002cba:	45850913          	addi	s2,a0,1112
    80002cbe:	a021                	j	80002cc6 <itrunc+0x78>
    80002cc0:	0491                	addi	s1,s1,4
    80002cc2:	01248b63          	beq	s1,s2,80002cd8 <itrunc+0x8a>
      if(a[j])
    80002cc6:	408c                	lw	a1,0(s1)
    80002cc8:	dde5                	beqz	a1,80002cc0 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002cca:	0009a503          	lw	a0,0(s3)
    80002cce:	00000097          	auipc	ra,0x0
    80002cd2:	8b8080e7          	jalr	-1864(ra) # 80002586 <bfree>
    80002cd6:	b7ed                	j	80002cc0 <itrunc+0x72>
    brelse(bp);
    80002cd8:	8552                	mv	a0,s4
    80002cda:	fffff097          	auipc	ra,0xfffff
    80002cde:	798080e7          	jalr	1944(ra) # 80002472 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002ce2:	0809a583          	lw	a1,128(s3)
    80002ce6:	0009a503          	lw	a0,0(s3)
    80002cea:	00000097          	auipc	ra,0x0
    80002cee:	89c080e7          	jalr	-1892(ra) # 80002586 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cf2:	0809a023          	sw	zero,128(s3)
    80002cf6:	6a02                	ld	s4,0(sp)
    80002cf8:	bf49                	j	80002c8a <itrunc+0x3c>

0000000080002cfa <iput>:
{
    80002cfa:	1101                	addi	sp,sp,-32
    80002cfc:	ec06                	sd	ra,24(sp)
    80002cfe:	e822                	sd	s0,16(sp)
    80002d00:	e426                	sd	s1,8(sp)
    80002d02:	1000                	addi	s0,sp,32
    80002d04:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d06:	00015517          	auipc	a0,0x15
    80002d0a:	a7250513          	addi	a0,a0,-1422 # 80017778 <itable>
    80002d0e:	00003097          	auipc	ra,0x3
    80002d12:	518080e7          	jalr	1304(ra) # 80006226 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d16:	4498                	lw	a4,8(s1)
    80002d18:	4785                	li	a5,1
    80002d1a:	02f70263          	beq	a4,a5,80002d3e <iput+0x44>
  ip->ref--;
    80002d1e:	449c                	lw	a5,8(s1)
    80002d20:	37fd                	addiw	a5,a5,-1
    80002d22:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d24:	00015517          	auipc	a0,0x15
    80002d28:	a5450513          	addi	a0,a0,-1452 # 80017778 <itable>
    80002d2c:	00003097          	auipc	ra,0x3
    80002d30:	5ae080e7          	jalr	1454(ra) # 800062da <release>
}
    80002d34:	60e2                	ld	ra,24(sp)
    80002d36:	6442                	ld	s0,16(sp)
    80002d38:	64a2                	ld	s1,8(sp)
    80002d3a:	6105                	addi	sp,sp,32
    80002d3c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d3e:	40bc                	lw	a5,64(s1)
    80002d40:	dff9                	beqz	a5,80002d1e <iput+0x24>
    80002d42:	04a49783          	lh	a5,74(s1)
    80002d46:	ffe1                	bnez	a5,80002d1e <iput+0x24>
    80002d48:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002d4a:	01048913          	addi	s2,s1,16
    80002d4e:	854a                	mv	a0,s2
    80002d50:	00001097          	auipc	ra,0x1
    80002d54:	ab4080e7          	jalr	-1356(ra) # 80003804 <acquiresleep>
    release(&itable.lock);
    80002d58:	00015517          	auipc	a0,0x15
    80002d5c:	a2050513          	addi	a0,a0,-1504 # 80017778 <itable>
    80002d60:	00003097          	auipc	ra,0x3
    80002d64:	57a080e7          	jalr	1402(ra) # 800062da <release>
    itrunc(ip);
    80002d68:	8526                	mv	a0,s1
    80002d6a:	00000097          	auipc	ra,0x0
    80002d6e:	ee4080e7          	jalr	-284(ra) # 80002c4e <itrunc>
    ip->type = 0;
    80002d72:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d76:	8526                	mv	a0,s1
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	cf8080e7          	jalr	-776(ra) # 80002a70 <iupdate>
    ip->valid = 0;
    80002d80:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d84:	854a                	mv	a0,s2
    80002d86:	00001097          	auipc	ra,0x1
    80002d8a:	ad4080e7          	jalr	-1324(ra) # 8000385a <releasesleep>
    acquire(&itable.lock);
    80002d8e:	00015517          	auipc	a0,0x15
    80002d92:	9ea50513          	addi	a0,a0,-1558 # 80017778 <itable>
    80002d96:	00003097          	auipc	ra,0x3
    80002d9a:	490080e7          	jalr	1168(ra) # 80006226 <acquire>
    80002d9e:	6902                	ld	s2,0(sp)
    80002da0:	bfbd                	j	80002d1e <iput+0x24>

0000000080002da2 <iunlockput>:
{
    80002da2:	1101                	addi	sp,sp,-32
    80002da4:	ec06                	sd	ra,24(sp)
    80002da6:	e822                	sd	s0,16(sp)
    80002da8:	e426                	sd	s1,8(sp)
    80002daa:	1000                	addi	s0,sp,32
    80002dac:	84aa                	mv	s1,a0
  iunlock(ip);
    80002dae:	00000097          	auipc	ra,0x0
    80002db2:	e54080e7          	jalr	-428(ra) # 80002c02 <iunlock>
  iput(ip);
    80002db6:	8526                	mv	a0,s1
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	f42080e7          	jalr	-190(ra) # 80002cfa <iput>
}
    80002dc0:	60e2                	ld	ra,24(sp)
    80002dc2:	6442                	ld	s0,16(sp)
    80002dc4:	64a2                	ld	s1,8(sp)
    80002dc6:	6105                	addi	sp,sp,32
    80002dc8:	8082                	ret

0000000080002dca <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002dca:	1141                	addi	sp,sp,-16
    80002dcc:	e422                	sd	s0,8(sp)
    80002dce:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002dd0:	411c                	lw	a5,0(a0)
    80002dd2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002dd4:	415c                	lw	a5,4(a0)
    80002dd6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dd8:	04451783          	lh	a5,68(a0)
    80002ddc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002de0:	04a51783          	lh	a5,74(a0)
    80002de4:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002de8:	04c56783          	lwu	a5,76(a0)
    80002dec:	e99c                	sd	a5,16(a1)
}
    80002dee:	6422                	ld	s0,8(sp)
    80002df0:	0141                	addi	sp,sp,16
    80002df2:	8082                	ret

0000000080002df4 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002df4:	457c                	lw	a5,76(a0)
    80002df6:	0ed7ef63          	bltu	a5,a3,80002ef4 <readi+0x100>
{
    80002dfa:	7159                	addi	sp,sp,-112
    80002dfc:	f486                	sd	ra,104(sp)
    80002dfe:	f0a2                	sd	s0,96(sp)
    80002e00:	eca6                	sd	s1,88(sp)
    80002e02:	fc56                	sd	s5,56(sp)
    80002e04:	f85a                	sd	s6,48(sp)
    80002e06:	f45e                	sd	s7,40(sp)
    80002e08:	f062                	sd	s8,32(sp)
    80002e0a:	1880                	addi	s0,sp,112
    80002e0c:	8baa                	mv	s7,a0
    80002e0e:	8c2e                	mv	s8,a1
    80002e10:	8ab2                	mv	s5,a2
    80002e12:	84b6                	mv	s1,a3
    80002e14:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002e16:	9f35                	addw	a4,a4,a3
    return 0;
    80002e18:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002e1a:	0ad76c63          	bltu	a4,a3,80002ed2 <readi+0xde>
    80002e1e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002e20:	00e7f463          	bgeu	a5,a4,80002e28 <readi+0x34>
    n = ip->size - off;
    80002e24:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e28:	0c0b0463          	beqz	s6,80002ef0 <readi+0xfc>
    80002e2c:	e8ca                	sd	s2,80(sp)
    80002e2e:	e0d2                	sd	s4,64(sp)
    80002e30:	ec66                	sd	s9,24(sp)
    80002e32:	e86a                	sd	s10,16(sp)
    80002e34:	e46e                	sd	s11,8(sp)
    80002e36:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e38:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e3c:	5cfd                	li	s9,-1
    80002e3e:	a82d                	j	80002e78 <readi+0x84>
    80002e40:	020a1d93          	slli	s11,s4,0x20
    80002e44:	020ddd93          	srli	s11,s11,0x20
    80002e48:	05890613          	addi	a2,s2,88
    80002e4c:	86ee                	mv	a3,s11
    80002e4e:	963a                	add	a2,a2,a4
    80002e50:	85d6                	mv	a1,s5
    80002e52:	8562                	mv	a0,s8
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	b12080e7          	jalr	-1262(ra) # 80001966 <either_copyout>
    80002e5c:	05950d63          	beq	a0,s9,80002eb6 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e60:	854a                	mv	a0,s2
    80002e62:	fffff097          	auipc	ra,0xfffff
    80002e66:	610080e7          	jalr	1552(ra) # 80002472 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e6a:	013a09bb          	addw	s3,s4,s3
    80002e6e:	009a04bb          	addw	s1,s4,s1
    80002e72:	9aee                	add	s5,s5,s11
    80002e74:	0769f863          	bgeu	s3,s6,80002ee4 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e78:	000ba903          	lw	s2,0(s7)
    80002e7c:	00a4d59b          	srliw	a1,s1,0xa
    80002e80:	855e                	mv	a0,s7
    80002e82:	00000097          	auipc	ra,0x0
    80002e86:	8ae080e7          	jalr	-1874(ra) # 80002730 <bmap>
    80002e8a:	0005059b          	sext.w	a1,a0
    80002e8e:	854a                	mv	a0,s2
    80002e90:	fffff097          	auipc	ra,0xfffff
    80002e94:	4b2080e7          	jalr	1202(ra) # 80002342 <bread>
    80002e98:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e9a:	3ff4f713          	andi	a4,s1,1023
    80002e9e:	40ed07bb          	subw	a5,s10,a4
    80002ea2:	413b06bb          	subw	a3,s6,s3
    80002ea6:	8a3e                	mv	s4,a5
    80002ea8:	2781                	sext.w	a5,a5
    80002eaa:	0006861b          	sext.w	a2,a3
    80002eae:	f8f679e3          	bgeu	a2,a5,80002e40 <readi+0x4c>
    80002eb2:	8a36                	mv	s4,a3
    80002eb4:	b771                	j	80002e40 <readi+0x4c>
      brelse(bp);
    80002eb6:	854a                	mv	a0,s2
    80002eb8:	fffff097          	auipc	ra,0xfffff
    80002ebc:	5ba080e7          	jalr	1466(ra) # 80002472 <brelse>
      tot = -1;
    80002ec0:	59fd                	li	s3,-1
      break;
    80002ec2:	6946                	ld	s2,80(sp)
    80002ec4:	6a06                	ld	s4,64(sp)
    80002ec6:	6ce2                	ld	s9,24(sp)
    80002ec8:	6d42                	ld	s10,16(sp)
    80002eca:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002ecc:	0009851b          	sext.w	a0,s3
    80002ed0:	69a6                	ld	s3,72(sp)
}
    80002ed2:	70a6                	ld	ra,104(sp)
    80002ed4:	7406                	ld	s0,96(sp)
    80002ed6:	64e6                	ld	s1,88(sp)
    80002ed8:	7ae2                	ld	s5,56(sp)
    80002eda:	7b42                	ld	s6,48(sp)
    80002edc:	7ba2                	ld	s7,40(sp)
    80002ede:	7c02                	ld	s8,32(sp)
    80002ee0:	6165                	addi	sp,sp,112
    80002ee2:	8082                	ret
    80002ee4:	6946                	ld	s2,80(sp)
    80002ee6:	6a06                	ld	s4,64(sp)
    80002ee8:	6ce2                	ld	s9,24(sp)
    80002eea:	6d42                	ld	s10,16(sp)
    80002eec:	6da2                	ld	s11,8(sp)
    80002eee:	bff9                	j	80002ecc <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef0:	89da                	mv	s3,s6
    80002ef2:	bfe9                	j	80002ecc <readi+0xd8>
    return 0;
    80002ef4:	4501                	li	a0,0
}
    80002ef6:	8082                	ret

0000000080002ef8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ef8:	457c                	lw	a5,76(a0)
    80002efa:	10d7ee63          	bltu	a5,a3,80003016 <writei+0x11e>
{
    80002efe:	7159                	addi	sp,sp,-112
    80002f00:	f486                	sd	ra,104(sp)
    80002f02:	f0a2                	sd	s0,96(sp)
    80002f04:	e8ca                	sd	s2,80(sp)
    80002f06:	fc56                	sd	s5,56(sp)
    80002f08:	f85a                	sd	s6,48(sp)
    80002f0a:	f45e                	sd	s7,40(sp)
    80002f0c:	f062                	sd	s8,32(sp)
    80002f0e:	1880                	addi	s0,sp,112
    80002f10:	8b2a                	mv	s6,a0
    80002f12:	8c2e                	mv	s8,a1
    80002f14:	8ab2                	mv	s5,a2
    80002f16:	8936                	mv	s2,a3
    80002f18:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002f1a:	00e687bb          	addw	a5,a3,a4
    80002f1e:	0ed7ee63          	bltu	a5,a3,8000301a <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002f22:	00043737          	lui	a4,0x43
    80002f26:	0ef76c63          	bltu	a4,a5,8000301e <writei+0x126>
    80002f2a:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f2c:	0c0b8d63          	beqz	s7,80003006 <writei+0x10e>
    80002f30:	eca6                	sd	s1,88(sp)
    80002f32:	e4ce                	sd	s3,72(sp)
    80002f34:	ec66                	sd	s9,24(sp)
    80002f36:	e86a                	sd	s10,16(sp)
    80002f38:	e46e                	sd	s11,8(sp)
    80002f3a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f3c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f40:	5cfd                	li	s9,-1
    80002f42:	a091                	j	80002f86 <writei+0x8e>
    80002f44:	02099d93          	slli	s11,s3,0x20
    80002f48:	020ddd93          	srli	s11,s11,0x20
    80002f4c:	05848513          	addi	a0,s1,88
    80002f50:	86ee                	mv	a3,s11
    80002f52:	8656                	mv	a2,s5
    80002f54:	85e2                	mv	a1,s8
    80002f56:	953a                	add	a0,a0,a4
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	a64080e7          	jalr	-1436(ra) # 800019bc <either_copyin>
    80002f60:	07950263          	beq	a0,s9,80002fc4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f64:	8526                	mv	a0,s1
    80002f66:	00000097          	auipc	ra,0x0
    80002f6a:	780080e7          	jalr	1920(ra) # 800036e6 <log_write>
    brelse(bp);
    80002f6e:	8526                	mv	a0,s1
    80002f70:	fffff097          	auipc	ra,0xfffff
    80002f74:	502080e7          	jalr	1282(ra) # 80002472 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f78:	01498a3b          	addw	s4,s3,s4
    80002f7c:	0129893b          	addw	s2,s3,s2
    80002f80:	9aee                	add	s5,s5,s11
    80002f82:	057a7663          	bgeu	s4,s7,80002fce <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f86:	000b2483          	lw	s1,0(s6)
    80002f8a:	00a9559b          	srliw	a1,s2,0xa
    80002f8e:	855a                	mv	a0,s6
    80002f90:	fffff097          	auipc	ra,0xfffff
    80002f94:	7a0080e7          	jalr	1952(ra) # 80002730 <bmap>
    80002f98:	0005059b          	sext.w	a1,a0
    80002f9c:	8526                	mv	a0,s1
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	3a4080e7          	jalr	932(ra) # 80002342 <bread>
    80002fa6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fa8:	3ff97713          	andi	a4,s2,1023
    80002fac:	40ed07bb          	subw	a5,s10,a4
    80002fb0:	414b86bb          	subw	a3,s7,s4
    80002fb4:	89be                	mv	s3,a5
    80002fb6:	2781                	sext.w	a5,a5
    80002fb8:	0006861b          	sext.w	a2,a3
    80002fbc:	f8f674e3          	bgeu	a2,a5,80002f44 <writei+0x4c>
    80002fc0:	89b6                	mv	s3,a3
    80002fc2:	b749                	j	80002f44 <writei+0x4c>
      brelse(bp);
    80002fc4:	8526                	mv	a0,s1
    80002fc6:	fffff097          	auipc	ra,0xfffff
    80002fca:	4ac080e7          	jalr	1196(ra) # 80002472 <brelse>
  }

  if(off > ip->size)
    80002fce:	04cb2783          	lw	a5,76(s6)
    80002fd2:	0327fc63          	bgeu	a5,s2,8000300a <writei+0x112>
    ip->size = off;
    80002fd6:	052b2623          	sw	s2,76(s6)
    80002fda:	64e6                	ld	s1,88(sp)
    80002fdc:	69a6                	ld	s3,72(sp)
    80002fde:	6ce2                	ld	s9,24(sp)
    80002fe0:	6d42                	ld	s10,16(sp)
    80002fe2:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fe4:	855a                	mv	a0,s6
    80002fe6:	00000097          	auipc	ra,0x0
    80002fea:	a8a080e7          	jalr	-1398(ra) # 80002a70 <iupdate>

  return tot;
    80002fee:	000a051b          	sext.w	a0,s4
    80002ff2:	6a06                	ld	s4,64(sp)
}
    80002ff4:	70a6                	ld	ra,104(sp)
    80002ff6:	7406                	ld	s0,96(sp)
    80002ff8:	6946                	ld	s2,80(sp)
    80002ffa:	7ae2                	ld	s5,56(sp)
    80002ffc:	7b42                	ld	s6,48(sp)
    80002ffe:	7ba2                	ld	s7,40(sp)
    80003000:	7c02                	ld	s8,32(sp)
    80003002:	6165                	addi	sp,sp,112
    80003004:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003006:	8a5e                	mv	s4,s7
    80003008:	bff1                	j	80002fe4 <writei+0xec>
    8000300a:	64e6                	ld	s1,88(sp)
    8000300c:	69a6                	ld	s3,72(sp)
    8000300e:	6ce2                	ld	s9,24(sp)
    80003010:	6d42                	ld	s10,16(sp)
    80003012:	6da2                	ld	s11,8(sp)
    80003014:	bfc1                	j	80002fe4 <writei+0xec>
    return -1;
    80003016:	557d                	li	a0,-1
}
    80003018:	8082                	ret
    return -1;
    8000301a:	557d                	li	a0,-1
    8000301c:	bfe1                	j	80002ff4 <writei+0xfc>
    return -1;
    8000301e:	557d                	li	a0,-1
    80003020:	bfd1                	j	80002ff4 <writei+0xfc>

0000000080003022 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003022:	1141                	addi	sp,sp,-16
    80003024:	e406                	sd	ra,8(sp)
    80003026:	e022                	sd	s0,0(sp)
    80003028:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000302a:	4639                	li	a2,14
    8000302c:	ffffd097          	auipc	ra,0xffffd
    80003030:	21e080e7          	jalr	542(ra) # 8000024a <strncmp>
}
    80003034:	60a2                	ld	ra,8(sp)
    80003036:	6402                	ld	s0,0(sp)
    80003038:	0141                	addi	sp,sp,16
    8000303a:	8082                	ret

000000008000303c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000303c:	7139                	addi	sp,sp,-64
    8000303e:	fc06                	sd	ra,56(sp)
    80003040:	f822                	sd	s0,48(sp)
    80003042:	f426                	sd	s1,40(sp)
    80003044:	f04a                	sd	s2,32(sp)
    80003046:	ec4e                	sd	s3,24(sp)
    80003048:	e852                	sd	s4,16(sp)
    8000304a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000304c:	04451703          	lh	a4,68(a0)
    80003050:	4785                	li	a5,1
    80003052:	00f71a63          	bne	a4,a5,80003066 <dirlookup+0x2a>
    80003056:	892a                	mv	s2,a0
    80003058:	89ae                	mv	s3,a1
    8000305a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000305c:	457c                	lw	a5,76(a0)
    8000305e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003060:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003062:	e79d                	bnez	a5,80003090 <dirlookup+0x54>
    80003064:	a8a5                	j	800030dc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003066:	00005517          	auipc	a0,0x5
    8000306a:	40a50513          	addi	a0,a0,1034 # 80008470 <etext+0x470>
    8000306e:	00003097          	auipc	ra,0x3
    80003072:	c3e080e7          	jalr	-962(ra) # 80005cac <panic>
      panic("dirlookup read");
    80003076:	00005517          	auipc	a0,0x5
    8000307a:	41250513          	addi	a0,a0,1042 # 80008488 <etext+0x488>
    8000307e:	00003097          	auipc	ra,0x3
    80003082:	c2e080e7          	jalr	-978(ra) # 80005cac <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003086:	24c1                	addiw	s1,s1,16
    80003088:	04c92783          	lw	a5,76(s2)
    8000308c:	04f4f763          	bgeu	s1,a5,800030da <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003090:	4741                	li	a4,16
    80003092:	86a6                	mv	a3,s1
    80003094:	fc040613          	addi	a2,s0,-64
    80003098:	4581                	li	a1,0
    8000309a:	854a                	mv	a0,s2
    8000309c:	00000097          	auipc	ra,0x0
    800030a0:	d58080e7          	jalr	-680(ra) # 80002df4 <readi>
    800030a4:	47c1                	li	a5,16
    800030a6:	fcf518e3          	bne	a0,a5,80003076 <dirlookup+0x3a>
    if(de.inum == 0)
    800030aa:	fc045783          	lhu	a5,-64(s0)
    800030ae:	dfe1                	beqz	a5,80003086 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800030b0:	fc240593          	addi	a1,s0,-62
    800030b4:	854e                	mv	a0,s3
    800030b6:	00000097          	auipc	ra,0x0
    800030ba:	f6c080e7          	jalr	-148(ra) # 80003022 <namecmp>
    800030be:	f561                	bnez	a0,80003086 <dirlookup+0x4a>
      if(poff)
    800030c0:	000a0463          	beqz	s4,800030c8 <dirlookup+0x8c>
        *poff = off;
    800030c4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800030c8:	fc045583          	lhu	a1,-64(s0)
    800030cc:	00092503          	lw	a0,0(s2)
    800030d0:	fffff097          	auipc	ra,0xfffff
    800030d4:	73c080e7          	jalr	1852(ra) # 8000280c <iget>
    800030d8:	a011                	j	800030dc <dirlookup+0xa0>
  return 0;
    800030da:	4501                	li	a0,0
}
    800030dc:	70e2                	ld	ra,56(sp)
    800030de:	7442                	ld	s0,48(sp)
    800030e0:	74a2                	ld	s1,40(sp)
    800030e2:	7902                	ld	s2,32(sp)
    800030e4:	69e2                	ld	s3,24(sp)
    800030e6:	6a42                	ld	s4,16(sp)
    800030e8:	6121                	addi	sp,sp,64
    800030ea:	8082                	ret

00000000800030ec <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030ec:	711d                	addi	sp,sp,-96
    800030ee:	ec86                	sd	ra,88(sp)
    800030f0:	e8a2                	sd	s0,80(sp)
    800030f2:	e4a6                	sd	s1,72(sp)
    800030f4:	e0ca                	sd	s2,64(sp)
    800030f6:	fc4e                	sd	s3,56(sp)
    800030f8:	f852                	sd	s4,48(sp)
    800030fa:	f456                	sd	s5,40(sp)
    800030fc:	f05a                	sd	s6,32(sp)
    800030fe:	ec5e                	sd	s7,24(sp)
    80003100:	e862                	sd	s8,16(sp)
    80003102:	e466                	sd	s9,8(sp)
    80003104:	1080                	addi	s0,sp,96
    80003106:	84aa                	mv	s1,a0
    80003108:	8b2e                	mv	s6,a1
    8000310a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000310c:	00054703          	lbu	a4,0(a0)
    80003110:	02f00793          	li	a5,47
    80003114:	02f70263          	beq	a4,a5,80003138 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003118:	ffffe097          	auipc	ra,0xffffe
    8000311c:	d60080e7          	jalr	-672(ra) # 80000e78 <myproc>
    80003120:	15053503          	ld	a0,336(a0)
    80003124:	00000097          	auipc	ra,0x0
    80003128:	9da080e7          	jalr	-1574(ra) # 80002afe <idup>
    8000312c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000312e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003132:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003134:	4b85                	li	s7,1
    80003136:	a875                	j	800031f2 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003138:	4585                	li	a1,1
    8000313a:	4505                	li	a0,1
    8000313c:	fffff097          	auipc	ra,0xfffff
    80003140:	6d0080e7          	jalr	1744(ra) # 8000280c <iget>
    80003144:	8a2a                	mv	s4,a0
    80003146:	b7e5                	j	8000312e <namex+0x42>
      iunlockput(ip);
    80003148:	8552                	mv	a0,s4
    8000314a:	00000097          	auipc	ra,0x0
    8000314e:	c58080e7          	jalr	-936(ra) # 80002da2 <iunlockput>
      return 0;
    80003152:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003154:	8552                	mv	a0,s4
    80003156:	60e6                	ld	ra,88(sp)
    80003158:	6446                	ld	s0,80(sp)
    8000315a:	64a6                	ld	s1,72(sp)
    8000315c:	6906                	ld	s2,64(sp)
    8000315e:	79e2                	ld	s3,56(sp)
    80003160:	7a42                	ld	s4,48(sp)
    80003162:	7aa2                	ld	s5,40(sp)
    80003164:	7b02                	ld	s6,32(sp)
    80003166:	6be2                	ld	s7,24(sp)
    80003168:	6c42                	ld	s8,16(sp)
    8000316a:	6ca2                	ld	s9,8(sp)
    8000316c:	6125                	addi	sp,sp,96
    8000316e:	8082                	ret
      iunlock(ip);
    80003170:	8552                	mv	a0,s4
    80003172:	00000097          	auipc	ra,0x0
    80003176:	a90080e7          	jalr	-1392(ra) # 80002c02 <iunlock>
      return ip;
    8000317a:	bfe9                	j	80003154 <namex+0x68>
      iunlockput(ip);
    8000317c:	8552                	mv	a0,s4
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	c24080e7          	jalr	-988(ra) # 80002da2 <iunlockput>
      return 0;
    80003186:	8a4e                	mv	s4,s3
    80003188:	b7f1                	j	80003154 <namex+0x68>
  len = path - s;
    8000318a:	40998633          	sub	a2,s3,s1
    8000318e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003192:	099c5863          	bge	s8,s9,80003222 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003196:	4639                	li	a2,14
    80003198:	85a6                	mv	a1,s1
    8000319a:	8556                	mv	a0,s5
    8000319c:	ffffd097          	auipc	ra,0xffffd
    800031a0:	03a080e7          	jalr	58(ra) # 800001d6 <memmove>
    800031a4:	84ce                	mv	s1,s3
  while(*path == '/')
    800031a6:	0004c783          	lbu	a5,0(s1)
    800031aa:	01279763          	bne	a5,s2,800031b8 <namex+0xcc>
    path++;
    800031ae:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031b0:	0004c783          	lbu	a5,0(s1)
    800031b4:	ff278de3          	beq	a5,s2,800031ae <namex+0xc2>
    ilock(ip);
    800031b8:	8552                	mv	a0,s4
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	982080e7          	jalr	-1662(ra) # 80002b3c <ilock>
    if(ip->type != T_DIR){
    800031c2:	044a1783          	lh	a5,68(s4)
    800031c6:	f97791e3          	bne	a5,s7,80003148 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800031ca:	000b0563          	beqz	s6,800031d4 <namex+0xe8>
    800031ce:	0004c783          	lbu	a5,0(s1)
    800031d2:	dfd9                	beqz	a5,80003170 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031d4:	4601                	li	a2,0
    800031d6:	85d6                	mv	a1,s5
    800031d8:	8552                	mv	a0,s4
    800031da:	00000097          	auipc	ra,0x0
    800031de:	e62080e7          	jalr	-414(ra) # 8000303c <dirlookup>
    800031e2:	89aa                	mv	s3,a0
    800031e4:	dd41                	beqz	a0,8000317c <namex+0x90>
    iunlockput(ip);
    800031e6:	8552                	mv	a0,s4
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	bba080e7          	jalr	-1094(ra) # 80002da2 <iunlockput>
    ip = next;
    800031f0:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031f2:	0004c783          	lbu	a5,0(s1)
    800031f6:	01279763          	bne	a5,s2,80003204 <namex+0x118>
    path++;
    800031fa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031fc:	0004c783          	lbu	a5,0(s1)
    80003200:	ff278de3          	beq	a5,s2,800031fa <namex+0x10e>
  if(*path == 0)
    80003204:	cb9d                	beqz	a5,8000323a <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003206:	0004c783          	lbu	a5,0(s1)
    8000320a:	89a6                	mv	s3,s1
  len = path - s;
    8000320c:	4c81                	li	s9,0
    8000320e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003210:	01278963          	beq	a5,s2,80003222 <namex+0x136>
    80003214:	dbbd                	beqz	a5,8000318a <namex+0x9e>
    path++;
    80003216:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003218:	0009c783          	lbu	a5,0(s3)
    8000321c:	ff279ce3          	bne	a5,s2,80003214 <namex+0x128>
    80003220:	b7ad                	j	8000318a <namex+0x9e>
    memmove(name, s, len);
    80003222:	2601                	sext.w	a2,a2
    80003224:	85a6                	mv	a1,s1
    80003226:	8556                	mv	a0,s5
    80003228:	ffffd097          	auipc	ra,0xffffd
    8000322c:	fae080e7          	jalr	-82(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003230:	9cd6                	add	s9,s9,s5
    80003232:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003236:	84ce                	mv	s1,s3
    80003238:	b7bd                	j	800031a6 <namex+0xba>
  if(nameiparent){
    8000323a:	f00b0de3          	beqz	s6,80003154 <namex+0x68>
    iput(ip);
    8000323e:	8552                	mv	a0,s4
    80003240:	00000097          	auipc	ra,0x0
    80003244:	aba080e7          	jalr	-1350(ra) # 80002cfa <iput>
    return 0;
    80003248:	4a01                	li	s4,0
    8000324a:	b729                	j	80003154 <namex+0x68>

000000008000324c <dirlink>:
{
    8000324c:	7139                	addi	sp,sp,-64
    8000324e:	fc06                	sd	ra,56(sp)
    80003250:	f822                	sd	s0,48(sp)
    80003252:	f04a                	sd	s2,32(sp)
    80003254:	ec4e                	sd	s3,24(sp)
    80003256:	e852                	sd	s4,16(sp)
    80003258:	0080                	addi	s0,sp,64
    8000325a:	892a                	mv	s2,a0
    8000325c:	8a2e                	mv	s4,a1
    8000325e:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003260:	4601                	li	a2,0
    80003262:	00000097          	auipc	ra,0x0
    80003266:	dda080e7          	jalr	-550(ra) # 8000303c <dirlookup>
    8000326a:	ed25                	bnez	a0,800032e2 <dirlink+0x96>
    8000326c:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000326e:	04c92483          	lw	s1,76(s2)
    80003272:	c49d                	beqz	s1,800032a0 <dirlink+0x54>
    80003274:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003276:	4741                	li	a4,16
    80003278:	86a6                	mv	a3,s1
    8000327a:	fc040613          	addi	a2,s0,-64
    8000327e:	4581                	li	a1,0
    80003280:	854a                	mv	a0,s2
    80003282:	00000097          	auipc	ra,0x0
    80003286:	b72080e7          	jalr	-1166(ra) # 80002df4 <readi>
    8000328a:	47c1                	li	a5,16
    8000328c:	06f51163          	bne	a0,a5,800032ee <dirlink+0xa2>
    if(de.inum == 0)
    80003290:	fc045783          	lhu	a5,-64(s0)
    80003294:	c791                	beqz	a5,800032a0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003296:	24c1                	addiw	s1,s1,16
    80003298:	04c92783          	lw	a5,76(s2)
    8000329c:	fcf4ede3          	bltu	s1,a5,80003276 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800032a0:	4639                	li	a2,14
    800032a2:	85d2                	mv	a1,s4
    800032a4:	fc240513          	addi	a0,s0,-62
    800032a8:	ffffd097          	auipc	ra,0xffffd
    800032ac:	fd8080e7          	jalr	-40(ra) # 80000280 <strncpy>
  de.inum = inum;
    800032b0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032b4:	4741                	li	a4,16
    800032b6:	86a6                	mv	a3,s1
    800032b8:	fc040613          	addi	a2,s0,-64
    800032bc:	4581                	li	a1,0
    800032be:	854a                	mv	a0,s2
    800032c0:	00000097          	auipc	ra,0x0
    800032c4:	c38080e7          	jalr	-968(ra) # 80002ef8 <writei>
    800032c8:	872a                	mv	a4,a0
    800032ca:	47c1                	li	a5,16
  return 0;
    800032cc:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ce:	02f71863          	bne	a4,a5,800032fe <dirlink+0xb2>
    800032d2:	74a2                	ld	s1,40(sp)
}
    800032d4:	70e2                	ld	ra,56(sp)
    800032d6:	7442                	ld	s0,48(sp)
    800032d8:	7902                	ld	s2,32(sp)
    800032da:	69e2                	ld	s3,24(sp)
    800032dc:	6a42                	ld	s4,16(sp)
    800032de:	6121                	addi	sp,sp,64
    800032e0:	8082                	ret
    iput(ip);
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	a18080e7          	jalr	-1512(ra) # 80002cfa <iput>
    return -1;
    800032ea:	557d                	li	a0,-1
    800032ec:	b7e5                	j	800032d4 <dirlink+0x88>
      panic("dirlink read");
    800032ee:	00005517          	auipc	a0,0x5
    800032f2:	1aa50513          	addi	a0,a0,426 # 80008498 <etext+0x498>
    800032f6:	00003097          	auipc	ra,0x3
    800032fa:	9b6080e7          	jalr	-1610(ra) # 80005cac <panic>
    panic("dirlink");
    800032fe:	00005517          	auipc	a0,0x5
    80003302:	2aa50513          	addi	a0,a0,682 # 800085a8 <etext+0x5a8>
    80003306:	00003097          	auipc	ra,0x3
    8000330a:	9a6080e7          	jalr	-1626(ra) # 80005cac <panic>

000000008000330e <namei>:

struct inode*
namei(char *path)
{
    8000330e:	1101                	addi	sp,sp,-32
    80003310:	ec06                	sd	ra,24(sp)
    80003312:	e822                	sd	s0,16(sp)
    80003314:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003316:	fe040613          	addi	a2,s0,-32
    8000331a:	4581                	li	a1,0
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	dd0080e7          	jalr	-560(ra) # 800030ec <namex>
}
    80003324:	60e2                	ld	ra,24(sp)
    80003326:	6442                	ld	s0,16(sp)
    80003328:	6105                	addi	sp,sp,32
    8000332a:	8082                	ret

000000008000332c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000332c:	1141                	addi	sp,sp,-16
    8000332e:	e406                	sd	ra,8(sp)
    80003330:	e022                	sd	s0,0(sp)
    80003332:	0800                	addi	s0,sp,16
    80003334:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003336:	4585                	li	a1,1
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	db4080e7          	jalr	-588(ra) # 800030ec <namex>
}
    80003340:	60a2                	ld	ra,8(sp)
    80003342:	6402                	ld	s0,0(sp)
    80003344:	0141                	addi	sp,sp,16
    80003346:	8082                	ret

0000000080003348 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003348:	1101                	addi	sp,sp,-32
    8000334a:	ec06                	sd	ra,24(sp)
    8000334c:	e822                	sd	s0,16(sp)
    8000334e:	e426                	sd	s1,8(sp)
    80003350:	e04a                	sd	s2,0(sp)
    80003352:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003354:	00016917          	auipc	s2,0x16
    80003358:	ecc90913          	addi	s2,s2,-308 # 80019220 <log>
    8000335c:	01892583          	lw	a1,24(s2)
    80003360:	02892503          	lw	a0,40(s2)
    80003364:	fffff097          	auipc	ra,0xfffff
    80003368:	fde080e7          	jalr	-34(ra) # 80002342 <bread>
    8000336c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000336e:	02c92603          	lw	a2,44(s2)
    80003372:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003374:	00c05f63          	blez	a2,80003392 <write_head+0x4a>
    80003378:	00016717          	auipc	a4,0x16
    8000337c:	ed870713          	addi	a4,a4,-296 # 80019250 <log+0x30>
    80003380:	87aa                	mv	a5,a0
    80003382:	060a                	slli	a2,a2,0x2
    80003384:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003386:	4314                	lw	a3,0(a4)
    80003388:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000338a:	0711                	addi	a4,a4,4
    8000338c:	0791                	addi	a5,a5,4
    8000338e:	fec79ce3          	bne	a5,a2,80003386 <write_head+0x3e>
  }
  bwrite(buf);
    80003392:	8526                	mv	a0,s1
    80003394:	fffff097          	auipc	ra,0xfffff
    80003398:	0a0080e7          	jalr	160(ra) # 80002434 <bwrite>
  brelse(buf);
    8000339c:	8526                	mv	a0,s1
    8000339e:	fffff097          	auipc	ra,0xfffff
    800033a2:	0d4080e7          	jalr	212(ra) # 80002472 <brelse>
}
    800033a6:	60e2                	ld	ra,24(sp)
    800033a8:	6442                	ld	s0,16(sp)
    800033aa:	64a2                	ld	s1,8(sp)
    800033ac:	6902                	ld	s2,0(sp)
    800033ae:	6105                	addi	sp,sp,32
    800033b0:	8082                	ret

00000000800033b2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b2:	00016797          	auipc	a5,0x16
    800033b6:	e9a7a783          	lw	a5,-358(a5) # 8001924c <log+0x2c>
    800033ba:	0af05d63          	blez	a5,80003474 <install_trans+0xc2>
{
    800033be:	7139                	addi	sp,sp,-64
    800033c0:	fc06                	sd	ra,56(sp)
    800033c2:	f822                	sd	s0,48(sp)
    800033c4:	f426                	sd	s1,40(sp)
    800033c6:	f04a                	sd	s2,32(sp)
    800033c8:	ec4e                	sd	s3,24(sp)
    800033ca:	e852                	sd	s4,16(sp)
    800033cc:	e456                	sd	s5,8(sp)
    800033ce:	e05a                	sd	s6,0(sp)
    800033d0:	0080                	addi	s0,sp,64
    800033d2:	8b2a                	mv	s6,a0
    800033d4:	00016a97          	auipc	s5,0x16
    800033d8:	e7ca8a93          	addi	s5,s5,-388 # 80019250 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033dc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033de:	00016997          	auipc	s3,0x16
    800033e2:	e4298993          	addi	s3,s3,-446 # 80019220 <log>
    800033e6:	a00d                	j	80003408 <install_trans+0x56>
    brelse(lbuf);
    800033e8:	854a                	mv	a0,s2
    800033ea:	fffff097          	auipc	ra,0xfffff
    800033ee:	088080e7          	jalr	136(ra) # 80002472 <brelse>
    brelse(dbuf);
    800033f2:	8526                	mv	a0,s1
    800033f4:	fffff097          	auipc	ra,0xfffff
    800033f8:	07e080e7          	jalr	126(ra) # 80002472 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033fc:	2a05                	addiw	s4,s4,1
    800033fe:	0a91                	addi	s5,s5,4
    80003400:	02c9a783          	lw	a5,44(s3)
    80003404:	04fa5e63          	bge	s4,a5,80003460 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003408:	0189a583          	lw	a1,24(s3)
    8000340c:	014585bb          	addw	a1,a1,s4
    80003410:	2585                	addiw	a1,a1,1
    80003412:	0289a503          	lw	a0,40(s3)
    80003416:	fffff097          	auipc	ra,0xfffff
    8000341a:	f2c080e7          	jalr	-212(ra) # 80002342 <bread>
    8000341e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003420:	000aa583          	lw	a1,0(s5)
    80003424:	0289a503          	lw	a0,40(s3)
    80003428:	fffff097          	auipc	ra,0xfffff
    8000342c:	f1a080e7          	jalr	-230(ra) # 80002342 <bread>
    80003430:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003432:	40000613          	li	a2,1024
    80003436:	05890593          	addi	a1,s2,88
    8000343a:	05850513          	addi	a0,a0,88
    8000343e:	ffffd097          	auipc	ra,0xffffd
    80003442:	d98080e7          	jalr	-616(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003446:	8526                	mv	a0,s1
    80003448:	fffff097          	auipc	ra,0xfffff
    8000344c:	fec080e7          	jalr	-20(ra) # 80002434 <bwrite>
    if(recovering == 0)
    80003450:	f80b1ce3          	bnez	s6,800033e8 <install_trans+0x36>
      bunpin(dbuf);
    80003454:	8526                	mv	a0,s1
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	0f4080e7          	jalr	244(ra) # 8000254a <bunpin>
    8000345e:	b769                	j	800033e8 <install_trans+0x36>
}
    80003460:	70e2                	ld	ra,56(sp)
    80003462:	7442                	ld	s0,48(sp)
    80003464:	74a2                	ld	s1,40(sp)
    80003466:	7902                	ld	s2,32(sp)
    80003468:	69e2                	ld	s3,24(sp)
    8000346a:	6a42                	ld	s4,16(sp)
    8000346c:	6aa2                	ld	s5,8(sp)
    8000346e:	6b02                	ld	s6,0(sp)
    80003470:	6121                	addi	sp,sp,64
    80003472:	8082                	ret
    80003474:	8082                	ret

0000000080003476 <initlog>:
{
    80003476:	7179                	addi	sp,sp,-48
    80003478:	f406                	sd	ra,40(sp)
    8000347a:	f022                	sd	s0,32(sp)
    8000347c:	ec26                	sd	s1,24(sp)
    8000347e:	e84a                	sd	s2,16(sp)
    80003480:	e44e                	sd	s3,8(sp)
    80003482:	1800                	addi	s0,sp,48
    80003484:	892a                	mv	s2,a0
    80003486:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003488:	00016497          	auipc	s1,0x16
    8000348c:	d9848493          	addi	s1,s1,-616 # 80019220 <log>
    80003490:	00005597          	auipc	a1,0x5
    80003494:	01858593          	addi	a1,a1,24 # 800084a8 <etext+0x4a8>
    80003498:	8526                	mv	a0,s1
    8000349a:	00003097          	auipc	ra,0x3
    8000349e:	cfc080e7          	jalr	-772(ra) # 80006196 <initlock>
  log.start = sb->logstart;
    800034a2:	0149a583          	lw	a1,20(s3)
    800034a6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800034a8:	0109a783          	lw	a5,16(s3)
    800034ac:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800034ae:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800034b2:	854a                	mv	a0,s2
    800034b4:	fffff097          	auipc	ra,0xfffff
    800034b8:	e8e080e7          	jalr	-370(ra) # 80002342 <bread>
  log.lh.n = lh->n;
    800034bc:	4d30                	lw	a2,88(a0)
    800034be:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800034c0:	00c05f63          	blez	a2,800034de <initlog+0x68>
    800034c4:	87aa                	mv	a5,a0
    800034c6:	00016717          	auipc	a4,0x16
    800034ca:	d8a70713          	addi	a4,a4,-630 # 80019250 <log+0x30>
    800034ce:	060a                	slli	a2,a2,0x2
    800034d0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800034d2:	4ff4                	lw	a3,92(a5)
    800034d4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034d6:	0791                	addi	a5,a5,4
    800034d8:	0711                	addi	a4,a4,4
    800034da:	fec79ce3          	bne	a5,a2,800034d2 <initlog+0x5c>
  brelse(buf);
    800034de:	fffff097          	auipc	ra,0xfffff
    800034e2:	f94080e7          	jalr	-108(ra) # 80002472 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034e6:	4505                	li	a0,1
    800034e8:	00000097          	auipc	ra,0x0
    800034ec:	eca080e7          	jalr	-310(ra) # 800033b2 <install_trans>
  log.lh.n = 0;
    800034f0:	00016797          	auipc	a5,0x16
    800034f4:	d407ae23          	sw	zero,-676(a5) # 8001924c <log+0x2c>
  write_head(); // clear the log
    800034f8:	00000097          	auipc	ra,0x0
    800034fc:	e50080e7          	jalr	-432(ra) # 80003348 <write_head>
}
    80003500:	70a2                	ld	ra,40(sp)
    80003502:	7402                	ld	s0,32(sp)
    80003504:	64e2                	ld	s1,24(sp)
    80003506:	6942                	ld	s2,16(sp)
    80003508:	69a2                	ld	s3,8(sp)
    8000350a:	6145                	addi	sp,sp,48
    8000350c:	8082                	ret

000000008000350e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000350e:	1101                	addi	sp,sp,-32
    80003510:	ec06                	sd	ra,24(sp)
    80003512:	e822                	sd	s0,16(sp)
    80003514:	e426                	sd	s1,8(sp)
    80003516:	e04a                	sd	s2,0(sp)
    80003518:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000351a:	00016517          	auipc	a0,0x16
    8000351e:	d0650513          	addi	a0,a0,-762 # 80019220 <log>
    80003522:	00003097          	auipc	ra,0x3
    80003526:	d04080e7          	jalr	-764(ra) # 80006226 <acquire>
  while(1){
    if(log.committing){
    8000352a:	00016497          	auipc	s1,0x16
    8000352e:	cf648493          	addi	s1,s1,-778 # 80019220 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003532:	4979                	li	s2,30
    80003534:	a039                	j	80003542 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003536:	85a6                	mv	a1,s1
    80003538:	8526                	mv	a0,s1
    8000353a:	ffffe097          	auipc	ra,0xffffe
    8000353e:	088080e7          	jalr	136(ra) # 800015c2 <sleep>
    if(log.committing){
    80003542:	50dc                	lw	a5,36(s1)
    80003544:	fbed                	bnez	a5,80003536 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003546:	5098                	lw	a4,32(s1)
    80003548:	2705                	addiw	a4,a4,1
    8000354a:	0027179b          	slliw	a5,a4,0x2
    8000354e:	9fb9                	addw	a5,a5,a4
    80003550:	0017979b          	slliw	a5,a5,0x1
    80003554:	54d4                	lw	a3,44(s1)
    80003556:	9fb5                	addw	a5,a5,a3
    80003558:	00f95963          	bge	s2,a5,8000356a <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000355c:	85a6                	mv	a1,s1
    8000355e:	8526                	mv	a0,s1
    80003560:	ffffe097          	auipc	ra,0xffffe
    80003564:	062080e7          	jalr	98(ra) # 800015c2 <sleep>
    80003568:	bfe9                	j	80003542 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000356a:	00016517          	auipc	a0,0x16
    8000356e:	cb650513          	addi	a0,a0,-842 # 80019220 <log>
    80003572:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003574:	00003097          	auipc	ra,0x3
    80003578:	d66080e7          	jalr	-666(ra) # 800062da <release>
      break;
    }
  }
}
    8000357c:	60e2                	ld	ra,24(sp)
    8000357e:	6442                	ld	s0,16(sp)
    80003580:	64a2                	ld	s1,8(sp)
    80003582:	6902                	ld	s2,0(sp)
    80003584:	6105                	addi	sp,sp,32
    80003586:	8082                	ret

0000000080003588 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003588:	7139                	addi	sp,sp,-64
    8000358a:	fc06                	sd	ra,56(sp)
    8000358c:	f822                	sd	s0,48(sp)
    8000358e:	f426                	sd	s1,40(sp)
    80003590:	f04a                	sd	s2,32(sp)
    80003592:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003594:	00016497          	auipc	s1,0x16
    80003598:	c8c48493          	addi	s1,s1,-884 # 80019220 <log>
    8000359c:	8526                	mv	a0,s1
    8000359e:	00003097          	auipc	ra,0x3
    800035a2:	c88080e7          	jalr	-888(ra) # 80006226 <acquire>
  log.outstanding -= 1;
    800035a6:	509c                	lw	a5,32(s1)
    800035a8:	37fd                	addiw	a5,a5,-1
    800035aa:	0007891b          	sext.w	s2,a5
    800035ae:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800035b0:	50dc                	lw	a5,36(s1)
    800035b2:	e7b9                	bnez	a5,80003600 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800035b4:	06091163          	bnez	s2,80003616 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800035b8:	00016497          	auipc	s1,0x16
    800035bc:	c6848493          	addi	s1,s1,-920 # 80019220 <log>
    800035c0:	4785                	li	a5,1
    800035c2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800035c4:	8526                	mv	a0,s1
    800035c6:	00003097          	auipc	ra,0x3
    800035ca:	d14080e7          	jalr	-748(ra) # 800062da <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035ce:	54dc                	lw	a5,44(s1)
    800035d0:	06f04763          	bgtz	a5,8000363e <end_op+0xb6>
    acquire(&log.lock);
    800035d4:	00016497          	auipc	s1,0x16
    800035d8:	c4c48493          	addi	s1,s1,-948 # 80019220 <log>
    800035dc:	8526                	mv	a0,s1
    800035de:	00003097          	auipc	ra,0x3
    800035e2:	c48080e7          	jalr	-952(ra) # 80006226 <acquire>
    log.committing = 0;
    800035e6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035ea:	8526                	mv	a0,s1
    800035ec:	ffffe097          	auipc	ra,0xffffe
    800035f0:	162080e7          	jalr	354(ra) # 8000174e <wakeup>
    release(&log.lock);
    800035f4:	8526                	mv	a0,s1
    800035f6:	00003097          	auipc	ra,0x3
    800035fa:	ce4080e7          	jalr	-796(ra) # 800062da <release>
}
    800035fe:	a815                	j	80003632 <end_op+0xaa>
    80003600:	ec4e                	sd	s3,24(sp)
    80003602:	e852                	sd	s4,16(sp)
    80003604:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003606:	00005517          	auipc	a0,0x5
    8000360a:	eaa50513          	addi	a0,a0,-342 # 800084b0 <etext+0x4b0>
    8000360e:	00002097          	auipc	ra,0x2
    80003612:	69e080e7          	jalr	1694(ra) # 80005cac <panic>
    wakeup(&log);
    80003616:	00016497          	auipc	s1,0x16
    8000361a:	c0a48493          	addi	s1,s1,-1014 # 80019220 <log>
    8000361e:	8526                	mv	a0,s1
    80003620:	ffffe097          	auipc	ra,0xffffe
    80003624:	12e080e7          	jalr	302(ra) # 8000174e <wakeup>
  release(&log.lock);
    80003628:	8526                	mv	a0,s1
    8000362a:	00003097          	auipc	ra,0x3
    8000362e:	cb0080e7          	jalr	-848(ra) # 800062da <release>
}
    80003632:	70e2                	ld	ra,56(sp)
    80003634:	7442                	ld	s0,48(sp)
    80003636:	74a2                	ld	s1,40(sp)
    80003638:	7902                	ld	s2,32(sp)
    8000363a:	6121                	addi	sp,sp,64
    8000363c:	8082                	ret
    8000363e:	ec4e                	sd	s3,24(sp)
    80003640:	e852                	sd	s4,16(sp)
    80003642:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003644:	00016a97          	auipc	s5,0x16
    80003648:	c0ca8a93          	addi	s5,s5,-1012 # 80019250 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000364c:	00016a17          	auipc	s4,0x16
    80003650:	bd4a0a13          	addi	s4,s4,-1068 # 80019220 <log>
    80003654:	018a2583          	lw	a1,24(s4)
    80003658:	012585bb          	addw	a1,a1,s2
    8000365c:	2585                	addiw	a1,a1,1
    8000365e:	028a2503          	lw	a0,40(s4)
    80003662:	fffff097          	auipc	ra,0xfffff
    80003666:	ce0080e7          	jalr	-800(ra) # 80002342 <bread>
    8000366a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000366c:	000aa583          	lw	a1,0(s5)
    80003670:	028a2503          	lw	a0,40(s4)
    80003674:	fffff097          	auipc	ra,0xfffff
    80003678:	cce080e7          	jalr	-818(ra) # 80002342 <bread>
    8000367c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000367e:	40000613          	li	a2,1024
    80003682:	05850593          	addi	a1,a0,88
    80003686:	05848513          	addi	a0,s1,88
    8000368a:	ffffd097          	auipc	ra,0xffffd
    8000368e:	b4c080e7          	jalr	-1204(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003692:	8526                	mv	a0,s1
    80003694:	fffff097          	auipc	ra,0xfffff
    80003698:	da0080e7          	jalr	-608(ra) # 80002434 <bwrite>
    brelse(from);
    8000369c:	854e                	mv	a0,s3
    8000369e:	fffff097          	auipc	ra,0xfffff
    800036a2:	dd4080e7          	jalr	-556(ra) # 80002472 <brelse>
    brelse(to);
    800036a6:	8526                	mv	a0,s1
    800036a8:	fffff097          	auipc	ra,0xfffff
    800036ac:	dca080e7          	jalr	-566(ra) # 80002472 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036b0:	2905                	addiw	s2,s2,1
    800036b2:	0a91                	addi	s5,s5,4
    800036b4:	02ca2783          	lw	a5,44(s4)
    800036b8:	f8f94ee3          	blt	s2,a5,80003654 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800036bc:	00000097          	auipc	ra,0x0
    800036c0:	c8c080e7          	jalr	-884(ra) # 80003348 <write_head>
    install_trans(0); // Now install writes to home locations
    800036c4:	4501                	li	a0,0
    800036c6:	00000097          	auipc	ra,0x0
    800036ca:	cec080e7          	jalr	-788(ra) # 800033b2 <install_trans>
    log.lh.n = 0;
    800036ce:	00016797          	auipc	a5,0x16
    800036d2:	b607af23          	sw	zero,-1154(a5) # 8001924c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036d6:	00000097          	auipc	ra,0x0
    800036da:	c72080e7          	jalr	-910(ra) # 80003348 <write_head>
    800036de:	69e2                	ld	s3,24(sp)
    800036e0:	6a42                	ld	s4,16(sp)
    800036e2:	6aa2                	ld	s5,8(sp)
    800036e4:	bdc5                	j	800035d4 <end_op+0x4c>

00000000800036e6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036e6:	1101                	addi	sp,sp,-32
    800036e8:	ec06                	sd	ra,24(sp)
    800036ea:	e822                	sd	s0,16(sp)
    800036ec:	e426                	sd	s1,8(sp)
    800036ee:	e04a                	sd	s2,0(sp)
    800036f0:	1000                	addi	s0,sp,32
    800036f2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036f4:	00016917          	auipc	s2,0x16
    800036f8:	b2c90913          	addi	s2,s2,-1236 # 80019220 <log>
    800036fc:	854a                	mv	a0,s2
    800036fe:	00003097          	auipc	ra,0x3
    80003702:	b28080e7          	jalr	-1240(ra) # 80006226 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003706:	02c92603          	lw	a2,44(s2)
    8000370a:	47f5                	li	a5,29
    8000370c:	06c7c563          	blt	a5,a2,80003776 <log_write+0x90>
    80003710:	00016797          	auipc	a5,0x16
    80003714:	b2c7a783          	lw	a5,-1236(a5) # 8001923c <log+0x1c>
    80003718:	37fd                	addiw	a5,a5,-1
    8000371a:	04f65e63          	bge	a2,a5,80003776 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000371e:	00016797          	auipc	a5,0x16
    80003722:	b227a783          	lw	a5,-1246(a5) # 80019240 <log+0x20>
    80003726:	06f05063          	blez	a5,80003786 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000372a:	4781                	li	a5,0
    8000372c:	06c05563          	blez	a2,80003796 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003730:	44cc                	lw	a1,12(s1)
    80003732:	00016717          	auipc	a4,0x16
    80003736:	b1e70713          	addi	a4,a4,-1250 # 80019250 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000373a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000373c:	4314                	lw	a3,0(a4)
    8000373e:	04b68c63          	beq	a3,a1,80003796 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003742:	2785                	addiw	a5,a5,1
    80003744:	0711                	addi	a4,a4,4
    80003746:	fef61be3          	bne	a2,a5,8000373c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000374a:	0621                	addi	a2,a2,8
    8000374c:	060a                	slli	a2,a2,0x2
    8000374e:	00016797          	auipc	a5,0x16
    80003752:	ad278793          	addi	a5,a5,-1326 # 80019220 <log>
    80003756:	97b2                	add	a5,a5,a2
    80003758:	44d8                	lw	a4,12(s1)
    8000375a:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000375c:	8526                	mv	a0,s1
    8000375e:	fffff097          	auipc	ra,0xfffff
    80003762:	db0080e7          	jalr	-592(ra) # 8000250e <bpin>
    log.lh.n++;
    80003766:	00016717          	auipc	a4,0x16
    8000376a:	aba70713          	addi	a4,a4,-1350 # 80019220 <log>
    8000376e:	575c                	lw	a5,44(a4)
    80003770:	2785                	addiw	a5,a5,1
    80003772:	d75c                	sw	a5,44(a4)
    80003774:	a82d                	j	800037ae <log_write+0xc8>
    panic("too big a transaction");
    80003776:	00005517          	auipc	a0,0x5
    8000377a:	d4a50513          	addi	a0,a0,-694 # 800084c0 <etext+0x4c0>
    8000377e:	00002097          	auipc	ra,0x2
    80003782:	52e080e7          	jalr	1326(ra) # 80005cac <panic>
    panic("log_write outside of trans");
    80003786:	00005517          	auipc	a0,0x5
    8000378a:	d5250513          	addi	a0,a0,-686 # 800084d8 <etext+0x4d8>
    8000378e:	00002097          	auipc	ra,0x2
    80003792:	51e080e7          	jalr	1310(ra) # 80005cac <panic>
  log.lh.block[i] = b->blockno;
    80003796:	00878693          	addi	a3,a5,8
    8000379a:	068a                	slli	a3,a3,0x2
    8000379c:	00016717          	auipc	a4,0x16
    800037a0:	a8470713          	addi	a4,a4,-1404 # 80019220 <log>
    800037a4:	9736                	add	a4,a4,a3
    800037a6:	44d4                	lw	a3,12(s1)
    800037a8:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800037aa:	faf609e3          	beq	a2,a5,8000375c <log_write+0x76>
  }
  release(&log.lock);
    800037ae:	00016517          	auipc	a0,0x16
    800037b2:	a7250513          	addi	a0,a0,-1422 # 80019220 <log>
    800037b6:	00003097          	auipc	ra,0x3
    800037ba:	b24080e7          	jalr	-1244(ra) # 800062da <release>
}
    800037be:	60e2                	ld	ra,24(sp)
    800037c0:	6442                	ld	s0,16(sp)
    800037c2:	64a2                	ld	s1,8(sp)
    800037c4:	6902                	ld	s2,0(sp)
    800037c6:	6105                	addi	sp,sp,32
    800037c8:	8082                	ret

00000000800037ca <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037ca:	1101                	addi	sp,sp,-32
    800037cc:	ec06                	sd	ra,24(sp)
    800037ce:	e822                	sd	s0,16(sp)
    800037d0:	e426                	sd	s1,8(sp)
    800037d2:	e04a                	sd	s2,0(sp)
    800037d4:	1000                	addi	s0,sp,32
    800037d6:	84aa                	mv	s1,a0
    800037d8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037da:	00005597          	auipc	a1,0x5
    800037de:	d1e58593          	addi	a1,a1,-738 # 800084f8 <etext+0x4f8>
    800037e2:	0521                	addi	a0,a0,8
    800037e4:	00003097          	auipc	ra,0x3
    800037e8:	9b2080e7          	jalr	-1614(ra) # 80006196 <initlock>
  lk->name = name;
    800037ec:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037f0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037f4:	0204a423          	sw	zero,40(s1)
}
    800037f8:	60e2                	ld	ra,24(sp)
    800037fa:	6442                	ld	s0,16(sp)
    800037fc:	64a2                	ld	s1,8(sp)
    800037fe:	6902                	ld	s2,0(sp)
    80003800:	6105                	addi	sp,sp,32
    80003802:	8082                	ret

0000000080003804 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003804:	1101                	addi	sp,sp,-32
    80003806:	ec06                	sd	ra,24(sp)
    80003808:	e822                	sd	s0,16(sp)
    8000380a:	e426                	sd	s1,8(sp)
    8000380c:	e04a                	sd	s2,0(sp)
    8000380e:	1000                	addi	s0,sp,32
    80003810:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003812:	00850913          	addi	s2,a0,8
    80003816:	854a                	mv	a0,s2
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	a0e080e7          	jalr	-1522(ra) # 80006226 <acquire>
  while (lk->locked) {
    80003820:	409c                	lw	a5,0(s1)
    80003822:	cb89                	beqz	a5,80003834 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003824:	85ca                	mv	a1,s2
    80003826:	8526                	mv	a0,s1
    80003828:	ffffe097          	auipc	ra,0xffffe
    8000382c:	d9a080e7          	jalr	-614(ra) # 800015c2 <sleep>
  while (lk->locked) {
    80003830:	409c                	lw	a5,0(s1)
    80003832:	fbed                	bnez	a5,80003824 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003834:	4785                	li	a5,1
    80003836:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003838:	ffffd097          	auipc	ra,0xffffd
    8000383c:	640080e7          	jalr	1600(ra) # 80000e78 <myproc>
    80003840:	591c                	lw	a5,48(a0)
    80003842:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003844:	854a                	mv	a0,s2
    80003846:	00003097          	auipc	ra,0x3
    8000384a:	a94080e7          	jalr	-1388(ra) # 800062da <release>
}
    8000384e:	60e2                	ld	ra,24(sp)
    80003850:	6442                	ld	s0,16(sp)
    80003852:	64a2                	ld	s1,8(sp)
    80003854:	6902                	ld	s2,0(sp)
    80003856:	6105                	addi	sp,sp,32
    80003858:	8082                	ret

000000008000385a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000385a:	1101                	addi	sp,sp,-32
    8000385c:	ec06                	sd	ra,24(sp)
    8000385e:	e822                	sd	s0,16(sp)
    80003860:	e426                	sd	s1,8(sp)
    80003862:	e04a                	sd	s2,0(sp)
    80003864:	1000                	addi	s0,sp,32
    80003866:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003868:	00850913          	addi	s2,a0,8
    8000386c:	854a                	mv	a0,s2
    8000386e:	00003097          	auipc	ra,0x3
    80003872:	9b8080e7          	jalr	-1608(ra) # 80006226 <acquire>
  lk->locked = 0;
    80003876:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000387a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000387e:	8526                	mv	a0,s1
    80003880:	ffffe097          	auipc	ra,0xffffe
    80003884:	ece080e7          	jalr	-306(ra) # 8000174e <wakeup>
  release(&lk->lk);
    80003888:	854a                	mv	a0,s2
    8000388a:	00003097          	auipc	ra,0x3
    8000388e:	a50080e7          	jalr	-1456(ra) # 800062da <release>
}
    80003892:	60e2                	ld	ra,24(sp)
    80003894:	6442                	ld	s0,16(sp)
    80003896:	64a2                	ld	s1,8(sp)
    80003898:	6902                	ld	s2,0(sp)
    8000389a:	6105                	addi	sp,sp,32
    8000389c:	8082                	ret

000000008000389e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000389e:	7179                	addi	sp,sp,-48
    800038a0:	f406                	sd	ra,40(sp)
    800038a2:	f022                	sd	s0,32(sp)
    800038a4:	ec26                	sd	s1,24(sp)
    800038a6:	e84a                	sd	s2,16(sp)
    800038a8:	1800                	addi	s0,sp,48
    800038aa:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800038ac:	00850913          	addi	s2,a0,8
    800038b0:	854a                	mv	a0,s2
    800038b2:	00003097          	auipc	ra,0x3
    800038b6:	974080e7          	jalr	-1676(ra) # 80006226 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800038ba:	409c                	lw	a5,0(s1)
    800038bc:	ef91                	bnez	a5,800038d8 <holdingsleep+0x3a>
    800038be:	4481                	li	s1,0
  release(&lk->lk);
    800038c0:	854a                	mv	a0,s2
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	a18080e7          	jalr	-1512(ra) # 800062da <release>
  return r;
}
    800038ca:	8526                	mv	a0,s1
    800038cc:	70a2                	ld	ra,40(sp)
    800038ce:	7402                	ld	s0,32(sp)
    800038d0:	64e2                	ld	s1,24(sp)
    800038d2:	6942                	ld	s2,16(sp)
    800038d4:	6145                	addi	sp,sp,48
    800038d6:	8082                	ret
    800038d8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800038da:	0284a983          	lw	s3,40(s1)
    800038de:	ffffd097          	auipc	ra,0xffffd
    800038e2:	59a080e7          	jalr	1434(ra) # 80000e78 <myproc>
    800038e6:	5904                	lw	s1,48(a0)
    800038e8:	413484b3          	sub	s1,s1,s3
    800038ec:	0014b493          	seqz	s1,s1
    800038f0:	69a2                	ld	s3,8(sp)
    800038f2:	b7f9                	j	800038c0 <holdingsleep+0x22>

00000000800038f4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038f4:	1141                	addi	sp,sp,-16
    800038f6:	e406                	sd	ra,8(sp)
    800038f8:	e022                	sd	s0,0(sp)
    800038fa:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038fc:	00005597          	auipc	a1,0x5
    80003900:	c0c58593          	addi	a1,a1,-1012 # 80008508 <etext+0x508>
    80003904:	00016517          	auipc	a0,0x16
    80003908:	a6450513          	addi	a0,a0,-1436 # 80019368 <ftable>
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	88a080e7          	jalr	-1910(ra) # 80006196 <initlock>
}
    80003914:	60a2                	ld	ra,8(sp)
    80003916:	6402                	ld	s0,0(sp)
    80003918:	0141                	addi	sp,sp,16
    8000391a:	8082                	ret

000000008000391c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	e426                	sd	s1,8(sp)
    80003924:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003926:	00016517          	auipc	a0,0x16
    8000392a:	a4250513          	addi	a0,a0,-1470 # 80019368 <ftable>
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	8f8080e7          	jalr	-1800(ra) # 80006226 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003936:	00016497          	auipc	s1,0x16
    8000393a:	a4a48493          	addi	s1,s1,-1462 # 80019380 <ftable+0x18>
    8000393e:	00017717          	auipc	a4,0x17
    80003942:	9e270713          	addi	a4,a4,-1566 # 8001a320 <ftable+0xfb8>
    if(f->ref == 0){
    80003946:	40dc                	lw	a5,4(s1)
    80003948:	cf99                	beqz	a5,80003966 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000394a:	02848493          	addi	s1,s1,40
    8000394e:	fee49ce3          	bne	s1,a4,80003946 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003952:	00016517          	auipc	a0,0x16
    80003956:	a1650513          	addi	a0,a0,-1514 # 80019368 <ftable>
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	980080e7          	jalr	-1664(ra) # 800062da <release>
  return 0;
    80003962:	4481                	li	s1,0
    80003964:	a819                	j	8000397a <filealloc+0x5e>
      f->ref = 1;
    80003966:	4785                	li	a5,1
    80003968:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000396a:	00016517          	auipc	a0,0x16
    8000396e:	9fe50513          	addi	a0,a0,-1538 # 80019368 <ftable>
    80003972:	00003097          	auipc	ra,0x3
    80003976:	968080e7          	jalr	-1688(ra) # 800062da <release>
}
    8000397a:	8526                	mv	a0,s1
    8000397c:	60e2                	ld	ra,24(sp)
    8000397e:	6442                	ld	s0,16(sp)
    80003980:	64a2                	ld	s1,8(sp)
    80003982:	6105                	addi	sp,sp,32
    80003984:	8082                	ret

0000000080003986 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003986:	1101                	addi	sp,sp,-32
    80003988:	ec06                	sd	ra,24(sp)
    8000398a:	e822                	sd	s0,16(sp)
    8000398c:	e426                	sd	s1,8(sp)
    8000398e:	1000                	addi	s0,sp,32
    80003990:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003992:	00016517          	auipc	a0,0x16
    80003996:	9d650513          	addi	a0,a0,-1578 # 80019368 <ftable>
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	88c080e7          	jalr	-1908(ra) # 80006226 <acquire>
  if(f->ref < 1)
    800039a2:	40dc                	lw	a5,4(s1)
    800039a4:	02f05263          	blez	a5,800039c8 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800039a8:	2785                	addiw	a5,a5,1
    800039aa:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800039ac:	00016517          	auipc	a0,0x16
    800039b0:	9bc50513          	addi	a0,a0,-1604 # 80019368 <ftable>
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	926080e7          	jalr	-1754(ra) # 800062da <release>
  return f;
}
    800039bc:	8526                	mv	a0,s1
    800039be:	60e2                	ld	ra,24(sp)
    800039c0:	6442                	ld	s0,16(sp)
    800039c2:	64a2                	ld	s1,8(sp)
    800039c4:	6105                	addi	sp,sp,32
    800039c6:	8082                	ret
    panic("filedup");
    800039c8:	00005517          	auipc	a0,0x5
    800039cc:	b4850513          	addi	a0,a0,-1208 # 80008510 <etext+0x510>
    800039d0:	00002097          	auipc	ra,0x2
    800039d4:	2dc080e7          	jalr	732(ra) # 80005cac <panic>

00000000800039d8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039d8:	7139                	addi	sp,sp,-64
    800039da:	fc06                	sd	ra,56(sp)
    800039dc:	f822                	sd	s0,48(sp)
    800039de:	f426                	sd	s1,40(sp)
    800039e0:	0080                	addi	s0,sp,64
    800039e2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039e4:	00016517          	auipc	a0,0x16
    800039e8:	98450513          	addi	a0,a0,-1660 # 80019368 <ftable>
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	83a080e7          	jalr	-1990(ra) # 80006226 <acquire>
  if(f->ref < 1)
    800039f4:	40dc                	lw	a5,4(s1)
    800039f6:	04f05c63          	blez	a5,80003a4e <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    800039fa:	37fd                	addiw	a5,a5,-1
    800039fc:	0007871b          	sext.w	a4,a5
    80003a00:	c0dc                	sw	a5,4(s1)
    80003a02:	06e04263          	bgtz	a4,80003a66 <fileclose+0x8e>
    80003a06:	f04a                	sd	s2,32(sp)
    80003a08:	ec4e                	sd	s3,24(sp)
    80003a0a:	e852                	sd	s4,16(sp)
    80003a0c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a0e:	0004a903          	lw	s2,0(s1)
    80003a12:	0094ca83          	lbu	s5,9(s1)
    80003a16:	0104ba03          	ld	s4,16(s1)
    80003a1a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003a1e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003a22:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003a26:	00016517          	auipc	a0,0x16
    80003a2a:	94250513          	addi	a0,a0,-1726 # 80019368 <ftable>
    80003a2e:	00003097          	auipc	ra,0x3
    80003a32:	8ac080e7          	jalr	-1876(ra) # 800062da <release>

  if(ff.type == FD_PIPE){
    80003a36:	4785                	li	a5,1
    80003a38:	04f90463          	beq	s2,a5,80003a80 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a3c:	3979                	addiw	s2,s2,-2
    80003a3e:	4785                	li	a5,1
    80003a40:	0527fb63          	bgeu	a5,s2,80003a96 <fileclose+0xbe>
    80003a44:	7902                	ld	s2,32(sp)
    80003a46:	69e2                	ld	s3,24(sp)
    80003a48:	6a42                	ld	s4,16(sp)
    80003a4a:	6aa2                	ld	s5,8(sp)
    80003a4c:	a02d                	j	80003a76 <fileclose+0x9e>
    80003a4e:	f04a                	sd	s2,32(sp)
    80003a50:	ec4e                	sd	s3,24(sp)
    80003a52:	e852                	sd	s4,16(sp)
    80003a54:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003a56:	00005517          	auipc	a0,0x5
    80003a5a:	ac250513          	addi	a0,a0,-1342 # 80008518 <etext+0x518>
    80003a5e:	00002097          	auipc	ra,0x2
    80003a62:	24e080e7          	jalr	590(ra) # 80005cac <panic>
    release(&ftable.lock);
    80003a66:	00016517          	auipc	a0,0x16
    80003a6a:	90250513          	addi	a0,a0,-1790 # 80019368 <ftable>
    80003a6e:	00003097          	auipc	ra,0x3
    80003a72:	86c080e7          	jalr	-1940(ra) # 800062da <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003a76:	70e2                	ld	ra,56(sp)
    80003a78:	7442                	ld	s0,48(sp)
    80003a7a:	74a2                	ld	s1,40(sp)
    80003a7c:	6121                	addi	sp,sp,64
    80003a7e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a80:	85d6                	mv	a1,s5
    80003a82:	8552                	mv	a0,s4
    80003a84:	00000097          	auipc	ra,0x0
    80003a88:	3a2080e7          	jalr	930(ra) # 80003e26 <pipeclose>
    80003a8c:	7902                	ld	s2,32(sp)
    80003a8e:	69e2                	ld	s3,24(sp)
    80003a90:	6a42                	ld	s4,16(sp)
    80003a92:	6aa2                	ld	s5,8(sp)
    80003a94:	b7cd                	j	80003a76 <fileclose+0x9e>
    begin_op();
    80003a96:	00000097          	auipc	ra,0x0
    80003a9a:	a78080e7          	jalr	-1416(ra) # 8000350e <begin_op>
    iput(ff.ip);
    80003a9e:	854e                	mv	a0,s3
    80003aa0:	fffff097          	auipc	ra,0xfffff
    80003aa4:	25a080e7          	jalr	602(ra) # 80002cfa <iput>
    end_op();
    80003aa8:	00000097          	auipc	ra,0x0
    80003aac:	ae0080e7          	jalr	-1312(ra) # 80003588 <end_op>
    80003ab0:	7902                	ld	s2,32(sp)
    80003ab2:	69e2                	ld	s3,24(sp)
    80003ab4:	6a42                	ld	s4,16(sp)
    80003ab6:	6aa2                	ld	s5,8(sp)
    80003ab8:	bf7d                	j	80003a76 <fileclose+0x9e>

0000000080003aba <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003aba:	715d                	addi	sp,sp,-80
    80003abc:	e486                	sd	ra,72(sp)
    80003abe:	e0a2                	sd	s0,64(sp)
    80003ac0:	fc26                	sd	s1,56(sp)
    80003ac2:	f44e                	sd	s3,40(sp)
    80003ac4:	0880                	addi	s0,sp,80
    80003ac6:	84aa                	mv	s1,a0
    80003ac8:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aca:	ffffd097          	auipc	ra,0xffffd
    80003ace:	3ae080e7          	jalr	942(ra) # 80000e78 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003ad2:	409c                	lw	a5,0(s1)
    80003ad4:	37f9                	addiw	a5,a5,-2
    80003ad6:	4705                	li	a4,1
    80003ad8:	04f76863          	bltu	a4,a5,80003b28 <filestat+0x6e>
    80003adc:	f84a                	sd	s2,48(sp)
    80003ade:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ae0:	6c88                	ld	a0,24(s1)
    80003ae2:	fffff097          	auipc	ra,0xfffff
    80003ae6:	05a080e7          	jalr	90(ra) # 80002b3c <ilock>
    stati(f->ip, &st);
    80003aea:	fb840593          	addi	a1,s0,-72
    80003aee:	6c88                	ld	a0,24(s1)
    80003af0:	fffff097          	auipc	ra,0xfffff
    80003af4:	2da080e7          	jalr	730(ra) # 80002dca <stati>
    iunlock(f->ip);
    80003af8:	6c88                	ld	a0,24(s1)
    80003afa:	fffff097          	auipc	ra,0xfffff
    80003afe:	108080e7          	jalr	264(ra) # 80002c02 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b02:	46e1                	li	a3,24
    80003b04:	fb840613          	addi	a2,s0,-72
    80003b08:	85ce                	mv	a1,s3
    80003b0a:	05093503          	ld	a0,80(s2)
    80003b0e:	ffffd097          	auipc	ra,0xffffd
    80003b12:	00a080e7          	jalr	10(ra) # 80000b18 <copyout>
    80003b16:	41f5551b          	sraiw	a0,a0,0x1f
    80003b1a:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003b1c:	60a6                	ld	ra,72(sp)
    80003b1e:	6406                	ld	s0,64(sp)
    80003b20:	74e2                	ld	s1,56(sp)
    80003b22:	79a2                	ld	s3,40(sp)
    80003b24:	6161                	addi	sp,sp,80
    80003b26:	8082                	ret
  return -1;
    80003b28:	557d                	li	a0,-1
    80003b2a:	bfcd                	j	80003b1c <filestat+0x62>

0000000080003b2c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b2c:	7179                	addi	sp,sp,-48
    80003b2e:	f406                	sd	ra,40(sp)
    80003b30:	f022                	sd	s0,32(sp)
    80003b32:	e84a                	sd	s2,16(sp)
    80003b34:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b36:	00854783          	lbu	a5,8(a0)
    80003b3a:	cbc5                	beqz	a5,80003bea <fileread+0xbe>
    80003b3c:	ec26                	sd	s1,24(sp)
    80003b3e:	e44e                	sd	s3,8(sp)
    80003b40:	84aa                	mv	s1,a0
    80003b42:	89ae                	mv	s3,a1
    80003b44:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b46:	411c                	lw	a5,0(a0)
    80003b48:	4705                	li	a4,1
    80003b4a:	04e78963          	beq	a5,a4,80003b9c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b4e:	470d                	li	a4,3
    80003b50:	04e78f63          	beq	a5,a4,80003bae <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b54:	4709                	li	a4,2
    80003b56:	08e79263          	bne	a5,a4,80003bda <fileread+0xae>
    ilock(f->ip);
    80003b5a:	6d08                	ld	a0,24(a0)
    80003b5c:	fffff097          	auipc	ra,0xfffff
    80003b60:	fe0080e7          	jalr	-32(ra) # 80002b3c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b64:	874a                	mv	a4,s2
    80003b66:	5094                	lw	a3,32(s1)
    80003b68:	864e                	mv	a2,s3
    80003b6a:	4585                	li	a1,1
    80003b6c:	6c88                	ld	a0,24(s1)
    80003b6e:	fffff097          	auipc	ra,0xfffff
    80003b72:	286080e7          	jalr	646(ra) # 80002df4 <readi>
    80003b76:	892a                	mv	s2,a0
    80003b78:	00a05563          	blez	a0,80003b82 <fileread+0x56>
      f->off += r;
    80003b7c:	509c                	lw	a5,32(s1)
    80003b7e:	9fa9                	addw	a5,a5,a0
    80003b80:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b82:	6c88                	ld	a0,24(s1)
    80003b84:	fffff097          	auipc	ra,0xfffff
    80003b88:	07e080e7          	jalr	126(ra) # 80002c02 <iunlock>
    80003b8c:	64e2                	ld	s1,24(sp)
    80003b8e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003b90:	854a                	mv	a0,s2
    80003b92:	70a2                	ld	ra,40(sp)
    80003b94:	7402                	ld	s0,32(sp)
    80003b96:	6942                	ld	s2,16(sp)
    80003b98:	6145                	addi	sp,sp,48
    80003b9a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b9c:	6908                	ld	a0,16(a0)
    80003b9e:	00000097          	auipc	ra,0x0
    80003ba2:	3fa080e7          	jalr	1018(ra) # 80003f98 <piperead>
    80003ba6:	892a                	mv	s2,a0
    80003ba8:	64e2                	ld	s1,24(sp)
    80003baa:	69a2                	ld	s3,8(sp)
    80003bac:	b7d5                	j	80003b90 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003bae:	02451783          	lh	a5,36(a0)
    80003bb2:	03079693          	slli	a3,a5,0x30
    80003bb6:	92c1                	srli	a3,a3,0x30
    80003bb8:	4725                	li	a4,9
    80003bba:	02d76a63          	bltu	a4,a3,80003bee <fileread+0xc2>
    80003bbe:	0792                	slli	a5,a5,0x4
    80003bc0:	00015717          	auipc	a4,0x15
    80003bc4:	70870713          	addi	a4,a4,1800 # 800192c8 <devsw>
    80003bc8:	97ba                	add	a5,a5,a4
    80003bca:	639c                	ld	a5,0(a5)
    80003bcc:	c78d                	beqz	a5,80003bf6 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003bce:	4505                	li	a0,1
    80003bd0:	9782                	jalr	a5
    80003bd2:	892a                	mv	s2,a0
    80003bd4:	64e2                	ld	s1,24(sp)
    80003bd6:	69a2                	ld	s3,8(sp)
    80003bd8:	bf65                	j	80003b90 <fileread+0x64>
    panic("fileread");
    80003bda:	00005517          	auipc	a0,0x5
    80003bde:	94e50513          	addi	a0,a0,-1714 # 80008528 <etext+0x528>
    80003be2:	00002097          	auipc	ra,0x2
    80003be6:	0ca080e7          	jalr	202(ra) # 80005cac <panic>
    return -1;
    80003bea:	597d                	li	s2,-1
    80003bec:	b755                	j	80003b90 <fileread+0x64>
      return -1;
    80003bee:	597d                	li	s2,-1
    80003bf0:	64e2                	ld	s1,24(sp)
    80003bf2:	69a2                	ld	s3,8(sp)
    80003bf4:	bf71                	j	80003b90 <fileread+0x64>
    80003bf6:	597d                	li	s2,-1
    80003bf8:	64e2                	ld	s1,24(sp)
    80003bfa:	69a2                	ld	s3,8(sp)
    80003bfc:	bf51                	j	80003b90 <fileread+0x64>

0000000080003bfe <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003bfe:	00954783          	lbu	a5,9(a0)
    80003c02:	12078963          	beqz	a5,80003d34 <filewrite+0x136>
{
    80003c06:	715d                	addi	sp,sp,-80
    80003c08:	e486                	sd	ra,72(sp)
    80003c0a:	e0a2                	sd	s0,64(sp)
    80003c0c:	f84a                	sd	s2,48(sp)
    80003c0e:	f052                	sd	s4,32(sp)
    80003c10:	e85a                	sd	s6,16(sp)
    80003c12:	0880                	addi	s0,sp,80
    80003c14:	892a                	mv	s2,a0
    80003c16:	8b2e                	mv	s6,a1
    80003c18:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c1a:	411c                	lw	a5,0(a0)
    80003c1c:	4705                	li	a4,1
    80003c1e:	02e78763          	beq	a5,a4,80003c4c <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c22:	470d                	li	a4,3
    80003c24:	02e78a63          	beq	a5,a4,80003c58 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c28:	4709                	li	a4,2
    80003c2a:	0ee79863          	bne	a5,a4,80003d1a <filewrite+0x11c>
    80003c2e:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c30:	0cc05463          	blez	a2,80003cf8 <filewrite+0xfa>
    80003c34:	fc26                	sd	s1,56(sp)
    80003c36:	ec56                	sd	s5,24(sp)
    80003c38:	e45e                	sd	s7,8(sp)
    80003c3a:	e062                	sd	s8,0(sp)
    int i = 0;
    80003c3c:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003c3e:	6b85                	lui	s7,0x1
    80003c40:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c44:	6c05                	lui	s8,0x1
    80003c46:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c4a:	a851                	j	80003cde <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003c4c:	6908                	ld	a0,16(a0)
    80003c4e:	00000097          	auipc	ra,0x0
    80003c52:	248080e7          	jalr	584(ra) # 80003e96 <pipewrite>
    80003c56:	a85d                	j	80003d0c <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c58:	02451783          	lh	a5,36(a0)
    80003c5c:	03079693          	slli	a3,a5,0x30
    80003c60:	92c1                	srli	a3,a3,0x30
    80003c62:	4725                	li	a4,9
    80003c64:	0cd76a63          	bltu	a4,a3,80003d38 <filewrite+0x13a>
    80003c68:	0792                	slli	a5,a5,0x4
    80003c6a:	00015717          	auipc	a4,0x15
    80003c6e:	65e70713          	addi	a4,a4,1630 # 800192c8 <devsw>
    80003c72:	97ba                	add	a5,a5,a4
    80003c74:	679c                	ld	a5,8(a5)
    80003c76:	c3f9                	beqz	a5,80003d3c <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003c78:	4505                	li	a0,1
    80003c7a:	9782                	jalr	a5
    80003c7c:	a841                	j	80003d0c <filewrite+0x10e>
      if(n1 > max)
    80003c7e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003c82:	00000097          	auipc	ra,0x0
    80003c86:	88c080e7          	jalr	-1908(ra) # 8000350e <begin_op>
      ilock(f->ip);
    80003c8a:	01893503          	ld	a0,24(s2)
    80003c8e:	fffff097          	auipc	ra,0xfffff
    80003c92:	eae080e7          	jalr	-338(ra) # 80002b3c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c96:	8756                	mv	a4,s5
    80003c98:	02092683          	lw	a3,32(s2)
    80003c9c:	01698633          	add	a2,s3,s6
    80003ca0:	4585                	li	a1,1
    80003ca2:	01893503          	ld	a0,24(s2)
    80003ca6:	fffff097          	auipc	ra,0xfffff
    80003caa:	252080e7          	jalr	594(ra) # 80002ef8 <writei>
    80003cae:	84aa                	mv	s1,a0
    80003cb0:	00a05763          	blez	a0,80003cbe <filewrite+0xc0>
        f->off += r;
    80003cb4:	02092783          	lw	a5,32(s2)
    80003cb8:	9fa9                	addw	a5,a5,a0
    80003cba:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003cbe:	01893503          	ld	a0,24(s2)
    80003cc2:	fffff097          	auipc	ra,0xfffff
    80003cc6:	f40080e7          	jalr	-192(ra) # 80002c02 <iunlock>
      end_op();
    80003cca:	00000097          	auipc	ra,0x0
    80003cce:	8be080e7          	jalr	-1858(ra) # 80003588 <end_op>

      if(r != n1){
    80003cd2:	029a9563          	bne	s5,s1,80003cfc <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003cd6:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003cda:	0149da63          	bge	s3,s4,80003cee <filewrite+0xf0>
      int n1 = n - i;
    80003cde:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003ce2:	0004879b          	sext.w	a5,s1
    80003ce6:	f8fbdce3          	bge	s7,a5,80003c7e <filewrite+0x80>
    80003cea:	84e2                	mv	s1,s8
    80003cec:	bf49                	j	80003c7e <filewrite+0x80>
    80003cee:	74e2                	ld	s1,56(sp)
    80003cf0:	6ae2                	ld	s5,24(sp)
    80003cf2:	6ba2                	ld	s7,8(sp)
    80003cf4:	6c02                	ld	s8,0(sp)
    80003cf6:	a039                	j	80003d04 <filewrite+0x106>
    int i = 0;
    80003cf8:	4981                	li	s3,0
    80003cfa:	a029                	j	80003d04 <filewrite+0x106>
    80003cfc:	74e2                	ld	s1,56(sp)
    80003cfe:	6ae2                	ld	s5,24(sp)
    80003d00:	6ba2                	ld	s7,8(sp)
    80003d02:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003d04:	033a1e63          	bne	s4,s3,80003d40 <filewrite+0x142>
    80003d08:	8552                	mv	a0,s4
    80003d0a:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d0c:	60a6                	ld	ra,72(sp)
    80003d0e:	6406                	ld	s0,64(sp)
    80003d10:	7942                	ld	s2,48(sp)
    80003d12:	7a02                	ld	s4,32(sp)
    80003d14:	6b42                	ld	s6,16(sp)
    80003d16:	6161                	addi	sp,sp,80
    80003d18:	8082                	ret
    80003d1a:	fc26                	sd	s1,56(sp)
    80003d1c:	f44e                	sd	s3,40(sp)
    80003d1e:	ec56                	sd	s5,24(sp)
    80003d20:	e45e                	sd	s7,8(sp)
    80003d22:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003d24:	00005517          	auipc	a0,0x5
    80003d28:	81450513          	addi	a0,a0,-2028 # 80008538 <etext+0x538>
    80003d2c:	00002097          	auipc	ra,0x2
    80003d30:	f80080e7          	jalr	-128(ra) # 80005cac <panic>
    return -1;
    80003d34:	557d                	li	a0,-1
}
    80003d36:	8082                	ret
      return -1;
    80003d38:	557d                	li	a0,-1
    80003d3a:	bfc9                	j	80003d0c <filewrite+0x10e>
    80003d3c:	557d                	li	a0,-1
    80003d3e:	b7f9                	j	80003d0c <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003d40:	557d                	li	a0,-1
    80003d42:	79a2                	ld	s3,40(sp)
    80003d44:	b7e1                	j	80003d0c <filewrite+0x10e>

0000000080003d46 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d46:	7179                	addi	sp,sp,-48
    80003d48:	f406                	sd	ra,40(sp)
    80003d4a:	f022                	sd	s0,32(sp)
    80003d4c:	ec26                	sd	s1,24(sp)
    80003d4e:	e052                	sd	s4,0(sp)
    80003d50:	1800                	addi	s0,sp,48
    80003d52:	84aa                	mv	s1,a0
    80003d54:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d56:	0005b023          	sd	zero,0(a1)
    80003d5a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	bbe080e7          	jalr	-1090(ra) # 8000391c <filealloc>
    80003d66:	e088                	sd	a0,0(s1)
    80003d68:	cd49                	beqz	a0,80003e02 <pipealloc+0xbc>
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	bb2080e7          	jalr	-1102(ra) # 8000391c <filealloc>
    80003d72:	00aa3023          	sd	a0,0(s4)
    80003d76:	c141                	beqz	a0,80003df6 <pipealloc+0xb0>
    80003d78:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d7a:	ffffc097          	auipc	ra,0xffffc
    80003d7e:	3a0080e7          	jalr	928(ra) # 8000011a <kalloc>
    80003d82:	892a                	mv	s2,a0
    80003d84:	c13d                	beqz	a0,80003dea <pipealloc+0xa4>
    80003d86:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003d88:	4985                	li	s3,1
    80003d8a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d8e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d92:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d96:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d9a:	00004597          	auipc	a1,0x4
    80003d9e:	7ae58593          	addi	a1,a1,1966 # 80008548 <etext+0x548>
    80003da2:	00002097          	auipc	ra,0x2
    80003da6:	3f4080e7          	jalr	1012(ra) # 80006196 <initlock>
  (*f0)->type = FD_PIPE;
    80003daa:	609c                	ld	a5,0(s1)
    80003dac:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003db0:	609c                	ld	a5,0(s1)
    80003db2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003db6:	609c                	ld	a5,0(s1)
    80003db8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003dbc:	609c                	ld	a5,0(s1)
    80003dbe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003dc2:	000a3783          	ld	a5,0(s4)
    80003dc6:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003dca:	000a3783          	ld	a5,0(s4)
    80003dce:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003dd2:	000a3783          	ld	a5,0(s4)
    80003dd6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003dda:	000a3783          	ld	a5,0(s4)
    80003dde:	0127b823          	sd	s2,16(a5)
  return 0;
    80003de2:	4501                	li	a0,0
    80003de4:	6942                	ld	s2,16(sp)
    80003de6:	69a2                	ld	s3,8(sp)
    80003de8:	a03d                	j	80003e16 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dea:	6088                	ld	a0,0(s1)
    80003dec:	c119                	beqz	a0,80003df2 <pipealloc+0xac>
    80003dee:	6942                	ld	s2,16(sp)
    80003df0:	a029                	j	80003dfa <pipealloc+0xb4>
    80003df2:	6942                	ld	s2,16(sp)
    80003df4:	a039                	j	80003e02 <pipealloc+0xbc>
    80003df6:	6088                	ld	a0,0(s1)
    80003df8:	c50d                	beqz	a0,80003e22 <pipealloc+0xdc>
    fileclose(*f0);
    80003dfa:	00000097          	auipc	ra,0x0
    80003dfe:	bde080e7          	jalr	-1058(ra) # 800039d8 <fileclose>
  if(*f1)
    80003e02:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e06:	557d                	li	a0,-1
  if(*f1)
    80003e08:	c799                	beqz	a5,80003e16 <pipealloc+0xd0>
    fileclose(*f1);
    80003e0a:	853e                	mv	a0,a5
    80003e0c:	00000097          	auipc	ra,0x0
    80003e10:	bcc080e7          	jalr	-1076(ra) # 800039d8 <fileclose>
  return -1;
    80003e14:	557d                	li	a0,-1
}
    80003e16:	70a2                	ld	ra,40(sp)
    80003e18:	7402                	ld	s0,32(sp)
    80003e1a:	64e2                	ld	s1,24(sp)
    80003e1c:	6a02                	ld	s4,0(sp)
    80003e1e:	6145                	addi	sp,sp,48
    80003e20:	8082                	ret
  return -1;
    80003e22:	557d                	li	a0,-1
    80003e24:	bfcd                	j	80003e16 <pipealloc+0xd0>

0000000080003e26 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e26:	1101                	addi	sp,sp,-32
    80003e28:	ec06                	sd	ra,24(sp)
    80003e2a:	e822                	sd	s0,16(sp)
    80003e2c:	e426                	sd	s1,8(sp)
    80003e2e:	e04a                	sd	s2,0(sp)
    80003e30:	1000                	addi	s0,sp,32
    80003e32:	84aa                	mv	s1,a0
    80003e34:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e36:	00002097          	auipc	ra,0x2
    80003e3a:	3f0080e7          	jalr	1008(ra) # 80006226 <acquire>
  if(writable){
    80003e3e:	02090d63          	beqz	s2,80003e78 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e42:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e46:	21848513          	addi	a0,s1,536
    80003e4a:	ffffe097          	auipc	ra,0xffffe
    80003e4e:	904080e7          	jalr	-1788(ra) # 8000174e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e52:	2204b783          	ld	a5,544(s1)
    80003e56:	eb95                	bnez	a5,80003e8a <pipeclose+0x64>
    release(&pi->lock);
    80003e58:	8526                	mv	a0,s1
    80003e5a:	00002097          	auipc	ra,0x2
    80003e5e:	480080e7          	jalr	1152(ra) # 800062da <release>
    kfree((char*)pi);
    80003e62:	8526                	mv	a0,s1
    80003e64:	ffffc097          	auipc	ra,0xffffc
    80003e68:	1b8080e7          	jalr	440(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e6c:	60e2                	ld	ra,24(sp)
    80003e6e:	6442                	ld	s0,16(sp)
    80003e70:	64a2                	ld	s1,8(sp)
    80003e72:	6902                	ld	s2,0(sp)
    80003e74:	6105                	addi	sp,sp,32
    80003e76:	8082                	ret
    pi->readopen = 0;
    80003e78:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e7c:	21c48513          	addi	a0,s1,540
    80003e80:	ffffe097          	auipc	ra,0xffffe
    80003e84:	8ce080e7          	jalr	-1842(ra) # 8000174e <wakeup>
    80003e88:	b7e9                	j	80003e52 <pipeclose+0x2c>
    release(&pi->lock);
    80003e8a:	8526                	mv	a0,s1
    80003e8c:	00002097          	auipc	ra,0x2
    80003e90:	44e080e7          	jalr	1102(ra) # 800062da <release>
}
    80003e94:	bfe1                	j	80003e6c <pipeclose+0x46>

0000000080003e96 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e96:	711d                	addi	sp,sp,-96
    80003e98:	ec86                	sd	ra,88(sp)
    80003e9a:	e8a2                	sd	s0,80(sp)
    80003e9c:	e4a6                	sd	s1,72(sp)
    80003e9e:	e0ca                	sd	s2,64(sp)
    80003ea0:	fc4e                	sd	s3,56(sp)
    80003ea2:	f852                	sd	s4,48(sp)
    80003ea4:	f456                	sd	s5,40(sp)
    80003ea6:	1080                	addi	s0,sp,96
    80003ea8:	84aa                	mv	s1,a0
    80003eaa:	8aae                	mv	s5,a1
    80003eac:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003eae:	ffffd097          	auipc	ra,0xffffd
    80003eb2:	fca080e7          	jalr	-54(ra) # 80000e78 <myproc>
    80003eb6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003eb8:	8526                	mv	a0,s1
    80003eba:	00002097          	auipc	ra,0x2
    80003ebe:	36c080e7          	jalr	876(ra) # 80006226 <acquire>
  while(i < n){
    80003ec2:	0d405563          	blez	s4,80003f8c <pipewrite+0xf6>
    80003ec6:	f05a                	sd	s6,32(sp)
    80003ec8:	ec5e                	sd	s7,24(sp)
    80003eca:	e862                	sd	s8,16(sp)
  int i = 0;
    80003ecc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ece:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ed0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003ed4:	21c48b93          	addi	s7,s1,540
    80003ed8:	a089                	j	80003f1a <pipewrite+0x84>
      release(&pi->lock);
    80003eda:	8526                	mv	a0,s1
    80003edc:	00002097          	auipc	ra,0x2
    80003ee0:	3fe080e7          	jalr	1022(ra) # 800062da <release>
      return -1;
    80003ee4:	597d                	li	s2,-1
    80003ee6:	7b02                	ld	s6,32(sp)
    80003ee8:	6be2                	ld	s7,24(sp)
    80003eea:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003eec:	854a                	mv	a0,s2
    80003eee:	60e6                	ld	ra,88(sp)
    80003ef0:	6446                	ld	s0,80(sp)
    80003ef2:	64a6                	ld	s1,72(sp)
    80003ef4:	6906                	ld	s2,64(sp)
    80003ef6:	79e2                	ld	s3,56(sp)
    80003ef8:	7a42                	ld	s4,48(sp)
    80003efa:	7aa2                	ld	s5,40(sp)
    80003efc:	6125                	addi	sp,sp,96
    80003efe:	8082                	ret
      wakeup(&pi->nread);
    80003f00:	8562                	mv	a0,s8
    80003f02:	ffffe097          	auipc	ra,0xffffe
    80003f06:	84c080e7          	jalr	-1972(ra) # 8000174e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f0a:	85a6                	mv	a1,s1
    80003f0c:	855e                	mv	a0,s7
    80003f0e:	ffffd097          	auipc	ra,0xffffd
    80003f12:	6b4080e7          	jalr	1716(ra) # 800015c2 <sleep>
  while(i < n){
    80003f16:	05495c63          	bge	s2,s4,80003f6e <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003f1a:	2204a783          	lw	a5,544(s1)
    80003f1e:	dfd5                	beqz	a5,80003eda <pipewrite+0x44>
    80003f20:	0289a783          	lw	a5,40(s3)
    80003f24:	fbdd                	bnez	a5,80003eda <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f26:	2184a783          	lw	a5,536(s1)
    80003f2a:	21c4a703          	lw	a4,540(s1)
    80003f2e:	2007879b          	addiw	a5,a5,512
    80003f32:	fcf707e3          	beq	a4,a5,80003f00 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f36:	4685                	li	a3,1
    80003f38:	01590633          	add	a2,s2,s5
    80003f3c:	faf40593          	addi	a1,s0,-81
    80003f40:	0509b503          	ld	a0,80(s3)
    80003f44:	ffffd097          	auipc	ra,0xffffd
    80003f48:	c60080e7          	jalr	-928(ra) # 80000ba4 <copyin>
    80003f4c:	05650263          	beq	a0,s6,80003f90 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f50:	21c4a783          	lw	a5,540(s1)
    80003f54:	0017871b          	addiw	a4,a5,1
    80003f58:	20e4ae23          	sw	a4,540(s1)
    80003f5c:	1ff7f793          	andi	a5,a5,511
    80003f60:	97a6                	add	a5,a5,s1
    80003f62:	faf44703          	lbu	a4,-81(s0)
    80003f66:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f6a:	2905                	addiw	s2,s2,1
    80003f6c:	b76d                	j	80003f16 <pipewrite+0x80>
    80003f6e:	7b02                	ld	s6,32(sp)
    80003f70:	6be2                	ld	s7,24(sp)
    80003f72:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003f74:	21848513          	addi	a0,s1,536
    80003f78:	ffffd097          	auipc	ra,0xffffd
    80003f7c:	7d6080e7          	jalr	2006(ra) # 8000174e <wakeup>
  release(&pi->lock);
    80003f80:	8526                	mv	a0,s1
    80003f82:	00002097          	auipc	ra,0x2
    80003f86:	358080e7          	jalr	856(ra) # 800062da <release>
  return i;
    80003f8a:	b78d                	j	80003eec <pipewrite+0x56>
  int i = 0;
    80003f8c:	4901                	li	s2,0
    80003f8e:	b7dd                	j	80003f74 <pipewrite+0xde>
    80003f90:	7b02                	ld	s6,32(sp)
    80003f92:	6be2                	ld	s7,24(sp)
    80003f94:	6c42                	ld	s8,16(sp)
    80003f96:	bff9                	j	80003f74 <pipewrite+0xde>

0000000080003f98 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f98:	715d                	addi	sp,sp,-80
    80003f9a:	e486                	sd	ra,72(sp)
    80003f9c:	e0a2                	sd	s0,64(sp)
    80003f9e:	fc26                	sd	s1,56(sp)
    80003fa0:	f84a                	sd	s2,48(sp)
    80003fa2:	f44e                	sd	s3,40(sp)
    80003fa4:	f052                	sd	s4,32(sp)
    80003fa6:	ec56                	sd	s5,24(sp)
    80003fa8:	0880                	addi	s0,sp,80
    80003faa:	84aa                	mv	s1,a0
    80003fac:	892e                	mv	s2,a1
    80003fae:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fb0:	ffffd097          	auipc	ra,0xffffd
    80003fb4:	ec8080e7          	jalr	-312(ra) # 80000e78 <myproc>
    80003fb8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fba:	8526                	mv	a0,s1
    80003fbc:	00002097          	auipc	ra,0x2
    80003fc0:	26a080e7          	jalr	618(ra) # 80006226 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fc4:	2184a703          	lw	a4,536(s1)
    80003fc8:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fcc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fd0:	02f71663          	bne	a4,a5,80003ffc <piperead+0x64>
    80003fd4:	2244a783          	lw	a5,548(s1)
    80003fd8:	cb9d                	beqz	a5,8000400e <piperead+0x76>
    if(pr->killed){
    80003fda:	028a2783          	lw	a5,40(s4)
    80003fde:	e38d                	bnez	a5,80004000 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fe0:	85a6                	mv	a1,s1
    80003fe2:	854e                	mv	a0,s3
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	5de080e7          	jalr	1502(ra) # 800015c2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fec:	2184a703          	lw	a4,536(s1)
    80003ff0:	21c4a783          	lw	a5,540(s1)
    80003ff4:	fef700e3          	beq	a4,a5,80003fd4 <piperead+0x3c>
    80003ff8:	e85a                	sd	s6,16(sp)
    80003ffa:	a819                	j	80004010 <piperead+0x78>
    80003ffc:	e85a                	sd	s6,16(sp)
    80003ffe:	a809                	j	80004010 <piperead+0x78>
      release(&pi->lock);
    80004000:	8526                	mv	a0,s1
    80004002:	00002097          	auipc	ra,0x2
    80004006:	2d8080e7          	jalr	728(ra) # 800062da <release>
      return -1;
    8000400a:	59fd                	li	s3,-1
    8000400c:	a0a5                	j	80004074 <piperead+0xdc>
    8000400e:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004010:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004012:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004014:	05505463          	blez	s5,8000405c <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004018:	2184a783          	lw	a5,536(s1)
    8000401c:	21c4a703          	lw	a4,540(s1)
    80004020:	02f70e63          	beq	a4,a5,8000405c <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004024:	0017871b          	addiw	a4,a5,1
    80004028:	20e4ac23          	sw	a4,536(s1)
    8000402c:	1ff7f793          	andi	a5,a5,511
    80004030:	97a6                	add	a5,a5,s1
    80004032:	0187c783          	lbu	a5,24(a5)
    80004036:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000403a:	4685                	li	a3,1
    8000403c:	fbf40613          	addi	a2,s0,-65
    80004040:	85ca                	mv	a1,s2
    80004042:	050a3503          	ld	a0,80(s4)
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	ad2080e7          	jalr	-1326(ra) # 80000b18 <copyout>
    8000404e:	01650763          	beq	a0,s6,8000405c <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004052:	2985                	addiw	s3,s3,1
    80004054:	0905                	addi	s2,s2,1
    80004056:	fd3a91e3          	bne	s5,s3,80004018 <piperead+0x80>
    8000405a:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000405c:	21c48513          	addi	a0,s1,540
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	6ee080e7          	jalr	1774(ra) # 8000174e <wakeup>
  release(&pi->lock);
    80004068:	8526                	mv	a0,s1
    8000406a:	00002097          	auipc	ra,0x2
    8000406e:	270080e7          	jalr	624(ra) # 800062da <release>
    80004072:	6b42                	ld	s6,16(sp)
  return i;
}
    80004074:	854e                	mv	a0,s3
    80004076:	60a6                	ld	ra,72(sp)
    80004078:	6406                	ld	s0,64(sp)
    8000407a:	74e2                	ld	s1,56(sp)
    8000407c:	7942                	ld	s2,48(sp)
    8000407e:	79a2                	ld	s3,40(sp)
    80004080:	7a02                	ld	s4,32(sp)
    80004082:	6ae2                	ld	s5,24(sp)
    80004084:	6161                	addi	sp,sp,80
    80004086:	8082                	ret

0000000080004088 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004088:	df010113          	addi	sp,sp,-528
    8000408c:	20113423          	sd	ra,520(sp)
    80004090:	20813023          	sd	s0,512(sp)
    80004094:	ffa6                	sd	s1,504(sp)
    80004096:	fbca                	sd	s2,496(sp)
    80004098:	0c00                	addi	s0,sp,528
    8000409a:	892a                	mv	s2,a0
    8000409c:	dea43c23          	sd	a0,-520(s0)
    800040a0:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040a4:	ffffd097          	auipc	ra,0xffffd
    800040a8:	dd4080e7          	jalr	-556(ra) # 80000e78 <myproc>
    800040ac:	84aa                	mv	s1,a0

  begin_op();
    800040ae:	fffff097          	auipc	ra,0xfffff
    800040b2:	460080e7          	jalr	1120(ra) # 8000350e <begin_op>

  if((ip = namei(path)) == 0){
    800040b6:	854a                	mv	a0,s2
    800040b8:	fffff097          	auipc	ra,0xfffff
    800040bc:	256080e7          	jalr	598(ra) # 8000330e <namei>
    800040c0:	c135                	beqz	a0,80004124 <exec+0x9c>
    800040c2:	f3d2                	sd	s4,480(sp)
    800040c4:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800040c6:	fffff097          	auipc	ra,0xfffff
    800040ca:	a76080e7          	jalr	-1418(ra) # 80002b3c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040ce:	04000713          	li	a4,64
    800040d2:	4681                	li	a3,0
    800040d4:	e5040613          	addi	a2,s0,-432
    800040d8:	4581                	li	a1,0
    800040da:	8552                	mv	a0,s4
    800040dc:	fffff097          	auipc	ra,0xfffff
    800040e0:	d18080e7          	jalr	-744(ra) # 80002df4 <readi>
    800040e4:	04000793          	li	a5,64
    800040e8:	00f51a63          	bne	a0,a5,800040fc <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040ec:	e5042703          	lw	a4,-432(s0)
    800040f0:	464c47b7          	lui	a5,0x464c4
    800040f4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040f8:	02f70c63          	beq	a4,a5,80004130 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040fc:	8552                	mv	a0,s4
    800040fe:	fffff097          	auipc	ra,0xfffff
    80004102:	ca4080e7          	jalr	-860(ra) # 80002da2 <iunlockput>
    end_op();
    80004106:	fffff097          	auipc	ra,0xfffff
    8000410a:	482080e7          	jalr	1154(ra) # 80003588 <end_op>
  }
  return -1;
    8000410e:	557d                	li	a0,-1
    80004110:	7a1e                	ld	s4,480(sp)
}
    80004112:	20813083          	ld	ra,520(sp)
    80004116:	20013403          	ld	s0,512(sp)
    8000411a:	74fe                	ld	s1,504(sp)
    8000411c:	795e                	ld	s2,496(sp)
    8000411e:	21010113          	addi	sp,sp,528
    80004122:	8082                	ret
    end_op();
    80004124:	fffff097          	auipc	ra,0xfffff
    80004128:	464080e7          	jalr	1124(ra) # 80003588 <end_op>
    return -1;
    8000412c:	557d                	li	a0,-1
    8000412e:	b7d5                	j	80004112 <exec+0x8a>
    80004130:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004132:	8526                	mv	a0,s1
    80004134:	ffffd097          	auipc	ra,0xffffd
    80004138:	e08080e7          	jalr	-504(ra) # 80000f3c <proc_pagetable>
    8000413c:	8b2a                	mv	s6,a0
    8000413e:	30050563          	beqz	a0,80004448 <exec+0x3c0>
    80004142:	f7ce                	sd	s3,488(sp)
    80004144:	efd6                	sd	s5,472(sp)
    80004146:	e7de                	sd	s7,456(sp)
    80004148:	e3e2                	sd	s8,448(sp)
    8000414a:	ff66                	sd	s9,440(sp)
    8000414c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000414e:	e7042d03          	lw	s10,-400(s0)
    80004152:	e8845783          	lhu	a5,-376(s0)
    80004156:	14078563          	beqz	a5,800042a0 <exec+0x218>
    8000415a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000415c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000415e:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004160:	6c85                	lui	s9,0x1
    80004162:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004166:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000416a:	6a85                	lui	s5,0x1
    8000416c:	a0b5                	j	800041d8 <exec+0x150>
      panic("loadseg: address should exist");
    8000416e:	00004517          	auipc	a0,0x4
    80004172:	3e250513          	addi	a0,a0,994 # 80008550 <etext+0x550>
    80004176:	00002097          	auipc	ra,0x2
    8000417a:	b36080e7          	jalr	-1226(ra) # 80005cac <panic>
    if(sz - i < PGSIZE)
    8000417e:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004180:	8726                	mv	a4,s1
    80004182:	012c06bb          	addw	a3,s8,s2
    80004186:	4581                	li	a1,0
    80004188:	8552                	mv	a0,s4
    8000418a:	fffff097          	auipc	ra,0xfffff
    8000418e:	c6a080e7          	jalr	-918(ra) # 80002df4 <readi>
    80004192:	2501                	sext.w	a0,a0
    80004194:	26a49e63          	bne	s1,a0,80004410 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    80004198:	012a893b          	addw	s2,s5,s2
    8000419c:	03397563          	bgeu	s2,s3,800041c6 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800041a0:	02091593          	slli	a1,s2,0x20
    800041a4:	9181                	srli	a1,a1,0x20
    800041a6:	95de                	add	a1,a1,s7
    800041a8:	855a                	mv	a0,s6
    800041aa:	ffffc097          	auipc	ra,0xffffc
    800041ae:	34e080e7          	jalr	846(ra) # 800004f8 <walkaddr>
    800041b2:	862a                	mv	a2,a0
    if(pa == 0)
    800041b4:	dd4d                	beqz	a0,8000416e <exec+0xe6>
    if(sz - i < PGSIZE)
    800041b6:	412984bb          	subw	s1,s3,s2
    800041ba:	0004879b          	sext.w	a5,s1
    800041be:	fcfcf0e3          	bgeu	s9,a5,8000417e <exec+0xf6>
    800041c2:	84d6                	mv	s1,s5
    800041c4:	bf6d                	j	8000417e <exec+0xf6>
    sz = sz1;
    800041c6:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ca:	2d85                	addiw	s11,s11,1
    800041cc:	038d0d1b          	addiw	s10,s10,56
    800041d0:	e8845783          	lhu	a5,-376(s0)
    800041d4:	06fddf63          	bge	s11,a5,80004252 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041d8:	2d01                	sext.w	s10,s10
    800041da:	03800713          	li	a4,56
    800041de:	86ea                	mv	a3,s10
    800041e0:	e1840613          	addi	a2,s0,-488
    800041e4:	4581                	li	a1,0
    800041e6:	8552                	mv	a0,s4
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	c0c080e7          	jalr	-1012(ra) # 80002df4 <readi>
    800041f0:	03800793          	li	a5,56
    800041f4:	1ef51863          	bne	a0,a5,800043e4 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800041f8:	e1842783          	lw	a5,-488(s0)
    800041fc:	4705                	li	a4,1
    800041fe:	fce796e3          	bne	a5,a4,800041ca <exec+0x142>
    if(ph.memsz < ph.filesz)
    80004202:	e4043603          	ld	a2,-448(s0)
    80004206:	e3843783          	ld	a5,-456(s0)
    8000420a:	1ef66163          	bltu	a2,a5,800043ec <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000420e:	e2843783          	ld	a5,-472(s0)
    80004212:	963e                	add	a2,a2,a5
    80004214:	1ef66063          	bltu	a2,a5,800043f4 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004218:	85a6                	mv	a1,s1
    8000421a:	855a                	mv	a0,s6
    8000421c:	ffffc097          	auipc	ra,0xffffc
    80004220:	6a0080e7          	jalr	1696(ra) # 800008bc <uvmalloc>
    80004224:	e0a43423          	sd	a0,-504(s0)
    80004228:	1c050a63          	beqz	a0,800043fc <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    8000422c:	e2843b83          	ld	s7,-472(s0)
    80004230:	df043783          	ld	a5,-528(s0)
    80004234:	00fbf7b3          	and	a5,s7,a5
    80004238:	1c079a63          	bnez	a5,8000440c <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000423c:	e2042c03          	lw	s8,-480(s0)
    80004240:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004244:	00098463          	beqz	s3,8000424c <exec+0x1c4>
    80004248:	4901                	li	s2,0
    8000424a:	bf99                	j	800041a0 <exec+0x118>
    sz = sz1;
    8000424c:	e0843483          	ld	s1,-504(s0)
    80004250:	bfad                	j	800041ca <exec+0x142>
    80004252:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004254:	8552                	mv	a0,s4
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	b4c080e7          	jalr	-1204(ra) # 80002da2 <iunlockput>
  end_op();
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	32a080e7          	jalr	810(ra) # 80003588 <end_op>
  p = myproc();
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	c12080e7          	jalr	-1006(ra) # 80000e78 <myproc>
    8000426e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004270:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004274:	6985                	lui	s3,0x1
    80004276:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004278:	99a6                	add	s3,s3,s1
    8000427a:	77fd                	lui	a5,0xfffff
    8000427c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004280:	6609                	lui	a2,0x2
    80004282:	964e                	add	a2,a2,s3
    80004284:	85ce                	mv	a1,s3
    80004286:	855a                	mv	a0,s6
    80004288:	ffffc097          	auipc	ra,0xffffc
    8000428c:	634080e7          	jalr	1588(ra) # 800008bc <uvmalloc>
    80004290:	892a                	mv	s2,a0
    80004292:	e0a43423          	sd	a0,-504(s0)
    80004296:	e519                	bnez	a0,800042a4 <exec+0x21c>
  if(pagetable)
    80004298:	e1343423          	sd	s3,-504(s0)
    8000429c:	4a01                	li	s4,0
    8000429e:	aa95                	j	80004412 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042a0:	4481                	li	s1,0
    800042a2:	bf4d                	j	80004254 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042a4:	75f9                	lui	a1,0xffffe
    800042a6:	95aa                	add	a1,a1,a0
    800042a8:	855a                	mv	a0,s6
    800042aa:	ffffd097          	auipc	ra,0xffffd
    800042ae:	83c080e7          	jalr	-1988(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    800042b2:	7bfd                	lui	s7,0xfffff
    800042b4:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800042b6:	e0043783          	ld	a5,-512(s0)
    800042ba:	6388                	ld	a0,0(a5)
    800042bc:	c52d                	beqz	a0,80004326 <exec+0x29e>
    800042be:	e9040993          	addi	s3,s0,-368
    800042c2:	f9040c13          	addi	s8,s0,-112
    800042c6:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800042c8:	ffffc097          	auipc	ra,0xffffc
    800042cc:	026080e7          	jalr	38(ra) # 800002ee <strlen>
    800042d0:	0015079b          	addiw	a5,a0,1
    800042d4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042d8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042dc:	13796463          	bltu	s2,s7,80004404 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042e0:	e0043d03          	ld	s10,-512(s0)
    800042e4:	000d3a03          	ld	s4,0(s10)
    800042e8:	8552                	mv	a0,s4
    800042ea:	ffffc097          	auipc	ra,0xffffc
    800042ee:	004080e7          	jalr	4(ra) # 800002ee <strlen>
    800042f2:	0015069b          	addiw	a3,a0,1
    800042f6:	8652                	mv	a2,s4
    800042f8:	85ca                	mv	a1,s2
    800042fa:	855a                	mv	a0,s6
    800042fc:	ffffd097          	auipc	ra,0xffffd
    80004300:	81c080e7          	jalr	-2020(ra) # 80000b18 <copyout>
    80004304:	10054263          	bltz	a0,80004408 <exec+0x380>
    ustack[argc] = sp;
    80004308:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000430c:	0485                	addi	s1,s1,1
    8000430e:	008d0793          	addi	a5,s10,8
    80004312:	e0f43023          	sd	a5,-512(s0)
    80004316:	008d3503          	ld	a0,8(s10)
    8000431a:	c909                	beqz	a0,8000432c <exec+0x2a4>
    if(argc >= MAXARG)
    8000431c:	09a1                	addi	s3,s3,8
    8000431e:	fb8995e3          	bne	s3,s8,800042c8 <exec+0x240>
  ip = 0;
    80004322:	4a01                	li	s4,0
    80004324:	a0fd                	j	80004412 <exec+0x38a>
  sp = sz;
    80004326:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    8000432a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000432c:	00349793          	slli	a5,s1,0x3
    80004330:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    80004334:	97a2                	add	a5,a5,s0
    80004336:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000433a:	00148693          	addi	a3,s1,1
    8000433e:	068e                	slli	a3,a3,0x3
    80004340:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004344:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004348:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    8000434c:	f57966e3          	bltu	s2,s7,80004298 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004350:	e9040613          	addi	a2,s0,-368
    80004354:	85ca                	mv	a1,s2
    80004356:	855a                	mv	a0,s6
    80004358:	ffffc097          	auipc	ra,0xffffc
    8000435c:	7c0080e7          	jalr	1984(ra) # 80000b18 <copyout>
    80004360:	0e054663          	bltz	a0,8000444c <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004364:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004368:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000436c:	df843783          	ld	a5,-520(s0)
    80004370:	0007c703          	lbu	a4,0(a5)
    80004374:	cf11                	beqz	a4,80004390 <exec+0x308>
    80004376:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004378:	02f00693          	li	a3,47
    8000437c:	a039                	j	8000438a <exec+0x302>
      last = s+1;
    8000437e:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004382:	0785                	addi	a5,a5,1
    80004384:	fff7c703          	lbu	a4,-1(a5)
    80004388:	c701                	beqz	a4,80004390 <exec+0x308>
    if(*s == '/')
    8000438a:	fed71ce3          	bne	a4,a3,80004382 <exec+0x2fa>
    8000438e:	bfc5                	j	8000437e <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004390:	4641                	li	a2,16
    80004392:	df843583          	ld	a1,-520(s0)
    80004396:	158a8513          	addi	a0,s5,344
    8000439a:	ffffc097          	auipc	ra,0xffffc
    8000439e:	f22080e7          	jalr	-222(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    800043a2:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043a6:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043aa:	e0843783          	ld	a5,-504(s0)
    800043ae:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043b2:	058ab783          	ld	a5,88(s5)
    800043b6:	e6843703          	ld	a4,-408(s0)
    800043ba:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043bc:	058ab783          	ld	a5,88(s5)
    800043c0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043c4:	85e6                	mv	a1,s9
    800043c6:	ffffd097          	auipc	ra,0xffffd
    800043ca:	c4a080e7          	jalr	-950(ra) # 80001010 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043ce:	0004851b          	sext.w	a0,s1
    800043d2:	79be                	ld	s3,488(sp)
    800043d4:	7a1e                	ld	s4,480(sp)
    800043d6:	6afe                	ld	s5,472(sp)
    800043d8:	6b5e                	ld	s6,464(sp)
    800043da:	6bbe                	ld	s7,456(sp)
    800043dc:	6c1e                	ld	s8,448(sp)
    800043de:	7cfa                	ld	s9,440(sp)
    800043e0:	7d5a                	ld	s10,432(sp)
    800043e2:	bb05                	j	80004112 <exec+0x8a>
    800043e4:	e0943423          	sd	s1,-504(s0)
    800043e8:	7dba                	ld	s11,424(sp)
    800043ea:	a025                	j	80004412 <exec+0x38a>
    800043ec:	e0943423          	sd	s1,-504(s0)
    800043f0:	7dba                	ld	s11,424(sp)
    800043f2:	a005                	j	80004412 <exec+0x38a>
    800043f4:	e0943423          	sd	s1,-504(s0)
    800043f8:	7dba                	ld	s11,424(sp)
    800043fa:	a821                	j	80004412 <exec+0x38a>
    800043fc:	e0943423          	sd	s1,-504(s0)
    80004400:	7dba                	ld	s11,424(sp)
    80004402:	a801                	j	80004412 <exec+0x38a>
  ip = 0;
    80004404:	4a01                	li	s4,0
    80004406:	a031                	j	80004412 <exec+0x38a>
    80004408:	4a01                	li	s4,0
  if(pagetable)
    8000440a:	a021                	j	80004412 <exec+0x38a>
    8000440c:	7dba                	ld	s11,424(sp)
    8000440e:	a011                	j	80004412 <exec+0x38a>
    80004410:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004412:	e0843583          	ld	a1,-504(s0)
    80004416:	855a                	mv	a0,s6
    80004418:	ffffd097          	auipc	ra,0xffffd
    8000441c:	bf8080e7          	jalr	-1032(ra) # 80001010 <proc_freepagetable>
  return -1;
    80004420:	557d                	li	a0,-1
  if(ip){
    80004422:	000a1b63          	bnez	s4,80004438 <exec+0x3b0>
    80004426:	79be                	ld	s3,488(sp)
    80004428:	7a1e                	ld	s4,480(sp)
    8000442a:	6afe                	ld	s5,472(sp)
    8000442c:	6b5e                	ld	s6,464(sp)
    8000442e:	6bbe                	ld	s7,456(sp)
    80004430:	6c1e                	ld	s8,448(sp)
    80004432:	7cfa                	ld	s9,440(sp)
    80004434:	7d5a                	ld	s10,432(sp)
    80004436:	b9f1                	j	80004112 <exec+0x8a>
    80004438:	79be                	ld	s3,488(sp)
    8000443a:	6afe                	ld	s5,472(sp)
    8000443c:	6b5e                	ld	s6,464(sp)
    8000443e:	6bbe                	ld	s7,456(sp)
    80004440:	6c1e                	ld	s8,448(sp)
    80004442:	7cfa                	ld	s9,440(sp)
    80004444:	7d5a                	ld	s10,432(sp)
    80004446:	b95d                	j	800040fc <exec+0x74>
    80004448:	6b5e                	ld	s6,464(sp)
    8000444a:	b94d                	j	800040fc <exec+0x74>
  sz = sz1;
    8000444c:	e0843983          	ld	s3,-504(s0)
    80004450:	b5a1                	j	80004298 <exec+0x210>

0000000080004452 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004452:	7179                	addi	sp,sp,-48
    80004454:	f406                	sd	ra,40(sp)
    80004456:	f022                	sd	s0,32(sp)
    80004458:	ec26                	sd	s1,24(sp)
    8000445a:	e84a                	sd	s2,16(sp)
    8000445c:	1800                	addi	s0,sp,48
    8000445e:	892e                	mv	s2,a1
    80004460:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004462:	fdc40593          	addi	a1,s0,-36
    80004466:	ffffe097          	auipc	ra,0xffffe
    8000446a:	b56080e7          	jalr	-1194(ra) # 80001fbc <argint>
    8000446e:	04054063          	bltz	a0,800044ae <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004472:	fdc42703          	lw	a4,-36(s0)
    80004476:	47bd                	li	a5,15
    80004478:	02e7ed63          	bltu	a5,a4,800044b2 <argfd+0x60>
    8000447c:	ffffd097          	auipc	ra,0xffffd
    80004480:	9fc080e7          	jalr	-1540(ra) # 80000e78 <myproc>
    80004484:	fdc42703          	lw	a4,-36(s0)
    80004488:	01a70793          	addi	a5,a4,26
    8000448c:	078e                	slli	a5,a5,0x3
    8000448e:	953e                	add	a0,a0,a5
    80004490:	611c                	ld	a5,0(a0)
    80004492:	c395                	beqz	a5,800044b6 <argfd+0x64>
    return -1;
  if(pfd)
    80004494:	00090463          	beqz	s2,8000449c <argfd+0x4a>
    *pfd = fd;
    80004498:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000449c:	4501                	li	a0,0
  if(pf)
    8000449e:	c091                	beqz	s1,800044a2 <argfd+0x50>
    *pf = f;
    800044a0:	e09c                	sd	a5,0(s1)
}
    800044a2:	70a2                	ld	ra,40(sp)
    800044a4:	7402                	ld	s0,32(sp)
    800044a6:	64e2                	ld	s1,24(sp)
    800044a8:	6942                	ld	s2,16(sp)
    800044aa:	6145                	addi	sp,sp,48
    800044ac:	8082                	ret
    return -1;
    800044ae:	557d                	li	a0,-1
    800044b0:	bfcd                	j	800044a2 <argfd+0x50>
    return -1;
    800044b2:	557d                	li	a0,-1
    800044b4:	b7fd                	j	800044a2 <argfd+0x50>
    800044b6:	557d                	li	a0,-1
    800044b8:	b7ed                	j	800044a2 <argfd+0x50>

00000000800044ba <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044ba:	1101                	addi	sp,sp,-32
    800044bc:	ec06                	sd	ra,24(sp)
    800044be:	e822                	sd	s0,16(sp)
    800044c0:	e426                	sd	s1,8(sp)
    800044c2:	1000                	addi	s0,sp,32
    800044c4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044c6:	ffffd097          	auipc	ra,0xffffd
    800044ca:	9b2080e7          	jalr	-1614(ra) # 80000e78 <myproc>
    800044ce:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044d0:	0d050793          	addi	a5,a0,208
    800044d4:	4501                	li	a0,0
    800044d6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044d8:	6398                	ld	a4,0(a5)
    800044da:	cb19                	beqz	a4,800044f0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044dc:	2505                	addiw	a0,a0,1
    800044de:	07a1                	addi	a5,a5,8
    800044e0:	fed51ce3          	bne	a0,a3,800044d8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044e4:	557d                	li	a0,-1
}
    800044e6:	60e2                	ld	ra,24(sp)
    800044e8:	6442                	ld	s0,16(sp)
    800044ea:	64a2                	ld	s1,8(sp)
    800044ec:	6105                	addi	sp,sp,32
    800044ee:	8082                	ret
      p->ofile[fd] = f;
    800044f0:	01a50793          	addi	a5,a0,26
    800044f4:	078e                	slli	a5,a5,0x3
    800044f6:	963e                	add	a2,a2,a5
    800044f8:	e204                	sd	s1,0(a2)
      return fd;
    800044fa:	b7f5                	j	800044e6 <fdalloc+0x2c>

00000000800044fc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044fc:	715d                	addi	sp,sp,-80
    800044fe:	e486                	sd	ra,72(sp)
    80004500:	e0a2                	sd	s0,64(sp)
    80004502:	fc26                	sd	s1,56(sp)
    80004504:	f84a                	sd	s2,48(sp)
    80004506:	f44e                	sd	s3,40(sp)
    80004508:	f052                	sd	s4,32(sp)
    8000450a:	ec56                	sd	s5,24(sp)
    8000450c:	0880                	addi	s0,sp,80
    8000450e:	8aae                	mv	s5,a1
    80004510:	8a32                	mv	s4,a2
    80004512:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004514:	fb040593          	addi	a1,s0,-80
    80004518:	fffff097          	auipc	ra,0xfffff
    8000451c:	e14080e7          	jalr	-492(ra) # 8000332c <nameiparent>
    80004520:	892a                	mv	s2,a0
    80004522:	12050c63          	beqz	a0,8000465a <create+0x15e>
    return 0;

  ilock(dp);
    80004526:	ffffe097          	auipc	ra,0xffffe
    8000452a:	616080e7          	jalr	1558(ra) # 80002b3c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000452e:	4601                	li	a2,0
    80004530:	fb040593          	addi	a1,s0,-80
    80004534:	854a                	mv	a0,s2
    80004536:	fffff097          	auipc	ra,0xfffff
    8000453a:	b06080e7          	jalr	-1274(ra) # 8000303c <dirlookup>
    8000453e:	84aa                	mv	s1,a0
    80004540:	c539                	beqz	a0,8000458e <create+0x92>
    iunlockput(dp);
    80004542:	854a                	mv	a0,s2
    80004544:	fffff097          	auipc	ra,0xfffff
    80004548:	85e080e7          	jalr	-1954(ra) # 80002da2 <iunlockput>
    ilock(ip);
    8000454c:	8526                	mv	a0,s1
    8000454e:	ffffe097          	auipc	ra,0xffffe
    80004552:	5ee080e7          	jalr	1518(ra) # 80002b3c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004556:	4789                	li	a5,2
    80004558:	02fa9463          	bne	s5,a5,80004580 <create+0x84>
    8000455c:	0444d783          	lhu	a5,68(s1)
    80004560:	37f9                	addiw	a5,a5,-2
    80004562:	17c2                	slli	a5,a5,0x30
    80004564:	93c1                	srli	a5,a5,0x30
    80004566:	4705                	li	a4,1
    80004568:	00f76c63          	bltu	a4,a5,80004580 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000456c:	8526                	mv	a0,s1
    8000456e:	60a6                	ld	ra,72(sp)
    80004570:	6406                	ld	s0,64(sp)
    80004572:	74e2                	ld	s1,56(sp)
    80004574:	7942                	ld	s2,48(sp)
    80004576:	79a2                	ld	s3,40(sp)
    80004578:	7a02                	ld	s4,32(sp)
    8000457a:	6ae2                	ld	s5,24(sp)
    8000457c:	6161                	addi	sp,sp,80
    8000457e:	8082                	ret
    iunlockput(ip);
    80004580:	8526                	mv	a0,s1
    80004582:	fffff097          	auipc	ra,0xfffff
    80004586:	820080e7          	jalr	-2016(ra) # 80002da2 <iunlockput>
    return 0;
    8000458a:	4481                	li	s1,0
    8000458c:	b7c5                	j	8000456c <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000458e:	85d6                	mv	a1,s5
    80004590:	00092503          	lw	a0,0(s2)
    80004594:	ffffe097          	auipc	ra,0xffffe
    80004598:	414080e7          	jalr	1044(ra) # 800029a8 <ialloc>
    8000459c:	84aa                	mv	s1,a0
    8000459e:	c139                	beqz	a0,800045e4 <create+0xe8>
  ilock(ip);
    800045a0:	ffffe097          	auipc	ra,0xffffe
    800045a4:	59c080e7          	jalr	1436(ra) # 80002b3c <ilock>
  ip->major = major;
    800045a8:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800045ac:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800045b0:	4985                	li	s3,1
    800045b2:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800045b6:	8526                	mv	a0,s1
    800045b8:	ffffe097          	auipc	ra,0xffffe
    800045bc:	4b8080e7          	jalr	1208(ra) # 80002a70 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045c0:	033a8a63          	beq	s5,s3,800045f4 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800045c4:	40d0                	lw	a2,4(s1)
    800045c6:	fb040593          	addi	a1,s0,-80
    800045ca:	854a                	mv	a0,s2
    800045cc:	fffff097          	auipc	ra,0xfffff
    800045d0:	c80080e7          	jalr	-896(ra) # 8000324c <dirlink>
    800045d4:	06054b63          	bltz	a0,8000464a <create+0x14e>
  iunlockput(dp);
    800045d8:	854a                	mv	a0,s2
    800045da:	ffffe097          	auipc	ra,0xffffe
    800045de:	7c8080e7          	jalr	1992(ra) # 80002da2 <iunlockput>
  return ip;
    800045e2:	b769                	j	8000456c <create+0x70>
    panic("create: ialloc");
    800045e4:	00004517          	auipc	a0,0x4
    800045e8:	f8c50513          	addi	a0,a0,-116 # 80008570 <etext+0x570>
    800045ec:	00001097          	auipc	ra,0x1
    800045f0:	6c0080e7          	jalr	1728(ra) # 80005cac <panic>
    dp->nlink++;  // for ".."
    800045f4:	04a95783          	lhu	a5,74(s2)
    800045f8:	2785                	addiw	a5,a5,1
    800045fa:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045fe:	854a                	mv	a0,s2
    80004600:	ffffe097          	auipc	ra,0xffffe
    80004604:	470080e7          	jalr	1136(ra) # 80002a70 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004608:	40d0                	lw	a2,4(s1)
    8000460a:	00004597          	auipc	a1,0x4
    8000460e:	f7658593          	addi	a1,a1,-138 # 80008580 <etext+0x580>
    80004612:	8526                	mv	a0,s1
    80004614:	fffff097          	auipc	ra,0xfffff
    80004618:	c38080e7          	jalr	-968(ra) # 8000324c <dirlink>
    8000461c:	00054f63          	bltz	a0,8000463a <create+0x13e>
    80004620:	00492603          	lw	a2,4(s2)
    80004624:	00004597          	auipc	a1,0x4
    80004628:	f6458593          	addi	a1,a1,-156 # 80008588 <etext+0x588>
    8000462c:	8526                	mv	a0,s1
    8000462e:	fffff097          	auipc	ra,0xfffff
    80004632:	c1e080e7          	jalr	-994(ra) # 8000324c <dirlink>
    80004636:	f80557e3          	bgez	a0,800045c4 <create+0xc8>
      panic("create dots");
    8000463a:	00004517          	auipc	a0,0x4
    8000463e:	f5650513          	addi	a0,a0,-170 # 80008590 <etext+0x590>
    80004642:	00001097          	auipc	ra,0x1
    80004646:	66a080e7          	jalr	1642(ra) # 80005cac <panic>
    panic("create: dirlink");
    8000464a:	00004517          	auipc	a0,0x4
    8000464e:	f5650513          	addi	a0,a0,-170 # 800085a0 <etext+0x5a0>
    80004652:	00001097          	auipc	ra,0x1
    80004656:	65a080e7          	jalr	1626(ra) # 80005cac <panic>
    return 0;
    8000465a:	84aa                	mv	s1,a0
    8000465c:	bf01                	j	8000456c <create+0x70>

000000008000465e <sys_dup>:
{
    8000465e:	7179                	addi	sp,sp,-48
    80004660:	f406                	sd	ra,40(sp)
    80004662:	f022                	sd	s0,32(sp)
    80004664:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004666:	fd840613          	addi	a2,s0,-40
    8000466a:	4581                	li	a1,0
    8000466c:	4501                	li	a0,0
    8000466e:	00000097          	auipc	ra,0x0
    80004672:	de4080e7          	jalr	-540(ra) # 80004452 <argfd>
    return -1;
    80004676:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004678:	02054763          	bltz	a0,800046a6 <sys_dup+0x48>
    8000467c:	ec26                	sd	s1,24(sp)
    8000467e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004680:	fd843903          	ld	s2,-40(s0)
    80004684:	854a                	mv	a0,s2
    80004686:	00000097          	auipc	ra,0x0
    8000468a:	e34080e7          	jalr	-460(ra) # 800044ba <fdalloc>
    8000468e:	84aa                	mv	s1,a0
    return -1;
    80004690:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004692:	00054f63          	bltz	a0,800046b0 <sys_dup+0x52>
  filedup(f);
    80004696:	854a                	mv	a0,s2
    80004698:	fffff097          	auipc	ra,0xfffff
    8000469c:	2ee080e7          	jalr	750(ra) # 80003986 <filedup>
  return fd;
    800046a0:	87a6                	mv	a5,s1
    800046a2:	64e2                	ld	s1,24(sp)
    800046a4:	6942                	ld	s2,16(sp)
}
    800046a6:	853e                	mv	a0,a5
    800046a8:	70a2                	ld	ra,40(sp)
    800046aa:	7402                	ld	s0,32(sp)
    800046ac:	6145                	addi	sp,sp,48
    800046ae:	8082                	ret
    800046b0:	64e2                	ld	s1,24(sp)
    800046b2:	6942                	ld	s2,16(sp)
    800046b4:	bfcd                	j	800046a6 <sys_dup+0x48>

00000000800046b6 <sys_read>:
{
    800046b6:	7179                	addi	sp,sp,-48
    800046b8:	f406                	sd	ra,40(sp)
    800046ba:	f022                	sd	s0,32(sp)
    800046bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046be:	fe840613          	addi	a2,s0,-24
    800046c2:	4581                	li	a1,0
    800046c4:	4501                	li	a0,0
    800046c6:	00000097          	auipc	ra,0x0
    800046ca:	d8c080e7          	jalr	-628(ra) # 80004452 <argfd>
    return -1;
    800046ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046d0:	04054163          	bltz	a0,80004712 <sys_read+0x5c>
    800046d4:	fe440593          	addi	a1,s0,-28
    800046d8:	4509                	li	a0,2
    800046da:	ffffe097          	auipc	ra,0xffffe
    800046de:	8e2080e7          	jalr	-1822(ra) # 80001fbc <argint>
    return -1;
    800046e2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046e4:	02054763          	bltz	a0,80004712 <sys_read+0x5c>
    800046e8:	fd840593          	addi	a1,s0,-40
    800046ec:	4505                	li	a0,1
    800046ee:	ffffe097          	auipc	ra,0xffffe
    800046f2:	8f0080e7          	jalr	-1808(ra) # 80001fde <argaddr>
    return -1;
    800046f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046f8:	00054d63          	bltz	a0,80004712 <sys_read+0x5c>
  return fileread(f, p, n);
    800046fc:	fe442603          	lw	a2,-28(s0)
    80004700:	fd843583          	ld	a1,-40(s0)
    80004704:	fe843503          	ld	a0,-24(s0)
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	424080e7          	jalr	1060(ra) # 80003b2c <fileread>
    80004710:	87aa                	mv	a5,a0
}
    80004712:	853e                	mv	a0,a5
    80004714:	70a2                	ld	ra,40(sp)
    80004716:	7402                	ld	s0,32(sp)
    80004718:	6145                	addi	sp,sp,48
    8000471a:	8082                	ret

000000008000471c <sys_write>:
{
    8000471c:	7179                	addi	sp,sp,-48
    8000471e:	f406                	sd	ra,40(sp)
    80004720:	f022                	sd	s0,32(sp)
    80004722:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004724:	fe840613          	addi	a2,s0,-24
    80004728:	4581                	li	a1,0
    8000472a:	4501                	li	a0,0
    8000472c:	00000097          	auipc	ra,0x0
    80004730:	d26080e7          	jalr	-730(ra) # 80004452 <argfd>
    return -1;
    80004734:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004736:	04054163          	bltz	a0,80004778 <sys_write+0x5c>
    8000473a:	fe440593          	addi	a1,s0,-28
    8000473e:	4509                	li	a0,2
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	87c080e7          	jalr	-1924(ra) # 80001fbc <argint>
    return -1;
    80004748:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000474a:	02054763          	bltz	a0,80004778 <sys_write+0x5c>
    8000474e:	fd840593          	addi	a1,s0,-40
    80004752:	4505                	li	a0,1
    80004754:	ffffe097          	auipc	ra,0xffffe
    80004758:	88a080e7          	jalr	-1910(ra) # 80001fde <argaddr>
    return -1;
    8000475c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000475e:	00054d63          	bltz	a0,80004778 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004762:	fe442603          	lw	a2,-28(s0)
    80004766:	fd843583          	ld	a1,-40(s0)
    8000476a:	fe843503          	ld	a0,-24(s0)
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	490080e7          	jalr	1168(ra) # 80003bfe <filewrite>
    80004776:	87aa                	mv	a5,a0
}
    80004778:	853e                	mv	a0,a5
    8000477a:	70a2                	ld	ra,40(sp)
    8000477c:	7402                	ld	s0,32(sp)
    8000477e:	6145                	addi	sp,sp,48
    80004780:	8082                	ret

0000000080004782 <sys_close>:
{
    80004782:	1101                	addi	sp,sp,-32
    80004784:	ec06                	sd	ra,24(sp)
    80004786:	e822                	sd	s0,16(sp)
    80004788:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000478a:	fe040613          	addi	a2,s0,-32
    8000478e:	fec40593          	addi	a1,s0,-20
    80004792:	4501                	li	a0,0
    80004794:	00000097          	auipc	ra,0x0
    80004798:	cbe080e7          	jalr	-834(ra) # 80004452 <argfd>
    return -1;
    8000479c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000479e:	02054463          	bltz	a0,800047c6 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047a2:	ffffc097          	auipc	ra,0xffffc
    800047a6:	6d6080e7          	jalr	1750(ra) # 80000e78 <myproc>
    800047aa:	fec42783          	lw	a5,-20(s0)
    800047ae:	07e9                	addi	a5,a5,26
    800047b0:	078e                	slli	a5,a5,0x3
    800047b2:	953e                	add	a0,a0,a5
    800047b4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047b8:	fe043503          	ld	a0,-32(s0)
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	21c080e7          	jalr	540(ra) # 800039d8 <fileclose>
  return 0;
    800047c4:	4781                	li	a5,0
}
    800047c6:	853e                	mv	a0,a5
    800047c8:	60e2                	ld	ra,24(sp)
    800047ca:	6442                	ld	s0,16(sp)
    800047cc:	6105                	addi	sp,sp,32
    800047ce:	8082                	ret

00000000800047d0 <sys_fstat>:
{
    800047d0:	1101                	addi	sp,sp,-32
    800047d2:	ec06                	sd	ra,24(sp)
    800047d4:	e822                	sd	s0,16(sp)
    800047d6:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d8:	fe840613          	addi	a2,s0,-24
    800047dc:	4581                	li	a1,0
    800047de:	4501                	li	a0,0
    800047e0:	00000097          	auipc	ra,0x0
    800047e4:	c72080e7          	jalr	-910(ra) # 80004452 <argfd>
    return -1;
    800047e8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ea:	02054563          	bltz	a0,80004814 <sys_fstat+0x44>
    800047ee:	fe040593          	addi	a1,s0,-32
    800047f2:	4505                	li	a0,1
    800047f4:	ffffd097          	auipc	ra,0xffffd
    800047f8:	7ea080e7          	jalr	2026(ra) # 80001fde <argaddr>
    return -1;
    800047fc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047fe:	00054b63          	bltz	a0,80004814 <sys_fstat+0x44>
  return filestat(f, st);
    80004802:	fe043583          	ld	a1,-32(s0)
    80004806:	fe843503          	ld	a0,-24(s0)
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	2b0080e7          	jalr	688(ra) # 80003aba <filestat>
    80004812:	87aa                	mv	a5,a0
}
    80004814:	853e                	mv	a0,a5
    80004816:	60e2                	ld	ra,24(sp)
    80004818:	6442                	ld	s0,16(sp)
    8000481a:	6105                	addi	sp,sp,32
    8000481c:	8082                	ret

000000008000481e <sys_link>:
{
    8000481e:	7169                	addi	sp,sp,-304
    80004820:	f606                	sd	ra,296(sp)
    80004822:	f222                	sd	s0,288(sp)
    80004824:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004826:	08000613          	li	a2,128
    8000482a:	ed040593          	addi	a1,s0,-304
    8000482e:	4501                	li	a0,0
    80004830:	ffffd097          	auipc	ra,0xffffd
    80004834:	7d0080e7          	jalr	2000(ra) # 80002000 <argstr>
    return -1;
    80004838:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000483a:	12054663          	bltz	a0,80004966 <sys_link+0x148>
    8000483e:	08000613          	li	a2,128
    80004842:	f5040593          	addi	a1,s0,-176
    80004846:	4505                	li	a0,1
    80004848:	ffffd097          	auipc	ra,0xffffd
    8000484c:	7b8080e7          	jalr	1976(ra) # 80002000 <argstr>
    return -1;
    80004850:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004852:	10054a63          	bltz	a0,80004966 <sys_link+0x148>
    80004856:	ee26                	sd	s1,280(sp)
  begin_op();
    80004858:	fffff097          	auipc	ra,0xfffff
    8000485c:	cb6080e7          	jalr	-842(ra) # 8000350e <begin_op>
  if((ip = namei(old)) == 0){
    80004860:	ed040513          	addi	a0,s0,-304
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	aaa080e7          	jalr	-1366(ra) # 8000330e <namei>
    8000486c:	84aa                	mv	s1,a0
    8000486e:	c949                	beqz	a0,80004900 <sys_link+0xe2>
  ilock(ip);
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	2cc080e7          	jalr	716(ra) # 80002b3c <ilock>
  if(ip->type == T_DIR){
    80004878:	04449703          	lh	a4,68(s1)
    8000487c:	4785                	li	a5,1
    8000487e:	08f70863          	beq	a4,a5,8000490e <sys_link+0xf0>
    80004882:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004884:	04a4d783          	lhu	a5,74(s1)
    80004888:	2785                	addiw	a5,a5,1
    8000488a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000488e:	8526                	mv	a0,s1
    80004890:	ffffe097          	auipc	ra,0xffffe
    80004894:	1e0080e7          	jalr	480(ra) # 80002a70 <iupdate>
  iunlock(ip);
    80004898:	8526                	mv	a0,s1
    8000489a:	ffffe097          	auipc	ra,0xffffe
    8000489e:	368080e7          	jalr	872(ra) # 80002c02 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048a2:	fd040593          	addi	a1,s0,-48
    800048a6:	f5040513          	addi	a0,s0,-176
    800048aa:	fffff097          	auipc	ra,0xfffff
    800048ae:	a82080e7          	jalr	-1406(ra) # 8000332c <nameiparent>
    800048b2:	892a                	mv	s2,a0
    800048b4:	cd35                	beqz	a0,80004930 <sys_link+0x112>
  ilock(dp);
    800048b6:	ffffe097          	auipc	ra,0xffffe
    800048ba:	286080e7          	jalr	646(ra) # 80002b3c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048be:	00092703          	lw	a4,0(s2)
    800048c2:	409c                	lw	a5,0(s1)
    800048c4:	06f71163          	bne	a4,a5,80004926 <sys_link+0x108>
    800048c8:	40d0                	lw	a2,4(s1)
    800048ca:	fd040593          	addi	a1,s0,-48
    800048ce:	854a                	mv	a0,s2
    800048d0:	fffff097          	auipc	ra,0xfffff
    800048d4:	97c080e7          	jalr	-1668(ra) # 8000324c <dirlink>
    800048d8:	04054763          	bltz	a0,80004926 <sys_link+0x108>
  iunlockput(dp);
    800048dc:	854a                	mv	a0,s2
    800048de:	ffffe097          	auipc	ra,0xffffe
    800048e2:	4c4080e7          	jalr	1220(ra) # 80002da2 <iunlockput>
  iput(ip);
    800048e6:	8526                	mv	a0,s1
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	412080e7          	jalr	1042(ra) # 80002cfa <iput>
  end_op();
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	c98080e7          	jalr	-872(ra) # 80003588 <end_op>
  return 0;
    800048f8:	4781                	li	a5,0
    800048fa:	64f2                	ld	s1,280(sp)
    800048fc:	6952                	ld	s2,272(sp)
    800048fe:	a0a5                	j	80004966 <sys_link+0x148>
    end_op();
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	c88080e7          	jalr	-888(ra) # 80003588 <end_op>
    return -1;
    80004908:	57fd                	li	a5,-1
    8000490a:	64f2                	ld	s1,280(sp)
    8000490c:	a8a9                	j	80004966 <sys_link+0x148>
    iunlockput(ip);
    8000490e:	8526                	mv	a0,s1
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	492080e7          	jalr	1170(ra) # 80002da2 <iunlockput>
    end_op();
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	c70080e7          	jalr	-912(ra) # 80003588 <end_op>
    return -1;
    80004920:	57fd                	li	a5,-1
    80004922:	64f2                	ld	s1,280(sp)
    80004924:	a089                	j	80004966 <sys_link+0x148>
    iunlockput(dp);
    80004926:	854a                	mv	a0,s2
    80004928:	ffffe097          	auipc	ra,0xffffe
    8000492c:	47a080e7          	jalr	1146(ra) # 80002da2 <iunlockput>
  ilock(ip);
    80004930:	8526                	mv	a0,s1
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	20a080e7          	jalr	522(ra) # 80002b3c <ilock>
  ip->nlink--;
    8000493a:	04a4d783          	lhu	a5,74(s1)
    8000493e:	37fd                	addiw	a5,a5,-1
    80004940:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004944:	8526                	mv	a0,s1
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	12a080e7          	jalr	298(ra) # 80002a70 <iupdate>
  iunlockput(ip);
    8000494e:	8526                	mv	a0,s1
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	452080e7          	jalr	1106(ra) # 80002da2 <iunlockput>
  end_op();
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	c30080e7          	jalr	-976(ra) # 80003588 <end_op>
  return -1;
    80004960:	57fd                	li	a5,-1
    80004962:	64f2                	ld	s1,280(sp)
    80004964:	6952                	ld	s2,272(sp)
}
    80004966:	853e                	mv	a0,a5
    80004968:	70b2                	ld	ra,296(sp)
    8000496a:	7412                	ld	s0,288(sp)
    8000496c:	6155                	addi	sp,sp,304
    8000496e:	8082                	ret

0000000080004970 <sys_unlink>:
{
    80004970:	7151                	addi	sp,sp,-240
    80004972:	f586                	sd	ra,232(sp)
    80004974:	f1a2                	sd	s0,224(sp)
    80004976:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004978:	08000613          	li	a2,128
    8000497c:	f3040593          	addi	a1,s0,-208
    80004980:	4501                	li	a0,0
    80004982:	ffffd097          	auipc	ra,0xffffd
    80004986:	67e080e7          	jalr	1662(ra) # 80002000 <argstr>
    8000498a:	1a054a63          	bltz	a0,80004b3e <sys_unlink+0x1ce>
    8000498e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	b7e080e7          	jalr	-1154(ra) # 8000350e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004998:	fb040593          	addi	a1,s0,-80
    8000499c:	f3040513          	addi	a0,s0,-208
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	98c080e7          	jalr	-1652(ra) # 8000332c <nameiparent>
    800049a8:	84aa                	mv	s1,a0
    800049aa:	cd71                	beqz	a0,80004a86 <sys_unlink+0x116>
  ilock(dp);
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	190080e7          	jalr	400(ra) # 80002b3c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049b4:	00004597          	auipc	a1,0x4
    800049b8:	bcc58593          	addi	a1,a1,-1076 # 80008580 <etext+0x580>
    800049bc:	fb040513          	addi	a0,s0,-80
    800049c0:	ffffe097          	auipc	ra,0xffffe
    800049c4:	662080e7          	jalr	1634(ra) # 80003022 <namecmp>
    800049c8:	14050c63          	beqz	a0,80004b20 <sys_unlink+0x1b0>
    800049cc:	00004597          	auipc	a1,0x4
    800049d0:	bbc58593          	addi	a1,a1,-1092 # 80008588 <etext+0x588>
    800049d4:	fb040513          	addi	a0,s0,-80
    800049d8:	ffffe097          	auipc	ra,0xffffe
    800049dc:	64a080e7          	jalr	1610(ra) # 80003022 <namecmp>
    800049e0:	14050063          	beqz	a0,80004b20 <sys_unlink+0x1b0>
    800049e4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049e6:	f2c40613          	addi	a2,s0,-212
    800049ea:	fb040593          	addi	a1,s0,-80
    800049ee:	8526                	mv	a0,s1
    800049f0:	ffffe097          	auipc	ra,0xffffe
    800049f4:	64c080e7          	jalr	1612(ra) # 8000303c <dirlookup>
    800049f8:	892a                	mv	s2,a0
    800049fa:	12050263          	beqz	a0,80004b1e <sys_unlink+0x1ae>
  ilock(ip);
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	13e080e7          	jalr	318(ra) # 80002b3c <ilock>
  if(ip->nlink < 1)
    80004a06:	04a91783          	lh	a5,74(s2)
    80004a0a:	08f05563          	blez	a5,80004a94 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a0e:	04491703          	lh	a4,68(s2)
    80004a12:	4785                	li	a5,1
    80004a14:	08f70963          	beq	a4,a5,80004aa6 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004a18:	4641                	li	a2,16
    80004a1a:	4581                	li	a1,0
    80004a1c:	fc040513          	addi	a0,s0,-64
    80004a20:	ffffb097          	auipc	ra,0xffffb
    80004a24:	75a080e7          	jalr	1882(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a28:	4741                	li	a4,16
    80004a2a:	f2c42683          	lw	a3,-212(s0)
    80004a2e:	fc040613          	addi	a2,s0,-64
    80004a32:	4581                	li	a1,0
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	4c2080e7          	jalr	1218(ra) # 80002ef8 <writei>
    80004a3e:	47c1                	li	a5,16
    80004a40:	0af51b63          	bne	a0,a5,80004af6 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004a44:	04491703          	lh	a4,68(s2)
    80004a48:	4785                	li	a5,1
    80004a4a:	0af70f63          	beq	a4,a5,80004b08 <sys_unlink+0x198>
  iunlockput(dp);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	352080e7          	jalr	850(ra) # 80002da2 <iunlockput>
  ip->nlink--;
    80004a58:	04a95783          	lhu	a5,74(s2)
    80004a5c:	37fd                	addiw	a5,a5,-1
    80004a5e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a62:	854a                	mv	a0,s2
    80004a64:	ffffe097          	auipc	ra,0xffffe
    80004a68:	00c080e7          	jalr	12(ra) # 80002a70 <iupdate>
  iunlockput(ip);
    80004a6c:	854a                	mv	a0,s2
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	334080e7          	jalr	820(ra) # 80002da2 <iunlockput>
  end_op();
    80004a76:	fffff097          	auipc	ra,0xfffff
    80004a7a:	b12080e7          	jalr	-1262(ra) # 80003588 <end_op>
  return 0;
    80004a7e:	4501                	li	a0,0
    80004a80:	64ee                	ld	s1,216(sp)
    80004a82:	694e                	ld	s2,208(sp)
    80004a84:	a84d                	j	80004b36 <sys_unlink+0x1c6>
    end_op();
    80004a86:	fffff097          	auipc	ra,0xfffff
    80004a8a:	b02080e7          	jalr	-1278(ra) # 80003588 <end_op>
    return -1;
    80004a8e:	557d                	li	a0,-1
    80004a90:	64ee                	ld	s1,216(sp)
    80004a92:	a055                	j	80004b36 <sys_unlink+0x1c6>
    80004a94:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004a96:	00004517          	auipc	a0,0x4
    80004a9a:	b1a50513          	addi	a0,a0,-1254 # 800085b0 <etext+0x5b0>
    80004a9e:	00001097          	auipc	ra,0x1
    80004aa2:	20e080e7          	jalr	526(ra) # 80005cac <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aa6:	04c92703          	lw	a4,76(s2)
    80004aaa:	02000793          	li	a5,32
    80004aae:	f6e7f5e3          	bgeu	a5,a4,80004a18 <sys_unlink+0xa8>
    80004ab2:	e5ce                	sd	s3,200(sp)
    80004ab4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ab8:	4741                	li	a4,16
    80004aba:	86ce                	mv	a3,s3
    80004abc:	f1840613          	addi	a2,s0,-232
    80004ac0:	4581                	li	a1,0
    80004ac2:	854a                	mv	a0,s2
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	330080e7          	jalr	816(ra) # 80002df4 <readi>
    80004acc:	47c1                	li	a5,16
    80004ace:	00f51c63          	bne	a0,a5,80004ae6 <sys_unlink+0x176>
    if(de.inum != 0)
    80004ad2:	f1845783          	lhu	a5,-232(s0)
    80004ad6:	e7b5                	bnez	a5,80004b42 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ad8:	29c1                	addiw	s3,s3,16
    80004ada:	04c92783          	lw	a5,76(s2)
    80004ade:	fcf9ede3          	bltu	s3,a5,80004ab8 <sys_unlink+0x148>
    80004ae2:	69ae                	ld	s3,200(sp)
    80004ae4:	bf15                	j	80004a18 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004ae6:	00004517          	auipc	a0,0x4
    80004aea:	ae250513          	addi	a0,a0,-1310 # 800085c8 <etext+0x5c8>
    80004aee:	00001097          	auipc	ra,0x1
    80004af2:	1be080e7          	jalr	446(ra) # 80005cac <panic>
    80004af6:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004af8:	00004517          	auipc	a0,0x4
    80004afc:	ae850513          	addi	a0,a0,-1304 # 800085e0 <etext+0x5e0>
    80004b00:	00001097          	auipc	ra,0x1
    80004b04:	1ac080e7          	jalr	428(ra) # 80005cac <panic>
    dp->nlink--;
    80004b08:	04a4d783          	lhu	a5,74(s1)
    80004b0c:	37fd                	addiw	a5,a5,-1
    80004b0e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	f5c080e7          	jalr	-164(ra) # 80002a70 <iupdate>
    80004b1c:	bf0d                	j	80004a4e <sys_unlink+0xde>
    80004b1e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004b20:	8526                	mv	a0,s1
    80004b22:	ffffe097          	auipc	ra,0xffffe
    80004b26:	280080e7          	jalr	640(ra) # 80002da2 <iunlockput>
  end_op();
    80004b2a:	fffff097          	auipc	ra,0xfffff
    80004b2e:	a5e080e7          	jalr	-1442(ra) # 80003588 <end_op>
  return -1;
    80004b32:	557d                	li	a0,-1
    80004b34:	64ee                	ld	s1,216(sp)
}
    80004b36:	70ae                	ld	ra,232(sp)
    80004b38:	740e                	ld	s0,224(sp)
    80004b3a:	616d                	addi	sp,sp,240
    80004b3c:	8082                	ret
    return -1;
    80004b3e:	557d                	li	a0,-1
    80004b40:	bfdd                	j	80004b36 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004b42:	854a                	mv	a0,s2
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	25e080e7          	jalr	606(ra) # 80002da2 <iunlockput>
    goto bad;
    80004b4c:	694e                	ld	s2,208(sp)
    80004b4e:	69ae                	ld	s3,200(sp)
    80004b50:	bfc1                	j	80004b20 <sys_unlink+0x1b0>

0000000080004b52 <sys_open>:

uint64
sys_open(void)
{
    80004b52:	7131                	addi	sp,sp,-192
    80004b54:	fd06                	sd	ra,184(sp)
    80004b56:	f922                	sd	s0,176(sp)
    80004b58:	f526                	sd	s1,168(sp)
    80004b5a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b5c:	08000613          	li	a2,128
    80004b60:	f5040593          	addi	a1,s0,-176
    80004b64:	4501                	li	a0,0
    80004b66:	ffffd097          	auipc	ra,0xffffd
    80004b6a:	49a080e7          	jalr	1178(ra) # 80002000 <argstr>
    return -1;
    80004b6e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b70:	0c054463          	bltz	a0,80004c38 <sys_open+0xe6>
    80004b74:	f4c40593          	addi	a1,s0,-180
    80004b78:	4505                	li	a0,1
    80004b7a:	ffffd097          	auipc	ra,0xffffd
    80004b7e:	442080e7          	jalr	1090(ra) # 80001fbc <argint>
    80004b82:	0a054b63          	bltz	a0,80004c38 <sys_open+0xe6>
    80004b86:	f14a                	sd	s2,160(sp)

  begin_op();
    80004b88:	fffff097          	auipc	ra,0xfffff
    80004b8c:	986080e7          	jalr	-1658(ra) # 8000350e <begin_op>

  if(omode & O_CREATE){
    80004b90:	f4c42783          	lw	a5,-180(s0)
    80004b94:	2007f793          	andi	a5,a5,512
    80004b98:	cfc5                	beqz	a5,80004c50 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b9a:	4681                	li	a3,0
    80004b9c:	4601                	li	a2,0
    80004b9e:	4589                	li	a1,2
    80004ba0:	f5040513          	addi	a0,s0,-176
    80004ba4:	00000097          	auipc	ra,0x0
    80004ba8:	958080e7          	jalr	-1704(ra) # 800044fc <create>
    80004bac:	892a                	mv	s2,a0
    if(ip == 0){
    80004bae:	c959                	beqz	a0,80004c44 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bb0:	04491703          	lh	a4,68(s2)
    80004bb4:	478d                	li	a5,3
    80004bb6:	00f71763          	bne	a4,a5,80004bc4 <sys_open+0x72>
    80004bba:	04695703          	lhu	a4,70(s2)
    80004bbe:	47a5                	li	a5,9
    80004bc0:	0ce7ef63          	bltu	a5,a4,80004c9e <sys_open+0x14c>
    80004bc4:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bc6:	fffff097          	auipc	ra,0xfffff
    80004bca:	d56080e7          	jalr	-682(ra) # 8000391c <filealloc>
    80004bce:	89aa                	mv	s3,a0
    80004bd0:	c965                	beqz	a0,80004cc0 <sys_open+0x16e>
    80004bd2:	00000097          	auipc	ra,0x0
    80004bd6:	8e8080e7          	jalr	-1816(ra) # 800044ba <fdalloc>
    80004bda:	84aa                	mv	s1,a0
    80004bdc:	0c054d63          	bltz	a0,80004cb6 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004be0:	04491703          	lh	a4,68(s2)
    80004be4:	478d                	li	a5,3
    80004be6:	0ef70a63          	beq	a4,a5,80004cda <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bea:	4789                	li	a5,2
    80004bec:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bf0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bf4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bf8:	f4c42783          	lw	a5,-180(s0)
    80004bfc:	0017c713          	xori	a4,a5,1
    80004c00:	8b05                	andi	a4,a4,1
    80004c02:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c06:	0037f713          	andi	a4,a5,3
    80004c0a:	00e03733          	snez	a4,a4
    80004c0e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c12:	4007f793          	andi	a5,a5,1024
    80004c16:	c791                	beqz	a5,80004c22 <sys_open+0xd0>
    80004c18:	04491703          	lh	a4,68(s2)
    80004c1c:	4789                	li	a5,2
    80004c1e:	0cf70563          	beq	a4,a5,80004ce8 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004c22:	854a                	mv	a0,s2
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	fde080e7          	jalr	-34(ra) # 80002c02 <iunlock>
  end_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	95c080e7          	jalr	-1700(ra) # 80003588 <end_op>
    80004c34:	790a                	ld	s2,160(sp)
    80004c36:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004c38:	8526                	mv	a0,s1
    80004c3a:	70ea                	ld	ra,184(sp)
    80004c3c:	744a                	ld	s0,176(sp)
    80004c3e:	74aa                	ld	s1,168(sp)
    80004c40:	6129                	addi	sp,sp,192
    80004c42:	8082                	ret
      end_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	944080e7          	jalr	-1724(ra) # 80003588 <end_op>
      return -1;
    80004c4c:	790a                	ld	s2,160(sp)
    80004c4e:	b7ed                	j	80004c38 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004c50:	f5040513          	addi	a0,s0,-176
    80004c54:	ffffe097          	auipc	ra,0xffffe
    80004c58:	6ba080e7          	jalr	1722(ra) # 8000330e <namei>
    80004c5c:	892a                	mv	s2,a0
    80004c5e:	c90d                	beqz	a0,80004c90 <sys_open+0x13e>
    ilock(ip);
    80004c60:	ffffe097          	auipc	ra,0xffffe
    80004c64:	edc080e7          	jalr	-292(ra) # 80002b3c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c68:	04491703          	lh	a4,68(s2)
    80004c6c:	4785                	li	a5,1
    80004c6e:	f4f711e3          	bne	a4,a5,80004bb0 <sys_open+0x5e>
    80004c72:	f4c42783          	lw	a5,-180(s0)
    80004c76:	d7b9                	beqz	a5,80004bc4 <sys_open+0x72>
      iunlockput(ip);
    80004c78:	854a                	mv	a0,s2
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	128080e7          	jalr	296(ra) # 80002da2 <iunlockput>
      end_op();
    80004c82:	fffff097          	auipc	ra,0xfffff
    80004c86:	906080e7          	jalr	-1786(ra) # 80003588 <end_op>
      return -1;
    80004c8a:	54fd                	li	s1,-1
    80004c8c:	790a                	ld	s2,160(sp)
    80004c8e:	b76d                	j	80004c38 <sys_open+0xe6>
      end_op();
    80004c90:	fffff097          	auipc	ra,0xfffff
    80004c94:	8f8080e7          	jalr	-1800(ra) # 80003588 <end_op>
      return -1;
    80004c98:	54fd                	li	s1,-1
    80004c9a:	790a                	ld	s2,160(sp)
    80004c9c:	bf71                	j	80004c38 <sys_open+0xe6>
    iunlockput(ip);
    80004c9e:	854a                	mv	a0,s2
    80004ca0:	ffffe097          	auipc	ra,0xffffe
    80004ca4:	102080e7          	jalr	258(ra) # 80002da2 <iunlockput>
    end_op();
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	8e0080e7          	jalr	-1824(ra) # 80003588 <end_op>
    return -1;
    80004cb0:	54fd                	li	s1,-1
    80004cb2:	790a                	ld	s2,160(sp)
    80004cb4:	b751                	j	80004c38 <sys_open+0xe6>
      fileclose(f);
    80004cb6:	854e                	mv	a0,s3
    80004cb8:	fffff097          	auipc	ra,0xfffff
    80004cbc:	d20080e7          	jalr	-736(ra) # 800039d8 <fileclose>
    iunlockput(ip);
    80004cc0:	854a                	mv	a0,s2
    80004cc2:	ffffe097          	auipc	ra,0xffffe
    80004cc6:	0e0080e7          	jalr	224(ra) # 80002da2 <iunlockput>
    end_op();
    80004cca:	fffff097          	auipc	ra,0xfffff
    80004cce:	8be080e7          	jalr	-1858(ra) # 80003588 <end_op>
    return -1;
    80004cd2:	54fd                	li	s1,-1
    80004cd4:	790a                	ld	s2,160(sp)
    80004cd6:	69ea                	ld	s3,152(sp)
    80004cd8:	b785                	j	80004c38 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004cda:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cde:	04691783          	lh	a5,70(s2)
    80004ce2:	02f99223          	sh	a5,36(s3)
    80004ce6:	b739                	j	80004bf4 <sys_open+0xa2>
    itrunc(ip);
    80004ce8:	854a                	mv	a0,s2
    80004cea:	ffffe097          	auipc	ra,0xffffe
    80004cee:	f64080e7          	jalr	-156(ra) # 80002c4e <itrunc>
    80004cf2:	bf05                	j	80004c22 <sys_open+0xd0>

0000000080004cf4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cf4:	7175                	addi	sp,sp,-144
    80004cf6:	e506                	sd	ra,136(sp)
    80004cf8:	e122                	sd	s0,128(sp)
    80004cfa:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cfc:	fffff097          	auipc	ra,0xfffff
    80004d00:	812080e7          	jalr	-2030(ra) # 8000350e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d04:	08000613          	li	a2,128
    80004d08:	f7040593          	addi	a1,s0,-144
    80004d0c:	4501                	li	a0,0
    80004d0e:	ffffd097          	auipc	ra,0xffffd
    80004d12:	2f2080e7          	jalr	754(ra) # 80002000 <argstr>
    80004d16:	02054963          	bltz	a0,80004d48 <sys_mkdir+0x54>
    80004d1a:	4681                	li	a3,0
    80004d1c:	4601                	li	a2,0
    80004d1e:	4585                	li	a1,1
    80004d20:	f7040513          	addi	a0,s0,-144
    80004d24:	fffff097          	auipc	ra,0xfffff
    80004d28:	7d8080e7          	jalr	2008(ra) # 800044fc <create>
    80004d2c:	cd11                	beqz	a0,80004d48 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d2e:	ffffe097          	auipc	ra,0xffffe
    80004d32:	074080e7          	jalr	116(ra) # 80002da2 <iunlockput>
  end_op();
    80004d36:	fffff097          	auipc	ra,0xfffff
    80004d3a:	852080e7          	jalr	-1966(ra) # 80003588 <end_op>
  return 0;
    80004d3e:	4501                	li	a0,0
}
    80004d40:	60aa                	ld	ra,136(sp)
    80004d42:	640a                	ld	s0,128(sp)
    80004d44:	6149                	addi	sp,sp,144
    80004d46:	8082                	ret
    end_op();
    80004d48:	fffff097          	auipc	ra,0xfffff
    80004d4c:	840080e7          	jalr	-1984(ra) # 80003588 <end_op>
    return -1;
    80004d50:	557d                	li	a0,-1
    80004d52:	b7fd                	j	80004d40 <sys_mkdir+0x4c>

0000000080004d54 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d54:	7135                	addi	sp,sp,-160
    80004d56:	ed06                	sd	ra,152(sp)
    80004d58:	e922                	sd	s0,144(sp)
    80004d5a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d5c:	ffffe097          	auipc	ra,0xffffe
    80004d60:	7b2080e7          	jalr	1970(ra) # 8000350e <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d64:	08000613          	li	a2,128
    80004d68:	f7040593          	addi	a1,s0,-144
    80004d6c:	4501                	li	a0,0
    80004d6e:	ffffd097          	auipc	ra,0xffffd
    80004d72:	292080e7          	jalr	658(ra) # 80002000 <argstr>
    80004d76:	04054a63          	bltz	a0,80004dca <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d7a:	f6c40593          	addi	a1,s0,-148
    80004d7e:	4505                	li	a0,1
    80004d80:	ffffd097          	auipc	ra,0xffffd
    80004d84:	23c080e7          	jalr	572(ra) # 80001fbc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d88:	04054163          	bltz	a0,80004dca <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d8c:	f6840593          	addi	a1,s0,-152
    80004d90:	4509                	li	a0,2
    80004d92:	ffffd097          	auipc	ra,0xffffd
    80004d96:	22a080e7          	jalr	554(ra) # 80001fbc <argint>
     argint(1, &major) < 0 ||
    80004d9a:	02054863          	bltz	a0,80004dca <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d9e:	f6841683          	lh	a3,-152(s0)
    80004da2:	f6c41603          	lh	a2,-148(s0)
    80004da6:	458d                	li	a1,3
    80004da8:	f7040513          	addi	a0,s0,-144
    80004dac:	fffff097          	auipc	ra,0xfffff
    80004db0:	750080e7          	jalr	1872(ra) # 800044fc <create>
     argint(2, &minor) < 0 ||
    80004db4:	c919                	beqz	a0,80004dca <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004db6:	ffffe097          	auipc	ra,0xffffe
    80004dba:	fec080e7          	jalr	-20(ra) # 80002da2 <iunlockput>
  end_op();
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	7ca080e7          	jalr	1994(ra) # 80003588 <end_op>
  return 0;
    80004dc6:	4501                	li	a0,0
    80004dc8:	a031                	j	80004dd4 <sys_mknod+0x80>
    end_op();
    80004dca:	ffffe097          	auipc	ra,0xffffe
    80004dce:	7be080e7          	jalr	1982(ra) # 80003588 <end_op>
    return -1;
    80004dd2:	557d                	li	a0,-1
}
    80004dd4:	60ea                	ld	ra,152(sp)
    80004dd6:	644a                	ld	s0,144(sp)
    80004dd8:	610d                	addi	sp,sp,160
    80004dda:	8082                	ret

0000000080004ddc <sys_chdir>:

uint64
sys_chdir(void)
{
    80004ddc:	7135                	addi	sp,sp,-160
    80004dde:	ed06                	sd	ra,152(sp)
    80004de0:	e922                	sd	s0,144(sp)
    80004de2:	e14a                	sd	s2,128(sp)
    80004de4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004de6:	ffffc097          	auipc	ra,0xffffc
    80004dea:	092080e7          	jalr	146(ra) # 80000e78 <myproc>
    80004dee:	892a                	mv	s2,a0
  
  begin_op();
    80004df0:	ffffe097          	auipc	ra,0xffffe
    80004df4:	71e080e7          	jalr	1822(ra) # 8000350e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004df8:	08000613          	li	a2,128
    80004dfc:	f6040593          	addi	a1,s0,-160
    80004e00:	4501                	li	a0,0
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	1fe080e7          	jalr	510(ra) # 80002000 <argstr>
    80004e0a:	04054d63          	bltz	a0,80004e64 <sys_chdir+0x88>
    80004e0e:	e526                	sd	s1,136(sp)
    80004e10:	f6040513          	addi	a0,s0,-160
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	4fa080e7          	jalr	1274(ra) # 8000330e <namei>
    80004e1c:	84aa                	mv	s1,a0
    80004e1e:	c131                	beqz	a0,80004e62 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e20:	ffffe097          	auipc	ra,0xffffe
    80004e24:	d1c080e7          	jalr	-740(ra) # 80002b3c <ilock>
  if(ip->type != T_DIR){
    80004e28:	04449703          	lh	a4,68(s1)
    80004e2c:	4785                	li	a5,1
    80004e2e:	04f71163          	bne	a4,a5,80004e70 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e32:	8526                	mv	a0,s1
    80004e34:	ffffe097          	auipc	ra,0xffffe
    80004e38:	dce080e7          	jalr	-562(ra) # 80002c02 <iunlock>
  iput(p->cwd);
    80004e3c:	15093503          	ld	a0,336(s2)
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	eba080e7          	jalr	-326(ra) # 80002cfa <iput>
  end_op();
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	740080e7          	jalr	1856(ra) # 80003588 <end_op>
  p->cwd = ip;
    80004e50:	14993823          	sd	s1,336(s2)
  return 0;
    80004e54:	4501                	li	a0,0
    80004e56:	64aa                	ld	s1,136(sp)
}
    80004e58:	60ea                	ld	ra,152(sp)
    80004e5a:	644a                	ld	s0,144(sp)
    80004e5c:	690a                	ld	s2,128(sp)
    80004e5e:	610d                	addi	sp,sp,160
    80004e60:	8082                	ret
    80004e62:	64aa                	ld	s1,136(sp)
    end_op();
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	724080e7          	jalr	1828(ra) # 80003588 <end_op>
    return -1;
    80004e6c:	557d                	li	a0,-1
    80004e6e:	b7ed                	j	80004e58 <sys_chdir+0x7c>
    iunlockput(ip);
    80004e70:	8526                	mv	a0,s1
    80004e72:	ffffe097          	auipc	ra,0xffffe
    80004e76:	f30080e7          	jalr	-208(ra) # 80002da2 <iunlockput>
    end_op();
    80004e7a:	ffffe097          	auipc	ra,0xffffe
    80004e7e:	70e080e7          	jalr	1806(ra) # 80003588 <end_op>
    return -1;
    80004e82:	557d                	li	a0,-1
    80004e84:	64aa                	ld	s1,136(sp)
    80004e86:	bfc9                	j	80004e58 <sys_chdir+0x7c>

0000000080004e88 <sys_exec>:

uint64
sys_exec(void)
{
    80004e88:	7121                	addi	sp,sp,-448
    80004e8a:	ff06                	sd	ra,440(sp)
    80004e8c:	fb22                	sd	s0,432(sp)
    80004e8e:	f34a                	sd	s2,416(sp)
    80004e90:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e92:	08000613          	li	a2,128
    80004e96:	f5040593          	addi	a1,s0,-176
    80004e9a:	4501                	li	a0,0
    80004e9c:	ffffd097          	auipc	ra,0xffffd
    80004ea0:	164080e7          	jalr	356(ra) # 80002000 <argstr>
    return -1;
    80004ea4:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004ea6:	0e054a63          	bltz	a0,80004f9a <sys_exec+0x112>
    80004eaa:	e4840593          	addi	a1,s0,-440
    80004eae:	4505                	li	a0,1
    80004eb0:	ffffd097          	auipc	ra,0xffffd
    80004eb4:	12e080e7          	jalr	302(ra) # 80001fde <argaddr>
    80004eb8:	0e054163          	bltz	a0,80004f9a <sys_exec+0x112>
    80004ebc:	f726                	sd	s1,424(sp)
    80004ebe:	ef4e                	sd	s3,408(sp)
    80004ec0:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004ec2:	10000613          	li	a2,256
    80004ec6:	4581                	li	a1,0
    80004ec8:	e5040513          	addi	a0,s0,-432
    80004ecc:	ffffb097          	auipc	ra,0xffffb
    80004ed0:	2ae080e7          	jalr	686(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ed4:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004ed8:	89a6                	mv	s3,s1
    80004eda:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004edc:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ee0:	00391513          	slli	a0,s2,0x3
    80004ee4:	e4040593          	addi	a1,s0,-448
    80004ee8:	e4843783          	ld	a5,-440(s0)
    80004eec:	953e                	add	a0,a0,a5
    80004eee:	ffffd097          	auipc	ra,0xffffd
    80004ef2:	034080e7          	jalr	52(ra) # 80001f22 <fetchaddr>
    80004ef6:	02054a63          	bltz	a0,80004f2a <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004efa:	e4043783          	ld	a5,-448(s0)
    80004efe:	c7b1                	beqz	a5,80004f4a <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f00:	ffffb097          	auipc	ra,0xffffb
    80004f04:	21a080e7          	jalr	538(ra) # 8000011a <kalloc>
    80004f08:	85aa                	mv	a1,a0
    80004f0a:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f0e:	cd11                	beqz	a0,80004f2a <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f10:	6605                	lui	a2,0x1
    80004f12:	e4043503          	ld	a0,-448(s0)
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	05e080e7          	jalr	94(ra) # 80001f74 <fetchstr>
    80004f1e:	00054663          	bltz	a0,80004f2a <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004f22:	0905                	addi	s2,s2,1
    80004f24:	09a1                	addi	s3,s3,8
    80004f26:	fb491de3          	bne	s2,s4,80004ee0 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f2a:	f5040913          	addi	s2,s0,-176
    80004f2e:	6088                	ld	a0,0(s1)
    80004f30:	c12d                	beqz	a0,80004f92 <sys_exec+0x10a>
    kfree(argv[i]);
    80004f32:	ffffb097          	auipc	ra,0xffffb
    80004f36:	0ea080e7          	jalr	234(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f3a:	04a1                	addi	s1,s1,8
    80004f3c:	ff2499e3          	bne	s1,s2,80004f2e <sys_exec+0xa6>
  return -1;
    80004f40:	597d                	li	s2,-1
    80004f42:	74ba                	ld	s1,424(sp)
    80004f44:	69fa                	ld	s3,408(sp)
    80004f46:	6a5a                	ld	s4,400(sp)
    80004f48:	a889                	j	80004f9a <sys_exec+0x112>
      argv[i] = 0;
    80004f4a:	0009079b          	sext.w	a5,s2
    80004f4e:	078e                	slli	a5,a5,0x3
    80004f50:	fd078793          	addi	a5,a5,-48
    80004f54:	97a2                	add	a5,a5,s0
    80004f56:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f5a:	e5040593          	addi	a1,s0,-432
    80004f5e:	f5040513          	addi	a0,s0,-176
    80004f62:	fffff097          	auipc	ra,0xfffff
    80004f66:	126080e7          	jalr	294(ra) # 80004088 <exec>
    80004f6a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6c:	f5040993          	addi	s3,s0,-176
    80004f70:	6088                	ld	a0,0(s1)
    80004f72:	cd01                	beqz	a0,80004f8a <sys_exec+0x102>
    kfree(argv[i]);
    80004f74:	ffffb097          	auipc	ra,0xffffb
    80004f78:	0a8080e7          	jalr	168(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7c:	04a1                	addi	s1,s1,8
    80004f7e:	ff3499e3          	bne	s1,s3,80004f70 <sys_exec+0xe8>
    80004f82:	74ba                	ld	s1,424(sp)
    80004f84:	69fa                	ld	s3,408(sp)
    80004f86:	6a5a                	ld	s4,400(sp)
    80004f88:	a809                	j	80004f9a <sys_exec+0x112>
  return ret;
    80004f8a:	74ba                	ld	s1,424(sp)
    80004f8c:	69fa                	ld	s3,408(sp)
    80004f8e:	6a5a                	ld	s4,400(sp)
    80004f90:	a029                	j	80004f9a <sys_exec+0x112>
  return -1;
    80004f92:	597d                	li	s2,-1
    80004f94:	74ba                	ld	s1,424(sp)
    80004f96:	69fa                	ld	s3,408(sp)
    80004f98:	6a5a                	ld	s4,400(sp)
}
    80004f9a:	854a                	mv	a0,s2
    80004f9c:	70fa                	ld	ra,440(sp)
    80004f9e:	745a                	ld	s0,432(sp)
    80004fa0:	791a                	ld	s2,416(sp)
    80004fa2:	6139                	addi	sp,sp,448
    80004fa4:	8082                	ret

0000000080004fa6 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fa6:	7139                	addi	sp,sp,-64
    80004fa8:	fc06                	sd	ra,56(sp)
    80004faa:	f822                	sd	s0,48(sp)
    80004fac:	f426                	sd	s1,40(sp)
    80004fae:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fb0:	ffffc097          	auipc	ra,0xffffc
    80004fb4:	ec8080e7          	jalr	-312(ra) # 80000e78 <myproc>
    80004fb8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004fba:	fd840593          	addi	a1,s0,-40
    80004fbe:	4501                	li	a0,0
    80004fc0:	ffffd097          	auipc	ra,0xffffd
    80004fc4:	01e080e7          	jalr	30(ra) # 80001fde <argaddr>
    return -1;
    80004fc8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fca:	0e054063          	bltz	a0,800050aa <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fce:	fc840593          	addi	a1,s0,-56
    80004fd2:	fd040513          	addi	a0,s0,-48
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	d70080e7          	jalr	-656(ra) # 80003d46 <pipealloc>
    return -1;
    80004fde:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fe0:	0c054563          	bltz	a0,800050aa <sys_pipe+0x104>
  fd0 = -1;
    80004fe4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fe8:	fd043503          	ld	a0,-48(s0)
    80004fec:	fffff097          	auipc	ra,0xfffff
    80004ff0:	4ce080e7          	jalr	1230(ra) # 800044ba <fdalloc>
    80004ff4:	fca42223          	sw	a0,-60(s0)
    80004ff8:	08054c63          	bltz	a0,80005090 <sys_pipe+0xea>
    80004ffc:	fc843503          	ld	a0,-56(s0)
    80005000:	fffff097          	auipc	ra,0xfffff
    80005004:	4ba080e7          	jalr	1210(ra) # 800044ba <fdalloc>
    80005008:	fca42023          	sw	a0,-64(s0)
    8000500c:	06054963          	bltz	a0,8000507e <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005010:	4691                	li	a3,4
    80005012:	fc440613          	addi	a2,s0,-60
    80005016:	fd843583          	ld	a1,-40(s0)
    8000501a:	68a8                	ld	a0,80(s1)
    8000501c:	ffffc097          	auipc	ra,0xffffc
    80005020:	afc080e7          	jalr	-1284(ra) # 80000b18 <copyout>
    80005024:	02054063          	bltz	a0,80005044 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005028:	4691                	li	a3,4
    8000502a:	fc040613          	addi	a2,s0,-64
    8000502e:	fd843583          	ld	a1,-40(s0)
    80005032:	0591                	addi	a1,a1,4
    80005034:	68a8                	ld	a0,80(s1)
    80005036:	ffffc097          	auipc	ra,0xffffc
    8000503a:	ae2080e7          	jalr	-1310(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000503e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005040:	06055563          	bgez	a0,800050aa <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005044:	fc442783          	lw	a5,-60(s0)
    80005048:	07e9                	addi	a5,a5,26
    8000504a:	078e                	slli	a5,a5,0x3
    8000504c:	97a6                	add	a5,a5,s1
    8000504e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005052:	fc042783          	lw	a5,-64(s0)
    80005056:	07e9                	addi	a5,a5,26
    80005058:	078e                	slli	a5,a5,0x3
    8000505a:	00f48533          	add	a0,s1,a5
    8000505e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005062:	fd043503          	ld	a0,-48(s0)
    80005066:	fffff097          	auipc	ra,0xfffff
    8000506a:	972080e7          	jalr	-1678(ra) # 800039d8 <fileclose>
    fileclose(wf);
    8000506e:	fc843503          	ld	a0,-56(s0)
    80005072:	fffff097          	auipc	ra,0xfffff
    80005076:	966080e7          	jalr	-1690(ra) # 800039d8 <fileclose>
    return -1;
    8000507a:	57fd                	li	a5,-1
    8000507c:	a03d                	j	800050aa <sys_pipe+0x104>
    if(fd0 >= 0)
    8000507e:	fc442783          	lw	a5,-60(s0)
    80005082:	0007c763          	bltz	a5,80005090 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005086:	07e9                	addi	a5,a5,26
    80005088:	078e                	slli	a5,a5,0x3
    8000508a:	97a6                	add	a5,a5,s1
    8000508c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005090:	fd043503          	ld	a0,-48(s0)
    80005094:	fffff097          	auipc	ra,0xfffff
    80005098:	944080e7          	jalr	-1724(ra) # 800039d8 <fileclose>
    fileclose(wf);
    8000509c:	fc843503          	ld	a0,-56(s0)
    800050a0:	fffff097          	auipc	ra,0xfffff
    800050a4:	938080e7          	jalr	-1736(ra) # 800039d8 <fileclose>
    return -1;
    800050a8:	57fd                	li	a5,-1
}
    800050aa:	853e                	mv	a0,a5
    800050ac:	70e2                	ld	ra,56(sp)
    800050ae:	7442                	ld	s0,48(sp)
    800050b0:	74a2                	ld	s1,40(sp)
    800050b2:	6121                	addi	sp,sp,64
    800050b4:	8082                	ret
	...

00000000800050c0 <kernelvec>:
    800050c0:	7111                	addi	sp,sp,-256
    800050c2:	e006                	sd	ra,0(sp)
    800050c4:	e40a                	sd	sp,8(sp)
    800050c6:	e80e                	sd	gp,16(sp)
    800050c8:	ec12                	sd	tp,24(sp)
    800050ca:	f016                	sd	t0,32(sp)
    800050cc:	f41a                	sd	t1,40(sp)
    800050ce:	f81e                	sd	t2,48(sp)
    800050d0:	fc22                	sd	s0,56(sp)
    800050d2:	e0a6                	sd	s1,64(sp)
    800050d4:	e4aa                	sd	a0,72(sp)
    800050d6:	e8ae                	sd	a1,80(sp)
    800050d8:	ecb2                	sd	a2,88(sp)
    800050da:	f0b6                	sd	a3,96(sp)
    800050dc:	f4ba                	sd	a4,104(sp)
    800050de:	f8be                	sd	a5,112(sp)
    800050e0:	fcc2                	sd	a6,120(sp)
    800050e2:	e146                	sd	a7,128(sp)
    800050e4:	e54a                	sd	s2,136(sp)
    800050e6:	e94e                	sd	s3,144(sp)
    800050e8:	ed52                	sd	s4,152(sp)
    800050ea:	f156                	sd	s5,160(sp)
    800050ec:	f55a                	sd	s6,168(sp)
    800050ee:	f95e                	sd	s7,176(sp)
    800050f0:	fd62                	sd	s8,184(sp)
    800050f2:	e1e6                	sd	s9,192(sp)
    800050f4:	e5ea                	sd	s10,200(sp)
    800050f6:	e9ee                	sd	s11,208(sp)
    800050f8:	edf2                	sd	t3,216(sp)
    800050fa:	f1f6                	sd	t4,224(sp)
    800050fc:	f5fa                	sd	t5,232(sp)
    800050fe:	f9fe                	sd	t6,240(sp)
    80005100:	ceffc0ef          	jal	80001dee <kerneltrap>
    80005104:	6082                	ld	ra,0(sp)
    80005106:	6122                	ld	sp,8(sp)
    80005108:	61c2                	ld	gp,16(sp)
    8000510a:	7282                	ld	t0,32(sp)
    8000510c:	7322                	ld	t1,40(sp)
    8000510e:	73c2                	ld	t2,48(sp)
    80005110:	7462                	ld	s0,56(sp)
    80005112:	6486                	ld	s1,64(sp)
    80005114:	6526                	ld	a0,72(sp)
    80005116:	65c6                	ld	a1,80(sp)
    80005118:	6666                	ld	a2,88(sp)
    8000511a:	7686                	ld	a3,96(sp)
    8000511c:	7726                	ld	a4,104(sp)
    8000511e:	77c6                	ld	a5,112(sp)
    80005120:	7866                	ld	a6,120(sp)
    80005122:	688a                	ld	a7,128(sp)
    80005124:	692a                	ld	s2,136(sp)
    80005126:	69ca                	ld	s3,144(sp)
    80005128:	6a6a                	ld	s4,152(sp)
    8000512a:	7a8a                	ld	s5,160(sp)
    8000512c:	7b2a                	ld	s6,168(sp)
    8000512e:	7bca                	ld	s7,176(sp)
    80005130:	7c6a                	ld	s8,184(sp)
    80005132:	6c8e                	ld	s9,192(sp)
    80005134:	6d2e                	ld	s10,200(sp)
    80005136:	6dce                	ld	s11,208(sp)
    80005138:	6e6e                	ld	t3,216(sp)
    8000513a:	7e8e                	ld	t4,224(sp)
    8000513c:	7f2e                	ld	t5,232(sp)
    8000513e:	7fce                	ld	t6,240(sp)
    80005140:	6111                	addi	sp,sp,256
    80005142:	10200073          	sret
    80005146:	00000013          	nop
    8000514a:	00000013          	nop
    8000514e:	0001                	nop

0000000080005150 <timervec>:
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	e10c                	sd	a1,0(a0)
    80005156:	e510                	sd	a2,8(a0)
    80005158:	e914                	sd	a3,16(a0)
    8000515a:	6d0c                	ld	a1,24(a0)
    8000515c:	7110                	ld	a2,32(a0)
    8000515e:	6194                	ld	a3,0(a1)
    80005160:	96b2                	add	a3,a3,a2
    80005162:	e194                	sd	a3,0(a1)
    80005164:	4589                	li	a1,2
    80005166:	14459073          	csrw	sip,a1
    8000516a:	6914                	ld	a3,16(a0)
    8000516c:	6510                	ld	a2,8(a0)
    8000516e:	610c                	ld	a1,0(a0)
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	30200073          	mret
	...

000000008000517a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000517a:	1141                	addi	sp,sp,-16
    8000517c:	e422                	sd	s0,8(sp)
    8000517e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005180:	0c0007b7          	lui	a5,0xc000
    80005184:	4705                	li	a4,1
    80005186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005188:	0c0007b7          	lui	a5,0xc000
    8000518c:	c3d8                	sw	a4,4(a5)
}
    8000518e:	6422                	ld	s0,8(sp)
    80005190:	0141                	addi	sp,sp,16
    80005192:	8082                	ret

0000000080005194 <plicinithart>:

void
plicinithart(void)
{
    80005194:	1141                	addi	sp,sp,-16
    80005196:	e406                	sd	ra,8(sp)
    80005198:	e022                	sd	s0,0(sp)
    8000519a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000519c:	ffffc097          	auipc	ra,0xffffc
    800051a0:	cb0080e7          	jalr	-848(ra) # 80000e4c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051a4:	0085171b          	slliw	a4,a0,0x8
    800051a8:	0c0027b7          	lui	a5,0xc002
    800051ac:	97ba                	add	a5,a5,a4
    800051ae:	40200713          	li	a4,1026
    800051b2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051b6:	00d5151b          	slliw	a0,a0,0xd
    800051ba:	0c2017b7          	lui	a5,0xc201
    800051be:	97aa                	add	a5,a5,a0
    800051c0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051cc:	1141                	addi	sp,sp,-16
    800051ce:	e406                	sd	ra,8(sp)
    800051d0:	e022                	sd	s0,0(sp)
    800051d2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051d4:	ffffc097          	auipc	ra,0xffffc
    800051d8:	c78080e7          	jalr	-904(ra) # 80000e4c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051dc:	00d5151b          	slliw	a0,a0,0xd
    800051e0:	0c2017b7          	lui	a5,0xc201
    800051e4:	97aa                	add	a5,a5,a0
  return irq;
}
    800051e6:	43c8                	lw	a0,4(a5)
    800051e8:	60a2                	ld	ra,8(sp)
    800051ea:	6402                	ld	s0,0(sp)
    800051ec:	0141                	addi	sp,sp,16
    800051ee:	8082                	ret

00000000800051f0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051f0:	1101                	addi	sp,sp,-32
    800051f2:	ec06                	sd	ra,24(sp)
    800051f4:	e822                	sd	s0,16(sp)
    800051f6:	e426                	sd	s1,8(sp)
    800051f8:	1000                	addi	s0,sp,32
    800051fa:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051fc:	ffffc097          	auipc	ra,0xffffc
    80005200:	c50080e7          	jalr	-944(ra) # 80000e4c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005204:	00d5151b          	slliw	a0,a0,0xd
    80005208:	0c2017b7          	lui	a5,0xc201
    8000520c:	97aa                	add	a5,a5,a0
    8000520e:	c3c4                	sw	s1,4(a5)
}
    80005210:	60e2                	ld	ra,24(sp)
    80005212:	6442                	ld	s0,16(sp)
    80005214:	64a2                	ld	s1,8(sp)
    80005216:	6105                	addi	sp,sp,32
    80005218:	8082                	ret

000000008000521a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000521a:	1141                	addi	sp,sp,-16
    8000521c:	e406                	sd	ra,8(sp)
    8000521e:	e022                	sd	s0,0(sp)
    80005220:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005222:	479d                	li	a5,7
    80005224:	06a7c863          	blt	a5,a0,80005294 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005228:	00016717          	auipc	a4,0x16
    8000522c:	dd870713          	addi	a4,a4,-552 # 8001b000 <disk>
    80005230:	972a                	add	a4,a4,a0
    80005232:	6789                	lui	a5,0x2
    80005234:	97ba                	add	a5,a5,a4
    80005236:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000523a:	e7ad                	bnez	a5,800052a4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000523c:	00451793          	slli	a5,a0,0x4
    80005240:	00018717          	auipc	a4,0x18
    80005244:	dc070713          	addi	a4,a4,-576 # 8001d000 <disk+0x2000>
    80005248:	6314                	ld	a3,0(a4)
    8000524a:	96be                	add	a3,a3,a5
    8000524c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005250:	6314                	ld	a3,0(a4)
    80005252:	96be                	add	a3,a3,a5
    80005254:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005258:	6314                	ld	a3,0(a4)
    8000525a:	96be                	add	a3,a3,a5
    8000525c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005260:	6318                	ld	a4,0(a4)
    80005262:	97ba                	add	a5,a5,a4
    80005264:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005268:	00016717          	auipc	a4,0x16
    8000526c:	d9870713          	addi	a4,a4,-616 # 8001b000 <disk>
    80005270:	972a                	add	a4,a4,a0
    80005272:	6789                	lui	a5,0x2
    80005274:	97ba                	add	a5,a5,a4
    80005276:	4705                	li	a4,1
    80005278:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000527c:	00018517          	auipc	a0,0x18
    80005280:	d9c50513          	addi	a0,a0,-612 # 8001d018 <disk+0x2018>
    80005284:	ffffc097          	auipc	ra,0xffffc
    80005288:	4ca080e7          	jalr	1226(ra) # 8000174e <wakeup>
}
    8000528c:	60a2                	ld	ra,8(sp)
    8000528e:	6402                	ld	s0,0(sp)
    80005290:	0141                	addi	sp,sp,16
    80005292:	8082                	ret
    panic("free_desc 1");
    80005294:	00003517          	auipc	a0,0x3
    80005298:	35c50513          	addi	a0,a0,860 # 800085f0 <etext+0x5f0>
    8000529c:	00001097          	auipc	ra,0x1
    800052a0:	a10080e7          	jalr	-1520(ra) # 80005cac <panic>
    panic("free_desc 2");
    800052a4:	00003517          	auipc	a0,0x3
    800052a8:	35c50513          	addi	a0,a0,860 # 80008600 <etext+0x600>
    800052ac:	00001097          	auipc	ra,0x1
    800052b0:	a00080e7          	jalr	-1536(ra) # 80005cac <panic>

00000000800052b4 <virtio_disk_init>:
{
    800052b4:	1141                	addi	sp,sp,-16
    800052b6:	e406                	sd	ra,8(sp)
    800052b8:	e022                	sd	s0,0(sp)
    800052ba:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052bc:	00003597          	auipc	a1,0x3
    800052c0:	35458593          	addi	a1,a1,852 # 80008610 <etext+0x610>
    800052c4:	00018517          	auipc	a0,0x18
    800052c8:	e6450513          	addi	a0,a0,-412 # 8001d128 <disk+0x2128>
    800052cc:	00001097          	auipc	ra,0x1
    800052d0:	eca080e7          	jalr	-310(ra) # 80006196 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d4:	100017b7          	lui	a5,0x10001
    800052d8:	4398                	lw	a4,0(a5)
    800052da:	2701                	sext.w	a4,a4
    800052dc:	747277b7          	lui	a5,0x74727
    800052e0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052e4:	0ef71f63          	bne	a4,a5,800053e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052e8:	100017b7          	lui	a5,0x10001
    800052ec:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800052ee:	439c                	lw	a5,0(a5)
    800052f0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052f2:	4705                	li	a4,1
    800052f4:	0ee79763          	bne	a5,a4,800053e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f8:	100017b7          	lui	a5,0x10001
    800052fc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800052fe:	439c                	lw	a5,0(a5)
    80005300:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005302:	4709                	li	a4,2
    80005304:	0ce79f63          	bne	a5,a4,800053e2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005308:	100017b7          	lui	a5,0x10001
    8000530c:	47d8                	lw	a4,12(a5)
    8000530e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005310:	554d47b7          	lui	a5,0x554d4
    80005314:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005318:	0cf71563          	bne	a4,a5,800053e2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531c:	100017b7          	lui	a5,0x10001
    80005320:	4705                	li	a4,1
    80005322:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005324:	470d                	li	a4,3
    80005326:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005328:	10001737          	lui	a4,0x10001
    8000532c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000532e:	c7ffe737          	lui	a4,0xc7ffe
    80005332:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005336:	8ef9                	and	a3,a3,a4
    80005338:	10001737          	lui	a4,0x10001
    8000533c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000533e:	472d                	li	a4,11
    80005340:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005342:	473d                	li	a4,15
    80005344:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005346:	100017b7          	lui	a5,0x10001
    8000534a:	6705                	lui	a4,0x1
    8000534c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000534e:	100017b7          	lui	a5,0x10001
    80005352:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005356:	100017b7          	lui	a5,0x10001
    8000535a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000535e:	439c                	lw	a5,0(a5)
    80005360:	2781                	sext.w	a5,a5
  if(max == 0)
    80005362:	cbc1                	beqz	a5,800053f2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005364:	471d                	li	a4,7
    80005366:	08f77e63          	bgeu	a4,a5,80005402 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000536a:	100017b7          	lui	a5,0x10001
    8000536e:	4721                	li	a4,8
    80005370:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005372:	6609                	lui	a2,0x2
    80005374:	4581                	li	a1,0
    80005376:	00016517          	auipc	a0,0x16
    8000537a:	c8a50513          	addi	a0,a0,-886 # 8001b000 <disk>
    8000537e:	ffffb097          	auipc	ra,0xffffb
    80005382:	dfc080e7          	jalr	-516(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005386:	00016697          	auipc	a3,0x16
    8000538a:	c7a68693          	addi	a3,a3,-902 # 8001b000 <disk>
    8000538e:	00c6d713          	srli	a4,a3,0xc
    80005392:	2701                	sext.w	a4,a4
    80005394:	100017b7          	lui	a5,0x10001
    80005398:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000539a:	00018797          	auipc	a5,0x18
    8000539e:	c6678793          	addi	a5,a5,-922 # 8001d000 <disk+0x2000>
    800053a2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800053a4:	00016717          	auipc	a4,0x16
    800053a8:	cdc70713          	addi	a4,a4,-804 # 8001b080 <disk+0x80>
    800053ac:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800053ae:	00017717          	auipc	a4,0x17
    800053b2:	c5270713          	addi	a4,a4,-942 # 8001c000 <disk+0x1000>
    800053b6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800053b8:	4705                	li	a4,1
    800053ba:	00e78c23          	sb	a4,24(a5)
    800053be:	00e78ca3          	sb	a4,25(a5)
    800053c2:	00e78d23          	sb	a4,26(a5)
    800053c6:	00e78da3          	sb	a4,27(a5)
    800053ca:	00e78e23          	sb	a4,28(a5)
    800053ce:	00e78ea3          	sb	a4,29(a5)
    800053d2:	00e78f23          	sb	a4,30(a5)
    800053d6:	00e78fa3          	sb	a4,31(a5)
}
    800053da:	60a2                	ld	ra,8(sp)
    800053dc:	6402                	ld	s0,0(sp)
    800053de:	0141                	addi	sp,sp,16
    800053e0:	8082                	ret
    panic("could not find virtio disk");
    800053e2:	00003517          	auipc	a0,0x3
    800053e6:	23e50513          	addi	a0,a0,574 # 80008620 <etext+0x620>
    800053ea:	00001097          	auipc	ra,0x1
    800053ee:	8c2080e7          	jalr	-1854(ra) # 80005cac <panic>
    panic("virtio disk has no queue 0");
    800053f2:	00003517          	auipc	a0,0x3
    800053f6:	24e50513          	addi	a0,a0,590 # 80008640 <etext+0x640>
    800053fa:	00001097          	auipc	ra,0x1
    800053fe:	8b2080e7          	jalr	-1870(ra) # 80005cac <panic>
    panic("virtio disk max queue too short");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	25e50513          	addi	a0,a0,606 # 80008660 <etext+0x660>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	8a2080e7          	jalr	-1886(ra) # 80005cac <panic>

0000000080005412 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005412:	7159                	addi	sp,sp,-112
    80005414:	f486                	sd	ra,104(sp)
    80005416:	f0a2                	sd	s0,96(sp)
    80005418:	eca6                	sd	s1,88(sp)
    8000541a:	e8ca                	sd	s2,80(sp)
    8000541c:	e4ce                	sd	s3,72(sp)
    8000541e:	e0d2                	sd	s4,64(sp)
    80005420:	fc56                	sd	s5,56(sp)
    80005422:	f85a                	sd	s6,48(sp)
    80005424:	f45e                	sd	s7,40(sp)
    80005426:	f062                	sd	s8,32(sp)
    80005428:	ec66                	sd	s9,24(sp)
    8000542a:	1880                	addi	s0,sp,112
    8000542c:	8a2a                	mv	s4,a0
    8000542e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005430:	00c52c03          	lw	s8,12(a0)
    80005434:	001c1c1b          	slliw	s8,s8,0x1
    80005438:	1c02                	slli	s8,s8,0x20
    8000543a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000543e:	00018517          	auipc	a0,0x18
    80005442:	cea50513          	addi	a0,a0,-790 # 8001d128 <disk+0x2128>
    80005446:	00001097          	auipc	ra,0x1
    8000544a:	de0080e7          	jalr	-544(ra) # 80006226 <acquire>
  for(int i = 0; i < 3; i++){
    8000544e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005450:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005452:	00016b97          	auipc	s7,0x16
    80005456:	baeb8b93          	addi	s7,s7,-1106 # 8001b000 <disk>
    8000545a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000545c:	4a8d                	li	s5,3
    8000545e:	a88d                	j	800054d0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005460:	00fb8733          	add	a4,s7,a5
    80005464:	975a                	add	a4,a4,s6
    80005466:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000546a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000546c:	0207c563          	bltz	a5,80005496 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005470:	2905                	addiw	s2,s2,1
    80005472:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005474:	1b590163          	beq	s2,s5,80005616 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005478:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000547a:	00018717          	auipc	a4,0x18
    8000547e:	b9e70713          	addi	a4,a4,-1122 # 8001d018 <disk+0x2018>
    80005482:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005484:	00074683          	lbu	a3,0(a4)
    80005488:	fee1                	bnez	a3,80005460 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000548a:	2785                	addiw	a5,a5,1
    8000548c:	0705                	addi	a4,a4,1
    8000548e:	fe979be3          	bne	a5,s1,80005484 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005492:	57fd                	li	a5,-1
    80005494:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005496:	03205163          	blez	s2,800054b8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000549a:	f9042503          	lw	a0,-112(s0)
    8000549e:	00000097          	auipc	ra,0x0
    800054a2:	d7c080e7          	jalr	-644(ra) # 8000521a <free_desc>
      for(int j = 0; j < i; j++)
    800054a6:	4785                	li	a5,1
    800054a8:	0127d863          	bge	a5,s2,800054b8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800054ac:	f9442503          	lw	a0,-108(s0)
    800054b0:	00000097          	auipc	ra,0x0
    800054b4:	d6a080e7          	jalr	-662(ra) # 8000521a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054b8:	00018597          	auipc	a1,0x18
    800054bc:	c7058593          	addi	a1,a1,-912 # 8001d128 <disk+0x2128>
    800054c0:	00018517          	auipc	a0,0x18
    800054c4:	b5850513          	addi	a0,a0,-1192 # 8001d018 <disk+0x2018>
    800054c8:	ffffc097          	auipc	ra,0xffffc
    800054cc:	0fa080e7          	jalr	250(ra) # 800015c2 <sleep>
  for(int i = 0; i < 3; i++){
    800054d0:	f9040613          	addi	a2,s0,-112
    800054d4:	894e                	mv	s2,s3
    800054d6:	b74d                	j	80005478 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054d8:	00018717          	auipc	a4,0x18
    800054dc:	b2873703          	ld	a4,-1240(a4) # 8001d000 <disk+0x2000>
    800054e0:	973e                	add	a4,a4,a5
    800054e2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054e6:	00016897          	auipc	a7,0x16
    800054ea:	b1a88893          	addi	a7,a7,-1254 # 8001b000 <disk>
    800054ee:	00018717          	auipc	a4,0x18
    800054f2:	b1270713          	addi	a4,a4,-1262 # 8001d000 <disk+0x2000>
    800054f6:	6314                	ld	a3,0(a4)
    800054f8:	96be                	add	a3,a3,a5
    800054fa:	00c6d583          	lhu	a1,12(a3)
    800054fe:	0015e593          	ori	a1,a1,1
    80005502:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005506:	f9842683          	lw	a3,-104(s0)
    8000550a:	630c                	ld	a1,0(a4)
    8000550c:	97ae                	add	a5,a5,a1
    8000550e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005512:	20050593          	addi	a1,a0,512
    80005516:	0592                	slli	a1,a1,0x4
    80005518:	95c6                	add	a1,a1,a7
    8000551a:	57fd                	li	a5,-1
    8000551c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005520:	00469793          	slli	a5,a3,0x4
    80005524:	00073803          	ld	a6,0(a4)
    80005528:	983e                	add	a6,a6,a5
    8000552a:	6689                	lui	a3,0x2
    8000552c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005530:	96b2                	add	a3,a3,a2
    80005532:	96c6                	add	a3,a3,a7
    80005534:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005538:	6314                	ld	a3,0(a4)
    8000553a:	96be                	add	a3,a3,a5
    8000553c:	4605                	li	a2,1
    8000553e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005540:	6314                	ld	a3,0(a4)
    80005542:	96be                	add	a3,a3,a5
    80005544:	4809                	li	a6,2
    80005546:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000554a:	6314                	ld	a3,0(a4)
    8000554c:	97b6                	add	a5,a5,a3
    8000554e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005552:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005556:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000555a:	6714                	ld	a3,8(a4)
    8000555c:	0026d783          	lhu	a5,2(a3)
    80005560:	8b9d                	andi	a5,a5,7
    80005562:	0786                	slli	a5,a5,0x1
    80005564:	96be                	add	a3,a3,a5
    80005566:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000556a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000556e:	6718                	ld	a4,8(a4)
    80005570:	00275783          	lhu	a5,2(a4)
    80005574:	2785                	addiw	a5,a5,1
    80005576:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000557a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000557e:	100017b7          	lui	a5,0x10001
    80005582:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005586:	004a2783          	lw	a5,4(s4)
    8000558a:	02c79163          	bne	a5,a2,800055ac <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000558e:	00018917          	auipc	s2,0x18
    80005592:	b9a90913          	addi	s2,s2,-1126 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005596:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005598:	85ca                	mv	a1,s2
    8000559a:	8552                	mv	a0,s4
    8000559c:	ffffc097          	auipc	ra,0xffffc
    800055a0:	026080e7          	jalr	38(ra) # 800015c2 <sleep>
  while(b->disk == 1) {
    800055a4:	004a2783          	lw	a5,4(s4)
    800055a8:	fe9788e3          	beq	a5,s1,80005598 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800055ac:	f9042903          	lw	s2,-112(s0)
    800055b0:	20090713          	addi	a4,s2,512
    800055b4:	0712                	slli	a4,a4,0x4
    800055b6:	00016797          	auipc	a5,0x16
    800055ba:	a4a78793          	addi	a5,a5,-1462 # 8001b000 <disk>
    800055be:	97ba                	add	a5,a5,a4
    800055c0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800055c4:	00018997          	auipc	s3,0x18
    800055c8:	a3c98993          	addi	s3,s3,-1476 # 8001d000 <disk+0x2000>
    800055cc:	00491713          	slli	a4,s2,0x4
    800055d0:	0009b783          	ld	a5,0(s3)
    800055d4:	97ba                	add	a5,a5,a4
    800055d6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055da:	854a                	mv	a0,s2
    800055dc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055e0:	00000097          	auipc	ra,0x0
    800055e4:	c3a080e7          	jalr	-966(ra) # 8000521a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055e8:	8885                	andi	s1,s1,1
    800055ea:	f0ed                	bnez	s1,800055cc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055ec:	00018517          	auipc	a0,0x18
    800055f0:	b3c50513          	addi	a0,a0,-1220 # 8001d128 <disk+0x2128>
    800055f4:	00001097          	auipc	ra,0x1
    800055f8:	ce6080e7          	jalr	-794(ra) # 800062da <release>
}
    800055fc:	70a6                	ld	ra,104(sp)
    800055fe:	7406                	ld	s0,96(sp)
    80005600:	64e6                	ld	s1,88(sp)
    80005602:	6946                	ld	s2,80(sp)
    80005604:	69a6                	ld	s3,72(sp)
    80005606:	6a06                	ld	s4,64(sp)
    80005608:	7ae2                	ld	s5,56(sp)
    8000560a:	7b42                	ld	s6,48(sp)
    8000560c:	7ba2                	ld	s7,40(sp)
    8000560e:	7c02                	ld	s8,32(sp)
    80005610:	6ce2                	ld	s9,24(sp)
    80005612:	6165                	addi	sp,sp,112
    80005614:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005616:	f9042503          	lw	a0,-112(s0)
    8000561a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000561e:	00016597          	auipc	a1,0x16
    80005622:	9e258593          	addi	a1,a1,-1566 # 8001b000 <disk>
    80005626:	20050793          	addi	a5,a0,512
    8000562a:	0792                	slli	a5,a5,0x4
    8000562c:	97ae                	add	a5,a5,a1
    8000562e:	01903733          	snez	a4,s9
    80005632:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005636:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000563a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000563e:	00018717          	auipc	a4,0x18
    80005642:	9c270713          	addi	a4,a4,-1598 # 8001d000 <disk+0x2000>
    80005646:	6314                	ld	a3,0(a4)
    80005648:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000564a:	6789                	lui	a5,0x2
    8000564c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005650:	97b2                	add	a5,a5,a2
    80005652:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005654:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005656:	631c                	ld	a5,0(a4)
    80005658:	97b2                	add	a5,a5,a2
    8000565a:	46c1                	li	a3,16
    8000565c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000565e:	631c                	ld	a5,0(a4)
    80005660:	97b2                	add	a5,a5,a2
    80005662:	4685                	li	a3,1
    80005664:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005668:	f9442783          	lw	a5,-108(s0)
    8000566c:	6314                	ld	a3,0(a4)
    8000566e:	96b2                	add	a3,a3,a2
    80005670:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005674:	0792                	slli	a5,a5,0x4
    80005676:	6314                	ld	a3,0(a4)
    80005678:	96be                	add	a3,a3,a5
    8000567a:	058a0593          	addi	a1,s4,88
    8000567e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005680:	6318                	ld	a4,0(a4)
    80005682:	973e                	add	a4,a4,a5
    80005684:	40000693          	li	a3,1024
    80005688:	c714                	sw	a3,8(a4)
  if(write)
    8000568a:	e40c97e3          	bnez	s9,800054d8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000568e:	00018717          	auipc	a4,0x18
    80005692:	97273703          	ld	a4,-1678(a4) # 8001d000 <disk+0x2000>
    80005696:	973e                	add	a4,a4,a5
    80005698:	4689                	li	a3,2
    8000569a:	00d71623          	sh	a3,12(a4)
    8000569e:	b5a1                	j	800054e6 <virtio_disk_rw+0xd4>

00000000800056a0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056a0:	1101                	addi	sp,sp,-32
    800056a2:	ec06                	sd	ra,24(sp)
    800056a4:	e822                	sd	s0,16(sp)
    800056a6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800056a8:	00018517          	auipc	a0,0x18
    800056ac:	a8050513          	addi	a0,a0,-1408 # 8001d128 <disk+0x2128>
    800056b0:	00001097          	auipc	ra,0x1
    800056b4:	b76080e7          	jalr	-1162(ra) # 80006226 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056b8:	100017b7          	lui	a5,0x10001
    800056bc:	53b8                	lw	a4,96(a5)
    800056be:	8b0d                	andi	a4,a4,3
    800056c0:	100017b7          	lui	a5,0x10001
    800056c4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800056c6:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056ca:	00018797          	auipc	a5,0x18
    800056ce:	93678793          	addi	a5,a5,-1738 # 8001d000 <disk+0x2000>
    800056d2:	6b94                	ld	a3,16(a5)
    800056d4:	0207d703          	lhu	a4,32(a5)
    800056d8:	0026d783          	lhu	a5,2(a3)
    800056dc:	06f70563          	beq	a4,a5,80005746 <virtio_disk_intr+0xa6>
    800056e0:	e426                	sd	s1,8(sp)
    800056e2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056e4:	00016917          	auipc	s2,0x16
    800056e8:	91c90913          	addi	s2,s2,-1764 # 8001b000 <disk>
    800056ec:	00018497          	auipc	s1,0x18
    800056f0:	91448493          	addi	s1,s1,-1772 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056f4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056f8:	6898                	ld	a4,16(s1)
    800056fa:	0204d783          	lhu	a5,32(s1)
    800056fe:	8b9d                	andi	a5,a5,7
    80005700:	078e                	slli	a5,a5,0x3
    80005702:	97ba                	add	a5,a5,a4
    80005704:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005706:	20078713          	addi	a4,a5,512
    8000570a:	0712                	slli	a4,a4,0x4
    8000570c:	974a                	add	a4,a4,s2
    8000570e:	03074703          	lbu	a4,48(a4)
    80005712:	e731                	bnez	a4,8000575e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005714:	20078793          	addi	a5,a5,512
    80005718:	0792                	slli	a5,a5,0x4
    8000571a:	97ca                	add	a5,a5,s2
    8000571c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000571e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005722:	ffffc097          	auipc	ra,0xffffc
    80005726:	02c080e7          	jalr	44(ra) # 8000174e <wakeup>

    disk.used_idx += 1;
    8000572a:	0204d783          	lhu	a5,32(s1)
    8000572e:	2785                	addiw	a5,a5,1
    80005730:	17c2                	slli	a5,a5,0x30
    80005732:	93c1                	srli	a5,a5,0x30
    80005734:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005738:	6898                	ld	a4,16(s1)
    8000573a:	00275703          	lhu	a4,2(a4)
    8000573e:	faf71be3          	bne	a4,a5,800056f4 <virtio_disk_intr+0x54>
    80005742:	64a2                	ld	s1,8(sp)
    80005744:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005746:	00018517          	auipc	a0,0x18
    8000574a:	9e250513          	addi	a0,a0,-1566 # 8001d128 <disk+0x2128>
    8000574e:	00001097          	auipc	ra,0x1
    80005752:	b8c080e7          	jalr	-1140(ra) # 800062da <release>
}
    80005756:	60e2                	ld	ra,24(sp)
    80005758:	6442                	ld	s0,16(sp)
    8000575a:	6105                	addi	sp,sp,32
    8000575c:	8082                	ret
      panic("virtio_disk_intr status");
    8000575e:	00003517          	auipc	a0,0x3
    80005762:	f2250513          	addi	a0,a0,-222 # 80008680 <etext+0x680>
    80005766:	00000097          	auipc	ra,0x0
    8000576a:	546080e7          	jalr	1350(ra) # 80005cac <panic>

000000008000576e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000576e:	1141                	addi	sp,sp,-16
    80005770:	e422                	sd	s0,8(sp)
    80005772:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005774:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005778:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000577c:	0037979b          	slliw	a5,a5,0x3
    80005780:	02004737          	lui	a4,0x2004
    80005784:	97ba                	add	a5,a5,a4
    80005786:	0200c737          	lui	a4,0x200c
    8000578a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000578c:	6318                	ld	a4,0(a4)
    8000578e:	000f4637          	lui	a2,0xf4
    80005792:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005796:	9732                	add	a4,a4,a2
    80005798:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000579a:	00259693          	slli	a3,a1,0x2
    8000579e:	96ae                	add	a3,a3,a1
    800057a0:	068e                	slli	a3,a3,0x3
    800057a2:	00019717          	auipc	a4,0x19
    800057a6:	85e70713          	addi	a4,a4,-1954 # 8001e000 <timer_scratch>
    800057aa:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057ac:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057ae:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057b0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057b4:	00000797          	auipc	a5,0x0
    800057b8:	99c78793          	addi	a5,a5,-1636 # 80005150 <timervec>
    800057bc:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057c0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800057c4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057c8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057cc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057d0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057d4:	30479073          	csrw	mie,a5
}
    800057d8:	6422                	ld	s0,8(sp)
    800057da:	0141                	addi	sp,sp,16
    800057dc:	8082                	ret

00000000800057de <start>:
{
    800057de:	1141                	addi	sp,sp,-16
    800057e0:	e406                	sd	ra,8(sp)
    800057e2:	e022                	sd	s0,0(sp)
    800057e4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057e6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057ea:	7779                	lui	a4,0xffffe
    800057ec:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057f0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057f2:	6705                	lui	a4,0x1
    800057f4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057f8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057fa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057fe:	ffffb797          	auipc	a5,0xffffb
    80005802:	b1a78793          	addi	a5,a5,-1254 # 80000318 <main>
    80005806:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000580a:	4781                	li	a5,0
    8000580c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005810:	67c1                	lui	a5,0x10
    80005812:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005814:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005818:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000581c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005820:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005824:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005828:	57fd                	li	a5,-1
    8000582a:	83a9                	srli	a5,a5,0xa
    8000582c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005830:	47bd                	li	a5,15
    80005832:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005836:	00000097          	auipc	ra,0x0
    8000583a:	f38080e7          	jalr	-200(ra) # 8000576e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000583e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005842:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005844:	823e                	mv	tp,a5
  asm volatile("mret");
    80005846:	30200073          	mret
}
    8000584a:	60a2                	ld	ra,8(sp)
    8000584c:	6402                	ld	s0,0(sp)
    8000584e:	0141                	addi	sp,sp,16
    80005850:	8082                	ret

0000000080005852 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005852:	715d                	addi	sp,sp,-80
    80005854:	e486                	sd	ra,72(sp)
    80005856:	e0a2                	sd	s0,64(sp)
    80005858:	f84a                	sd	s2,48(sp)
    8000585a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000585c:	04c05663          	blez	a2,800058a8 <consolewrite+0x56>
    80005860:	fc26                	sd	s1,56(sp)
    80005862:	f44e                	sd	s3,40(sp)
    80005864:	f052                	sd	s4,32(sp)
    80005866:	ec56                	sd	s5,24(sp)
    80005868:	8a2a                	mv	s4,a0
    8000586a:	84ae                	mv	s1,a1
    8000586c:	89b2                	mv	s3,a2
    8000586e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005870:	5afd                	li	s5,-1
    80005872:	4685                	li	a3,1
    80005874:	8626                	mv	a2,s1
    80005876:	85d2                	mv	a1,s4
    80005878:	fbf40513          	addi	a0,s0,-65
    8000587c:	ffffc097          	auipc	ra,0xffffc
    80005880:	140080e7          	jalr	320(ra) # 800019bc <either_copyin>
    80005884:	03550463          	beq	a0,s5,800058ac <consolewrite+0x5a>
      break;
    uartputc(c);
    80005888:	fbf44503          	lbu	a0,-65(s0)
    8000588c:	00000097          	auipc	ra,0x0
    80005890:	7de080e7          	jalr	2014(ra) # 8000606a <uartputc>
  for(i = 0; i < n; i++){
    80005894:	2905                	addiw	s2,s2,1
    80005896:	0485                	addi	s1,s1,1
    80005898:	fd299de3          	bne	s3,s2,80005872 <consolewrite+0x20>
    8000589c:	894e                	mv	s2,s3
    8000589e:	74e2                	ld	s1,56(sp)
    800058a0:	79a2                	ld	s3,40(sp)
    800058a2:	7a02                	ld	s4,32(sp)
    800058a4:	6ae2                	ld	s5,24(sp)
    800058a6:	a039                	j	800058b4 <consolewrite+0x62>
    800058a8:	4901                	li	s2,0
    800058aa:	a029                	j	800058b4 <consolewrite+0x62>
    800058ac:	74e2                	ld	s1,56(sp)
    800058ae:	79a2                	ld	s3,40(sp)
    800058b0:	7a02                	ld	s4,32(sp)
    800058b2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    800058b4:	854a                	mv	a0,s2
    800058b6:	60a6                	ld	ra,72(sp)
    800058b8:	6406                	ld	s0,64(sp)
    800058ba:	7942                	ld	s2,48(sp)
    800058bc:	6161                	addi	sp,sp,80
    800058be:	8082                	ret

00000000800058c0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058c0:	711d                	addi	sp,sp,-96
    800058c2:	ec86                	sd	ra,88(sp)
    800058c4:	e8a2                	sd	s0,80(sp)
    800058c6:	e4a6                	sd	s1,72(sp)
    800058c8:	e0ca                	sd	s2,64(sp)
    800058ca:	fc4e                	sd	s3,56(sp)
    800058cc:	f852                	sd	s4,48(sp)
    800058ce:	f456                	sd	s5,40(sp)
    800058d0:	f05a                	sd	s6,32(sp)
    800058d2:	1080                	addi	s0,sp,96
    800058d4:	8aaa                	mv	s5,a0
    800058d6:	8a2e                	mv	s4,a1
    800058d8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058da:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058de:	00021517          	auipc	a0,0x21
    800058e2:	86250513          	addi	a0,a0,-1950 # 80026140 <cons>
    800058e6:	00001097          	auipc	ra,0x1
    800058ea:	940080e7          	jalr	-1728(ra) # 80006226 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058ee:	00021497          	auipc	s1,0x21
    800058f2:	85248493          	addi	s1,s1,-1966 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058f6:	00021917          	auipc	s2,0x21
    800058fa:	8e290913          	addi	s2,s2,-1822 # 800261d8 <cons+0x98>
  while(n > 0){
    800058fe:	0d305463          	blez	s3,800059c6 <consoleread+0x106>
    while(cons.r == cons.w){
    80005902:	0984a783          	lw	a5,152(s1)
    80005906:	09c4a703          	lw	a4,156(s1)
    8000590a:	0af71963          	bne	a4,a5,800059bc <consoleread+0xfc>
      if(myproc()->killed){
    8000590e:	ffffb097          	auipc	ra,0xffffb
    80005912:	56a080e7          	jalr	1386(ra) # 80000e78 <myproc>
    80005916:	551c                	lw	a5,40(a0)
    80005918:	e7ad                	bnez	a5,80005982 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    8000591a:	85a6                	mv	a1,s1
    8000591c:	854a                	mv	a0,s2
    8000591e:	ffffc097          	auipc	ra,0xffffc
    80005922:	ca4080e7          	jalr	-860(ra) # 800015c2 <sleep>
    while(cons.r == cons.w){
    80005926:	0984a783          	lw	a5,152(s1)
    8000592a:	09c4a703          	lw	a4,156(s1)
    8000592e:	fef700e3          	beq	a4,a5,8000590e <consoleread+0x4e>
    80005932:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005934:	00021717          	auipc	a4,0x21
    80005938:	80c70713          	addi	a4,a4,-2036 # 80026140 <cons>
    8000593c:	0017869b          	addiw	a3,a5,1
    80005940:	08d72c23          	sw	a3,152(a4)
    80005944:	07f7f693          	andi	a3,a5,127
    80005948:	9736                	add	a4,a4,a3
    8000594a:	01874703          	lbu	a4,24(a4)
    8000594e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005952:	4691                	li	a3,4
    80005954:	04db8a63          	beq	s7,a3,800059a8 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005958:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000595c:	4685                	li	a3,1
    8000595e:	faf40613          	addi	a2,s0,-81
    80005962:	85d2                	mv	a1,s4
    80005964:	8556                	mv	a0,s5
    80005966:	ffffc097          	auipc	ra,0xffffc
    8000596a:	000080e7          	jalr	ra # 80001966 <either_copyout>
    8000596e:	57fd                	li	a5,-1
    80005970:	04f50a63          	beq	a0,a5,800059c4 <consoleread+0x104>
      break;

    dst++;
    80005974:	0a05                	addi	s4,s4,1
    --n;
    80005976:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005978:	47a9                	li	a5,10
    8000597a:	06fb8163          	beq	s7,a5,800059dc <consoleread+0x11c>
    8000597e:	6be2                	ld	s7,24(sp)
    80005980:	bfbd                	j	800058fe <consoleread+0x3e>
        release(&cons.lock);
    80005982:	00020517          	auipc	a0,0x20
    80005986:	7be50513          	addi	a0,a0,1982 # 80026140 <cons>
    8000598a:	00001097          	auipc	ra,0x1
    8000598e:	950080e7          	jalr	-1712(ra) # 800062da <release>
        return -1;
    80005992:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005994:	60e6                	ld	ra,88(sp)
    80005996:	6446                	ld	s0,80(sp)
    80005998:	64a6                	ld	s1,72(sp)
    8000599a:	6906                	ld	s2,64(sp)
    8000599c:	79e2                	ld	s3,56(sp)
    8000599e:	7a42                	ld	s4,48(sp)
    800059a0:	7aa2                	ld	s5,40(sp)
    800059a2:	7b02                	ld	s6,32(sp)
    800059a4:	6125                	addi	sp,sp,96
    800059a6:	8082                	ret
      if(n < target){
    800059a8:	0009871b          	sext.w	a4,s3
    800059ac:	01677a63          	bgeu	a4,s6,800059c0 <consoleread+0x100>
        cons.r--;
    800059b0:	00021717          	auipc	a4,0x21
    800059b4:	82f72423          	sw	a5,-2008(a4) # 800261d8 <cons+0x98>
    800059b8:	6be2                	ld	s7,24(sp)
    800059ba:	a031                	j	800059c6 <consoleread+0x106>
    800059bc:	ec5e                	sd	s7,24(sp)
    800059be:	bf9d                	j	80005934 <consoleread+0x74>
    800059c0:	6be2                	ld	s7,24(sp)
    800059c2:	a011                	j	800059c6 <consoleread+0x106>
    800059c4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    800059c6:	00020517          	auipc	a0,0x20
    800059ca:	77a50513          	addi	a0,a0,1914 # 80026140 <cons>
    800059ce:	00001097          	auipc	ra,0x1
    800059d2:	90c080e7          	jalr	-1780(ra) # 800062da <release>
  return target - n;
    800059d6:	413b053b          	subw	a0,s6,s3
    800059da:	bf6d                	j	80005994 <consoleread+0xd4>
    800059dc:	6be2                	ld	s7,24(sp)
    800059de:	b7e5                	j	800059c6 <consoleread+0x106>

00000000800059e0 <consputc>:
{
    800059e0:	1141                	addi	sp,sp,-16
    800059e2:	e406                	sd	ra,8(sp)
    800059e4:	e022                	sd	s0,0(sp)
    800059e6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059e8:	10000793          	li	a5,256
    800059ec:	00f50a63          	beq	a0,a5,80005a00 <consputc+0x20>
    uartputc_sync(c);
    800059f0:	00000097          	auipc	ra,0x0
    800059f4:	59c080e7          	jalr	1436(ra) # 80005f8c <uartputc_sync>
}
    800059f8:	60a2                	ld	ra,8(sp)
    800059fa:	6402                	ld	s0,0(sp)
    800059fc:	0141                	addi	sp,sp,16
    800059fe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a00:	4521                	li	a0,8
    80005a02:	00000097          	auipc	ra,0x0
    80005a06:	58a080e7          	jalr	1418(ra) # 80005f8c <uartputc_sync>
    80005a0a:	02000513          	li	a0,32
    80005a0e:	00000097          	auipc	ra,0x0
    80005a12:	57e080e7          	jalr	1406(ra) # 80005f8c <uartputc_sync>
    80005a16:	4521                	li	a0,8
    80005a18:	00000097          	auipc	ra,0x0
    80005a1c:	574080e7          	jalr	1396(ra) # 80005f8c <uartputc_sync>
    80005a20:	bfe1                	j	800059f8 <consputc+0x18>

0000000080005a22 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a22:	1101                	addi	sp,sp,-32
    80005a24:	ec06                	sd	ra,24(sp)
    80005a26:	e822                	sd	s0,16(sp)
    80005a28:	e426                	sd	s1,8(sp)
    80005a2a:	1000                	addi	s0,sp,32
    80005a2c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a2e:	00020517          	auipc	a0,0x20
    80005a32:	71250513          	addi	a0,a0,1810 # 80026140 <cons>
    80005a36:	00000097          	auipc	ra,0x0
    80005a3a:	7f0080e7          	jalr	2032(ra) # 80006226 <acquire>

  switch(c){
    80005a3e:	47d5                	li	a5,21
    80005a40:	0af48563          	beq	s1,a5,80005aea <consoleintr+0xc8>
    80005a44:	0297c963          	blt	a5,s1,80005a76 <consoleintr+0x54>
    80005a48:	47a1                	li	a5,8
    80005a4a:	0ef48c63          	beq	s1,a5,80005b42 <consoleintr+0x120>
    80005a4e:	47c1                	li	a5,16
    80005a50:	10f49f63          	bne	s1,a5,80005b6e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005a54:	ffffc097          	auipc	ra,0xffffc
    80005a58:	fbe080e7          	jalr	-66(ra) # 80001a12 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a5c:	00020517          	auipc	a0,0x20
    80005a60:	6e450513          	addi	a0,a0,1764 # 80026140 <cons>
    80005a64:	00001097          	auipc	ra,0x1
    80005a68:	876080e7          	jalr	-1930(ra) # 800062da <release>
}
    80005a6c:	60e2                	ld	ra,24(sp)
    80005a6e:	6442                	ld	s0,16(sp)
    80005a70:	64a2                	ld	s1,8(sp)
    80005a72:	6105                	addi	sp,sp,32
    80005a74:	8082                	ret
  switch(c){
    80005a76:	07f00793          	li	a5,127
    80005a7a:	0cf48463          	beq	s1,a5,80005b42 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a7e:	00020717          	auipc	a4,0x20
    80005a82:	6c270713          	addi	a4,a4,1730 # 80026140 <cons>
    80005a86:	0a072783          	lw	a5,160(a4)
    80005a8a:	09872703          	lw	a4,152(a4)
    80005a8e:	9f99                	subw	a5,a5,a4
    80005a90:	07f00713          	li	a4,127
    80005a94:	fcf764e3          	bltu	a4,a5,80005a5c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005a98:	47b5                	li	a5,13
    80005a9a:	0cf48d63          	beq	s1,a5,80005b74 <consoleintr+0x152>
      consputc(c);
    80005a9e:	8526                	mv	a0,s1
    80005aa0:	00000097          	auipc	ra,0x0
    80005aa4:	f40080e7          	jalr	-192(ra) # 800059e0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005aa8:	00020797          	auipc	a5,0x20
    80005aac:	69878793          	addi	a5,a5,1688 # 80026140 <cons>
    80005ab0:	0a07a703          	lw	a4,160(a5)
    80005ab4:	0017069b          	addiw	a3,a4,1
    80005ab8:	0006861b          	sext.w	a2,a3
    80005abc:	0ad7a023          	sw	a3,160(a5)
    80005ac0:	07f77713          	andi	a4,a4,127
    80005ac4:	97ba                	add	a5,a5,a4
    80005ac6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005aca:	47a9                	li	a5,10
    80005acc:	0cf48b63          	beq	s1,a5,80005ba2 <consoleintr+0x180>
    80005ad0:	4791                	li	a5,4
    80005ad2:	0cf48863          	beq	s1,a5,80005ba2 <consoleintr+0x180>
    80005ad6:	00020797          	auipc	a5,0x20
    80005ada:	7027a783          	lw	a5,1794(a5) # 800261d8 <cons+0x98>
    80005ade:	0807879b          	addiw	a5,a5,128
    80005ae2:	f6f61de3          	bne	a2,a5,80005a5c <consoleintr+0x3a>
    80005ae6:	863e                	mv	a2,a5
    80005ae8:	a86d                	j	80005ba2 <consoleintr+0x180>
    80005aea:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005aec:	00020717          	auipc	a4,0x20
    80005af0:	65470713          	addi	a4,a4,1620 # 80026140 <cons>
    80005af4:	0a072783          	lw	a5,160(a4)
    80005af8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005afc:	00020497          	auipc	s1,0x20
    80005b00:	64448493          	addi	s1,s1,1604 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005b04:	4929                	li	s2,10
    80005b06:	02f70a63          	beq	a4,a5,80005b3a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005b0a:	37fd                	addiw	a5,a5,-1
    80005b0c:	07f7f713          	andi	a4,a5,127
    80005b10:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b12:	01874703          	lbu	a4,24(a4)
    80005b16:	03270463          	beq	a4,s2,80005b3e <consoleintr+0x11c>
      cons.e--;
    80005b1a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b1e:	10000513          	li	a0,256
    80005b22:	00000097          	auipc	ra,0x0
    80005b26:	ebe080e7          	jalr	-322(ra) # 800059e0 <consputc>
    while(cons.e != cons.w &&
    80005b2a:	0a04a783          	lw	a5,160(s1)
    80005b2e:	09c4a703          	lw	a4,156(s1)
    80005b32:	fcf71ce3          	bne	a4,a5,80005b0a <consoleintr+0xe8>
    80005b36:	6902                	ld	s2,0(sp)
    80005b38:	b715                	j	80005a5c <consoleintr+0x3a>
    80005b3a:	6902                	ld	s2,0(sp)
    80005b3c:	b705                	j	80005a5c <consoleintr+0x3a>
    80005b3e:	6902                	ld	s2,0(sp)
    80005b40:	bf31                	j	80005a5c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005b42:	00020717          	auipc	a4,0x20
    80005b46:	5fe70713          	addi	a4,a4,1534 # 80026140 <cons>
    80005b4a:	0a072783          	lw	a5,160(a4)
    80005b4e:	09c72703          	lw	a4,156(a4)
    80005b52:	f0f705e3          	beq	a4,a5,80005a5c <consoleintr+0x3a>
      cons.e--;
    80005b56:	37fd                	addiw	a5,a5,-1
    80005b58:	00020717          	auipc	a4,0x20
    80005b5c:	68f72423          	sw	a5,1672(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b60:	10000513          	li	a0,256
    80005b64:	00000097          	auipc	ra,0x0
    80005b68:	e7c080e7          	jalr	-388(ra) # 800059e0 <consputc>
    80005b6c:	bdc5                	j	80005a5c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b6e:	ee0487e3          	beqz	s1,80005a5c <consoleintr+0x3a>
    80005b72:	b731                	j	80005a7e <consoleintr+0x5c>
      consputc(c);
    80005b74:	4529                	li	a0,10
    80005b76:	00000097          	auipc	ra,0x0
    80005b7a:	e6a080e7          	jalr	-406(ra) # 800059e0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b7e:	00020797          	auipc	a5,0x20
    80005b82:	5c278793          	addi	a5,a5,1474 # 80026140 <cons>
    80005b86:	0a07a703          	lw	a4,160(a5)
    80005b8a:	0017069b          	addiw	a3,a4,1
    80005b8e:	0006861b          	sext.w	a2,a3
    80005b92:	0ad7a023          	sw	a3,160(a5)
    80005b96:	07f77713          	andi	a4,a4,127
    80005b9a:	97ba                	add	a5,a5,a4
    80005b9c:	4729                	li	a4,10
    80005b9e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005ba2:	00020797          	auipc	a5,0x20
    80005ba6:	62c7ad23          	sw	a2,1594(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005baa:	00020517          	auipc	a0,0x20
    80005bae:	62e50513          	addi	a0,a0,1582 # 800261d8 <cons+0x98>
    80005bb2:	ffffc097          	auipc	ra,0xffffc
    80005bb6:	b9c080e7          	jalr	-1124(ra) # 8000174e <wakeup>
    80005bba:	b54d                	j	80005a5c <consoleintr+0x3a>

0000000080005bbc <consoleinit>:

void
consoleinit(void)
{
    80005bbc:	1141                	addi	sp,sp,-16
    80005bbe:	e406                	sd	ra,8(sp)
    80005bc0:	e022                	sd	s0,0(sp)
    80005bc2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bc4:	00003597          	auipc	a1,0x3
    80005bc8:	ad458593          	addi	a1,a1,-1324 # 80008698 <etext+0x698>
    80005bcc:	00020517          	auipc	a0,0x20
    80005bd0:	57450513          	addi	a0,a0,1396 # 80026140 <cons>
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	5c2080e7          	jalr	1474(ra) # 80006196 <initlock>

  uartinit();
    80005bdc:	00000097          	auipc	ra,0x0
    80005be0:	354080e7          	jalr	852(ra) # 80005f30 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005be4:	00013797          	auipc	a5,0x13
    80005be8:	6e478793          	addi	a5,a5,1764 # 800192c8 <devsw>
    80005bec:	00000717          	auipc	a4,0x0
    80005bf0:	cd470713          	addi	a4,a4,-812 # 800058c0 <consoleread>
    80005bf4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bf6:	00000717          	auipc	a4,0x0
    80005bfa:	c5c70713          	addi	a4,a4,-932 # 80005852 <consolewrite>
    80005bfe:	ef98                	sd	a4,24(a5)
}
    80005c00:	60a2                	ld	ra,8(sp)
    80005c02:	6402                	ld	s0,0(sp)
    80005c04:	0141                	addi	sp,sp,16
    80005c06:	8082                	ret

0000000080005c08 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c08:	7179                	addi	sp,sp,-48
    80005c0a:	f406                	sd	ra,40(sp)
    80005c0c:	f022                	sd	s0,32(sp)
    80005c0e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c10:	c219                	beqz	a2,80005c16 <printint+0xe>
    80005c12:	08054963          	bltz	a0,80005ca4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005c16:	2501                	sext.w	a0,a0
    80005c18:	4881                	li	a7,0
    80005c1a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c1e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c20:	2581                	sext.w	a1,a1
    80005c22:	00003617          	auipc	a2,0x3
    80005c26:	c1e60613          	addi	a2,a2,-994 # 80008840 <digits>
    80005c2a:	883a                	mv	a6,a4
    80005c2c:	2705                	addiw	a4,a4,1
    80005c2e:	02b577bb          	remuw	a5,a0,a1
    80005c32:	1782                	slli	a5,a5,0x20
    80005c34:	9381                	srli	a5,a5,0x20
    80005c36:	97b2                	add	a5,a5,a2
    80005c38:	0007c783          	lbu	a5,0(a5)
    80005c3c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c40:	0005079b          	sext.w	a5,a0
    80005c44:	02b5553b          	divuw	a0,a0,a1
    80005c48:	0685                	addi	a3,a3,1
    80005c4a:	feb7f0e3          	bgeu	a5,a1,80005c2a <printint+0x22>

  if(sign)
    80005c4e:	00088c63          	beqz	a7,80005c66 <printint+0x5e>
    buf[i++] = '-';
    80005c52:	fe070793          	addi	a5,a4,-32
    80005c56:	00878733          	add	a4,a5,s0
    80005c5a:	02d00793          	li	a5,45
    80005c5e:	fef70823          	sb	a5,-16(a4)
    80005c62:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c66:	02e05b63          	blez	a4,80005c9c <printint+0x94>
    80005c6a:	ec26                	sd	s1,24(sp)
    80005c6c:	e84a                	sd	s2,16(sp)
    80005c6e:	fd040793          	addi	a5,s0,-48
    80005c72:	00e784b3          	add	s1,a5,a4
    80005c76:	fff78913          	addi	s2,a5,-1
    80005c7a:	993a                	add	s2,s2,a4
    80005c7c:	377d                	addiw	a4,a4,-1
    80005c7e:	1702                	slli	a4,a4,0x20
    80005c80:	9301                	srli	a4,a4,0x20
    80005c82:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c86:	fff4c503          	lbu	a0,-1(s1)
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	d56080e7          	jalr	-682(ra) # 800059e0 <consputc>
  while(--i >= 0)
    80005c92:	14fd                	addi	s1,s1,-1
    80005c94:	ff2499e3          	bne	s1,s2,80005c86 <printint+0x7e>
    80005c98:	64e2                	ld	s1,24(sp)
    80005c9a:	6942                	ld	s2,16(sp)
}
    80005c9c:	70a2                	ld	ra,40(sp)
    80005c9e:	7402                	ld	s0,32(sp)
    80005ca0:	6145                	addi	sp,sp,48
    80005ca2:	8082                	ret
    x = -xx;
    80005ca4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ca8:	4885                	li	a7,1
    x = -xx;
    80005caa:	bf85                	j	80005c1a <printint+0x12>

0000000080005cac <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005cac:	1101                	addi	sp,sp,-32
    80005cae:	ec06                	sd	ra,24(sp)
    80005cb0:	e822                	sd	s0,16(sp)
    80005cb2:	e426                	sd	s1,8(sp)
    80005cb4:	1000                	addi	s0,sp,32
    80005cb6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cb8:	00020797          	auipc	a5,0x20
    80005cbc:	5407a423          	sw	zero,1352(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005cc0:	00003517          	auipc	a0,0x3
    80005cc4:	9e050513          	addi	a0,a0,-1568 # 800086a0 <etext+0x6a0>
    80005cc8:	00000097          	auipc	ra,0x0
    80005ccc:	02e080e7          	jalr	46(ra) # 80005cf6 <printf>
  printf(s);
    80005cd0:	8526                	mv	a0,s1
    80005cd2:	00000097          	auipc	ra,0x0
    80005cd6:	024080e7          	jalr	36(ra) # 80005cf6 <printf>
  printf("\n");
    80005cda:	00002517          	auipc	a0,0x2
    80005cde:	33e50513          	addi	a0,a0,830 # 80008018 <etext+0x18>
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	014080e7          	jalr	20(ra) # 80005cf6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cea:	4785                	li	a5,1
    80005cec:	00003717          	auipc	a4,0x3
    80005cf0:	32f72823          	sw	a5,816(a4) # 8000901c <panicked>
  for(;;)
    80005cf4:	a001                	j	80005cf4 <panic+0x48>

0000000080005cf6 <printf>:
{
    80005cf6:	7131                	addi	sp,sp,-192
    80005cf8:	fc86                	sd	ra,120(sp)
    80005cfa:	f8a2                	sd	s0,112(sp)
    80005cfc:	e8d2                	sd	s4,80(sp)
    80005cfe:	f06a                	sd	s10,32(sp)
    80005d00:	0100                	addi	s0,sp,128
    80005d02:	8a2a                	mv	s4,a0
    80005d04:	e40c                	sd	a1,8(s0)
    80005d06:	e810                	sd	a2,16(s0)
    80005d08:	ec14                	sd	a3,24(s0)
    80005d0a:	f018                	sd	a4,32(s0)
    80005d0c:	f41c                	sd	a5,40(s0)
    80005d0e:	03043823          	sd	a6,48(s0)
    80005d12:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d16:	00020d17          	auipc	s10,0x20
    80005d1a:	4ead2d03          	lw	s10,1258(s10) # 80026200 <pr+0x18>
  if(locking)
    80005d1e:	040d1463          	bnez	s10,80005d66 <printf+0x70>
  if (fmt == 0)
    80005d22:	040a0b63          	beqz	s4,80005d78 <printf+0x82>
  va_start(ap, fmt);
    80005d26:	00840793          	addi	a5,s0,8
    80005d2a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d2e:	000a4503          	lbu	a0,0(s4)
    80005d32:	18050b63          	beqz	a0,80005ec8 <printf+0x1d2>
    80005d36:	f4a6                	sd	s1,104(sp)
    80005d38:	f0ca                	sd	s2,96(sp)
    80005d3a:	ecce                	sd	s3,88(sp)
    80005d3c:	e4d6                	sd	s5,72(sp)
    80005d3e:	e0da                	sd	s6,64(sp)
    80005d40:	fc5e                	sd	s7,56(sp)
    80005d42:	f862                	sd	s8,48(sp)
    80005d44:	f466                	sd	s9,40(sp)
    80005d46:	ec6e                	sd	s11,24(sp)
    80005d48:	4981                	li	s3,0
    if(c != '%'){
    80005d4a:	02500b13          	li	s6,37
    switch(c){
    80005d4e:	07000b93          	li	s7,112
  consputc('x');
    80005d52:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d54:	00003a97          	auipc	s5,0x3
    80005d58:	aeca8a93          	addi	s5,s5,-1300 # 80008840 <digits>
    switch(c){
    80005d5c:	07300c13          	li	s8,115
    80005d60:	06400d93          	li	s11,100
    80005d64:	a0b1                	j	80005db0 <printf+0xba>
    acquire(&pr.lock);
    80005d66:	00020517          	auipc	a0,0x20
    80005d6a:	48250513          	addi	a0,a0,1154 # 800261e8 <pr>
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	4b8080e7          	jalr	1208(ra) # 80006226 <acquire>
    80005d76:	b775                	j	80005d22 <printf+0x2c>
    80005d78:	f4a6                	sd	s1,104(sp)
    80005d7a:	f0ca                	sd	s2,96(sp)
    80005d7c:	ecce                	sd	s3,88(sp)
    80005d7e:	e4d6                	sd	s5,72(sp)
    80005d80:	e0da                	sd	s6,64(sp)
    80005d82:	fc5e                	sd	s7,56(sp)
    80005d84:	f862                	sd	s8,48(sp)
    80005d86:	f466                	sd	s9,40(sp)
    80005d88:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005d8a:	00003517          	auipc	a0,0x3
    80005d8e:	92650513          	addi	a0,a0,-1754 # 800086b0 <etext+0x6b0>
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	f1a080e7          	jalr	-230(ra) # 80005cac <panic>
      consputc(c);
    80005d9a:	00000097          	auipc	ra,0x0
    80005d9e:	c46080e7          	jalr	-954(ra) # 800059e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005da2:	2985                	addiw	s3,s3,1
    80005da4:	013a07b3          	add	a5,s4,s3
    80005da8:	0007c503          	lbu	a0,0(a5)
    80005dac:	10050563          	beqz	a0,80005eb6 <printf+0x1c0>
    if(c != '%'){
    80005db0:	ff6515e3          	bne	a0,s6,80005d9a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005db4:	2985                	addiw	s3,s3,1
    80005db6:	013a07b3          	add	a5,s4,s3
    80005dba:	0007c783          	lbu	a5,0(a5)
    80005dbe:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005dc2:	10078b63          	beqz	a5,80005ed8 <printf+0x1e2>
    switch(c){
    80005dc6:	05778a63          	beq	a5,s7,80005e1a <printf+0x124>
    80005dca:	02fbf663          	bgeu	s7,a5,80005df6 <printf+0x100>
    80005dce:	09878863          	beq	a5,s8,80005e5e <printf+0x168>
    80005dd2:	07800713          	li	a4,120
    80005dd6:	0ce79563          	bne	a5,a4,80005ea0 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005dda:	f8843783          	ld	a5,-120(s0)
    80005dde:	00878713          	addi	a4,a5,8
    80005de2:	f8e43423          	sd	a4,-120(s0)
    80005de6:	4605                	li	a2,1
    80005de8:	85e6                	mv	a1,s9
    80005dea:	4388                	lw	a0,0(a5)
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	e1c080e7          	jalr	-484(ra) # 80005c08 <printint>
      break;
    80005df4:	b77d                	j	80005da2 <printf+0xac>
    switch(c){
    80005df6:	09678f63          	beq	a5,s6,80005e94 <printf+0x19e>
    80005dfa:	0bb79363          	bne	a5,s11,80005ea0 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005dfe:	f8843783          	ld	a5,-120(s0)
    80005e02:	00878713          	addi	a4,a5,8
    80005e06:	f8e43423          	sd	a4,-120(s0)
    80005e0a:	4605                	li	a2,1
    80005e0c:	45a9                	li	a1,10
    80005e0e:	4388                	lw	a0,0(a5)
    80005e10:	00000097          	auipc	ra,0x0
    80005e14:	df8080e7          	jalr	-520(ra) # 80005c08 <printint>
      break;
    80005e18:	b769                	j	80005da2 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005e1a:	f8843783          	ld	a5,-120(s0)
    80005e1e:	00878713          	addi	a4,a5,8
    80005e22:	f8e43423          	sd	a4,-120(s0)
    80005e26:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005e2a:	03000513          	li	a0,48
    80005e2e:	00000097          	auipc	ra,0x0
    80005e32:	bb2080e7          	jalr	-1102(ra) # 800059e0 <consputc>
  consputc('x');
    80005e36:	07800513          	li	a0,120
    80005e3a:	00000097          	auipc	ra,0x0
    80005e3e:	ba6080e7          	jalr	-1114(ra) # 800059e0 <consputc>
    80005e42:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e44:	03c95793          	srli	a5,s2,0x3c
    80005e48:	97d6                	add	a5,a5,s5
    80005e4a:	0007c503          	lbu	a0,0(a5)
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	b92080e7          	jalr	-1134(ra) # 800059e0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e56:	0912                	slli	s2,s2,0x4
    80005e58:	34fd                	addiw	s1,s1,-1
    80005e5a:	f4ed                	bnez	s1,80005e44 <printf+0x14e>
    80005e5c:	b799                	j	80005da2 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005e5e:	f8843783          	ld	a5,-120(s0)
    80005e62:	00878713          	addi	a4,a5,8
    80005e66:	f8e43423          	sd	a4,-120(s0)
    80005e6a:	6384                	ld	s1,0(a5)
    80005e6c:	cc89                	beqz	s1,80005e86 <printf+0x190>
      for(; *s; s++)
    80005e6e:	0004c503          	lbu	a0,0(s1)
    80005e72:	d905                	beqz	a0,80005da2 <printf+0xac>
        consputc(*s);
    80005e74:	00000097          	auipc	ra,0x0
    80005e78:	b6c080e7          	jalr	-1172(ra) # 800059e0 <consputc>
      for(; *s; s++)
    80005e7c:	0485                	addi	s1,s1,1
    80005e7e:	0004c503          	lbu	a0,0(s1)
    80005e82:	f96d                	bnez	a0,80005e74 <printf+0x17e>
    80005e84:	bf39                	j	80005da2 <printf+0xac>
        s = "(null)";
    80005e86:	00003497          	auipc	s1,0x3
    80005e8a:	82248493          	addi	s1,s1,-2014 # 800086a8 <etext+0x6a8>
      for(; *s; s++)
    80005e8e:	02800513          	li	a0,40
    80005e92:	b7cd                	j	80005e74 <printf+0x17e>
      consputc('%');
    80005e94:	855a                	mv	a0,s6
    80005e96:	00000097          	auipc	ra,0x0
    80005e9a:	b4a080e7          	jalr	-1206(ra) # 800059e0 <consputc>
      break;
    80005e9e:	b711                	j	80005da2 <printf+0xac>
      consputc('%');
    80005ea0:	855a                	mv	a0,s6
    80005ea2:	00000097          	auipc	ra,0x0
    80005ea6:	b3e080e7          	jalr	-1218(ra) # 800059e0 <consputc>
      consputc(c);
    80005eaa:	8526                	mv	a0,s1
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	b34080e7          	jalr	-1228(ra) # 800059e0 <consputc>
      break;
    80005eb4:	b5fd                	j	80005da2 <printf+0xac>
    80005eb6:	74a6                	ld	s1,104(sp)
    80005eb8:	7906                	ld	s2,96(sp)
    80005eba:	69e6                	ld	s3,88(sp)
    80005ebc:	6aa6                	ld	s5,72(sp)
    80005ebe:	6b06                	ld	s6,64(sp)
    80005ec0:	7be2                	ld	s7,56(sp)
    80005ec2:	7c42                	ld	s8,48(sp)
    80005ec4:	7ca2                	ld	s9,40(sp)
    80005ec6:	6de2                	ld	s11,24(sp)
  if(locking)
    80005ec8:	020d1263          	bnez	s10,80005eec <printf+0x1f6>
}
    80005ecc:	70e6                	ld	ra,120(sp)
    80005ece:	7446                	ld	s0,112(sp)
    80005ed0:	6a46                	ld	s4,80(sp)
    80005ed2:	7d02                	ld	s10,32(sp)
    80005ed4:	6129                	addi	sp,sp,192
    80005ed6:	8082                	ret
    80005ed8:	74a6                	ld	s1,104(sp)
    80005eda:	7906                	ld	s2,96(sp)
    80005edc:	69e6                	ld	s3,88(sp)
    80005ede:	6aa6                	ld	s5,72(sp)
    80005ee0:	6b06                	ld	s6,64(sp)
    80005ee2:	7be2                	ld	s7,56(sp)
    80005ee4:	7c42                	ld	s8,48(sp)
    80005ee6:	7ca2                	ld	s9,40(sp)
    80005ee8:	6de2                	ld	s11,24(sp)
    80005eea:	bff9                	j	80005ec8 <printf+0x1d2>
    release(&pr.lock);
    80005eec:	00020517          	auipc	a0,0x20
    80005ef0:	2fc50513          	addi	a0,a0,764 # 800261e8 <pr>
    80005ef4:	00000097          	auipc	ra,0x0
    80005ef8:	3e6080e7          	jalr	998(ra) # 800062da <release>
}
    80005efc:	bfc1                	j	80005ecc <printf+0x1d6>

0000000080005efe <printfinit>:
    ;
}

void
printfinit(void)
{
    80005efe:	1101                	addi	sp,sp,-32
    80005f00:	ec06                	sd	ra,24(sp)
    80005f02:	e822                	sd	s0,16(sp)
    80005f04:	e426                	sd	s1,8(sp)
    80005f06:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f08:	00020497          	auipc	s1,0x20
    80005f0c:	2e048493          	addi	s1,s1,736 # 800261e8 <pr>
    80005f10:	00002597          	auipc	a1,0x2
    80005f14:	7b058593          	addi	a1,a1,1968 # 800086c0 <etext+0x6c0>
    80005f18:	8526                	mv	a0,s1
    80005f1a:	00000097          	auipc	ra,0x0
    80005f1e:	27c080e7          	jalr	636(ra) # 80006196 <initlock>
  pr.locking = 1;
    80005f22:	4785                	li	a5,1
    80005f24:	cc9c                	sw	a5,24(s1)
}
    80005f26:	60e2                	ld	ra,24(sp)
    80005f28:	6442                	ld	s0,16(sp)
    80005f2a:	64a2                	ld	s1,8(sp)
    80005f2c:	6105                	addi	sp,sp,32
    80005f2e:	8082                	ret

0000000080005f30 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f30:	1141                	addi	sp,sp,-16
    80005f32:	e406                	sd	ra,8(sp)
    80005f34:	e022                	sd	s0,0(sp)
    80005f36:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f38:	100007b7          	lui	a5,0x10000
    80005f3c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f40:	10000737          	lui	a4,0x10000
    80005f44:	f8000693          	li	a3,-128
    80005f48:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f4c:	468d                	li	a3,3
    80005f4e:	10000637          	lui	a2,0x10000
    80005f52:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f56:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f5a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f5e:	10000737          	lui	a4,0x10000
    80005f62:	461d                	li	a2,7
    80005f64:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f68:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f6c:	00002597          	auipc	a1,0x2
    80005f70:	75c58593          	addi	a1,a1,1884 # 800086c8 <etext+0x6c8>
    80005f74:	00020517          	auipc	a0,0x20
    80005f78:	29450513          	addi	a0,a0,660 # 80026208 <uart_tx_lock>
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	21a080e7          	jalr	538(ra) # 80006196 <initlock>
}
    80005f84:	60a2                	ld	ra,8(sp)
    80005f86:	6402                	ld	s0,0(sp)
    80005f88:	0141                	addi	sp,sp,16
    80005f8a:	8082                	ret

0000000080005f8c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f8c:	1101                	addi	sp,sp,-32
    80005f8e:	ec06                	sd	ra,24(sp)
    80005f90:	e822                	sd	s0,16(sp)
    80005f92:	e426                	sd	s1,8(sp)
    80005f94:	1000                	addi	s0,sp,32
    80005f96:	84aa                	mv	s1,a0
  push_off();
    80005f98:	00000097          	auipc	ra,0x0
    80005f9c:	242080e7          	jalr	578(ra) # 800061da <push_off>

  if(panicked){
    80005fa0:	00003797          	auipc	a5,0x3
    80005fa4:	07c7a783          	lw	a5,124(a5) # 8000901c <panicked>
    80005fa8:	eb85                	bnez	a5,80005fd8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005faa:	10000737          	lui	a4,0x10000
    80005fae:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005fb0:	00074783          	lbu	a5,0(a4)
    80005fb4:	0207f793          	andi	a5,a5,32
    80005fb8:	dfe5                	beqz	a5,80005fb0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fba:	0ff4f513          	zext.b	a0,s1
    80005fbe:	100007b7          	lui	a5,0x10000
    80005fc2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fc6:	00000097          	auipc	ra,0x0
    80005fca:	2b4080e7          	jalr	692(ra) # 8000627a <pop_off>
}
    80005fce:	60e2                	ld	ra,24(sp)
    80005fd0:	6442                	ld	s0,16(sp)
    80005fd2:	64a2                	ld	s1,8(sp)
    80005fd4:	6105                	addi	sp,sp,32
    80005fd6:	8082                	ret
    for(;;)
    80005fd8:	a001                	j	80005fd8 <uartputc_sync+0x4c>

0000000080005fda <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005fda:	00003797          	auipc	a5,0x3
    80005fde:	0467b783          	ld	a5,70(a5) # 80009020 <uart_tx_r>
    80005fe2:	00003717          	auipc	a4,0x3
    80005fe6:	04673703          	ld	a4,70(a4) # 80009028 <uart_tx_w>
    80005fea:	06f70f63          	beq	a4,a5,80006068 <uartstart+0x8e>
{
    80005fee:	7139                	addi	sp,sp,-64
    80005ff0:	fc06                	sd	ra,56(sp)
    80005ff2:	f822                	sd	s0,48(sp)
    80005ff4:	f426                	sd	s1,40(sp)
    80005ff6:	f04a                	sd	s2,32(sp)
    80005ff8:	ec4e                	sd	s3,24(sp)
    80005ffa:	e852                	sd	s4,16(sp)
    80005ffc:	e456                	sd	s5,8(sp)
    80005ffe:	e05a                	sd	s6,0(sp)
    80006000:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006002:	10000937          	lui	s2,0x10000
    80006006:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006008:	00020a97          	auipc	s5,0x20
    8000600c:	200a8a93          	addi	s5,s5,512 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80006010:	00003497          	auipc	s1,0x3
    80006014:	01048493          	addi	s1,s1,16 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006018:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000601c:	00003997          	auipc	s3,0x3
    80006020:	00c98993          	addi	s3,s3,12 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006024:	00094703          	lbu	a4,0(s2)
    80006028:	02077713          	andi	a4,a4,32
    8000602c:	c705                	beqz	a4,80006054 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000602e:	01f7f713          	andi	a4,a5,31
    80006032:	9756                	add	a4,a4,s5
    80006034:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006038:	0785                	addi	a5,a5,1
    8000603a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000603c:	8526                	mv	a0,s1
    8000603e:	ffffb097          	auipc	ra,0xffffb
    80006042:	710080e7          	jalr	1808(ra) # 8000174e <wakeup>
    WriteReg(THR, c);
    80006046:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000604a:	609c                	ld	a5,0(s1)
    8000604c:	0009b703          	ld	a4,0(s3)
    80006050:	fcf71ae3          	bne	a4,a5,80006024 <uartstart+0x4a>
  }
}
    80006054:	70e2                	ld	ra,56(sp)
    80006056:	7442                	ld	s0,48(sp)
    80006058:	74a2                	ld	s1,40(sp)
    8000605a:	7902                	ld	s2,32(sp)
    8000605c:	69e2                	ld	s3,24(sp)
    8000605e:	6a42                	ld	s4,16(sp)
    80006060:	6aa2                	ld	s5,8(sp)
    80006062:	6b02                	ld	s6,0(sp)
    80006064:	6121                	addi	sp,sp,64
    80006066:	8082                	ret
    80006068:	8082                	ret

000000008000606a <uartputc>:
{
    8000606a:	7179                	addi	sp,sp,-48
    8000606c:	f406                	sd	ra,40(sp)
    8000606e:	f022                	sd	s0,32(sp)
    80006070:	e052                	sd	s4,0(sp)
    80006072:	1800                	addi	s0,sp,48
    80006074:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006076:	00020517          	auipc	a0,0x20
    8000607a:	19250513          	addi	a0,a0,402 # 80026208 <uart_tx_lock>
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	1a8080e7          	jalr	424(ra) # 80006226 <acquire>
  if(panicked){
    80006086:	00003797          	auipc	a5,0x3
    8000608a:	f967a783          	lw	a5,-106(a5) # 8000901c <panicked>
    8000608e:	c391                	beqz	a5,80006092 <uartputc+0x28>
    for(;;)
    80006090:	a001                	j	80006090 <uartputc+0x26>
    80006092:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006094:	00003717          	auipc	a4,0x3
    80006098:	f9473703          	ld	a4,-108(a4) # 80009028 <uart_tx_w>
    8000609c:	00003797          	auipc	a5,0x3
    800060a0:	f847b783          	ld	a5,-124(a5) # 80009020 <uart_tx_r>
    800060a4:	02078793          	addi	a5,a5,32
    800060a8:	02e79f63          	bne	a5,a4,800060e6 <uartputc+0x7c>
    800060ac:	e84a                	sd	s2,16(sp)
    800060ae:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800060b0:	00020997          	auipc	s3,0x20
    800060b4:	15898993          	addi	s3,s3,344 # 80026208 <uart_tx_lock>
    800060b8:	00003497          	auipc	s1,0x3
    800060bc:	f6848493          	addi	s1,s1,-152 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060c0:	00003917          	auipc	s2,0x3
    800060c4:	f6890913          	addi	s2,s2,-152 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800060c8:	85ce                	mv	a1,s3
    800060ca:	8526                	mv	a0,s1
    800060cc:	ffffb097          	auipc	ra,0xffffb
    800060d0:	4f6080e7          	jalr	1270(ra) # 800015c2 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060d4:	00093703          	ld	a4,0(s2)
    800060d8:	609c                	ld	a5,0(s1)
    800060da:	02078793          	addi	a5,a5,32
    800060de:	fee785e3          	beq	a5,a4,800060c8 <uartputc+0x5e>
    800060e2:	6942                	ld	s2,16(sp)
    800060e4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060e6:	00020497          	auipc	s1,0x20
    800060ea:	12248493          	addi	s1,s1,290 # 80026208 <uart_tx_lock>
    800060ee:	01f77793          	andi	a5,a4,31
    800060f2:	97a6                	add	a5,a5,s1
    800060f4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800060f8:	0705                	addi	a4,a4,1
    800060fa:	00003797          	auipc	a5,0x3
    800060fe:	f2e7b723          	sd	a4,-210(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006102:	00000097          	auipc	ra,0x0
    80006106:	ed8080e7          	jalr	-296(ra) # 80005fda <uartstart>
      release(&uart_tx_lock);
    8000610a:	8526                	mv	a0,s1
    8000610c:	00000097          	auipc	ra,0x0
    80006110:	1ce080e7          	jalr	462(ra) # 800062da <release>
    80006114:	64e2                	ld	s1,24(sp)
}
    80006116:	70a2                	ld	ra,40(sp)
    80006118:	7402                	ld	s0,32(sp)
    8000611a:	6a02                	ld	s4,0(sp)
    8000611c:	6145                	addi	sp,sp,48
    8000611e:	8082                	ret

0000000080006120 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006120:	1141                	addi	sp,sp,-16
    80006122:	e422                	sd	s0,8(sp)
    80006124:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006126:	100007b7          	lui	a5,0x10000
    8000612a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000612c:	0007c783          	lbu	a5,0(a5)
    80006130:	8b85                	andi	a5,a5,1
    80006132:	cb81                	beqz	a5,80006142 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006134:	100007b7          	lui	a5,0x10000
    80006138:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000613c:	6422                	ld	s0,8(sp)
    8000613e:	0141                	addi	sp,sp,16
    80006140:	8082                	ret
    return -1;
    80006142:	557d                	li	a0,-1
    80006144:	bfe5                	j	8000613c <uartgetc+0x1c>

0000000080006146 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006146:	1101                	addi	sp,sp,-32
    80006148:	ec06                	sd	ra,24(sp)
    8000614a:	e822                	sd	s0,16(sp)
    8000614c:	e426                	sd	s1,8(sp)
    8000614e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006150:	54fd                	li	s1,-1
    80006152:	a029                	j	8000615c <uartintr+0x16>
      break;
    consoleintr(c);
    80006154:	00000097          	auipc	ra,0x0
    80006158:	8ce080e7          	jalr	-1842(ra) # 80005a22 <consoleintr>
    int c = uartgetc();
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	fc4080e7          	jalr	-60(ra) # 80006120 <uartgetc>
    if(c == -1)
    80006164:	fe9518e3          	bne	a0,s1,80006154 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006168:	00020497          	auipc	s1,0x20
    8000616c:	0a048493          	addi	s1,s1,160 # 80026208 <uart_tx_lock>
    80006170:	8526                	mv	a0,s1
    80006172:	00000097          	auipc	ra,0x0
    80006176:	0b4080e7          	jalr	180(ra) # 80006226 <acquire>
  uartstart();
    8000617a:	00000097          	auipc	ra,0x0
    8000617e:	e60080e7          	jalr	-416(ra) # 80005fda <uartstart>
  release(&uart_tx_lock);
    80006182:	8526                	mv	a0,s1
    80006184:	00000097          	auipc	ra,0x0
    80006188:	156080e7          	jalr	342(ra) # 800062da <release>
}
    8000618c:	60e2                	ld	ra,24(sp)
    8000618e:	6442                	ld	s0,16(sp)
    80006190:	64a2                	ld	s1,8(sp)
    80006192:	6105                	addi	sp,sp,32
    80006194:	8082                	ret

0000000080006196 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006196:	1141                	addi	sp,sp,-16
    80006198:	e422                	sd	s0,8(sp)
    8000619a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000619c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000619e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061a2:	00053823          	sd	zero,16(a0)
}
    800061a6:	6422                	ld	s0,8(sp)
    800061a8:	0141                	addi	sp,sp,16
    800061aa:	8082                	ret

00000000800061ac <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061ac:	411c                	lw	a5,0(a0)
    800061ae:	e399                	bnez	a5,800061b4 <holding+0x8>
    800061b0:	4501                	li	a0,0
  return r;
}
    800061b2:	8082                	ret
{
    800061b4:	1101                	addi	sp,sp,-32
    800061b6:	ec06                	sd	ra,24(sp)
    800061b8:	e822                	sd	s0,16(sp)
    800061ba:	e426                	sd	s1,8(sp)
    800061bc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061be:	6904                	ld	s1,16(a0)
    800061c0:	ffffb097          	auipc	ra,0xffffb
    800061c4:	c9c080e7          	jalr	-868(ra) # 80000e5c <mycpu>
    800061c8:	40a48533          	sub	a0,s1,a0
    800061cc:	00153513          	seqz	a0,a0
}
    800061d0:	60e2                	ld	ra,24(sp)
    800061d2:	6442                	ld	s0,16(sp)
    800061d4:	64a2                	ld	s1,8(sp)
    800061d6:	6105                	addi	sp,sp,32
    800061d8:	8082                	ret

00000000800061da <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061da:	1101                	addi	sp,sp,-32
    800061dc:	ec06                	sd	ra,24(sp)
    800061de:	e822                	sd	s0,16(sp)
    800061e0:	e426                	sd	s1,8(sp)
    800061e2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061e4:	100024f3          	csrr	s1,sstatus
    800061e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061ec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061ee:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061f2:	ffffb097          	auipc	ra,0xffffb
    800061f6:	c6a080e7          	jalr	-918(ra) # 80000e5c <mycpu>
    800061fa:	5d3c                	lw	a5,120(a0)
    800061fc:	cf89                	beqz	a5,80006216 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061fe:	ffffb097          	auipc	ra,0xffffb
    80006202:	c5e080e7          	jalr	-930(ra) # 80000e5c <mycpu>
    80006206:	5d3c                	lw	a5,120(a0)
    80006208:	2785                	addiw	a5,a5,1
    8000620a:	dd3c                	sw	a5,120(a0)
}
    8000620c:	60e2                	ld	ra,24(sp)
    8000620e:	6442                	ld	s0,16(sp)
    80006210:	64a2                	ld	s1,8(sp)
    80006212:	6105                	addi	sp,sp,32
    80006214:	8082                	ret
    mycpu()->intena = old;
    80006216:	ffffb097          	auipc	ra,0xffffb
    8000621a:	c46080e7          	jalr	-954(ra) # 80000e5c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000621e:	8085                	srli	s1,s1,0x1
    80006220:	8885                	andi	s1,s1,1
    80006222:	dd64                	sw	s1,124(a0)
    80006224:	bfe9                	j	800061fe <push_off+0x24>

0000000080006226 <acquire>:
{
    80006226:	1101                	addi	sp,sp,-32
    80006228:	ec06                	sd	ra,24(sp)
    8000622a:	e822                	sd	s0,16(sp)
    8000622c:	e426                	sd	s1,8(sp)
    8000622e:	1000                	addi	s0,sp,32
    80006230:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006232:	00000097          	auipc	ra,0x0
    80006236:	fa8080e7          	jalr	-88(ra) # 800061da <push_off>
  if(holding(lk))
    8000623a:	8526                	mv	a0,s1
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	f70080e7          	jalr	-144(ra) # 800061ac <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006244:	4705                	li	a4,1
  if(holding(lk))
    80006246:	e115                	bnez	a0,8000626a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006248:	87ba                	mv	a5,a4
    8000624a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000624e:	2781                	sext.w	a5,a5
    80006250:	ffe5                	bnez	a5,80006248 <acquire+0x22>
  __sync_synchronize();
    80006252:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006256:	ffffb097          	auipc	ra,0xffffb
    8000625a:	c06080e7          	jalr	-1018(ra) # 80000e5c <mycpu>
    8000625e:	e888                	sd	a0,16(s1)
}
    80006260:	60e2                	ld	ra,24(sp)
    80006262:	6442                	ld	s0,16(sp)
    80006264:	64a2                	ld	s1,8(sp)
    80006266:	6105                	addi	sp,sp,32
    80006268:	8082                	ret
    panic("acquire");
    8000626a:	00002517          	auipc	a0,0x2
    8000626e:	46650513          	addi	a0,a0,1126 # 800086d0 <etext+0x6d0>
    80006272:	00000097          	auipc	ra,0x0
    80006276:	a3a080e7          	jalr	-1478(ra) # 80005cac <panic>

000000008000627a <pop_off>:

void
pop_off(void)
{
    8000627a:	1141                	addi	sp,sp,-16
    8000627c:	e406                	sd	ra,8(sp)
    8000627e:	e022                	sd	s0,0(sp)
    80006280:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006282:	ffffb097          	auipc	ra,0xffffb
    80006286:	bda080e7          	jalr	-1062(ra) # 80000e5c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000628a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000628e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006290:	e78d                	bnez	a5,800062ba <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006292:	5d3c                	lw	a5,120(a0)
    80006294:	02f05b63          	blez	a5,800062ca <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006298:	37fd                	addiw	a5,a5,-1
    8000629a:	0007871b          	sext.w	a4,a5
    8000629e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062a0:	eb09                	bnez	a4,800062b2 <pop_off+0x38>
    800062a2:	5d7c                	lw	a5,124(a0)
    800062a4:	c799                	beqz	a5,800062b2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062ae:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062b2:	60a2                	ld	ra,8(sp)
    800062b4:	6402                	ld	s0,0(sp)
    800062b6:	0141                	addi	sp,sp,16
    800062b8:	8082                	ret
    panic("pop_off - interruptible");
    800062ba:	00002517          	auipc	a0,0x2
    800062be:	41e50513          	addi	a0,a0,1054 # 800086d8 <etext+0x6d8>
    800062c2:	00000097          	auipc	ra,0x0
    800062c6:	9ea080e7          	jalr	-1558(ra) # 80005cac <panic>
    panic("pop_off");
    800062ca:	00002517          	auipc	a0,0x2
    800062ce:	42650513          	addi	a0,a0,1062 # 800086f0 <etext+0x6f0>
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	9da080e7          	jalr	-1574(ra) # 80005cac <panic>

00000000800062da <release>:
{
    800062da:	1101                	addi	sp,sp,-32
    800062dc:	ec06                	sd	ra,24(sp)
    800062de:	e822                	sd	s0,16(sp)
    800062e0:	e426                	sd	s1,8(sp)
    800062e2:	1000                	addi	s0,sp,32
    800062e4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062e6:	00000097          	auipc	ra,0x0
    800062ea:	ec6080e7          	jalr	-314(ra) # 800061ac <holding>
    800062ee:	c115                	beqz	a0,80006312 <release+0x38>
  lk->cpu = 0;
    800062f0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062f4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062f8:	0f50000f          	fence	iorw,ow
    800062fc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006300:	00000097          	auipc	ra,0x0
    80006304:	f7a080e7          	jalr	-134(ra) # 8000627a <pop_off>
}
    80006308:	60e2                	ld	ra,24(sp)
    8000630a:	6442                	ld	s0,16(sp)
    8000630c:	64a2                	ld	s1,8(sp)
    8000630e:	6105                	addi	sp,sp,32
    80006310:	8082                	ret
    panic("release");
    80006312:	00002517          	auipc	a0,0x2
    80006316:	3e650513          	addi	a0,a0,998 # 800086f8 <etext+0x6f8>
    8000631a:	00000097          	auipc	ra,0x0
    8000631e:	992080e7          	jalr	-1646(ra) # 80005cac <panic>
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
