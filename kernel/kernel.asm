
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
    80000016:	798050ef          	jal	800057ae <start>

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
    8000005e:	19c080e7          	jalr	412(ra) # 800061f6 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	23c080e7          	jalr	572(ra) # 800062aa <release>
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
    8000008e:	bf2080e7          	jalr	-1038(ra) # 80005c7c <panic>

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
    800000fa:	070080e7          	jalr	112(ra) # 80006166 <initlock>
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
    80000132:	0c8080e7          	jalr	200(ra) # 800061f6 <acquire>
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
    8000014a:	164080e7          	jalr	356(ra) # 800062aa <release>

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
    80000174:	13a080e7          	jalr	314(ra) # 800062aa <release>
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
    80000352:	978080e7          	jalr	-1672(ra) # 80005cc6 <printf>
    kvminithart();    // turn on paging
    80000356:	00000097          	auipc	ra,0x0
    8000035a:	0d8080e7          	jalr	216(ra) # 8000042e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	77e080e7          	jalr	1918(ra) # 80001adc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000366:	00005097          	auipc	ra,0x5
    8000036a:	dfe080e7          	jalr	-514(ra) # 80005164 <plicinithart>
  }

  scheduler();        
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	02a080e7          	jalr	42(ra) # 80001398 <scheduler>
    consoleinit();
    80000376:	00006097          	auipc	ra,0x6
    8000037a:	816080e7          	jalr	-2026(ra) # 80005b8c <consoleinit>
    printfinit();
    8000037e:	00006097          	auipc	ra,0x6
    80000382:	b50080e7          	jalr	-1200(ra) # 80005ece <printfinit>
    printf("\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	00006097          	auipc	ra,0x6
    80000392:	938080e7          	jalr	-1736(ra) # 80005cc6 <printf>
    printf("xv6 kernel is booting\n");
    80000396:	00008517          	auipc	a0,0x8
    8000039a:	c8a50513          	addi	a0,a0,-886 # 80008020 <etext+0x20>
    8000039e:	00006097          	auipc	ra,0x6
    800003a2:	928080e7          	jalr	-1752(ra) # 80005cc6 <printf>
    printf("\n");
    800003a6:	00008517          	auipc	a0,0x8
    800003aa:	c7250513          	addi	a0,a0,-910 # 80008018 <etext+0x18>
    800003ae:	00006097          	auipc	ra,0x6
    800003b2:	918080e7          	jalr	-1768(ra) # 80005cc6 <printf>
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
    800003da:	6de080e7          	jalr	1758(ra) # 80001ab4 <trapinit>
    trapinithart();  // install kernel trap vector
    800003de:	00001097          	auipc	ra,0x1
    800003e2:	6fe080e7          	jalr	1790(ra) # 80001adc <trapinithart>
    plicinit();      // set up interrupt controller
    800003e6:	00005097          	auipc	ra,0x5
    800003ea:	d64080e7          	jalr	-668(ra) # 8000514a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003ee:	00005097          	auipc	ra,0x5
    800003f2:	d76080e7          	jalr	-650(ra) # 80005164 <plicinithart>
    binit();         // buffer cache
    800003f6:	00002097          	auipc	ra,0x2
    800003fa:	e94080e7          	jalr	-364(ra) # 8000228a <binit>
    iinit();         // inode table
    800003fe:	00002097          	auipc	ra,0x2
    80000402:	520080e7          	jalr	1312(ra) # 8000291e <iinit>
    fileinit();      // file table
    80000406:	00003097          	auipc	ra,0x3
    8000040a:	4c4080e7          	jalr	1220(ra) # 800038ca <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000040e:	00005097          	auipc	ra,0x5
    80000412:	e76080e7          	jalr	-394(ra) # 80005284 <virtio_disk_init>
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
    80000480:	00005097          	auipc	ra,0x5
    80000484:	7fc080e7          	jalr	2044(ra) # 80005c7c <panic>
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
    800005aa:	6d6080e7          	jalr	1750(ra) # 80005c7c <panic>
      panic("mappages: remap");
    800005ae:	00008517          	auipc	a0,0x8
    800005b2:	aba50513          	addi	a0,a0,-1350 # 80008068 <etext+0x68>
    800005b6:	00005097          	auipc	ra,0x5
    800005ba:	6c6080e7          	jalr	1734(ra) # 80005c7c <panic>
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
    80000606:	67a080e7          	jalr	1658(ra) # 80005c7c <panic>

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
    8000074c:	534080e7          	jalr	1332(ra) # 80005c7c <panic>
      panic("uvmunmap: walk");
    80000750:	00008517          	auipc	a0,0x8
    80000754:	94850513          	addi	a0,a0,-1720 # 80008098 <etext+0x98>
    80000758:	00005097          	auipc	ra,0x5
    8000075c:	524080e7          	jalr	1316(ra) # 80005c7c <panic>
      panic("uvmunmap: not mapped");
    80000760:	00008517          	auipc	a0,0x8
    80000764:	94850513          	addi	a0,a0,-1720 # 800080a8 <etext+0xa8>
    80000768:	00005097          	auipc	ra,0x5
    8000076c:	514080e7          	jalr	1300(ra) # 80005c7c <panic>
      panic("uvmunmap: not a leaf");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	95050513          	addi	a0,a0,-1712 # 800080c0 <etext+0xc0>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	504080e7          	jalr	1284(ra) # 80005c7c <panic>
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
    80000870:	410080e7          	jalr	1040(ra) # 80005c7c <panic>

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
    800009bc:	2c4080e7          	jalr	708(ra) # 80005c7c <panic>
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
    80000a9a:	1e6080e7          	jalr	486(ra) # 80005c7c <panic>
      panic("uvmcopy: page not present");
    80000a9e:	00007517          	auipc	a0,0x7
    80000aa2:	68a50513          	addi	a0,a0,1674 # 80008128 <etext+0x128>
    80000aa6:	00005097          	auipc	ra,0x5
    80000aaa:	1d6080e7          	jalr	470(ra) # 80005c7c <panic>
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
    80000b14:	16c080e7          	jalr	364(ra) # 80005c7c <panic>

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
    80000d8e:	ef2080e7          	jalr	-270(ra) # 80005c7c <panic>

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
    80000dba:	3b0080e7          	jalr	944(ra) # 80006166 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3aa58593          	addi	a1,a1,938 # 80008168 <etext+0x168>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	2a250513          	addi	a0,a0,674 # 80009068 <wait_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	398080e7          	jalr	920(ra) # 80006166 <initlock>
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
    80000e1a:	350080e7          	jalr	848(ra) # 80006166 <initlock>
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
    80000e8a:	324080e7          	jalr	804(ra) # 800061aa <push_off>
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
    80000ea4:	3aa080e7          	jalr	938(ra) # 8000624a <pop_off>
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
    80000ec8:	3e6080e7          	jalr	998(ra) # 800062aa <release>

  if (first) {
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	a047a783          	lw	a5,-1532(a5) # 800088d0 <first.1>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	c1e080e7          	jalr	-994(ra) # 80001af4 <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	9e07a523          	sw	zero,-1558(a5) # 800088d0 <first.1>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	9ae080e7          	jalr	-1618(ra) # 8000289e <fsinit>
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
    80000f14:	2e6080e7          	jalr	742(ra) # 800061f6 <acquire>
  pid = nextpid;
    80000f18:	00008797          	auipc	a5,0x8
    80000f1c:	9bc78793          	addi	a5,a5,-1604 # 800088d4 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	380080e7          	jalr	896(ra) # 800062aa <release>
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
    800010a8:	152080e7          	jalr	338(ra) # 800061f6 <acquire>
    if(p->state == UNUSED) {
    800010ac:	4c9c                	lw	a5,24(s1)
    800010ae:	cf81                	beqz	a5,800010c6 <allocproc+0x40>
      release(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	1f8080e7          	jalr	504(ra) # 800062aa <release>
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
    80001134:	17a080e7          	jalr	378(ra) # 800062aa <release>
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
    8000114c:	162080e7          	jalr	354(ra) # 800062aa <release>
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
    80001178:	76c58593          	addi	a1,a1,1900 # 800088e0 <initcode>
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
    800011b6:	132080e7          	jalr	306(ra) # 800032e4 <namei>
    800011ba:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011be:	478d                	li	a5,3
    800011c0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c2:	8526                	mv	a0,s1
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	0e6080e7          	jalr	230(ra) # 800062aa <release>
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
    8000126c:	12050463          	beqz	a0,80001394 <fork+0x146>
    80001270:	ec4e                	sd	s3,24(sp)
    80001272:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001274:	048ab603          	ld	a2,72(s5)
    80001278:	692c                	ld	a1,80(a0)
    8000127a:	050ab503          	ld	a0,80(s5)
    8000127e:	fffff097          	auipc	ra,0xfffff
    80001282:	796080e7          	jalr	1942(ra) # 80000a14 <uvmcopy>
    80001286:	04054a63          	bltz	a0,800012da <fork+0x8c>
    8000128a:	f426                	sd	s1,40(sp)
    8000128c:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    8000128e:	048ab783          	ld	a5,72(s5)
    80001292:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001296:	058ab683          	ld	a3,88(s5)
    8000129a:	87b6                	mv	a5,a3
    8000129c:	0589b703          	ld	a4,88(s3)
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
    800012c4:	0589b783          	ld	a5,88(s3)
    800012c8:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012cc:	0d0a8493          	addi	s1,s5,208
    800012d0:	0d098913          	addi	s2,s3,208
    800012d4:	150a8a13          	addi	s4,s5,336
    800012d8:	a015                	j	800012fc <fork+0xae>
    freeproc(np);
    800012da:	854e                	mv	a0,s3
    800012dc:	00000097          	auipc	ra,0x0
    800012e0:	d52080e7          	jalr	-686(ra) # 8000102e <freeproc>
    release(&np->lock);
    800012e4:	854e                	mv	a0,s3
    800012e6:	00005097          	auipc	ra,0x5
    800012ea:	fc4080e7          	jalr	-60(ra) # 800062aa <release>
    return -1;
    800012ee:	597d                	li	s2,-1
    800012f0:	69e2                	ld	s3,24(sp)
    800012f2:	a851                	j	80001386 <fork+0x138>
  for(i = 0; i < NOFILE; i++)
    800012f4:	04a1                	addi	s1,s1,8
    800012f6:	0921                	addi	s2,s2,8
    800012f8:	01448b63          	beq	s1,s4,8000130e <fork+0xc0>
    if(p->ofile[i])
    800012fc:	6088                	ld	a0,0(s1)
    800012fe:	d97d                	beqz	a0,800012f4 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001300:	00002097          	auipc	ra,0x2
    80001304:	65c080e7          	jalr	1628(ra) # 8000395c <filedup>
    80001308:	00a93023          	sd	a0,0(s2)
    8000130c:	b7e5                	j	800012f4 <fork+0xa6>
  np->cwd = idup(p->cwd);
    8000130e:	150ab503          	ld	a0,336(s5)
    80001312:	00001097          	auipc	ra,0x1
    80001316:	7c2080e7          	jalr	1986(ra) # 80002ad4 <idup>
    8000131a:	14a9b823          	sd	a0,336(s3)
  np->mask = p->mask;
    8000131e:	034aa783          	lw	a5,52(s5)
    80001322:	02f9aa23          	sw	a5,52(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001326:	4641                	li	a2,16
    80001328:	158a8593          	addi	a1,s5,344
    8000132c:	15898513          	addi	a0,s3,344
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	f8c080e7          	jalr	-116(ra) # 800002bc <safestrcpy>
  pid = np->pid;
    80001338:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000133c:	854e                	mv	a0,s3
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	f6c080e7          	jalr	-148(ra) # 800062aa <release>
  acquire(&wait_lock);
    80001346:	00008497          	auipc	s1,0x8
    8000134a:	d2248493          	addi	s1,s1,-734 # 80009068 <wait_lock>
    8000134e:	8526                	mv	a0,s1
    80001350:	00005097          	auipc	ra,0x5
    80001354:	ea6080e7          	jalr	-346(ra) # 800061f6 <acquire>
  np->parent = p;
    80001358:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	f4c080e7          	jalr	-180(ra) # 800062aa <release>
  acquire(&np->lock);
    80001366:	854e                	mv	a0,s3
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	e8e080e7          	jalr	-370(ra) # 800061f6 <acquire>
  np->state = RUNNABLE;
    80001370:	478d                	li	a5,3
    80001372:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001376:	854e                	mv	a0,s3
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	f32080e7          	jalr	-206(ra) # 800062aa <release>
  return pid;
    80001380:	74a2                	ld	s1,40(sp)
    80001382:	69e2                	ld	s3,24(sp)
    80001384:	6a42                	ld	s4,16(sp)
}
    80001386:	854a                	mv	a0,s2
    80001388:	70e2                	ld	ra,56(sp)
    8000138a:	7442                	ld	s0,48(sp)
    8000138c:	7902                	ld	s2,32(sp)
    8000138e:	6aa2                	ld	s5,8(sp)
    80001390:	6121                	addi	sp,sp,64
    80001392:	8082                	ret
    return -1;
    80001394:	597d                	li	s2,-1
    80001396:	bfc5                	j	80001386 <fork+0x138>

0000000080001398 <scheduler>:
{
    80001398:	7139                	addi	sp,sp,-64
    8000139a:	fc06                	sd	ra,56(sp)
    8000139c:	f822                	sd	s0,48(sp)
    8000139e:	f426                	sd	s1,40(sp)
    800013a0:	f04a                	sd	s2,32(sp)
    800013a2:	ec4e                	sd	s3,24(sp)
    800013a4:	e852                	sd	s4,16(sp)
    800013a6:	e456                	sd	s5,8(sp)
    800013a8:	e05a                	sd	s6,0(sp)
    800013aa:	0080                	addi	s0,sp,64
    800013ac:	8792                	mv	a5,tp
  int id = r_tp();
    800013ae:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013b0:	00779a93          	slli	s5,a5,0x7
    800013b4:	00008717          	auipc	a4,0x8
    800013b8:	c9c70713          	addi	a4,a4,-868 # 80009050 <pid_lock>
    800013bc:	9756                	add	a4,a4,s5
    800013be:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013c2:	00008717          	auipc	a4,0x8
    800013c6:	cc670713          	addi	a4,a4,-826 # 80009088 <cpus+0x8>
    800013ca:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013cc:	498d                	li	s3,3
        p->state = RUNNING;
    800013ce:	4b11                	li	s6,4
        c->proc = p;
    800013d0:	079e                	slli	a5,a5,0x7
    800013d2:	00008a17          	auipc	s4,0x8
    800013d6:	c7ea0a13          	addi	s4,s4,-898 # 80009050 <pid_lock>
    800013da:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013dc:	0000e917          	auipc	s2,0xe
    800013e0:	aa490913          	addi	s2,s2,-1372 # 8000ee80 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013e8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ec:	10079073          	csrw	sstatus,a5
    800013f0:	00008497          	auipc	s1,0x8
    800013f4:	09048493          	addi	s1,s1,144 # 80009480 <proc>
    800013f8:	a811                	j	8000140c <scheduler+0x74>
      release(&p->lock);
    800013fa:	8526                	mv	a0,s1
    800013fc:	00005097          	auipc	ra,0x5
    80001400:	eae080e7          	jalr	-338(ra) # 800062aa <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001404:	16848493          	addi	s1,s1,360
    80001408:	fd248ee3          	beq	s1,s2,800013e4 <scheduler+0x4c>
      acquire(&p->lock);
    8000140c:	8526                	mv	a0,s1
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	de8080e7          	jalr	-536(ra) # 800061f6 <acquire>
      if(p->state == RUNNABLE) {
    80001416:	4c9c                	lw	a5,24(s1)
    80001418:	ff3791e3          	bne	a5,s3,800013fa <scheduler+0x62>
        p->state = RUNNING;
    8000141c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001420:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001424:	06048593          	addi	a1,s1,96
    80001428:	8556                	mv	a0,s5
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	620080e7          	jalr	1568(ra) # 80001a4a <swtch>
        c->proc = 0;
    80001432:	020a3823          	sd	zero,48(s4)
    80001436:	b7d1                	j	800013fa <scheduler+0x62>

0000000080001438 <sched>:
{
    80001438:	7179                	addi	sp,sp,-48
    8000143a:	f406                	sd	ra,40(sp)
    8000143c:	f022                	sd	s0,32(sp)
    8000143e:	ec26                	sd	s1,24(sp)
    80001440:	e84a                	sd	s2,16(sp)
    80001442:	e44e                	sd	s3,8(sp)
    80001444:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	a36080e7          	jalr	-1482(ra) # 80000e7c <myproc>
    8000144e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001450:	00005097          	auipc	ra,0x5
    80001454:	d2c080e7          	jalr	-724(ra) # 8000617c <holding>
    80001458:	c93d                	beqz	a0,800014ce <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000145a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000145c:	2781                	sext.w	a5,a5
    8000145e:	079e                	slli	a5,a5,0x7
    80001460:	00008717          	auipc	a4,0x8
    80001464:	bf070713          	addi	a4,a4,-1040 # 80009050 <pid_lock>
    80001468:	97ba                	add	a5,a5,a4
    8000146a:	0a87a703          	lw	a4,168(a5)
    8000146e:	4785                	li	a5,1
    80001470:	06f71763          	bne	a4,a5,800014de <sched+0xa6>
  if(p->state == RUNNING)
    80001474:	4c98                	lw	a4,24(s1)
    80001476:	4791                	li	a5,4
    80001478:	06f70b63          	beq	a4,a5,800014ee <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000147c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001480:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001482:	efb5                	bnez	a5,800014fe <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001484:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001486:	00008917          	auipc	s2,0x8
    8000148a:	bca90913          	addi	s2,s2,-1078 # 80009050 <pid_lock>
    8000148e:	2781                	sext.w	a5,a5
    80001490:	079e                	slli	a5,a5,0x7
    80001492:	97ca                	add	a5,a5,s2
    80001494:	0ac7a983          	lw	s3,172(a5)
    80001498:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	00008597          	auipc	a1,0x8
    800014a2:	bea58593          	addi	a1,a1,-1046 # 80009088 <cpus+0x8>
    800014a6:	95be                	add	a1,a1,a5
    800014a8:	06048513          	addi	a0,s1,96
    800014ac:	00000097          	auipc	ra,0x0
    800014b0:	59e080e7          	jalr	1438(ra) # 80001a4a <swtch>
    800014b4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014b6:	2781                	sext.w	a5,a5
    800014b8:	079e                	slli	a5,a5,0x7
    800014ba:	993e                	add	s2,s2,a5
    800014bc:	0b392623          	sw	s3,172(s2)
}
    800014c0:	70a2                	ld	ra,40(sp)
    800014c2:	7402                	ld	s0,32(sp)
    800014c4:	64e2                	ld	s1,24(sp)
    800014c6:	6942                	ld	s2,16(sp)
    800014c8:	69a2                	ld	s3,8(sp)
    800014ca:	6145                	addi	sp,sp,48
    800014cc:	8082                	ret
    panic("sched p->lock");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	cca50513          	addi	a0,a0,-822 # 80008198 <etext+0x198>
    800014d6:	00004097          	auipc	ra,0x4
    800014da:	7a6080e7          	jalr	1958(ra) # 80005c7c <panic>
    panic("sched locks");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cca50513          	addi	a0,a0,-822 # 800081a8 <etext+0x1a8>
    800014e6:	00004097          	auipc	ra,0x4
    800014ea:	796080e7          	jalr	1942(ra) # 80005c7c <panic>
    panic("sched running");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	cca50513          	addi	a0,a0,-822 # 800081b8 <etext+0x1b8>
    800014f6:	00004097          	auipc	ra,0x4
    800014fa:	786080e7          	jalr	1926(ra) # 80005c7c <panic>
    panic("sched interruptible");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	cca50513          	addi	a0,a0,-822 # 800081c8 <etext+0x1c8>
    80001506:	00004097          	auipc	ra,0x4
    8000150a:	776080e7          	jalr	1910(ra) # 80005c7c <panic>

000000008000150e <yield>:
{
    8000150e:	1101                	addi	sp,sp,-32
    80001510:	ec06                	sd	ra,24(sp)
    80001512:	e822                	sd	s0,16(sp)
    80001514:	e426                	sd	s1,8(sp)
    80001516:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	964080e7          	jalr	-1692(ra) # 80000e7c <myproc>
    80001520:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001522:	00005097          	auipc	ra,0x5
    80001526:	cd4080e7          	jalr	-812(ra) # 800061f6 <acquire>
  p->state = RUNNABLE;
    8000152a:	478d                	li	a5,3
    8000152c:	cc9c                	sw	a5,24(s1)
  sched();
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	f0a080e7          	jalr	-246(ra) # 80001438 <sched>
  release(&p->lock);
    80001536:	8526                	mv	a0,s1
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	d72080e7          	jalr	-654(ra) # 800062aa <release>
}
    80001540:	60e2                	ld	ra,24(sp)
    80001542:	6442                	ld	s0,16(sp)
    80001544:	64a2                	ld	s1,8(sp)
    80001546:	6105                	addi	sp,sp,32
    80001548:	8082                	ret

000000008000154a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000154a:	7179                	addi	sp,sp,-48
    8000154c:	f406                	sd	ra,40(sp)
    8000154e:	f022                	sd	s0,32(sp)
    80001550:	ec26                	sd	s1,24(sp)
    80001552:	e84a                	sd	s2,16(sp)
    80001554:	e44e                	sd	s3,8(sp)
    80001556:	1800                	addi	s0,sp,48
    80001558:	89aa                	mv	s3,a0
    8000155a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	920080e7          	jalr	-1760(ra) # 80000e7c <myproc>
    80001564:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	c90080e7          	jalr	-880(ra) # 800061f6 <acquire>
  release(lk);
    8000156e:	854a                	mv	a0,s2
    80001570:	00005097          	auipc	ra,0x5
    80001574:	d3a080e7          	jalr	-710(ra) # 800062aa <release>

  // Go to sleep.
  p->chan = chan;
    80001578:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000157c:	4789                	li	a5,2
    8000157e:	cc9c                	sw	a5,24(s1)

  sched();
    80001580:	00000097          	auipc	ra,0x0
    80001584:	eb8080e7          	jalr	-328(ra) # 80001438 <sched>

  // Tidy up.
  p->chan = 0;
    80001588:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000158c:	8526                	mv	a0,s1
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	d1c080e7          	jalr	-740(ra) # 800062aa <release>
  acquire(lk);
    80001596:	854a                	mv	a0,s2
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	c5e080e7          	jalr	-930(ra) # 800061f6 <acquire>
}
    800015a0:	70a2                	ld	ra,40(sp)
    800015a2:	7402                	ld	s0,32(sp)
    800015a4:	64e2                	ld	s1,24(sp)
    800015a6:	6942                	ld	s2,16(sp)
    800015a8:	69a2                	ld	s3,8(sp)
    800015aa:	6145                	addi	sp,sp,48
    800015ac:	8082                	ret

00000000800015ae <wait>:
{
    800015ae:	715d                	addi	sp,sp,-80
    800015b0:	e486                	sd	ra,72(sp)
    800015b2:	e0a2                	sd	s0,64(sp)
    800015b4:	fc26                	sd	s1,56(sp)
    800015b6:	f84a                	sd	s2,48(sp)
    800015b8:	f44e                	sd	s3,40(sp)
    800015ba:	f052                	sd	s4,32(sp)
    800015bc:	ec56                	sd	s5,24(sp)
    800015be:	e85a                	sd	s6,16(sp)
    800015c0:	e45e                	sd	s7,8(sp)
    800015c2:	e062                	sd	s8,0(sp)
    800015c4:	0880                	addi	s0,sp,80
    800015c6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015c8:	00000097          	auipc	ra,0x0
    800015cc:	8b4080e7          	jalr	-1868(ra) # 80000e7c <myproc>
    800015d0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015d2:	00008517          	auipc	a0,0x8
    800015d6:	a9650513          	addi	a0,a0,-1386 # 80009068 <wait_lock>
    800015da:	00005097          	auipc	ra,0x5
    800015de:	c1c080e7          	jalr	-996(ra) # 800061f6 <acquire>
    havekids = 0;
    800015e2:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800015e4:	4a15                	li	s4,5
        havekids = 1;
    800015e6:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800015e8:	0000e997          	auipc	s3,0xe
    800015ec:	89898993          	addi	s3,s3,-1896 # 8000ee80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015f0:	00008c17          	auipc	s8,0x8
    800015f4:	a78c0c13          	addi	s8,s8,-1416 # 80009068 <wait_lock>
    800015f8:	a87d                	j	800016b6 <wait+0x108>
          pid = np->pid;
    800015fa:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800015fe:	000b0e63          	beqz	s6,8000161a <wait+0x6c>
    80001602:	4691                	li	a3,4
    80001604:	02c48613          	addi	a2,s1,44
    80001608:	85da                	mv	a1,s6
    8000160a:	05093503          	ld	a0,80(s2)
    8000160e:	fffff097          	auipc	ra,0xfffff
    80001612:	50a080e7          	jalr	1290(ra) # 80000b18 <copyout>
    80001616:	04054163          	bltz	a0,80001658 <wait+0xaa>
          freeproc(np);
    8000161a:	8526                	mv	a0,s1
    8000161c:	00000097          	auipc	ra,0x0
    80001620:	a12080e7          	jalr	-1518(ra) # 8000102e <freeproc>
          release(&np->lock);
    80001624:	8526                	mv	a0,s1
    80001626:	00005097          	auipc	ra,0x5
    8000162a:	c84080e7          	jalr	-892(ra) # 800062aa <release>
          release(&wait_lock);
    8000162e:	00008517          	auipc	a0,0x8
    80001632:	a3a50513          	addi	a0,a0,-1478 # 80009068 <wait_lock>
    80001636:	00005097          	auipc	ra,0x5
    8000163a:	c74080e7          	jalr	-908(ra) # 800062aa <release>
}
    8000163e:	854e                	mv	a0,s3
    80001640:	60a6                	ld	ra,72(sp)
    80001642:	6406                	ld	s0,64(sp)
    80001644:	74e2                	ld	s1,56(sp)
    80001646:	7942                	ld	s2,48(sp)
    80001648:	79a2                	ld	s3,40(sp)
    8000164a:	7a02                	ld	s4,32(sp)
    8000164c:	6ae2                	ld	s5,24(sp)
    8000164e:	6b42                	ld	s6,16(sp)
    80001650:	6ba2                	ld	s7,8(sp)
    80001652:	6c02                	ld	s8,0(sp)
    80001654:	6161                	addi	sp,sp,80
    80001656:	8082                	ret
            release(&np->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	00005097          	auipc	ra,0x5
    8000165e:	c50080e7          	jalr	-944(ra) # 800062aa <release>
            release(&wait_lock);
    80001662:	00008517          	auipc	a0,0x8
    80001666:	a0650513          	addi	a0,a0,-1530 # 80009068 <wait_lock>
    8000166a:	00005097          	auipc	ra,0x5
    8000166e:	c40080e7          	jalr	-960(ra) # 800062aa <release>
            return -1;
    80001672:	59fd                	li	s3,-1
    80001674:	b7e9                	j	8000163e <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    80001676:	16848493          	addi	s1,s1,360
    8000167a:	03348463          	beq	s1,s3,800016a2 <wait+0xf4>
      if(np->parent == p){
    8000167e:	7c9c                	ld	a5,56(s1)
    80001680:	ff279be3          	bne	a5,s2,80001676 <wait+0xc8>
        acquire(&np->lock);
    80001684:	8526                	mv	a0,s1
    80001686:	00005097          	auipc	ra,0x5
    8000168a:	b70080e7          	jalr	-1168(ra) # 800061f6 <acquire>
        if(np->state == ZOMBIE){
    8000168e:	4c9c                	lw	a5,24(s1)
    80001690:	f74785e3          	beq	a5,s4,800015fa <wait+0x4c>
        release(&np->lock);
    80001694:	8526                	mv	a0,s1
    80001696:	00005097          	auipc	ra,0x5
    8000169a:	c14080e7          	jalr	-1004(ra) # 800062aa <release>
        havekids = 1;
    8000169e:	8756                	mv	a4,s5
    800016a0:	bfd9                	j	80001676 <wait+0xc8>
    if(!havekids || p->killed){
    800016a2:	c305                	beqz	a4,800016c2 <wait+0x114>
    800016a4:	02892783          	lw	a5,40(s2)
    800016a8:	ef89                	bnez	a5,800016c2 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016aa:	85e2                	mv	a1,s8
    800016ac:	854a                	mv	a0,s2
    800016ae:	00000097          	auipc	ra,0x0
    800016b2:	e9c080e7          	jalr	-356(ra) # 8000154a <sleep>
    havekids = 0;
    800016b6:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800016b8:	00008497          	auipc	s1,0x8
    800016bc:	dc848493          	addi	s1,s1,-568 # 80009480 <proc>
    800016c0:	bf7d                	j	8000167e <wait+0xd0>
      release(&wait_lock);
    800016c2:	00008517          	auipc	a0,0x8
    800016c6:	9a650513          	addi	a0,a0,-1626 # 80009068 <wait_lock>
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	be0080e7          	jalr	-1056(ra) # 800062aa <release>
      return -1;
    800016d2:	59fd                	li	s3,-1
    800016d4:	b7ad                	j	8000163e <wait+0x90>

00000000800016d6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016d6:	7139                	addi	sp,sp,-64
    800016d8:	fc06                	sd	ra,56(sp)
    800016da:	f822                	sd	s0,48(sp)
    800016dc:	f426                	sd	s1,40(sp)
    800016de:	f04a                	sd	s2,32(sp)
    800016e0:	ec4e                	sd	s3,24(sp)
    800016e2:	e852                	sd	s4,16(sp)
    800016e4:	e456                	sd	s5,8(sp)
    800016e6:	0080                	addi	s0,sp,64
    800016e8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800016ea:	00008497          	auipc	s1,0x8
    800016ee:	d9648493          	addi	s1,s1,-618 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800016f2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800016f4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800016f6:	0000d917          	auipc	s2,0xd
    800016fa:	78a90913          	addi	s2,s2,1930 # 8000ee80 <tickslock>
    800016fe:	a811                	j	80001712 <wakeup+0x3c>
      }
      release(&p->lock);
    80001700:	8526                	mv	a0,s1
    80001702:	00005097          	auipc	ra,0x5
    80001706:	ba8080e7          	jalr	-1112(ra) # 800062aa <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000170a:	16848493          	addi	s1,s1,360
    8000170e:	03248663          	beq	s1,s2,8000173a <wakeup+0x64>
    if(p != myproc()){
    80001712:	fffff097          	auipc	ra,0xfffff
    80001716:	76a080e7          	jalr	1898(ra) # 80000e7c <myproc>
    8000171a:	fea488e3          	beq	s1,a0,8000170a <wakeup+0x34>
      acquire(&p->lock);
    8000171e:	8526                	mv	a0,s1
    80001720:	00005097          	auipc	ra,0x5
    80001724:	ad6080e7          	jalr	-1322(ra) # 800061f6 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001728:	4c9c                	lw	a5,24(s1)
    8000172a:	fd379be3          	bne	a5,s3,80001700 <wakeup+0x2a>
    8000172e:	709c                	ld	a5,32(s1)
    80001730:	fd4798e3          	bne	a5,s4,80001700 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001734:	0154ac23          	sw	s5,24(s1)
    80001738:	b7e1                	j	80001700 <wakeup+0x2a>
    }
  }
}
    8000173a:	70e2                	ld	ra,56(sp)
    8000173c:	7442                	ld	s0,48(sp)
    8000173e:	74a2                	ld	s1,40(sp)
    80001740:	7902                	ld	s2,32(sp)
    80001742:	69e2                	ld	s3,24(sp)
    80001744:	6a42                	ld	s4,16(sp)
    80001746:	6aa2                	ld	s5,8(sp)
    80001748:	6121                	addi	sp,sp,64
    8000174a:	8082                	ret

000000008000174c <reparent>:
{
    8000174c:	7179                	addi	sp,sp,-48
    8000174e:	f406                	sd	ra,40(sp)
    80001750:	f022                	sd	s0,32(sp)
    80001752:	ec26                	sd	s1,24(sp)
    80001754:	e84a                	sd	s2,16(sp)
    80001756:	e44e                	sd	s3,8(sp)
    80001758:	e052                	sd	s4,0(sp)
    8000175a:	1800                	addi	s0,sp,48
    8000175c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000175e:	00008497          	auipc	s1,0x8
    80001762:	d2248493          	addi	s1,s1,-734 # 80009480 <proc>
      pp->parent = initproc;
    80001766:	00008a17          	auipc	s4,0x8
    8000176a:	8aaa0a13          	addi	s4,s4,-1878 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000176e:	0000d997          	auipc	s3,0xd
    80001772:	71298993          	addi	s3,s3,1810 # 8000ee80 <tickslock>
    80001776:	a029                	j	80001780 <reparent+0x34>
    80001778:	16848493          	addi	s1,s1,360
    8000177c:	01348d63          	beq	s1,s3,80001796 <reparent+0x4a>
    if(pp->parent == p){
    80001780:	7c9c                	ld	a5,56(s1)
    80001782:	ff279be3          	bne	a5,s2,80001778 <reparent+0x2c>
      pp->parent = initproc;
    80001786:	000a3503          	ld	a0,0(s4)
    8000178a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000178c:	00000097          	auipc	ra,0x0
    80001790:	f4a080e7          	jalr	-182(ra) # 800016d6 <wakeup>
    80001794:	b7d5                	j	80001778 <reparent+0x2c>
}
    80001796:	70a2                	ld	ra,40(sp)
    80001798:	7402                	ld	s0,32(sp)
    8000179a:	64e2                	ld	s1,24(sp)
    8000179c:	6942                	ld	s2,16(sp)
    8000179e:	69a2                	ld	s3,8(sp)
    800017a0:	6a02                	ld	s4,0(sp)
    800017a2:	6145                	addi	sp,sp,48
    800017a4:	8082                	ret

00000000800017a6 <exit>:
{
    800017a6:	7179                	addi	sp,sp,-48
    800017a8:	f406                	sd	ra,40(sp)
    800017aa:	f022                	sd	s0,32(sp)
    800017ac:	ec26                	sd	s1,24(sp)
    800017ae:	e84a                	sd	s2,16(sp)
    800017b0:	e44e                	sd	s3,8(sp)
    800017b2:	e052                	sd	s4,0(sp)
    800017b4:	1800                	addi	s0,sp,48
    800017b6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017b8:	fffff097          	auipc	ra,0xfffff
    800017bc:	6c4080e7          	jalr	1732(ra) # 80000e7c <myproc>
    800017c0:	89aa                	mv	s3,a0
  if(p == initproc)
    800017c2:	00008797          	auipc	a5,0x8
    800017c6:	84e7b783          	ld	a5,-1970(a5) # 80009010 <initproc>
    800017ca:	0d050493          	addi	s1,a0,208
    800017ce:	15050913          	addi	s2,a0,336
    800017d2:	02a79363          	bne	a5,a0,800017f8 <exit+0x52>
    panic("init exiting");
    800017d6:	00007517          	auipc	a0,0x7
    800017da:	a0a50513          	addi	a0,a0,-1526 # 800081e0 <etext+0x1e0>
    800017de:	00004097          	auipc	ra,0x4
    800017e2:	49e080e7          	jalr	1182(ra) # 80005c7c <panic>
      fileclose(f);
    800017e6:	00002097          	auipc	ra,0x2
    800017ea:	1c8080e7          	jalr	456(ra) # 800039ae <fileclose>
      p->ofile[fd] = 0;
    800017ee:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800017f2:	04a1                	addi	s1,s1,8
    800017f4:	01248563          	beq	s1,s2,800017fe <exit+0x58>
    if(p->ofile[fd]){
    800017f8:	6088                	ld	a0,0(s1)
    800017fa:	f575                	bnez	a0,800017e6 <exit+0x40>
    800017fc:	bfdd                	j	800017f2 <exit+0x4c>
  begin_op();
    800017fe:	00002097          	auipc	ra,0x2
    80001802:	ce6080e7          	jalr	-794(ra) # 800034e4 <begin_op>
  iput(p->cwd);
    80001806:	1509b503          	ld	a0,336(s3)
    8000180a:	00001097          	auipc	ra,0x1
    8000180e:	4c6080e7          	jalr	1222(ra) # 80002cd0 <iput>
  end_op();
    80001812:	00002097          	auipc	ra,0x2
    80001816:	d4c080e7          	jalr	-692(ra) # 8000355e <end_op>
  p->cwd = 0;
    8000181a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000181e:	00008497          	auipc	s1,0x8
    80001822:	84a48493          	addi	s1,s1,-1974 # 80009068 <wait_lock>
    80001826:	8526                	mv	a0,s1
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	9ce080e7          	jalr	-1586(ra) # 800061f6 <acquire>
  reparent(p);
    80001830:	854e                	mv	a0,s3
    80001832:	00000097          	auipc	ra,0x0
    80001836:	f1a080e7          	jalr	-230(ra) # 8000174c <reparent>
  wakeup(p->parent);
    8000183a:	0389b503          	ld	a0,56(s3)
    8000183e:	00000097          	auipc	ra,0x0
    80001842:	e98080e7          	jalr	-360(ra) # 800016d6 <wakeup>
  acquire(&p->lock);
    80001846:	854e                	mv	a0,s3
    80001848:	00005097          	auipc	ra,0x5
    8000184c:	9ae080e7          	jalr	-1618(ra) # 800061f6 <acquire>
  p->xstate = status;
    80001850:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001854:	4795                	li	a5,5
    80001856:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000185a:	8526                	mv	a0,s1
    8000185c:	00005097          	auipc	ra,0x5
    80001860:	a4e080e7          	jalr	-1458(ra) # 800062aa <release>
  sched();
    80001864:	00000097          	auipc	ra,0x0
    80001868:	bd4080e7          	jalr	-1068(ra) # 80001438 <sched>
  panic("zombie exit");
    8000186c:	00007517          	auipc	a0,0x7
    80001870:	98450513          	addi	a0,a0,-1660 # 800081f0 <etext+0x1f0>
    80001874:	00004097          	auipc	ra,0x4
    80001878:	408080e7          	jalr	1032(ra) # 80005c7c <panic>

000000008000187c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000187c:	7179                	addi	sp,sp,-48
    8000187e:	f406                	sd	ra,40(sp)
    80001880:	f022                	sd	s0,32(sp)
    80001882:	ec26                	sd	s1,24(sp)
    80001884:	e84a                	sd	s2,16(sp)
    80001886:	e44e                	sd	s3,8(sp)
    80001888:	1800                	addi	s0,sp,48
    8000188a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000188c:	00008497          	auipc	s1,0x8
    80001890:	bf448493          	addi	s1,s1,-1036 # 80009480 <proc>
    80001894:	0000d997          	auipc	s3,0xd
    80001898:	5ec98993          	addi	s3,s3,1516 # 8000ee80 <tickslock>
    acquire(&p->lock);
    8000189c:	8526                	mv	a0,s1
    8000189e:	00005097          	auipc	ra,0x5
    800018a2:	958080e7          	jalr	-1704(ra) # 800061f6 <acquire>
    if(p->pid == pid){
    800018a6:	589c                	lw	a5,48(s1)
    800018a8:	01278d63          	beq	a5,s2,800018c2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ac:	8526                	mv	a0,s1
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	9fc080e7          	jalr	-1540(ra) # 800062aa <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018b6:	16848493          	addi	s1,s1,360
    800018ba:	ff3491e3          	bne	s1,s3,8000189c <kill+0x20>
  }
  return -1;
    800018be:	557d                	li	a0,-1
    800018c0:	a829                	j	800018da <kill+0x5e>
      p->killed = 1;
    800018c2:	4785                	li	a5,1
    800018c4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018c6:	4c98                	lw	a4,24(s1)
    800018c8:	4789                	li	a5,2
    800018ca:	00f70f63          	beq	a4,a5,800018e8 <kill+0x6c>
      release(&p->lock);
    800018ce:	8526                	mv	a0,s1
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	9da080e7          	jalr	-1574(ra) # 800062aa <release>
      return 0;
    800018d8:	4501                	li	a0,0
}
    800018da:	70a2                	ld	ra,40(sp)
    800018dc:	7402                	ld	s0,32(sp)
    800018de:	64e2                	ld	s1,24(sp)
    800018e0:	6942                	ld	s2,16(sp)
    800018e2:	69a2                	ld	s3,8(sp)
    800018e4:	6145                	addi	sp,sp,48
    800018e6:	8082                	ret
        p->state = RUNNABLE;
    800018e8:	478d                	li	a5,3
    800018ea:	cc9c                	sw	a5,24(s1)
    800018ec:	b7cd                	j	800018ce <kill+0x52>

00000000800018ee <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800018ee:	7179                	addi	sp,sp,-48
    800018f0:	f406                	sd	ra,40(sp)
    800018f2:	f022                	sd	s0,32(sp)
    800018f4:	ec26                	sd	s1,24(sp)
    800018f6:	e84a                	sd	s2,16(sp)
    800018f8:	e44e                	sd	s3,8(sp)
    800018fa:	e052                	sd	s4,0(sp)
    800018fc:	1800                	addi	s0,sp,48
    800018fe:	84aa                	mv	s1,a0
    80001900:	892e                	mv	s2,a1
    80001902:	89b2                	mv	s3,a2
    80001904:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001906:	fffff097          	auipc	ra,0xfffff
    8000190a:	576080e7          	jalr	1398(ra) # 80000e7c <myproc>
  if(user_dst){
    8000190e:	c08d                	beqz	s1,80001930 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001910:	86d2                	mv	a3,s4
    80001912:	864e                	mv	a2,s3
    80001914:	85ca                	mv	a1,s2
    80001916:	6928                	ld	a0,80(a0)
    80001918:	fffff097          	auipc	ra,0xfffff
    8000191c:	200080e7          	jalr	512(ra) # 80000b18 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001920:	70a2                	ld	ra,40(sp)
    80001922:	7402                	ld	s0,32(sp)
    80001924:	64e2                	ld	s1,24(sp)
    80001926:	6942                	ld	s2,16(sp)
    80001928:	69a2                	ld	s3,8(sp)
    8000192a:	6a02                	ld	s4,0(sp)
    8000192c:	6145                	addi	sp,sp,48
    8000192e:	8082                	ret
    memmove((char *)dst, src, len);
    80001930:	000a061b          	sext.w	a2,s4
    80001934:	85ce                	mv	a1,s3
    80001936:	854a                	mv	a0,s2
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	89e080e7          	jalr	-1890(ra) # 800001d6 <memmove>
    return 0;
    80001940:	8526                	mv	a0,s1
    80001942:	bff9                	j	80001920 <either_copyout+0x32>

0000000080001944 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001944:	7179                	addi	sp,sp,-48
    80001946:	f406                	sd	ra,40(sp)
    80001948:	f022                	sd	s0,32(sp)
    8000194a:	ec26                	sd	s1,24(sp)
    8000194c:	e84a                	sd	s2,16(sp)
    8000194e:	e44e                	sd	s3,8(sp)
    80001950:	e052                	sd	s4,0(sp)
    80001952:	1800                	addi	s0,sp,48
    80001954:	892a                	mv	s2,a0
    80001956:	84ae                	mv	s1,a1
    80001958:	89b2                	mv	s3,a2
    8000195a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	520080e7          	jalr	1312(ra) # 80000e7c <myproc>
  if(user_src){
    80001964:	c08d                	beqz	s1,80001986 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001966:	86d2                	mv	a3,s4
    80001968:	864e                	mv	a2,s3
    8000196a:	85ca                	mv	a1,s2
    8000196c:	6928                	ld	a0,80(a0)
    8000196e:	fffff097          	auipc	ra,0xfffff
    80001972:	236080e7          	jalr	566(ra) # 80000ba4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001976:	70a2                	ld	ra,40(sp)
    80001978:	7402                	ld	s0,32(sp)
    8000197a:	64e2                	ld	s1,24(sp)
    8000197c:	6942                	ld	s2,16(sp)
    8000197e:	69a2                	ld	s3,8(sp)
    80001980:	6a02                	ld	s4,0(sp)
    80001982:	6145                	addi	sp,sp,48
    80001984:	8082                	ret
    memmove(dst, (char*)src, len);
    80001986:	000a061b          	sext.w	a2,s4
    8000198a:	85ce                	mv	a1,s3
    8000198c:	854a                	mv	a0,s2
    8000198e:	fffff097          	auipc	ra,0xfffff
    80001992:	848080e7          	jalr	-1976(ra) # 800001d6 <memmove>
    return 0;
    80001996:	8526                	mv	a0,s1
    80001998:	bff9                	j	80001976 <either_copyin+0x32>

000000008000199a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000199a:	715d                	addi	sp,sp,-80
    8000199c:	e486                	sd	ra,72(sp)
    8000199e:	e0a2                	sd	s0,64(sp)
    800019a0:	fc26                	sd	s1,56(sp)
    800019a2:	f84a                	sd	s2,48(sp)
    800019a4:	f44e                	sd	s3,40(sp)
    800019a6:	f052                	sd	s4,32(sp)
    800019a8:	ec56                	sd	s5,24(sp)
    800019aa:	e85a                	sd	s6,16(sp)
    800019ac:	e45e                	sd	s7,8(sp)
    800019ae:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019b0:	00006517          	auipc	a0,0x6
    800019b4:	66850513          	addi	a0,a0,1640 # 80008018 <etext+0x18>
    800019b8:	00004097          	auipc	ra,0x4
    800019bc:	30e080e7          	jalr	782(ra) # 80005cc6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019c0:	00008497          	auipc	s1,0x8
    800019c4:	c1848493          	addi	s1,s1,-1000 # 800095d8 <proc+0x158>
    800019c8:	0000d917          	auipc	s2,0xd
    800019cc:	61090913          	addi	s2,s2,1552 # 8000efd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019d0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019d2:	00007997          	auipc	s3,0x7
    800019d6:	82e98993          	addi	s3,s3,-2002 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019da:	00007a97          	auipc	s5,0x7
    800019de:	82ea8a93          	addi	s5,s5,-2002 # 80008208 <etext+0x208>
    printf("\n");
    800019e2:	00006a17          	auipc	s4,0x6
    800019e6:	636a0a13          	addi	s4,s4,1590 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019ea:	00007b97          	auipc	s7,0x7
    800019ee:	dc6b8b93          	addi	s7,s7,-570 # 800087b0 <states.0>
    800019f2:	a00d                	j	80001a14 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800019f4:	ed86a583          	lw	a1,-296(a3)
    800019f8:	8556                	mv	a0,s5
    800019fa:	00004097          	auipc	ra,0x4
    800019fe:	2cc080e7          	jalr	716(ra) # 80005cc6 <printf>
    printf("\n");
    80001a02:	8552                	mv	a0,s4
    80001a04:	00004097          	auipc	ra,0x4
    80001a08:	2c2080e7          	jalr	706(ra) # 80005cc6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a0c:	16848493          	addi	s1,s1,360
    80001a10:	03248263          	beq	s1,s2,80001a34 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a14:	86a6                	mv	a3,s1
    80001a16:	ec04a783          	lw	a5,-320(s1)
    80001a1a:	dbed                	beqz	a5,80001a0c <procdump+0x72>
      state = "???";
    80001a1c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a1e:	fcfb6be3          	bltu	s6,a5,800019f4 <procdump+0x5a>
    80001a22:	02079713          	slli	a4,a5,0x20
    80001a26:	01d75793          	srli	a5,a4,0x1d
    80001a2a:	97de                	add	a5,a5,s7
    80001a2c:	6390                	ld	a2,0(a5)
    80001a2e:	f279                	bnez	a2,800019f4 <procdump+0x5a>
      state = "???";
    80001a30:	864e                	mv	a2,s3
    80001a32:	b7c9                	j	800019f4 <procdump+0x5a>
  }
}
    80001a34:	60a6                	ld	ra,72(sp)
    80001a36:	6406                	ld	s0,64(sp)
    80001a38:	74e2                	ld	s1,56(sp)
    80001a3a:	7942                	ld	s2,48(sp)
    80001a3c:	79a2                	ld	s3,40(sp)
    80001a3e:	7a02                	ld	s4,32(sp)
    80001a40:	6ae2                	ld	s5,24(sp)
    80001a42:	6b42                	ld	s6,16(sp)
    80001a44:	6ba2                	ld	s7,8(sp)
    80001a46:	6161                	addi	sp,sp,80
    80001a48:	8082                	ret

0000000080001a4a <swtch>:
    80001a4a:	00153023          	sd	ra,0(a0)
    80001a4e:	00253423          	sd	sp,8(a0)
    80001a52:	e900                	sd	s0,16(a0)
    80001a54:	ed04                	sd	s1,24(a0)
    80001a56:	03253023          	sd	s2,32(a0)
    80001a5a:	03353423          	sd	s3,40(a0)
    80001a5e:	03453823          	sd	s4,48(a0)
    80001a62:	03553c23          	sd	s5,56(a0)
    80001a66:	05653023          	sd	s6,64(a0)
    80001a6a:	05753423          	sd	s7,72(a0)
    80001a6e:	05853823          	sd	s8,80(a0)
    80001a72:	05953c23          	sd	s9,88(a0)
    80001a76:	07a53023          	sd	s10,96(a0)
    80001a7a:	07b53423          	sd	s11,104(a0)
    80001a7e:	0005b083          	ld	ra,0(a1)
    80001a82:	0085b103          	ld	sp,8(a1)
    80001a86:	6980                	ld	s0,16(a1)
    80001a88:	6d84                	ld	s1,24(a1)
    80001a8a:	0205b903          	ld	s2,32(a1)
    80001a8e:	0285b983          	ld	s3,40(a1)
    80001a92:	0305ba03          	ld	s4,48(a1)
    80001a96:	0385ba83          	ld	s5,56(a1)
    80001a9a:	0405bb03          	ld	s6,64(a1)
    80001a9e:	0485bb83          	ld	s7,72(a1)
    80001aa2:	0505bc03          	ld	s8,80(a1)
    80001aa6:	0585bc83          	ld	s9,88(a1)
    80001aaa:	0605bd03          	ld	s10,96(a1)
    80001aae:	0685bd83          	ld	s11,104(a1)
    80001ab2:	8082                	ret

0000000080001ab4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ab4:	1141                	addi	sp,sp,-16
    80001ab6:	e406                	sd	ra,8(sp)
    80001ab8:	e022                	sd	s0,0(sp)
    80001aba:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001abc:	00006597          	auipc	a1,0x6
    80001ac0:	78458593          	addi	a1,a1,1924 # 80008240 <etext+0x240>
    80001ac4:	0000d517          	auipc	a0,0xd
    80001ac8:	3bc50513          	addi	a0,a0,956 # 8000ee80 <tickslock>
    80001acc:	00004097          	auipc	ra,0x4
    80001ad0:	69a080e7          	jalr	1690(ra) # 80006166 <initlock>
}
    80001ad4:	60a2                	ld	ra,8(sp)
    80001ad6:	6402                	ld	s0,0(sp)
    80001ad8:	0141                	addi	sp,sp,16
    80001ada:	8082                	ret

0000000080001adc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001adc:	1141                	addi	sp,sp,-16
    80001ade:	e422                	sd	s0,8(sp)
    80001ae0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae2:	00003797          	auipc	a5,0x3
    80001ae6:	5ae78793          	addi	a5,a5,1454 # 80005090 <kernelvec>
    80001aea:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001aee:	6422                	ld	s0,8(sp)
    80001af0:	0141                	addi	sp,sp,16
    80001af2:	8082                	ret

0000000080001af4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001af4:	1141                	addi	sp,sp,-16
    80001af6:	e406                	sd	ra,8(sp)
    80001af8:	e022                	sd	s0,0(sp)
    80001afa:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001afc:	fffff097          	auipc	ra,0xfffff
    80001b00:	380080e7          	jalr	896(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b04:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b08:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b0a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b0e:	00005697          	auipc	a3,0x5
    80001b12:	4f268693          	addi	a3,a3,1266 # 80007000 <_trampoline>
    80001b16:	00005717          	auipc	a4,0x5
    80001b1a:	4ea70713          	addi	a4,a4,1258 # 80007000 <_trampoline>
    80001b1e:	8f15                	sub	a4,a4,a3
    80001b20:	040007b7          	lui	a5,0x4000
    80001b24:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b26:	07b2                	slli	a5,a5,0xc
    80001b28:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b2a:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b2e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b30:	18002673          	csrr	a2,satp
    80001b34:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b36:	6d30                	ld	a2,88(a0)
    80001b38:	6138                	ld	a4,64(a0)
    80001b3a:	6585                	lui	a1,0x1
    80001b3c:	972e                	add	a4,a4,a1
    80001b3e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b40:	6d38                	ld	a4,88(a0)
    80001b42:	00000617          	auipc	a2,0x0
    80001b46:	14060613          	addi	a2,a2,320 # 80001c82 <usertrap>
    80001b4a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b4c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b4e:	8612                	mv	a2,tp
    80001b50:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b52:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b56:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b5a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b62:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b64:	6f18                	ld	a4,24(a4)
    80001b66:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b6a:	692c                	ld	a1,80(a0)
    80001b6c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b6e:	00005717          	auipc	a4,0x5
    80001b72:	52270713          	addi	a4,a4,1314 # 80007090 <userret>
    80001b76:	8f15                	sub	a4,a4,a3
    80001b78:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001b7a:	577d                	li	a4,-1
    80001b7c:	177e                	slli	a4,a4,0x3f
    80001b7e:	8dd9                	or	a1,a1,a4
    80001b80:	02000537          	lui	a0,0x2000
    80001b84:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001b86:	0536                	slli	a0,a0,0xd
    80001b88:	9782                	jalr	a5
}
    80001b8a:	60a2                	ld	ra,8(sp)
    80001b8c:	6402                	ld	s0,0(sp)
    80001b8e:	0141                	addi	sp,sp,16
    80001b90:	8082                	ret

0000000080001b92 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001b92:	1101                	addi	sp,sp,-32
    80001b94:	ec06                	sd	ra,24(sp)
    80001b96:	e822                	sd	s0,16(sp)
    80001b98:	e426                	sd	s1,8(sp)
    80001b9a:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001b9c:	0000d497          	auipc	s1,0xd
    80001ba0:	2e448493          	addi	s1,s1,740 # 8000ee80 <tickslock>
    80001ba4:	8526                	mv	a0,s1
    80001ba6:	00004097          	auipc	ra,0x4
    80001baa:	650080e7          	jalr	1616(ra) # 800061f6 <acquire>
  ticks++;
    80001bae:	00007517          	auipc	a0,0x7
    80001bb2:	46a50513          	addi	a0,a0,1130 # 80009018 <ticks>
    80001bb6:	411c                	lw	a5,0(a0)
    80001bb8:	2785                	addiw	a5,a5,1
    80001bba:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bbc:	00000097          	auipc	ra,0x0
    80001bc0:	b1a080e7          	jalr	-1254(ra) # 800016d6 <wakeup>
  release(&tickslock);
    80001bc4:	8526                	mv	a0,s1
    80001bc6:	00004097          	auipc	ra,0x4
    80001bca:	6e4080e7          	jalr	1764(ra) # 800062aa <release>
}
    80001bce:	60e2                	ld	ra,24(sp)
    80001bd0:	6442                	ld	s0,16(sp)
    80001bd2:	64a2                	ld	s1,8(sp)
    80001bd4:	6105                	addi	sp,sp,32
    80001bd6:	8082                	ret

0000000080001bd8 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bd8:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001bdc:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001bde:	0a07d163          	bgez	a5,80001c80 <devintr+0xa8>
{
    80001be2:	1101                	addi	sp,sp,-32
    80001be4:	ec06                	sd	ra,24(sp)
    80001be6:	e822                	sd	s0,16(sp)
    80001be8:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001bea:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001bee:	46a5                	li	a3,9
    80001bf0:	00d70c63          	beq	a4,a3,80001c08 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001bf4:	577d                	li	a4,-1
    80001bf6:	177e                	slli	a4,a4,0x3f
    80001bf8:	0705                	addi	a4,a4,1
    return 0;
    80001bfa:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001bfc:	06e78163          	beq	a5,a4,80001c5e <devintr+0x86>
  }
}
    80001c00:	60e2                	ld	ra,24(sp)
    80001c02:	6442                	ld	s0,16(sp)
    80001c04:	6105                	addi	sp,sp,32
    80001c06:	8082                	ret
    80001c08:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c0a:	00003097          	auipc	ra,0x3
    80001c0e:	592080e7          	jalr	1426(ra) # 8000519c <plic_claim>
    80001c12:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c14:	47a9                	li	a5,10
    80001c16:	00f50963          	beq	a0,a5,80001c28 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c1a:	4785                	li	a5,1
    80001c1c:	00f50b63          	beq	a0,a5,80001c32 <devintr+0x5a>
    return 1;
    80001c20:	4505                	li	a0,1
    } else if(irq){
    80001c22:	ec89                	bnez	s1,80001c3c <devintr+0x64>
    80001c24:	64a2                	ld	s1,8(sp)
    80001c26:	bfe9                	j	80001c00 <devintr+0x28>
      uartintr();
    80001c28:	00004097          	auipc	ra,0x4
    80001c2c:	4ee080e7          	jalr	1262(ra) # 80006116 <uartintr>
    if(irq)
    80001c30:	a839                	j	80001c4e <devintr+0x76>
      virtio_disk_intr();
    80001c32:	00004097          	auipc	ra,0x4
    80001c36:	a3e080e7          	jalr	-1474(ra) # 80005670 <virtio_disk_intr>
    if(irq)
    80001c3a:	a811                	j	80001c4e <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c3c:	85a6                	mv	a1,s1
    80001c3e:	00006517          	auipc	a0,0x6
    80001c42:	60a50513          	addi	a0,a0,1546 # 80008248 <etext+0x248>
    80001c46:	00004097          	auipc	ra,0x4
    80001c4a:	080080e7          	jalr	128(ra) # 80005cc6 <printf>
      plic_complete(irq);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	00003097          	auipc	ra,0x3
    80001c54:	570080e7          	jalr	1392(ra) # 800051c0 <plic_complete>
    return 1;
    80001c58:	4505                	li	a0,1
    80001c5a:	64a2                	ld	s1,8(sp)
    80001c5c:	b755                	j	80001c00 <devintr+0x28>
    if(cpuid() == 0){
    80001c5e:	fffff097          	auipc	ra,0xfffff
    80001c62:	1f2080e7          	jalr	498(ra) # 80000e50 <cpuid>
    80001c66:	c901                	beqz	a0,80001c76 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c68:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c6c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c6e:	14479073          	csrw	sip,a5
    return 2;
    80001c72:	4509                	li	a0,2
    80001c74:	b771                	j	80001c00 <devintr+0x28>
      clockintr();
    80001c76:	00000097          	auipc	ra,0x0
    80001c7a:	f1c080e7          	jalr	-228(ra) # 80001b92 <clockintr>
    80001c7e:	b7ed                	j	80001c68 <devintr+0x90>
}
    80001c80:	8082                	ret

0000000080001c82 <usertrap>:
{
    80001c82:	1101                	addi	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	e04a                	sd	s2,0(sp)
    80001c8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c8e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001c92:	1007f793          	andi	a5,a5,256
    80001c96:	e3ad                	bnez	a5,80001cf8 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c98:	00003797          	auipc	a5,0x3
    80001c9c:	3f878793          	addi	a5,a5,1016 # 80005090 <kernelvec>
    80001ca0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ca4:	fffff097          	auipc	ra,0xfffff
    80001ca8:	1d8080e7          	jalr	472(ra) # 80000e7c <myproc>
    80001cac:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cae:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cb0:	14102773          	csrr	a4,sepc
    80001cb4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cb6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cba:	47a1                	li	a5,8
    80001cbc:	04f71c63          	bne	a4,a5,80001d14 <usertrap+0x92>
    if(p->killed)
    80001cc0:	551c                	lw	a5,40(a0)
    80001cc2:	e3b9                	bnez	a5,80001d08 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cc4:	6cb8                	ld	a4,88(s1)
    80001cc6:	6f1c                	ld	a5,24(a4)
    80001cc8:	0791                	addi	a5,a5,4
    80001cca:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ccc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cd0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd4:	10079073          	csrw	sstatus,a5
    syscall();
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	2e0080e7          	jalr	736(ra) # 80001fb8 <syscall>
  if(p->killed)
    80001ce0:	549c                	lw	a5,40(s1)
    80001ce2:	ebc1                	bnez	a5,80001d72 <usertrap+0xf0>
  usertrapret();
    80001ce4:	00000097          	auipc	ra,0x0
    80001ce8:	e10080e7          	jalr	-496(ra) # 80001af4 <usertrapret>
}
    80001cec:	60e2                	ld	ra,24(sp)
    80001cee:	6442                	ld	s0,16(sp)
    80001cf0:	64a2                	ld	s1,8(sp)
    80001cf2:	6902                	ld	s2,0(sp)
    80001cf4:	6105                	addi	sp,sp,32
    80001cf6:	8082                	ret
    panic("usertrap: not from user mode");
    80001cf8:	00006517          	auipc	a0,0x6
    80001cfc:	57050513          	addi	a0,a0,1392 # 80008268 <etext+0x268>
    80001d00:	00004097          	auipc	ra,0x4
    80001d04:	f7c080e7          	jalr	-132(ra) # 80005c7c <panic>
      exit(-1);
    80001d08:	557d                	li	a0,-1
    80001d0a:	00000097          	auipc	ra,0x0
    80001d0e:	a9c080e7          	jalr	-1380(ra) # 800017a6 <exit>
    80001d12:	bf4d                	j	80001cc4 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d14:	00000097          	auipc	ra,0x0
    80001d18:	ec4080e7          	jalr	-316(ra) # 80001bd8 <devintr>
    80001d1c:	892a                	mv	s2,a0
    80001d1e:	c501                	beqz	a0,80001d26 <usertrap+0xa4>
  if(p->killed)
    80001d20:	549c                	lw	a5,40(s1)
    80001d22:	c3a1                	beqz	a5,80001d62 <usertrap+0xe0>
    80001d24:	a815                	j	80001d58 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d26:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d2a:	5890                	lw	a2,48(s1)
    80001d2c:	00006517          	auipc	a0,0x6
    80001d30:	55c50513          	addi	a0,a0,1372 # 80008288 <etext+0x288>
    80001d34:	00004097          	auipc	ra,0x4
    80001d38:	f92080e7          	jalr	-110(ra) # 80005cc6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d3c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d40:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d44:	00006517          	auipc	a0,0x6
    80001d48:	57450513          	addi	a0,a0,1396 # 800082b8 <etext+0x2b8>
    80001d4c:	00004097          	auipc	ra,0x4
    80001d50:	f7a080e7          	jalr	-134(ra) # 80005cc6 <printf>
    p->killed = 1;
    80001d54:	4785                	li	a5,1
    80001d56:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d58:	557d                	li	a0,-1
    80001d5a:	00000097          	auipc	ra,0x0
    80001d5e:	a4c080e7          	jalr	-1460(ra) # 800017a6 <exit>
  if(which_dev == 2)
    80001d62:	4789                	li	a5,2
    80001d64:	f8f910e3          	bne	s2,a5,80001ce4 <usertrap+0x62>
    yield();
    80001d68:	fffff097          	auipc	ra,0xfffff
    80001d6c:	7a6080e7          	jalr	1958(ra) # 8000150e <yield>
    80001d70:	bf95                	j	80001ce4 <usertrap+0x62>
  int which_dev = 0;
    80001d72:	4901                	li	s2,0
    80001d74:	b7d5                	j	80001d58 <usertrap+0xd6>

0000000080001d76 <kerneltrap>:
{
    80001d76:	7179                	addi	sp,sp,-48
    80001d78:	f406                	sd	ra,40(sp)
    80001d7a:	f022                	sd	s0,32(sp)
    80001d7c:	ec26                	sd	s1,24(sp)
    80001d7e:	e84a                	sd	s2,16(sp)
    80001d80:	e44e                	sd	s3,8(sp)
    80001d82:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d84:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d88:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d8c:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001d90:	1004f793          	andi	a5,s1,256
    80001d94:	cb85                	beqz	a5,80001dc4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d96:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001d9a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001d9c:	ef85                	bnez	a5,80001dd4 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001d9e:	00000097          	auipc	ra,0x0
    80001da2:	e3a080e7          	jalr	-454(ra) # 80001bd8 <devintr>
    80001da6:	cd1d                	beqz	a0,80001de4 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001da8:	4789                	li	a5,2
    80001daa:	06f50a63          	beq	a0,a5,80001e1e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001dae:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001db2:	10049073          	csrw	sstatus,s1
}
    80001db6:	70a2                	ld	ra,40(sp)
    80001db8:	7402                	ld	s0,32(sp)
    80001dba:	64e2                	ld	s1,24(sp)
    80001dbc:	6942                	ld	s2,16(sp)
    80001dbe:	69a2                	ld	s3,8(sp)
    80001dc0:	6145                	addi	sp,sp,48
    80001dc2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001dc4:	00006517          	auipc	a0,0x6
    80001dc8:	51450513          	addi	a0,a0,1300 # 800082d8 <etext+0x2d8>
    80001dcc:	00004097          	auipc	ra,0x4
    80001dd0:	eb0080e7          	jalr	-336(ra) # 80005c7c <panic>
    panic("kerneltrap: interrupts enabled");
    80001dd4:	00006517          	auipc	a0,0x6
    80001dd8:	52c50513          	addi	a0,a0,1324 # 80008300 <etext+0x300>
    80001ddc:	00004097          	auipc	ra,0x4
    80001de0:	ea0080e7          	jalr	-352(ra) # 80005c7c <panic>
    printf("scause %p\n", scause);
    80001de4:	85ce                	mv	a1,s3
    80001de6:	00006517          	auipc	a0,0x6
    80001dea:	53a50513          	addi	a0,a0,1338 # 80008320 <etext+0x320>
    80001dee:	00004097          	auipc	ra,0x4
    80001df2:	ed8080e7          	jalr	-296(ra) # 80005cc6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dfa:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	53250513          	addi	a0,a0,1330 # 80008330 <etext+0x330>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	ec0080e7          	jalr	-320(ra) # 80005cc6 <printf>
    panic("kerneltrap");
    80001e0e:	00006517          	auipc	a0,0x6
    80001e12:	53a50513          	addi	a0,a0,1338 # 80008348 <etext+0x348>
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	e66080e7          	jalr	-410(ra) # 80005c7c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e1e:	fffff097          	auipc	ra,0xfffff
    80001e22:	05e080e7          	jalr	94(ra) # 80000e7c <myproc>
    80001e26:	d541                	beqz	a0,80001dae <kerneltrap+0x38>
    80001e28:	fffff097          	auipc	ra,0xfffff
    80001e2c:	054080e7          	jalr	84(ra) # 80000e7c <myproc>
    80001e30:	4d18                	lw	a4,24(a0)
    80001e32:	4791                	li	a5,4
    80001e34:	f6f71de3          	bne	a4,a5,80001dae <kerneltrap+0x38>
    yield();
    80001e38:	fffff097          	auipc	ra,0xfffff
    80001e3c:	6d6080e7          	jalr	1750(ra) # 8000150e <yield>
    80001e40:	b7bd                	j	80001dae <kerneltrap+0x38>

0000000080001e42 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e42:	1101                	addi	sp,sp,-32
    80001e44:	ec06                	sd	ra,24(sp)
    80001e46:	e822                	sd	s0,16(sp)
    80001e48:	e426                	sd	s1,8(sp)
    80001e4a:	1000                	addi	s0,sp,32
    80001e4c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e4e:	fffff097          	auipc	ra,0xfffff
    80001e52:	02e080e7          	jalr	46(ra) # 80000e7c <myproc>
  switch (n) {
    80001e56:	4795                	li	a5,5
    80001e58:	0497e163          	bltu	a5,s1,80001e9a <argraw+0x58>
    80001e5c:	048a                	slli	s1,s1,0x2
    80001e5e:	00007717          	auipc	a4,0x7
    80001e62:	98270713          	addi	a4,a4,-1662 # 800087e0 <states.0+0x30>
    80001e66:	94ba                	add	s1,s1,a4
    80001e68:	409c                	lw	a5,0(s1)
    80001e6a:	97ba                	add	a5,a5,a4
    80001e6c:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e6e:	6d3c                	ld	a5,88(a0)
    80001e70:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e72:	60e2                	ld	ra,24(sp)
    80001e74:	6442                	ld	s0,16(sp)
    80001e76:	64a2                	ld	s1,8(sp)
    80001e78:	6105                	addi	sp,sp,32
    80001e7a:	8082                	ret
    return p->trapframe->a1;
    80001e7c:	6d3c                	ld	a5,88(a0)
    80001e7e:	7fa8                	ld	a0,120(a5)
    80001e80:	bfcd                	j	80001e72 <argraw+0x30>
    return p->trapframe->a2;
    80001e82:	6d3c                	ld	a5,88(a0)
    80001e84:	63c8                	ld	a0,128(a5)
    80001e86:	b7f5                	j	80001e72 <argraw+0x30>
    return p->trapframe->a3;
    80001e88:	6d3c                	ld	a5,88(a0)
    80001e8a:	67c8                	ld	a0,136(a5)
    80001e8c:	b7dd                	j	80001e72 <argraw+0x30>
    return p->trapframe->a4;
    80001e8e:	6d3c                	ld	a5,88(a0)
    80001e90:	6bc8                	ld	a0,144(a5)
    80001e92:	b7c5                	j	80001e72 <argraw+0x30>
    return p->trapframe->a5;
    80001e94:	6d3c                	ld	a5,88(a0)
    80001e96:	6fc8                	ld	a0,152(a5)
    80001e98:	bfe9                	j	80001e72 <argraw+0x30>
  panic("argraw");
    80001e9a:	00006517          	auipc	a0,0x6
    80001e9e:	4be50513          	addi	a0,a0,1214 # 80008358 <etext+0x358>
    80001ea2:	00004097          	auipc	ra,0x4
    80001ea6:	dda080e7          	jalr	-550(ra) # 80005c7c <panic>

0000000080001eaa <fetchaddr>:
{
    80001eaa:	1101                	addi	sp,sp,-32
    80001eac:	ec06                	sd	ra,24(sp)
    80001eae:	e822                	sd	s0,16(sp)
    80001eb0:	e426                	sd	s1,8(sp)
    80001eb2:	e04a                	sd	s2,0(sp)
    80001eb4:	1000                	addi	s0,sp,32
    80001eb6:	84aa                	mv	s1,a0
    80001eb8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eba:	fffff097          	auipc	ra,0xfffff
    80001ebe:	fc2080e7          	jalr	-62(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001ec2:	653c                	ld	a5,72(a0)
    80001ec4:	02f4f863          	bgeu	s1,a5,80001ef4 <fetchaddr+0x4a>
    80001ec8:	00848713          	addi	a4,s1,8
    80001ecc:	02e7e663          	bltu	a5,a4,80001ef8 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ed0:	46a1                	li	a3,8
    80001ed2:	8626                	mv	a2,s1
    80001ed4:	85ca                	mv	a1,s2
    80001ed6:	6928                	ld	a0,80(a0)
    80001ed8:	fffff097          	auipc	ra,0xfffff
    80001edc:	ccc080e7          	jalr	-820(ra) # 80000ba4 <copyin>
    80001ee0:	00a03533          	snez	a0,a0
    80001ee4:	40a00533          	neg	a0,a0
}
    80001ee8:	60e2                	ld	ra,24(sp)
    80001eea:	6442                	ld	s0,16(sp)
    80001eec:	64a2                	ld	s1,8(sp)
    80001eee:	6902                	ld	s2,0(sp)
    80001ef0:	6105                	addi	sp,sp,32
    80001ef2:	8082                	ret
    return -1;
    80001ef4:	557d                	li	a0,-1
    80001ef6:	bfcd                	j	80001ee8 <fetchaddr+0x3e>
    80001ef8:	557d                	li	a0,-1
    80001efa:	b7fd                	j	80001ee8 <fetchaddr+0x3e>

0000000080001efc <fetchstr>:
{
    80001efc:	7179                	addi	sp,sp,-48
    80001efe:	f406                	sd	ra,40(sp)
    80001f00:	f022                	sd	s0,32(sp)
    80001f02:	ec26                	sd	s1,24(sp)
    80001f04:	e84a                	sd	s2,16(sp)
    80001f06:	e44e                	sd	s3,8(sp)
    80001f08:	1800                	addi	s0,sp,48
    80001f0a:	892a                	mv	s2,a0
    80001f0c:	84ae                	mv	s1,a1
    80001f0e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f10:	fffff097          	auipc	ra,0xfffff
    80001f14:	f6c080e7          	jalr	-148(ra) # 80000e7c <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f18:	86ce                	mv	a3,s3
    80001f1a:	864a                	mv	a2,s2
    80001f1c:	85a6                	mv	a1,s1
    80001f1e:	6928                	ld	a0,80(a0)
    80001f20:	fffff097          	auipc	ra,0xfffff
    80001f24:	d12080e7          	jalr	-750(ra) # 80000c32 <copyinstr>
  if(err < 0)
    80001f28:	00054763          	bltz	a0,80001f36 <fetchstr+0x3a>
  return strlen(buf);
    80001f2c:	8526                	mv	a0,s1
    80001f2e:	ffffe097          	auipc	ra,0xffffe
    80001f32:	3c0080e7          	jalr	960(ra) # 800002ee <strlen>
}
    80001f36:	70a2                	ld	ra,40(sp)
    80001f38:	7402                	ld	s0,32(sp)
    80001f3a:	64e2                	ld	s1,24(sp)
    80001f3c:	6942                	ld	s2,16(sp)
    80001f3e:	69a2                	ld	s3,8(sp)
    80001f40:	6145                	addi	sp,sp,48
    80001f42:	8082                	ret

0000000080001f44 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	1000                	addi	s0,sp,32
    80001f4e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f50:	00000097          	auipc	ra,0x0
    80001f54:	ef2080e7          	jalr	-270(ra) # 80001e42 <argraw>
    80001f58:	c088                	sw	a0,0(s1)
  return 0;
}
    80001f5a:	4501                	li	a0,0
    80001f5c:	60e2                	ld	ra,24(sp)
    80001f5e:	6442                	ld	s0,16(sp)
    80001f60:	64a2                	ld	s1,8(sp)
    80001f62:	6105                	addi	sp,sp,32
    80001f64:	8082                	ret

0000000080001f66 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001f66:	1101                	addi	sp,sp,-32
    80001f68:	ec06                	sd	ra,24(sp)
    80001f6a:	e822                	sd	s0,16(sp)
    80001f6c:	e426                	sd	s1,8(sp)
    80001f6e:	1000                	addi	s0,sp,32
    80001f70:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f72:	00000097          	auipc	ra,0x0
    80001f76:	ed0080e7          	jalr	-304(ra) # 80001e42 <argraw>
    80001f7a:	e088                	sd	a0,0(s1)
  return 0;
}
    80001f7c:	4501                	li	a0,0
    80001f7e:	60e2                	ld	ra,24(sp)
    80001f80:	6442                	ld	s0,16(sp)
    80001f82:	64a2                	ld	s1,8(sp)
    80001f84:	6105                	addi	sp,sp,32
    80001f86:	8082                	ret

0000000080001f88 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f88:	1101                	addi	sp,sp,-32
    80001f8a:	ec06                	sd	ra,24(sp)
    80001f8c:	e822                	sd	s0,16(sp)
    80001f8e:	e426                	sd	s1,8(sp)
    80001f90:	e04a                	sd	s2,0(sp)
    80001f92:	1000                	addi	s0,sp,32
    80001f94:	84ae                	mv	s1,a1
    80001f96:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	eaa080e7          	jalr	-342(ra) # 80001e42 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80001fa0:	864a                	mv	a2,s2
    80001fa2:	85a6                	mv	a1,s1
    80001fa4:	00000097          	auipc	ra,0x0
    80001fa8:	f58080e7          	jalr	-168(ra) # 80001efc <fetchstr>
}
    80001fac:	60e2                	ld	ra,24(sp)
    80001fae:	6442                	ld	s0,16(sp)
    80001fb0:	64a2                	ld	s1,8(sp)
    80001fb2:	6902                	ld	s2,0(sp)
    80001fb4:	6105                	addi	sp,sp,32
    80001fb6:	8082                	ret

0000000080001fb8 <syscall>:
[SYS_trace]   sys_trace,
};

void
syscall(void)
{
    80001fb8:	7179                	addi	sp,sp,-48
    80001fba:	f406                	sd	ra,40(sp)
    80001fbc:	f022                	sd	s0,32(sp)
    80001fbe:	ec26                	sd	s1,24(sp)
    80001fc0:	e84a                	sd	s2,16(sp)
    80001fc2:	e44e                	sd	s3,8(sp)
    80001fc4:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001fc6:	fffff097          	auipc	ra,0xfffff
    80001fca:	eb6080e7          	jalr	-330(ra) # 80000e7c <myproc>
    80001fce:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fd0:	05853903          	ld	s2,88(a0)
    80001fd4:	0a893783          	ld	a5,168(s2)
    80001fd8:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fdc:	37fd                	addiw	a5,a5,-1
    80001fde:	4755                	li	a4,21
    80001fe0:	02f76f63          	bltu	a4,a5,8000201e <syscall+0x66>
    80001fe4:	00399713          	slli	a4,s3,0x3
    80001fe8:	00007797          	auipc	a5,0x7
    80001fec:	81078793          	addi	a5,a5,-2032 # 800087f8 <syscalls>
    80001ff0:	97ba                	add	a5,a5,a4
    80001ff2:	639c                	ld	a5,0(a5)
    80001ff4:	c78d                	beqz	a5,8000201e <syscall+0x66>
    p->trapframe->a0 = syscalls[num]();
    80001ff6:	9782                	jalr	a5
    80001ff8:	06a93823          	sd	a0,112(s2)
    if (SYS_trace == num) {
    80001ffc:	47d9                	li	a5,22
    80001ffe:	02f99f63          	bne	s3,a5,8000203c <syscall+0x84>
      printf("%d: syscall %s -> %d\n",
    80002002:	6cbc                	ld	a5,88(s1)
    80002004:	7bb4                	ld	a3,112(a5)
    80002006:	15848613          	addi	a2,s1,344
    8000200a:	588c                	lw	a1,48(s1)
    8000200c:	00006517          	auipc	a0,0x6
    80002010:	35450513          	addi	a0,a0,852 # 80008360 <etext+0x360>
    80002014:	00004097          	auipc	ra,0x4
    80002018:	cb2080e7          	jalr	-846(ra) # 80005cc6 <printf>
    8000201c:	a005                	j	8000203c <syscall+0x84>
        p->pid, p->name, p->trapframe->a0);
    }
    
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000201e:	86ce                	mv	a3,s3
    80002020:	15848613          	addi	a2,s1,344
    80002024:	588c                	lw	a1,48(s1)
    80002026:	00006517          	auipc	a0,0x6
    8000202a:	35250513          	addi	a0,a0,850 # 80008378 <etext+0x378>
    8000202e:	00004097          	auipc	ra,0x4
    80002032:	c98080e7          	jalr	-872(ra) # 80005cc6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002036:	6cbc                	ld	a5,88(s1)
    80002038:	577d                	li	a4,-1
    8000203a:	fbb8                	sd	a4,112(a5)
  }
}
    8000203c:	70a2                	ld	ra,40(sp)
    8000203e:	7402                	ld	s0,32(sp)
    80002040:	64e2                	ld	s1,24(sp)
    80002042:	6942                	ld	s2,16(sp)
    80002044:	69a2                	ld	s3,8(sp)
    80002046:	6145                	addi	sp,sp,48
    80002048:	8082                	ret

000000008000204a <sys_exit>:
    "close",
};

uint64
sys_exit(void)
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    80002052:	fec40593          	addi	a1,s0,-20
    80002056:	4501                	li	a0,0
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	eec080e7          	jalr	-276(ra) # 80001f44 <argint>
    return -1;
    80002060:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002062:	00054963          	bltz	a0,80002074 <sys_exit+0x2a>
  exit(n);
    80002066:	fec42503          	lw	a0,-20(s0)
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	73c080e7          	jalr	1852(ra) # 800017a6 <exit>
  return 0; // not reached
    80002072:	4781                	li	a5,0
}
    80002074:	853e                	mv	a0,a5
    80002076:	60e2                	ld	ra,24(sp)
    80002078:	6442                	ld	s0,16(sp)
    8000207a:	6105                	addi	sp,sp,32
    8000207c:	8082                	ret

000000008000207e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000207e:	1141                	addi	sp,sp,-16
    80002080:	e406                	sd	ra,8(sp)
    80002082:	e022                	sd	s0,0(sp)
    80002084:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	df6080e7          	jalr	-522(ra) # 80000e7c <myproc>
}
    8000208e:	5908                	lw	a0,48(a0)
    80002090:	60a2                	ld	ra,8(sp)
    80002092:	6402                	ld	s0,0(sp)
    80002094:	0141                	addi	sp,sp,16
    80002096:	8082                	ret

0000000080002098 <sys_fork>:

uint64
sys_fork(void)
{
    80002098:	1141                	addi	sp,sp,-16
    8000209a:	e406                	sd	ra,8(sp)
    8000209c:	e022                	sd	s0,0(sp)
    8000209e:	0800                	addi	s0,sp,16
  return fork();
    800020a0:	fffff097          	auipc	ra,0xfffff
    800020a4:	1ae080e7          	jalr	430(ra) # 8000124e <fork>
}
    800020a8:	60a2                	ld	ra,8(sp)
    800020aa:	6402                	ld	s0,0(sp)
    800020ac:	0141                	addi	sp,sp,16
    800020ae:	8082                	ret

00000000800020b0 <sys_wait>:

uint64
sys_wait(void)
{
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    800020b8:	fe840593          	addi	a1,s0,-24
    800020bc:	4501                	li	a0,0
    800020be:	00000097          	auipc	ra,0x0
    800020c2:	ea8080e7          	jalr	-344(ra) # 80001f66 <argaddr>
    800020c6:	87aa                	mv	a5,a0
    return -1;
    800020c8:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    800020ca:	0007c863          	bltz	a5,800020da <sys_wait+0x2a>
  return wait(p);
    800020ce:	fe843503          	ld	a0,-24(s0)
    800020d2:	fffff097          	auipc	ra,0xfffff
    800020d6:	4dc080e7          	jalr	1244(ra) # 800015ae <wait>
}
    800020da:	60e2                	ld	ra,24(sp)
    800020dc:	6442                	ld	s0,16(sp)
    800020de:	6105                	addi	sp,sp,32
    800020e0:	8082                	ret

00000000800020e2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800020e2:	7179                	addi	sp,sp,-48
    800020e4:	f406                	sd	ra,40(sp)
    800020e6:	f022                	sd	s0,32(sp)
    800020e8:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if (argint(0, &n) < 0)
    800020ea:	fdc40593          	addi	a1,s0,-36
    800020ee:	4501                	li	a0,0
    800020f0:	00000097          	auipc	ra,0x0
    800020f4:	e54080e7          	jalr	-428(ra) # 80001f44 <argint>
    800020f8:	87aa                	mv	a5,a0
    return -1;
    800020fa:	557d                	li	a0,-1
  if (argint(0, &n) < 0)
    800020fc:	0207c263          	bltz	a5,80002120 <sys_sbrk+0x3e>
    80002100:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    80002102:	fffff097          	auipc	ra,0xfffff
    80002106:	d7a080e7          	jalr	-646(ra) # 80000e7c <myproc>
    8000210a:	4524                	lw	s1,72(a0)
  if (growproc(n) < 0)
    8000210c:	fdc42503          	lw	a0,-36(s0)
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	0c6080e7          	jalr	198(ra) # 800011d6 <growproc>
    80002118:	00054863          	bltz	a0,80002128 <sys_sbrk+0x46>
    return -1;
  return addr;
    8000211c:	8526                	mv	a0,s1
    8000211e:	64e2                	ld	s1,24(sp)
}
    80002120:	70a2                	ld	ra,40(sp)
    80002122:	7402                	ld	s0,32(sp)
    80002124:	6145                	addi	sp,sp,48
    80002126:	8082                	ret
    return -1;
    80002128:	557d                	li	a0,-1
    8000212a:	64e2                	ld	s1,24(sp)
    8000212c:	bfd5                	j	80002120 <sys_sbrk+0x3e>

000000008000212e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000212e:	7139                	addi	sp,sp,-64
    80002130:	fc06                	sd	ra,56(sp)
    80002132:	f822                	sd	s0,48(sp)
    80002134:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80002136:	fcc40593          	addi	a1,s0,-52
    8000213a:	4501                	li	a0,0
    8000213c:	00000097          	auipc	ra,0x0
    80002140:	e08080e7          	jalr	-504(ra) # 80001f44 <argint>
    return -1;
    80002144:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002146:	06054b63          	bltz	a0,800021bc <sys_sleep+0x8e>
    8000214a:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    8000214c:	0000d517          	auipc	a0,0xd
    80002150:	d3450513          	addi	a0,a0,-716 # 8000ee80 <tickslock>
    80002154:	00004097          	auipc	ra,0x4
    80002158:	0a2080e7          	jalr	162(ra) # 800061f6 <acquire>
  ticks0 = ticks;
    8000215c:	00007917          	auipc	s2,0x7
    80002160:	ebc92903          	lw	s2,-324(s2) # 80009018 <ticks>
  while (ticks - ticks0 < n)
    80002164:	fcc42783          	lw	a5,-52(s0)
    80002168:	c3a1                	beqz	a5,800021a8 <sys_sleep+0x7a>
    8000216a:	f426                	sd	s1,40(sp)
    8000216c:	ec4e                	sd	s3,24(sp)
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000216e:	0000d997          	auipc	s3,0xd
    80002172:	d1298993          	addi	s3,s3,-750 # 8000ee80 <tickslock>
    80002176:	00007497          	auipc	s1,0x7
    8000217a:	ea248493          	addi	s1,s1,-350 # 80009018 <ticks>
    if (myproc()->killed)
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	cfe080e7          	jalr	-770(ra) # 80000e7c <myproc>
    80002186:	551c                	lw	a5,40(a0)
    80002188:	ef9d                	bnez	a5,800021c6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000218a:	85ce                	mv	a1,s3
    8000218c:	8526                	mv	a0,s1
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	3bc080e7          	jalr	956(ra) # 8000154a <sleep>
  while (ticks - ticks0 < n)
    80002196:	409c                	lw	a5,0(s1)
    80002198:	412787bb          	subw	a5,a5,s2
    8000219c:	fcc42703          	lw	a4,-52(s0)
    800021a0:	fce7efe3          	bltu	a5,a4,8000217e <sys_sleep+0x50>
    800021a4:	74a2                	ld	s1,40(sp)
    800021a6:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800021a8:	0000d517          	auipc	a0,0xd
    800021ac:	cd850513          	addi	a0,a0,-808 # 8000ee80 <tickslock>
    800021b0:	00004097          	auipc	ra,0x4
    800021b4:	0fa080e7          	jalr	250(ra) # 800062aa <release>
  return 0;
    800021b8:	4781                	li	a5,0
    800021ba:	7902                	ld	s2,32(sp)
}
    800021bc:	853e                	mv	a0,a5
    800021be:	70e2                	ld	ra,56(sp)
    800021c0:	7442                	ld	s0,48(sp)
    800021c2:	6121                	addi	sp,sp,64
    800021c4:	8082                	ret
      release(&tickslock);
    800021c6:	0000d517          	auipc	a0,0xd
    800021ca:	cba50513          	addi	a0,a0,-838 # 8000ee80 <tickslock>
    800021ce:	00004097          	auipc	ra,0x4
    800021d2:	0dc080e7          	jalr	220(ra) # 800062aa <release>
      return -1;
    800021d6:	57fd                	li	a5,-1
    800021d8:	74a2                	ld	s1,40(sp)
    800021da:	7902                	ld	s2,32(sp)
    800021dc:	69e2                	ld	s3,24(sp)
    800021de:	bff9                	j	800021bc <sys_sleep+0x8e>

00000000800021e0 <sys_kill>:

uint64
sys_kill(void)
{
    800021e0:	1101                	addi	sp,sp,-32
    800021e2:	ec06                	sd	ra,24(sp)
    800021e4:	e822                	sd	s0,16(sp)
    800021e6:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    800021e8:	fec40593          	addi	a1,s0,-20
    800021ec:	4501                	li	a0,0
    800021ee:	00000097          	auipc	ra,0x0
    800021f2:	d56080e7          	jalr	-682(ra) # 80001f44 <argint>
    800021f6:	87aa                	mv	a5,a0
    return -1;
    800021f8:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    800021fa:	0007c863          	bltz	a5,8000220a <sys_kill+0x2a>
  return kill(pid);
    800021fe:	fec42503          	lw	a0,-20(s0)
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	67a080e7          	jalr	1658(ra) # 8000187c <kill>
}
    8000220a:	60e2                	ld	ra,24(sp)
    8000220c:	6442                	ld	s0,16(sp)
    8000220e:	6105                	addi	sp,sp,32
    80002210:	8082                	ret

0000000080002212 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002212:	1101                	addi	sp,sp,-32
    80002214:	ec06                	sd	ra,24(sp)
    80002216:	e822                	sd	s0,16(sp)
    80002218:	e426                	sd	s1,8(sp)
    8000221a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000221c:	0000d517          	auipc	a0,0xd
    80002220:	c6450513          	addi	a0,a0,-924 # 8000ee80 <tickslock>
    80002224:	00004097          	auipc	ra,0x4
    80002228:	fd2080e7          	jalr	-46(ra) # 800061f6 <acquire>
  xticks = ticks;
    8000222c:	00007497          	auipc	s1,0x7
    80002230:	dec4a483          	lw	s1,-532(s1) # 80009018 <ticks>
  release(&tickslock);
    80002234:	0000d517          	auipc	a0,0xd
    80002238:	c4c50513          	addi	a0,a0,-948 # 8000ee80 <tickslock>
    8000223c:	00004097          	auipc	ra,0x4
    80002240:	06e080e7          	jalr	110(ra) # 800062aa <release>
  return xticks;
}
    80002244:	02049513          	slli	a0,s1,0x20
    80002248:	9101                	srli	a0,a0,0x20
    8000224a:	60e2                	ld	ra,24(sp)
    8000224c:	6442                	ld	s0,16(sp)
    8000224e:	64a2                	ld	s1,8(sp)
    80002250:	6105                	addi	sp,sp,32
    80002252:	8082                	ret

0000000080002254 <sys_trace>:

uint64
sys_trace(void)
{
    80002254:	1101                	addi	sp,sp,-32
    80002256:	ec06                	sd	ra,24(sp)
    80002258:	e822                	sd	s0,16(sp)
    8000225a:	1000                	addi	s0,sp,32
  int mask;
  if (argint(0, &mask) < 0)
    8000225c:	fec40593          	addi	a1,s0,-20
    80002260:	4501                	li	a0,0
    80002262:	00000097          	auipc	ra,0x0
    80002266:	ce2080e7          	jalr	-798(ra) # 80001f44 <argint>
    return -1;
    8000226a:	57fd                	li	a5,-1
  if (argint(0, &mask) < 0)
    8000226c:	00054a63          	bltz	a0,80002280 <sys_trace+0x2c>
  struct proc *p = myproc();
    80002270:	fffff097          	auipc	ra,0xfffff
    80002274:	c0c080e7          	jalr	-1012(ra) # 80000e7c <myproc>
  p->mask = mask;
    80002278:	fec42783          	lw	a5,-20(s0)
    8000227c:	d95c                	sw	a5,52(a0)
  return 0;
    8000227e:	4781                	li	a5,0
}
    80002280:	853e                	mv	a0,a5
    80002282:	60e2                	ld	ra,24(sp)
    80002284:	6442                	ld	s0,16(sp)
    80002286:	6105                	addi	sp,sp,32
    80002288:	8082                	ret

000000008000228a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000228a:	7179                	addi	sp,sp,-48
    8000228c:	f406                	sd	ra,40(sp)
    8000228e:	f022                	sd	s0,32(sp)
    80002290:	ec26                	sd	s1,24(sp)
    80002292:	e84a                	sd	s2,16(sp)
    80002294:	e44e                	sd	s3,8(sp)
    80002296:	e052                	sd	s4,0(sp)
    80002298:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000229a:	00006597          	auipc	a1,0x6
    8000229e:	19e58593          	addi	a1,a1,414 # 80008438 <etext+0x438>
    800022a2:	0000d517          	auipc	a0,0xd
    800022a6:	bf650513          	addi	a0,a0,-1034 # 8000ee98 <bcache>
    800022aa:	00004097          	auipc	ra,0x4
    800022ae:	ebc080e7          	jalr	-324(ra) # 80006166 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800022b2:	00015797          	auipc	a5,0x15
    800022b6:	be678793          	addi	a5,a5,-1050 # 80016e98 <bcache+0x8000>
    800022ba:	00015717          	auipc	a4,0x15
    800022be:	e4670713          	addi	a4,a4,-442 # 80017100 <bcache+0x8268>
    800022c2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800022c6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800022ca:	0000d497          	auipc	s1,0xd
    800022ce:	be648493          	addi	s1,s1,-1050 # 8000eeb0 <bcache+0x18>
    b->next = bcache.head.next;
    800022d2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800022d4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800022d6:	00006a17          	auipc	s4,0x6
    800022da:	16aa0a13          	addi	s4,s4,362 # 80008440 <etext+0x440>
    b->next = bcache.head.next;
    800022de:	2b893783          	ld	a5,696(s2)
    800022e2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800022e4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800022e8:	85d2                	mv	a1,s4
    800022ea:	01048513          	addi	a0,s1,16
    800022ee:	00001097          	auipc	ra,0x1
    800022f2:	4b2080e7          	jalr	1202(ra) # 800037a0 <initsleeplock>
    bcache.head.next->prev = b;
    800022f6:	2b893783          	ld	a5,696(s2)
    800022fa:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800022fc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002300:	45848493          	addi	s1,s1,1112
    80002304:	fd349de3          	bne	s1,s3,800022de <binit+0x54>
  }
}
    80002308:	70a2                	ld	ra,40(sp)
    8000230a:	7402                	ld	s0,32(sp)
    8000230c:	64e2                	ld	s1,24(sp)
    8000230e:	6942                	ld	s2,16(sp)
    80002310:	69a2                	ld	s3,8(sp)
    80002312:	6a02                	ld	s4,0(sp)
    80002314:	6145                	addi	sp,sp,48
    80002316:	8082                	ret

0000000080002318 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002318:	7179                	addi	sp,sp,-48
    8000231a:	f406                	sd	ra,40(sp)
    8000231c:	f022                	sd	s0,32(sp)
    8000231e:	ec26                	sd	s1,24(sp)
    80002320:	e84a                	sd	s2,16(sp)
    80002322:	e44e                	sd	s3,8(sp)
    80002324:	1800                	addi	s0,sp,48
    80002326:	892a                	mv	s2,a0
    80002328:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000232a:	0000d517          	auipc	a0,0xd
    8000232e:	b6e50513          	addi	a0,a0,-1170 # 8000ee98 <bcache>
    80002332:	00004097          	auipc	ra,0x4
    80002336:	ec4080e7          	jalr	-316(ra) # 800061f6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000233a:	00015497          	auipc	s1,0x15
    8000233e:	e164b483          	ld	s1,-490(s1) # 80017150 <bcache+0x82b8>
    80002342:	00015797          	auipc	a5,0x15
    80002346:	dbe78793          	addi	a5,a5,-578 # 80017100 <bcache+0x8268>
    8000234a:	02f48f63          	beq	s1,a5,80002388 <bread+0x70>
    8000234e:	873e                	mv	a4,a5
    80002350:	a021                	j	80002358 <bread+0x40>
    80002352:	68a4                	ld	s1,80(s1)
    80002354:	02e48a63          	beq	s1,a4,80002388 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002358:	449c                	lw	a5,8(s1)
    8000235a:	ff279ce3          	bne	a5,s2,80002352 <bread+0x3a>
    8000235e:	44dc                	lw	a5,12(s1)
    80002360:	ff3799e3          	bne	a5,s3,80002352 <bread+0x3a>
      b->refcnt++;
    80002364:	40bc                	lw	a5,64(s1)
    80002366:	2785                	addiw	a5,a5,1
    80002368:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000236a:	0000d517          	auipc	a0,0xd
    8000236e:	b2e50513          	addi	a0,a0,-1234 # 8000ee98 <bcache>
    80002372:	00004097          	auipc	ra,0x4
    80002376:	f38080e7          	jalr	-200(ra) # 800062aa <release>
      acquiresleep(&b->lock);
    8000237a:	01048513          	addi	a0,s1,16
    8000237e:	00001097          	auipc	ra,0x1
    80002382:	45c080e7          	jalr	1116(ra) # 800037da <acquiresleep>
      return b;
    80002386:	a8b9                	j	800023e4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002388:	00015497          	auipc	s1,0x15
    8000238c:	dc04b483          	ld	s1,-576(s1) # 80017148 <bcache+0x82b0>
    80002390:	00015797          	auipc	a5,0x15
    80002394:	d7078793          	addi	a5,a5,-656 # 80017100 <bcache+0x8268>
    80002398:	00f48863          	beq	s1,a5,800023a8 <bread+0x90>
    8000239c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000239e:	40bc                	lw	a5,64(s1)
    800023a0:	cf81                	beqz	a5,800023b8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800023a2:	64a4                	ld	s1,72(s1)
    800023a4:	fee49de3          	bne	s1,a4,8000239e <bread+0x86>
  panic("bget: no buffers");
    800023a8:	00006517          	auipc	a0,0x6
    800023ac:	0a050513          	addi	a0,a0,160 # 80008448 <etext+0x448>
    800023b0:	00004097          	auipc	ra,0x4
    800023b4:	8cc080e7          	jalr	-1844(ra) # 80005c7c <panic>
      b->dev = dev;
    800023b8:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800023bc:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800023c0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800023c4:	4785                	li	a5,1
    800023c6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800023c8:	0000d517          	auipc	a0,0xd
    800023cc:	ad050513          	addi	a0,a0,-1328 # 8000ee98 <bcache>
    800023d0:	00004097          	auipc	ra,0x4
    800023d4:	eda080e7          	jalr	-294(ra) # 800062aa <release>
      acquiresleep(&b->lock);
    800023d8:	01048513          	addi	a0,s1,16
    800023dc:	00001097          	auipc	ra,0x1
    800023e0:	3fe080e7          	jalr	1022(ra) # 800037da <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800023e4:	409c                	lw	a5,0(s1)
    800023e6:	cb89                	beqz	a5,800023f8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800023e8:	8526                	mv	a0,s1
    800023ea:	70a2                	ld	ra,40(sp)
    800023ec:	7402                	ld	s0,32(sp)
    800023ee:	64e2                	ld	s1,24(sp)
    800023f0:	6942                	ld	s2,16(sp)
    800023f2:	69a2                	ld	s3,8(sp)
    800023f4:	6145                	addi	sp,sp,48
    800023f6:	8082                	ret
    virtio_disk_rw(b, 0);
    800023f8:	4581                	li	a1,0
    800023fa:	8526                	mv	a0,s1
    800023fc:	00003097          	auipc	ra,0x3
    80002400:	fe6080e7          	jalr	-26(ra) # 800053e2 <virtio_disk_rw>
    b->valid = 1;
    80002404:	4785                	li	a5,1
    80002406:	c09c                	sw	a5,0(s1)
  return b;
    80002408:	b7c5                	j	800023e8 <bread+0xd0>

000000008000240a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000240a:	1101                	addi	sp,sp,-32
    8000240c:	ec06                	sd	ra,24(sp)
    8000240e:	e822                	sd	s0,16(sp)
    80002410:	e426                	sd	s1,8(sp)
    80002412:	1000                	addi	s0,sp,32
    80002414:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002416:	0541                	addi	a0,a0,16
    80002418:	00001097          	auipc	ra,0x1
    8000241c:	45c080e7          	jalr	1116(ra) # 80003874 <holdingsleep>
    80002420:	cd01                	beqz	a0,80002438 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002422:	4585                	li	a1,1
    80002424:	8526                	mv	a0,s1
    80002426:	00003097          	auipc	ra,0x3
    8000242a:	fbc080e7          	jalr	-68(ra) # 800053e2 <virtio_disk_rw>
}
    8000242e:	60e2                	ld	ra,24(sp)
    80002430:	6442                	ld	s0,16(sp)
    80002432:	64a2                	ld	s1,8(sp)
    80002434:	6105                	addi	sp,sp,32
    80002436:	8082                	ret
    panic("bwrite");
    80002438:	00006517          	auipc	a0,0x6
    8000243c:	02850513          	addi	a0,a0,40 # 80008460 <etext+0x460>
    80002440:	00004097          	auipc	ra,0x4
    80002444:	83c080e7          	jalr	-1988(ra) # 80005c7c <panic>

0000000080002448 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002448:	1101                	addi	sp,sp,-32
    8000244a:	ec06                	sd	ra,24(sp)
    8000244c:	e822                	sd	s0,16(sp)
    8000244e:	e426                	sd	s1,8(sp)
    80002450:	e04a                	sd	s2,0(sp)
    80002452:	1000                	addi	s0,sp,32
    80002454:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002456:	01050913          	addi	s2,a0,16
    8000245a:	854a                	mv	a0,s2
    8000245c:	00001097          	auipc	ra,0x1
    80002460:	418080e7          	jalr	1048(ra) # 80003874 <holdingsleep>
    80002464:	c925                	beqz	a0,800024d4 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002466:	854a                	mv	a0,s2
    80002468:	00001097          	auipc	ra,0x1
    8000246c:	3c8080e7          	jalr	968(ra) # 80003830 <releasesleep>

  acquire(&bcache.lock);
    80002470:	0000d517          	auipc	a0,0xd
    80002474:	a2850513          	addi	a0,a0,-1496 # 8000ee98 <bcache>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	d7e080e7          	jalr	-642(ra) # 800061f6 <acquire>
  b->refcnt--;
    80002480:	40bc                	lw	a5,64(s1)
    80002482:	37fd                	addiw	a5,a5,-1
    80002484:	0007871b          	sext.w	a4,a5
    80002488:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000248a:	e71d                	bnez	a4,800024b8 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000248c:	68b8                	ld	a4,80(s1)
    8000248e:	64bc                	ld	a5,72(s1)
    80002490:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002492:	68b8                	ld	a4,80(s1)
    80002494:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002496:	00015797          	auipc	a5,0x15
    8000249a:	a0278793          	addi	a5,a5,-1534 # 80016e98 <bcache+0x8000>
    8000249e:	2b87b703          	ld	a4,696(a5)
    800024a2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800024a4:	00015717          	auipc	a4,0x15
    800024a8:	c5c70713          	addi	a4,a4,-932 # 80017100 <bcache+0x8268>
    800024ac:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800024ae:	2b87b703          	ld	a4,696(a5)
    800024b2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800024b4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800024b8:	0000d517          	auipc	a0,0xd
    800024bc:	9e050513          	addi	a0,a0,-1568 # 8000ee98 <bcache>
    800024c0:	00004097          	auipc	ra,0x4
    800024c4:	dea080e7          	jalr	-534(ra) # 800062aa <release>
}
    800024c8:	60e2                	ld	ra,24(sp)
    800024ca:	6442                	ld	s0,16(sp)
    800024cc:	64a2                	ld	s1,8(sp)
    800024ce:	6902                	ld	s2,0(sp)
    800024d0:	6105                	addi	sp,sp,32
    800024d2:	8082                	ret
    panic("brelse");
    800024d4:	00006517          	auipc	a0,0x6
    800024d8:	f9450513          	addi	a0,a0,-108 # 80008468 <etext+0x468>
    800024dc:	00003097          	auipc	ra,0x3
    800024e0:	7a0080e7          	jalr	1952(ra) # 80005c7c <panic>

00000000800024e4 <bpin>:

void
bpin(struct buf *b) {
    800024e4:	1101                	addi	sp,sp,-32
    800024e6:	ec06                	sd	ra,24(sp)
    800024e8:	e822                	sd	s0,16(sp)
    800024ea:	e426                	sd	s1,8(sp)
    800024ec:	1000                	addi	s0,sp,32
    800024ee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800024f0:	0000d517          	auipc	a0,0xd
    800024f4:	9a850513          	addi	a0,a0,-1624 # 8000ee98 <bcache>
    800024f8:	00004097          	auipc	ra,0x4
    800024fc:	cfe080e7          	jalr	-770(ra) # 800061f6 <acquire>
  b->refcnt++;
    80002500:	40bc                	lw	a5,64(s1)
    80002502:	2785                	addiw	a5,a5,1
    80002504:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002506:	0000d517          	auipc	a0,0xd
    8000250a:	99250513          	addi	a0,a0,-1646 # 8000ee98 <bcache>
    8000250e:	00004097          	auipc	ra,0x4
    80002512:	d9c080e7          	jalr	-612(ra) # 800062aa <release>
}
    80002516:	60e2                	ld	ra,24(sp)
    80002518:	6442                	ld	s0,16(sp)
    8000251a:	64a2                	ld	s1,8(sp)
    8000251c:	6105                	addi	sp,sp,32
    8000251e:	8082                	ret

0000000080002520 <bunpin>:

void
bunpin(struct buf *b) {
    80002520:	1101                	addi	sp,sp,-32
    80002522:	ec06                	sd	ra,24(sp)
    80002524:	e822                	sd	s0,16(sp)
    80002526:	e426                	sd	s1,8(sp)
    80002528:	1000                	addi	s0,sp,32
    8000252a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000252c:	0000d517          	auipc	a0,0xd
    80002530:	96c50513          	addi	a0,a0,-1684 # 8000ee98 <bcache>
    80002534:	00004097          	auipc	ra,0x4
    80002538:	cc2080e7          	jalr	-830(ra) # 800061f6 <acquire>
  b->refcnt--;
    8000253c:	40bc                	lw	a5,64(s1)
    8000253e:	37fd                	addiw	a5,a5,-1
    80002540:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002542:	0000d517          	auipc	a0,0xd
    80002546:	95650513          	addi	a0,a0,-1706 # 8000ee98 <bcache>
    8000254a:	00004097          	auipc	ra,0x4
    8000254e:	d60080e7          	jalr	-672(ra) # 800062aa <release>
}
    80002552:	60e2                	ld	ra,24(sp)
    80002554:	6442                	ld	s0,16(sp)
    80002556:	64a2                	ld	s1,8(sp)
    80002558:	6105                	addi	sp,sp,32
    8000255a:	8082                	ret

000000008000255c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000255c:	1101                	addi	sp,sp,-32
    8000255e:	ec06                	sd	ra,24(sp)
    80002560:	e822                	sd	s0,16(sp)
    80002562:	e426                	sd	s1,8(sp)
    80002564:	e04a                	sd	s2,0(sp)
    80002566:	1000                	addi	s0,sp,32
    80002568:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000256a:	00d5d59b          	srliw	a1,a1,0xd
    8000256e:	00015797          	auipc	a5,0x15
    80002572:	0067a783          	lw	a5,6(a5) # 80017574 <sb+0x1c>
    80002576:	9dbd                	addw	a1,a1,a5
    80002578:	00000097          	auipc	ra,0x0
    8000257c:	da0080e7          	jalr	-608(ra) # 80002318 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002580:	0074f713          	andi	a4,s1,7
    80002584:	4785                	li	a5,1
    80002586:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000258a:	14ce                	slli	s1,s1,0x33
    8000258c:	90d9                	srli	s1,s1,0x36
    8000258e:	00950733          	add	a4,a0,s1
    80002592:	05874703          	lbu	a4,88(a4)
    80002596:	00e7f6b3          	and	a3,a5,a4
    8000259a:	c69d                	beqz	a3,800025c8 <bfree+0x6c>
    8000259c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000259e:	94aa                	add	s1,s1,a0
    800025a0:	fff7c793          	not	a5,a5
    800025a4:	8f7d                	and	a4,a4,a5
    800025a6:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800025aa:	00001097          	auipc	ra,0x1
    800025ae:	112080e7          	jalr	274(ra) # 800036bc <log_write>
  brelse(bp);
    800025b2:	854a                	mv	a0,s2
    800025b4:	00000097          	auipc	ra,0x0
    800025b8:	e94080e7          	jalr	-364(ra) # 80002448 <brelse>
}
    800025bc:	60e2                	ld	ra,24(sp)
    800025be:	6442                	ld	s0,16(sp)
    800025c0:	64a2                	ld	s1,8(sp)
    800025c2:	6902                	ld	s2,0(sp)
    800025c4:	6105                	addi	sp,sp,32
    800025c6:	8082                	ret
    panic("freeing free block");
    800025c8:	00006517          	auipc	a0,0x6
    800025cc:	ea850513          	addi	a0,a0,-344 # 80008470 <etext+0x470>
    800025d0:	00003097          	auipc	ra,0x3
    800025d4:	6ac080e7          	jalr	1708(ra) # 80005c7c <panic>

00000000800025d8 <balloc>:
{
    800025d8:	711d                	addi	sp,sp,-96
    800025da:	ec86                	sd	ra,88(sp)
    800025dc:	e8a2                	sd	s0,80(sp)
    800025de:	e4a6                	sd	s1,72(sp)
    800025e0:	e0ca                	sd	s2,64(sp)
    800025e2:	fc4e                	sd	s3,56(sp)
    800025e4:	f852                	sd	s4,48(sp)
    800025e6:	f456                	sd	s5,40(sp)
    800025e8:	f05a                	sd	s6,32(sp)
    800025ea:	ec5e                	sd	s7,24(sp)
    800025ec:	e862                	sd	s8,16(sp)
    800025ee:	e466                	sd	s9,8(sp)
    800025f0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800025f2:	00015797          	auipc	a5,0x15
    800025f6:	f6a7a783          	lw	a5,-150(a5) # 8001755c <sb+0x4>
    800025fa:	cbc1                	beqz	a5,8000268a <balloc+0xb2>
    800025fc:	8baa                	mv	s7,a0
    800025fe:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002600:	00015b17          	auipc	s6,0x15
    80002604:	f58b0b13          	addi	s6,s6,-168 # 80017558 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002608:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000260a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000260c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000260e:	6c89                	lui	s9,0x2
    80002610:	a831                	j	8000262c <balloc+0x54>
    brelse(bp);
    80002612:	854a                	mv	a0,s2
    80002614:	00000097          	auipc	ra,0x0
    80002618:	e34080e7          	jalr	-460(ra) # 80002448 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000261c:	015c87bb          	addw	a5,s9,s5
    80002620:	00078a9b          	sext.w	s5,a5
    80002624:	004b2703          	lw	a4,4(s6)
    80002628:	06eaf163          	bgeu	s5,a4,8000268a <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000262c:	41fad79b          	sraiw	a5,s5,0x1f
    80002630:	0137d79b          	srliw	a5,a5,0x13
    80002634:	015787bb          	addw	a5,a5,s5
    80002638:	40d7d79b          	sraiw	a5,a5,0xd
    8000263c:	01cb2583          	lw	a1,28(s6)
    80002640:	9dbd                	addw	a1,a1,a5
    80002642:	855e                	mv	a0,s7
    80002644:	00000097          	auipc	ra,0x0
    80002648:	cd4080e7          	jalr	-812(ra) # 80002318 <bread>
    8000264c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000264e:	004b2503          	lw	a0,4(s6)
    80002652:	000a849b          	sext.w	s1,s5
    80002656:	8762                	mv	a4,s8
    80002658:	faa4fde3          	bgeu	s1,a0,80002612 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000265c:	00777693          	andi	a3,a4,7
    80002660:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002664:	41f7579b          	sraiw	a5,a4,0x1f
    80002668:	01d7d79b          	srliw	a5,a5,0x1d
    8000266c:	9fb9                	addw	a5,a5,a4
    8000266e:	4037d79b          	sraiw	a5,a5,0x3
    80002672:	00f90633          	add	a2,s2,a5
    80002676:	05864603          	lbu	a2,88(a2)
    8000267a:	00c6f5b3          	and	a1,a3,a2
    8000267e:	cd91                	beqz	a1,8000269a <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002680:	2705                	addiw	a4,a4,1
    80002682:	2485                	addiw	s1,s1,1
    80002684:	fd471ae3          	bne	a4,s4,80002658 <balloc+0x80>
    80002688:	b769                	j	80002612 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000268a:	00006517          	auipc	a0,0x6
    8000268e:	dfe50513          	addi	a0,a0,-514 # 80008488 <etext+0x488>
    80002692:	00003097          	auipc	ra,0x3
    80002696:	5ea080e7          	jalr	1514(ra) # 80005c7c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000269a:	97ca                	add	a5,a5,s2
    8000269c:	8e55                	or	a2,a2,a3
    8000269e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026a2:	854a                	mv	a0,s2
    800026a4:	00001097          	auipc	ra,0x1
    800026a8:	018080e7          	jalr	24(ra) # 800036bc <log_write>
        brelse(bp);
    800026ac:	854a                	mv	a0,s2
    800026ae:	00000097          	auipc	ra,0x0
    800026b2:	d9a080e7          	jalr	-614(ra) # 80002448 <brelse>
  bp = bread(dev, bno);
    800026b6:	85a6                	mv	a1,s1
    800026b8:	855e                	mv	a0,s7
    800026ba:	00000097          	auipc	ra,0x0
    800026be:	c5e080e7          	jalr	-930(ra) # 80002318 <bread>
    800026c2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026c4:	40000613          	li	a2,1024
    800026c8:	4581                	li	a1,0
    800026ca:	05850513          	addi	a0,a0,88
    800026ce:	ffffe097          	auipc	ra,0xffffe
    800026d2:	aac080e7          	jalr	-1364(ra) # 8000017a <memset>
  log_write(bp);
    800026d6:	854a                	mv	a0,s2
    800026d8:	00001097          	auipc	ra,0x1
    800026dc:	fe4080e7          	jalr	-28(ra) # 800036bc <log_write>
  brelse(bp);
    800026e0:	854a                	mv	a0,s2
    800026e2:	00000097          	auipc	ra,0x0
    800026e6:	d66080e7          	jalr	-666(ra) # 80002448 <brelse>
}
    800026ea:	8526                	mv	a0,s1
    800026ec:	60e6                	ld	ra,88(sp)
    800026ee:	6446                	ld	s0,80(sp)
    800026f0:	64a6                	ld	s1,72(sp)
    800026f2:	6906                	ld	s2,64(sp)
    800026f4:	79e2                	ld	s3,56(sp)
    800026f6:	7a42                	ld	s4,48(sp)
    800026f8:	7aa2                	ld	s5,40(sp)
    800026fa:	7b02                	ld	s6,32(sp)
    800026fc:	6be2                	ld	s7,24(sp)
    800026fe:	6c42                	ld	s8,16(sp)
    80002700:	6ca2                	ld	s9,8(sp)
    80002702:	6125                	addi	sp,sp,96
    80002704:	8082                	ret

0000000080002706 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002706:	7179                	addi	sp,sp,-48
    80002708:	f406                	sd	ra,40(sp)
    8000270a:	f022                	sd	s0,32(sp)
    8000270c:	ec26                	sd	s1,24(sp)
    8000270e:	e84a                	sd	s2,16(sp)
    80002710:	e44e                	sd	s3,8(sp)
    80002712:	1800                	addi	s0,sp,48
    80002714:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002716:	47ad                	li	a5,11
    80002718:	04b7ff63          	bgeu	a5,a1,80002776 <bmap+0x70>
    8000271c:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000271e:	ff45849b          	addiw	s1,a1,-12
    80002722:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002726:	0ff00793          	li	a5,255
    8000272a:	0ae7e463          	bltu	a5,a4,800027d2 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000272e:	08052583          	lw	a1,128(a0)
    80002732:	c5b5                	beqz	a1,8000279e <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002734:	00092503          	lw	a0,0(s2)
    80002738:	00000097          	auipc	ra,0x0
    8000273c:	be0080e7          	jalr	-1056(ra) # 80002318 <bread>
    80002740:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002742:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002746:	02049713          	slli	a4,s1,0x20
    8000274a:	01e75593          	srli	a1,a4,0x1e
    8000274e:	00b784b3          	add	s1,a5,a1
    80002752:	0004a983          	lw	s3,0(s1)
    80002756:	04098e63          	beqz	s3,800027b2 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000275a:	8552                	mv	a0,s4
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	cec080e7          	jalr	-788(ra) # 80002448 <brelse>
    return addr;
    80002764:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002766:	854e                	mv	a0,s3
    80002768:	70a2                	ld	ra,40(sp)
    8000276a:	7402                	ld	s0,32(sp)
    8000276c:	64e2                	ld	s1,24(sp)
    8000276e:	6942                	ld	s2,16(sp)
    80002770:	69a2                	ld	s3,8(sp)
    80002772:	6145                	addi	sp,sp,48
    80002774:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002776:	02059793          	slli	a5,a1,0x20
    8000277a:	01e7d593          	srli	a1,a5,0x1e
    8000277e:	00b504b3          	add	s1,a0,a1
    80002782:	0504a983          	lw	s3,80(s1)
    80002786:	fe0990e3          	bnez	s3,80002766 <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000278a:	4108                	lw	a0,0(a0)
    8000278c:	00000097          	auipc	ra,0x0
    80002790:	e4c080e7          	jalr	-436(ra) # 800025d8 <balloc>
    80002794:	0005099b          	sext.w	s3,a0
    80002798:	0534a823          	sw	s3,80(s1)
    8000279c:	b7e9                	j	80002766 <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000279e:	4108                	lw	a0,0(a0)
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	e38080e7          	jalr	-456(ra) # 800025d8 <balloc>
    800027a8:	0005059b          	sext.w	a1,a0
    800027ac:	08b92023          	sw	a1,128(s2)
    800027b0:	b751                	j	80002734 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800027b2:	00092503          	lw	a0,0(s2)
    800027b6:	00000097          	auipc	ra,0x0
    800027ba:	e22080e7          	jalr	-478(ra) # 800025d8 <balloc>
    800027be:	0005099b          	sext.w	s3,a0
    800027c2:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800027c6:	8552                	mv	a0,s4
    800027c8:	00001097          	auipc	ra,0x1
    800027cc:	ef4080e7          	jalr	-268(ra) # 800036bc <log_write>
    800027d0:	b769                	j	8000275a <bmap+0x54>
  panic("bmap: out of range");
    800027d2:	00006517          	auipc	a0,0x6
    800027d6:	cce50513          	addi	a0,a0,-818 # 800084a0 <etext+0x4a0>
    800027da:	00003097          	auipc	ra,0x3
    800027de:	4a2080e7          	jalr	1186(ra) # 80005c7c <panic>

00000000800027e2 <iget>:
{
    800027e2:	7179                	addi	sp,sp,-48
    800027e4:	f406                	sd	ra,40(sp)
    800027e6:	f022                	sd	s0,32(sp)
    800027e8:	ec26                	sd	s1,24(sp)
    800027ea:	e84a                	sd	s2,16(sp)
    800027ec:	e44e                	sd	s3,8(sp)
    800027ee:	e052                	sd	s4,0(sp)
    800027f0:	1800                	addi	s0,sp,48
    800027f2:	89aa                	mv	s3,a0
    800027f4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800027f6:	00015517          	auipc	a0,0x15
    800027fa:	d8250513          	addi	a0,a0,-638 # 80017578 <itable>
    800027fe:	00004097          	auipc	ra,0x4
    80002802:	9f8080e7          	jalr	-1544(ra) # 800061f6 <acquire>
  empty = 0;
    80002806:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002808:	00015497          	auipc	s1,0x15
    8000280c:	d8848493          	addi	s1,s1,-632 # 80017590 <itable+0x18>
    80002810:	00017697          	auipc	a3,0x17
    80002814:	81068693          	addi	a3,a3,-2032 # 80019020 <log>
    80002818:	a039                	j	80002826 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000281a:	02090b63          	beqz	s2,80002850 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000281e:	08848493          	addi	s1,s1,136
    80002822:	02d48a63          	beq	s1,a3,80002856 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002826:	449c                	lw	a5,8(s1)
    80002828:	fef059e3          	blez	a5,8000281a <iget+0x38>
    8000282c:	4098                	lw	a4,0(s1)
    8000282e:	ff3716e3          	bne	a4,s3,8000281a <iget+0x38>
    80002832:	40d8                	lw	a4,4(s1)
    80002834:	ff4713e3          	bne	a4,s4,8000281a <iget+0x38>
      ip->ref++;
    80002838:	2785                	addiw	a5,a5,1
    8000283a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000283c:	00015517          	auipc	a0,0x15
    80002840:	d3c50513          	addi	a0,a0,-708 # 80017578 <itable>
    80002844:	00004097          	auipc	ra,0x4
    80002848:	a66080e7          	jalr	-1434(ra) # 800062aa <release>
      return ip;
    8000284c:	8926                	mv	s2,s1
    8000284e:	a03d                	j	8000287c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002850:	f7f9                	bnez	a5,8000281e <iget+0x3c>
      empty = ip;
    80002852:	8926                	mv	s2,s1
    80002854:	b7e9                	j	8000281e <iget+0x3c>
  if(empty == 0)
    80002856:	02090c63          	beqz	s2,8000288e <iget+0xac>
  ip->dev = dev;
    8000285a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000285e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002862:	4785                	li	a5,1
    80002864:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002868:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000286c:	00015517          	auipc	a0,0x15
    80002870:	d0c50513          	addi	a0,a0,-756 # 80017578 <itable>
    80002874:	00004097          	auipc	ra,0x4
    80002878:	a36080e7          	jalr	-1482(ra) # 800062aa <release>
}
    8000287c:	854a                	mv	a0,s2
    8000287e:	70a2                	ld	ra,40(sp)
    80002880:	7402                	ld	s0,32(sp)
    80002882:	64e2                	ld	s1,24(sp)
    80002884:	6942                	ld	s2,16(sp)
    80002886:	69a2                	ld	s3,8(sp)
    80002888:	6a02                	ld	s4,0(sp)
    8000288a:	6145                	addi	sp,sp,48
    8000288c:	8082                	ret
    panic("iget: no inodes");
    8000288e:	00006517          	auipc	a0,0x6
    80002892:	c2a50513          	addi	a0,a0,-982 # 800084b8 <etext+0x4b8>
    80002896:	00003097          	auipc	ra,0x3
    8000289a:	3e6080e7          	jalr	998(ra) # 80005c7c <panic>

000000008000289e <fsinit>:
fsinit(int dev) {
    8000289e:	7179                	addi	sp,sp,-48
    800028a0:	f406                	sd	ra,40(sp)
    800028a2:	f022                	sd	s0,32(sp)
    800028a4:	ec26                	sd	s1,24(sp)
    800028a6:	e84a                	sd	s2,16(sp)
    800028a8:	e44e                	sd	s3,8(sp)
    800028aa:	1800                	addi	s0,sp,48
    800028ac:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800028ae:	4585                	li	a1,1
    800028b0:	00000097          	auipc	ra,0x0
    800028b4:	a68080e7          	jalr	-1432(ra) # 80002318 <bread>
    800028b8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800028ba:	00015997          	auipc	s3,0x15
    800028be:	c9e98993          	addi	s3,s3,-866 # 80017558 <sb>
    800028c2:	02000613          	li	a2,32
    800028c6:	05850593          	addi	a1,a0,88
    800028ca:	854e                	mv	a0,s3
    800028cc:	ffffe097          	auipc	ra,0xffffe
    800028d0:	90a080e7          	jalr	-1782(ra) # 800001d6 <memmove>
  brelse(bp);
    800028d4:	8526                	mv	a0,s1
    800028d6:	00000097          	auipc	ra,0x0
    800028da:	b72080e7          	jalr	-1166(ra) # 80002448 <brelse>
  if(sb.magic != FSMAGIC)
    800028de:	0009a703          	lw	a4,0(s3)
    800028e2:	102037b7          	lui	a5,0x10203
    800028e6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800028ea:	02f71263          	bne	a4,a5,8000290e <fsinit+0x70>
  initlog(dev, &sb);
    800028ee:	00015597          	auipc	a1,0x15
    800028f2:	c6a58593          	addi	a1,a1,-918 # 80017558 <sb>
    800028f6:	854a                	mv	a0,s2
    800028f8:	00001097          	auipc	ra,0x1
    800028fc:	b54080e7          	jalr	-1196(ra) # 8000344c <initlog>
}
    80002900:	70a2                	ld	ra,40(sp)
    80002902:	7402                	ld	s0,32(sp)
    80002904:	64e2                	ld	s1,24(sp)
    80002906:	6942                	ld	s2,16(sp)
    80002908:	69a2                	ld	s3,8(sp)
    8000290a:	6145                	addi	sp,sp,48
    8000290c:	8082                	ret
    panic("invalid file system");
    8000290e:	00006517          	auipc	a0,0x6
    80002912:	bba50513          	addi	a0,a0,-1094 # 800084c8 <etext+0x4c8>
    80002916:	00003097          	auipc	ra,0x3
    8000291a:	366080e7          	jalr	870(ra) # 80005c7c <panic>

000000008000291e <iinit>:
{
    8000291e:	7179                	addi	sp,sp,-48
    80002920:	f406                	sd	ra,40(sp)
    80002922:	f022                	sd	s0,32(sp)
    80002924:	ec26                	sd	s1,24(sp)
    80002926:	e84a                	sd	s2,16(sp)
    80002928:	e44e                	sd	s3,8(sp)
    8000292a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000292c:	00006597          	auipc	a1,0x6
    80002930:	bb458593          	addi	a1,a1,-1100 # 800084e0 <etext+0x4e0>
    80002934:	00015517          	auipc	a0,0x15
    80002938:	c4450513          	addi	a0,a0,-956 # 80017578 <itable>
    8000293c:	00004097          	auipc	ra,0x4
    80002940:	82a080e7          	jalr	-2006(ra) # 80006166 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002944:	00015497          	auipc	s1,0x15
    80002948:	c5c48493          	addi	s1,s1,-932 # 800175a0 <itable+0x28>
    8000294c:	00016997          	auipc	s3,0x16
    80002950:	6e498993          	addi	s3,s3,1764 # 80019030 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002954:	00006917          	auipc	s2,0x6
    80002958:	b9490913          	addi	s2,s2,-1132 # 800084e8 <etext+0x4e8>
    8000295c:	85ca                	mv	a1,s2
    8000295e:	8526                	mv	a0,s1
    80002960:	00001097          	auipc	ra,0x1
    80002964:	e40080e7          	jalr	-448(ra) # 800037a0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002968:	08848493          	addi	s1,s1,136
    8000296c:	ff3498e3          	bne	s1,s3,8000295c <iinit+0x3e>
}
    80002970:	70a2                	ld	ra,40(sp)
    80002972:	7402                	ld	s0,32(sp)
    80002974:	64e2                	ld	s1,24(sp)
    80002976:	6942                	ld	s2,16(sp)
    80002978:	69a2                	ld	s3,8(sp)
    8000297a:	6145                	addi	sp,sp,48
    8000297c:	8082                	ret

000000008000297e <ialloc>:
{
    8000297e:	7139                	addi	sp,sp,-64
    80002980:	fc06                	sd	ra,56(sp)
    80002982:	f822                	sd	s0,48(sp)
    80002984:	f426                	sd	s1,40(sp)
    80002986:	f04a                	sd	s2,32(sp)
    80002988:	ec4e                	sd	s3,24(sp)
    8000298a:	e852                	sd	s4,16(sp)
    8000298c:	e456                	sd	s5,8(sp)
    8000298e:	e05a                	sd	s6,0(sp)
    80002990:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002992:	00015717          	auipc	a4,0x15
    80002996:	bd272703          	lw	a4,-1070(a4) # 80017564 <sb+0xc>
    8000299a:	4785                	li	a5,1
    8000299c:	04e7f863          	bgeu	a5,a4,800029ec <ialloc+0x6e>
    800029a0:	8aaa                	mv	s5,a0
    800029a2:	8b2e                	mv	s6,a1
    800029a4:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800029a6:	00015a17          	auipc	s4,0x15
    800029aa:	bb2a0a13          	addi	s4,s4,-1102 # 80017558 <sb>
    800029ae:	00495593          	srli	a1,s2,0x4
    800029b2:	018a2783          	lw	a5,24(s4)
    800029b6:	9dbd                	addw	a1,a1,a5
    800029b8:	8556                	mv	a0,s5
    800029ba:	00000097          	auipc	ra,0x0
    800029be:	95e080e7          	jalr	-1698(ra) # 80002318 <bread>
    800029c2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800029c4:	05850993          	addi	s3,a0,88
    800029c8:	00f97793          	andi	a5,s2,15
    800029cc:	079a                	slli	a5,a5,0x6
    800029ce:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800029d0:	00099783          	lh	a5,0(s3)
    800029d4:	c785                	beqz	a5,800029fc <ialloc+0x7e>
    brelse(bp);
    800029d6:	00000097          	auipc	ra,0x0
    800029da:	a72080e7          	jalr	-1422(ra) # 80002448 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800029de:	0905                	addi	s2,s2,1
    800029e0:	00ca2703          	lw	a4,12(s4)
    800029e4:	0009079b          	sext.w	a5,s2
    800029e8:	fce7e3e3          	bltu	a5,a4,800029ae <ialloc+0x30>
  panic("ialloc: no inodes");
    800029ec:	00006517          	auipc	a0,0x6
    800029f0:	b0450513          	addi	a0,a0,-1276 # 800084f0 <etext+0x4f0>
    800029f4:	00003097          	auipc	ra,0x3
    800029f8:	288080e7          	jalr	648(ra) # 80005c7c <panic>
      memset(dip, 0, sizeof(*dip));
    800029fc:	04000613          	li	a2,64
    80002a00:	4581                	li	a1,0
    80002a02:	854e                	mv	a0,s3
    80002a04:	ffffd097          	auipc	ra,0xffffd
    80002a08:	776080e7          	jalr	1910(ra) # 8000017a <memset>
      dip->type = type;
    80002a0c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002a10:	8526                	mv	a0,s1
    80002a12:	00001097          	auipc	ra,0x1
    80002a16:	caa080e7          	jalr	-854(ra) # 800036bc <log_write>
      brelse(bp);
    80002a1a:	8526                	mv	a0,s1
    80002a1c:	00000097          	auipc	ra,0x0
    80002a20:	a2c080e7          	jalr	-1492(ra) # 80002448 <brelse>
      return iget(dev, inum);
    80002a24:	0009059b          	sext.w	a1,s2
    80002a28:	8556                	mv	a0,s5
    80002a2a:	00000097          	auipc	ra,0x0
    80002a2e:	db8080e7          	jalr	-584(ra) # 800027e2 <iget>
}
    80002a32:	70e2                	ld	ra,56(sp)
    80002a34:	7442                	ld	s0,48(sp)
    80002a36:	74a2                	ld	s1,40(sp)
    80002a38:	7902                	ld	s2,32(sp)
    80002a3a:	69e2                	ld	s3,24(sp)
    80002a3c:	6a42                	ld	s4,16(sp)
    80002a3e:	6aa2                	ld	s5,8(sp)
    80002a40:	6b02                	ld	s6,0(sp)
    80002a42:	6121                	addi	sp,sp,64
    80002a44:	8082                	ret

0000000080002a46 <iupdate>:
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	e04a                	sd	s2,0(sp)
    80002a50:	1000                	addi	s0,sp,32
    80002a52:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002a54:	415c                	lw	a5,4(a0)
    80002a56:	0047d79b          	srliw	a5,a5,0x4
    80002a5a:	00015597          	auipc	a1,0x15
    80002a5e:	b165a583          	lw	a1,-1258(a1) # 80017570 <sb+0x18>
    80002a62:	9dbd                	addw	a1,a1,a5
    80002a64:	4108                	lw	a0,0(a0)
    80002a66:	00000097          	auipc	ra,0x0
    80002a6a:	8b2080e7          	jalr	-1870(ra) # 80002318 <bread>
    80002a6e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002a70:	05850793          	addi	a5,a0,88
    80002a74:	40d8                	lw	a4,4(s1)
    80002a76:	8b3d                	andi	a4,a4,15
    80002a78:	071a                	slli	a4,a4,0x6
    80002a7a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002a7c:	04449703          	lh	a4,68(s1)
    80002a80:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002a84:	04649703          	lh	a4,70(s1)
    80002a88:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002a8c:	04849703          	lh	a4,72(s1)
    80002a90:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002a94:	04a49703          	lh	a4,74(s1)
    80002a98:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002a9c:	44f8                	lw	a4,76(s1)
    80002a9e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002aa0:	03400613          	li	a2,52
    80002aa4:	05048593          	addi	a1,s1,80
    80002aa8:	00c78513          	addi	a0,a5,12
    80002aac:	ffffd097          	auipc	ra,0xffffd
    80002ab0:	72a080e7          	jalr	1834(ra) # 800001d6 <memmove>
  log_write(bp);
    80002ab4:	854a                	mv	a0,s2
    80002ab6:	00001097          	auipc	ra,0x1
    80002aba:	c06080e7          	jalr	-1018(ra) # 800036bc <log_write>
  brelse(bp);
    80002abe:	854a                	mv	a0,s2
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	988080e7          	jalr	-1656(ra) # 80002448 <brelse>
}
    80002ac8:	60e2                	ld	ra,24(sp)
    80002aca:	6442                	ld	s0,16(sp)
    80002acc:	64a2                	ld	s1,8(sp)
    80002ace:	6902                	ld	s2,0(sp)
    80002ad0:	6105                	addi	sp,sp,32
    80002ad2:	8082                	ret

0000000080002ad4 <idup>:
{
    80002ad4:	1101                	addi	sp,sp,-32
    80002ad6:	ec06                	sd	ra,24(sp)
    80002ad8:	e822                	sd	s0,16(sp)
    80002ada:	e426                	sd	s1,8(sp)
    80002adc:	1000                	addi	s0,sp,32
    80002ade:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ae0:	00015517          	auipc	a0,0x15
    80002ae4:	a9850513          	addi	a0,a0,-1384 # 80017578 <itable>
    80002ae8:	00003097          	auipc	ra,0x3
    80002aec:	70e080e7          	jalr	1806(ra) # 800061f6 <acquire>
  ip->ref++;
    80002af0:	449c                	lw	a5,8(s1)
    80002af2:	2785                	addiw	a5,a5,1
    80002af4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002af6:	00015517          	auipc	a0,0x15
    80002afa:	a8250513          	addi	a0,a0,-1406 # 80017578 <itable>
    80002afe:	00003097          	auipc	ra,0x3
    80002b02:	7ac080e7          	jalr	1964(ra) # 800062aa <release>
}
    80002b06:	8526                	mv	a0,s1
    80002b08:	60e2                	ld	ra,24(sp)
    80002b0a:	6442                	ld	s0,16(sp)
    80002b0c:	64a2                	ld	s1,8(sp)
    80002b0e:	6105                	addi	sp,sp,32
    80002b10:	8082                	ret

0000000080002b12 <ilock>:
{
    80002b12:	1101                	addi	sp,sp,-32
    80002b14:	ec06                	sd	ra,24(sp)
    80002b16:	e822                	sd	s0,16(sp)
    80002b18:	e426                	sd	s1,8(sp)
    80002b1a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002b1c:	c10d                	beqz	a0,80002b3e <ilock+0x2c>
    80002b1e:	84aa                	mv	s1,a0
    80002b20:	451c                	lw	a5,8(a0)
    80002b22:	00f05e63          	blez	a5,80002b3e <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002b26:	0541                	addi	a0,a0,16
    80002b28:	00001097          	auipc	ra,0x1
    80002b2c:	cb2080e7          	jalr	-846(ra) # 800037da <acquiresleep>
  if(ip->valid == 0){
    80002b30:	40bc                	lw	a5,64(s1)
    80002b32:	cf99                	beqz	a5,80002b50 <ilock+0x3e>
}
    80002b34:	60e2                	ld	ra,24(sp)
    80002b36:	6442                	ld	s0,16(sp)
    80002b38:	64a2                	ld	s1,8(sp)
    80002b3a:	6105                	addi	sp,sp,32
    80002b3c:	8082                	ret
    80002b3e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002b40:	00006517          	auipc	a0,0x6
    80002b44:	9c850513          	addi	a0,a0,-1592 # 80008508 <etext+0x508>
    80002b48:	00003097          	auipc	ra,0x3
    80002b4c:	134080e7          	jalr	308(ra) # 80005c7c <panic>
    80002b50:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b52:	40dc                	lw	a5,4(s1)
    80002b54:	0047d79b          	srliw	a5,a5,0x4
    80002b58:	00015597          	auipc	a1,0x15
    80002b5c:	a185a583          	lw	a1,-1512(a1) # 80017570 <sb+0x18>
    80002b60:	9dbd                	addw	a1,a1,a5
    80002b62:	4088                	lw	a0,0(s1)
    80002b64:	fffff097          	auipc	ra,0xfffff
    80002b68:	7b4080e7          	jalr	1972(ra) # 80002318 <bread>
    80002b6c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b6e:	05850593          	addi	a1,a0,88
    80002b72:	40dc                	lw	a5,4(s1)
    80002b74:	8bbd                	andi	a5,a5,15
    80002b76:	079a                	slli	a5,a5,0x6
    80002b78:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002b7a:	00059783          	lh	a5,0(a1)
    80002b7e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002b82:	00259783          	lh	a5,2(a1)
    80002b86:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002b8a:	00459783          	lh	a5,4(a1)
    80002b8e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002b92:	00659783          	lh	a5,6(a1)
    80002b96:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002b9a:	459c                	lw	a5,8(a1)
    80002b9c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002b9e:	03400613          	li	a2,52
    80002ba2:	05b1                	addi	a1,a1,12
    80002ba4:	05048513          	addi	a0,s1,80
    80002ba8:	ffffd097          	auipc	ra,0xffffd
    80002bac:	62e080e7          	jalr	1582(ra) # 800001d6 <memmove>
    brelse(bp);
    80002bb0:	854a                	mv	a0,s2
    80002bb2:	00000097          	auipc	ra,0x0
    80002bb6:	896080e7          	jalr	-1898(ra) # 80002448 <brelse>
    ip->valid = 1;
    80002bba:	4785                	li	a5,1
    80002bbc:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002bbe:	04449783          	lh	a5,68(s1)
    80002bc2:	c399                	beqz	a5,80002bc8 <ilock+0xb6>
    80002bc4:	6902                	ld	s2,0(sp)
    80002bc6:	b7bd                	j	80002b34 <ilock+0x22>
      panic("ilock: no type");
    80002bc8:	00006517          	auipc	a0,0x6
    80002bcc:	94850513          	addi	a0,a0,-1720 # 80008510 <etext+0x510>
    80002bd0:	00003097          	auipc	ra,0x3
    80002bd4:	0ac080e7          	jalr	172(ra) # 80005c7c <panic>

0000000080002bd8 <iunlock>:
{
    80002bd8:	1101                	addi	sp,sp,-32
    80002bda:	ec06                	sd	ra,24(sp)
    80002bdc:	e822                	sd	s0,16(sp)
    80002bde:	e426                	sd	s1,8(sp)
    80002be0:	e04a                	sd	s2,0(sp)
    80002be2:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002be4:	c905                	beqz	a0,80002c14 <iunlock+0x3c>
    80002be6:	84aa                	mv	s1,a0
    80002be8:	01050913          	addi	s2,a0,16
    80002bec:	854a                	mv	a0,s2
    80002bee:	00001097          	auipc	ra,0x1
    80002bf2:	c86080e7          	jalr	-890(ra) # 80003874 <holdingsleep>
    80002bf6:	cd19                	beqz	a0,80002c14 <iunlock+0x3c>
    80002bf8:	449c                	lw	a5,8(s1)
    80002bfa:	00f05d63          	blez	a5,80002c14 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002bfe:	854a                	mv	a0,s2
    80002c00:	00001097          	auipc	ra,0x1
    80002c04:	c30080e7          	jalr	-976(ra) # 80003830 <releasesleep>
}
    80002c08:	60e2                	ld	ra,24(sp)
    80002c0a:	6442                	ld	s0,16(sp)
    80002c0c:	64a2                	ld	s1,8(sp)
    80002c0e:	6902                	ld	s2,0(sp)
    80002c10:	6105                	addi	sp,sp,32
    80002c12:	8082                	ret
    panic("iunlock");
    80002c14:	00006517          	auipc	a0,0x6
    80002c18:	90c50513          	addi	a0,a0,-1780 # 80008520 <etext+0x520>
    80002c1c:	00003097          	auipc	ra,0x3
    80002c20:	060080e7          	jalr	96(ra) # 80005c7c <panic>

0000000080002c24 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002c24:	7179                	addi	sp,sp,-48
    80002c26:	f406                	sd	ra,40(sp)
    80002c28:	f022                	sd	s0,32(sp)
    80002c2a:	ec26                	sd	s1,24(sp)
    80002c2c:	e84a                	sd	s2,16(sp)
    80002c2e:	e44e                	sd	s3,8(sp)
    80002c30:	1800                	addi	s0,sp,48
    80002c32:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002c34:	05050493          	addi	s1,a0,80
    80002c38:	08050913          	addi	s2,a0,128
    80002c3c:	a021                	j	80002c44 <itrunc+0x20>
    80002c3e:	0491                	addi	s1,s1,4
    80002c40:	01248d63          	beq	s1,s2,80002c5a <itrunc+0x36>
    if(ip->addrs[i]){
    80002c44:	408c                	lw	a1,0(s1)
    80002c46:	dde5                	beqz	a1,80002c3e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002c48:	0009a503          	lw	a0,0(s3)
    80002c4c:	00000097          	auipc	ra,0x0
    80002c50:	910080e7          	jalr	-1776(ra) # 8000255c <bfree>
      ip->addrs[i] = 0;
    80002c54:	0004a023          	sw	zero,0(s1)
    80002c58:	b7dd                	j	80002c3e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002c5a:	0809a583          	lw	a1,128(s3)
    80002c5e:	ed99                	bnez	a1,80002c7c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002c60:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002c64:	854e                	mv	a0,s3
    80002c66:	00000097          	auipc	ra,0x0
    80002c6a:	de0080e7          	jalr	-544(ra) # 80002a46 <iupdate>
}
    80002c6e:	70a2                	ld	ra,40(sp)
    80002c70:	7402                	ld	s0,32(sp)
    80002c72:	64e2                	ld	s1,24(sp)
    80002c74:	6942                	ld	s2,16(sp)
    80002c76:	69a2                	ld	s3,8(sp)
    80002c78:	6145                	addi	sp,sp,48
    80002c7a:	8082                	ret
    80002c7c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002c7e:	0009a503          	lw	a0,0(s3)
    80002c82:	fffff097          	auipc	ra,0xfffff
    80002c86:	696080e7          	jalr	1686(ra) # 80002318 <bread>
    80002c8a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002c8c:	05850493          	addi	s1,a0,88
    80002c90:	45850913          	addi	s2,a0,1112
    80002c94:	a021                	j	80002c9c <itrunc+0x78>
    80002c96:	0491                	addi	s1,s1,4
    80002c98:	01248b63          	beq	s1,s2,80002cae <itrunc+0x8a>
      if(a[j])
    80002c9c:	408c                	lw	a1,0(s1)
    80002c9e:	dde5                	beqz	a1,80002c96 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002ca0:	0009a503          	lw	a0,0(s3)
    80002ca4:	00000097          	auipc	ra,0x0
    80002ca8:	8b8080e7          	jalr	-1864(ra) # 8000255c <bfree>
    80002cac:	b7ed                	j	80002c96 <itrunc+0x72>
    brelse(bp);
    80002cae:	8552                	mv	a0,s4
    80002cb0:	fffff097          	auipc	ra,0xfffff
    80002cb4:	798080e7          	jalr	1944(ra) # 80002448 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002cb8:	0809a583          	lw	a1,128(s3)
    80002cbc:	0009a503          	lw	a0,0(s3)
    80002cc0:	00000097          	auipc	ra,0x0
    80002cc4:	89c080e7          	jalr	-1892(ra) # 8000255c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002cc8:	0809a023          	sw	zero,128(s3)
    80002ccc:	6a02                	ld	s4,0(sp)
    80002cce:	bf49                	j	80002c60 <itrunc+0x3c>

0000000080002cd0 <iput>:
{
    80002cd0:	1101                	addi	sp,sp,-32
    80002cd2:	ec06                	sd	ra,24(sp)
    80002cd4:	e822                	sd	s0,16(sp)
    80002cd6:	e426                	sd	s1,8(sp)
    80002cd8:	1000                	addi	s0,sp,32
    80002cda:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002cdc:	00015517          	auipc	a0,0x15
    80002ce0:	89c50513          	addi	a0,a0,-1892 # 80017578 <itable>
    80002ce4:	00003097          	auipc	ra,0x3
    80002ce8:	512080e7          	jalr	1298(ra) # 800061f6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002cec:	4498                	lw	a4,8(s1)
    80002cee:	4785                	li	a5,1
    80002cf0:	02f70263          	beq	a4,a5,80002d14 <iput+0x44>
  ip->ref--;
    80002cf4:	449c                	lw	a5,8(s1)
    80002cf6:	37fd                	addiw	a5,a5,-1
    80002cf8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cfa:	00015517          	auipc	a0,0x15
    80002cfe:	87e50513          	addi	a0,a0,-1922 # 80017578 <itable>
    80002d02:	00003097          	auipc	ra,0x3
    80002d06:	5a8080e7          	jalr	1448(ra) # 800062aa <release>
}
    80002d0a:	60e2                	ld	ra,24(sp)
    80002d0c:	6442                	ld	s0,16(sp)
    80002d0e:	64a2                	ld	s1,8(sp)
    80002d10:	6105                	addi	sp,sp,32
    80002d12:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d14:	40bc                	lw	a5,64(s1)
    80002d16:	dff9                	beqz	a5,80002cf4 <iput+0x24>
    80002d18:	04a49783          	lh	a5,74(s1)
    80002d1c:	ffe1                	bnez	a5,80002cf4 <iput+0x24>
    80002d1e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002d20:	01048913          	addi	s2,s1,16
    80002d24:	854a                	mv	a0,s2
    80002d26:	00001097          	auipc	ra,0x1
    80002d2a:	ab4080e7          	jalr	-1356(ra) # 800037da <acquiresleep>
    release(&itable.lock);
    80002d2e:	00015517          	auipc	a0,0x15
    80002d32:	84a50513          	addi	a0,a0,-1974 # 80017578 <itable>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	574080e7          	jalr	1396(ra) # 800062aa <release>
    itrunc(ip);
    80002d3e:	8526                	mv	a0,s1
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	ee4080e7          	jalr	-284(ra) # 80002c24 <itrunc>
    ip->type = 0;
    80002d48:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002d4c:	8526                	mv	a0,s1
    80002d4e:	00000097          	auipc	ra,0x0
    80002d52:	cf8080e7          	jalr	-776(ra) # 80002a46 <iupdate>
    ip->valid = 0;
    80002d56:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002d5a:	854a                	mv	a0,s2
    80002d5c:	00001097          	auipc	ra,0x1
    80002d60:	ad4080e7          	jalr	-1324(ra) # 80003830 <releasesleep>
    acquire(&itable.lock);
    80002d64:	00015517          	auipc	a0,0x15
    80002d68:	81450513          	addi	a0,a0,-2028 # 80017578 <itable>
    80002d6c:	00003097          	auipc	ra,0x3
    80002d70:	48a080e7          	jalr	1162(ra) # 800061f6 <acquire>
    80002d74:	6902                	ld	s2,0(sp)
    80002d76:	bfbd                	j	80002cf4 <iput+0x24>

0000000080002d78 <iunlockput>:
{
    80002d78:	1101                	addi	sp,sp,-32
    80002d7a:	ec06                	sd	ra,24(sp)
    80002d7c:	e822                	sd	s0,16(sp)
    80002d7e:	e426                	sd	s1,8(sp)
    80002d80:	1000                	addi	s0,sp,32
    80002d82:	84aa                	mv	s1,a0
  iunlock(ip);
    80002d84:	00000097          	auipc	ra,0x0
    80002d88:	e54080e7          	jalr	-428(ra) # 80002bd8 <iunlock>
  iput(ip);
    80002d8c:	8526                	mv	a0,s1
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	f42080e7          	jalr	-190(ra) # 80002cd0 <iput>
}
    80002d96:	60e2                	ld	ra,24(sp)
    80002d98:	6442                	ld	s0,16(sp)
    80002d9a:	64a2                	ld	s1,8(sp)
    80002d9c:	6105                	addi	sp,sp,32
    80002d9e:	8082                	ret

0000000080002da0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002da0:	1141                	addi	sp,sp,-16
    80002da2:	e422                	sd	s0,8(sp)
    80002da4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002da6:	411c                	lw	a5,0(a0)
    80002da8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002daa:	415c                	lw	a5,4(a0)
    80002dac:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002dae:	04451783          	lh	a5,68(a0)
    80002db2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002db6:	04a51783          	lh	a5,74(a0)
    80002dba:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002dbe:	04c56783          	lwu	a5,76(a0)
    80002dc2:	e99c                	sd	a5,16(a1)
}
    80002dc4:	6422                	ld	s0,8(sp)
    80002dc6:	0141                	addi	sp,sp,16
    80002dc8:	8082                	ret

0000000080002dca <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002dca:	457c                	lw	a5,76(a0)
    80002dcc:	0ed7ef63          	bltu	a5,a3,80002eca <readi+0x100>
{
    80002dd0:	7159                	addi	sp,sp,-112
    80002dd2:	f486                	sd	ra,104(sp)
    80002dd4:	f0a2                	sd	s0,96(sp)
    80002dd6:	eca6                	sd	s1,88(sp)
    80002dd8:	fc56                	sd	s5,56(sp)
    80002dda:	f85a                	sd	s6,48(sp)
    80002ddc:	f45e                	sd	s7,40(sp)
    80002dde:	f062                	sd	s8,32(sp)
    80002de0:	1880                	addi	s0,sp,112
    80002de2:	8baa                	mv	s7,a0
    80002de4:	8c2e                	mv	s8,a1
    80002de6:	8ab2                	mv	s5,a2
    80002de8:	84b6                	mv	s1,a3
    80002dea:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002dec:	9f35                	addw	a4,a4,a3
    return 0;
    80002dee:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002df0:	0ad76c63          	bltu	a4,a3,80002ea8 <readi+0xde>
    80002df4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002df6:	00e7f463          	bgeu	a5,a4,80002dfe <readi+0x34>
    n = ip->size - off;
    80002dfa:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002dfe:	0c0b0463          	beqz	s6,80002ec6 <readi+0xfc>
    80002e02:	e8ca                	sd	s2,80(sp)
    80002e04:	e0d2                	sd	s4,64(sp)
    80002e06:	ec66                	sd	s9,24(sp)
    80002e08:	e86a                	sd	s10,16(sp)
    80002e0a:	e46e                	sd	s11,8(sp)
    80002e0c:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e0e:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002e12:	5cfd                	li	s9,-1
    80002e14:	a82d                	j	80002e4e <readi+0x84>
    80002e16:	020a1d93          	slli	s11,s4,0x20
    80002e1a:	020ddd93          	srli	s11,s11,0x20
    80002e1e:	05890613          	addi	a2,s2,88
    80002e22:	86ee                	mv	a3,s11
    80002e24:	963a                	add	a2,a2,a4
    80002e26:	85d6                	mv	a1,s5
    80002e28:	8562                	mv	a0,s8
    80002e2a:	fffff097          	auipc	ra,0xfffff
    80002e2e:	ac4080e7          	jalr	-1340(ra) # 800018ee <either_copyout>
    80002e32:	05950d63          	beq	a0,s9,80002e8c <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002e36:	854a                	mv	a0,s2
    80002e38:	fffff097          	auipc	ra,0xfffff
    80002e3c:	610080e7          	jalr	1552(ra) # 80002448 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002e40:	013a09bb          	addw	s3,s4,s3
    80002e44:	009a04bb          	addw	s1,s4,s1
    80002e48:	9aee                	add	s5,s5,s11
    80002e4a:	0769f863          	bgeu	s3,s6,80002eba <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002e4e:	000ba903          	lw	s2,0(s7)
    80002e52:	00a4d59b          	srliw	a1,s1,0xa
    80002e56:	855e                	mv	a0,s7
    80002e58:	00000097          	auipc	ra,0x0
    80002e5c:	8ae080e7          	jalr	-1874(ra) # 80002706 <bmap>
    80002e60:	0005059b          	sext.w	a1,a0
    80002e64:	854a                	mv	a0,s2
    80002e66:	fffff097          	auipc	ra,0xfffff
    80002e6a:	4b2080e7          	jalr	1202(ra) # 80002318 <bread>
    80002e6e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e70:	3ff4f713          	andi	a4,s1,1023
    80002e74:	40ed07bb          	subw	a5,s10,a4
    80002e78:	413b06bb          	subw	a3,s6,s3
    80002e7c:	8a3e                	mv	s4,a5
    80002e7e:	2781                	sext.w	a5,a5
    80002e80:	0006861b          	sext.w	a2,a3
    80002e84:	f8f679e3          	bgeu	a2,a5,80002e16 <readi+0x4c>
    80002e88:	8a36                	mv	s4,a3
    80002e8a:	b771                	j	80002e16 <readi+0x4c>
      brelse(bp);
    80002e8c:	854a                	mv	a0,s2
    80002e8e:	fffff097          	auipc	ra,0xfffff
    80002e92:	5ba080e7          	jalr	1466(ra) # 80002448 <brelse>
      tot = -1;
    80002e96:	59fd                	li	s3,-1
      break;
    80002e98:	6946                	ld	s2,80(sp)
    80002e9a:	6a06                	ld	s4,64(sp)
    80002e9c:	6ce2                	ld	s9,24(sp)
    80002e9e:	6d42                	ld	s10,16(sp)
    80002ea0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002ea2:	0009851b          	sext.w	a0,s3
    80002ea6:	69a6                	ld	s3,72(sp)
}
    80002ea8:	70a6                	ld	ra,104(sp)
    80002eaa:	7406                	ld	s0,96(sp)
    80002eac:	64e6                	ld	s1,88(sp)
    80002eae:	7ae2                	ld	s5,56(sp)
    80002eb0:	7b42                	ld	s6,48(sp)
    80002eb2:	7ba2                	ld	s7,40(sp)
    80002eb4:	7c02                	ld	s8,32(sp)
    80002eb6:	6165                	addi	sp,sp,112
    80002eb8:	8082                	ret
    80002eba:	6946                	ld	s2,80(sp)
    80002ebc:	6a06                	ld	s4,64(sp)
    80002ebe:	6ce2                	ld	s9,24(sp)
    80002ec0:	6d42                	ld	s10,16(sp)
    80002ec2:	6da2                	ld	s11,8(sp)
    80002ec4:	bff9                	j	80002ea2 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ec6:	89da                	mv	s3,s6
    80002ec8:	bfe9                	j	80002ea2 <readi+0xd8>
    return 0;
    80002eca:	4501                	li	a0,0
}
    80002ecc:	8082                	ret

0000000080002ece <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ece:	457c                	lw	a5,76(a0)
    80002ed0:	10d7ee63          	bltu	a5,a3,80002fec <writei+0x11e>
{
    80002ed4:	7159                	addi	sp,sp,-112
    80002ed6:	f486                	sd	ra,104(sp)
    80002ed8:	f0a2                	sd	s0,96(sp)
    80002eda:	e8ca                	sd	s2,80(sp)
    80002edc:	fc56                	sd	s5,56(sp)
    80002ede:	f85a                	sd	s6,48(sp)
    80002ee0:	f45e                	sd	s7,40(sp)
    80002ee2:	f062                	sd	s8,32(sp)
    80002ee4:	1880                	addi	s0,sp,112
    80002ee6:	8b2a                	mv	s6,a0
    80002ee8:	8c2e                	mv	s8,a1
    80002eea:	8ab2                	mv	s5,a2
    80002eec:	8936                	mv	s2,a3
    80002eee:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80002ef0:	00e687bb          	addw	a5,a3,a4
    80002ef4:	0ed7ee63          	bltu	a5,a3,80002ff0 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002ef8:	00043737          	lui	a4,0x43
    80002efc:	0ef76c63          	bltu	a4,a5,80002ff4 <writei+0x126>
    80002f00:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f02:	0c0b8d63          	beqz	s7,80002fdc <writei+0x10e>
    80002f06:	eca6                	sd	s1,88(sp)
    80002f08:	e4ce                	sd	s3,72(sp)
    80002f0a:	ec66                	sd	s9,24(sp)
    80002f0c:	e86a                	sd	s10,16(sp)
    80002f0e:	e46e                	sd	s11,8(sp)
    80002f10:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f12:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002f16:	5cfd                	li	s9,-1
    80002f18:	a091                	j	80002f5c <writei+0x8e>
    80002f1a:	02099d93          	slli	s11,s3,0x20
    80002f1e:	020ddd93          	srli	s11,s11,0x20
    80002f22:	05848513          	addi	a0,s1,88
    80002f26:	86ee                	mv	a3,s11
    80002f28:	8656                	mv	a2,s5
    80002f2a:	85e2                	mv	a1,s8
    80002f2c:	953a                	add	a0,a0,a4
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	a16080e7          	jalr	-1514(ra) # 80001944 <either_copyin>
    80002f36:	07950263          	beq	a0,s9,80002f9a <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002f3a:	8526                	mv	a0,s1
    80002f3c:	00000097          	auipc	ra,0x0
    80002f40:	780080e7          	jalr	1920(ra) # 800036bc <log_write>
    brelse(bp);
    80002f44:	8526                	mv	a0,s1
    80002f46:	fffff097          	auipc	ra,0xfffff
    80002f4a:	502080e7          	jalr	1282(ra) # 80002448 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002f4e:	01498a3b          	addw	s4,s3,s4
    80002f52:	0129893b          	addw	s2,s3,s2
    80002f56:	9aee                	add	s5,s5,s11
    80002f58:	057a7663          	bgeu	s4,s7,80002fa4 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f5c:	000b2483          	lw	s1,0(s6)
    80002f60:	00a9559b          	srliw	a1,s2,0xa
    80002f64:	855a                	mv	a0,s6
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	7a0080e7          	jalr	1952(ra) # 80002706 <bmap>
    80002f6e:	0005059b          	sext.w	a1,a0
    80002f72:	8526                	mv	a0,s1
    80002f74:	fffff097          	auipc	ra,0xfffff
    80002f78:	3a4080e7          	jalr	932(ra) # 80002318 <bread>
    80002f7c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f7e:	3ff97713          	andi	a4,s2,1023
    80002f82:	40ed07bb          	subw	a5,s10,a4
    80002f86:	414b86bb          	subw	a3,s7,s4
    80002f8a:	89be                	mv	s3,a5
    80002f8c:	2781                	sext.w	a5,a5
    80002f8e:	0006861b          	sext.w	a2,a3
    80002f92:	f8f674e3          	bgeu	a2,a5,80002f1a <writei+0x4c>
    80002f96:	89b6                	mv	s3,a3
    80002f98:	b749                	j	80002f1a <writei+0x4c>
      brelse(bp);
    80002f9a:	8526                	mv	a0,s1
    80002f9c:	fffff097          	auipc	ra,0xfffff
    80002fa0:	4ac080e7          	jalr	1196(ra) # 80002448 <brelse>
  }

  if(off > ip->size)
    80002fa4:	04cb2783          	lw	a5,76(s6)
    80002fa8:	0327fc63          	bgeu	a5,s2,80002fe0 <writei+0x112>
    ip->size = off;
    80002fac:	052b2623          	sw	s2,76(s6)
    80002fb0:	64e6                	ld	s1,88(sp)
    80002fb2:	69a6                	ld	s3,72(sp)
    80002fb4:	6ce2                	ld	s9,24(sp)
    80002fb6:	6d42                	ld	s10,16(sp)
    80002fb8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002fba:	855a                	mv	a0,s6
    80002fbc:	00000097          	auipc	ra,0x0
    80002fc0:	a8a080e7          	jalr	-1398(ra) # 80002a46 <iupdate>

  return tot;
    80002fc4:	000a051b          	sext.w	a0,s4
    80002fc8:	6a06                	ld	s4,64(sp)
}
    80002fca:	70a6                	ld	ra,104(sp)
    80002fcc:	7406                	ld	s0,96(sp)
    80002fce:	6946                	ld	s2,80(sp)
    80002fd0:	7ae2                	ld	s5,56(sp)
    80002fd2:	7b42                	ld	s6,48(sp)
    80002fd4:	7ba2                	ld	s7,40(sp)
    80002fd6:	7c02                	ld	s8,32(sp)
    80002fd8:	6165                	addi	sp,sp,112
    80002fda:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fdc:	8a5e                	mv	s4,s7
    80002fde:	bff1                	j	80002fba <writei+0xec>
    80002fe0:	64e6                	ld	s1,88(sp)
    80002fe2:	69a6                	ld	s3,72(sp)
    80002fe4:	6ce2                	ld	s9,24(sp)
    80002fe6:	6d42                	ld	s10,16(sp)
    80002fe8:	6da2                	ld	s11,8(sp)
    80002fea:	bfc1                	j	80002fba <writei+0xec>
    return -1;
    80002fec:	557d                	li	a0,-1
}
    80002fee:	8082                	ret
    return -1;
    80002ff0:	557d                	li	a0,-1
    80002ff2:	bfe1                	j	80002fca <writei+0xfc>
    return -1;
    80002ff4:	557d                	li	a0,-1
    80002ff6:	bfd1                	j	80002fca <writei+0xfc>

0000000080002ff8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002ff8:	1141                	addi	sp,sp,-16
    80002ffa:	e406                	sd	ra,8(sp)
    80002ffc:	e022                	sd	s0,0(sp)
    80002ffe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003000:	4639                	li	a2,14
    80003002:	ffffd097          	auipc	ra,0xffffd
    80003006:	248080e7          	jalr	584(ra) # 8000024a <strncmp>
}
    8000300a:	60a2                	ld	ra,8(sp)
    8000300c:	6402                	ld	s0,0(sp)
    8000300e:	0141                	addi	sp,sp,16
    80003010:	8082                	ret

0000000080003012 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003012:	7139                	addi	sp,sp,-64
    80003014:	fc06                	sd	ra,56(sp)
    80003016:	f822                	sd	s0,48(sp)
    80003018:	f426                	sd	s1,40(sp)
    8000301a:	f04a                	sd	s2,32(sp)
    8000301c:	ec4e                	sd	s3,24(sp)
    8000301e:	e852                	sd	s4,16(sp)
    80003020:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003022:	04451703          	lh	a4,68(a0)
    80003026:	4785                	li	a5,1
    80003028:	00f71a63          	bne	a4,a5,8000303c <dirlookup+0x2a>
    8000302c:	892a                	mv	s2,a0
    8000302e:	89ae                	mv	s3,a1
    80003030:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003032:	457c                	lw	a5,76(a0)
    80003034:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003036:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003038:	e79d                	bnez	a5,80003066 <dirlookup+0x54>
    8000303a:	a8a5                	j	800030b2 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000303c:	00005517          	auipc	a0,0x5
    80003040:	4ec50513          	addi	a0,a0,1260 # 80008528 <etext+0x528>
    80003044:	00003097          	auipc	ra,0x3
    80003048:	c38080e7          	jalr	-968(ra) # 80005c7c <panic>
      panic("dirlookup read");
    8000304c:	00005517          	auipc	a0,0x5
    80003050:	4f450513          	addi	a0,a0,1268 # 80008540 <etext+0x540>
    80003054:	00003097          	auipc	ra,0x3
    80003058:	c28080e7          	jalr	-984(ra) # 80005c7c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000305c:	24c1                	addiw	s1,s1,16
    8000305e:	04c92783          	lw	a5,76(s2)
    80003062:	04f4f763          	bgeu	s1,a5,800030b0 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003066:	4741                	li	a4,16
    80003068:	86a6                	mv	a3,s1
    8000306a:	fc040613          	addi	a2,s0,-64
    8000306e:	4581                	li	a1,0
    80003070:	854a                	mv	a0,s2
    80003072:	00000097          	auipc	ra,0x0
    80003076:	d58080e7          	jalr	-680(ra) # 80002dca <readi>
    8000307a:	47c1                	li	a5,16
    8000307c:	fcf518e3          	bne	a0,a5,8000304c <dirlookup+0x3a>
    if(de.inum == 0)
    80003080:	fc045783          	lhu	a5,-64(s0)
    80003084:	dfe1                	beqz	a5,8000305c <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003086:	fc240593          	addi	a1,s0,-62
    8000308a:	854e                	mv	a0,s3
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	f6c080e7          	jalr	-148(ra) # 80002ff8 <namecmp>
    80003094:	f561                	bnez	a0,8000305c <dirlookup+0x4a>
      if(poff)
    80003096:	000a0463          	beqz	s4,8000309e <dirlookup+0x8c>
        *poff = off;
    8000309a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000309e:	fc045583          	lhu	a1,-64(s0)
    800030a2:	00092503          	lw	a0,0(s2)
    800030a6:	fffff097          	auipc	ra,0xfffff
    800030aa:	73c080e7          	jalr	1852(ra) # 800027e2 <iget>
    800030ae:	a011                	j	800030b2 <dirlookup+0xa0>
  return 0;
    800030b0:	4501                	li	a0,0
}
    800030b2:	70e2                	ld	ra,56(sp)
    800030b4:	7442                	ld	s0,48(sp)
    800030b6:	74a2                	ld	s1,40(sp)
    800030b8:	7902                	ld	s2,32(sp)
    800030ba:	69e2                	ld	s3,24(sp)
    800030bc:	6a42                	ld	s4,16(sp)
    800030be:	6121                	addi	sp,sp,64
    800030c0:	8082                	ret

00000000800030c2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800030c2:	711d                	addi	sp,sp,-96
    800030c4:	ec86                	sd	ra,88(sp)
    800030c6:	e8a2                	sd	s0,80(sp)
    800030c8:	e4a6                	sd	s1,72(sp)
    800030ca:	e0ca                	sd	s2,64(sp)
    800030cc:	fc4e                	sd	s3,56(sp)
    800030ce:	f852                	sd	s4,48(sp)
    800030d0:	f456                	sd	s5,40(sp)
    800030d2:	f05a                	sd	s6,32(sp)
    800030d4:	ec5e                	sd	s7,24(sp)
    800030d6:	e862                	sd	s8,16(sp)
    800030d8:	e466                	sd	s9,8(sp)
    800030da:	1080                	addi	s0,sp,96
    800030dc:	84aa                	mv	s1,a0
    800030de:	8b2e                	mv	s6,a1
    800030e0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800030e2:	00054703          	lbu	a4,0(a0)
    800030e6:	02f00793          	li	a5,47
    800030ea:	02f70263          	beq	a4,a5,8000310e <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800030ee:	ffffe097          	auipc	ra,0xffffe
    800030f2:	d8e080e7          	jalr	-626(ra) # 80000e7c <myproc>
    800030f6:	15053503          	ld	a0,336(a0)
    800030fa:	00000097          	auipc	ra,0x0
    800030fe:	9da080e7          	jalr	-1574(ra) # 80002ad4 <idup>
    80003102:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003104:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003108:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000310a:	4b85                	li	s7,1
    8000310c:	a875                	j	800031c8 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    8000310e:	4585                	li	a1,1
    80003110:	4505                	li	a0,1
    80003112:	fffff097          	auipc	ra,0xfffff
    80003116:	6d0080e7          	jalr	1744(ra) # 800027e2 <iget>
    8000311a:	8a2a                	mv	s4,a0
    8000311c:	b7e5                	j	80003104 <namex+0x42>
      iunlockput(ip);
    8000311e:	8552                	mv	a0,s4
    80003120:	00000097          	auipc	ra,0x0
    80003124:	c58080e7          	jalr	-936(ra) # 80002d78 <iunlockput>
      return 0;
    80003128:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000312a:	8552                	mv	a0,s4
    8000312c:	60e6                	ld	ra,88(sp)
    8000312e:	6446                	ld	s0,80(sp)
    80003130:	64a6                	ld	s1,72(sp)
    80003132:	6906                	ld	s2,64(sp)
    80003134:	79e2                	ld	s3,56(sp)
    80003136:	7a42                	ld	s4,48(sp)
    80003138:	7aa2                	ld	s5,40(sp)
    8000313a:	7b02                	ld	s6,32(sp)
    8000313c:	6be2                	ld	s7,24(sp)
    8000313e:	6c42                	ld	s8,16(sp)
    80003140:	6ca2                	ld	s9,8(sp)
    80003142:	6125                	addi	sp,sp,96
    80003144:	8082                	ret
      iunlock(ip);
    80003146:	8552                	mv	a0,s4
    80003148:	00000097          	auipc	ra,0x0
    8000314c:	a90080e7          	jalr	-1392(ra) # 80002bd8 <iunlock>
      return ip;
    80003150:	bfe9                	j	8000312a <namex+0x68>
      iunlockput(ip);
    80003152:	8552                	mv	a0,s4
    80003154:	00000097          	auipc	ra,0x0
    80003158:	c24080e7          	jalr	-988(ra) # 80002d78 <iunlockput>
      return 0;
    8000315c:	8a4e                	mv	s4,s3
    8000315e:	b7f1                	j	8000312a <namex+0x68>
  len = path - s;
    80003160:	40998633          	sub	a2,s3,s1
    80003164:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003168:	099c5863          	bge	s8,s9,800031f8 <namex+0x136>
    memmove(name, s, DIRSIZ);
    8000316c:	4639                	li	a2,14
    8000316e:	85a6                	mv	a1,s1
    80003170:	8556                	mv	a0,s5
    80003172:	ffffd097          	auipc	ra,0xffffd
    80003176:	064080e7          	jalr	100(ra) # 800001d6 <memmove>
    8000317a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000317c:	0004c783          	lbu	a5,0(s1)
    80003180:	01279763          	bne	a5,s2,8000318e <namex+0xcc>
    path++;
    80003184:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003186:	0004c783          	lbu	a5,0(s1)
    8000318a:	ff278de3          	beq	a5,s2,80003184 <namex+0xc2>
    ilock(ip);
    8000318e:	8552                	mv	a0,s4
    80003190:	00000097          	auipc	ra,0x0
    80003194:	982080e7          	jalr	-1662(ra) # 80002b12 <ilock>
    if(ip->type != T_DIR){
    80003198:	044a1783          	lh	a5,68(s4)
    8000319c:	f97791e3          	bne	a5,s7,8000311e <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800031a0:	000b0563          	beqz	s6,800031aa <namex+0xe8>
    800031a4:	0004c783          	lbu	a5,0(s1)
    800031a8:	dfd9                	beqz	a5,80003146 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800031aa:	4601                	li	a2,0
    800031ac:	85d6                	mv	a1,s5
    800031ae:	8552                	mv	a0,s4
    800031b0:	00000097          	auipc	ra,0x0
    800031b4:	e62080e7          	jalr	-414(ra) # 80003012 <dirlookup>
    800031b8:	89aa                	mv	s3,a0
    800031ba:	dd41                	beqz	a0,80003152 <namex+0x90>
    iunlockput(ip);
    800031bc:	8552                	mv	a0,s4
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	bba080e7          	jalr	-1094(ra) # 80002d78 <iunlockput>
    ip = next;
    800031c6:	8a4e                	mv	s4,s3
  while(*path == '/')
    800031c8:	0004c783          	lbu	a5,0(s1)
    800031cc:	01279763          	bne	a5,s2,800031da <namex+0x118>
    path++;
    800031d0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800031d2:	0004c783          	lbu	a5,0(s1)
    800031d6:	ff278de3          	beq	a5,s2,800031d0 <namex+0x10e>
  if(*path == 0)
    800031da:	cb9d                	beqz	a5,80003210 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800031dc:	0004c783          	lbu	a5,0(s1)
    800031e0:	89a6                	mv	s3,s1
  len = path - s;
    800031e2:	4c81                	li	s9,0
    800031e4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800031e6:	01278963          	beq	a5,s2,800031f8 <namex+0x136>
    800031ea:	dbbd                	beqz	a5,80003160 <namex+0x9e>
    path++;
    800031ec:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800031ee:	0009c783          	lbu	a5,0(s3)
    800031f2:	ff279ce3          	bne	a5,s2,800031ea <namex+0x128>
    800031f6:	b7ad                	j	80003160 <namex+0x9e>
    memmove(name, s, len);
    800031f8:	2601                	sext.w	a2,a2
    800031fa:	85a6                	mv	a1,s1
    800031fc:	8556                	mv	a0,s5
    800031fe:	ffffd097          	auipc	ra,0xffffd
    80003202:	fd8080e7          	jalr	-40(ra) # 800001d6 <memmove>
    name[len] = 0;
    80003206:	9cd6                	add	s9,s9,s5
    80003208:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000320c:	84ce                	mv	s1,s3
    8000320e:	b7bd                	j	8000317c <namex+0xba>
  if(nameiparent){
    80003210:	f00b0de3          	beqz	s6,8000312a <namex+0x68>
    iput(ip);
    80003214:	8552                	mv	a0,s4
    80003216:	00000097          	auipc	ra,0x0
    8000321a:	aba080e7          	jalr	-1350(ra) # 80002cd0 <iput>
    return 0;
    8000321e:	4a01                	li	s4,0
    80003220:	b729                	j	8000312a <namex+0x68>

0000000080003222 <dirlink>:
{
    80003222:	7139                	addi	sp,sp,-64
    80003224:	fc06                	sd	ra,56(sp)
    80003226:	f822                	sd	s0,48(sp)
    80003228:	f04a                	sd	s2,32(sp)
    8000322a:	ec4e                	sd	s3,24(sp)
    8000322c:	e852                	sd	s4,16(sp)
    8000322e:	0080                	addi	s0,sp,64
    80003230:	892a                	mv	s2,a0
    80003232:	8a2e                	mv	s4,a1
    80003234:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003236:	4601                	li	a2,0
    80003238:	00000097          	auipc	ra,0x0
    8000323c:	dda080e7          	jalr	-550(ra) # 80003012 <dirlookup>
    80003240:	ed25                	bnez	a0,800032b8 <dirlink+0x96>
    80003242:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003244:	04c92483          	lw	s1,76(s2)
    80003248:	c49d                	beqz	s1,80003276 <dirlink+0x54>
    8000324a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324c:	4741                	li	a4,16
    8000324e:	86a6                	mv	a3,s1
    80003250:	fc040613          	addi	a2,s0,-64
    80003254:	4581                	li	a1,0
    80003256:	854a                	mv	a0,s2
    80003258:	00000097          	auipc	ra,0x0
    8000325c:	b72080e7          	jalr	-1166(ra) # 80002dca <readi>
    80003260:	47c1                	li	a5,16
    80003262:	06f51163          	bne	a0,a5,800032c4 <dirlink+0xa2>
    if(de.inum == 0)
    80003266:	fc045783          	lhu	a5,-64(s0)
    8000326a:	c791                	beqz	a5,80003276 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000326c:	24c1                	addiw	s1,s1,16
    8000326e:	04c92783          	lw	a5,76(s2)
    80003272:	fcf4ede3          	bltu	s1,a5,8000324c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003276:	4639                	li	a2,14
    80003278:	85d2                	mv	a1,s4
    8000327a:	fc240513          	addi	a0,s0,-62
    8000327e:	ffffd097          	auipc	ra,0xffffd
    80003282:	002080e7          	jalr	2(ra) # 80000280 <strncpy>
  de.inum = inum;
    80003286:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000328a:	4741                	li	a4,16
    8000328c:	86a6                	mv	a3,s1
    8000328e:	fc040613          	addi	a2,s0,-64
    80003292:	4581                	li	a1,0
    80003294:	854a                	mv	a0,s2
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	c38080e7          	jalr	-968(ra) # 80002ece <writei>
    8000329e:	872a                	mv	a4,a0
    800032a0:	47c1                	li	a5,16
  return 0;
    800032a2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032a4:	02f71863          	bne	a4,a5,800032d4 <dirlink+0xb2>
    800032a8:	74a2                	ld	s1,40(sp)
}
    800032aa:	70e2                	ld	ra,56(sp)
    800032ac:	7442                	ld	s0,48(sp)
    800032ae:	7902                	ld	s2,32(sp)
    800032b0:	69e2                	ld	s3,24(sp)
    800032b2:	6a42                	ld	s4,16(sp)
    800032b4:	6121                	addi	sp,sp,64
    800032b6:	8082                	ret
    iput(ip);
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	a18080e7          	jalr	-1512(ra) # 80002cd0 <iput>
    return -1;
    800032c0:	557d                	li	a0,-1
    800032c2:	b7e5                	j	800032aa <dirlink+0x88>
      panic("dirlink read");
    800032c4:	00005517          	auipc	a0,0x5
    800032c8:	28c50513          	addi	a0,a0,652 # 80008550 <etext+0x550>
    800032cc:	00003097          	auipc	ra,0x3
    800032d0:	9b0080e7          	jalr	-1616(ra) # 80005c7c <panic>
    panic("dirlink");
    800032d4:	00005517          	auipc	a0,0x5
    800032d8:	38450513          	addi	a0,a0,900 # 80008658 <etext+0x658>
    800032dc:	00003097          	auipc	ra,0x3
    800032e0:	9a0080e7          	jalr	-1632(ra) # 80005c7c <panic>

00000000800032e4 <namei>:

struct inode*
namei(char *path)
{
    800032e4:	1101                	addi	sp,sp,-32
    800032e6:	ec06                	sd	ra,24(sp)
    800032e8:	e822                	sd	s0,16(sp)
    800032ea:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800032ec:	fe040613          	addi	a2,s0,-32
    800032f0:	4581                	li	a1,0
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	dd0080e7          	jalr	-560(ra) # 800030c2 <namex>
}
    800032fa:	60e2                	ld	ra,24(sp)
    800032fc:	6442                	ld	s0,16(sp)
    800032fe:	6105                	addi	sp,sp,32
    80003300:	8082                	ret

0000000080003302 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003302:	1141                	addi	sp,sp,-16
    80003304:	e406                	sd	ra,8(sp)
    80003306:	e022                	sd	s0,0(sp)
    80003308:	0800                	addi	s0,sp,16
    8000330a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000330c:	4585                	li	a1,1
    8000330e:	00000097          	auipc	ra,0x0
    80003312:	db4080e7          	jalr	-588(ra) # 800030c2 <namex>
}
    80003316:	60a2                	ld	ra,8(sp)
    80003318:	6402                	ld	s0,0(sp)
    8000331a:	0141                	addi	sp,sp,16
    8000331c:	8082                	ret

000000008000331e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000331e:	1101                	addi	sp,sp,-32
    80003320:	ec06                	sd	ra,24(sp)
    80003322:	e822                	sd	s0,16(sp)
    80003324:	e426                	sd	s1,8(sp)
    80003326:	e04a                	sd	s2,0(sp)
    80003328:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000332a:	00016917          	auipc	s2,0x16
    8000332e:	cf690913          	addi	s2,s2,-778 # 80019020 <log>
    80003332:	01892583          	lw	a1,24(s2)
    80003336:	02892503          	lw	a0,40(s2)
    8000333a:	fffff097          	auipc	ra,0xfffff
    8000333e:	fde080e7          	jalr	-34(ra) # 80002318 <bread>
    80003342:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003344:	02c92603          	lw	a2,44(s2)
    80003348:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000334a:	00c05f63          	blez	a2,80003368 <write_head+0x4a>
    8000334e:	00016717          	auipc	a4,0x16
    80003352:	d0270713          	addi	a4,a4,-766 # 80019050 <log+0x30>
    80003356:	87aa                	mv	a5,a0
    80003358:	060a                	slli	a2,a2,0x2
    8000335a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000335c:	4314                	lw	a3,0(a4)
    8000335e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003360:	0711                	addi	a4,a4,4
    80003362:	0791                	addi	a5,a5,4
    80003364:	fec79ce3          	bne	a5,a2,8000335c <write_head+0x3e>
  }
  bwrite(buf);
    80003368:	8526                	mv	a0,s1
    8000336a:	fffff097          	auipc	ra,0xfffff
    8000336e:	0a0080e7          	jalr	160(ra) # 8000240a <bwrite>
  brelse(buf);
    80003372:	8526                	mv	a0,s1
    80003374:	fffff097          	auipc	ra,0xfffff
    80003378:	0d4080e7          	jalr	212(ra) # 80002448 <brelse>
}
    8000337c:	60e2                	ld	ra,24(sp)
    8000337e:	6442                	ld	s0,16(sp)
    80003380:	64a2                	ld	s1,8(sp)
    80003382:	6902                	ld	s2,0(sp)
    80003384:	6105                	addi	sp,sp,32
    80003386:	8082                	ret

0000000080003388 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003388:	00016797          	auipc	a5,0x16
    8000338c:	cc47a783          	lw	a5,-828(a5) # 8001904c <log+0x2c>
    80003390:	0af05d63          	blez	a5,8000344a <install_trans+0xc2>
{
    80003394:	7139                	addi	sp,sp,-64
    80003396:	fc06                	sd	ra,56(sp)
    80003398:	f822                	sd	s0,48(sp)
    8000339a:	f426                	sd	s1,40(sp)
    8000339c:	f04a                	sd	s2,32(sp)
    8000339e:	ec4e                	sd	s3,24(sp)
    800033a0:	e852                	sd	s4,16(sp)
    800033a2:	e456                	sd	s5,8(sp)
    800033a4:	e05a                	sd	s6,0(sp)
    800033a6:	0080                	addi	s0,sp,64
    800033a8:	8b2a                	mv	s6,a0
    800033aa:	00016a97          	auipc	s5,0x16
    800033ae:	ca6a8a93          	addi	s5,s5,-858 # 80019050 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033b2:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033b4:	00016997          	auipc	s3,0x16
    800033b8:	c6c98993          	addi	s3,s3,-916 # 80019020 <log>
    800033bc:	a00d                	j	800033de <install_trans+0x56>
    brelse(lbuf);
    800033be:	854a                	mv	a0,s2
    800033c0:	fffff097          	auipc	ra,0xfffff
    800033c4:	088080e7          	jalr	136(ra) # 80002448 <brelse>
    brelse(dbuf);
    800033c8:	8526                	mv	a0,s1
    800033ca:	fffff097          	auipc	ra,0xfffff
    800033ce:	07e080e7          	jalr	126(ra) # 80002448 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800033d2:	2a05                	addiw	s4,s4,1
    800033d4:	0a91                	addi	s5,s5,4
    800033d6:	02c9a783          	lw	a5,44(s3)
    800033da:	04fa5e63          	bge	s4,a5,80003436 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800033de:	0189a583          	lw	a1,24(s3)
    800033e2:	014585bb          	addw	a1,a1,s4
    800033e6:	2585                	addiw	a1,a1,1
    800033e8:	0289a503          	lw	a0,40(s3)
    800033ec:	fffff097          	auipc	ra,0xfffff
    800033f0:	f2c080e7          	jalr	-212(ra) # 80002318 <bread>
    800033f4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800033f6:	000aa583          	lw	a1,0(s5)
    800033fa:	0289a503          	lw	a0,40(s3)
    800033fe:	fffff097          	auipc	ra,0xfffff
    80003402:	f1a080e7          	jalr	-230(ra) # 80002318 <bread>
    80003406:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003408:	40000613          	li	a2,1024
    8000340c:	05890593          	addi	a1,s2,88
    80003410:	05850513          	addi	a0,a0,88
    80003414:	ffffd097          	auipc	ra,0xffffd
    80003418:	dc2080e7          	jalr	-574(ra) # 800001d6 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000341c:	8526                	mv	a0,s1
    8000341e:	fffff097          	auipc	ra,0xfffff
    80003422:	fec080e7          	jalr	-20(ra) # 8000240a <bwrite>
    if(recovering == 0)
    80003426:	f80b1ce3          	bnez	s6,800033be <install_trans+0x36>
      bunpin(dbuf);
    8000342a:	8526                	mv	a0,s1
    8000342c:	fffff097          	auipc	ra,0xfffff
    80003430:	0f4080e7          	jalr	244(ra) # 80002520 <bunpin>
    80003434:	b769                	j	800033be <install_trans+0x36>
}
    80003436:	70e2                	ld	ra,56(sp)
    80003438:	7442                	ld	s0,48(sp)
    8000343a:	74a2                	ld	s1,40(sp)
    8000343c:	7902                	ld	s2,32(sp)
    8000343e:	69e2                	ld	s3,24(sp)
    80003440:	6a42                	ld	s4,16(sp)
    80003442:	6aa2                	ld	s5,8(sp)
    80003444:	6b02                	ld	s6,0(sp)
    80003446:	6121                	addi	sp,sp,64
    80003448:	8082                	ret
    8000344a:	8082                	ret

000000008000344c <initlog>:
{
    8000344c:	7179                	addi	sp,sp,-48
    8000344e:	f406                	sd	ra,40(sp)
    80003450:	f022                	sd	s0,32(sp)
    80003452:	ec26                	sd	s1,24(sp)
    80003454:	e84a                	sd	s2,16(sp)
    80003456:	e44e                	sd	s3,8(sp)
    80003458:	1800                	addi	s0,sp,48
    8000345a:	892a                	mv	s2,a0
    8000345c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000345e:	00016497          	auipc	s1,0x16
    80003462:	bc248493          	addi	s1,s1,-1086 # 80019020 <log>
    80003466:	00005597          	auipc	a1,0x5
    8000346a:	0fa58593          	addi	a1,a1,250 # 80008560 <etext+0x560>
    8000346e:	8526                	mv	a0,s1
    80003470:	00003097          	auipc	ra,0x3
    80003474:	cf6080e7          	jalr	-778(ra) # 80006166 <initlock>
  log.start = sb->logstart;
    80003478:	0149a583          	lw	a1,20(s3)
    8000347c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000347e:	0109a783          	lw	a5,16(s3)
    80003482:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003484:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003488:	854a                	mv	a0,s2
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	e8e080e7          	jalr	-370(ra) # 80002318 <bread>
  log.lh.n = lh->n;
    80003492:	4d30                	lw	a2,88(a0)
    80003494:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003496:	00c05f63          	blez	a2,800034b4 <initlog+0x68>
    8000349a:	87aa                	mv	a5,a0
    8000349c:	00016717          	auipc	a4,0x16
    800034a0:	bb470713          	addi	a4,a4,-1100 # 80019050 <log+0x30>
    800034a4:	060a                	slli	a2,a2,0x2
    800034a6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800034a8:	4ff4                	lw	a3,92(a5)
    800034aa:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034ac:	0791                	addi	a5,a5,4
    800034ae:	0711                	addi	a4,a4,4
    800034b0:	fec79ce3          	bne	a5,a2,800034a8 <initlog+0x5c>
  brelse(buf);
    800034b4:	fffff097          	auipc	ra,0xfffff
    800034b8:	f94080e7          	jalr	-108(ra) # 80002448 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800034bc:	4505                	li	a0,1
    800034be:	00000097          	auipc	ra,0x0
    800034c2:	eca080e7          	jalr	-310(ra) # 80003388 <install_trans>
  log.lh.n = 0;
    800034c6:	00016797          	auipc	a5,0x16
    800034ca:	b807a323          	sw	zero,-1146(a5) # 8001904c <log+0x2c>
  write_head(); // clear the log
    800034ce:	00000097          	auipc	ra,0x0
    800034d2:	e50080e7          	jalr	-432(ra) # 8000331e <write_head>
}
    800034d6:	70a2                	ld	ra,40(sp)
    800034d8:	7402                	ld	s0,32(sp)
    800034da:	64e2                	ld	s1,24(sp)
    800034dc:	6942                	ld	s2,16(sp)
    800034de:	69a2                	ld	s3,8(sp)
    800034e0:	6145                	addi	sp,sp,48
    800034e2:	8082                	ret

00000000800034e4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800034e4:	1101                	addi	sp,sp,-32
    800034e6:	ec06                	sd	ra,24(sp)
    800034e8:	e822                	sd	s0,16(sp)
    800034ea:	e426                	sd	s1,8(sp)
    800034ec:	e04a                	sd	s2,0(sp)
    800034ee:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800034f0:	00016517          	auipc	a0,0x16
    800034f4:	b3050513          	addi	a0,a0,-1232 # 80019020 <log>
    800034f8:	00003097          	auipc	ra,0x3
    800034fc:	cfe080e7          	jalr	-770(ra) # 800061f6 <acquire>
  while(1){
    if(log.committing){
    80003500:	00016497          	auipc	s1,0x16
    80003504:	b2048493          	addi	s1,s1,-1248 # 80019020 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003508:	4979                	li	s2,30
    8000350a:	a039                	j	80003518 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000350c:	85a6                	mv	a1,s1
    8000350e:	8526                	mv	a0,s1
    80003510:	ffffe097          	auipc	ra,0xffffe
    80003514:	03a080e7          	jalr	58(ra) # 8000154a <sleep>
    if(log.committing){
    80003518:	50dc                	lw	a5,36(s1)
    8000351a:	fbed                	bnez	a5,8000350c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000351c:	5098                	lw	a4,32(s1)
    8000351e:	2705                	addiw	a4,a4,1
    80003520:	0027179b          	slliw	a5,a4,0x2
    80003524:	9fb9                	addw	a5,a5,a4
    80003526:	0017979b          	slliw	a5,a5,0x1
    8000352a:	54d4                	lw	a3,44(s1)
    8000352c:	9fb5                	addw	a5,a5,a3
    8000352e:	00f95963          	bge	s2,a5,80003540 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003532:	85a6                	mv	a1,s1
    80003534:	8526                	mv	a0,s1
    80003536:	ffffe097          	auipc	ra,0xffffe
    8000353a:	014080e7          	jalr	20(ra) # 8000154a <sleep>
    8000353e:	bfe9                	j	80003518 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003540:	00016517          	auipc	a0,0x16
    80003544:	ae050513          	addi	a0,a0,-1312 # 80019020 <log>
    80003548:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000354a:	00003097          	auipc	ra,0x3
    8000354e:	d60080e7          	jalr	-672(ra) # 800062aa <release>
      break;
    }
  }
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	64a2                	ld	s1,8(sp)
    80003558:	6902                	ld	s2,0(sp)
    8000355a:	6105                	addi	sp,sp,32
    8000355c:	8082                	ret

000000008000355e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000355e:	7139                	addi	sp,sp,-64
    80003560:	fc06                	sd	ra,56(sp)
    80003562:	f822                	sd	s0,48(sp)
    80003564:	f426                	sd	s1,40(sp)
    80003566:	f04a                	sd	s2,32(sp)
    80003568:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000356a:	00016497          	auipc	s1,0x16
    8000356e:	ab648493          	addi	s1,s1,-1354 # 80019020 <log>
    80003572:	8526                	mv	a0,s1
    80003574:	00003097          	auipc	ra,0x3
    80003578:	c82080e7          	jalr	-894(ra) # 800061f6 <acquire>
  log.outstanding -= 1;
    8000357c:	509c                	lw	a5,32(s1)
    8000357e:	37fd                	addiw	a5,a5,-1
    80003580:	0007891b          	sext.w	s2,a5
    80003584:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003586:	50dc                	lw	a5,36(s1)
    80003588:	e7b9                	bnez	a5,800035d6 <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000358a:	06091163          	bnez	s2,800035ec <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000358e:	00016497          	auipc	s1,0x16
    80003592:	a9248493          	addi	s1,s1,-1390 # 80019020 <log>
    80003596:	4785                	li	a5,1
    80003598:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000359a:	8526                	mv	a0,s1
    8000359c:	00003097          	auipc	ra,0x3
    800035a0:	d0e080e7          	jalr	-754(ra) # 800062aa <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800035a4:	54dc                	lw	a5,44(s1)
    800035a6:	06f04763          	bgtz	a5,80003614 <end_op+0xb6>
    acquire(&log.lock);
    800035aa:	00016497          	auipc	s1,0x16
    800035ae:	a7648493          	addi	s1,s1,-1418 # 80019020 <log>
    800035b2:	8526                	mv	a0,s1
    800035b4:	00003097          	auipc	ra,0x3
    800035b8:	c42080e7          	jalr	-958(ra) # 800061f6 <acquire>
    log.committing = 0;
    800035bc:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800035c0:	8526                	mv	a0,s1
    800035c2:	ffffe097          	auipc	ra,0xffffe
    800035c6:	114080e7          	jalr	276(ra) # 800016d6 <wakeup>
    release(&log.lock);
    800035ca:	8526                	mv	a0,s1
    800035cc:	00003097          	auipc	ra,0x3
    800035d0:	cde080e7          	jalr	-802(ra) # 800062aa <release>
}
    800035d4:	a815                	j	80003608 <end_op+0xaa>
    800035d6:	ec4e                	sd	s3,24(sp)
    800035d8:	e852                	sd	s4,16(sp)
    800035da:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800035dc:	00005517          	auipc	a0,0x5
    800035e0:	f8c50513          	addi	a0,a0,-116 # 80008568 <etext+0x568>
    800035e4:	00002097          	auipc	ra,0x2
    800035e8:	698080e7          	jalr	1688(ra) # 80005c7c <panic>
    wakeup(&log);
    800035ec:	00016497          	auipc	s1,0x16
    800035f0:	a3448493          	addi	s1,s1,-1484 # 80019020 <log>
    800035f4:	8526                	mv	a0,s1
    800035f6:	ffffe097          	auipc	ra,0xffffe
    800035fa:	0e0080e7          	jalr	224(ra) # 800016d6 <wakeup>
  release(&log.lock);
    800035fe:	8526                	mv	a0,s1
    80003600:	00003097          	auipc	ra,0x3
    80003604:	caa080e7          	jalr	-854(ra) # 800062aa <release>
}
    80003608:	70e2                	ld	ra,56(sp)
    8000360a:	7442                	ld	s0,48(sp)
    8000360c:	74a2                	ld	s1,40(sp)
    8000360e:	7902                	ld	s2,32(sp)
    80003610:	6121                	addi	sp,sp,64
    80003612:	8082                	ret
    80003614:	ec4e                	sd	s3,24(sp)
    80003616:	e852                	sd	s4,16(sp)
    80003618:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000361a:	00016a97          	auipc	s5,0x16
    8000361e:	a36a8a93          	addi	s5,s5,-1482 # 80019050 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003622:	00016a17          	auipc	s4,0x16
    80003626:	9fea0a13          	addi	s4,s4,-1538 # 80019020 <log>
    8000362a:	018a2583          	lw	a1,24(s4)
    8000362e:	012585bb          	addw	a1,a1,s2
    80003632:	2585                	addiw	a1,a1,1
    80003634:	028a2503          	lw	a0,40(s4)
    80003638:	fffff097          	auipc	ra,0xfffff
    8000363c:	ce0080e7          	jalr	-800(ra) # 80002318 <bread>
    80003640:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003642:	000aa583          	lw	a1,0(s5)
    80003646:	028a2503          	lw	a0,40(s4)
    8000364a:	fffff097          	auipc	ra,0xfffff
    8000364e:	cce080e7          	jalr	-818(ra) # 80002318 <bread>
    80003652:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003654:	40000613          	li	a2,1024
    80003658:	05850593          	addi	a1,a0,88
    8000365c:	05848513          	addi	a0,s1,88
    80003660:	ffffd097          	auipc	ra,0xffffd
    80003664:	b76080e7          	jalr	-1162(ra) # 800001d6 <memmove>
    bwrite(to);  // write the log
    80003668:	8526                	mv	a0,s1
    8000366a:	fffff097          	auipc	ra,0xfffff
    8000366e:	da0080e7          	jalr	-608(ra) # 8000240a <bwrite>
    brelse(from);
    80003672:	854e                	mv	a0,s3
    80003674:	fffff097          	auipc	ra,0xfffff
    80003678:	dd4080e7          	jalr	-556(ra) # 80002448 <brelse>
    brelse(to);
    8000367c:	8526                	mv	a0,s1
    8000367e:	fffff097          	auipc	ra,0xfffff
    80003682:	dca080e7          	jalr	-566(ra) # 80002448 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003686:	2905                	addiw	s2,s2,1
    80003688:	0a91                	addi	s5,s5,4
    8000368a:	02ca2783          	lw	a5,44(s4)
    8000368e:	f8f94ee3          	blt	s2,a5,8000362a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003692:	00000097          	auipc	ra,0x0
    80003696:	c8c080e7          	jalr	-884(ra) # 8000331e <write_head>
    install_trans(0); // Now install writes to home locations
    8000369a:	4501                	li	a0,0
    8000369c:	00000097          	auipc	ra,0x0
    800036a0:	cec080e7          	jalr	-788(ra) # 80003388 <install_trans>
    log.lh.n = 0;
    800036a4:	00016797          	auipc	a5,0x16
    800036a8:	9a07a423          	sw	zero,-1624(a5) # 8001904c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800036ac:	00000097          	auipc	ra,0x0
    800036b0:	c72080e7          	jalr	-910(ra) # 8000331e <write_head>
    800036b4:	69e2                	ld	s3,24(sp)
    800036b6:	6a42                	ld	s4,16(sp)
    800036b8:	6aa2                	ld	s5,8(sp)
    800036ba:	bdc5                	j	800035aa <end_op+0x4c>

00000000800036bc <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800036bc:	1101                	addi	sp,sp,-32
    800036be:	ec06                	sd	ra,24(sp)
    800036c0:	e822                	sd	s0,16(sp)
    800036c2:	e426                	sd	s1,8(sp)
    800036c4:	e04a                	sd	s2,0(sp)
    800036c6:	1000                	addi	s0,sp,32
    800036c8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800036ca:	00016917          	auipc	s2,0x16
    800036ce:	95690913          	addi	s2,s2,-1706 # 80019020 <log>
    800036d2:	854a                	mv	a0,s2
    800036d4:	00003097          	auipc	ra,0x3
    800036d8:	b22080e7          	jalr	-1246(ra) # 800061f6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800036dc:	02c92603          	lw	a2,44(s2)
    800036e0:	47f5                	li	a5,29
    800036e2:	06c7c563          	blt	a5,a2,8000374c <log_write+0x90>
    800036e6:	00016797          	auipc	a5,0x16
    800036ea:	9567a783          	lw	a5,-1706(a5) # 8001903c <log+0x1c>
    800036ee:	37fd                	addiw	a5,a5,-1
    800036f0:	04f65e63          	bge	a2,a5,8000374c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800036f4:	00016797          	auipc	a5,0x16
    800036f8:	94c7a783          	lw	a5,-1716(a5) # 80019040 <log+0x20>
    800036fc:	06f05063          	blez	a5,8000375c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003700:	4781                	li	a5,0
    80003702:	06c05563          	blez	a2,8000376c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003706:	44cc                	lw	a1,12(s1)
    80003708:	00016717          	auipc	a4,0x16
    8000370c:	94870713          	addi	a4,a4,-1720 # 80019050 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003710:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003712:	4314                	lw	a3,0(a4)
    80003714:	04b68c63          	beq	a3,a1,8000376c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003718:	2785                	addiw	a5,a5,1
    8000371a:	0711                	addi	a4,a4,4
    8000371c:	fef61be3          	bne	a2,a5,80003712 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003720:	0621                	addi	a2,a2,8
    80003722:	060a                	slli	a2,a2,0x2
    80003724:	00016797          	auipc	a5,0x16
    80003728:	8fc78793          	addi	a5,a5,-1796 # 80019020 <log>
    8000372c:	97b2                	add	a5,a5,a2
    8000372e:	44d8                	lw	a4,12(s1)
    80003730:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003732:	8526                	mv	a0,s1
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	db0080e7          	jalr	-592(ra) # 800024e4 <bpin>
    log.lh.n++;
    8000373c:	00016717          	auipc	a4,0x16
    80003740:	8e470713          	addi	a4,a4,-1820 # 80019020 <log>
    80003744:	575c                	lw	a5,44(a4)
    80003746:	2785                	addiw	a5,a5,1
    80003748:	d75c                	sw	a5,44(a4)
    8000374a:	a82d                	j	80003784 <log_write+0xc8>
    panic("too big a transaction");
    8000374c:	00005517          	auipc	a0,0x5
    80003750:	e2c50513          	addi	a0,a0,-468 # 80008578 <etext+0x578>
    80003754:	00002097          	auipc	ra,0x2
    80003758:	528080e7          	jalr	1320(ra) # 80005c7c <panic>
    panic("log_write outside of trans");
    8000375c:	00005517          	auipc	a0,0x5
    80003760:	e3450513          	addi	a0,a0,-460 # 80008590 <etext+0x590>
    80003764:	00002097          	auipc	ra,0x2
    80003768:	518080e7          	jalr	1304(ra) # 80005c7c <panic>
  log.lh.block[i] = b->blockno;
    8000376c:	00878693          	addi	a3,a5,8
    80003770:	068a                	slli	a3,a3,0x2
    80003772:	00016717          	auipc	a4,0x16
    80003776:	8ae70713          	addi	a4,a4,-1874 # 80019020 <log>
    8000377a:	9736                	add	a4,a4,a3
    8000377c:	44d4                	lw	a3,12(s1)
    8000377e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003780:	faf609e3          	beq	a2,a5,80003732 <log_write+0x76>
  }
  release(&log.lock);
    80003784:	00016517          	auipc	a0,0x16
    80003788:	89c50513          	addi	a0,a0,-1892 # 80019020 <log>
    8000378c:	00003097          	auipc	ra,0x3
    80003790:	b1e080e7          	jalr	-1250(ra) # 800062aa <release>
}
    80003794:	60e2                	ld	ra,24(sp)
    80003796:	6442                	ld	s0,16(sp)
    80003798:	64a2                	ld	s1,8(sp)
    8000379a:	6902                	ld	s2,0(sp)
    8000379c:	6105                	addi	sp,sp,32
    8000379e:	8082                	ret

00000000800037a0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800037a0:	1101                	addi	sp,sp,-32
    800037a2:	ec06                	sd	ra,24(sp)
    800037a4:	e822                	sd	s0,16(sp)
    800037a6:	e426                	sd	s1,8(sp)
    800037a8:	e04a                	sd	s2,0(sp)
    800037aa:	1000                	addi	s0,sp,32
    800037ac:	84aa                	mv	s1,a0
    800037ae:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800037b0:	00005597          	auipc	a1,0x5
    800037b4:	e0058593          	addi	a1,a1,-512 # 800085b0 <etext+0x5b0>
    800037b8:	0521                	addi	a0,a0,8
    800037ba:	00003097          	auipc	ra,0x3
    800037be:	9ac080e7          	jalr	-1620(ra) # 80006166 <initlock>
  lk->name = name;
    800037c2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800037c6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800037ca:	0204a423          	sw	zero,40(s1)
}
    800037ce:	60e2                	ld	ra,24(sp)
    800037d0:	6442                	ld	s0,16(sp)
    800037d2:	64a2                	ld	s1,8(sp)
    800037d4:	6902                	ld	s2,0(sp)
    800037d6:	6105                	addi	sp,sp,32
    800037d8:	8082                	ret

00000000800037da <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800037da:	1101                	addi	sp,sp,-32
    800037dc:	ec06                	sd	ra,24(sp)
    800037de:	e822                	sd	s0,16(sp)
    800037e0:	e426                	sd	s1,8(sp)
    800037e2:	e04a                	sd	s2,0(sp)
    800037e4:	1000                	addi	s0,sp,32
    800037e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800037e8:	00850913          	addi	s2,a0,8
    800037ec:	854a                	mv	a0,s2
    800037ee:	00003097          	auipc	ra,0x3
    800037f2:	a08080e7          	jalr	-1528(ra) # 800061f6 <acquire>
  while (lk->locked) {
    800037f6:	409c                	lw	a5,0(s1)
    800037f8:	cb89                	beqz	a5,8000380a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800037fa:	85ca                	mv	a1,s2
    800037fc:	8526                	mv	a0,s1
    800037fe:	ffffe097          	auipc	ra,0xffffe
    80003802:	d4c080e7          	jalr	-692(ra) # 8000154a <sleep>
  while (lk->locked) {
    80003806:	409c                	lw	a5,0(s1)
    80003808:	fbed                	bnez	a5,800037fa <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000380a:	4785                	li	a5,1
    8000380c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000380e:	ffffd097          	auipc	ra,0xffffd
    80003812:	66e080e7          	jalr	1646(ra) # 80000e7c <myproc>
    80003816:	591c                	lw	a5,48(a0)
    80003818:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000381a:	854a                	mv	a0,s2
    8000381c:	00003097          	auipc	ra,0x3
    80003820:	a8e080e7          	jalr	-1394(ra) # 800062aa <release>
}
    80003824:	60e2                	ld	ra,24(sp)
    80003826:	6442                	ld	s0,16(sp)
    80003828:	64a2                	ld	s1,8(sp)
    8000382a:	6902                	ld	s2,0(sp)
    8000382c:	6105                	addi	sp,sp,32
    8000382e:	8082                	ret

0000000080003830 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003830:	1101                	addi	sp,sp,-32
    80003832:	ec06                	sd	ra,24(sp)
    80003834:	e822                	sd	s0,16(sp)
    80003836:	e426                	sd	s1,8(sp)
    80003838:	e04a                	sd	s2,0(sp)
    8000383a:	1000                	addi	s0,sp,32
    8000383c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000383e:	00850913          	addi	s2,a0,8
    80003842:	854a                	mv	a0,s2
    80003844:	00003097          	auipc	ra,0x3
    80003848:	9b2080e7          	jalr	-1614(ra) # 800061f6 <acquire>
  lk->locked = 0;
    8000384c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003850:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003854:	8526                	mv	a0,s1
    80003856:	ffffe097          	auipc	ra,0xffffe
    8000385a:	e80080e7          	jalr	-384(ra) # 800016d6 <wakeup>
  release(&lk->lk);
    8000385e:	854a                	mv	a0,s2
    80003860:	00003097          	auipc	ra,0x3
    80003864:	a4a080e7          	jalr	-1462(ra) # 800062aa <release>
}
    80003868:	60e2                	ld	ra,24(sp)
    8000386a:	6442                	ld	s0,16(sp)
    8000386c:	64a2                	ld	s1,8(sp)
    8000386e:	6902                	ld	s2,0(sp)
    80003870:	6105                	addi	sp,sp,32
    80003872:	8082                	ret

0000000080003874 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003874:	7179                	addi	sp,sp,-48
    80003876:	f406                	sd	ra,40(sp)
    80003878:	f022                	sd	s0,32(sp)
    8000387a:	ec26                	sd	s1,24(sp)
    8000387c:	e84a                	sd	s2,16(sp)
    8000387e:	1800                	addi	s0,sp,48
    80003880:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003882:	00850913          	addi	s2,a0,8
    80003886:	854a                	mv	a0,s2
    80003888:	00003097          	auipc	ra,0x3
    8000388c:	96e080e7          	jalr	-1682(ra) # 800061f6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003890:	409c                	lw	a5,0(s1)
    80003892:	ef91                	bnez	a5,800038ae <holdingsleep+0x3a>
    80003894:	4481                	li	s1,0
  release(&lk->lk);
    80003896:	854a                	mv	a0,s2
    80003898:	00003097          	auipc	ra,0x3
    8000389c:	a12080e7          	jalr	-1518(ra) # 800062aa <release>
  return r;
}
    800038a0:	8526                	mv	a0,s1
    800038a2:	70a2                	ld	ra,40(sp)
    800038a4:	7402                	ld	s0,32(sp)
    800038a6:	64e2                	ld	s1,24(sp)
    800038a8:	6942                	ld	s2,16(sp)
    800038aa:	6145                	addi	sp,sp,48
    800038ac:	8082                	ret
    800038ae:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800038b0:	0284a983          	lw	s3,40(s1)
    800038b4:	ffffd097          	auipc	ra,0xffffd
    800038b8:	5c8080e7          	jalr	1480(ra) # 80000e7c <myproc>
    800038bc:	5904                	lw	s1,48(a0)
    800038be:	413484b3          	sub	s1,s1,s3
    800038c2:	0014b493          	seqz	s1,s1
    800038c6:	69a2                	ld	s3,8(sp)
    800038c8:	b7f9                	j	80003896 <holdingsleep+0x22>

00000000800038ca <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800038ca:	1141                	addi	sp,sp,-16
    800038cc:	e406                	sd	ra,8(sp)
    800038ce:	e022                	sd	s0,0(sp)
    800038d0:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800038d2:	00005597          	auipc	a1,0x5
    800038d6:	cee58593          	addi	a1,a1,-786 # 800085c0 <etext+0x5c0>
    800038da:	00016517          	auipc	a0,0x16
    800038de:	88e50513          	addi	a0,a0,-1906 # 80019168 <ftable>
    800038e2:	00003097          	auipc	ra,0x3
    800038e6:	884080e7          	jalr	-1916(ra) # 80006166 <initlock>
}
    800038ea:	60a2                	ld	ra,8(sp)
    800038ec:	6402                	ld	s0,0(sp)
    800038ee:	0141                	addi	sp,sp,16
    800038f0:	8082                	ret

00000000800038f2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800038f2:	1101                	addi	sp,sp,-32
    800038f4:	ec06                	sd	ra,24(sp)
    800038f6:	e822                	sd	s0,16(sp)
    800038f8:	e426                	sd	s1,8(sp)
    800038fa:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800038fc:	00016517          	auipc	a0,0x16
    80003900:	86c50513          	addi	a0,a0,-1940 # 80019168 <ftable>
    80003904:	00003097          	auipc	ra,0x3
    80003908:	8f2080e7          	jalr	-1806(ra) # 800061f6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000390c:	00016497          	auipc	s1,0x16
    80003910:	87448493          	addi	s1,s1,-1932 # 80019180 <ftable+0x18>
    80003914:	00017717          	auipc	a4,0x17
    80003918:	80c70713          	addi	a4,a4,-2036 # 8001a120 <ftable+0xfb8>
    if(f->ref == 0){
    8000391c:	40dc                	lw	a5,4(s1)
    8000391e:	cf99                	beqz	a5,8000393c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003920:	02848493          	addi	s1,s1,40
    80003924:	fee49ce3          	bne	s1,a4,8000391c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003928:	00016517          	auipc	a0,0x16
    8000392c:	84050513          	addi	a0,a0,-1984 # 80019168 <ftable>
    80003930:	00003097          	auipc	ra,0x3
    80003934:	97a080e7          	jalr	-1670(ra) # 800062aa <release>
  return 0;
    80003938:	4481                	li	s1,0
    8000393a:	a819                	j	80003950 <filealloc+0x5e>
      f->ref = 1;
    8000393c:	4785                	li	a5,1
    8000393e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003940:	00016517          	auipc	a0,0x16
    80003944:	82850513          	addi	a0,a0,-2008 # 80019168 <ftable>
    80003948:	00003097          	auipc	ra,0x3
    8000394c:	962080e7          	jalr	-1694(ra) # 800062aa <release>
}
    80003950:	8526                	mv	a0,s1
    80003952:	60e2                	ld	ra,24(sp)
    80003954:	6442                	ld	s0,16(sp)
    80003956:	64a2                	ld	s1,8(sp)
    80003958:	6105                	addi	sp,sp,32
    8000395a:	8082                	ret

000000008000395c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000395c:	1101                	addi	sp,sp,-32
    8000395e:	ec06                	sd	ra,24(sp)
    80003960:	e822                	sd	s0,16(sp)
    80003962:	e426                	sd	s1,8(sp)
    80003964:	1000                	addi	s0,sp,32
    80003966:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003968:	00016517          	auipc	a0,0x16
    8000396c:	80050513          	addi	a0,a0,-2048 # 80019168 <ftable>
    80003970:	00003097          	auipc	ra,0x3
    80003974:	886080e7          	jalr	-1914(ra) # 800061f6 <acquire>
  if(f->ref < 1)
    80003978:	40dc                	lw	a5,4(s1)
    8000397a:	02f05263          	blez	a5,8000399e <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000397e:	2785                	addiw	a5,a5,1
    80003980:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003982:	00015517          	auipc	a0,0x15
    80003986:	7e650513          	addi	a0,a0,2022 # 80019168 <ftable>
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	920080e7          	jalr	-1760(ra) # 800062aa <release>
  return f;
}
    80003992:	8526                	mv	a0,s1
    80003994:	60e2                	ld	ra,24(sp)
    80003996:	6442                	ld	s0,16(sp)
    80003998:	64a2                	ld	s1,8(sp)
    8000399a:	6105                	addi	sp,sp,32
    8000399c:	8082                	ret
    panic("filedup");
    8000399e:	00005517          	auipc	a0,0x5
    800039a2:	c2a50513          	addi	a0,a0,-982 # 800085c8 <etext+0x5c8>
    800039a6:	00002097          	auipc	ra,0x2
    800039aa:	2d6080e7          	jalr	726(ra) # 80005c7c <panic>

00000000800039ae <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800039ae:	7139                	addi	sp,sp,-64
    800039b0:	fc06                	sd	ra,56(sp)
    800039b2:	f822                	sd	s0,48(sp)
    800039b4:	f426                	sd	s1,40(sp)
    800039b6:	0080                	addi	s0,sp,64
    800039b8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800039ba:	00015517          	auipc	a0,0x15
    800039be:	7ae50513          	addi	a0,a0,1966 # 80019168 <ftable>
    800039c2:	00003097          	auipc	ra,0x3
    800039c6:	834080e7          	jalr	-1996(ra) # 800061f6 <acquire>
  if(f->ref < 1)
    800039ca:	40dc                	lw	a5,4(s1)
    800039cc:	04f05c63          	blez	a5,80003a24 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    800039d0:	37fd                	addiw	a5,a5,-1
    800039d2:	0007871b          	sext.w	a4,a5
    800039d6:	c0dc                	sw	a5,4(s1)
    800039d8:	06e04263          	bgtz	a4,80003a3c <fileclose+0x8e>
    800039dc:	f04a                	sd	s2,32(sp)
    800039de:	ec4e                	sd	s3,24(sp)
    800039e0:	e852                	sd	s4,16(sp)
    800039e2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800039e4:	0004a903          	lw	s2,0(s1)
    800039e8:	0094ca83          	lbu	s5,9(s1)
    800039ec:	0104ba03          	ld	s4,16(s1)
    800039f0:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800039f4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800039f8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800039fc:	00015517          	auipc	a0,0x15
    80003a00:	76c50513          	addi	a0,a0,1900 # 80019168 <ftable>
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	8a6080e7          	jalr	-1882(ra) # 800062aa <release>

  if(ff.type == FD_PIPE){
    80003a0c:	4785                	li	a5,1
    80003a0e:	04f90463          	beq	s2,a5,80003a56 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003a12:	3979                	addiw	s2,s2,-2
    80003a14:	4785                	li	a5,1
    80003a16:	0527fb63          	bgeu	a5,s2,80003a6c <fileclose+0xbe>
    80003a1a:	7902                	ld	s2,32(sp)
    80003a1c:	69e2                	ld	s3,24(sp)
    80003a1e:	6a42                	ld	s4,16(sp)
    80003a20:	6aa2                	ld	s5,8(sp)
    80003a22:	a02d                	j	80003a4c <fileclose+0x9e>
    80003a24:	f04a                	sd	s2,32(sp)
    80003a26:	ec4e                	sd	s3,24(sp)
    80003a28:	e852                	sd	s4,16(sp)
    80003a2a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003a2c:	00005517          	auipc	a0,0x5
    80003a30:	ba450513          	addi	a0,a0,-1116 # 800085d0 <etext+0x5d0>
    80003a34:	00002097          	auipc	ra,0x2
    80003a38:	248080e7          	jalr	584(ra) # 80005c7c <panic>
    release(&ftable.lock);
    80003a3c:	00015517          	auipc	a0,0x15
    80003a40:	72c50513          	addi	a0,a0,1836 # 80019168 <ftable>
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	866080e7          	jalr	-1946(ra) # 800062aa <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003a4c:	70e2                	ld	ra,56(sp)
    80003a4e:	7442                	ld	s0,48(sp)
    80003a50:	74a2                	ld	s1,40(sp)
    80003a52:	6121                	addi	sp,sp,64
    80003a54:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003a56:	85d6                	mv	a1,s5
    80003a58:	8552                	mv	a0,s4
    80003a5a:	00000097          	auipc	ra,0x0
    80003a5e:	3a2080e7          	jalr	930(ra) # 80003dfc <pipeclose>
    80003a62:	7902                	ld	s2,32(sp)
    80003a64:	69e2                	ld	s3,24(sp)
    80003a66:	6a42                	ld	s4,16(sp)
    80003a68:	6aa2                	ld	s5,8(sp)
    80003a6a:	b7cd                	j	80003a4c <fileclose+0x9e>
    begin_op();
    80003a6c:	00000097          	auipc	ra,0x0
    80003a70:	a78080e7          	jalr	-1416(ra) # 800034e4 <begin_op>
    iput(ff.ip);
    80003a74:	854e                	mv	a0,s3
    80003a76:	fffff097          	auipc	ra,0xfffff
    80003a7a:	25a080e7          	jalr	602(ra) # 80002cd0 <iput>
    end_op();
    80003a7e:	00000097          	auipc	ra,0x0
    80003a82:	ae0080e7          	jalr	-1312(ra) # 8000355e <end_op>
    80003a86:	7902                	ld	s2,32(sp)
    80003a88:	69e2                	ld	s3,24(sp)
    80003a8a:	6a42                	ld	s4,16(sp)
    80003a8c:	6aa2                	ld	s5,8(sp)
    80003a8e:	bf7d                	j	80003a4c <fileclose+0x9e>

0000000080003a90 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003a90:	715d                	addi	sp,sp,-80
    80003a92:	e486                	sd	ra,72(sp)
    80003a94:	e0a2                	sd	s0,64(sp)
    80003a96:	fc26                	sd	s1,56(sp)
    80003a98:	f44e                	sd	s3,40(sp)
    80003a9a:	0880                	addi	s0,sp,80
    80003a9c:	84aa                	mv	s1,a0
    80003a9e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003aa0:	ffffd097          	auipc	ra,0xffffd
    80003aa4:	3dc080e7          	jalr	988(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003aa8:	409c                	lw	a5,0(s1)
    80003aaa:	37f9                	addiw	a5,a5,-2
    80003aac:	4705                	li	a4,1
    80003aae:	04f76863          	bltu	a4,a5,80003afe <filestat+0x6e>
    80003ab2:	f84a                	sd	s2,48(sp)
    80003ab4:	892a                	mv	s2,a0
    ilock(f->ip);
    80003ab6:	6c88                	ld	a0,24(s1)
    80003ab8:	fffff097          	auipc	ra,0xfffff
    80003abc:	05a080e7          	jalr	90(ra) # 80002b12 <ilock>
    stati(f->ip, &st);
    80003ac0:	fb840593          	addi	a1,s0,-72
    80003ac4:	6c88                	ld	a0,24(s1)
    80003ac6:	fffff097          	auipc	ra,0xfffff
    80003aca:	2da080e7          	jalr	730(ra) # 80002da0 <stati>
    iunlock(f->ip);
    80003ace:	6c88                	ld	a0,24(s1)
    80003ad0:	fffff097          	auipc	ra,0xfffff
    80003ad4:	108080e7          	jalr	264(ra) # 80002bd8 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003ad8:	46e1                	li	a3,24
    80003ada:	fb840613          	addi	a2,s0,-72
    80003ade:	85ce                	mv	a1,s3
    80003ae0:	05093503          	ld	a0,80(s2)
    80003ae4:	ffffd097          	auipc	ra,0xffffd
    80003ae8:	034080e7          	jalr	52(ra) # 80000b18 <copyout>
    80003aec:	41f5551b          	sraiw	a0,a0,0x1f
    80003af0:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003af2:	60a6                	ld	ra,72(sp)
    80003af4:	6406                	ld	s0,64(sp)
    80003af6:	74e2                	ld	s1,56(sp)
    80003af8:	79a2                	ld	s3,40(sp)
    80003afa:	6161                	addi	sp,sp,80
    80003afc:	8082                	ret
  return -1;
    80003afe:	557d                	li	a0,-1
    80003b00:	bfcd                	j	80003af2 <filestat+0x62>

0000000080003b02 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003b02:	7179                	addi	sp,sp,-48
    80003b04:	f406                	sd	ra,40(sp)
    80003b06:	f022                	sd	s0,32(sp)
    80003b08:	e84a                	sd	s2,16(sp)
    80003b0a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003b0c:	00854783          	lbu	a5,8(a0)
    80003b10:	cbc5                	beqz	a5,80003bc0 <fileread+0xbe>
    80003b12:	ec26                	sd	s1,24(sp)
    80003b14:	e44e                	sd	s3,8(sp)
    80003b16:	84aa                	mv	s1,a0
    80003b18:	89ae                	mv	s3,a1
    80003b1a:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003b1c:	411c                	lw	a5,0(a0)
    80003b1e:	4705                	li	a4,1
    80003b20:	04e78963          	beq	a5,a4,80003b72 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003b24:	470d                	li	a4,3
    80003b26:	04e78f63          	beq	a5,a4,80003b84 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003b2a:	4709                	li	a4,2
    80003b2c:	08e79263          	bne	a5,a4,80003bb0 <fileread+0xae>
    ilock(f->ip);
    80003b30:	6d08                	ld	a0,24(a0)
    80003b32:	fffff097          	auipc	ra,0xfffff
    80003b36:	fe0080e7          	jalr	-32(ra) # 80002b12 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003b3a:	874a                	mv	a4,s2
    80003b3c:	5094                	lw	a3,32(s1)
    80003b3e:	864e                	mv	a2,s3
    80003b40:	4585                	li	a1,1
    80003b42:	6c88                	ld	a0,24(s1)
    80003b44:	fffff097          	auipc	ra,0xfffff
    80003b48:	286080e7          	jalr	646(ra) # 80002dca <readi>
    80003b4c:	892a                	mv	s2,a0
    80003b4e:	00a05563          	blez	a0,80003b58 <fileread+0x56>
      f->off += r;
    80003b52:	509c                	lw	a5,32(s1)
    80003b54:	9fa9                	addw	a5,a5,a0
    80003b56:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003b58:	6c88                	ld	a0,24(s1)
    80003b5a:	fffff097          	auipc	ra,0xfffff
    80003b5e:	07e080e7          	jalr	126(ra) # 80002bd8 <iunlock>
    80003b62:	64e2                	ld	s1,24(sp)
    80003b64:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003b66:	854a                	mv	a0,s2
    80003b68:	70a2                	ld	ra,40(sp)
    80003b6a:	7402                	ld	s0,32(sp)
    80003b6c:	6942                	ld	s2,16(sp)
    80003b6e:	6145                	addi	sp,sp,48
    80003b70:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003b72:	6908                	ld	a0,16(a0)
    80003b74:	00000097          	auipc	ra,0x0
    80003b78:	3fa080e7          	jalr	1018(ra) # 80003f6e <piperead>
    80003b7c:	892a                	mv	s2,a0
    80003b7e:	64e2                	ld	s1,24(sp)
    80003b80:	69a2                	ld	s3,8(sp)
    80003b82:	b7d5                	j	80003b66 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003b84:	02451783          	lh	a5,36(a0)
    80003b88:	03079693          	slli	a3,a5,0x30
    80003b8c:	92c1                	srli	a3,a3,0x30
    80003b8e:	4725                	li	a4,9
    80003b90:	02d76a63          	bltu	a4,a3,80003bc4 <fileread+0xc2>
    80003b94:	0792                	slli	a5,a5,0x4
    80003b96:	00015717          	auipc	a4,0x15
    80003b9a:	53270713          	addi	a4,a4,1330 # 800190c8 <devsw>
    80003b9e:	97ba                	add	a5,a5,a4
    80003ba0:	639c                	ld	a5,0(a5)
    80003ba2:	c78d                	beqz	a5,80003bcc <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003ba4:	4505                	li	a0,1
    80003ba6:	9782                	jalr	a5
    80003ba8:	892a                	mv	s2,a0
    80003baa:	64e2                	ld	s1,24(sp)
    80003bac:	69a2                	ld	s3,8(sp)
    80003bae:	bf65                	j	80003b66 <fileread+0x64>
    panic("fileread");
    80003bb0:	00005517          	auipc	a0,0x5
    80003bb4:	a3050513          	addi	a0,a0,-1488 # 800085e0 <etext+0x5e0>
    80003bb8:	00002097          	auipc	ra,0x2
    80003bbc:	0c4080e7          	jalr	196(ra) # 80005c7c <panic>
    return -1;
    80003bc0:	597d                	li	s2,-1
    80003bc2:	b755                	j	80003b66 <fileread+0x64>
      return -1;
    80003bc4:	597d                	li	s2,-1
    80003bc6:	64e2                	ld	s1,24(sp)
    80003bc8:	69a2                	ld	s3,8(sp)
    80003bca:	bf71                	j	80003b66 <fileread+0x64>
    80003bcc:	597d                	li	s2,-1
    80003bce:	64e2                	ld	s1,24(sp)
    80003bd0:	69a2                	ld	s3,8(sp)
    80003bd2:	bf51                	j	80003b66 <fileread+0x64>

0000000080003bd4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003bd4:	00954783          	lbu	a5,9(a0)
    80003bd8:	12078963          	beqz	a5,80003d0a <filewrite+0x136>
{
    80003bdc:	715d                	addi	sp,sp,-80
    80003bde:	e486                	sd	ra,72(sp)
    80003be0:	e0a2                	sd	s0,64(sp)
    80003be2:	f84a                	sd	s2,48(sp)
    80003be4:	f052                	sd	s4,32(sp)
    80003be6:	e85a                	sd	s6,16(sp)
    80003be8:	0880                	addi	s0,sp,80
    80003bea:	892a                	mv	s2,a0
    80003bec:	8b2e                	mv	s6,a1
    80003bee:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bf0:	411c                	lw	a5,0(a0)
    80003bf2:	4705                	li	a4,1
    80003bf4:	02e78763          	beq	a5,a4,80003c22 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bf8:	470d                	li	a4,3
    80003bfa:	02e78a63          	beq	a5,a4,80003c2e <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bfe:	4709                	li	a4,2
    80003c00:	0ee79863          	bne	a5,a4,80003cf0 <filewrite+0x11c>
    80003c04:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c06:	0cc05463          	blez	a2,80003cce <filewrite+0xfa>
    80003c0a:	fc26                	sd	s1,56(sp)
    80003c0c:	ec56                	sd	s5,24(sp)
    80003c0e:	e45e                	sd	s7,8(sp)
    80003c10:	e062                	sd	s8,0(sp)
    int i = 0;
    80003c12:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003c14:	6b85                	lui	s7,0x1
    80003c16:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003c1a:	6c05                	lui	s8,0x1
    80003c1c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003c20:	a851                	j	80003cb4 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003c22:	6908                	ld	a0,16(a0)
    80003c24:	00000097          	auipc	ra,0x0
    80003c28:	248080e7          	jalr	584(ra) # 80003e6c <pipewrite>
    80003c2c:	a85d                	j	80003ce2 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003c2e:	02451783          	lh	a5,36(a0)
    80003c32:	03079693          	slli	a3,a5,0x30
    80003c36:	92c1                	srli	a3,a3,0x30
    80003c38:	4725                	li	a4,9
    80003c3a:	0cd76a63          	bltu	a4,a3,80003d0e <filewrite+0x13a>
    80003c3e:	0792                	slli	a5,a5,0x4
    80003c40:	00015717          	auipc	a4,0x15
    80003c44:	48870713          	addi	a4,a4,1160 # 800190c8 <devsw>
    80003c48:	97ba                	add	a5,a5,a4
    80003c4a:	679c                	ld	a5,8(a5)
    80003c4c:	c3f9                	beqz	a5,80003d12 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003c4e:	4505                	li	a0,1
    80003c50:	9782                	jalr	a5
    80003c52:	a841                	j	80003ce2 <filewrite+0x10e>
      if(n1 > max)
    80003c54:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003c58:	00000097          	auipc	ra,0x0
    80003c5c:	88c080e7          	jalr	-1908(ra) # 800034e4 <begin_op>
      ilock(f->ip);
    80003c60:	01893503          	ld	a0,24(s2)
    80003c64:	fffff097          	auipc	ra,0xfffff
    80003c68:	eae080e7          	jalr	-338(ra) # 80002b12 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003c6c:	8756                	mv	a4,s5
    80003c6e:	02092683          	lw	a3,32(s2)
    80003c72:	01698633          	add	a2,s3,s6
    80003c76:	4585                	li	a1,1
    80003c78:	01893503          	ld	a0,24(s2)
    80003c7c:	fffff097          	auipc	ra,0xfffff
    80003c80:	252080e7          	jalr	594(ra) # 80002ece <writei>
    80003c84:	84aa                	mv	s1,a0
    80003c86:	00a05763          	blez	a0,80003c94 <filewrite+0xc0>
        f->off += r;
    80003c8a:	02092783          	lw	a5,32(s2)
    80003c8e:	9fa9                	addw	a5,a5,a0
    80003c90:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003c94:	01893503          	ld	a0,24(s2)
    80003c98:	fffff097          	auipc	ra,0xfffff
    80003c9c:	f40080e7          	jalr	-192(ra) # 80002bd8 <iunlock>
      end_op();
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	8be080e7          	jalr	-1858(ra) # 8000355e <end_op>

      if(r != n1){
    80003ca8:	029a9563          	bne	s5,s1,80003cd2 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003cac:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003cb0:	0149da63          	bge	s3,s4,80003cc4 <filewrite+0xf0>
      int n1 = n - i;
    80003cb4:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003cb8:	0004879b          	sext.w	a5,s1
    80003cbc:	f8fbdce3          	bge	s7,a5,80003c54 <filewrite+0x80>
    80003cc0:	84e2                	mv	s1,s8
    80003cc2:	bf49                	j	80003c54 <filewrite+0x80>
    80003cc4:	74e2                	ld	s1,56(sp)
    80003cc6:	6ae2                	ld	s5,24(sp)
    80003cc8:	6ba2                	ld	s7,8(sp)
    80003cca:	6c02                	ld	s8,0(sp)
    80003ccc:	a039                	j	80003cda <filewrite+0x106>
    int i = 0;
    80003cce:	4981                	li	s3,0
    80003cd0:	a029                	j	80003cda <filewrite+0x106>
    80003cd2:	74e2                	ld	s1,56(sp)
    80003cd4:	6ae2                	ld	s5,24(sp)
    80003cd6:	6ba2                	ld	s7,8(sp)
    80003cd8:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003cda:	033a1e63          	bne	s4,s3,80003d16 <filewrite+0x142>
    80003cde:	8552                	mv	a0,s4
    80003ce0:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003ce2:	60a6                	ld	ra,72(sp)
    80003ce4:	6406                	ld	s0,64(sp)
    80003ce6:	7942                	ld	s2,48(sp)
    80003ce8:	7a02                	ld	s4,32(sp)
    80003cea:	6b42                	ld	s6,16(sp)
    80003cec:	6161                	addi	sp,sp,80
    80003cee:	8082                	ret
    80003cf0:	fc26                	sd	s1,56(sp)
    80003cf2:	f44e                	sd	s3,40(sp)
    80003cf4:	ec56                	sd	s5,24(sp)
    80003cf6:	e45e                	sd	s7,8(sp)
    80003cf8:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003cfa:	00005517          	auipc	a0,0x5
    80003cfe:	8f650513          	addi	a0,a0,-1802 # 800085f0 <etext+0x5f0>
    80003d02:	00002097          	auipc	ra,0x2
    80003d06:	f7a080e7          	jalr	-134(ra) # 80005c7c <panic>
    return -1;
    80003d0a:	557d                	li	a0,-1
}
    80003d0c:	8082                	ret
      return -1;
    80003d0e:	557d                	li	a0,-1
    80003d10:	bfc9                	j	80003ce2 <filewrite+0x10e>
    80003d12:	557d                	li	a0,-1
    80003d14:	b7f9                	j	80003ce2 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003d16:	557d                	li	a0,-1
    80003d18:	79a2                	ld	s3,40(sp)
    80003d1a:	b7e1                	j	80003ce2 <filewrite+0x10e>

0000000080003d1c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d1c:	7179                	addi	sp,sp,-48
    80003d1e:	f406                	sd	ra,40(sp)
    80003d20:	f022                	sd	s0,32(sp)
    80003d22:	ec26                	sd	s1,24(sp)
    80003d24:	e052                	sd	s4,0(sp)
    80003d26:	1800                	addi	s0,sp,48
    80003d28:	84aa                	mv	s1,a0
    80003d2a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003d2c:	0005b023          	sd	zero,0(a1)
    80003d30:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003d34:	00000097          	auipc	ra,0x0
    80003d38:	bbe080e7          	jalr	-1090(ra) # 800038f2 <filealloc>
    80003d3c:	e088                	sd	a0,0(s1)
    80003d3e:	cd49                	beqz	a0,80003dd8 <pipealloc+0xbc>
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	bb2080e7          	jalr	-1102(ra) # 800038f2 <filealloc>
    80003d48:	00aa3023          	sd	a0,0(s4)
    80003d4c:	c141                	beqz	a0,80003dcc <pipealloc+0xb0>
    80003d4e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003d50:	ffffc097          	auipc	ra,0xffffc
    80003d54:	3ca080e7          	jalr	970(ra) # 8000011a <kalloc>
    80003d58:	892a                	mv	s2,a0
    80003d5a:	c13d                	beqz	a0,80003dc0 <pipealloc+0xa4>
    80003d5c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003d5e:	4985                	li	s3,1
    80003d60:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003d64:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003d68:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003d6c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003d70:	00004597          	auipc	a1,0x4
    80003d74:	64058593          	addi	a1,a1,1600 # 800083b0 <etext+0x3b0>
    80003d78:	00002097          	auipc	ra,0x2
    80003d7c:	3ee080e7          	jalr	1006(ra) # 80006166 <initlock>
  (*f0)->type = FD_PIPE;
    80003d80:	609c                	ld	a5,0(s1)
    80003d82:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003d86:	609c                	ld	a5,0(s1)
    80003d88:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003d8c:	609c                	ld	a5,0(s1)
    80003d8e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003d92:	609c                	ld	a5,0(s1)
    80003d94:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003d98:	000a3783          	ld	a5,0(s4)
    80003d9c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003da0:	000a3783          	ld	a5,0(s4)
    80003da4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003da8:	000a3783          	ld	a5,0(s4)
    80003dac:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003db0:	000a3783          	ld	a5,0(s4)
    80003db4:	0127b823          	sd	s2,16(a5)
  return 0;
    80003db8:	4501                	li	a0,0
    80003dba:	6942                	ld	s2,16(sp)
    80003dbc:	69a2                	ld	s3,8(sp)
    80003dbe:	a03d                	j	80003dec <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003dc0:	6088                	ld	a0,0(s1)
    80003dc2:	c119                	beqz	a0,80003dc8 <pipealloc+0xac>
    80003dc4:	6942                	ld	s2,16(sp)
    80003dc6:	a029                	j	80003dd0 <pipealloc+0xb4>
    80003dc8:	6942                	ld	s2,16(sp)
    80003dca:	a039                	j	80003dd8 <pipealloc+0xbc>
    80003dcc:	6088                	ld	a0,0(s1)
    80003dce:	c50d                	beqz	a0,80003df8 <pipealloc+0xdc>
    fileclose(*f0);
    80003dd0:	00000097          	auipc	ra,0x0
    80003dd4:	bde080e7          	jalr	-1058(ra) # 800039ae <fileclose>
  if(*f1)
    80003dd8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ddc:	557d                	li	a0,-1
  if(*f1)
    80003dde:	c799                	beqz	a5,80003dec <pipealloc+0xd0>
    fileclose(*f1);
    80003de0:	853e                	mv	a0,a5
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	bcc080e7          	jalr	-1076(ra) # 800039ae <fileclose>
  return -1;
    80003dea:	557d                	li	a0,-1
}
    80003dec:	70a2                	ld	ra,40(sp)
    80003dee:	7402                	ld	s0,32(sp)
    80003df0:	64e2                	ld	s1,24(sp)
    80003df2:	6a02                	ld	s4,0(sp)
    80003df4:	6145                	addi	sp,sp,48
    80003df6:	8082                	ret
  return -1;
    80003df8:	557d                	li	a0,-1
    80003dfa:	bfcd                	j	80003dec <pipealloc+0xd0>

0000000080003dfc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003dfc:	1101                	addi	sp,sp,-32
    80003dfe:	ec06                	sd	ra,24(sp)
    80003e00:	e822                	sd	s0,16(sp)
    80003e02:	e426                	sd	s1,8(sp)
    80003e04:	e04a                	sd	s2,0(sp)
    80003e06:	1000                	addi	s0,sp,32
    80003e08:	84aa                	mv	s1,a0
    80003e0a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e0c:	00002097          	auipc	ra,0x2
    80003e10:	3ea080e7          	jalr	1002(ra) # 800061f6 <acquire>
  if(writable){
    80003e14:	02090d63          	beqz	s2,80003e4e <pipeclose+0x52>
    pi->writeopen = 0;
    80003e18:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e1c:	21848513          	addi	a0,s1,536
    80003e20:	ffffe097          	auipc	ra,0xffffe
    80003e24:	8b6080e7          	jalr	-1866(ra) # 800016d6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e28:	2204b783          	ld	a5,544(s1)
    80003e2c:	eb95                	bnez	a5,80003e60 <pipeclose+0x64>
    release(&pi->lock);
    80003e2e:	8526                	mv	a0,s1
    80003e30:	00002097          	auipc	ra,0x2
    80003e34:	47a080e7          	jalr	1146(ra) # 800062aa <release>
    kfree((char*)pi);
    80003e38:	8526                	mv	a0,s1
    80003e3a:	ffffc097          	auipc	ra,0xffffc
    80003e3e:	1e2080e7          	jalr	482(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003e42:	60e2                	ld	ra,24(sp)
    80003e44:	6442                	ld	s0,16(sp)
    80003e46:	64a2                	ld	s1,8(sp)
    80003e48:	6902                	ld	s2,0(sp)
    80003e4a:	6105                	addi	sp,sp,32
    80003e4c:	8082                	ret
    pi->readopen = 0;
    80003e4e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003e52:	21c48513          	addi	a0,s1,540
    80003e56:	ffffe097          	auipc	ra,0xffffe
    80003e5a:	880080e7          	jalr	-1920(ra) # 800016d6 <wakeup>
    80003e5e:	b7e9                	j	80003e28 <pipeclose+0x2c>
    release(&pi->lock);
    80003e60:	8526                	mv	a0,s1
    80003e62:	00002097          	auipc	ra,0x2
    80003e66:	448080e7          	jalr	1096(ra) # 800062aa <release>
}
    80003e6a:	bfe1                	j	80003e42 <pipeclose+0x46>

0000000080003e6c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003e6c:	711d                	addi	sp,sp,-96
    80003e6e:	ec86                	sd	ra,88(sp)
    80003e70:	e8a2                	sd	s0,80(sp)
    80003e72:	e4a6                	sd	s1,72(sp)
    80003e74:	e0ca                	sd	s2,64(sp)
    80003e76:	fc4e                	sd	s3,56(sp)
    80003e78:	f852                	sd	s4,48(sp)
    80003e7a:	f456                	sd	s5,40(sp)
    80003e7c:	1080                	addi	s0,sp,96
    80003e7e:	84aa                	mv	s1,a0
    80003e80:	8aae                	mv	s5,a1
    80003e82:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003e84:	ffffd097          	auipc	ra,0xffffd
    80003e88:	ff8080e7          	jalr	-8(ra) # 80000e7c <myproc>
    80003e8c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003e8e:	8526                	mv	a0,s1
    80003e90:	00002097          	auipc	ra,0x2
    80003e94:	366080e7          	jalr	870(ra) # 800061f6 <acquire>
  while(i < n){
    80003e98:	0d405563          	blez	s4,80003f62 <pipewrite+0xf6>
    80003e9c:	f05a                	sd	s6,32(sp)
    80003e9e:	ec5e                	sd	s7,24(sp)
    80003ea0:	e862                	sd	s8,16(sp)
  int i = 0;
    80003ea2:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ea4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003ea6:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003eaa:	21c48b93          	addi	s7,s1,540
    80003eae:	a089                	j	80003ef0 <pipewrite+0x84>
      release(&pi->lock);
    80003eb0:	8526                	mv	a0,s1
    80003eb2:	00002097          	auipc	ra,0x2
    80003eb6:	3f8080e7          	jalr	1016(ra) # 800062aa <release>
      return -1;
    80003eba:	597d                	li	s2,-1
    80003ebc:	7b02                	ld	s6,32(sp)
    80003ebe:	6be2                	ld	s7,24(sp)
    80003ec0:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003ec2:	854a                	mv	a0,s2
    80003ec4:	60e6                	ld	ra,88(sp)
    80003ec6:	6446                	ld	s0,80(sp)
    80003ec8:	64a6                	ld	s1,72(sp)
    80003eca:	6906                	ld	s2,64(sp)
    80003ecc:	79e2                	ld	s3,56(sp)
    80003ece:	7a42                	ld	s4,48(sp)
    80003ed0:	7aa2                	ld	s5,40(sp)
    80003ed2:	6125                	addi	sp,sp,96
    80003ed4:	8082                	ret
      wakeup(&pi->nread);
    80003ed6:	8562                	mv	a0,s8
    80003ed8:	ffffd097          	auipc	ra,0xffffd
    80003edc:	7fe080e7          	jalr	2046(ra) # 800016d6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ee0:	85a6                	mv	a1,s1
    80003ee2:	855e                	mv	a0,s7
    80003ee4:	ffffd097          	auipc	ra,0xffffd
    80003ee8:	666080e7          	jalr	1638(ra) # 8000154a <sleep>
  while(i < n){
    80003eec:	05495c63          	bge	s2,s4,80003f44 <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80003ef0:	2204a783          	lw	a5,544(s1)
    80003ef4:	dfd5                	beqz	a5,80003eb0 <pipewrite+0x44>
    80003ef6:	0289a783          	lw	a5,40(s3)
    80003efa:	fbdd                	bnez	a5,80003eb0 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003efc:	2184a783          	lw	a5,536(s1)
    80003f00:	21c4a703          	lw	a4,540(s1)
    80003f04:	2007879b          	addiw	a5,a5,512
    80003f08:	fcf707e3          	beq	a4,a5,80003ed6 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f0c:	4685                	li	a3,1
    80003f0e:	01590633          	add	a2,s2,s5
    80003f12:	faf40593          	addi	a1,s0,-81
    80003f16:	0509b503          	ld	a0,80(s3)
    80003f1a:	ffffd097          	auipc	ra,0xffffd
    80003f1e:	c8a080e7          	jalr	-886(ra) # 80000ba4 <copyin>
    80003f22:	05650263          	beq	a0,s6,80003f66 <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f26:	21c4a783          	lw	a5,540(s1)
    80003f2a:	0017871b          	addiw	a4,a5,1
    80003f2e:	20e4ae23          	sw	a4,540(s1)
    80003f32:	1ff7f793          	andi	a5,a5,511
    80003f36:	97a6                	add	a5,a5,s1
    80003f38:	faf44703          	lbu	a4,-81(s0)
    80003f3c:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f40:	2905                	addiw	s2,s2,1
    80003f42:	b76d                	j	80003eec <pipewrite+0x80>
    80003f44:	7b02                	ld	s6,32(sp)
    80003f46:	6be2                	ld	s7,24(sp)
    80003f48:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003f4a:	21848513          	addi	a0,s1,536
    80003f4e:	ffffd097          	auipc	ra,0xffffd
    80003f52:	788080e7          	jalr	1928(ra) # 800016d6 <wakeup>
  release(&pi->lock);
    80003f56:	8526                	mv	a0,s1
    80003f58:	00002097          	auipc	ra,0x2
    80003f5c:	352080e7          	jalr	850(ra) # 800062aa <release>
  return i;
    80003f60:	b78d                	j	80003ec2 <pipewrite+0x56>
  int i = 0;
    80003f62:	4901                	li	s2,0
    80003f64:	b7dd                	j	80003f4a <pipewrite+0xde>
    80003f66:	7b02                	ld	s6,32(sp)
    80003f68:	6be2                	ld	s7,24(sp)
    80003f6a:	6c42                	ld	s8,16(sp)
    80003f6c:	bff9                	j	80003f4a <pipewrite+0xde>

0000000080003f6e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003f6e:	715d                	addi	sp,sp,-80
    80003f70:	e486                	sd	ra,72(sp)
    80003f72:	e0a2                	sd	s0,64(sp)
    80003f74:	fc26                	sd	s1,56(sp)
    80003f76:	f84a                	sd	s2,48(sp)
    80003f78:	f44e                	sd	s3,40(sp)
    80003f7a:	f052                	sd	s4,32(sp)
    80003f7c:	ec56                	sd	s5,24(sp)
    80003f7e:	0880                	addi	s0,sp,80
    80003f80:	84aa                	mv	s1,a0
    80003f82:	892e                	mv	s2,a1
    80003f84:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003f86:	ffffd097          	auipc	ra,0xffffd
    80003f8a:	ef6080e7          	jalr	-266(ra) # 80000e7c <myproc>
    80003f8e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003f90:	8526                	mv	a0,s1
    80003f92:	00002097          	auipc	ra,0x2
    80003f96:	264080e7          	jalr	612(ra) # 800061f6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003f9a:	2184a703          	lw	a4,536(s1)
    80003f9e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fa2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fa6:	02f71663          	bne	a4,a5,80003fd2 <piperead+0x64>
    80003faa:	2244a783          	lw	a5,548(s1)
    80003fae:	cb9d                	beqz	a5,80003fe4 <piperead+0x76>
    if(pr->killed){
    80003fb0:	028a2783          	lw	a5,40(s4)
    80003fb4:	e38d                	bnez	a5,80003fd6 <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003fb6:	85a6                	mv	a1,s1
    80003fb8:	854e                	mv	a0,s3
    80003fba:	ffffd097          	auipc	ra,0xffffd
    80003fbe:	590080e7          	jalr	1424(ra) # 8000154a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fc2:	2184a703          	lw	a4,536(s1)
    80003fc6:	21c4a783          	lw	a5,540(s1)
    80003fca:	fef700e3          	beq	a4,a5,80003faa <piperead+0x3c>
    80003fce:	e85a                	sd	s6,16(sp)
    80003fd0:	a819                	j	80003fe6 <piperead+0x78>
    80003fd2:	e85a                	sd	s6,16(sp)
    80003fd4:	a809                	j	80003fe6 <piperead+0x78>
      release(&pi->lock);
    80003fd6:	8526                	mv	a0,s1
    80003fd8:	00002097          	auipc	ra,0x2
    80003fdc:	2d2080e7          	jalr	722(ra) # 800062aa <release>
      return -1;
    80003fe0:	59fd                	li	s3,-1
    80003fe2:	a0a5                	j	8000404a <piperead+0xdc>
    80003fe4:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fe6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003fe8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003fea:	05505463          	blez	s5,80004032 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80003fee:	2184a783          	lw	a5,536(s1)
    80003ff2:	21c4a703          	lw	a4,540(s1)
    80003ff6:	02f70e63          	beq	a4,a5,80004032 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ffa:	0017871b          	addiw	a4,a5,1
    80003ffe:	20e4ac23          	sw	a4,536(s1)
    80004002:	1ff7f793          	andi	a5,a5,511
    80004006:	97a6                	add	a5,a5,s1
    80004008:	0187c783          	lbu	a5,24(a5)
    8000400c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004010:	4685                	li	a3,1
    80004012:	fbf40613          	addi	a2,s0,-65
    80004016:	85ca                	mv	a1,s2
    80004018:	050a3503          	ld	a0,80(s4)
    8000401c:	ffffd097          	auipc	ra,0xffffd
    80004020:	afc080e7          	jalr	-1284(ra) # 80000b18 <copyout>
    80004024:	01650763          	beq	a0,s6,80004032 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004028:	2985                	addiw	s3,s3,1
    8000402a:	0905                	addi	s2,s2,1
    8000402c:	fd3a91e3          	bne	s5,s3,80003fee <piperead+0x80>
    80004030:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004032:	21c48513          	addi	a0,s1,540
    80004036:	ffffd097          	auipc	ra,0xffffd
    8000403a:	6a0080e7          	jalr	1696(ra) # 800016d6 <wakeup>
  release(&pi->lock);
    8000403e:	8526                	mv	a0,s1
    80004040:	00002097          	auipc	ra,0x2
    80004044:	26a080e7          	jalr	618(ra) # 800062aa <release>
    80004048:	6b42                	ld	s6,16(sp)
  return i;
}
    8000404a:	854e                	mv	a0,s3
    8000404c:	60a6                	ld	ra,72(sp)
    8000404e:	6406                	ld	s0,64(sp)
    80004050:	74e2                	ld	s1,56(sp)
    80004052:	7942                	ld	s2,48(sp)
    80004054:	79a2                	ld	s3,40(sp)
    80004056:	7a02                	ld	s4,32(sp)
    80004058:	6ae2                	ld	s5,24(sp)
    8000405a:	6161                	addi	sp,sp,80
    8000405c:	8082                	ret

000000008000405e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    8000405e:	df010113          	addi	sp,sp,-528
    80004062:	20113423          	sd	ra,520(sp)
    80004066:	20813023          	sd	s0,512(sp)
    8000406a:	ffa6                	sd	s1,504(sp)
    8000406c:	fbca                	sd	s2,496(sp)
    8000406e:	0c00                	addi	s0,sp,528
    80004070:	892a                	mv	s2,a0
    80004072:	dea43c23          	sd	a0,-520(s0)
    80004076:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000407a:	ffffd097          	auipc	ra,0xffffd
    8000407e:	e02080e7          	jalr	-510(ra) # 80000e7c <myproc>
    80004082:	84aa                	mv	s1,a0

  begin_op();
    80004084:	fffff097          	auipc	ra,0xfffff
    80004088:	460080e7          	jalr	1120(ra) # 800034e4 <begin_op>

  if((ip = namei(path)) == 0){
    8000408c:	854a                	mv	a0,s2
    8000408e:	fffff097          	auipc	ra,0xfffff
    80004092:	256080e7          	jalr	598(ra) # 800032e4 <namei>
    80004096:	c135                	beqz	a0,800040fa <exec+0x9c>
    80004098:	f3d2                	sd	s4,480(sp)
    8000409a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000409c:	fffff097          	auipc	ra,0xfffff
    800040a0:	a76080e7          	jalr	-1418(ra) # 80002b12 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800040a4:	04000713          	li	a4,64
    800040a8:	4681                	li	a3,0
    800040aa:	e5040613          	addi	a2,s0,-432
    800040ae:	4581                	li	a1,0
    800040b0:	8552                	mv	a0,s4
    800040b2:	fffff097          	auipc	ra,0xfffff
    800040b6:	d18080e7          	jalr	-744(ra) # 80002dca <readi>
    800040ba:	04000793          	li	a5,64
    800040be:	00f51a63          	bne	a0,a5,800040d2 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800040c2:	e5042703          	lw	a4,-432(s0)
    800040c6:	464c47b7          	lui	a5,0x464c4
    800040ca:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800040ce:	02f70c63          	beq	a4,a5,80004106 <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800040d2:	8552                	mv	a0,s4
    800040d4:	fffff097          	auipc	ra,0xfffff
    800040d8:	ca4080e7          	jalr	-860(ra) # 80002d78 <iunlockput>
    end_op();
    800040dc:	fffff097          	auipc	ra,0xfffff
    800040e0:	482080e7          	jalr	1154(ra) # 8000355e <end_op>
  }
  return -1;
    800040e4:	557d                	li	a0,-1
    800040e6:	7a1e                	ld	s4,480(sp)
}
    800040e8:	20813083          	ld	ra,520(sp)
    800040ec:	20013403          	ld	s0,512(sp)
    800040f0:	74fe                	ld	s1,504(sp)
    800040f2:	795e                	ld	s2,496(sp)
    800040f4:	21010113          	addi	sp,sp,528
    800040f8:	8082                	ret
    end_op();
    800040fa:	fffff097          	auipc	ra,0xfffff
    800040fe:	464080e7          	jalr	1124(ra) # 8000355e <end_op>
    return -1;
    80004102:	557d                	li	a0,-1
    80004104:	b7d5                	j	800040e8 <exec+0x8a>
    80004106:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004108:	8526                	mv	a0,s1
    8000410a:	ffffd097          	auipc	ra,0xffffd
    8000410e:	e36080e7          	jalr	-458(ra) # 80000f40 <proc_pagetable>
    80004112:	8b2a                	mv	s6,a0
    80004114:	30050563          	beqz	a0,8000441e <exec+0x3c0>
    80004118:	f7ce                	sd	s3,488(sp)
    8000411a:	efd6                	sd	s5,472(sp)
    8000411c:	e7de                	sd	s7,456(sp)
    8000411e:	e3e2                	sd	s8,448(sp)
    80004120:	ff66                	sd	s9,440(sp)
    80004122:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004124:	e7042d03          	lw	s10,-400(s0)
    80004128:	e8845783          	lhu	a5,-376(s0)
    8000412c:	14078563          	beqz	a5,80004276 <exec+0x218>
    80004130:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004132:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004134:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    80004136:	6c85                	lui	s9,0x1
    80004138:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000413c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004140:	6a85                	lui	s5,0x1
    80004142:	a0b5                	j	800041ae <exec+0x150>
      panic("loadseg: address should exist");
    80004144:	00004517          	auipc	a0,0x4
    80004148:	4bc50513          	addi	a0,a0,1212 # 80008600 <etext+0x600>
    8000414c:	00002097          	auipc	ra,0x2
    80004150:	b30080e7          	jalr	-1232(ra) # 80005c7c <panic>
    if(sz - i < PGSIZE)
    80004154:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004156:	8726                	mv	a4,s1
    80004158:	012c06bb          	addw	a3,s8,s2
    8000415c:	4581                	li	a1,0
    8000415e:	8552                	mv	a0,s4
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	c6a080e7          	jalr	-918(ra) # 80002dca <readi>
    80004168:	2501                	sext.w	a0,a0
    8000416a:	26a49e63          	bne	s1,a0,800043e6 <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    8000416e:	012a893b          	addw	s2,s5,s2
    80004172:	03397563          	bgeu	s2,s3,8000419c <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    80004176:	02091593          	slli	a1,s2,0x20
    8000417a:	9181                	srli	a1,a1,0x20
    8000417c:	95de                	add	a1,a1,s7
    8000417e:	855a                	mv	a0,s6
    80004180:	ffffc097          	auipc	ra,0xffffc
    80004184:	378080e7          	jalr	888(ra) # 800004f8 <walkaddr>
    80004188:	862a                	mv	a2,a0
    if(pa == 0)
    8000418a:	dd4d                	beqz	a0,80004144 <exec+0xe6>
    if(sz - i < PGSIZE)
    8000418c:	412984bb          	subw	s1,s3,s2
    80004190:	0004879b          	sext.w	a5,s1
    80004194:	fcfcf0e3          	bgeu	s9,a5,80004154 <exec+0xf6>
    80004198:	84d6                	mv	s1,s5
    8000419a:	bf6d                	j	80004154 <exec+0xf6>
    sz = sz1;
    8000419c:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a0:	2d85                	addiw	s11,s11,1
    800041a2:	038d0d1b          	addiw	s10,s10,56
    800041a6:	e8845783          	lhu	a5,-376(s0)
    800041aa:	06fddf63          	bge	s11,a5,80004228 <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041ae:	2d01                	sext.w	s10,s10
    800041b0:	03800713          	li	a4,56
    800041b4:	86ea                	mv	a3,s10
    800041b6:	e1840613          	addi	a2,s0,-488
    800041ba:	4581                	li	a1,0
    800041bc:	8552                	mv	a0,s4
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	c0c080e7          	jalr	-1012(ra) # 80002dca <readi>
    800041c6:	03800793          	li	a5,56
    800041ca:	1ef51863          	bne	a0,a5,800043ba <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    800041ce:	e1842783          	lw	a5,-488(s0)
    800041d2:	4705                	li	a4,1
    800041d4:	fce796e3          	bne	a5,a4,800041a0 <exec+0x142>
    if(ph.memsz < ph.filesz)
    800041d8:	e4043603          	ld	a2,-448(s0)
    800041dc:	e3843783          	ld	a5,-456(s0)
    800041e0:	1ef66163          	bltu	a2,a5,800043c2 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800041e4:	e2843783          	ld	a5,-472(s0)
    800041e8:	963e                	add	a2,a2,a5
    800041ea:	1ef66063          	bltu	a2,a5,800043ca <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800041ee:	85a6                	mv	a1,s1
    800041f0:	855a                	mv	a0,s6
    800041f2:	ffffc097          	auipc	ra,0xffffc
    800041f6:	6ca080e7          	jalr	1738(ra) # 800008bc <uvmalloc>
    800041fa:	e0a43423          	sd	a0,-504(s0)
    800041fe:	1c050a63          	beqz	a0,800043d2 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004202:	e2843b83          	ld	s7,-472(s0)
    80004206:	df043783          	ld	a5,-528(s0)
    8000420a:	00fbf7b3          	and	a5,s7,a5
    8000420e:	1c079a63          	bnez	a5,800043e2 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004212:	e2042c03          	lw	s8,-480(s0)
    80004216:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000421a:	00098463          	beqz	s3,80004222 <exec+0x1c4>
    8000421e:	4901                	li	s2,0
    80004220:	bf99                	j	80004176 <exec+0x118>
    sz = sz1;
    80004222:	e0843483          	ld	s1,-504(s0)
    80004226:	bfad                	j	800041a0 <exec+0x142>
    80004228:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    8000422a:	8552                	mv	a0,s4
    8000422c:	fffff097          	auipc	ra,0xfffff
    80004230:	b4c080e7          	jalr	-1204(ra) # 80002d78 <iunlockput>
  end_op();
    80004234:	fffff097          	auipc	ra,0xfffff
    80004238:	32a080e7          	jalr	810(ra) # 8000355e <end_op>
  p = myproc();
    8000423c:	ffffd097          	auipc	ra,0xffffd
    80004240:	c40080e7          	jalr	-960(ra) # 80000e7c <myproc>
    80004244:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004246:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    8000424a:	6985                	lui	s3,0x1
    8000424c:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    8000424e:	99a6                	add	s3,s3,s1
    80004250:	77fd                	lui	a5,0xfffff
    80004252:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004256:	6609                	lui	a2,0x2
    80004258:	964e                	add	a2,a2,s3
    8000425a:	85ce                	mv	a1,s3
    8000425c:	855a                	mv	a0,s6
    8000425e:	ffffc097          	auipc	ra,0xffffc
    80004262:	65e080e7          	jalr	1630(ra) # 800008bc <uvmalloc>
    80004266:	892a                	mv	s2,a0
    80004268:	e0a43423          	sd	a0,-504(s0)
    8000426c:	e519                	bnez	a0,8000427a <exec+0x21c>
  if(pagetable)
    8000426e:	e1343423          	sd	s3,-504(s0)
    80004272:	4a01                	li	s4,0
    80004274:	aa95                	j	800043e8 <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004276:	4481                	li	s1,0
    80004278:	bf4d                	j	8000422a <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000427a:	75f9                	lui	a1,0xffffe
    8000427c:	95aa                	add	a1,a1,a0
    8000427e:	855a                	mv	a0,s6
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	866080e7          	jalr	-1946(ra) # 80000ae6 <uvmclear>
  stackbase = sp - PGSIZE;
    80004288:	7bfd                	lui	s7,0xfffff
    8000428a:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000428c:	e0043783          	ld	a5,-512(s0)
    80004290:	6388                	ld	a0,0(a5)
    80004292:	c52d                	beqz	a0,800042fc <exec+0x29e>
    80004294:	e9040993          	addi	s3,s0,-368
    80004298:	f9040c13          	addi	s8,s0,-112
    8000429c:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000429e:	ffffc097          	auipc	ra,0xffffc
    800042a2:	050080e7          	jalr	80(ra) # 800002ee <strlen>
    800042a6:	0015079b          	addiw	a5,a0,1
    800042aa:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042ae:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042b2:	13796463          	bltu	s2,s7,800043da <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042b6:	e0043d03          	ld	s10,-512(s0)
    800042ba:	000d3a03          	ld	s4,0(s10)
    800042be:	8552                	mv	a0,s4
    800042c0:	ffffc097          	auipc	ra,0xffffc
    800042c4:	02e080e7          	jalr	46(ra) # 800002ee <strlen>
    800042c8:	0015069b          	addiw	a3,a0,1
    800042cc:	8652                	mv	a2,s4
    800042ce:	85ca                	mv	a1,s2
    800042d0:	855a                	mv	a0,s6
    800042d2:	ffffd097          	auipc	ra,0xffffd
    800042d6:	846080e7          	jalr	-1978(ra) # 80000b18 <copyout>
    800042da:	10054263          	bltz	a0,800043de <exec+0x380>
    ustack[argc] = sp;
    800042de:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042e2:	0485                	addi	s1,s1,1
    800042e4:	008d0793          	addi	a5,s10,8
    800042e8:	e0f43023          	sd	a5,-512(s0)
    800042ec:	008d3503          	ld	a0,8(s10)
    800042f0:	c909                	beqz	a0,80004302 <exec+0x2a4>
    if(argc >= MAXARG)
    800042f2:	09a1                	addi	s3,s3,8
    800042f4:	fb8995e3          	bne	s3,s8,8000429e <exec+0x240>
  ip = 0;
    800042f8:	4a01                	li	s4,0
    800042fa:	a0fd                	j	800043e8 <exec+0x38a>
  sp = sz;
    800042fc:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004300:	4481                	li	s1,0
  ustack[argc] = 0;
    80004302:	00349793          	slli	a5,s1,0x3
    80004306:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd8d50>
    8000430a:	97a2                	add	a5,a5,s0
    8000430c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004310:	00148693          	addi	a3,s1,1
    80004314:	068e                	slli	a3,a3,0x3
    80004316:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000431a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    8000431e:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004322:	f57966e3          	bltu	s2,s7,8000426e <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004326:	e9040613          	addi	a2,s0,-368
    8000432a:	85ca                	mv	a1,s2
    8000432c:	855a                	mv	a0,s6
    8000432e:	ffffc097          	auipc	ra,0xffffc
    80004332:	7ea080e7          	jalr	2026(ra) # 80000b18 <copyout>
    80004336:	0e054663          	bltz	a0,80004422 <exec+0x3c4>
  p->trapframe->a1 = sp;
    8000433a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000433e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004342:	df843783          	ld	a5,-520(s0)
    80004346:	0007c703          	lbu	a4,0(a5)
    8000434a:	cf11                	beqz	a4,80004366 <exec+0x308>
    8000434c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000434e:	02f00693          	li	a3,47
    80004352:	a039                	j	80004360 <exec+0x302>
      last = s+1;
    80004354:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004358:	0785                	addi	a5,a5,1
    8000435a:	fff7c703          	lbu	a4,-1(a5)
    8000435e:	c701                	beqz	a4,80004366 <exec+0x308>
    if(*s == '/')
    80004360:	fed71ce3          	bne	a4,a3,80004358 <exec+0x2fa>
    80004364:	bfc5                	j	80004354 <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004366:	4641                	li	a2,16
    80004368:	df843583          	ld	a1,-520(s0)
    8000436c:	158a8513          	addi	a0,s5,344
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	f4c080e7          	jalr	-180(ra) # 800002bc <safestrcpy>
  oldpagetable = p->pagetable;
    80004378:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000437c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004380:	e0843783          	ld	a5,-504(s0)
    80004384:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004388:	058ab783          	ld	a5,88(s5)
    8000438c:	e6843703          	ld	a4,-408(s0)
    80004390:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004392:	058ab783          	ld	a5,88(s5)
    80004396:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000439a:	85e6                	mv	a1,s9
    8000439c:	ffffd097          	auipc	ra,0xffffd
    800043a0:	c40080e7          	jalr	-960(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043a4:	0004851b          	sext.w	a0,s1
    800043a8:	79be                	ld	s3,488(sp)
    800043aa:	7a1e                	ld	s4,480(sp)
    800043ac:	6afe                	ld	s5,472(sp)
    800043ae:	6b5e                	ld	s6,464(sp)
    800043b0:	6bbe                	ld	s7,456(sp)
    800043b2:	6c1e                	ld	s8,448(sp)
    800043b4:	7cfa                	ld	s9,440(sp)
    800043b6:	7d5a                	ld	s10,432(sp)
    800043b8:	bb05                	j	800040e8 <exec+0x8a>
    800043ba:	e0943423          	sd	s1,-504(s0)
    800043be:	7dba                	ld	s11,424(sp)
    800043c0:	a025                	j	800043e8 <exec+0x38a>
    800043c2:	e0943423          	sd	s1,-504(s0)
    800043c6:	7dba                	ld	s11,424(sp)
    800043c8:	a005                	j	800043e8 <exec+0x38a>
    800043ca:	e0943423          	sd	s1,-504(s0)
    800043ce:	7dba                	ld	s11,424(sp)
    800043d0:	a821                	j	800043e8 <exec+0x38a>
    800043d2:	e0943423          	sd	s1,-504(s0)
    800043d6:	7dba                	ld	s11,424(sp)
    800043d8:	a801                	j	800043e8 <exec+0x38a>
  ip = 0;
    800043da:	4a01                	li	s4,0
    800043dc:	a031                	j	800043e8 <exec+0x38a>
    800043de:	4a01                	li	s4,0
  if(pagetable)
    800043e0:	a021                	j	800043e8 <exec+0x38a>
    800043e2:	7dba                	ld	s11,424(sp)
    800043e4:	a011                	j	800043e8 <exec+0x38a>
    800043e6:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    800043e8:	e0843583          	ld	a1,-504(s0)
    800043ec:	855a                	mv	a0,s6
    800043ee:	ffffd097          	auipc	ra,0xffffd
    800043f2:	bee080e7          	jalr	-1042(ra) # 80000fdc <proc_freepagetable>
  return -1;
    800043f6:	557d                	li	a0,-1
  if(ip){
    800043f8:	000a1b63          	bnez	s4,8000440e <exec+0x3b0>
    800043fc:	79be                	ld	s3,488(sp)
    800043fe:	7a1e                	ld	s4,480(sp)
    80004400:	6afe                	ld	s5,472(sp)
    80004402:	6b5e                	ld	s6,464(sp)
    80004404:	6bbe                	ld	s7,456(sp)
    80004406:	6c1e                	ld	s8,448(sp)
    80004408:	7cfa                	ld	s9,440(sp)
    8000440a:	7d5a                	ld	s10,432(sp)
    8000440c:	b9f1                	j	800040e8 <exec+0x8a>
    8000440e:	79be                	ld	s3,488(sp)
    80004410:	6afe                	ld	s5,472(sp)
    80004412:	6b5e                	ld	s6,464(sp)
    80004414:	6bbe                	ld	s7,456(sp)
    80004416:	6c1e                	ld	s8,448(sp)
    80004418:	7cfa                	ld	s9,440(sp)
    8000441a:	7d5a                	ld	s10,432(sp)
    8000441c:	b95d                	j	800040d2 <exec+0x74>
    8000441e:	6b5e                	ld	s6,464(sp)
    80004420:	b94d                	j	800040d2 <exec+0x74>
  sz = sz1;
    80004422:	e0843983          	ld	s3,-504(s0)
    80004426:	b5a1                	j	8000426e <exec+0x210>

0000000080004428 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004428:	7179                	addi	sp,sp,-48
    8000442a:	f406                	sd	ra,40(sp)
    8000442c:	f022                	sd	s0,32(sp)
    8000442e:	ec26                	sd	s1,24(sp)
    80004430:	e84a                	sd	s2,16(sp)
    80004432:	1800                	addi	s0,sp,48
    80004434:	892e                	mv	s2,a1
    80004436:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004438:	fdc40593          	addi	a1,s0,-36
    8000443c:	ffffe097          	auipc	ra,0xffffe
    80004440:	b08080e7          	jalr	-1272(ra) # 80001f44 <argint>
    80004444:	04054063          	bltz	a0,80004484 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004448:	fdc42703          	lw	a4,-36(s0)
    8000444c:	47bd                	li	a5,15
    8000444e:	02e7ed63          	bltu	a5,a4,80004488 <argfd+0x60>
    80004452:	ffffd097          	auipc	ra,0xffffd
    80004456:	a2a080e7          	jalr	-1494(ra) # 80000e7c <myproc>
    8000445a:	fdc42703          	lw	a4,-36(s0)
    8000445e:	01a70793          	addi	a5,a4,26
    80004462:	078e                	slli	a5,a5,0x3
    80004464:	953e                	add	a0,a0,a5
    80004466:	611c                	ld	a5,0(a0)
    80004468:	c395                	beqz	a5,8000448c <argfd+0x64>
    return -1;
  if(pfd)
    8000446a:	00090463          	beqz	s2,80004472 <argfd+0x4a>
    *pfd = fd;
    8000446e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004472:	4501                	li	a0,0
  if(pf)
    80004474:	c091                	beqz	s1,80004478 <argfd+0x50>
    *pf = f;
    80004476:	e09c                	sd	a5,0(s1)
}
    80004478:	70a2                	ld	ra,40(sp)
    8000447a:	7402                	ld	s0,32(sp)
    8000447c:	64e2                	ld	s1,24(sp)
    8000447e:	6942                	ld	s2,16(sp)
    80004480:	6145                	addi	sp,sp,48
    80004482:	8082                	ret
    return -1;
    80004484:	557d                	li	a0,-1
    80004486:	bfcd                	j	80004478 <argfd+0x50>
    return -1;
    80004488:	557d                	li	a0,-1
    8000448a:	b7fd                	j	80004478 <argfd+0x50>
    8000448c:	557d                	li	a0,-1
    8000448e:	b7ed                	j	80004478 <argfd+0x50>

0000000080004490 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004490:	1101                	addi	sp,sp,-32
    80004492:	ec06                	sd	ra,24(sp)
    80004494:	e822                	sd	s0,16(sp)
    80004496:	e426                	sd	s1,8(sp)
    80004498:	1000                	addi	s0,sp,32
    8000449a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000449c:	ffffd097          	auipc	ra,0xffffd
    800044a0:	9e0080e7          	jalr	-1568(ra) # 80000e7c <myproc>
    800044a4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044a6:	0d050793          	addi	a5,a0,208
    800044aa:	4501                	li	a0,0
    800044ac:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044ae:	6398                	ld	a4,0(a5)
    800044b0:	cb19                	beqz	a4,800044c6 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800044b2:	2505                	addiw	a0,a0,1
    800044b4:	07a1                	addi	a5,a5,8
    800044b6:	fed51ce3          	bne	a0,a3,800044ae <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044ba:	557d                	li	a0,-1
}
    800044bc:	60e2                	ld	ra,24(sp)
    800044be:	6442                	ld	s0,16(sp)
    800044c0:	64a2                	ld	s1,8(sp)
    800044c2:	6105                	addi	sp,sp,32
    800044c4:	8082                	ret
      p->ofile[fd] = f;
    800044c6:	01a50793          	addi	a5,a0,26
    800044ca:	078e                	slli	a5,a5,0x3
    800044cc:	963e                	add	a2,a2,a5
    800044ce:	e204                	sd	s1,0(a2)
      return fd;
    800044d0:	b7f5                	j	800044bc <fdalloc+0x2c>

00000000800044d2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044d2:	715d                	addi	sp,sp,-80
    800044d4:	e486                	sd	ra,72(sp)
    800044d6:	e0a2                	sd	s0,64(sp)
    800044d8:	fc26                	sd	s1,56(sp)
    800044da:	f84a                	sd	s2,48(sp)
    800044dc:	f44e                	sd	s3,40(sp)
    800044de:	f052                	sd	s4,32(sp)
    800044e0:	ec56                	sd	s5,24(sp)
    800044e2:	0880                	addi	s0,sp,80
    800044e4:	8aae                	mv	s5,a1
    800044e6:	8a32                	mv	s4,a2
    800044e8:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044ea:	fb040593          	addi	a1,s0,-80
    800044ee:	fffff097          	auipc	ra,0xfffff
    800044f2:	e14080e7          	jalr	-492(ra) # 80003302 <nameiparent>
    800044f6:	892a                	mv	s2,a0
    800044f8:	12050c63          	beqz	a0,80004630 <create+0x15e>
    return 0;

  ilock(dp);
    800044fc:	ffffe097          	auipc	ra,0xffffe
    80004500:	616080e7          	jalr	1558(ra) # 80002b12 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004504:	4601                	li	a2,0
    80004506:	fb040593          	addi	a1,s0,-80
    8000450a:	854a                	mv	a0,s2
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	b06080e7          	jalr	-1274(ra) # 80003012 <dirlookup>
    80004514:	84aa                	mv	s1,a0
    80004516:	c539                	beqz	a0,80004564 <create+0x92>
    iunlockput(dp);
    80004518:	854a                	mv	a0,s2
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	85e080e7          	jalr	-1954(ra) # 80002d78 <iunlockput>
    ilock(ip);
    80004522:	8526                	mv	a0,s1
    80004524:	ffffe097          	auipc	ra,0xffffe
    80004528:	5ee080e7          	jalr	1518(ra) # 80002b12 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000452c:	4789                	li	a5,2
    8000452e:	02fa9463          	bne	s5,a5,80004556 <create+0x84>
    80004532:	0444d783          	lhu	a5,68(s1)
    80004536:	37f9                	addiw	a5,a5,-2
    80004538:	17c2                	slli	a5,a5,0x30
    8000453a:	93c1                	srli	a5,a5,0x30
    8000453c:	4705                	li	a4,1
    8000453e:	00f76c63          	bltu	a4,a5,80004556 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004542:	8526                	mv	a0,s1
    80004544:	60a6                	ld	ra,72(sp)
    80004546:	6406                	ld	s0,64(sp)
    80004548:	74e2                	ld	s1,56(sp)
    8000454a:	7942                	ld	s2,48(sp)
    8000454c:	79a2                	ld	s3,40(sp)
    8000454e:	7a02                	ld	s4,32(sp)
    80004550:	6ae2                	ld	s5,24(sp)
    80004552:	6161                	addi	sp,sp,80
    80004554:	8082                	ret
    iunlockput(ip);
    80004556:	8526                	mv	a0,s1
    80004558:	fffff097          	auipc	ra,0xfffff
    8000455c:	820080e7          	jalr	-2016(ra) # 80002d78 <iunlockput>
    return 0;
    80004560:	4481                	li	s1,0
    80004562:	b7c5                	j	80004542 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    80004564:	85d6                	mv	a1,s5
    80004566:	00092503          	lw	a0,0(s2)
    8000456a:	ffffe097          	auipc	ra,0xffffe
    8000456e:	414080e7          	jalr	1044(ra) # 8000297e <ialloc>
    80004572:	84aa                	mv	s1,a0
    80004574:	c139                	beqz	a0,800045ba <create+0xe8>
  ilock(ip);
    80004576:	ffffe097          	auipc	ra,0xffffe
    8000457a:	59c080e7          	jalr	1436(ra) # 80002b12 <ilock>
  ip->major = major;
    8000457e:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004582:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004586:	4985                	li	s3,1
    80004588:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000458c:	8526                	mv	a0,s1
    8000458e:	ffffe097          	auipc	ra,0xffffe
    80004592:	4b8080e7          	jalr	1208(ra) # 80002a46 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004596:	033a8a63          	beq	s5,s3,800045ca <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000459a:	40d0                	lw	a2,4(s1)
    8000459c:	fb040593          	addi	a1,s0,-80
    800045a0:	854a                	mv	a0,s2
    800045a2:	fffff097          	auipc	ra,0xfffff
    800045a6:	c80080e7          	jalr	-896(ra) # 80003222 <dirlink>
    800045aa:	06054b63          	bltz	a0,80004620 <create+0x14e>
  iunlockput(dp);
    800045ae:	854a                	mv	a0,s2
    800045b0:	ffffe097          	auipc	ra,0xffffe
    800045b4:	7c8080e7          	jalr	1992(ra) # 80002d78 <iunlockput>
  return ip;
    800045b8:	b769                	j	80004542 <create+0x70>
    panic("create: ialloc");
    800045ba:	00004517          	auipc	a0,0x4
    800045be:	06650513          	addi	a0,a0,102 # 80008620 <etext+0x620>
    800045c2:	00001097          	auipc	ra,0x1
    800045c6:	6ba080e7          	jalr	1722(ra) # 80005c7c <panic>
    dp->nlink++;  // for ".."
    800045ca:	04a95783          	lhu	a5,74(s2)
    800045ce:	2785                	addiw	a5,a5,1
    800045d0:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800045d4:	854a                	mv	a0,s2
    800045d6:	ffffe097          	auipc	ra,0xffffe
    800045da:	470080e7          	jalr	1136(ra) # 80002a46 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045de:	40d0                	lw	a2,4(s1)
    800045e0:	00004597          	auipc	a1,0x4
    800045e4:	05058593          	addi	a1,a1,80 # 80008630 <etext+0x630>
    800045e8:	8526                	mv	a0,s1
    800045ea:	fffff097          	auipc	ra,0xfffff
    800045ee:	c38080e7          	jalr	-968(ra) # 80003222 <dirlink>
    800045f2:	00054f63          	bltz	a0,80004610 <create+0x13e>
    800045f6:	00492603          	lw	a2,4(s2)
    800045fa:	00004597          	auipc	a1,0x4
    800045fe:	03e58593          	addi	a1,a1,62 # 80008638 <etext+0x638>
    80004602:	8526                	mv	a0,s1
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	c1e080e7          	jalr	-994(ra) # 80003222 <dirlink>
    8000460c:	f80557e3          	bgez	a0,8000459a <create+0xc8>
      panic("create dots");
    80004610:	00004517          	auipc	a0,0x4
    80004614:	03050513          	addi	a0,a0,48 # 80008640 <etext+0x640>
    80004618:	00001097          	auipc	ra,0x1
    8000461c:	664080e7          	jalr	1636(ra) # 80005c7c <panic>
    panic("create: dirlink");
    80004620:	00004517          	auipc	a0,0x4
    80004624:	03050513          	addi	a0,a0,48 # 80008650 <etext+0x650>
    80004628:	00001097          	auipc	ra,0x1
    8000462c:	654080e7          	jalr	1620(ra) # 80005c7c <panic>
    return 0;
    80004630:	84aa                	mv	s1,a0
    80004632:	bf01                	j	80004542 <create+0x70>

0000000080004634 <sys_dup>:
{
    80004634:	7179                	addi	sp,sp,-48
    80004636:	f406                	sd	ra,40(sp)
    80004638:	f022                	sd	s0,32(sp)
    8000463a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000463c:	fd840613          	addi	a2,s0,-40
    80004640:	4581                	li	a1,0
    80004642:	4501                	li	a0,0
    80004644:	00000097          	auipc	ra,0x0
    80004648:	de4080e7          	jalr	-540(ra) # 80004428 <argfd>
    return -1;
    8000464c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000464e:	02054763          	bltz	a0,8000467c <sys_dup+0x48>
    80004652:	ec26                	sd	s1,24(sp)
    80004654:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004656:	fd843903          	ld	s2,-40(s0)
    8000465a:	854a                	mv	a0,s2
    8000465c:	00000097          	auipc	ra,0x0
    80004660:	e34080e7          	jalr	-460(ra) # 80004490 <fdalloc>
    80004664:	84aa                	mv	s1,a0
    return -1;
    80004666:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004668:	00054f63          	bltz	a0,80004686 <sys_dup+0x52>
  filedup(f);
    8000466c:	854a                	mv	a0,s2
    8000466e:	fffff097          	auipc	ra,0xfffff
    80004672:	2ee080e7          	jalr	750(ra) # 8000395c <filedup>
  return fd;
    80004676:	87a6                	mv	a5,s1
    80004678:	64e2                	ld	s1,24(sp)
    8000467a:	6942                	ld	s2,16(sp)
}
    8000467c:	853e                	mv	a0,a5
    8000467e:	70a2                	ld	ra,40(sp)
    80004680:	7402                	ld	s0,32(sp)
    80004682:	6145                	addi	sp,sp,48
    80004684:	8082                	ret
    80004686:	64e2                	ld	s1,24(sp)
    80004688:	6942                	ld	s2,16(sp)
    8000468a:	bfcd                	j	8000467c <sys_dup+0x48>

000000008000468c <sys_read>:
{
    8000468c:	7179                	addi	sp,sp,-48
    8000468e:	f406                	sd	ra,40(sp)
    80004690:	f022                	sd	s0,32(sp)
    80004692:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004694:	fe840613          	addi	a2,s0,-24
    80004698:	4581                	li	a1,0
    8000469a:	4501                	li	a0,0
    8000469c:	00000097          	auipc	ra,0x0
    800046a0:	d8c080e7          	jalr	-628(ra) # 80004428 <argfd>
    return -1;
    800046a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046a6:	04054163          	bltz	a0,800046e8 <sys_read+0x5c>
    800046aa:	fe440593          	addi	a1,s0,-28
    800046ae:	4509                	li	a0,2
    800046b0:	ffffe097          	auipc	ra,0xffffe
    800046b4:	894080e7          	jalr	-1900(ra) # 80001f44 <argint>
    return -1;
    800046b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ba:	02054763          	bltz	a0,800046e8 <sys_read+0x5c>
    800046be:	fd840593          	addi	a1,s0,-40
    800046c2:	4505                	li	a0,1
    800046c4:	ffffe097          	auipc	ra,0xffffe
    800046c8:	8a2080e7          	jalr	-1886(ra) # 80001f66 <argaddr>
    return -1;
    800046cc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046ce:	00054d63          	bltz	a0,800046e8 <sys_read+0x5c>
  return fileread(f, p, n);
    800046d2:	fe442603          	lw	a2,-28(s0)
    800046d6:	fd843583          	ld	a1,-40(s0)
    800046da:	fe843503          	ld	a0,-24(s0)
    800046de:	fffff097          	auipc	ra,0xfffff
    800046e2:	424080e7          	jalr	1060(ra) # 80003b02 <fileread>
    800046e6:	87aa                	mv	a5,a0
}
    800046e8:	853e                	mv	a0,a5
    800046ea:	70a2                	ld	ra,40(sp)
    800046ec:	7402                	ld	s0,32(sp)
    800046ee:	6145                	addi	sp,sp,48
    800046f0:	8082                	ret

00000000800046f2 <sys_write>:
{
    800046f2:	7179                	addi	sp,sp,-48
    800046f4:	f406                	sd	ra,40(sp)
    800046f6:	f022                	sd	s0,32(sp)
    800046f8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800046fa:	fe840613          	addi	a2,s0,-24
    800046fe:	4581                	li	a1,0
    80004700:	4501                	li	a0,0
    80004702:	00000097          	auipc	ra,0x0
    80004706:	d26080e7          	jalr	-730(ra) # 80004428 <argfd>
    return -1;
    8000470a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000470c:	04054163          	bltz	a0,8000474e <sys_write+0x5c>
    80004710:	fe440593          	addi	a1,s0,-28
    80004714:	4509                	li	a0,2
    80004716:	ffffe097          	auipc	ra,0xffffe
    8000471a:	82e080e7          	jalr	-2002(ra) # 80001f44 <argint>
    return -1;
    8000471e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004720:	02054763          	bltz	a0,8000474e <sys_write+0x5c>
    80004724:	fd840593          	addi	a1,s0,-40
    80004728:	4505                	li	a0,1
    8000472a:	ffffe097          	auipc	ra,0xffffe
    8000472e:	83c080e7          	jalr	-1988(ra) # 80001f66 <argaddr>
    return -1;
    80004732:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004734:	00054d63          	bltz	a0,8000474e <sys_write+0x5c>
  return filewrite(f, p, n);
    80004738:	fe442603          	lw	a2,-28(s0)
    8000473c:	fd843583          	ld	a1,-40(s0)
    80004740:	fe843503          	ld	a0,-24(s0)
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	490080e7          	jalr	1168(ra) # 80003bd4 <filewrite>
    8000474c:	87aa                	mv	a5,a0
}
    8000474e:	853e                	mv	a0,a5
    80004750:	70a2                	ld	ra,40(sp)
    80004752:	7402                	ld	s0,32(sp)
    80004754:	6145                	addi	sp,sp,48
    80004756:	8082                	ret

0000000080004758 <sys_close>:
{
    80004758:	1101                	addi	sp,sp,-32
    8000475a:	ec06                	sd	ra,24(sp)
    8000475c:	e822                	sd	s0,16(sp)
    8000475e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004760:	fe040613          	addi	a2,s0,-32
    80004764:	fec40593          	addi	a1,s0,-20
    80004768:	4501                	li	a0,0
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	cbe080e7          	jalr	-834(ra) # 80004428 <argfd>
    return -1;
    80004772:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004774:	02054463          	bltz	a0,8000479c <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004778:	ffffc097          	auipc	ra,0xffffc
    8000477c:	704080e7          	jalr	1796(ra) # 80000e7c <myproc>
    80004780:	fec42783          	lw	a5,-20(s0)
    80004784:	07e9                	addi	a5,a5,26
    80004786:	078e                	slli	a5,a5,0x3
    80004788:	953e                	add	a0,a0,a5
    8000478a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000478e:	fe043503          	ld	a0,-32(s0)
    80004792:	fffff097          	auipc	ra,0xfffff
    80004796:	21c080e7          	jalr	540(ra) # 800039ae <fileclose>
  return 0;
    8000479a:	4781                	li	a5,0
}
    8000479c:	853e                	mv	a0,a5
    8000479e:	60e2                	ld	ra,24(sp)
    800047a0:	6442                	ld	s0,16(sp)
    800047a2:	6105                	addi	sp,sp,32
    800047a4:	8082                	ret

00000000800047a6 <sys_fstat>:
{
    800047a6:	1101                	addi	sp,sp,-32
    800047a8:	ec06                	sd	ra,24(sp)
    800047aa:	e822                	sd	s0,16(sp)
    800047ac:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047ae:	fe840613          	addi	a2,s0,-24
    800047b2:	4581                	li	a1,0
    800047b4:	4501                	li	a0,0
    800047b6:	00000097          	auipc	ra,0x0
    800047ba:	c72080e7          	jalr	-910(ra) # 80004428 <argfd>
    return -1;
    800047be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047c0:	02054563          	bltz	a0,800047ea <sys_fstat+0x44>
    800047c4:	fe040593          	addi	a1,s0,-32
    800047c8:	4505                	li	a0,1
    800047ca:	ffffd097          	auipc	ra,0xffffd
    800047ce:	79c080e7          	jalr	1948(ra) # 80001f66 <argaddr>
    return -1;
    800047d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800047d4:	00054b63          	bltz	a0,800047ea <sys_fstat+0x44>
  return filestat(f, st);
    800047d8:	fe043583          	ld	a1,-32(s0)
    800047dc:	fe843503          	ld	a0,-24(s0)
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	2b0080e7          	jalr	688(ra) # 80003a90 <filestat>
    800047e8:	87aa                	mv	a5,a0
}
    800047ea:	853e                	mv	a0,a5
    800047ec:	60e2                	ld	ra,24(sp)
    800047ee:	6442                	ld	s0,16(sp)
    800047f0:	6105                	addi	sp,sp,32
    800047f2:	8082                	ret

00000000800047f4 <sys_link>:
{
    800047f4:	7169                	addi	sp,sp,-304
    800047f6:	f606                	sd	ra,296(sp)
    800047f8:	f222                	sd	s0,288(sp)
    800047fa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047fc:	08000613          	li	a2,128
    80004800:	ed040593          	addi	a1,s0,-304
    80004804:	4501                	li	a0,0
    80004806:	ffffd097          	auipc	ra,0xffffd
    8000480a:	782080e7          	jalr	1922(ra) # 80001f88 <argstr>
    return -1;
    8000480e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004810:	12054663          	bltz	a0,8000493c <sys_link+0x148>
    80004814:	08000613          	li	a2,128
    80004818:	f5040593          	addi	a1,s0,-176
    8000481c:	4505                	li	a0,1
    8000481e:	ffffd097          	auipc	ra,0xffffd
    80004822:	76a080e7          	jalr	1898(ra) # 80001f88 <argstr>
    return -1;
    80004826:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004828:	10054a63          	bltz	a0,8000493c <sys_link+0x148>
    8000482c:	ee26                	sd	s1,280(sp)
  begin_op();
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	cb6080e7          	jalr	-842(ra) # 800034e4 <begin_op>
  if((ip = namei(old)) == 0){
    80004836:	ed040513          	addi	a0,s0,-304
    8000483a:	fffff097          	auipc	ra,0xfffff
    8000483e:	aaa080e7          	jalr	-1366(ra) # 800032e4 <namei>
    80004842:	84aa                	mv	s1,a0
    80004844:	c949                	beqz	a0,800048d6 <sys_link+0xe2>
  ilock(ip);
    80004846:	ffffe097          	auipc	ra,0xffffe
    8000484a:	2cc080e7          	jalr	716(ra) # 80002b12 <ilock>
  if(ip->type == T_DIR){
    8000484e:	04449703          	lh	a4,68(s1)
    80004852:	4785                	li	a5,1
    80004854:	08f70863          	beq	a4,a5,800048e4 <sys_link+0xf0>
    80004858:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000485a:	04a4d783          	lhu	a5,74(s1)
    8000485e:	2785                	addiw	a5,a5,1
    80004860:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004864:	8526                	mv	a0,s1
    80004866:	ffffe097          	auipc	ra,0xffffe
    8000486a:	1e0080e7          	jalr	480(ra) # 80002a46 <iupdate>
  iunlock(ip);
    8000486e:	8526                	mv	a0,s1
    80004870:	ffffe097          	auipc	ra,0xffffe
    80004874:	368080e7          	jalr	872(ra) # 80002bd8 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004878:	fd040593          	addi	a1,s0,-48
    8000487c:	f5040513          	addi	a0,s0,-176
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	a82080e7          	jalr	-1406(ra) # 80003302 <nameiparent>
    80004888:	892a                	mv	s2,a0
    8000488a:	cd35                	beqz	a0,80004906 <sys_link+0x112>
  ilock(dp);
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	286080e7          	jalr	646(ra) # 80002b12 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004894:	00092703          	lw	a4,0(s2)
    80004898:	409c                	lw	a5,0(s1)
    8000489a:	06f71163          	bne	a4,a5,800048fc <sys_link+0x108>
    8000489e:	40d0                	lw	a2,4(s1)
    800048a0:	fd040593          	addi	a1,s0,-48
    800048a4:	854a                	mv	a0,s2
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	97c080e7          	jalr	-1668(ra) # 80003222 <dirlink>
    800048ae:	04054763          	bltz	a0,800048fc <sys_link+0x108>
  iunlockput(dp);
    800048b2:	854a                	mv	a0,s2
    800048b4:	ffffe097          	auipc	ra,0xffffe
    800048b8:	4c4080e7          	jalr	1220(ra) # 80002d78 <iunlockput>
  iput(ip);
    800048bc:	8526                	mv	a0,s1
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	412080e7          	jalr	1042(ra) # 80002cd0 <iput>
  end_op();
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	c98080e7          	jalr	-872(ra) # 8000355e <end_op>
  return 0;
    800048ce:	4781                	li	a5,0
    800048d0:	64f2                	ld	s1,280(sp)
    800048d2:	6952                	ld	s2,272(sp)
    800048d4:	a0a5                	j	8000493c <sys_link+0x148>
    end_op();
    800048d6:	fffff097          	auipc	ra,0xfffff
    800048da:	c88080e7          	jalr	-888(ra) # 8000355e <end_op>
    return -1;
    800048de:	57fd                	li	a5,-1
    800048e0:	64f2                	ld	s1,280(sp)
    800048e2:	a8a9                	j	8000493c <sys_link+0x148>
    iunlockput(ip);
    800048e4:	8526                	mv	a0,s1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	492080e7          	jalr	1170(ra) # 80002d78 <iunlockput>
    end_op();
    800048ee:	fffff097          	auipc	ra,0xfffff
    800048f2:	c70080e7          	jalr	-912(ra) # 8000355e <end_op>
    return -1;
    800048f6:	57fd                	li	a5,-1
    800048f8:	64f2                	ld	s1,280(sp)
    800048fa:	a089                	j	8000493c <sys_link+0x148>
    iunlockput(dp);
    800048fc:	854a                	mv	a0,s2
    800048fe:	ffffe097          	auipc	ra,0xffffe
    80004902:	47a080e7          	jalr	1146(ra) # 80002d78 <iunlockput>
  ilock(ip);
    80004906:	8526                	mv	a0,s1
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	20a080e7          	jalr	522(ra) # 80002b12 <ilock>
  ip->nlink--;
    80004910:	04a4d783          	lhu	a5,74(s1)
    80004914:	37fd                	addiw	a5,a5,-1
    80004916:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000491a:	8526                	mv	a0,s1
    8000491c:	ffffe097          	auipc	ra,0xffffe
    80004920:	12a080e7          	jalr	298(ra) # 80002a46 <iupdate>
  iunlockput(ip);
    80004924:	8526                	mv	a0,s1
    80004926:	ffffe097          	auipc	ra,0xffffe
    8000492a:	452080e7          	jalr	1106(ra) # 80002d78 <iunlockput>
  end_op();
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	c30080e7          	jalr	-976(ra) # 8000355e <end_op>
  return -1;
    80004936:	57fd                	li	a5,-1
    80004938:	64f2                	ld	s1,280(sp)
    8000493a:	6952                	ld	s2,272(sp)
}
    8000493c:	853e                	mv	a0,a5
    8000493e:	70b2                	ld	ra,296(sp)
    80004940:	7412                	ld	s0,288(sp)
    80004942:	6155                	addi	sp,sp,304
    80004944:	8082                	ret

0000000080004946 <sys_unlink>:
{
    80004946:	7151                	addi	sp,sp,-240
    80004948:	f586                	sd	ra,232(sp)
    8000494a:	f1a2                	sd	s0,224(sp)
    8000494c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000494e:	08000613          	li	a2,128
    80004952:	f3040593          	addi	a1,s0,-208
    80004956:	4501                	li	a0,0
    80004958:	ffffd097          	auipc	ra,0xffffd
    8000495c:	630080e7          	jalr	1584(ra) # 80001f88 <argstr>
    80004960:	1a054a63          	bltz	a0,80004b14 <sys_unlink+0x1ce>
    80004964:	eda6                	sd	s1,216(sp)
  begin_op();
    80004966:	fffff097          	auipc	ra,0xfffff
    8000496a:	b7e080e7          	jalr	-1154(ra) # 800034e4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000496e:	fb040593          	addi	a1,s0,-80
    80004972:	f3040513          	addi	a0,s0,-208
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	98c080e7          	jalr	-1652(ra) # 80003302 <nameiparent>
    8000497e:	84aa                	mv	s1,a0
    80004980:	cd71                	beqz	a0,80004a5c <sys_unlink+0x116>
  ilock(dp);
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	190080e7          	jalr	400(ra) # 80002b12 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000498a:	00004597          	auipc	a1,0x4
    8000498e:	ca658593          	addi	a1,a1,-858 # 80008630 <etext+0x630>
    80004992:	fb040513          	addi	a0,s0,-80
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	662080e7          	jalr	1634(ra) # 80002ff8 <namecmp>
    8000499e:	14050c63          	beqz	a0,80004af6 <sys_unlink+0x1b0>
    800049a2:	00004597          	auipc	a1,0x4
    800049a6:	c9658593          	addi	a1,a1,-874 # 80008638 <etext+0x638>
    800049aa:	fb040513          	addi	a0,s0,-80
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	64a080e7          	jalr	1610(ra) # 80002ff8 <namecmp>
    800049b6:	14050063          	beqz	a0,80004af6 <sys_unlink+0x1b0>
    800049ba:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800049bc:	f2c40613          	addi	a2,s0,-212
    800049c0:	fb040593          	addi	a1,s0,-80
    800049c4:	8526                	mv	a0,s1
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	64c080e7          	jalr	1612(ra) # 80003012 <dirlookup>
    800049ce:	892a                	mv	s2,a0
    800049d0:	12050263          	beqz	a0,80004af4 <sys_unlink+0x1ae>
  ilock(ip);
    800049d4:	ffffe097          	auipc	ra,0xffffe
    800049d8:	13e080e7          	jalr	318(ra) # 80002b12 <ilock>
  if(ip->nlink < 1)
    800049dc:	04a91783          	lh	a5,74(s2)
    800049e0:	08f05563          	blez	a5,80004a6a <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800049e4:	04491703          	lh	a4,68(s2)
    800049e8:	4785                	li	a5,1
    800049ea:	08f70963          	beq	a4,a5,80004a7c <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    800049ee:	4641                	li	a2,16
    800049f0:	4581                	li	a1,0
    800049f2:	fc040513          	addi	a0,s0,-64
    800049f6:	ffffb097          	auipc	ra,0xffffb
    800049fa:	784080e7          	jalr	1924(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049fe:	4741                	li	a4,16
    80004a00:	f2c42683          	lw	a3,-212(s0)
    80004a04:	fc040613          	addi	a2,s0,-64
    80004a08:	4581                	li	a1,0
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	4c2080e7          	jalr	1218(ra) # 80002ece <writei>
    80004a14:	47c1                	li	a5,16
    80004a16:	0af51b63          	bne	a0,a5,80004acc <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004a1a:	04491703          	lh	a4,68(s2)
    80004a1e:	4785                	li	a5,1
    80004a20:	0af70f63          	beq	a4,a5,80004ade <sys_unlink+0x198>
  iunlockput(dp);
    80004a24:	8526                	mv	a0,s1
    80004a26:	ffffe097          	auipc	ra,0xffffe
    80004a2a:	352080e7          	jalr	850(ra) # 80002d78 <iunlockput>
  ip->nlink--;
    80004a2e:	04a95783          	lhu	a5,74(s2)
    80004a32:	37fd                	addiw	a5,a5,-1
    80004a34:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a38:	854a                	mv	a0,s2
    80004a3a:	ffffe097          	auipc	ra,0xffffe
    80004a3e:	00c080e7          	jalr	12(ra) # 80002a46 <iupdate>
  iunlockput(ip);
    80004a42:	854a                	mv	a0,s2
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	334080e7          	jalr	820(ra) # 80002d78 <iunlockput>
  end_op();
    80004a4c:	fffff097          	auipc	ra,0xfffff
    80004a50:	b12080e7          	jalr	-1262(ra) # 8000355e <end_op>
  return 0;
    80004a54:	4501                	li	a0,0
    80004a56:	64ee                	ld	s1,216(sp)
    80004a58:	694e                	ld	s2,208(sp)
    80004a5a:	a84d                	j	80004b0c <sys_unlink+0x1c6>
    end_op();
    80004a5c:	fffff097          	auipc	ra,0xfffff
    80004a60:	b02080e7          	jalr	-1278(ra) # 8000355e <end_op>
    return -1;
    80004a64:	557d                	li	a0,-1
    80004a66:	64ee                	ld	s1,216(sp)
    80004a68:	a055                	j	80004b0c <sys_unlink+0x1c6>
    80004a6a:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004a6c:	00004517          	auipc	a0,0x4
    80004a70:	bf450513          	addi	a0,a0,-1036 # 80008660 <etext+0x660>
    80004a74:	00001097          	auipc	ra,0x1
    80004a78:	208080e7          	jalr	520(ra) # 80005c7c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004a7c:	04c92703          	lw	a4,76(s2)
    80004a80:	02000793          	li	a5,32
    80004a84:	f6e7f5e3          	bgeu	a5,a4,800049ee <sys_unlink+0xa8>
    80004a88:	e5ce                	sd	s3,200(sp)
    80004a8a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a8e:	4741                	li	a4,16
    80004a90:	86ce                	mv	a3,s3
    80004a92:	f1840613          	addi	a2,s0,-232
    80004a96:	4581                	li	a1,0
    80004a98:	854a                	mv	a0,s2
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	330080e7          	jalr	816(ra) # 80002dca <readi>
    80004aa2:	47c1                	li	a5,16
    80004aa4:	00f51c63          	bne	a0,a5,80004abc <sys_unlink+0x176>
    if(de.inum != 0)
    80004aa8:	f1845783          	lhu	a5,-232(s0)
    80004aac:	e7b5                	bnez	a5,80004b18 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aae:	29c1                	addiw	s3,s3,16
    80004ab0:	04c92783          	lw	a5,76(s2)
    80004ab4:	fcf9ede3          	bltu	s3,a5,80004a8e <sys_unlink+0x148>
    80004ab8:	69ae                	ld	s3,200(sp)
    80004aba:	bf15                	j	800049ee <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004abc:	00004517          	auipc	a0,0x4
    80004ac0:	bbc50513          	addi	a0,a0,-1092 # 80008678 <etext+0x678>
    80004ac4:	00001097          	auipc	ra,0x1
    80004ac8:	1b8080e7          	jalr	440(ra) # 80005c7c <panic>
    80004acc:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004ace:	00004517          	auipc	a0,0x4
    80004ad2:	bc250513          	addi	a0,a0,-1086 # 80008690 <etext+0x690>
    80004ad6:	00001097          	auipc	ra,0x1
    80004ada:	1a6080e7          	jalr	422(ra) # 80005c7c <panic>
    dp->nlink--;
    80004ade:	04a4d783          	lhu	a5,74(s1)
    80004ae2:	37fd                	addiw	a5,a5,-1
    80004ae4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	ffffe097          	auipc	ra,0xffffe
    80004aee:	f5c080e7          	jalr	-164(ra) # 80002a46 <iupdate>
    80004af2:	bf0d                	j	80004a24 <sys_unlink+0xde>
    80004af4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004af6:	8526                	mv	a0,s1
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	280080e7          	jalr	640(ra) # 80002d78 <iunlockput>
  end_op();
    80004b00:	fffff097          	auipc	ra,0xfffff
    80004b04:	a5e080e7          	jalr	-1442(ra) # 8000355e <end_op>
  return -1;
    80004b08:	557d                	li	a0,-1
    80004b0a:	64ee                	ld	s1,216(sp)
}
    80004b0c:	70ae                	ld	ra,232(sp)
    80004b0e:	740e                	ld	s0,224(sp)
    80004b10:	616d                	addi	sp,sp,240
    80004b12:	8082                	ret
    return -1;
    80004b14:	557d                	li	a0,-1
    80004b16:	bfdd                	j	80004b0c <sys_unlink+0x1c6>
    iunlockput(ip);
    80004b18:	854a                	mv	a0,s2
    80004b1a:	ffffe097          	auipc	ra,0xffffe
    80004b1e:	25e080e7          	jalr	606(ra) # 80002d78 <iunlockput>
    goto bad;
    80004b22:	694e                	ld	s2,208(sp)
    80004b24:	69ae                	ld	s3,200(sp)
    80004b26:	bfc1                	j	80004af6 <sys_unlink+0x1b0>

0000000080004b28 <sys_open>:

uint64
sys_open(void)
{
    80004b28:	7131                	addi	sp,sp,-192
    80004b2a:	fd06                	sd	ra,184(sp)
    80004b2c:	f922                	sd	s0,176(sp)
    80004b2e:	f526                	sd	s1,168(sp)
    80004b30:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b32:	08000613          	li	a2,128
    80004b36:	f5040593          	addi	a1,s0,-176
    80004b3a:	4501                	li	a0,0
    80004b3c:	ffffd097          	auipc	ra,0xffffd
    80004b40:	44c080e7          	jalr	1100(ra) # 80001f88 <argstr>
    return -1;
    80004b44:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004b46:	0c054463          	bltz	a0,80004c0e <sys_open+0xe6>
    80004b4a:	f4c40593          	addi	a1,s0,-180
    80004b4e:	4505                	li	a0,1
    80004b50:	ffffd097          	auipc	ra,0xffffd
    80004b54:	3f4080e7          	jalr	1012(ra) # 80001f44 <argint>
    80004b58:	0a054b63          	bltz	a0,80004c0e <sys_open+0xe6>
    80004b5c:	f14a                	sd	s2,160(sp)

  begin_op();
    80004b5e:	fffff097          	auipc	ra,0xfffff
    80004b62:	986080e7          	jalr	-1658(ra) # 800034e4 <begin_op>

  if(omode & O_CREATE){
    80004b66:	f4c42783          	lw	a5,-180(s0)
    80004b6a:	2007f793          	andi	a5,a5,512
    80004b6e:	cfc5                	beqz	a5,80004c26 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004b70:	4681                	li	a3,0
    80004b72:	4601                	li	a2,0
    80004b74:	4589                	li	a1,2
    80004b76:	f5040513          	addi	a0,s0,-176
    80004b7a:	00000097          	auipc	ra,0x0
    80004b7e:	958080e7          	jalr	-1704(ra) # 800044d2 <create>
    80004b82:	892a                	mv	s2,a0
    if(ip == 0){
    80004b84:	c959                	beqz	a0,80004c1a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004b86:	04491703          	lh	a4,68(s2)
    80004b8a:	478d                	li	a5,3
    80004b8c:	00f71763          	bne	a4,a5,80004b9a <sys_open+0x72>
    80004b90:	04695703          	lhu	a4,70(s2)
    80004b94:	47a5                	li	a5,9
    80004b96:	0ce7ef63          	bltu	a5,a4,80004c74 <sys_open+0x14c>
    80004b9a:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004b9c:	fffff097          	auipc	ra,0xfffff
    80004ba0:	d56080e7          	jalr	-682(ra) # 800038f2 <filealloc>
    80004ba4:	89aa                	mv	s3,a0
    80004ba6:	c965                	beqz	a0,80004c96 <sys_open+0x16e>
    80004ba8:	00000097          	auipc	ra,0x0
    80004bac:	8e8080e7          	jalr	-1816(ra) # 80004490 <fdalloc>
    80004bb0:	84aa                	mv	s1,a0
    80004bb2:	0c054d63          	bltz	a0,80004c8c <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bb6:	04491703          	lh	a4,68(s2)
    80004bba:	478d                	li	a5,3
    80004bbc:	0ef70a63          	beq	a4,a5,80004cb0 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bc0:	4789                	li	a5,2
    80004bc2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004bc6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004bca:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004bce:	f4c42783          	lw	a5,-180(s0)
    80004bd2:	0017c713          	xori	a4,a5,1
    80004bd6:	8b05                	andi	a4,a4,1
    80004bd8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004bdc:	0037f713          	andi	a4,a5,3
    80004be0:	00e03733          	snez	a4,a4
    80004be4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004be8:	4007f793          	andi	a5,a5,1024
    80004bec:	c791                	beqz	a5,80004bf8 <sys_open+0xd0>
    80004bee:	04491703          	lh	a4,68(s2)
    80004bf2:	4789                	li	a5,2
    80004bf4:	0cf70563          	beq	a4,a5,80004cbe <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004bf8:	854a                	mv	a0,s2
    80004bfa:	ffffe097          	auipc	ra,0xffffe
    80004bfe:	fde080e7          	jalr	-34(ra) # 80002bd8 <iunlock>
  end_op();
    80004c02:	fffff097          	auipc	ra,0xfffff
    80004c06:	95c080e7          	jalr	-1700(ra) # 8000355e <end_op>
    80004c0a:	790a                	ld	s2,160(sp)
    80004c0c:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004c0e:	8526                	mv	a0,s1
    80004c10:	70ea                	ld	ra,184(sp)
    80004c12:	744a                	ld	s0,176(sp)
    80004c14:	74aa                	ld	s1,168(sp)
    80004c16:	6129                	addi	sp,sp,192
    80004c18:	8082                	ret
      end_op();
    80004c1a:	fffff097          	auipc	ra,0xfffff
    80004c1e:	944080e7          	jalr	-1724(ra) # 8000355e <end_op>
      return -1;
    80004c22:	790a                	ld	s2,160(sp)
    80004c24:	b7ed                	j	80004c0e <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004c26:	f5040513          	addi	a0,s0,-176
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	6ba080e7          	jalr	1722(ra) # 800032e4 <namei>
    80004c32:	892a                	mv	s2,a0
    80004c34:	c90d                	beqz	a0,80004c66 <sys_open+0x13e>
    ilock(ip);
    80004c36:	ffffe097          	auipc	ra,0xffffe
    80004c3a:	edc080e7          	jalr	-292(ra) # 80002b12 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c3e:	04491703          	lh	a4,68(s2)
    80004c42:	4785                	li	a5,1
    80004c44:	f4f711e3          	bne	a4,a5,80004b86 <sys_open+0x5e>
    80004c48:	f4c42783          	lw	a5,-180(s0)
    80004c4c:	d7b9                	beqz	a5,80004b9a <sys_open+0x72>
      iunlockput(ip);
    80004c4e:	854a                	mv	a0,s2
    80004c50:	ffffe097          	auipc	ra,0xffffe
    80004c54:	128080e7          	jalr	296(ra) # 80002d78 <iunlockput>
      end_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	906080e7          	jalr	-1786(ra) # 8000355e <end_op>
      return -1;
    80004c60:	54fd                	li	s1,-1
    80004c62:	790a                	ld	s2,160(sp)
    80004c64:	b76d                	j	80004c0e <sys_open+0xe6>
      end_op();
    80004c66:	fffff097          	auipc	ra,0xfffff
    80004c6a:	8f8080e7          	jalr	-1800(ra) # 8000355e <end_op>
      return -1;
    80004c6e:	54fd                	li	s1,-1
    80004c70:	790a                	ld	s2,160(sp)
    80004c72:	bf71                	j	80004c0e <sys_open+0xe6>
    iunlockput(ip);
    80004c74:	854a                	mv	a0,s2
    80004c76:	ffffe097          	auipc	ra,0xffffe
    80004c7a:	102080e7          	jalr	258(ra) # 80002d78 <iunlockput>
    end_op();
    80004c7e:	fffff097          	auipc	ra,0xfffff
    80004c82:	8e0080e7          	jalr	-1824(ra) # 8000355e <end_op>
    return -1;
    80004c86:	54fd                	li	s1,-1
    80004c88:	790a                	ld	s2,160(sp)
    80004c8a:	b751                	j	80004c0e <sys_open+0xe6>
      fileclose(f);
    80004c8c:	854e                	mv	a0,s3
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	d20080e7          	jalr	-736(ra) # 800039ae <fileclose>
    iunlockput(ip);
    80004c96:	854a                	mv	a0,s2
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	0e0080e7          	jalr	224(ra) # 80002d78 <iunlockput>
    end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	8be080e7          	jalr	-1858(ra) # 8000355e <end_op>
    return -1;
    80004ca8:	54fd                	li	s1,-1
    80004caa:	790a                	ld	s2,160(sp)
    80004cac:	69ea                	ld	s3,152(sp)
    80004cae:	b785                	j	80004c0e <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004cb0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cb4:	04691783          	lh	a5,70(s2)
    80004cb8:	02f99223          	sh	a5,36(s3)
    80004cbc:	b739                	j	80004bca <sys_open+0xa2>
    itrunc(ip);
    80004cbe:	854a                	mv	a0,s2
    80004cc0:	ffffe097          	auipc	ra,0xffffe
    80004cc4:	f64080e7          	jalr	-156(ra) # 80002c24 <itrunc>
    80004cc8:	bf05                	j	80004bf8 <sys_open+0xd0>

0000000080004cca <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cca:	7175                	addi	sp,sp,-144
    80004ccc:	e506                	sd	ra,136(sp)
    80004cce:	e122                	sd	s0,128(sp)
    80004cd0:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004cd2:	fffff097          	auipc	ra,0xfffff
    80004cd6:	812080e7          	jalr	-2030(ra) # 800034e4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004cda:	08000613          	li	a2,128
    80004cde:	f7040593          	addi	a1,s0,-144
    80004ce2:	4501                	li	a0,0
    80004ce4:	ffffd097          	auipc	ra,0xffffd
    80004ce8:	2a4080e7          	jalr	676(ra) # 80001f88 <argstr>
    80004cec:	02054963          	bltz	a0,80004d1e <sys_mkdir+0x54>
    80004cf0:	4681                	li	a3,0
    80004cf2:	4601                	li	a2,0
    80004cf4:	4585                	li	a1,1
    80004cf6:	f7040513          	addi	a0,s0,-144
    80004cfa:	fffff097          	auipc	ra,0xfffff
    80004cfe:	7d8080e7          	jalr	2008(ra) # 800044d2 <create>
    80004d02:	cd11                	beqz	a0,80004d1e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d04:	ffffe097          	auipc	ra,0xffffe
    80004d08:	074080e7          	jalr	116(ra) # 80002d78 <iunlockput>
  end_op();
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	852080e7          	jalr	-1966(ra) # 8000355e <end_op>
  return 0;
    80004d14:	4501                	li	a0,0
}
    80004d16:	60aa                	ld	ra,136(sp)
    80004d18:	640a                	ld	s0,128(sp)
    80004d1a:	6149                	addi	sp,sp,144
    80004d1c:	8082                	ret
    end_op();
    80004d1e:	fffff097          	auipc	ra,0xfffff
    80004d22:	840080e7          	jalr	-1984(ra) # 8000355e <end_op>
    return -1;
    80004d26:	557d                	li	a0,-1
    80004d28:	b7fd                	j	80004d16 <sys_mkdir+0x4c>

0000000080004d2a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d2a:	7135                	addi	sp,sp,-160
    80004d2c:	ed06                	sd	ra,152(sp)
    80004d2e:	e922                	sd	s0,144(sp)
    80004d30:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	7b2080e7          	jalr	1970(ra) # 800034e4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d3a:	08000613          	li	a2,128
    80004d3e:	f7040593          	addi	a1,s0,-144
    80004d42:	4501                	li	a0,0
    80004d44:	ffffd097          	auipc	ra,0xffffd
    80004d48:	244080e7          	jalr	580(ra) # 80001f88 <argstr>
    80004d4c:	04054a63          	bltz	a0,80004da0 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004d50:	f6c40593          	addi	a1,s0,-148
    80004d54:	4505                	li	a0,1
    80004d56:	ffffd097          	auipc	ra,0xffffd
    80004d5a:	1ee080e7          	jalr	494(ra) # 80001f44 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d5e:	04054163          	bltz	a0,80004da0 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004d62:	f6840593          	addi	a1,s0,-152
    80004d66:	4509                	li	a0,2
    80004d68:	ffffd097          	auipc	ra,0xffffd
    80004d6c:	1dc080e7          	jalr	476(ra) # 80001f44 <argint>
     argint(1, &major) < 0 ||
    80004d70:	02054863          	bltz	a0,80004da0 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d74:	f6841683          	lh	a3,-152(s0)
    80004d78:	f6c41603          	lh	a2,-148(s0)
    80004d7c:	458d                	li	a1,3
    80004d7e:	f7040513          	addi	a0,s0,-144
    80004d82:	fffff097          	auipc	ra,0xfffff
    80004d86:	750080e7          	jalr	1872(ra) # 800044d2 <create>
     argint(2, &minor) < 0 ||
    80004d8a:	c919                	beqz	a0,80004da0 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d8c:	ffffe097          	auipc	ra,0xffffe
    80004d90:	fec080e7          	jalr	-20(ra) # 80002d78 <iunlockput>
  end_op();
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	7ca080e7          	jalr	1994(ra) # 8000355e <end_op>
  return 0;
    80004d9c:	4501                	li	a0,0
    80004d9e:	a031                	j	80004daa <sys_mknod+0x80>
    end_op();
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	7be080e7          	jalr	1982(ra) # 8000355e <end_op>
    return -1;
    80004da8:	557d                	li	a0,-1
}
    80004daa:	60ea                	ld	ra,152(sp)
    80004dac:	644a                	ld	s0,144(sp)
    80004dae:	610d                	addi	sp,sp,160
    80004db0:	8082                	ret

0000000080004db2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004db2:	7135                	addi	sp,sp,-160
    80004db4:	ed06                	sd	ra,152(sp)
    80004db6:	e922                	sd	s0,144(sp)
    80004db8:	e14a                	sd	s2,128(sp)
    80004dba:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004dbc:	ffffc097          	auipc	ra,0xffffc
    80004dc0:	0c0080e7          	jalr	192(ra) # 80000e7c <myproc>
    80004dc4:	892a                	mv	s2,a0
  
  begin_op();
    80004dc6:	ffffe097          	auipc	ra,0xffffe
    80004dca:	71e080e7          	jalr	1822(ra) # 800034e4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004dce:	08000613          	li	a2,128
    80004dd2:	f6040593          	addi	a1,s0,-160
    80004dd6:	4501                	li	a0,0
    80004dd8:	ffffd097          	auipc	ra,0xffffd
    80004ddc:	1b0080e7          	jalr	432(ra) # 80001f88 <argstr>
    80004de0:	04054d63          	bltz	a0,80004e3a <sys_chdir+0x88>
    80004de4:	e526                	sd	s1,136(sp)
    80004de6:	f6040513          	addi	a0,s0,-160
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	4fa080e7          	jalr	1274(ra) # 800032e4 <namei>
    80004df2:	84aa                	mv	s1,a0
    80004df4:	c131                	beqz	a0,80004e38 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	d1c080e7          	jalr	-740(ra) # 80002b12 <ilock>
  if(ip->type != T_DIR){
    80004dfe:	04449703          	lh	a4,68(s1)
    80004e02:	4785                	li	a5,1
    80004e04:	04f71163          	bne	a4,a5,80004e46 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e08:	8526                	mv	a0,s1
    80004e0a:	ffffe097          	auipc	ra,0xffffe
    80004e0e:	dce080e7          	jalr	-562(ra) # 80002bd8 <iunlock>
  iput(p->cwd);
    80004e12:	15093503          	ld	a0,336(s2)
    80004e16:	ffffe097          	auipc	ra,0xffffe
    80004e1a:	eba080e7          	jalr	-326(ra) # 80002cd0 <iput>
  end_op();
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	740080e7          	jalr	1856(ra) # 8000355e <end_op>
  p->cwd = ip;
    80004e26:	14993823          	sd	s1,336(s2)
  return 0;
    80004e2a:	4501                	li	a0,0
    80004e2c:	64aa                	ld	s1,136(sp)
}
    80004e2e:	60ea                	ld	ra,152(sp)
    80004e30:	644a                	ld	s0,144(sp)
    80004e32:	690a                	ld	s2,128(sp)
    80004e34:	610d                	addi	sp,sp,160
    80004e36:	8082                	ret
    80004e38:	64aa                	ld	s1,136(sp)
    end_op();
    80004e3a:	ffffe097          	auipc	ra,0xffffe
    80004e3e:	724080e7          	jalr	1828(ra) # 8000355e <end_op>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	b7ed                	j	80004e2e <sys_chdir+0x7c>
    iunlockput(ip);
    80004e46:	8526                	mv	a0,s1
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	f30080e7          	jalr	-208(ra) # 80002d78 <iunlockput>
    end_op();
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	70e080e7          	jalr	1806(ra) # 8000355e <end_op>
    return -1;
    80004e58:	557d                	li	a0,-1
    80004e5a:	64aa                	ld	s1,136(sp)
    80004e5c:	bfc9                	j	80004e2e <sys_chdir+0x7c>

0000000080004e5e <sys_exec>:

uint64
sys_exec(void)
{
    80004e5e:	7121                	addi	sp,sp,-448
    80004e60:	ff06                	sd	ra,440(sp)
    80004e62:	fb22                	sd	s0,432(sp)
    80004e64:	f34a                	sd	s2,416(sp)
    80004e66:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e68:	08000613          	li	a2,128
    80004e6c:	f5040593          	addi	a1,s0,-176
    80004e70:	4501                	li	a0,0
    80004e72:	ffffd097          	auipc	ra,0xffffd
    80004e76:	116080e7          	jalr	278(ra) # 80001f88 <argstr>
    return -1;
    80004e7a:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004e7c:	0e054a63          	bltz	a0,80004f70 <sys_exec+0x112>
    80004e80:	e4840593          	addi	a1,s0,-440
    80004e84:	4505                	li	a0,1
    80004e86:	ffffd097          	auipc	ra,0xffffd
    80004e8a:	0e0080e7          	jalr	224(ra) # 80001f66 <argaddr>
    80004e8e:	0e054163          	bltz	a0,80004f70 <sys_exec+0x112>
    80004e92:	f726                	sd	s1,424(sp)
    80004e94:	ef4e                	sd	s3,408(sp)
    80004e96:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004e98:	10000613          	li	a2,256
    80004e9c:	4581                	li	a1,0
    80004e9e:	e5040513          	addi	a0,s0,-432
    80004ea2:	ffffb097          	auipc	ra,0xffffb
    80004ea6:	2d8080e7          	jalr	728(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004eaa:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004eae:	89a6                	mv	s3,s1
    80004eb0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004eb2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004eb6:	00391513          	slli	a0,s2,0x3
    80004eba:	e4040593          	addi	a1,s0,-448
    80004ebe:	e4843783          	ld	a5,-440(s0)
    80004ec2:	953e                	add	a0,a0,a5
    80004ec4:	ffffd097          	auipc	ra,0xffffd
    80004ec8:	fe6080e7          	jalr	-26(ra) # 80001eaa <fetchaddr>
    80004ecc:	02054a63          	bltz	a0,80004f00 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80004ed0:	e4043783          	ld	a5,-448(s0)
    80004ed4:	c7b1                	beqz	a5,80004f20 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ed6:	ffffb097          	auipc	ra,0xffffb
    80004eda:	244080e7          	jalr	580(ra) # 8000011a <kalloc>
    80004ede:	85aa                	mv	a1,a0
    80004ee0:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004ee4:	cd11                	beqz	a0,80004f00 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ee6:	6605                	lui	a2,0x1
    80004ee8:	e4043503          	ld	a0,-448(s0)
    80004eec:	ffffd097          	auipc	ra,0xffffd
    80004ef0:	010080e7          	jalr	16(ra) # 80001efc <fetchstr>
    80004ef4:	00054663          	bltz	a0,80004f00 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    80004ef8:	0905                	addi	s2,s2,1
    80004efa:	09a1                	addi	s3,s3,8
    80004efc:	fb491de3          	bne	s2,s4,80004eb6 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f00:	f5040913          	addi	s2,s0,-176
    80004f04:	6088                	ld	a0,0(s1)
    80004f06:	c12d                	beqz	a0,80004f68 <sys_exec+0x10a>
    kfree(argv[i]);
    80004f08:	ffffb097          	auipc	ra,0xffffb
    80004f0c:	114080e7          	jalr	276(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f10:	04a1                	addi	s1,s1,8
    80004f12:	ff2499e3          	bne	s1,s2,80004f04 <sys_exec+0xa6>
  return -1;
    80004f16:	597d                	li	s2,-1
    80004f18:	74ba                	ld	s1,424(sp)
    80004f1a:	69fa                	ld	s3,408(sp)
    80004f1c:	6a5a                	ld	s4,400(sp)
    80004f1e:	a889                	j	80004f70 <sys_exec+0x112>
      argv[i] = 0;
    80004f20:	0009079b          	sext.w	a5,s2
    80004f24:	078e                	slli	a5,a5,0x3
    80004f26:	fd078793          	addi	a5,a5,-48
    80004f2a:	97a2                	add	a5,a5,s0
    80004f2c:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f30:	e5040593          	addi	a1,s0,-432
    80004f34:	f5040513          	addi	a0,s0,-176
    80004f38:	fffff097          	auipc	ra,0xfffff
    80004f3c:	126080e7          	jalr	294(ra) # 8000405e <exec>
    80004f40:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f42:	f5040993          	addi	s3,s0,-176
    80004f46:	6088                	ld	a0,0(s1)
    80004f48:	cd01                	beqz	a0,80004f60 <sys_exec+0x102>
    kfree(argv[i]);
    80004f4a:	ffffb097          	auipc	ra,0xffffb
    80004f4e:	0d2080e7          	jalr	210(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f52:	04a1                	addi	s1,s1,8
    80004f54:	ff3499e3          	bne	s1,s3,80004f46 <sys_exec+0xe8>
    80004f58:	74ba                	ld	s1,424(sp)
    80004f5a:	69fa                	ld	s3,408(sp)
    80004f5c:	6a5a                	ld	s4,400(sp)
    80004f5e:	a809                	j	80004f70 <sys_exec+0x112>
  return ret;
    80004f60:	74ba                	ld	s1,424(sp)
    80004f62:	69fa                	ld	s3,408(sp)
    80004f64:	6a5a                	ld	s4,400(sp)
    80004f66:	a029                	j	80004f70 <sys_exec+0x112>
  return -1;
    80004f68:	597d                	li	s2,-1
    80004f6a:	74ba                	ld	s1,424(sp)
    80004f6c:	69fa                	ld	s3,408(sp)
    80004f6e:	6a5a                	ld	s4,400(sp)
}
    80004f70:	854a                	mv	a0,s2
    80004f72:	70fa                	ld	ra,440(sp)
    80004f74:	745a                	ld	s0,432(sp)
    80004f76:	791a                	ld	s2,416(sp)
    80004f78:	6139                	addi	sp,sp,448
    80004f7a:	8082                	ret

0000000080004f7c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f7c:	7139                	addi	sp,sp,-64
    80004f7e:	fc06                	sd	ra,56(sp)
    80004f80:	f822                	sd	s0,48(sp)
    80004f82:	f426                	sd	s1,40(sp)
    80004f84:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f86:	ffffc097          	auipc	ra,0xffffc
    80004f8a:	ef6080e7          	jalr	-266(ra) # 80000e7c <myproc>
    80004f8e:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80004f90:	fd840593          	addi	a1,s0,-40
    80004f94:	4501                	li	a0,0
    80004f96:	ffffd097          	auipc	ra,0xffffd
    80004f9a:	fd0080e7          	jalr	-48(ra) # 80001f66 <argaddr>
    return -1;
    80004f9e:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80004fa0:	0e054063          	bltz	a0,80005080 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80004fa4:	fc840593          	addi	a1,s0,-56
    80004fa8:	fd040513          	addi	a0,s0,-48
    80004fac:	fffff097          	auipc	ra,0xfffff
    80004fb0:	d70080e7          	jalr	-656(ra) # 80003d1c <pipealloc>
    return -1;
    80004fb4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fb6:	0c054563          	bltz	a0,80005080 <sys_pipe+0x104>
  fd0 = -1;
    80004fba:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fbe:	fd043503          	ld	a0,-48(s0)
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	4ce080e7          	jalr	1230(ra) # 80004490 <fdalloc>
    80004fca:	fca42223          	sw	a0,-60(s0)
    80004fce:	08054c63          	bltz	a0,80005066 <sys_pipe+0xea>
    80004fd2:	fc843503          	ld	a0,-56(s0)
    80004fd6:	fffff097          	auipc	ra,0xfffff
    80004fda:	4ba080e7          	jalr	1210(ra) # 80004490 <fdalloc>
    80004fde:	fca42023          	sw	a0,-64(s0)
    80004fe2:	06054963          	bltz	a0,80005054 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fe6:	4691                	li	a3,4
    80004fe8:	fc440613          	addi	a2,s0,-60
    80004fec:	fd843583          	ld	a1,-40(s0)
    80004ff0:	68a8                	ld	a0,80(s1)
    80004ff2:	ffffc097          	auipc	ra,0xffffc
    80004ff6:	b26080e7          	jalr	-1242(ra) # 80000b18 <copyout>
    80004ffa:	02054063          	bltz	a0,8000501a <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004ffe:	4691                	li	a3,4
    80005000:	fc040613          	addi	a2,s0,-64
    80005004:	fd843583          	ld	a1,-40(s0)
    80005008:	0591                	addi	a1,a1,4
    8000500a:	68a8                	ld	a0,80(s1)
    8000500c:	ffffc097          	auipc	ra,0xffffc
    80005010:	b0c080e7          	jalr	-1268(ra) # 80000b18 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005014:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005016:	06055563          	bgez	a0,80005080 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    8000501a:	fc442783          	lw	a5,-60(s0)
    8000501e:	07e9                	addi	a5,a5,26
    80005020:	078e                	slli	a5,a5,0x3
    80005022:	97a6                	add	a5,a5,s1
    80005024:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005028:	fc042783          	lw	a5,-64(s0)
    8000502c:	07e9                	addi	a5,a5,26
    8000502e:	078e                	slli	a5,a5,0x3
    80005030:	00f48533          	add	a0,s1,a5
    80005034:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005038:	fd043503          	ld	a0,-48(s0)
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	972080e7          	jalr	-1678(ra) # 800039ae <fileclose>
    fileclose(wf);
    80005044:	fc843503          	ld	a0,-56(s0)
    80005048:	fffff097          	auipc	ra,0xfffff
    8000504c:	966080e7          	jalr	-1690(ra) # 800039ae <fileclose>
    return -1;
    80005050:	57fd                	li	a5,-1
    80005052:	a03d                	j	80005080 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005054:	fc442783          	lw	a5,-60(s0)
    80005058:	0007c763          	bltz	a5,80005066 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000505c:	07e9                	addi	a5,a5,26
    8000505e:	078e                	slli	a5,a5,0x3
    80005060:	97a6                	add	a5,a5,s1
    80005062:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005066:	fd043503          	ld	a0,-48(s0)
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	944080e7          	jalr	-1724(ra) # 800039ae <fileclose>
    fileclose(wf);
    80005072:	fc843503          	ld	a0,-56(s0)
    80005076:	fffff097          	auipc	ra,0xfffff
    8000507a:	938080e7          	jalr	-1736(ra) # 800039ae <fileclose>
    return -1;
    8000507e:	57fd                	li	a5,-1
}
    80005080:	853e                	mv	a0,a5
    80005082:	70e2                	ld	ra,56(sp)
    80005084:	7442                	ld	s0,48(sp)
    80005086:	74a2                	ld	s1,40(sp)
    80005088:	6121                	addi	sp,sp,64
    8000508a:	8082                	ret
    8000508c:	0000                	unimp
	...

0000000080005090 <kernelvec>:
    80005090:	7111                	addi	sp,sp,-256
    80005092:	e006                	sd	ra,0(sp)
    80005094:	e40a                	sd	sp,8(sp)
    80005096:	e80e                	sd	gp,16(sp)
    80005098:	ec12                	sd	tp,24(sp)
    8000509a:	f016                	sd	t0,32(sp)
    8000509c:	f41a                	sd	t1,40(sp)
    8000509e:	f81e                	sd	t2,48(sp)
    800050a0:	fc22                	sd	s0,56(sp)
    800050a2:	e0a6                	sd	s1,64(sp)
    800050a4:	e4aa                	sd	a0,72(sp)
    800050a6:	e8ae                	sd	a1,80(sp)
    800050a8:	ecb2                	sd	a2,88(sp)
    800050aa:	f0b6                	sd	a3,96(sp)
    800050ac:	f4ba                	sd	a4,104(sp)
    800050ae:	f8be                	sd	a5,112(sp)
    800050b0:	fcc2                	sd	a6,120(sp)
    800050b2:	e146                	sd	a7,128(sp)
    800050b4:	e54a                	sd	s2,136(sp)
    800050b6:	e94e                	sd	s3,144(sp)
    800050b8:	ed52                	sd	s4,152(sp)
    800050ba:	f156                	sd	s5,160(sp)
    800050bc:	f55a                	sd	s6,168(sp)
    800050be:	f95e                	sd	s7,176(sp)
    800050c0:	fd62                	sd	s8,184(sp)
    800050c2:	e1e6                	sd	s9,192(sp)
    800050c4:	e5ea                	sd	s10,200(sp)
    800050c6:	e9ee                	sd	s11,208(sp)
    800050c8:	edf2                	sd	t3,216(sp)
    800050ca:	f1f6                	sd	t4,224(sp)
    800050cc:	f5fa                	sd	t5,232(sp)
    800050ce:	f9fe                	sd	t6,240(sp)
    800050d0:	ca7fc0ef          	jal	80001d76 <kerneltrap>
    800050d4:	6082                	ld	ra,0(sp)
    800050d6:	6122                	ld	sp,8(sp)
    800050d8:	61c2                	ld	gp,16(sp)
    800050da:	7282                	ld	t0,32(sp)
    800050dc:	7322                	ld	t1,40(sp)
    800050de:	73c2                	ld	t2,48(sp)
    800050e0:	7462                	ld	s0,56(sp)
    800050e2:	6486                	ld	s1,64(sp)
    800050e4:	6526                	ld	a0,72(sp)
    800050e6:	65c6                	ld	a1,80(sp)
    800050e8:	6666                	ld	a2,88(sp)
    800050ea:	7686                	ld	a3,96(sp)
    800050ec:	7726                	ld	a4,104(sp)
    800050ee:	77c6                	ld	a5,112(sp)
    800050f0:	7866                	ld	a6,120(sp)
    800050f2:	688a                	ld	a7,128(sp)
    800050f4:	692a                	ld	s2,136(sp)
    800050f6:	69ca                	ld	s3,144(sp)
    800050f8:	6a6a                	ld	s4,152(sp)
    800050fa:	7a8a                	ld	s5,160(sp)
    800050fc:	7b2a                	ld	s6,168(sp)
    800050fe:	7bca                	ld	s7,176(sp)
    80005100:	7c6a                	ld	s8,184(sp)
    80005102:	6c8e                	ld	s9,192(sp)
    80005104:	6d2e                	ld	s10,200(sp)
    80005106:	6dce                	ld	s11,208(sp)
    80005108:	6e6e                	ld	t3,216(sp)
    8000510a:	7e8e                	ld	t4,224(sp)
    8000510c:	7f2e                	ld	t5,232(sp)
    8000510e:	7fce                	ld	t6,240(sp)
    80005110:	6111                	addi	sp,sp,256
    80005112:	10200073          	sret
    80005116:	00000013          	nop
    8000511a:	00000013          	nop
    8000511e:	0001                	nop

0000000080005120 <timervec>:
    80005120:	34051573          	csrrw	a0,mscratch,a0
    80005124:	e10c                	sd	a1,0(a0)
    80005126:	e510                	sd	a2,8(a0)
    80005128:	e914                	sd	a3,16(a0)
    8000512a:	6d0c                	ld	a1,24(a0)
    8000512c:	7110                	ld	a2,32(a0)
    8000512e:	6194                	ld	a3,0(a1)
    80005130:	96b2                	add	a3,a3,a2
    80005132:	e194                	sd	a3,0(a1)
    80005134:	4589                	li	a1,2
    80005136:	14459073          	csrw	sip,a1
    8000513a:	6914                	ld	a3,16(a0)
    8000513c:	6510                	ld	a2,8(a0)
    8000513e:	610c                	ld	a1,0(a0)
    80005140:	34051573          	csrrw	a0,mscratch,a0
    80005144:	30200073          	mret
	...

000000008000514a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000514a:	1141                	addi	sp,sp,-16
    8000514c:	e422                	sd	s0,8(sp)
    8000514e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005150:	0c0007b7          	lui	a5,0xc000
    80005154:	4705                	li	a4,1
    80005156:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005158:	0c0007b7          	lui	a5,0xc000
    8000515c:	c3d8                	sw	a4,4(a5)
}
    8000515e:	6422                	ld	s0,8(sp)
    80005160:	0141                	addi	sp,sp,16
    80005162:	8082                	ret

0000000080005164 <plicinithart>:

void
plicinithart(void)
{
    80005164:	1141                	addi	sp,sp,-16
    80005166:	e406                	sd	ra,8(sp)
    80005168:	e022                	sd	s0,0(sp)
    8000516a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000516c:	ffffc097          	auipc	ra,0xffffc
    80005170:	ce4080e7          	jalr	-796(ra) # 80000e50 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005174:	0085171b          	slliw	a4,a0,0x8
    80005178:	0c0027b7          	lui	a5,0xc002
    8000517c:	97ba                	add	a5,a5,a4
    8000517e:	40200713          	li	a4,1026
    80005182:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005186:	00d5151b          	slliw	a0,a0,0xd
    8000518a:	0c2017b7          	lui	a5,0xc201
    8000518e:	97aa                	add	a5,a5,a0
    80005190:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005194:	60a2                	ld	ra,8(sp)
    80005196:	6402                	ld	s0,0(sp)
    80005198:	0141                	addi	sp,sp,16
    8000519a:	8082                	ret

000000008000519c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000519c:	1141                	addi	sp,sp,-16
    8000519e:	e406                	sd	ra,8(sp)
    800051a0:	e022                	sd	s0,0(sp)
    800051a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051a4:	ffffc097          	auipc	ra,0xffffc
    800051a8:	cac080e7          	jalr	-852(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051ac:	00d5151b          	slliw	a0,a0,0xd
    800051b0:	0c2017b7          	lui	a5,0xc201
    800051b4:	97aa                	add	a5,a5,a0
  return irq;
}
    800051b6:	43c8                	lw	a0,4(a5)
    800051b8:	60a2                	ld	ra,8(sp)
    800051ba:	6402                	ld	s0,0(sp)
    800051bc:	0141                	addi	sp,sp,16
    800051be:	8082                	ret

00000000800051c0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051c0:	1101                	addi	sp,sp,-32
    800051c2:	ec06                	sd	ra,24(sp)
    800051c4:	e822                	sd	s0,16(sp)
    800051c6:	e426                	sd	s1,8(sp)
    800051c8:	1000                	addi	s0,sp,32
    800051ca:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051cc:	ffffc097          	auipc	ra,0xffffc
    800051d0:	c84080e7          	jalr	-892(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051d4:	00d5151b          	slliw	a0,a0,0xd
    800051d8:	0c2017b7          	lui	a5,0xc201
    800051dc:	97aa                	add	a5,a5,a0
    800051de:	c3c4                	sw	s1,4(a5)
}
    800051e0:	60e2                	ld	ra,24(sp)
    800051e2:	6442                	ld	s0,16(sp)
    800051e4:	64a2                	ld	s1,8(sp)
    800051e6:	6105                	addi	sp,sp,32
    800051e8:	8082                	ret

00000000800051ea <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051ea:	1141                	addi	sp,sp,-16
    800051ec:	e406                	sd	ra,8(sp)
    800051ee:	e022                	sd	s0,0(sp)
    800051f0:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051f2:	479d                	li	a5,7
    800051f4:	06a7c863          	blt	a5,a0,80005264 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800051f8:	00016717          	auipc	a4,0x16
    800051fc:	e0870713          	addi	a4,a4,-504 # 8001b000 <disk>
    80005200:	972a                	add	a4,a4,a0
    80005202:	6789                	lui	a5,0x2
    80005204:	97ba                	add	a5,a5,a4
    80005206:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000520a:	e7ad                	bnez	a5,80005274 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000520c:	00451793          	slli	a5,a0,0x4
    80005210:	00018717          	auipc	a4,0x18
    80005214:	df070713          	addi	a4,a4,-528 # 8001d000 <disk+0x2000>
    80005218:	6314                	ld	a3,0(a4)
    8000521a:	96be                	add	a3,a3,a5
    8000521c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005220:	6314                	ld	a3,0(a4)
    80005222:	96be                	add	a3,a3,a5
    80005224:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005228:	6314                	ld	a3,0(a4)
    8000522a:	96be                	add	a3,a3,a5
    8000522c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005230:	6318                	ld	a4,0(a4)
    80005232:	97ba                	add	a5,a5,a4
    80005234:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005238:	00016717          	auipc	a4,0x16
    8000523c:	dc870713          	addi	a4,a4,-568 # 8001b000 <disk>
    80005240:	972a                	add	a4,a4,a0
    80005242:	6789                	lui	a5,0x2
    80005244:	97ba                	add	a5,a5,a4
    80005246:	4705                	li	a4,1
    80005248:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000524c:	00018517          	auipc	a0,0x18
    80005250:	dcc50513          	addi	a0,a0,-564 # 8001d018 <disk+0x2018>
    80005254:	ffffc097          	auipc	ra,0xffffc
    80005258:	482080e7          	jalr	1154(ra) # 800016d6 <wakeup>
}
    8000525c:	60a2                	ld	ra,8(sp)
    8000525e:	6402                	ld	s0,0(sp)
    80005260:	0141                	addi	sp,sp,16
    80005262:	8082                	ret
    panic("free_desc 1");
    80005264:	00003517          	auipc	a0,0x3
    80005268:	43c50513          	addi	a0,a0,1084 # 800086a0 <etext+0x6a0>
    8000526c:	00001097          	auipc	ra,0x1
    80005270:	a10080e7          	jalr	-1520(ra) # 80005c7c <panic>
    panic("free_desc 2");
    80005274:	00003517          	auipc	a0,0x3
    80005278:	43c50513          	addi	a0,a0,1084 # 800086b0 <etext+0x6b0>
    8000527c:	00001097          	auipc	ra,0x1
    80005280:	a00080e7          	jalr	-1536(ra) # 80005c7c <panic>

0000000080005284 <virtio_disk_init>:
{
    80005284:	1141                	addi	sp,sp,-16
    80005286:	e406                	sd	ra,8(sp)
    80005288:	e022                	sd	s0,0(sp)
    8000528a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000528c:	00003597          	auipc	a1,0x3
    80005290:	43458593          	addi	a1,a1,1076 # 800086c0 <etext+0x6c0>
    80005294:	00018517          	auipc	a0,0x18
    80005298:	e9450513          	addi	a0,a0,-364 # 8001d128 <disk+0x2128>
    8000529c:	00001097          	auipc	ra,0x1
    800052a0:	eca080e7          	jalr	-310(ra) # 80006166 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052a4:	100017b7          	lui	a5,0x10001
    800052a8:	4398                	lw	a4,0(a5)
    800052aa:	2701                	sext.w	a4,a4
    800052ac:	747277b7          	lui	a5,0x74727
    800052b0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052b4:	0ef71f63          	bne	a4,a5,800053b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052b8:	100017b7          	lui	a5,0x10001
    800052bc:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800052be:	439c                	lw	a5,0(a5)
    800052c0:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052c2:	4705                	li	a4,1
    800052c4:	0ee79763          	bne	a5,a4,800053b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052c8:	100017b7          	lui	a5,0x10001
    800052cc:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800052ce:	439c                	lw	a5,0(a5)
    800052d0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800052d2:	4709                	li	a4,2
    800052d4:	0ce79f63          	bne	a5,a4,800053b2 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052d8:	100017b7          	lui	a5,0x10001
    800052dc:	47d8                	lw	a4,12(a5)
    800052de:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052e0:	554d47b7          	lui	a5,0x554d4
    800052e4:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052e8:	0cf71563          	bne	a4,a5,800053b2 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ec:	100017b7          	lui	a5,0x10001
    800052f0:	4705                	li	a4,1
    800052f2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052f4:	470d                	li	a4,3
    800052f6:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052f8:	10001737          	lui	a4,0x10001
    800052fc:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052fe:	c7ffe737          	lui	a4,0xc7ffe
    80005302:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005306:	8ef9                	and	a3,a3,a4
    80005308:	10001737          	lui	a4,0x10001
    8000530c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000530e:	472d                	li	a4,11
    80005310:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005312:	473d                	li	a4,15
    80005314:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005316:	100017b7          	lui	a5,0x10001
    8000531a:	6705                	lui	a4,0x1
    8000531c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000531e:	100017b7          	lui	a5,0x10001
    80005322:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005326:	100017b7          	lui	a5,0x10001
    8000532a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000532e:	439c                	lw	a5,0(a5)
    80005330:	2781                	sext.w	a5,a5
  if(max == 0)
    80005332:	cbc1                	beqz	a5,800053c2 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005334:	471d                	li	a4,7
    80005336:	08f77e63          	bgeu	a4,a5,800053d2 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000533a:	100017b7          	lui	a5,0x10001
    8000533e:	4721                	li	a4,8
    80005340:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005342:	6609                	lui	a2,0x2
    80005344:	4581                	li	a1,0
    80005346:	00016517          	auipc	a0,0x16
    8000534a:	cba50513          	addi	a0,a0,-838 # 8001b000 <disk>
    8000534e:	ffffb097          	auipc	ra,0xffffb
    80005352:	e2c080e7          	jalr	-468(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005356:	00016697          	auipc	a3,0x16
    8000535a:	caa68693          	addi	a3,a3,-854 # 8001b000 <disk>
    8000535e:	00c6d713          	srli	a4,a3,0xc
    80005362:	2701                	sext.w	a4,a4
    80005364:	100017b7          	lui	a5,0x10001
    80005368:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    8000536a:	00018797          	auipc	a5,0x18
    8000536e:	c9678793          	addi	a5,a5,-874 # 8001d000 <disk+0x2000>
    80005372:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005374:	00016717          	auipc	a4,0x16
    80005378:	d0c70713          	addi	a4,a4,-756 # 8001b080 <disk+0x80>
    8000537c:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000537e:	00017717          	auipc	a4,0x17
    80005382:	c8270713          	addi	a4,a4,-894 # 8001c000 <disk+0x1000>
    80005386:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005388:	4705                	li	a4,1
    8000538a:	00e78c23          	sb	a4,24(a5)
    8000538e:	00e78ca3          	sb	a4,25(a5)
    80005392:	00e78d23          	sb	a4,26(a5)
    80005396:	00e78da3          	sb	a4,27(a5)
    8000539a:	00e78e23          	sb	a4,28(a5)
    8000539e:	00e78ea3          	sb	a4,29(a5)
    800053a2:	00e78f23          	sb	a4,30(a5)
    800053a6:	00e78fa3          	sb	a4,31(a5)
}
    800053aa:	60a2                	ld	ra,8(sp)
    800053ac:	6402                	ld	s0,0(sp)
    800053ae:	0141                	addi	sp,sp,16
    800053b0:	8082                	ret
    panic("could not find virtio disk");
    800053b2:	00003517          	auipc	a0,0x3
    800053b6:	31e50513          	addi	a0,a0,798 # 800086d0 <etext+0x6d0>
    800053ba:	00001097          	auipc	ra,0x1
    800053be:	8c2080e7          	jalr	-1854(ra) # 80005c7c <panic>
    panic("virtio disk has no queue 0");
    800053c2:	00003517          	auipc	a0,0x3
    800053c6:	32e50513          	addi	a0,a0,814 # 800086f0 <etext+0x6f0>
    800053ca:	00001097          	auipc	ra,0x1
    800053ce:	8b2080e7          	jalr	-1870(ra) # 80005c7c <panic>
    panic("virtio disk max queue too short");
    800053d2:	00003517          	auipc	a0,0x3
    800053d6:	33e50513          	addi	a0,a0,830 # 80008710 <etext+0x710>
    800053da:	00001097          	auipc	ra,0x1
    800053de:	8a2080e7          	jalr	-1886(ra) # 80005c7c <panic>

00000000800053e2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800053e2:	7159                	addi	sp,sp,-112
    800053e4:	f486                	sd	ra,104(sp)
    800053e6:	f0a2                	sd	s0,96(sp)
    800053e8:	eca6                	sd	s1,88(sp)
    800053ea:	e8ca                	sd	s2,80(sp)
    800053ec:	e4ce                	sd	s3,72(sp)
    800053ee:	e0d2                	sd	s4,64(sp)
    800053f0:	fc56                	sd	s5,56(sp)
    800053f2:	f85a                	sd	s6,48(sp)
    800053f4:	f45e                	sd	s7,40(sp)
    800053f6:	f062                	sd	s8,32(sp)
    800053f8:	ec66                	sd	s9,24(sp)
    800053fa:	1880                	addi	s0,sp,112
    800053fc:	8a2a                	mv	s4,a0
    800053fe:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005400:	00c52c03          	lw	s8,12(a0)
    80005404:	001c1c1b          	slliw	s8,s8,0x1
    80005408:	1c02                	slli	s8,s8,0x20
    8000540a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000540e:	00018517          	auipc	a0,0x18
    80005412:	d1a50513          	addi	a0,a0,-742 # 8001d128 <disk+0x2128>
    80005416:	00001097          	auipc	ra,0x1
    8000541a:	de0080e7          	jalr	-544(ra) # 800061f6 <acquire>
  for(int i = 0; i < 3; i++){
    8000541e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005420:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005422:	00016b97          	auipc	s7,0x16
    80005426:	bdeb8b93          	addi	s7,s7,-1058 # 8001b000 <disk>
    8000542a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000542c:	4a8d                	li	s5,3
    8000542e:	a88d                	j	800054a0 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005430:	00fb8733          	add	a4,s7,a5
    80005434:	975a                	add	a4,a4,s6
    80005436:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000543a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000543c:	0207c563          	bltz	a5,80005466 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005440:	2905                	addiw	s2,s2,1
    80005442:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    80005444:	1b590163          	beq	s2,s5,800055e6 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    80005448:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000544a:	00018717          	auipc	a4,0x18
    8000544e:	bce70713          	addi	a4,a4,-1074 # 8001d018 <disk+0x2018>
    80005452:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005454:	00074683          	lbu	a3,0(a4)
    80005458:	fee1                	bnez	a3,80005430 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    8000545a:	2785                	addiw	a5,a5,1
    8000545c:	0705                	addi	a4,a4,1
    8000545e:	fe979be3          	bne	a5,s1,80005454 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005462:	57fd                	li	a5,-1
    80005464:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005466:	03205163          	blez	s2,80005488 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000546a:	f9042503          	lw	a0,-112(s0)
    8000546e:	00000097          	auipc	ra,0x0
    80005472:	d7c080e7          	jalr	-644(ra) # 800051ea <free_desc>
      for(int j = 0; j < i; j++)
    80005476:	4785                	li	a5,1
    80005478:	0127d863          	bge	a5,s2,80005488 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    8000547c:	f9442503          	lw	a0,-108(s0)
    80005480:	00000097          	auipc	ra,0x0
    80005484:	d6a080e7          	jalr	-662(ra) # 800051ea <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005488:	00018597          	auipc	a1,0x18
    8000548c:	ca058593          	addi	a1,a1,-864 # 8001d128 <disk+0x2128>
    80005490:	00018517          	auipc	a0,0x18
    80005494:	b8850513          	addi	a0,a0,-1144 # 8001d018 <disk+0x2018>
    80005498:	ffffc097          	auipc	ra,0xffffc
    8000549c:	0b2080e7          	jalr	178(ra) # 8000154a <sleep>
  for(int i = 0; i < 3; i++){
    800054a0:	f9040613          	addi	a2,s0,-112
    800054a4:	894e                	mv	s2,s3
    800054a6:	b74d                	j	80005448 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800054a8:	00018717          	auipc	a4,0x18
    800054ac:	b5873703          	ld	a4,-1192(a4) # 8001d000 <disk+0x2000>
    800054b0:	973e                	add	a4,a4,a5
    800054b2:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800054b6:	00016897          	auipc	a7,0x16
    800054ba:	b4a88893          	addi	a7,a7,-1206 # 8001b000 <disk>
    800054be:	00018717          	auipc	a4,0x18
    800054c2:	b4270713          	addi	a4,a4,-1214 # 8001d000 <disk+0x2000>
    800054c6:	6314                	ld	a3,0(a4)
    800054c8:	96be                	add	a3,a3,a5
    800054ca:	00c6d583          	lhu	a1,12(a3)
    800054ce:	0015e593          	ori	a1,a1,1
    800054d2:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800054d6:	f9842683          	lw	a3,-104(s0)
    800054da:	630c                	ld	a1,0(a4)
    800054dc:	97ae                	add	a5,a5,a1
    800054de:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800054e2:	20050593          	addi	a1,a0,512
    800054e6:	0592                	slli	a1,a1,0x4
    800054e8:	95c6                	add	a1,a1,a7
    800054ea:	57fd                	li	a5,-1
    800054ec:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800054f0:	00469793          	slli	a5,a3,0x4
    800054f4:	00073803          	ld	a6,0(a4)
    800054f8:	983e                	add	a6,a6,a5
    800054fa:	6689                	lui	a3,0x2
    800054fc:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005500:	96b2                	add	a3,a3,a2
    80005502:	96c6                	add	a3,a3,a7
    80005504:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005508:	6314                	ld	a3,0(a4)
    8000550a:	96be                	add	a3,a3,a5
    8000550c:	4605                	li	a2,1
    8000550e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005510:	6314                	ld	a3,0(a4)
    80005512:	96be                	add	a3,a3,a5
    80005514:	4809                	li	a6,2
    80005516:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000551a:	6314                	ld	a3,0(a4)
    8000551c:	97b6                	add	a5,a5,a3
    8000551e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005522:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005526:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000552a:	6714                	ld	a3,8(a4)
    8000552c:	0026d783          	lhu	a5,2(a3)
    80005530:	8b9d                	andi	a5,a5,7
    80005532:	0786                	slli	a5,a5,0x1
    80005534:	96be                	add	a3,a3,a5
    80005536:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000553a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000553e:	6718                	ld	a4,8(a4)
    80005540:	00275783          	lhu	a5,2(a4)
    80005544:	2785                	addiw	a5,a5,1
    80005546:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000554a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000554e:	100017b7          	lui	a5,0x10001
    80005552:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005556:	004a2783          	lw	a5,4(s4)
    8000555a:	02c79163          	bne	a5,a2,8000557c <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    8000555e:	00018917          	auipc	s2,0x18
    80005562:	bca90913          	addi	s2,s2,-1078 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    80005566:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005568:	85ca                	mv	a1,s2
    8000556a:	8552                	mv	a0,s4
    8000556c:	ffffc097          	auipc	ra,0xffffc
    80005570:	fde080e7          	jalr	-34(ra) # 8000154a <sleep>
  while(b->disk == 1) {
    80005574:	004a2783          	lw	a5,4(s4)
    80005578:	fe9788e3          	beq	a5,s1,80005568 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    8000557c:	f9042903          	lw	s2,-112(s0)
    80005580:	20090713          	addi	a4,s2,512
    80005584:	0712                	slli	a4,a4,0x4
    80005586:	00016797          	auipc	a5,0x16
    8000558a:	a7a78793          	addi	a5,a5,-1414 # 8001b000 <disk>
    8000558e:	97ba                	add	a5,a5,a4
    80005590:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    80005594:	00018997          	auipc	s3,0x18
    80005598:	a6c98993          	addi	s3,s3,-1428 # 8001d000 <disk+0x2000>
    8000559c:	00491713          	slli	a4,s2,0x4
    800055a0:	0009b783          	ld	a5,0(s3)
    800055a4:	97ba                	add	a5,a5,a4
    800055a6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800055aa:	854a                	mv	a0,s2
    800055ac:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800055b0:	00000097          	auipc	ra,0x0
    800055b4:	c3a080e7          	jalr	-966(ra) # 800051ea <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800055b8:	8885                	andi	s1,s1,1
    800055ba:	f0ed                	bnez	s1,8000559c <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800055bc:	00018517          	auipc	a0,0x18
    800055c0:	b6c50513          	addi	a0,a0,-1172 # 8001d128 <disk+0x2128>
    800055c4:	00001097          	auipc	ra,0x1
    800055c8:	ce6080e7          	jalr	-794(ra) # 800062aa <release>
}
    800055cc:	70a6                	ld	ra,104(sp)
    800055ce:	7406                	ld	s0,96(sp)
    800055d0:	64e6                	ld	s1,88(sp)
    800055d2:	6946                	ld	s2,80(sp)
    800055d4:	69a6                	ld	s3,72(sp)
    800055d6:	6a06                	ld	s4,64(sp)
    800055d8:	7ae2                	ld	s5,56(sp)
    800055da:	7b42                	ld	s6,48(sp)
    800055dc:	7ba2                	ld	s7,40(sp)
    800055de:	7c02                	ld	s8,32(sp)
    800055e0:	6ce2                	ld	s9,24(sp)
    800055e2:	6165                	addi	sp,sp,112
    800055e4:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800055e6:	f9042503          	lw	a0,-112(s0)
    800055ea:	00451613          	slli	a2,a0,0x4
  if(write)
    800055ee:	00016597          	auipc	a1,0x16
    800055f2:	a1258593          	addi	a1,a1,-1518 # 8001b000 <disk>
    800055f6:	20050793          	addi	a5,a0,512
    800055fa:	0792                	slli	a5,a5,0x4
    800055fc:	97ae                	add	a5,a5,a1
    800055fe:	01903733          	snez	a4,s9
    80005602:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005606:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000560a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000560e:	00018717          	auipc	a4,0x18
    80005612:	9f270713          	addi	a4,a4,-1550 # 8001d000 <disk+0x2000>
    80005616:	6314                	ld	a3,0(a4)
    80005618:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000561a:	6789                	lui	a5,0x2
    8000561c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005620:	97b2                	add	a5,a5,a2
    80005622:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005624:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005626:	631c                	ld	a5,0(a4)
    80005628:	97b2                	add	a5,a5,a2
    8000562a:	46c1                	li	a3,16
    8000562c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000562e:	631c                	ld	a5,0(a4)
    80005630:	97b2                	add	a5,a5,a2
    80005632:	4685                	li	a3,1
    80005634:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f9442783          	lw	a5,-108(s0)
    8000563c:	6314                	ld	a3,0(a4)
    8000563e:	96b2                	add	a3,a3,a2
    80005640:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    80005644:	0792                	slli	a5,a5,0x4
    80005646:	6314                	ld	a3,0(a4)
    80005648:	96be                	add	a3,a3,a5
    8000564a:	058a0593          	addi	a1,s4,88
    8000564e:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005650:	6318                	ld	a4,0(a4)
    80005652:	973e                	add	a4,a4,a5
    80005654:	40000693          	li	a3,1024
    80005658:	c714                	sw	a3,8(a4)
  if(write)
    8000565a:	e40c97e3          	bnez	s9,800054a8 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000565e:	00018717          	auipc	a4,0x18
    80005662:	9a273703          	ld	a4,-1630(a4) # 8001d000 <disk+0x2000>
    80005666:	973e                	add	a4,a4,a5
    80005668:	4689                	li	a3,2
    8000566a:	00d71623          	sh	a3,12(a4)
    8000566e:	b5a1                	j	800054b6 <virtio_disk_rw+0xd4>

0000000080005670 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005670:	1101                	addi	sp,sp,-32
    80005672:	ec06                	sd	ra,24(sp)
    80005674:	e822                	sd	s0,16(sp)
    80005676:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005678:	00018517          	auipc	a0,0x18
    8000567c:	ab050513          	addi	a0,a0,-1360 # 8001d128 <disk+0x2128>
    80005680:	00001097          	auipc	ra,0x1
    80005684:	b76080e7          	jalr	-1162(ra) # 800061f6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	53b8                	lw	a4,96(a5)
    8000568e:	8b0d                	andi	a4,a4,3
    80005690:	100017b7          	lui	a5,0x10001
    80005694:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005696:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000569a:	00018797          	auipc	a5,0x18
    8000569e:	96678793          	addi	a5,a5,-1690 # 8001d000 <disk+0x2000>
    800056a2:	6b94                	ld	a3,16(a5)
    800056a4:	0207d703          	lhu	a4,32(a5)
    800056a8:	0026d783          	lhu	a5,2(a3)
    800056ac:	06f70563          	beq	a4,a5,80005716 <virtio_disk_intr+0xa6>
    800056b0:	e426                	sd	s1,8(sp)
    800056b2:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056b4:	00016917          	auipc	s2,0x16
    800056b8:	94c90913          	addi	s2,s2,-1716 # 8001b000 <disk>
    800056bc:	00018497          	auipc	s1,0x18
    800056c0:	94448493          	addi	s1,s1,-1724 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800056c4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056c8:	6898                	ld	a4,16(s1)
    800056ca:	0204d783          	lhu	a5,32(s1)
    800056ce:	8b9d                	andi	a5,a5,7
    800056d0:	078e                	slli	a5,a5,0x3
    800056d2:	97ba                	add	a5,a5,a4
    800056d4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056d6:	20078713          	addi	a4,a5,512
    800056da:	0712                	slli	a4,a4,0x4
    800056dc:	974a                	add	a4,a4,s2
    800056de:	03074703          	lbu	a4,48(a4)
    800056e2:	e731                	bnez	a4,8000572e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056e4:	20078793          	addi	a5,a5,512
    800056e8:	0792                	slli	a5,a5,0x4
    800056ea:	97ca                	add	a5,a5,s2
    800056ec:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800056ee:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056f2:	ffffc097          	auipc	ra,0xffffc
    800056f6:	fe4080e7          	jalr	-28(ra) # 800016d6 <wakeup>

    disk.used_idx += 1;
    800056fa:	0204d783          	lhu	a5,32(s1)
    800056fe:	2785                	addiw	a5,a5,1
    80005700:	17c2                	slli	a5,a5,0x30
    80005702:	93c1                	srli	a5,a5,0x30
    80005704:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005708:	6898                	ld	a4,16(s1)
    8000570a:	00275703          	lhu	a4,2(a4)
    8000570e:	faf71be3          	bne	a4,a5,800056c4 <virtio_disk_intr+0x54>
    80005712:	64a2                	ld	s1,8(sp)
    80005714:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005716:	00018517          	auipc	a0,0x18
    8000571a:	a1250513          	addi	a0,a0,-1518 # 8001d128 <disk+0x2128>
    8000571e:	00001097          	auipc	ra,0x1
    80005722:	b8c080e7          	jalr	-1140(ra) # 800062aa <release>
}
    80005726:	60e2                	ld	ra,24(sp)
    80005728:	6442                	ld	s0,16(sp)
    8000572a:	6105                	addi	sp,sp,32
    8000572c:	8082                	ret
      panic("virtio_disk_intr status");
    8000572e:	00003517          	auipc	a0,0x3
    80005732:	00250513          	addi	a0,a0,2 # 80008730 <etext+0x730>
    80005736:	00000097          	auipc	ra,0x0
    8000573a:	546080e7          	jalr	1350(ra) # 80005c7c <panic>

000000008000573e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000573e:	1141                	addi	sp,sp,-16
    80005740:	e422                	sd	s0,8(sp)
    80005742:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005744:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005748:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000574c:	0037979b          	slliw	a5,a5,0x3
    80005750:	02004737          	lui	a4,0x2004
    80005754:	97ba                	add	a5,a5,a4
    80005756:	0200c737          	lui	a4,0x200c
    8000575a:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000575c:	6318                	ld	a4,0(a4)
    8000575e:	000f4637          	lui	a2,0xf4
    80005762:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005766:	9732                	add	a4,a4,a2
    80005768:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    8000576a:	00259693          	slli	a3,a1,0x2
    8000576e:	96ae                	add	a3,a3,a1
    80005770:	068e                	slli	a3,a3,0x3
    80005772:	00019717          	auipc	a4,0x19
    80005776:	88e70713          	addi	a4,a4,-1906 # 8001e000 <timer_scratch>
    8000577a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000577c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000577e:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005780:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005784:	00000797          	auipc	a5,0x0
    80005788:	99c78793          	addi	a5,a5,-1636 # 80005120 <timervec>
    8000578c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005790:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005794:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005798:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000579c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057a0:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057a4:	30479073          	csrw	mie,a5
}
    800057a8:	6422                	ld	s0,8(sp)
    800057aa:	0141                	addi	sp,sp,16
    800057ac:	8082                	ret

00000000800057ae <start>:
{
    800057ae:	1141                	addi	sp,sp,-16
    800057b0:	e406                	sd	ra,8(sp)
    800057b2:	e022                	sd	s0,0(sp)
    800057b4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057b6:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057ba:	7779                	lui	a4,0xffffe
    800057bc:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800057c0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057c2:	6705                	lui	a4,0x1
    800057c4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057c8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057ca:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057ce:	ffffb797          	auipc	a5,0xffffb
    800057d2:	b4a78793          	addi	a5,a5,-1206 # 80000318 <main>
    800057d6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057da:	4781                	li	a5,0
    800057dc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057e0:	67c1                	lui	a5,0x10
    800057e2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057e4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057e8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057ec:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057f0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057f4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800057f8:	57fd                	li	a5,-1
    800057fa:	83a9                	srli	a5,a5,0xa
    800057fc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005800:	47bd                	li	a5,15
    80005802:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005806:	00000097          	auipc	ra,0x0
    8000580a:	f38080e7          	jalr	-200(ra) # 8000573e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000580e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005812:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005814:	823e                	mv	tp,a5
  asm volatile("mret");
    80005816:	30200073          	mret
}
    8000581a:	60a2                	ld	ra,8(sp)
    8000581c:	6402                	ld	s0,0(sp)
    8000581e:	0141                	addi	sp,sp,16
    80005820:	8082                	ret

0000000080005822 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005822:	715d                	addi	sp,sp,-80
    80005824:	e486                	sd	ra,72(sp)
    80005826:	e0a2                	sd	s0,64(sp)
    80005828:	f84a                	sd	s2,48(sp)
    8000582a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000582c:	04c05663          	blez	a2,80005878 <consolewrite+0x56>
    80005830:	fc26                	sd	s1,56(sp)
    80005832:	f44e                	sd	s3,40(sp)
    80005834:	f052                	sd	s4,32(sp)
    80005836:	ec56                	sd	s5,24(sp)
    80005838:	8a2a                	mv	s4,a0
    8000583a:	84ae                	mv	s1,a1
    8000583c:	89b2                	mv	s3,a2
    8000583e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005840:	5afd                	li	s5,-1
    80005842:	4685                	li	a3,1
    80005844:	8626                	mv	a2,s1
    80005846:	85d2                	mv	a1,s4
    80005848:	fbf40513          	addi	a0,s0,-65
    8000584c:	ffffc097          	auipc	ra,0xffffc
    80005850:	0f8080e7          	jalr	248(ra) # 80001944 <either_copyin>
    80005854:	03550463          	beq	a0,s5,8000587c <consolewrite+0x5a>
      break;
    uartputc(c);
    80005858:	fbf44503          	lbu	a0,-65(s0)
    8000585c:	00000097          	auipc	ra,0x0
    80005860:	7de080e7          	jalr	2014(ra) # 8000603a <uartputc>
  for(i = 0; i < n; i++){
    80005864:	2905                	addiw	s2,s2,1
    80005866:	0485                	addi	s1,s1,1
    80005868:	fd299de3          	bne	s3,s2,80005842 <consolewrite+0x20>
    8000586c:	894e                	mv	s2,s3
    8000586e:	74e2                	ld	s1,56(sp)
    80005870:	79a2                	ld	s3,40(sp)
    80005872:	7a02                	ld	s4,32(sp)
    80005874:	6ae2                	ld	s5,24(sp)
    80005876:	a039                	j	80005884 <consolewrite+0x62>
    80005878:	4901                	li	s2,0
    8000587a:	a029                	j	80005884 <consolewrite+0x62>
    8000587c:	74e2                	ld	s1,56(sp)
    8000587e:	79a2                	ld	s3,40(sp)
    80005880:	7a02                	ld	s4,32(sp)
    80005882:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005884:	854a                	mv	a0,s2
    80005886:	60a6                	ld	ra,72(sp)
    80005888:	6406                	ld	s0,64(sp)
    8000588a:	7942                	ld	s2,48(sp)
    8000588c:	6161                	addi	sp,sp,80
    8000588e:	8082                	ret

0000000080005890 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005890:	711d                	addi	sp,sp,-96
    80005892:	ec86                	sd	ra,88(sp)
    80005894:	e8a2                	sd	s0,80(sp)
    80005896:	e4a6                	sd	s1,72(sp)
    80005898:	e0ca                	sd	s2,64(sp)
    8000589a:	fc4e                	sd	s3,56(sp)
    8000589c:	f852                	sd	s4,48(sp)
    8000589e:	f456                	sd	s5,40(sp)
    800058a0:	f05a                	sd	s6,32(sp)
    800058a2:	1080                	addi	s0,sp,96
    800058a4:	8aaa                	mv	s5,a0
    800058a6:	8a2e                	mv	s4,a1
    800058a8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058aa:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058ae:	00021517          	auipc	a0,0x21
    800058b2:	89250513          	addi	a0,a0,-1902 # 80026140 <cons>
    800058b6:	00001097          	auipc	ra,0x1
    800058ba:	940080e7          	jalr	-1728(ra) # 800061f6 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058be:	00021497          	auipc	s1,0x21
    800058c2:	88248493          	addi	s1,s1,-1918 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058c6:	00021917          	auipc	s2,0x21
    800058ca:	91290913          	addi	s2,s2,-1774 # 800261d8 <cons+0x98>
  while(n > 0){
    800058ce:	0d305463          	blez	s3,80005996 <consoleread+0x106>
    while(cons.r == cons.w){
    800058d2:	0984a783          	lw	a5,152(s1)
    800058d6:	09c4a703          	lw	a4,156(s1)
    800058da:	0af71963          	bne	a4,a5,8000598c <consoleread+0xfc>
      if(myproc()->killed){
    800058de:	ffffb097          	auipc	ra,0xffffb
    800058e2:	59e080e7          	jalr	1438(ra) # 80000e7c <myproc>
    800058e6:	551c                	lw	a5,40(a0)
    800058e8:	e7ad                	bnez	a5,80005952 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    800058ea:	85a6                	mv	a1,s1
    800058ec:	854a                	mv	a0,s2
    800058ee:	ffffc097          	auipc	ra,0xffffc
    800058f2:	c5c080e7          	jalr	-932(ra) # 8000154a <sleep>
    while(cons.r == cons.w){
    800058f6:	0984a783          	lw	a5,152(s1)
    800058fa:	09c4a703          	lw	a4,156(s1)
    800058fe:	fef700e3          	beq	a4,a5,800058de <consoleread+0x4e>
    80005902:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005904:	00021717          	auipc	a4,0x21
    80005908:	83c70713          	addi	a4,a4,-1988 # 80026140 <cons>
    8000590c:	0017869b          	addiw	a3,a5,1
    80005910:	08d72c23          	sw	a3,152(a4)
    80005914:	07f7f693          	andi	a3,a5,127
    80005918:	9736                	add	a4,a4,a3
    8000591a:	01874703          	lbu	a4,24(a4)
    8000591e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005922:	4691                	li	a3,4
    80005924:	04db8a63          	beq	s7,a3,80005978 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005928:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000592c:	4685                	li	a3,1
    8000592e:	faf40613          	addi	a2,s0,-81
    80005932:	85d2                	mv	a1,s4
    80005934:	8556                	mv	a0,s5
    80005936:	ffffc097          	auipc	ra,0xffffc
    8000593a:	fb8080e7          	jalr	-72(ra) # 800018ee <either_copyout>
    8000593e:	57fd                	li	a5,-1
    80005940:	04f50a63          	beq	a0,a5,80005994 <consoleread+0x104>
      break;

    dst++;
    80005944:	0a05                	addi	s4,s4,1
    --n;
    80005946:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005948:	47a9                	li	a5,10
    8000594a:	06fb8163          	beq	s7,a5,800059ac <consoleread+0x11c>
    8000594e:	6be2                	ld	s7,24(sp)
    80005950:	bfbd                	j	800058ce <consoleread+0x3e>
        release(&cons.lock);
    80005952:	00020517          	auipc	a0,0x20
    80005956:	7ee50513          	addi	a0,a0,2030 # 80026140 <cons>
    8000595a:	00001097          	auipc	ra,0x1
    8000595e:	950080e7          	jalr	-1712(ra) # 800062aa <release>
        return -1;
    80005962:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005964:	60e6                	ld	ra,88(sp)
    80005966:	6446                	ld	s0,80(sp)
    80005968:	64a6                	ld	s1,72(sp)
    8000596a:	6906                	ld	s2,64(sp)
    8000596c:	79e2                	ld	s3,56(sp)
    8000596e:	7a42                	ld	s4,48(sp)
    80005970:	7aa2                	ld	s5,40(sp)
    80005972:	7b02                	ld	s6,32(sp)
    80005974:	6125                	addi	sp,sp,96
    80005976:	8082                	ret
      if(n < target){
    80005978:	0009871b          	sext.w	a4,s3
    8000597c:	01677a63          	bgeu	a4,s6,80005990 <consoleread+0x100>
        cons.r--;
    80005980:	00021717          	auipc	a4,0x21
    80005984:	84f72c23          	sw	a5,-1960(a4) # 800261d8 <cons+0x98>
    80005988:	6be2                	ld	s7,24(sp)
    8000598a:	a031                	j	80005996 <consoleread+0x106>
    8000598c:	ec5e                	sd	s7,24(sp)
    8000598e:	bf9d                	j	80005904 <consoleread+0x74>
    80005990:	6be2                	ld	s7,24(sp)
    80005992:	a011                	j	80005996 <consoleread+0x106>
    80005994:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005996:	00020517          	auipc	a0,0x20
    8000599a:	7aa50513          	addi	a0,a0,1962 # 80026140 <cons>
    8000599e:	00001097          	auipc	ra,0x1
    800059a2:	90c080e7          	jalr	-1780(ra) # 800062aa <release>
  return target - n;
    800059a6:	413b053b          	subw	a0,s6,s3
    800059aa:	bf6d                	j	80005964 <consoleread+0xd4>
    800059ac:	6be2                	ld	s7,24(sp)
    800059ae:	b7e5                	j	80005996 <consoleread+0x106>

00000000800059b0 <consputc>:
{
    800059b0:	1141                	addi	sp,sp,-16
    800059b2:	e406                	sd	ra,8(sp)
    800059b4:	e022                	sd	s0,0(sp)
    800059b6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059b8:	10000793          	li	a5,256
    800059bc:	00f50a63          	beq	a0,a5,800059d0 <consputc+0x20>
    uartputc_sync(c);
    800059c0:	00000097          	auipc	ra,0x0
    800059c4:	59c080e7          	jalr	1436(ra) # 80005f5c <uartputc_sync>
}
    800059c8:	60a2                	ld	ra,8(sp)
    800059ca:	6402                	ld	s0,0(sp)
    800059cc:	0141                	addi	sp,sp,16
    800059ce:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059d0:	4521                	li	a0,8
    800059d2:	00000097          	auipc	ra,0x0
    800059d6:	58a080e7          	jalr	1418(ra) # 80005f5c <uartputc_sync>
    800059da:	02000513          	li	a0,32
    800059de:	00000097          	auipc	ra,0x0
    800059e2:	57e080e7          	jalr	1406(ra) # 80005f5c <uartputc_sync>
    800059e6:	4521                	li	a0,8
    800059e8:	00000097          	auipc	ra,0x0
    800059ec:	574080e7          	jalr	1396(ra) # 80005f5c <uartputc_sync>
    800059f0:	bfe1                	j	800059c8 <consputc+0x18>

00000000800059f2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059f2:	1101                	addi	sp,sp,-32
    800059f4:	ec06                	sd	ra,24(sp)
    800059f6:	e822                	sd	s0,16(sp)
    800059f8:	e426                	sd	s1,8(sp)
    800059fa:	1000                	addi	s0,sp,32
    800059fc:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059fe:	00020517          	auipc	a0,0x20
    80005a02:	74250513          	addi	a0,a0,1858 # 80026140 <cons>
    80005a06:	00000097          	auipc	ra,0x0
    80005a0a:	7f0080e7          	jalr	2032(ra) # 800061f6 <acquire>

  switch(c){
    80005a0e:	47d5                	li	a5,21
    80005a10:	0af48563          	beq	s1,a5,80005aba <consoleintr+0xc8>
    80005a14:	0297c963          	blt	a5,s1,80005a46 <consoleintr+0x54>
    80005a18:	47a1                	li	a5,8
    80005a1a:	0ef48c63          	beq	s1,a5,80005b12 <consoleintr+0x120>
    80005a1e:	47c1                	li	a5,16
    80005a20:	10f49f63          	bne	s1,a5,80005b3e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005a24:	ffffc097          	auipc	ra,0xffffc
    80005a28:	f76080e7          	jalr	-138(ra) # 8000199a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a2c:	00020517          	auipc	a0,0x20
    80005a30:	71450513          	addi	a0,a0,1812 # 80026140 <cons>
    80005a34:	00001097          	auipc	ra,0x1
    80005a38:	876080e7          	jalr	-1930(ra) # 800062aa <release>
}
    80005a3c:	60e2                	ld	ra,24(sp)
    80005a3e:	6442                	ld	s0,16(sp)
    80005a40:	64a2                	ld	s1,8(sp)
    80005a42:	6105                	addi	sp,sp,32
    80005a44:	8082                	ret
  switch(c){
    80005a46:	07f00793          	li	a5,127
    80005a4a:	0cf48463          	beq	s1,a5,80005b12 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005a4e:	00020717          	auipc	a4,0x20
    80005a52:	6f270713          	addi	a4,a4,1778 # 80026140 <cons>
    80005a56:	0a072783          	lw	a5,160(a4)
    80005a5a:	09872703          	lw	a4,152(a4)
    80005a5e:	9f99                	subw	a5,a5,a4
    80005a60:	07f00713          	li	a4,127
    80005a64:	fcf764e3          	bltu	a4,a5,80005a2c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005a68:	47b5                	li	a5,13
    80005a6a:	0cf48d63          	beq	s1,a5,80005b44 <consoleintr+0x152>
      consputc(c);
    80005a6e:	8526                	mv	a0,s1
    80005a70:	00000097          	auipc	ra,0x0
    80005a74:	f40080e7          	jalr	-192(ra) # 800059b0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005a78:	00020797          	auipc	a5,0x20
    80005a7c:	6c878793          	addi	a5,a5,1736 # 80026140 <cons>
    80005a80:	0a07a703          	lw	a4,160(a5)
    80005a84:	0017069b          	addiw	a3,a4,1
    80005a88:	0006861b          	sext.w	a2,a3
    80005a8c:	0ad7a023          	sw	a3,160(a5)
    80005a90:	07f77713          	andi	a4,a4,127
    80005a94:	97ba                	add	a5,a5,a4
    80005a96:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005a9a:	47a9                	li	a5,10
    80005a9c:	0cf48b63          	beq	s1,a5,80005b72 <consoleintr+0x180>
    80005aa0:	4791                	li	a5,4
    80005aa2:	0cf48863          	beq	s1,a5,80005b72 <consoleintr+0x180>
    80005aa6:	00020797          	auipc	a5,0x20
    80005aaa:	7327a783          	lw	a5,1842(a5) # 800261d8 <cons+0x98>
    80005aae:	0807879b          	addiw	a5,a5,128
    80005ab2:	f6f61de3          	bne	a2,a5,80005a2c <consoleintr+0x3a>
    80005ab6:	863e                	mv	a2,a5
    80005ab8:	a86d                	j	80005b72 <consoleintr+0x180>
    80005aba:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005abc:	00020717          	auipc	a4,0x20
    80005ac0:	68470713          	addi	a4,a4,1668 # 80026140 <cons>
    80005ac4:	0a072783          	lw	a5,160(a4)
    80005ac8:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005acc:	00020497          	auipc	s1,0x20
    80005ad0:	67448493          	addi	s1,s1,1652 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005ad4:	4929                	li	s2,10
    80005ad6:	02f70a63          	beq	a4,a5,80005b0a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005ada:	37fd                	addiw	a5,a5,-1
    80005adc:	07f7f713          	andi	a4,a5,127
    80005ae0:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ae2:	01874703          	lbu	a4,24(a4)
    80005ae6:	03270463          	beq	a4,s2,80005b0e <consoleintr+0x11c>
      cons.e--;
    80005aea:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005aee:	10000513          	li	a0,256
    80005af2:	00000097          	auipc	ra,0x0
    80005af6:	ebe080e7          	jalr	-322(ra) # 800059b0 <consputc>
    while(cons.e != cons.w &&
    80005afa:	0a04a783          	lw	a5,160(s1)
    80005afe:	09c4a703          	lw	a4,156(s1)
    80005b02:	fcf71ce3          	bne	a4,a5,80005ada <consoleintr+0xe8>
    80005b06:	6902                	ld	s2,0(sp)
    80005b08:	b715                	j	80005a2c <consoleintr+0x3a>
    80005b0a:	6902                	ld	s2,0(sp)
    80005b0c:	b705                	j	80005a2c <consoleintr+0x3a>
    80005b0e:	6902                	ld	s2,0(sp)
    80005b10:	bf31                	j	80005a2c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005b12:	00020717          	auipc	a4,0x20
    80005b16:	62e70713          	addi	a4,a4,1582 # 80026140 <cons>
    80005b1a:	0a072783          	lw	a5,160(a4)
    80005b1e:	09c72703          	lw	a4,156(a4)
    80005b22:	f0f705e3          	beq	a4,a5,80005a2c <consoleintr+0x3a>
      cons.e--;
    80005b26:	37fd                	addiw	a5,a5,-1
    80005b28:	00020717          	auipc	a4,0x20
    80005b2c:	6af72c23          	sw	a5,1720(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005b30:	10000513          	li	a0,256
    80005b34:	00000097          	auipc	ra,0x0
    80005b38:	e7c080e7          	jalr	-388(ra) # 800059b0 <consputc>
    80005b3c:	bdc5                	j	80005a2c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b3e:	ee0487e3          	beqz	s1,80005a2c <consoleintr+0x3a>
    80005b42:	b731                	j	80005a4e <consoleintr+0x5c>
      consputc(c);
    80005b44:	4529                	li	a0,10
    80005b46:	00000097          	auipc	ra,0x0
    80005b4a:	e6a080e7          	jalr	-406(ra) # 800059b0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b4e:	00020797          	auipc	a5,0x20
    80005b52:	5f278793          	addi	a5,a5,1522 # 80026140 <cons>
    80005b56:	0a07a703          	lw	a4,160(a5)
    80005b5a:	0017069b          	addiw	a3,a4,1
    80005b5e:	0006861b          	sext.w	a2,a3
    80005b62:	0ad7a023          	sw	a3,160(a5)
    80005b66:	07f77713          	andi	a4,a4,127
    80005b6a:	97ba                	add	a5,a5,a4
    80005b6c:	4729                	li	a4,10
    80005b6e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b72:	00020797          	auipc	a5,0x20
    80005b76:	66c7a523          	sw	a2,1642(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005b7a:	00020517          	auipc	a0,0x20
    80005b7e:	65e50513          	addi	a0,a0,1630 # 800261d8 <cons+0x98>
    80005b82:	ffffc097          	auipc	ra,0xffffc
    80005b86:	b54080e7          	jalr	-1196(ra) # 800016d6 <wakeup>
    80005b8a:	b54d                	j	80005a2c <consoleintr+0x3a>

0000000080005b8c <consoleinit>:

void
consoleinit(void)
{
    80005b8c:	1141                	addi	sp,sp,-16
    80005b8e:	e406                	sd	ra,8(sp)
    80005b90:	e022                	sd	s0,0(sp)
    80005b92:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b94:	00003597          	auipc	a1,0x3
    80005b98:	bb458593          	addi	a1,a1,-1100 # 80008748 <etext+0x748>
    80005b9c:	00020517          	auipc	a0,0x20
    80005ba0:	5a450513          	addi	a0,a0,1444 # 80026140 <cons>
    80005ba4:	00000097          	auipc	ra,0x0
    80005ba8:	5c2080e7          	jalr	1474(ra) # 80006166 <initlock>

  uartinit();
    80005bac:	00000097          	auipc	ra,0x0
    80005bb0:	354080e7          	jalr	852(ra) # 80005f00 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005bb4:	00013797          	auipc	a5,0x13
    80005bb8:	51478793          	addi	a5,a5,1300 # 800190c8 <devsw>
    80005bbc:	00000717          	auipc	a4,0x0
    80005bc0:	cd470713          	addi	a4,a4,-812 # 80005890 <consoleread>
    80005bc4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bc6:	00000717          	auipc	a4,0x0
    80005bca:	c5c70713          	addi	a4,a4,-932 # 80005822 <consolewrite>
    80005bce:	ef98                	sd	a4,24(a5)
}
    80005bd0:	60a2                	ld	ra,8(sp)
    80005bd2:	6402                	ld	s0,0(sp)
    80005bd4:	0141                	addi	sp,sp,16
    80005bd6:	8082                	ret

0000000080005bd8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bd8:	7179                	addi	sp,sp,-48
    80005bda:	f406                	sd	ra,40(sp)
    80005bdc:	f022                	sd	s0,32(sp)
    80005bde:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005be0:	c219                	beqz	a2,80005be6 <printint+0xe>
    80005be2:	08054963          	bltz	a0,80005c74 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005be6:	2501                	sext.w	a0,a0
    80005be8:	4881                	li	a7,0
    80005bea:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bee:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bf0:	2581                	sext.w	a1,a1
    80005bf2:	00003617          	auipc	a2,0x3
    80005bf6:	cbe60613          	addi	a2,a2,-834 # 800088b0 <digits>
    80005bfa:	883a                	mv	a6,a4
    80005bfc:	2705                	addiw	a4,a4,1
    80005bfe:	02b577bb          	remuw	a5,a0,a1
    80005c02:	1782                	slli	a5,a5,0x20
    80005c04:	9381                	srli	a5,a5,0x20
    80005c06:	97b2                	add	a5,a5,a2
    80005c08:	0007c783          	lbu	a5,0(a5)
    80005c0c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c10:	0005079b          	sext.w	a5,a0
    80005c14:	02b5553b          	divuw	a0,a0,a1
    80005c18:	0685                	addi	a3,a3,1
    80005c1a:	feb7f0e3          	bgeu	a5,a1,80005bfa <printint+0x22>

  if(sign)
    80005c1e:	00088c63          	beqz	a7,80005c36 <printint+0x5e>
    buf[i++] = '-';
    80005c22:	fe070793          	addi	a5,a4,-32
    80005c26:	00878733          	add	a4,a5,s0
    80005c2a:	02d00793          	li	a5,45
    80005c2e:	fef70823          	sb	a5,-16(a4)
    80005c32:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c36:	02e05b63          	blez	a4,80005c6c <printint+0x94>
    80005c3a:	ec26                	sd	s1,24(sp)
    80005c3c:	e84a                	sd	s2,16(sp)
    80005c3e:	fd040793          	addi	a5,s0,-48
    80005c42:	00e784b3          	add	s1,a5,a4
    80005c46:	fff78913          	addi	s2,a5,-1
    80005c4a:	993a                	add	s2,s2,a4
    80005c4c:	377d                	addiw	a4,a4,-1
    80005c4e:	1702                	slli	a4,a4,0x20
    80005c50:	9301                	srli	a4,a4,0x20
    80005c52:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c56:	fff4c503          	lbu	a0,-1(s1)
    80005c5a:	00000097          	auipc	ra,0x0
    80005c5e:	d56080e7          	jalr	-682(ra) # 800059b0 <consputc>
  while(--i >= 0)
    80005c62:	14fd                	addi	s1,s1,-1
    80005c64:	ff2499e3          	bne	s1,s2,80005c56 <printint+0x7e>
    80005c68:	64e2                	ld	s1,24(sp)
    80005c6a:	6942                	ld	s2,16(sp)
}
    80005c6c:	70a2                	ld	ra,40(sp)
    80005c6e:	7402                	ld	s0,32(sp)
    80005c70:	6145                	addi	sp,sp,48
    80005c72:	8082                	ret
    x = -xx;
    80005c74:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c78:	4885                	li	a7,1
    x = -xx;
    80005c7a:	bf85                	j	80005bea <printint+0x12>

0000000080005c7c <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c7c:	1101                	addi	sp,sp,-32
    80005c7e:	ec06                	sd	ra,24(sp)
    80005c80:	e822                	sd	s0,16(sp)
    80005c82:	e426                	sd	s1,8(sp)
    80005c84:	1000                	addi	s0,sp,32
    80005c86:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c88:	00020797          	auipc	a5,0x20
    80005c8c:	5607ac23          	sw	zero,1400(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005c90:	00003517          	auipc	a0,0x3
    80005c94:	ac050513          	addi	a0,a0,-1344 # 80008750 <etext+0x750>
    80005c98:	00000097          	auipc	ra,0x0
    80005c9c:	02e080e7          	jalr	46(ra) # 80005cc6 <printf>
  printf(s);
    80005ca0:	8526                	mv	a0,s1
    80005ca2:	00000097          	auipc	ra,0x0
    80005ca6:	024080e7          	jalr	36(ra) # 80005cc6 <printf>
  printf("\n");
    80005caa:	00002517          	auipc	a0,0x2
    80005cae:	36e50513          	addi	a0,a0,878 # 80008018 <etext+0x18>
    80005cb2:	00000097          	auipc	ra,0x0
    80005cb6:	014080e7          	jalr	20(ra) # 80005cc6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005cba:	4785                	li	a5,1
    80005cbc:	00003717          	auipc	a4,0x3
    80005cc0:	36f72023          	sw	a5,864(a4) # 8000901c <panicked>
  for(;;)
    80005cc4:	a001                	j	80005cc4 <panic+0x48>

0000000080005cc6 <printf>:
{
    80005cc6:	7131                	addi	sp,sp,-192
    80005cc8:	fc86                	sd	ra,120(sp)
    80005cca:	f8a2                	sd	s0,112(sp)
    80005ccc:	e8d2                	sd	s4,80(sp)
    80005cce:	f06a                	sd	s10,32(sp)
    80005cd0:	0100                	addi	s0,sp,128
    80005cd2:	8a2a                	mv	s4,a0
    80005cd4:	e40c                	sd	a1,8(s0)
    80005cd6:	e810                	sd	a2,16(s0)
    80005cd8:	ec14                	sd	a3,24(s0)
    80005cda:	f018                	sd	a4,32(s0)
    80005cdc:	f41c                	sd	a5,40(s0)
    80005cde:	03043823          	sd	a6,48(s0)
    80005ce2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ce6:	00020d17          	auipc	s10,0x20
    80005cea:	51ad2d03          	lw	s10,1306(s10) # 80026200 <pr+0x18>
  if(locking)
    80005cee:	040d1463          	bnez	s10,80005d36 <printf+0x70>
  if (fmt == 0)
    80005cf2:	040a0b63          	beqz	s4,80005d48 <printf+0x82>
  va_start(ap, fmt);
    80005cf6:	00840793          	addi	a5,s0,8
    80005cfa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cfe:	000a4503          	lbu	a0,0(s4)
    80005d02:	18050b63          	beqz	a0,80005e98 <printf+0x1d2>
    80005d06:	f4a6                	sd	s1,104(sp)
    80005d08:	f0ca                	sd	s2,96(sp)
    80005d0a:	ecce                	sd	s3,88(sp)
    80005d0c:	e4d6                	sd	s5,72(sp)
    80005d0e:	e0da                	sd	s6,64(sp)
    80005d10:	fc5e                	sd	s7,56(sp)
    80005d12:	f862                	sd	s8,48(sp)
    80005d14:	f466                	sd	s9,40(sp)
    80005d16:	ec6e                	sd	s11,24(sp)
    80005d18:	4981                	li	s3,0
    if(c != '%'){
    80005d1a:	02500b13          	li	s6,37
    switch(c){
    80005d1e:	07000b93          	li	s7,112
  consputc('x');
    80005d22:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d24:	00003a97          	auipc	s5,0x3
    80005d28:	b8ca8a93          	addi	s5,s5,-1140 # 800088b0 <digits>
    switch(c){
    80005d2c:	07300c13          	li	s8,115
    80005d30:	06400d93          	li	s11,100
    80005d34:	a0b1                	j	80005d80 <printf+0xba>
    acquire(&pr.lock);
    80005d36:	00020517          	auipc	a0,0x20
    80005d3a:	4b250513          	addi	a0,a0,1202 # 800261e8 <pr>
    80005d3e:	00000097          	auipc	ra,0x0
    80005d42:	4b8080e7          	jalr	1208(ra) # 800061f6 <acquire>
    80005d46:	b775                	j	80005cf2 <printf+0x2c>
    80005d48:	f4a6                	sd	s1,104(sp)
    80005d4a:	f0ca                	sd	s2,96(sp)
    80005d4c:	ecce                	sd	s3,88(sp)
    80005d4e:	e4d6                	sd	s5,72(sp)
    80005d50:	e0da                	sd	s6,64(sp)
    80005d52:	fc5e                	sd	s7,56(sp)
    80005d54:	f862                	sd	s8,48(sp)
    80005d56:	f466                	sd	s9,40(sp)
    80005d58:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005d5a:	00003517          	auipc	a0,0x3
    80005d5e:	a0650513          	addi	a0,a0,-1530 # 80008760 <etext+0x760>
    80005d62:	00000097          	auipc	ra,0x0
    80005d66:	f1a080e7          	jalr	-230(ra) # 80005c7c <panic>
      consputc(c);
    80005d6a:	00000097          	auipc	ra,0x0
    80005d6e:	c46080e7          	jalr	-954(ra) # 800059b0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d72:	2985                	addiw	s3,s3,1
    80005d74:	013a07b3          	add	a5,s4,s3
    80005d78:	0007c503          	lbu	a0,0(a5)
    80005d7c:	10050563          	beqz	a0,80005e86 <printf+0x1c0>
    if(c != '%'){
    80005d80:	ff6515e3          	bne	a0,s6,80005d6a <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005d84:	2985                	addiw	s3,s3,1
    80005d86:	013a07b3          	add	a5,s4,s3
    80005d8a:	0007c783          	lbu	a5,0(a5)
    80005d8e:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d92:	10078b63          	beqz	a5,80005ea8 <printf+0x1e2>
    switch(c){
    80005d96:	05778a63          	beq	a5,s7,80005dea <printf+0x124>
    80005d9a:	02fbf663          	bgeu	s7,a5,80005dc6 <printf+0x100>
    80005d9e:	09878863          	beq	a5,s8,80005e2e <printf+0x168>
    80005da2:	07800713          	li	a4,120
    80005da6:	0ce79563          	bne	a5,a4,80005e70 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    80005daa:	f8843783          	ld	a5,-120(s0)
    80005dae:	00878713          	addi	a4,a5,8
    80005db2:	f8e43423          	sd	a4,-120(s0)
    80005db6:	4605                	li	a2,1
    80005db8:	85e6                	mv	a1,s9
    80005dba:	4388                	lw	a0,0(a5)
    80005dbc:	00000097          	auipc	ra,0x0
    80005dc0:	e1c080e7          	jalr	-484(ra) # 80005bd8 <printint>
      break;
    80005dc4:	b77d                	j	80005d72 <printf+0xac>
    switch(c){
    80005dc6:	09678f63          	beq	a5,s6,80005e64 <printf+0x19e>
    80005dca:	0bb79363          	bne	a5,s11,80005e70 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    80005dce:	f8843783          	ld	a5,-120(s0)
    80005dd2:	00878713          	addi	a4,a5,8
    80005dd6:	f8e43423          	sd	a4,-120(s0)
    80005dda:	4605                	li	a2,1
    80005ddc:	45a9                	li	a1,10
    80005dde:	4388                	lw	a0,0(a5)
    80005de0:	00000097          	auipc	ra,0x0
    80005de4:	df8080e7          	jalr	-520(ra) # 80005bd8 <printint>
      break;
    80005de8:	b769                	j	80005d72 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005dea:	f8843783          	ld	a5,-120(s0)
    80005dee:	00878713          	addi	a4,a5,8
    80005df2:	f8e43423          	sd	a4,-120(s0)
    80005df6:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dfa:	03000513          	li	a0,48
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	bb2080e7          	jalr	-1102(ra) # 800059b0 <consputc>
  consputc('x');
    80005e06:	07800513          	li	a0,120
    80005e0a:	00000097          	auipc	ra,0x0
    80005e0e:	ba6080e7          	jalr	-1114(ra) # 800059b0 <consputc>
    80005e12:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e14:	03c95793          	srli	a5,s2,0x3c
    80005e18:	97d6                	add	a5,a5,s5
    80005e1a:	0007c503          	lbu	a0,0(a5)
    80005e1e:	00000097          	auipc	ra,0x0
    80005e22:	b92080e7          	jalr	-1134(ra) # 800059b0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e26:	0912                	slli	s2,s2,0x4
    80005e28:	34fd                	addiw	s1,s1,-1
    80005e2a:	f4ed                	bnez	s1,80005e14 <printf+0x14e>
    80005e2c:	b799                	j	80005d72 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005e2e:	f8843783          	ld	a5,-120(s0)
    80005e32:	00878713          	addi	a4,a5,8
    80005e36:	f8e43423          	sd	a4,-120(s0)
    80005e3a:	6384                	ld	s1,0(a5)
    80005e3c:	cc89                	beqz	s1,80005e56 <printf+0x190>
      for(; *s; s++)
    80005e3e:	0004c503          	lbu	a0,0(s1)
    80005e42:	d905                	beqz	a0,80005d72 <printf+0xac>
        consputc(*s);
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	b6c080e7          	jalr	-1172(ra) # 800059b0 <consputc>
      for(; *s; s++)
    80005e4c:	0485                	addi	s1,s1,1
    80005e4e:	0004c503          	lbu	a0,0(s1)
    80005e52:	f96d                	bnez	a0,80005e44 <printf+0x17e>
    80005e54:	bf39                	j	80005d72 <printf+0xac>
        s = "(null)";
    80005e56:	00003497          	auipc	s1,0x3
    80005e5a:	90248493          	addi	s1,s1,-1790 # 80008758 <etext+0x758>
      for(; *s; s++)
    80005e5e:	02800513          	li	a0,40
    80005e62:	b7cd                	j	80005e44 <printf+0x17e>
      consputc('%');
    80005e64:	855a                	mv	a0,s6
    80005e66:	00000097          	auipc	ra,0x0
    80005e6a:	b4a080e7          	jalr	-1206(ra) # 800059b0 <consputc>
      break;
    80005e6e:	b711                	j	80005d72 <printf+0xac>
      consputc('%');
    80005e70:	855a                	mv	a0,s6
    80005e72:	00000097          	auipc	ra,0x0
    80005e76:	b3e080e7          	jalr	-1218(ra) # 800059b0 <consputc>
      consputc(c);
    80005e7a:	8526                	mv	a0,s1
    80005e7c:	00000097          	auipc	ra,0x0
    80005e80:	b34080e7          	jalr	-1228(ra) # 800059b0 <consputc>
      break;
    80005e84:	b5fd                	j	80005d72 <printf+0xac>
    80005e86:	74a6                	ld	s1,104(sp)
    80005e88:	7906                	ld	s2,96(sp)
    80005e8a:	69e6                	ld	s3,88(sp)
    80005e8c:	6aa6                	ld	s5,72(sp)
    80005e8e:	6b06                	ld	s6,64(sp)
    80005e90:	7be2                	ld	s7,56(sp)
    80005e92:	7c42                	ld	s8,48(sp)
    80005e94:	7ca2                	ld	s9,40(sp)
    80005e96:	6de2                	ld	s11,24(sp)
  if(locking)
    80005e98:	020d1263          	bnez	s10,80005ebc <printf+0x1f6>
}
    80005e9c:	70e6                	ld	ra,120(sp)
    80005e9e:	7446                	ld	s0,112(sp)
    80005ea0:	6a46                	ld	s4,80(sp)
    80005ea2:	7d02                	ld	s10,32(sp)
    80005ea4:	6129                	addi	sp,sp,192
    80005ea6:	8082                	ret
    80005ea8:	74a6                	ld	s1,104(sp)
    80005eaa:	7906                	ld	s2,96(sp)
    80005eac:	69e6                	ld	s3,88(sp)
    80005eae:	6aa6                	ld	s5,72(sp)
    80005eb0:	6b06                	ld	s6,64(sp)
    80005eb2:	7be2                	ld	s7,56(sp)
    80005eb4:	7c42                	ld	s8,48(sp)
    80005eb6:	7ca2                	ld	s9,40(sp)
    80005eb8:	6de2                	ld	s11,24(sp)
    80005eba:	bff9                	j	80005e98 <printf+0x1d2>
    release(&pr.lock);
    80005ebc:	00020517          	auipc	a0,0x20
    80005ec0:	32c50513          	addi	a0,a0,812 # 800261e8 <pr>
    80005ec4:	00000097          	auipc	ra,0x0
    80005ec8:	3e6080e7          	jalr	998(ra) # 800062aa <release>
}
    80005ecc:	bfc1                	j	80005e9c <printf+0x1d6>

0000000080005ece <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ece:	1101                	addi	sp,sp,-32
    80005ed0:	ec06                	sd	ra,24(sp)
    80005ed2:	e822                	sd	s0,16(sp)
    80005ed4:	e426                	sd	s1,8(sp)
    80005ed6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005ed8:	00020497          	auipc	s1,0x20
    80005edc:	31048493          	addi	s1,s1,784 # 800261e8 <pr>
    80005ee0:	00003597          	auipc	a1,0x3
    80005ee4:	89058593          	addi	a1,a1,-1904 # 80008770 <etext+0x770>
    80005ee8:	8526                	mv	a0,s1
    80005eea:	00000097          	auipc	ra,0x0
    80005eee:	27c080e7          	jalr	636(ra) # 80006166 <initlock>
  pr.locking = 1;
    80005ef2:	4785                	li	a5,1
    80005ef4:	cc9c                	sw	a5,24(s1)
}
    80005ef6:	60e2                	ld	ra,24(sp)
    80005ef8:	6442                	ld	s0,16(sp)
    80005efa:	64a2                	ld	s1,8(sp)
    80005efc:	6105                	addi	sp,sp,32
    80005efe:	8082                	ret

0000000080005f00 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f00:	1141                	addi	sp,sp,-16
    80005f02:	e406                	sd	ra,8(sp)
    80005f04:	e022                	sd	s0,0(sp)
    80005f06:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f08:	100007b7          	lui	a5,0x10000
    80005f0c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f10:	10000737          	lui	a4,0x10000
    80005f14:	f8000693          	li	a3,-128
    80005f18:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f1c:	468d                	li	a3,3
    80005f1e:	10000637          	lui	a2,0x10000
    80005f22:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f26:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f2a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f2e:	10000737          	lui	a4,0x10000
    80005f32:	461d                	li	a2,7
    80005f34:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f38:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f3c:	00003597          	auipc	a1,0x3
    80005f40:	83c58593          	addi	a1,a1,-1988 # 80008778 <etext+0x778>
    80005f44:	00020517          	auipc	a0,0x20
    80005f48:	2c450513          	addi	a0,a0,708 # 80026208 <uart_tx_lock>
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	21a080e7          	jalr	538(ra) # 80006166 <initlock>
}
    80005f54:	60a2                	ld	ra,8(sp)
    80005f56:	6402                	ld	s0,0(sp)
    80005f58:	0141                	addi	sp,sp,16
    80005f5a:	8082                	ret

0000000080005f5c <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f5c:	1101                	addi	sp,sp,-32
    80005f5e:	ec06                	sd	ra,24(sp)
    80005f60:	e822                	sd	s0,16(sp)
    80005f62:	e426                	sd	s1,8(sp)
    80005f64:	1000                	addi	s0,sp,32
    80005f66:	84aa                	mv	s1,a0
  push_off();
    80005f68:	00000097          	auipc	ra,0x0
    80005f6c:	242080e7          	jalr	578(ra) # 800061aa <push_off>

  if(panicked){
    80005f70:	00003797          	auipc	a5,0x3
    80005f74:	0ac7a783          	lw	a5,172(a5) # 8000901c <panicked>
    80005f78:	eb85                	bnez	a5,80005fa8 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f7a:	10000737          	lui	a4,0x10000
    80005f7e:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005f80:	00074783          	lbu	a5,0(a4)
    80005f84:	0207f793          	andi	a5,a5,32
    80005f88:	dfe5                	beqz	a5,80005f80 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f8a:	0ff4f513          	zext.b	a0,s1
    80005f8e:	100007b7          	lui	a5,0x10000
    80005f92:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f96:	00000097          	auipc	ra,0x0
    80005f9a:	2b4080e7          	jalr	692(ra) # 8000624a <pop_off>
}
    80005f9e:	60e2                	ld	ra,24(sp)
    80005fa0:	6442                	ld	s0,16(sp)
    80005fa2:	64a2                	ld	s1,8(sp)
    80005fa4:	6105                	addi	sp,sp,32
    80005fa6:	8082                	ret
    for(;;)
    80005fa8:	a001                	j	80005fa8 <uartputc_sync+0x4c>

0000000080005faa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005faa:	00003797          	auipc	a5,0x3
    80005fae:	0767b783          	ld	a5,118(a5) # 80009020 <uart_tx_r>
    80005fb2:	00003717          	auipc	a4,0x3
    80005fb6:	07673703          	ld	a4,118(a4) # 80009028 <uart_tx_w>
    80005fba:	06f70f63          	beq	a4,a5,80006038 <uartstart+0x8e>
{
    80005fbe:	7139                	addi	sp,sp,-64
    80005fc0:	fc06                	sd	ra,56(sp)
    80005fc2:	f822                	sd	s0,48(sp)
    80005fc4:	f426                	sd	s1,40(sp)
    80005fc6:	f04a                	sd	s2,32(sp)
    80005fc8:	ec4e                	sd	s3,24(sp)
    80005fca:	e852                	sd	s4,16(sp)
    80005fcc:	e456                	sd	s5,8(sp)
    80005fce:	e05a                	sd	s6,0(sp)
    80005fd0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fd2:	10000937          	lui	s2,0x10000
    80005fd6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005fd8:	00020a97          	auipc	s5,0x20
    80005fdc:	230a8a93          	addi	s5,s5,560 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80005fe0:	00003497          	auipc	s1,0x3
    80005fe4:	04048493          	addi	s1,s1,64 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80005fe8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80005fec:	00003997          	auipc	s3,0x3
    80005ff0:	03c98993          	addi	s3,s3,60 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005ff4:	00094703          	lbu	a4,0(s2)
    80005ff8:	02077713          	andi	a4,a4,32
    80005ffc:	c705                	beqz	a4,80006024 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005ffe:	01f7f713          	andi	a4,a5,31
    80006002:	9756                	add	a4,a4,s5
    80006004:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006008:	0785                	addi	a5,a5,1
    8000600a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000600c:	8526                	mv	a0,s1
    8000600e:	ffffb097          	auipc	ra,0xffffb
    80006012:	6c8080e7          	jalr	1736(ra) # 800016d6 <wakeup>
    WriteReg(THR, c);
    80006016:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000601a:	609c                	ld	a5,0(s1)
    8000601c:	0009b703          	ld	a4,0(s3)
    80006020:	fcf71ae3          	bne	a4,a5,80005ff4 <uartstart+0x4a>
  }
}
    80006024:	70e2                	ld	ra,56(sp)
    80006026:	7442                	ld	s0,48(sp)
    80006028:	74a2                	ld	s1,40(sp)
    8000602a:	7902                	ld	s2,32(sp)
    8000602c:	69e2                	ld	s3,24(sp)
    8000602e:	6a42                	ld	s4,16(sp)
    80006030:	6aa2                	ld	s5,8(sp)
    80006032:	6b02                	ld	s6,0(sp)
    80006034:	6121                	addi	sp,sp,64
    80006036:	8082                	ret
    80006038:	8082                	ret

000000008000603a <uartputc>:
{
    8000603a:	7179                	addi	sp,sp,-48
    8000603c:	f406                	sd	ra,40(sp)
    8000603e:	f022                	sd	s0,32(sp)
    80006040:	e052                	sd	s4,0(sp)
    80006042:	1800                	addi	s0,sp,48
    80006044:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006046:	00020517          	auipc	a0,0x20
    8000604a:	1c250513          	addi	a0,a0,450 # 80026208 <uart_tx_lock>
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	1a8080e7          	jalr	424(ra) # 800061f6 <acquire>
  if(panicked){
    80006056:	00003797          	auipc	a5,0x3
    8000605a:	fc67a783          	lw	a5,-58(a5) # 8000901c <panicked>
    8000605e:	c391                	beqz	a5,80006062 <uartputc+0x28>
    for(;;)
    80006060:	a001                	j	80006060 <uartputc+0x26>
    80006062:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006064:	00003717          	auipc	a4,0x3
    80006068:	fc473703          	ld	a4,-60(a4) # 80009028 <uart_tx_w>
    8000606c:	00003797          	auipc	a5,0x3
    80006070:	fb47b783          	ld	a5,-76(a5) # 80009020 <uart_tx_r>
    80006074:	02078793          	addi	a5,a5,32
    80006078:	02e79f63          	bne	a5,a4,800060b6 <uartputc+0x7c>
    8000607c:	e84a                	sd	s2,16(sp)
    8000607e:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006080:	00020997          	auipc	s3,0x20
    80006084:	18898993          	addi	s3,s3,392 # 80026208 <uart_tx_lock>
    80006088:	00003497          	auipc	s1,0x3
    8000608c:	f9848493          	addi	s1,s1,-104 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006090:	00003917          	auipc	s2,0x3
    80006094:	f9890913          	addi	s2,s2,-104 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80006098:	85ce                	mv	a1,s3
    8000609a:	8526                	mv	a0,s1
    8000609c:	ffffb097          	auipc	ra,0xffffb
    800060a0:	4ae080e7          	jalr	1198(ra) # 8000154a <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060a4:	00093703          	ld	a4,0(s2)
    800060a8:	609c                	ld	a5,0(s1)
    800060aa:	02078793          	addi	a5,a5,32
    800060ae:	fee785e3          	beq	a5,a4,80006098 <uartputc+0x5e>
    800060b2:	6942                	ld	s2,16(sp)
    800060b4:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060b6:	00020497          	auipc	s1,0x20
    800060ba:	15248493          	addi	s1,s1,338 # 80026208 <uart_tx_lock>
    800060be:	01f77793          	andi	a5,a4,31
    800060c2:	97a6                	add	a5,a5,s1
    800060c4:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    800060c8:	0705                	addi	a4,a4,1
    800060ca:	00003797          	auipc	a5,0x3
    800060ce:	f4e7bf23          	sd	a4,-162(a5) # 80009028 <uart_tx_w>
      uartstart();
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	ed8080e7          	jalr	-296(ra) # 80005faa <uartstart>
      release(&uart_tx_lock);
    800060da:	8526                	mv	a0,s1
    800060dc:	00000097          	auipc	ra,0x0
    800060e0:	1ce080e7          	jalr	462(ra) # 800062aa <release>
    800060e4:	64e2                	ld	s1,24(sp)
}
    800060e6:	70a2                	ld	ra,40(sp)
    800060e8:	7402                	ld	s0,32(sp)
    800060ea:	6a02                	ld	s4,0(sp)
    800060ec:	6145                	addi	sp,sp,48
    800060ee:	8082                	ret

00000000800060f0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800060f0:	1141                	addi	sp,sp,-16
    800060f2:	e422                	sd	s0,8(sp)
    800060f4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060f6:	100007b7          	lui	a5,0x10000
    800060fa:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800060fc:	0007c783          	lbu	a5,0(a5)
    80006100:	8b85                	andi	a5,a5,1
    80006102:	cb81                	beqz	a5,80006112 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006104:	100007b7          	lui	a5,0x10000
    80006108:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000610c:	6422                	ld	s0,8(sp)
    8000610e:	0141                	addi	sp,sp,16
    80006110:	8082                	ret
    return -1;
    80006112:	557d                	li	a0,-1
    80006114:	bfe5                	j	8000610c <uartgetc+0x1c>

0000000080006116 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006116:	1101                	addi	sp,sp,-32
    80006118:	ec06                	sd	ra,24(sp)
    8000611a:	e822                	sd	s0,16(sp)
    8000611c:	e426                	sd	s1,8(sp)
    8000611e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006120:	54fd                	li	s1,-1
    80006122:	a029                	j	8000612c <uartintr+0x16>
      break;
    consoleintr(c);
    80006124:	00000097          	auipc	ra,0x0
    80006128:	8ce080e7          	jalr	-1842(ra) # 800059f2 <consoleintr>
    int c = uartgetc();
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	fc4080e7          	jalr	-60(ra) # 800060f0 <uartgetc>
    if(c == -1)
    80006134:	fe9518e3          	bne	a0,s1,80006124 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006138:	00020497          	auipc	s1,0x20
    8000613c:	0d048493          	addi	s1,s1,208 # 80026208 <uart_tx_lock>
    80006140:	8526                	mv	a0,s1
    80006142:	00000097          	auipc	ra,0x0
    80006146:	0b4080e7          	jalr	180(ra) # 800061f6 <acquire>
  uartstart();
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	e60080e7          	jalr	-416(ra) # 80005faa <uartstart>
  release(&uart_tx_lock);
    80006152:	8526                	mv	a0,s1
    80006154:	00000097          	auipc	ra,0x0
    80006158:	156080e7          	jalr	342(ra) # 800062aa <release>
}
    8000615c:	60e2                	ld	ra,24(sp)
    8000615e:	6442                	ld	s0,16(sp)
    80006160:	64a2                	ld	s1,8(sp)
    80006162:	6105                	addi	sp,sp,32
    80006164:	8082                	ret

0000000080006166 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80006166:	1141                	addi	sp,sp,-16
    80006168:	e422                	sd	s0,8(sp)
    8000616a:	0800                	addi	s0,sp,16
  lk->name = name;
    8000616c:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000616e:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006172:	00053823          	sd	zero,16(a0)
}
    80006176:	6422                	ld	s0,8(sp)
    80006178:	0141                	addi	sp,sp,16
    8000617a:	8082                	ret

000000008000617c <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000617c:	411c                	lw	a5,0(a0)
    8000617e:	e399                	bnez	a5,80006184 <holding+0x8>
    80006180:	4501                	li	a0,0
  return r;
}
    80006182:	8082                	ret
{
    80006184:	1101                	addi	sp,sp,-32
    80006186:	ec06                	sd	ra,24(sp)
    80006188:	e822                	sd	s0,16(sp)
    8000618a:	e426                	sd	s1,8(sp)
    8000618c:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000618e:	6904                	ld	s1,16(a0)
    80006190:	ffffb097          	auipc	ra,0xffffb
    80006194:	cd0080e7          	jalr	-816(ra) # 80000e60 <mycpu>
    80006198:	40a48533          	sub	a0,s1,a0
    8000619c:	00153513          	seqz	a0,a0
}
    800061a0:	60e2                	ld	ra,24(sp)
    800061a2:	6442                	ld	s0,16(sp)
    800061a4:	64a2                	ld	s1,8(sp)
    800061a6:	6105                	addi	sp,sp,32
    800061a8:	8082                	ret

00000000800061aa <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061aa:	1101                	addi	sp,sp,-32
    800061ac:	ec06                	sd	ra,24(sp)
    800061ae:	e822                	sd	s0,16(sp)
    800061b0:	e426                	sd	s1,8(sp)
    800061b2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061b4:	100024f3          	csrr	s1,sstatus
    800061b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800061bc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800061be:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800061c2:	ffffb097          	auipc	ra,0xffffb
    800061c6:	c9e080e7          	jalr	-866(ra) # 80000e60 <mycpu>
    800061ca:	5d3c                	lw	a5,120(a0)
    800061cc:	cf89                	beqz	a5,800061e6 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800061ce:	ffffb097          	auipc	ra,0xffffb
    800061d2:	c92080e7          	jalr	-878(ra) # 80000e60 <mycpu>
    800061d6:	5d3c                	lw	a5,120(a0)
    800061d8:	2785                	addiw	a5,a5,1
    800061da:	dd3c                	sw	a5,120(a0)
}
    800061dc:	60e2                	ld	ra,24(sp)
    800061de:	6442                	ld	s0,16(sp)
    800061e0:	64a2                	ld	s1,8(sp)
    800061e2:	6105                	addi	sp,sp,32
    800061e4:	8082                	ret
    mycpu()->intena = old;
    800061e6:	ffffb097          	auipc	ra,0xffffb
    800061ea:	c7a080e7          	jalr	-902(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800061ee:	8085                	srli	s1,s1,0x1
    800061f0:	8885                	andi	s1,s1,1
    800061f2:	dd64                	sw	s1,124(a0)
    800061f4:	bfe9                	j	800061ce <push_off+0x24>

00000000800061f6 <acquire>:
{
    800061f6:	1101                	addi	sp,sp,-32
    800061f8:	ec06                	sd	ra,24(sp)
    800061fa:	e822                	sd	s0,16(sp)
    800061fc:	e426                	sd	s1,8(sp)
    800061fe:	1000                	addi	s0,sp,32
    80006200:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006202:	00000097          	auipc	ra,0x0
    80006206:	fa8080e7          	jalr	-88(ra) # 800061aa <push_off>
  if(holding(lk))
    8000620a:	8526                	mv	a0,s1
    8000620c:	00000097          	auipc	ra,0x0
    80006210:	f70080e7          	jalr	-144(ra) # 8000617c <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006214:	4705                	li	a4,1
  if(holding(lk))
    80006216:	e115                	bnez	a0,8000623a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006218:	87ba                	mv	a5,a4
    8000621a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000621e:	2781                	sext.w	a5,a5
    80006220:	ffe5                	bnez	a5,80006218 <acquire+0x22>
  __sync_synchronize();
    80006222:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006226:	ffffb097          	auipc	ra,0xffffb
    8000622a:	c3a080e7          	jalr	-966(ra) # 80000e60 <mycpu>
    8000622e:	e888                	sd	a0,16(s1)
}
    80006230:	60e2                	ld	ra,24(sp)
    80006232:	6442                	ld	s0,16(sp)
    80006234:	64a2                	ld	s1,8(sp)
    80006236:	6105                	addi	sp,sp,32
    80006238:	8082                	ret
    panic("acquire");
    8000623a:	00002517          	auipc	a0,0x2
    8000623e:	54650513          	addi	a0,a0,1350 # 80008780 <etext+0x780>
    80006242:	00000097          	auipc	ra,0x0
    80006246:	a3a080e7          	jalr	-1478(ra) # 80005c7c <panic>

000000008000624a <pop_off>:

void
pop_off(void)
{
    8000624a:	1141                	addi	sp,sp,-16
    8000624c:	e406                	sd	ra,8(sp)
    8000624e:	e022                	sd	s0,0(sp)
    80006250:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006252:	ffffb097          	auipc	ra,0xffffb
    80006256:	c0e080e7          	jalr	-1010(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000625a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000625e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006260:	e78d                	bnez	a5,8000628a <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006262:	5d3c                	lw	a5,120(a0)
    80006264:	02f05b63          	blez	a5,8000629a <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006268:	37fd                	addiw	a5,a5,-1
    8000626a:	0007871b          	sext.w	a4,a5
    8000626e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006270:	eb09                	bnez	a4,80006282 <pop_off+0x38>
    80006272:	5d7c                	lw	a5,124(a0)
    80006274:	c799                	beqz	a5,80006282 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006276:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000627a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000627e:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006282:	60a2                	ld	ra,8(sp)
    80006284:	6402                	ld	s0,0(sp)
    80006286:	0141                	addi	sp,sp,16
    80006288:	8082                	ret
    panic("pop_off - interruptible");
    8000628a:	00002517          	auipc	a0,0x2
    8000628e:	4fe50513          	addi	a0,a0,1278 # 80008788 <etext+0x788>
    80006292:	00000097          	auipc	ra,0x0
    80006296:	9ea080e7          	jalr	-1558(ra) # 80005c7c <panic>
    panic("pop_off");
    8000629a:	00002517          	auipc	a0,0x2
    8000629e:	50650513          	addi	a0,a0,1286 # 800087a0 <etext+0x7a0>
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	9da080e7          	jalr	-1574(ra) # 80005c7c <panic>

00000000800062aa <release>:
{
    800062aa:	1101                	addi	sp,sp,-32
    800062ac:	ec06                	sd	ra,24(sp)
    800062ae:	e822                	sd	s0,16(sp)
    800062b0:	e426                	sd	s1,8(sp)
    800062b2:	1000                	addi	s0,sp,32
    800062b4:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062b6:	00000097          	auipc	ra,0x0
    800062ba:	ec6080e7          	jalr	-314(ra) # 8000617c <holding>
    800062be:	c115                	beqz	a0,800062e2 <release+0x38>
  lk->cpu = 0;
    800062c0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800062c4:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800062c8:	0f50000f          	fence	iorw,ow
    800062cc:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800062d0:	00000097          	auipc	ra,0x0
    800062d4:	f7a080e7          	jalr	-134(ra) # 8000624a <pop_off>
}
    800062d8:	60e2                	ld	ra,24(sp)
    800062da:	6442                	ld	s0,16(sp)
    800062dc:	64a2                	ld	s1,8(sp)
    800062de:	6105                	addi	sp,sp,32
    800062e0:	8082                	ret
    panic("release");
    800062e2:	00002517          	auipc	a0,0x2
    800062e6:	4c650513          	addi	a0,a0,1222 # 800087a8 <etext+0x7a8>
    800062ea:	00000097          	auipc	ra,0x0
    800062ee:	992080e7          	jalr	-1646(ra) # 80005c7c <panic>
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
