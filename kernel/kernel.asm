
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
    80000016:	0a1050ef          	jal	800058b6 <start>

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
    8000005e:	308080e7          	jalr	776(ra) # 80006362 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	3a4080e7          	jalr	932(ra) # 80006412 <release>
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
    8000008e:	d82080e7          	jalr	-638(ra) # 80005e0c <panic>

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
    800000fa:	1d8080e7          	jalr	472(ra) # 800062ce <initlock>
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
    80000132:	234080e7          	jalr	564(ra) # 80006362 <acquire>
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
    8000014a:	2cc080e7          	jalr	716(ra) # 80006412 <release>

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
    80000174:	2a2080e7          	jalr	674(ra) # 80006412 <release>
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
    8000036e:	af4080e7          	jalr	-1292(ra) # 80005e5e <printf>
    kvminithart();    // turn on paging
    80000372:	00000097          	auipc	ra,0x0
    80000376:	0d8080e7          	jalr	216(ra) # 8000044a <kvminithart>
    trapinithart();   // install kernel trap vector
    8000037a:	00001097          	auipc	ra,0x1
    8000037e:	786080e7          	jalr	1926(ra) # 80001b00 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000382:	00005097          	auipc	ra,0x5
    80000386:	f02080e7          	jalr	-254(ra) # 80005284 <plicinithart>
  }

  scheduler();        
    8000038a:	00001097          	auipc	ra,0x1
    8000038e:	038080e7          	jalr	56(ra) # 800013c2 <scheduler>
    consoleinit();
    80000392:	00006097          	auipc	ra,0x6
    80000396:	912080e7          	jalr	-1774(ra) # 80005ca4 <consoleinit>
    printfinit();
    8000039a:	00006097          	auipc	ra,0x6
    8000039e:	9e8080e7          	jalr	-1560(ra) # 80005d82 <printfinit>
    printf("\n");
    800003a2:	00008517          	auipc	a0,0x8
    800003a6:	c7650513          	addi	a0,a0,-906 # 80008018 <etext+0x18>
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	ab4080e7          	jalr	-1356(ra) # 80005e5e <printf>
    printf("xv6 kernel is booting\n");
    800003b2:	00008517          	auipc	a0,0x8
    800003b6:	c6e50513          	addi	a0,a0,-914 # 80008020 <etext+0x20>
    800003ba:	00006097          	auipc	ra,0x6
    800003be:	aa4080e7          	jalr	-1372(ra) # 80005e5e <printf>
    printf("\n");
    800003c2:	00008517          	auipc	a0,0x8
    800003c6:	c5650513          	addi	a0,a0,-938 # 80008018 <etext+0x18>
    800003ca:	00006097          	auipc	ra,0x6
    800003ce:	a94080e7          	jalr	-1388(ra) # 80005e5e <printf>
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
    800003f6:	6e6080e7          	jalr	1766(ra) # 80001ad8 <trapinit>
    trapinithart();  // install kernel trap vector
    800003fa:	00001097          	auipc	ra,0x1
    800003fe:	706080e7          	jalr	1798(ra) # 80001b00 <trapinithart>
    plicinit();      // set up interrupt controller
    80000402:	00005097          	auipc	ra,0x5
    80000406:	e68080e7          	jalr	-408(ra) # 8000526a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000040a:	00005097          	auipc	ra,0x5
    8000040e:	e7a080e7          	jalr	-390(ra) # 80005284 <plicinithart>
    binit();         // buffer cache
    80000412:	00002097          	auipc	ra,0x2
    80000416:	f46080e7          	jalr	-186(ra) # 80002358 <binit>
    iinit();         // inode table
    8000041a:	00002097          	auipc	ra,0x2
    8000041e:	5b4080e7          	jalr	1460(ra) # 800029ce <iinit>
    fileinit();      // file table
    80000422:	00003097          	auipc	ra,0x3
    80000426:	57e080e7          	jalr	1406(ra) # 800039a0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000042a:	00005097          	auipc	ra,0x5
    8000042e:	f7a080e7          	jalr	-134(ra) # 800053a4 <virtio_disk_init>
    userinit();      // first user process
    80000432:	00001097          	auipc	ra,0x1
    80000436:	d54080e7          	jalr	-684(ra) # 80001186 <userinit>
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
    800004e4:	92c080e7          	jalr	-1748(ra) # 80005e0c <panic>
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
    800005ca:	00006097          	auipc	ra,0x6
    800005ce:	842080e7          	jalr	-1982(ra) # 80005e0c <panic>
      panic("mappages: remap");
    800005d2:	00008517          	auipc	a0,0x8
    800005d6:	a9650513          	addi	a0,a0,-1386 # 80008068 <etext+0x68>
    800005da:	00006097          	auipc	ra,0x6
    800005de:	832080e7          	jalr	-1998(ra) # 80005e0c <panic>
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
    8000062c:	7e4080e7          	jalr	2020(ra) # 80005e0c <panic>

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
    8000076c:	6a4080e7          	jalr	1700(ra) # 80005e0c <panic>
      panic("uvmunmap: walk");
    80000770:	00008517          	auipc	a0,0x8
    80000774:	92850513          	addi	a0,a0,-1752 # 80008098 <etext+0x98>
    80000778:	00005097          	auipc	ra,0x5
    8000077c:	694080e7          	jalr	1684(ra) # 80005e0c <panic>
      panic("uvmunmap: not mapped");
    80000780:	00008517          	auipc	a0,0x8
    80000784:	92850513          	addi	a0,a0,-1752 # 800080a8 <etext+0xa8>
    80000788:	00005097          	auipc	ra,0x5
    8000078c:	684080e7          	jalr	1668(ra) # 80005e0c <panic>
      panic("uvmunmap: not a leaf");
    80000790:	00008517          	auipc	a0,0x8
    80000794:	93050513          	addi	a0,a0,-1744 # 800080c0 <etext+0xc0>
    80000798:	00005097          	auipc	ra,0x5
    8000079c:	674080e7          	jalr	1652(ra) # 80005e0c <panic>
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
    80000890:	580080e7          	jalr	1408(ra) # 80005e0c <panic>

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
    800009ee:	422080e7          	jalr	1058(ra) # 80005e0c <panic>
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
    80000ace:	342080e7          	jalr	834(ra) # 80005e0c <panic>
      panic("uvmcopy: page not present");
    80000ad2:	00007517          	auipc	a0,0x7
    80000ad6:	65650513          	addi	a0,a0,1622 # 80008128 <etext+0x128>
    80000ada:	00005097          	auipc	ra,0x5
    80000ade:	332080e7          	jalr	818(ra) # 80005e0c <panic>
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
    80000b4a:	2c6080e7          	jalr	710(ra) # 80005e0c <panic>

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
    80000d30:	1a1f67b7          	lui	a5,0x1a1f6
    80000d34:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    80000d38:	7d634937          	lui	s2,0x7d634
    80000d3c:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    80000d40:	1902                	slli	s2,s2,0x20
    80000d42:	993e                	add	s2,s2,a5
    80000d44:	040009b7          	lui	s3,0x4000
    80000d48:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d4a:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d4c:	4b99                	li	s7,6
    80000d4e:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d50:	0000fa97          	auipc	s5,0xf
    80000d54:	930a8a93          	addi	s5,s5,-1744 # 8000f680 <tickslock>
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
    80000d86:	18848493          	addi	s1,s1,392
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
    80000db2:	05e080e7          	jalr	94(ra) # 80005e0c <panic>

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
    80000dde:	4f4080e7          	jalr	1268(ra) # 800062ce <initlock>
  initlock(&wait_lock, "wait_lock");
    80000de2:	00007597          	auipc	a1,0x7
    80000de6:	38658593          	addi	a1,a1,902 # 80008168 <etext+0x168>
    80000dea:	00008517          	auipc	a0,0x8
    80000dee:	27e50513          	addi	a0,a0,638 # 80009068 <wait_lock>
    80000df2:	00005097          	auipc	ra,0x5
    80000df6:	4dc080e7          	jalr	1244(ra) # 800062ce <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dfa:	00008497          	auipc	s1,0x8
    80000dfe:	68648493          	addi	s1,s1,1670 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000e02:	00007b17          	auipc	s6,0x7
    80000e06:	376b0b13          	addi	s6,s6,886 # 80008178 <etext+0x178>
      p->kstack = KSTACK((int) (p - proc));
    80000e0a:	8aa6                	mv	s5,s1
    80000e0c:	1a1f67b7          	lui	a5,0x1a1f6
    80000e10:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    80000e14:	7d634937          	lui	s2,0x7d634
    80000e18:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    80000e1c:	1902                	slli	s2,s2,0x20
    80000e1e:	993e                	add	s2,s2,a5
    80000e20:	040009b7          	lui	s3,0x4000
    80000e24:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000e26:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e28:	0000fa17          	auipc	s4,0xf
    80000e2c:	858a0a13          	addi	s4,s4,-1960 # 8000f680 <tickslock>
      initlock(&p->lock, "proc");
    80000e30:	85da                	mv	a1,s6
    80000e32:	8526                	mv	a0,s1
    80000e34:	00005097          	auipc	ra,0x5
    80000e38:	49a080e7          	jalr	1178(ra) # 800062ce <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000e3c:	415487b3          	sub	a5,s1,s5
    80000e40:	878d                	srai	a5,a5,0x3
    80000e42:	032787b3          	mul	a5,a5,s2
    80000e46:	2785                	addiw	a5,a5,1
    80000e48:	00d7979b          	slliw	a5,a5,0xd
    80000e4c:	40f987b3          	sub	a5,s3,a5
    80000e50:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e52:	18848493          	addi	s1,s1,392
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
    80000eb0:	46a080e7          	jalr	1130(ra) # 80006316 <push_off>
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
    80000eca:	4f0080e7          	jalr	1264(ra) # 800063b6 <pop_off>
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
    80000eee:	528080e7          	jalr	1320(ra) # 80006412 <release>

  if (first) {
    80000ef2:	00008797          	auipc	a5,0x8
    80000ef6:	93e7a783          	lw	a5,-1730(a5) # 80008830 <first.1>
    80000efa:	eb89                	bnez	a5,80000f0c <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000efc:	00001097          	auipc	ra,0x1
    80000f00:	c20080e7          	jalr	-992(ra) # 80001b1c <usertrapret>
}
    80000f04:	60a2                	ld	ra,8(sp)
    80000f06:	6402                	ld	s0,0(sp)
    80000f08:	0141                	addi	sp,sp,16
    80000f0a:	8082                	ret
    first = 0;
    80000f0c:	00008797          	auipc	a5,0x8
    80000f10:	9207a223          	sw	zero,-1756(a5) # 80008830 <first.1>
    fsinit(ROOTDEV);
    80000f14:	4505                	li	a0,1
    80000f16:	00002097          	auipc	ra,0x2
    80000f1a:	a38080e7          	jalr	-1480(ra) # 8000294e <fsinit>
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
    80000f3a:	42c080e7          	jalr	1068(ra) # 80006362 <acquire>
  pid = nextpid;
    80000f3e:	00008797          	auipc	a5,0x8
    80000f42:	8f678793          	addi	a5,a5,-1802 # 80008834 <nextpid>
    80000f46:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f48:	0014871b          	addiw	a4,s1,1
    80000f4c:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f4e:	854a                	mv	a0,s2
    80000f50:	00005097          	auipc	ra,0x5
    80000f54:	4c2080e7          	jalr	1218(ra) # 80006412 <release>
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
    800010c4:	5c090913          	addi	s2,s2,1472 # 8000f680 <tickslock>
    acquire(&p->lock);
    800010c8:	8526                	mv	a0,s1
    800010ca:	00005097          	auipc	ra,0x5
    800010ce:	298080e7          	jalr	664(ra) # 80006362 <acquire>
    if(p->state == UNUSED) {
    800010d2:	4c9c                	lw	a5,24(s1)
    800010d4:	cf81                	beqz	a5,800010ec <allocproc+0x40>
      release(&p->lock);
    800010d6:	8526                	mv	a0,s1
    800010d8:	00005097          	auipc	ra,0x5
    800010dc:	33a080e7          	jalr	826(ra) # 80006412 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010e0:	18848493          	addi	s1,s1,392
    800010e4:	ff2492e3          	bne	s1,s2,800010c8 <allocproc+0x1c>
  return 0;
    800010e8:	4481                	li	s1,0
    800010ea:	a8b9                	j	80001148 <allocproc+0x9c>
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
    80001106:	c921                	beqz	a0,80001156 <allocproc+0xaa>
  p->pagetable = proc_pagetable(p);
    80001108:	8526                	mv	a0,s1
    8000110a:	00000097          	auipc	ra,0x0
    8000110e:	e5c080e7          	jalr	-420(ra) # 80000f66 <proc_pagetable>
    80001112:	892a                	mv	s2,a0
    80001114:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001116:	cd21                	beqz	a0,8000116e <allocproc+0xc2>
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
  p->alarm_interval = 0;
    8000113c:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    80001140:	1604b823          	sd	zero,368(s1)
  p->tickes_num = 0;
    80001144:	1604ac23          	sw	zero,376(s1)
}
    80001148:	8526                	mv	a0,s1
    8000114a:	60e2                	ld	ra,24(sp)
    8000114c:	6442                	ld	s0,16(sp)
    8000114e:	64a2                	ld	s1,8(sp)
    80001150:	6902                	ld	s2,0(sp)
    80001152:	6105                	addi	sp,sp,32
    80001154:	8082                	ret
    freeproc(p);
    80001156:	8526                	mv	a0,s1
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	efc080e7          	jalr	-260(ra) # 80001054 <freeproc>
    release(&p->lock);
    80001160:	8526                	mv	a0,s1
    80001162:	00005097          	auipc	ra,0x5
    80001166:	2b0080e7          	jalr	688(ra) # 80006412 <release>
    return 0;
    8000116a:	84ca                	mv	s1,s2
    8000116c:	bff1                	j	80001148 <allocproc+0x9c>
    freeproc(p);
    8000116e:	8526                	mv	a0,s1
    80001170:	00000097          	auipc	ra,0x0
    80001174:	ee4080e7          	jalr	-284(ra) # 80001054 <freeproc>
    release(&p->lock);
    80001178:	8526                	mv	a0,s1
    8000117a:	00005097          	auipc	ra,0x5
    8000117e:	298080e7          	jalr	664(ra) # 80006412 <release>
    return 0;
    80001182:	84ca                	mv	s1,s2
    80001184:	b7d1                	j	80001148 <allocproc+0x9c>

0000000080001186 <userinit>:
{
    80001186:	1101                	addi	sp,sp,-32
    80001188:	ec06                	sd	ra,24(sp)
    8000118a:	e822                	sd	s0,16(sp)
    8000118c:	e426                	sd	s1,8(sp)
    8000118e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001190:	00000097          	auipc	ra,0x0
    80001194:	f1c080e7          	jalr	-228(ra) # 800010ac <allocproc>
    80001198:	84aa                	mv	s1,a0
  initproc = p;
    8000119a:	00008797          	auipc	a5,0x8
    8000119e:	e6a7bb23          	sd	a0,-394(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    800011a2:	03400613          	li	a2,52
    800011a6:	00007597          	auipc	a1,0x7
    800011aa:	69a58593          	addi	a1,a1,1690 # 80008840 <initcode>
    800011ae:	6928                	ld	a0,80(a0)
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	672080e7          	jalr	1650(ra) # 80000822 <uvminit>
  p->sz = PGSIZE;
    800011b8:	6785                	lui	a5,0x1
    800011ba:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800011bc:	6cb8                	ld	a4,88(s1)
    800011be:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800011c2:	6cb8                	ld	a4,88(s1)
    800011c4:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011c6:	4641                	li	a2,16
    800011c8:	00007597          	auipc	a1,0x7
    800011cc:	fb858593          	addi	a1,a1,-72 # 80008180 <etext+0x180>
    800011d0:	15848513          	addi	a0,s1,344
    800011d4:	fffff097          	auipc	ra,0xfffff
    800011d8:	0fc080e7          	jalr	252(ra) # 800002d0 <safestrcpy>
  p->cwd = namei("/");
    800011dc:	00007517          	auipc	a0,0x7
    800011e0:	fb450513          	addi	a0,a0,-76 # 80008190 <etext+0x190>
    800011e4:	00002097          	auipc	ra,0x2
    800011e8:	1ca080e7          	jalr	458(ra) # 800033ae <namei>
    800011ec:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011f0:	478d                	li	a5,3
    800011f2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011f4:	8526                	mv	a0,s1
    800011f6:	00005097          	auipc	ra,0x5
    800011fa:	21c080e7          	jalr	540(ra) # 80006412 <release>
}
    800011fe:	60e2                	ld	ra,24(sp)
    80001200:	6442                	ld	s0,16(sp)
    80001202:	64a2                	ld	s1,8(sp)
    80001204:	6105                	addi	sp,sp,32
    80001206:	8082                	ret

0000000080001208 <growproc>:
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	e04a                	sd	s2,0(sp)
    80001212:	1000                	addi	s0,sp,32
    80001214:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001216:	00000097          	auipc	ra,0x0
    8000121a:	c8c080e7          	jalr	-884(ra) # 80000ea2 <myproc>
    8000121e:	892a                	mv	s2,a0
  sz = p->sz;
    80001220:	652c                	ld	a1,72(a0)
    80001222:	0005879b          	sext.w	a5,a1
  if(n > 0){
    80001226:	00904f63          	bgtz	s1,80001244 <growproc+0x3c>
  } else if(n < 0){
    8000122a:	0204cd63          	bltz	s1,80001264 <growproc+0x5c>
  p->sz = sz;
    8000122e:	1782                	slli	a5,a5,0x20
    80001230:	9381                	srli	a5,a5,0x20
    80001232:	04f93423          	sd	a5,72(s2)
  return 0;
    80001236:	4501                	li	a0,0
}
    80001238:	60e2                	ld	ra,24(sp)
    8000123a:	6442                	ld	s0,16(sp)
    8000123c:	64a2                	ld	s1,8(sp)
    8000123e:	6902                	ld	s2,0(sp)
    80001240:	6105                	addi	sp,sp,32
    80001242:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001244:	00f4863b          	addw	a2,s1,a5
    80001248:	1602                	slli	a2,a2,0x20
    8000124a:	9201                	srli	a2,a2,0x20
    8000124c:	1582                	slli	a1,a1,0x20
    8000124e:	9181                	srli	a1,a1,0x20
    80001250:	6928                	ld	a0,80(a0)
    80001252:	fffff097          	auipc	ra,0xfffff
    80001256:	68a080e7          	jalr	1674(ra) # 800008dc <uvmalloc>
    8000125a:	0005079b          	sext.w	a5,a0
    8000125e:	fbe1                	bnez	a5,8000122e <growproc+0x26>
      return -1;
    80001260:	557d                	li	a0,-1
    80001262:	bfd9                	j	80001238 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001264:	00f4863b          	addw	a2,s1,a5
    80001268:	1602                	slli	a2,a2,0x20
    8000126a:	9201                	srli	a2,a2,0x20
    8000126c:	1582                	slli	a1,a1,0x20
    8000126e:	9181                	srli	a1,a1,0x20
    80001270:	6928                	ld	a0,80(a0)
    80001272:	fffff097          	auipc	ra,0xfffff
    80001276:	622080e7          	jalr	1570(ra) # 80000894 <uvmdealloc>
    8000127a:	0005079b          	sext.w	a5,a0
    8000127e:	bf45                	j	8000122e <growproc+0x26>

0000000080001280 <fork>:
{
    80001280:	7139                	addi	sp,sp,-64
    80001282:	fc06                	sd	ra,56(sp)
    80001284:	f822                	sd	s0,48(sp)
    80001286:	f04a                	sd	s2,32(sp)
    80001288:	e456                	sd	s5,8(sp)
    8000128a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000128c:	00000097          	auipc	ra,0x0
    80001290:	c16080e7          	jalr	-1002(ra) # 80000ea2 <myproc>
    80001294:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	e16080e7          	jalr	-490(ra) # 800010ac <allocproc>
    8000129e:	12050063          	beqz	a0,800013be <fork+0x13e>
    800012a2:	e852                	sd	s4,16(sp)
    800012a4:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800012a6:	048ab603          	ld	a2,72(s5)
    800012aa:	692c                	ld	a1,80(a0)
    800012ac:	050ab503          	ld	a0,80(s5)
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	796080e7          	jalr	1942(ra) # 80000a46 <uvmcopy>
    800012b8:	04054a63          	bltz	a0,8000130c <fork+0x8c>
    800012bc:	f426                	sd	s1,40(sp)
    800012be:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800012c0:	048ab783          	ld	a5,72(s5)
    800012c4:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800012c8:	058ab683          	ld	a3,88(s5)
    800012cc:	87b6                	mv	a5,a3
    800012ce:	058a3703          	ld	a4,88(s4)
    800012d2:	12068693          	addi	a3,a3,288
    800012d6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012da:	6788                	ld	a0,8(a5)
    800012dc:	6b8c                	ld	a1,16(a5)
    800012de:	6f90                	ld	a2,24(a5)
    800012e0:	01073023          	sd	a6,0(a4)
    800012e4:	e708                	sd	a0,8(a4)
    800012e6:	eb0c                	sd	a1,16(a4)
    800012e8:	ef10                	sd	a2,24(a4)
    800012ea:	02078793          	addi	a5,a5,32
    800012ee:	02070713          	addi	a4,a4,32
    800012f2:	fed792e3          	bne	a5,a3,800012d6 <fork+0x56>
  np->trapframe->a0 = 0;
    800012f6:	058a3783          	ld	a5,88(s4)
    800012fa:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012fe:	0d0a8493          	addi	s1,s5,208
    80001302:	0d0a0913          	addi	s2,s4,208
    80001306:	150a8993          	addi	s3,s5,336
    8000130a:	a015                	j	8000132e <fork+0xae>
    freeproc(np);
    8000130c:	8552                	mv	a0,s4
    8000130e:	00000097          	auipc	ra,0x0
    80001312:	d46080e7          	jalr	-698(ra) # 80001054 <freeproc>
    release(&np->lock);
    80001316:	8552                	mv	a0,s4
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	0fa080e7          	jalr	250(ra) # 80006412 <release>
    return -1;
    80001320:	597d                	li	s2,-1
    80001322:	6a42                	ld	s4,16(sp)
    80001324:	a071                	j	800013b0 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001326:	04a1                	addi	s1,s1,8
    80001328:	0921                	addi	s2,s2,8
    8000132a:	01348b63          	beq	s1,s3,80001340 <fork+0xc0>
    if(p->ofile[i])
    8000132e:	6088                	ld	a0,0(s1)
    80001330:	d97d                	beqz	a0,80001326 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    80001332:	00002097          	auipc	ra,0x2
    80001336:	700080e7          	jalr	1792(ra) # 80003a32 <filedup>
    8000133a:	00a93023          	sd	a0,0(s2)
    8000133e:	b7e5                	j	80001326 <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001340:	150ab503          	ld	a0,336(s5)
    80001344:	00002097          	auipc	ra,0x2
    80001348:	840080e7          	jalr	-1984(ra) # 80002b84 <idup>
    8000134c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001350:	4641                	li	a2,16
    80001352:	158a8593          	addi	a1,s5,344
    80001356:	158a0513          	addi	a0,s4,344
    8000135a:	fffff097          	auipc	ra,0xfffff
    8000135e:	f76080e7          	jalr	-138(ra) # 800002d0 <safestrcpy>
  pid = np->pid;
    80001362:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001366:	8552                	mv	a0,s4
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	0aa080e7          	jalr	170(ra) # 80006412 <release>
  acquire(&wait_lock);
    80001370:	00008497          	auipc	s1,0x8
    80001374:	cf848493          	addi	s1,s1,-776 # 80009068 <wait_lock>
    80001378:	8526                	mv	a0,s1
    8000137a:	00005097          	auipc	ra,0x5
    8000137e:	fe8080e7          	jalr	-24(ra) # 80006362 <acquire>
  np->parent = p;
    80001382:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001386:	8526                	mv	a0,s1
    80001388:	00005097          	auipc	ra,0x5
    8000138c:	08a080e7          	jalr	138(ra) # 80006412 <release>
  acquire(&np->lock);
    80001390:	8552                	mv	a0,s4
    80001392:	00005097          	auipc	ra,0x5
    80001396:	fd0080e7          	jalr	-48(ra) # 80006362 <acquire>
  np->state = RUNNABLE;
    8000139a:	478d                	li	a5,3
    8000139c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800013a0:	8552                	mv	a0,s4
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	070080e7          	jalr	112(ra) # 80006412 <release>
  return pid;
    800013aa:	74a2                	ld	s1,40(sp)
    800013ac:	69e2                	ld	s3,24(sp)
    800013ae:	6a42                	ld	s4,16(sp)
}
    800013b0:	854a                	mv	a0,s2
    800013b2:	70e2                	ld	ra,56(sp)
    800013b4:	7442                	ld	s0,48(sp)
    800013b6:	7902                	ld	s2,32(sp)
    800013b8:	6aa2                	ld	s5,8(sp)
    800013ba:	6121                	addi	sp,sp,64
    800013bc:	8082                	ret
    return -1;
    800013be:	597d                	li	s2,-1
    800013c0:	bfc5                	j	800013b0 <fork+0x130>

00000000800013c2 <scheduler>:
{
    800013c2:	7139                	addi	sp,sp,-64
    800013c4:	fc06                	sd	ra,56(sp)
    800013c6:	f822                	sd	s0,48(sp)
    800013c8:	f426                	sd	s1,40(sp)
    800013ca:	f04a                	sd	s2,32(sp)
    800013cc:	ec4e                	sd	s3,24(sp)
    800013ce:	e852                	sd	s4,16(sp)
    800013d0:	e456                	sd	s5,8(sp)
    800013d2:	e05a                	sd	s6,0(sp)
    800013d4:	0080                	addi	s0,sp,64
    800013d6:	8792                	mv	a5,tp
  int id = r_tp();
    800013d8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013da:	00779a93          	slli	s5,a5,0x7
    800013de:	00008717          	auipc	a4,0x8
    800013e2:	c7270713          	addi	a4,a4,-910 # 80009050 <pid_lock>
    800013e6:	9756                	add	a4,a4,s5
    800013e8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013ec:	00008717          	auipc	a4,0x8
    800013f0:	c9c70713          	addi	a4,a4,-868 # 80009088 <cpus+0x8>
    800013f4:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013f6:	498d                	li	s3,3
        p->state = RUNNING;
    800013f8:	4b11                	li	s6,4
        c->proc = p;
    800013fa:	079e                	slli	a5,a5,0x7
    800013fc:	00008a17          	auipc	s4,0x8
    80001400:	c54a0a13          	addi	s4,s4,-940 # 80009050 <pid_lock>
    80001404:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001406:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000140a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000140e:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001412:	00008497          	auipc	s1,0x8
    80001416:	06e48493          	addi	s1,s1,110 # 80009480 <proc>
    8000141a:	0000e917          	auipc	s2,0xe
    8000141e:	26690913          	addi	s2,s2,614 # 8000f680 <tickslock>
    80001422:	a811                	j	80001436 <scheduler+0x74>
      release(&p->lock);
    80001424:	8526                	mv	a0,s1
    80001426:	00005097          	auipc	ra,0x5
    8000142a:	fec080e7          	jalr	-20(ra) # 80006412 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000142e:	18848493          	addi	s1,s1,392
    80001432:	fd248ae3          	beq	s1,s2,80001406 <scheduler+0x44>
      acquire(&p->lock);
    80001436:	8526                	mv	a0,s1
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	f2a080e7          	jalr	-214(ra) # 80006362 <acquire>
      if(p->state == RUNNABLE) {
    80001440:	4c9c                	lw	a5,24(s1)
    80001442:	ff3791e3          	bne	a5,s3,80001424 <scheduler+0x62>
        p->state = RUNNING;
    80001446:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    8000144a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000144e:	06048593          	addi	a1,s1,96
    80001452:	8556                	mv	a0,s5
    80001454:	00000097          	auipc	ra,0x0
    80001458:	61a080e7          	jalr	1562(ra) # 80001a6e <swtch>
        c->proc = 0;
    8000145c:	020a3823          	sd	zero,48(s4)
    80001460:	b7d1                	j	80001424 <scheduler+0x62>

0000000080001462 <sched>:
{
    80001462:	7179                	addi	sp,sp,-48
    80001464:	f406                	sd	ra,40(sp)
    80001466:	f022                	sd	s0,32(sp)
    80001468:	ec26                	sd	s1,24(sp)
    8000146a:	e84a                	sd	s2,16(sp)
    8000146c:	e44e                	sd	s3,8(sp)
    8000146e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001470:	00000097          	auipc	ra,0x0
    80001474:	a32080e7          	jalr	-1486(ra) # 80000ea2 <myproc>
    80001478:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000147a:	00005097          	auipc	ra,0x5
    8000147e:	e6e080e7          	jalr	-402(ra) # 800062e8 <holding>
    80001482:	c93d                	beqz	a0,800014f8 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001484:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001486:	2781                	sext.w	a5,a5
    80001488:	079e                	slli	a5,a5,0x7
    8000148a:	00008717          	auipc	a4,0x8
    8000148e:	bc670713          	addi	a4,a4,-1082 # 80009050 <pid_lock>
    80001492:	97ba                	add	a5,a5,a4
    80001494:	0a87a703          	lw	a4,168(a5)
    80001498:	4785                	li	a5,1
    8000149a:	06f71763          	bne	a4,a5,80001508 <sched+0xa6>
  if(p->state == RUNNING)
    8000149e:	4c98                	lw	a4,24(s1)
    800014a0:	4791                	li	a5,4
    800014a2:	06f70b63          	beq	a4,a5,80001518 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800014a6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800014aa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800014ac:	efb5                	bnez	a5,80001528 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800014ae:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800014b0:	00008917          	auipc	s2,0x8
    800014b4:	ba090913          	addi	s2,s2,-1120 # 80009050 <pid_lock>
    800014b8:	2781                	sext.w	a5,a5
    800014ba:	079e                	slli	a5,a5,0x7
    800014bc:	97ca                	add	a5,a5,s2
    800014be:	0ac7a983          	lw	s3,172(a5)
    800014c2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800014c4:	2781                	sext.w	a5,a5
    800014c6:	079e                	slli	a5,a5,0x7
    800014c8:	00008597          	auipc	a1,0x8
    800014cc:	bc058593          	addi	a1,a1,-1088 # 80009088 <cpus+0x8>
    800014d0:	95be                	add	a1,a1,a5
    800014d2:	06048513          	addi	a0,s1,96
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	598080e7          	jalr	1432(ra) # 80001a6e <swtch>
    800014de:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014e0:	2781                	sext.w	a5,a5
    800014e2:	079e                	slli	a5,a5,0x7
    800014e4:	993e                	add	s2,s2,a5
    800014e6:	0b392623          	sw	s3,172(s2)
}
    800014ea:	70a2                	ld	ra,40(sp)
    800014ec:	7402                	ld	s0,32(sp)
    800014ee:	64e2                	ld	s1,24(sp)
    800014f0:	6942                	ld	s2,16(sp)
    800014f2:	69a2                	ld	s3,8(sp)
    800014f4:	6145                	addi	sp,sp,48
    800014f6:	8082                	ret
    panic("sched p->lock");
    800014f8:	00007517          	auipc	a0,0x7
    800014fc:	ca050513          	addi	a0,a0,-864 # 80008198 <etext+0x198>
    80001500:	00005097          	auipc	ra,0x5
    80001504:	90c080e7          	jalr	-1780(ra) # 80005e0c <panic>
    panic("sched locks");
    80001508:	00007517          	auipc	a0,0x7
    8000150c:	ca050513          	addi	a0,a0,-864 # 800081a8 <etext+0x1a8>
    80001510:	00005097          	auipc	ra,0x5
    80001514:	8fc080e7          	jalr	-1796(ra) # 80005e0c <panic>
    panic("sched running");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	ca050513          	addi	a0,a0,-864 # 800081b8 <etext+0x1b8>
    80001520:	00005097          	auipc	ra,0x5
    80001524:	8ec080e7          	jalr	-1812(ra) # 80005e0c <panic>
    panic("sched interruptible");
    80001528:	00007517          	auipc	a0,0x7
    8000152c:	ca050513          	addi	a0,a0,-864 # 800081c8 <etext+0x1c8>
    80001530:	00005097          	auipc	ra,0x5
    80001534:	8dc080e7          	jalr	-1828(ra) # 80005e0c <panic>

0000000080001538 <yield>:
{
    80001538:	1101                	addi	sp,sp,-32
    8000153a:	ec06                	sd	ra,24(sp)
    8000153c:	e822                	sd	s0,16(sp)
    8000153e:	e426                	sd	s1,8(sp)
    80001540:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001542:	00000097          	auipc	ra,0x0
    80001546:	960080e7          	jalr	-1696(ra) # 80000ea2 <myproc>
    8000154a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	e16080e7          	jalr	-490(ra) # 80006362 <acquire>
  p->state = RUNNABLE;
    80001554:	478d                	li	a5,3
    80001556:	cc9c                	sw	a5,24(s1)
  sched();
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	f0a080e7          	jalr	-246(ra) # 80001462 <sched>
  release(&p->lock);
    80001560:	8526                	mv	a0,s1
    80001562:	00005097          	auipc	ra,0x5
    80001566:	eb0080e7          	jalr	-336(ra) # 80006412 <release>
}
    8000156a:	60e2                	ld	ra,24(sp)
    8000156c:	6442                	ld	s0,16(sp)
    8000156e:	64a2                	ld	s1,8(sp)
    80001570:	6105                	addi	sp,sp,32
    80001572:	8082                	ret

0000000080001574 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001574:	7179                	addi	sp,sp,-48
    80001576:	f406                	sd	ra,40(sp)
    80001578:	f022                	sd	s0,32(sp)
    8000157a:	ec26                	sd	s1,24(sp)
    8000157c:	e84a                	sd	s2,16(sp)
    8000157e:	e44e                	sd	s3,8(sp)
    80001580:	1800                	addi	s0,sp,48
    80001582:	89aa                	mv	s3,a0
    80001584:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001586:	00000097          	auipc	ra,0x0
    8000158a:	91c080e7          	jalr	-1764(ra) # 80000ea2 <myproc>
    8000158e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001590:	00005097          	auipc	ra,0x5
    80001594:	dd2080e7          	jalr	-558(ra) # 80006362 <acquire>
  release(lk);
    80001598:	854a                	mv	a0,s2
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	e78080e7          	jalr	-392(ra) # 80006412 <release>

  // Go to sleep.
  p->chan = chan;
    800015a2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800015a6:	4789                	li	a5,2
    800015a8:	cc9c                	sw	a5,24(s1)

  sched();
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	eb8080e7          	jalr	-328(ra) # 80001462 <sched>

  // Tidy up.
  p->chan = 0;
    800015b2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800015b6:	8526                	mv	a0,s1
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	e5a080e7          	jalr	-422(ra) # 80006412 <release>
  acquire(lk);
    800015c0:	854a                	mv	a0,s2
    800015c2:	00005097          	auipc	ra,0x5
    800015c6:	da0080e7          	jalr	-608(ra) # 80006362 <acquire>
}
    800015ca:	70a2                	ld	ra,40(sp)
    800015cc:	7402                	ld	s0,32(sp)
    800015ce:	64e2                	ld	s1,24(sp)
    800015d0:	6942                	ld	s2,16(sp)
    800015d2:	69a2                	ld	s3,8(sp)
    800015d4:	6145                	addi	sp,sp,48
    800015d6:	8082                	ret

00000000800015d8 <wait>:
{
    800015d8:	715d                	addi	sp,sp,-80
    800015da:	e486                	sd	ra,72(sp)
    800015dc:	e0a2                	sd	s0,64(sp)
    800015de:	fc26                	sd	s1,56(sp)
    800015e0:	f84a                	sd	s2,48(sp)
    800015e2:	f44e                	sd	s3,40(sp)
    800015e4:	f052                	sd	s4,32(sp)
    800015e6:	ec56                	sd	s5,24(sp)
    800015e8:	e85a                	sd	s6,16(sp)
    800015ea:	e45e                	sd	s7,8(sp)
    800015ec:	0880                	addi	s0,sp,80
    800015ee:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015f0:	00000097          	auipc	ra,0x0
    800015f4:	8b2080e7          	jalr	-1870(ra) # 80000ea2 <myproc>
    800015f8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015fa:	00008517          	auipc	a0,0x8
    800015fe:	a6e50513          	addi	a0,a0,-1426 # 80009068 <wait_lock>
    80001602:	00005097          	auipc	ra,0x5
    80001606:	d60080e7          	jalr	-672(ra) # 80006362 <acquire>
        if(np->state == ZOMBIE){
    8000160a:	4a15                	li	s4,5
        havekids = 1;
    8000160c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000160e:	0000e997          	auipc	s3,0xe
    80001612:	07298993          	addi	s3,s3,114 # 8000f680 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001616:	00008b97          	auipc	s7,0x8
    8000161a:	a52b8b93          	addi	s7,s7,-1454 # 80009068 <wait_lock>
    8000161e:	a875                	j	800016da <wait+0x102>
          pid = np->pid;
    80001620:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80001624:	000b0e63          	beqz	s6,80001640 <wait+0x68>
    80001628:	4691                	li	a3,4
    8000162a:	02c48613          	addi	a2,s1,44
    8000162e:	85da                	mv	a1,s6
    80001630:	05093503          	ld	a0,80(s2)
    80001634:	fffff097          	auipc	ra,0xfffff
    80001638:	51a080e7          	jalr	1306(ra) # 80000b4e <copyout>
    8000163c:	04054063          	bltz	a0,8000167c <wait+0xa4>
          freeproc(np);
    80001640:	8526                	mv	a0,s1
    80001642:	00000097          	auipc	ra,0x0
    80001646:	a12080e7          	jalr	-1518(ra) # 80001054 <freeproc>
          release(&np->lock);
    8000164a:	8526                	mv	a0,s1
    8000164c:	00005097          	auipc	ra,0x5
    80001650:	dc6080e7          	jalr	-570(ra) # 80006412 <release>
          release(&wait_lock);
    80001654:	00008517          	auipc	a0,0x8
    80001658:	a1450513          	addi	a0,a0,-1516 # 80009068 <wait_lock>
    8000165c:	00005097          	auipc	ra,0x5
    80001660:	db6080e7          	jalr	-586(ra) # 80006412 <release>
}
    80001664:	854e                	mv	a0,s3
    80001666:	60a6                	ld	ra,72(sp)
    80001668:	6406                	ld	s0,64(sp)
    8000166a:	74e2                	ld	s1,56(sp)
    8000166c:	7942                	ld	s2,48(sp)
    8000166e:	79a2                	ld	s3,40(sp)
    80001670:	7a02                	ld	s4,32(sp)
    80001672:	6ae2                	ld	s5,24(sp)
    80001674:	6b42                	ld	s6,16(sp)
    80001676:	6ba2                	ld	s7,8(sp)
    80001678:	6161                	addi	sp,sp,80
    8000167a:	8082                	ret
            release(&np->lock);
    8000167c:	8526                	mv	a0,s1
    8000167e:	00005097          	auipc	ra,0x5
    80001682:	d94080e7          	jalr	-620(ra) # 80006412 <release>
            release(&wait_lock);
    80001686:	00008517          	auipc	a0,0x8
    8000168a:	9e250513          	addi	a0,a0,-1566 # 80009068 <wait_lock>
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	d84080e7          	jalr	-636(ra) # 80006412 <release>
            return -1;
    80001696:	59fd                	li	s3,-1
    80001698:	b7f1                	j	80001664 <wait+0x8c>
    for(np = proc; np < &proc[NPROC]; np++){
    8000169a:	18848493          	addi	s1,s1,392
    8000169e:	03348463          	beq	s1,s3,800016c6 <wait+0xee>
      if(np->parent == p){
    800016a2:	7c9c                	ld	a5,56(s1)
    800016a4:	ff279be3          	bne	a5,s2,8000169a <wait+0xc2>
        acquire(&np->lock);
    800016a8:	8526                	mv	a0,s1
    800016aa:	00005097          	auipc	ra,0x5
    800016ae:	cb8080e7          	jalr	-840(ra) # 80006362 <acquire>
        if(np->state == ZOMBIE){
    800016b2:	4c9c                	lw	a5,24(s1)
    800016b4:	f74786e3          	beq	a5,s4,80001620 <wait+0x48>
        release(&np->lock);
    800016b8:	8526                	mv	a0,s1
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	d58080e7          	jalr	-680(ra) # 80006412 <release>
        havekids = 1;
    800016c2:	8756                	mv	a4,s5
    800016c4:	bfd9                	j	8000169a <wait+0xc2>
    if(!havekids || p->killed){
    800016c6:	c305                	beqz	a4,800016e6 <wait+0x10e>
    800016c8:	02892783          	lw	a5,40(s2)
    800016cc:	ef89                	bnez	a5,800016e6 <wait+0x10e>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ce:	85de                	mv	a1,s7
    800016d0:	854a                	mv	a0,s2
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	ea2080e7          	jalr	-350(ra) # 80001574 <sleep>
    havekids = 0;
    800016da:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    800016dc:	00008497          	auipc	s1,0x8
    800016e0:	da448493          	addi	s1,s1,-604 # 80009480 <proc>
    800016e4:	bf7d                	j	800016a2 <wait+0xca>
      release(&wait_lock);
    800016e6:	00008517          	auipc	a0,0x8
    800016ea:	98250513          	addi	a0,a0,-1662 # 80009068 <wait_lock>
    800016ee:	00005097          	auipc	ra,0x5
    800016f2:	d24080e7          	jalr	-732(ra) # 80006412 <release>
      return -1;
    800016f6:	59fd                	li	s3,-1
    800016f8:	b7b5                	j	80001664 <wait+0x8c>

00000000800016fa <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016fa:	7139                	addi	sp,sp,-64
    800016fc:	fc06                	sd	ra,56(sp)
    800016fe:	f822                	sd	s0,48(sp)
    80001700:	f426                	sd	s1,40(sp)
    80001702:	f04a                	sd	s2,32(sp)
    80001704:	ec4e                	sd	s3,24(sp)
    80001706:	e852                	sd	s4,16(sp)
    80001708:	e456                	sd	s5,8(sp)
    8000170a:	0080                	addi	s0,sp,64
    8000170c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000170e:	00008497          	auipc	s1,0x8
    80001712:	d7248493          	addi	s1,s1,-654 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001716:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001718:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000171a:	0000e917          	auipc	s2,0xe
    8000171e:	f6690913          	addi	s2,s2,-154 # 8000f680 <tickslock>
    80001722:	a811                	j	80001736 <wakeup+0x3c>
      }
      release(&p->lock);
    80001724:	8526                	mv	a0,s1
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	cec080e7          	jalr	-788(ra) # 80006412 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000172e:	18848493          	addi	s1,s1,392
    80001732:	03248663          	beq	s1,s2,8000175e <wakeup+0x64>
    if(p != myproc()){
    80001736:	fffff097          	auipc	ra,0xfffff
    8000173a:	76c080e7          	jalr	1900(ra) # 80000ea2 <myproc>
    8000173e:	fea488e3          	beq	s1,a0,8000172e <wakeup+0x34>
      acquire(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	00005097          	auipc	ra,0x5
    80001748:	c1e080e7          	jalr	-994(ra) # 80006362 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000174c:	4c9c                	lw	a5,24(s1)
    8000174e:	fd379be3          	bne	a5,s3,80001724 <wakeup+0x2a>
    80001752:	709c                	ld	a5,32(s1)
    80001754:	fd4798e3          	bne	a5,s4,80001724 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001758:	0154ac23          	sw	s5,24(s1)
    8000175c:	b7e1                	j	80001724 <wakeup+0x2a>
    }
  }
}
    8000175e:	70e2                	ld	ra,56(sp)
    80001760:	7442                	ld	s0,48(sp)
    80001762:	74a2                	ld	s1,40(sp)
    80001764:	7902                	ld	s2,32(sp)
    80001766:	69e2                	ld	s3,24(sp)
    80001768:	6a42                	ld	s4,16(sp)
    8000176a:	6aa2                	ld	s5,8(sp)
    8000176c:	6121                	addi	sp,sp,64
    8000176e:	8082                	ret

0000000080001770 <reparent>:
{
    80001770:	7179                	addi	sp,sp,-48
    80001772:	f406                	sd	ra,40(sp)
    80001774:	f022                	sd	s0,32(sp)
    80001776:	ec26                	sd	s1,24(sp)
    80001778:	e84a                	sd	s2,16(sp)
    8000177a:	e44e                	sd	s3,8(sp)
    8000177c:	e052                	sd	s4,0(sp)
    8000177e:	1800                	addi	s0,sp,48
    80001780:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001782:	00008497          	auipc	s1,0x8
    80001786:	cfe48493          	addi	s1,s1,-770 # 80009480 <proc>
      pp->parent = initproc;
    8000178a:	00008a17          	auipc	s4,0x8
    8000178e:	886a0a13          	addi	s4,s4,-1914 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001792:	0000e997          	auipc	s3,0xe
    80001796:	eee98993          	addi	s3,s3,-274 # 8000f680 <tickslock>
    8000179a:	a029                	j	800017a4 <reparent+0x34>
    8000179c:	18848493          	addi	s1,s1,392
    800017a0:	01348d63          	beq	s1,s3,800017ba <reparent+0x4a>
    if(pp->parent == p){
    800017a4:	7c9c                	ld	a5,56(s1)
    800017a6:	ff279be3          	bne	a5,s2,8000179c <reparent+0x2c>
      pp->parent = initproc;
    800017aa:	000a3503          	ld	a0,0(s4)
    800017ae:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	f4a080e7          	jalr	-182(ra) # 800016fa <wakeup>
    800017b8:	b7d5                	j	8000179c <reparent+0x2c>
}
    800017ba:	70a2                	ld	ra,40(sp)
    800017bc:	7402                	ld	s0,32(sp)
    800017be:	64e2                	ld	s1,24(sp)
    800017c0:	6942                	ld	s2,16(sp)
    800017c2:	69a2                	ld	s3,8(sp)
    800017c4:	6a02                	ld	s4,0(sp)
    800017c6:	6145                	addi	sp,sp,48
    800017c8:	8082                	ret

00000000800017ca <exit>:
{
    800017ca:	7179                	addi	sp,sp,-48
    800017cc:	f406                	sd	ra,40(sp)
    800017ce:	f022                	sd	s0,32(sp)
    800017d0:	ec26                	sd	s1,24(sp)
    800017d2:	e84a                	sd	s2,16(sp)
    800017d4:	e44e                	sd	s3,8(sp)
    800017d6:	e052                	sd	s4,0(sp)
    800017d8:	1800                	addi	s0,sp,48
    800017da:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017dc:	fffff097          	auipc	ra,0xfffff
    800017e0:	6c6080e7          	jalr	1734(ra) # 80000ea2 <myproc>
    800017e4:	89aa                	mv	s3,a0
  if(p == initproc)
    800017e6:	00008797          	auipc	a5,0x8
    800017ea:	82a7b783          	ld	a5,-2006(a5) # 80009010 <initproc>
    800017ee:	0d050493          	addi	s1,a0,208
    800017f2:	15050913          	addi	s2,a0,336
    800017f6:	00a79d63          	bne	a5,a0,80001810 <exit+0x46>
    panic("init exiting");
    800017fa:	00007517          	auipc	a0,0x7
    800017fe:	9e650513          	addi	a0,a0,-1562 # 800081e0 <etext+0x1e0>
    80001802:	00004097          	auipc	ra,0x4
    80001806:	60a080e7          	jalr	1546(ra) # 80005e0c <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000180a:	04a1                	addi	s1,s1,8
    8000180c:	01248b63          	beq	s1,s2,80001822 <exit+0x58>
    if(p->ofile[fd]){
    80001810:	6088                	ld	a0,0(s1)
    80001812:	dd65                	beqz	a0,8000180a <exit+0x40>
      fileclose(f);
    80001814:	00002097          	auipc	ra,0x2
    80001818:	270080e7          	jalr	624(ra) # 80003a84 <fileclose>
      p->ofile[fd] = 0;
    8000181c:	0004b023          	sd	zero,0(s1)
    80001820:	b7ed                	j	8000180a <exit+0x40>
  begin_op();
    80001822:	00002097          	auipc	ra,0x2
    80001826:	d92080e7          	jalr	-622(ra) # 800035b4 <begin_op>
  iput(p->cwd);
    8000182a:	1509b503          	ld	a0,336(s3)
    8000182e:	00001097          	auipc	ra,0x1
    80001832:	552080e7          	jalr	1362(ra) # 80002d80 <iput>
  end_op();
    80001836:	00002097          	auipc	ra,0x2
    8000183a:	df8080e7          	jalr	-520(ra) # 8000362e <end_op>
  p->cwd = 0;
    8000183e:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001842:	00008497          	auipc	s1,0x8
    80001846:	82648493          	addi	s1,s1,-2010 # 80009068 <wait_lock>
    8000184a:	8526                	mv	a0,s1
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	b16080e7          	jalr	-1258(ra) # 80006362 <acquire>
  reparent(p);
    80001854:	854e                	mv	a0,s3
    80001856:	00000097          	auipc	ra,0x0
    8000185a:	f1a080e7          	jalr	-230(ra) # 80001770 <reparent>
  wakeup(p->parent);
    8000185e:	0389b503          	ld	a0,56(s3)
    80001862:	00000097          	auipc	ra,0x0
    80001866:	e98080e7          	jalr	-360(ra) # 800016fa <wakeup>
  acquire(&p->lock);
    8000186a:	854e                	mv	a0,s3
    8000186c:	00005097          	auipc	ra,0x5
    80001870:	af6080e7          	jalr	-1290(ra) # 80006362 <acquire>
  p->xstate = status;
    80001874:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001878:	4795                	li	a5,5
    8000187a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	b92080e7          	jalr	-1134(ra) # 80006412 <release>
  sched();
    80001888:	00000097          	auipc	ra,0x0
    8000188c:	bda080e7          	jalr	-1062(ra) # 80001462 <sched>
  panic("zombie exit");
    80001890:	00007517          	auipc	a0,0x7
    80001894:	96050513          	addi	a0,a0,-1696 # 800081f0 <etext+0x1f0>
    80001898:	00004097          	auipc	ra,0x4
    8000189c:	574080e7          	jalr	1396(ra) # 80005e0c <panic>

00000000800018a0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800018a0:	7179                	addi	sp,sp,-48
    800018a2:	f406                	sd	ra,40(sp)
    800018a4:	f022                	sd	s0,32(sp)
    800018a6:	ec26                	sd	s1,24(sp)
    800018a8:	e84a                	sd	s2,16(sp)
    800018aa:	e44e                	sd	s3,8(sp)
    800018ac:	1800                	addi	s0,sp,48
    800018ae:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018b0:	00008497          	auipc	s1,0x8
    800018b4:	bd048493          	addi	s1,s1,-1072 # 80009480 <proc>
    800018b8:	0000e997          	auipc	s3,0xe
    800018bc:	dc898993          	addi	s3,s3,-568 # 8000f680 <tickslock>
    acquire(&p->lock);
    800018c0:	8526                	mv	a0,s1
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	aa0080e7          	jalr	-1376(ra) # 80006362 <acquire>
    if(p->pid == pid){
    800018ca:	589c                	lw	a5,48(s1)
    800018cc:	01278d63          	beq	a5,s2,800018e6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018d0:	8526                	mv	a0,s1
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	b40080e7          	jalr	-1216(ra) # 80006412 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018da:	18848493          	addi	s1,s1,392
    800018de:	ff3491e3          	bne	s1,s3,800018c0 <kill+0x20>
  }
  return -1;
    800018e2:	557d                	li	a0,-1
    800018e4:	a829                	j	800018fe <kill+0x5e>
      p->killed = 1;
    800018e6:	4785                	li	a5,1
    800018e8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018ea:	4c98                	lw	a4,24(s1)
    800018ec:	4789                	li	a5,2
    800018ee:	00f70f63          	beq	a4,a5,8000190c <kill+0x6c>
      release(&p->lock);
    800018f2:	8526                	mv	a0,s1
    800018f4:	00005097          	auipc	ra,0x5
    800018f8:	b1e080e7          	jalr	-1250(ra) # 80006412 <release>
      return 0;
    800018fc:	4501                	li	a0,0
}
    800018fe:	70a2                	ld	ra,40(sp)
    80001900:	7402                	ld	s0,32(sp)
    80001902:	64e2                	ld	s1,24(sp)
    80001904:	6942                	ld	s2,16(sp)
    80001906:	69a2                	ld	s3,8(sp)
    80001908:	6145                	addi	sp,sp,48
    8000190a:	8082                	ret
        p->state = RUNNABLE;
    8000190c:	478d                	li	a5,3
    8000190e:	cc9c                	sw	a5,24(s1)
    80001910:	b7cd                	j	800018f2 <kill+0x52>

0000000080001912 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001912:	7179                	addi	sp,sp,-48
    80001914:	f406                	sd	ra,40(sp)
    80001916:	f022                	sd	s0,32(sp)
    80001918:	ec26                	sd	s1,24(sp)
    8000191a:	e84a                	sd	s2,16(sp)
    8000191c:	e44e                	sd	s3,8(sp)
    8000191e:	e052                	sd	s4,0(sp)
    80001920:	1800                	addi	s0,sp,48
    80001922:	84aa                	mv	s1,a0
    80001924:	892e                	mv	s2,a1
    80001926:	89b2                	mv	s3,a2
    80001928:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000192a:	fffff097          	auipc	ra,0xfffff
    8000192e:	578080e7          	jalr	1400(ra) # 80000ea2 <myproc>
  if(user_dst){
    80001932:	c08d                	beqz	s1,80001954 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001934:	86d2                	mv	a3,s4
    80001936:	864e                	mv	a2,s3
    80001938:	85ca                	mv	a1,s2
    8000193a:	6928                	ld	a0,80(a0)
    8000193c:	fffff097          	auipc	ra,0xfffff
    80001940:	212080e7          	jalr	530(ra) # 80000b4e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001944:	70a2                	ld	ra,40(sp)
    80001946:	7402                	ld	s0,32(sp)
    80001948:	64e2                	ld	s1,24(sp)
    8000194a:	6942                	ld	s2,16(sp)
    8000194c:	69a2                	ld	s3,8(sp)
    8000194e:	6a02                	ld	s4,0(sp)
    80001950:	6145                	addi	sp,sp,48
    80001952:	8082                	ret
    memmove((char *)dst, src, len);
    80001954:	000a061b          	sext.w	a2,s4
    80001958:	85ce                	mv	a1,s3
    8000195a:	854a                	mv	a0,s2
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	882080e7          	jalr	-1918(ra) # 800001de <memmove>
    return 0;
    80001964:	8526                	mv	a0,s1
    80001966:	bff9                	j	80001944 <either_copyout+0x32>

0000000080001968 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001968:	7179                	addi	sp,sp,-48
    8000196a:	f406                	sd	ra,40(sp)
    8000196c:	f022                	sd	s0,32(sp)
    8000196e:	ec26                	sd	s1,24(sp)
    80001970:	e84a                	sd	s2,16(sp)
    80001972:	e44e                	sd	s3,8(sp)
    80001974:	e052                	sd	s4,0(sp)
    80001976:	1800                	addi	s0,sp,48
    80001978:	892a                	mv	s2,a0
    8000197a:	84ae                	mv	s1,a1
    8000197c:	89b2                	mv	s3,a2
    8000197e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001980:	fffff097          	auipc	ra,0xfffff
    80001984:	522080e7          	jalr	1314(ra) # 80000ea2 <myproc>
  if(user_src){
    80001988:	c08d                	beqz	s1,800019aa <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    8000198a:	86d2                	mv	a3,s4
    8000198c:	864e                	mv	a2,s3
    8000198e:	85ca                	mv	a1,s2
    80001990:	6928                	ld	a0,80(a0)
    80001992:	fffff097          	auipc	ra,0xfffff
    80001996:	248080e7          	jalr	584(ra) # 80000bda <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000199a:	70a2                	ld	ra,40(sp)
    8000199c:	7402                	ld	s0,32(sp)
    8000199e:	64e2                	ld	s1,24(sp)
    800019a0:	6942                	ld	s2,16(sp)
    800019a2:	69a2                	ld	s3,8(sp)
    800019a4:	6a02                	ld	s4,0(sp)
    800019a6:	6145                	addi	sp,sp,48
    800019a8:	8082                	ret
    memmove(dst, (char*)src, len);
    800019aa:	000a061b          	sext.w	a2,s4
    800019ae:	85ce                	mv	a1,s3
    800019b0:	854a                	mv	a0,s2
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	82c080e7          	jalr	-2004(ra) # 800001de <memmove>
    return 0;
    800019ba:	8526                	mv	a0,s1
    800019bc:	bff9                	j	8000199a <either_copyin+0x32>

00000000800019be <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019be:	715d                	addi	sp,sp,-80
    800019c0:	e486                	sd	ra,72(sp)
    800019c2:	e0a2                	sd	s0,64(sp)
    800019c4:	fc26                	sd	s1,56(sp)
    800019c6:	f84a                	sd	s2,48(sp)
    800019c8:	f44e                	sd	s3,40(sp)
    800019ca:	f052                	sd	s4,32(sp)
    800019cc:	ec56                	sd	s5,24(sp)
    800019ce:	e85a                	sd	s6,16(sp)
    800019d0:	e45e                	sd	s7,8(sp)
    800019d2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019d4:	00006517          	auipc	a0,0x6
    800019d8:	64450513          	addi	a0,a0,1604 # 80008018 <etext+0x18>
    800019dc:	00004097          	auipc	ra,0x4
    800019e0:	482080e7          	jalr	1154(ra) # 80005e5e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019e4:	00008497          	auipc	s1,0x8
    800019e8:	bf448493          	addi	s1,s1,-1036 # 800095d8 <proc+0x158>
    800019ec:	0000e917          	auipc	s2,0xe
    800019f0:	dec90913          	addi	s2,s2,-532 # 8000f7d8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019f6:	00007997          	auipc	s3,0x7
    800019fa:	80a98993          	addi	s3,s3,-2038 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019fe:	00007a97          	auipc	s5,0x7
    80001a02:	80aa8a93          	addi	s5,s5,-2038 # 80008208 <etext+0x208>
    printf("\n");
    80001a06:	00006a17          	auipc	s4,0x6
    80001a0a:	612a0a13          	addi	s4,s4,1554 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0e:	00007b97          	auipc	s7,0x7
    80001a12:	cfab8b93          	addi	s7,s7,-774 # 80008708 <states.0>
    80001a16:	a00d                	j	80001a38 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a18:	ed86a583          	lw	a1,-296(a3)
    80001a1c:	8556                	mv	a0,s5
    80001a1e:	00004097          	auipc	ra,0x4
    80001a22:	440080e7          	jalr	1088(ra) # 80005e5e <printf>
    printf("\n");
    80001a26:	8552                	mv	a0,s4
    80001a28:	00004097          	auipc	ra,0x4
    80001a2c:	436080e7          	jalr	1078(ra) # 80005e5e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a30:	18848493          	addi	s1,s1,392
    80001a34:	03248263          	beq	s1,s2,80001a58 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a38:	86a6                	mv	a3,s1
    80001a3a:	ec04a783          	lw	a5,-320(s1)
    80001a3e:	dbed                	beqz	a5,80001a30 <procdump+0x72>
      state = "???";
    80001a40:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a42:	fcfb6be3          	bltu	s6,a5,80001a18 <procdump+0x5a>
    80001a46:	02079713          	slli	a4,a5,0x20
    80001a4a:	01d75793          	srli	a5,a4,0x1d
    80001a4e:	97de                	add	a5,a5,s7
    80001a50:	6390                	ld	a2,0(a5)
    80001a52:	f279                	bnez	a2,80001a18 <procdump+0x5a>
      state = "???";
    80001a54:	864e                	mv	a2,s3
    80001a56:	b7c9                	j	80001a18 <procdump+0x5a>
  }
}
    80001a58:	60a6                	ld	ra,72(sp)
    80001a5a:	6406                	ld	s0,64(sp)
    80001a5c:	74e2                	ld	s1,56(sp)
    80001a5e:	7942                	ld	s2,48(sp)
    80001a60:	79a2                	ld	s3,40(sp)
    80001a62:	7a02                	ld	s4,32(sp)
    80001a64:	6ae2                	ld	s5,24(sp)
    80001a66:	6b42                	ld	s6,16(sp)
    80001a68:	6ba2                	ld	s7,8(sp)
    80001a6a:	6161                	addi	sp,sp,80
    80001a6c:	8082                	ret

0000000080001a6e <swtch>:
    80001a6e:	00153023          	sd	ra,0(a0)
    80001a72:	00253423          	sd	sp,8(a0)
    80001a76:	e900                	sd	s0,16(a0)
    80001a78:	ed04                	sd	s1,24(a0)
    80001a7a:	03253023          	sd	s2,32(a0)
    80001a7e:	03353423          	sd	s3,40(a0)
    80001a82:	03453823          	sd	s4,48(a0)
    80001a86:	03553c23          	sd	s5,56(a0)
    80001a8a:	05653023          	sd	s6,64(a0)
    80001a8e:	05753423          	sd	s7,72(a0)
    80001a92:	05853823          	sd	s8,80(a0)
    80001a96:	05953c23          	sd	s9,88(a0)
    80001a9a:	07a53023          	sd	s10,96(a0)
    80001a9e:	07b53423          	sd	s11,104(a0)
    80001aa2:	0005b083          	ld	ra,0(a1)
    80001aa6:	0085b103          	ld	sp,8(a1)
    80001aaa:	6980                	ld	s0,16(a1)
    80001aac:	6d84                	ld	s1,24(a1)
    80001aae:	0205b903          	ld	s2,32(a1)
    80001ab2:	0285b983          	ld	s3,40(a1)
    80001ab6:	0305ba03          	ld	s4,48(a1)
    80001aba:	0385ba83          	ld	s5,56(a1)
    80001abe:	0405bb03          	ld	s6,64(a1)
    80001ac2:	0485bb83          	ld	s7,72(a1)
    80001ac6:	0505bc03          	ld	s8,80(a1)
    80001aca:	0585bc83          	ld	s9,88(a1)
    80001ace:	0605bd03          	ld	s10,96(a1)
    80001ad2:	0685bd83          	ld	s11,104(a1)
    80001ad6:	8082                	ret

0000000080001ad8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ad8:	1141                	addi	sp,sp,-16
    80001ada:	e406                	sd	ra,8(sp)
    80001adc:	e022                	sd	s0,0(sp)
    80001ade:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ae0:	00006597          	auipc	a1,0x6
    80001ae4:	76058593          	addi	a1,a1,1888 # 80008240 <etext+0x240>
    80001ae8:	0000e517          	auipc	a0,0xe
    80001aec:	b9850513          	addi	a0,a0,-1128 # 8000f680 <tickslock>
    80001af0:	00004097          	auipc	ra,0x4
    80001af4:	7de080e7          	jalr	2014(ra) # 800062ce <initlock>
}
    80001af8:	60a2                	ld	ra,8(sp)
    80001afa:	6402                	ld	s0,0(sp)
    80001afc:	0141                	addi	sp,sp,16
    80001afe:	8082                	ret

0000000080001b00 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b00:	1141                	addi	sp,sp,-16
    80001b02:	e406                	sd	ra,8(sp)
    80001b04:	e022                	sd	s0,0(sp)
    80001b06:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b08:	00003797          	auipc	a5,0x3
    80001b0c:	6a878793          	addi	a5,a5,1704 # 800051b0 <kernelvec>
    80001b10:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b14:	60a2                	ld	ra,8(sp)
    80001b16:	6402                	ld	s0,0(sp)
    80001b18:	0141                	addi	sp,sp,16
    80001b1a:	8082                	ret

0000000080001b1c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b1c:	1141                	addi	sp,sp,-16
    80001b1e:	e406                	sd	ra,8(sp)
    80001b20:	e022                	sd	s0,0(sp)
    80001b22:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	37e080e7          	jalr	894(ra) # 80000ea2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b2c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b30:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b32:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001b36:	00005697          	auipc	a3,0x5
    80001b3a:	4ca68693          	addi	a3,a3,1226 # 80007000 <_trampoline>
    80001b3e:	00005717          	auipc	a4,0x5
    80001b42:	4c270713          	addi	a4,a4,1218 # 80007000 <_trampoline>
    80001b46:	8f15                	sub	a4,a4,a3
    80001b48:	040007b7          	lui	a5,0x4000
    80001b4c:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001b4e:	07b2                	slli	a5,a5,0xc
    80001b50:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b52:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b56:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b58:	18002673          	csrr	a2,satp
    80001b5c:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b5e:	6d30                	ld	a2,88(a0)
    80001b60:	6138                	ld	a4,64(a0)
    80001b62:	6585                	lui	a1,0x1
    80001b64:	972e                	add	a4,a4,a1
    80001b66:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b68:	6d38                	ld	a4,88(a0)
    80001b6a:	00000617          	auipc	a2,0x0
    80001b6e:	14060613          	addi	a2,a2,320 # 80001caa <usertrap>
    80001b72:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b74:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b76:	8612                	mv	a2,tp
    80001b78:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b7a:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b7e:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b82:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b86:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b8a:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b8c:	6f18                	ld	a4,24(a4)
    80001b8e:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b92:	692c                	ld	a1,80(a0)
    80001b94:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001b96:	00005717          	auipc	a4,0x5
    80001b9a:	4fa70713          	addi	a4,a4,1274 # 80007090 <userret>
    80001b9e:	8f15                	sub	a4,a4,a3
    80001ba0:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001ba2:	577d                	li	a4,-1
    80001ba4:	177e                	slli	a4,a4,0x3f
    80001ba6:	8dd9                	or	a1,a1,a4
    80001ba8:	02000537          	lui	a0,0x2000
    80001bac:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001bae:	0536                	slli	a0,a0,0xd
    80001bb0:	9782                	jalr	a5
}
    80001bb2:	60a2                	ld	ra,8(sp)
    80001bb4:	6402                	ld	s0,0(sp)
    80001bb6:	0141                	addi	sp,sp,16
    80001bb8:	8082                	ret

0000000080001bba <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bba:	1101                	addi	sp,sp,-32
    80001bbc:	ec06                	sd	ra,24(sp)
    80001bbe:	e822                	sd	s0,16(sp)
    80001bc0:	e426                	sd	s1,8(sp)
    80001bc2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bc4:	0000e497          	auipc	s1,0xe
    80001bc8:	abc48493          	addi	s1,s1,-1348 # 8000f680 <tickslock>
    80001bcc:	8526                	mv	a0,s1
    80001bce:	00004097          	auipc	ra,0x4
    80001bd2:	794080e7          	jalr	1940(ra) # 80006362 <acquire>
  ticks++;
    80001bd6:	00007517          	auipc	a0,0x7
    80001bda:	44250513          	addi	a0,a0,1090 # 80009018 <ticks>
    80001bde:	411c                	lw	a5,0(a0)
    80001be0:	2785                	addiw	a5,a5,1
    80001be2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001be4:	00000097          	auipc	ra,0x0
    80001be8:	b16080e7          	jalr	-1258(ra) # 800016fa <wakeup>
  release(&tickslock);
    80001bec:	8526                	mv	a0,s1
    80001bee:	00005097          	auipc	ra,0x5
    80001bf2:	824080e7          	jalr	-2012(ra) # 80006412 <release>
}
    80001bf6:	60e2                	ld	ra,24(sp)
    80001bf8:	6442                	ld	s0,16(sp)
    80001bfa:	64a2                	ld	s1,8(sp)
    80001bfc:	6105                	addi	sp,sp,32
    80001bfe:	8082                	ret

0000000080001c00 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c00:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c04:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c06:	0a07d163          	bgez	a5,80001ca8 <devintr+0xa8>
{
    80001c0a:	1101                	addi	sp,sp,-32
    80001c0c:	ec06                	sd	ra,24(sp)
    80001c0e:	e822                	sd	s0,16(sp)
    80001c10:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c12:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c16:	46a5                	li	a3,9
    80001c18:	00d70c63          	beq	a4,a3,80001c30 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001c1c:	577d                	li	a4,-1
    80001c1e:	177e                	slli	a4,a4,0x3f
    80001c20:	0705                	addi	a4,a4,1
    return 0;
    80001c22:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c24:	06e78163          	beq	a5,a4,80001c86 <devintr+0x86>
  }
}
    80001c28:	60e2                	ld	ra,24(sp)
    80001c2a:	6442                	ld	s0,16(sp)
    80001c2c:	6105                	addi	sp,sp,32
    80001c2e:	8082                	ret
    80001c30:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c32:	00003097          	auipc	ra,0x3
    80001c36:	68a080e7          	jalr	1674(ra) # 800052bc <plic_claim>
    80001c3a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c3c:	47a9                	li	a5,10
    80001c3e:	00f50963          	beq	a0,a5,80001c50 <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001c42:	4785                	li	a5,1
    80001c44:	00f50b63          	beq	a0,a5,80001c5a <devintr+0x5a>
    return 1;
    80001c48:	4505                	li	a0,1
    } else if(irq){
    80001c4a:	ec89                	bnez	s1,80001c64 <devintr+0x64>
    80001c4c:	64a2                	ld	s1,8(sp)
    80001c4e:	bfe9                	j	80001c28 <devintr+0x28>
      uartintr();
    80001c50:	00004097          	auipc	ra,0x4
    80001c54:	62e080e7          	jalr	1582(ra) # 8000627e <uartintr>
    if(irq)
    80001c58:	a839                	j	80001c76 <devintr+0x76>
      virtio_disk_intr();
    80001c5a:	00004097          	auipc	ra,0x4
    80001c5e:	b1c080e7          	jalr	-1252(ra) # 80005776 <virtio_disk_intr>
    if(irq)
    80001c62:	a811                	j	80001c76 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c64:	85a6                	mv	a1,s1
    80001c66:	00006517          	auipc	a0,0x6
    80001c6a:	5e250513          	addi	a0,a0,1506 # 80008248 <etext+0x248>
    80001c6e:	00004097          	auipc	ra,0x4
    80001c72:	1f0080e7          	jalr	496(ra) # 80005e5e <printf>
      plic_complete(irq);
    80001c76:	8526                	mv	a0,s1
    80001c78:	00003097          	auipc	ra,0x3
    80001c7c:	668080e7          	jalr	1640(ra) # 800052e0 <plic_complete>
    return 1;
    80001c80:	4505                	li	a0,1
    80001c82:	64a2                	ld	s1,8(sp)
    80001c84:	b755                	j	80001c28 <devintr+0x28>
    if(cpuid() == 0){
    80001c86:	fffff097          	auipc	ra,0xfffff
    80001c8a:	1e8080e7          	jalr	488(ra) # 80000e6e <cpuid>
    80001c8e:	c901                	beqz	a0,80001c9e <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c90:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c94:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c96:	14479073          	csrw	sip,a5
    return 2;
    80001c9a:	4509                	li	a0,2
    80001c9c:	b771                	j	80001c28 <devintr+0x28>
      clockintr();
    80001c9e:	00000097          	auipc	ra,0x0
    80001ca2:	f1c080e7          	jalr	-228(ra) # 80001bba <clockintr>
    80001ca6:	b7ed                	j	80001c90 <devintr+0x90>
}
    80001ca8:	8082                	ret

0000000080001caa <usertrap>:
{
    80001caa:	1101                	addi	sp,sp,-32
    80001cac:	ec06                	sd	ra,24(sp)
    80001cae:	e822                	sd	s0,16(sp)
    80001cb0:	e426                	sd	s1,8(sp)
    80001cb2:	e04a                	sd	s2,0(sp)
    80001cb4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cb6:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cba:	1007f793          	andi	a5,a5,256
    80001cbe:	e3ad                	bnez	a5,80001d20 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc0:	00003797          	auipc	a5,0x3
    80001cc4:	4f078793          	addi	a5,a5,1264 # 800051b0 <kernelvec>
    80001cc8:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ccc:	fffff097          	auipc	ra,0xfffff
    80001cd0:	1d6080e7          	jalr	470(ra) # 80000ea2 <myproc>
    80001cd4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cd6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cd8:	14102773          	csrr	a4,sepc
    80001cdc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cde:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ce2:	47a1                	li	a5,8
    80001ce4:	04f71c63          	bne	a4,a5,80001d3c <usertrap+0x92>
    if(p->killed)
    80001ce8:	551c                	lw	a5,40(a0)
    80001cea:	e3b9                	bnez	a5,80001d30 <usertrap+0x86>
    p->trapframe->epc += 4;
    80001cec:	6cb8                	ld	a4,88(s1)
    80001cee:	6f1c                	ld	a5,24(a4)
    80001cf0:	0791                	addi	a5,a5,4
    80001cf2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001cf8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cfc:	10079073          	csrw	sstatus,a5
    syscall();
    80001d00:	00000097          	auipc	ra,0x0
    80001d04:	328080e7          	jalr	808(ra) # 80002028 <syscall>
  if(p->killed)
    80001d08:	549c                	lw	a5,40(s1)
    80001d0a:	e7c5                	bnez	a5,80001db2 <usertrap+0x108>
  usertrapret();
    80001d0c:	00000097          	auipc	ra,0x0
    80001d10:	e10080e7          	jalr	-496(ra) # 80001b1c <usertrapret>
}
    80001d14:	60e2                	ld	ra,24(sp)
    80001d16:	6442                	ld	s0,16(sp)
    80001d18:	64a2                	ld	s1,8(sp)
    80001d1a:	6902                	ld	s2,0(sp)
    80001d1c:	6105                	addi	sp,sp,32
    80001d1e:	8082                	ret
    panic("usertrap: not from user mode");
    80001d20:	00006517          	auipc	a0,0x6
    80001d24:	54850513          	addi	a0,a0,1352 # 80008268 <etext+0x268>
    80001d28:	00004097          	auipc	ra,0x4
    80001d2c:	0e4080e7          	jalr	228(ra) # 80005e0c <panic>
      exit(-1);
    80001d30:	557d                	li	a0,-1
    80001d32:	00000097          	auipc	ra,0x0
    80001d36:	a98080e7          	jalr	-1384(ra) # 800017ca <exit>
    80001d3a:	bf4d                	j	80001cec <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001d3c:	00000097          	auipc	ra,0x0
    80001d40:	ec4080e7          	jalr	-316(ra) # 80001c00 <devintr>
    80001d44:	892a                	mv	s2,a0
    80001d46:	c501                	beqz	a0,80001d4e <usertrap+0xa4>
  if(p->killed)
    80001d48:	549c                	lw	a5,40(s1)
    80001d4a:	c3a1                	beqz	a5,80001d8a <usertrap+0xe0>
    80001d4c:	a815                	j	80001d80 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d4e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d52:	5890                	lw	a2,48(s1)
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	53450513          	addi	a0,a0,1332 # 80008288 <etext+0x288>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	102080e7          	jalr	258(ra) # 80005e5e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d64:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d68:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d6c:	00006517          	auipc	a0,0x6
    80001d70:	54c50513          	addi	a0,a0,1356 # 800082b8 <etext+0x2b8>
    80001d74:	00004097          	auipc	ra,0x4
    80001d78:	0ea080e7          	jalr	234(ra) # 80005e5e <printf>
    p->killed = 1;
    80001d7c:	4785                	li	a5,1
    80001d7e:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001d80:	557d                	li	a0,-1
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	a48080e7          	jalr	-1464(ra) # 800017ca <exit>
  if(which_dev == 2){
    80001d8a:	4789                	li	a5,2
    80001d8c:	f8f910e3          	bne	s2,a5,80001d0c <usertrap+0x62>
    p->tickes_num++;
    80001d90:	1784a783          	lw	a5,376(s1)
    80001d94:	2785                	addiw	a5,a5,1
    80001d96:	873e                	mv	a4,a5
    80001d98:	16f4ac23          	sw	a5,376(s1)
    if (p->alarm_interval > 0 && p->tickes_num == p->alarm_interval) {
    80001d9c:	1684a783          	lw	a5,360(s1)
    80001da0:	00f05463          	blez	a5,80001da8 <usertrap+0xfe>
    80001da4:	00f70963          	beq	a4,a5,80001db6 <usertrap+0x10c>
    yield(); 
    80001da8:	fffff097          	auipc	ra,0xfffff
    80001dac:	790080e7          	jalr	1936(ra) # 80001538 <yield>
    80001db0:	bfb1                	j	80001d0c <usertrap+0x62>
  int which_dev = 0;
    80001db2:	4901                	li	s2,0
    80001db4:	b7f1                	j	80001d80 <usertrap+0xd6>
      if (p->alarm_trapframe == 0) {
    80001db6:	1804b783          	ld	a5,384(s1)
    80001dba:	f7fd                	bnez	a5,80001da8 <usertrap+0xfe>
        p->tickes_num = 0;
    80001dbc:	1604ac23          	sw	zero,376(s1)
        p->alarm_trapframe = (struct trapframe*)kalloc();
    80001dc0:	ffffe097          	auipc	ra,0xffffe
    80001dc4:	35a080e7          	jalr	858(ra) # 8000011a <kalloc>
    80001dc8:	18a4b023          	sd	a0,384(s1)
        if (p->alarm_trapframe) {
    80001dcc:	dd71                	beqz	a0,80001da8 <usertrap+0xfe>
          memmove(p->alarm_trapframe, p->trapframe, sizeof(struct trapframe));
    80001dce:	12000613          	li	a2,288
    80001dd2:	6cac                	ld	a1,88(s1)
    80001dd4:	ffffe097          	auipc	ra,0xffffe
    80001dd8:	40a080e7          	jalr	1034(ra) # 800001de <memmove>
          p->trapframe->epc = p->handler;
    80001ddc:	6cbc                	ld	a5,88(s1)
    80001dde:	1704b703          	ld	a4,368(s1)
    80001de2:	ef98                	sd	a4,24(a5)
    80001de4:	b7d1                	j	80001da8 <usertrap+0xfe>

0000000080001de6 <kerneltrap>:
{
    80001de6:	7179                	addi	sp,sp,-48
    80001de8:	f406                	sd	ra,40(sp)
    80001dea:	f022                	sd	s0,32(sp)
    80001dec:	ec26                	sd	s1,24(sp)
    80001dee:	e84a                	sd	s2,16(sp)
    80001df0:	e44e                	sd	s3,8(sp)
    80001df2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001df4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001df8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dfc:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e00:	1004f793          	andi	a5,s1,256
    80001e04:	cb85                	beqz	a5,80001e34 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e06:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e0a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e0c:	ef85                	bnez	a5,80001e44 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	df2080e7          	jalr	-526(ra) # 80001c00 <devintr>
    80001e16:	cd1d                	beqz	a0,80001e54 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e18:	4789                	li	a5,2
    80001e1a:	06f50a63          	beq	a0,a5,80001e8e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e1e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e22:	10049073          	csrw	sstatus,s1
}
    80001e26:	70a2                	ld	ra,40(sp)
    80001e28:	7402                	ld	s0,32(sp)
    80001e2a:	64e2                	ld	s1,24(sp)
    80001e2c:	6942                	ld	s2,16(sp)
    80001e2e:	69a2                	ld	s3,8(sp)
    80001e30:	6145                	addi	sp,sp,48
    80001e32:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e34:	00006517          	auipc	a0,0x6
    80001e38:	4a450513          	addi	a0,a0,1188 # 800082d8 <etext+0x2d8>
    80001e3c:	00004097          	auipc	ra,0x4
    80001e40:	fd0080e7          	jalr	-48(ra) # 80005e0c <panic>
    panic("kerneltrap: interrupts enabled");
    80001e44:	00006517          	auipc	a0,0x6
    80001e48:	4bc50513          	addi	a0,a0,1212 # 80008300 <etext+0x300>
    80001e4c:	00004097          	auipc	ra,0x4
    80001e50:	fc0080e7          	jalr	-64(ra) # 80005e0c <panic>
    printf("scause %p\n", scause);
    80001e54:	85ce                	mv	a1,s3
    80001e56:	00006517          	auipc	a0,0x6
    80001e5a:	4ca50513          	addi	a0,a0,1226 # 80008320 <etext+0x320>
    80001e5e:	00004097          	auipc	ra,0x4
    80001e62:	000080e7          	jalr	ra # 80005e5e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e66:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e6a:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e6e:	00006517          	auipc	a0,0x6
    80001e72:	4c250513          	addi	a0,a0,1218 # 80008330 <etext+0x330>
    80001e76:	00004097          	auipc	ra,0x4
    80001e7a:	fe8080e7          	jalr	-24(ra) # 80005e5e <printf>
    panic("kerneltrap");
    80001e7e:	00006517          	auipc	a0,0x6
    80001e82:	4ca50513          	addi	a0,a0,1226 # 80008348 <etext+0x348>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	f86080e7          	jalr	-122(ra) # 80005e0c <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	014080e7          	jalr	20(ra) # 80000ea2 <myproc>
    80001e96:	d541                	beqz	a0,80001e1e <kerneltrap+0x38>
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	00a080e7          	jalr	10(ra) # 80000ea2 <myproc>
    80001ea0:	4d18                	lw	a4,24(a0)
    80001ea2:	4791                	li	a5,4
    80001ea4:	f6f71de3          	bne	a4,a5,80001e1e <kerneltrap+0x38>
    yield();
    80001ea8:	fffff097          	auipc	ra,0xfffff
    80001eac:	690080e7          	jalr	1680(ra) # 80001538 <yield>
    80001eb0:	b7bd                	j	80001e1e <kerneltrap+0x38>

0000000080001eb2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001eb2:	1101                	addi	sp,sp,-32
    80001eb4:	ec06                	sd	ra,24(sp)
    80001eb6:	e822                	sd	s0,16(sp)
    80001eb8:	e426                	sd	s1,8(sp)
    80001eba:	1000                	addi	s0,sp,32
    80001ebc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	fe4080e7          	jalr	-28(ra) # 80000ea2 <myproc>
  switch (n) {
    80001ec6:	4795                	li	a5,5
    80001ec8:	0497e163          	bltu	a5,s1,80001f0a <argraw+0x58>
    80001ecc:	048a                	slli	s1,s1,0x2
    80001ece:	00007717          	auipc	a4,0x7
    80001ed2:	86a70713          	addi	a4,a4,-1942 # 80008738 <states.0+0x30>
    80001ed6:	94ba                	add	s1,s1,a4
    80001ed8:	409c                	lw	a5,0(s1)
    80001eda:	97ba                	add	a5,a5,a4
    80001edc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ede:	6d3c                	ld	a5,88(a0)
    80001ee0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001ee2:	60e2                	ld	ra,24(sp)
    80001ee4:	6442                	ld	s0,16(sp)
    80001ee6:	64a2                	ld	s1,8(sp)
    80001ee8:	6105                	addi	sp,sp,32
    80001eea:	8082                	ret
    return p->trapframe->a1;
    80001eec:	6d3c                	ld	a5,88(a0)
    80001eee:	7fa8                	ld	a0,120(a5)
    80001ef0:	bfcd                	j	80001ee2 <argraw+0x30>
    return p->trapframe->a2;
    80001ef2:	6d3c                	ld	a5,88(a0)
    80001ef4:	63c8                	ld	a0,128(a5)
    80001ef6:	b7f5                	j	80001ee2 <argraw+0x30>
    return p->trapframe->a3;
    80001ef8:	6d3c                	ld	a5,88(a0)
    80001efa:	67c8                	ld	a0,136(a5)
    80001efc:	b7dd                	j	80001ee2 <argraw+0x30>
    return p->trapframe->a4;
    80001efe:	6d3c                	ld	a5,88(a0)
    80001f00:	6bc8                	ld	a0,144(a5)
    80001f02:	b7c5                	j	80001ee2 <argraw+0x30>
    return p->trapframe->a5;
    80001f04:	6d3c                	ld	a5,88(a0)
    80001f06:	6fc8                	ld	a0,152(a5)
    80001f08:	bfe9                	j	80001ee2 <argraw+0x30>
  panic("argraw");
    80001f0a:	00006517          	auipc	a0,0x6
    80001f0e:	44e50513          	addi	a0,a0,1102 # 80008358 <etext+0x358>
    80001f12:	00004097          	auipc	ra,0x4
    80001f16:	efa080e7          	jalr	-262(ra) # 80005e0c <panic>

0000000080001f1a <fetchaddr>:
{
    80001f1a:	1101                	addi	sp,sp,-32
    80001f1c:	ec06                	sd	ra,24(sp)
    80001f1e:	e822                	sd	s0,16(sp)
    80001f20:	e426                	sd	s1,8(sp)
    80001f22:	e04a                	sd	s2,0(sp)
    80001f24:	1000                	addi	s0,sp,32
    80001f26:	84aa                	mv	s1,a0
    80001f28:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f2a:	fffff097          	auipc	ra,0xfffff
    80001f2e:	f78080e7          	jalr	-136(ra) # 80000ea2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80001f32:	653c                	ld	a5,72(a0)
    80001f34:	02f4f863          	bgeu	s1,a5,80001f64 <fetchaddr+0x4a>
    80001f38:	00848713          	addi	a4,s1,8
    80001f3c:	02e7e663          	bltu	a5,a4,80001f68 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f40:	46a1                	li	a3,8
    80001f42:	8626                	mv	a2,s1
    80001f44:	85ca                	mv	a1,s2
    80001f46:	6928                	ld	a0,80(a0)
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	c92080e7          	jalr	-878(ra) # 80000bda <copyin>
    80001f50:	00a03533          	snez	a0,a0
    80001f54:	40a0053b          	negw	a0,a0
}
    80001f58:	60e2                	ld	ra,24(sp)
    80001f5a:	6442                	ld	s0,16(sp)
    80001f5c:	64a2                	ld	s1,8(sp)
    80001f5e:	6902                	ld	s2,0(sp)
    80001f60:	6105                	addi	sp,sp,32
    80001f62:	8082                	ret
    return -1;
    80001f64:	557d                	li	a0,-1
    80001f66:	bfcd                	j	80001f58 <fetchaddr+0x3e>
    80001f68:	557d                	li	a0,-1
    80001f6a:	b7fd                	j	80001f58 <fetchaddr+0x3e>

0000000080001f6c <fetchstr>:
{
    80001f6c:	7179                	addi	sp,sp,-48
    80001f6e:	f406                	sd	ra,40(sp)
    80001f70:	f022                	sd	s0,32(sp)
    80001f72:	ec26                	sd	s1,24(sp)
    80001f74:	e84a                	sd	s2,16(sp)
    80001f76:	e44e                	sd	s3,8(sp)
    80001f78:	1800                	addi	s0,sp,48
    80001f7a:	892a                	mv	s2,a0
    80001f7c:	84ae                	mv	s1,a1
    80001f7e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	f22080e7          	jalr	-222(ra) # 80000ea2 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80001f88:	86ce                	mv	a3,s3
    80001f8a:	864a                	mv	a2,s2
    80001f8c:	85a6                	mv	a1,s1
    80001f8e:	6928                	ld	a0,80(a0)
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	cd8080e7          	jalr	-808(ra) # 80000c68 <copyinstr>
  if(err < 0)
    80001f98:	00054763          	bltz	a0,80001fa6 <fetchstr+0x3a>
  return strlen(buf);
    80001f9c:	8526                	mv	a0,s1
    80001f9e:	ffffe097          	auipc	ra,0xffffe
    80001fa2:	368080e7          	jalr	872(ra) # 80000306 <strlen>
}
    80001fa6:	70a2                	ld	ra,40(sp)
    80001fa8:	7402                	ld	s0,32(sp)
    80001faa:	64e2                	ld	s1,24(sp)
    80001fac:	6942                	ld	s2,16(sp)
    80001fae:	69a2                	ld	s3,8(sp)
    80001fb0:	6145                	addi	sp,sp,48
    80001fb2:	8082                	ret

0000000080001fb4 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80001fb4:	1101                	addi	sp,sp,-32
    80001fb6:	ec06                	sd	ra,24(sp)
    80001fb8:	e822                	sd	s0,16(sp)
    80001fba:	e426                	sd	s1,8(sp)
    80001fbc:	1000                	addi	s0,sp,32
    80001fbe:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fc0:	00000097          	auipc	ra,0x0
    80001fc4:	ef2080e7          	jalr	-270(ra) # 80001eb2 <argraw>
    80001fc8:	c088                	sw	a0,0(s1)
  return 0;
}
    80001fca:	4501                	li	a0,0
    80001fcc:	60e2                	ld	ra,24(sp)
    80001fce:	6442                	ld	s0,16(sp)
    80001fd0:	64a2                	ld	s1,8(sp)
    80001fd2:	6105                	addi	sp,sp,32
    80001fd4:	8082                	ret

0000000080001fd6 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80001fd6:	1101                	addi	sp,sp,-32
    80001fd8:	ec06                	sd	ra,24(sp)
    80001fda:	e822                	sd	s0,16(sp)
    80001fdc:	e426                	sd	s1,8(sp)
    80001fde:	1000                	addi	s0,sp,32
    80001fe0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fe2:	00000097          	auipc	ra,0x0
    80001fe6:	ed0080e7          	jalr	-304(ra) # 80001eb2 <argraw>
    80001fea:	e088                	sd	a0,0(s1)
  return 0;
}
    80001fec:	4501                	li	a0,0
    80001fee:	60e2                	ld	ra,24(sp)
    80001ff0:	6442                	ld	s0,16(sp)
    80001ff2:	64a2                	ld	s1,8(sp)
    80001ff4:	6105                	addi	sp,sp,32
    80001ff6:	8082                	ret

0000000080001ff8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001ff8:	1101                	addi	sp,sp,-32
    80001ffa:	ec06                	sd	ra,24(sp)
    80001ffc:	e822                	sd	s0,16(sp)
    80001ffe:	e426                	sd	s1,8(sp)
    80002000:	e04a                	sd	s2,0(sp)
    80002002:	1000                	addi	s0,sp,32
    80002004:	84ae                	mv	s1,a1
    80002006:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002008:	00000097          	auipc	ra,0x0
    8000200c:	eaa080e7          	jalr	-342(ra) # 80001eb2 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002010:	864a                	mv	a2,s2
    80002012:	85a6                	mv	a1,s1
    80002014:	00000097          	auipc	ra,0x0
    80002018:	f58080e7          	jalr	-168(ra) # 80001f6c <fetchstr>
}
    8000201c:	60e2                	ld	ra,24(sp)
    8000201e:	6442                	ld	s0,16(sp)
    80002020:	64a2                	ld	s1,8(sp)
    80002022:	6902                	ld	s2,0(sp)
    80002024:	6105                	addi	sp,sp,32
    80002026:	8082                	ret

0000000080002028 <syscall>:
[SYS_sigreturn]   sys_sigreturn,
};

void
syscall(void)
{
    80002028:	1101                	addi	sp,sp,-32
    8000202a:	ec06                	sd	ra,24(sp)
    8000202c:	e822                	sd	s0,16(sp)
    8000202e:	e426                	sd	s1,8(sp)
    80002030:	e04a                	sd	s2,0(sp)
    80002032:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	e6e080e7          	jalr	-402(ra) # 80000ea2 <myproc>
    8000203c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000203e:	05853903          	ld	s2,88(a0)
    80002042:	0a893783          	ld	a5,168(s2)
    80002046:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000204a:	37fd                	addiw	a5,a5,-1
    8000204c:	4759                	li	a4,22
    8000204e:	00f76f63          	bltu	a4,a5,8000206c <syscall+0x44>
    80002052:	00369713          	slli	a4,a3,0x3
    80002056:	00006797          	auipc	a5,0x6
    8000205a:	6fa78793          	addi	a5,a5,1786 # 80008750 <syscalls>
    8000205e:	97ba                	add	a5,a5,a4
    80002060:	639c                	ld	a5,0(a5)
    80002062:	c789                	beqz	a5,8000206c <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002064:	9782                	jalr	a5
    80002066:	06a93823          	sd	a0,112(s2)
    8000206a:	a839                	j	80002088 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000206c:	15848613          	addi	a2,s1,344
    80002070:	588c                	lw	a1,48(s1)
    80002072:	00006517          	auipc	a0,0x6
    80002076:	2ee50513          	addi	a0,a0,750 # 80008360 <etext+0x360>
    8000207a:	00004097          	auipc	ra,0x4
    8000207e:	de4080e7          	jalr	-540(ra) # 80005e5e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002082:	6cbc                	ld	a5,88(s1)
    80002084:	577d                	li	a4,-1
    80002086:	fbb8                	sd	a4,112(a5)
  }
}
    80002088:	60e2                	ld	ra,24(sp)
    8000208a:	6442                	ld	s0,16(sp)
    8000208c:	64a2                	ld	s1,8(sp)
    8000208e:	6902                	ld	s2,0(sp)
    80002090:	6105                	addi	sp,sp,32
    80002092:	8082                	ret

0000000080002094 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002094:	1101                	addi	sp,sp,-32
    80002096:	ec06                	sd	ra,24(sp)
    80002098:	e822                	sd	s0,16(sp)
    8000209a:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    8000209c:	fec40593          	addi	a1,s0,-20
    800020a0:	4501                	li	a0,0
    800020a2:	00000097          	auipc	ra,0x0
    800020a6:	f12080e7          	jalr	-238(ra) # 80001fb4 <argint>
    return -1;
    800020aa:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800020ac:	00054963          	bltz	a0,800020be <sys_exit+0x2a>
  exit(n);
    800020b0:	fec42503          	lw	a0,-20(s0)
    800020b4:	fffff097          	auipc	ra,0xfffff
    800020b8:	716080e7          	jalr	1814(ra) # 800017ca <exit>
  return 0;  // not reached
    800020bc:	4781                	li	a5,0
}
    800020be:	853e                	mv	a0,a5
    800020c0:	60e2                	ld	ra,24(sp)
    800020c2:	6442                	ld	s0,16(sp)
    800020c4:	6105                	addi	sp,sp,32
    800020c6:	8082                	ret

00000000800020c8 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020c8:	1141                	addi	sp,sp,-16
    800020ca:	e406                	sd	ra,8(sp)
    800020cc:	e022                	sd	s0,0(sp)
    800020ce:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	dd2080e7          	jalr	-558(ra) # 80000ea2 <myproc>
}
    800020d8:	5908                	lw	a0,48(a0)
    800020da:	60a2                	ld	ra,8(sp)
    800020dc:	6402                	ld	s0,0(sp)
    800020de:	0141                	addi	sp,sp,16
    800020e0:	8082                	ret

00000000800020e2 <sys_fork>:

uint64
sys_fork(void)
{
    800020e2:	1141                	addi	sp,sp,-16
    800020e4:	e406                	sd	ra,8(sp)
    800020e6:	e022                	sd	s0,0(sp)
    800020e8:	0800                	addi	s0,sp,16
  return fork();
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	196080e7          	jalr	406(ra) # 80001280 <fork>
}
    800020f2:	60a2                	ld	ra,8(sp)
    800020f4:	6402                	ld	s0,0(sp)
    800020f6:	0141                	addi	sp,sp,16
    800020f8:	8082                	ret

00000000800020fa <sys_wait>:

uint64
sys_wait(void)
{
    800020fa:	1101                	addi	sp,sp,-32
    800020fc:	ec06                	sd	ra,24(sp)
    800020fe:	e822                	sd	s0,16(sp)
    80002100:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002102:	fe840593          	addi	a1,s0,-24
    80002106:	4501                	li	a0,0
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	ece080e7          	jalr	-306(ra) # 80001fd6 <argaddr>
    80002110:	87aa                	mv	a5,a0
    return -1;
    80002112:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002114:	0007c863          	bltz	a5,80002124 <sys_wait+0x2a>
  return wait(p);
    80002118:	fe843503          	ld	a0,-24(s0)
    8000211c:	fffff097          	auipc	ra,0xfffff
    80002120:	4bc080e7          	jalr	1212(ra) # 800015d8 <wait>
}
    80002124:	60e2                	ld	ra,24(sp)
    80002126:	6442                	ld	s0,16(sp)
    80002128:	6105                	addi	sp,sp,32
    8000212a:	8082                	ret

000000008000212c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000212c:	7179                	addi	sp,sp,-48
    8000212e:	f406                	sd	ra,40(sp)
    80002130:	f022                	sd	s0,32(sp)
    80002132:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002134:	fdc40593          	addi	a1,s0,-36
    80002138:	4501                	li	a0,0
    8000213a:	00000097          	auipc	ra,0x0
    8000213e:	e7a080e7          	jalr	-390(ra) # 80001fb4 <argint>
    80002142:	87aa                	mv	a5,a0
    return -1;
    80002144:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002146:	0207c263          	bltz	a5,8000216a <sys_sbrk+0x3e>
    8000214a:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    8000214c:	fffff097          	auipc	ra,0xfffff
    80002150:	d56080e7          	jalr	-682(ra) # 80000ea2 <myproc>
    80002154:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002156:	fdc42503          	lw	a0,-36(s0)
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	0ae080e7          	jalr	174(ra) # 80001208 <growproc>
    80002162:	00054863          	bltz	a0,80002172 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002166:	8526                	mv	a0,s1
    80002168:	64e2                	ld	s1,24(sp)
}
    8000216a:	70a2                	ld	ra,40(sp)
    8000216c:	7402                	ld	s0,32(sp)
    8000216e:	6145                	addi	sp,sp,48
    80002170:	8082                	ret
    return -1;
    80002172:	557d                	li	a0,-1
    80002174:	64e2                	ld	s1,24(sp)
    80002176:	bfd5                	j	8000216a <sys_sbrk+0x3e>

0000000080002178 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002178:	7139                	addi	sp,sp,-64
    8000217a:	fc06                	sd	ra,56(sp)
    8000217c:	f822                	sd	s0,48(sp)
    8000217e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002180:	fcc40593          	addi	a1,s0,-52
    80002184:	4501                	li	a0,0
    80002186:	00000097          	auipc	ra,0x0
    8000218a:	e2e080e7          	jalr	-466(ra) # 80001fb4 <argint>
    return -1;
    8000218e:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002190:	06054f63          	bltz	a0,8000220e <sys_sleep+0x96>
    80002194:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    80002196:	0000d517          	auipc	a0,0xd
    8000219a:	4ea50513          	addi	a0,a0,1258 # 8000f680 <tickslock>
    8000219e:	00004097          	auipc	ra,0x4
    800021a2:	1c4080e7          	jalr	452(ra) # 80006362 <acquire>
  ticks0 = ticks;
    800021a6:	00007917          	auipc	s2,0x7
    800021aa:	e7292903          	lw	s2,-398(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    800021ae:	fcc42783          	lw	a5,-52(s0)
    800021b2:	c3a1                	beqz	a5,800021f2 <sys_sleep+0x7a>
    800021b4:	f426                	sd	s1,40(sp)
    800021b6:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021b8:	0000d997          	auipc	s3,0xd
    800021bc:	4c898993          	addi	s3,s3,1224 # 8000f680 <tickslock>
    800021c0:	00007497          	auipc	s1,0x7
    800021c4:	e5848493          	addi	s1,s1,-424 # 80009018 <ticks>
    if(myproc()->killed){
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	cda080e7          	jalr	-806(ra) # 80000ea2 <myproc>
    800021d0:	551c                	lw	a5,40(a0)
    800021d2:	e3b9                	bnez	a5,80002218 <sys_sleep+0xa0>
    sleep(&ticks, &tickslock);
    800021d4:	85ce                	mv	a1,s3
    800021d6:	8526                	mv	a0,s1
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	39c080e7          	jalr	924(ra) # 80001574 <sleep>
  while(ticks - ticks0 < n){
    800021e0:	409c                	lw	a5,0(s1)
    800021e2:	412787bb          	subw	a5,a5,s2
    800021e6:	fcc42703          	lw	a4,-52(s0)
    800021ea:	fce7efe3          	bltu	a5,a4,800021c8 <sys_sleep+0x50>
    800021ee:	74a2                	ld	s1,40(sp)
    800021f0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800021f2:	0000d517          	auipc	a0,0xd
    800021f6:	48e50513          	addi	a0,a0,1166 # 8000f680 <tickslock>
    800021fa:	00004097          	auipc	ra,0x4
    800021fe:	218080e7          	jalr	536(ra) # 80006412 <release>
  backtrace();
    80002202:	00004097          	auipc	ra,0x4
    80002206:	bb2080e7          	jalr	-1102(ra) # 80005db4 <backtrace>
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
    8000221c:	46850513          	addi	a0,a0,1128 # 8000f680 <tickslock>
    80002220:	00004097          	auipc	ra,0x4
    80002224:	1f2080e7          	jalr	498(ra) # 80006412 <release>
      return -1;
    80002228:	57fd                	li	a5,-1
    8000222a:	74a2                	ld	s1,40(sp)
    8000222c:	7902                	ld	s2,32(sp)
    8000222e:	69e2                	ld	s3,24(sp)
    80002230:	bff9                	j	8000220e <sys_sleep+0x96>

0000000080002232 <sys_kill>:

uint64
sys_kill(void)
{
    80002232:	1101                	addi	sp,sp,-32
    80002234:	ec06                	sd	ra,24(sp)
    80002236:	e822                	sd	s0,16(sp)
    80002238:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    8000223a:	fec40593          	addi	a1,s0,-20
    8000223e:	4501                	li	a0,0
    80002240:	00000097          	auipc	ra,0x0
    80002244:	d74080e7          	jalr	-652(ra) # 80001fb4 <argint>
    80002248:	87aa                	mv	a5,a0
    return -1;
    8000224a:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    8000224c:	0007c863          	bltz	a5,8000225c <sys_kill+0x2a>
  return kill(pid);
    80002250:	fec42503          	lw	a0,-20(s0)
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	64c080e7          	jalr	1612(ra) # 800018a0 <kill>
}
    8000225c:	60e2                	ld	ra,24(sp)
    8000225e:	6442                	ld	s0,16(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	e426                	sd	s1,8(sp)
    8000226c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000226e:	0000d517          	auipc	a0,0xd
    80002272:	41250513          	addi	a0,a0,1042 # 8000f680 <tickslock>
    80002276:	00004097          	auipc	ra,0x4
    8000227a:	0ec080e7          	jalr	236(ra) # 80006362 <acquire>
  xticks = ticks;
    8000227e:	00007497          	auipc	s1,0x7
    80002282:	d9a4a483          	lw	s1,-614(s1) # 80009018 <ticks>
  release(&tickslock);
    80002286:	0000d517          	auipc	a0,0xd
    8000228a:	3fa50513          	addi	a0,a0,1018 # 8000f680 <tickslock>
    8000228e:	00004097          	auipc	ra,0x4
    80002292:	184080e7          	jalr	388(ra) # 80006412 <release>
  return xticks;
}
    80002296:	02049513          	slli	a0,s1,0x20
    8000229a:	9101                	srli	a0,a0,0x20
    8000229c:	60e2                	ld	ra,24(sp)
    8000229e:	6442                	ld	s0,16(sp)
    800022a0:	64a2                	ld	s1,8(sp)
    800022a2:	6105                	addi	sp,sp,32
    800022a4:	8082                	ret

00000000800022a6 <sys_sigalarm>:

uint64 sys_sigalarm() {
    800022a6:	1101                	addi	sp,sp,-32
    800022a8:	ec06                	sd	ra,24(sp)
    800022aa:	e822                	sd	s0,16(sp)
    800022ac:	1000                	addi	s0,sp,32
  int ticks;
  if(argint(0, &ticks) < 0)
    800022ae:	fec40593          	addi	a1,s0,-20
    800022b2:	4501                	li	a0,0
    800022b4:	00000097          	auipc	ra,0x0
    800022b8:	d00080e7          	jalr	-768(ra) # 80001fb4 <argint>
    return -1;
    800022bc:	57fd                	li	a5,-1
  if(argint(0, &ticks) < 0)
    800022be:	02054f63          	bltz	a0,800022fc <sys_sigalarm+0x56>
  myproc()->alarm_interval = ticks;
    800022c2:	fffff097          	auipc	ra,0xfffff
    800022c6:	be0080e7          	jalr	-1056(ra) # 80000ea2 <myproc>
    800022ca:	fec42783          	lw	a5,-20(s0)
    800022ce:	16f52423          	sw	a5,360(a0)
  uint64 handler = 0;
    800022d2:	fe043023          	sd	zero,-32(s0)
  if(argaddr(1, &handler) < 0) {
    800022d6:	fe040593          	addi	a1,s0,-32
    800022da:	4505                	li	a0,1
    800022dc:	00000097          	auipc	ra,0x0
    800022e0:	cfa080e7          	jalr	-774(ra) # 80001fd6 <argaddr>
    return -1;
    800022e4:	57fd                	li	a5,-1
  if(argaddr(1, &handler) < 0) {
    800022e6:	00054b63          	bltz	a0,800022fc <sys_sigalarm+0x56>
  }
  myproc()->handler = handler;
    800022ea:	fffff097          	auipc	ra,0xfffff
    800022ee:	bb8080e7          	jalr	-1096(ra) # 80000ea2 <myproc>
    800022f2:	fe043783          	ld	a5,-32(s0)
    800022f6:	16f53823          	sd	a5,368(a0)
  return 0;
    800022fa:	4781                	li	a5,0
}
    800022fc:	853e                	mv	a0,a5
    800022fe:	60e2                	ld	ra,24(sp)
    80002300:	6442                	ld	s0,16(sp)
    80002302:	6105                	addi	sp,sp,32
    80002304:	8082                	ret

0000000080002306 <sys_sigreturn>:

uint64 sys_sigreturn(void) {
    80002306:	1101                	addi	sp,sp,-32
    80002308:	ec06                	sd	ra,24(sp)
    8000230a:	e822                	sd	s0,16(sp)
    8000230c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	b94080e7          	jalr	-1132(ra) # 80000ea2 <myproc>
  if (p->alarm_trapframe == 0) {
    80002316:	18053583          	ld	a1,384(a0)
    8000231a:	cd8d                	beqz	a1,80002354 <sys_sigreturn+0x4e>
    8000231c:	e426                	sd	s1,8(sp)
    8000231e:	84aa                	mv	s1,a0
    return -1;
  }
  memmove(p->trapframe, p->alarm_trapframe, sizeof(struct trapframe));
    80002320:	12000613          	li	a2,288
    80002324:	6d28                	ld	a0,88(a0)
    80002326:	ffffe097          	auipc	ra,0xffffe
    8000232a:	eb8080e7          	jalr	-328(ra) # 800001de <memmove>
  kfree((char*)p->alarm_trapframe);
    8000232e:	1804b503          	ld	a0,384(s1)
    80002332:	ffffe097          	auipc	ra,0xffffe
    80002336:	cea080e7          	jalr	-790(ra) # 8000001c <kfree>
  p->alarm_trapframe = 0;
    8000233a:	1804b023          	sd	zero,384(s1)
  p->tickes_num = 0;
    8000233e:	1604ac23          	sw	zero,376(s1)
  p->trapframe->a0 = 0;
    80002342:	6cbc                	ld	a5,88(s1)
    80002344:	0607b823          	sd	zero,112(a5)
  return 0;
    80002348:	4501                	li	a0,0
    8000234a:	64a2                	ld	s1,8(sp)
}
    8000234c:	60e2                	ld	ra,24(sp)
    8000234e:	6442                	ld	s0,16(sp)
    80002350:	6105                	addi	sp,sp,32
    80002352:	8082                	ret
    return -1;
    80002354:	557d                	li	a0,-1
    80002356:	bfdd                	j	8000234c <sys_sigreturn+0x46>

0000000080002358 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002358:	7179                	addi	sp,sp,-48
    8000235a:	f406                	sd	ra,40(sp)
    8000235c:	f022                	sd	s0,32(sp)
    8000235e:	ec26                	sd	s1,24(sp)
    80002360:	e84a                	sd	s2,16(sp)
    80002362:	e44e                	sd	s3,8(sp)
    80002364:	e052                	sd	s4,0(sp)
    80002366:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002368:	00006597          	auipc	a1,0x6
    8000236c:	01858593          	addi	a1,a1,24 # 80008380 <etext+0x380>
    80002370:	0000d517          	auipc	a0,0xd
    80002374:	32850513          	addi	a0,a0,808 # 8000f698 <bcache>
    80002378:	00004097          	auipc	ra,0x4
    8000237c:	f56080e7          	jalr	-170(ra) # 800062ce <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002380:	00015797          	auipc	a5,0x15
    80002384:	31878793          	addi	a5,a5,792 # 80017698 <bcache+0x8000>
    80002388:	00015717          	auipc	a4,0x15
    8000238c:	57870713          	addi	a4,a4,1400 # 80017900 <bcache+0x8268>
    80002390:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002394:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002398:	0000d497          	auipc	s1,0xd
    8000239c:	31848493          	addi	s1,s1,792 # 8000f6b0 <bcache+0x18>
    b->next = bcache.head.next;
    800023a0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023a2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023a4:	00006a17          	auipc	s4,0x6
    800023a8:	fe4a0a13          	addi	s4,s4,-28 # 80008388 <etext+0x388>
    b->next = bcache.head.next;
    800023ac:	2b893783          	ld	a5,696(s2)
    800023b0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023b2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023b6:	85d2                	mv	a1,s4
    800023b8:	01048513          	addi	a0,s1,16
    800023bc:	00001097          	auipc	ra,0x1
    800023c0:	4ba080e7          	jalr	1210(ra) # 80003876 <initsleeplock>
    bcache.head.next->prev = b;
    800023c4:	2b893783          	ld	a5,696(s2)
    800023c8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023ca:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ce:	45848493          	addi	s1,s1,1112
    800023d2:	fd349de3          	bne	s1,s3,800023ac <binit+0x54>
  }
}
    800023d6:	70a2                	ld	ra,40(sp)
    800023d8:	7402                	ld	s0,32(sp)
    800023da:	64e2                	ld	s1,24(sp)
    800023dc:	6942                	ld	s2,16(sp)
    800023de:	69a2                	ld	s3,8(sp)
    800023e0:	6a02                	ld	s4,0(sp)
    800023e2:	6145                	addi	sp,sp,48
    800023e4:	8082                	ret

00000000800023e6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023e6:	7179                	addi	sp,sp,-48
    800023e8:	f406                	sd	ra,40(sp)
    800023ea:	f022                	sd	s0,32(sp)
    800023ec:	ec26                	sd	s1,24(sp)
    800023ee:	e84a                	sd	s2,16(sp)
    800023f0:	e44e                	sd	s3,8(sp)
    800023f2:	1800                	addi	s0,sp,48
    800023f4:	892a                	mv	s2,a0
    800023f6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800023f8:	0000d517          	auipc	a0,0xd
    800023fc:	2a050513          	addi	a0,a0,672 # 8000f698 <bcache>
    80002400:	00004097          	auipc	ra,0x4
    80002404:	f62080e7          	jalr	-158(ra) # 80006362 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002408:	00015497          	auipc	s1,0x15
    8000240c:	5484b483          	ld	s1,1352(s1) # 80017950 <bcache+0x82b8>
    80002410:	00015797          	auipc	a5,0x15
    80002414:	4f078793          	addi	a5,a5,1264 # 80017900 <bcache+0x8268>
    80002418:	02f48f63          	beq	s1,a5,80002456 <bread+0x70>
    8000241c:	873e                	mv	a4,a5
    8000241e:	a021                	j	80002426 <bread+0x40>
    80002420:	68a4                	ld	s1,80(s1)
    80002422:	02e48a63          	beq	s1,a4,80002456 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002426:	449c                	lw	a5,8(s1)
    80002428:	ff279ce3          	bne	a5,s2,80002420 <bread+0x3a>
    8000242c:	44dc                	lw	a5,12(s1)
    8000242e:	ff3799e3          	bne	a5,s3,80002420 <bread+0x3a>
      b->refcnt++;
    80002432:	40bc                	lw	a5,64(s1)
    80002434:	2785                	addiw	a5,a5,1
    80002436:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002438:	0000d517          	auipc	a0,0xd
    8000243c:	26050513          	addi	a0,a0,608 # 8000f698 <bcache>
    80002440:	00004097          	auipc	ra,0x4
    80002444:	fd2080e7          	jalr	-46(ra) # 80006412 <release>
      acquiresleep(&b->lock);
    80002448:	01048513          	addi	a0,s1,16
    8000244c:	00001097          	auipc	ra,0x1
    80002450:	464080e7          	jalr	1124(ra) # 800038b0 <acquiresleep>
      return b;
    80002454:	a8b9                	j	800024b2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002456:	00015497          	auipc	s1,0x15
    8000245a:	4f24b483          	ld	s1,1266(s1) # 80017948 <bcache+0x82b0>
    8000245e:	00015797          	auipc	a5,0x15
    80002462:	4a278793          	addi	a5,a5,1186 # 80017900 <bcache+0x8268>
    80002466:	00f48863          	beq	s1,a5,80002476 <bread+0x90>
    8000246a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000246c:	40bc                	lw	a5,64(s1)
    8000246e:	cf81                	beqz	a5,80002486 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002470:	64a4                	ld	s1,72(s1)
    80002472:	fee49de3          	bne	s1,a4,8000246c <bread+0x86>
  panic("bget: no buffers");
    80002476:	00006517          	auipc	a0,0x6
    8000247a:	f1a50513          	addi	a0,a0,-230 # 80008390 <etext+0x390>
    8000247e:	00004097          	auipc	ra,0x4
    80002482:	98e080e7          	jalr	-1650(ra) # 80005e0c <panic>
      b->dev = dev;
    80002486:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000248a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000248e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002492:	4785                	li	a5,1
    80002494:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002496:	0000d517          	auipc	a0,0xd
    8000249a:	20250513          	addi	a0,a0,514 # 8000f698 <bcache>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	f74080e7          	jalr	-140(ra) # 80006412 <release>
      acquiresleep(&b->lock);
    800024a6:	01048513          	addi	a0,s1,16
    800024aa:	00001097          	auipc	ra,0x1
    800024ae:	406080e7          	jalr	1030(ra) # 800038b0 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024b2:	409c                	lw	a5,0(s1)
    800024b4:	cb89                	beqz	a5,800024c6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024b6:	8526                	mv	a0,s1
    800024b8:	70a2                	ld	ra,40(sp)
    800024ba:	7402                	ld	s0,32(sp)
    800024bc:	64e2                	ld	s1,24(sp)
    800024be:	6942                	ld	s2,16(sp)
    800024c0:	69a2                	ld	s3,8(sp)
    800024c2:	6145                	addi	sp,sp,48
    800024c4:	8082                	ret
    virtio_disk_rw(b, 0);
    800024c6:	4581                	li	a1,0
    800024c8:	8526                	mv	a0,s1
    800024ca:	00003097          	auipc	ra,0x3
    800024ce:	024080e7          	jalr	36(ra) # 800054ee <virtio_disk_rw>
    b->valid = 1;
    800024d2:	4785                	li	a5,1
    800024d4:	c09c                	sw	a5,0(s1)
  return b;
    800024d6:	b7c5                	j	800024b6 <bread+0xd0>

00000000800024d8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024d8:	1101                	addi	sp,sp,-32
    800024da:	ec06                	sd	ra,24(sp)
    800024dc:	e822                	sd	s0,16(sp)
    800024de:	e426                	sd	s1,8(sp)
    800024e0:	1000                	addi	s0,sp,32
    800024e2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024e4:	0541                	addi	a0,a0,16
    800024e6:	00001097          	auipc	ra,0x1
    800024ea:	464080e7          	jalr	1124(ra) # 8000394a <holdingsleep>
    800024ee:	cd01                	beqz	a0,80002506 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024f0:	4585                	li	a1,1
    800024f2:	8526                	mv	a0,s1
    800024f4:	00003097          	auipc	ra,0x3
    800024f8:	ffa080e7          	jalr	-6(ra) # 800054ee <virtio_disk_rw>
}
    800024fc:	60e2                	ld	ra,24(sp)
    800024fe:	6442                	ld	s0,16(sp)
    80002500:	64a2                	ld	s1,8(sp)
    80002502:	6105                	addi	sp,sp,32
    80002504:	8082                	ret
    panic("bwrite");
    80002506:	00006517          	auipc	a0,0x6
    8000250a:	ea250513          	addi	a0,a0,-350 # 800083a8 <etext+0x3a8>
    8000250e:	00004097          	auipc	ra,0x4
    80002512:	8fe080e7          	jalr	-1794(ra) # 80005e0c <panic>

0000000080002516 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002516:	1101                	addi	sp,sp,-32
    80002518:	ec06                	sd	ra,24(sp)
    8000251a:	e822                	sd	s0,16(sp)
    8000251c:	e426                	sd	s1,8(sp)
    8000251e:	e04a                	sd	s2,0(sp)
    80002520:	1000                	addi	s0,sp,32
    80002522:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002524:	01050913          	addi	s2,a0,16
    80002528:	854a                	mv	a0,s2
    8000252a:	00001097          	auipc	ra,0x1
    8000252e:	420080e7          	jalr	1056(ra) # 8000394a <holdingsleep>
    80002532:	c535                	beqz	a0,8000259e <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    80002534:	854a                	mv	a0,s2
    80002536:	00001097          	auipc	ra,0x1
    8000253a:	3d0080e7          	jalr	976(ra) # 80003906 <releasesleep>

  acquire(&bcache.lock);
    8000253e:	0000d517          	auipc	a0,0xd
    80002542:	15a50513          	addi	a0,a0,346 # 8000f698 <bcache>
    80002546:	00004097          	auipc	ra,0x4
    8000254a:	e1c080e7          	jalr	-484(ra) # 80006362 <acquire>
  b->refcnt--;
    8000254e:	40bc                	lw	a5,64(s1)
    80002550:	37fd                	addiw	a5,a5,-1
    80002552:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002554:	e79d                	bnez	a5,80002582 <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002556:	68b8                	ld	a4,80(s1)
    80002558:	64bc                	ld	a5,72(s1)
    8000255a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000255c:	68b8                	ld	a4,80(s1)
    8000255e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002560:	00015797          	auipc	a5,0x15
    80002564:	13878793          	addi	a5,a5,312 # 80017698 <bcache+0x8000>
    80002568:	2b87b703          	ld	a4,696(a5)
    8000256c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000256e:	00015717          	auipc	a4,0x15
    80002572:	39270713          	addi	a4,a4,914 # 80017900 <bcache+0x8268>
    80002576:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002578:	2b87b703          	ld	a4,696(a5)
    8000257c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000257e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002582:	0000d517          	auipc	a0,0xd
    80002586:	11650513          	addi	a0,a0,278 # 8000f698 <bcache>
    8000258a:	00004097          	auipc	ra,0x4
    8000258e:	e88080e7          	jalr	-376(ra) # 80006412 <release>
}
    80002592:	60e2                	ld	ra,24(sp)
    80002594:	6442                	ld	s0,16(sp)
    80002596:	64a2                	ld	s1,8(sp)
    80002598:	6902                	ld	s2,0(sp)
    8000259a:	6105                	addi	sp,sp,32
    8000259c:	8082                	ret
    panic("brelse");
    8000259e:	00006517          	auipc	a0,0x6
    800025a2:	e1250513          	addi	a0,a0,-494 # 800083b0 <etext+0x3b0>
    800025a6:	00004097          	auipc	ra,0x4
    800025aa:	866080e7          	jalr	-1946(ra) # 80005e0c <panic>

00000000800025ae <bpin>:

void
bpin(struct buf *b) {
    800025ae:	1101                	addi	sp,sp,-32
    800025b0:	ec06                	sd	ra,24(sp)
    800025b2:	e822                	sd	s0,16(sp)
    800025b4:	e426                	sd	s1,8(sp)
    800025b6:	1000                	addi	s0,sp,32
    800025b8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025ba:	0000d517          	auipc	a0,0xd
    800025be:	0de50513          	addi	a0,a0,222 # 8000f698 <bcache>
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	da0080e7          	jalr	-608(ra) # 80006362 <acquire>
  b->refcnt++;
    800025ca:	40bc                	lw	a5,64(s1)
    800025cc:	2785                	addiw	a5,a5,1
    800025ce:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025d0:	0000d517          	auipc	a0,0xd
    800025d4:	0c850513          	addi	a0,a0,200 # 8000f698 <bcache>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	e3a080e7          	jalr	-454(ra) # 80006412 <release>
}
    800025e0:	60e2                	ld	ra,24(sp)
    800025e2:	6442                	ld	s0,16(sp)
    800025e4:	64a2                	ld	s1,8(sp)
    800025e6:	6105                	addi	sp,sp,32
    800025e8:	8082                	ret

00000000800025ea <bunpin>:

void
bunpin(struct buf *b) {
    800025ea:	1101                	addi	sp,sp,-32
    800025ec:	ec06                	sd	ra,24(sp)
    800025ee:	e822                	sd	s0,16(sp)
    800025f0:	e426                	sd	s1,8(sp)
    800025f2:	1000                	addi	s0,sp,32
    800025f4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f6:	0000d517          	auipc	a0,0xd
    800025fa:	0a250513          	addi	a0,a0,162 # 8000f698 <bcache>
    800025fe:	00004097          	auipc	ra,0x4
    80002602:	d64080e7          	jalr	-668(ra) # 80006362 <acquire>
  b->refcnt--;
    80002606:	40bc                	lw	a5,64(s1)
    80002608:	37fd                	addiw	a5,a5,-1
    8000260a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000260c:	0000d517          	auipc	a0,0xd
    80002610:	08c50513          	addi	a0,a0,140 # 8000f698 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	dfe080e7          	jalr	-514(ra) # 80006412 <release>
}
    8000261c:	60e2                	ld	ra,24(sp)
    8000261e:	6442                	ld	s0,16(sp)
    80002620:	64a2                	ld	s1,8(sp)
    80002622:	6105                	addi	sp,sp,32
    80002624:	8082                	ret

0000000080002626 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002626:	1101                	addi	sp,sp,-32
    80002628:	ec06                	sd	ra,24(sp)
    8000262a:	e822                	sd	s0,16(sp)
    8000262c:	e426                	sd	s1,8(sp)
    8000262e:	e04a                	sd	s2,0(sp)
    80002630:	1000                	addi	s0,sp,32
    80002632:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002634:	00d5d79b          	srliw	a5,a1,0xd
    80002638:	00015597          	auipc	a1,0x15
    8000263c:	73c5a583          	lw	a1,1852(a1) # 80017d74 <sb+0x1c>
    80002640:	9dbd                	addw	a1,a1,a5
    80002642:	00000097          	auipc	ra,0x0
    80002646:	da4080e7          	jalr	-604(ra) # 800023e6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000264a:	0074f713          	andi	a4,s1,7
    8000264e:	4785                	li	a5,1
    80002650:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002654:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002656:	90d9                	srli	s1,s1,0x36
    80002658:	00950733          	add	a4,a0,s1
    8000265c:	05874703          	lbu	a4,88(a4)
    80002660:	00e7f6b3          	and	a3,a5,a4
    80002664:	c69d                	beqz	a3,80002692 <bfree+0x6c>
    80002666:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002668:	94aa                	add	s1,s1,a0
    8000266a:	fff7c793          	not	a5,a5
    8000266e:	8f7d                	and	a4,a4,a5
    80002670:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002674:	00001097          	auipc	ra,0x1
    80002678:	11e080e7          	jalr	286(ra) # 80003792 <log_write>
  brelse(bp);
    8000267c:	854a                	mv	a0,s2
    8000267e:	00000097          	auipc	ra,0x0
    80002682:	e98080e7          	jalr	-360(ra) # 80002516 <brelse>
}
    80002686:	60e2                	ld	ra,24(sp)
    80002688:	6442                	ld	s0,16(sp)
    8000268a:	64a2                	ld	s1,8(sp)
    8000268c:	6902                	ld	s2,0(sp)
    8000268e:	6105                	addi	sp,sp,32
    80002690:	8082                	ret
    panic("freeing free block");
    80002692:	00006517          	auipc	a0,0x6
    80002696:	d2650513          	addi	a0,a0,-730 # 800083b8 <etext+0x3b8>
    8000269a:	00003097          	auipc	ra,0x3
    8000269e:	772080e7          	jalr	1906(ra) # 80005e0c <panic>

00000000800026a2 <balloc>:
{
    800026a2:	715d                	addi	sp,sp,-80
    800026a4:	e486                	sd	ra,72(sp)
    800026a6:	e0a2                	sd	s0,64(sp)
    800026a8:	fc26                	sd	s1,56(sp)
    800026aa:	f84a                	sd	s2,48(sp)
    800026ac:	f44e                	sd	s3,40(sp)
    800026ae:	f052                	sd	s4,32(sp)
    800026b0:	ec56                	sd	s5,24(sp)
    800026b2:	e85a                	sd	s6,16(sp)
    800026b4:	e45e                	sd	s7,8(sp)
    800026b6:	e062                	sd	s8,0(sp)
    800026b8:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800026ba:	00015797          	auipc	a5,0x15
    800026be:	6a27a783          	lw	a5,1698(a5) # 80017d5c <sb+0x4>
    800026c2:	c7c1                	beqz	a5,8000274a <balloc+0xa8>
    800026c4:	8baa                	mv	s7,a0
    800026c6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026c8:	00015b17          	auipc	s6,0x15
    800026cc:	690b0b13          	addi	s6,s6,1680 # 80017d58 <sb>
      m = 1 << (bi % 8);
    800026d0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026d4:	6c09                	lui	s8,0x2
    800026d6:	a821                	j	800026ee <balloc+0x4c>
    brelse(bp);
    800026d8:	854a                	mv	a0,s2
    800026da:	00000097          	auipc	ra,0x0
    800026de:	e3c080e7          	jalr	-452(ra) # 80002516 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800026e2:	015c0abb          	addw	s5,s8,s5
    800026e6:	004b2783          	lw	a5,4(s6)
    800026ea:	06faf063          	bgeu	s5,a5,8000274a <balloc+0xa8>
    bp = bread(dev, BBLOCK(b, sb));
    800026ee:	41fad79b          	sraiw	a5,s5,0x1f
    800026f2:	0137d79b          	srliw	a5,a5,0x13
    800026f6:	015787bb          	addw	a5,a5,s5
    800026fa:	40d7d79b          	sraiw	a5,a5,0xd
    800026fe:	01cb2583          	lw	a1,28(s6)
    80002702:	9dbd                	addw	a1,a1,a5
    80002704:	855e                	mv	a0,s7
    80002706:	00000097          	auipc	ra,0x0
    8000270a:	ce0080e7          	jalr	-800(ra) # 800023e6 <bread>
    8000270e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002710:	004b2503          	lw	a0,4(s6)
    80002714:	84d6                	mv	s1,s5
    80002716:	4701                	li	a4,0
    80002718:	fca4f0e3          	bgeu	s1,a0,800026d8 <balloc+0x36>
      m = 1 << (bi % 8);
    8000271c:	00777693          	andi	a3,a4,7
    80002720:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002724:	41f7579b          	sraiw	a5,a4,0x1f
    80002728:	01d7d79b          	srliw	a5,a5,0x1d
    8000272c:	9fb9                	addw	a5,a5,a4
    8000272e:	4037d79b          	sraiw	a5,a5,0x3
    80002732:	00f90633          	add	a2,s2,a5
    80002736:	05864603          	lbu	a2,88(a2)
    8000273a:	00c6f5b3          	and	a1,a3,a2
    8000273e:	cd91                	beqz	a1,8000275a <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002740:	2705                	addiw	a4,a4,1
    80002742:	2485                	addiw	s1,s1,1
    80002744:	fd471ae3          	bne	a4,s4,80002718 <balloc+0x76>
    80002748:	bf41                	j	800026d8 <balloc+0x36>
  panic("balloc: out of blocks");
    8000274a:	00006517          	auipc	a0,0x6
    8000274e:	c8650513          	addi	a0,a0,-890 # 800083d0 <etext+0x3d0>
    80002752:	00003097          	auipc	ra,0x3
    80002756:	6ba080e7          	jalr	1722(ra) # 80005e0c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000275a:	97ca                	add	a5,a5,s2
    8000275c:	8e55                	or	a2,a2,a3
    8000275e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002762:	854a                	mv	a0,s2
    80002764:	00001097          	auipc	ra,0x1
    80002768:	02e080e7          	jalr	46(ra) # 80003792 <log_write>
        brelse(bp);
    8000276c:	854a                	mv	a0,s2
    8000276e:	00000097          	auipc	ra,0x0
    80002772:	da8080e7          	jalr	-600(ra) # 80002516 <brelse>
  bp = bread(dev, bno);
    80002776:	85a6                	mv	a1,s1
    80002778:	855e                	mv	a0,s7
    8000277a:	00000097          	auipc	ra,0x0
    8000277e:	c6c080e7          	jalr	-916(ra) # 800023e6 <bread>
    80002782:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002784:	40000613          	li	a2,1024
    80002788:	4581                	li	a1,0
    8000278a:	05850513          	addi	a0,a0,88
    8000278e:	ffffe097          	auipc	ra,0xffffe
    80002792:	9ec080e7          	jalr	-1556(ra) # 8000017a <memset>
  log_write(bp);
    80002796:	854a                	mv	a0,s2
    80002798:	00001097          	auipc	ra,0x1
    8000279c:	ffa080e7          	jalr	-6(ra) # 80003792 <log_write>
  brelse(bp);
    800027a0:	854a                	mv	a0,s2
    800027a2:	00000097          	auipc	ra,0x0
    800027a6:	d74080e7          	jalr	-652(ra) # 80002516 <brelse>
}
    800027aa:	8526                	mv	a0,s1
    800027ac:	60a6                	ld	ra,72(sp)
    800027ae:	6406                	ld	s0,64(sp)
    800027b0:	74e2                	ld	s1,56(sp)
    800027b2:	7942                	ld	s2,48(sp)
    800027b4:	79a2                	ld	s3,40(sp)
    800027b6:	7a02                	ld	s4,32(sp)
    800027b8:	6ae2                	ld	s5,24(sp)
    800027ba:	6b42                	ld	s6,16(sp)
    800027bc:	6ba2                	ld	s7,8(sp)
    800027be:	6c02                	ld	s8,0(sp)
    800027c0:	6161                	addi	sp,sp,80
    800027c2:	8082                	ret

00000000800027c4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800027c4:	7179                	addi	sp,sp,-48
    800027c6:	f406                	sd	ra,40(sp)
    800027c8:	f022                	sd	s0,32(sp)
    800027ca:	ec26                	sd	s1,24(sp)
    800027cc:	e84a                	sd	s2,16(sp)
    800027ce:	e44e                	sd	s3,8(sp)
    800027d0:	1800                	addi	s0,sp,48
    800027d2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027d4:	47ad                	li	a5,11
    800027d6:	04b7fd63          	bgeu	a5,a1,80002830 <bmap+0x6c>
    800027da:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    800027dc:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    800027e0:	0ff00793          	li	a5,255
    800027e4:	0897ef63          	bltu	a5,s1,80002882 <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    800027e8:	08052583          	lw	a1,128(a0)
    800027ec:	c5a5                	beqz	a1,80002854 <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800027ee:	00092503          	lw	a0,0(s2)
    800027f2:	00000097          	auipc	ra,0x0
    800027f6:	bf4080e7          	jalr	-1036(ra) # 800023e6 <bread>
    800027fa:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800027fc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002800:	02049713          	slli	a4,s1,0x20
    80002804:	01e75593          	srli	a1,a4,0x1e
    80002808:	00b784b3          	add	s1,a5,a1
    8000280c:	0004a983          	lw	s3,0(s1)
    80002810:	04098b63          	beqz	s3,80002866 <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002814:	8552                	mv	a0,s4
    80002816:	00000097          	auipc	ra,0x0
    8000281a:	d00080e7          	jalr	-768(ra) # 80002516 <brelse>
    return addr;
    8000281e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002820:	854e                	mv	a0,s3
    80002822:	70a2                	ld	ra,40(sp)
    80002824:	7402                	ld	s0,32(sp)
    80002826:	64e2                	ld	s1,24(sp)
    80002828:	6942                	ld	s2,16(sp)
    8000282a:	69a2                	ld	s3,8(sp)
    8000282c:	6145                	addi	sp,sp,48
    8000282e:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002830:	02059793          	slli	a5,a1,0x20
    80002834:	01e7d593          	srli	a1,a5,0x1e
    80002838:	00b504b3          	add	s1,a0,a1
    8000283c:	0504a983          	lw	s3,80(s1)
    80002840:	fe0990e3          	bnez	s3,80002820 <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002844:	4108                	lw	a0,0(a0)
    80002846:	00000097          	auipc	ra,0x0
    8000284a:	e5c080e7          	jalr	-420(ra) # 800026a2 <balloc>
    8000284e:	89aa                	mv	s3,a0
    80002850:	c8a8                	sw	a0,80(s1)
    80002852:	b7f9                	j	80002820 <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002854:	4108                	lw	a0,0(a0)
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	e4c080e7          	jalr	-436(ra) # 800026a2 <balloc>
    8000285e:	85aa                	mv	a1,a0
    80002860:	08a92023          	sw	a0,128(s2)
    80002864:	b769                	j	800027ee <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    80002866:	00092503          	lw	a0,0(s2)
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	e38080e7          	jalr	-456(ra) # 800026a2 <balloc>
    80002872:	89aa                	mv	s3,a0
    80002874:	c088                	sw	a0,0(s1)
      log_write(bp);
    80002876:	8552                	mv	a0,s4
    80002878:	00001097          	auipc	ra,0x1
    8000287c:	f1a080e7          	jalr	-230(ra) # 80003792 <log_write>
    80002880:	bf51                	j	80002814 <bmap+0x50>
  panic("bmap: out of range");
    80002882:	00006517          	auipc	a0,0x6
    80002886:	b6650513          	addi	a0,a0,-1178 # 800083e8 <etext+0x3e8>
    8000288a:	00003097          	auipc	ra,0x3
    8000288e:	582080e7          	jalr	1410(ra) # 80005e0c <panic>

0000000080002892 <iget>:
{
    80002892:	7179                	addi	sp,sp,-48
    80002894:	f406                	sd	ra,40(sp)
    80002896:	f022                	sd	s0,32(sp)
    80002898:	ec26                	sd	s1,24(sp)
    8000289a:	e84a                	sd	s2,16(sp)
    8000289c:	e44e                	sd	s3,8(sp)
    8000289e:	e052                	sd	s4,0(sp)
    800028a0:	1800                	addi	s0,sp,48
    800028a2:	89aa                	mv	s3,a0
    800028a4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028a6:	00015517          	auipc	a0,0x15
    800028aa:	4d250513          	addi	a0,a0,1234 # 80017d78 <itable>
    800028ae:	00004097          	auipc	ra,0x4
    800028b2:	ab4080e7          	jalr	-1356(ra) # 80006362 <acquire>
  empty = 0;
    800028b6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028b8:	00015497          	auipc	s1,0x15
    800028bc:	4d848493          	addi	s1,s1,1240 # 80017d90 <itable+0x18>
    800028c0:	00017697          	auipc	a3,0x17
    800028c4:	f6068693          	addi	a3,a3,-160 # 80019820 <log>
    800028c8:	a039                	j	800028d6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028ca:	02090b63          	beqz	s2,80002900 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028ce:	08848493          	addi	s1,s1,136
    800028d2:	02d48a63          	beq	s1,a3,80002906 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028d6:	449c                	lw	a5,8(s1)
    800028d8:	fef059e3          	blez	a5,800028ca <iget+0x38>
    800028dc:	4098                	lw	a4,0(s1)
    800028de:	ff3716e3          	bne	a4,s3,800028ca <iget+0x38>
    800028e2:	40d8                	lw	a4,4(s1)
    800028e4:	ff4713e3          	bne	a4,s4,800028ca <iget+0x38>
      ip->ref++;
    800028e8:	2785                	addiw	a5,a5,1
    800028ea:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028ec:	00015517          	auipc	a0,0x15
    800028f0:	48c50513          	addi	a0,a0,1164 # 80017d78 <itable>
    800028f4:	00004097          	auipc	ra,0x4
    800028f8:	b1e080e7          	jalr	-1250(ra) # 80006412 <release>
      return ip;
    800028fc:	8926                	mv	s2,s1
    800028fe:	a03d                	j	8000292c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002900:	f7f9                	bnez	a5,800028ce <iget+0x3c>
      empty = ip;
    80002902:	8926                	mv	s2,s1
    80002904:	b7e9                	j	800028ce <iget+0x3c>
  if(empty == 0)
    80002906:	02090c63          	beqz	s2,8000293e <iget+0xac>
  ip->dev = dev;
    8000290a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000290e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002912:	4785                	li	a5,1
    80002914:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002918:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000291c:	00015517          	auipc	a0,0x15
    80002920:	45c50513          	addi	a0,a0,1116 # 80017d78 <itable>
    80002924:	00004097          	auipc	ra,0x4
    80002928:	aee080e7          	jalr	-1298(ra) # 80006412 <release>
}
    8000292c:	854a                	mv	a0,s2
    8000292e:	70a2                	ld	ra,40(sp)
    80002930:	7402                	ld	s0,32(sp)
    80002932:	64e2                	ld	s1,24(sp)
    80002934:	6942                	ld	s2,16(sp)
    80002936:	69a2                	ld	s3,8(sp)
    80002938:	6a02                	ld	s4,0(sp)
    8000293a:	6145                	addi	sp,sp,48
    8000293c:	8082                	ret
    panic("iget: no inodes");
    8000293e:	00006517          	auipc	a0,0x6
    80002942:	ac250513          	addi	a0,a0,-1342 # 80008400 <etext+0x400>
    80002946:	00003097          	auipc	ra,0x3
    8000294a:	4c6080e7          	jalr	1222(ra) # 80005e0c <panic>

000000008000294e <fsinit>:
fsinit(int dev) {
    8000294e:	7179                	addi	sp,sp,-48
    80002950:	f406                	sd	ra,40(sp)
    80002952:	f022                	sd	s0,32(sp)
    80002954:	ec26                	sd	s1,24(sp)
    80002956:	e84a                	sd	s2,16(sp)
    80002958:	e44e                	sd	s3,8(sp)
    8000295a:	1800                	addi	s0,sp,48
    8000295c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000295e:	4585                	li	a1,1
    80002960:	00000097          	auipc	ra,0x0
    80002964:	a86080e7          	jalr	-1402(ra) # 800023e6 <bread>
    80002968:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000296a:	00015997          	auipc	s3,0x15
    8000296e:	3ee98993          	addi	s3,s3,1006 # 80017d58 <sb>
    80002972:	02000613          	li	a2,32
    80002976:	05850593          	addi	a1,a0,88
    8000297a:	854e                	mv	a0,s3
    8000297c:	ffffe097          	auipc	ra,0xffffe
    80002980:	862080e7          	jalr	-1950(ra) # 800001de <memmove>
  brelse(bp);
    80002984:	8526                	mv	a0,s1
    80002986:	00000097          	auipc	ra,0x0
    8000298a:	b90080e7          	jalr	-1136(ra) # 80002516 <brelse>
  if(sb.magic != FSMAGIC)
    8000298e:	0009a703          	lw	a4,0(s3)
    80002992:	102037b7          	lui	a5,0x10203
    80002996:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000299a:	02f71263          	bne	a4,a5,800029be <fsinit+0x70>
  initlog(dev, &sb);
    8000299e:	00015597          	auipc	a1,0x15
    800029a2:	3ba58593          	addi	a1,a1,954 # 80017d58 <sb>
    800029a6:	854a                	mv	a0,s2
    800029a8:	00001097          	auipc	ra,0x1
    800029ac:	b74080e7          	jalr	-1164(ra) # 8000351c <initlog>
}
    800029b0:	70a2                	ld	ra,40(sp)
    800029b2:	7402                	ld	s0,32(sp)
    800029b4:	64e2                	ld	s1,24(sp)
    800029b6:	6942                	ld	s2,16(sp)
    800029b8:	69a2                	ld	s3,8(sp)
    800029ba:	6145                	addi	sp,sp,48
    800029bc:	8082                	ret
    panic("invalid file system");
    800029be:	00006517          	auipc	a0,0x6
    800029c2:	a5250513          	addi	a0,a0,-1454 # 80008410 <etext+0x410>
    800029c6:	00003097          	auipc	ra,0x3
    800029ca:	446080e7          	jalr	1094(ra) # 80005e0c <panic>

00000000800029ce <iinit>:
{
    800029ce:	7179                	addi	sp,sp,-48
    800029d0:	f406                	sd	ra,40(sp)
    800029d2:	f022                	sd	s0,32(sp)
    800029d4:	ec26                	sd	s1,24(sp)
    800029d6:	e84a                	sd	s2,16(sp)
    800029d8:	e44e                	sd	s3,8(sp)
    800029da:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029dc:	00006597          	auipc	a1,0x6
    800029e0:	a4c58593          	addi	a1,a1,-1460 # 80008428 <etext+0x428>
    800029e4:	00015517          	auipc	a0,0x15
    800029e8:	39450513          	addi	a0,a0,916 # 80017d78 <itable>
    800029ec:	00004097          	auipc	ra,0x4
    800029f0:	8e2080e7          	jalr	-1822(ra) # 800062ce <initlock>
  for(i = 0; i < NINODE; i++) {
    800029f4:	00015497          	auipc	s1,0x15
    800029f8:	3ac48493          	addi	s1,s1,940 # 80017da0 <itable+0x28>
    800029fc:	00017997          	auipc	s3,0x17
    80002a00:	e3498993          	addi	s3,s3,-460 # 80019830 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a04:	00006917          	auipc	s2,0x6
    80002a08:	a2c90913          	addi	s2,s2,-1492 # 80008430 <etext+0x430>
    80002a0c:	85ca                	mv	a1,s2
    80002a0e:	8526                	mv	a0,s1
    80002a10:	00001097          	auipc	ra,0x1
    80002a14:	e66080e7          	jalr	-410(ra) # 80003876 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a18:	08848493          	addi	s1,s1,136
    80002a1c:	ff3498e3          	bne	s1,s3,80002a0c <iinit+0x3e>
}
    80002a20:	70a2                	ld	ra,40(sp)
    80002a22:	7402                	ld	s0,32(sp)
    80002a24:	64e2                	ld	s1,24(sp)
    80002a26:	6942                	ld	s2,16(sp)
    80002a28:	69a2                	ld	s3,8(sp)
    80002a2a:	6145                	addi	sp,sp,48
    80002a2c:	8082                	ret

0000000080002a2e <ialloc>:
{
    80002a2e:	7139                	addi	sp,sp,-64
    80002a30:	fc06                	sd	ra,56(sp)
    80002a32:	f822                	sd	s0,48(sp)
    80002a34:	f426                	sd	s1,40(sp)
    80002a36:	f04a                	sd	s2,32(sp)
    80002a38:	ec4e                	sd	s3,24(sp)
    80002a3a:	e852                	sd	s4,16(sp)
    80002a3c:	e456                	sd	s5,8(sp)
    80002a3e:	e05a                	sd	s6,0(sp)
    80002a40:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a42:	00015717          	auipc	a4,0x15
    80002a46:	32272703          	lw	a4,802(a4) # 80017d64 <sb+0xc>
    80002a4a:	4785                	li	a5,1
    80002a4c:	04e7f863          	bgeu	a5,a4,80002a9c <ialloc+0x6e>
    80002a50:	8aaa                	mv	s5,a0
    80002a52:	8b2e                	mv	s6,a1
    80002a54:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002a56:	00015a17          	auipc	s4,0x15
    80002a5a:	302a0a13          	addi	s4,s4,770 # 80017d58 <sb>
    80002a5e:	00495593          	srli	a1,s2,0x4
    80002a62:	018a2783          	lw	a5,24(s4)
    80002a66:	9dbd                	addw	a1,a1,a5
    80002a68:	8556                	mv	a0,s5
    80002a6a:	00000097          	auipc	ra,0x0
    80002a6e:	97c080e7          	jalr	-1668(ra) # 800023e6 <bread>
    80002a72:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a74:	05850993          	addi	s3,a0,88
    80002a78:	00f97793          	andi	a5,s2,15
    80002a7c:	079a                	slli	a5,a5,0x6
    80002a7e:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a80:	00099783          	lh	a5,0(s3)
    80002a84:	c785                	beqz	a5,80002aac <ialloc+0x7e>
    brelse(bp);
    80002a86:	00000097          	auipc	ra,0x0
    80002a8a:	a90080e7          	jalr	-1392(ra) # 80002516 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a8e:	0905                	addi	s2,s2,1
    80002a90:	00ca2703          	lw	a4,12(s4)
    80002a94:	0009079b          	sext.w	a5,s2
    80002a98:	fce7e3e3          	bltu	a5,a4,80002a5e <ialloc+0x30>
  panic("ialloc: no inodes");
    80002a9c:	00006517          	auipc	a0,0x6
    80002aa0:	99c50513          	addi	a0,a0,-1636 # 80008438 <etext+0x438>
    80002aa4:	00003097          	auipc	ra,0x3
    80002aa8:	368080e7          	jalr	872(ra) # 80005e0c <panic>
      memset(dip, 0, sizeof(*dip));
    80002aac:	04000613          	li	a2,64
    80002ab0:	4581                	li	a1,0
    80002ab2:	854e                	mv	a0,s3
    80002ab4:	ffffd097          	auipc	ra,0xffffd
    80002ab8:	6c6080e7          	jalr	1734(ra) # 8000017a <memset>
      dip->type = type;
    80002abc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ac0:	8526                	mv	a0,s1
    80002ac2:	00001097          	auipc	ra,0x1
    80002ac6:	cd0080e7          	jalr	-816(ra) # 80003792 <log_write>
      brelse(bp);
    80002aca:	8526                	mv	a0,s1
    80002acc:	00000097          	auipc	ra,0x0
    80002ad0:	a4a080e7          	jalr	-1462(ra) # 80002516 <brelse>
      return iget(dev, inum);
    80002ad4:	0009059b          	sext.w	a1,s2
    80002ad8:	8556                	mv	a0,s5
    80002ada:	00000097          	auipc	ra,0x0
    80002ade:	db8080e7          	jalr	-584(ra) # 80002892 <iget>
}
    80002ae2:	70e2                	ld	ra,56(sp)
    80002ae4:	7442                	ld	s0,48(sp)
    80002ae6:	74a2                	ld	s1,40(sp)
    80002ae8:	7902                	ld	s2,32(sp)
    80002aea:	69e2                	ld	s3,24(sp)
    80002aec:	6a42                	ld	s4,16(sp)
    80002aee:	6aa2                	ld	s5,8(sp)
    80002af0:	6b02                	ld	s6,0(sp)
    80002af2:	6121                	addi	sp,sp,64
    80002af4:	8082                	ret

0000000080002af6 <iupdate>:
{
    80002af6:	1101                	addi	sp,sp,-32
    80002af8:	ec06                	sd	ra,24(sp)
    80002afa:	e822                	sd	s0,16(sp)
    80002afc:	e426                	sd	s1,8(sp)
    80002afe:	e04a                	sd	s2,0(sp)
    80002b00:	1000                	addi	s0,sp,32
    80002b02:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b04:	415c                	lw	a5,4(a0)
    80002b06:	0047d79b          	srliw	a5,a5,0x4
    80002b0a:	00015597          	auipc	a1,0x15
    80002b0e:	2665a583          	lw	a1,614(a1) # 80017d70 <sb+0x18>
    80002b12:	9dbd                	addw	a1,a1,a5
    80002b14:	4108                	lw	a0,0(a0)
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	8d0080e7          	jalr	-1840(ra) # 800023e6 <bread>
    80002b1e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b20:	05850793          	addi	a5,a0,88
    80002b24:	40d8                	lw	a4,4(s1)
    80002b26:	8b3d                	andi	a4,a4,15
    80002b28:	071a                	slli	a4,a4,0x6
    80002b2a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b2c:	04449703          	lh	a4,68(s1)
    80002b30:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b34:	04649703          	lh	a4,70(s1)
    80002b38:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b3c:	04849703          	lh	a4,72(s1)
    80002b40:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b44:	04a49703          	lh	a4,74(s1)
    80002b48:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b4c:	44f8                	lw	a4,76(s1)
    80002b4e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b50:	03400613          	li	a2,52
    80002b54:	05048593          	addi	a1,s1,80
    80002b58:	00c78513          	addi	a0,a5,12
    80002b5c:	ffffd097          	auipc	ra,0xffffd
    80002b60:	682080e7          	jalr	1666(ra) # 800001de <memmove>
  log_write(bp);
    80002b64:	854a                	mv	a0,s2
    80002b66:	00001097          	auipc	ra,0x1
    80002b6a:	c2c080e7          	jalr	-980(ra) # 80003792 <log_write>
  brelse(bp);
    80002b6e:	854a                	mv	a0,s2
    80002b70:	00000097          	auipc	ra,0x0
    80002b74:	9a6080e7          	jalr	-1626(ra) # 80002516 <brelse>
}
    80002b78:	60e2                	ld	ra,24(sp)
    80002b7a:	6442                	ld	s0,16(sp)
    80002b7c:	64a2                	ld	s1,8(sp)
    80002b7e:	6902                	ld	s2,0(sp)
    80002b80:	6105                	addi	sp,sp,32
    80002b82:	8082                	ret

0000000080002b84 <idup>:
{
    80002b84:	1101                	addi	sp,sp,-32
    80002b86:	ec06                	sd	ra,24(sp)
    80002b88:	e822                	sd	s0,16(sp)
    80002b8a:	e426                	sd	s1,8(sp)
    80002b8c:	1000                	addi	s0,sp,32
    80002b8e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002b90:	00015517          	auipc	a0,0x15
    80002b94:	1e850513          	addi	a0,a0,488 # 80017d78 <itable>
    80002b98:	00003097          	auipc	ra,0x3
    80002b9c:	7ca080e7          	jalr	1994(ra) # 80006362 <acquire>
  ip->ref++;
    80002ba0:	449c                	lw	a5,8(s1)
    80002ba2:	2785                	addiw	a5,a5,1
    80002ba4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002ba6:	00015517          	auipc	a0,0x15
    80002baa:	1d250513          	addi	a0,a0,466 # 80017d78 <itable>
    80002bae:	00004097          	auipc	ra,0x4
    80002bb2:	864080e7          	jalr	-1948(ra) # 80006412 <release>
}
    80002bb6:	8526                	mv	a0,s1
    80002bb8:	60e2                	ld	ra,24(sp)
    80002bba:	6442                	ld	s0,16(sp)
    80002bbc:	64a2                	ld	s1,8(sp)
    80002bbe:	6105                	addi	sp,sp,32
    80002bc0:	8082                	ret

0000000080002bc2 <ilock>:
{
    80002bc2:	1101                	addi	sp,sp,-32
    80002bc4:	ec06                	sd	ra,24(sp)
    80002bc6:	e822                	sd	s0,16(sp)
    80002bc8:	e426                	sd	s1,8(sp)
    80002bca:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002bcc:	c10d                	beqz	a0,80002bee <ilock+0x2c>
    80002bce:	84aa                	mv	s1,a0
    80002bd0:	451c                	lw	a5,8(a0)
    80002bd2:	00f05e63          	blez	a5,80002bee <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002bd6:	0541                	addi	a0,a0,16
    80002bd8:	00001097          	auipc	ra,0x1
    80002bdc:	cd8080e7          	jalr	-808(ra) # 800038b0 <acquiresleep>
  if(ip->valid == 0){
    80002be0:	40bc                	lw	a5,64(s1)
    80002be2:	cf99                	beqz	a5,80002c00 <ilock+0x3e>
}
    80002be4:	60e2                	ld	ra,24(sp)
    80002be6:	6442                	ld	s0,16(sp)
    80002be8:	64a2                	ld	s1,8(sp)
    80002bea:	6105                	addi	sp,sp,32
    80002bec:	8082                	ret
    80002bee:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002bf0:	00006517          	auipc	a0,0x6
    80002bf4:	86050513          	addi	a0,a0,-1952 # 80008450 <etext+0x450>
    80002bf8:	00003097          	auipc	ra,0x3
    80002bfc:	214080e7          	jalr	532(ra) # 80005e0c <panic>
    80002c00:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c02:	40dc                	lw	a5,4(s1)
    80002c04:	0047d79b          	srliw	a5,a5,0x4
    80002c08:	00015597          	auipc	a1,0x15
    80002c0c:	1685a583          	lw	a1,360(a1) # 80017d70 <sb+0x18>
    80002c10:	9dbd                	addw	a1,a1,a5
    80002c12:	4088                	lw	a0,0(s1)
    80002c14:	fffff097          	auipc	ra,0xfffff
    80002c18:	7d2080e7          	jalr	2002(ra) # 800023e6 <bread>
    80002c1c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c1e:	05850593          	addi	a1,a0,88
    80002c22:	40dc                	lw	a5,4(s1)
    80002c24:	8bbd                	andi	a5,a5,15
    80002c26:	079a                	slli	a5,a5,0x6
    80002c28:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c2a:	00059783          	lh	a5,0(a1)
    80002c2e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c32:	00259783          	lh	a5,2(a1)
    80002c36:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c3a:	00459783          	lh	a5,4(a1)
    80002c3e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c42:	00659783          	lh	a5,6(a1)
    80002c46:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c4a:	459c                	lw	a5,8(a1)
    80002c4c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c4e:	03400613          	li	a2,52
    80002c52:	05b1                	addi	a1,a1,12
    80002c54:	05048513          	addi	a0,s1,80
    80002c58:	ffffd097          	auipc	ra,0xffffd
    80002c5c:	586080e7          	jalr	1414(ra) # 800001de <memmove>
    brelse(bp);
    80002c60:	854a                	mv	a0,s2
    80002c62:	00000097          	auipc	ra,0x0
    80002c66:	8b4080e7          	jalr	-1868(ra) # 80002516 <brelse>
    ip->valid = 1;
    80002c6a:	4785                	li	a5,1
    80002c6c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c6e:	04449783          	lh	a5,68(s1)
    80002c72:	c399                	beqz	a5,80002c78 <ilock+0xb6>
    80002c74:	6902                	ld	s2,0(sp)
    80002c76:	b7bd                	j	80002be4 <ilock+0x22>
      panic("ilock: no type");
    80002c78:	00005517          	auipc	a0,0x5
    80002c7c:	7e050513          	addi	a0,a0,2016 # 80008458 <etext+0x458>
    80002c80:	00003097          	auipc	ra,0x3
    80002c84:	18c080e7          	jalr	396(ra) # 80005e0c <panic>

0000000080002c88 <iunlock>:
{
    80002c88:	1101                	addi	sp,sp,-32
    80002c8a:	ec06                	sd	ra,24(sp)
    80002c8c:	e822                	sd	s0,16(sp)
    80002c8e:	e426                	sd	s1,8(sp)
    80002c90:	e04a                	sd	s2,0(sp)
    80002c92:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002c94:	c905                	beqz	a0,80002cc4 <iunlock+0x3c>
    80002c96:	84aa                	mv	s1,a0
    80002c98:	01050913          	addi	s2,a0,16
    80002c9c:	854a                	mv	a0,s2
    80002c9e:	00001097          	auipc	ra,0x1
    80002ca2:	cac080e7          	jalr	-852(ra) # 8000394a <holdingsleep>
    80002ca6:	cd19                	beqz	a0,80002cc4 <iunlock+0x3c>
    80002ca8:	449c                	lw	a5,8(s1)
    80002caa:	00f05d63          	blez	a5,80002cc4 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cae:	854a                	mv	a0,s2
    80002cb0:	00001097          	auipc	ra,0x1
    80002cb4:	c56080e7          	jalr	-938(ra) # 80003906 <releasesleep>
}
    80002cb8:	60e2                	ld	ra,24(sp)
    80002cba:	6442                	ld	s0,16(sp)
    80002cbc:	64a2                	ld	s1,8(sp)
    80002cbe:	6902                	ld	s2,0(sp)
    80002cc0:	6105                	addi	sp,sp,32
    80002cc2:	8082                	ret
    panic("iunlock");
    80002cc4:	00005517          	auipc	a0,0x5
    80002cc8:	7a450513          	addi	a0,a0,1956 # 80008468 <etext+0x468>
    80002ccc:	00003097          	auipc	ra,0x3
    80002cd0:	140080e7          	jalr	320(ra) # 80005e0c <panic>

0000000080002cd4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002cd4:	7179                	addi	sp,sp,-48
    80002cd6:	f406                	sd	ra,40(sp)
    80002cd8:	f022                	sd	s0,32(sp)
    80002cda:	ec26                	sd	s1,24(sp)
    80002cdc:	e84a                	sd	s2,16(sp)
    80002cde:	e44e                	sd	s3,8(sp)
    80002ce0:	1800                	addi	s0,sp,48
    80002ce2:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002ce4:	05050493          	addi	s1,a0,80
    80002ce8:	08050913          	addi	s2,a0,128
    80002cec:	a021                	j	80002cf4 <itrunc+0x20>
    80002cee:	0491                	addi	s1,s1,4
    80002cf0:	01248d63          	beq	s1,s2,80002d0a <itrunc+0x36>
    if(ip->addrs[i]){
    80002cf4:	408c                	lw	a1,0(s1)
    80002cf6:	dde5                	beqz	a1,80002cee <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002cf8:	0009a503          	lw	a0,0(s3)
    80002cfc:	00000097          	auipc	ra,0x0
    80002d00:	92a080e7          	jalr	-1750(ra) # 80002626 <bfree>
      ip->addrs[i] = 0;
    80002d04:	0004a023          	sw	zero,0(s1)
    80002d08:	b7dd                	j	80002cee <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d0a:	0809a583          	lw	a1,128(s3)
    80002d0e:	ed99                	bnez	a1,80002d2c <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d10:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d14:	854e                	mv	a0,s3
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	de0080e7          	jalr	-544(ra) # 80002af6 <iupdate>
}
    80002d1e:	70a2                	ld	ra,40(sp)
    80002d20:	7402                	ld	s0,32(sp)
    80002d22:	64e2                	ld	s1,24(sp)
    80002d24:	6942                	ld	s2,16(sp)
    80002d26:	69a2                	ld	s3,8(sp)
    80002d28:	6145                	addi	sp,sp,48
    80002d2a:	8082                	ret
    80002d2c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d2e:	0009a503          	lw	a0,0(s3)
    80002d32:	fffff097          	auipc	ra,0xfffff
    80002d36:	6b4080e7          	jalr	1716(ra) # 800023e6 <bread>
    80002d3a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d3c:	05850493          	addi	s1,a0,88
    80002d40:	45850913          	addi	s2,a0,1112
    80002d44:	a021                	j	80002d4c <itrunc+0x78>
    80002d46:	0491                	addi	s1,s1,4
    80002d48:	01248b63          	beq	s1,s2,80002d5e <itrunc+0x8a>
      if(a[j])
    80002d4c:	408c                	lw	a1,0(s1)
    80002d4e:	dde5                	beqz	a1,80002d46 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002d50:	0009a503          	lw	a0,0(s3)
    80002d54:	00000097          	auipc	ra,0x0
    80002d58:	8d2080e7          	jalr	-1838(ra) # 80002626 <bfree>
    80002d5c:	b7ed                	j	80002d46 <itrunc+0x72>
    brelse(bp);
    80002d5e:	8552                	mv	a0,s4
    80002d60:	fffff097          	auipc	ra,0xfffff
    80002d64:	7b6080e7          	jalr	1974(ra) # 80002516 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d68:	0809a583          	lw	a1,128(s3)
    80002d6c:	0009a503          	lw	a0,0(s3)
    80002d70:	00000097          	auipc	ra,0x0
    80002d74:	8b6080e7          	jalr	-1866(ra) # 80002626 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d78:	0809a023          	sw	zero,128(s3)
    80002d7c:	6a02                	ld	s4,0(sp)
    80002d7e:	bf49                	j	80002d10 <itrunc+0x3c>

0000000080002d80 <iput>:
{
    80002d80:	1101                	addi	sp,sp,-32
    80002d82:	ec06                	sd	ra,24(sp)
    80002d84:	e822                	sd	s0,16(sp)
    80002d86:	e426                	sd	s1,8(sp)
    80002d88:	1000                	addi	s0,sp,32
    80002d8a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d8c:	00015517          	auipc	a0,0x15
    80002d90:	fec50513          	addi	a0,a0,-20 # 80017d78 <itable>
    80002d94:	00003097          	auipc	ra,0x3
    80002d98:	5ce080e7          	jalr	1486(ra) # 80006362 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002d9c:	4498                	lw	a4,8(s1)
    80002d9e:	4785                	li	a5,1
    80002da0:	02f70263          	beq	a4,a5,80002dc4 <iput+0x44>
  ip->ref--;
    80002da4:	449c                	lw	a5,8(s1)
    80002da6:	37fd                	addiw	a5,a5,-1
    80002da8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002daa:	00015517          	auipc	a0,0x15
    80002dae:	fce50513          	addi	a0,a0,-50 # 80017d78 <itable>
    80002db2:	00003097          	auipc	ra,0x3
    80002db6:	660080e7          	jalr	1632(ra) # 80006412 <release>
}
    80002dba:	60e2                	ld	ra,24(sp)
    80002dbc:	6442                	ld	s0,16(sp)
    80002dbe:	64a2                	ld	s1,8(sp)
    80002dc0:	6105                	addi	sp,sp,32
    80002dc2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dc4:	40bc                	lw	a5,64(s1)
    80002dc6:	dff9                	beqz	a5,80002da4 <iput+0x24>
    80002dc8:	04a49783          	lh	a5,74(s1)
    80002dcc:	ffe1                	bnez	a5,80002da4 <iput+0x24>
    80002dce:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002dd0:	01048913          	addi	s2,s1,16
    80002dd4:	854a                	mv	a0,s2
    80002dd6:	00001097          	auipc	ra,0x1
    80002dda:	ada080e7          	jalr	-1318(ra) # 800038b0 <acquiresleep>
    release(&itable.lock);
    80002dde:	00015517          	auipc	a0,0x15
    80002de2:	f9a50513          	addi	a0,a0,-102 # 80017d78 <itable>
    80002de6:	00003097          	auipc	ra,0x3
    80002dea:	62c080e7          	jalr	1580(ra) # 80006412 <release>
    itrunc(ip);
    80002dee:	8526                	mv	a0,s1
    80002df0:	00000097          	auipc	ra,0x0
    80002df4:	ee4080e7          	jalr	-284(ra) # 80002cd4 <itrunc>
    ip->type = 0;
    80002df8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002dfc:	8526                	mv	a0,s1
    80002dfe:	00000097          	auipc	ra,0x0
    80002e02:	cf8080e7          	jalr	-776(ra) # 80002af6 <iupdate>
    ip->valid = 0;
    80002e06:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	00001097          	auipc	ra,0x1
    80002e10:	afa080e7          	jalr	-1286(ra) # 80003906 <releasesleep>
    acquire(&itable.lock);
    80002e14:	00015517          	auipc	a0,0x15
    80002e18:	f6450513          	addi	a0,a0,-156 # 80017d78 <itable>
    80002e1c:	00003097          	auipc	ra,0x3
    80002e20:	546080e7          	jalr	1350(ra) # 80006362 <acquire>
    80002e24:	6902                	ld	s2,0(sp)
    80002e26:	bfbd                	j	80002da4 <iput+0x24>

0000000080002e28 <iunlockput>:
{
    80002e28:	1101                	addi	sp,sp,-32
    80002e2a:	ec06                	sd	ra,24(sp)
    80002e2c:	e822                	sd	s0,16(sp)
    80002e2e:	e426                	sd	s1,8(sp)
    80002e30:	1000                	addi	s0,sp,32
    80002e32:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e34:	00000097          	auipc	ra,0x0
    80002e38:	e54080e7          	jalr	-428(ra) # 80002c88 <iunlock>
  iput(ip);
    80002e3c:	8526                	mv	a0,s1
    80002e3e:	00000097          	auipc	ra,0x0
    80002e42:	f42080e7          	jalr	-190(ra) # 80002d80 <iput>
}
    80002e46:	60e2                	ld	ra,24(sp)
    80002e48:	6442                	ld	s0,16(sp)
    80002e4a:	64a2                	ld	s1,8(sp)
    80002e4c:	6105                	addi	sp,sp,32
    80002e4e:	8082                	ret

0000000080002e50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e50:	1141                	addi	sp,sp,-16
    80002e52:	e406                	sd	ra,8(sp)
    80002e54:	e022                	sd	s0,0(sp)
    80002e56:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e58:	411c                	lw	a5,0(a0)
    80002e5a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e5c:	415c                	lw	a5,4(a0)
    80002e5e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e60:	04451783          	lh	a5,68(a0)
    80002e64:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e68:	04a51783          	lh	a5,74(a0)
    80002e6c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e70:	04c56783          	lwu	a5,76(a0)
    80002e74:	e99c                	sd	a5,16(a1)
}
    80002e76:	60a2                	ld	ra,8(sp)
    80002e78:	6402                	ld	s0,0(sp)
    80002e7a:	0141                	addi	sp,sp,16
    80002e7c:	8082                	ret

0000000080002e7e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e7e:	457c                	lw	a5,76(a0)
    80002e80:	0ed7ea63          	bltu	a5,a3,80002f74 <readi+0xf6>
{
    80002e84:	7159                	addi	sp,sp,-112
    80002e86:	f486                	sd	ra,104(sp)
    80002e88:	f0a2                	sd	s0,96(sp)
    80002e8a:	eca6                	sd	s1,88(sp)
    80002e8c:	fc56                	sd	s5,56(sp)
    80002e8e:	f85a                	sd	s6,48(sp)
    80002e90:	f45e                	sd	s7,40(sp)
    80002e92:	ec66                	sd	s9,24(sp)
    80002e94:	1880                	addi	s0,sp,112
    80002e96:	8baa                	mv	s7,a0
    80002e98:	8cae                	mv	s9,a1
    80002e9a:	8ab2                	mv	s5,a2
    80002e9c:	84b6                	mv	s1,a3
    80002e9e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002ea0:	9f35                	addw	a4,a4,a3
    return 0;
    80002ea2:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ea4:	0ad76763          	bltu	a4,a3,80002f52 <readi+0xd4>
    80002ea8:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002eaa:	00e7f463          	bgeu	a5,a4,80002eb2 <readi+0x34>
    n = ip->size - off;
    80002eae:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002eb2:	0a0b0f63          	beqz	s6,80002f70 <readi+0xf2>
    80002eb6:	e8ca                	sd	s2,80(sp)
    80002eb8:	e0d2                	sd	s4,64(sp)
    80002eba:	f062                	sd	s8,32(sp)
    80002ebc:	e86a                	sd	s10,16(sp)
    80002ebe:	e46e                	sd	s11,8(sp)
    80002ec0:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ec2:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ec6:	5d7d                	li	s10,-1
    80002ec8:	a82d                	j	80002f02 <readi+0x84>
    80002eca:	020a1c13          	slli	s8,s4,0x20
    80002ece:	020c5c13          	srli	s8,s8,0x20
    80002ed2:	05890613          	addi	a2,s2,88
    80002ed6:	86e2                	mv	a3,s8
    80002ed8:	963e                	add	a2,a2,a5
    80002eda:	85d6                	mv	a1,s5
    80002edc:	8566                	mv	a0,s9
    80002ede:	fffff097          	auipc	ra,0xfffff
    80002ee2:	a34080e7          	jalr	-1484(ra) # 80001912 <either_copyout>
    80002ee6:	05a50963          	beq	a0,s10,80002f38 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002eea:	854a                	mv	a0,s2
    80002eec:	fffff097          	auipc	ra,0xfffff
    80002ef0:	62a080e7          	jalr	1578(ra) # 80002516 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ef4:	013a09bb          	addw	s3,s4,s3
    80002ef8:	009a04bb          	addw	s1,s4,s1
    80002efc:	9ae2                	add	s5,s5,s8
    80002efe:	0769f363          	bgeu	s3,s6,80002f64 <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80002f02:	000ba903          	lw	s2,0(s7)
    80002f06:	00a4d59b          	srliw	a1,s1,0xa
    80002f0a:	855e                	mv	a0,s7
    80002f0c:	00000097          	auipc	ra,0x0
    80002f10:	8b8080e7          	jalr	-1864(ra) # 800027c4 <bmap>
    80002f14:	85aa                	mv	a1,a0
    80002f16:	854a                	mv	a0,s2
    80002f18:	fffff097          	auipc	ra,0xfffff
    80002f1c:	4ce080e7          	jalr	1230(ra) # 800023e6 <bread>
    80002f20:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f22:	3ff4f793          	andi	a5,s1,1023
    80002f26:	40fd873b          	subw	a4,s11,a5
    80002f2a:	413b06bb          	subw	a3,s6,s3
    80002f2e:	8a3a                	mv	s4,a4
    80002f30:	f8e6fde3          	bgeu	a3,a4,80002eca <readi+0x4c>
    80002f34:	8a36                	mv	s4,a3
    80002f36:	bf51                	j	80002eca <readi+0x4c>
      brelse(bp);
    80002f38:	854a                	mv	a0,s2
    80002f3a:	fffff097          	auipc	ra,0xfffff
    80002f3e:	5dc080e7          	jalr	1500(ra) # 80002516 <brelse>
      tot = -1;
    80002f42:	59fd                	li	s3,-1
      break;
    80002f44:	6946                	ld	s2,80(sp)
    80002f46:	6a06                	ld	s4,64(sp)
    80002f48:	7c02                	ld	s8,32(sp)
    80002f4a:	6d42                	ld	s10,16(sp)
    80002f4c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002f4e:	854e                	mv	a0,s3
    80002f50:	69a6                	ld	s3,72(sp)
}
    80002f52:	70a6                	ld	ra,104(sp)
    80002f54:	7406                	ld	s0,96(sp)
    80002f56:	64e6                	ld	s1,88(sp)
    80002f58:	7ae2                	ld	s5,56(sp)
    80002f5a:	7b42                	ld	s6,48(sp)
    80002f5c:	7ba2                	ld	s7,40(sp)
    80002f5e:	6ce2                	ld	s9,24(sp)
    80002f60:	6165                	addi	sp,sp,112
    80002f62:	8082                	ret
    80002f64:	6946                	ld	s2,80(sp)
    80002f66:	6a06                	ld	s4,64(sp)
    80002f68:	7c02                	ld	s8,32(sp)
    80002f6a:	6d42                	ld	s10,16(sp)
    80002f6c:	6da2                	ld	s11,8(sp)
    80002f6e:	b7c5                	j	80002f4e <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f70:	89da                	mv	s3,s6
    80002f72:	bff1                	j	80002f4e <readi+0xd0>
    return 0;
    80002f74:	4501                	li	a0,0
}
    80002f76:	8082                	ret

0000000080002f78 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f78:	457c                	lw	a5,76(a0)
    80002f7a:	10d7e963          	bltu	a5,a3,8000308c <writei+0x114>
{
    80002f7e:	7159                	addi	sp,sp,-112
    80002f80:	f486                	sd	ra,104(sp)
    80002f82:	f0a2                	sd	s0,96(sp)
    80002f84:	e8ca                	sd	s2,80(sp)
    80002f86:	fc56                	sd	s5,56(sp)
    80002f88:	f45e                	sd	s7,40(sp)
    80002f8a:	f062                	sd	s8,32(sp)
    80002f8c:	ec66                	sd	s9,24(sp)
    80002f8e:	1880                	addi	s0,sp,112
    80002f90:	8baa                	mv	s7,a0
    80002f92:	8cae                	mv	s9,a1
    80002f94:	8ab2                	mv	s5,a2
    80002f96:	8936                	mv	s2,a3
    80002f98:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    80002f9a:	00e687bb          	addw	a5,a3,a4
    80002f9e:	0ed7e963          	bltu	a5,a3,80003090 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fa2:	00043737          	lui	a4,0x43
    80002fa6:	0ef76763          	bltu	a4,a5,80003094 <writei+0x11c>
    80002faa:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fac:	0c0c0863          	beqz	s8,8000307c <writei+0x104>
    80002fb0:	eca6                	sd	s1,88(sp)
    80002fb2:	e4ce                	sd	s3,72(sp)
    80002fb4:	f85a                	sd	s6,48(sp)
    80002fb6:	e86a                	sd	s10,16(sp)
    80002fb8:	e46e                	sd	s11,8(sp)
    80002fba:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fbc:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fc0:	5d7d                	li	s10,-1
    80002fc2:	a091                	j	80003006 <writei+0x8e>
    80002fc4:	02099b13          	slli	s6,s3,0x20
    80002fc8:	020b5b13          	srli	s6,s6,0x20
    80002fcc:	05848513          	addi	a0,s1,88
    80002fd0:	86da                	mv	a3,s6
    80002fd2:	8656                	mv	a2,s5
    80002fd4:	85e6                	mv	a1,s9
    80002fd6:	953e                	add	a0,a0,a5
    80002fd8:	fffff097          	auipc	ra,0xfffff
    80002fdc:	990080e7          	jalr	-1648(ra) # 80001968 <either_copyin>
    80002fe0:	05a50e63          	beq	a0,s10,8000303c <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002fe4:	8526                	mv	a0,s1
    80002fe6:	00000097          	auipc	ra,0x0
    80002fea:	7ac080e7          	jalr	1964(ra) # 80003792 <log_write>
    brelse(bp);
    80002fee:	8526                	mv	a0,s1
    80002ff0:	fffff097          	auipc	ra,0xfffff
    80002ff4:	526080e7          	jalr	1318(ra) # 80002516 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff8:	01498a3b          	addw	s4,s3,s4
    80002ffc:	0129893b          	addw	s2,s3,s2
    80003000:	9ada                	add	s5,s5,s6
    80003002:	058a7263          	bgeu	s4,s8,80003046 <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003006:	000ba483          	lw	s1,0(s7)
    8000300a:	00a9559b          	srliw	a1,s2,0xa
    8000300e:	855e                	mv	a0,s7
    80003010:	fffff097          	auipc	ra,0xfffff
    80003014:	7b4080e7          	jalr	1972(ra) # 800027c4 <bmap>
    80003018:	85aa                	mv	a1,a0
    8000301a:	8526                	mv	a0,s1
    8000301c:	fffff097          	auipc	ra,0xfffff
    80003020:	3ca080e7          	jalr	970(ra) # 800023e6 <bread>
    80003024:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003026:	3ff97793          	andi	a5,s2,1023
    8000302a:	40fd873b          	subw	a4,s11,a5
    8000302e:	414c06bb          	subw	a3,s8,s4
    80003032:	89ba                	mv	s3,a4
    80003034:	f8e6f8e3          	bgeu	a3,a4,80002fc4 <writei+0x4c>
    80003038:	89b6                	mv	s3,a3
    8000303a:	b769                	j	80002fc4 <writei+0x4c>
      brelse(bp);
    8000303c:	8526                	mv	a0,s1
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	4d8080e7          	jalr	1240(ra) # 80002516 <brelse>
  }

  if(off > ip->size)
    80003046:	04cba783          	lw	a5,76(s7)
    8000304a:	0327fb63          	bgeu	a5,s2,80003080 <writei+0x108>
    ip->size = off;
    8000304e:	052ba623          	sw	s2,76(s7)
    80003052:	64e6                	ld	s1,88(sp)
    80003054:	69a6                	ld	s3,72(sp)
    80003056:	7b42                	ld	s6,48(sp)
    80003058:	6d42                	ld	s10,16(sp)
    8000305a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000305c:	855e                	mv	a0,s7
    8000305e:	00000097          	auipc	ra,0x0
    80003062:	a98080e7          	jalr	-1384(ra) # 80002af6 <iupdate>

  return tot;
    80003066:	8552                	mv	a0,s4
    80003068:	6a06                	ld	s4,64(sp)
}
    8000306a:	70a6                	ld	ra,104(sp)
    8000306c:	7406                	ld	s0,96(sp)
    8000306e:	6946                	ld	s2,80(sp)
    80003070:	7ae2                	ld	s5,56(sp)
    80003072:	7ba2                	ld	s7,40(sp)
    80003074:	7c02                	ld	s8,32(sp)
    80003076:	6ce2                	ld	s9,24(sp)
    80003078:	6165                	addi	sp,sp,112
    8000307a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000307c:	8a62                	mv	s4,s8
    8000307e:	bff9                	j	8000305c <writei+0xe4>
    80003080:	64e6                	ld	s1,88(sp)
    80003082:	69a6                	ld	s3,72(sp)
    80003084:	7b42                	ld	s6,48(sp)
    80003086:	6d42                	ld	s10,16(sp)
    80003088:	6da2                	ld	s11,8(sp)
    8000308a:	bfc9                	j	8000305c <writei+0xe4>
    return -1;
    8000308c:	557d                	li	a0,-1
}
    8000308e:	8082                	ret
    return -1;
    80003090:	557d                	li	a0,-1
    80003092:	bfe1                	j	8000306a <writei+0xf2>
    return -1;
    80003094:	557d                	li	a0,-1
    80003096:	bfd1                	j	8000306a <writei+0xf2>

0000000080003098 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003098:	1141                	addi	sp,sp,-16
    8000309a:	e406                	sd	ra,8(sp)
    8000309c:	e022                	sd	s0,0(sp)
    8000309e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030a0:	4639                	li	a2,14
    800030a2:	ffffd097          	auipc	ra,0xffffd
    800030a6:	1b4080e7          	jalr	436(ra) # 80000256 <strncmp>
}
    800030aa:	60a2                	ld	ra,8(sp)
    800030ac:	6402                	ld	s0,0(sp)
    800030ae:	0141                	addi	sp,sp,16
    800030b0:	8082                	ret

00000000800030b2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030b2:	711d                	addi	sp,sp,-96
    800030b4:	ec86                	sd	ra,88(sp)
    800030b6:	e8a2                	sd	s0,80(sp)
    800030b8:	e4a6                	sd	s1,72(sp)
    800030ba:	e0ca                	sd	s2,64(sp)
    800030bc:	fc4e                	sd	s3,56(sp)
    800030be:	f852                	sd	s4,48(sp)
    800030c0:	f456                	sd	s5,40(sp)
    800030c2:	f05a                	sd	s6,32(sp)
    800030c4:	ec5e                	sd	s7,24(sp)
    800030c6:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030c8:	04451703          	lh	a4,68(a0)
    800030cc:	4785                	li	a5,1
    800030ce:	00f71f63          	bne	a4,a5,800030ec <dirlookup+0x3a>
    800030d2:	892a                	mv	s2,a0
    800030d4:	8aae                	mv	s5,a1
    800030d6:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d8:	457c                	lw	a5,76(a0)
    800030da:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030dc:	fa040a13          	addi	s4,s0,-96
    800030e0:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800030e2:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030e6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e8:	e79d                	bnez	a5,80003116 <dirlookup+0x64>
    800030ea:	a88d                	j	8000315c <dirlookup+0xaa>
    panic("dirlookup not DIR");
    800030ec:	00005517          	auipc	a0,0x5
    800030f0:	38450513          	addi	a0,a0,900 # 80008470 <etext+0x470>
    800030f4:	00003097          	auipc	ra,0x3
    800030f8:	d18080e7          	jalr	-744(ra) # 80005e0c <panic>
      panic("dirlookup read");
    800030fc:	00005517          	auipc	a0,0x5
    80003100:	38c50513          	addi	a0,a0,908 # 80008488 <etext+0x488>
    80003104:	00003097          	auipc	ra,0x3
    80003108:	d08080e7          	jalr	-760(ra) # 80005e0c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000310c:	24c1                	addiw	s1,s1,16
    8000310e:	04c92783          	lw	a5,76(s2)
    80003112:	04f4f463          	bgeu	s1,a5,8000315a <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003116:	874e                	mv	a4,s3
    80003118:	86a6                	mv	a3,s1
    8000311a:	8652                	mv	a2,s4
    8000311c:	4581                	li	a1,0
    8000311e:	854a                	mv	a0,s2
    80003120:	00000097          	auipc	ra,0x0
    80003124:	d5e080e7          	jalr	-674(ra) # 80002e7e <readi>
    80003128:	fd351ae3          	bne	a0,s3,800030fc <dirlookup+0x4a>
    if(de.inum == 0)
    8000312c:	fa045783          	lhu	a5,-96(s0)
    80003130:	dff1                	beqz	a5,8000310c <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80003132:	85da                	mv	a1,s6
    80003134:	8556                	mv	a0,s5
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	f62080e7          	jalr	-158(ra) # 80003098 <namecmp>
    8000313e:	f579                	bnez	a0,8000310c <dirlookup+0x5a>
      if(poff)
    80003140:	000b8463          	beqz	s7,80003148 <dirlookup+0x96>
        *poff = off;
    80003144:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003148:	fa045583          	lhu	a1,-96(s0)
    8000314c:	00092503          	lw	a0,0(s2)
    80003150:	fffff097          	auipc	ra,0xfffff
    80003154:	742080e7          	jalr	1858(ra) # 80002892 <iget>
    80003158:	a011                	j	8000315c <dirlookup+0xaa>
  return 0;
    8000315a:	4501                	li	a0,0
}
    8000315c:	60e6                	ld	ra,88(sp)
    8000315e:	6446                	ld	s0,80(sp)
    80003160:	64a6                	ld	s1,72(sp)
    80003162:	6906                	ld	s2,64(sp)
    80003164:	79e2                	ld	s3,56(sp)
    80003166:	7a42                	ld	s4,48(sp)
    80003168:	7aa2                	ld	s5,40(sp)
    8000316a:	7b02                	ld	s6,32(sp)
    8000316c:	6be2                	ld	s7,24(sp)
    8000316e:	6125                	addi	sp,sp,96
    80003170:	8082                	ret

0000000080003172 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003172:	711d                	addi	sp,sp,-96
    80003174:	ec86                	sd	ra,88(sp)
    80003176:	e8a2                	sd	s0,80(sp)
    80003178:	e4a6                	sd	s1,72(sp)
    8000317a:	e0ca                	sd	s2,64(sp)
    8000317c:	fc4e                	sd	s3,56(sp)
    8000317e:	f852                	sd	s4,48(sp)
    80003180:	f456                	sd	s5,40(sp)
    80003182:	f05a                	sd	s6,32(sp)
    80003184:	ec5e                	sd	s7,24(sp)
    80003186:	e862                	sd	s8,16(sp)
    80003188:	e466                	sd	s9,8(sp)
    8000318a:	e06a                	sd	s10,0(sp)
    8000318c:	1080                	addi	s0,sp,96
    8000318e:	84aa                	mv	s1,a0
    80003190:	8b2e                	mv	s6,a1
    80003192:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003194:	00054703          	lbu	a4,0(a0)
    80003198:	02f00793          	li	a5,47
    8000319c:	02f70363          	beq	a4,a5,800031c2 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031a0:	ffffe097          	auipc	ra,0xffffe
    800031a4:	d02080e7          	jalr	-766(ra) # 80000ea2 <myproc>
    800031a8:	15053503          	ld	a0,336(a0)
    800031ac:	00000097          	auipc	ra,0x0
    800031b0:	9d8080e7          	jalr	-1576(ra) # 80002b84 <idup>
    800031b4:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031b6:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031ba:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800031bc:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031be:	4b85                	li	s7,1
    800031c0:	a87d                	j	8000327e <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800031c2:	4585                	li	a1,1
    800031c4:	852e                	mv	a0,a1
    800031c6:	fffff097          	auipc	ra,0xfffff
    800031ca:	6cc080e7          	jalr	1740(ra) # 80002892 <iget>
    800031ce:	8a2a                	mv	s4,a0
    800031d0:	b7dd                	j	800031b6 <namex+0x44>
      iunlockput(ip);
    800031d2:	8552                	mv	a0,s4
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	c54080e7          	jalr	-940(ra) # 80002e28 <iunlockput>
      return 0;
    800031dc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031de:	8552                	mv	a0,s4
    800031e0:	60e6                	ld	ra,88(sp)
    800031e2:	6446                	ld	s0,80(sp)
    800031e4:	64a6                	ld	s1,72(sp)
    800031e6:	6906                	ld	s2,64(sp)
    800031e8:	79e2                	ld	s3,56(sp)
    800031ea:	7a42                	ld	s4,48(sp)
    800031ec:	7aa2                	ld	s5,40(sp)
    800031ee:	7b02                	ld	s6,32(sp)
    800031f0:	6be2                	ld	s7,24(sp)
    800031f2:	6c42                	ld	s8,16(sp)
    800031f4:	6ca2                	ld	s9,8(sp)
    800031f6:	6d02                	ld	s10,0(sp)
    800031f8:	6125                	addi	sp,sp,96
    800031fa:	8082                	ret
      iunlock(ip);
    800031fc:	8552                	mv	a0,s4
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	a8a080e7          	jalr	-1398(ra) # 80002c88 <iunlock>
      return ip;
    80003206:	bfe1                	j	800031de <namex+0x6c>
      iunlockput(ip);
    80003208:	8552                	mv	a0,s4
    8000320a:	00000097          	auipc	ra,0x0
    8000320e:	c1e080e7          	jalr	-994(ra) # 80002e28 <iunlockput>
      return 0;
    80003212:	8a4e                	mv	s4,s3
    80003214:	b7e9                	j	800031de <namex+0x6c>
  len = path - s;
    80003216:	40998633          	sub	a2,s3,s1
    8000321a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    8000321e:	09ac5863          	bge	s8,s10,800032ae <namex+0x13c>
    memmove(name, s, DIRSIZ);
    80003222:	8666                	mv	a2,s9
    80003224:	85a6                	mv	a1,s1
    80003226:	8556                	mv	a0,s5
    80003228:	ffffd097          	auipc	ra,0xffffd
    8000322c:	fb6080e7          	jalr	-74(ra) # 800001de <memmove>
    80003230:	84ce                	mv	s1,s3
  while(*path == '/')
    80003232:	0004c783          	lbu	a5,0(s1)
    80003236:	01279763          	bne	a5,s2,80003244 <namex+0xd2>
    path++;
    8000323a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000323c:	0004c783          	lbu	a5,0(s1)
    80003240:	ff278de3          	beq	a5,s2,8000323a <namex+0xc8>
    ilock(ip);
    80003244:	8552                	mv	a0,s4
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	97c080e7          	jalr	-1668(ra) # 80002bc2 <ilock>
    if(ip->type != T_DIR){
    8000324e:	044a1783          	lh	a5,68(s4)
    80003252:	f97790e3          	bne	a5,s7,800031d2 <namex+0x60>
    if(nameiparent && *path == '\0'){
    80003256:	000b0563          	beqz	s6,80003260 <namex+0xee>
    8000325a:	0004c783          	lbu	a5,0(s1)
    8000325e:	dfd9                	beqz	a5,800031fc <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003260:	4601                	li	a2,0
    80003262:	85d6                	mv	a1,s5
    80003264:	8552                	mv	a0,s4
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	e4c080e7          	jalr	-436(ra) # 800030b2 <dirlookup>
    8000326e:	89aa                	mv	s3,a0
    80003270:	dd41                	beqz	a0,80003208 <namex+0x96>
    iunlockput(ip);
    80003272:	8552                	mv	a0,s4
    80003274:	00000097          	auipc	ra,0x0
    80003278:	bb4080e7          	jalr	-1100(ra) # 80002e28 <iunlockput>
    ip = next;
    8000327c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000327e:	0004c783          	lbu	a5,0(s1)
    80003282:	01279763          	bne	a5,s2,80003290 <namex+0x11e>
    path++;
    80003286:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003288:	0004c783          	lbu	a5,0(s1)
    8000328c:	ff278de3          	beq	a5,s2,80003286 <namex+0x114>
  if(*path == 0)
    80003290:	cb9d                	beqz	a5,800032c6 <namex+0x154>
  while(*path != '/' && *path != 0)
    80003292:	0004c783          	lbu	a5,0(s1)
    80003296:	89a6                	mv	s3,s1
  len = path - s;
    80003298:	4d01                	li	s10,0
    8000329a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000329c:	01278963          	beq	a5,s2,800032ae <namex+0x13c>
    800032a0:	dbbd                	beqz	a5,80003216 <namex+0xa4>
    path++;
    800032a2:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032a4:	0009c783          	lbu	a5,0(s3)
    800032a8:	ff279ce3          	bne	a5,s2,800032a0 <namex+0x12e>
    800032ac:	b7ad                	j	80003216 <namex+0xa4>
    memmove(name, s, len);
    800032ae:	2601                	sext.w	a2,a2
    800032b0:	85a6                	mv	a1,s1
    800032b2:	8556                	mv	a0,s5
    800032b4:	ffffd097          	auipc	ra,0xffffd
    800032b8:	f2a080e7          	jalr	-214(ra) # 800001de <memmove>
    name[len] = 0;
    800032bc:	9d56                	add	s10,s10,s5
    800032be:	000d0023          	sb	zero,0(s10)
    800032c2:	84ce                	mv	s1,s3
    800032c4:	b7bd                	j	80003232 <namex+0xc0>
  if(nameiparent){
    800032c6:	f00b0ce3          	beqz	s6,800031de <namex+0x6c>
    iput(ip);
    800032ca:	8552                	mv	a0,s4
    800032cc:	00000097          	auipc	ra,0x0
    800032d0:	ab4080e7          	jalr	-1356(ra) # 80002d80 <iput>
    return 0;
    800032d4:	4a01                	li	s4,0
    800032d6:	b721                	j	800031de <namex+0x6c>

00000000800032d8 <dirlink>:
{
    800032d8:	715d                	addi	sp,sp,-80
    800032da:	e486                	sd	ra,72(sp)
    800032dc:	e0a2                	sd	s0,64(sp)
    800032de:	f84a                	sd	s2,48(sp)
    800032e0:	ec56                	sd	s5,24(sp)
    800032e2:	e85a                	sd	s6,16(sp)
    800032e4:	0880                	addi	s0,sp,80
    800032e6:	892a                	mv	s2,a0
    800032e8:	8aae                	mv	s5,a1
    800032ea:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032ec:	4601                	li	a2,0
    800032ee:	00000097          	auipc	ra,0x0
    800032f2:	dc4080e7          	jalr	-572(ra) # 800030b2 <dirlookup>
    800032f6:	e129                	bnez	a0,80003338 <dirlink+0x60>
    800032f8:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032fa:	04c92483          	lw	s1,76(s2)
    800032fe:	cca9                	beqz	s1,80003358 <dirlink+0x80>
    80003300:	f44e                	sd	s3,40(sp)
    80003302:	f052                	sd	s4,32(sp)
    80003304:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003306:	fb040a13          	addi	s4,s0,-80
    8000330a:	49c1                	li	s3,16
    8000330c:	874e                	mv	a4,s3
    8000330e:	86a6                	mv	a3,s1
    80003310:	8652                	mv	a2,s4
    80003312:	4581                	li	a1,0
    80003314:	854a                	mv	a0,s2
    80003316:	00000097          	auipc	ra,0x0
    8000331a:	b68080e7          	jalr	-1176(ra) # 80002e7e <readi>
    8000331e:	03351363          	bne	a0,s3,80003344 <dirlink+0x6c>
    if(de.inum == 0)
    80003322:	fb045783          	lhu	a5,-80(s0)
    80003326:	c79d                	beqz	a5,80003354 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003328:	24c1                	addiw	s1,s1,16
    8000332a:	04c92783          	lw	a5,76(s2)
    8000332e:	fcf4efe3          	bltu	s1,a5,8000330c <dirlink+0x34>
    80003332:	79a2                	ld	s3,40(sp)
    80003334:	7a02                	ld	s4,32(sp)
    80003336:	a00d                	j	80003358 <dirlink+0x80>
    iput(ip);
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	a48080e7          	jalr	-1464(ra) # 80002d80 <iput>
    return -1;
    80003340:	557d                	li	a0,-1
    80003342:	a0a9                	j	8000338c <dirlink+0xb4>
      panic("dirlink read");
    80003344:	00005517          	auipc	a0,0x5
    80003348:	15450513          	addi	a0,a0,340 # 80008498 <etext+0x498>
    8000334c:	00003097          	auipc	ra,0x3
    80003350:	ac0080e7          	jalr	-1344(ra) # 80005e0c <panic>
    80003354:	79a2                	ld	s3,40(sp)
    80003356:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003358:	4639                	li	a2,14
    8000335a:	85d6                	mv	a1,s5
    8000335c:	fb240513          	addi	a0,s0,-78
    80003360:	ffffd097          	auipc	ra,0xffffd
    80003364:	f30080e7          	jalr	-208(ra) # 80000290 <strncpy>
  de.inum = inum;
    80003368:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000336c:	4741                	li	a4,16
    8000336e:	86a6                	mv	a3,s1
    80003370:	fb040613          	addi	a2,s0,-80
    80003374:	4581                	li	a1,0
    80003376:	854a                	mv	a0,s2
    80003378:	00000097          	auipc	ra,0x0
    8000337c:	c00080e7          	jalr	-1024(ra) # 80002f78 <writei>
    80003380:	872a                	mv	a4,a0
    80003382:	47c1                	li	a5,16
  return 0;
    80003384:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003386:	00f71a63          	bne	a4,a5,8000339a <dirlink+0xc2>
    8000338a:	74e2                	ld	s1,56(sp)
}
    8000338c:	60a6                	ld	ra,72(sp)
    8000338e:	6406                	ld	s0,64(sp)
    80003390:	7942                	ld	s2,48(sp)
    80003392:	6ae2                	ld	s5,24(sp)
    80003394:	6b42                	ld	s6,16(sp)
    80003396:	6161                	addi	sp,sp,80
    80003398:	8082                	ret
    8000339a:	f44e                	sd	s3,40(sp)
    8000339c:	f052                	sd	s4,32(sp)
    panic("dirlink");
    8000339e:	00005517          	auipc	a0,0x5
    800033a2:	20a50513          	addi	a0,a0,522 # 800085a8 <etext+0x5a8>
    800033a6:	00003097          	auipc	ra,0x3
    800033aa:	a66080e7          	jalr	-1434(ra) # 80005e0c <panic>

00000000800033ae <namei>:

struct inode*
namei(char *path)
{
    800033ae:	1101                	addi	sp,sp,-32
    800033b0:	ec06                	sd	ra,24(sp)
    800033b2:	e822                	sd	s0,16(sp)
    800033b4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033b6:	fe040613          	addi	a2,s0,-32
    800033ba:	4581                	li	a1,0
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	db6080e7          	jalr	-586(ra) # 80003172 <namex>
}
    800033c4:	60e2                	ld	ra,24(sp)
    800033c6:	6442                	ld	s0,16(sp)
    800033c8:	6105                	addi	sp,sp,32
    800033ca:	8082                	ret

00000000800033cc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033cc:	1141                	addi	sp,sp,-16
    800033ce:	e406                	sd	ra,8(sp)
    800033d0:	e022                	sd	s0,0(sp)
    800033d2:	0800                	addi	s0,sp,16
    800033d4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033d6:	4585                	li	a1,1
    800033d8:	00000097          	auipc	ra,0x0
    800033dc:	d9a080e7          	jalr	-614(ra) # 80003172 <namex>
}
    800033e0:	60a2                	ld	ra,8(sp)
    800033e2:	6402                	ld	s0,0(sp)
    800033e4:	0141                	addi	sp,sp,16
    800033e6:	8082                	ret

00000000800033e8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	e04a                	sd	s2,0(sp)
    800033f2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033f4:	00016917          	auipc	s2,0x16
    800033f8:	42c90913          	addi	s2,s2,1068 # 80019820 <log>
    800033fc:	01892583          	lw	a1,24(s2)
    80003400:	02892503          	lw	a0,40(s2)
    80003404:	fffff097          	auipc	ra,0xfffff
    80003408:	fe2080e7          	jalr	-30(ra) # 800023e6 <bread>
    8000340c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000340e:	02c92603          	lw	a2,44(s2)
    80003412:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003414:	00c05f63          	blez	a2,80003432 <write_head+0x4a>
    80003418:	00016717          	auipc	a4,0x16
    8000341c:	43870713          	addi	a4,a4,1080 # 80019850 <log+0x30>
    80003420:	87aa                	mv	a5,a0
    80003422:	060a                	slli	a2,a2,0x2
    80003424:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003426:	4314                	lw	a3,0(a4)
    80003428:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000342a:	0711                	addi	a4,a4,4
    8000342c:	0791                	addi	a5,a5,4
    8000342e:	fec79ce3          	bne	a5,a2,80003426 <write_head+0x3e>
  }
  bwrite(buf);
    80003432:	8526                	mv	a0,s1
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	0a4080e7          	jalr	164(ra) # 800024d8 <bwrite>
  brelse(buf);
    8000343c:	8526                	mv	a0,s1
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	0d8080e7          	jalr	216(ra) # 80002516 <brelse>
}
    80003446:	60e2                	ld	ra,24(sp)
    80003448:	6442                	ld	s0,16(sp)
    8000344a:	64a2                	ld	s1,8(sp)
    8000344c:	6902                	ld	s2,0(sp)
    8000344e:	6105                	addi	sp,sp,32
    80003450:	8082                	ret

0000000080003452 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003452:	00016797          	auipc	a5,0x16
    80003456:	3fa7a783          	lw	a5,1018(a5) # 8001984c <log+0x2c>
    8000345a:	0cf05063          	blez	a5,8000351a <install_trans+0xc8>
{
    8000345e:	715d                	addi	sp,sp,-80
    80003460:	e486                	sd	ra,72(sp)
    80003462:	e0a2                	sd	s0,64(sp)
    80003464:	fc26                	sd	s1,56(sp)
    80003466:	f84a                	sd	s2,48(sp)
    80003468:	f44e                	sd	s3,40(sp)
    8000346a:	f052                	sd	s4,32(sp)
    8000346c:	ec56                	sd	s5,24(sp)
    8000346e:	e85a                	sd	s6,16(sp)
    80003470:	e45e                	sd	s7,8(sp)
    80003472:	0880                	addi	s0,sp,80
    80003474:	8b2a                	mv	s6,a0
    80003476:	00016a97          	auipc	s5,0x16
    8000347a:	3daa8a93          	addi	s5,s5,986 # 80019850 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003480:	00016997          	auipc	s3,0x16
    80003484:	3a098993          	addi	s3,s3,928 # 80019820 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003488:	40000b93          	li	s7,1024
    8000348c:	a00d                	j	800034ae <install_trans+0x5c>
    brelse(lbuf);
    8000348e:	854a                	mv	a0,s2
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	086080e7          	jalr	134(ra) # 80002516 <brelse>
    brelse(dbuf);
    80003498:	8526                	mv	a0,s1
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	07c080e7          	jalr	124(ra) # 80002516 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a2:	2a05                	addiw	s4,s4,1
    800034a4:	0a91                	addi	s5,s5,4
    800034a6:	02c9a783          	lw	a5,44(s3)
    800034aa:	04fa5d63          	bge	s4,a5,80003504 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ae:	0189a583          	lw	a1,24(s3)
    800034b2:	014585bb          	addw	a1,a1,s4
    800034b6:	2585                	addiw	a1,a1,1
    800034b8:	0289a503          	lw	a0,40(s3)
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	f2a080e7          	jalr	-214(ra) # 800023e6 <bread>
    800034c4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c6:	000aa583          	lw	a1,0(s5)
    800034ca:	0289a503          	lw	a0,40(s3)
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	f18080e7          	jalr	-232(ra) # 800023e6 <bread>
    800034d6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d8:	865e                	mv	a2,s7
    800034da:	05890593          	addi	a1,s2,88
    800034de:	05850513          	addi	a0,a0,88
    800034e2:	ffffd097          	auipc	ra,0xffffd
    800034e6:	cfc080e7          	jalr	-772(ra) # 800001de <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ea:	8526                	mv	a0,s1
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	fec080e7          	jalr	-20(ra) # 800024d8 <bwrite>
    if(recovering == 0)
    800034f4:	f80b1de3          	bnez	s6,8000348e <install_trans+0x3c>
      bunpin(dbuf);
    800034f8:	8526                	mv	a0,s1
    800034fa:	fffff097          	auipc	ra,0xfffff
    800034fe:	0f0080e7          	jalr	240(ra) # 800025ea <bunpin>
    80003502:	b771                	j	8000348e <install_trans+0x3c>
}
    80003504:	60a6                	ld	ra,72(sp)
    80003506:	6406                	ld	s0,64(sp)
    80003508:	74e2                	ld	s1,56(sp)
    8000350a:	7942                	ld	s2,48(sp)
    8000350c:	79a2                	ld	s3,40(sp)
    8000350e:	7a02                	ld	s4,32(sp)
    80003510:	6ae2                	ld	s5,24(sp)
    80003512:	6b42                	ld	s6,16(sp)
    80003514:	6ba2                	ld	s7,8(sp)
    80003516:	6161                	addi	sp,sp,80
    80003518:	8082                	ret
    8000351a:	8082                	ret

000000008000351c <initlog>:
{
    8000351c:	7179                	addi	sp,sp,-48
    8000351e:	f406                	sd	ra,40(sp)
    80003520:	f022                	sd	s0,32(sp)
    80003522:	ec26                	sd	s1,24(sp)
    80003524:	e84a                	sd	s2,16(sp)
    80003526:	e44e                	sd	s3,8(sp)
    80003528:	1800                	addi	s0,sp,48
    8000352a:	892a                	mv	s2,a0
    8000352c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000352e:	00016497          	auipc	s1,0x16
    80003532:	2f248493          	addi	s1,s1,754 # 80019820 <log>
    80003536:	00005597          	auipc	a1,0x5
    8000353a:	f7258593          	addi	a1,a1,-142 # 800084a8 <etext+0x4a8>
    8000353e:	8526                	mv	a0,s1
    80003540:	00003097          	auipc	ra,0x3
    80003544:	d8e080e7          	jalr	-626(ra) # 800062ce <initlock>
  log.start = sb->logstart;
    80003548:	0149a583          	lw	a1,20(s3)
    8000354c:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000354e:	0109a783          	lw	a5,16(s3)
    80003552:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003554:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003558:	854a                	mv	a0,s2
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	e8c080e7          	jalr	-372(ra) # 800023e6 <bread>
  log.lh.n = lh->n;
    80003562:	4d30                	lw	a2,88(a0)
    80003564:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003566:	00c05f63          	blez	a2,80003584 <initlog+0x68>
    8000356a:	87aa                	mv	a5,a0
    8000356c:	00016717          	auipc	a4,0x16
    80003570:	2e470713          	addi	a4,a4,740 # 80019850 <log+0x30>
    80003574:	060a                	slli	a2,a2,0x2
    80003576:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003578:	4ff4                	lw	a3,92(a5)
    8000357a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000357c:	0791                	addi	a5,a5,4
    8000357e:	0711                	addi	a4,a4,4
    80003580:	fec79ce3          	bne	a5,a2,80003578 <initlog+0x5c>
  brelse(buf);
    80003584:	fffff097          	auipc	ra,0xfffff
    80003588:	f92080e7          	jalr	-110(ra) # 80002516 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000358c:	4505                	li	a0,1
    8000358e:	00000097          	auipc	ra,0x0
    80003592:	ec4080e7          	jalr	-316(ra) # 80003452 <install_trans>
  log.lh.n = 0;
    80003596:	00016797          	auipc	a5,0x16
    8000359a:	2a07ab23          	sw	zero,694(a5) # 8001984c <log+0x2c>
  write_head(); // clear the log
    8000359e:	00000097          	auipc	ra,0x0
    800035a2:	e4a080e7          	jalr	-438(ra) # 800033e8 <write_head>
}
    800035a6:	70a2                	ld	ra,40(sp)
    800035a8:	7402                	ld	s0,32(sp)
    800035aa:	64e2                	ld	s1,24(sp)
    800035ac:	6942                	ld	s2,16(sp)
    800035ae:	69a2                	ld	s3,8(sp)
    800035b0:	6145                	addi	sp,sp,48
    800035b2:	8082                	ret

00000000800035b4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035b4:	1101                	addi	sp,sp,-32
    800035b6:	ec06                	sd	ra,24(sp)
    800035b8:	e822                	sd	s0,16(sp)
    800035ba:	e426                	sd	s1,8(sp)
    800035bc:	e04a                	sd	s2,0(sp)
    800035be:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035c0:	00016517          	auipc	a0,0x16
    800035c4:	26050513          	addi	a0,a0,608 # 80019820 <log>
    800035c8:	00003097          	auipc	ra,0x3
    800035cc:	d9a080e7          	jalr	-614(ra) # 80006362 <acquire>
  while(1){
    if(log.committing){
    800035d0:	00016497          	auipc	s1,0x16
    800035d4:	25048493          	addi	s1,s1,592 # 80019820 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d8:	4979                	li	s2,30
    800035da:	a039                	j	800035e8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035dc:	85a6                	mv	a1,s1
    800035de:	8526                	mv	a0,s1
    800035e0:	ffffe097          	auipc	ra,0xffffe
    800035e4:	f94080e7          	jalr	-108(ra) # 80001574 <sleep>
    if(log.committing){
    800035e8:	50dc                	lw	a5,36(s1)
    800035ea:	fbed                	bnez	a5,800035dc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ec:	5098                	lw	a4,32(s1)
    800035ee:	2705                	addiw	a4,a4,1
    800035f0:	0027179b          	slliw	a5,a4,0x2
    800035f4:	9fb9                	addw	a5,a5,a4
    800035f6:	0017979b          	slliw	a5,a5,0x1
    800035fa:	54d4                	lw	a3,44(s1)
    800035fc:	9fb5                	addw	a5,a5,a3
    800035fe:	00f95963          	bge	s2,a5,80003610 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003602:	85a6                	mv	a1,s1
    80003604:	8526                	mv	a0,s1
    80003606:	ffffe097          	auipc	ra,0xffffe
    8000360a:	f6e080e7          	jalr	-146(ra) # 80001574 <sleep>
    8000360e:	bfe9                	j	800035e8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003610:	00016517          	auipc	a0,0x16
    80003614:	21050513          	addi	a0,a0,528 # 80019820 <log>
    80003618:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000361a:	00003097          	auipc	ra,0x3
    8000361e:	df8080e7          	jalr	-520(ra) # 80006412 <release>
      break;
    }
  }
}
    80003622:	60e2                	ld	ra,24(sp)
    80003624:	6442                	ld	s0,16(sp)
    80003626:	64a2                	ld	s1,8(sp)
    80003628:	6902                	ld	s2,0(sp)
    8000362a:	6105                	addi	sp,sp,32
    8000362c:	8082                	ret

000000008000362e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000362e:	7139                	addi	sp,sp,-64
    80003630:	fc06                	sd	ra,56(sp)
    80003632:	f822                	sd	s0,48(sp)
    80003634:	f426                	sd	s1,40(sp)
    80003636:	f04a                	sd	s2,32(sp)
    80003638:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000363a:	00016497          	auipc	s1,0x16
    8000363e:	1e648493          	addi	s1,s1,486 # 80019820 <log>
    80003642:	8526                	mv	a0,s1
    80003644:	00003097          	auipc	ra,0x3
    80003648:	d1e080e7          	jalr	-738(ra) # 80006362 <acquire>
  log.outstanding -= 1;
    8000364c:	509c                	lw	a5,32(s1)
    8000364e:	37fd                	addiw	a5,a5,-1
    80003650:	893e                	mv	s2,a5
    80003652:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003654:	50dc                	lw	a5,36(s1)
    80003656:	e7b9                	bnez	a5,800036a4 <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    80003658:	06091263          	bnez	s2,800036bc <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000365c:	00016497          	auipc	s1,0x16
    80003660:	1c448493          	addi	s1,s1,452 # 80019820 <log>
    80003664:	4785                	li	a5,1
    80003666:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	da8080e7          	jalr	-600(ra) # 80006412 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003672:	54dc                	lw	a5,44(s1)
    80003674:	06f04863          	bgtz	a5,800036e4 <end_op+0xb6>
    acquire(&log.lock);
    80003678:	00016497          	auipc	s1,0x16
    8000367c:	1a848493          	addi	s1,s1,424 # 80019820 <log>
    80003680:	8526                	mv	a0,s1
    80003682:	00003097          	auipc	ra,0x3
    80003686:	ce0080e7          	jalr	-800(ra) # 80006362 <acquire>
    log.committing = 0;
    8000368a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000368e:	8526                	mv	a0,s1
    80003690:	ffffe097          	auipc	ra,0xffffe
    80003694:	06a080e7          	jalr	106(ra) # 800016fa <wakeup>
    release(&log.lock);
    80003698:	8526                	mv	a0,s1
    8000369a:	00003097          	auipc	ra,0x3
    8000369e:	d78080e7          	jalr	-648(ra) # 80006412 <release>
}
    800036a2:	a81d                	j	800036d8 <end_op+0xaa>
    800036a4:	ec4e                	sd	s3,24(sp)
    800036a6:	e852                	sd	s4,16(sp)
    800036a8:	e456                	sd	s5,8(sp)
    800036aa:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800036ac:	00005517          	auipc	a0,0x5
    800036b0:	e0450513          	addi	a0,a0,-508 # 800084b0 <etext+0x4b0>
    800036b4:	00002097          	auipc	ra,0x2
    800036b8:	758080e7          	jalr	1880(ra) # 80005e0c <panic>
    wakeup(&log);
    800036bc:	00016497          	auipc	s1,0x16
    800036c0:	16448493          	addi	s1,s1,356 # 80019820 <log>
    800036c4:	8526                	mv	a0,s1
    800036c6:	ffffe097          	auipc	ra,0xffffe
    800036ca:	034080e7          	jalr	52(ra) # 800016fa <wakeup>
  release(&log.lock);
    800036ce:	8526                	mv	a0,s1
    800036d0:	00003097          	auipc	ra,0x3
    800036d4:	d42080e7          	jalr	-702(ra) # 80006412 <release>
}
    800036d8:	70e2                	ld	ra,56(sp)
    800036da:	7442                	ld	s0,48(sp)
    800036dc:	74a2                	ld	s1,40(sp)
    800036de:	7902                	ld	s2,32(sp)
    800036e0:	6121                	addi	sp,sp,64
    800036e2:	8082                	ret
    800036e4:	ec4e                	sd	s3,24(sp)
    800036e6:	e852                	sd	s4,16(sp)
    800036e8:	e456                	sd	s5,8(sp)
    800036ea:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ec:	00016a97          	auipc	s5,0x16
    800036f0:	164a8a93          	addi	s5,s5,356 # 80019850 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036f4:	00016a17          	auipc	s4,0x16
    800036f8:	12ca0a13          	addi	s4,s4,300 # 80019820 <log>
    memmove(to->data, from->data, BSIZE);
    800036fc:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003700:	018a2583          	lw	a1,24(s4)
    80003704:	012585bb          	addw	a1,a1,s2
    80003708:	2585                	addiw	a1,a1,1
    8000370a:	028a2503          	lw	a0,40(s4)
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	cd8080e7          	jalr	-808(ra) # 800023e6 <bread>
    80003716:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003718:	000aa583          	lw	a1,0(s5)
    8000371c:	028a2503          	lw	a0,40(s4)
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	cc6080e7          	jalr	-826(ra) # 800023e6 <bread>
    80003728:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000372a:	865a                	mv	a2,s6
    8000372c:	05850593          	addi	a1,a0,88
    80003730:	05848513          	addi	a0,s1,88
    80003734:	ffffd097          	auipc	ra,0xffffd
    80003738:	aaa080e7          	jalr	-1366(ra) # 800001de <memmove>
    bwrite(to);  // write the log
    8000373c:	8526                	mv	a0,s1
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	d9a080e7          	jalr	-614(ra) # 800024d8 <bwrite>
    brelse(from);
    80003746:	854e                	mv	a0,s3
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	dce080e7          	jalr	-562(ra) # 80002516 <brelse>
    brelse(to);
    80003750:	8526                	mv	a0,s1
    80003752:	fffff097          	auipc	ra,0xfffff
    80003756:	dc4080e7          	jalr	-572(ra) # 80002516 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375a:	2905                	addiw	s2,s2,1
    8000375c:	0a91                	addi	s5,s5,4
    8000375e:	02ca2783          	lw	a5,44(s4)
    80003762:	f8f94fe3          	blt	s2,a5,80003700 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	c82080e7          	jalr	-894(ra) # 800033e8 <write_head>
    install_trans(0); // Now install writes to home locations
    8000376e:	4501                	li	a0,0
    80003770:	00000097          	auipc	ra,0x0
    80003774:	ce2080e7          	jalr	-798(ra) # 80003452 <install_trans>
    log.lh.n = 0;
    80003778:	00016797          	auipc	a5,0x16
    8000377c:	0c07aa23          	sw	zero,212(a5) # 8001984c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003780:	00000097          	auipc	ra,0x0
    80003784:	c68080e7          	jalr	-920(ra) # 800033e8 <write_head>
    80003788:	69e2                	ld	s3,24(sp)
    8000378a:	6a42                	ld	s4,16(sp)
    8000378c:	6aa2                	ld	s5,8(sp)
    8000378e:	6b02                	ld	s6,0(sp)
    80003790:	b5e5                	j	80003678 <end_op+0x4a>

0000000080003792 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003792:	1101                	addi	sp,sp,-32
    80003794:	ec06                	sd	ra,24(sp)
    80003796:	e822                	sd	s0,16(sp)
    80003798:	e426                	sd	s1,8(sp)
    8000379a:	e04a                	sd	s2,0(sp)
    8000379c:	1000                	addi	s0,sp,32
    8000379e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037a0:	00016917          	auipc	s2,0x16
    800037a4:	08090913          	addi	s2,s2,128 # 80019820 <log>
    800037a8:	854a                	mv	a0,s2
    800037aa:	00003097          	auipc	ra,0x3
    800037ae:	bb8080e7          	jalr	-1096(ra) # 80006362 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037b2:	02c92603          	lw	a2,44(s2)
    800037b6:	47f5                	li	a5,29
    800037b8:	06c7c563          	blt	a5,a2,80003822 <log_write+0x90>
    800037bc:	00016797          	auipc	a5,0x16
    800037c0:	0807a783          	lw	a5,128(a5) # 8001983c <log+0x1c>
    800037c4:	37fd                	addiw	a5,a5,-1
    800037c6:	04f65e63          	bge	a2,a5,80003822 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037ca:	00016797          	auipc	a5,0x16
    800037ce:	0767a783          	lw	a5,118(a5) # 80019840 <log+0x20>
    800037d2:	06f05063          	blez	a5,80003832 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037d6:	4781                	li	a5,0
    800037d8:	06c05563          	blez	a2,80003842 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037dc:	44cc                	lw	a1,12(s1)
    800037de:	00016717          	auipc	a4,0x16
    800037e2:	07270713          	addi	a4,a4,114 # 80019850 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037e6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e8:	4314                	lw	a3,0(a4)
    800037ea:	04b68c63          	beq	a3,a1,80003842 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037ee:	2785                	addiw	a5,a5,1
    800037f0:	0711                	addi	a4,a4,4
    800037f2:	fef61be3          	bne	a2,a5,800037e8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037f6:	0621                	addi	a2,a2,8
    800037f8:	060a                	slli	a2,a2,0x2
    800037fa:	00016797          	auipc	a5,0x16
    800037fe:	02678793          	addi	a5,a5,38 # 80019820 <log>
    80003802:	97b2                	add	a5,a5,a2
    80003804:	44d8                	lw	a4,12(s1)
    80003806:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003808:	8526                	mv	a0,s1
    8000380a:	fffff097          	auipc	ra,0xfffff
    8000380e:	da4080e7          	jalr	-604(ra) # 800025ae <bpin>
    log.lh.n++;
    80003812:	00016717          	auipc	a4,0x16
    80003816:	00e70713          	addi	a4,a4,14 # 80019820 <log>
    8000381a:	575c                	lw	a5,44(a4)
    8000381c:	2785                	addiw	a5,a5,1
    8000381e:	d75c                	sw	a5,44(a4)
    80003820:	a82d                	j	8000385a <log_write+0xc8>
    panic("too big a transaction");
    80003822:	00005517          	auipc	a0,0x5
    80003826:	c9e50513          	addi	a0,a0,-866 # 800084c0 <etext+0x4c0>
    8000382a:	00002097          	auipc	ra,0x2
    8000382e:	5e2080e7          	jalr	1506(ra) # 80005e0c <panic>
    panic("log_write outside of trans");
    80003832:	00005517          	auipc	a0,0x5
    80003836:	ca650513          	addi	a0,a0,-858 # 800084d8 <etext+0x4d8>
    8000383a:	00002097          	auipc	ra,0x2
    8000383e:	5d2080e7          	jalr	1490(ra) # 80005e0c <panic>
  log.lh.block[i] = b->blockno;
    80003842:	00878693          	addi	a3,a5,8
    80003846:	068a                	slli	a3,a3,0x2
    80003848:	00016717          	auipc	a4,0x16
    8000384c:	fd870713          	addi	a4,a4,-40 # 80019820 <log>
    80003850:	9736                	add	a4,a4,a3
    80003852:	44d4                	lw	a3,12(s1)
    80003854:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003856:	faf609e3          	beq	a2,a5,80003808 <log_write+0x76>
  }
  release(&log.lock);
    8000385a:	00016517          	auipc	a0,0x16
    8000385e:	fc650513          	addi	a0,a0,-58 # 80019820 <log>
    80003862:	00003097          	auipc	ra,0x3
    80003866:	bb0080e7          	jalr	-1104(ra) # 80006412 <release>
}
    8000386a:	60e2                	ld	ra,24(sp)
    8000386c:	6442                	ld	s0,16(sp)
    8000386e:	64a2                	ld	s1,8(sp)
    80003870:	6902                	ld	s2,0(sp)
    80003872:	6105                	addi	sp,sp,32
    80003874:	8082                	ret

0000000080003876 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003876:	1101                	addi	sp,sp,-32
    80003878:	ec06                	sd	ra,24(sp)
    8000387a:	e822                	sd	s0,16(sp)
    8000387c:	e426                	sd	s1,8(sp)
    8000387e:	e04a                	sd	s2,0(sp)
    80003880:	1000                	addi	s0,sp,32
    80003882:	84aa                	mv	s1,a0
    80003884:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003886:	00005597          	auipc	a1,0x5
    8000388a:	c7258593          	addi	a1,a1,-910 # 800084f8 <etext+0x4f8>
    8000388e:	0521                	addi	a0,a0,8
    80003890:	00003097          	auipc	ra,0x3
    80003894:	a3e080e7          	jalr	-1474(ra) # 800062ce <initlock>
  lk->name = name;
    80003898:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000389c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038a0:	0204a423          	sw	zero,40(s1)
}
    800038a4:	60e2                	ld	ra,24(sp)
    800038a6:	6442                	ld	s0,16(sp)
    800038a8:	64a2                	ld	s1,8(sp)
    800038aa:	6902                	ld	s2,0(sp)
    800038ac:	6105                	addi	sp,sp,32
    800038ae:	8082                	ret

00000000800038b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038b0:	1101                	addi	sp,sp,-32
    800038b2:	ec06                	sd	ra,24(sp)
    800038b4:	e822                	sd	s0,16(sp)
    800038b6:	e426                	sd	s1,8(sp)
    800038b8:	e04a                	sd	s2,0(sp)
    800038ba:	1000                	addi	s0,sp,32
    800038bc:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038be:	00850913          	addi	s2,a0,8
    800038c2:	854a                	mv	a0,s2
    800038c4:	00003097          	auipc	ra,0x3
    800038c8:	a9e080e7          	jalr	-1378(ra) # 80006362 <acquire>
  while (lk->locked) {
    800038cc:	409c                	lw	a5,0(s1)
    800038ce:	cb89                	beqz	a5,800038e0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038d0:	85ca                	mv	a1,s2
    800038d2:	8526                	mv	a0,s1
    800038d4:	ffffe097          	auipc	ra,0xffffe
    800038d8:	ca0080e7          	jalr	-864(ra) # 80001574 <sleep>
  while (lk->locked) {
    800038dc:	409c                	lw	a5,0(s1)
    800038de:	fbed                	bnez	a5,800038d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038e0:	4785                	li	a5,1
    800038e2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038e4:	ffffd097          	auipc	ra,0xffffd
    800038e8:	5be080e7          	jalr	1470(ra) # 80000ea2 <myproc>
    800038ec:	591c                	lw	a5,48(a0)
    800038ee:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038f0:	854a                	mv	a0,s2
    800038f2:	00003097          	auipc	ra,0x3
    800038f6:	b20080e7          	jalr	-1248(ra) # 80006412 <release>
}
    800038fa:	60e2                	ld	ra,24(sp)
    800038fc:	6442                	ld	s0,16(sp)
    800038fe:	64a2                	ld	s1,8(sp)
    80003900:	6902                	ld	s2,0(sp)
    80003902:	6105                	addi	sp,sp,32
    80003904:	8082                	ret

0000000080003906 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003906:	1101                	addi	sp,sp,-32
    80003908:	ec06                	sd	ra,24(sp)
    8000390a:	e822                	sd	s0,16(sp)
    8000390c:	e426                	sd	s1,8(sp)
    8000390e:	e04a                	sd	s2,0(sp)
    80003910:	1000                	addi	s0,sp,32
    80003912:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003914:	00850913          	addi	s2,a0,8
    80003918:	854a                	mv	a0,s2
    8000391a:	00003097          	auipc	ra,0x3
    8000391e:	a48080e7          	jalr	-1464(ra) # 80006362 <acquire>
  lk->locked = 0;
    80003922:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003926:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000392a:	8526                	mv	a0,s1
    8000392c:	ffffe097          	auipc	ra,0xffffe
    80003930:	dce080e7          	jalr	-562(ra) # 800016fa <wakeup>
  release(&lk->lk);
    80003934:	854a                	mv	a0,s2
    80003936:	00003097          	auipc	ra,0x3
    8000393a:	adc080e7          	jalr	-1316(ra) # 80006412 <release>
}
    8000393e:	60e2                	ld	ra,24(sp)
    80003940:	6442                	ld	s0,16(sp)
    80003942:	64a2                	ld	s1,8(sp)
    80003944:	6902                	ld	s2,0(sp)
    80003946:	6105                	addi	sp,sp,32
    80003948:	8082                	ret

000000008000394a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000394a:	7179                	addi	sp,sp,-48
    8000394c:	f406                	sd	ra,40(sp)
    8000394e:	f022                	sd	s0,32(sp)
    80003950:	ec26                	sd	s1,24(sp)
    80003952:	e84a                	sd	s2,16(sp)
    80003954:	1800                	addi	s0,sp,48
    80003956:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003958:	00850913          	addi	s2,a0,8
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	a04080e7          	jalr	-1532(ra) # 80006362 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003966:	409c                	lw	a5,0(s1)
    80003968:	ef91                	bnez	a5,80003984 <holdingsleep+0x3a>
    8000396a:	4481                	li	s1,0
  release(&lk->lk);
    8000396c:	854a                	mv	a0,s2
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	aa4080e7          	jalr	-1372(ra) # 80006412 <release>
  return r;
}
    80003976:	8526                	mv	a0,s1
    80003978:	70a2                	ld	ra,40(sp)
    8000397a:	7402                	ld	s0,32(sp)
    8000397c:	64e2                	ld	s1,24(sp)
    8000397e:	6942                	ld	s2,16(sp)
    80003980:	6145                	addi	sp,sp,48
    80003982:	8082                	ret
    80003984:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003986:	0284a983          	lw	s3,40(s1)
    8000398a:	ffffd097          	auipc	ra,0xffffd
    8000398e:	518080e7          	jalr	1304(ra) # 80000ea2 <myproc>
    80003992:	5904                	lw	s1,48(a0)
    80003994:	413484b3          	sub	s1,s1,s3
    80003998:	0014b493          	seqz	s1,s1
    8000399c:	69a2                	ld	s3,8(sp)
    8000399e:	b7f9                	j	8000396c <holdingsleep+0x22>

00000000800039a0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039a0:	1141                	addi	sp,sp,-16
    800039a2:	e406                	sd	ra,8(sp)
    800039a4:	e022                	sd	s0,0(sp)
    800039a6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039a8:	00005597          	auipc	a1,0x5
    800039ac:	b6058593          	addi	a1,a1,-1184 # 80008508 <etext+0x508>
    800039b0:	00016517          	auipc	a0,0x16
    800039b4:	fb850513          	addi	a0,a0,-72 # 80019968 <ftable>
    800039b8:	00003097          	auipc	ra,0x3
    800039bc:	916080e7          	jalr	-1770(ra) # 800062ce <initlock>
}
    800039c0:	60a2                	ld	ra,8(sp)
    800039c2:	6402                	ld	s0,0(sp)
    800039c4:	0141                	addi	sp,sp,16
    800039c6:	8082                	ret

00000000800039c8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039c8:	1101                	addi	sp,sp,-32
    800039ca:	ec06                	sd	ra,24(sp)
    800039cc:	e822                	sd	s0,16(sp)
    800039ce:	e426                	sd	s1,8(sp)
    800039d0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039d2:	00016517          	auipc	a0,0x16
    800039d6:	f9650513          	addi	a0,a0,-106 # 80019968 <ftable>
    800039da:	00003097          	auipc	ra,0x3
    800039de:	988080e7          	jalr	-1656(ra) # 80006362 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e2:	00016497          	auipc	s1,0x16
    800039e6:	f9e48493          	addi	s1,s1,-98 # 80019980 <ftable+0x18>
    800039ea:	00017717          	auipc	a4,0x17
    800039ee:	f3670713          	addi	a4,a4,-202 # 8001a920 <ftable+0xfb8>
    if(f->ref == 0){
    800039f2:	40dc                	lw	a5,4(s1)
    800039f4:	cf99                	beqz	a5,80003a12 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f6:	02848493          	addi	s1,s1,40
    800039fa:	fee49ce3          	bne	s1,a4,800039f2 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039fe:	00016517          	auipc	a0,0x16
    80003a02:	f6a50513          	addi	a0,a0,-150 # 80019968 <ftable>
    80003a06:	00003097          	auipc	ra,0x3
    80003a0a:	a0c080e7          	jalr	-1524(ra) # 80006412 <release>
  return 0;
    80003a0e:	4481                	li	s1,0
    80003a10:	a819                	j	80003a26 <filealloc+0x5e>
      f->ref = 1;
    80003a12:	4785                	li	a5,1
    80003a14:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a16:	00016517          	auipc	a0,0x16
    80003a1a:	f5250513          	addi	a0,a0,-174 # 80019968 <ftable>
    80003a1e:	00003097          	auipc	ra,0x3
    80003a22:	9f4080e7          	jalr	-1548(ra) # 80006412 <release>
}
    80003a26:	8526                	mv	a0,s1
    80003a28:	60e2                	ld	ra,24(sp)
    80003a2a:	6442                	ld	s0,16(sp)
    80003a2c:	64a2                	ld	s1,8(sp)
    80003a2e:	6105                	addi	sp,sp,32
    80003a30:	8082                	ret

0000000080003a32 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a32:	1101                	addi	sp,sp,-32
    80003a34:	ec06                	sd	ra,24(sp)
    80003a36:	e822                	sd	s0,16(sp)
    80003a38:	e426                	sd	s1,8(sp)
    80003a3a:	1000                	addi	s0,sp,32
    80003a3c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a3e:	00016517          	auipc	a0,0x16
    80003a42:	f2a50513          	addi	a0,a0,-214 # 80019968 <ftable>
    80003a46:	00003097          	auipc	ra,0x3
    80003a4a:	91c080e7          	jalr	-1764(ra) # 80006362 <acquire>
  if(f->ref < 1)
    80003a4e:	40dc                	lw	a5,4(s1)
    80003a50:	02f05263          	blez	a5,80003a74 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a54:	2785                	addiw	a5,a5,1
    80003a56:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a58:	00016517          	auipc	a0,0x16
    80003a5c:	f1050513          	addi	a0,a0,-240 # 80019968 <ftable>
    80003a60:	00003097          	auipc	ra,0x3
    80003a64:	9b2080e7          	jalr	-1614(ra) # 80006412 <release>
  return f;
}
    80003a68:	8526                	mv	a0,s1
    80003a6a:	60e2                	ld	ra,24(sp)
    80003a6c:	6442                	ld	s0,16(sp)
    80003a6e:	64a2                	ld	s1,8(sp)
    80003a70:	6105                	addi	sp,sp,32
    80003a72:	8082                	ret
    panic("filedup");
    80003a74:	00005517          	auipc	a0,0x5
    80003a78:	a9c50513          	addi	a0,a0,-1380 # 80008510 <etext+0x510>
    80003a7c:	00002097          	auipc	ra,0x2
    80003a80:	390080e7          	jalr	912(ra) # 80005e0c <panic>

0000000080003a84 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a84:	7139                	addi	sp,sp,-64
    80003a86:	fc06                	sd	ra,56(sp)
    80003a88:	f822                	sd	s0,48(sp)
    80003a8a:	f426                	sd	s1,40(sp)
    80003a8c:	0080                	addi	s0,sp,64
    80003a8e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a90:	00016517          	auipc	a0,0x16
    80003a94:	ed850513          	addi	a0,a0,-296 # 80019968 <ftable>
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	8ca080e7          	jalr	-1846(ra) # 80006362 <acquire>
  if(f->ref < 1)
    80003aa0:	40dc                	lw	a5,4(s1)
    80003aa2:	04f05a63          	blez	a5,80003af6 <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80003aa6:	37fd                	addiw	a5,a5,-1
    80003aa8:	c0dc                	sw	a5,4(s1)
    80003aaa:	06f04263          	bgtz	a5,80003b0e <fileclose+0x8a>
    80003aae:	f04a                	sd	s2,32(sp)
    80003ab0:	ec4e                	sd	s3,24(sp)
    80003ab2:	e852                	sd	s4,16(sp)
    80003ab4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ab6:	0004a903          	lw	s2,0(s1)
    80003aba:	0094ca83          	lbu	s5,9(s1)
    80003abe:	0104ba03          	ld	s4,16(s1)
    80003ac2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ac6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003aca:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ace:	00016517          	auipc	a0,0x16
    80003ad2:	e9a50513          	addi	a0,a0,-358 # 80019968 <ftable>
    80003ad6:	00003097          	auipc	ra,0x3
    80003ada:	93c080e7          	jalr	-1732(ra) # 80006412 <release>

  if(ff.type == FD_PIPE){
    80003ade:	4785                	li	a5,1
    80003ae0:	04f90463          	beq	s2,a5,80003b28 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ae4:	3979                	addiw	s2,s2,-2
    80003ae6:	4785                	li	a5,1
    80003ae8:	0527fb63          	bgeu	a5,s2,80003b3e <fileclose+0xba>
    80003aec:	7902                	ld	s2,32(sp)
    80003aee:	69e2                	ld	s3,24(sp)
    80003af0:	6a42                	ld	s4,16(sp)
    80003af2:	6aa2                	ld	s5,8(sp)
    80003af4:	a02d                	j	80003b1e <fileclose+0x9a>
    80003af6:	f04a                	sd	s2,32(sp)
    80003af8:	ec4e                	sd	s3,24(sp)
    80003afa:	e852                	sd	s4,16(sp)
    80003afc:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003afe:	00005517          	auipc	a0,0x5
    80003b02:	a1a50513          	addi	a0,a0,-1510 # 80008518 <etext+0x518>
    80003b06:	00002097          	auipc	ra,0x2
    80003b0a:	306080e7          	jalr	774(ra) # 80005e0c <panic>
    release(&ftable.lock);
    80003b0e:	00016517          	auipc	a0,0x16
    80003b12:	e5a50513          	addi	a0,a0,-422 # 80019968 <ftable>
    80003b16:	00003097          	auipc	ra,0x3
    80003b1a:	8fc080e7          	jalr	-1796(ra) # 80006412 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b1e:	70e2                	ld	ra,56(sp)
    80003b20:	7442                	ld	s0,48(sp)
    80003b22:	74a2                	ld	s1,40(sp)
    80003b24:	6121                	addi	sp,sp,64
    80003b26:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b28:	85d6                	mv	a1,s5
    80003b2a:	8552                	mv	a0,s4
    80003b2c:	00000097          	auipc	ra,0x0
    80003b30:	3ac080e7          	jalr	940(ra) # 80003ed8 <pipeclose>
    80003b34:	7902                	ld	s2,32(sp)
    80003b36:	69e2                	ld	s3,24(sp)
    80003b38:	6a42                	ld	s4,16(sp)
    80003b3a:	6aa2                	ld	s5,8(sp)
    80003b3c:	b7cd                	j	80003b1e <fileclose+0x9a>
    begin_op();
    80003b3e:	00000097          	auipc	ra,0x0
    80003b42:	a76080e7          	jalr	-1418(ra) # 800035b4 <begin_op>
    iput(ff.ip);
    80003b46:	854e                	mv	a0,s3
    80003b48:	fffff097          	auipc	ra,0xfffff
    80003b4c:	238080e7          	jalr	568(ra) # 80002d80 <iput>
    end_op();
    80003b50:	00000097          	auipc	ra,0x0
    80003b54:	ade080e7          	jalr	-1314(ra) # 8000362e <end_op>
    80003b58:	7902                	ld	s2,32(sp)
    80003b5a:	69e2                	ld	s3,24(sp)
    80003b5c:	6a42                	ld	s4,16(sp)
    80003b5e:	6aa2                	ld	s5,8(sp)
    80003b60:	bf7d                	j	80003b1e <fileclose+0x9a>

0000000080003b62 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b62:	715d                	addi	sp,sp,-80
    80003b64:	e486                	sd	ra,72(sp)
    80003b66:	e0a2                	sd	s0,64(sp)
    80003b68:	fc26                	sd	s1,56(sp)
    80003b6a:	f44e                	sd	s3,40(sp)
    80003b6c:	0880                	addi	s0,sp,80
    80003b6e:	84aa                	mv	s1,a0
    80003b70:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b72:	ffffd097          	auipc	ra,0xffffd
    80003b76:	330080e7          	jalr	816(ra) # 80000ea2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b7a:	409c                	lw	a5,0(s1)
    80003b7c:	37f9                	addiw	a5,a5,-2
    80003b7e:	4705                	li	a4,1
    80003b80:	04f76a63          	bltu	a4,a5,80003bd4 <filestat+0x72>
    80003b84:	f84a                	sd	s2,48(sp)
    80003b86:	f052                	sd	s4,32(sp)
    80003b88:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b8a:	6c88                	ld	a0,24(s1)
    80003b8c:	fffff097          	auipc	ra,0xfffff
    80003b90:	036080e7          	jalr	54(ra) # 80002bc2 <ilock>
    stati(f->ip, &st);
    80003b94:	fb840a13          	addi	s4,s0,-72
    80003b98:	85d2                	mv	a1,s4
    80003b9a:	6c88                	ld	a0,24(s1)
    80003b9c:	fffff097          	auipc	ra,0xfffff
    80003ba0:	2b4080e7          	jalr	692(ra) # 80002e50 <stati>
    iunlock(f->ip);
    80003ba4:	6c88                	ld	a0,24(s1)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	0e2080e7          	jalr	226(ra) # 80002c88 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bae:	46e1                	li	a3,24
    80003bb0:	8652                	mv	a2,s4
    80003bb2:	85ce                	mv	a1,s3
    80003bb4:	05093503          	ld	a0,80(s2)
    80003bb8:	ffffd097          	auipc	ra,0xffffd
    80003bbc:	f96080e7          	jalr	-106(ra) # 80000b4e <copyout>
    80003bc0:	41f5551b          	sraiw	a0,a0,0x1f
    80003bc4:	7942                	ld	s2,48(sp)
    80003bc6:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003bc8:	60a6                	ld	ra,72(sp)
    80003bca:	6406                	ld	s0,64(sp)
    80003bcc:	74e2                	ld	s1,56(sp)
    80003bce:	79a2                	ld	s3,40(sp)
    80003bd0:	6161                	addi	sp,sp,80
    80003bd2:	8082                	ret
  return -1;
    80003bd4:	557d                	li	a0,-1
    80003bd6:	bfcd                	j	80003bc8 <filestat+0x66>

0000000080003bd8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bd8:	7179                	addi	sp,sp,-48
    80003bda:	f406                	sd	ra,40(sp)
    80003bdc:	f022                	sd	s0,32(sp)
    80003bde:	e84a                	sd	s2,16(sp)
    80003be0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003be2:	00854783          	lbu	a5,8(a0)
    80003be6:	cbc5                	beqz	a5,80003c96 <fileread+0xbe>
    80003be8:	ec26                	sd	s1,24(sp)
    80003bea:	e44e                	sd	s3,8(sp)
    80003bec:	84aa                	mv	s1,a0
    80003bee:	89ae                	mv	s3,a1
    80003bf0:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bf2:	411c                	lw	a5,0(a0)
    80003bf4:	4705                	li	a4,1
    80003bf6:	04e78963          	beq	a5,a4,80003c48 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bfa:	470d                	li	a4,3
    80003bfc:	04e78f63          	beq	a5,a4,80003c5a <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c00:	4709                	li	a4,2
    80003c02:	08e79263          	bne	a5,a4,80003c86 <fileread+0xae>
    ilock(f->ip);
    80003c06:	6d08                	ld	a0,24(a0)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	fba080e7          	jalr	-70(ra) # 80002bc2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c10:	874a                	mv	a4,s2
    80003c12:	5094                	lw	a3,32(s1)
    80003c14:	864e                	mv	a2,s3
    80003c16:	4585                	li	a1,1
    80003c18:	6c88                	ld	a0,24(s1)
    80003c1a:	fffff097          	auipc	ra,0xfffff
    80003c1e:	264080e7          	jalr	612(ra) # 80002e7e <readi>
    80003c22:	892a                	mv	s2,a0
    80003c24:	00a05563          	blez	a0,80003c2e <fileread+0x56>
      f->off += r;
    80003c28:	509c                	lw	a5,32(s1)
    80003c2a:	9fa9                	addw	a5,a5,a0
    80003c2c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c2e:	6c88                	ld	a0,24(s1)
    80003c30:	fffff097          	auipc	ra,0xfffff
    80003c34:	058080e7          	jalr	88(ra) # 80002c88 <iunlock>
    80003c38:	64e2                	ld	s1,24(sp)
    80003c3a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c3c:	854a                	mv	a0,s2
    80003c3e:	70a2                	ld	ra,40(sp)
    80003c40:	7402                	ld	s0,32(sp)
    80003c42:	6942                	ld	s2,16(sp)
    80003c44:	6145                	addi	sp,sp,48
    80003c46:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c48:	6908                	ld	a0,16(a0)
    80003c4a:	00000097          	auipc	ra,0x0
    80003c4e:	414080e7          	jalr	1044(ra) # 8000405e <piperead>
    80003c52:	892a                	mv	s2,a0
    80003c54:	64e2                	ld	s1,24(sp)
    80003c56:	69a2                	ld	s3,8(sp)
    80003c58:	b7d5                	j	80003c3c <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c5a:	02451783          	lh	a5,36(a0)
    80003c5e:	03079693          	slli	a3,a5,0x30
    80003c62:	92c1                	srli	a3,a3,0x30
    80003c64:	4725                	li	a4,9
    80003c66:	02d76a63          	bltu	a4,a3,80003c9a <fileread+0xc2>
    80003c6a:	0792                	slli	a5,a5,0x4
    80003c6c:	00016717          	auipc	a4,0x16
    80003c70:	c5c70713          	addi	a4,a4,-932 # 800198c8 <devsw>
    80003c74:	97ba                	add	a5,a5,a4
    80003c76:	639c                	ld	a5,0(a5)
    80003c78:	c78d                	beqz	a5,80003ca2 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003c7a:	4505                	li	a0,1
    80003c7c:	9782                	jalr	a5
    80003c7e:	892a                	mv	s2,a0
    80003c80:	64e2                	ld	s1,24(sp)
    80003c82:	69a2                	ld	s3,8(sp)
    80003c84:	bf65                	j	80003c3c <fileread+0x64>
    panic("fileread");
    80003c86:	00005517          	auipc	a0,0x5
    80003c8a:	8a250513          	addi	a0,a0,-1886 # 80008528 <etext+0x528>
    80003c8e:	00002097          	auipc	ra,0x2
    80003c92:	17e080e7          	jalr	382(ra) # 80005e0c <panic>
    return -1;
    80003c96:	597d                	li	s2,-1
    80003c98:	b755                	j	80003c3c <fileread+0x64>
      return -1;
    80003c9a:	597d                	li	s2,-1
    80003c9c:	64e2                	ld	s1,24(sp)
    80003c9e:	69a2                	ld	s3,8(sp)
    80003ca0:	bf71                	j	80003c3c <fileread+0x64>
    80003ca2:	597d                	li	s2,-1
    80003ca4:	64e2                	ld	s1,24(sp)
    80003ca6:	69a2                	ld	s3,8(sp)
    80003ca8:	bf51                	j	80003c3c <fileread+0x64>

0000000080003caa <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003caa:	00954783          	lbu	a5,9(a0)
    80003cae:	12078c63          	beqz	a5,80003de6 <filewrite+0x13c>
{
    80003cb2:	711d                	addi	sp,sp,-96
    80003cb4:	ec86                	sd	ra,88(sp)
    80003cb6:	e8a2                	sd	s0,80(sp)
    80003cb8:	e0ca                	sd	s2,64(sp)
    80003cba:	f456                	sd	s5,40(sp)
    80003cbc:	f05a                	sd	s6,32(sp)
    80003cbe:	1080                	addi	s0,sp,96
    80003cc0:	892a                	mv	s2,a0
    80003cc2:	8b2e                	mv	s6,a1
    80003cc4:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cc6:	411c                	lw	a5,0(a0)
    80003cc8:	4705                	li	a4,1
    80003cca:	02e78963          	beq	a5,a4,80003cfc <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cce:	470d                	li	a4,3
    80003cd0:	02e78c63          	beq	a5,a4,80003d08 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cd4:	4709                	li	a4,2
    80003cd6:	0ee79a63          	bne	a5,a4,80003dca <filewrite+0x120>
    80003cda:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cdc:	0cc05563          	blez	a2,80003da6 <filewrite+0xfc>
    80003ce0:	e4a6                	sd	s1,72(sp)
    80003ce2:	fc4e                	sd	s3,56(sp)
    80003ce4:	ec5e                	sd	s7,24(sp)
    80003ce6:	e862                	sd	s8,16(sp)
    80003ce8:	e466                	sd	s9,8(sp)
    int i = 0;
    80003cea:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003cec:	6b85                	lui	s7,0x1
    80003cee:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cf2:	6c85                	lui	s9,0x1
    80003cf4:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cf8:	4c05                	li	s8,1
    80003cfa:	a849                	j	80003d8c <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003cfc:	6908                	ld	a0,16(a0)
    80003cfe:	00000097          	auipc	ra,0x0
    80003d02:	24a080e7          	jalr	586(ra) # 80003f48 <pipewrite>
    80003d06:	a85d                	j	80003dbc <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d08:	02451783          	lh	a5,36(a0)
    80003d0c:	03079693          	slli	a3,a5,0x30
    80003d10:	92c1                	srli	a3,a3,0x30
    80003d12:	4725                	li	a4,9
    80003d14:	0cd76b63          	bltu	a4,a3,80003dea <filewrite+0x140>
    80003d18:	0792                	slli	a5,a5,0x4
    80003d1a:	00016717          	auipc	a4,0x16
    80003d1e:	bae70713          	addi	a4,a4,-1106 # 800198c8 <devsw>
    80003d22:	97ba                	add	a5,a5,a4
    80003d24:	679c                	ld	a5,8(a5)
    80003d26:	c7e1                	beqz	a5,80003dee <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003d28:	4505                	li	a0,1
    80003d2a:	9782                	jalr	a5
    80003d2c:	a841                	j	80003dbc <filewrite+0x112>
      if(n1 > max)
    80003d2e:	2981                	sext.w	s3,s3
      begin_op();
    80003d30:	00000097          	auipc	ra,0x0
    80003d34:	884080e7          	jalr	-1916(ra) # 800035b4 <begin_op>
      ilock(f->ip);
    80003d38:	01893503          	ld	a0,24(s2)
    80003d3c:	fffff097          	auipc	ra,0xfffff
    80003d40:	e86080e7          	jalr	-378(ra) # 80002bc2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d44:	874e                	mv	a4,s3
    80003d46:	02092683          	lw	a3,32(s2)
    80003d4a:	016a0633          	add	a2,s4,s6
    80003d4e:	85e2                	mv	a1,s8
    80003d50:	01893503          	ld	a0,24(s2)
    80003d54:	fffff097          	auipc	ra,0xfffff
    80003d58:	224080e7          	jalr	548(ra) # 80002f78 <writei>
    80003d5c:	84aa                	mv	s1,a0
    80003d5e:	00a05763          	blez	a0,80003d6c <filewrite+0xc2>
        f->off += r;
    80003d62:	02092783          	lw	a5,32(s2)
    80003d66:	9fa9                	addw	a5,a5,a0
    80003d68:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d6c:	01893503          	ld	a0,24(s2)
    80003d70:	fffff097          	auipc	ra,0xfffff
    80003d74:	f18080e7          	jalr	-232(ra) # 80002c88 <iunlock>
      end_op();
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	8b6080e7          	jalr	-1866(ra) # 8000362e <end_op>

      if(r != n1){
    80003d80:	02999563          	bne	s3,s1,80003daa <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003d84:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003d88:	015a5963          	bge	s4,s5,80003d9a <filewrite+0xf0>
      int n1 = n - i;
    80003d8c:	414a87bb          	subw	a5,s5,s4
    80003d90:	89be                	mv	s3,a5
      if(n1 > max)
    80003d92:	f8fbdee3          	bge	s7,a5,80003d2e <filewrite+0x84>
    80003d96:	89e6                	mv	s3,s9
    80003d98:	bf59                	j	80003d2e <filewrite+0x84>
    80003d9a:	64a6                	ld	s1,72(sp)
    80003d9c:	79e2                	ld	s3,56(sp)
    80003d9e:	6be2                	ld	s7,24(sp)
    80003da0:	6c42                	ld	s8,16(sp)
    80003da2:	6ca2                	ld	s9,8(sp)
    80003da4:	a801                	j	80003db4 <filewrite+0x10a>
    int i = 0;
    80003da6:	4a01                	li	s4,0
    80003da8:	a031                	j	80003db4 <filewrite+0x10a>
    80003daa:	64a6                	ld	s1,72(sp)
    80003dac:	79e2                	ld	s3,56(sp)
    80003dae:	6be2                	ld	s7,24(sp)
    80003db0:	6c42                	ld	s8,16(sp)
    80003db2:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003db4:	034a9f63          	bne	s5,s4,80003df2 <filewrite+0x148>
    80003db8:	8556                	mv	a0,s5
    80003dba:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dbc:	60e6                	ld	ra,88(sp)
    80003dbe:	6446                	ld	s0,80(sp)
    80003dc0:	6906                	ld	s2,64(sp)
    80003dc2:	7aa2                	ld	s5,40(sp)
    80003dc4:	7b02                	ld	s6,32(sp)
    80003dc6:	6125                	addi	sp,sp,96
    80003dc8:	8082                	ret
    80003dca:	e4a6                	sd	s1,72(sp)
    80003dcc:	fc4e                	sd	s3,56(sp)
    80003dce:	f852                	sd	s4,48(sp)
    80003dd0:	ec5e                	sd	s7,24(sp)
    80003dd2:	e862                	sd	s8,16(sp)
    80003dd4:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003dd6:	00004517          	auipc	a0,0x4
    80003dda:	76250513          	addi	a0,a0,1890 # 80008538 <etext+0x538>
    80003dde:	00002097          	auipc	ra,0x2
    80003de2:	02e080e7          	jalr	46(ra) # 80005e0c <panic>
    return -1;
    80003de6:	557d                	li	a0,-1
}
    80003de8:	8082                	ret
      return -1;
    80003dea:	557d                	li	a0,-1
    80003dec:	bfc1                	j	80003dbc <filewrite+0x112>
    80003dee:	557d                	li	a0,-1
    80003df0:	b7f1                	j	80003dbc <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003df2:	557d                	li	a0,-1
    80003df4:	7a42                	ld	s4,48(sp)
    80003df6:	b7d9                	j	80003dbc <filewrite+0x112>

0000000080003df8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003df8:	7179                	addi	sp,sp,-48
    80003dfa:	f406                	sd	ra,40(sp)
    80003dfc:	f022                	sd	s0,32(sp)
    80003dfe:	ec26                	sd	s1,24(sp)
    80003e00:	e052                	sd	s4,0(sp)
    80003e02:	1800                	addi	s0,sp,48
    80003e04:	84aa                	mv	s1,a0
    80003e06:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e08:	0005b023          	sd	zero,0(a1)
    80003e0c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e10:	00000097          	auipc	ra,0x0
    80003e14:	bb8080e7          	jalr	-1096(ra) # 800039c8 <filealloc>
    80003e18:	e088                	sd	a0,0(s1)
    80003e1a:	cd49                	beqz	a0,80003eb4 <pipealloc+0xbc>
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	bac080e7          	jalr	-1108(ra) # 800039c8 <filealloc>
    80003e24:	00aa3023          	sd	a0,0(s4)
    80003e28:	c141                	beqz	a0,80003ea8 <pipealloc+0xb0>
    80003e2a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e2c:	ffffc097          	auipc	ra,0xffffc
    80003e30:	2ee080e7          	jalr	750(ra) # 8000011a <kalloc>
    80003e34:	892a                	mv	s2,a0
    80003e36:	c13d                	beqz	a0,80003e9c <pipealloc+0xa4>
    80003e38:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e3a:	4985                	li	s3,1
    80003e3c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e40:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e44:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e48:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e4c:	00004597          	auipc	a1,0x4
    80003e50:	6fc58593          	addi	a1,a1,1788 # 80008548 <etext+0x548>
    80003e54:	00002097          	auipc	ra,0x2
    80003e58:	47a080e7          	jalr	1146(ra) # 800062ce <initlock>
  (*f0)->type = FD_PIPE;
    80003e5c:	609c                	ld	a5,0(s1)
    80003e5e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e62:	609c                	ld	a5,0(s1)
    80003e64:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e68:	609c                	ld	a5,0(s1)
    80003e6a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e6e:	609c                	ld	a5,0(s1)
    80003e70:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e74:	000a3783          	ld	a5,0(s4)
    80003e78:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e7c:	000a3783          	ld	a5,0(s4)
    80003e80:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e84:	000a3783          	ld	a5,0(s4)
    80003e88:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e8c:	000a3783          	ld	a5,0(s4)
    80003e90:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e94:	4501                	li	a0,0
    80003e96:	6942                	ld	s2,16(sp)
    80003e98:	69a2                	ld	s3,8(sp)
    80003e9a:	a03d                	j	80003ec8 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e9c:	6088                	ld	a0,0(s1)
    80003e9e:	c119                	beqz	a0,80003ea4 <pipealloc+0xac>
    80003ea0:	6942                	ld	s2,16(sp)
    80003ea2:	a029                	j	80003eac <pipealloc+0xb4>
    80003ea4:	6942                	ld	s2,16(sp)
    80003ea6:	a039                	j	80003eb4 <pipealloc+0xbc>
    80003ea8:	6088                	ld	a0,0(s1)
    80003eaa:	c50d                	beqz	a0,80003ed4 <pipealloc+0xdc>
    fileclose(*f0);
    80003eac:	00000097          	auipc	ra,0x0
    80003eb0:	bd8080e7          	jalr	-1064(ra) # 80003a84 <fileclose>
  if(*f1)
    80003eb4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eb8:	557d                	li	a0,-1
  if(*f1)
    80003eba:	c799                	beqz	a5,80003ec8 <pipealloc+0xd0>
    fileclose(*f1);
    80003ebc:	853e                	mv	a0,a5
    80003ebe:	00000097          	auipc	ra,0x0
    80003ec2:	bc6080e7          	jalr	-1082(ra) # 80003a84 <fileclose>
  return -1;
    80003ec6:	557d                	li	a0,-1
}
    80003ec8:	70a2                	ld	ra,40(sp)
    80003eca:	7402                	ld	s0,32(sp)
    80003ecc:	64e2                	ld	s1,24(sp)
    80003ece:	6a02                	ld	s4,0(sp)
    80003ed0:	6145                	addi	sp,sp,48
    80003ed2:	8082                	ret
  return -1;
    80003ed4:	557d                	li	a0,-1
    80003ed6:	bfcd                	j	80003ec8 <pipealloc+0xd0>

0000000080003ed8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ed8:	1101                	addi	sp,sp,-32
    80003eda:	ec06                	sd	ra,24(sp)
    80003edc:	e822                	sd	s0,16(sp)
    80003ede:	e426                	sd	s1,8(sp)
    80003ee0:	e04a                	sd	s2,0(sp)
    80003ee2:	1000                	addi	s0,sp,32
    80003ee4:	84aa                	mv	s1,a0
    80003ee6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ee8:	00002097          	auipc	ra,0x2
    80003eec:	47a080e7          	jalr	1146(ra) # 80006362 <acquire>
  if(writable){
    80003ef0:	02090d63          	beqz	s2,80003f2a <pipeclose+0x52>
    pi->writeopen = 0;
    80003ef4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ef8:	21848513          	addi	a0,s1,536
    80003efc:	ffffd097          	auipc	ra,0xffffd
    80003f00:	7fe080e7          	jalr	2046(ra) # 800016fa <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f04:	2204b783          	ld	a5,544(s1)
    80003f08:	eb95                	bnez	a5,80003f3c <pipeclose+0x64>
    release(&pi->lock);
    80003f0a:	8526                	mv	a0,s1
    80003f0c:	00002097          	auipc	ra,0x2
    80003f10:	506080e7          	jalr	1286(ra) # 80006412 <release>
    kfree((char*)pi);
    80003f14:	8526                	mv	a0,s1
    80003f16:	ffffc097          	auipc	ra,0xffffc
    80003f1a:	106080e7          	jalr	262(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f1e:	60e2                	ld	ra,24(sp)
    80003f20:	6442                	ld	s0,16(sp)
    80003f22:	64a2                	ld	s1,8(sp)
    80003f24:	6902                	ld	s2,0(sp)
    80003f26:	6105                	addi	sp,sp,32
    80003f28:	8082                	ret
    pi->readopen = 0;
    80003f2a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f2e:	21c48513          	addi	a0,s1,540
    80003f32:	ffffd097          	auipc	ra,0xffffd
    80003f36:	7c8080e7          	jalr	1992(ra) # 800016fa <wakeup>
    80003f3a:	b7e9                	j	80003f04 <pipeclose+0x2c>
    release(&pi->lock);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	00002097          	auipc	ra,0x2
    80003f42:	4d4080e7          	jalr	1236(ra) # 80006412 <release>
}
    80003f46:	bfe1                	j	80003f1e <pipeclose+0x46>

0000000080003f48 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f48:	7159                	addi	sp,sp,-112
    80003f4a:	f486                	sd	ra,104(sp)
    80003f4c:	f0a2                	sd	s0,96(sp)
    80003f4e:	eca6                	sd	s1,88(sp)
    80003f50:	e8ca                	sd	s2,80(sp)
    80003f52:	e4ce                	sd	s3,72(sp)
    80003f54:	e0d2                	sd	s4,64(sp)
    80003f56:	fc56                	sd	s5,56(sp)
    80003f58:	1880                	addi	s0,sp,112
    80003f5a:	84aa                	mv	s1,a0
    80003f5c:	8aae                	mv	s5,a1
    80003f5e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	f42080e7          	jalr	-190(ra) # 80000ea2 <myproc>
    80003f68:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f6a:	8526                	mv	a0,s1
    80003f6c:	00002097          	auipc	ra,0x2
    80003f70:	3f6080e7          	jalr	1014(ra) # 80006362 <acquire>
  while(i < n){
    80003f74:	0d405d63          	blez	s4,8000404e <pipewrite+0x106>
    80003f78:	f85a                	sd	s6,48(sp)
    80003f7a:	f45e                	sd	s7,40(sp)
    80003f7c:	f062                	sd	s8,32(sp)
    80003f7e:	ec66                	sd	s9,24(sp)
    80003f80:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003f82:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f84:	f9f40c13          	addi	s8,s0,-97
    80003f88:	4b85                	li	s7,1
    80003f8a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f8c:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f90:	21c48c93          	addi	s9,s1,540
    80003f94:	a099                	j	80003fda <pipewrite+0x92>
      release(&pi->lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	47a080e7          	jalr	1146(ra) # 80006412 <release>
      return -1;
    80003fa0:	597d                	li	s2,-1
    80003fa2:	7b42                	ld	s6,48(sp)
    80003fa4:	7ba2                	ld	s7,40(sp)
    80003fa6:	7c02                	ld	s8,32(sp)
    80003fa8:	6ce2                	ld	s9,24(sp)
    80003faa:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fac:	854a                	mv	a0,s2
    80003fae:	70a6                	ld	ra,104(sp)
    80003fb0:	7406                	ld	s0,96(sp)
    80003fb2:	64e6                	ld	s1,88(sp)
    80003fb4:	6946                	ld	s2,80(sp)
    80003fb6:	69a6                	ld	s3,72(sp)
    80003fb8:	6a06                	ld	s4,64(sp)
    80003fba:	7ae2                	ld	s5,56(sp)
    80003fbc:	6165                	addi	sp,sp,112
    80003fbe:	8082                	ret
      wakeup(&pi->nread);
    80003fc0:	856a                	mv	a0,s10
    80003fc2:	ffffd097          	auipc	ra,0xffffd
    80003fc6:	738080e7          	jalr	1848(ra) # 800016fa <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fca:	85a6                	mv	a1,s1
    80003fcc:	8566                	mv	a0,s9
    80003fce:	ffffd097          	auipc	ra,0xffffd
    80003fd2:	5a6080e7          	jalr	1446(ra) # 80001574 <sleep>
  while(i < n){
    80003fd6:	05495b63          	bge	s2,s4,8000402c <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80003fda:	2204a783          	lw	a5,544(s1)
    80003fde:	dfc5                	beqz	a5,80003f96 <pipewrite+0x4e>
    80003fe0:	0289a783          	lw	a5,40(s3)
    80003fe4:	fbcd                	bnez	a5,80003f96 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fe6:	2184a783          	lw	a5,536(s1)
    80003fea:	21c4a703          	lw	a4,540(s1)
    80003fee:	2007879b          	addiw	a5,a5,512
    80003ff2:	fcf707e3          	beq	a4,a5,80003fc0 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ff6:	86de                	mv	a3,s7
    80003ff8:	01590633          	add	a2,s2,s5
    80003ffc:	85e2                	mv	a1,s8
    80003ffe:	0509b503          	ld	a0,80(s3)
    80004002:	ffffd097          	auipc	ra,0xffffd
    80004006:	bd8080e7          	jalr	-1064(ra) # 80000bda <copyin>
    8000400a:	05650463          	beq	a0,s6,80004052 <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000400e:	21c4a783          	lw	a5,540(s1)
    80004012:	0017871b          	addiw	a4,a5,1
    80004016:	20e4ae23          	sw	a4,540(s1)
    8000401a:	1ff7f793          	andi	a5,a5,511
    8000401e:	97a6                	add	a5,a5,s1
    80004020:	f9f44703          	lbu	a4,-97(s0)
    80004024:	00e78c23          	sb	a4,24(a5)
      i++;
    80004028:	2905                	addiw	s2,s2,1
    8000402a:	b775                	j	80003fd6 <pipewrite+0x8e>
    8000402c:	7b42                	ld	s6,48(sp)
    8000402e:	7ba2                	ld	s7,40(sp)
    80004030:	7c02                	ld	s8,32(sp)
    80004032:	6ce2                	ld	s9,24(sp)
    80004034:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004036:	21848513          	addi	a0,s1,536
    8000403a:	ffffd097          	auipc	ra,0xffffd
    8000403e:	6c0080e7          	jalr	1728(ra) # 800016fa <wakeup>
  release(&pi->lock);
    80004042:	8526                	mv	a0,s1
    80004044:	00002097          	auipc	ra,0x2
    80004048:	3ce080e7          	jalr	974(ra) # 80006412 <release>
  return i;
    8000404c:	b785                	j	80003fac <pipewrite+0x64>
  int i = 0;
    8000404e:	4901                	li	s2,0
    80004050:	b7dd                	j	80004036 <pipewrite+0xee>
    80004052:	7b42                	ld	s6,48(sp)
    80004054:	7ba2                	ld	s7,40(sp)
    80004056:	7c02                	ld	s8,32(sp)
    80004058:	6ce2                	ld	s9,24(sp)
    8000405a:	6d42                	ld	s10,16(sp)
    8000405c:	bfe9                	j	80004036 <pipewrite+0xee>

000000008000405e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000405e:	711d                	addi	sp,sp,-96
    80004060:	ec86                	sd	ra,88(sp)
    80004062:	e8a2                	sd	s0,80(sp)
    80004064:	e4a6                	sd	s1,72(sp)
    80004066:	e0ca                	sd	s2,64(sp)
    80004068:	fc4e                	sd	s3,56(sp)
    8000406a:	f852                	sd	s4,48(sp)
    8000406c:	f456                	sd	s5,40(sp)
    8000406e:	1080                	addi	s0,sp,96
    80004070:	84aa                	mv	s1,a0
    80004072:	892e                	mv	s2,a1
    80004074:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004076:	ffffd097          	auipc	ra,0xffffd
    8000407a:	e2c080e7          	jalr	-468(ra) # 80000ea2 <myproc>
    8000407e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004080:	8526                	mv	a0,s1
    80004082:	00002097          	auipc	ra,0x2
    80004086:	2e0080e7          	jalr	736(ra) # 80006362 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000408a:	2184a703          	lw	a4,536(s1)
    8000408e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004092:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004096:	02f71863          	bne	a4,a5,800040c6 <piperead+0x68>
    8000409a:	2244a783          	lw	a5,548(s1)
    8000409e:	cf9d                	beqz	a5,800040dc <piperead+0x7e>
    if(pr->killed){
    800040a0:	028a2783          	lw	a5,40(s4)
    800040a4:	e78d                	bnez	a5,800040ce <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a6:	85a6                	mv	a1,s1
    800040a8:	854e                	mv	a0,s3
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	4ca080e7          	jalr	1226(ra) # 80001574 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b2:	2184a703          	lw	a4,536(s1)
    800040b6:	21c4a783          	lw	a5,540(s1)
    800040ba:	fef700e3          	beq	a4,a5,8000409a <piperead+0x3c>
    800040be:	f05a                	sd	s6,32(sp)
    800040c0:	ec5e                	sd	s7,24(sp)
    800040c2:	e862                	sd	s8,16(sp)
    800040c4:	a839                	j	800040e2 <piperead+0x84>
    800040c6:	f05a                	sd	s6,32(sp)
    800040c8:	ec5e                	sd	s7,24(sp)
    800040ca:	e862                	sd	s8,16(sp)
    800040cc:	a819                	j	800040e2 <piperead+0x84>
      release(&pi->lock);
    800040ce:	8526                	mv	a0,s1
    800040d0:	00002097          	auipc	ra,0x2
    800040d4:	342080e7          	jalr	834(ra) # 80006412 <release>
      return -1;
    800040d8:	59fd                	li	s3,-1
    800040da:	a895                	j	8000414e <piperead+0xf0>
    800040dc:	f05a                	sd	s6,32(sp)
    800040de:	ec5e                	sd	s7,24(sp)
    800040e0:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040e2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040e4:	faf40c13          	addi	s8,s0,-81
    800040e8:	4b85                	li	s7,1
    800040ea:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ec:	05505363          	blez	s5,80004132 <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    800040f0:	2184a783          	lw	a5,536(s1)
    800040f4:	21c4a703          	lw	a4,540(s1)
    800040f8:	02f70d63          	beq	a4,a5,80004132 <piperead+0xd4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040fc:	0017871b          	addiw	a4,a5,1
    80004100:	20e4ac23          	sw	a4,536(s1)
    80004104:	1ff7f793          	andi	a5,a5,511
    80004108:	97a6                	add	a5,a5,s1
    8000410a:	0187c783          	lbu	a5,24(a5)
    8000410e:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004112:	86de                	mv	a3,s7
    80004114:	8662                	mv	a2,s8
    80004116:	85ca                	mv	a1,s2
    80004118:	050a3503          	ld	a0,80(s4)
    8000411c:	ffffd097          	auipc	ra,0xffffd
    80004120:	a32080e7          	jalr	-1486(ra) # 80000b4e <copyout>
    80004124:	01650763          	beq	a0,s6,80004132 <piperead+0xd4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004128:	2985                	addiw	s3,s3,1
    8000412a:	0905                	addi	s2,s2,1
    8000412c:	fd3a92e3          	bne	s5,s3,800040f0 <piperead+0x92>
    80004130:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004132:	21c48513          	addi	a0,s1,540
    80004136:	ffffd097          	auipc	ra,0xffffd
    8000413a:	5c4080e7          	jalr	1476(ra) # 800016fa <wakeup>
  release(&pi->lock);
    8000413e:	8526                	mv	a0,s1
    80004140:	00002097          	auipc	ra,0x2
    80004144:	2d2080e7          	jalr	722(ra) # 80006412 <release>
    80004148:	7b02                	ld	s6,32(sp)
    8000414a:	6be2                	ld	s7,24(sp)
    8000414c:	6c42                	ld	s8,16(sp)
  return i;
}
    8000414e:	854e                	mv	a0,s3
    80004150:	60e6                	ld	ra,88(sp)
    80004152:	6446                	ld	s0,80(sp)
    80004154:	64a6                	ld	s1,72(sp)
    80004156:	6906                	ld	s2,64(sp)
    80004158:	79e2                	ld	s3,56(sp)
    8000415a:	7a42                	ld	s4,48(sp)
    8000415c:	7aa2                	ld	s5,40(sp)
    8000415e:	6125                	addi	sp,sp,96
    80004160:	8082                	ret

0000000080004162 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004162:	de010113          	addi	sp,sp,-544
    80004166:	20113c23          	sd	ra,536(sp)
    8000416a:	20813823          	sd	s0,528(sp)
    8000416e:	20913423          	sd	s1,520(sp)
    80004172:	21213023          	sd	s2,512(sp)
    80004176:	1400                	addi	s0,sp,544
    80004178:	892a                	mv	s2,a0
    8000417a:	dea43823          	sd	a0,-528(s0)
    8000417e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004182:	ffffd097          	auipc	ra,0xffffd
    80004186:	d20080e7          	jalr	-736(ra) # 80000ea2 <myproc>
    8000418a:	84aa                	mv	s1,a0

  begin_op();
    8000418c:	fffff097          	auipc	ra,0xfffff
    80004190:	428080e7          	jalr	1064(ra) # 800035b4 <begin_op>

  if((ip = namei(path)) == 0){
    80004194:	854a                	mv	a0,s2
    80004196:	fffff097          	auipc	ra,0xfffff
    8000419a:	218080e7          	jalr	536(ra) # 800033ae <namei>
    8000419e:	c525                	beqz	a0,80004206 <exec+0xa4>
    800041a0:	fbd2                	sd	s4,496(sp)
    800041a2:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041a4:	fffff097          	auipc	ra,0xfffff
    800041a8:	a1e080e7          	jalr	-1506(ra) # 80002bc2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041ac:	04000713          	li	a4,64
    800041b0:	4681                	li	a3,0
    800041b2:	e5040613          	addi	a2,s0,-432
    800041b6:	4581                	li	a1,0
    800041b8:	8552                	mv	a0,s4
    800041ba:	fffff097          	auipc	ra,0xfffff
    800041be:	cc4080e7          	jalr	-828(ra) # 80002e7e <readi>
    800041c2:	04000793          	li	a5,64
    800041c6:	00f51a63          	bne	a0,a5,800041da <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800041ca:	e5042703          	lw	a4,-432(s0)
    800041ce:	464c47b7          	lui	a5,0x464c4
    800041d2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041d6:	02f70e63          	beq	a4,a5,80004212 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041da:	8552                	mv	a0,s4
    800041dc:	fffff097          	auipc	ra,0xfffff
    800041e0:	c4c080e7          	jalr	-948(ra) # 80002e28 <iunlockput>
    end_op();
    800041e4:	fffff097          	auipc	ra,0xfffff
    800041e8:	44a080e7          	jalr	1098(ra) # 8000362e <end_op>
  }
  return -1;
    800041ec:	557d                	li	a0,-1
    800041ee:	7a5e                	ld	s4,496(sp)
}
    800041f0:	21813083          	ld	ra,536(sp)
    800041f4:	21013403          	ld	s0,528(sp)
    800041f8:	20813483          	ld	s1,520(sp)
    800041fc:	20013903          	ld	s2,512(sp)
    80004200:	22010113          	addi	sp,sp,544
    80004204:	8082                	ret
    end_op();
    80004206:	fffff097          	auipc	ra,0xfffff
    8000420a:	428080e7          	jalr	1064(ra) # 8000362e <end_op>
    return -1;
    8000420e:	557d                	li	a0,-1
    80004210:	b7c5                	j	800041f0 <exec+0x8e>
    80004212:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004214:	8526                	mv	a0,s1
    80004216:	ffffd097          	auipc	ra,0xffffd
    8000421a:	d50080e7          	jalr	-688(ra) # 80000f66 <proc_pagetable>
    8000421e:	8b2a                	mv	s6,a0
    80004220:	2a050863          	beqz	a0,800044d0 <exec+0x36e>
    80004224:	ffce                	sd	s3,504(sp)
    80004226:	f7d6                	sd	s5,488(sp)
    80004228:	efde                	sd	s7,472(sp)
    8000422a:	ebe2                	sd	s8,464(sp)
    8000422c:	e7e6                	sd	s9,456(sp)
    8000422e:	e3ea                	sd	s10,448(sp)
    80004230:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004232:	e7042683          	lw	a3,-400(s0)
    80004236:	e8845783          	lhu	a5,-376(s0)
    8000423a:	cbfd                	beqz	a5,80004330 <exec+0x1ce>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000423c:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000423e:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004240:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    80004244:	6c85                	lui	s9,0x1
    80004246:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000424a:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000424e:	6a85                	lui	s5,0x1
    80004250:	a0b5                	j	800042bc <exec+0x15a>
      panic("loadseg: address should exist");
    80004252:	00004517          	auipc	a0,0x4
    80004256:	2fe50513          	addi	a0,a0,766 # 80008550 <etext+0x550>
    8000425a:	00002097          	auipc	ra,0x2
    8000425e:	bb2080e7          	jalr	-1102(ra) # 80005e0c <panic>
    if(sz - i < PGSIZE)
    80004262:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004264:	874a                	mv	a4,s2
    80004266:	009c06bb          	addw	a3,s8,s1
    8000426a:	4581                	li	a1,0
    8000426c:	8552                	mv	a0,s4
    8000426e:	fffff097          	auipc	ra,0xfffff
    80004272:	c10080e7          	jalr	-1008(ra) # 80002e7e <readi>
    80004276:	26a91163          	bne	s2,a0,800044d8 <exec+0x376>
  for(i = 0; i < sz; i += PGSIZE){
    8000427a:	009a84bb          	addw	s1,s5,s1
    8000427e:	0334f463          	bgeu	s1,s3,800042a6 <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    80004282:	02049593          	slli	a1,s1,0x20
    80004286:	9181                	srli	a1,a1,0x20
    80004288:	95de                	add	a1,a1,s7
    8000428a:	855a                	mv	a0,s6
    8000428c:	ffffc097          	auipc	ra,0xffffc
    80004290:	28c080e7          	jalr	652(ra) # 80000518 <walkaddr>
    80004294:	862a                	mv	a2,a0
    if(pa == 0)
    80004296:	dd55                	beqz	a0,80004252 <exec+0xf0>
    if(sz - i < PGSIZE)
    80004298:	409987bb          	subw	a5,s3,s1
    8000429c:	893e                	mv	s2,a5
    8000429e:	fcfcf2e3          	bgeu	s9,a5,80004262 <exec+0x100>
    800042a2:	8956                	mv	s2,s5
    800042a4:	bf7d                	j	80004262 <exec+0x100>
    sz = sz1;
    800042a6:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042aa:	2d05                	addiw	s10,s10,1
    800042ac:	e0843783          	ld	a5,-504(s0)
    800042b0:	0387869b          	addiw	a3,a5,56
    800042b4:	e8845783          	lhu	a5,-376(s0)
    800042b8:	06fd5d63          	bge	s10,a5,80004332 <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800042bc:	e0d43423          	sd	a3,-504(s0)
    800042c0:	876e                	mv	a4,s11
    800042c2:	e1840613          	addi	a2,s0,-488
    800042c6:	4581                	li	a1,0
    800042c8:	8552                	mv	a0,s4
    800042ca:	fffff097          	auipc	ra,0xfffff
    800042ce:	bb4080e7          	jalr	-1100(ra) # 80002e7e <readi>
    800042d2:	21b51163          	bne	a0,s11,800044d4 <exec+0x372>
    if(ph.type != ELF_PROG_LOAD)
    800042d6:	e1842783          	lw	a5,-488(s0)
    800042da:	4705                	li	a4,1
    800042dc:	fce797e3          	bne	a5,a4,800042aa <exec+0x148>
    if(ph.memsz < ph.filesz)
    800042e0:	e4043603          	ld	a2,-448(s0)
    800042e4:	e3843783          	ld	a5,-456(s0)
    800042e8:	20f66863          	bltu	a2,a5,800044f8 <exec+0x396>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800042ec:	e2843783          	ld	a5,-472(s0)
    800042f0:	963e                	add	a2,a2,a5
    800042f2:	20f66663          	bltu	a2,a5,800044fe <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800042f6:	85a6                	mv	a1,s1
    800042f8:	855a                	mv	a0,s6
    800042fa:	ffffc097          	auipc	ra,0xffffc
    800042fe:	5e2080e7          	jalr	1506(ra) # 800008dc <uvmalloc>
    80004302:	dea43c23          	sd	a0,-520(s0)
    80004306:	1e050f63          	beqz	a0,80004504 <exec+0x3a2>
    if((ph.vaddr % PGSIZE) != 0)
    8000430a:	e2843b83          	ld	s7,-472(s0)
    8000430e:	de843783          	ld	a5,-536(s0)
    80004312:	00fbf7b3          	and	a5,s7,a5
    80004316:	1c079163          	bnez	a5,800044d8 <exec+0x376>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000431a:	e2042c03          	lw	s8,-480(s0)
    8000431e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004322:	00098463          	beqz	s3,8000432a <exec+0x1c8>
    80004326:	4481                	li	s1,0
    80004328:	bfa9                	j	80004282 <exec+0x120>
    sz = sz1;
    8000432a:	df843483          	ld	s1,-520(s0)
    8000432e:	bfb5                	j	800042aa <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004330:	4481                	li	s1,0
  iunlockput(ip);
    80004332:	8552                	mv	a0,s4
    80004334:	fffff097          	auipc	ra,0xfffff
    80004338:	af4080e7          	jalr	-1292(ra) # 80002e28 <iunlockput>
  end_op();
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	2f2080e7          	jalr	754(ra) # 8000362e <end_op>
  p = myproc();
    80004344:	ffffd097          	auipc	ra,0xffffd
    80004348:	b5e080e7          	jalr	-1186(ra) # 80000ea2 <myproc>
    8000434c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000434e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004352:	6985                	lui	s3,0x1
    80004354:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004356:	99a6                	add	s3,s3,s1
    80004358:	77fd                	lui	a5,0xfffff
    8000435a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    8000435e:	6609                	lui	a2,0x2
    80004360:	964e                	add	a2,a2,s3
    80004362:	85ce                	mv	a1,s3
    80004364:	855a                	mv	a0,s6
    80004366:	ffffc097          	auipc	ra,0xffffc
    8000436a:	576080e7          	jalr	1398(ra) # 800008dc <uvmalloc>
    8000436e:	8a2a                	mv	s4,a0
    80004370:	e115                	bnez	a0,80004394 <exec+0x232>
    proc_freepagetable(pagetable, sz);
    80004372:	85ce                	mv	a1,s3
    80004374:	855a                	mv	a0,s6
    80004376:	ffffd097          	auipc	ra,0xffffd
    8000437a:	c8c080e7          	jalr	-884(ra) # 80001002 <proc_freepagetable>
  return -1;
    8000437e:	557d                	li	a0,-1
    80004380:	79fe                	ld	s3,504(sp)
    80004382:	7a5e                	ld	s4,496(sp)
    80004384:	7abe                	ld	s5,488(sp)
    80004386:	7b1e                	ld	s6,480(sp)
    80004388:	6bfe                	ld	s7,472(sp)
    8000438a:	6c5e                	ld	s8,464(sp)
    8000438c:	6cbe                	ld	s9,456(sp)
    8000438e:	6d1e                	ld	s10,448(sp)
    80004390:	7dfa                	ld	s11,440(sp)
    80004392:	bdb9                	j	800041f0 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004394:	75f9                	lui	a1,0xffffe
    80004396:	95aa                	add	a1,a1,a0
    80004398:	855a                	mv	a0,s6
    8000439a:	ffffc097          	auipc	ra,0xffffc
    8000439e:	782080e7          	jalr	1922(ra) # 80000b1c <uvmclear>
  stackbase = sp - PGSIZE;
    800043a2:	7bfd                	lui	s7,0xfffff
    800043a4:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    800043a6:	e0043783          	ld	a5,-512(s0)
    800043aa:	6388                	ld	a0,0(a5)
  sp = sz;
    800043ac:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800043ae:	4481                	li	s1,0
    ustack[argc] = sp;
    800043b0:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800043b4:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800043b8:	c135                	beqz	a0,8000441c <exec+0x2ba>
    sp -= strlen(argv[argc]) + 1;
    800043ba:	ffffc097          	auipc	ra,0xffffc
    800043be:	f4c080e7          	jalr	-180(ra) # 80000306 <strlen>
    800043c2:	0015079b          	addiw	a5,a0,1
    800043c6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043ca:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800043ce:	13796e63          	bltu	s2,s7,8000450a <exec+0x3a8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043d2:	e0043d83          	ld	s11,-512(s0)
    800043d6:	000db983          	ld	s3,0(s11)
    800043da:	854e                	mv	a0,s3
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	f2a080e7          	jalr	-214(ra) # 80000306 <strlen>
    800043e4:	0015069b          	addiw	a3,a0,1
    800043e8:	864e                	mv	a2,s3
    800043ea:	85ca                	mv	a1,s2
    800043ec:	855a                	mv	a0,s6
    800043ee:	ffffc097          	auipc	ra,0xffffc
    800043f2:	760080e7          	jalr	1888(ra) # 80000b4e <copyout>
    800043f6:	10054c63          	bltz	a0,8000450e <exec+0x3ac>
    ustack[argc] = sp;
    800043fa:	00349793          	slli	a5,s1,0x3
    800043fe:	97e6                	add	a5,a5,s9
    80004400:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
  for(argc = 0; argv[argc]; argc++) {
    80004404:	0485                	addi	s1,s1,1
    80004406:	008d8793          	addi	a5,s11,8
    8000440a:	e0f43023          	sd	a5,-512(s0)
    8000440e:	008db503          	ld	a0,8(s11)
    80004412:	c509                	beqz	a0,8000441c <exec+0x2ba>
    if(argc >= MAXARG)
    80004414:	fb8493e3          	bne	s1,s8,800043ba <exec+0x258>
  sz = sz1;
    80004418:	89d2                	mv	s3,s4
    8000441a:	bfa1                	j	80004372 <exec+0x210>
  ustack[argc] = 0;
    8000441c:	00349793          	slli	a5,s1,0x3
    80004420:	f9078793          	addi	a5,a5,-112
    80004424:	97a2                	add	a5,a5,s0
    80004426:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000442a:	00148693          	addi	a3,s1,1
    8000442e:	068e                	slli	a3,a3,0x3
    80004430:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004434:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004438:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000443a:	f3796ce3          	bltu	s2,s7,80004372 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000443e:	e9040613          	addi	a2,s0,-368
    80004442:	85ca                	mv	a1,s2
    80004444:	855a                	mv	a0,s6
    80004446:	ffffc097          	auipc	ra,0xffffc
    8000444a:	708080e7          	jalr	1800(ra) # 80000b4e <copyout>
    8000444e:	f20542e3          	bltz	a0,80004372 <exec+0x210>
  p->trapframe->a1 = sp;
    80004452:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004456:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000445a:	df043783          	ld	a5,-528(s0)
    8000445e:	0007c703          	lbu	a4,0(a5)
    80004462:	cf11                	beqz	a4,8000447e <exec+0x31c>
    80004464:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004466:	02f00693          	li	a3,47
    8000446a:	a029                	j	80004474 <exec+0x312>
  for(last=s=path; *s; s++)
    8000446c:	0785                	addi	a5,a5,1
    8000446e:	fff7c703          	lbu	a4,-1(a5)
    80004472:	c711                	beqz	a4,8000447e <exec+0x31c>
    if(*s == '/')
    80004474:	fed71ce3          	bne	a4,a3,8000446c <exec+0x30a>
      last = s+1;
    80004478:	def43823          	sd	a5,-528(s0)
    8000447c:	bfc5                	j	8000446c <exec+0x30a>
  safestrcpy(p->name, last, sizeof(p->name));
    8000447e:	4641                	li	a2,16
    80004480:	df043583          	ld	a1,-528(s0)
    80004484:	158a8513          	addi	a0,s5,344
    80004488:	ffffc097          	auipc	ra,0xffffc
    8000448c:	e48080e7          	jalr	-440(ra) # 800002d0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004490:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004494:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004498:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000449c:	058ab783          	ld	a5,88(s5)
    800044a0:	e6843703          	ld	a4,-408(s0)
    800044a4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800044a6:	058ab783          	ld	a5,88(s5)
    800044aa:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800044ae:	85ea                	mv	a1,s10
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	b52080e7          	jalr	-1198(ra) # 80001002 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044b8:	0004851b          	sext.w	a0,s1
    800044bc:	79fe                	ld	s3,504(sp)
    800044be:	7a5e                	ld	s4,496(sp)
    800044c0:	7abe                	ld	s5,488(sp)
    800044c2:	7b1e                	ld	s6,480(sp)
    800044c4:	6bfe                	ld	s7,472(sp)
    800044c6:	6c5e                	ld	s8,464(sp)
    800044c8:	6cbe                	ld	s9,456(sp)
    800044ca:	6d1e                	ld	s10,448(sp)
    800044cc:	7dfa                	ld	s11,440(sp)
    800044ce:	b30d                	j	800041f0 <exec+0x8e>
    800044d0:	7b1e                	ld	s6,480(sp)
    800044d2:	b321                	j	800041da <exec+0x78>
    800044d4:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    800044d8:	df843583          	ld	a1,-520(s0)
    800044dc:	855a                	mv	a0,s6
    800044de:	ffffd097          	auipc	ra,0xffffd
    800044e2:	b24080e7          	jalr	-1244(ra) # 80001002 <proc_freepagetable>
  if(ip){
    800044e6:	79fe                	ld	s3,504(sp)
    800044e8:	7abe                	ld	s5,488(sp)
    800044ea:	7b1e                	ld	s6,480(sp)
    800044ec:	6bfe                	ld	s7,472(sp)
    800044ee:	6c5e                	ld	s8,464(sp)
    800044f0:	6cbe                	ld	s9,456(sp)
    800044f2:	6d1e                	ld	s10,448(sp)
    800044f4:	7dfa                	ld	s11,440(sp)
    800044f6:	b1d5                	j	800041da <exec+0x78>
    800044f8:	de943c23          	sd	s1,-520(s0)
    800044fc:	bff1                	j	800044d8 <exec+0x376>
    800044fe:	de943c23          	sd	s1,-520(s0)
    80004502:	bfd9                	j	800044d8 <exec+0x376>
    80004504:	de943c23          	sd	s1,-520(s0)
    80004508:	bfc1                	j	800044d8 <exec+0x376>
  sz = sz1;
    8000450a:	89d2                	mv	s3,s4
    8000450c:	b59d                	j	80004372 <exec+0x210>
    8000450e:	89d2                	mv	s3,s4
    80004510:	b58d                	j	80004372 <exec+0x210>

0000000080004512 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004512:	7179                	addi	sp,sp,-48
    80004514:	f406                	sd	ra,40(sp)
    80004516:	f022                	sd	s0,32(sp)
    80004518:	ec26                	sd	s1,24(sp)
    8000451a:	e84a                	sd	s2,16(sp)
    8000451c:	1800                	addi	s0,sp,48
    8000451e:	892e                	mv	s2,a1
    80004520:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004522:	fdc40593          	addi	a1,s0,-36
    80004526:	ffffe097          	auipc	ra,0xffffe
    8000452a:	a8e080e7          	jalr	-1394(ra) # 80001fb4 <argint>
    8000452e:	04054063          	bltz	a0,8000456e <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004532:	fdc42703          	lw	a4,-36(s0)
    80004536:	47bd                	li	a5,15
    80004538:	02e7ed63          	bltu	a5,a4,80004572 <argfd+0x60>
    8000453c:	ffffd097          	auipc	ra,0xffffd
    80004540:	966080e7          	jalr	-1690(ra) # 80000ea2 <myproc>
    80004544:	fdc42703          	lw	a4,-36(s0)
    80004548:	01a70793          	addi	a5,a4,26
    8000454c:	078e                	slli	a5,a5,0x3
    8000454e:	953e                	add	a0,a0,a5
    80004550:	611c                	ld	a5,0(a0)
    80004552:	c395                	beqz	a5,80004576 <argfd+0x64>
    return -1;
  if(pfd)
    80004554:	00090463          	beqz	s2,8000455c <argfd+0x4a>
    *pfd = fd;
    80004558:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000455c:	4501                	li	a0,0
  if(pf)
    8000455e:	c091                	beqz	s1,80004562 <argfd+0x50>
    *pf = f;
    80004560:	e09c                	sd	a5,0(s1)
}
    80004562:	70a2                	ld	ra,40(sp)
    80004564:	7402                	ld	s0,32(sp)
    80004566:	64e2                	ld	s1,24(sp)
    80004568:	6942                	ld	s2,16(sp)
    8000456a:	6145                	addi	sp,sp,48
    8000456c:	8082                	ret
    return -1;
    8000456e:	557d                	li	a0,-1
    80004570:	bfcd                	j	80004562 <argfd+0x50>
    return -1;
    80004572:	557d                	li	a0,-1
    80004574:	b7fd                	j	80004562 <argfd+0x50>
    80004576:	557d                	li	a0,-1
    80004578:	b7ed                	j	80004562 <argfd+0x50>

000000008000457a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000457a:	1101                	addi	sp,sp,-32
    8000457c:	ec06                	sd	ra,24(sp)
    8000457e:	e822                	sd	s0,16(sp)
    80004580:	e426                	sd	s1,8(sp)
    80004582:	1000                	addi	s0,sp,32
    80004584:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004586:	ffffd097          	auipc	ra,0xffffd
    8000458a:	91c080e7          	jalr	-1764(ra) # 80000ea2 <myproc>
    8000458e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004590:	0d050793          	addi	a5,a0,208
    80004594:	4501                	li	a0,0
    80004596:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004598:	6398                	ld	a4,0(a5)
    8000459a:	cb19                	beqz	a4,800045b0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000459c:	2505                	addiw	a0,a0,1
    8000459e:	07a1                	addi	a5,a5,8
    800045a0:	fed51ce3          	bne	a0,a3,80004598 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045a4:	557d                	li	a0,-1
}
    800045a6:	60e2                	ld	ra,24(sp)
    800045a8:	6442                	ld	s0,16(sp)
    800045aa:	64a2                	ld	s1,8(sp)
    800045ac:	6105                	addi	sp,sp,32
    800045ae:	8082                	ret
      p->ofile[fd] = f;
    800045b0:	01a50793          	addi	a5,a0,26
    800045b4:	078e                	slli	a5,a5,0x3
    800045b6:	963e                	add	a2,a2,a5
    800045b8:	e204                	sd	s1,0(a2)
      return fd;
    800045ba:	b7f5                	j	800045a6 <fdalloc+0x2c>

00000000800045bc <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045bc:	715d                	addi	sp,sp,-80
    800045be:	e486                	sd	ra,72(sp)
    800045c0:	e0a2                	sd	s0,64(sp)
    800045c2:	fc26                	sd	s1,56(sp)
    800045c4:	f84a                	sd	s2,48(sp)
    800045c6:	f44e                	sd	s3,40(sp)
    800045c8:	f052                	sd	s4,32(sp)
    800045ca:	ec56                	sd	s5,24(sp)
    800045cc:	0880                	addi	s0,sp,80
    800045ce:	8aae                	mv	s5,a1
    800045d0:	8a32                	mv	s4,a2
    800045d2:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045d4:	fb040593          	addi	a1,s0,-80
    800045d8:	fffff097          	auipc	ra,0xfffff
    800045dc:	df4080e7          	jalr	-524(ra) # 800033cc <nameiparent>
    800045e0:	892a                	mv	s2,a0
    800045e2:	12050c63          	beqz	a0,8000471a <create+0x15e>
    return 0;

  ilock(dp);
    800045e6:	ffffe097          	auipc	ra,0xffffe
    800045ea:	5dc080e7          	jalr	1500(ra) # 80002bc2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800045ee:	4601                	li	a2,0
    800045f0:	fb040593          	addi	a1,s0,-80
    800045f4:	854a                	mv	a0,s2
    800045f6:	fffff097          	auipc	ra,0xfffff
    800045fa:	abc080e7          	jalr	-1348(ra) # 800030b2 <dirlookup>
    800045fe:	84aa                	mv	s1,a0
    80004600:	c539                	beqz	a0,8000464e <create+0x92>
    iunlockput(dp);
    80004602:	854a                	mv	a0,s2
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	824080e7          	jalr	-2012(ra) # 80002e28 <iunlockput>
    ilock(ip);
    8000460c:	8526                	mv	a0,s1
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	5b4080e7          	jalr	1460(ra) # 80002bc2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004616:	4789                	li	a5,2
    80004618:	02fa9463          	bne	s5,a5,80004640 <create+0x84>
    8000461c:	0444d783          	lhu	a5,68(s1)
    80004620:	37f9                	addiw	a5,a5,-2
    80004622:	17c2                	slli	a5,a5,0x30
    80004624:	93c1                	srli	a5,a5,0x30
    80004626:	4705                	li	a4,1
    80004628:	00f76c63          	bltu	a4,a5,80004640 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000462c:	8526                	mv	a0,s1
    8000462e:	60a6                	ld	ra,72(sp)
    80004630:	6406                	ld	s0,64(sp)
    80004632:	74e2                	ld	s1,56(sp)
    80004634:	7942                	ld	s2,48(sp)
    80004636:	79a2                	ld	s3,40(sp)
    80004638:	7a02                	ld	s4,32(sp)
    8000463a:	6ae2                	ld	s5,24(sp)
    8000463c:	6161                	addi	sp,sp,80
    8000463e:	8082                	ret
    iunlockput(ip);
    80004640:	8526                	mv	a0,s1
    80004642:	ffffe097          	auipc	ra,0xffffe
    80004646:	7e6080e7          	jalr	2022(ra) # 80002e28 <iunlockput>
    return 0;
    8000464a:	4481                	li	s1,0
    8000464c:	b7c5                	j	8000462c <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000464e:	85d6                	mv	a1,s5
    80004650:	00092503          	lw	a0,0(s2)
    80004654:	ffffe097          	auipc	ra,0xffffe
    80004658:	3da080e7          	jalr	986(ra) # 80002a2e <ialloc>
    8000465c:	84aa                	mv	s1,a0
    8000465e:	c139                	beqz	a0,800046a4 <create+0xe8>
  ilock(ip);
    80004660:	ffffe097          	auipc	ra,0xffffe
    80004664:	562080e7          	jalr	1378(ra) # 80002bc2 <ilock>
  ip->major = major;
    80004668:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    8000466c:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004670:	4985                	li	s3,1
    80004672:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    80004676:	8526                	mv	a0,s1
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	47e080e7          	jalr	1150(ra) # 80002af6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004680:	033a8a63          	beq	s5,s3,800046b4 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    80004684:	40d0                	lw	a2,4(s1)
    80004686:	fb040593          	addi	a1,s0,-80
    8000468a:	854a                	mv	a0,s2
    8000468c:	fffff097          	auipc	ra,0xfffff
    80004690:	c4c080e7          	jalr	-948(ra) # 800032d8 <dirlink>
    80004694:	06054b63          	bltz	a0,8000470a <create+0x14e>
  iunlockput(dp);
    80004698:	854a                	mv	a0,s2
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	78e080e7          	jalr	1934(ra) # 80002e28 <iunlockput>
  return ip;
    800046a2:	b769                	j	8000462c <create+0x70>
    panic("create: ialloc");
    800046a4:	00004517          	auipc	a0,0x4
    800046a8:	ecc50513          	addi	a0,a0,-308 # 80008570 <etext+0x570>
    800046ac:	00001097          	auipc	ra,0x1
    800046b0:	760080e7          	jalr	1888(ra) # 80005e0c <panic>
    dp->nlink++;  // for ".."
    800046b4:	04a95783          	lhu	a5,74(s2)
    800046b8:	2785                	addiw	a5,a5,1
    800046ba:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800046be:	854a                	mv	a0,s2
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	436080e7          	jalr	1078(ra) # 80002af6 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046c8:	40d0                	lw	a2,4(s1)
    800046ca:	00004597          	auipc	a1,0x4
    800046ce:	eb658593          	addi	a1,a1,-330 # 80008580 <etext+0x580>
    800046d2:	8526                	mv	a0,s1
    800046d4:	fffff097          	auipc	ra,0xfffff
    800046d8:	c04080e7          	jalr	-1020(ra) # 800032d8 <dirlink>
    800046dc:	00054f63          	bltz	a0,800046fa <create+0x13e>
    800046e0:	00492603          	lw	a2,4(s2)
    800046e4:	00004597          	auipc	a1,0x4
    800046e8:	ea458593          	addi	a1,a1,-348 # 80008588 <etext+0x588>
    800046ec:	8526                	mv	a0,s1
    800046ee:	fffff097          	auipc	ra,0xfffff
    800046f2:	bea080e7          	jalr	-1046(ra) # 800032d8 <dirlink>
    800046f6:	f80557e3          	bgez	a0,80004684 <create+0xc8>
      panic("create dots");
    800046fa:	00004517          	auipc	a0,0x4
    800046fe:	e9650513          	addi	a0,a0,-362 # 80008590 <etext+0x590>
    80004702:	00001097          	auipc	ra,0x1
    80004706:	70a080e7          	jalr	1802(ra) # 80005e0c <panic>
    panic("create: dirlink");
    8000470a:	00004517          	auipc	a0,0x4
    8000470e:	e9650513          	addi	a0,a0,-362 # 800085a0 <etext+0x5a0>
    80004712:	00001097          	auipc	ra,0x1
    80004716:	6fa080e7          	jalr	1786(ra) # 80005e0c <panic>
    return 0;
    8000471a:	84aa                	mv	s1,a0
    8000471c:	bf01                	j	8000462c <create+0x70>

000000008000471e <sys_dup>:
{
    8000471e:	7179                	addi	sp,sp,-48
    80004720:	f406                	sd	ra,40(sp)
    80004722:	f022                	sd	s0,32(sp)
    80004724:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004726:	fd840613          	addi	a2,s0,-40
    8000472a:	4581                	li	a1,0
    8000472c:	4501                	li	a0,0
    8000472e:	00000097          	auipc	ra,0x0
    80004732:	de4080e7          	jalr	-540(ra) # 80004512 <argfd>
    return -1;
    80004736:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004738:	02054763          	bltz	a0,80004766 <sys_dup+0x48>
    8000473c:	ec26                	sd	s1,24(sp)
    8000473e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004740:	fd843903          	ld	s2,-40(s0)
    80004744:	854a                	mv	a0,s2
    80004746:	00000097          	auipc	ra,0x0
    8000474a:	e34080e7          	jalr	-460(ra) # 8000457a <fdalloc>
    8000474e:	84aa                	mv	s1,a0
    return -1;
    80004750:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004752:	00054f63          	bltz	a0,80004770 <sys_dup+0x52>
  filedup(f);
    80004756:	854a                	mv	a0,s2
    80004758:	fffff097          	auipc	ra,0xfffff
    8000475c:	2da080e7          	jalr	730(ra) # 80003a32 <filedup>
  return fd;
    80004760:	87a6                	mv	a5,s1
    80004762:	64e2                	ld	s1,24(sp)
    80004764:	6942                	ld	s2,16(sp)
}
    80004766:	853e                	mv	a0,a5
    80004768:	70a2                	ld	ra,40(sp)
    8000476a:	7402                	ld	s0,32(sp)
    8000476c:	6145                	addi	sp,sp,48
    8000476e:	8082                	ret
    80004770:	64e2                	ld	s1,24(sp)
    80004772:	6942                	ld	s2,16(sp)
    80004774:	bfcd                	j	80004766 <sys_dup+0x48>

0000000080004776 <sys_read>:
{
    80004776:	7179                	addi	sp,sp,-48
    80004778:	f406                	sd	ra,40(sp)
    8000477a:	f022                	sd	s0,32(sp)
    8000477c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000477e:	fe840613          	addi	a2,s0,-24
    80004782:	4581                	li	a1,0
    80004784:	4501                	li	a0,0
    80004786:	00000097          	auipc	ra,0x0
    8000478a:	d8c080e7          	jalr	-628(ra) # 80004512 <argfd>
    return -1;
    8000478e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004790:	04054163          	bltz	a0,800047d2 <sys_read+0x5c>
    80004794:	fe440593          	addi	a1,s0,-28
    80004798:	4509                	li	a0,2
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	81a080e7          	jalr	-2022(ra) # 80001fb4 <argint>
    return -1;
    800047a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047a4:	02054763          	bltz	a0,800047d2 <sys_read+0x5c>
    800047a8:	fd840593          	addi	a1,s0,-40
    800047ac:	4505                	li	a0,1
    800047ae:	ffffe097          	auipc	ra,0xffffe
    800047b2:	828080e7          	jalr	-2008(ra) # 80001fd6 <argaddr>
    return -1;
    800047b6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047b8:	00054d63          	bltz	a0,800047d2 <sys_read+0x5c>
  return fileread(f, p, n);
    800047bc:	fe442603          	lw	a2,-28(s0)
    800047c0:	fd843583          	ld	a1,-40(s0)
    800047c4:	fe843503          	ld	a0,-24(s0)
    800047c8:	fffff097          	auipc	ra,0xfffff
    800047cc:	410080e7          	jalr	1040(ra) # 80003bd8 <fileread>
    800047d0:	87aa                	mv	a5,a0
}
    800047d2:	853e                	mv	a0,a5
    800047d4:	70a2                	ld	ra,40(sp)
    800047d6:	7402                	ld	s0,32(sp)
    800047d8:	6145                	addi	sp,sp,48
    800047da:	8082                	ret

00000000800047dc <sys_write>:
{
    800047dc:	7179                	addi	sp,sp,-48
    800047de:	f406                	sd	ra,40(sp)
    800047e0:	f022                	sd	s0,32(sp)
    800047e2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047e4:	fe840613          	addi	a2,s0,-24
    800047e8:	4581                	li	a1,0
    800047ea:	4501                	li	a0,0
    800047ec:	00000097          	auipc	ra,0x0
    800047f0:	d26080e7          	jalr	-730(ra) # 80004512 <argfd>
    return -1;
    800047f4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800047f6:	04054163          	bltz	a0,80004838 <sys_write+0x5c>
    800047fa:	fe440593          	addi	a1,s0,-28
    800047fe:	4509                	li	a0,2
    80004800:	ffffd097          	auipc	ra,0xffffd
    80004804:	7b4080e7          	jalr	1972(ra) # 80001fb4 <argint>
    return -1;
    80004808:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000480a:	02054763          	bltz	a0,80004838 <sys_write+0x5c>
    8000480e:	fd840593          	addi	a1,s0,-40
    80004812:	4505                	li	a0,1
    80004814:	ffffd097          	auipc	ra,0xffffd
    80004818:	7c2080e7          	jalr	1986(ra) # 80001fd6 <argaddr>
    return -1;
    8000481c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000481e:	00054d63          	bltz	a0,80004838 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004822:	fe442603          	lw	a2,-28(s0)
    80004826:	fd843583          	ld	a1,-40(s0)
    8000482a:	fe843503          	ld	a0,-24(s0)
    8000482e:	fffff097          	auipc	ra,0xfffff
    80004832:	47c080e7          	jalr	1148(ra) # 80003caa <filewrite>
    80004836:	87aa                	mv	a5,a0
}
    80004838:	853e                	mv	a0,a5
    8000483a:	70a2                	ld	ra,40(sp)
    8000483c:	7402                	ld	s0,32(sp)
    8000483e:	6145                	addi	sp,sp,48
    80004840:	8082                	ret

0000000080004842 <sys_close>:
{
    80004842:	1101                	addi	sp,sp,-32
    80004844:	ec06                	sd	ra,24(sp)
    80004846:	e822                	sd	s0,16(sp)
    80004848:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000484a:	fe040613          	addi	a2,s0,-32
    8000484e:	fec40593          	addi	a1,s0,-20
    80004852:	4501                	li	a0,0
    80004854:	00000097          	auipc	ra,0x0
    80004858:	cbe080e7          	jalr	-834(ra) # 80004512 <argfd>
    return -1;
    8000485c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000485e:	02054463          	bltz	a0,80004886 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004862:	ffffc097          	auipc	ra,0xffffc
    80004866:	640080e7          	jalr	1600(ra) # 80000ea2 <myproc>
    8000486a:	fec42783          	lw	a5,-20(s0)
    8000486e:	07e9                	addi	a5,a5,26
    80004870:	078e                	slli	a5,a5,0x3
    80004872:	953e                	add	a0,a0,a5
    80004874:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004878:	fe043503          	ld	a0,-32(s0)
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	208080e7          	jalr	520(ra) # 80003a84 <fileclose>
  return 0;
    80004884:	4781                	li	a5,0
}
    80004886:	853e                	mv	a0,a5
    80004888:	60e2                	ld	ra,24(sp)
    8000488a:	6442                	ld	s0,16(sp)
    8000488c:	6105                	addi	sp,sp,32
    8000488e:	8082                	ret

0000000080004890 <sys_fstat>:
{
    80004890:	1101                	addi	sp,sp,-32
    80004892:	ec06                	sd	ra,24(sp)
    80004894:	e822                	sd	s0,16(sp)
    80004896:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004898:	fe840613          	addi	a2,s0,-24
    8000489c:	4581                	li	a1,0
    8000489e:	4501                	li	a0,0
    800048a0:	00000097          	auipc	ra,0x0
    800048a4:	c72080e7          	jalr	-910(ra) # 80004512 <argfd>
    return -1;
    800048a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048aa:	02054563          	bltz	a0,800048d4 <sys_fstat+0x44>
    800048ae:	fe040593          	addi	a1,s0,-32
    800048b2:	4505                	li	a0,1
    800048b4:	ffffd097          	auipc	ra,0xffffd
    800048b8:	722080e7          	jalr	1826(ra) # 80001fd6 <argaddr>
    return -1;
    800048bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800048be:	00054b63          	bltz	a0,800048d4 <sys_fstat+0x44>
  return filestat(f, st);
    800048c2:	fe043583          	ld	a1,-32(s0)
    800048c6:	fe843503          	ld	a0,-24(s0)
    800048ca:	fffff097          	auipc	ra,0xfffff
    800048ce:	298080e7          	jalr	664(ra) # 80003b62 <filestat>
    800048d2:	87aa                	mv	a5,a0
}
    800048d4:	853e                	mv	a0,a5
    800048d6:	60e2                	ld	ra,24(sp)
    800048d8:	6442                	ld	s0,16(sp)
    800048da:	6105                	addi	sp,sp,32
    800048dc:	8082                	ret

00000000800048de <sys_link>:
{
    800048de:	7169                	addi	sp,sp,-304
    800048e0:	f606                	sd	ra,296(sp)
    800048e2:	f222                	sd	s0,288(sp)
    800048e4:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e6:	08000613          	li	a2,128
    800048ea:	ed040593          	addi	a1,s0,-304
    800048ee:	4501                	li	a0,0
    800048f0:	ffffd097          	auipc	ra,0xffffd
    800048f4:	708080e7          	jalr	1800(ra) # 80001ff8 <argstr>
    return -1;
    800048f8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fa:	12054663          	bltz	a0,80004a26 <sys_link+0x148>
    800048fe:	08000613          	li	a2,128
    80004902:	f5040593          	addi	a1,s0,-176
    80004906:	4505                	li	a0,1
    80004908:	ffffd097          	auipc	ra,0xffffd
    8000490c:	6f0080e7          	jalr	1776(ra) # 80001ff8 <argstr>
    return -1;
    80004910:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004912:	10054a63          	bltz	a0,80004a26 <sys_link+0x148>
    80004916:	ee26                	sd	s1,280(sp)
  begin_op();
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	c9c080e7          	jalr	-868(ra) # 800035b4 <begin_op>
  if((ip = namei(old)) == 0){
    80004920:	ed040513          	addi	a0,s0,-304
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	a8a080e7          	jalr	-1398(ra) # 800033ae <namei>
    8000492c:	84aa                	mv	s1,a0
    8000492e:	c949                	beqz	a0,800049c0 <sys_link+0xe2>
  ilock(ip);
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	292080e7          	jalr	658(ra) # 80002bc2 <ilock>
  if(ip->type == T_DIR){
    80004938:	04449703          	lh	a4,68(s1)
    8000493c:	4785                	li	a5,1
    8000493e:	08f70863          	beq	a4,a5,800049ce <sys_link+0xf0>
    80004942:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004944:	04a4d783          	lhu	a5,74(s1)
    80004948:	2785                	addiw	a5,a5,1
    8000494a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000494e:	8526                	mv	a0,s1
    80004950:	ffffe097          	auipc	ra,0xffffe
    80004954:	1a6080e7          	jalr	422(ra) # 80002af6 <iupdate>
  iunlock(ip);
    80004958:	8526                	mv	a0,s1
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	32e080e7          	jalr	814(ra) # 80002c88 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004962:	fd040593          	addi	a1,s0,-48
    80004966:	f5040513          	addi	a0,s0,-176
    8000496a:	fffff097          	auipc	ra,0xfffff
    8000496e:	a62080e7          	jalr	-1438(ra) # 800033cc <nameiparent>
    80004972:	892a                	mv	s2,a0
    80004974:	cd35                	beqz	a0,800049f0 <sys_link+0x112>
  ilock(dp);
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	24c080e7          	jalr	588(ra) # 80002bc2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000497e:	00092703          	lw	a4,0(s2)
    80004982:	409c                	lw	a5,0(s1)
    80004984:	06f71163          	bne	a4,a5,800049e6 <sys_link+0x108>
    80004988:	40d0                	lw	a2,4(s1)
    8000498a:	fd040593          	addi	a1,s0,-48
    8000498e:	854a                	mv	a0,s2
    80004990:	fffff097          	auipc	ra,0xfffff
    80004994:	948080e7          	jalr	-1720(ra) # 800032d8 <dirlink>
    80004998:	04054763          	bltz	a0,800049e6 <sys_link+0x108>
  iunlockput(dp);
    8000499c:	854a                	mv	a0,s2
    8000499e:	ffffe097          	auipc	ra,0xffffe
    800049a2:	48a080e7          	jalr	1162(ra) # 80002e28 <iunlockput>
  iput(ip);
    800049a6:	8526                	mv	a0,s1
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	3d8080e7          	jalr	984(ra) # 80002d80 <iput>
  end_op();
    800049b0:	fffff097          	auipc	ra,0xfffff
    800049b4:	c7e080e7          	jalr	-898(ra) # 8000362e <end_op>
  return 0;
    800049b8:	4781                	li	a5,0
    800049ba:	64f2                	ld	s1,280(sp)
    800049bc:	6952                	ld	s2,272(sp)
    800049be:	a0a5                	j	80004a26 <sys_link+0x148>
    end_op();
    800049c0:	fffff097          	auipc	ra,0xfffff
    800049c4:	c6e080e7          	jalr	-914(ra) # 8000362e <end_op>
    return -1;
    800049c8:	57fd                	li	a5,-1
    800049ca:	64f2                	ld	s1,280(sp)
    800049cc:	a8a9                	j	80004a26 <sys_link+0x148>
    iunlockput(ip);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	458080e7          	jalr	1112(ra) # 80002e28 <iunlockput>
    end_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	c56080e7          	jalr	-938(ra) # 8000362e <end_op>
    return -1;
    800049e0:	57fd                	li	a5,-1
    800049e2:	64f2                	ld	s1,280(sp)
    800049e4:	a089                	j	80004a26 <sys_link+0x148>
    iunlockput(dp);
    800049e6:	854a                	mv	a0,s2
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	440080e7          	jalr	1088(ra) # 80002e28 <iunlockput>
  ilock(ip);
    800049f0:	8526                	mv	a0,s1
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	1d0080e7          	jalr	464(ra) # 80002bc2 <ilock>
  ip->nlink--;
    800049fa:	04a4d783          	lhu	a5,74(s1)
    800049fe:	37fd                	addiw	a5,a5,-1
    80004a00:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a04:	8526                	mv	a0,s1
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	0f0080e7          	jalr	240(ra) # 80002af6 <iupdate>
  iunlockput(ip);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	418080e7          	jalr	1048(ra) # 80002e28 <iunlockput>
  end_op();
    80004a18:	fffff097          	auipc	ra,0xfffff
    80004a1c:	c16080e7          	jalr	-1002(ra) # 8000362e <end_op>
  return -1;
    80004a20:	57fd                	li	a5,-1
    80004a22:	64f2                	ld	s1,280(sp)
    80004a24:	6952                	ld	s2,272(sp)
}
    80004a26:	853e                	mv	a0,a5
    80004a28:	70b2                	ld	ra,296(sp)
    80004a2a:	7412                	ld	s0,288(sp)
    80004a2c:	6155                	addi	sp,sp,304
    80004a2e:	8082                	ret

0000000080004a30 <sys_unlink>:
{
    80004a30:	7111                	addi	sp,sp,-256
    80004a32:	fd86                	sd	ra,248(sp)
    80004a34:	f9a2                	sd	s0,240(sp)
    80004a36:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004a38:	08000613          	li	a2,128
    80004a3c:	f2040593          	addi	a1,s0,-224
    80004a40:	4501                	li	a0,0
    80004a42:	ffffd097          	auipc	ra,0xffffd
    80004a46:	5b6080e7          	jalr	1462(ra) # 80001ff8 <argstr>
    80004a4a:	1c054063          	bltz	a0,80004c0a <sys_unlink+0x1da>
    80004a4e:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004a50:	fffff097          	auipc	ra,0xfffff
    80004a54:	b64080e7          	jalr	-1180(ra) # 800035b4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a58:	fa040593          	addi	a1,s0,-96
    80004a5c:	f2040513          	addi	a0,s0,-224
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	96c080e7          	jalr	-1684(ra) # 800033cc <nameiparent>
    80004a68:	84aa                	mv	s1,a0
    80004a6a:	c165                	beqz	a0,80004b4a <sys_unlink+0x11a>
  ilock(dp);
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	156080e7          	jalr	342(ra) # 80002bc2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a74:	00004597          	auipc	a1,0x4
    80004a78:	b0c58593          	addi	a1,a1,-1268 # 80008580 <etext+0x580>
    80004a7c:	fa040513          	addi	a0,s0,-96
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	618080e7          	jalr	1560(ra) # 80003098 <namecmp>
    80004a88:	16050263          	beqz	a0,80004bec <sys_unlink+0x1bc>
    80004a8c:	00004597          	auipc	a1,0x4
    80004a90:	afc58593          	addi	a1,a1,-1284 # 80008588 <etext+0x588>
    80004a94:	fa040513          	addi	a0,s0,-96
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	600080e7          	jalr	1536(ra) # 80003098 <namecmp>
    80004aa0:	14050663          	beqz	a0,80004bec <sys_unlink+0x1bc>
    80004aa4:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004aa6:	f1c40613          	addi	a2,s0,-228
    80004aaa:	fa040593          	addi	a1,s0,-96
    80004aae:	8526                	mv	a0,s1
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	602080e7          	jalr	1538(ra) # 800030b2 <dirlookup>
    80004ab8:	892a                	mv	s2,a0
    80004aba:	12050863          	beqz	a0,80004bea <sys_unlink+0x1ba>
    80004abe:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004ac0:	ffffe097          	auipc	ra,0xffffe
    80004ac4:	102080e7          	jalr	258(ra) # 80002bc2 <ilock>
  if(ip->nlink < 1)
    80004ac8:	04a91783          	lh	a5,74(s2)
    80004acc:	08f05663          	blez	a5,80004b58 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ad0:	04491703          	lh	a4,68(s2)
    80004ad4:	4785                	li	a5,1
    80004ad6:	08f70b63          	beq	a4,a5,80004b6c <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80004ada:	fb040993          	addi	s3,s0,-80
    80004ade:	4641                	li	a2,16
    80004ae0:	4581                	li	a1,0
    80004ae2:	854e                	mv	a0,s3
    80004ae4:	ffffb097          	auipc	ra,0xffffb
    80004ae8:	696080e7          	jalr	1686(ra) # 8000017a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aec:	4741                	li	a4,16
    80004aee:	f1c42683          	lw	a3,-228(s0)
    80004af2:	864e                	mv	a2,s3
    80004af4:	4581                	li	a1,0
    80004af6:	8526                	mv	a0,s1
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	480080e7          	jalr	1152(ra) # 80002f78 <writei>
    80004b00:	47c1                	li	a5,16
    80004b02:	0af51f63          	bne	a0,a5,80004bc0 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80004b06:	04491703          	lh	a4,68(s2)
    80004b0a:	4785                	li	a5,1
    80004b0c:	0cf70463          	beq	a4,a5,80004bd4 <sys_unlink+0x1a4>
  iunlockput(dp);
    80004b10:	8526                	mv	a0,s1
    80004b12:	ffffe097          	auipc	ra,0xffffe
    80004b16:	316080e7          	jalr	790(ra) # 80002e28 <iunlockput>
  ip->nlink--;
    80004b1a:	04a95783          	lhu	a5,74(s2)
    80004b1e:	37fd                	addiw	a5,a5,-1
    80004b20:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	fd0080e7          	jalr	-48(ra) # 80002af6 <iupdate>
  iunlockput(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	2f8080e7          	jalr	760(ra) # 80002e28 <iunlockput>
  end_op();
    80004b38:	fffff097          	auipc	ra,0xfffff
    80004b3c:	af6080e7          	jalr	-1290(ra) # 8000362e <end_op>
  return 0;
    80004b40:	4501                	li	a0,0
    80004b42:	74ae                	ld	s1,232(sp)
    80004b44:	790e                	ld	s2,224(sp)
    80004b46:	69ee                	ld	s3,216(sp)
    80004b48:	a86d                	j	80004c02 <sys_unlink+0x1d2>
    end_op();
    80004b4a:	fffff097          	auipc	ra,0xfffff
    80004b4e:	ae4080e7          	jalr	-1308(ra) # 8000362e <end_op>
    return -1;
    80004b52:	557d                	li	a0,-1
    80004b54:	74ae                	ld	s1,232(sp)
    80004b56:	a075                	j	80004c02 <sys_unlink+0x1d2>
    80004b58:	e9d2                	sd	s4,208(sp)
    80004b5a:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004b5c:	00004517          	auipc	a0,0x4
    80004b60:	a5450513          	addi	a0,a0,-1452 # 800085b0 <etext+0x5b0>
    80004b64:	00001097          	auipc	ra,0x1
    80004b68:	2a8080e7          	jalr	680(ra) # 80005e0c <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b6c:	04c92703          	lw	a4,76(s2)
    80004b70:	02000793          	li	a5,32
    80004b74:	f6e7f3e3          	bgeu	a5,a4,80004ada <sys_unlink+0xaa>
    80004b78:	e9d2                	sd	s4,208(sp)
    80004b7a:	e5d6                	sd	s5,200(sp)
    80004b7c:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7e:	f0840a93          	addi	s5,s0,-248
    80004b82:	4a41                	li	s4,16
    80004b84:	8752                	mv	a4,s4
    80004b86:	86ce                	mv	a3,s3
    80004b88:	8656                	mv	a2,s5
    80004b8a:	4581                	li	a1,0
    80004b8c:	854a                	mv	a0,s2
    80004b8e:	ffffe097          	auipc	ra,0xffffe
    80004b92:	2f0080e7          	jalr	752(ra) # 80002e7e <readi>
    80004b96:	01451d63          	bne	a0,s4,80004bb0 <sys_unlink+0x180>
    if(de.inum != 0)
    80004b9a:	f0845783          	lhu	a5,-248(s0)
    80004b9e:	eba5                	bnez	a5,80004c0e <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ba0:	29c1                	addiw	s3,s3,16
    80004ba2:	04c92783          	lw	a5,76(s2)
    80004ba6:	fcf9efe3          	bltu	s3,a5,80004b84 <sys_unlink+0x154>
    80004baa:	6a4e                	ld	s4,208(sp)
    80004bac:	6aae                	ld	s5,200(sp)
    80004bae:	b735                	j	80004ada <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004bb0:	00004517          	auipc	a0,0x4
    80004bb4:	a1850513          	addi	a0,a0,-1512 # 800085c8 <etext+0x5c8>
    80004bb8:	00001097          	auipc	ra,0x1
    80004bbc:	254080e7          	jalr	596(ra) # 80005e0c <panic>
    80004bc0:	e9d2                	sd	s4,208(sp)
    80004bc2:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004bc4:	00004517          	auipc	a0,0x4
    80004bc8:	a1c50513          	addi	a0,a0,-1508 # 800085e0 <etext+0x5e0>
    80004bcc:	00001097          	auipc	ra,0x1
    80004bd0:	240080e7          	jalr	576(ra) # 80005e0c <panic>
    dp->nlink--;
    80004bd4:	04a4d783          	lhu	a5,74(s1)
    80004bd8:	37fd                	addiw	a5,a5,-1
    80004bda:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bde:	8526                	mv	a0,s1
    80004be0:	ffffe097          	auipc	ra,0xffffe
    80004be4:	f16080e7          	jalr	-234(ra) # 80002af6 <iupdate>
    80004be8:	b725                	j	80004b10 <sys_unlink+0xe0>
    80004bea:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	23a080e7          	jalr	570(ra) # 80002e28 <iunlockput>
  end_op();
    80004bf6:	fffff097          	auipc	ra,0xfffff
    80004bfa:	a38080e7          	jalr	-1480(ra) # 8000362e <end_op>
  return -1;
    80004bfe:	557d                	li	a0,-1
    80004c00:	74ae                	ld	s1,232(sp)
}
    80004c02:	70ee                	ld	ra,248(sp)
    80004c04:	744e                	ld	s0,240(sp)
    80004c06:	6111                	addi	sp,sp,256
    80004c08:	8082                	ret
    return -1;
    80004c0a:	557d                	li	a0,-1
    80004c0c:	bfdd                	j	80004c02 <sys_unlink+0x1d2>
    iunlockput(ip);
    80004c0e:	854a                	mv	a0,s2
    80004c10:	ffffe097          	auipc	ra,0xffffe
    80004c14:	218080e7          	jalr	536(ra) # 80002e28 <iunlockput>
    goto bad;
    80004c18:	790e                	ld	s2,224(sp)
    80004c1a:	69ee                	ld	s3,216(sp)
    80004c1c:	6a4e                	ld	s4,208(sp)
    80004c1e:	6aae                	ld	s5,200(sp)
    80004c20:	b7f1                	j	80004bec <sys_unlink+0x1bc>

0000000080004c22 <sys_open>:

uint64
sys_open(void)
{
    80004c22:	7131                	addi	sp,sp,-192
    80004c24:	fd06                	sd	ra,184(sp)
    80004c26:	f922                	sd	s0,176(sp)
    80004c28:	f526                	sd	s1,168(sp)
    80004c2a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c2c:	08000613          	li	a2,128
    80004c30:	f5040593          	addi	a1,s0,-176
    80004c34:	4501                	li	a0,0
    80004c36:	ffffd097          	auipc	ra,0xffffd
    80004c3a:	3c2080e7          	jalr	962(ra) # 80001ff8 <argstr>
    return -1;
    80004c3e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004c40:	0c054563          	bltz	a0,80004d0a <sys_open+0xe8>
    80004c44:	f4c40593          	addi	a1,s0,-180
    80004c48:	4505                	li	a0,1
    80004c4a:	ffffd097          	auipc	ra,0xffffd
    80004c4e:	36a080e7          	jalr	874(ra) # 80001fb4 <argint>
    80004c52:	0a054c63          	bltz	a0,80004d0a <sys_open+0xe8>
    80004c56:	f14a                	sd	s2,160(sp)

  begin_op();
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	95c080e7          	jalr	-1700(ra) # 800035b4 <begin_op>

  if(omode & O_CREATE){
    80004c60:	f4c42783          	lw	a5,-180(s0)
    80004c64:	2007f793          	andi	a5,a5,512
    80004c68:	cfcd                	beqz	a5,80004d22 <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004c6a:	4681                	li	a3,0
    80004c6c:	4601                	li	a2,0
    80004c6e:	4589                	li	a1,2
    80004c70:	f5040513          	addi	a0,s0,-176
    80004c74:	00000097          	auipc	ra,0x0
    80004c78:	948080e7          	jalr	-1720(ra) # 800045bc <create>
    80004c7c:	892a                	mv	s2,a0
    if(ip == 0){
    80004c7e:	cd41                	beqz	a0,80004d16 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c80:	04491703          	lh	a4,68(s2)
    80004c84:	478d                	li	a5,3
    80004c86:	00f71763          	bne	a4,a5,80004c94 <sys_open+0x72>
    80004c8a:	04695703          	lhu	a4,70(s2)
    80004c8e:	47a5                	li	a5,9
    80004c90:	0ee7e063          	bltu	a5,a4,80004d70 <sys_open+0x14e>
    80004c94:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	d32080e7          	jalr	-718(ra) # 800039c8 <filealloc>
    80004c9e:	89aa                	mv	s3,a0
    80004ca0:	c96d                	beqz	a0,80004d92 <sys_open+0x170>
    80004ca2:	00000097          	auipc	ra,0x0
    80004ca6:	8d8080e7          	jalr	-1832(ra) # 8000457a <fdalloc>
    80004caa:	84aa                	mv	s1,a0
    80004cac:	0c054e63          	bltz	a0,80004d88 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004cb0:	04491703          	lh	a4,68(s2)
    80004cb4:	478d                	li	a5,3
    80004cb6:	0ef70b63          	beq	a4,a5,80004dac <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004cba:	4789                	li	a5,2
    80004cbc:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cc0:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cc4:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cc8:	f4c42783          	lw	a5,-180(s0)
    80004ccc:	0017f713          	andi	a4,a5,1
    80004cd0:	00174713          	xori	a4,a4,1
    80004cd4:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cd8:	0037f713          	andi	a4,a5,3
    80004cdc:	00e03733          	snez	a4,a4
    80004ce0:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ce4:	4007f793          	andi	a5,a5,1024
    80004ce8:	c791                	beqz	a5,80004cf4 <sys_open+0xd2>
    80004cea:	04491703          	lh	a4,68(s2)
    80004cee:	4789                	li	a5,2
    80004cf0:	0cf70563          	beq	a4,a5,80004dba <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004cf4:	854a                	mv	a0,s2
    80004cf6:	ffffe097          	auipc	ra,0xffffe
    80004cfa:	f92080e7          	jalr	-110(ra) # 80002c88 <iunlock>
  end_op();
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	930080e7          	jalr	-1744(ra) # 8000362e <end_op>
    80004d06:	790a                	ld	s2,160(sp)
    80004d08:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004d0a:	8526                	mv	a0,s1
    80004d0c:	70ea                	ld	ra,184(sp)
    80004d0e:	744a                	ld	s0,176(sp)
    80004d10:	74aa                	ld	s1,168(sp)
    80004d12:	6129                	addi	sp,sp,192
    80004d14:	8082                	ret
      end_op();
    80004d16:	fffff097          	auipc	ra,0xfffff
    80004d1a:	918080e7          	jalr	-1768(ra) # 8000362e <end_op>
      return -1;
    80004d1e:	790a                	ld	s2,160(sp)
    80004d20:	b7ed                	j	80004d0a <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004d22:	f5040513          	addi	a0,s0,-176
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	688080e7          	jalr	1672(ra) # 800033ae <namei>
    80004d2e:	892a                	mv	s2,a0
    80004d30:	c90d                	beqz	a0,80004d62 <sys_open+0x140>
    ilock(ip);
    80004d32:	ffffe097          	auipc	ra,0xffffe
    80004d36:	e90080e7          	jalr	-368(ra) # 80002bc2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d3a:	04491703          	lh	a4,68(s2)
    80004d3e:	4785                	li	a5,1
    80004d40:	f4f710e3          	bne	a4,a5,80004c80 <sys_open+0x5e>
    80004d44:	f4c42783          	lw	a5,-180(s0)
    80004d48:	d7b1                	beqz	a5,80004c94 <sys_open+0x72>
      iunlockput(ip);
    80004d4a:	854a                	mv	a0,s2
    80004d4c:	ffffe097          	auipc	ra,0xffffe
    80004d50:	0dc080e7          	jalr	220(ra) # 80002e28 <iunlockput>
      end_op();
    80004d54:	fffff097          	auipc	ra,0xfffff
    80004d58:	8da080e7          	jalr	-1830(ra) # 8000362e <end_op>
      return -1;
    80004d5c:	54fd                	li	s1,-1
    80004d5e:	790a                	ld	s2,160(sp)
    80004d60:	b76d                	j	80004d0a <sys_open+0xe8>
      end_op();
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	8cc080e7          	jalr	-1844(ra) # 8000362e <end_op>
      return -1;
    80004d6a:	54fd                	li	s1,-1
    80004d6c:	790a                	ld	s2,160(sp)
    80004d6e:	bf71                	j	80004d0a <sys_open+0xe8>
    iunlockput(ip);
    80004d70:	854a                	mv	a0,s2
    80004d72:	ffffe097          	auipc	ra,0xffffe
    80004d76:	0b6080e7          	jalr	182(ra) # 80002e28 <iunlockput>
    end_op();
    80004d7a:	fffff097          	auipc	ra,0xfffff
    80004d7e:	8b4080e7          	jalr	-1868(ra) # 8000362e <end_op>
    return -1;
    80004d82:	54fd                	li	s1,-1
    80004d84:	790a                	ld	s2,160(sp)
    80004d86:	b751                	j	80004d0a <sys_open+0xe8>
      fileclose(f);
    80004d88:	854e                	mv	a0,s3
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	cfa080e7          	jalr	-774(ra) # 80003a84 <fileclose>
    iunlockput(ip);
    80004d92:	854a                	mv	a0,s2
    80004d94:	ffffe097          	auipc	ra,0xffffe
    80004d98:	094080e7          	jalr	148(ra) # 80002e28 <iunlockput>
    end_op();
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	892080e7          	jalr	-1902(ra) # 8000362e <end_op>
    return -1;
    80004da4:	54fd                	li	s1,-1
    80004da6:	790a                	ld	s2,160(sp)
    80004da8:	69ea                	ld	s3,152(sp)
    80004daa:	b785                	j	80004d0a <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004dac:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004db0:	04691783          	lh	a5,70(s2)
    80004db4:	02f99223          	sh	a5,36(s3)
    80004db8:	b731                	j	80004cc4 <sys_open+0xa2>
    itrunc(ip);
    80004dba:	854a                	mv	a0,s2
    80004dbc:	ffffe097          	auipc	ra,0xffffe
    80004dc0:	f18080e7          	jalr	-232(ra) # 80002cd4 <itrunc>
    80004dc4:	bf05                	j	80004cf4 <sys_open+0xd2>

0000000080004dc6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004dc6:	7175                	addi	sp,sp,-144
    80004dc8:	e506                	sd	ra,136(sp)
    80004dca:	e122                	sd	s0,128(sp)
    80004dcc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dce:	ffffe097          	auipc	ra,0xffffe
    80004dd2:	7e6080e7          	jalr	2022(ra) # 800035b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004dd6:	08000613          	li	a2,128
    80004dda:	f7040593          	addi	a1,s0,-144
    80004dde:	4501                	li	a0,0
    80004de0:	ffffd097          	auipc	ra,0xffffd
    80004de4:	218080e7          	jalr	536(ra) # 80001ff8 <argstr>
    80004de8:	02054963          	bltz	a0,80004e1a <sys_mkdir+0x54>
    80004dec:	4681                	li	a3,0
    80004dee:	4601                	li	a2,0
    80004df0:	4585                	li	a1,1
    80004df2:	f7040513          	addi	a0,s0,-144
    80004df6:	fffff097          	auipc	ra,0xfffff
    80004dfa:	7c6080e7          	jalr	1990(ra) # 800045bc <create>
    80004dfe:	cd11                	beqz	a0,80004e1a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e00:	ffffe097          	auipc	ra,0xffffe
    80004e04:	028080e7          	jalr	40(ra) # 80002e28 <iunlockput>
  end_op();
    80004e08:	fffff097          	auipc	ra,0xfffff
    80004e0c:	826080e7          	jalr	-2010(ra) # 8000362e <end_op>
  return 0;
    80004e10:	4501                	li	a0,0
}
    80004e12:	60aa                	ld	ra,136(sp)
    80004e14:	640a                	ld	s0,128(sp)
    80004e16:	6149                	addi	sp,sp,144
    80004e18:	8082                	ret
    end_op();
    80004e1a:	fffff097          	auipc	ra,0xfffff
    80004e1e:	814080e7          	jalr	-2028(ra) # 8000362e <end_op>
    return -1;
    80004e22:	557d                	li	a0,-1
    80004e24:	b7fd                	j	80004e12 <sys_mkdir+0x4c>

0000000080004e26 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e26:	7135                	addi	sp,sp,-160
    80004e28:	ed06                	sd	ra,152(sp)
    80004e2a:	e922                	sd	s0,144(sp)
    80004e2c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e2e:	ffffe097          	auipc	ra,0xffffe
    80004e32:	786080e7          	jalr	1926(ra) # 800035b4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e36:	08000613          	li	a2,128
    80004e3a:	f7040593          	addi	a1,s0,-144
    80004e3e:	4501                	li	a0,0
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	1b8080e7          	jalr	440(ra) # 80001ff8 <argstr>
    80004e48:	04054a63          	bltz	a0,80004e9c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004e4c:	f6c40593          	addi	a1,s0,-148
    80004e50:	4505                	li	a0,1
    80004e52:	ffffd097          	auipc	ra,0xffffd
    80004e56:	162080e7          	jalr	354(ra) # 80001fb4 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e5a:	04054163          	bltz	a0,80004e9c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004e5e:	f6840593          	addi	a1,s0,-152
    80004e62:	4509                	li	a0,2
    80004e64:	ffffd097          	auipc	ra,0xffffd
    80004e68:	150080e7          	jalr	336(ra) # 80001fb4 <argint>
     argint(1, &major) < 0 ||
    80004e6c:	02054863          	bltz	a0,80004e9c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e70:	f6841683          	lh	a3,-152(s0)
    80004e74:	f6c41603          	lh	a2,-148(s0)
    80004e78:	458d                	li	a1,3
    80004e7a:	f7040513          	addi	a0,s0,-144
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	73e080e7          	jalr	1854(ra) # 800045bc <create>
     argint(2, &minor) < 0 ||
    80004e86:	c919                	beqz	a0,80004e9c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e88:	ffffe097          	auipc	ra,0xffffe
    80004e8c:	fa0080e7          	jalr	-96(ra) # 80002e28 <iunlockput>
  end_op();
    80004e90:	ffffe097          	auipc	ra,0xffffe
    80004e94:	79e080e7          	jalr	1950(ra) # 8000362e <end_op>
  return 0;
    80004e98:	4501                	li	a0,0
    80004e9a:	a031                	j	80004ea6 <sys_mknod+0x80>
    end_op();
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	792080e7          	jalr	1938(ra) # 8000362e <end_op>
    return -1;
    80004ea4:	557d                	li	a0,-1
}
    80004ea6:	60ea                	ld	ra,152(sp)
    80004ea8:	644a                	ld	s0,144(sp)
    80004eaa:	610d                	addi	sp,sp,160
    80004eac:	8082                	ret

0000000080004eae <sys_chdir>:

uint64
sys_chdir(void)
{
    80004eae:	7135                	addi	sp,sp,-160
    80004eb0:	ed06                	sd	ra,152(sp)
    80004eb2:	e922                	sd	s0,144(sp)
    80004eb4:	e14a                	sd	s2,128(sp)
    80004eb6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004eb8:	ffffc097          	auipc	ra,0xffffc
    80004ebc:	fea080e7          	jalr	-22(ra) # 80000ea2 <myproc>
    80004ec0:	892a                	mv	s2,a0
  
  begin_op();
    80004ec2:	ffffe097          	auipc	ra,0xffffe
    80004ec6:	6f2080e7          	jalr	1778(ra) # 800035b4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004eca:	08000613          	li	a2,128
    80004ece:	f6040593          	addi	a1,s0,-160
    80004ed2:	4501                	li	a0,0
    80004ed4:	ffffd097          	auipc	ra,0xffffd
    80004ed8:	124080e7          	jalr	292(ra) # 80001ff8 <argstr>
    80004edc:	04054d63          	bltz	a0,80004f36 <sys_chdir+0x88>
    80004ee0:	e526                	sd	s1,136(sp)
    80004ee2:	f6040513          	addi	a0,s0,-160
    80004ee6:	ffffe097          	auipc	ra,0xffffe
    80004eea:	4c8080e7          	jalr	1224(ra) # 800033ae <namei>
    80004eee:	84aa                	mv	s1,a0
    80004ef0:	c131                	beqz	a0,80004f34 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004ef2:	ffffe097          	auipc	ra,0xffffe
    80004ef6:	cd0080e7          	jalr	-816(ra) # 80002bc2 <ilock>
  if(ip->type != T_DIR){
    80004efa:	04449703          	lh	a4,68(s1)
    80004efe:	4785                	li	a5,1
    80004f00:	04f71163          	bne	a4,a5,80004f42 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004f04:	8526                	mv	a0,s1
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	d82080e7          	jalr	-638(ra) # 80002c88 <iunlock>
  iput(p->cwd);
    80004f0e:	15093503          	ld	a0,336(s2)
    80004f12:	ffffe097          	auipc	ra,0xffffe
    80004f16:	e6e080e7          	jalr	-402(ra) # 80002d80 <iput>
  end_op();
    80004f1a:	ffffe097          	auipc	ra,0xffffe
    80004f1e:	714080e7          	jalr	1812(ra) # 8000362e <end_op>
  p->cwd = ip;
    80004f22:	14993823          	sd	s1,336(s2)
  return 0;
    80004f26:	4501                	li	a0,0
    80004f28:	64aa                	ld	s1,136(sp)
}
    80004f2a:	60ea                	ld	ra,152(sp)
    80004f2c:	644a                	ld	s0,144(sp)
    80004f2e:	690a                	ld	s2,128(sp)
    80004f30:	610d                	addi	sp,sp,160
    80004f32:	8082                	ret
    80004f34:	64aa                	ld	s1,136(sp)
    end_op();
    80004f36:	ffffe097          	auipc	ra,0xffffe
    80004f3a:	6f8080e7          	jalr	1784(ra) # 8000362e <end_op>
    return -1;
    80004f3e:	557d                	li	a0,-1
    80004f40:	b7ed                	j	80004f2a <sys_chdir+0x7c>
    iunlockput(ip);
    80004f42:	8526                	mv	a0,s1
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	ee4080e7          	jalr	-284(ra) # 80002e28 <iunlockput>
    end_op();
    80004f4c:	ffffe097          	auipc	ra,0xffffe
    80004f50:	6e2080e7          	jalr	1762(ra) # 8000362e <end_op>
    return -1;
    80004f54:	557d                	li	a0,-1
    80004f56:	64aa                	ld	s1,136(sp)
    80004f58:	bfc9                	j	80004f2a <sys_chdir+0x7c>

0000000080004f5a <sys_exec>:

uint64
sys_exec(void)
{
    80004f5a:	7105                	addi	sp,sp,-480
    80004f5c:	ef86                	sd	ra,472(sp)
    80004f5e:	eba2                	sd	s0,464(sp)
    80004f60:	e3ca                	sd	s2,448(sp)
    80004f62:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f64:	08000613          	li	a2,128
    80004f68:	f3040593          	addi	a1,s0,-208
    80004f6c:	4501                	li	a0,0
    80004f6e:	ffffd097          	auipc	ra,0xffffd
    80004f72:	08a080e7          	jalr	138(ra) # 80001ff8 <argstr>
    return -1;
    80004f76:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80004f78:	10054963          	bltz	a0,8000508a <sys_exec+0x130>
    80004f7c:	e2840593          	addi	a1,s0,-472
    80004f80:	4505                	li	a0,1
    80004f82:	ffffd097          	auipc	ra,0xffffd
    80004f86:	054080e7          	jalr	84(ra) # 80001fd6 <argaddr>
    80004f8a:	10054063          	bltz	a0,8000508a <sys_exec+0x130>
    80004f8e:	e7a6                	sd	s1,456(sp)
    80004f90:	ff4e                	sd	s3,440(sp)
    80004f92:	fb52                	sd	s4,432(sp)
    80004f94:	f756                	sd	s5,424(sp)
    80004f96:	f35a                	sd	s6,416(sp)
    80004f98:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004f9a:	e3040a13          	addi	s4,s0,-464
    80004f9e:	10000613          	li	a2,256
    80004fa2:	4581                	li	a1,0
    80004fa4:	8552                	mv	a0,s4
    80004fa6:	ffffb097          	auipc	ra,0xffffb
    80004faa:	1d4080e7          	jalr	468(ra) # 8000017a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004fae:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004fb0:	89d2                	mv	s3,s4
    80004fb2:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fb4:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fb8:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004fba:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004fbe:	00391513          	slli	a0,s2,0x3
    80004fc2:	85d6                	mv	a1,s5
    80004fc4:	e2843783          	ld	a5,-472(s0)
    80004fc8:	953e                	add	a0,a0,a5
    80004fca:	ffffd097          	auipc	ra,0xffffd
    80004fce:	f50080e7          	jalr	-176(ra) # 80001f1a <fetchaddr>
    80004fd2:	02054a63          	bltz	a0,80005006 <sys_exec+0xac>
    if(uarg == 0){
    80004fd6:	e2043783          	ld	a5,-480(s0)
    80004fda:	cba9                	beqz	a5,8000502c <sys_exec+0xd2>
    argv[i] = kalloc();
    80004fdc:	ffffb097          	auipc	ra,0xffffb
    80004fe0:	13e080e7          	jalr	318(ra) # 8000011a <kalloc>
    80004fe4:	85aa                	mv	a1,a0
    80004fe6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fea:	cd11                	beqz	a0,80005006 <sys_exec+0xac>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fec:	865a                	mv	a2,s6
    80004fee:	e2043503          	ld	a0,-480(s0)
    80004ff2:	ffffd097          	auipc	ra,0xffffd
    80004ff6:	f7a080e7          	jalr	-134(ra) # 80001f6c <fetchstr>
    80004ffa:	00054663          	bltz	a0,80005006 <sys_exec+0xac>
    if(i >= NELEM(argv)){
    80004ffe:	0905                	addi	s2,s2,1
    80005000:	09a1                	addi	s3,s3,8
    80005002:	fb791ee3          	bne	s2,s7,80004fbe <sys_exec+0x64>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005006:	100a0a13          	addi	s4,s4,256
    8000500a:	6088                	ld	a0,0(s1)
    8000500c:	c925                	beqz	a0,8000507c <sys_exec+0x122>
    kfree(argv[i]);
    8000500e:	ffffb097          	auipc	ra,0xffffb
    80005012:	00e080e7          	jalr	14(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005016:	04a1                	addi	s1,s1,8
    80005018:	ff4499e3          	bne	s1,s4,8000500a <sys_exec+0xb0>
  return -1;
    8000501c:	597d                	li	s2,-1
    8000501e:	64be                	ld	s1,456(sp)
    80005020:	79fa                	ld	s3,440(sp)
    80005022:	7a5a                	ld	s4,432(sp)
    80005024:	7aba                	ld	s5,424(sp)
    80005026:	7b1a                	ld	s6,416(sp)
    80005028:	6bfa                	ld	s7,408(sp)
    8000502a:	a085                	j	8000508a <sys_exec+0x130>
      argv[i] = 0;
    8000502c:	0009079b          	sext.w	a5,s2
    80005030:	e3040593          	addi	a1,s0,-464
    80005034:	078e                	slli	a5,a5,0x3
    80005036:	97ae                	add	a5,a5,a1
    80005038:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    8000503c:	f3040513          	addi	a0,s0,-208
    80005040:	fffff097          	auipc	ra,0xfffff
    80005044:	122080e7          	jalr	290(ra) # 80004162 <exec>
    80005048:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000504a:	100a0a13          	addi	s4,s4,256
    8000504e:	6088                	ld	a0,0(s1)
    80005050:	cd19                	beqz	a0,8000506e <sys_exec+0x114>
    kfree(argv[i]);
    80005052:	ffffb097          	auipc	ra,0xffffb
    80005056:	fca080e7          	jalr	-54(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000505a:	04a1                	addi	s1,s1,8
    8000505c:	ff4499e3          	bne	s1,s4,8000504e <sys_exec+0xf4>
    80005060:	64be                	ld	s1,456(sp)
    80005062:	79fa                	ld	s3,440(sp)
    80005064:	7a5a                	ld	s4,432(sp)
    80005066:	7aba                	ld	s5,424(sp)
    80005068:	7b1a                	ld	s6,416(sp)
    8000506a:	6bfa                	ld	s7,408(sp)
    8000506c:	a839                	j	8000508a <sys_exec+0x130>
  return ret;
    8000506e:	64be                	ld	s1,456(sp)
    80005070:	79fa                	ld	s3,440(sp)
    80005072:	7a5a                	ld	s4,432(sp)
    80005074:	7aba                	ld	s5,424(sp)
    80005076:	7b1a                	ld	s6,416(sp)
    80005078:	6bfa                	ld	s7,408(sp)
    8000507a:	a801                	j	8000508a <sys_exec+0x130>
  return -1;
    8000507c:	597d                	li	s2,-1
    8000507e:	64be                	ld	s1,456(sp)
    80005080:	79fa                	ld	s3,440(sp)
    80005082:	7a5a                	ld	s4,432(sp)
    80005084:	7aba                	ld	s5,424(sp)
    80005086:	7b1a                	ld	s6,416(sp)
    80005088:	6bfa                	ld	s7,408(sp)
}
    8000508a:	854a                	mv	a0,s2
    8000508c:	60fe                	ld	ra,472(sp)
    8000508e:	645e                	ld	s0,464(sp)
    80005090:	691e                	ld	s2,448(sp)
    80005092:	613d                	addi	sp,sp,480
    80005094:	8082                	ret

0000000080005096 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005096:	7139                	addi	sp,sp,-64
    80005098:	fc06                	sd	ra,56(sp)
    8000509a:	f822                	sd	s0,48(sp)
    8000509c:	f426                	sd	s1,40(sp)
    8000509e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800050a0:	ffffc097          	auipc	ra,0xffffc
    800050a4:	e02080e7          	jalr	-510(ra) # 80000ea2 <myproc>
    800050a8:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800050aa:	fd840593          	addi	a1,s0,-40
    800050ae:	4501                	li	a0,0
    800050b0:	ffffd097          	auipc	ra,0xffffd
    800050b4:	f26080e7          	jalr	-218(ra) # 80001fd6 <argaddr>
    return -1;
    800050b8:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800050ba:	0e054063          	bltz	a0,8000519a <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800050be:	fc840593          	addi	a1,s0,-56
    800050c2:	fd040513          	addi	a0,s0,-48
    800050c6:	fffff097          	auipc	ra,0xfffff
    800050ca:	d32080e7          	jalr	-718(ra) # 80003df8 <pipealloc>
    return -1;
    800050ce:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800050d0:	0c054563          	bltz	a0,8000519a <sys_pipe+0x104>
  fd0 = -1;
    800050d4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800050d8:	fd043503          	ld	a0,-48(s0)
    800050dc:	fffff097          	auipc	ra,0xfffff
    800050e0:	49e080e7          	jalr	1182(ra) # 8000457a <fdalloc>
    800050e4:	fca42223          	sw	a0,-60(s0)
    800050e8:	08054c63          	bltz	a0,80005180 <sys_pipe+0xea>
    800050ec:	fc843503          	ld	a0,-56(s0)
    800050f0:	fffff097          	auipc	ra,0xfffff
    800050f4:	48a080e7          	jalr	1162(ra) # 8000457a <fdalloc>
    800050f8:	fca42023          	sw	a0,-64(s0)
    800050fc:	06054963          	bltz	a0,8000516e <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005100:	4691                	li	a3,4
    80005102:	fc440613          	addi	a2,s0,-60
    80005106:	fd843583          	ld	a1,-40(s0)
    8000510a:	68a8                	ld	a0,80(s1)
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	a42080e7          	jalr	-1470(ra) # 80000b4e <copyout>
    80005114:	02054063          	bltz	a0,80005134 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005118:	4691                	li	a3,4
    8000511a:	fc040613          	addi	a2,s0,-64
    8000511e:	fd843583          	ld	a1,-40(s0)
    80005122:	95b6                	add	a1,a1,a3
    80005124:	68a8                	ld	a0,80(s1)
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	a28080e7          	jalr	-1496(ra) # 80000b4e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000512e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005130:	06055563          	bgez	a0,8000519a <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005134:	fc442783          	lw	a5,-60(s0)
    80005138:	07e9                	addi	a5,a5,26
    8000513a:	078e                	slli	a5,a5,0x3
    8000513c:	97a6                	add	a5,a5,s1
    8000513e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005142:	fc042783          	lw	a5,-64(s0)
    80005146:	07e9                	addi	a5,a5,26
    80005148:	078e                	slli	a5,a5,0x3
    8000514a:	00f48533          	add	a0,s1,a5
    8000514e:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005152:	fd043503          	ld	a0,-48(s0)
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	92e080e7          	jalr	-1746(ra) # 80003a84 <fileclose>
    fileclose(wf);
    8000515e:	fc843503          	ld	a0,-56(s0)
    80005162:	fffff097          	auipc	ra,0xfffff
    80005166:	922080e7          	jalr	-1758(ra) # 80003a84 <fileclose>
    return -1;
    8000516a:	57fd                	li	a5,-1
    8000516c:	a03d                	j	8000519a <sys_pipe+0x104>
    if(fd0 >= 0)
    8000516e:	fc442783          	lw	a5,-60(s0)
    80005172:	0007c763          	bltz	a5,80005180 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005176:	07e9                	addi	a5,a5,26
    80005178:	078e                	slli	a5,a5,0x3
    8000517a:	97a6                	add	a5,a5,s1
    8000517c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005180:	fd043503          	ld	a0,-48(s0)
    80005184:	fffff097          	auipc	ra,0xfffff
    80005188:	900080e7          	jalr	-1792(ra) # 80003a84 <fileclose>
    fileclose(wf);
    8000518c:	fc843503          	ld	a0,-56(s0)
    80005190:	fffff097          	auipc	ra,0xfffff
    80005194:	8f4080e7          	jalr	-1804(ra) # 80003a84 <fileclose>
    return -1;
    80005198:	57fd                	li	a5,-1
}
    8000519a:	853e                	mv	a0,a5
    8000519c:	70e2                	ld	ra,56(sp)
    8000519e:	7442                	ld	s0,48(sp)
    800051a0:	74a2                	ld	s1,40(sp)
    800051a2:	6121                	addi	sp,sp,64
    800051a4:	8082                	ret
	...

00000000800051b0 <kernelvec>:
    800051b0:	7111                	addi	sp,sp,-256
    800051b2:	e006                	sd	ra,0(sp)
    800051b4:	e40a                	sd	sp,8(sp)
    800051b6:	e80e                	sd	gp,16(sp)
    800051b8:	ec12                	sd	tp,24(sp)
    800051ba:	f016                	sd	t0,32(sp)
    800051bc:	f41a                	sd	t1,40(sp)
    800051be:	f81e                	sd	t2,48(sp)
    800051c0:	fc22                	sd	s0,56(sp)
    800051c2:	e0a6                	sd	s1,64(sp)
    800051c4:	e4aa                	sd	a0,72(sp)
    800051c6:	e8ae                	sd	a1,80(sp)
    800051c8:	ecb2                	sd	a2,88(sp)
    800051ca:	f0b6                	sd	a3,96(sp)
    800051cc:	f4ba                	sd	a4,104(sp)
    800051ce:	f8be                	sd	a5,112(sp)
    800051d0:	fcc2                	sd	a6,120(sp)
    800051d2:	e146                	sd	a7,128(sp)
    800051d4:	e54a                	sd	s2,136(sp)
    800051d6:	e94e                	sd	s3,144(sp)
    800051d8:	ed52                	sd	s4,152(sp)
    800051da:	f156                	sd	s5,160(sp)
    800051dc:	f55a                	sd	s6,168(sp)
    800051de:	f95e                	sd	s7,176(sp)
    800051e0:	fd62                	sd	s8,184(sp)
    800051e2:	e1e6                	sd	s9,192(sp)
    800051e4:	e5ea                	sd	s10,200(sp)
    800051e6:	e9ee                	sd	s11,208(sp)
    800051e8:	edf2                	sd	t3,216(sp)
    800051ea:	f1f6                	sd	t4,224(sp)
    800051ec:	f5fa                	sd	t5,232(sp)
    800051ee:	f9fe                	sd	t6,240(sp)
    800051f0:	bf7fc0ef          	jal	80001de6 <kerneltrap>
    800051f4:	6082                	ld	ra,0(sp)
    800051f6:	6122                	ld	sp,8(sp)
    800051f8:	61c2                	ld	gp,16(sp)
    800051fa:	7282                	ld	t0,32(sp)
    800051fc:	7322                	ld	t1,40(sp)
    800051fe:	73c2                	ld	t2,48(sp)
    80005200:	7462                	ld	s0,56(sp)
    80005202:	6486                	ld	s1,64(sp)
    80005204:	6526                	ld	a0,72(sp)
    80005206:	65c6                	ld	a1,80(sp)
    80005208:	6666                	ld	a2,88(sp)
    8000520a:	7686                	ld	a3,96(sp)
    8000520c:	7726                	ld	a4,104(sp)
    8000520e:	77c6                	ld	a5,112(sp)
    80005210:	7866                	ld	a6,120(sp)
    80005212:	688a                	ld	a7,128(sp)
    80005214:	692a                	ld	s2,136(sp)
    80005216:	69ca                	ld	s3,144(sp)
    80005218:	6a6a                	ld	s4,152(sp)
    8000521a:	7a8a                	ld	s5,160(sp)
    8000521c:	7b2a                	ld	s6,168(sp)
    8000521e:	7bca                	ld	s7,176(sp)
    80005220:	7c6a                	ld	s8,184(sp)
    80005222:	6c8e                	ld	s9,192(sp)
    80005224:	6d2e                	ld	s10,200(sp)
    80005226:	6dce                	ld	s11,208(sp)
    80005228:	6e6e                	ld	t3,216(sp)
    8000522a:	7e8e                	ld	t4,224(sp)
    8000522c:	7f2e                	ld	t5,232(sp)
    8000522e:	7fce                	ld	t6,240(sp)
    80005230:	6111                	addi	sp,sp,256
    80005232:	10200073          	sret
    80005236:	00000013          	nop
    8000523a:	00000013          	nop
    8000523e:	0001                	nop

0000000080005240 <timervec>:
    80005240:	34051573          	csrrw	a0,mscratch,a0
    80005244:	e10c                	sd	a1,0(a0)
    80005246:	e510                	sd	a2,8(a0)
    80005248:	e914                	sd	a3,16(a0)
    8000524a:	6d0c                	ld	a1,24(a0)
    8000524c:	7110                	ld	a2,32(a0)
    8000524e:	6194                	ld	a3,0(a1)
    80005250:	96b2                	add	a3,a3,a2
    80005252:	e194                	sd	a3,0(a1)
    80005254:	4589                	li	a1,2
    80005256:	14459073          	csrw	sip,a1
    8000525a:	6914                	ld	a3,16(a0)
    8000525c:	6510                	ld	a2,8(a0)
    8000525e:	610c                	ld	a1,0(a0)
    80005260:	34051573          	csrrw	a0,mscratch,a0
    80005264:	30200073          	mret
	...

000000008000526a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000526a:	1141                	addi	sp,sp,-16
    8000526c:	e406                	sd	ra,8(sp)
    8000526e:	e022                	sd	s0,0(sp)
    80005270:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005272:	0c000737          	lui	a4,0xc000
    80005276:	4785                	li	a5,1
    80005278:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000527a:	c35c                	sw	a5,4(a4)
}
    8000527c:	60a2                	ld	ra,8(sp)
    8000527e:	6402                	ld	s0,0(sp)
    80005280:	0141                	addi	sp,sp,16
    80005282:	8082                	ret

0000000080005284 <plicinithart>:

void
plicinithart(void)
{
    80005284:	1141                	addi	sp,sp,-16
    80005286:	e406                	sd	ra,8(sp)
    80005288:	e022                	sd	s0,0(sp)
    8000528a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000528c:	ffffc097          	auipc	ra,0xffffc
    80005290:	be2080e7          	jalr	-1054(ra) # 80000e6e <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005294:	0085171b          	slliw	a4,a0,0x8
    80005298:	0c0027b7          	lui	a5,0xc002
    8000529c:	97ba                	add	a5,a5,a4
    8000529e:	40200713          	li	a4,1026
    800052a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800052a6:	00d5151b          	slliw	a0,a0,0xd
    800052aa:	0c2017b7          	lui	a5,0xc201
    800052ae:	97aa                	add	a5,a5,a0
    800052b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800052b4:	60a2                	ld	ra,8(sp)
    800052b6:	6402                	ld	s0,0(sp)
    800052b8:	0141                	addi	sp,sp,16
    800052ba:	8082                	ret

00000000800052bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800052bc:	1141                	addi	sp,sp,-16
    800052be:	e406                	sd	ra,8(sp)
    800052c0:	e022                	sd	s0,0(sp)
    800052c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800052c4:	ffffc097          	auipc	ra,0xffffc
    800052c8:	baa080e7          	jalr	-1110(ra) # 80000e6e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800052cc:	00d5151b          	slliw	a0,a0,0xd
    800052d0:	0c2017b7          	lui	a5,0xc201
    800052d4:	97aa                	add	a5,a5,a0
  return irq;
}
    800052d6:	43c8                	lw	a0,4(a5)
    800052d8:	60a2                	ld	ra,8(sp)
    800052da:	6402                	ld	s0,0(sp)
    800052dc:	0141                	addi	sp,sp,16
    800052de:	8082                	ret

00000000800052e0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800052e0:	1101                	addi	sp,sp,-32
    800052e2:	ec06                	sd	ra,24(sp)
    800052e4:	e822                	sd	s0,16(sp)
    800052e6:	e426                	sd	s1,8(sp)
    800052e8:	1000                	addi	s0,sp,32
    800052ea:	84aa                	mv	s1,a0
  int hart = cpuid();
    800052ec:	ffffc097          	auipc	ra,0xffffc
    800052f0:	b82080e7          	jalr	-1150(ra) # 80000e6e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800052f4:	00d5179b          	slliw	a5,a0,0xd
    800052f8:	0c201737          	lui	a4,0xc201
    800052fc:	97ba                	add	a5,a5,a4
    800052fe:	c3c4                	sw	s1,4(a5)
}
    80005300:	60e2                	ld	ra,24(sp)
    80005302:	6442                	ld	s0,16(sp)
    80005304:	64a2                	ld	s1,8(sp)
    80005306:	6105                	addi	sp,sp,32
    80005308:	8082                	ret

000000008000530a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000530a:	1141                	addi	sp,sp,-16
    8000530c:	e406                	sd	ra,8(sp)
    8000530e:	e022                	sd	s0,0(sp)
    80005310:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005312:	479d                	li	a5,7
    80005314:	06a7c863          	blt	a5,a0,80005384 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005318:	00016717          	auipc	a4,0x16
    8000531c:	ce870713          	addi	a4,a4,-792 # 8001b000 <disk>
    80005320:	972a                	add	a4,a4,a0
    80005322:	6789                	lui	a5,0x2
    80005324:	97ba                	add	a5,a5,a4
    80005326:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000532a:	e7ad                	bnez	a5,80005394 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000532c:	00451793          	slli	a5,a0,0x4
    80005330:	00018717          	auipc	a4,0x18
    80005334:	cd070713          	addi	a4,a4,-816 # 8001d000 <disk+0x2000>
    80005338:	6314                	ld	a3,0(a4)
    8000533a:	96be                	add	a3,a3,a5
    8000533c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005340:	6314                	ld	a3,0(a4)
    80005342:	96be                	add	a3,a3,a5
    80005344:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005348:	6314                	ld	a3,0(a4)
    8000534a:	96be                	add	a3,a3,a5
    8000534c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005350:	6318                	ld	a4,0(a4)
    80005352:	97ba                	add	a5,a5,a4
    80005354:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005358:	00016717          	auipc	a4,0x16
    8000535c:	ca870713          	addi	a4,a4,-856 # 8001b000 <disk>
    80005360:	972a                	add	a4,a4,a0
    80005362:	6789                	lui	a5,0x2
    80005364:	97ba                	add	a5,a5,a4
    80005366:	4705                	li	a4,1
    80005368:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    8000536c:	00018517          	auipc	a0,0x18
    80005370:	cac50513          	addi	a0,a0,-852 # 8001d018 <disk+0x2018>
    80005374:	ffffc097          	auipc	ra,0xffffc
    80005378:	386080e7          	jalr	902(ra) # 800016fa <wakeup>
}
    8000537c:	60a2                	ld	ra,8(sp)
    8000537e:	6402                	ld	s0,0(sp)
    80005380:	0141                	addi	sp,sp,16
    80005382:	8082                	ret
    panic("free_desc 1");
    80005384:	00003517          	auipc	a0,0x3
    80005388:	26c50513          	addi	a0,a0,620 # 800085f0 <etext+0x5f0>
    8000538c:	00001097          	auipc	ra,0x1
    80005390:	a80080e7          	jalr	-1408(ra) # 80005e0c <panic>
    panic("free_desc 2");
    80005394:	00003517          	auipc	a0,0x3
    80005398:	26c50513          	addi	a0,a0,620 # 80008600 <etext+0x600>
    8000539c:	00001097          	auipc	ra,0x1
    800053a0:	a70080e7          	jalr	-1424(ra) # 80005e0c <panic>

00000000800053a4 <virtio_disk_init>:
{
    800053a4:	1141                	addi	sp,sp,-16
    800053a6:	e406                	sd	ra,8(sp)
    800053a8:	e022                	sd	s0,0(sp)
    800053aa:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800053ac:	00003597          	auipc	a1,0x3
    800053b0:	26458593          	addi	a1,a1,612 # 80008610 <etext+0x610>
    800053b4:	00018517          	auipc	a0,0x18
    800053b8:	d7450513          	addi	a0,a0,-652 # 8001d128 <disk+0x2128>
    800053bc:	00001097          	auipc	ra,0x1
    800053c0:	f12080e7          	jalr	-238(ra) # 800062ce <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053c4:	100017b7          	lui	a5,0x10001
    800053c8:	4398                	lw	a4,0(a5)
    800053ca:	2701                	sext.w	a4,a4
    800053cc:	747277b7          	lui	a5,0x74727
    800053d0:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800053d4:	0ef71563          	bne	a4,a5,800054be <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053d8:	100017b7          	lui	a5,0x10001
    800053dc:	43dc                	lw	a5,4(a5)
    800053de:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800053e0:	4705                	li	a4,1
    800053e2:	0ce79e63          	bne	a5,a4,800054be <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053e6:	100017b7          	lui	a5,0x10001
    800053ea:	479c                	lw	a5,8(a5)
    800053ec:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    800053ee:	4709                	li	a4,2
    800053f0:	0ce79763          	bne	a5,a4,800054be <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800053f4:	100017b7          	lui	a5,0x10001
    800053f8:	47d8                	lw	a4,12(a5)
    800053fa:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800053fc:	554d47b7          	lui	a5,0x554d4
    80005400:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005404:	0af71d63          	bne	a4,a5,800054be <virtio_disk_init+0x11a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005408:	100017b7          	lui	a5,0x10001
    8000540c:	4705                	li	a4,1
    8000540e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005410:	470d                	li	a4,3
    80005412:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005414:	10001737          	lui	a4,0x10001
    80005418:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000541a:	c7ffe6b7          	lui	a3,0xc7ffe
    8000541e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005422:	8f75                	and	a4,a4,a3
    80005424:	100016b7          	lui	a3,0x10001
    80005428:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542a:	472d                	li	a4,11
    8000542c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000542e:	473d                	li	a4,15
    80005430:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005432:	6705                	lui	a4,0x1
    80005434:	d698                	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005436:	0206a823          	sw	zero,48(a3) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000543a:	5adc                	lw	a5,52(a3)
    8000543c:	2781                	sext.w	a5,a5
  if(max == 0)
    8000543e:	cbc1                	beqz	a5,800054ce <virtio_disk_init+0x12a>
  if(max < NUM)
    80005440:	471d                	li	a4,7
    80005442:	08f77e63          	bgeu	a4,a5,800054de <virtio_disk_init+0x13a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005446:	100017b7          	lui	a5,0x10001
    8000544a:	4721                	li	a4,8
    8000544c:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    8000544e:	6609                	lui	a2,0x2
    80005450:	4581                	li	a1,0
    80005452:	00016517          	auipc	a0,0x16
    80005456:	bae50513          	addi	a0,a0,-1106 # 8001b000 <disk>
    8000545a:	ffffb097          	auipc	ra,0xffffb
    8000545e:	d20080e7          	jalr	-736(ra) # 8000017a <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005462:	00016717          	auipc	a4,0x16
    80005466:	b9e70713          	addi	a4,a4,-1122 # 8001b000 <disk>
    8000546a:	00c75793          	srli	a5,a4,0xc
    8000546e:	2781                	sext.w	a5,a5
    80005470:	100016b7          	lui	a3,0x10001
    80005474:	c2bc                	sw	a5,64(a3)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005476:	00018797          	auipc	a5,0x18
    8000547a:	b8a78793          	addi	a5,a5,-1142 # 8001d000 <disk+0x2000>
    8000547e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005480:	00016717          	auipc	a4,0x16
    80005484:	c0070713          	addi	a4,a4,-1024 # 8001b080 <disk+0x80>
    80005488:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000548a:	00017717          	auipc	a4,0x17
    8000548e:	b7670713          	addi	a4,a4,-1162 # 8001c000 <disk+0x1000>
    80005492:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005494:	4705                	li	a4,1
    80005496:	00e78c23          	sb	a4,24(a5)
    8000549a:	00e78ca3          	sb	a4,25(a5)
    8000549e:	00e78d23          	sb	a4,26(a5)
    800054a2:	00e78da3          	sb	a4,27(a5)
    800054a6:	00e78e23          	sb	a4,28(a5)
    800054aa:	00e78ea3          	sb	a4,29(a5)
    800054ae:	00e78f23          	sb	a4,30(a5)
    800054b2:	00e78fa3          	sb	a4,31(a5)
}
    800054b6:	60a2                	ld	ra,8(sp)
    800054b8:	6402                	ld	s0,0(sp)
    800054ba:	0141                	addi	sp,sp,16
    800054bc:	8082                	ret
    panic("could not find virtio disk");
    800054be:	00003517          	auipc	a0,0x3
    800054c2:	16250513          	addi	a0,a0,354 # 80008620 <etext+0x620>
    800054c6:	00001097          	auipc	ra,0x1
    800054ca:	946080e7          	jalr	-1722(ra) # 80005e0c <panic>
    panic("virtio disk has no queue 0");
    800054ce:	00003517          	auipc	a0,0x3
    800054d2:	17250513          	addi	a0,a0,370 # 80008640 <etext+0x640>
    800054d6:	00001097          	auipc	ra,0x1
    800054da:	936080e7          	jalr	-1738(ra) # 80005e0c <panic>
    panic("virtio disk max queue too short");
    800054de:	00003517          	auipc	a0,0x3
    800054e2:	18250513          	addi	a0,a0,386 # 80008660 <etext+0x660>
    800054e6:	00001097          	auipc	ra,0x1
    800054ea:	926080e7          	jalr	-1754(ra) # 80005e0c <panic>

00000000800054ee <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800054ee:	711d                	addi	sp,sp,-96
    800054f0:	ec86                	sd	ra,88(sp)
    800054f2:	e8a2                	sd	s0,80(sp)
    800054f4:	e4a6                	sd	s1,72(sp)
    800054f6:	e0ca                	sd	s2,64(sp)
    800054f8:	fc4e                	sd	s3,56(sp)
    800054fa:	f852                	sd	s4,48(sp)
    800054fc:	f456                	sd	s5,40(sp)
    800054fe:	f05a                	sd	s6,32(sp)
    80005500:	ec5e                	sd	s7,24(sp)
    80005502:	e862                	sd	s8,16(sp)
    80005504:	1080                	addi	s0,sp,96
    80005506:	89aa                	mv	s3,a0
    80005508:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000550a:	00c52b83          	lw	s7,12(a0)
    8000550e:	001b9b9b          	slliw	s7,s7,0x1
    80005512:	1b82                	slli	s7,s7,0x20
    80005514:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80005518:	00018517          	auipc	a0,0x18
    8000551c:	c1050513          	addi	a0,a0,-1008 # 8001d128 <disk+0x2128>
    80005520:	00001097          	auipc	ra,0x1
    80005524:	e42080e7          	jalr	-446(ra) # 80006362 <acquire>
  for(int i = 0; i < NUM; i++){
    80005528:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000552a:	00016b17          	auipc	s6,0x16
    8000552e:	ad6b0b13          	addi	s6,s6,-1322 # 8001b000 <disk>
    80005532:	6a89                	lui	s5,0x2
  for(int i = 0; i < 3; i++){
    80005534:	4a0d                	li	s4,3
    80005536:	a88d                	j	800055a8 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005538:	00fb0733          	add	a4,s6,a5
    8000553c:	9756                	add	a4,a4,s5
    8000553e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005542:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005544:	0207c563          	bltz	a5,8000556e <virtio_disk_rw+0x80>
  for(int i = 0; i < 3; i++){
    80005548:	2905                	addiw	s2,s2,1
    8000554a:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    8000554c:	1b490063          	beq	s2,s4,800056ec <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    80005550:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005552:	00018717          	auipc	a4,0x18
    80005556:	ac670713          	addi	a4,a4,-1338 # 8001d018 <disk+0x2018>
    8000555a:	4781                	li	a5,0
    if(disk.free[i]){
    8000555c:	00074683          	lbu	a3,0(a4)
    80005560:	fee1                	bnez	a3,80005538 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    80005562:	2785                	addiw	a5,a5,1
    80005564:	0705                	addi	a4,a4,1
    80005566:	fe979be3          	bne	a5,s1,8000555c <virtio_disk_rw+0x6e>
    idx[i] = alloc_desc();
    8000556a:	57fd                	li	a5,-1
    8000556c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000556e:	03205163          	blez	s2,80005590 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005572:	fa042503          	lw	a0,-96(s0)
    80005576:	00000097          	auipc	ra,0x0
    8000557a:	d94080e7          	jalr	-620(ra) # 8000530a <free_desc>
      for(int j = 0; j < i; j++)
    8000557e:	4785                	li	a5,1
    80005580:	0127d863          	bge	a5,s2,80005590 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005584:	fa442503          	lw	a0,-92(s0)
    80005588:	00000097          	auipc	ra,0x0
    8000558c:	d82080e7          	jalr	-638(ra) # 8000530a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005590:	00018597          	auipc	a1,0x18
    80005594:	b9858593          	addi	a1,a1,-1128 # 8001d128 <disk+0x2128>
    80005598:	00018517          	auipc	a0,0x18
    8000559c:	a8050513          	addi	a0,a0,-1408 # 8001d018 <disk+0x2018>
    800055a0:	ffffc097          	auipc	ra,0xffffc
    800055a4:	fd4080e7          	jalr	-44(ra) # 80001574 <sleep>
  for(int i = 0; i < 3; i++){
    800055a8:	fa040613          	addi	a2,s0,-96
    800055ac:	4901                	li	s2,0
    800055ae:	b74d                	j	80005550 <virtio_disk_rw+0x62>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055b0:	00018717          	auipc	a4,0x18
    800055b4:	a5073703          	ld	a4,-1456(a4) # 8001d000 <disk+0x2000>
    800055b8:	973e                	add	a4,a4,a5
    800055ba:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055be:	00016897          	auipc	a7,0x16
    800055c2:	a4288893          	addi	a7,a7,-1470 # 8001b000 <disk>
    800055c6:	00018717          	auipc	a4,0x18
    800055ca:	a3a70713          	addi	a4,a4,-1478 # 8001d000 <disk+0x2000>
    800055ce:	6314                	ld	a3,0(a4)
    800055d0:	96be                	add	a3,a3,a5
    800055d2:	00c6d583          	lhu	a1,12(a3) # 1000100c <_entry-0x6fffeff4>
    800055d6:	0015e593          	ori	a1,a1,1
    800055da:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    800055de:	fa842683          	lw	a3,-88(s0)
    800055e2:	630c                	ld	a1,0(a4)
    800055e4:	97ae                	add	a5,a5,a1
    800055e6:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055ea:	20050593          	addi	a1,a0,512
    800055ee:	0592                	slli	a1,a1,0x4
    800055f0:	95c6                	add	a1,a1,a7
    800055f2:	57fd                	li	a5,-1
    800055f4:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055f8:	00469793          	slli	a5,a3,0x4
    800055fc:	00073803          	ld	a6,0(a4)
    80005600:	983e                	add	a6,a6,a5
    80005602:	6689                	lui	a3,0x2
    80005604:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005608:	96b2                	add	a3,a3,a2
    8000560a:	96c6                	add	a3,a3,a7
    8000560c:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005610:	6314                	ld	a3,0(a4)
    80005612:	96be                	add	a3,a3,a5
    80005614:	4605                	li	a2,1
    80005616:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005618:	6314                	ld	a3,0(a4)
    8000561a:	96be                	add	a3,a3,a5
    8000561c:	4809                	li	a6,2
    8000561e:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    80005622:	6314                	ld	a3,0(a4)
    80005624:	97b6                	add	a5,a5,a3
    80005626:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000562a:	00c9a223          	sw	a2,4(s3)
  disk.info[idx[0]].b = b;
    8000562e:	0335b423          	sd	s3,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005632:	6714                	ld	a3,8(a4)
    80005634:	0026d783          	lhu	a5,2(a3)
    80005638:	8b9d                	andi	a5,a5,7
    8000563a:	0786                	slli	a5,a5,0x1
    8000563c:	96be                	add	a3,a3,a5
    8000563e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005642:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005646:	6718                	ld	a4,8(a4)
    80005648:	00275783          	lhu	a5,2(a4)
    8000564c:	2785                	addiw	a5,a5,1
    8000564e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005652:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005656:	100017b7          	lui	a5,0x10001
    8000565a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000565e:	0049a783          	lw	a5,4(s3)
    80005662:	02c79163          	bne	a5,a2,80005684 <virtio_disk_rw+0x196>
    sleep(b, &disk.vdisk_lock);
    80005666:	00018917          	auipc	s2,0x18
    8000566a:	ac290913          	addi	s2,s2,-1342 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000566e:	84b2                	mv	s1,a2
    sleep(b, &disk.vdisk_lock);
    80005670:	85ca                	mv	a1,s2
    80005672:	854e                	mv	a0,s3
    80005674:	ffffc097          	auipc	ra,0xffffc
    80005678:	f00080e7          	jalr	-256(ra) # 80001574 <sleep>
  while(b->disk == 1) {
    8000567c:	0049a783          	lw	a5,4(s3)
    80005680:	fe9788e3          	beq	a5,s1,80005670 <virtio_disk_rw+0x182>
  }

  disk.info[idx[0]].b = 0;
    80005684:	fa042903          	lw	s2,-96(s0)
    80005688:	20090713          	addi	a4,s2,512
    8000568c:	0712                	slli	a4,a4,0x4
    8000568e:	00016797          	auipc	a5,0x16
    80005692:	97278793          	addi	a5,a5,-1678 # 8001b000 <disk>
    80005696:	97ba                	add	a5,a5,a4
    80005698:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000569c:	00018997          	auipc	s3,0x18
    800056a0:	96498993          	addi	s3,s3,-1692 # 8001d000 <disk+0x2000>
    800056a4:	00491713          	slli	a4,s2,0x4
    800056a8:	0009b783          	ld	a5,0(s3)
    800056ac:	97ba                	add	a5,a5,a4
    800056ae:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056b2:	854a                	mv	a0,s2
    800056b4:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056b8:	00000097          	auipc	ra,0x0
    800056bc:	c52080e7          	jalr	-942(ra) # 8000530a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056c0:	8885                	andi	s1,s1,1
    800056c2:	f0ed                	bnez	s1,800056a4 <virtio_disk_rw+0x1b6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056c4:	00018517          	auipc	a0,0x18
    800056c8:	a6450513          	addi	a0,a0,-1436 # 8001d128 <disk+0x2128>
    800056cc:	00001097          	auipc	ra,0x1
    800056d0:	d46080e7          	jalr	-698(ra) # 80006412 <release>
}
    800056d4:	60e6                	ld	ra,88(sp)
    800056d6:	6446                	ld	s0,80(sp)
    800056d8:	64a6                	ld	s1,72(sp)
    800056da:	6906                	ld	s2,64(sp)
    800056dc:	79e2                	ld	s3,56(sp)
    800056de:	7a42                	ld	s4,48(sp)
    800056e0:	7aa2                	ld	s5,40(sp)
    800056e2:	7b02                	ld	s6,32(sp)
    800056e4:	6be2                	ld	s7,24(sp)
    800056e6:	6c42                	ld	s8,16(sp)
    800056e8:	6125                	addi	sp,sp,96
    800056ea:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056ec:	fa042503          	lw	a0,-96(s0)
    800056f0:	00451613          	slli	a2,a0,0x4
  if(write)
    800056f4:	00016597          	auipc	a1,0x16
    800056f8:	90c58593          	addi	a1,a1,-1780 # 8001b000 <disk>
    800056fc:	20050793          	addi	a5,a0,512
    80005700:	0792                	slli	a5,a5,0x4
    80005702:	97ae                	add	a5,a5,a1
    80005704:	01803733          	snez	a4,s8
    80005708:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    8000570c:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    80005710:	0b77b823          	sd	s7,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005714:	00018717          	auipc	a4,0x18
    80005718:	8ec70713          	addi	a4,a4,-1812 # 8001d000 <disk+0x2000>
    8000571c:	6314                	ld	a3,0(a4)
    8000571e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005720:	6789                	lui	a5,0x2
    80005722:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005726:	97b2                	add	a5,a5,a2
    80005728:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000572a:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000572c:	631c                	ld	a5,0(a4)
    8000572e:	97b2                	add	a5,a5,a2
    80005730:	46c1                	li	a3,16
    80005732:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005734:	631c                	ld	a5,0(a4)
    80005736:	97b2                	add	a5,a5,a2
    80005738:	4685                	li	a3,1
    8000573a:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    8000573e:	fa442783          	lw	a5,-92(s0)
    80005742:	6314                	ld	a3,0(a4)
    80005744:	96b2                	add	a3,a3,a2
    80005746:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000574a:	0792                	slli	a5,a5,0x4
    8000574c:	6314                	ld	a3,0(a4)
    8000574e:	96be                	add	a3,a3,a5
    80005750:	05898593          	addi	a1,s3,88
    80005754:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80005756:	6318                	ld	a4,0(a4)
    80005758:	973e                	add	a4,a4,a5
    8000575a:	40000693          	li	a3,1024
    8000575e:	c714                	sw	a3,8(a4)
  if(write)
    80005760:	e40c18e3          	bnez	s8,800055b0 <virtio_disk_rw+0xc2>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005764:	00018717          	auipc	a4,0x18
    80005768:	89c73703          	ld	a4,-1892(a4) # 8001d000 <disk+0x2000>
    8000576c:	973e                	add	a4,a4,a5
    8000576e:	4689                	li	a3,2
    80005770:	00d71623          	sh	a3,12(a4)
    80005774:	b5a9                	j	800055be <virtio_disk_rw+0xd0>

0000000080005776 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005776:	1101                	addi	sp,sp,-32
    80005778:	ec06                	sd	ra,24(sp)
    8000577a:	e822                	sd	s0,16(sp)
    8000577c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000577e:	00018517          	auipc	a0,0x18
    80005782:	9aa50513          	addi	a0,a0,-1622 # 8001d128 <disk+0x2128>
    80005786:	00001097          	auipc	ra,0x1
    8000578a:	bdc080e7          	jalr	-1060(ra) # 80006362 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000578e:	100017b7          	lui	a5,0x10001
    80005792:	53bc                	lw	a5,96(a5)
    80005794:	8b8d                	andi	a5,a5,3
    80005796:	10001737          	lui	a4,0x10001
    8000579a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000579c:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057a0:	00018797          	auipc	a5,0x18
    800057a4:	86078793          	addi	a5,a5,-1952 # 8001d000 <disk+0x2000>
    800057a8:	6b94                	ld	a3,16(a5)
    800057aa:	0207d703          	lhu	a4,32(a5)
    800057ae:	0026d783          	lhu	a5,2(a3)
    800057b2:	06f70563          	beq	a4,a5,8000581c <virtio_disk_intr+0xa6>
    800057b6:	e426                	sd	s1,8(sp)
    800057b8:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ba:	00016917          	auipc	s2,0x16
    800057be:	84690913          	addi	s2,s2,-1978 # 8001b000 <disk>
    800057c2:	00018497          	auipc	s1,0x18
    800057c6:	83e48493          	addi	s1,s1,-1986 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    800057ca:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057ce:	6898                	ld	a4,16(s1)
    800057d0:	0204d783          	lhu	a5,32(s1)
    800057d4:	8b9d                	andi	a5,a5,7
    800057d6:	078e                	slli	a5,a5,0x3
    800057d8:	97ba                	add	a5,a5,a4
    800057da:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057dc:	20078713          	addi	a4,a5,512
    800057e0:	0712                	slli	a4,a4,0x4
    800057e2:	974a                	add	a4,a4,s2
    800057e4:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    800057e8:	e731                	bnez	a4,80005834 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800057ea:	20078793          	addi	a5,a5,512
    800057ee:	0792                	slli	a5,a5,0x4
    800057f0:	97ca                	add	a5,a5,s2
    800057f2:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    800057f4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800057f8:	ffffc097          	auipc	ra,0xffffc
    800057fc:	f02080e7          	jalr	-254(ra) # 800016fa <wakeup>

    disk.used_idx += 1;
    80005800:	0204d783          	lhu	a5,32(s1)
    80005804:	2785                	addiw	a5,a5,1
    80005806:	17c2                	slli	a5,a5,0x30
    80005808:	93c1                	srli	a5,a5,0x30
    8000580a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000580e:	6898                	ld	a4,16(s1)
    80005810:	00275703          	lhu	a4,2(a4)
    80005814:	faf71be3          	bne	a4,a5,800057ca <virtio_disk_intr+0x54>
    80005818:	64a2                	ld	s1,8(sp)
    8000581a:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    8000581c:	00018517          	auipc	a0,0x18
    80005820:	90c50513          	addi	a0,a0,-1780 # 8001d128 <disk+0x2128>
    80005824:	00001097          	auipc	ra,0x1
    80005828:	bee080e7          	jalr	-1042(ra) # 80006412 <release>
}
    8000582c:	60e2                	ld	ra,24(sp)
    8000582e:	6442                	ld	s0,16(sp)
    80005830:	6105                	addi	sp,sp,32
    80005832:	8082                	ret
      panic("virtio_disk_intr status");
    80005834:	00003517          	auipc	a0,0x3
    80005838:	e4c50513          	addi	a0,a0,-436 # 80008680 <etext+0x680>
    8000583c:	00000097          	auipc	ra,0x0
    80005840:	5d0080e7          	jalr	1488(ra) # 80005e0c <panic>

0000000080005844 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005844:	1141                	addi	sp,sp,-16
    80005846:	e406                	sd	ra,8(sp)
    80005848:	e022                	sd	s0,0(sp)
    8000584a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000584c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005850:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005852:	0037961b          	slliw	a2,a5,0x3
    80005856:	02004737          	lui	a4,0x2004
    8000585a:	963a                	add	a2,a2,a4
    8000585c:	0200c737          	lui	a4,0x200c
    80005860:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005864:	000f46b7          	lui	a3,0xf4
    80005868:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    8000586c:	9736                	add	a4,a4,a3
    8000586e:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005870:	00279713          	slli	a4,a5,0x2
    80005874:	973e                	add	a4,a4,a5
    80005876:	070e                	slli	a4,a4,0x3
    80005878:	00018797          	auipc	a5,0x18
    8000587c:	78878793          	addi	a5,a5,1928 # 8001e000 <timer_scratch>
    80005880:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    80005882:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    80005884:	f394                	sd	a3,32(a5)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005886:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000588a:	00000797          	auipc	a5,0x0
    8000588e:	9b678793          	addi	a5,a5,-1610 # 80005240 <timervec>
    80005892:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005896:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000589a:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000589e:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058a2:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058a6:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058aa:	30479073          	csrw	mie,a5
}
    800058ae:	60a2                	ld	ra,8(sp)
    800058b0:	6402                	ld	s0,0(sp)
    800058b2:	0141                	addi	sp,sp,16
    800058b4:	8082                	ret

00000000800058b6 <start>:
{
    800058b6:	1141                	addi	sp,sp,-16
    800058b8:	e406                	sd	ra,8(sp)
    800058ba:	e022                	sd	s0,0(sp)
    800058bc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058be:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058c2:	7779                	lui	a4,0xffffe
    800058c4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    800058c8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058ca:	6705                	lui	a4,0x1
    800058cc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058d6:	ffffb797          	auipc	a5,0xffffb
    800058da:	a5e78793          	addi	a5,a5,-1442 # 80000334 <main>
    800058de:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058e2:	4781                	li	a5,0
    800058e4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058e8:	67c1                	lui	a5,0x10
    800058ea:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800058ec:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800058f0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800058f4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800058f8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800058fc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005900:	57fd                	li	a5,-1
    80005902:	83a9                	srli	a5,a5,0xa
    80005904:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005908:	47bd                	li	a5,15
    8000590a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000590e:	00000097          	auipc	ra,0x0
    80005912:	f36080e7          	jalr	-202(ra) # 80005844 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005916:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000591a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000591c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000591e:	30200073          	mret
}
    80005922:	60a2                	ld	ra,8(sp)
    80005924:	6402                	ld	s0,0(sp)
    80005926:	0141                	addi	sp,sp,16
    80005928:	8082                	ret

000000008000592a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000592a:	711d                	addi	sp,sp,-96
    8000592c:	ec86                	sd	ra,88(sp)
    8000592e:	e8a2                	sd	s0,80(sp)
    80005930:	e0ca                	sd	s2,64(sp)
    80005932:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80005934:	04c05c63          	blez	a2,8000598c <consolewrite+0x62>
    80005938:	e4a6                	sd	s1,72(sp)
    8000593a:	fc4e                	sd	s3,56(sp)
    8000593c:	f852                	sd	s4,48(sp)
    8000593e:	f456                	sd	s5,40(sp)
    80005940:	f05a                	sd	s6,32(sp)
    80005942:	ec5e                	sd	s7,24(sp)
    80005944:	8a2a                	mv	s4,a0
    80005946:	84ae                	mv	s1,a1
    80005948:	89b2                	mv	s3,a2
    8000594a:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000594c:	faf40b93          	addi	s7,s0,-81
    80005950:	4b05                	li	s6,1
    80005952:	5afd                	li	s5,-1
    80005954:	86da                	mv	a3,s6
    80005956:	8626                	mv	a2,s1
    80005958:	85d2                	mv	a1,s4
    8000595a:	855e                	mv	a0,s7
    8000595c:	ffffc097          	auipc	ra,0xffffc
    80005960:	00c080e7          	jalr	12(ra) # 80001968 <either_copyin>
    80005964:	03550663          	beq	a0,s5,80005990 <consolewrite+0x66>
      break;
    uartputc(c);
    80005968:	faf44503          	lbu	a0,-81(s0)
    8000596c:	00001097          	auipc	ra,0x1
    80005970:	834080e7          	jalr	-1996(ra) # 800061a0 <uartputc>
  for(i = 0; i < n; i++){
    80005974:	2905                	addiw	s2,s2,1
    80005976:	0485                	addi	s1,s1,1
    80005978:	fd299ee3          	bne	s3,s2,80005954 <consolewrite+0x2a>
    8000597c:	894e                	mv	s2,s3
    8000597e:	64a6                	ld	s1,72(sp)
    80005980:	79e2                	ld	s3,56(sp)
    80005982:	7a42                	ld	s4,48(sp)
    80005984:	7aa2                	ld	s5,40(sp)
    80005986:	7b02                	ld	s6,32(sp)
    80005988:	6be2                	ld	s7,24(sp)
    8000598a:	a809                	j	8000599c <consolewrite+0x72>
    8000598c:	4901                	li	s2,0
    8000598e:	a039                	j	8000599c <consolewrite+0x72>
    80005990:	64a6                	ld	s1,72(sp)
    80005992:	79e2                	ld	s3,56(sp)
    80005994:	7a42                	ld	s4,48(sp)
    80005996:	7aa2                	ld	s5,40(sp)
    80005998:	7b02                	ld	s6,32(sp)
    8000599a:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    8000599c:	854a                	mv	a0,s2
    8000599e:	60e6                	ld	ra,88(sp)
    800059a0:	6446                	ld	s0,80(sp)
    800059a2:	6906                	ld	s2,64(sp)
    800059a4:	6125                	addi	sp,sp,96
    800059a6:	8082                	ret

00000000800059a8 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059a8:	711d                	addi	sp,sp,-96
    800059aa:	ec86                	sd	ra,88(sp)
    800059ac:	e8a2                	sd	s0,80(sp)
    800059ae:	e4a6                	sd	s1,72(sp)
    800059b0:	e0ca                	sd	s2,64(sp)
    800059b2:	fc4e                	sd	s3,56(sp)
    800059b4:	f852                	sd	s4,48(sp)
    800059b6:	f456                	sd	s5,40(sp)
    800059b8:	f05a                	sd	s6,32(sp)
    800059ba:	1080                	addi	s0,sp,96
    800059bc:	8aaa                	mv	s5,a0
    800059be:	8a2e                	mv	s4,a1
    800059c0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059c2:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    800059c4:	00020517          	auipc	a0,0x20
    800059c8:	77c50513          	addi	a0,a0,1916 # 80026140 <cons>
    800059cc:	00001097          	auipc	ra,0x1
    800059d0:	996080e7          	jalr	-1642(ra) # 80006362 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059d4:	00020497          	auipc	s1,0x20
    800059d8:	76c48493          	addi	s1,s1,1900 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059dc:	00020917          	auipc	s2,0x20
    800059e0:	7fc90913          	addi	s2,s2,2044 # 800261d8 <cons+0x98>
  while(n > 0){
    800059e4:	0d305263          	blez	s3,80005aa8 <consoleread+0x100>
    while(cons.r == cons.w){
    800059e8:	0984a783          	lw	a5,152(s1)
    800059ec:	09c4a703          	lw	a4,156(s1)
    800059f0:	0af71763          	bne	a4,a5,80005a9e <consoleread+0xf6>
      if(myproc()->killed){
    800059f4:	ffffb097          	auipc	ra,0xffffb
    800059f8:	4ae080e7          	jalr	1198(ra) # 80000ea2 <myproc>
    800059fc:	551c                	lw	a5,40(a0)
    800059fe:	e7ad                	bnez	a5,80005a68 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80005a00:	85a6                	mv	a1,s1
    80005a02:	854a                	mv	a0,s2
    80005a04:	ffffc097          	auipc	ra,0xffffc
    80005a08:	b70080e7          	jalr	-1168(ra) # 80001574 <sleep>
    while(cons.r == cons.w){
    80005a0c:	0984a783          	lw	a5,152(s1)
    80005a10:	09c4a703          	lw	a4,156(s1)
    80005a14:	fef700e3          	beq	a4,a5,800059f4 <consoleread+0x4c>
    80005a18:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005a1a:	00020717          	auipc	a4,0x20
    80005a1e:	72670713          	addi	a4,a4,1830 # 80026140 <cons>
    80005a22:	0017869b          	addiw	a3,a5,1
    80005a26:	08d72c23          	sw	a3,152(a4)
    80005a2a:	07f7f693          	andi	a3,a5,127
    80005a2e:	9736                	add	a4,a4,a3
    80005a30:	01874703          	lbu	a4,24(a4)
    80005a34:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005a38:	4691                	li	a3,4
    80005a3a:	04db8a63          	beq	s7,a3,80005a8e <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005a3e:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a42:	4685                	li	a3,1
    80005a44:	faf40613          	addi	a2,s0,-81
    80005a48:	85d2                	mv	a1,s4
    80005a4a:	8556                	mv	a0,s5
    80005a4c:	ffffc097          	auipc	ra,0xffffc
    80005a50:	ec6080e7          	jalr	-314(ra) # 80001912 <either_copyout>
    80005a54:	57fd                	li	a5,-1
    80005a56:	04f50863          	beq	a0,a5,80005aa6 <consoleread+0xfe>
      break;

    dst++;
    80005a5a:	0a05                	addi	s4,s4,1
    --n;
    80005a5c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005a5e:	47a9                	li	a5,10
    80005a60:	04fb8f63          	beq	s7,a5,80005abe <consoleread+0x116>
    80005a64:	6be2                	ld	s7,24(sp)
    80005a66:	bfbd                	j	800059e4 <consoleread+0x3c>
        release(&cons.lock);
    80005a68:	00020517          	auipc	a0,0x20
    80005a6c:	6d850513          	addi	a0,a0,1752 # 80026140 <cons>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	9a2080e7          	jalr	-1630(ra) # 80006412 <release>
        return -1;
    80005a78:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005a7a:	60e6                	ld	ra,88(sp)
    80005a7c:	6446                	ld	s0,80(sp)
    80005a7e:	64a6                	ld	s1,72(sp)
    80005a80:	6906                	ld	s2,64(sp)
    80005a82:	79e2                	ld	s3,56(sp)
    80005a84:	7a42                	ld	s4,48(sp)
    80005a86:	7aa2                	ld	s5,40(sp)
    80005a88:	7b02                	ld	s6,32(sp)
    80005a8a:	6125                	addi	sp,sp,96
    80005a8c:	8082                	ret
      if(n < target){
    80005a8e:	0169fa63          	bgeu	s3,s6,80005aa2 <consoleread+0xfa>
        cons.r--;
    80005a92:	00020717          	auipc	a4,0x20
    80005a96:	74f72323          	sw	a5,1862(a4) # 800261d8 <cons+0x98>
    80005a9a:	6be2                	ld	s7,24(sp)
    80005a9c:	a031                	j	80005aa8 <consoleread+0x100>
    80005a9e:	ec5e                	sd	s7,24(sp)
    80005aa0:	bfad                	j	80005a1a <consoleread+0x72>
    80005aa2:	6be2                	ld	s7,24(sp)
    80005aa4:	a011                	j	80005aa8 <consoleread+0x100>
    80005aa6:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005aa8:	00020517          	auipc	a0,0x20
    80005aac:	69850513          	addi	a0,a0,1688 # 80026140 <cons>
    80005ab0:	00001097          	auipc	ra,0x1
    80005ab4:	962080e7          	jalr	-1694(ra) # 80006412 <release>
  return target - n;
    80005ab8:	413b053b          	subw	a0,s6,s3
    80005abc:	bf7d                	j	80005a7a <consoleread+0xd2>
    80005abe:	6be2                	ld	s7,24(sp)
    80005ac0:	b7e5                	j	80005aa8 <consoleread+0x100>

0000000080005ac2 <consputc>:
{
    80005ac2:	1141                	addi	sp,sp,-16
    80005ac4:	e406                	sd	ra,8(sp)
    80005ac6:	e022                	sd	s0,0(sp)
    80005ac8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005aca:	10000793          	li	a5,256
    80005ace:	00f50a63          	beq	a0,a5,80005ae2 <consputc+0x20>
    uartputc_sync(c);
    80005ad2:	00000097          	auipc	ra,0x0
    80005ad6:	5f0080e7          	jalr	1520(ra) # 800060c2 <uartputc_sync>
}
    80005ada:	60a2                	ld	ra,8(sp)
    80005adc:	6402                	ld	s0,0(sp)
    80005ade:	0141                	addi	sp,sp,16
    80005ae0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ae2:	4521                	li	a0,8
    80005ae4:	00000097          	auipc	ra,0x0
    80005ae8:	5de080e7          	jalr	1502(ra) # 800060c2 <uartputc_sync>
    80005aec:	02000513          	li	a0,32
    80005af0:	00000097          	auipc	ra,0x0
    80005af4:	5d2080e7          	jalr	1490(ra) # 800060c2 <uartputc_sync>
    80005af8:	4521                	li	a0,8
    80005afa:	00000097          	auipc	ra,0x0
    80005afe:	5c8080e7          	jalr	1480(ra) # 800060c2 <uartputc_sync>
    80005b02:	bfe1                	j	80005ada <consputc+0x18>

0000000080005b04 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b04:	7179                	addi	sp,sp,-48
    80005b06:	f406                	sd	ra,40(sp)
    80005b08:	f022                	sd	s0,32(sp)
    80005b0a:	ec26                	sd	s1,24(sp)
    80005b0c:	1800                	addi	s0,sp,48
    80005b0e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b10:	00020517          	auipc	a0,0x20
    80005b14:	63050513          	addi	a0,a0,1584 # 80026140 <cons>
    80005b18:	00001097          	auipc	ra,0x1
    80005b1c:	84a080e7          	jalr	-1974(ra) # 80006362 <acquire>

  switch(c){
    80005b20:	47d5                	li	a5,21
    80005b22:	0af48463          	beq	s1,a5,80005bca <consoleintr+0xc6>
    80005b26:	0297c963          	blt	a5,s1,80005b58 <consoleintr+0x54>
    80005b2a:	47a1                	li	a5,8
    80005b2c:	10f48063          	beq	s1,a5,80005c2c <consoleintr+0x128>
    80005b30:	47c1                	li	a5,16
    80005b32:	12f49363          	bne	s1,a5,80005c58 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80005b36:	ffffc097          	auipc	ra,0xffffc
    80005b3a:	e88080e7          	jalr	-376(ra) # 800019be <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b3e:	00020517          	auipc	a0,0x20
    80005b42:	60250513          	addi	a0,a0,1538 # 80026140 <cons>
    80005b46:	00001097          	auipc	ra,0x1
    80005b4a:	8cc080e7          	jalr	-1844(ra) # 80006412 <release>
}
    80005b4e:	70a2                	ld	ra,40(sp)
    80005b50:	7402                	ld	s0,32(sp)
    80005b52:	64e2                	ld	s1,24(sp)
    80005b54:	6145                	addi	sp,sp,48
    80005b56:	8082                	ret
  switch(c){
    80005b58:	07f00793          	li	a5,127
    80005b5c:	0cf48863          	beq	s1,a5,80005c2c <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005b60:	00020717          	auipc	a4,0x20
    80005b64:	5e070713          	addi	a4,a4,1504 # 80026140 <cons>
    80005b68:	0a072783          	lw	a5,160(a4)
    80005b6c:	09872703          	lw	a4,152(a4)
    80005b70:	9f99                	subw	a5,a5,a4
    80005b72:	07f00713          	li	a4,127
    80005b76:	fcf764e3          	bltu	a4,a5,80005b3e <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005b7a:	47b5                	li	a5,13
    80005b7c:	0ef48163          	beq	s1,a5,80005c5e <consoleintr+0x15a>
      consputc(c);
    80005b80:	8526                	mv	a0,s1
    80005b82:	00000097          	auipc	ra,0x0
    80005b86:	f40080e7          	jalr	-192(ra) # 80005ac2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005b8a:	00020797          	auipc	a5,0x20
    80005b8e:	5b678793          	addi	a5,a5,1462 # 80026140 <cons>
    80005b92:	0a07a703          	lw	a4,160(a5)
    80005b96:	0017069b          	addiw	a3,a4,1
    80005b9a:	8636                	mv	a2,a3
    80005b9c:	0ad7a023          	sw	a3,160(a5)
    80005ba0:	07f77713          	andi	a4,a4,127
    80005ba4:	97ba                	add	a5,a5,a4
    80005ba6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005baa:	47a9                	li	a5,10
    80005bac:	0cf48f63          	beq	s1,a5,80005c8a <consoleintr+0x186>
    80005bb0:	4791                	li	a5,4
    80005bb2:	0cf48c63          	beq	s1,a5,80005c8a <consoleintr+0x186>
    80005bb6:	00020797          	auipc	a5,0x20
    80005bba:	6227a783          	lw	a5,1570(a5) # 800261d8 <cons+0x98>
    80005bbe:	0807879b          	addiw	a5,a5,128
    80005bc2:	f6f69ee3          	bne	a3,a5,80005b3e <consoleintr+0x3a>
    80005bc6:	863e                	mv	a2,a5
    80005bc8:	a0c9                	j	80005c8a <consoleintr+0x186>
    80005bca:	e84a                	sd	s2,16(sp)
    80005bcc:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005bce:	00020717          	auipc	a4,0x20
    80005bd2:	57270713          	addi	a4,a4,1394 # 80026140 <cons>
    80005bd6:	0a072783          	lw	a5,160(a4)
    80005bda:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bde:	00020497          	auipc	s1,0x20
    80005be2:	56248493          	addi	s1,s1,1378 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005be6:	4929                	li	s2,10
      consputc(BACKSPACE);
    80005be8:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005bec:	02f70a63          	beq	a4,a5,80005c20 <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005bf0:	37fd                	addiw	a5,a5,-1
    80005bf2:	07f7f713          	andi	a4,a5,127
    80005bf6:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bf8:	01874703          	lbu	a4,24(a4)
    80005bfc:	03270563          	beq	a4,s2,80005c26 <consoleintr+0x122>
      cons.e--;
    80005c00:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c04:	854e                	mv	a0,s3
    80005c06:	00000097          	auipc	ra,0x0
    80005c0a:	ebc080e7          	jalr	-324(ra) # 80005ac2 <consputc>
    while(cons.e != cons.w &&
    80005c0e:	0a04a783          	lw	a5,160(s1)
    80005c12:	09c4a703          	lw	a4,156(s1)
    80005c16:	fcf71de3          	bne	a4,a5,80005bf0 <consoleintr+0xec>
    80005c1a:	6942                	ld	s2,16(sp)
    80005c1c:	69a2                	ld	s3,8(sp)
    80005c1e:	b705                	j	80005b3e <consoleintr+0x3a>
    80005c20:	6942                	ld	s2,16(sp)
    80005c22:	69a2                	ld	s3,8(sp)
    80005c24:	bf29                	j	80005b3e <consoleintr+0x3a>
    80005c26:	6942                	ld	s2,16(sp)
    80005c28:	69a2                	ld	s3,8(sp)
    80005c2a:	bf11                	j	80005b3e <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005c2c:	00020717          	auipc	a4,0x20
    80005c30:	51470713          	addi	a4,a4,1300 # 80026140 <cons>
    80005c34:	0a072783          	lw	a5,160(a4)
    80005c38:	09c72703          	lw	a4,156(a4)
    80005c3c:	f0f701e3          	beq	a4,a5,80005b3e <consoleintr+0x3a>
      cons.e--;
    80005c40:	37fd                	addiw	a5,a5,-1
    80005c42:	00020717          	auipc	a4,0x20
    80005c46:	58f72f23          	sw	a5,1438(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c4a:	10000513          	li	a0,256
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	e74080e7          	jalr	-396(ra) # 80005ac2 <consputc>
    80005c56:	b5e5                	j	80005b3e <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005c58:	ee0483e3          	beqz	s1,80005b3e <consoleintr+0x3a>
    80005c5c:	b711                	j	80005b60 <consoleintr+0x5c>
      consputc(c);
    80005c5e:	4529                	li	a0,10
    80005c60:	00000097          	auipc	ra,0x0
    80005c64:	e62080e7          	jalr	-414(ra) # 80005ac2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005c68:	00020797          	auipc	a5,0x20
    80005c6c:	4d878793          	addi	a5,a5,1240 # 80026140 <cons>
    80005c70:	0a07a703          	lw	a4,160(a5)
    80005c74:	0017069b          	addiw	a3,a4,1
    80005c78:	8636                	mv	a2,a3
    80005c7a:	0ad7a023          	sw	a3,160(a5)
    80005c7e:	07f77713          	andi	a4,a4,127
    80005c82:	97ba                	add	a5,a5,a4
    80005c84:	4729                	li	a4,10
    80005c86:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c8a:	00020797          	auipc	a5,0x20
    80005c8e:	54c7a923          	sw	a2,1362(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005c92:	00020517          	auipc	a0,0x20
    80005c96:	54650513          	addi	a0,a0,1350 # 800261d8 <cons+0x98>
    80005c9a:	ffffc097          	auipc	ra,0xffffc
    80005c9e:	a60080e7          	jalr	-1440(ra) # 800016fa <wakeup>
    80005ca2:	bd71                	j	80005b3e <consoleintr+0x3a>

0000000080005ca4 <consoleinit>:

void
consoleinit(void)
{
    80005ca4:	1141                	addi	sp,sp,-16
    80005ca6:	e406                	sd	ra,8(sp)
    80005ca8:	e022                	sd	s0,0(sp)
    80005caa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005cac:	00003597          	auipc	a1,0x3
    80005cb0:	9ec58593          	addi	a1,a1,-1556 # 80008698 <etext+0x698>
    80005cb4:	00020517          	auipc	a0,0x20
    80005cb8:	48c50513          	addi	a0,a0,1164 # 80026140 <cons>
    80005cbc:	00000097          	auipc	ra,0x0
    80005cc0:	612080e7          	jalr	1554(ra) # 800062ce <initlock>

  uartinit();
    80005cc4:	00000097          	auipc	ra,0x0
    80005cc8:	3a4080e7          	jalr	932(ra) # 80006068 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ccc:	00014797          	auipc	a5,0x14
    80005cd0:	bfc78793          	addi	a5,a5,-1028 # 800198c8 <devsw>
    80005cd4:	00000717          	auipc	a4,0x0
    80005cd8:	cd470713          	addi	a4,a4,-812 # 800059a8 <consoleread>
    80005cdc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cde:	00000717          	auipc	a4,0x0
    80005ce2:	c4c70713          	addi	a4,a4,-948 # 8000592a <consolewrite>
    80005ce6:	ef98                	sd	a4,24(a5)
}
    80005ce8:	60a2                	ld	ra,8(sp)
    80005cea:	6402                	ld	s0,0(sp)
    80005cec:	0141                	addi	sp,sp,16
    80005cee:	8082                	ret

0000000080005cf0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005cf0:	7179                	addi	sp,sp,-48
    80005cf2:	f406                	sd	ra,40(sp)
    80005cf4:	f022                	sd	s0,32(sp)
    80005cf6:	ec26                	sd	s1,24(sp)
    80005cf8:	e84a                	sd	s2,16(sp)
    80005cfa:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cfc:	c219                	beqz	a2,80005d02 <printint+0x12>
    80005cfe:	06054e63          	bltz	a0,80005d7a <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005d02:	4e01                	li	t3,0

  i = 0;
    80005d04:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005d08:	869a                	mv	a3,t1
  i = 0;
    80005d0a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005d0c:	00003817          	auipc	a6,0x3
    80005d10:	b0480813          	addi	a6,a6,-1276 # 80008810 <digits>
    80005d14:	88be                	mv	a7,a5
    80005d16:	0017861b          	addiw	a2,a5,1
    80005d1a:	87b2                	mv	a5,a2
    80005d1c:	02b5773b          	remuw	a4,a0,a1
    80005d20:	1702                	slli	a4,a4,0x20
    80005d22:	9301                	srli	a4,a4,0x20
    80005d24:	9742                	add	a4,a4,a6
    80005d26:	00074703          	lbu	a4,0(a4)
    80005d2a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005d2e:	872a                	mv	a4,a0
    80005d30:	02b5553b          	divuw	a0,a0,a1
    80005d34:	0685                	addi	a3,a3,1
    80005d36:	fcb77fe3          	bgeu	a4,a1,80005d14 <printint+0x24>

  if(sign)
    80005d3a:	000e0c63          	beqz	t3,80005d52 <printint+0x62>
    buf[i++] = '-';
    80005d3e:	fe060793          	addi	a5,a2,-32
    80005d42:	00878633          	add	a2,a5,s0
    80005d46:	02d00793          	li	a5,45
    80005d4a:	fef60823          	sb	a5,-16(a2)
    80005d4e:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80005d52:	fff7891b          	addiw	s2,a5,-1
    80005d56:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005d5a:	fff4c503          	lbu	a0,-1(s1)
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	d64080e7          	jalr	-668(ra) # 80005ac2 <consputc>
  while(--i >= 0)
    80005d66:	397d                	addiw	s2,s2,-1
    80005d68:	14fd                	addi	s1,s1,-1
    80005d6a:	fe0958e3          	bgez	s2,80005d5a <printint+0x6a>
}
    80005d6e:	70a2                	ld	ra,40(sp)
    80005d70:	7402                	ld	s0,32(sp)
    80005d72:	64e2                	ld	s1,24(sp)
    80005d74:	6942                	ld	s2,16(sp)
    80005d76:	6145                	addi	sp,sp,48
    80005d78:	8082                	ret
    x = -xx;
    80005d7a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d7e:	4e05                	li	t3,1
    x = -xx;
    80005d80:	b751                	j	80005d04 <printint+0x14>

0000000080005d82 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d82:	1101                	addi	sp,sp,-32
    80005d84:	ec06                	sd	ra,24(sp)
    80005d86:	e822                	sd	s0,16(sp)
    80005d88:	e426                	sd	s1,8(sp)
    80005d8a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005d8c:	00020497          	auipc	s1,0x20
    80005d90:	45c48493          	addi	s1,s1,1116 # 800261e8 <pr>
    80005d94:	00003597          	auipc	a1,0x3
    80005d98:	90c58593          	addi	a1,a1,-1780 # 800086a0 <etext+0x6a0>
    80005d9c:	8526                	mv	a0,s1
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	530080e7          	jalr	1328(ra) # 800062ce <initlock>
  pr.locking = 1;
    80005da6:	4785                	li	a5,1
    80005da8:	cc9c                	sw	a5,24(s1)
}
    80005daa:	60e2                	ld	ra,24(sp)
    80005dac:	6442                	ld	s0,16(sp)
    80005dae:	64a2                	ld	s1,8(sp)
    80005db0:	6105                	addi	sp,sp,32
    80005db2:	8082                	ret

0000000080005db4 <backtrace>:

void backtrace(void) {
    80005db4:	7179                	addi	sp,sp,-48
    80005db6:	f406                	sd	ra,40(sp)
    80005db8:	f022                	sd	s0,32(sp)
    80005dba:	ec26                	sd	s1,24(sp)
    80005dbc:	e84a                	sd	s2,16(sp)
    80005dbe:	e44e                	sd	s3,8(sp)
    80005dc0:	e052                	sd	s4,0(sp)
    80005dc2:	1800                	addi	s0,sp,48
  asm volatile("mv %0, s0" : "=r" (x) );
    80005dc4:	84a2                	mv	s1,s0
  uint64 fp = r_fp();
  uint64 high = PGROUNDUP(fp), low = PGROUNDDOWN(fp);
    80005dc6:	6905                	lui	s2,0x1
    80005dc8:	197d                	addi	s2,s2,-1 # fff <_entry-0x7ffff001>
    80005dca:	9926                	add	s2,s2,s1
    80005dcc:	79fd                	lui	s3,0xfffff
    80005dce:	01397933          	and	s2,s2,s3
    80005dd2:	0134f9b3          	and	s3,s1,s3
  while (fp > low && fp < high) {
    uint64 ra = fp - 8;
    uint64 next_fp = fp - 16;
    printf("%p\n", *(uint64*)ra);
    80005dd6:	00003a17          	auipc	s4,0x3
    80005dda:	8d2a0a13          	addi	s4,s4,-1838 # 800086a8 <etext+0x6a8>
  while (fp > low && fp < high) {
    80005dde:	0099ff63          	bgeu	s3,s1,80005dfc <backtrace+0x48>
    80005de2:	0124fd63          	bgeu	s1,s2,80005dfc <backtrace+0x48>
    printf("%p\n", *(uint64*)ra);
    80005de6:	ff84b583          	ld	a1,-8(s1)
    80005dea:	8552                	mv	a0,s4
    80005dec:	00000097          	auipc	ra,0x0
    80005df0:	072080e7          	jalr	114(ra) # 80005e5e <printf>
    fp = *(uint64*)next_fp;
    80005df4:	ff04b483          	ld	s1,-16(s1)
  while (fp > low && fp < high) {
    80005df8:	fe99e5e3          	bltu	s3,s1,80005de2 <backtrace+0x2e>
  }
    80005dfc:	70a2                	ld	ra,40(sp)
    80005dfe:	7402                	ld	s0,32(sp)
    80005e00:	64e2                	ld	s1,24(sp)
    80005e02:	6942                	ld	s2,16(sp)
    80005e04:	69a2                	ld	s3,8(sp)
    80005e06:	6a02                	ld	s4,0(sp)
    80005e08:	6145                	addi	sp,sp,48
    80005e0a:	8082                	ret

0000000080005e0c <panic>:
{
    80005e0c:	1101                	addi	sp,sp,-32
    80005e0e:	ec06                	sd	ra,24(sp)
    80005e10:	e822                	sd	s0,16(sp)
    80005e12:	e426                	sd	s1,8(sp)
    80005e14:	1000                	addi	s0,sp,32
    80005e16:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e18:	00020797          	auipc	a5,0x20
    80005e1c:	3e07a423          	sw	zero,1000(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005e20:	00003517          	auipc	a0,0x3
    80005e24:	89050513          	addi	a0,a0,-1904 # 800086b0 <etext+0x6b0>
    80005e28:	00000097          	auipc	ra,0x0
    80005e2c:	036080e7          	jalr	54(ra) # 80005e5e <printf>
  printf(s);
    80005e30:	8526                	mv	a0,s1
    80005e32:	00000097          	auipc	ra,0x0
    80005e36:	02c080e7          	jalr	44(ra) # 80005e5e <printf>
  printf("\n");
    80005e3a:	00002517          	auipc	a0,0x2
    80005e3e:	1de50513          	addi	a0,a0,478 # 80008018 <etext+0x18>
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	01c080e7          	jalr	28(ra) # 80005e5e <printf>
  backtrace();
    80005e4a:	00000097          	auipc	ra,0x0
    80005e4e:	f6a080e7          	jalr	-150(ra) # 80005db4 <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    80005e52:	4785                	li	a5,1
    80005e54:	00003717          	auipc	a4,0x3
    80005e58:	1cf72423          	sw	a5,456(a4) # 8000901c <panicked>
  for(;;)
    80005e5c:	a001                	j	80005e5c <panic+0x50>

0000000080005e5e <printf>:
{
    80005e5e:	7131                	addi	sp,sp,-192
    80005e60:	fc86                	sd	ra,120(sp)
    80005e62:	f8a2                	sd	s0,112(sp)
    80005e64:	e8d2                	sd	s4,80(sp)
    80005e66:	ec6e                	sd	s11,24(sp)
    80005e68:	0100                	addi	s0,sp,128
    80005e6a:	8a2a                	mv	s4,a0
    80005e6c:	e40c                	sd	a1,8(s0)
    80005e6e:	e810                	sd	a2,16(s0)
    80005e70:	ec14                	sd	a3,24(s0)
    80005e72:	f018                	sd	a4,32(s0)
    80005e74:	f41c                	sd	a5,40(s0)
    80005e76:	03043823          	sd	a6,48(s0)
    80005e7a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005e7e:	00020d97          	auipc	s11,0x20
    80005e82:	382dad83          	lw	s11,898(s11) # 80026200 <pr+0x18>
  if(locking)
    80005e86:	040d9463          	bnez	s11,80005ece <printf+0x70>
  if (fmt == 0)
    80005e8a:	040a0b63          	beqz	s4,80005ee0 <printf+0x82>
  va_start(ap, fmt);
    80005e8e:	00840793          	addi	a5,s0,8
    80005e92:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e96:	000a4503          	lbu	a0,0(s4)
    80005e9a:	18050c63          	beqz	a0,80006032 <printf+0x1d4>
    80005e9e:	f4a6                	sd	s1,104(sp)
    80005ea0:	f0ca                	sd	s2,96(sp)
    80005ea2:	ecce                	sd	s3,88(sp)
    80005ea4:	e4d6                	sd	s5,72(sp)
    80005ea6:	e0da                	sd	s6,64(sp)
    80005ea8:	fc5e                	sd	s7,56(sp)
    80005eaa:	f862                	sd	s8,48(sp)
    80005eac:	f466                	sd	s9,40(sp)
    80005eae:	f06a                	sd	s10,32(sp)
    80005eb0:	4981                	li	s3,0
    if(c != '%'){
    80005eb2:	02500b13          	li	s6,37
    switch(c){
    80005eb6:	07000b93          	li	s7,112
  consputc('x');
    80005eba:	07800c93          	li	s9,120
    80005ebe:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ec0:	00003a97          	auipc	s5,0x3
    80005ec4:	950a8a93          	addi	s5,s5,-1712 # 80008810 <digits>
    switch(c){
    80005ec8:	07300c13          	li	s8,115
    80005ecc:	a0b9                	j	80005f1a <printf+0xbc>
    acquire(&pr.lock);
    80005ece:	00020517          	auipc	a0,0x20
    80005ed2:	31a50513          	addi	a0,a0,794 # 800261e8 <pr>
    80005ed6:	00000097          	auipc	ra,0x0
    80005eda:	48c080e7          	jalr	1164(ra) # 80006362 <acquire>
    80005ede:	b775                	j	80005e8a <printf+0x2c>
    80005ee0:	f4a6                	sd	s1,104(sp)
    80005ee2:	f0ca                	sd	s2,96(sp)
    80005ee4:	ecce                	sd	s3,88(sp)
    80005ee6:	e4d6                	sd	s5,72(sp)
    80005ee8:	e0da                	sd	s6,64(sp)
    80005eea:	fc5e                	sd	s7,56(sp)
    80005eec:	f862                	sd	s8,48(sp)
    80005eee:	f466                	sd	s9,40(sp)
    80005ef0:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80005ef2:	00002517          	auipc	a0,0x2
    80005ef6:	7ce50513          	addi	a0,a0,1998 # 800086c0 <etext+0x6c0>
    80005efa:	00000097          	auipc	ra,0x0
    80005efe:	f12080e7          	jalr	-238(ra) # 80005e0c <panic>
      consputc(c);
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	bc0080e7          	jalr	-1088(ra) # 80005ac2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f0a:	0019879b          	addiw	a5,s3,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    80005f0e:	89be                	mv	s3,a5
    80005f10:	97d2                	add	a5,a5,s4
    80005f12:	0007c503          	lbu	a0,0(a5)
    80005f16:	10050563          	beqz	a0,80006020 <printf+0x1c2>
    if(c != '%'){
    80005f1a:	ff6514e3          	bne	a0,s6,80005f02 <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005f1e:	0019879b          	addiw	a5,s3,1
    80005f22:	89be                	mv	s3,a5
    80005f24:	97d2                	add	a5,a5,s4
    80005f26:	0007c783          	lbu	a5,0(a5)
    80005f2a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005f2e:	10078a63          	beqz	a5,80006042 <printf+0x1e4>
    switch(c){
    80005f32:	05778a63          	beq	a5,s7,80005f86 <printf+0x128>
    80005f36:	02fbf463          	bgeu	s7,a5,80005f5e <printf+0x100>
    80005f3a:	09878763          	beq	a5,s8,80005fc8 <printf+0x16a>
    80005f3e:	0d979663          	bne	a5,s9,8000600a <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80005f42:	f8843783          	ld	a5,-120(s0)
    80005f46:	00878713          	addi	a4,a5,8
    80005f4a:	f8e43423          	sd	a4,-120(s0)
    80005f4e:	4605                	li	a2,1
    80005f50:	85ea                	mv	a1,s10
    80005f52:	4388                	lw	a0,0(a5)
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	d9c080e7          	jalr	-612(ra) # 80005cf0 <printint>
      break;
    80005f5c:	b77d                	j	80005f0a <printf+0xac>
    switch(c){
    80005f5e:	0b678063          	beq	a5,s6,80005ffe <printf+0x1a0>
    80005f62:	06400713          	li	a4,100
    80005f66:	0ae79263          	bne	a5,a4,8000600a <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    80005f6a:	f8843783          	ld	a5,-120(s0)
    80005f6e:	00878713          	addi	a4,a5,8
    80005f72:	f8e43423          	sd	a4,-120(s0)
    80005f76:	4605                	li	a2,1
    80005f78:	45a9                	li	a1,10
    80005f7a:	4388                	lw	a0,0(a5)
    80005f7c:	00000097          	auipc	ra,0x0
    80005f80:	d74080e7          	jalr	-652(ra) # 80005cf0 <printint>
      break;
    80005f84:	b759                	j	80005f0a <printf+0xac>
      printptr(va_arg(ap, uint64));
    80005f86:	f8843783          	ld	a5,-120(s0)
    80005f8a:	00878713          	addi	a4,a5,8
    80005f8e:	f8e43423          	sd	a4,-120(s0)
    80005f92:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005f96:	03000513          	li	a0,48
    80005f9a:	00000097          	auipc	ra,0x0
    80005f9e:	b28080e7          	jalr	-1240(ra) # 80005ac2 <consputc>
  consputc('x');
    80005fa2:	8566                	mv	a0,s9
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	b1e080e7          	jalr	-1250(ra) # 80005ac2 <consputc>
    80005fac:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fae:	03c95793          	srli	a5,s2,0x3c
    80005fb2:	97d6                	add	a5,a5,s5
    80005fb4:	0007c503          	lbu	a0,0(a5)
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	b0a080e7          	jalr	-1270(ra) # 80005ac2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005fc0:	0912                	slli	s2,s2,0x4
    80005fc2:	34fd                	addiw	s1,s1,-1
    80005fc4:	f4ed                	bnez	s1,80005fae <printf+0x150>
    80005fc6:	b791                	j	80005f0a <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80005fc8:	f8843783          	ld	a5,-120(s0)
    80005fcc:	00878713          	addi	a4,a5,8
    80005fd0:	f8e43423          	sd	a4,-120(s0)
    80005fd4:	6384                	ld	s1,0(a5)
    80005fd6:	cc89                	beqz	s1,80005ff0 <printf+0x192>
      for(; *s; s++)
    80005fd8:	0004c503          	lbu	a0,0(s1)
    80005fdc:	d51d                	beqz	a0,80005f0a <printf+0xac>
        consputc(*s);
    80005fde:	00000097          	auipc	ra,0x0
    80005fe2:	ae4080e7          	jalr	-1308(ra) # 80005ac2 <consputc>
      for(; *s; s++)
    80005fe6:	0485                	addi	s1,s1,1
    80005fe8:	0004c503          	lbu	a0,0(s1)
    80005fec:	f96d                	bnez	a0,80005fde <printf+0x180>
    80005fee:	bf31                	j	80005f0a <printf+0xac>
        s = "(null)";
    80005ff0:	00002497          	auipc	s1,0x2
    80005ff4:	6c848493          	addi	s1,s1,1736 # 800086b8 <etext+0x6b8>
      for(; *s; s++)
    80005ff8:	02800513          	li	a0,40
    80005ffc:	b7cd                	j	80005fde <printf+0x180>
      consputc('%');
    80005ffe:	855a                	mv	a0,s6
    80006000:	00000097          	auipc	ra,0x0
    80006004:	ac2080e7          	jalr	-1342(ra) # 80005ac2 <consputc>
      break;
    80006008:	b709                	j	80005f0a <printf+0xac>
      consputc('%');
    8000600a:	855a                	mv	a0,s6
    8000600c:	00000097          	auipc	ra,0x0
    80006010:	ab6080e7          	jalr	-1354(ra) # 80005ac2 <consputc>
      consputc(c);
    80006014:	8526                	mv	a0,s1
    80006016:	00000097          	auipc	ra,0x0
    8000601a:	aac080e7          	jalr	-1364(ra) # 80005ac2 <consputc>
      break;
    8000601e:	b5f5                	j	80005f0a <printf+0xac>
    80006020:	74a6                	ld	s1,104(sp)
    80006022:	7906                	ld	s2,96(sp)
    80006024:	69e6                	ld	s3,88(sp)
    80006026:	6aa6                	ld	s5,72(sp)
    80006028:	6b06                	ld	s6,64(sp)
    8000602a:	7be2                	ld	s7,56(sp)
    8000602c:	7c42                	ld	s8,48(sp)
    8000602e:	7ca2                	ld	s9,40(sp)
    80006030:	7d02                	ld	s10,32(sp)
  if(locking)
    80006032:	020d9263          	bnez	s11,80006056 <printf+0x1f8>
}
    80006036:	70e6                	ld	ra,120(sp)
    80006038:	7446                	ld	s0,112(sp)
    8000603a:	6a46                	ld	s4,80(sp)
    8000603c:	6de2                	ld	s11,24(sp)
    8000603e:	6129                	addi	sp,sp,192
    80006040:	8082                	ret
    80006042:	74a6                	ld	s1,104(sp)
    80006044:	7906                	ld	s2,96(sp)
    80006046:	69e6                	ld	s3,88(sp)
    80006048:	6aa6                	ld	s5,72(sp)
    8000604a:	6b06                	ld	s6,64(sp)
    8000604c:	7be2                	ld	s7,56(sp)
    8000604e:	7c42                	ld	s8,48(sp)
    80006050:	7ca2                	ld	s9,40(sp)
    80006052:	7d02                	ld	s10,32(sp)
    80006054:	bff9                	j	80006032 <printf+0x1d4>
    release(&pr.lock);
    80006056:	00020517          	auipc	a0,0x20
    8000605a:	19250513          	addi	a0,a0,402 # 800261e8 <pr>
    8000605e:	00000097          	auipc	ra,0x0
    80006062:	3b4080e7          	jalr	948(ra) # 80006412 <release>
}
    80006066:	bfc1                	j	80006036 <printf+0x1d8>

0000000080006068 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006068:	1141                	addi	sp,sp,-16
    8000606a:	e406                	sd	ra,8(sp)
    8000606c:	e022                	sd	s0,0(sp)
    8000606e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006070:	100007b7          	lui	a5,0x10000
    80006074:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006078:	10000737          	lui	a4,0x10000
    8000607c:	f8000693          	li	a3,-128
    80006080:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006084:	468d                	li	a3,3
    80006086:	10000637          	lui	a2,0x10000
    8000608a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000608e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006092:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006096:	8732                	mv	a4,a2
    80006098:	461d                	li	a2,7
    8000609a:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000609e:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800060a2:	00002597          	auipc	a1,0x2
    800060a6:	62e58593          	addi	a1,a1,1582 # 800086d0 <etext+0x6d0>
    800060aa:	00020517          	auipc	a0,0x20
    800060ae:	15e50513          	addi	a0,a0,350 # 80026208 <uart_tx_lock>
    800060b2:	00000097          	auipc	ra,0x0
    800060b6:	21c080e7          	jalr	540(ra) # 800062ce <initlock>
}
    800060ba:	60a2                	ld	ra,8(sp)
    800060bc:	6402                	ld	s0,0(sp)
    800060be:	0141                	addi	sp,sp,16
    800060c0:	8082                	ret

00000000800060c2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800060c2:	1101                	addi	sp,sp,-32
    800060c4:	ec06                	sd	ra,24(sp)
    800060c6:	e822                	sd	s0,16(sp)
    800060c8:	e426                	sd	s1,8(sp)
    800060ca:	1000                	addi	s0,sp,32
    800060cc:	84aa                	mv	s1,a0
  push_off();
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	248080e7          	jalr	584(ra) # 80006316 <push_off>

  if(panicked){
    800060d6:	00003797          	auipc	a5,0x3
    800060da:	f467a783          	lw	a5,-186(a5) # 8000901c <panicked>
    800060de:	eb85                	bnez	a5,8000610e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800060e0:	10000737          	lui	a4,0x10000
    800060e4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800060e6:	00074783          	lbu	a5,0(a4)
    800060ea:	0207f793          	andi	a5,a5,32
    800060ee:	dfe5                	beqz	a5,800060e6 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800060f0:	0ff4f513          	zext.b	a0,s1
    800060f4:	100007b7          	lui	a5,0x10000
    800060f8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800060fc:	00000097          	auipc	ra,0x0
    80006100:	2ba080e7          	jalr	698(ra) # 800063b6 <pop_off>
}
    80006104:	60e2                	ld	ra,24(sp)
    80006106:	6442                	ld	s0,16(sp)
    80006108:	64a2                	ld	s1,8(sp)
    8000610a:	6105                	addi	sp,sp,32
    8000610c:	8082                	ret
    for(;;)
    8000610e:	a001                	j	8000610e <uartputc_sync+0x4c>

0000000080006110 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006110:	00003797          	auipc	a5,0x3
    80006114:	f107b783          	ld	a5,-240(a5) # 80009020 <uart_tx_r>
    80006118:	00003717          	auipc	a4,0x3
    8000611c:	f1073703          	ld	a4,-240(a4) # 80009028 <uart_tx_w>
    80006120:	06f70f63          	beq	a4,a5,8000619e <uartstart+0x8e>
{
    80006124:	7139                	addi	sp,sp,-64
    80006126:	fc06                	sd	ra,56(sp)
    80006128:	f822                	sd	s0,48(sp)
    8000612a:	f426                	sd	s1,40(sp)
    8000612c:	f04a                	sd	s2,32(sp)
    8000612e:	ec4e                	sd	s3,24(sp)
    80006130:	e852                	sd	s4,16(sp)
    80006132:	e456                	sd	s5,8(sp)
    80006134:	e05a                	sd	s6,0(sp)
    80006136:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006138:	10000937          	lui	s2,0x10000
    8000613c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000613e:	00020a97          	auipc	s5,0x20
    80006142:	0caa8a93          	addi	s5,s5,202 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    80006146:	00003497          	auipc	s1,0x3
    8000614a:	eda48493          	addi	s1,s1,-294 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000614e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006152:	00003997          	auipc	s3,0x3
    80006156:	ed698993          	addi	s3,s3,-298 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000615a:	00094703          	lbu	a4,0(s2)
    8000615e:	02077713          	andi	a4,a4,32
    80006162:	c705                	beqz	a4,8000618a <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006164:	01f7f713          	andi	a4,a5,31
    80006168:	9756                	add	a4,a4,s5
    8000616a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000616e:	0785                	addi	a5,a5,1
    80006170:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80006172:	8526                	mv	a0,s1
    80006174:	ffffb097          	auipc	ra,0xffffb
    80006178:	586080e7          	jalr	1414(ra) # 800016fa <wakeup>
    WriteReg(THR, c);
    8000617c:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80006180:	609c                	ld	a5,0(s1)
    80006182:	0009b703          	ld	a4,0(s3)
    80006186:	fcf71ae3          	bne	a4,a5,8000615a <uartstart+0x4a>
  }
}
    8000618a:	70e2                	ld	ra,56(sp)
    8000618c:	7442                	ld	s0,48(sp)
    8000618e:	74a2                	ld	s1,40(sp)
    80006190:	7902                	ld	s2,32(sp)
    80006192:	69e2                	ld	s3,24(sp)
    80006194:	6a42                	ld	s4,16(sp)
    80006196:	6aa2                	ld	s5,8(sp)
    80006198:	6b02                	ld	s6,0(sp)
    8000619a:	6121                	addi	sp,sp,64
    8000619c:	8082                	ret
    8000619e:	8082                	ret

00000000800061a0 <uartputc>:
{
    800061a0:	7179                	addi	sp,sp,-48
    800061a2:	f406                	sd	ra,40(sp)
    800061a4:	f022                	sd	s0,32(sp)
    800061a6:	e052                	sd	s4,0(sp)
    800061a8:	1800                	addi	s0,sp,48
    800061aa:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800061ac:	00020517          	auipc	a0,0x20
    800061b0:	05c50513          	addi	a0,a0,92 # 80026208 <uart_tx_lock>
    800061b4:	00000097          	auipc	ra,0x0
    800061b8:	1ae080e7          	jalr	430(ra) # 80006362 <acquire>
  if(panicked){
    800061bc:	00003797          	auipc	a5,0x3
    800061c0:	e607a783          	lw	a5,-416(a5) # 8000901c <panicked>
    800061c4:	c391                	beqz	a5,800061c8 <uartputc+0x28>
    for(;;)
    800061c6:	a001                	j	800061c6 <uartputc+0x26>
    800061c8:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061ca:	00003717          	auipc	a4,0x3
    800061ce:	e5e73703          	ld	a4,-418(a4) # 80009028 <uart_tx_w>
    800061d2:	00003797          	auipc	a5,0x3
    800061d6:	e4e7b783          	ld	a5,-434(a5) # 80009020 <uart_tx_r>
    800061da:	02078793          	addi	a5,a5,32
    800061de:	02e79f63          	bne	a5,a4,8000621c <uartputc+0x7c>
    800061e2:	e84a                	sd	s2,16(sp)
    800061e4:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800061e6:	00020997          	auipc	s3,0x20
    800061ea:	02298993          	addi	s3,s3,34 # 80026208 <uart_tx_lock>
    800061ee:	00003497          	auipc	s1,0x3
    800061f2:	e3248493          	addi	s1,s1,-462 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800061f6:	00003917          	auipc	s2,0x3
    800061fa:	e3290913          	addi	s2,s2,-462 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800061fe:	85ce                	mv	a1,s3
    80006200:	8526                	mv	a0,s1
    80006202:	ffffb097          	auipc	ra,0xffffb
    80006206:	372080e7          	jalr	882(ra) # 80001574 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000620a:	00093703          	ld	a4,0(s2)
    8000620e:	609c                	ld	a5,0(s1)
    80006210:	02078793          	addi	a5,a5,32
    80006214:	fee785e3          	beq	a5,a4,800061fe <uartputc+0x5e>
    80006218:	6942                	ld	s2,16(sp)
    8000621a:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000621c:	00020497          	auipc	s1,0x20
    80006220:	fec48493          	addi	s1,s1,-20 # 80026208 <uart_tx_lock>
    80006224:	01f77793          	andi	a5,a4,31
    80006228:	97a6                	add	a5,a5,s1
    8000622a:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000622e:	0705                	addi	a4,a4,1
    80006230:	00003797          	auipc	a5,0x3
    80006234:	dee7bc23          	sd	a4,-520(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006238:	00000097          	auipc	ra,0x0
    8000623c:	ed8080e7          	jalr	-296(ra) # 80006110 <uartstart>
      release(&uart_tx_lock);
    80006240:	8526                	mv	a0,s1
    80006242:	00000097          	auipc	ra,0x0
    80006246:	1d0080e7          	jalr	464(ra) # 80006412 <release>
    8000624a:	64e2                	ld	s1,24(sp)
}
    8000624c:	70a2                	ld	ra,40(sp)
    8000624e:	7402                	ld	s0,32(sp)
    80006250:	6a02                	ld	s4,0(sp)
    80006252:	6145                	addi	sp,sp,48
    80006254:	8082                	ret

0000000080006256 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006256:	1141                	addi	sp,sp,-16
    80006258:	e406                	sd	ra,8(sp)
    8000625a:	e022                	sd	s0,0(sp)
    8000625c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000625e:	100007b7          	lui	a5,0x10000
    80006262:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006266:	8b85                	andi	a5,a5,1
    80006268:	cb89                	beqz	a5,8000627a <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000626a:	100007b7          	lui	a5,0x10000
    8000626e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80006272:	60a2                	ld	ra,8(sp)
    80006274:	6402                	ld	s0,0(sp)
    80006276:	0141                	addi	sp,sp,16
    80006278:	8082                	ret
    return -1;
    8000627a:	557d                	li	a0,-1
    8000627c:	bfdd                	j	80006272 <uartgetc+0x1c>

000000008000627e <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    8000627e:	1101                	addi	sp,sp,-32
    80006280:	ec06                	sd	ra,24(sp)
    80006282:	e822                	sd	s0,16(sp)
    80006284:	e426                	sd	s1,8(sp)
    80006286:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006288:	54fd                	li	s1,-1
    int c = uartgetc();
    8000628a:	00000097          	auipc	ra,0x0
    8000628e:	fcc080e7          	jalr	-52(ra) # 80006256 <uartgetc>
    if(c == -1)
    80006292:	00950763          	beq	a0,s1,800062a0 <uartintr+0x22>
      break;
    consoleintr(c);
    80006296:	00000097          	auipc	ra,0x0
    8000629a:	86e080e7          	jalr	-1938(ra) # 80005b04 <consoleintr>
  while(1){
    8000629e:	b7f5                	j	8000628a <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800062a0:	00020497          	auipc	s1,0x20
    800062a4:	f6848493          	addi	s1,s1,-152 # 80026208 <uart_tx_lock>
    800062a8:	8526                	mv	a0,s1
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	0b8080e7          	jalr	184(ra) # 80006362 <acquire>
  uartstart();
    800062b2:	00000097          	auipc	ra,0x0
    800062b6:	e5e080e7          	jalr	-418(ra) # 80006110 <uartstart>
  release(&uart_tx_lock);
    800062ba:	8526                	mv	a0,s1
    800062bc:	00000097          	auipc	ra,0x0
    800062c0:	156080e7          	jalr	342(ra) # 80006412 <release>
}
    800062c4:	60e2                	ld	ra,24(sp)
    800062c6:	6442                	ld	s0,16(sp)
    800062c8:	64a2                	ld	s1,8(sp)
    800062ca:	6105                	addi	sp,sp,32
    800062cc:	8082                	ret

00000000800062ce <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800062ce:	1141                	addi	sp,sp,-16
    800062d0:	e406                	sd	ra,8(sp)
    800062d2:	e022                	sd	s0,0(sp)
    800062d4:	0800                	addi	s0,sp,16
  lk->name = name;
    800062d6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800062d8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800062dc:	00053823          	sd	zero,16(a0)
}
    800062e0:	60a2                	ld	ra,8(sp)
    800062e2:	6402                	ld	s0,0(sp)
    800062e4:	0141                	addi	sp,sp,16
    800062e6:	8082                	ret

00000000800062e8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800062e8:	411c                	lw	a5,0(a0)
    800062ea:	e399                	bnez	a5,800062f0 <holding+0x8>
    800062ec:	4501                	li	a0,0
  return r;
}
    800062ee:	8082                	ret
{
    800062f0:	1101                	addi	sp,sp,-32
    800062f2:	ec06                	sd	ra,24(sp)
    800062f4:	e822                	sd	s0,16(sp)
    800062f6:	e426                	sd	s1,8(sp)
    800062f8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800062fa:	6904                	ld	s1,16(a0)
    800062fc:	ffffb097          	auipc	ra,0xffffb
    80006300:	b86080e7          	jalr	-1146(ra) # 80000e82 <mycpu>
    80006304:	40a48533          	sub	a0,s1,a0
    80006308:	00153513          	seqz	a0,a0
}
    8000630c:	60e2                	ld	ra,24(sp)
    8000630e:	6442                	ld	s0,16(sp)
    80006310:	64a2                	ld	s1,8(sp)
    80006312:	6105                	addi	sp,sp,32
    80006314:	8082                	ret

0000000080006316 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006316:	1101                	addi	sp,sp,-32
    80006318:	ec06                	sd	ra,24(sp)
    8000631a:	e822                	sd	s0,16(sp)
    8000631c:	e426                	sd	s1,8(sp)
    8000631e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006320:	100024f3          	csrr	s1,sstatus
    80006324:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006328:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000632a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000632e:	ffffb097          	auipc	ra,0xffffb
    80006332:	b54080e7          	jalr	-1196(ra) # 80000e82 <mycpu>
    80006336:	5d3c                	lw	a5,120(a0)
    80006338:	cf89                	beqz	a5,80006352 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000633a:	ffffb097          	auipc	ra,0xffffb
    8000633e:	b48080e7          	jalr	-1208(ra) # 80000e82 <mycpu>
    80006342:	5d3c                	lw	a5,120(a0)
    80006344:	2785                	addiw	a5,a5,1
    80006346:	dd3c                	sw	a5,120(a0)
}
    80006348:	60e2                	ld	ra,24(sp)
    8000634a:	6442                	ld	s0,16(sp)
    8000634c:	64a2                	ld	s1,8(sp)
    8000634e:	6105                	addi	sp,sp,32
    80006350:	8082                	ret
    mycpu()->intena = old;
    80006352:	ffffb097          	auipc	ra,0xffffb
    80006356:	b30080e7          	jalr	-1232(ra) # 80000e82 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000635a:	8085                	srli	s1,s1,0x1
    8000635c:	8885                	andi	s1,s1,1
    8000635e:	dd64                	sw	s1,124(a0)
    80006360:	bfe9                	j	8000633a <push_off+0x24>

0000000080006362 <acquire>:
{
    80006362:	1101                	addi	sp,sp,-32
    80006364:	ec06                	sd	ra,24(sp)
    80006366:	e822                	sd	s0,16(sp)
    80006368:	e426                	sd	s1,8(sp)
    8000636a:	1000                	addi	s0,sp,32
    8000636c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	fa8080e7          	jalr	-88(ra) # 80006316 <push_off>
  if(holding(lk))
    80006376:	8526                	mv	a0,s1
    80006378:	00000097          	auipc	ra,0x0
    8000637c:	f70080e7          	jalr	-144(ra) # 800062e8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006380:	4705                	li	a4,1
  if(holding(lk))
    80006382:	e115                	bnez	a0,800063a6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006384:	87ba                	mv	a5,a4
    80006386:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000638a:	2781                	sext.w	a5,a5
    8000638c:	ffe5                	bnez	a5,80006384 <acquire+0x22>
  __sync_synchronize();
    8000638e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006392:	ffffb097          	auipc	ra,0xffffb
    80006396:	af0080e7          	jalr	-1296(ra) # 80000e82 <mycpu>
    8000639a:	e888                	sd	a0,16(s1)
}
    8000639c:	60e2                	ld	ra,24(sp)
    8000639e:	6442                	ld	s0,16(sp)
    800063a0:	64a2                	ld	s1,8(sp)
    800063a2:	6105                	addi	sp,sp,32
    800063a4:	8082                	ret
    panic("acquire");
    800063a6:	00002517          	auipc	a0,0x2
    800063aa:	33250513          	addi	a0,a0,818 # 800086d8 <etext+0x6d8>
    800063ae:	00000097          	auipc	ra,0x0
    800063b2:	a5e080e7          	jalr	-1442(ra) # 80005e0c <panic>

00000000800063b6 <pop_off>:

void
pop_off(void)
{
    800063b6:	1141                	addi	sp,sp,-16
    800063b8:	e406                	sd	ra,8(sp)
    800063ba:	e022                	sd	s0,0(sp)
    800063bc:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800063be:	ffffb097          	auipc	ra,0xffffb
    800063c2:	ac4080e7          	jalr	-1340(ra) # 80000e82 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800063ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800063cc:	e39d                	bnez	a5,800063f2 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800063ce:	5d3c                	lw	a5,120(a0)
    800063d0:	02f05963          	blez	a5,80006402 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    800063d4:	37fd                	addiw	a5,a5,-1
    800063d6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800063d8:	eb89                	bnez	a5,800063ea <pop_off+0x34>
    800063da:	5d7c                	lw	a5,124(a0)
    800063dc:	c799                	beqz	a5,800063ea <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800063e2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063e6:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800063ea:	60a2                	ld	ra,8(sp)
    800063ec:	6402                	ld	s0,0(sp)
    800063ee:	0141                	addi	sp,sp,16
    800063f0:	8082                	ret
    panic("pop_off - interruptible");
    800063f2:	00002517          	auipc	a0,0x2
    800063f6:	2ee50513          	addi	a0,a0,750 # 800086e0 <etext+0x6e0>
    800063fa:	00000097          	auipc	ra,0x0
    800063fe:	a12080e7          	jalr	-1518(ra) # 80005e0c <panic>
    panic("pop_off");
    80006402:	00002517          	auipc	a0,0x2
    80006406:	2f650513          	addi	a0,a0,758 # 800086f8 <etext+0x6f8>
    8000640a:	00000097          	auipc	ra,0x0
    8000640e:	a02080e7          	jalr	-1534(ra) # 80005e0c <panic>

0000000080006412 <release>:
{
    80006412:	1101                	addi	sp,sp,-32
    80006414:	ec06                	sd	ra,24(sp)
    80006416:	e822                	sd	s0,16(sp)
    80006418:	e426                	sd	s1,8(sp)
    8000641a:	1000                	addi	s0,sp,32
    8000641c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000641e:	00000097          	auipc	ra,0x0
    80006422:	eca080e7          	jalr	-310(ra) # 800062e8 <holding>
    80006426:	c115                	beqz	a0,8000644a <release+0x38>
  lk->cpu = 0;
    80006428:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000642c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006430:	0310000f          	fence	rw,w
    80006434:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	f7e080e7          	jalr	-130(ra) # 800063b6 <pop_off>
}
    80006440:	60e2                	ld	ra,24(sp)
    80006442:	6442                	ld	s0,16(sp)
    80006444:	64a2                	ld	s1,8(sp)
    80006446:	6105                	addi	sp,sp,32
    80006448:	8082                	ret
    panic("release");
    8000644a:	00002517          	auipc	a0,0x2
    8000644e:	2b650513          	addi	a0,a0,694 # 80008700 <etext+0x700>
    80006452:	00000097          	auipc	ra,0x0
    80006456:	9ba080e7          	jalr	-1606(ra) # 80005e0c <panic>
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
