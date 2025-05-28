
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0025e117          	auipc	sp,0x25e
    80000004:	14010113          	addi	sp,sp,320 # 8025e140 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	231050ef          	jal	80005a46 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <refcnt_incr>:
  struct spinlock lock; // protects freelist
  int refcnt_array[PA2PPIDX(PHYSTOP) + 1]; // reference count for each physical page
} refcnt_recorder;

int refcnt_incr(uint64 pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	1000                	addi	s0,sp,32
    80000026:	84aa                	mv	s1,a0
  acquire(&refcnt_recorder.lock);
    80000028:	00009517          	auipc	a0,0x9
    8000002c:	02850513          	addi	a0,a0,40 # 80009050 <refcnt_recorder>
    80000030:	00006097          	auipc	ra,0x6
    80000034:	462080e7          	jalr	1122(ra) # 80006492 <acquire>
  int refcnt = ++refcnt_recorder.refcnt_array[PA2PPIDX(pa)];
    80000038:	800007b7          	lui	a5,0x80000
    8000003c:	97a6                	add	a5,a5,s1
    8000003e:	83b1                	srli	a5,a5,0xc
    80000040:	00009517          	auipc	a0,0x9
    80000044:	01050513          	addi	a0,a0,16 # 80009050 <refcnt_recorder>
    80000048:	0791                	addi	a5,a5,4 # ffffffff80000004 <end+0xfffffffeffd99dc4>
    8000004a:	078a                	slli	a5,a5,0x2
    8000004c:	97aa                	add	a5,a5,a0
    8000004e:	4784                	lw	s1,8(a5)
    80000050:	2485                	addiw	s1,s1,1
    80000052:	c784                	sw	s1,8(a5)
  release(&refcnt_recorder.lock);
    80000054:	00006097          	auipc	ra,0x6
    80000058:	4ee080e7          	jalr	1262(ra) # 80006542 <release>
  return refcnt;
}
    8000005c:	8526                	mv	a0,s1
    8000005e:	60e2                	ld	ra,24(sp)
    80000060:	6442                	ld	s0,16(sp)
    80000062:	64a2                	ld	s1,8(sp)
    80000064:	6105                	addi	sp,sp,32
    80000066:	8082                	ret

0000000080000068 <refcnt_decr>:

int refcnt_decr(uint64 pa)
{
    80000068:	1101                	addi	sp,sp,-32
    8000006a:	ec06                	sd	ra,24(sp)
    8000006c:	e822                	sd	s0,16(sp)
    8000006e:	e426                	sd	s1,8(sp)
    80000070:	1000                	addi	s0,sp,32
    80000072:	84aa                	mv	s1,a0
  acquire(&refcnt_recorder.lock);
    80000074:	00009517          	auipc	a0,0x9
    80000078:	fdc50513          	addi	a0,a0,-36 # 80009050 <refcnt_recorder>
    8000007c:	00006097          	auipc	ra,0x6
    80000080:	416080e7          	jalr	1046(ra) # 80006492 <acquire>
  int refcnt = --refcnt_recorder.refcnt_array[PA2PPIDX(pa)];
    80000084:	800007b7          	lui	a5,0x80000
    80000088:	97a6                	add	a5,a5,s1
    8000008a:	83b1                	srli	a5,a5,0xc
    8000008c:	00009517          	auipc	a0,0x9
    80000090:	fc450513          	addi	a0,a0,-60 # 80009050 <refcnt_recorder>
    80000094:	0791                	addi	a5,a5,4 # ffffffff80000004 <end+0xfffffffeffd99dc4>
    80000096:	078a                	slli	a5,a5,0x2
    80000098:	97aa                	add	a5,a5,a0
    8000009a:	4784                	lw	s1,8(a5)
    8000009c:	34fd                	addiw	s1,s1,-1
    8000009e:	c784                	sw	s1,8(a5)
  release(&refcnt_recorder.lock);
    800000a0:	00006097          	auipc	ra,0x6
    800000a4:	4a2080e7          	jalr	1186(ra) # 80006542 <release>
  return refcnt;
}
    800000a8:	8526                	mv	a0,s1
    800000aa:	60e2                	ld	ra,24(sp)
    800000ac:	6442                	ld	s0,16(sp)
    800000ae:	64a2                	ld	s1,8(sp)
    800000b0:	6105                	addi	sp,sp,32
    800000b2:	8082                	ret

00000000800000b4 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800000b4:	1101                	addi	sp,sp,-32
    800000b6:	ec06                	sd	ra,24(sp)
    800000b8:	e822                	sd	s0,16(sp)
    800000ba:	e426                	sd	s1,8(sp)
    800000bc:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800000be:	03451793          	slli	a5,a0,0x34
    800000c2:	e79d                	bnez	a5,800000f0 <kfree+0x3c>
    800000c4:	84aa                	mv	s1,a0
    800000c6:	00266797          	auipc	a5,0x266
    800000ca:	17a78793          	addi	a5,a5,378 # 80266240 <end>
    800000ce:	02f56163          	bltu	a0,a5,800000f0 <kfree+0x3c>
    800000d2:	47c5                	li	a5,17
    800000d4:	07ee                	slli	a5,a5,0x1b
    800000d6:	00f57d63          	bgeu	a0,a5,800000f0 <kfree+0x3c>
    panic("kfree");

  int ref = refcnt_decr((uint64)pa);
    800000da:	00000097          	auipc	ra,0x0
    800000de:	f8e080e7          	jalr	-114(ra) # 80000068 <refcnt_decr>
  if(ref > 0)
    800000e2:	02a05063          	blez	a0,80000102 <kfree+0x4e>

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}
    800000e6:	60e2                	ld	ra,24(sp)
    800000e8:	6442                	ld	s0,16(sp)
    800000ea:	64a2                	ld	s1,8(sp)
    800000ec:	6105                	addi	sp,sp,32
    800000ee:	8082                	ret
    800000f0:	e04a                	sd	s2,0(sp)
    panic("kfree");
    800000f2:	00008517          	auipc	a0,0x8
    800000f6:	f0e50513          	addi	a0,a0,-242 # 80008000 <etext>
    800000fa:	00006097          	auipc	ra,0x6
    800000fe:	e18080e7          	jalr	-488(ra) # 80005f12 <panic>
    80000102:	e04a                	sd	s2,0(sp)
  memset(pa, 1, PGSIZE);
    80000104:	6605                	lui	a2,0x1
    80000106:	4585                	li	a1,1
    80000108:	8526                	mv	a0,s1
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	1ae080e7          	jalr	430(ra) # 800002b8 <memset>
  acquire(&kmem.lock);
    80000112:	00009917          	auipc	s2,0x9
    80000116:	f1e90913          	addi	s2,s2,-226 # 80009030 <kmem>
    8000011a:	854a                	mv	a0,s2
    8000011c:	00006097          	auipc	ra,0x6
    80000120:	376080e7          	jalr	886(ra) # 80006492 <acquire>
  r->next = kmem.freelist;
    80000124:	01893783          	ld	a5,24(s2)
    80000128:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    8000012a:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000012e:	854a                	mv	a0,s2
    80000130:	00006097          	auipc	ra,0x6
    80000134:	412080e7          	jalr	1042(ra) # 80006542 <release>
    80000138:	6902                	ld	s2,0(sp)
    8000013a:	b775                	j	800000e6 <kfree+0x32>

000000008000013c <freerange>:
{
    8000013c:	715d                	addi	sp,sp,-80
    8000013e:	e486                	sd	ra,72(sp)
    80000140:	e0a2                	sd	s0,64(sp)
    80000142:	fc26                	sd	s1,56(sp)
    80000144:	0880                	addi	s0,sp,80
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000146:	6785                	lui	a5,0x1
    80000148:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000014c:	00e504b3          	add	s1,a0,a4
    80000150:	777d                	lui	a4,0xfffff
    80000152:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000154:	94be                	add	s1,s1,a5
    80000156:	0695e563          	bltu	a1,s1,800001c0 <freerange+0x84>
    8000015a:	f84a                	sd	s2,48(sp)
    8000015c:	f44e                	sd	s3,40(sp)
    8000015e:	f052                	sd	s4,32(sp)
    80000160:	ec56                	sd	s5,24(sp)
    80000162:	e85a                	sd	s6,16(sp)
    80000164:	e45e                	sd	s7,8(sp)
    80000166:	8a2e                	mv	s4,a1
    acquire(&refcnt_recorder.lock);
    80000168:	00009917          	auipc	s2,0x9
    8000016c:	ee890913          	addi	s2,s2,-280 # 80009050 <refcnt_recorder>
    refcnt_recorder.refcnt_array[PA2PPIDX(p)] = 1; // initialize reference count
    80000170:	fff809b7          	lui	s3,0xfff80
    80000174:	19fd                	addi	s3,s3,-1 # fffffffffff7ffff <end+0xffffffff7fd19dbf>
    80000176:	09b2                	slli	s3,s3,0xc
    80000178:	4b85                	li	s7,1
    kfree(p);
    8000017a:	8b3a                	mv	s6,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000017c:	8abe                	mv	s5,a5
    acquire(&refcnt_recorder.lock);
    8000017e:	854a                	mv	a0,s2
    80000180:	00006097          	auipc	ra,0x6
    80000184:	312080e7          	jalr	786(ra) # 80006492 <acquire>
    refcnt_recorder.refcnt_array[PA2PPIDX(p)] = 1; // initialize reference count
    80000188:	013487b3          	add	a5,s1,s3
    8000018c:	83b1                	srli	a5,a5,0xc
    8000018e:	0791                	addi	a5,a5,4
    80000190:	078a                	slli	a5,a5,0x2
    80000192:	97ca                	add	a5,a5,s2
    80000194:	0177a423          	sw	s7,8(a5)
    release(&refcnt_recorder.lock);
    80000198:	854a                	mv	a0,s2
    8000019a:	00006097          	auipc	ra,0x6
    8000019e:	3a8080e7          	jalr	936(ra) # 80006542 <release>
    kfree(p);
    800001a2:	01648533          	add	a0,s1,s6
    800001a6:	00000097          	auipc	ra,0x0
    800001aa:	f0e080e7          	jalr	-242(ra) # 800000b4 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800001ae:	94d6                	add	s1,s1,s5
    800001b0:	fc9a77e3          	bgeu	s4,s1,8000017e <freerange+0x42>
    800001b4:	7942                	ld	s2,48(sp)
    800001b6:	79a2                	ld	s3,40(sp)
    800001b8:	7a02                	ld	s4,32(sp)
    800001ba:	6ae2                	ld	s5,24(sp)
    800001bc:	6b42                	ld	s6,16(sp)
    800001be:	6ba2                	ld	s7,8(sp)
}
    800001c0:	60a6                	ld	ra,72(sp)
    800001c2:	6406                	ld	s0,64(sp)
    800001c4:	74e2                	ld	s1,56(sp)
    800001c6:	6161                	addi	sp,sp,80
    800001c8:	8082                	ret

00000000800001ca <kinit>:
{
    800001ca:	1141                	addi	sp,sp,-16
    800001cc:	e406                	sd	ra,8(sp)
    800001ce:	e022                	sd	s0,0(sp)
    800001d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800001d2:	00008597          	auipc	a1,0x8
    800001d6:	e3e58593          	addi	a1,a1,-450 # 80008010 <etext+0x10>
    800001da:	00009517          	auipc	a0,0x9
    800001de:	e5650513          	addi	a0,a0,-426 # 80009030 <kmem>
    800001e2:	00006097          	auipc	ra,0x6
    800001e6:	21c080e7          	jalr	540(ra) # 800063fe <initlock>
  initlock(&refcnt_recorder.lock, "refcnt_recorder");
    800001ea:	00008597          	auipc	a1,0x8
    800001ee:	e2e58593          	addi	a1,a1,-466 # 80008018 <etext+0x18>
    800001f2:	00009517          	auipc	a0,0x9
    800001f6:	e5e50513          	addi	a0,a0,-418 # 80009050 <refcnt_recorder>
    800001fa:	00006097          	auipc	ra,0x6
    800001fe:	204080e7          	jalr	516(ra) # 800063fe <initlock>
  freerange(end, (void*)PHYSTOP);
    80000202:	45c5                	li	a1,17
    80000204:	05ee                	slli	a1,a1,0x1b
    80000206:	00266517          	auipc	a0,0x266
    8000020a:	03a50513          	addi	a0,a0,58 # 80266240 <end>
    8000020e:	00000097          	auipc	ra,0x0
    80000212:	f2e080e7          	jalr	-210(ra) # 8000013c <freerange>
}
    80000216:	60a2                	ld	ra,8(sp)
    80000218:	6402                	ld	s0,0(sp)
    8000021a:	0141                	addi	sp,sp,16
    8000021c:	8082                	ret

000000008000021e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000021e:	1101                	addi	sp,sp,-32
    80000220:	ec06                	sd	ra,24(sp)
    80000222:	e822                	sd	s0,16(sp)
    80000224:	e426                	sd	s1,8(sp)
    80000226:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000228:	00009497          	auipc	s1,0x9
    8000022c:	e0848493          	addi	s1,s1,-504 # 80009030 <kmem>
    80000230:	8526                	mv	a0,s1
    80000232:	00006097          	auipc	ra,0x6
    80000236:	260080e7          	jalr	608(ra) # 80006492 <acquire>
  r = kmem.freelist;
    8000023a:	6c84                	ld	s1,24(s1)
  if(r) {
    8000023c:	c4ad                	beqz	s1,800002a6 <kalloc+0x88>
    8000023e:	e04a                	sd	s2,0(sp)
    kmem.freelist = r->next;
    80000240:	609c                	ld	a5,0(s1)
    80000242:	00009917          	auipc	s2,0x9
    80000246:	dee90913          	addi	s2,s2,-530 # 80009030 <kmem>
    8000024a:	00f93c23          	sd	a5,24(s2)
    acquire(&refcnt_recorder.lock);
    8000024e:	00009517          	auipc	a0,0x9
    80000252:	e0250513          	addi	a0,a0,-510 # 80009050 <refcnt_recorder>
    80000256:	00006097          	auipc	ra,0x6
    8000025a:	23c080e7          	jalr	572(ra) # 80006492 <acquire>
    refcnt_recorder.refcnt_array[PA2PPIDX(r)] = 1; // reset reference count
    8000025e:	00009517          	auipc	a0,0x9
    80000262:	df250513          	addi	a0,a0,-526 # 80009050 <refcnt_recorder>
    80000266:	800007b7          	lui	a5,0x80000
    8000026a:	97a6                	add	a5,a5,s1
    8000026c:	83b1                	srli	a5,a5,0xc
    8000026e:	0791                	addi	a5,a5,4 # ffffffff80000004 <end+0xfffffffeffd99dc4>
    80000270:	078a                	slli	a5,a5,0x2
    80000272:	97aa                	add	a5,a5,a0
    80000274:	4705                	li	a4,1
    80000276:	c798                	sw	a4,8(a5)
    release(&refcnt_recorder.lock);
    80000278:	00006097          	auipc	ra,0x6
    8000027c:	2ca080e7          	jalr	714(ra) # 80006542 <release>
  }  
  release(&kmem.lock);
    80000280:	854a                	mv	a0,s2
    80000282:	00006097          	auipc	ra,0x6
    80000286:	2c0080e7          	jalr	704(ra) # 80006542 <release>

  if(r) {
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000028a:	6605                	lui	a2,0x1
    8000028c:	4595                	li	a1,5
    8000028e:	8526                	mv	a0,s1
    80000290:	00000097          	auipc	ra,0x0
    80000294:	028080e7          	jalr	40(ra) # 800002b8 <memset>
  }
    
  return (void*)r;
    80000298:	6902                	ld	s2,0(sp)
}
    8000029a:	8526                	mv	a0,s1
    8000029c:	60e2                	ld	ra,24(sp)
    8000029e:	6442                	ld	s0,16(sp)
    800002a0:	64a2                	ld	s1,8(sp)
    800002a2:	6105                	addi	sp,sp,32
    800002a4:	8082                	ret
  release(&kmem.lock);
    800002a6:	00009517          	auipc	a0,0x9
    800002aa:	d8a50513          	addi	a0,a0,-630 # 80009030 <kmem>
    800002ae:	00006097          	auipc	ra,0x6
    800002b2:	294080e7          	jalr	660(ra) # 80006542 <release>
  if(r) {
    800002b6:	b7d5                	j	8000029a <kalloc+0x7c>

00000000800002b8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002b8:	1141                	addi	sp,sp,-16
    800002ba:	e406                	sd	ra,8(sp)
    800002bc:	e022                	sd	s0,0(sp)
    800002be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002c0:	ca19                	beqz	a2,800002d6 <memset+0x1e>
    800002c2:	87aa                	mv	a5,a0
    800002c4:	1602                	slli	a2,a2,0x20
    800002c6:	9201                	srli	a2,a2,0x20
    800002c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fee79de3          	bne	a5,a4,800002cc <memset+0x14>
  }
  return dst;
}
    800002d6:	60a2                	ld	ra,8(sp)
    800002d8:	6402                	ld	s0,0(sp)
    800002da:	0141                	addi	sp,sp,16
    800002dc:	8082                	ret

00000000800002de <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002de:	1141                	addi	sp,sp,-16
    800002e0:	e406                	sd	ra,8(sp)
    800002e2:	e022                	sd	s0,0(sp)
    800002e4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002e6:	ca0d                	beqz	a2,80000318 <memcmp+0x3a>
    800002e8:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800002ec:	1682                	slli	a3,a3,0x20
    800002ee:	9281                	srli	a3,a3,0x20
    800002f0:	0685                	addi	a3,a3,1
    800002f2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800002f4:	00054783          	lbu	a5,0(a0)
    800002f8:	0005c703          	lbu	a4,0(a1)
    800002fc:	00e79863          	bne	a5,a4,8000030c <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000300:	0505                	addi	a0,a0,1
    80000302:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000304:	fed518e3          	bne	a0,a3,800002f4 <memcmp+0x16>
  }

  return 0;
    80000308:	4501                	li	a0,0
    8000030a:	a019                	j	80000310 <memcmp+0x32>
      return *s1 - *s2;
    8000030c:	40e7853b          	subw	a0,a5,a4
}
    80000310:	60a2                	ld	ra,8(sp)
    80000312:	6402                	ld	s0,0(sp)
    80000314:	0141                	addi	sp,sp,16
    80000316:	8082                	ret
  return 0;
    80000318:	4501                	li	a0,0
    8000031a:	bfdd                	j	80000310 <memcmp+0x32>

000000008000031c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000031c:	1141                	addi	sp,sp,-16
    8000031e:	e406                	sd	ra,8(sp)
    80000320:	e022                	sd	s0,0(sp)
    80000322:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000324:	c205                	beqz	a2,80000344 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000326:	02a5e363          	bltu	a1,a0,8000034c <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000032a:	1602                	slli	a2,a2,0x20
    8000032c:	9201                	srli	a2,a2,0x20
    8000032e:	00c587b3          	add	a5,a1,a2
{
    80000332:	872a                	mv	a4,a0
      *d++ = *s++;
    80000334:	0585                	addi	a1,a1,1
    80000336:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fd98dc1>
    80000338:	fff5c683          	lbu	a3,-1(a1)
    8000033c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000340:	feb79ae3          	bne	a5,a1,80000334 <memmove+0x18>

  return dst;
}
    80000344:	60a2                	ld	ra,8(sp)
    80000346:	6402                	ld	s0,0(sp)
    80000348:	0141                	addi	sp,sp,16
    8000034a:	8082                	ret
  if(s < d && s + n > d){
    8000034c:	02061693          	slli	a3,a2,0x20
    80000350:	9281                	srli	a3,a3,0x20
    80000352:	00d58733          	add	a4,a1,a3
    80000356:	fce57ae3          	bgeu	a0,a4,8000032a <memmove+0xe>
    d += n;
    8000035a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000035c:	fff6079b          	addiw	a5,a2,-1
    80000360:	1782                	slli	a5,a5,0x20
    80000362:	9381                	srli	a5,a5,0x20
    80000364:	fff7c793          	not	a5,a5
    80000368:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000036a:	177d                	addi	a4,a4,-1
    8000036c:	16fd                	addi	a3,a3,-1
    8000036e:	00074603          	lbu	a2,0(a4)
    80000372:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000376:	fee79ae3          	bne	a5,a4,8000036a <memmove+0x4e>
    8000037a:	b7e9                	j	80000344 <memmove+0x28>

000000008000037c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000037c:	1141                	addi	sp,sp,-16
    8000037e:	e406                	sd	ra,8(sp)
    80000380:	e022                	sd	s0,0(sp)
    80000382:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000384:	00000097          	auipc	ra,0x0
    80000388:	f98080e7          	jalr	-104(ra) # 8000031c <memmove>
}
    8000038c:	60a2                	ld	ra,8(sp)
    8000038e:	6402                	ld	s0,0(sp)
    80000390:	0141                	addi	sp,sp,16
    80000392:	8082                	ret

0000000080000394 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000394:	1141                	addi	sp,sp,-16
    80000396:	e406                	sd	ra,8(sp)
    80000398:	e022                	sd	s0,0(sp)
    8000039a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000039c:	ce11                	beqz	a2,800003b8 <strncmp+0x24>
    8000039e:	00054783          	lbu	a5,0(a0)
    800003a2:	cf89                	beqz	a5,800003bc <strncmp+0x28>
    800003a4:	0005c703          	lbu	a4,0(a1)
    800003a8:	00f71a63          	bne	a4,a5,800003bc <strncmp+0x28>
    n--, p++, q++;
    800003ac:	367d                	addiw	a2,a2,-1
    800003ae:	0505                	addi	a0,a0,1
    800003b0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800003b2:	f675                	bnez	a2,8000039e <strncmp+0xa>
  if(n == 0)
    return 0;
    800003b4:	4501                	li	a0,0
    800003b6:	a801                	j	800003c6 <strncmp+0x32>
    800003b8:	4501                	li	a0,0
    800003ba:	a031                	j	800003c6 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    800003bc:	00054503          	lbu	a0,0(a0)
    800003c0:	0005c783          	lbu	a5,0(a1)
    800003c4:	9d1d                	subw	a0,a0,a5
}
    800003c6:	60a2                	ld	ra,8(sp)
    800003c8:	6402                	ld	s0,0(sp)
    800003ca:	0141                	addi	sp,sp,16
    800003cc:	8082                	ret

00000000800003ce <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003ce:	1141                	addi	sp,sp,-16
    800003d0:	e406                	sd	ra,8(sp)
    800003d2:	e022                	sd	s0,0(sp)
    800003d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003d6:	87aa                	mv	a5,a0
    800003d8:	86b2                	mv	a3,a2
    800003da:	367d                	addiw	a2,a2,-1
    800003dc:	02d05563          	blez	a3,80000406 <strncpy+0x38>
    800003e0:	0785                	addi	a5,a5,1
    800003e2:	0005c703          	lbu	a4,0(a1)
    800003e6:	fee78fa3          	sb	a4,-1(a5)
    800003ea:	0585                	addi	a1,a1,1
    800003ec:	f775                	bnez	a4,800003d8 <strncpy+0xa>
    ;
  while(n-- > 0)
    800003ee:	873e                	mv	a4,a5
    800003f0:	00c05b63          	blez	a2,80000406 <strncpy+0x38>
    800003f4:	9fb5                	addw	a5,a5,a3
    800003f6:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    800003f8:	0705                	addi	a4,a4,1
    800003fa:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003fe:	40e786bb          	subw	a3,a5,a4
    80000402:	fed04be3          	bgtz	a3,800003f8 <strncpy+0x2a>
  return os;
}
    80000406:	60a2                	ld	ra,8(sp)
    80000408:	6402                	ld	s0,0(sp)
    8000040a:	0141                	addi	sp,sp,16
    8000040c:	8082                	ret

000000008000040e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000040e:	1141                	addi	sp,sp,-16
    80000410:	e406                	sd	ra,8(sp)
    80000412:	e022                	sd	s0,0(sp)
    80000414:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000416:	02c05363          	blez	a2,8000043c <safestrcpy+0x2e>
    8000041a:	fff6069b          	addiw	a3,a2,-1
    8000041e:	1682                	slli	a3,a3,0x20
    80000420:	9281                	srli	a3,a3,0x20
    80000422:	96ae                	add	a3,a3,a1
    80000424:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000426:	00d58963          	beq	a1,a3,80000438 <safestrcpy+0x2a>
    8000042a:	0585                	addi	a1,a1,1
    8000042c:	0785                	addi	a5,a5,1
    8000042e:	fff5c703          	lbu	a4,-1(a1)
    80000432:	fee78fa3          	sb	a4,-1(a5)
    80000436:	fb65                	bnez	a4,80000426 <safestrcpy+0x18>
    ;
  *s = 0;
    80000438:	00078023          	sb	zero,0(a5)
  return os;
}
    8000043c:	60a2                	ld	ra,8(sp)
    8000043e:	6402                	ld	s0,0(sp)
    80000440:	0141                	addi	sp,sp,16
    80000442:	8082                	ret

0000000080000444 <strlen>:

int
strlen(const char *s)
{
    80000444:	1141                	addi	sp,sp,-16
    80000446:	e406                	sd	ra,8(sp)
    80000448:	e022                	sd	s0,0(sp)
    8000044a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000044c:	00054783          	lbu	a5,0(a0)
    80000450:	cf99                	beqz	a5,8000046e <strlen+0x2a>
    80000452:	0505                	addi	a0,a0,1
    80000454:	87aa                	mv	a5,a0
    80000456:	86be                	mv	a3,a5
    80000458:	0785                	addi	a5,a5,1
    8000045a:	fff7c703          	lbu	a4,-1(a5)
    8000045e:	ff65                	bnez	a4,80000456 <strlen+0x12>
    80000460:	40a6853b          	subw	a0,a3,a0
    80000464:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000466:	60a2                	ld	ra,8(sp)
    80000468:	6402                	ld	s0,0(sp)
    8000046a:	0141                	addi	sp,sp,16
    8000046c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000046e:	4501                	li	a0,0
    80000470:	bfdd                	j	80000466 <strlen+0x22>

0000000080000472 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000472:	1141                	addi	sp,sp,-16
    80000474:	e406                	sd	ra,8(sp)
    80000476:	e022                	sd	s0,0(sp)
    80000478:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000047a:	00001097          	auipc	ra,0x1
    8000047e:	be8080e7          	jalr	-1048(ra) # 80001062 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000482:	00009717          	auipc	a4,0x9
    80000486:	b7e70713          	addi	a4,a4,-1154 # 80009000 <started>
  if(cpuid() == 0){
    8000048a:	c139                	beqz	a0,800004d0 <main+0x5e>
    while(started == 0)
    8000048c:	431c                	lw	a5,0(a4)
    8000048e:	2781                	sext.w	a5,a5
    80000490:	dff5                	beqz	a5,8000048c <main+0x1a>
      ;
    __sync_synchronize();
    80000492:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000496:	00001097          	auipc	ra,0x1
    8000049a:	bcc080e7          	jalr	-1076(ra) # 80001062 <cpuid>
    8000049e:	85aa                	mv	a1,a0
    800004a0:	00008517          	auipc	a0,0x8
    800004a4:	ba850513          	addi	a0,a0,-1112 # 80008048 <etext+0x48>
    800004a8:	00006097          	auipc	ra,0x6
    800004ac:	ab4080e7          	jalr	-1356(ra) # 80005f5c <printf>
    kvminithart();    // turn on paging
    800004b0:	00000097          	auipc	ra,0x0
    800004b4:	0d8080e7          	jalr	216(ra) # 80000588 <kvminithart>
    trapinithart();   // install kernel trap vector
    800004b8:	00002097          	auipc	ra,0x2
    800004bc:	830080e7          	jalr	-2000(ra) # 80001ce8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800004c0:	00005097          	auipc	ra,0x5
    800004c4:	f54080e7          	jalr	-172(ra) # 80005414 <plicinithart>
  }

  scheduler();        
    800004c8:	00001097          	auipc	ra,0x1
    800004cc:	0e2080e7          	jalr	226(ra) # 800015aa <scheduler>
    consoleinit();
    800004d0:	00006097          	auipc	ra,0x6
    800004d4:	964080e7          	jalr	-1692(ra) # 80005e34 <consoleinit>
    printfinit();
    800004d8:	00006097          	auipc	ra,0x6
    800004dc:	c8e080e7          	jalr	-882(ra) # 80006166 <printfinit>
    printf("\n");
    800004e0:	00008517          	auipc	a0,0x8
    800004e4:	b4850513          	addi	a0,a0,-1208 # 80008028 <etext+0x28>
    800004e8:	00006097          	auipc	ra,0x6
    800004ec:	a74080e7          	jalr	-1420(ra) # 80005f5c <printf>
    printf("xv6 kernel is booting\n");
    800004f0:	00008517          	auipc	a0,0x8
    800004f4:	b4050513          	addi	a0,a0,-1216 # 80008030 <etext+0x30>
    800004f8:	00006097          	auipc	ra,0x6
    800004fc:	a64080e7          	jalr	-1436(ra) # 80005f5c <printf>
    printf("\n");
    80000500:	00008517          	auipc	a0,0x8
    80000504:	b2850513          	addi	a0,a0,-1240 # 80008028 <etext+0x28>
    80000508:	00006097          	auipc	ra,0x6
    8000050c:	a54080e7          	jalr	-1452(ra) # 80005f5c <printf>
    kinit();         // physical page allocator
    80000510:	00000097          	auipc	ra,0x0
    80000514:	cba080e7          	jalr	-838(ra) # 800001ca <kinit>
    kvminit();       // create kernel page table
    80000518:	00000097          	auipc	ra,0x0
    8000051c:	326080e7          	jalr	806(ra) # 8000083e <kvminit>
    kvminithart();   // turn on paging
    80000520:	00000097          	auipc	ra,0x0
    80000524:	068080e7          	jalr	104(ra) # 80000588 <kvminithart>
    procinit();      // process table
    80000528:	00001097          	auipc	ra,0x1
    8000052c:	a82080e7          	jalr	-1406(ra) # 80000faa <procinit>
    trapinit();      // trap vectors
    80000530:	00001097          	auipc	ra,0x1
    80000534:	790080e7          	jalr	1936(ra) # 80001cc0 <trapinit>
    trapinithart();  // install kernel trap vector
    80000538:	00001097          	auipc	ra,0x1
    8000053c:	7b0080e7          	jalr	1968(ra) # 80001ce8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000540:	00005097          	auipc	ra,0x5
    80000544:	eba080e7          	jalr	-326(ra) # 800053fa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000548:	00005097          	auipc	ra,0x5
    8000054c:	ecc080e7          	jalr	-308(ra) # 80005414 <plicinithart>
    binit();         // buffer cache
    80000550:	00002097          	auipc	ra,0x2
    80000554:	fa0080e7          	jalr	-96(ra) # 800024f0 <binit>
    iinit();         // inode table
    80000558:	00002097          	auipc	ra,0x2
    8000055c:	60e080e7          	jalr	1550(ra) # 80002b66 <iinit>
    fileinit();      // file table
    80000560:	00003097          	auipc	ra,0x3
    80000564:	5d8080e7          	jalr	1496(ra) # 80003b38 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000568:	00005097          	auipc	ra,0x5
    8000056c:	fcc080e7          	jalr	-52(ra) # 80005534 <virtio_disk_init>
    userinit();      // first user process
    80000570:	00001097          	auipc	ra,0x1
    80000574:	dfe080e7          	jalr	-514(ra) # 8000136e <userinit>
    __sync_synchronize();
    80000578:	0330000f          	fence	rw,rw
    started = 1;
    8000057c:	4785                	li	a5,1
    8000057e:	00009717          	auipc	a4,0x9
    80000582:	a8f72123          	sw	a5,-1406(a4) # 80009000 <started>
    80000586:	b789                	j	800004c8 <main+0x56>

0000000080000588 <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    80000588:	1141                	addi	sp,sp,-16
    8000058a:	e406                	sd	ra,8(sp)
    8000058c:	e022                	sd	s0,0(sp)
    8000058e:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000590:	00009797          	auipc	a5,0x9
    80000594:	a787b783          	ld	a5,-1416(a5) # 80009008 <kernel_pagetable>
    80000598:	83b1                	srli	a5,a5,0xc
    8000059a:	577d                	li	a4,-1
    8000059c:	177e                	slli	a4,a4,0x3f
    8000059e:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800005a0:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800005a4:	12000073          	sfence.vma
  sfence_vma();
}
    800005a8:	60a2                	ld	ra,8(sp)
    800005aa:	6402                	ld	s0,0(sp)
    800005ac:	0141                	addi	sp,sp,16
    800005ae:	8082                	ret

00000000800005b0 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005b0:	7139                	addi	sp,sp,-64
    800005b2:	fc06                	sd	ra,56(sp)
    800005b4:	f822                	sd	s0,48(sp)
    800005b6:	f426                	sd	s1,40(sp)
    800005b8:	f04a                	sd	s2,32(sp)
    800005ba:	ec4e                	sd	s3,24(sp)
    800005bc:	e852                	sd	s4,16(sp)
    800005be:	e456                	sd	s5,8(sp)
    800005c0:	e05a                	sd	s6,0(sp)
    800005c2:	0080                	addi	s0,sp,64
    800005c4:	84aa                	mv	s1,a0
    800005c6:	89ae                	mv	s3,a1
    800005c8:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    800005ca:	57fd                	li	a5,-1
    800005cc:	83e9                	srli	a5,a5,0x1a
    800005ce:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--)
    800005d0:	4b31                	li	s6,12
  if (va >= MAXVA)
    800005d2:	04b7e263          	bltu	a5,a1,80000616 <walk+0x66>
  {
    pte_t *pte = &pagetable[PX(level, va)];
    800005d6:	0149d933          	srl	s2,s3,s4
    800005da:	1ff97913          	andi	s2,s2,511
    800005de:	090e                	slli	s2,s2,0x3
    800005e0:	9926                	add	s2,s2,s1
    if (*pte & PTE_V)
    800005e2:	00093483          	ld	s1,0(s2)
    800005e6:	0014f793          	andi	a5,s1,1
    800005ea:	cf95                	beqz	a5,80000626 <walk+0x76>
    {
      pagetable = (pagetable_t)PTE2PA(*pte);
    800005ec:	80a9                	srli	s1,s1,0xa
    800005ee:	04b2                	slli	s1,s1,0xc
  for (int level = 2; level > 0; level--)
    800005f0:	3a5d                	addiw	s4,s4,-9
    800005f2:	ff6a12e3          	bne	s4,s6,800005d6 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    800005f6:	00c9d513          	srli	a0,s3,0xc
    800005fa:	1ff57513          	andi	a0,a0,511
    800005fe:	050e                	slli	a0,a0,0x3
    80000600:	9526                	add	a0,a0,s1
}
    80000602:	70e2                	ld	ra,56(sp)
    80000604:	7442                	ld	s0,48(sp)
    80000606:	74a2                	ld	s1,40(sp)
    80000608:	7902                	ld	s2,32(sp)
    8000060a:	69e2                	ld	s3,24(sp)
    8000060c:	6a42                	ld	s4,16(sp)
    8000060e:	6aa2                	ld	s5,8(sp)
    80000610:	6b02                	ld	s6,0(sp)
    80000612:	6121                	addi	sp,sp,64
    80000614:	8082                	ret
    panic("walk");
    80000616:	00008517          	auipc	a0,0x8
    8000061a:	a4a50513          	addi	a0,a0,-1462 # 80008060 <etext+0x60>
    8000061e:	00006097          	auipc	ra,0x6
    80000622:	8f4080e7          	jalr	-1804(ra) # 80005f12 <panic>
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000626:	020a8663          	beqz	s5,80000652 <walk+0xa2>
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	bf4080e7          	jalr	-1036(ra) # 8000021e <kalloc>
    80000632:	84aa                	mv	s1,a0
    80000634:	d579                	beqz	a0,80000602 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000636:	6605                	lui	a2,0x1
    80000638:	4581                	li	a1,0
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	c7e080e7          	jalr	-898(ra) # 800002b8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000642:	00c4d793          	srli	a5,s1,0xc
    80000646:	07aa                	slli	a5,a5,0xa
    80000648:	0017e793          	ori	a5,a5,1
    8000064c:	00f93023          	sd	a5,0(s2)
    80000650:	b745                	j	800005f0 <walk+0x40>
        return 0;
    80000652:	4501                	li	a0,0
    80000654:	b77d                	j	80000602 <walk+0x52>

0000000080000656 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000656:	57fd                	li	a5,-1
    80000658:	83e9                	srli	a5,a5,0x1a
    8000065a:	00b7f463          	bgeu	a5,a1,80000662 <walkaddr+0xc>
    return 0;
    8000065e:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000660:	8082                	ret
{
    80000662:	1141                	addi	sp,sp,-16
    80000664:	e406                	sd	ra,8(sp)
    80000666:	e022                	sd	s0,0(sp)
    80000668:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000066a:	4601                	li	a2,0
    8000066c:	00000097          	auipc	ra,0x0
    80000670:	f44080e7          	jalr	-188(ra) # 800005b0 <walk>
  if (pte == 0)
    80000674:	c105                	beqz	a0,80000694 <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    80000676:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    80000678:	0117f693          	andi	a3,a5,17
    8000067c:	4745                	li	a4,17
    return 0;
    8000067e:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    80000680:	00e68663          	beq	a3,a4,8000068c <walkaddr+0x36>
}
    80000684:	60a2                	ld	ra,8(sp)
    80000686:	6402                	ld	s0,0(sp)
    80000688:	0141                	addi	sp,sp,16
    8000068a:	8082                	ret
  pa = PTE2PA(*pte);
    8000068c:	83a9                	srli	a5,a5,0xa
    8000068e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000692:	bfcd                	j	80000684 <walkaddr+0x2e>
    return 0;
    80000694:	4501                	li	a0,0
    80000696:	b7fd                	j	80000684 <walkaddr+0x2e>

0000000080000698 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000698:	715d                	addi	sp,sp,-80
    8000069a:	e486                	sd	ra,72(sp)
    8000069c:	e0a2                	sd	s0,64(sp)
    8000069e:	fc26                	sd	s1,56(sp)
    800006a0:	f84a                	sd	s2,48(sp)
    800006a2:	f44e                	sd	s3,40(sp)
    800006a4:	f052                	sd	s4,32(sp)
    800006a6:	ec56                	sd	s5,24(sp)
    800006a8:	e85a                	sd	s6,16(sp)
    800006aa:	e45e                	sd	s7,8(sp)
    800006ac:	e062                	sd	s8,0(sp)
    800006ae:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if (size == 0)
    800006b0:	ca21                	beqz	a2,80000700 <mappages+0x68>
    800006b2:	8aaa                	mv	s5,a0
    800006b4:	8b3a                	mv	s6,a4
    panic("mappages: size");

  a = PGROUNDDOWN(va);
    800006b6:	777d                	lui	a4,0xfffff
    800006b8:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800006bc:	fff58993          	addi	s3,a1,-1
    800006c0:	99b2                	add	s3,s3,a2
    800006c2:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800006c6:	893e                	mv	s2,a5
    800006c8:	40f68a33          	sub	s4,a3,a5
  for (;;)
  {
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006cc:	4b85                	li	s7,1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    800006ce:	6c05                	lui	s8,0x1
    800006d0:	014904b3          	add	s1,s2,s4
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006d4:	865e                	mv	a2,s7
    800006d6:	85ca                	mv	a1,s2
    800006d8:	8556                	mv	a0,s5
    800006da:	00000097          	auipc	ra,0x0
    800006de:	ed6080e7          	jalr	-298(ra) # 800005b0 <walk>
    800006e2:	cd1d                	beqz	a0,80000720 <mappages+0x88>
    if (*pte & PTE_V)
    800006e4:	611c                	ld	a5,0(a0)
    800006e6:	8b85                	andi	a5,a5,1
    800006e8:	e785                	bnez	a5,80000710 <mappages+0x78>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800006ea:	80b1                	srli	s1,s1,0xc
    800006ec:	04aa                	slli	s1,s1,0xa
    800006ee:	0164e4b3          	or	s1,s1,s6
    800006f2:	0014e493          	ori	s1,s1,1
    800006f6:	e104                	sd	s1,0(a0)
    if (a == last)
    800006f8:	05390163          	beq	s2,s3,8000073a <mappages+0xa2>
    a += PGSIZE;
    800006fc:	9962                	add	s2,s2,s8
    if ((pte = walk(pagetable, a, 1)) == 0)
    800006fe:	bfc9                	j	800006d0 <mappages+0x38>
    panic("mappages: size");
    80000700:	00008517          	auipc	a0,0x8
    80000704:	96850513          	addi	a0,a0,-1688 # 80008068 <etext+0x68>
    80000708:	00006097          	auipc	ra,0x6
    8000070c:	80a080e7          	jalr	-2038(ra) # 80005f12 <panic>
      panic("mappages: remap");
    80000710:	00008517          	auipc	a0,0x8
    80000714:	96850513          	addi	a0,a0,-1688 # 80008078 <etext+0x78>
    80000718:	00005097          	auipc	ra,0x5
    8000071c:	7fa080e7          	jalr	2042(ra) # 80005f12 <panic>
      return -1;
    80000720:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000722:	60a6                	ld	ra,72(sp)
    80000724:	6406                	ld	s0,64(sp)
    80000726:	74e2                	ld	s1,56(sp)
    80000728:	7942                	ld	s2,48(sp)
    8000072a:	79a2                	ld	s3,40(sp)
    8000072c:	7a02                	ld	s4,32(sp)
    8000072e:	6ae2                	ld	s5,24(sp)
    80000730:	6b42                	ld	s6,16(sp)
    80000732:	6ba2                	ld	s7,8(sp)
    80000734:	6c02                	ld	s8,0(sp)
    80000736:	6161                	addi	sp,sp,80
    80000738:	8082                	ret
  return 0;
    8000073a:	4501                	li	a0,0
    8000073c:	b7dd                	j	80000722 <mappages+0x8a>

000000008000073e <kvmmap>:
{
    8000073e:	1141                	addi	sp,sp,-16
    80000740:	e406                	sd	ra,8(sp)
    80000742:	e022                	sd	s0,0(sp)
    80000744:	0800                	addi	s0,sp,16
    80000746:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000748:	86b2                	mv	a3,a2
    8000074a:	863e                	mv	a2,a5
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	f4c080e7          	jalr	-180(ra) # 80000698 <mappages>
    80000754:	e509                	bnez	a0,8000075e <kvmmap+0x20>
}
    80000756:	60a2                	ld	ra,8(sp)
    80000758:	6402                	ld	s0,0(sp)
    8000075a:	0141                	addi	sp,sp,16
    8000075c:	8082                	ret
    panic("kvmmap");
    8000075e:	00008517          	auipc	a0,0x8
    80000762:	92a50513          	addi	a0,a0,-1750 # 80008088 <etext+0x88>
    80000766:	00005097          	auipc	ra,0x5
    8000076a:	7ac080e7          	jalr	1964(ra) # 80005f12 <panic>

000000008000076e <kvmmake>:
{
    8000076e:	1101                	addi	sp,sp,-32
    80000770:	ec06                	sd	ra,24(sp)
    80000772:	e822                	sd	s0,16(sp)
    80000774:	e426                	sd	s1,8(sp)
    80000776:	e04a                	sd	s2,0(sp)
    80000778:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    8000077a:	00000097          	auipc	ra,0x0
    8000077e:	aa4080e7          	jalr	-1372(ra) # 8000021e <kalloc>
    80000782:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000784:	6605                	lui	a2,0x1
    80000786:	4581                	li	a1,0
    80000788:	00000097          	auipc	ra,0x0
    8000078c:	b30080e7          	jalr	-1232(ra) # 800002b8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000790:	4719                	li	a4,6
    80000792:	6685                	lui	a3,0x1
    80000794:	10000637          	lui	a2,0x10000
    80000798:	85b2                	mv	a1,a2
    8000079a:	8526                	mv	a0,s1
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	fa2080e7          	jalr	-94(ra) # 8000073e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800007a4:	4719                	li	a4,6
    800007a6:	6685                	lui	a3,0x1
    800007a8:	10001637          	lui	a2,0x10001
    800007ac:	85b2                	mv	a1,a2
    800007ae:	8526                	mv	a0,s1
    800007b0:	00000097          	auipc	ra,0x0
    800007b4:	f8e080e7          	jalr	-114(ra) # 8000073e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800007b8:	4719                	li	a4,6
    800007ba:	004006b7          	lui	a3,0x400
    800007be:	0c000637          	lui	a2,0xc000
    800007c2:	85b2                	mv	a1,a2
    800007c4:	8526                	mv	a0,s1
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	f78080e7          	jalr	-136(ra) # 8000073e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800007ce:	00008917          	auipc	s2,0x8
    800007d2:	83290913          	addi	s2,s2,-1998 # 80008000 <etext>
    800007d6:	4729                	li	a4,10
    800007d8:	80008697          	auipc	a3,0x80008
    800007dc:	82868693          	addi	a3,a3,-2008 # 8000 <_entry-0x7fff8000>
    800007e0:	4605                	li	a2,1
    800007e2:	067e                	slli	a2,a2,0x1f
    800007e4:	85b2                	mv	a1,a2
    800007e6:	8526                	mv	a0,s1
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	f56080e7          	jalr	-170(ra) # 8000073e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800007f0:	4719                	li	a4,6
    800007f2:	46c5                	li	a3,17
    800007f4:	06ee                	slli	a3,a3,0x1b
    800007f6:	412686b3          	sub	a3,a3,s2
    800007fa:	864a                	mv	a2,s2
    800007fc:	85ca                	mv	a1,s2
    800007fe:	8526                	mv	a0,s1
    80000800:	00000097          	auipc	ra,0x0
    80000804:	f3e080e7          	jalr	-194(ra) # 8000073e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000808:	4729                	li	a4,10
    8000080a:	6685                	lui	a3,0x1
    8000080c:	00006617          	auipc	a2,0x6
    80000810:	7f460613          	addi	a2,a2,2036 # 80007000 <_trampoline>
    80000814:	040005b7          	lui	a1,0x4000
    80000818:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000081a:	05b2                	slli	a1,a1,0xc
    8000081c:	8526                	mv	a0,s1
    8000081e:	00000097          	auipc	ra,0x0
    80000822:	f20080e7          	jalr	-224(ra) # 8000073e <kvmmap>
  proc_mapstacks(kpgtbl);
    80000826:	8526                	mv	a0,s1
    80000828:	00000097          	auipc	ra,0x0
    8000082c:	6d8080e7          	jalr	1752(ra) # 80000f00 <proc_mapstacks>
}
    80000830:	8526                	mv	a0,s1
    80000832:	60e2                	ld	ra,24(sp)
    80000834:	6442                	ld	s0,16(sp)
    80000836:	64a2                	ld	s1,8(sp)
    80000838:	6902                	ld	s2,0(sp)
    8000083a:	6105                	addi	sp,sp,32
    8000083c:	8082                	ret

000000008000083e <kvminit>:
{
    8000083e:	1141                	addi	sp,sp,-16
    80000840:	e406                	sd	ra,8(sp)
    80000842:	e022                	sd	s0,0(sp)
    80000844:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	f28080e7          	jalr	-216(ra) # 8000076e <kvmmake>
    8000084e:	00008797          	auipc	a5,0x8
    80000852:	7aa7bd23          	sd	a0,1978(a5) # 80009008 <kernel_pagetable>
}
    80000856:	60a2                	ld	ra,8(sp)
    80000858:	6402                	ld	s0,0(sp)
    8000085a:	0141                	addi	sp,sp,16
    8000085c:	8082                	ret

000000008000085e <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000085e:	715d                	addi	sp,sp,-80
    80000860:	e486                	sd	ra,72(sp)
    80000862:	e0a2                	sd	s0,64(sp)
    80000864:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80000866:	03459793          	slli	a5,a1,0x34
    8000086a:	e39d                	bnez	a5,80000890 <uvmunmap+0x32>
    8000086c:	f84a                	sd	s2,48(sp)
    8000086e:	f44e                	sd	s3,40(sp)
    80000870:	f052                	sd	s4,32(sp)
    80000872:	ec56                	sd	s5,24(sp)
    80000874:	e85a                	sd	s6,16(sp)
    80000876:	e45e                	sd	s7,8(sp)
    80000878:	8a2a                	mv	s4,a0
    8000087a:	892e                	mv	s2,a1
    8000087c:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000087e:	0632                	slli	a2,a2,0xc
    80000880:	00b609b3          	add	s3,a2,a1
  {
    if ((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if ((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if (PTE_FLAGS(*pte) == PTE_V)
    80000884:	4b85                	li	s7,1
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000886:	6b05                	lui	s6,0x1
    80000888:	0935fb63          	bgeu	a1,s3,8000091e <uvmunmap+0xc0>
    8000088c:	fc26                	sd	s1,56(sp)
    8000088e:	a8a9                	j	800008e8 <uvmunmap+0x8a>
    80000890:	fc26                	sd	s1,56(sp)
    80000892:	f84a                	sd	s2,48(sp)
    80000894:	f44e                	sd	s3,40(sp)
    80000896:	f052                	sd	s4,32(sp)
    80000898:	ec56                	sd	s5,24(sp)
    8000089a:	e85a                	sd	s6,16(sp)
    8000089c:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000089e:	00007517          	auipc	a0,0x7
    800008a2:	7f250513          	addi	a0,a0,2034 # 80008090 <etext+0x90>
    800008a6:	00005097          	auipc	ra,0x5
    800008aa:	66c080e7          	jalr	1644(ra) # 80005f12 <panic>
      panic("uvmunmap: walk");
    800008ae:	00007517          	auipc	a0,0x7
    800008b2:	7fa50513          	addi	a0,a0,2042 # 800080a8 <etext+0xa8>
    800008b6:	00005097          	auipc	ra,0x5
    800008ba:	65c080e7          	jalr	1628(ra) # 80005f12 <panic>
      panic("uvmunmap: not mapped");
    800008be:	00007517          	auipc	a0,0x7
    800008c2:	7fa50513          	addi	a0,a0,2042 # 800080b8 <etext+0xb8>
    800008c6:	00005097          	auipc	ra,0x5
    800008ca:	64c080e7          	jalr	1612(ra) # 80005f12 <panic>
      panic("uvmunmap: not a leaf");
    800008ce:	00008517          	auipc	a0,0x8
    800008d2:	80250513          	addi	a0,a0,-2046 # 800080d0 <etext+0xd0>
    800008d6:	00005097          	auipc	ra,0x5
    800008da:	63c080e7          	jalr	1596(ra) # 80005f12 <panic>
    if (do_free)
    {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    800008de:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800008e2:	995a                	add	s2,s2,s6
    800008e4:	03397c63          	bgeu	s2,s3,8000091c <uvmunmap+0xbe>
    if ((pte = walk(pagetable, a, 0)) == 0)
    800008e8:	4601                	li	a2,0
    800008ea:	85ca                	mv	a1,s2
    800008ec:	8552                	mv	a0,s4
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	cc2080e7          	jalr	-830(ra) # 800005b0 <walk>
    800008f6:	84aa                	mv	s1,a0
    800008f8:	d95d                	beqz	a0,800008ae <uvmunmap+0x50>
    if ((*pte & PTE_V) == 0)
    800008fa:	6108                	ld	a0,0(a0)
    800008fc:	00157793          	andi	a5,a0,1
    80000900:	dfdd                	beqz	a5,800008be <uvmunmap+0x60>
    if (PTE_FLAGS(*pte) == PTE_V)
    80000902:	3ff57793          	andi	a5,a0,1023
    80000906:	fd7784e3          	beq	a5,s7,800008ce <uvmunmap+0x70>
    if (do_free)
    8000090a:	fc0a8ae3          	beqz	s5,800008de <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000090e:	8129                	srli	a0,a0,0xa
      kfree((void *)pa);
    80000910:	0532                	slli	a0,a0,0xc
    80000912:	fffff097          	auipc	ra,0xfffff
    80000916:	7a2080e7          	jalr	1954(ra) # 800000b4 <kfree>
    8000091a:	b7d1                	j	800008de <uvmunmap+0x80>
    8000091c:	74e2                	ld	s1,56(sp)
    8000091e:	7942                	ld	s2,48(sp)
    80000920:	79a2                	ld	s3,40(sp)
    80000922:	7a02                	ld	s4,32(sp)
    80000924:	6ae2                	ld	s5,24(sp)
    80000926:	6b42                	ld	s6,16(sp)
    80000928:	6ba2                	ld	s7,8(sp)
  }
}
    8000092a:	60a6                	ld	ra,72(sp)
    8000092c:	6406                	ld	s0,64(sp)
    8000092e:	6161                	addi	sp,sp,80
    80000930:	8082                	ret

0000000080000932 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000932:	1101                	addi	sp,sp,-32
    80000934:	ec06                	sd	ra,24(sp)
    80000936:	e822                	sd	s0,16(sp)
    80000938:	e426                	sd	s1,8(sp)
    8000093a:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	8e2080e7          	jalr	-1822(ra) # 8000021e <kalloc>
    80000944:	84aa                	mv	s1,a0
  if (pagetable == 0)
    80000946:	c519                	beqz	a0,80000954 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000948:	6605                	lui	a2,0x1
    8000094a:	4581                	li	a1,0
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	96c080e7          	jalr	-1684(ra) # 800002b8 <memset>
  return pagetable;
}
    80000954:	8526                	mv	a0,s1
    80000956:	60e2                	ld	ra,24(sp)
    80000958:	6442                	ld	s0,16(sp)
    8000095a:	64a2                	ld	s1,8(sp)
    8000095c:	6105                	addi	sp,sp,32
    8000095e:	8082                	ret

0000000080000960 <uvminit>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000960:	7179                	addi	sp,sp,-48
    80000962:	f406                	sd	ra,40(sp)
    80000964:	f022                	sd	s0,32(sp)
    80000966:	ec26                	sd	s1,24(sp)
    80000968:	e84a                	sd	s2,16(sp)
    8000096a:	e44e                	sd	s3,8(sp)
    8000096c:	e052                	sd	s4,0(sp)
    8000096e:	1800                	addi	s0,sp,48
  char *mem;

  if (sz >= PGSIZE)
    80000970:	6785                	lui	a5,0x1
    80000972:	04f67863          	bgeu	a2,a5,800009c2 <uvminit+0x62>
    80000976:	8a2a                	mv	s4,a0
    80000978:	89ae                	mv	s3,a1
    8000097a:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    8000097c:	00000097          	auipc	ra,0x0
    80000980:	8a2080e7          	jalr	-1886(ra) # 8000021e <kalloc>
    80000984:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000986:	6605                	lui	a2,0x1
    80000988:	4581                	li	a1,0
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	92e080e7          	jalr	-1746(ra) # 800002b8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000992:	4779                	li	a4,30
    80000994:	86ca                	mv	a3,s2
    80000996:	6605                	lui	a2,0x1
    80000998:	4581                	li	a1,0
    8000099a:	8552                	mv	a0,s4
    8000099c:	00000097          	auipc	ra,0x0
    800009a0:	cfc080e7          	jalr	-772(ra) # 80000698 <mappages>
  memmove(mem, src, sz);
    800009a4:	8626                	mv	a2,s1
    800009a6:	85ce                	mv	a1,s3
    800009a8:	854a                	mv	a0,s2
    800009aa:	00000097          	auipc	ra,0x0
    800009ae:	972080e7          	jalr	-1678(ra) # 8000031c <memmove>
}
    800009b2:	70a2                	ld	ra,40(sp)
    800009b4:	7402                	ld	s0,32(sp)
    800009b6:	64e2                	ld	s1,24(sp)
    800009b8:	6942                	ld	s2,16(sp)
    800009ba:	69a2                	ld	s3,8(sp)
    800009bc:	6a02                	ld	s4,0(sp)
    800009be:	6145                	addi	sp,sp,48
    800009c0:	8082                	ret
    panic("inituvm: more than a page");
    800009c2:	00007517          	auipc	a0,0x7
    800009c6:	72650513          	addi	a0,a0,1830 # 800080e8 <etext+0xe8>
    800009ca:	00005097          	auipc	ra,0x5
    800009ce:	548080e7          	jalr	1352(ra) # 80005f12 <panic>

00000000800009d2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800009d2:	1101                	addi	sp,sp,-32
    800009d4:	ec06                	sd	ra,24(sp)
    800009d6:	e822                	sd	s0,16(sp)
    800009d8:	e426                	sd	s1,8(sp)
    800009da:	1000                	addi	s0,sp,32
  if (newsz >= oldsz)
    return oldsz;
    800009dc:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    800009de:	00b67d63          	bgeu	a2,a1,800009f8 <uvmdealloc+0x26>
    800009e2:	84b2                	mv	s1,a2

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    800009e4:	6785                	lui	a5,0x1
    800009e6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009e8:	00f60733          	add	a4,a2,a5
    800009ec:	76fd                	lui	a3,0xfffff
    800009ee:	8f75                	and	a4,a4,a3
    800009f0:	97ae                	add	a5,a5,a1
    800009f2:	8ff5                	and	a5,a5,a3
    800009f4:	00f76863          	bltu	a4,a5,80000a04 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800009f8:	8526                	mv	a0,s1
    800009fa:	60e2                	ld	ra,24(sp)
    800009fc:	6442                	ld	s0,16(sp)
    800009fe:	64a2                	ld	s1,8(sp)
    80000a00:	6105                	addi	sp,sp,32
    80000a02:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000a04:	8f99                	sub	a5,a5,a4
    80000a06:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000a08:	4685                	li	a3,1
    80000a0a:	0007861b          	sext.w	a2,a5
    80000a0e:	85ba                	mv	a1,a4
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	e4e080e7          	jalr	-434(ra) # 8000085e <uvmunmap>
    80000a18:	b7c5                	j	800009f8 <uvmdealloc+0x26>

0000000080000a1a <uvmalloc>:
  if (newsz < oldsz)
    80000a1a:	0ab66e63          	bltu	a2,a1,80000ad6 <uvmalloc+0xbc>
{
    80000a1e:	715d                	addi	sp,sp,-80
    80000a20:	e486                	sd	ra,72(sp)
    80000a22:	e0a2                	sd	s0,64(sp)
    80000a24:	f052                	sd	s4,32(sp)
    80000a26:	ec56                	sd	s5,24(sp)
    80000a28:	e85a                	sd	s6,16(sp)
    80000a2a:	0880                	addi	s0,sp,80
    80000a2c:	8b2a                	mv	s6,a0
    80000a2e:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    80000a30:	6785                	lui	a5,0x1
    80000a32:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a34:	95be                	add	a1,a1,a5
    80000a36:	77fd                	lui	a5,0xfffff
    80000a38:	00f5fa33          	and	s4,a1,a5
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a3c:	08ca7f63          	bgeu	s4,a2,80000ada <uvmalloc+0xc0>
    80000a40:	fc26                	sd	s1,56(sp)
    80000a42:	f84a                	sd	s2,48(sp)
    80000a44:	f44e                	sd	s3,40(sp)
    80000a46:	e45e                	sd	s7,8(sp)
    80000a48:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80000a4a:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000a4c:	4bf9                	li	s7,30
    mem = kalloc();
    80000a4e:	fffff097          	auipc	ra,0xfffff
    80000a52:	7d0080e7          	jalr	2000(ra) # 8000021e <kalloc>
    80000a56:	84aa                	mv	s1,a0
    if (mem == 0)
    80000a58:	c915                	beqz	a0,80000a8c <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    80000a5a:	864e                	mv	a2,s3
    80000a5c:	4581                	li	a1,0
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	85a080e7          	jalr	-1958(ra) # 800002b8 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W | PTE_X | PTE_R | PTE_U) != 0)
    80000a66:	875e                	mv	a4,s7
    80000a68:	86a6                	mv	a3,s1
    80000a6a:	864e                	mv	a2,s3
    80000a6c:	85ca                	mv	a1,s2
    80000a6e:	855a                	mv	a0,s6
    80000a70:	00000097          	auipc	ra,0x0
    80000a74:	c28080e7          	jalr	-984(ra) # 80000698 <mappages>
    80000a78:	ed0d                	bnez	a0,80000ab2 <uvmalloc+0x98>
  for (a = oldsz; a < newsz; a += PGSIZE)
    80000a7a:	994e                	add	s2,s2,s3
    80000a7c:	fd5969e3          	bltu	s2,s5,80000a4e <uvmalloc+0x34>
  return newsz;
    80000a80:	8556                	mv	a0,s5
    80000a82:	74e2                	ld	s1,56(sp)
    80000a84:	7942                	ld	s2,48(sp)
    80000a86:	79a2                	ld	s3,40(sp)
    80000a88:	6ba2                	ld	s7,8(sp)
    80000a8a:	a829                	j	80000aa4 <uvmalloc+0x8a>
      uvmdealloc(pagetable, a, oldsz);
    80000a8c:	8652                	mv	a2,s4
    80000a8e:	85ca                	mv	a1,s2
    80000a90:	855a                	mv	a0,s6
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	f40080e7          	jalr	-192(ra) # 800009d2 <uvmdealloc>
      return 0;
    80000a9a:	4501                	li	a0,0
    80000a9c:	74e2                	ld	s1,56(sp)
    80000a9e:	7942                	ld	s2,48(sp)
    80000aa0:	79a2                	ld	s3,40(sp)
    80000aa2:	6ba2                	ld	s7,8(sp)
}
    80000aa4:	60a6                	ld	ra,72(sp)
    80000aa6:	6406                	ld	s0,64(sp)
    80000aa8:	7a02                	ld	s4,32(sp)
    80000aaa:	6ae2                	ld	s5,24(sp)
    80000aac:	6b42                	ld	s6,16(sp)
    80000aae:	6161                	addi	sp,sp,80
    80000ab0:	8082                	ret
      kfree(mem);
    80000ab2:	8526                	mv	a0,s1
    80000ab4:	fffff097          	auipc	ra,0xfffff
    80000ab8:	600080e7          	jalr	1536(ra) # 800000b4 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000abc:	8652                	mv	a2,s4
    80000abe:	85ca                	mv	a1,s2
    80000ac0:	855a                	mv	a0,s6
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	f10080e7          	jalr	-240(ra) # 800009d2 <uvmdealloc>
      return 0;
    80000aca:	4501                	li	a0,0
    80000acc:	74e2                	ld	s1,56(sp)
    80000ace:	7942                	ld	s2,48(sp)
    80000ad0:	79a2                	ld	s3,40(sp)
    80000ad2:	6ba2                	ld	s7,8(sp)
    80000ad4:	bfc1                	j	80000aa4 <uvmalloc+0x8a>
    return oldsz;
    80000ad6:	852e                	mv	a0,a1
}
    80000ad8:	8082                	ret
  return newsz;
    80000ada:	8532                	mv	a0,a2
    80000adc:	b7e1                	j	80000aa4 <uvmalloc+0x8a>

0000000080000ade <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000ade:	7179                	addi	sp,sp,-48
    80000ae0:	f406                	sd	ra,40(sp)
    80000ae2:	f022                	sd	s0,32(sp)
    80000ae4:	ec26                	sd	s1,24(sp)
    80000ae6:	e84a                	sd	s2,16(sp)
    80000ae8:	e44e                	sd	s3,8(sp)
    80000aea:	e052                	sd	s4,0(sp)
    80000aec:	1800                	addi	s0,sp,48
    80000aee:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++)
    80000af0:	84aa                	mv	s1,a0
    80000af2:	6905                	lui	s2,0x1
    80000af4:	992a                	add	s2,s2,a0
  {
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000af6:	4985                	li	s3,1
    80000af8:	a829                	j	80000b12 <freewalk+0x34>
    {
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000afa:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000afc:	00c79513          	slli	a0,a5,0xc
    80000b00:	00000097          	auipc	ra,0x0
    80000b04:	fde080e7          	jalr	-34(ra) # 80000ade <freewalk>
      pagetable[i] = 0;
    80000b08:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++)
    80000b0c:	04a1                	addi	s1,s1,8
    80000b0e:	03248163          	beq	s1,s2,80000b30 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000b12:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000b14:	00f7f713          	andi	a4,a5,15
    80000b18:	ff3701e3          	beq	a4,s3,80000afa <freewalk+0x1c>
    }
    else if (pte & PTE_V)
    80000b1c:	8b85                	andi	a5,a5,1
    80000b1e:	d7fd                	beqz	a5,80000b0c <freewalk+0x2e>
    {
      panic("freewalk: leaf");
    80000b20:	00007517          	auipc	a0,0x7
    80000b24:	5e850513          	addi	a0,a0,1512 # 80008108 <etext+0x108>
    80000b28:	00005097          	auipc	ra,0x5
    80000b2c:	3ea080e7          	jalr	1002(ra) # 80005f12 <panic>
    }
  }
  kfree((void *)pagetable);
    80000b30:	8552                	mv	a0,s4
    80000b32:	fffff097          	auipc	ra,0xfffff
    80000b36:	582080e7          	jalr	1410(ra) # 800000b4 <kfree>
}
    80000b3a:	70a2                	ld	ra,40(sp)
    80000b3c:	7402                	ld	s0,32(sp)
    80000b3e:	64e2                	ld	s1,24(sp)
    80000b40:	6942                	ld	s2,16(sp)
    80000b42:	69a2                	ld	s3,8(sp)
    80000b44:	6a02                	ld	s4,0(sp)
    80000b46:	6145                	addi	sp,sp,48
    80000b48:	8082                	ret

0000000080000b4a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000b4a:	1101                	addi	sp,sp,-32
    80000b4c:	ec06                	sd	ra,24(sp)
    80000b4e:	e822                	sd	s0,16(sp)
    80000b50:	e426                	sd	s1,8(sp)
    80000b52:	1000                	addi	s0,sp,32
    80000b54:	84aa                	mv	s1,a0
  if (sz > 0)
    80000b56:	e999                	bnez	a1,80000b6c <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    80000b58:	8526                	mv	a0,s1
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	f84080e7          	jalr	-124(ra) # 80000ade <freewalk>
}
    80000b62:	60e2                	ld	ra,24(sp)
    80000b64:	6442                	ld	s0,16(sp)
    80000b66:	64a2                	ld	s1,8(sp)
    80000b68:	6105                	addi	sp,sp,32
    80000b6a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000b6c:	6785                	lui	a5,0x1
    80000b6e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000b70:	95be                	add	a1,a1,a5
    80000b72:	4685                	li	a3,1
    80000b74:	00c5d613          	srli	a2,a1,0xc
    80000b78:	4581                	li	a1,0
    80000b7a:	00000097          	auipc	ra,0x0
    80000b7e:	ce4080e7          	jalr	-796(ra) # 8000085e <uvmunmap>
    80000b82:	bfd9                	j	80000b58 <uvmfree+0xe>

0000000080000b84 <uvmcopy>:
// Copies both the page table and the
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000b84:	7159                	addi	sp,sp,-112
    80000b86:	f486                	sd	ra,104(sp)
    80000b88:	f0a2                	sd	s0,96(sp)
    80000b8a:	f85a                	sd	s6,48(sp)
    80000b8c:	1880                	addi	s0,sp,112
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for (i = 0; i < sz; i += PGSIZE)
    80000b8e:	c66d                	beqz	a2,80000c78 <uvmcopy+0xf4>
    80000b90:	eca6                	sd	s1,88(sp)
    80000b92:	e8ca                	sd	s2,80(sp)
    80000b94:	e4ce                	sd	s3,72(sp)
    80000b96:	e0d2                	sd	s4,64(sp)
    80000b98:	fc56                	sd	s5,56(sp)
    80000b9a:	f45e                	sd	s7,40(sp)
    80000b9c:	f062                	sd	s8,32(sp)
    80000b9e:	ec66                	sd	s9,24(sp)
    80000ba0:	e86a                	sd	s10,16(sp)
    80000ba2:	e46e                	sd	s11,8(sp)
    80000ba4:	8d2a                	mv	s10,a0
    80000ba6:	8cae                	mv	s9,a1
    80000ba8:	8c32                	mv	s8,a2
    80000baa:	4a01                	li	s4,0

    flags = PTE_FLAGS(*pte);
    flags &= ~PTE_W;
    flags |= PTE_C; // mark as copy-on-write

    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000bac:	6b85                	lui	s7,0x1
    {
      goto err;
    }
    *pte = PA2PTE(pa) | flags;
    80000bae:	7dfd                	lui	s11,0xfffff
    80000bb0:	002ddd93          	srli	s11,s11,0x2
    if ((pte = walk(old, i, 0)) == 0)
    80000bb4:	4601                	li	a2,0
    80000bb6:	85d2                	mv	a1,s4
    80000bb8:	856a                	mv	a0,s10
    80000bba:	00000097          	auipc	ra,0x0
    80000bbe:	9f6080e7          	jalr	-1546(ra) # 800005b0 <walk>
    80000bc2:	89aa                	mv	s3,a0
    80000bc4:	c125                	beqz	a0,80000c24 <uvmcopy+0xa0>
    if ((*pte & PTE_V) == 0)
    80000bc6:	6104                	ld	s1,0(a0)
    80000bc8:	0014f793          	andi	a5,s1,1
    80000bcc:	c7a5                	beqz	a5,80000c34 <uvmcopy+0xb0>
    pa = PTE2PA(*pte);
    80000bce:	00a4da93          	srli	s5,s1,0xa
    80000bd2:	0ab2                	slli	s5,s5,0xc
    flags &= ~PTE_W;
    80000bd4:	3fb4f913          	andi	s2,s1,1019
    flags |= PTE_C; // mark as copy-on-write
    80000bd8:	10096913          	ori	s2,s2,256
    if (mappages(new, i, PGSIZE, pa, flags) != 0)
    80000bdc:	874a                	mv	a4,s2
    80000bde:	86d6                	mv	a3,s5
    80000be0:	865e                	mv	a2,s7
    80000be2:	85d2                	mv	a1,s4
    80000be4:	8566                	mv	a0,s9
    80000be6:	00000097          	auipc	ra,0x0
    80000bea:	ab2080e7          	jalr	-1358(ra) # 80000698 <mappages>
    80000bee:	8b2a                	mv	s6,a0
    80000bf0:	e931                	bnez	a0,80000c44 <uvmcopy+0xc0>
    *pte = PA2PTE(pa) | flags;
    80000bf2:	01b4f4b3          	and	s1,s1,s11
    80000bf6:	00996933          	or	s2,s2,s1
    80000bfa:	0129b023          	sd	s2,0(s3) # 1000 <_entry-0x7ffff000>
    refcnt_incr(pa); // increment reference count for the physical page
    80000bfe:	8556                	mv	a0,s5
    80000c00:	fffff097          	auipc	ra,0xfffff
    80000c04:	41c080e7          	jalr	1052(ra) # 8000001c <refcnt_incr>
  for (i = 0; i < sz; i += PGSIZE)
    80000c08:	9a5e                	add	s4,s4,s7
    80000c0a:	fb8a65e3          	bltu	s4,s8,80000bb4 <uvmcopy+0x30>
    80000c0e:	64e6                	ld	s1,88(sp)
    80000c10:	6946                	ld	s2,80(sp)
    80000c12:	69a6                	ld	s3,72(sp)
    80000c14:	6a06                	ld	s4,64(sp)
    80000c16:	7ae2                	ld	s5,56(sp)
    80000c18:	7ba2                	ld	s7,40(sp)
    80000c1a:	7c02                	ld	s8,32(sp)
    80000c1c:	6ce2                	ld	s9,24(sp)
    80000c1e:	6d42                	ld	s10,16(sp)
    80000c20:	6da2                	ld	s11,8(sp)
    80000c22:	a0a9                	j	80000c6c <uvmcopy+0xe8>
      panic("uvmcopy: pte should exist");
    80000c24:	00007517          	auipc	a0,0x7
    80000c28:	4f450513          	addi	a0,a0,1268 # 80008118 <etext+0x118>
    80000c2c:	00005097          	auipc	ra,0x5
    80000c30:	2e6080e7          	jalr	742(ra) # 80005f12 <panic>
      panic("uvmcopy: page not present");
    80000c34:	00007517          	auipc	a0,0x7
    80000c38:	50450513          	addi	a0,a0,1284 # 80008138 <etext+0x138>
    80000c3c:	00005097          	auipc	ra,0x5
    80000c40:	2d6080e7          	jalr	726(ra) # 80005f12 <panic>
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000c44:	4685                	li	a3,1
    80000c46:	00ca5613          	srli	a2,s4,0xc
    80000c4a:	4581                	li	a1,0
    80000c4c:	8566                	mv	a0,s9
    80000c4e:	00000097          	auipc	ra,0x0
    80000c52:	c10080e7          	jalr	-1008(ra) # 8000085e <uvmunmap>
  return -1;
    80000c56:	5b7d                	li	s6,-1
    80000c58:	64e6                	ld	s1,88(sp)
    80000c5a:	6946                	ld	s2,80(sp)
    80000c5c:	69a6                	ld	s3,72(sp)
    80000c5e:	6a06                	ld	s4,64(sp)
    80000c60:	7ae2                	ld	s5,56(sp)
    80000c62:	7ba2                	ld	s7,40(sp)
    80000c64:	7c02                	ld	s8,32(sp)
    80000c66:	6ce2                	ld	s9,24(sp)
    80000c68:	6d42                	ld	s10,16(sp)
    80000c6a:	6da2                	ld	s11,8(sp)
}
    80000c6c:	855a                	mv	a0,s6
    80000c6e:	70a6                	ld	ra,104(sp)
    80000c70:	7406                	ld	s0,96(sp)
    80000c72:	7b42                	ld	s6,48(sp)
    80000c74:	6165                	addi	sp,sp,112
    80000c76:	8082                	ret
  return 0;
    80000c78:	4b01                	li	s6,0
    80000c7a:	bfcd                	j	80000c6c <uvmcopy+0xe8>

0000000080000c7c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000c7c:	1141                	addi	sp,sp,-16
    80000c7e:	e406                	sd	ra,8(sp)
    80000c80:	e022                	sd	s0,0(sp)
    80000c82:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80000c84:	4601                	li	a2,0
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	92a080e7          	jalr	-1750(ra) # 800005b0 <walk>
  if (pte == 0)
    80000c8e:	c901                	beqz	a0,80000c9e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000c90:	611c                	ld	a5,0(a0)
    80000c92:	9bbd                	andi	a5,a5,-17
    80000c94:	e11c                	sd	a5,0(a0)
}
    80000c96:	60a2                	ld	ra,8(sp)
    80000c98:	6402                	ld	s0,0(sp)
    80000c9a:	0141                	addi	sp,sp,16
    80000c9c:	8082                	ret
    panic("uvmclear");
    80000c9e:	00007517          	auipc	a0,0x7
    80000ca2:	4ba50513          	addi	a0,a0,1210 # 80008158 <etext+0x158>
    80000ca6:	00005097          	auipc	ra,0x5
    80000caa:	26c080e7          	jalr	620(ra) # 80005f12 <panic>

0000000080000cae <copyout>:
{
  uint64 n, va0, pa0;
  pte_t *pte;
  char *mem;

  while (len > 0)
    80000cae:	c6e5                	beqz	a3,80000d96 <copyout+0xe8>
{
    80000cb0:	7119                	addi	sp,sp,-128
    80000cb2:	fc86                	sd	ra,120(sp)
    80000cb4:	f8a2                	sd	s0,112(sp)
    80000cb6:	f4a6                	sd	s1,104(sp)
    80000cb8:	f0ca                	sd	s2,96(sp)
    80000cba:	ecce                	sd	s3,88(sp)
    80000cbc:	e8d2                	sd	s4,80(sp)
    80000cbe:	e4d6                	sd	s5,72(sp)
    80000cc0:	e0da                	sd	s6,64(sp)
    80000cc2:	fc5e                	sd	s7,56(sp)
    80000cc4:	f862                	sd	s8,48(sp)
    80000cc6:	f466                	sd	s9,40(sp)
    80000cc8:	f06a                	sd	s10,32(sp)
    80000cca:	ec6e                	sd	s11,24(sp)
    80000ccc:	0100                	addi	s0,sp,128
    80000cce:	8d2a                	mv	s10,a0
    80000cd0:	8a2e                	mv	s4,a1
    80000cd2:	8c32                	mv	s8,a2
    80000cd4:	8bb6                	mv	s7,a3
  {
    va0 = PGROUNDDOWN(dstva);
    80000cd6:	7dfd                	lui	s11,0xfffff
    
    if(va0 > MAXVA) return -1;
    80000cd8:	4785                	li	a5,1
    80000cda:	179a                	slli	a5,a5,0x26
    80000cdc:	f8f43423          	sd	a5,-120(s0)
    flags |= PTE_W;
    flags &= ~PTE_C; // clear COW flag
    if((mem = kalloc()) == 0) {
      return -1; // out of memory
    }
    memmove(mem, (char *)pa, PGSIZE); // copy the page content
    80000ce0:	6c85                	lui	s9,0x1
    80000ce2:	a015                	j	80000d06 <copyout+0x58>
    if (pa0 == 0)
      return -1; // page not present
    n = PGSIZE - (dstva - va0);
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ce4:	413a0a33          	sub	s4,s4,s3
    80000ce8:	0004861b          	sext.w	a2,s1
    80000cec:	85e2                	mv	a1,s8
    80000cee:	9552                	add	a0,a0,s4
    80000cf0:	fffff097          	auipc	ra,0xfffff
    80000cf4:	62c080e7          	jalr	1580(ra) # 8000031c <memmove>
    len -= n;
    80000cf8:	409b8bb3          	sub	s7,s7,s1
    src += n;
    80000cfc:	9c26                	add	s8,s8,s1
    dstva = va0 + PGSIZE;
    80000cfe:	01998a33          	add	s4,s3,s9
  while (len > 0)
    80000d02:	080b8863          	beqz	s7,80000d92 <copyout+0xe4>
    va0 = PGROUNDDOWN(dstva);
    80000d06:	01ba79b3          	and	s3,s4,s11
    if(va0 > MAXVA) return -1;
    80000d0a:	f8843783          	ld	a5,-120(s0)
    80000d0e:	0937e663          	bltu	a5,s3,80000d9a <copyout+0xec>
    pte = walk(pagetable, va0, 0);
    80000d12:	4601                	li	a2,0
    80000d14:	85ce                	mv	a1,s3
    80000d16:	856a                	mv	a0,s10
    80000d18:	00000097          	auipc	ra,0x0
    80000d1c:	898080e7          	jalr	-1896(ra) # 800005b0 <walk>
    80000d20:	8aaa                	mv	s5,a0
    if(pte == 0 || (*pte & (PTE_V)) == 0 || (*pte & PTE_U) == 0) {
    80000d22:	cd41                	beqz	a0,80000dba <copyout+0x10c>
    80000d24:	611c                	ld	a5,0(a0)
    80000d26:	0117f713          	andi	a4,a5,17
    80000d2a:	46c5                	li	a3,17
    80000d2c:	08d71963          	bne	a4,a3,80000dbe <copyout+0x110>
    uint64 pa = PTE2PA(*pte);
    80000d30:	00a7db13          	srli	s6,a5,0xa
    80000d34:	0b32                	slli	s6,s6,0xc
    uint flags = PTE_FLAGS(*pte);
    80000d36:	0007891b          	sext.w	s2,a5
    if(!(flags & PTE_C)) return -1; // not a COW page, so can't write to it
    80000d3a:	1007f793          	andi	a5,a5,256
    80000d3e:	c3d1                	beqz	a5,80000dc2 <copyout+0x114>
    flags &= ~PTE_C; // clear COW flag
    80000d40:	2ff97913          	andi	s2,s2,767
    80000d44:	00496913          	ori	s2,s2,4
    if((mem = kalloc()) == 0) {
    80000d48:	fffff097          	auipc	ra,0xfffff
    80000d4c:	4d6080e7          	jalr	1238(ra) # 8000021e <kalloc>
    80000d50:	84aa                	mv	s1,a0
    80000d52:	c935                	beqz	a0,80000dc6 <copyout+0x118>
    memmove(mem, (char *)pa, PGSIZE); // copy the page content
    80000d54:	8666                	mv	a2,s9
    80000d56:	85da                	mv	a1,s6
    80000d58:	fffff097          	auipc	ra,0xfffff
    80000d5c:	5c4080e7          	jalr	1476(ra) # 8000031c <memmove>
    *pte = PA2PTE((uint64)mem) | flags; // update the page table entry
    80000d60:	80b1                	srli	s1,s1,0xc
    80000d62:	04aa                	slli	s1,s1,0xa
    80000d64:	00996933          	or	s2,s2,s1
    80000d68:	012ab023          	sd	s2,0(s5)
    kfree((void *)pa); // free the old page
    80000d6c:	855a                	mv	a0,s6
    80000d6e:	fffff097          	auipc	ra,0xfffff
    80000d72:	346080e7          	jalr	838(ra) # 800000b4 <kfree>
    pa0 = walkaddr(pagetable, va0);
    80000d76:	85ce                	mv	a1,s3
    80000d78:	856a                	mv	a0,s10
    80000d7a:	00000097          	auipc	ra,0x0
    80000d7e:	8dc080e7          	jalr	-1828(ra) # 80000656 <walkaddr>
    if (pa0 == 0)
    80000d82:	c521                	beqz	a0,80000dca <copyout+0x11c>
    n = PGSIZE - (dstva - va0);
    80000d84:	414984b3          	sub	s1,s3,s4
    80000d88:	94e6                	add	s1,s1,s9
    if (n > len)
    80000d8a:	f49bfde3          	bgeu	s7,s1,80000ce4 <copyout+0x36>
    80000d8e:	84de                	mv	s1,s7
    80000d90:	bf91                	j	80000ce4 <copyout+0x36>
  }
  return 0;
    80000d92:	4501                	li	a0,0
    80000d94:	a021                	j	80000d9c <copyout+0xee>
    80000d96:	4501                	li	a0,0
}
    80000d98:	8082                	ret
    if(va0 > MAXVA) return -1;
    80000d9a:	557d                	li	a0,-1
}
    80000d9c:	70e6                	ld	ra,120(sp)
    80000d9e:	7446                	ld	s0,112(sp)
    80000da0:	74a6                	ld	s1,104(sp)
    80000da2:	7906                	ld	s2,96(sp)
    80000da4:	69e6                	ld	s3,88(sp)
    80000da6:	6a46                	ld	s4,80(sp)
    80000da8:	6aa6                	ld	s5,72(sp)
    80000daa:	6b06                	ld	s6,64(sp)
    80000dac:	7be2                	ld	s7,56(sp)
    80000dae:	7c42                	ld	s8,48(sp)
    80000db0:	7ca2                	ld	s9,40(sp)
    80000db2:	7d02                	ld	s10,32(sp)
    80000db4:	6de2                	ld	s11,24(sp)
    80000db6:	6109                	addi	sp,sp,128
    80000db8:	8082                	ret
      return -1;
    80000dba:	557d                	li	a0,-1
    80000dbc:	b7c5                	j	80000d9c <copyout+0xee>
    80000dbe:	557d                	li	a0,-1
    80000dc0:	bff1                	j	80000d9c <copyout+0xee>
    if(!(flags & PTE_C)) return -1; // not a COW page, so can't write to it
    80000dc2:	557d                	li	a0,-1
    80000dc4:	bfe1                	j	80000d9c <copyout+0xee>
      return -1; // out of memory
    80000dc6:	557d                	li	a0,-1
    80000dc8:	bfd1                	j	80000d9c <copyout+0xee>
      return -1; // page not present
    80000dca:	557d                	li	a0,-1
    80000dcc:	bfc1                	j	80000d9c <copyout+0xee>

0000000080000dce <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while (len > 0)
    80000dce:	caa5                	beqz	a3,80000e3e <copyin+0x70>
{
    80000dd0:	715d                	addi	sp,sp,-80
    80000dd2:	e486                	sd	ra,72(sp)
    80000dd4:	e0a2                	sd	s0,64(sp)
    80000dd6:	fc26                	sd	s1,56(sp)
    80000dd8:	f84a                	sd	s2,48(sp)
    80000dda:	f44e                	sd	s3,40(sp)
    80000ddc:	f052                	sd	s4,32(sp)
    80000dde:	ec56                	sd	s5,24(sp)
    80000de0:	e85a                	sd	s6,16(sp)
    80000de2:	e45e                	sd	s7,8(sp)
    80000de4:	e062                	sd	s8,0(sp)
    80000de6:	0880                	addi	s0,sp,80
    80000de8:	8b2a                	mv	s6,a0
    80000dea:	8a2e                	mv	s4,a1
    80000dec:	8c32                	mv	s8,a2
    80000dee:	89b6                	mv	s3,a3
  {
    va0 = PGROUNDDOWN(srcva);
    80000df0:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000df2:	6a85                	lui	s5,0x1
    80000df4:	a01d                	j	80000e1a <copyin+0x4c>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000df6:	018505b3          	add	a1,a0,s8
    80000dfa:	0004861b          	sext.w	a2,s1
    80000dfe:	412585b3          	sub	a1,a1,s2
    80000e02:	8552                	mv	a0,s4
    80000e04:	fffff097          	auipc	ra,0xfffff
    80000e08:	518080e7          	jalr	1304(ra) # 8000031c <memmove>

    len -= n;
    80000e0c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000e10:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000e12:	01590c33          	add	s8,s2,s5
  while (len > 0)
    80000e16:	02098263          	beqz	s3,80000e3a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000e1a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000e1e:	85ca                	mv	a1,s2
    80000e20:	855a                	mv	a0,s6
    80000e22:	00000097          	auipc	ra,0x0
    80000e26:	834080e7          	jalr	-1996(ra) # 80000656 <walkaddr>
    if (pa0 == 0)
    80000e2a:	cd01                	beqz	a0,80000e42 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000e2c:	418904b3          	sub	s1,s2,s8
    80000e30:	94d6                	add	s1,s1,s5
    if (n > len)
    80000e32:	fc99f2e3          	bgeu	s3,s1,80000df6 <copyin+0x28>
    80000e36:	84ce                	mv	s1,s3
    80000e38:	bf7d                	j	80000df6 <copyin+0x28>
  }
  return 0;
    80000e3a:	4501                	li	a0,0
    80000e3c:	a021                	j	80000e44 <copyin+0x76>
    80000e3e:	4501                	li	a0,0
}
    80000e40:	8082                	ret
      return -1;
    80000e42:	557d                	li	a0,-1
}
    80000e44:	60a6                	ld	ra,72(sp)
    80000e46:	6406                	ld	s0,64(sp)
    80000e48:	74e2                	ld	s1,56(sp)
    80000e4a:	7942                	ld	s2,48(sp)
    80000e4c:	79a2                	ld	s3,40(sp)
    80000e4e:	7a02                	ld	s4,32(sp)
    80000e50:	6ae2                	ld	s5,24(sp)
    80000e52:	6b42                	ld	s6,16(sp)
    80000e54:	6ba2                	ld	s7,8(sp)
    80000e56:	6c02                	ld	s8,0(sp)
    80000e58:	6161                	addi	sp,sp,80
    80000e5a:	8082                	ret

0000000080000e5c <copyinstr>:
// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000e5c:	715d                	addi	sp,sp,-80
    80000e5e:	e486                	sd	ra,72(sp)
    80000e60:	e0a2                	sd	s0,64(sp)
    80000e62:	fc26                	sd	s1,56(sp)
    80000e64:	f84a                	sd	s2,48(sp)
    80000e66:	f44e                	sd	s3,40(sp)
    80000e68:	f052                	sd	s4,32(sp)
    80000e6a:	ec56                	sd	s5,24(sp)
    80000e6c:	e85a                	sd	s6,16(sp)
    80000e6e:	e45e                	sd	s7,8(sp)
    80000e70:	0880                	addi	s0,sp,80
    80000e72:	8aaa                	mv	s5,a0
    80000e74:	89ae                	mv	s3,a1
    80000e76:	8bb2                	mv	s7,a2
    80000e78:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0)
  {
    va0 = PGROUNDDOWN(srcva);
    80000e7a:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e7c:	6a05                	lui	s4,0x1
    80000e7e:	a02d                	j	80000ea8 <copyinstr+0x4c>
    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0)
    {
      if (*p == '\0')
      {
        *dst = '\0';
    80000e80:	00078023          	sb	zero,0(a5)
    80000e84:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null)
    80000e86:	0017c793          	xori	a5,a5,1
    80000e8a:	40f0053b          	negw	a0,a5
  }
  else
  {
    return -1;
  }
}
    80000e8e:	60a6                	ld	ra,72(sp)
    80000e90:	6406                	ld	s0,64(sp)
    80000e92:	74e2                	ld	s1,56(sp)
    80000e94:	7942                	ld	s2,48(sp)
    80000e96:	79a2                	ld	s3,40(sp)
    80000e98:	7a02                	ld	s4,32(sp)
    80000e9a:	6ae2                	ld	s5,24(sp)
    80000e9c:	6b42                	ld	s6,16(sp)
    80000e9e:	6ba2                	ld	s7,8(sp)
    80000ea0:	6161                	addi	sp,sp,80
    80000ea2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000ea4:	01490bb3          	add	s7,s2,s4
  while (got_null == 0 && max > 0)
    80000ea8:	c8a1                	beqz	s1,80000ef8 <copyinstr+0x9c>
    va0 = PGROUNDDOWN(srcva);
    80000eaa:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000eae:	85ca                	mv	a1,s2
    80000eb0:	8556                	mv	a0,s5
    80000eb2:	fffff097          	auipc	ra,0xfffff
    80000eb6:	7a4080e7          	jalr	1956(ra) # 80000656 <walkaddr>
    if (pa0 == 0)
    80000eba:	c129                	beqz	a0,80000efc <copyinstr+0xa0>
    n = PGSIZE - (srcva - va0);
    80000ebc:	41790633          	sub	a2,s2,s7
    80000ec0:	9652                	add	a2,a2,s4
    if (n > max)
    80000ec2:	00c4f363          	bgeu	s1,a2,80000ec8 <copyinstr+0x6c>
    80000ec6:	8626                	mv	a2,s1
    char *p = (char *)(pa0 + (srcva - va0));
    80000ec8:	412b8bb3          	sub	s7,s7,s2
    80000ecc:	9baa                	add	s7,s7,a0
    while (n > 0)
    80000ece:	da79                	beqz	a2,80000ea4 <copyinstr+0x48>
    80000ed0:	87ce                	mv	a5,s3
      if (*p == '\0')
    80000ed2:	413b86b3          	sub	a3,s7,s3
    while (n > 0)
    80000ed6:	964e                	add	a2,a2,s3
    80000ed8:	85be                	mv	a1,a5
      if (*p == '\0')
    80000eda:	00f68733          	add	a4,a3,a5
    80000ede:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fd98dc0>
    80000ee2:	df59                	beqz	a4,80000e80 <copyinstr+0x24>
        *dst = *p;
    80000ee4:	00e78023          	sb	a4,0(a5)
      dst++;
    80000ee8:	0785                	addi	a5,a5,1
    while (n > 0)
    80000eea:	fec797e3          	bne	a5,a2,80000ed8 <copyinstr+0x7c>
    80000eee:	14fd                	addi	s1,s1,-1
    80000ef0:	94ce                	add	s1,s1,s3
      --max;
    80000ef2:	8c8d                	sub	s1,s1,a1
    80000ef4:	89be                	mv	s3,a5
    80000ef6:	b77d                	j	80000ea4 <copyinstr+0x48>
    80000ef8:	4781                	li	a5,0
    80000efa:	b771                	j	80000e86 <copyinstr+0x2a>
      return -1;
    80000efc:	557d                	li	a0,-1
    80000efe:	bf41                	j	80000e8e <copyinstr+0x32>

0000000080000f00 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000f00:	715d                	addi	sp,sp,-80
    80000f02:	e486                	sd	ra,72(sp)
    80000f04:	e0a2                	sd	s0,64(sp)
    80000f06:	fc26                	sd	s1,56(sp)
    80000f08:	f84a                	sd	s2,48(sp)
    80000f0a:	f44e                	sd	s3,40(sp)
    80000f0c:	f052                	sd	s4,32(sp)
    80000f0e:	ec56                	sd	s5,24(sp)
    80000f10:	e85a                	sd	s6,16(sp)
    80000f12:	e45e                	sd	s7,8(sp)
    80000f14:	e062                	sd	s8,0(sp)
    80000f16:	0880                	addi	s0,sp,80
    80000f18:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f1a:	00248497          	auipc	s1,0x248
    80000f1e:	59e48493          	addi	s1,s1,1438 # 802494b8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f22:	8c26                	mv	s8,s1
    80000f24:	a4fa57b7          	lui	a5,0xa4fa5
    80000f28:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24d3ed65>
    80000f2c:	4fa50937          	lui	s2,0x4fa50
    80000f30:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000f34:	1902                	slli	s2,s2,0x20
    80000f36:	993e                	add	s2,s2,a5
    80000f38:	040009b7          	lui	s3,0x4000
    80000f3c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000f3e:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f40:	4b99                	li	s7,6
    80000f42:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f44:	0024ea97          	auipc	s5,0x24e
    80000f48:	f74a8a93          	addi	s5,s5,-140 # 8024eeb8 <tickslock>
    char *pa = kalloc();
    80000f4c:	fffff097          	auipc	ra,0xfffff
    80000f50:	2d2080e7          	jalr	722(ra) # 8000021e <kalloc>
    80000f54:	862a                	mv	a2,a0
    if(pa == 0)
    80000f56:	c131                	beqz	a0,80000f9a <proc_mapstacks+0x9a>
    uint64 va = KSTACK((int) (p - proc));
    80000f58:	418485b3          	sub	a1,s1,s8
    80000f5c:	858d                	srai	a1,a1,0x3
    80000f5e:	032585b3          	mul	a1,a1,s2
    80000f62:	2585                	addiw	a1,a1,1
    80000f64:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f68:	875e                	mv	a4,s7
    80000f6a:	86da                	mv	a3,s6
    80000f6c:	40b985b3          	sub	a1,s3,a1
    80000f70:	8552                	mv	a0,s4
    80000f72:	fffff097          	auipc	ra,0xfffff
    80000f76:	7cc080e7          	jalr	1996(ra) # 8000073e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7a:	16848493          	addi	s1,s1,360
    80000f7e:	fd5497e3          	bne	s1,s5,80000f4c <proc_mapstacks+0x4c>
  }
}
    80000f82:	60a6                	ld	ra,72(sp)
    80000f84:	6406                	ld	s0,64(sp)
    80000f86:	74e2                	ld	s1,56(sp)
    80000f88:	7942                	ld	s2,48(sp)
    80000f8a:	79a2                	ld	s3,40(sp)
    80000f8c:	7a02                	ld	s4,32(sp)
    80000f8e:	6ae2                	ld	s5,24(sp)
    80000f90:	6b42                	ld	s6,16(sp)
    80000f92:	6ba2                	ld	s7,8(sp)
    80000f94:	6c02                	ld	s8,0(sp)
    80000f96:	6161                	addi	sp,sp,80
    80000f98:	8082                	ret
      panic("kalloc");
    80000f9a:	00007517          	auipc	a0,0x7
    80000f9e:	1ce50513          	addi	a0,a0,462 # 80008168 <etext+0x168>
    80000fa2:	00005097          	auipc	ra,0x5
    80000fa6:	f70080e7          	jalr	-144(ra) # 80005f12 <panic>

0000000080000faa <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000faa:	7139                	addi	sp,sp,-64
    80000fac:	fc06                	sd	ra,56(sp)
    80000fae:	f822                	sd	s0,48(sp)
    80000fb0:	f426                	sd	s1,40(sp)
    80000fb2:	f04a                	sd	s2,32(sp)
    80000fb4:	ec4e                	sd	s3,24(sp)
    80000fb6:	e852                	sd	s4,16(sp)
    80000fb8:	e456                	sd	s5,8(sp)
    80000fba:	e05a                	sd	s6,0(sp)
    80000fbc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000fbe:	00007597          	auipc	a1,0x7
    80000fc2:	1b258593          	addi	a1,a1,434 # 80008170 <etext+0x170>
    80000fc6:	00248517          	auipc	a0,0x248
    80000fca:	0c250513          	addi	a0,a0,194 # 80249088 <pid_lock>
    80000fce:	00005097          	auipc	ra,0x5
    80000fd2:	430080e7          	jalr	1072(ra) # 800063fe <initlock>
  initlock(&wait_lock, "wait_lock");
    80000fd6:	00007597          	auipc	a1,0x7
    80000fda:	1a258593          	addi	a1,a1,418 # 80008178 <etext+0x178>
    80000fde:	00248517          	auipc	a0,0x248
    80000fe2:	0c250513          	addi	a0,a0,194 # 802490a0 <wait_lock>
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	418080e7          	jalr	1048(ra) # 800063fe <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fee:	00248497          	auipc	s1,0x248
    80000ff2:	4ca48493          	addi	s1,s1,1226 # 802494b8 <proc>
      initlock(&p->lock, "proc");
    80000ff6:	00007b17          	auipc	s6,0x7
    80000ffa:	192b0b13          	addi	s6,s6,402 # 80008188 <etext+0x188>
      p->kstack = KSTACK((int) (p - proc));
    80000ffe:	8aa6                	mv	s5,s1
    80001000:	a4fa57b7          	lui	a5,0xa4fa5
    80001004:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24d3ed65>
    80001008:	4fa50937          	lui	s2,0x4fa50
    8000100c:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80001010:	1902                	slli	s2,s2,0x20
    80001012:	993e                	add	s2,s2,a5
    80001014:	040009b7          	lui	s3,0x4000
    80001018:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000101a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000101c:	0024ea17          	auipc	s4,0x24e
    80001020:	e9ca0a13          	addi	s4,s4,-356 # 8024eeb8 <tickslock>
      initlock(&p->lock, "proc");
    80001024:	85da                	mv	a1,s6
    80001026:	8526                	mv	a0,s1
    80001028:	00005097          	auipc	ra,0x5
    8000102c:	3d6080e7          	jalr	982(ra) # 800063fe <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80001030:	415487b3          	sub	a5,s1,s5
    80001034:	878d                	srai	a5,a5,0x3
    80001036:	032787b3          	mul	a5,a5,s2
    8000103a:	2785                	addiw	a5,a5,1
    8000103c:	00d7979b          	slliw	a5,a5,0xd
    80001040:	40f987b3          	sub	a5,s3,a5
    80001044:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001046:	16848493          	addi	s1,s1,360
    8000104a:	fd449de3          	bne	s1,s4,80001024 <procinit+0x7a>
  }
}
    8000104e:	70e2                	ld	ra,56(sp)
    80001050:	7442                	ld	s0,48(sp)
    80001052:	74a2                	ld	s1,40(sp)
    80001054:	7902                	ld	s2,32(sp)
    80001056:	69e2                	ld	s3,24(sp)
    80001058:	6a42                	ld	s4,16(sp)
    8000105a:	6aa2                	ld	s5,8(sp)
    8000105c:	6b02                	ld	s6,0(sp)
    8000105e:	6121                	addi	sp,sp,64
    80001060:	8082                	ret

0000000080001062 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001062:	1141                	addi	sp,sp,-16
    80001064:	e406                	sd	ra,8(sp)
    80001066:	e022                	sd	s0,0(sp)
    80001068:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000106a:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000106c:	2501                	sext.w	a0,a0
    8000106e:	60a2                	ld	ra,8(sp)
    80001070:	6402                	ld	s0,0(sp)
    80001072:	0141                	addi	sp,sp,16
    80001074:	8082                	ret

0000000080001076 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001076:	1141                	addi	sp,sp,-16
    80001078:	e406                	sd	ra,8(sp)
    8000107a:	e022                	sd	s0,0(sp)
    8000107c:	0800                	addi	s0,sp,16
    8000107e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001080:	2781                	sext.w	a5,a5
    80001082:	079e                	slli	a5,a5,0x7
  return c;
}
    80001084:	00248517          	auipc	a0,0x248
    80001088:	03450513          	addi	a0,a0,52 # 802490b8 <cpus>
    8000108c:	953e                	add	a0,a0,a5
    8000108e:	60a2                	ld	ra,8(sp)
    80001090:	6402                	ld	s0,0(sp)
    80001092:	0141                	addi	sp,sp,16
    80001094:	8082                	ret

0000000080001096 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001096:	1101                	addi	sp,sp,-32
    80001098:	ec06                	sd	ra,24(sp)
    8000109a:	e822                	sd	s0,16(sp)
    8000109c:	e426                	sd	s1,8(sp)
    8000109e:	1000                	addi	s0,sp,32
  push_off();
    800010a0:	00005097          	auipc	ra,0x5
    800010a4:	3a6080e7          	jalr	934(ra) # 80006446 <push_off>
    800010a8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800010aa:	2781                	sext.w	a5,a5
    800010ac:	079e                	slli	a5,a5,0x7
    800010ae:	00248717          	auipc	a4,0x248
    800010b2:	fda70713          	addi	a4,a4,-38 # 80249088 <pid_lock>
    800010b6:	97ba                	add	a5,a5,a4
    800010b8:	7b84                	ld	s1,48(a5)
  pop_off();
    800010ba:	00005097          	auipc	ra,0x5
    800010be:	42c080e7          	jalr	1068(ra) # 800064e6 <pop_off>
  return p;
}
    800010c2:	8526                	mv	a0,s1
    800010c4:	60e2                	ld	ra,24(sp)
    800010c6:	6442                	ld	s0,16(sp)
    800010c8:	64a2                	ld	s1,8(sp)
    800010ca:	6105                	addi	sp,sp,32
    800010cc:	8082                	ret

00000000800010ce <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010ce:	1141                	addi	sp,sp,-16
    800010d0:	e406                	sd	ra,8(sp)
    800010d2:	e022                	sd	s0,0(sp)
    800010d4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010d6:	00000097          	auipc	ra,0x0
    800010da:	fc0080e7          	jalr	-64(ra) # 80001096 <myproc>
    800010de:	00005097          	auipc	ra,0x5
    800010e2:	464080e7          	jalr	1124(ra) # 80006542 <release>

  if (first) {
    800010e6:	00007797          	auipc	a5,0x7
    800010ea:	73a7a783          	lw	a5,1850(a5) # 80008820 <first.1>
    800010ee:	eb89                	bnez	a5,80001100 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010f0:	00001097          	auipc	ra,0x1
    800010f4:	c14080e7          	jalr	-1004(ra) # 80001d04 <usertrapret>
}
    800010f8:	60a2                	ld	ra,8(sp)
    800010fa:	6402                	ld	s0,0(sp)
    800010fc:	0141                	addi	sp,sp,16
    800010fe:	8082                	ret
    first = 0;
    80001100:	00007797          	auipc	a5,0x7
    80001104:	7207a023          	sw	zero,1824(a5) # 80008820 <first.1>
    fsinit(ROOTDEV);
    80001108:	4505                	li	a0,1
    8000110a:	00002097          	auipc	ra,0x2
    8000110e:	9dc080e7          	jalr	-1572(ra) # 80002ae6 <fsinit>
    80001112:	bff9                	j	800010f0 <forkret+0x22>

0000000080001114 <allocpid>:
allocpid() {
    80001114:	1101                	addi	sp,sp,-32
    80001116:	ec06                	sd	ra,24(sp)
    80001118:	e822                	sd	s0,16(sp)
    8000111a:	e426                	sd	s1,8(sp)
    8000111c:	e04a                	sd	s2,0(sp)
    8000111e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001120:	00248917          	auipc	s2,0x248
    80001124:	f6890913          	addi	s2,s2,-152 # 80249088 <pid_lock>
    80001128:	854a                	mv	a0,s2
    8000112a:	00005097          	auipc	ra,0x5
    8000112e:	368080e7          	jalr	872(ra) # 80006492 <acquire>
  pid = nextpid;
    80001132:	00007797          	auipc	a5,0x7
    80001136:	6f278793          	addi	a5,a5,1778 # 80008824 <nextpid>
    8000113a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000113c:	0014871b          	addiw	a4,s1,1
    80001140:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001142:	854a                	mv	a0,s2
    80001144:	00005097          	auipc	ra,0x5
    80001148:	3fe080e7          	jalr	1022(ra) # 80006542 <release>
}
    8000114c:	8526                	mv	a0,s1
    8000114e:	60e2                	ld	ra,24(sp)
    80001150:	6442                	ld	s0,16(sp)
    80001152:	64a2                	ld	s1,8(sp)
    80001154:	6902                	ld	s2,0(sp)
    80001156:	6105                	addi	sp,sp,32
    80001158:	8082                	ret

000000008000115a <proc_pagetable>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	e04a                	sd	s2,0(sp)
    80001164:	1000                	addi	s0,sp,32
    80001166:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001168:	fffff097          	auipc	ra,0xfffff
    8000116c:	7ca080e7          	jalr	1994(ra) # 80000932 <uvmcreate>
    80001170:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001172:	c121                	beqz	a0,800011b2 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001174:	4729                	li	a4,10
    80001176:	00006697          	auipc	a3,0x6
    8000117a:	e8a68693          	addi	a3,a3,-374 # 80007000 <_trampoline>
    8000117e:	6605                	lui	a2,0x1
    80001180:	040005b7          	lui	a1,0x4000
    80001184:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001186:	05b2                	slli	a1,a1,0xc
    80001188:	fffff097          	auipc	ra,0xfffff
    8000118c:	510080e7          	jalr	1296(ra) # 80000698 <mappages>
    80001190:	02054863          	bltz	a0,800011c0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001194:	4719                	li	a4,6
    80001196:	05893683          	ld	a3,88(s2)
    8000119a:	6605                	lui	a2,0x1
    8000119c:	020005b7          	lui	a1,0x2000
    800011a0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011a2:	05b6                	slli	a1,a1,0xd
    800011a4:	8526                	mv	a0,s1
    800011a6:	fffff097          	auipc	ra,0xfffff
    800011aa:	4f2080e7          	jalr	1266(ra) # 80000698 <mappages>
    800011ae:	02054163          	bltz	a0,800011d0 <proc_pagetable+0x76>
}
    800011b2:	8526                	mv	a0,s1
    800011b4:	60e2                	ld	ra,24(sp)
    800011b6:	6442                	ld	s0,16(sp)
    800011b8:	64a2                	ld	s1,8(sp)
    800011ba:	6902                	ld	s2,0(sp)
    800011bc:	6105                	addi	sp,sp,32
    800011be:	8082                	ret
    uvmfree(pagetable, 0);
    800011c0:	4581                	li	a1,0
    800011c2:	8526                	mv	a0,s1
    800011c4:	00000097          	auipc	ra,0x0
    800011c8:	986080e7          	jalr	-1658(ra) # 80000b4a <uvmfree>
    return 0;
    800011cc:	4481                	li	s1,0
    800011ce:	b7d5                	j	800011b2 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011d0:	4681                	li	a3,0
    800011d2:	4605                	li	a2,1
    800011d4:	040005b7          	lui	a1,0x4000
    800011d8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011da:	05b2                	slli	a1,a1,0xc
    800011dc:	8526                	mv	a0,s1
    800011de:	fffff097          	auipc	ra,0xfffff
    800011e2:	680080e7          	jalr	1664(ra) # 8000085e <uvmunmap>
    uvmfree(pagetable, 0);
    800011e6:	4581                	li	a1,0
    800011e8:	8526                	mv	a0,s1
    800011ea:	00000097          	auipc	ra,0x0
    800011ee:	960080e7          	jalr	-1696(ra) # 80000b4a <uvmfree>
    return 0;
    800011f2:	4481                	li	s1,0
    800011f4:	bf7d                	j	800011b2 <proc_pagetable+0x58>

00000000800011f6 <proc_freepagetable>:
{
    800011f6:	1101                	addi	sp,sp,-32
    800011f8:	ec06                	sd	ra,24(sp)
    800011fa:	e822                	sd	s0,16(sp)
    800011fc:	e426                	sd	s1,8(sp)
    800011fe:	e04a                	sd	s2,0(sp)
    80001200:	1000                	addi	s0,sp,32
    80001202:	84aa                	mv	s1,a0
    80001204:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001206:	4681                	li	a3,0
    80001208:	4605                	li	a2,1
    8000120a:	040005b7          	lui	a1,0x4000
    8000120e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001210:	05b2                	slli	a1,a1,0xc
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	64c080e7          	jalr	1612(ra) # 8000085e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000121a:	4681                	li	a3,0
    8000121c:	4605                	li	a2,1
    8000121e:	020005b7          	lui	a1,0x2000
    80001222:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001224:	05b6                	slli	a1,a1,0xd
    80001226:	8526                	mv	a0,s1
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	636080e7          	jalr	1590(ra) # 8000085e <uvmunmap>
  uvmfree(pagetable, sz);
    80001230:	85ca                	mv	a1,s2
    80001232:	8526                	mv	a0,s1
    80001234:	00000097          	auipc	ra,0x0
    80001238:	916080e7          	jalr	-1770(ra) # 80000b4a <uvmfree>
}
    8000123c:	60e2                	ld	ra,24(sp)
    8000123e:	6442                	ld	s0,16(sp)
    80001240:	64a2                	ld	s1,8(sp)
    80001242:	6902                	ld	s2,0(sp)
    80001244:	6105                	addi	sp,sp,32
    80001246:	8082                	ret

0000000080001248 <freeproc>:
{
    80001248:	1101                	addi	sp,sp,-32
    8000124a:	ec06                	sd	ra,24(sp)
    8000124c:	e822                	sd	s0,16(sp)
    8000124e:	e426                	sd	s1,8(sp)
    80001250:	1000                	addi	s0,sp,32
    80001252:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001254:	6d28                	ld	a0,88(a0)
    80001256:	c509                	beqz	a0,80001260 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	e5c080e7          	jalr	-420(ra) # 800000b4 <kfree>
  p->trapframe = 0;
    80001260:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001264:	68a8                	ld	a0,80(s1)
    80001266:	c511                	beqz	a0,80001272 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001268:	64ac                	ld	a1,72(s1)
    8000126a:	00000097          	auipc	ra,0x0
    8000126e:	f8c080e7          	jalr	-116(ra) # 800011f6 <proc_freepagetable>
  p->pagetable = 0;
    80001272:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001276:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000127a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000127e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001282:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001286:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000128a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000128e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001292:	0004ac23          	sw	zero,24(s1)
}
    80001296:	60e2                	ld	ra,24(sp)
    80001298:	6442                	ld	s0,16(sp)
    8000129a:	64a2                	ld	s1,8(sp)
    8000129c:	6105                	addi	sp,sp,32
    8000129e:	8082                	ret

00000000800012a0 <allocproc>:
{
    800012a0:	1101                	addi	sp,sp,-32
    800012a2:	ec06                	sd	ra,24(sp)
    800012a4:	e822                	sd	s0,16(sp)
    800012a6:	e426                	sd	s1,8(sp)
    800012a8:	e04a                	sd	s2,0(sp)
    800012aa:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800012ac:	00248497          	auipc	s1,0x248
    800012b0:	20c48493          	addi	s1,s1,524 # 802494b8 <proc>
    800012b4:	0024e917          	auipc	s2,0x24e
    800012b8:	c0490913          	addi	s2,s2,-1020 # 8024eeb8 <tickslock>
    acquire(&p->lock);
    800012bc:	8526                	mv	a0,s1
    800012be:	00005097          	auipc	ra,0x5
    800012c2:	1d4080e7          	jalr	468(ra) # 80006492 <acquire>
    if(p->state == UNUSED) {
    800012c6:	4c9c                	lw	a5,24(s1)
    800012c8:	cf81                	beqz	a5,800012e0 <allocproc+0x40>
      release(&p->lock);
    800012ca:	8526                	mv	a0,s1
    800012cc:	00005097          	auipc	ra,0x5
    800012d0:	276080e7          	jalr	630(ra) # 80006542 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012d4:	16848493          	addi	s1,s1,360
    800012d8:	ff2492e3          	bne	s1,s2,800012bc <allocproc+0x1c>
  return 0;
    800012dc:	4481                	li	s1,0
    800012de:	a889                	j	80001330 <allocproc+0x90>
  p->pid = allocpid();
    800012e0:	00000097          	auipc	ra,0x0
    800012e4:	e34080e7          	jalr	-460(ra) # 80001114 <allocpid>
    800012e8:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012ea:	4785                	li	a5,1
    800012ec:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	f30080e7          	jalr	-208(ra) # 8000021e <kalloc>
    800012f6:	892a                	mv	s2,a0
    800012f8:	eca8                	sd	a0,88(s1)
    800012fa:	c131                	beqz	a0,8000133e <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012fc:	8526                	mv	a0,s1
    800012fe:	00000097          	auipc	ra,0x0
    80001302:	e5c080e7          	jalr	-420(ra) # 8000115a <proc_pagetable>
    80001306:	892a                	mv	s2,a0
    80001308:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000130a:	c531                	beqz	a0,80001356 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    8000130c:	07000613          	li	a2,112
    80001310:	4581                	li	a1,0
    80001312:	06048513          	addi	a0,s1,96
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	fa2080e7          	jalr	-94(ra) # 800002b8 <memset>
  p->context.ra = (uint64)forkret;
    8000131e:	00000797          	auipc	a5,0x0
    80001322:	db078793          	addi	a5,a5,-592 # 800010ce <forkret>
    80001326:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001328:	60bc                	ld	a5,64(s1)
    8000132a:	6705                	lui	a4,0x1
    8000132c:	97ba                	add	a5,a5,a4
    8000132e:	f4bc                	sd	a5,104(s1)
}
    80001330:	8526                	mv	a0,s1
    80001332:	60e2                	ld	ra,24(sp)
    80001334:	6442                	ld	s0,16(sp)
    80001336:	64a2                	ld	s1,8(sp)
    80001338:	6902                	ld	s2,0(sp)
    8000133a:	6105                	addi	sp,sp,32
    8000133c:	8082                	ret
    freeproc(p);
    8000133e:	8526                	mv	a0,s1
    80001340:	00000097          	auipc	ra,0x0
    80001344:	f08080e7          	jalr	-248(ra) # 80001248 <freeproc>
    release(&p->lock);
    80001348:	8526                	mv	a0,s1
    8000134a:	00005097          	auipc	ra,0x5
    8000134e:	1f8080e7          	jalr	504(ra) # 80006542 <release>
    return 0;
    80001352:	84ca                	mv	s1,s2
    80001354:	bff1                	j	80001330 <allocproc+0x90>
    freeproc(p);
    80001356:	8526                	mv	a0,s1
    80001358:	00000097          	auipc	ra,0x0
    8000135c:	ef0080e7          	jalr	-272(ra) # 80001248 <freeproc>
    release(&p->lock);
    80001360:	8526                	mv	a0,s1
    80001362:	00005097          	auipc	ra,0x5
    80001366:	1e0080e7          	jalr	480(ra) # 80006542 <release>
    return 0;
    8000136a:	84ca                	mv	s1,s2
    8000136c:	b7d1                	j	80001330 <allocproc+0x90>

000000008000136e <userinit>:
{
    8000136e:	1101                	addi	sp,sp,-32
    80001370:	ec06                	sd	ra,24(sp)
    80001372:	e822                	sd	s0,16(sp)
    80001374:	e426                	sd	s1,8(sp)
    80001376:	1000                	addi	s0,sp,32
  p = allocproc();
    80001378:	00000097          	auipc	ra,0x0
    8000137c:	f28080e7          	jalr	-216(ra) # 800012a0 <allocproc>
    80001380:	84aa                	mv	s1,a0
  initproc = p;
    80001382:	00008797          	auipc	a5,0x8
    80001386:	c8a7b723          	sd	a0,-882(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000138a:	03400613          	li	a2,52
    8000138e:	00007597          	auipc	a1,0x7
    80001392:	4a258593          	addi	a1,a1,1186 # 80008830 <initcode>
    80001396:	6928                	ld	a0,80(a0)
    80001398:	fffff097          	auipc	ra,0xfffff
    8000139c:	5c8080e7          	jalr	1480(ra) # 80000960 <uvminit>
  p->sz = PGSIZE;
    800013a0:	6785                	lui	a5,0x1
    800013a2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013a4:	6cb8                	ld	a4,88(s1)
    800013a6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800013aa:	6cb8                	ld	a4,88(s1)
    800013ac:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800013ae:	4641                	li	a2,16
    800013b0:	00007597          	auipc	a1,0x7
    800013b4:	de058593          	addi	a1,a1,-544 # 80008190 <etext+0x190>
    800013b8:	15848513          	addi	a0,s1,344
    800013bc:	fffff097          	auipc	ra,0xfffff
    800013c0:	052080e7          	jalr	82(ra) # 8000040e <safestrcpy>
  p->cwd = namei("/");
    800013c4:	00007517          	auipc	a0,0x7
    800013c8:	ddc50513          	addi	a0,a0,-548 # 800081a0 <etext+0x1a0>
    800013cc:	00002097          	auipc	ra,0x2
    800013d0:	17a080e7          	jalr	378(ra) # 80003546 <namei>
    800013d4:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013d8:	478d                	li	a5,3
    800013da:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013dc:	8526                	mv	a0,s1
    800013de:	00005097          	auipc	ra,0x5
    800013e2:	164080e7          	jalr	356(ra) # 80006542 <release>
}
    800013e6:	60e2                	ld	ra,24(sp)
    800013e8:	6442                	ld	s0,16(sp)
    800013ea:	64a2                	ld	s1,8(sp)
    800013ec:	6105                	addi	sp,sp,32
    800013ee:	8082                	ret

00000000800013f0 <growproc>:
{
    800013f0:	1101                	addi	sp,sp,-32
    800013f2:	ec06                	sd	ra,24(sp)
    800013f4:	e822                	sd	s0,16(sp)
    800013f6:	e426                	sd	s1,8(sp)
    800013f8:	e04a                	sd	s2,0(sp)
    800013fa:	1000                	addi	s0,sp,32
    800013fc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800013fe:	00000097          	auipc	ra,0x0
    80001402:	c98080e7          	jalr	-872(ra) # 80001096 <myproc>
    80001406:	892a                	mv	s2,a0
  sz = p->sz;
    80001408:	652c                	ld	a1,72(a0)
    8000140a:	0005879b          	sext.w	a5,a1
  if(n > 0){
    8000140e:	00904f63          	bgtz	s1,8000142c <growproc+0x3c>
  } else if(n < 0){
    80001412:	0204cd63          	bltz	s1,8000144c <growproc+0x5c>
  p->sz = sz;
    80001416:	1782                	slli	a5,a5,0x20
    80001418:	9381                	srli	a5,a5,0x20
    8000141a:	04f93423          	sd	a5,72(s2)
  return 0;
    8000141e:	4501                	li	a0,0
}
    80001420:	60e2                	ld	ra,24(sp)
    80001422:	6442                	ld	s0,16(sp)
    80001424:	64a2                	ld	s1,8(sp)
    80001426:	6902                	ld	s2,0(sp)
    80001428:	6105                	addi	sp,sp,32
    8000142a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    8000142c:	00f4863b          	addw	a2,s1,a5
    80001430:	1602                	slli	a2,a2,0x20
    80001432:	9201                	srli	a2,a2,0x20
    80001434:	1582                	slli	a1,a1,0x20
    80001436:	9181                	srli	a1,a1,0x20
    80001438:	6928                	ld	a0,80(a0)
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	5e0080e7          	jalr	1504(ra) # 80000a1a <uvmalloc>
    80001442:	0005079b          	sext.w	a5,a0
    80001446:	fbe1                	bnez	a5,80001416 <growproc+0x26>
      return -1;
    80001448:	557d                	li	a0,-1
    8000144a:	bfd9                	j	80001420 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000144c:	00f4863b          	addw	a2,s1,a5
    80001450:	1602                	slli	a2,a2,0x20
    80001452:	9201                	srli	a2,a2,0x20
    80001454:	1582                	slli	a1,a1,0x20
    80001456:	9181                	srli	a1,a1,0x20
    80001458:	6928                	ld	a0,80(a0)
    8000145a:	fffff097          	auipc	ra,0xfffff
    8000145e:	578080e7          	jalr	1400(ra) # 800009d2 <uvmdealloc>
    80001462:	0005079b          	sext.w	a5,a0
    80001466:	bf45                	j	80001416 <growproc+0x26>

0000000080001468 <fork>:
{
    80001468:	7139                	addi	sp,sp,-64
    8000146a:	fc06                	sd	ra,56(sp)
    8000146c:	f822                	sd	s0,48(sp)
    8000146e:	f04a                	sd	s2,32(sp)
    80001470:	e456                	sd	s5,8(sp)
    80001472:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001474:	00000097          	auipc	ra,0x0
    80001478:	c22080e7          	jalr	-990(ra) # 80001096 <myproc>
    8000147c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000147e:	00000097          	auipc	ra,0x0
    80001482:	e22080e7          	jalr	-478(ra) # 800012a0 <allocproc>
    80001486:	12050063          	beqz	a0,800015a6 <fork+0x13e>
    8000148a:	e852                	sd	s4,16(sp)
    8000148c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000148e:	048ab603          	ld	a2,72(s5)
    80001492:	692c                	ld	a1,80(a0)
    80001494:	050ab503          	ld	a0,80(s5)
    80001498:	fffff097          	auipc	ra,0xfffff
    8000149c:	6ec080e7          	jalr	1772(ra) # 80000b84 <uvmcopy>
    800014a0:	04054a63          	bltz	a0,800014f4 <fork+0x8c>
    800014a4:	f426                	sd	s1,40(sp)
    800014a6:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800014a8:	048ab783          	ld	a5,72(s5)
    800014ac:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800014b0:	058ab683          	ld	a3,88(s5)
    800014b4:	87b6                	mv	a5,a3
    800014b6:	058a3703          	ld	a4,88(s4)
    800014ba:	12068693          	addi	a3,a3,288
    800014be:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014c2:	6788                	ld	a0,8(a5)
    800014c4:	6b8c                	ld	a1,16(a5)
    800014c6:	6f90                	ld	a2,24(a5)
    800014c8:	01073023          	sd	a6,0(a4)
    800014cc:	e708                	sd	a0,8(a4)
    800014ce:	eb0c                	sd	a1,16(a4)
    800014d0:	ef10                	sd	a2,24(a4)
    800014d2:	02078793          	addi	a5,a5,32
    800014d6:	02070713          	addi	a4,a4,32
    800014da:	fed792e3          	bne	a5,a3,800014be <fork+0x56>
  np->trapframe->a0 = 0;
    800014de:	058a3783          	ld	a5,88(s4)
    800014e2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014e6:	0d0a8493          	addi	s1,s5,208
    800014ea:	0d0a0913          	addi	s2,s4,208
    800014ee:	150a8993          	addi	s3,s5,336
    800014f2:	a015                	j	80001516 <fork+0xae>
    freeproc(np);
    800014f4:	8552                	mv	a0,s4
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	d52080e7          	jalr	-686(ra) # 80001248 <freeproc>
    release(&np->lock);
    800014fe:	8552                	mv	a0,s4
    80001500:	00005097          	auipc	ra,0x5
    80001504:	042080e7          	jalr	66(ra) # 80006542 <release>
    return -1;
    80001508:	597d                	li	s2,-1
    8000150a:	6a42                	ld	s4,16(sp)
    8000150c:	a071                	j	80001598 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    8000150e:	04a1                	addi	s1,s1,8
    80001510:	0921                	addi	s2,s2,8
    80001512:	01348b63          	beq	s1,s3,80001528 <fork+0xc0>
    if(p->ofile[i])
    80001516:	6088                	ld	a0,0(s1)
    80001518:	d97d                	beqz	a0,8000150e <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    8000151a:	00002097          	auipc	ra,0x2
    8000151e:	6b0080e7          	jalr	1712(ra) # 80003bca <filedup>
    80001522:	00a93023          	sd	a0,0(s2)
    80001526:	b7e5                	j	8000150e <fork+0xa6>
  np->cwd = idup(p->cwd);
    80001528:	150ab503          	ld	a0,336(s5)
    8000152c:	00001097          	auipc	ra,0x1
    80001530:	7f0080e7          	jalr	2032(ra) # 80002d1c <idup>
    80001534:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001538:	4641                	li	a2,16
    8000153a:	158a8593          	addi	a1,s5,344
    8000153e:	158a0513          	addi	a0,s4,344
    80001542:	fffff097          	auipc	ra,0xfffff
    80001546:	ecc080e7          	jalr	-308(ra) # 8000040e <safestrcpy>
  pid = np->pid;
    8000154a:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    8000154e:	8552                	mv	a0,s4
    80001550:	00005097          	auipc	ra,0x5
    80001554:	ff2080e7          	jalr	-14(ra) # 80006542 <release>
  acquire(&wait_lock);
    80001558:	00248497          	auipc	s1,0x248
    8000155c:	b4848493          	addi	s1,s1,-1208 # 802490a0 <wait_lock>
    80001560:	8526                	mv	a0,s1
    80001562:	00005097          	auipc	ra,0x5
    80001566:	f30080e7          	jalr	-208(ra) # 80006492 <acquire>
  np->parent = p;
    8000156a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	00005097          	auipc	ra,0x5
    80001574:	fd2080e7          	jalr	-46(ra) # 80006542 <release>
  acquire(&np->lock);
    80001578:	8552                	mv	a0,s4
    8000157a:	00005097          	auipc	ra,0x5
    8000157e:	f18080e7          	jalr	-232(ra) # 80006492 <acquire>
  np->state = RUNNABLE;
    80001582:	478d                	li	a5,3
    80001584:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001588:	8552                	mv	a0,s4
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	fb8080e7          	jalr	-72(ra) # 80006542 <release>
  return pid;
    80001592:	74a2                	ld	s1,40(sp)
    80001594:	69e2                	ld	s3,24(sp)
    80001596:	6a42                	ld	s4,16(sp)
}
    80001598:	854a                	mv	a0,s2
    8000159a:	70e2                	ld	ra,56(sp)
    8000159c:	7442                	ld	s0,48(sp)
    8000159e:	7902                	ld	s2,32(sp)
    800015a0:	6aa2                	ld	s5,8(sp)
    800015a2:	6121                	addi	sp,sp,64
    800015a4:	8082                	ret
    return -1;
    800015a6:	597d                	li	s2,-1
    800015a8:	bfc5                	j	80001598 <fork+0x130>

00000000800015aa <scheduler>:
{
    800015aa:	7139                	addi	sp,sp,-64
    800015ac:	fc06                	sd	ra,56(sp)
    800015ae:	f822                	sd	s0,48(sp)
    800015b0:	f426                	sd	s1,40(sp)
    800015b2:	f04a                	sd	s2,32(sp)
    800015b4:	ec4e                	sd	s3,24(sp)
    800015b6:	e852                	sd	s4,16(sp)
    800015b8:	e456                	sd	s5,8(sp)
    800015ba:	e05a                	sd	s6,0(sp)
    800015bc:	0080                	addi	s0,sp,64
    800015be:	8792                	mv	a5,tp
  int id = r_tp();
    800015c0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015c2:	00779a93          	slli	s5,a5,0x7
    800015c6:	00248717          	auipc	a4,0x248
    800015ca:	ac270713          	addi	a4,a4,-1342 # 80249088 <pid_lock>
    800015ce:	9756                	add	a4,a4,s5
    800015d0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015d4:	00248717          	auipc	a4,0x248
    800015d8:	aec70713          	addi	a4,a4,-1300 # 802490c0 <cpus+0x8>
    800015dc:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015de:	498d                	li	s3,3
        p->state = RUNNING;
    800015e0:	4b11                	li	s6,4
        c->proc = p;
    800015e2:	079e                	slli	a5,a5,0x7
    800015e4:	00248a17          	auipc	s4,0x248
    800015e8:	aa4a0a13          	addi	s4,s4,-1372 # 80249088 <pid_lock>
    800015ec:	9a3e                	add	s4,s4,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015f2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015f6:	10079073          	csrw	sstatus,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015fa:	00248497          	auipc	s1,0x248
    800015fe:	ebe48493          	addi	s1,s1,-322 # 802494b8 <proc>
    80001602:	0024e917          	auipc	s2,0x24e
    80001606:	8b690913          	addi	s2,s2,-1866 # 8024eeb8 <tickslock>
    8000160a:	a811                	j	8000161e <scheduler+0x74>
      release(&p->lock);
    8000160c:	8526                	mv	a0,s1
    8000160e:	00005097          	auipc	ra,0x5
    80001612:	f34080e7          	jalr	-204(ra) # 80006542 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001616:	16848493          	addi	s1,s1,360
    8000161a:	fd248ae3          	beq	s1,s2,800015ee <scheduler+0x44>
      acquire(&p->lock);
    8000161e:	8526                	mv	a0,s1
    80001620:	00005097          	auipc	ra,0x5
    80001624:	e72080e7          	jalr	-398(ra) # 80006492 <acquire>
      if(p->state == RUNNABLE) {
    80001628:	4c9c                	lw	a5,24(s1)
    8000162a:	ff3791e3          	bne	a5,s3,8000160c <scheduler+0x62>
        p->state = RUNNING;
    8000162e:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001632:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001636:	06048593          	addi	a1,s1,96
    8000163a:	8556                	mv	a0,s5
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	61a080e7          	jalr	1562(ra) # 80001c56 <swtch>
        c->proc = 0;
    80001644:	020a3823          	sd	zero,48(s4)
    80001648:	b7d1                	j	8000160c <scheduler+0x62>

000000008000164a <sched>:
{
    8000164a:	7179                	addi	sp,sp,-48
    8000164c:	f406                	sd	ra,40(sp)
    8000164e:	f022                	sd	s0,32(sp)
    80001650:	ec26                	sd	s1,24(sp)
    80001652:	e84a                	sd	s2,16(sp)
    80001654:	e44e                	sd	s3,8(sp)
    80001656:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	a3e080e7          	jalr	-1474(ra) # 80001096 <myproc>
    80001660:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001662:	00005097          	auipc	ra,0x5
    80001666:	db6080e7          	jalr	-586(ra) # 80006418 <holding>
    8000166a:	c93d                	beqz	a0,800016e0 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000166c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000166e:	2781                	sext.w	a5,a5
    80001670:	079e                	slli	a5,a5,0x7
    80001672:	00248717          	auipc	a4,0x248
    80001676:	a1670713          	addi	a4,a4,-1514 # 80249088 <pid_lock>
    8000167a:	97ba                	add	a5,a5,a4
    8000167c:	0a87a703          	lw	a4,168(a5)
    80001680:	4785                	li	a5,1
    80001682:	06f71763          	bne	a4,a5,800016f0 <sched+0xa6>
  if(p->state == RUNNING)
    80001686:	4c98                	lw	a4,24(s1)
    80001688:	4791                	li	a5,4
    8000168a:	06f70b63          	beq	a4,a5,80001700 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000168e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001692:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001694:	efb5                	bnez	a5,80001710 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001696:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001698:	00248917          	auipc	s2,0x248
    8000169c:	9f090913          	addi	s2,s2,-1552 # 80249088 <pid_lock>
    800016a0:	2781                	sext.w	a5,a5
    800016a2:	079e                	slli	a5,a5,0x7
    800016a4:	97ca                	add	a5,a5,s2
    800016a6:	0ac7a983          	lw	s3,172(a5)
    800016aa:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016ac:	2781                	sext.w	a5,a5
    800016ae:	079e                	slli	a5,a5,0x7
    800016b0:	00248597          	auipc	a1,0x248
    800016b4:	a1058593          	addi	a1,a1,-1520 # 802490c0 <cpus+0x8>
    800016b8:	95be                	add	a1,a1,a5
    800016ba:	06048513          	addi	a0,s1,96
    800016be:	00000097          	auipc	ra,0x0
    800016c2:	598080e7          	jalr	1432(ra) # 80001c56 <swtch>
    800016c6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016c8:	2781                	sext.w	a5,a5
    800016ca:	079e                	slli	a5,a5,0x7
    800016cc:	993e                	add	s2,s2,a5
    800016ce:	0b392623          	sw	s3,172(s2)
}
    800016d2:	70a2                	ld	ra,40(sp)
    800016d4:	7402                	ld	s0,32(sp)
    800016d6:	64e2                	ld	s1,24(sp)
    800016d8:	6942                	ld	s2,16(sp)
    800016da:	69a2                	ld	s3,8(sp)
    800016dc:	6145                	addi	sp,sp,48
    800016de:	8082                	ret
    panic("sched p->lock");
    800016e0:	00007517          	auipc	a0,0x7
    800016e4:	ac850513          	addi	a0,a0,-1336 # 800081a8 <etext+0x1a8>
    800016e8:	00005097          	auipc	ra,0x5
    800016ec:	82a080e7          	jalr	-2006(ra) # 80005f12 <panic>
    panic("sched locks");
    800016f0:	00007517          	auipc	a0,0x7
    800016f4:	ac850513          	addi	a0,a0,-1336 # 800081b8 <etext+0x1b8>
    800016f8:	00005097          	auipc	ra,0x5
    800016fc:	81a080e7          	jalr	-2022(ra) # 80005f12 <panic>
    panic("sched running");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	ac850513          	addi	a0,a0,-1336 # 800081c8 <etext+0x1c8>
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	80a080e7          	jalr	-2038(ra) # 80005f12 <panic>
    panic("sched interruptible");
    80001710:	00007517          	auipc	a0,0x7
    80001714:	ac850513          	addi	a0,a0,-1336 # 800081d8 <etext+0x1d8>
    80001718:	00004097          	auipc	ra,0x4
    8000171c:	7fa080e7          	jalr	2042(ra) # 80005f12 <panic>

0000000080001720 <yield>:
{
    80001720:	1101                	addi	sp,sp,-32
    80001722:	ec06                	sd	ra,24(sp)
    80001724:	e822                	sd	s0,16(sp)
    80001726:	e426                	sd	s1,8(sp)
    80001728:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000172a:	00000097          	auipc	ra,0x0
    8000172e:	96c080e7          	jalr	-1684(ra) # 80001096 <myproc>
    80001732:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001734:	00005097          	auipc	ra,0x5
    80001738:	d5e080e7          	jalr	-674(ra) # 80006492 <acquire>
  p->state = RUNNABLE;
    8000173c:	478d                	li	a5,3
    8000173e:	cc9c                	sw	a5,24(s1)
  sched();
    80001740:	00000097          	auipc	ra,0x0
    80001744:	f0a080e7          	jalr	-246(ra) # 8000164a <sched>
  release(&p->lock);
    80001748:	8526                	mv	a0,s1
    8000174a:	00005097          	auipc	ra,0x5
    8000174e:	df8080e7          	jalr	-520(ra) # 80006542 <release>
}
    80001752:	60e2                	ld	ra,24(sp)
    80001754:	6442                	ld	s0,16(sp)
    80001756:	64a2                	ld	s1,8(sp)
    80001758:	6105                	addi	sp,sp,32
    8000175a:	8082                	ret

000000008000175c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000175c:	7179                	addi	sp,sp,-48
    8000175e:	f406                	sd	ra,40(sp)
    80001760:	f022                	sd	s0,32(sp)
    80001762:	ec26                	sd	s1,24(sp)
    80001764:	e84a                	sd	s2,16(sp)
    80001766:	e44e                	sd	s3,8(sp)
    80001768:	1800                	addi	s0,sp,48
    8000176a:	89aa                	mv	s3,a0
    8000176c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000176e:	00000097          	auipc	ra,0x0
    80001772:	928080e7          	jalr	-1752(ra) # 80001096 <myproc>
    80001776:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001778:	00005097          	auipc	ra,0x5
    8000177c:	d1a080e7          	jalr	-742(ra) # 80006492 <acquire>
  release(lk);
    80001780:	854a                	mv	a0,s2
    80001782:	00005097          	auipc	ra,0x5
    80001786:	dc0080e7          	jalr	-576(ra) # 80006542 <release>

  // Go to sleep.
  p->chan = chan;
    8000178a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000178e:	4789                	li	a5,2
    80001790:	cc9c                	sw	a5,24(s1)

  sched();
    80001792:	00000097          	auipc	ra,0x0
    80001796:	eb8080e7          	jalr	-328(ra) # 8000164a <sched>

  // Tidy up.
  p->chan = 0;
    8000179a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000179e:	8526                	mv	a0,s1
    800017a0:	00005097          	auipc	ra,0x5
    800017a4:	da2080e7          	jalr	-606(ra) # 80006542 <release>
  acquire(lk);
    800017a8:	854a                	mv	a0,s2
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	ce8080e7          	jalr	-792(ra) # 80006492 <acquire>
}
    800017b2:	70a2                	ld	ra,40(sp)
    800017b4:	7402                	ld	s0,32(sp)
    800017b6:	64e2                	ld	s1,24(sp)
    800017b8:	6942                	ld	s2,16(sp)
    800017ba:	69a2                	ld	s3,8(sp)
    800017bc:	6145                	addi	sp,sp,48
    800017be:	8082                	ret

00000000800017c0 <wait>:
{
    800017c0:	715d                	addi	sp,sp,-80
    800017c2:	e486                	sd	ra,72(sp)
    800017c4:	e0a2                	sd	s0,64(sp)
    800017c6:	fc26                	sd	s1,56(sp)
    800017c8:	f84a                	sd	s2,48(sp)
    800017ca:	f44e                	sd	s3,40(sp)
    800017cc:	f052                	sd	s4,32(sp)
    800017ce:	ec56                	sd	s5,24(sp)
    800017d0:	e85a                	sd	s6,16(sp)
    800017d2:	e45e                	sd	s7,8(sp)
    800017d4:	0880                	addi	s0,sp,80
    800017d6:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017d8:	00000097          	auipc	ra,0x0
    800017dc:	8be080e7          	jalr	-1858(ra) # 80001096 <myproc>
    800017e0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017e2:	00248517          	auipc	a0,0x248
    800017e6:	8be50513          	addi	a0,a0,-1858 # 802490a0 <wait_lock>
    800017ea:	00005097          	auipc	ra,0x5
    800017ee:	ca8080e7          	jalr	-856(ra) # 80006492 <acquire>
        if(np->state == ZOMBIE){
    800017f2:	4a15                	li	s4,5
        havekids = 1;
    800017f4:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800017f6:	0024d997          	auipc	s3,0x24d
    800017fa:	6c298993          	addi	s3,s3,1730 # 8024eeb8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017fe:	00248b97          	auipc	s7,0x248
    80001802:	8a2b8b93          	addi	s7,s7,-1886 # 802490a0 <wait_lock>
    80001806:	a875                	j	800018c2 <wait+0x102>
          pid = np->pid;
    80001808:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    8000180c:	000b0e63          	beqz	s6,80001828 <wait+0x68>
    80001810:	4691                	li	a3,4
    80001812:	02c48613          	addi	a2,s1,44
    80001816:	85da                	mv	a1,s6
    80001818:	05093503          	ld	a0,80(s2)
    8000181c:	fffff097          	auipc	ra,0xfffff
    80001820:	492080e7          	jalr	1170(ra) # 80000cae <copyout>
    80001824:	04054063          	bltz	a0,80001864 <wait+0xa4>
          freeproc(np);
    80001828:	8526                	mv	a0,s1
    8000182a:	00000097          	auipc	ra,0x0
    8000182e:	a1e080e7          	jalr	-1506(ra) # 80001248 <freeproc>
          release(&np->lock);
    80001832:	8526                	mv	a0,s1
    80001834:	00005097          	auipc	ra,0x5
    80001838:	d0e080e7          	jalr	-754(ra) # 80006542 <release>
          release(&wait_lock);
    8000183c:	00248517          	auipc	a0,0x248
    80001840:	86450513          	addi	a0,a0,-1948 # 802490a0 <wait_lock>
    80001844:	00005097          	auipc	ra,0x5
    80001848:	cfe080e7          	jalr	-770(ra) # 80006542 <release>
}
    8000184c:	854e                	mv	a0,s3
    8000184e:	60a6                	ld	ra,72(sp)
    80001850:	6406                	ld	s0,64(sp)
    80001852:	74e2                	ld	s1,56(sp)
    80001854:	7942                	ld	s2,48(sp)
    80001856:	79a2                	ld	s3,40(sp)
    80001858:	7a02                	ld	s4,32(sp)
    8000185a:	6ae2                	ld	s5,24(sp)
    8000185c:	6b42                	ld	s6,16(sp)
    8000185e:	6ba2                	ld	s7,8(sp)
    80001860:	6161                	addi	sp,sp,80
    80001862:	8082                	ret
            release(&np->lock);
    80001864:	8526                	mv	a0,s1
    80001866:	00005097          	auipc	ra,0x5
    8000186a:	cdc080e7          	jalr	-804(ra) # 80006542 <release>
            release(&wait_lock);
    8000186e:	00248517          	auipc	a0,0x248
    80001872:	83250513          	addi	a0,a0,-1998 # 802490a0 <wait_lock>
    80001876:	00005097          	auipc	ra,0x5
    8000187a:	ccc080e7          	jalr	-820(ra) # 80006542 <release>
            return -1;
    8000187e:	59fd                	li	s3,-1
    80001880:	b7f1                	j	8000184c <wait+0x8c>
    for(np = proc; np < &proc[NPROC]; np++){
    80001882:	16848493          	addi	s1,s1,360
    80001886:	03348463          	beq	s1,s3,800018ae <wait+0xee>
      if(np->parent == p){
    8000188a:	7c9c                	ld	a5,56(s1)
    8000188c:	ff279be3          	bne	a5,s2,80001882 <wait+0xc2>
        acquire(&np->lock);
    80001890:	8526                	mv	a0,s1
    80001892:	00005097          	auipc	ra,0x5
    80001896:	c00080e7          	jalr	-1024(ra) # 80006492 <acquire>
        if(np->state == ZOMBIE){
    8000189a:	4c9c                	lw	a5,24(s1)
    8000189c:	f74786e3          	beq	a5,s4,80001808 <wait+0x48>
        release(&np->lock);
    800018a0:	8526                	mv	a0,s1
    800018a2:	00005097          	auipc	ra,0x5
    800018a6:	ca0080e7          	jalr	-864(ra) # 80006542 <release>
        havekids = 1;
    800018aa:	8756                	mv	a4,s5
    800018ac:	bfd9                	j	80001882 <wait+0xc2>
    if(!havekids || p->killed){
    800018ae:	c305                	beqz	a4,800018ce <wait+0x10e>
    800018b0:	02892783          	lw	a5,40(s2)
    800018b4:	ef89                	bnez	a5,800018ce <wait+0x10e>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018b6:	85de                	mv	a1,s7
    800018b8:	854a                	mv	a0,s2
    800018ba:	00000097          	auipc	ra,0x0
    800018be:	ea2080e7          	jalr	-350(ra) # 8000175c <sleep>
    havekids = 0;
    800018c2:	4701                	li	a4,0
    for(np = proc; np < &proc[NPROC]; np++){
    800018c4:	00248497          	auipc	s1,0x248
    800018c8:	bf448493          	addi	s1,s1,-1036 # 802494b8 <proc>
    800018cc:	bf7d                	j	8000188a <wait+0xca>
      release(&wait_lock);
    800018ce:	00247517          	auipc	a0,0x247
    800018d2:	7d250513          	addi	a0,a0,2002 # 802490a0 <wait_lock>
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	c6c080e7          	jalr	-916(ra) # 80006542 <release>
      return -1;
    800018de:	59fd                	li	s3,-1
    800018e0:	b7b5                	j	8000184c <wait+0x8c>

00000000800018e2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018e2:	7139                	addi	sp,sp,-64
    800018e4:	fc06                	sd	ra,56(sp)
    800018e6:	f822                	sd	s0,48(sp)
    800018e8:	f426                	sd	s1,40(sp)
    800018ea:	f04a                	sd	s2,32(sp)
    800018ec:	ec4e                	sd	s3,24(sp)
    800018ee:	e852                	sd	s4,16(sp)
    800018f0:	e456                	sd	s5,8(sp)
    800018f2:	0080                	addi	s0,sp,64
    800018f4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018f6:	00248497          	auipc	s1,0x248
    800018fa:	bc248493          	addi	s1,s1,-1086 # 802494b8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800018fe:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001900:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001902:	0024d917          	auipc	s2,0x24d
    80001906:	5b690913          	addi	s2,s2,1462 # 8024eeb8 <tickslock>
    8000190a:	a811                	j	8000191e <wakeup+0x3c>
      }
      release(&p->lock);
    8000190c:	8526                	mv	a0,s1
    8000190e:	00005097          	auipc	ra,0x5
    80001912:	c34080e7          	jalr	-972(ra) # 80006542 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001916:	16848493          	addi	s1,s1,360
    8000191a:	03248663          	beq	s1,s2,80001946 <wakeup+0x64>
    if(p != myproc()){
    8000191e:	fffff097          	auipc	ra,0xfffff
    80001922:	778080e7          	jalr	1912(ra) # 80001096 <myproc>
    80001926:	fea488e3          	beq	s1,a0,80001916 <wakeup+0x34>
      acquire(&p->lock);
    8000192a:	8526                	mv	a0,s1
    8000192c:	00005097          	auipc	ra,0x5
    80001930:	b66080e7          	jalr	-1178(ra) # 80006492 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001934:	4c9c                	lw	a5,24(s1)
    80001936:	fd379be3          	bne	a5,s3,8000190c <wakeup+0x2a>
    8000193a:	709c                	ld	a5,32(s1)
    8000193c:	fd4798e3          	bne	a5,s4,8000190c <wakeup+0x2a>
        p->state = RUNNABLE;
    80001940:	0154ac23          	sw	s5,24(s1)
    80001944:	b7e1                	j	8000190c <wakeup+0x2a>
    }
  }
}
    80001946:	70e2                	ld	ra,56(sp)
    80001948:	7442                	ld	s0,48(sp)
    8000194a:	74a2                	ld	s1,40(sp)
    8000194c:	7902                	ld	s2,32(sp)
    8000194e:	69e2                	ld	s3,24(sp)
    80001950:	6a42                	ld	s4,16(sp)
    80001952:	6aa2                	ld	s5,8(sp)
    80001954:	6121                	addi	sp,sp,64
    80001956:	8082                	ret

0000000080001958 <reparent>:
{
    80001958:	7179                	addi	sp,sp,-48
    8000195a:	f406                	sd	ra,40(sp)
    8000195c:	f022                	sd	s0,32(sp)
    8000195e:	ec26                	sd	s1,24(sp)
    80001960:	e84a                	sd	s2,16(sp)
    80001962:	e44e                	sd	s3,8(sp)
    80001964:	e052                	sd	s4,0(sp)
    80001966:	1800                	addi	s0,sp,48
    80001968:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000196a:	00248497          	auipc	s1,0x248
    8000196e:	b4e48493          	addi	s1,s1,-1202 # 802494b8 <proc>
      pp->parent = initproc;
    80001972:	00007a17          	auipc	s4,0x7
    80001976:	69ea0a13          	addi	s4,s4,1694 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000197a:	0024d997          	auipc	s3,0x24d
    8000197e:	53e98993          	addi	s3,s3,1342 # 8024eeb8 <tickslock>
    80001982:	a029                	j	8000198c <reparent+0x34>
    80001984:	16848493          	addi	s1,s1,360
    80001988:	01348d63          	beq	s1,s3,800019a2 <reparent+0x4a>
    if(pp->parent == p){
    8000198c:	7c9c                	ld	a5,56(s1)
    8000198e:	ff279be3          	bne	a5,s2,80001984 <reparent+0x2c>
      pp->parent = initproc;
    80001992:	000a3503          	ld	a0,0(s4)
    80001996:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001998:	00000097          	auipc	ra,0x0
    8000199c:	f4a080e7          	jalr	-182(ra) # 800018e2 <wakeup>
    800019a0:	b7d5                	j	80001984 <reparent+0x2c>
}
    800019a2:	70a2                	ld	ra,40(sp)
    800019a4:	7402                	ld	s0,32(sp)
    800019a6:	64e2                	ld	s1,24(sp)
    800019a8:	6942                	ld	s2,16(sp)
    800019aa:	69a2                	ld	s3,8(sp)
    800019ac:	6a02                	ld	s4,0(sp)
    800019ae:	6145                	addi	sp,sp,48
    800019b0:	8082                	ret

00000000800019b2 <exit>:
{
    800019b2:	7179                	addi	sp,sp,-48
    800019b4:	f406                	sd	ra,40(sp)
    800019b6:	f022                	sd	s0,32(sp)
    800019b8:	ec26                	sd	s1,24(sp)
    800019ba:	e84a                	sd	s2,16(sp)
    800019bc:	e44e                	sd	s3,8(sp)
    800019be:	e052                	sd	s4,0(sp)
    800019c0:	1800                	addi	s0,sp,48
    800019c2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800019c4:	fffff097          	auipc	ra,0xfffff
    800019c8:	6d2080e7          	jalr	1746(ra) # 80001096 <myproc>
    800019cc:	89aa                	mv	s3,a0
  if(p == initproc)
    800019ce:	00007797          	auipc	a5,0x7
    800019d2:	6427b783          	ld	a5,1602(a5) # 80009010 <initproc>
    800019d6:	0d050493          	addi	s1,a0,208
    800019da:	15050913          	addi	s2,a0,336
    800019de:	00a79d63          	bne	a5,a0,800019f8 <exit+0x46>
    panic("init exiting");
    800019e2:	00007517          	auipc	a0,0x7
    800019e6:	80e50513          	addi	a0,a0,-2034 # 800081f0 <etext+0x1f0>
    800019ea:	00004097          	auipc	ra,0x4
    800019ee:	528080e7          	jalr	1320(ra) # 80005f12 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800019f2:	04a1                	addi	s1,s1,8
    800019f4:	01248b63          	beq	s1,s2,80001a0a <exit+0x58>
    if(p->ofile[fd]){
    800019f8:	6088                	ld	a0,0(s1)
    800019fa:	dd65                	beqz	a0,800019f2 <exit+0x40>
      fileclose(f);
    800019fc:	00002097          	auipc	ra,0x2
    80001a00:	220080e7          	jalr	544(ra) # 80003c1c <fileclose>
      p->ofile[fd] = 0;
    80001a04:	0004b023          	sd	zero,0(s1)
    80001a08:	b7ed                	j	800019f2 <exit+0x40>
  begin_op();
    80001a0a:	00002097          	auipc	ra,0x2
    80001a0e:	d42080e7          	jalr	-702(ra) # 8000374c <begin_op>
  iput(p->cwd);
    80001a12:	1509b503          	ld	a0,336(s3)
    80001a16:	00001097          	auipc	ra,0x1
    80001a1a:	502080e7          	jalr	1282(ra) # 80002f18 <iput>
  end_op();
    80001a1e:	00002097          	auipc	ra,0x2
    80001a22:	da8080e7          	jalr	-600(ra) # 800037c6 <end_op>
  p->cwd = 0;
    80001a26:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001a2a:	00247497          	auipc	s1,0x247
    80001a2e:	67648493          	addi	s1,s1,1654 # 802490a0 <wait_lock>
    80001a32:	8526                	mv	a0,s1
    80001a34:	00005097          	auipc	ra,0x5
    80001a38:	a5e080e7          	jalr	-1442(ra) # 80006492 <acquire>
  reparent(p);
    80001a3c:	854e                	mv	a0,s3
    80001a3e:	00000097          	auipc	ra,0x0
    80001a42:	f1a080e7          	jalr	-230(ra) # 80001958 <reparent>
  wakeup(p->parent);
    80001a46:	0389b503          	ld	a0,56(s3)
    80001a4a:	00000097          	auipc	ra,0x0
    80001a4e:	e98080e7          	jalr	-360(ra) # 800018e2 <wakeup>
  acquire(&p->lock);
    80001a52:	854e                	mv	a0,s3
    80001a54:	00005097          	auipc	ra,0x5
    80001a58:	a3e080e7          	jalr	-1474(ra) # 80006492 <acquire>
  p->xstate = status;
    80001a5c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a60:	4795                	li	a5,5
    80001a62:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a66:	8526                	mv	a0,s1
    80001a68:	00005097          	auipc	ra,0x5
    80001a6c:	ada080e7          	jalr	-1318(ra) # 80006542 <release>
  sched();
    80001a70:	00000097          	auipc	ra,0x0
    80001a74:	bda080e7          	jalr	-1062(ra) # 8000164a <sched>
  panic("zombie exit");
    80001a78:	00006517          	auipc	a0,0x6
    80001a7c:	78850513          	addi	a0,a0,1928 # 80008200 <etext+0x200>
    80001a80:	00004097          	auipc	ra,0x4
    80001a84:	492080e7          	jalr	1170(ra) # 80005f12 <panic>

0000000080001a88 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a88:	7179                	addi	sp,sp,-48
    80001a8a:	f406                	sd	ra,40(sp)
    80001a8c:	f022                	sd	s0,32(sp)
    80001a8e:	ec26                	sd	s1,24(sp)
    80001a90:	e84a                	sd	s2,16(sp)
    80001a92:	e44e                	sd	s3,8(sp)
    80001a94:	1800                	addi	s0,sp,48
    80001a96:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a98:	00248497          	auipc	s1,0x248
    80001a9c:	a2048493          	addi	s1,s1,-1504 # 802494b8 <proc>
    80001aa0:	0024d997          	auipc	s3,0x24d
    80001aa4:	41898993          	addi	s3,s3,1048 # 8024eeb8 <tickslock>
    acquire(&p->lock);
    80001aa8:	8526                	mv	a0,s1
    80001aaa:	00005097          	auipc	ra,0x5
    80001aae:	9e8080e7          	jalr	-1560(ra) # 80006492 <acquire>
    if(p->pid == pid){
    80001ab2:	589c                	lw	a5,48(s1)
    80001ab4:	01278d63          	beq	a5,s2,80001ace <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001ab8:	8526                	mv	a0,s1
    80001aba:	00005097          	auipc	ra,0x5
    80001abe:	a88080e7          	jalr	-1400(ra) # 80006542 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ac2:	16848493          	addi	s1,s1,360
    80001ac6:	ff3491e3          	bne	s1,s3,80001aa8 <kill+0x20>
  }
  return -1;
    80001aca:	557d                	li	a0,-1
    80001acc:	a829                	j	80001ae6 <kill+0x5e>
      p->killed = 1;
    80001ace:	4785                	li	a5,1
    80001ad0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001ad2:	4c98                	lw	a4,24(s1)
    80001ad4:	4789                	li	a5,2
    80001ad6:	00f70f63          	beq	a4,a5,80001af4 <kill+0x6c>
      release(&p->lock);
    80001ada:	8526                	mv	a0,s1
    80001adc:	00005097          	auipc	ra,0x5
    80001ae0:	a66080e7          	jalr	-1434(ra) # 80006542 <release>
      return 0;
    80001ae4:	4501                	li	a0,0
}
    80001ae6:	70a2                	ld	ra,40(sp)
    80001ae8:	7402                	ld	s0,32(sp)
    80001aea:	64e2                	ld	s1,24(sp)
    80001aec:	6942                	ld	s2,16(sp)
    80001aee:	69a2                	ld	s3,8(sp)
    80001af0:	6145                	addi	sp,sp,48
    80001af2:	8082                	ret
        p->state = RUNNABLE;
    80001af4:	478d                	li	a5,3
    80001af6:	cc9c                	sw	a5,24(s1)
    80001af8:	b7cd                	j	80001ada <kill+0x52>

0000000080001afa <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001afa:	7179                	addi	sp,sp,-48
    80001afc:	f406                	sd	ra,40(sp)
    80001afe:	f022                	sd	s0,32(sp)
    80001b00:	ec26                	sd	s1,24(sp)
    80001b02:	e84a                	sd	s2,16(sp)
    80001b04:	e44e                	sd	s3,8(sp)
    80001b06:	e052                	sd	s4,0(sp)
    80001b08:	1800                	addi	s0,sp,48
    80001b0a:	84aa                	mv	s1,a0
    80001b0c:	892e                	mv	s2,a1
    80001b0e:	89b2                	mv	s3,a2
    80001b10:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	584080e7          	jalr	1412(ra) # 80001096 <myproc>
  if(user_dst){
    80001b1a:	c08d                	beqz	s1,80001b3c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001b1c:	86d2                	mv	a3,s4
    80001b1e:	864e                	mv	a2,s3
    80001b20:	85ca                	mv	a1,s2
    80001b22:	6928                	ld	a0,80(a0)
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	18a080e7          	jalr	394(ra) # 80000cae <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b2c:	70a2                	ld	ra,40(sp)
    80001b2e:	7402                	ld	s0,32(sp)
    80001b30:	64e2                	ld	s1,24(sp)
    80001b32:	6942                	ld	s2,16(sp)
    80001b34:	69a2                	ld	s3,8(sp)
    80001b36:	6a02                	ld	s4,0(sp)
    80001b38:	6145                	addi	sp,sp,48
    80001b3a:	8082                	ret
    memmove((char *)dst, src, len);
    80001b3c:	000a061b          	sext.w	a2,s4
    80001b40:	85ce                	mv	a1,s3
    80001b42:	854a                	mv	a0,s2
    80001b44:	ffffe097          	auipc	ra,0xffffe
    80001b48:	7d8080e7          	jalr	2008(ra) # 8000031c <memmove>
    return 0;
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	bff9                	j	80001b2c <either_copyout+0x32>

0000000080001b50 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b50:	7179                	addi	sp,sp,-48
    80001b52:	f406                	sd	ra,40(sp)
    80001b54:	f022                	sd	s0,32(sp)
    80001b56:	ec26                	sd	s1,24(sp)
    80001b58:	e84a                	sd	s2,16(sp)
    80001b5a:	e44e                	sd	s3,8(sp)
    80001b5c:	e052                	sd	s4,0(sp)
    80001b5e:	1800                	addi	s0,sp,48
    80001b60:	892a                	mv	s2,a0
    80001b62:	84ae                	mv	s1,a1
    80001b64:	89b2                	mv	s3,a2
    80001b66:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b68:	fffff097          	auipc	ra,0xfffff
    80001b6c:	52e080e7          	jalr	1326(ra) # 80001096 <myproc>
  if(user_src){
    80001b70:	c08d                	beqz	s1,80001b92 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b72:	86d2                	mv	a3,s4
    80001b74:	864e                	mv	a2,s3
    80001b76:	85ca                	mv	a1,s2
    80001b78:	6928                	ld	a0,80(a0)
    80001b7a:	fffff097          	auipc	ra,0xfffff
    80001b7e:	254080e7          	jalr	596(ra) # 80000dce <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b82:	70a2                	ld	ra,40(sp)
    80001b84:	7402                	ld	s0,32(sp)
    80001b86:	64e2                	ld	s1,24(sp)
    80001b88:	6942                	ld	s2,16(sp)
    80001b8a:	69a2                	ld	s3,8(sp)
    80001b8c:	6a02                	ld	s4,0(sp)
    80001b8e:	6145                	addi	sp,sp,48
    80001b90:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b92:	000a061b          	sext.w	a2,s4
    80001b96:	85ce                	mv	a1,s3
    80001b98:	854a                	mv	a0,s2
    80001b9a:	ffffe097          	auipc	ra,0xffffe
    80001b9e:	782080e7          	jalr	1922(ra) # 8000031c <memmove>
    return 0;
    80001ba2:	8526                	mv	a0,s1
    80001ba4:	bff9                	j	80001b82 <either_copyin+0x32>

0000000080001ba6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001ba6:	715d                	addi	sp,sp,-80
    80001ba8:	e486                	sd	ra,72(sp)
    80001baa:	e0a2                	sd	s0,64(sp)
    80001bac:	fc26                	sd	s1,56(sp)
    80001bae:	f84a                	sd	s2,48(sp)
    80001bb0:	f44e                	sd	s3,40(sp)
    80001bb2:	f052                	sd	s4,32(sp)
    80001bb4:	ec56                	sd	s5,24(sp)
    80001bb6:	e85a                	sd	s6,16(sp)
    80001bb8:	e45e                	sd	s7,8(sp)
    80001bba:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001bbc:	00006517          	auipc	a0,0x6
    80001bc0:	46c50513          	addi	a0,a0,1132 # 80008028 <etext+0x28>
    80001bc4:	00004097          	auipc	ra,0x4
    80001bc8:	398080e7          	jalr	920(ra) # 80005f5c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bcc:	00248497          	auipc	s1,0x248
    80001bd0:	a4448493          	addi	s1,s1,-1468 # 80249610 <proc+0x158>
    80001bd4:	0024d917          	auipc	s2,0x24d
    80001bd8:	43c90913          	addi	s2,s2,1084 # 8024f010 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bdc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bde:	00006997          	auipc	s3,0x6
    80001be2:	63298993          	addi	s3,s3,1586 # 80008210 <etext+0x210>
    printf("%d %s %s", p->pid, state, p->name);
    80001be6:	00006a97          	auipc	s5,0x6
    80001bea:	632a8a93          	addi	s5,s5,1586 # 80008218 <etext+0x218>
    printf("\n");
    80001bee:	00006a17          	auipc	s4,0x6
    80001bf2:	43aa0a13          	addi	s4,s4,1082 # 80008028 <etext+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bf6:	00007b97          	auipc	s7,0x7
    80001bfa:	b1ab8b93          	addi	s7,s7,-1254 # 80008710 <states.0>
    80001bfe:	a00d                	j	80001c20 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001c00:	ed86a583          	lw	a1,-296(a3)
    80001c04:	8556                	mv	a0,s5
    80001c06:	00004097          	auipc	ra,0x4
    80001c0a:	356080e7          	jalr	854(ra) # 80005f5c <printf>
    printf("\n");
    80001c0e:	8552                	mv	a0,s4
    80001c10:	00004097          	auipc	ra,0x4
    80001c14:	34c080e7          	jalr	844(ra) # 80005f5c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c18:	16848493          	addi	s1,s1,360
    80001c1c:	03248263          	beq	s1,s2,80001c40 <procdump+0x9a>
    if(p->state == UNUSED)
    80001c20:	86a6                	mv	a3,s1
    80001c22:	ec04a783          	lw	a5,-320(s1)
    80001c26:	dbed                	beqz	a5,80001c18 <procdump+0x72>
      state = "???";
    80001c28:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c2a:	fcfb6be3          	bltu	s6,a5,80001c00 <procdump+0x5a>
    80001c2e:	02079713          	slli	a4,a5,0x20
    80001c32:	01d75793          	srli	a5,a4,0x1d
    80001c36:	97de                	add	a5,a5,s7
    80001c38:	6390                	ld	a2,0(a5)
    80001c3a:	f279                	bnez	a2,80001c00 <procdump+0x5a>
      state = "???";
    80001c3c:	864e                	mv	a2,s3
    80001c3e:	b7c9                	j	80001c00 <procdump+0x5a>
  }
}
    80001c40:	60a6                	ld	ra,72(sp)
    80001c42:	6406                	ld	s0,64(sp)
    80001c44:	74e2                	ld	s1,56(sp)
    80001c46:	7942                	ld	s2,48(sp)
    80001c48:	79a2                	ld	s3,40(sp)
    80001c4a:	7a02                	ld	s4,32(sp)
    80001c4c:	6ae2                	ld	s5,24(sp)
    80001c4e:	6b42                	ld	s6,16(sp)
    80001c50:	6ba2                	ld	s7,8(sp)
    80001c52:	6161                	addi	sp,sp,80
    80001c54:	8082                	ret

0000000080001c56 <swtch>:
    80001c56:	00153023          	sd	ra,0(a0)
    80001c5a:	00253423          	sd	sp,8(a0)
    80001c5e:	e900                	sd	s0,16(a0)
    80001c60:	ed04                	sd	s1,24(a0)
    80001c62:	03253023          	sd	s2,32(a0)
    80001c66:	03353423          	sd	s3,40(a0)
    80001c6a:	03453823          	sd	s4,48(a0)
    80001c6e:	03553c23          	sd	s5,56(a0)
    80001c72:	05653023          	sd	s6,64(a0)
    80001c76:	05753423          	sd	s7,72(a0)
    80001c7a:	05853823          	sd	s8,80(a0)
    80001c7e:	05953c23          	sd	s9,88(a0)
    80001c82:	07a53023          	sd	s10,96(a0)
    80001c86:	07b53423          	sd	s11,104(a0)
    80001c8a:	0005b083          	ld	ra,0(a1)
    80001c8e:	0085b103          	ld	sp,8(a1)
    80001c92:	6980                	ld	s0,16(a1)
    80001c94:	6d84                	ld	s1,24(a1)
    80001c96:	0205b903          	ld	s2,32(a1)
    80001c9a:	0285b983          	ld	s3,40(a1)
    80001c9e:	0305ba03          	ld	s4,48(a1)
    80001ca2:	0385ba83          	ld	s5,56(a1)
    80001ca6:	0405bb03          	ld	s6,64(a1)
    80001caa:	0485bb83          	ld	s7,72(a1)
    80001cae:	0505bc03          	ld	s8,80(a1)
    80001cb2:	0585bc83          	ld	s9,88(a1)
    80001cb6:	0605bd03          	ld	s10,96(a1)
    80001cba:	0685bd83          	ld	s11,104(a1)
    80001cbe:	8082                	ret

0000000080001cc0 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001cc0:	1141                	addi	sp,sp,-16
    80001cc2:	e406                	sd	ra,8(sp)
    80001cc4:	e022                	sd	s0,0(sp)
    80001cc6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001cc8:	00006597          	auipc	a1,0x6
    80001ccc:	58858593          	addi	a1,a1,1416 # 80008250 <etext+0x250>
    80001cd0:	0024d517          	auipc	a0,0x24d
    80001cd4:	1e850513          	addi	a0,a0,488 # 8024eeb8 <tickslock>
    80001cd8:	00004097          	auipc	ra,0x4
    80001cdc:	726080e7          	jalr	1830(ra) # 800063fe <initlock>
}
    80001ce0:	60a2                	ld	ra,8(sp)
    80001ce2:	6402                	ld	s0,0(sp)
    80001ce4:	0141                	addi	sp,sp,16
    80001ce6:	8082                	ret

0000000080001ce8 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001ce8:	1141                	addi	sp,sp,-16
    80001cea:	e406                	sd	ra,8(sp)
    80001cec:	e022                	sd	s0,0(sp)
    80001cee:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf0:	00003797          	auipc	a5,0x3
    80001cf4:	65078793          	addi	a5,a5,1616 # 80005340 <kernelvec>
    80001cf8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cfc:	60a2                	ld	ra,8(sp)
    80001cfe:	6402                	ld	s0,0(sp)
    80001d00:	0141                	addi	sp,sp,16
    80001d02:	8082                	ret

0000000080001d04 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001d04:	1141                	addi	sp,sp,-16
    80001d06:	e406                	sd	ra,8(sp)
    80001d08:	e022                	sd	s0,0(sp)
    80001d0a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d0c:	fffff097          	auipc	ra,0xfffff
    80001d10:	38a080e7          	jalr	906(ra) # 80001096 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d14:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d18:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d1a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d1e:	00005697          	auipc	a3,0x5
    80001d22:	2e268693          	addi	a3,a3,738 # 80007000 <_trampoline>
    80001d26:	00005717          	auipc	a4,0x5
    80001d2a:	2da70713          	addi	a4,a4,730 # 80007000 <_trampoline>
    80001d2e:	8f15                	sub	a4,a4,a3
    80001d30:	040007b7          	lui	a5,0x4000
    80001d34:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d36:	07b2                	slli	a5,a5,0xc
    80001d38:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d3a:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d3e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d40:	18002673          	csrr	a2,satp
    80001d44:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d46:	6d30                	ld	a2,88(a0)
    80001d48:	6138                	ld	a4,64(a0)
    80001d4a:	6585                	lui	a1,0x1
    80001d4c:	972e                	add	a4,a4,a1
    80001d4e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d50:	6d38                	ld	a4,88(a0)
    80001d52:	00000617          	auipc	a2,0x0
    80001d56:	14060613          	addi	a2,a2,320 # 80001e92 <usertrap>
    80001d5a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001d5c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d5e:	8612                	mv	a2,tp
    80001d60:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d62:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d66:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d6a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d6e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d72:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d74:	6f18                	ld	a4,24(a4)
    80001d76:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d7a:	692c                	ld	a1,80(a0)
    80001d7c:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d7e:	00005717          	auipc	a4,0x5
    80001d82:	31270713          	addi	a4,a4,786 # 80007090 <userret>
    80001d86:	8f15                	sub	a4,a4,a3
    80001d88:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80001d8a:	577d                	li	a4,-1
    80001d8c:	177e                	slli	a4,a4,0x3f
    80001d8e:	8dd9                	or	a1,a1,a4
    80001d90:	02000537          	lui	a0,0x2000
    80001d94:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d96:	0536                	slli	a0,a0,0xd
    80001d98:	9782                	jalr	a5
}
    80001d9a:	60a2                	ld	ra,8(sp)
    80001d9c:	6402                	ld	s0,0(sp)
    80001d9e:	0141                	addi	sp,sp,16
    80001da0:	8082                	ret

0000000080001da2 <clockintr>:
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void clockintr()
{
    80001da2:	1101                	addi	sp,sp,-32
    80001da4:	ec06                	sd	ra,24(sp)
    80001da6:	e822                	sd	s0,16(sp)
    80001da8:	e426                	sd	s1,8(sp)
    80001daa:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001dac:	0024d497          	auipc	s1,0x24d
    80001db0:	10c48493          	addi	s1,s1,268 # 8024eeb8 <tickslock>
    80001db4:	8526                	mv	a0,s1
    80001db6:	00004097          	auipc	ra,0x4
    80001dba:	6dc080e7          	jalr	1756(ra) # 80006492 <acquire>
  ticks++;
    80001dbe:	00007517          	auipc	a0,0x7
    80001dc2:	25a50513          	addi	a0,a0,602 # 80009018 <ticks>
    80001dc6:	411c                	lw	a5,0(a0)
    80001dc8:	2785                	addiw	a5,a5,1
    80001dca:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dcc:	00000097          	auipc	ra,0x0
    80001dd0:	b16080e7          	jalr	-1258(ra) # 800018e2 <wakeup>
  release(&tickslock);
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	00004097          	auipc	ra,0x4
    80001dda:	76c080e7          	jalr	1900(ra) # 80006542 <release>
}
    80001dde:	60e2                	ld	ra,24(sp)
    80001de0:	6442                	ld	s0,16(sp)
    80001de2:	64a2                	ld	s1,8(sp)
    80001de4:	6105                	addi	sp,sp,32
    80001de6:	8082                	ret

0000000080001de8 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de8:	142027f3          	csrr	a5,scause

    return 2;
  }
  else
  {
    return 0;
    80001dec:	4501                	li	a0,0
  if ((scause & 0x8000000000000000L) &&
    80001dee:	0a07d163          	bgez	a5,80001e90 <devintr+0xa8>
{
    80001df2:	1101                	addi	sp,sp,-32
    80001df4:	ec06                	sd	ra,24(sp)
    80001df6:	e822                	sd	s0,16(sp)
    80001df8:	1000                	addi	s0,sp,32
      (scause & 0xff) == 9)
    80001dfa:	0ff7f713          	zext.b	a4,a5
  if ((scause & 0x8000000000000000L) &&
    80001dfe:	46a5                	li	a3,9
    80001e00:	00d70c63          	beq	a4,a3,80001e18 <devintr+0x30>
  else if (scause == 0x8000000000000001L)
    80001e04:	577d                	li	a4,-1
    80001e06:	177e                	slli	a4,a4,0x3f
    80001e08:	0705                	addi	a4,a4,1
    return 0;
    80001e0a:	4501                	li	a0,0
  else if (scause == 0x8000000000000001L)
    80001e0c:	06e78163          	beq	a5,a4,80001e6e <devintr+0x86>
  }
}
    80001e10:	60e2                	ld	ra,24(sp)
    80001e12:	6442                	ld	s0,16(sp)
    80001e14:	6105                	addi	sp,sp,32
    80001e16:	8082                	ret
    80001e18:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001e1a:	00003097          	auipc	ra,0x3
    80001e1e:	632080e7          	jalr	1586(ra) # 8000544c <plic_claim>
    80001e22:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ)
    80001e24:	47a9                	li	a5,10
    80001e26:	00f50963          	beq	a0,a5,80001e38 <devintr+0x50>
    else if (irq == VIRTIO0_IRQ)
    80001e2a:	4785                	li	a5,1
    80001e2c:	00f50b63          	beq	a0,a5,80001e42 <devintr+0x5a>
    return 1;
    80001e30:	4505                	li	a0,1
    else if (irq)
    80001e32:	ec89                	bnez	s1,80001e4c <devintr+0x64>
    80001e34:	64a2                	ld	s1,8(sp)
    80001e36:	bfe9                	j	80001e10 <devintr+0x28>
      uartintr();
    80001e38:	00004097          	auipc	ra,0x4
    80001e3c:	576080e7          	jalr	1398(ra) # 800063ae <uartintr>
    if (irq)
    80001e40:	a839                	j	80001e5e <devintr+0x76>
      virtio_disk_intr();
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	ac4080e7          	jalr	-1340(ra) # 80005906 <virtio_disk_intr>
    if (irq)
    80001e4a:	a811                	j	80001e5e <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e4c:	85a6                	mv	a1,s1
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	40a50513          	addi	a0,a0,1034 # 80008258 <etext+0x258>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	106080e7          	jalr	262(ra) # 80005f5c <printf>
      plic_complete(irq);
    80001e5e:	8526                	mv	a0,s1
    80001e60:	00003097          	auipc	ra,0x3
    80001e64:	610080e7          	jalr	1552(ra) # 80005470 <plic_complete>
    return 1;
    80001e68:	4505                	li	a0,1
    80001e6a:	64a2                	ld	s1,8(sp)
    80001e6c:	b755                	j	80001e10 <devintr+0x28>
    if (cpuid() == 0)
    80001e6e:	fffff097          	auipc	ra,0xfffff
    80001e72:	1f4080e7          	jalr	500(ra) # 80001062 <cpuid>
    80001e76:	c901                	beqz	a0,80001e86 <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e78:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e7e:	14479073          	csrw	sip,a5
    return 2;
    80001e82:	4509                	li	a0,2
    80001e84:	b771                	j	80001e10 <devintr+0x28>
      clockintr();
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	f1c080e7          	jalr	-228(ra) # 80001da2 <clockintr>
    80001e8e:	b7ed                	j	80001e78 <devintr+0x90>
}
    80001e90:	8082                	ret

0000000080001e92 <usertrap>:
{
    80001e92:	7139                	addi	sp,sp,-64
    80001e94:	fc06                	sd	ra,56(sp)
    80001e96:	f822                	sd	s0,48(sp)
    80001e98:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e9a:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001e9e:	1007f793          	andi	a5,a5,256
    80001ea2:	e7a5                	bnez	a5,80001f0a <usertrap+0x78>
    80001ea4:	f426                	sd	s1,40(sp)
    80001ea6:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ea8:	00003797          	auipc	a5,0x3
    80001eac:	49878793          	addi	a5,a5,1176 # 80005340 <kernelvec>
    80001eb0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001eb4:	fffff097          	auipc	ra,0xfffff
    80001eb8:	1e2080e7          	jalr	482(ra) # 80001096 <myproc>
    80001ebc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ebe:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ec0:	14102773          	csrr	a4,sepc
    80001ec4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ec6:	14202773          	csrr	a4,scause
  if (r_scause() == 8)
    80001eca:	47a1                	li	a5,8
    80001ecc:	06f71363          	bne	a4,a5,80001f32 <usertrap+0xa0>
    if (p->killed)
    80001ed0:	551c                	lw	a5,40(a0)
    80001ed2:	ebb1                	bnez	a5,80001f26 <usertrap+0x94>
    p->trapframe->epc += 4;
    80001ed4:	6cb8                	ld	a4,88(s1)
    80001ed6:	6f1c                	ld	a5,24(a4)
    80001ed8:	0791                	addi	a5,a5,4
    80001eda:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001edc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ee0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ee4:	10079073          	csrw	sstatus,a5
    syscall();
    80001ee8:	00000097          	auipc	ra,0x0
    80001eec:	392080e7          	jalr	914(ra) # 8000227a <syscall>
  if (p->killed)
    80001ef0:	549c                	lw	a5,40(s1)
    80001ef2:	12079c63          	bnez	a5,8000202a <usertrap+0x198>
  usertrapret();
    80001ef6:	00000097          	auipc	ra,0x0
    80001efa:	e0e080e7          	jalr	-498(ra) # 80001d04 <usertrapret>
    80001efe:	74a2                	ld	s1,40(sp)
    80001f00:	7902                	ld	s2,32(sp)
}
    80001f02:	70e2                	ld	ra,56(sp)
    80001f04:	7442                	ld	s0,48(sp)
    80001f06:	6121                	addi	sp,sp,64
    80001f08:	8082                	ret
    80001f0a:	f426                	sd	s1,40(sp)
    80001f0c:	f04a                	sd	s2,32(sp)
    80001f0e:	ec4e                	sd	s3,24(sp)
    80001f10:	e852                	sd	s4,16(sp)
    80001f12:	e456                	sd	s5,8(sp)
    80001f14:	e05a                	sd	s6,0(sp)
    panic("usertrap: not from user mode");
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	36250513          	addi	a0,a0,866 # 80008278 <etext+0x278>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	ff4080e7          	jalr	-12(ra) # 80005f12 <panic>
      exit(-1);
    80001f26:	557d                	li	a0,-1
    80001f28:	00000097          	auipc	ra,0x0
    80001f2c:	a8a080e7          	jalr	-1398(ra) # 800019b2 <exit>
    80001f30:	b755                	j	80001ed4 <usertrap+0x42>
  else if ((which_dev = devintr()) != 0)
    80001f32:	00000097          	auipc	ra,0x0
    80001f36:	eb6080e7          	jalr	-330(ra) # 80001de8 <devintr>
    80001f3a:	892a                	mv	s2,a0
    80001f3c:	e565                	bnez	a0,80002024 <usertrap+0x192>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f3e:	14202773          	csrr	a4,scause
  else if (r_scause() == 15)
    80001f42:	47bd                	li	a5,15
    80001f44:	08f71a63          	bne	a4,a5,80001fd8 <usertrap+0x146>
    80001f48:	ec4e                	sd	s3,24(sp)
    80001f4a:	e852                	sd	s4,16(sp)
    80001f4c:	e456                	sd	s5,8(sp)
    80001f4e:	e05a                	sd	s6,0(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f50:	143025f3          	csrr	a1,stval
    if(va > MAXVA) p->killed = 1; // invalid address, kill the process
    80001f54:	4785                	li	a5,1
    80001f56:	179a                	slli	a5,a5,0x26
    80001f58:	00b7f463          	bgeu	a5,a1,80001f60 <usertrap+0xce>
    80001f5c:	4785                	li	a5,1
    80001f5e:	d49c                	sw	a5,40(s1)
    pte_t *pte = walk(p->pagetable, va, 0);
    80001f60:	4601                	li	a2,0
    80001f62:	68a8                	ld	a0,80(s1)
    80001f64:	ffffe097          	auipc	ra,0xffffe
    80001f68:	64c080e7          	jalr	1612(ra) # 800005b0 <walk>
    80001f6c:	8a2a                	mv	s4,a0
    if(pte == 0 || (*pte & (PTE_V)) == 0 || (*pte & PTE_U) == 0) {
    80001f6e:	c511                	beqz	a0,80001f7a <usertrap+0xe8>
    80001f70:	611c                	ld	a5,0(a0)
    80001f72:	8bc5                	andi	a5,a5,17
    80001f74:	4745                	li	a4,17
    80001f76:	00e78463          	beq	a5,a4,80001f7e <usertrap+0xec>
      p->killed = 1; // page not present or not user-accessible, kill the process
    80001f7a:	4785                	li	a5,1
    80001f7c:	d49c                	sw	a5,40(s1)
    uint64 pa = PTE2PA(*pte);
    80001f7e:	000a3a83          	ld	s5,0(s4)
    uint flags = PTE_FLAGS(*pte);
    80001f82:	000a8b1b          	sext.w	s6,s5
    if(!(flags & PTE_C)) p->killed = 1; // not a COW page, so kill the process
    80001f86:	100af793          	andi	a5,s5,256
    80001f8a:	e399                	bnez	a5,80001f90 <usertrap+0xfe>
    80001f8c:	4785                	li	a5,1
    80001f8e:	d49c                	sw	a5,40(s1)
    if((mem = kalloc()) == 0) {
    80001f90:	ffffe097          	auipc	ra,0xffffe
    80001f94:	28e080e7          	jalr	654(ra) # 8000021e <kalloc>
    80001f98:	89aa                	mv	s3,a0
    80001f9a:	c951                	beqz	a0,8000202e <usertrap+0x19c>
    uint64 pa = PTE2PA(*pte);
    80001f9c:	00aada93          	srli	s5,s5,0xa
    80001fa0:	0ab2                	slli	s5,s5,0xc
      memmove(mem, (char *)pa, PGSIZE); // copy the page content
    80001fa2:	6605                	lui	a2,0x1
    80001fa4:	85d6                	mv	a1,s5
    80001fa6:	ffffe097          	auipc	ra,0xffffe
    80001faa:	376080e7          	jalr	886(ra) # 8000031c <memmove>
      *pte = PA2PTE((uint64)mem) | flags; // update the page table entry
    80001fae:	00c9d993          	srli	s3,s3,0xc
    80001fb2:	09aa                	slli	s3,s3,0xa
    flags &= ~PTE_C; // clear COW flag
    80001fb4:	2ffb7b13          	andi	s6,s6,767
      *pte = PA2PTE((uint64)mem) | flags; // update the page table entry
    80001fb8:	004b6b13          	ori	s6,s6,4
    80001fbc:	0169e9b3          	or	s3,s3,s6
    80001fc0:	013a3023          	sd	s3,0(s4)
      kfree((void *)pa); // free the old page
    80001fc4:	8556                	mv	a0,s5
    80001fc6:	ffffe097          	auipc	ra,0xffffe
    80001fca:	0ee080e7          	jalr	238(ra) # 800000b4 <kfree>
    80001fce:	69e2                	ld	s3,24(sp)
    80001fd0:	6a42                	ld	s4,16(sp)
    80001fd2:	6aa2                	ld	s5,8(sp)
    80001fd4:	6b02                	ld	s6,0(sp)
    80001fd6:	bf29                	j	80001ef0 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fd8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001fdc:	5890                	lw	a2,48(s1)
    80001fde:	00006517          	auipc	a0,0x6
    80001fe2:	2ba50513          	addi	a0,a0,698 # 80008298 <etext+0x298>
    80001fe6:	00004097          	auipc	ra,0x4
    80001fea:	f76080e7          	jalr	-138(ra) # 80005f5c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fee:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ff2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ff6:	00006517          	auipc	a0,0x6
    80001ffa:	2d250513          	addi	a0,a0,722 # 800082c8 <etext+0x2c8>
    80001ffe:	00004097          	auipc	ra,0x4
    80002002:	f5e080e7          	jalr	-162(ra) # 80005f5c <printf>
      p->killed = 1; // out of memory, kill the process
    80002006:	4785                	li	a5,1
    80002008:	d49c                	sw	a5,40(s1)
    exit(-1);
    8000200a:	557d                	li	a0,-1
    8000200c:	00000097          	auipc	ra,0x0
    80002010:	9a6080e7          	jalr	-1626(ra) # 800019b2 <exit>
  if (which_dev == 2)
    80002014:	4789                	li	a5,2
    80002016:	eef910e3          	bne	s2,a5,80001ef6 <usertrap+0x64>
    yield();
    8000201a:	fffff097          	auipc	ra,0xfffff
    8000201e:	706080e7          	jalr	1798(ra) # 80001720 <yield>
    80002022:	bdd1                	j	80001ef6 <usertrap+0x64>
  if (p->killed)
    80002024:	549c                	lw	a5,40(s1)
    80002026:	d7fd                	beqz	a5,80002014 <usertrap+0x182>
    80002028:	b7cd                	j	8000200a <usertrap+0x178>
    8000202a:	4901                	li	s2,0
    8000202c:	bff9                	j	8000200a <usertrap+0x178>
    8000202e:	69e2                	ld	s3,24(sp)
    80002030:	6a42                	ld	s4,16(sp)
    80002032:	6aa2                	ld	s5,8(sp)
    80002034:	6b02                	ld	s6,0(sp)
    80002036:	bfc1                	j	80002006 <usertrap+0x174>

0000000080002038 <kerneltrap>:
{
    80002038:	7179                	addi	sp,sp,-48
    8000203a:	f406                	sd	ra,40(sp)
    8000203c:	f022                	sd	s0,32(sp)
    8000203e:	ec26                	sd	s1,24(sp)
    80002040:	e84a                	sd	s2,16(sp)
    80002042:	e44e                	sd	s3,8(sp)
    80002044:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002046:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000204a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000204e:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002052:	1004f793          	andi	a5,s1,256
    80002056:	cb85                	beqz	a5,80002086 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002058:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000205c:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    8000205e:	ef85                	bnez	a5,80002096 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0)
    80002060:	00000097          	auipc	ra,0x0
    80002064:	d88080e7          	jalr	-632(ra) # 80001de8 <devintr>
    80002068:	cd1d                	beqz	a0,800020a6 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000206a:	4789                	li	a5,2
    8000206c:	06f50a63          	beq	a0,a5,800020e0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002070:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002074:	10049073          	csrw	sstatus,s1
}
    80002078:	70a2                	ld	ra,40(sp)
    8000207a:	7402                	ld	s0,32(sp)
    8000207c:	64e2                	ld	s1,24(sp)
    8000207e:	6942                	ld	s2,16(sp)
    80002080:	69a2                	ld	s3,8(sp)
    80002082:	6145                	addi	sp,sp,48
    80002084:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002086:	00006517          	auipc	a0,0x6
    8000208a:	26250513          	addi	a0,a0,610 # 800082e8 <etext+0x2e8>
    8000208e:	00004097          	auipc	ra,0x4
    80002092:	e84080e7          	jalr	-380(ra) # 80005f12 <panic>
    panic("kerneltrap: interrupts enabled");
    80002096:	00006517          	auipc	a0,0x6
    8000209a:	27a50513          	addi	a0,a0,634 # 80008310 <etext+0x310>
    8000209e:	00004097          	auipc	ra,0x4
    800020a2:	e74080e7          	jalr	-396(ra) # 80005f12 <panic>
    printf("scause %p\n", scause);
    800020a6:	85ce                	mv	a1,s3
    800020a8:	00006517          	auipc	a0,0x6
    800020ac:	28850513          	addi	a0,a0,648 # 80008330 <etext+0x330>
    800020b0:	00004097          	auipc	ra,0x4
    800020b4:	eac080e7          	jalr	-340(ra) # 80005f5c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020b8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020bc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020c0:	00006517          	auipc	a0,0x6
    800020c4:	28050513          	addi	a0,a0,640 # 80008340 <etext+0x340>
    800020c8:	00004097          	auipc	ra,0x4
    800020cc:	e94080e7          	jalr	-364(ra) # 80005f5c <printf>
    panic("kerneltrap");
    800020d0:	00006517          	auipc	a0,0x6
    800020d4:	28850513          	addi	a0,a0,648 # 80008358 <etext+0x358>
    800020d8:	00004097          	auipc	ra,0x4
    800020dc:	e3a080e7          	jalr	-454(ra) # 80005f12 <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	fb6080e7          	jalr	-74(ra) # 80001096 <myproc>
    800020e8:	d541                	beqz	a0,80002070 <kerneltrap+0x38>
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	fac080e7          	jalr	-84(ra) # 80001096 <myproc>
    800020f2:	4d18                	lw	a4,24(a0)
    800020f4:	4791                	li	a5,4
    800020f6:	f6f71de3          	bne	a4,a5,80002070 <kerneltrap+0x38>
    yield();
    800020fa:	fffff097          	auipc	ra,0xfffff
    800020fe:	626080e7          	jalr	1574(ra) # 80001720 <yield>
    80002102:	b7bd                	j	80002070 <kerneltrap+0x38>

0000000080002104 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002104:	1101                	addi	sp,sp,-32
    80002106:	ec06                	sd	ra,24(sp)
    80002108:	e822                	sd	s0,16(sp)
    8000210a:	e426                	sd	s1,8(sp)
    8000210c:	1000                	addi	s0,sp,32
    8000210e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	f86080e7          	jalr	-122(ra) # 80001096 <myproc>
  switch (n) {
    80002118:	4795                	li	a5,5
    8000211a:	0497e163          	bltu	a5,s1,8000215c <argraw+0x58>
    8000211e:	048a                	slli	s1,s1,0x2
    80002120:	00006717          	auipc	a4,0x6
    80002124:	62070713          	addi	a4,a4,1568 # 80008740 <states.0+0x30>
    80002128:	94ba                	add	s1,s1,a4
    8000212a:	409c                	lw	a5,0(s1)
    8000212c:	97ba                	add	a5,a5,a4
    8000212e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002130:	6d3c                	ld	a5,88(a0)
    80002132:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002134:	60e2                	ld	ra,24(sp)
    80002136:	6442                	ld	s0,16(sp)
    80002138:	64a2                	ld	s1,8(sp)
    8000213a:	6105                	addi	sp,sp,32
    8000213c:	8082                	ret
    return p->trapframe->a1;
    8000213e:	6d3c                	ld	a5,88(a0)
    80002140:	7fa8                	ld	a0,120(a5)
    80002142:	bfcd                	j	80002134 <argraw+0x30>
    return p->trapframe->a2;
    80002144:	6d3c                	ld	a5,88(a0)
    80002146:	63c8                	ld	a0,128(a5)
    80002148:	b7f5                	j	80002134 <argraw+0x30>
    return p->trapframe->a3;
    8000214a:	6d3c                	ld	a5,88(a0)
    8000214c:	67c8                	ld	a0,136(a5)
    8000214e:	b7dd                	j	80002134 <argraw+0x30>
    return p->trapframe->a4;
    80002150:	6d3c                	ld	a5,88(a0)
    80002152:	6bc8                	ld	a0,144(a5)
    80002154:	b7c5                	j	80002134 <argraw+0x30>
    return p->trapframe->a5;
    80002156:	6d3c                	ld	a5,88(a0)
    80002158:	6fc8                	ld	a0,152(a5)
    8000215a:	bfe9                	j	80002134 <argraw+0x30>
  panic("argraw");
    8000215c:	00006517          	auipc	a0,0x6
    80002160:	20c50513          	addi	a0,a0,524 # 80008368 <etext+0x368>
    80002164:	00004097          	auipc	ra,0x4
    80002168:	dae080e7          	jalr	-594(ra) # 80005f12 <panic>

000000008000216c <fetchaddr>:
{
    8000216c:	1101                	addi	sp,sp,-32
    8000216e:	ec06                	sd	ra,24(sp)
    80002170:	e822                	sd	s0,16(sp)
    80002172:	e426                	sd	s1,8(sp)
    80002174:	e04a                	sd	s2,0(sp)
    80002176:	1000                	addi	s0,sp,32
    80002178:	84aa                	mv	s1,a0
    8000217a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	f1a080e7          	jalr	-230(ra) # 80001096 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002184:	653c                	ld	a5,72(a0)
    80002186:	02f4f863          	bgeu	s1,a5,800021b6 <fetchaddr+0x4a>
    8000218a:	00848713          	addi	a4,s1,8
    8000218e:	02e7e663          	bltu	a5,a4,800021ba <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002192:	46a1                	li	a3,8
    80002194:	8626                	mv	a2,s1
    80002196:	85ca                	mv	a1,s2
    80002198:	6928                	ld	a0,80(a0)
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	c34080e7          	jalr	-972(ra) # 80000dce <copyin>
    800021a2:	00a03533          	snez	a0,a0
    800021a6:	40a0053b          	negw	a0,a0
}
    800021aa:	60e2                	ld	ra,24(sp)
    800021ac:	6442                	ld	s0,16(sp)
    800021ae:	64a2                	ld	s1,8(sp)
    800021b0:	6902                	ld	s2,0(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret
    return -1;
    800021b6:	557d                	li	a0,-1
    800021b8:	bfcd                	j	800021aa <fetchaddr+0x3e>
    800021ba:	557d                	li	a0,-1
    800021bc:	b7fd                	j	800021aa <fetchaddr+0x3e>

00000000800021be <fetchstr>:
{
    800021be:	7179                	addi	sp,sp,-48
    800021c0:	f406                	sd	ra,40(sp)
    800021c2:	f022                	sd	s0,32(sp)
    800021c4:	ec26                	sd	s1,24(sp)
    800021c6:	e84a                	sd	s2,16(sp)
    800021c8:	e44e                	sd	s3,8(sp)
    800021ca:	1800                	addi	s0,sp,48
    800021cc:	892a                	mv	s2,a0
    800021ce:	84ae                	mv	s1,a1
    800021d0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	ec4080e7          	jalr	-316(ra) # 80001096 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800021da:	86ce                	mv	a3,s3
    800021dc:	864a                	mv	a2,s2
    800021de:	85a6                	mv	a1,s1
    800021e0:	6928                	ld	a0,80(a0)
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	c7a080e7          	jalr	-902(ra) # 80000e5c <copyinstr>
  if(err < 0)
    800021ea:	00054763          	bltz	a0,800021f8 <fetchstr+0x3a>
  return strlen(buf);
    800021ee:	8526                	mv	a0,s1
    800021f0:	ffffe097          	auipc	ra,0xffffe
    800021f4:	254080e7          	jalr	596(ra) # 80000444 <strlen>
}
    800021f8:	70a2                	ld	ra,40(sp)
    800021fa:	7402                	ld	s0,32(sp)
    800021fc:	64e2                	ld	s1,24(sp)
    800021fe:	6942                	ld	s2,16(sp)
    80002200:	69a2                	ld	s3,8(sp)
    80002202:	6145                	addi	sp,sp,48
    80002204:	8082                	ret

0000000080002206 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002206:	1101                	addi	sp,sp,-32
    80002208:	ec06                	sd	ra,24(sp)
    8000220a:	e822                	sd	s0,16(sp)
    8000220c:	e426                	sd	s1,8(sp)
    8000220e:	1000                	addi	s0,sp,32
    80002210:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002212:	00000097          	auipc	ra,0x0
    80002216:	ef2080e7          	jalr	-270(ra) # 80002104 <argraw>
    8000221a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000221c:	4501                	li	a0,0
    8000221e:	60e2                	ld	ra,24(sp)
    80002220:	6442                	ld	s0,16(sp)
    80002222:	64a2                	ld	s1,8(sp)
    80002224:	6105                	addi	sp,sp,32
    80002226:	8082                	ret

0000000080002228 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002228:	1101                	addi	sp,sp,-32
    8000222a:	ec06                	sd	ra,24(sp)
    8000222c:	e822                	sd	s0,16(sp)
    8000222e:	e426                	sd	s1,8(sp)
    80002230:	1000                	addi	s0,sp,32
    80002232:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002234:	00000097          	auipc	ra,0x0
    80002238:	ed0080e7          	jalr	-304(ra) # 80002104 <argraw>
    8000223c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000223e:	4501                	li	a0,0
    80002240:	60e2                	ld	ra,24(sp)
    80002242:	6442                	ld	s0,16(sp)
    80002244:	64a2                	ld	s1,8(sp)
    80002246:	6105                	addi	sp,sp,32
    80002248:	8082                	ret

000000008000224a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000224a:	1101                	addi	sp,sp,-32
    8000224c:	ec06                	sd	ra,24(sp)
    8000224e:	e822                	sd	s0,16(sp)
    80002250:	e426                	sd	s1,8(sp)
    80002252:	e04a                	sd	s2,0(sp)
    80002254:	1000                	addi	s0,sp,32
    80002256:	84ae                	mv	s1,a1
    80002258:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	eaa080e7          	jalr	-342(ra) # 80002104 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002262:	864a                	mv	a2,s2
    80002264:	85a6                	mv	a1,s1
    80002266:	00000097          	auipc	ra,0x0
    8000226a:	f58080e7          	jalr	-168(ra) # 800021be <fetchstr>
}
    8000226e:	60e2                	ld	ra,24(sp)
    80002270:	6442                	ld	s0,16(sp)
    80002272:	64a2                	ld	s1,8(sp)
    80002274:	6902                	ld	s2,0(sp)
    80002276:	6105                	addi	sp,sp,32
    80002278:	8082                	ret

000000008000227a <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	e426                	sd	s1,8(sp)
    80002282:	e04a                	sd	s2,0(sp)
    80002284:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002286:	fffff097          	auipc	ra,0xfffff
    8000228a:	e10080e7          	jalr	-496(ra) # 80001096 <myproc>
    8000228e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002290:	05853903          	ld	s2,88(a0)
    80002294:	0a893783          	ld	a5,168(s2)
    80002298:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000229c:	37fd                	addiw	a5,a5,-1
    8000229e:	4751                	li	a4,20
    800022a0:	00f76f63          	bltu	a4,a5,800022be <syscall+0x44>
    800022a4:	00369713          	slli	a4,a3,0x3
    800022a8:	00006797          	auipc	a5,0x6
    800022ac:	4b078793          	addi	a5,a5,1200 # 80008758 <syscalls>
    800022b0:	97ba                	add	a5,a5,a4
    800022b2:	639c                	ld	a5,0(a5)
    800022b4:	c789                	beqz	a5,800022be <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800022b6:	9782                	jalr	a5
    800022b8:	06a93823          	sd	a0,112(s2)
    800022bc:	a839                	j	800022da <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022be:	15848613          	addi	a2,s1,344
    800022c2:	588c                	lw	a1,48(s1)
    800022c4:	00006517          	auipc	a0,0x6
    800022c8:	0ac50513          	addi	a0,a0,172 # 80008370 <etext+0x370>
    800022cc:	00004097          	auipc	ra,0x4
    800022d0:	c90080e7          	jalr	-880(ra) # 80005f5c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022d4:	6cbc                	ld	a5,88(s1)
    800022d6:	577d                	li	a4,-1
    800022d8:	fbb8                	sd	a4,112(a5)
  }
}
    800022da:	60e2                	ld	ra,24(sp)
    800022dc:	6442                	ld	s0,16(sp)
    800022de:	64a2                	ld	s1,8(sp)
    800022e0:	6902                	ld	s2,0(sp)
    800022e2:	6105                	addi	sp,sp,32
    800022e4:	8082                	ret

00000000800022e6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800022e6:	1101                	addi	sp,sp,-32
    800022e8:	ec06                	sd	ra,24(sp)
    800022ea:	e822                	sd	s0,16(sp)
    800022ec:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800022ee:	fec40593          	addi	a1,s0,-20
    800022f2:	4501                	li	a0,0
    800022f4:	00000097          	auipc	ra,0x0
    800022f8:	f12080e7          	jalr	-238(ra) # 80002206 <argint>
    return -1;
    800022fc:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022fe:	00054963          	bltz	a0,80002310 <sys_exit+0x2a>
  exit(n);
    80002302:	fec42503          	lw	a0,-20(s0)
    80002306:	fffff097          	auipc	ra,0xfffff
    8000230a:	6ac080e7          	jalr	1708(ra) # 800019b2 <exit>
  return 0;  // not reached
    8000230e:	4781                	li	a5,0
}
    80002310:	853e                	mv	a0,a5
    80002312:	60e2                	ld	ra,24(sp)
    80002314:	6442                	ld	s0,16(sp)
    80002316:	6105                	addi	sp,sp,32
    80002318:	8082                	ret

000000008000231a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000231a:	1141                	addi	sp,sp,-16
    8000231c:	e406                	sd	ra,8(sp)
    8000231e:	e022                	sd	s0,0(sp)
    80002320:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	d74080e7          	jalr	-652(ra) # 80001096 <myproc>
}
    8000232a:	5908                	lw	a0,48(a0)
    8000232c:	60a2                	ld	ra,8(sp)
    8000232e:	6402                	ld	s0,0(sp)
    80002330:	0141                	addi	sp,sp,16
    80002332:	8082                	ret

0000000080002334 <sys_fork>:

uint64
sys_fork(void)
{
    80002334:	1141                	addi	sp,sp,-16
    80002336:	e406                	sd	ra,8(sp)
    80002338:	e022                	sd	s0,0(sp)
    8000233a:	0800                	addi	s0,sp,16
  return fork();
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	12c080e7          	jalr	300(ra) # 80001468 <fork>
}
    80002344:	60a2                	ld	ra,8(sp)
    80002346:	6402                	ld	s0,0(sp)
    80002348:	0141                	addi	sp,sp,16
    8000234a:	8082                	ret

000000008000234c <sys_wait>:

uint64
sys_wait(void)
{
    8000234c:	1101                	addi	sp,sp,-32
    8000234e:	ec06                	sd	ra,24(sp)
    80002350:	e822                	sd	s0,16(sp)
    80002352:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002354:	fe840593          	addi	a1,s0,-24
    80002358:	4501                	li	a0,0
    8000235a:	00000097          	auipc	ra,0x0
    8000235e:	ece080e7          	jalr	-306(ra) # 80002228 <argaddr>
    80002362:	87aa                	mv	a5,a0
    return -1;
    80002364:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002366:	0007c863          	bltz	a5,80002376 <sys_wait+0x2a>
  return wait(p);
    8000236a:	fe843503          	ld	a0,-24(s0)
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	452080e7          	jalr	1106(ra) # 800017c0 <wait>
}
    80002376:	60e2                	ld	ra,24(sp)
    80002378:	6442                	ld	s0,16(sp)
    8000237a:	6105                	addi	sp,sp,32
    8000237c:	8082                	ret

000000008000237e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000237e:	7179                	addi	sp,sp,-48
    80002380:	f406                	sd	ra,40(sp)
    80002382:	f022                	sd	s0,32(sp)
    80002384:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002386:	fdc40593          	addi	a1,s0,-36
    8000238a:	4501                	li	a0,0
    8000238c:	00000097          	auipc	ra,0x0
    80002390:	e7a080e7          	jalr	-390(ra) # 80002206 <argint>
    80002394:	87aa                	mv	a5,a0
    return -1;
    80002396:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002398:	0207c263          	bltz	a5,800023bc <sys_sbrk+0x3e>
    8000239c:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    8000239e:	fffff097          	auipc	ra,0xfffff
    800023a2:	cf8080e7          	jalr	-776(ra) # 80001096 <myproc>
    800023a6:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    800023a8:	fdc42503          	lw	a0,-36(s0)
    800023ac:	fffff097          	auipc	ra,0xfffff
    800023b0:	044080e7          	jalr	68(ra) # 800013f0 <growproc>
    800023b4:	00054863          	bltz	a0,800023c4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800023b8:	8526                	mv	a0,s1
    800023ba:	64e2                	ld	s1,24(sp)
}
    800023bc:	70a2                	ld	ra,40(sp)
    800023be:	7402                	ld	s0,32(sp)
    800023c0:	6145                	addi	sp,sp,48
    800023c2:	8082                	ret
    return -1;
    800023c4:	557d                	li	a0,-1
    800023c6:	64e2                	ld	s1,24(sp)
    800023c8:	bfd5                	j	800023bc <sys_sbrk+0x3e>

00000000800023ca <sys_sleep>:

uint64
sys_sleep(void)
{
    800023ca:	7139                	addi	sp,sp,-64
    800023cc:	fc06                	sd	ra,56(sp)
    800023ce:	f822                	sd	s0,48(sp)
    800023d0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800023d2:	fcc40593          	addi	a1,s0,-52
    800023d6:	4501                	li	a0,0
    800023d8:	00000097          	auipc	ra,0x0
    800023dc:	e2e080e7          	jalr	-466(ra) # 80002206 <argint>
    return -1;
    800023e0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800023e2:	06054b63          	bltz	a0,80002458 <sys_sleep+0x8e>
    800023e6:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800023e8:	0024d517          	auipc	a0,0x24d
    800023ec:	ad050513          	addi	a0,a0,-1328 # 8024eeb8 <tickslock>
    800023f0:	00004097          	auipc	ra,0x4
    800023f4:	0a2080e7          	jalr	162(ra) # 80006492 <acquire>
  ticks0 = ticks;
    800023f8:	00007917          	auipc	s2,0x7
    800023fc:	c2092903          	lw	s2,-992(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002400:	fcc42783          	lw	a5,-52(s0)
    80002404:	c3a1                	beqz	a5,80002444 <sys_sleep+0x7a>
    80002406:	f426                	sd	s1,40(sp)
    80002408:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000240a:	0024d997          	auipc	s3,0x24d
    8000240e:	aae98993          	addi	s3,s3,-1362 # 8024eeb8 <tickslock>
    80002412:	00007497          	auipc	s1,0x7
    80002416:	c0648493          	addi	s1,s1,-1018 # 80009018 <ticks>
    if(myproc()->killed){
    8000241a:	fffff097          	auipc	ra,0xfffff
    8000241e:	c7c080e7          	jalr	-900(ra) # 80001096 <myproc>
    80002422:	551c                	lw	a5,40(a0)
    80002424:	ef9d                	bnez	a5,80002462 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002426:	85ce                	mv	a1,s3
    80002428:	8526                	mv	a0,s1
    8000242a:	fffff097          	auipc	ra,0xfffff
    8000242e:	332080e7          	jalr	818(ra) # 8000175c <sleep>
  while(ticks - ticks0 < n){
    80002432:	409c                	lw	a5,0(s1)
    80002434:	412787bb          	subw	a5,a5,s2
    80002438:	fcc42703          	lw	a4,-52(s0)
    8000243c:	fce7efe3          	bltu	a5,a4,8000241a <sys_sleep+0x50>
    80002440:	74a2                	ld	s1,40(sp)
    80002442:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002444:	0024d517          	auipc	a0,0x24d
    80002448:	a7450513          	addi	a0,a0,-1420 # 8024eeb8 <tickslock>
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	0f6080e7          	jalr	246(ra) # 80006542 <release>
  return 0;
    80002454:	4781                	li	a5,0
    80002456:	7902                	ld	s2,32(sp)
}
    80002458:	853e                	mv	a0,a5
    8000245a:	70e2                	ld	ra,56(sp)
    8000245c:	7442                	ld	s0,48(sp)
    8000245e:	6121                	addi	sp,sp,64
    80002460:	8082                	ret
      release(&tickslock);
    80002462:	0024d517          	auipc	a0,0x24d
    80002466:	a5650513          	addi	a0,a0,-1450 # 8024eeb8 <tickslock>
    8000246a:	00004097          	auipc	ra,0x4
    8000246e:	0d8080e7          	jalr	216(ra) # 80006542 <release>
      return -1;
    80002472:	57fd                	li	a5,-1
    80002474:	74a2                	ld	s1,40(sp)
    80002476:	7902                	ld	s2,32(sp)
    80002478:	69e2                	ld	s3,24(sp)
    8000247a:	bff9                	j	80002458 <sys_sleep+0x8e>

000000008000247c <sys_kill>:

uint64
sys_kill(void)
{
    8000247c:	1101                	addi	sp,sp,-32
    8000247e:	ec06                	sd	ra,24(sp)
    80002480:	e822                	sd	s0,16(sp)
    80002482:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002484:	fec40593          	addi	a1,s0,-20
    80002488:	4501                	li	a0,0
    8000248a:	00000097          	auipc	ra,0x0
    8000248e:	d7c080e7          	jalr	-644(ra) # 80002206 <argint>
    80002492:	87aa                	mv	a5,a0
    return -1;
    80002494:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002496:	0007c863          	bltz	a5,800024a6 <sys_kill+0x2a>
  return kill(pid);
    8000249a:	fec42503          	lw	a0,-20(s0)
    8000249e:	fffff097          	auipc	ra,0xfffff
    800024a2:	5ea080e7          	jalr	1514(ra) # 80001a88 <kill>
}
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	6105                	addi	sp,sp,32
    800024ac:	8082                	ret

00000000800024ae <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800024ae:	1101                	addi	sp,sp,-32
    800024b0:	ec06                	sd	ra,24(sp)
    800024b2:	e822                	sd	s0,16(sp)
    800024b4:	e426                	sd	s1,8(sp)
    800024b6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024b8:	0024d517          	auipc	a0,0x24d
    800024bc:	a0050513          	addi	a0,a0,-1536 # 8024eeb8 <tickslock>
    800024c0:	00004097          	auipc	ra,0x4
    800024c4:	fd2080e7          	jalr	-46(ra) # 80006492 <acquire>
  xticks = ticks;
    800024c8:	00007497          	auipc	s1,0x7
    800024cc:	b504a483          	lw	s1,-1200(s1) # 80009018 <ticks>
  release(&tickslock);
    800024d0:	0024d517          	auipc	a0,0x24d
    800024d4:	9e850513          	addi	a0,a0,-1560 # 8024eeb8 <tickslock>
    800024d8:	00004097          	auipc	ra,0x4
    800024dc:	06a080e7          	jalr	106(ra) # 80006542 <release>
  return xticks;
}
    800024e0:	02049513          	slli	a0,s1,0x20
    800024e4:	9101                	srli	a0,a0,0x20
    800024e6:	60e2                	ld	ra,24(sp)
    800024e8:	6442                	ld	s0,16(sp)
    800024ea:	64a2                	ld	s1,8(sp)
    800024ec:	6105                	addi	sp,sp,32
    800024ee:	8082                	ret

00000000800024f0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024f0:	7179                	addi	sp,sp,-48
    800024f2:	f406                	sd	ra,40(sp)
    800024f4:	f022                	sd	s0,32(sp)
    800024f6:	ec26                	sd	s1,24(sp)
    800024f8:	e84a                	sd	s2,16(sp)
    800024fa:	e44e                	sd	s3,8(sp)
    800024fc:	e052                	sd	s4,0(sp)
    800024fe:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002500:	00006597          	auipc	a1,0x6
    80002504:	e9058593          	addi	a1,a1,-368 # 80008390 <etext+0x390>
    80002508:	0024d517          	auipc	a0,0x24d
    8000250c:	9c850513          	addi	a0,a0,-1592 # 8024eed0 <bcache>
    80002510:	00004097          	auipc	ra,0x4
    80002514:	eee080e7          	jalr	-274(ra) # 800063fe <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002518:	00255797          	auipc	a5,0x255
    8000251c:	9b878793          	addi	a5,a5,-1608 # 80256ed0 <bcache+0x8000>
    80002520:	00255717          	auipc	a4,0x255
    80002524:	c1870713          	addi	a4,a4,-1000 # 80257138 <bcache+0x8268>
    80002528:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000252c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002530:	0024d497          	auipc	s1,0x24d
    80002534:	9b848493          	addi	s1,s1,-1608 # 8024eee8 <bcache+0x18>
    b->next = bcache.head.next;
    80002538:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000253a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000253c:	00006a17          	auipc	s4,0x6
    80002540:	e5ca0a13          	addi	s4,s4,-420 # 80008398 <etext+0x398>
    b->next = bcache.head.next;
    80002544:	2b893783          	ld	a5,696(s2)
    80002548:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000254a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000254e:	85d2                	mv	a1,s4
    80002550:	01048513          	addi	a0,s1,16
    80002554:	00001097          	auipc	ra,0x1
    80002558:	4ba080e7          	jalr	1210(ra) # 80003a0e <initsleeplock>
    bcache.head.next->prev = b;
    8000255c:	2b893783          	ld	a5,696(s2)
    80002560:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002562:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002566:	45848493          	addi	s1,s1,1112
    8000256a:	fd349de3          	bne	s1,s3,80002544 <binit+0x54>
  }
}
    8000256e:	70a2                	ld	ra,40(sp)
    80002570:	7402                	ld	s0,32(sp)
    80002572:	64e2                	ld	s1,24(sp)
    80002574:	6942                	ld	s2,16(sp)
    80002576:	69a2                	ld	s3,8(sp)
    80002578:	6a02                	ld	s4,0(sp)
    8000257a:	6145                	addi	sp,sp,48
    8000257c:	8082                	ret

000000008000257e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000257e:	7179                	addi	sp,sp,-48
    80002580:	f406                	sd	ra,40(sp)
    80002582:	f022                	sd	s0,32(sp)
    80002584:	ec26                	sd	s1,24(sp)
    80002586:	e84a                	sd	s2,16(sp)
    80002588:	e44e                	sd	s3,8(sp)
    8000258a:	1800                	addi	s0,sp,48
    8000258c:	892a                	mv	s2,a0
    8000258e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002590:	0024d517          	auipc	a0,0x24d
    80002594:	94050513          	addi	a0,a0,-1728 # 8024eed0 <bcache>
    80002598:	00004097          	auipc	ra,0x4
    8000259c:	efa080e7          	jalr	-262(ra) # 80006492 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025a0:	00255497          	auipc	s1,0x255
    800025a4:	be84b483          	ld	s1,-1048(s1) # 80257188 <bcache+0x82b8>
    800025a8:	00255797          	auipc	a5,0x255
    800025ac:	b9078793          	addi	a5,a5,-1136 # 80257138 <bcache+0x8268>
    800025b0:	02f48f63          	beq	s1,a5,800025ee <bread+0x70>
    800025b4:	873e                	mv	a4,a5
    800025b6:	a021                	j	800025be <bread+0x40>
    800025b8:	68a4                	ld	s1,80(s1)
    800025ba:	02e48a63          	beq	s1,a4,800025ee <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025be:	449c                	lw	a5,8(s1)
    800025c0:	ff279ce3          	bne	a5,s2,800025b8 <bread+0x3a>
    800025c4:	44dc                	lw	a5,12(s1)
    800025c6:	ff3799e3          	bne	a5,s3,800025b8 <bread+0x3a>
      b->refcnt++;
    800025ca:	40bc                	lw	a5,64(s1)
    800025cc:	2785                	addiw	a5,a5,1
    800025ce:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025d0:	0024d517          	auipc	a0,0x24d
    800025d4:	90050513          	addi	a0,a0,-1792 # 8024eed0 <bcache>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	f6a080e7          	jalr	-150(ra) # 80006542 <release>
      acquiresleep(&b->lock);
    800025e0:	01048513          	addi	a0,s1,16
    800025e4:	00001097          	auipc	ra,0x1
    800025e8:	464080e7          	jalr	1124(ra) # 80003a48 <acquiresleep>
      return b;
    800025ec:	a8b9                	j	8000264a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025ee:	00255497          	auipc	s1,0x255
    800025f2:	b924b483          	ld	s1,-1134(s1) # 80257180 <bcache+0x82b0>
    800025f6:	00255797          	auipc	a5,0x255
    800025fa:	b4278793          	addi	a5,a5,-1214 # 80257138 <bcache+0x8268>
    800025fe:	00f48863          	beq	s1,a5,8000260e <bread+0x90>
    80002602:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002604:	40bc                	lw	a5,64(s1)
    80002606:	cf81                	beqz	a5,8000261e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002608:	64a4                	ld	s1,72(s1)
    8000260a:	fee49de3          	bne	s1,a4,80002604 <bread+0x86>
  panic("bget: no buffers");
    8000260e:	00006517          	auipc	a0,0x6
    80002612:	d9250513          	addi	a0,a0,-622 # 800083a0 <etext+0x3a0>
    80002616:	00004097          	auipc	ra,0x4
    8000261a:	8fc080e7          	jalr	-1796(ra) # 80005f12 <panic>
      b->dev = dev;
    8000261e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002622:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002626:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000262a:	4785                	li	a5,1
    8000262c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000262e:	0024d517          	auipc	a0,0x24d
    80002632:	8a250513          	addi	a0,a0,-1886 # 8024eed0 <bcache>
    80002636:	00004097          	auipc	ra,0x4
    8000263a:	f0c080e7          	jalr	-244(ra) # 80006542 <release>
      acquiresleep(&b->lock);
    8000263e:	01048513          	addi	a0,s1,16
    80002642:	00001097          	auipc	ra,0x1
    80002646:	406080e7          	jalr	1030(ra) # 80003a48 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000264a:	409c                	lw	a5,0(s1)
    8000264c:	cb89                	beqz	a5,8000265e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000264e:	8526                	mv	a0,s1
    80002650:	70a2                	ld	ra,40(sp)
    80002652:	7402                	ld	s0,32(sp)
    80002654:	64e2                	ld	s1,24(sp)
    80002656:	6942                	ld	s2,16(sp)
    80002658:	69a2                	ld	s3,8(sp)
    8000265a:	6145                	addi	sp,sp,48
    8000265c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000265e:	4581                	li	a1,0
    80002660:	8526                	mv	a0,s1
    80002662:	00003097          	auipc	ra,0x3
    80002666:	01c080e7          	jalr	28(ra) # 8000567e <virtio_disk_rw>
    b->valid = 1;
    8000266a:	4785                	li	a5,1
    8000266c:	c09c                	sw	a5,0(s1)
  return b;
    8000266e:	b7c5                	j	8000264e <bread+0xd0>

0000000080002670 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002670:	1101                	addi	sp,sp,-32
    80002672:	ec06                	sd	ra,24(sp)
    80002674:	e822                	sd	s0,16(sp)
    80002676:	e426                	sd	s1,8(sp)
    80002678:	1000                	addi	s0,sp,32
    8000267a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000267c:	0541                	addi	a0,a0,16
    8000267e:	00001097          	auipc	ra,0x1
    80002682:	464080e7          	jalr	1124(ra) # 80003ae2 <holdingsleep>
    80002686:	cd01                	beqz	a0,8000269e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002688:	4585                	li	a1,1
    8000268a:	8526                	mv	a0,s1
    8000268c:	00003097          	auipc	ra,0x3
    80002690:	ff2080e7          	jalr	-14(ra) # 8000567e <virtio_disk_rw>
}
    80002694:	60e2                	ld	ra,24(sp)
    80002696:	6442                	ld	s0,16(sp)
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	6105                	addi	sp,sp,32
    8000269c:	8082                	ret
    panic("bwrite");
    8000269e:	00006517          	auipc	a0,0x6
    800026a2:	d1a50513          	addi	a0,a0,-742 # 800083b8 <etext+0x3b8>
    800026a6:	00004097          	auipc	ra,0x4
    800026aa:	86c080e7          	jalr	-1940(ra) # 80005f12 <panic>

00000000800026ae <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026ae:	1101                	addi	sp,sp,-32
    800026b0:	ec06                	sd	ra,24(sp)
    800026b2:	e822                	sd	s0,16(sp)
    800026b4:	e426                	sd	s1,8(sp)
    800026b6:	e04a                	sd	s2,0(sp)
    800026b8:	1000                	addi	s0,sp,32
    800026ba:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026bc:	01050913          	addi	s2,a0,16
    800026c0:	854a                	mv	a0,s2
    800026c2:	00001097          	auipc	ra,0x1
    800026c6:	420080e7          	jalr	1056(ra) # 80003ae2 <holdingsleep>
    800026ca:	c535                	beqz	a0,80002736 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    800026cc:	854a                	mv	a0,s2
    800026ce:	00001097          	auipc	ra,0x1
    800026d2:	3d0080e7          	jalr	976(ra) # 80003a9e <releasesleep>

  acquire(&bcache.lock);
    800026d6:	0024c517          	auipc	a0,0x24c
    800026da:	7fa50513          	addi	a0,a0,2042 # 8024eed0 <bcache>
    800026de:	00004097          	auipc	ra,0x4
    800026e2:	db4080e7          	jalr	-588(ra) # 80006492 <acquire>
  b->refcnt--;
    800026e6:	40bc                	lw	a5,64(s1)
    800026e8:	37fd                	addiw	a5,a5,-1
    800026ea:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026ec:	e79d                	bnez	a5,8000271a <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026ee:	68b8                	ld	a4,80(s1)
    800026f0:	64bc                	ld	a5,72(s1)
    800026f2:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800026f4:	68b8                	ld	a4,80(s1)
    800026f6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026f8:	00254797          	auipc	a5,0x254
    800026fc:	7d878793          	addi	a5,a5,2008 # 80256ed0 <bcache+0x8000>
    80002700:	2b87b703          	ld	a4,696(a5)
    80002704:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002706:	00255717          	auipc	a4,0x255
    8000270a:	a3270713          	addi	a4,a4,-1486 # 80257138 <bcache+0x8268>
    8000270e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002710:	2b87b703          	ld	a4,696(a5)
    80002714:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002716:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000271a:	0024c517          	auipc	a0,0x24c
    8000271e:	7b650513          	addi	a0,a0,1974 # 8024eed0 <bcache>
    80002722:	00004097          	auipc	ra,0x4
    80002726:	e20080e7          	jalr	-480(ra) # 80006542 <release>
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6902                	ld	s2,0(sp)
    80002732:	6105                	addi	sp,sp,32
    80002734:	8082                	ret
    panic("brelse");
    80002736:	00006517          	auipc	a0,0x6
    8000273a:	c8a50513          	addi	a0,a0,-886 # 800083c0 <etext+0x3c0>
    8000273e:	00003097          	auipc	ra,0x3
    80002742:	7d4080e7          	jalr	2004(ra) # 80005f12 <panic>

0000000080002746 <bpin>:

void
bpin(struct buf *b) {
    80002746:	1101                	addi	sp,sp,-32
    80002748:	ec06                	sd	ra,24(sp)
    8000274a:	e822                	sd	s0,16(sp)
    8000274c:	e426                	sd	s1,8(sp)
    8000274e:	1000                	addi	s0,sp,32
    80002750:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002752:	0024c517          	auipc	a0,0x24c
    80002756:	77e50513          	addi	a0,a0,1918 # 8024eed0 <bcache>
    8000275a:	00004097          	auipc	ra,0x4
    8000275e:	d38080e7          	jalr	-712(ra) # 80006492 <acquire>
  b->refcnt++;
    80002762:	40bc                	lw	a5,64(s1)
    80002764:	2785                	addiw	a5,a5,1
    80002766:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002768:	0024c517          	auipc	a0,0x24c
    8000276c:	76850513          	addi	a0,a0,1896 # 8024eed0 <bcache>
    80002770:	00004097          	auipc	ra,0x4
    80002774:	dd2080e7          	jalr	-558(ra) # 80006542 <release>
}
    80002778:	60e2                	ld	ra,24(sp)
    8000277a:	6442                	ld	s0,16(sp)
    8000277c:	64a2                	ld	s1,8(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret

0000000080002782 <bunpin>:

void
bunpin(struct buf *b) {
    80002782:	1101                	addi	sp,sp,-32
    80002784:	ec06                	sd	ra,24(sp)
    80002786:	e822                	sd	s0,16(sp)
    80002788:	e426                	sd	s1,8(sp)
    8000278a:	1000                	addi	s0,sp,32
    8000278c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000278e:	0024c517          	auipc	a0,0x24c
    80002792:	74250513          	addi	a0,a0,1858 # 8024eed0 <bcache>
    80002796:	00004097          	auipc	ra,0x4
    8000279a:	cfc080e7          	jalr	-772(ra) # 80006492 <acquire>
  b->refcnt--;
    8000279e:	40bc                	lw	a5,64(s1)
    800027a0:	37fd                	addiw	a5,a5,-1
    800027a2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027a4:	0024c517          	auipc	a0,0x24c
    800027a8:	72c50513          	addi	a0,a0,1836 # 8024eed0 <bcache>
    800027ac:	00004097          	auipc	ra,0x4
    800027b0:	d96080e7          	jalr	-618(ra) # 80006542 <release>
}
    800027b4:	60e2                	ld	ra,24(sp)
    800027b6:	6442                	ld	s0,16(sp)
    800027b8:	64a2                	ld	s1,8(sp)
    800027ba:	6105                	addi	sp,sp,32
    800027bc:	8082                	ret

00000000800027be <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027be:	1101                	addi	sp,sp,-32
    800027c0:	ec06                	sd	ra,24(sp)
    800027c2:	e822                	sd	s0,16(sp)
    800027c4:	e426                	sd	s1,8(sp)
    800027c6:	e04a                	sd	s2,0(sp)
    800027c8:	1000                	addi	s0,sp,32
    800027ca:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027cc:	00d5d79b          	srliw	a5,a1,0xd
    800027d0:	00255597          	auipc	a1,0x255
    800027d4:	ddc5a583          	lw	a1,-548(a1) # 802575ac <sb+0x1c>
    800027d8:	9dbd                	addw	a1,a1,a5
    800027da:	00000097          	auipc	ra,0x0
    800027de:	da4080e7          	jalr	-604(ra) # 8000257e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027e2:	0074f713          	andi	a4,s1,7
    800027e6:	4785                	li	a5,1
    800027e8:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800027ec:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800027ee:	90d9                	srli	s1,s1,0x36
    800027f0:	00950733          	add	a4,a0,s1
    800027f4:	05874703          	lbu	a4,88(a4)
    800027f8:	00e7f6b3          	and	a3,a5,a4
    800027fc:	c69d                	beqz	a3,8000282a <bfree+0x6c>
    800027fe:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002800:	94aa                	add	s1,s1,a0
    80002802:	fff7c793          	not	a5,a5
    80002806:	8f7d                	and	a4,a4,a5
    80002808:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000280c:	00001097          	auipc	ra,0x1
    80002810:	11e080e7          	jalr	286(ra) # 8000392a <log_write>
  brelse(bp);
    80002814:	854a                	mv	a0,s2
    80002816:	00000097          	auipc	ra,0x0
    8000281a:	e98080e7          	jalr	-360(ra) # 800026ae <brelse>
}
    8000281e:	60e2                	ld	ra,24(sp)
    80002820:	6442                	ld	s0,16(sp)
    80002822:	64a2                	ld	s1,8(sp)
    80002824:	6902                	ld	s2,0(sp)
    80002826:	6105                	addi	sp,sp,32
    80002828:	8082                	ret
    panic("freeing free block");
    8000282a:	00006517          	auipc	a0,0x6
    8000282e:	b9e50513          	addi	a0,a0,-1122 # 800083c8 <etext+0x3c8>
    80002832:	00003097          	auipc	ra,0x3
    80002836:	6e0080e7          	jalr	1760(ra) # 80005f12 <panic>

000000008000283a <balloc>:
{
    8000283a:	715d                	addi	sp,sp,-80
    8000283c:	e486                	sd	ra,72(sp)
    8000283e:	e0a2                	sd	s0,64(sp)
    80002840:	fc26                	sd	s1,56(sp)
    80002842:	f84a                	sd	s2,48(sp)
    80002844:	f44e                	sd	s3,40(sp)
    80002846:	f052                	sd	s4,32(sp)
    80002848:	ec56                	sd	s5,24(sp)
    8000284a:	e85a                	sd	s6,16(sp)
    8000284c:	e45e                	sd	s7,8(sp)
    8000284e:	e062                	sd	s8,0(sp)
    80002850:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002852:	00255797          	auipc	a5,0x255
    80002856:	d427a783          	lw	a5,-702(a5) # 80257594 <sb+0x4>
    8000285a:	c7c1                	beqz	a5,800028e2 <balloc+0xa8>
    8000285c:	8baa                	mv	s7,a0
    8000285e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002860:	00255b17          	auipc	s6,0x255
    80002864:	d30b0b13          	addi	s6,s6,-720 # 80257590 <sb>
      m = 1 << (bi % 8);
    80002868:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000286a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000286c:	6c09                	lui	s8,0x2
    8000286e:	a821                	j	80002886 <balloc+0x4c>
    brelse(bp);
    80002870:	854a                	mv	a0,s2
    80002872:	00000097          	auipc	ra,0x0
    80002876:	e3c080e7          	jalr	-452(ra) # 800026ae <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000287a:	015c0abb          	addw	s5,s8,s5
    8000287e:	004b2783          	lw	a5,4(s6)
    80002882:	06faf063          	bgeu	s5,a5,800028e2 <balloc+0xa8>
    bp = bread(dev, BBLOCK(b, sb));
    80002886:	41fad79b          	sraiw	a5,s5,0x1f
    8000288a:	0137d79b          	srliw	a5,a5,0x13
    8000288e:	015787bb          	addw	a5,a5,s5
    80002892:	40d7d79b          	sraiw	a5,a5,0xd
    80002896:	01cb2583          	lw	a1,28(s6)
    8000289a:	9dbd                	addw	a1,a1,a5
    8000289c:	855e                	mv	a0,s7
    8000289e:	00000097          	auipc	ra,0x0
    800028a2:	ce0080e7          	jalr	-800(ra) # 8000257e <bread>
    800028a6:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028a8:	004b2503          	lw	a0,4(s6)
    800028ac:	84d6                	mv	s1,s5
    800028ae:	4701                	li	a4,0
    800028b0:	fca4f0e3          	bgeu	s1,a0,80002870 <balloc+0x36>
      m = 1 << (bi % 8);
    800028b4:	00777693          	andi	a3,a4,7
    800028b8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028bc:	41f7579b          	sraiw	a5,a4,0x1f
    800028c0:	01d7d79b          	srliw	a5,a5,0x1d
    800028c4:	9fb9                	addw	a5,a5,a4
    800028c6:	4037d79b          	sraiw	a5,a5,0x3
    800028ca:	00f90633          	add	a2,s2,a5
    800028ce:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800028d2:	00c6f5b3          	and	a1,a3,a2
    800028d6:	cd91                	beqz	a1,800028f2 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028d8:	2705                	addiw	a4,a4,1
    800028da:	2485                	addiw	s1,s1,1
    800028dc:	fd471ae3          	bne	a4,s4,800028b0 <balloc+0x76>
    800028e0:	bf41                	j	80002870 <balloc+0x36>
  panic("balloc: out of blocks");
    800028e2:	00006517          	auipc	a0,0x6
    800028e6:	afe50513          	addi	a0,a0,-1282 # 800083e0 <etext+0x3e0>
    800028ea:	00003097          	auipc	ra,0x3
    800028ee:	628080e7          	jalr	1576(ra) # 80005f12 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028f2:	97ca                	add	a5,a5,s2
    800028f4:	8e55                	or	a2,a2,a3
    800028f6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028fa:	854a                	mv	a0,s2
    800028fc:	00001097          	auipc	ra,0x1
    80002900:	02e080e7          	jalr	46(ra) # 8000392a <log_write>
        brelse(bp);
    80002904:	854a                	mv	a0,s2
    80002906:	00000097          	auipc	ra,0x0
    8000290a:	da8080e7          	jalr	-600(ra) # 800026ae <brelse>
  bp = bread(dev, bno);
    8000290e:	85a6                	mv	a1,s1
    80002910:	855e                	mv	a0,s7
    80002912:	00000097          	auipc	ra,0x0
    80002916:	c6c080e7          	jalr	-916(ra) # 8000257e <bread>
    8000291a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000291c:	40000613          	li	a2,1024
    80002920:	4581                	li	a1,0
    80002922:	05850513          	addi	a0,a0,88
    80002926:	ffffe097          	auipc	ra,0xffffe
    8000292a:	992080e7          	jalr	-1646(ra) # 800002b8 <memset>
  log_write(bp);
    8000292e:	854a                	mv	a0,s2
    80002930:	00001097          	auipc	ra,0x1
    80002934:	ffa080e7          	jalr	-6(ra) # 8000392a <log_write>
  brelse(bp);
    80002938:	854a                	mv	a0,s2
    8000293a:	00000097          	auipc	ra,0x0
    8000293e:	d74080e7          	jalr	-652(ra) # 800026ae <brelse>
}
    80002942:	8526                	mv	a0,s1
    80002944:	60a6                	ld	ra,72(sp)
    80002946:	6406                	ld	s0,64(sp)
    80002948:	74e2                	ld	s1,56(sp)
    8000294a:	7942                	ld	s2,48(sp)
    8000294c:	79a2                	ld	s3,40(sp)
    8000294e:	7a02                	ld	s4,32(sp)
    80002950:	6ae2                	ld	s5,24(sp)
    80002952:	6b42                	ld	s6,16(sp)
    80002954:	6ba2                	ld	s7,8(sp)
    80002956:	6c02                	ld	s8,0(sp)
    80002958:	6161                	addi	sp,sp,80
    8000295a:	8082                	ret

000000008000295c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000295c:	7179                	addi	sp,sp,-48
    8000295e:	f406                	sd	ra,40(sp)
    80002960:	f022                	sd	s0,32(sp)
    80002962:	ec26                	sd	s1,24(sp)
    80002964:	e84a                	sd	s2,16(sp)
    80002966:	e44e                	sd	s3,8(sp)
    80002968:	1800                	addi	s0,sp,48
    8000296a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000296c:	47ad                	li	a5,11
    8000296e:	04b7fd63          	bgeu	a5,a1,800029c8 <bmap+0x6c>
    80002972:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002974:	ff45849b          	addiw	s1,a1,-12

  if(bn < NINDIRECT){
    80002978:	0ff00793          	li	a5,255
    8000297c:	0897ef63          	bltu	a5,s1,80002a1a <bmap+0xbe>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002980:	08052583          	lw	a1,128(a0)
    80002984:	c5a5                	beqz	a1,800029ec <bmap+0x90>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002986:	00092503          	lw	a0,0(s2)
    8000298a:	00000097          	auipc	ra,0x0
    8000298e:	bf4080e7          	jalr	-1036(ra) # 8000257e <bread>
    80002992:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002994:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002998:	02049713          	slli	a4,s1,0x20
    8000299c:	01e75593          	srli	a1,a4,0x1e
    800029a0:	00b784b3          	add	s1,a5,a1
    800029a4:	0004a983          	lw	s3,0(s1)
    800029a8:	04098b63          	beqz	s3,800029fe <bmap+0xa2>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029ac:	8552                	mv	a0,s4
    800029ae:	00000097          	auipc	ra,0x0
    800029b2:	d00080e7          	jalr	-768(ra) # 800026ae <brelse>
    return addr;
    800029b6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800029b8:	854e                	mv	a0,s3
    800029ba:	70a2                	ld	ra,40(sp)
    800029bc:	7402                	ld	s0,32(sp)
    800029be:	64e2                	ld	s1,24(sp)
    800029c0:	6942                	ld	s2,16(sp)
    800029c2:	69a2                	ld	s3,8(sp)
    800029c4:	6145                	addi	sp,sp,48
    800029c6:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029c8:	02059793          	slli	a5,a1,0x20
    800029cc:	01e7d593          	srli	a1,a5,0x1e
    800029d0:	00b504b3          	add	s1,a0,a1
    800029d4:	0504a983          	lw	s3,80(s1)
    800029d8:	fe0990e3          	bnez	s3,800029b8 <bmap+0x5c>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029dc:	4108                	lw	a0,0(a0)
    800029de:	00000097          	auipc	ra,0x0
    800029e2:	e5c080e7          	jalr	-420(ra) # 8000283a <balloc>
    800029e6:	89aa                	mv	s3,a0
    800029e8:	c8a8                	sw	a0,80(s1)
    800029ea:	b7f9                	j	800029b8 <bmap+0x5c>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029ec:	4108                	lw	a0,0(a0)
    800029ee:	00000097          	auipc	ra,0x0
    800029f2:	e4c080e7          	jalr	-436(ra) # 8000283a <balloc>
    800029f6:	85aa                	mv	a1,a0
    800029f8:	08a92023          	sw	a0,128(s2)
    800029fc:	b769                	j	80002986 <bmap+0x2a>
      a[bn] = addr = balloc(ip->dev);
    800029fe:	00092503          	lw	a0,0(s2)
    80002a02:	00000097          	auipc	ra,0x0
    80002a06:	e38080e7          	jalr	-456(ra) # 8000283a <balloc>
    80002a0a:	89aa                	mv	s3,a0
    80002a0c:	c088                	sw	a0,0(s1)
      log_write(bp);
    80002a0e:	8552                	mv	a0,s4
    80002a10:	00001097          	auipc	ra,0x1
    80002a14:	f1a080e7          	jalr	-230(ra) # 8000392a <log_write>
    80002a18:	bf51                	j	800029ac <bmap+0x50>
  panic("bmap: out of range");
    80002a1a:	00006517          	auipc	a0,0x6
    80002a1e:	9de50513          	addi	a0,a0,-1570 # 800083f8 <etext+0x3f8>
    80002a22:	00003097          	auipc	ra,0x3
    80002a26:	4f0080e7          	jalr	1264(ra) # 80005f12 <panic>

0000000080002a2a <iget>:
{
    80002a2a:	7179                	addi	sp,sp,-48
    80002a2c:	f406                	sd	ra,40(sp)
    80002a2e:	f022                	sd	s0,32(sp)
    80002a30:	ec26                	sd	s1,24(sp)
    80002a32:	e84a                	sd	s2,16(sp)
    80002a34:	e44e                	sd	s3,8(sp)
    80002a36:	e052                	sd	s4,0(sp)
    80002a38:	1800                	addi	s0,sp,48
    80002a3a:	89aa                	mv	s3,a0
    80002a3c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a3e:	00255517          	auipc	a0,0x255
    80002a42:	b7250513          	addi	a0,a0,-1166 # 802575b0 <itable>
    80002a46:	00004097          	auipc	ra,0x4
    80002a4a:	a4c080e7          	jalr	-1460(ra) # 80006492 <acquire>
  empty = 0;
    80002a4e:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a50:	00255497          	auipc	s1,0x255
    80002a54:	b7848493          	addi	s1,s1,-1160 # 802575c8 <itable+0x18>
    80002a58:	00256697          	auipc	a3,0x256
    80002a5c:	60068693          	addi	a3,a3,1536 # 80259058 <log>
    80002a60:	a039                	j	80002a6e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a62:	02090b63          	beqz	s2,80002a98 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a66:	08848493          	addi	s1,s1,136
    80002a6a:	02d48a63          	beq	s1,a3,80002a9e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a6e:	449c                	lw	a5,8(s1)
    80002a70:	fef059e3          	blez	a5,80002a62 <iget+0x38>
    80002a74:	4098                	lw	a4,0(s1)
    80002a76:	ff3716e3          	bne	a4,s3,80002a62 <iget+0x38>
    80002a7a:	40d8                	lw	a4,4(s1)
    80002a7c:	ff4713e3          	bne	a4,s4,80002a62 <iget+0x38>
      ip->ref++;
    80002a80:	2785                	addiw	a5,a5,1
    80002a82:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a84:	00255517          	auipc	a0,0x255
    80002a88:	b2c50513          	addi	a0,a0,-1236 # 802575b0 <itable>
    80002a8c:	00004097          	auipc	ra,0x4
    80002a90:	ab6080e7          	jalr	-1354(ra) # 80006542 <release>
      return ip;
    80002a94:	8926                	mv	s2,s1
    80002a96:	a03d                	j	80002ac4 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a98:	f7f9                	bnez	a5,80002a66 <iget+0x3c>
      empty = ip;
    80002a9a:	8926                	mv	s2,s1
    80002a9c:	b7e9                	j	80002a66 <iget+0x3c>
  if(empty == 0)
    80002a9e:	02090c63          	beqz	s2,80002ad6 <iget+0xac>
  ip->dev = dev;
    80002aa2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002aa6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aaa:	4785                	li	a5,1
    80002aac:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002ab0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ab4:	00255517          	auipc	a0,0x255
    80002ab8:	afc50513          	addi	a0,a0,-1284 # 802575b0 <itable>
    80002abc:	00004097          	auipc	ra,0x4
    80002ac0:	a86080e7          	jalr	-1402(ra) # 80006542 <release>
}
    80002ac4:	854a                	mv	a0,s2
    80002ac6:	70a2                	ld	ra,40(sp)
    80002ac8:	7402                	ld	s0,32(sp)
    80002aca:	64e2                	ld	s1,24(sp)
    80002acc:	6942                	ld	s2,16(sp)
    80002ace:	69a2                	ld	s3,8(sp)
    80002ad0:	6a02                	ld	s4,0(sp)
    80002ad2:	6145                	addi	sp,sp,48
    80002ad4:	8082                	ret
    panic("iget: no inodes");
    80002ad6:	00006517          	auipc	a0,0x6
    80002ada:	93a50513          	addi	a0,a0,-1734 # 80008410 <etext+0x410>
    80002ade:	00003097          	auipc	ra,0x3
    80002ae2:	434080e7          	jalr	1076(ra) # 80005f12 <panic>

0000000080002ae6 <fsinit>:
fsinit(int dev) {
    80002ae6:	7179                	addi	sp,sp,-48
    80002ae8:	f406                	sd	ra,40(sp)
    80002aea:	f022                	sd	s0,32(sp)
    80002aec:	ec26                	sd	s1,24(sp)
    80002aee:	e84a                	sd	s2,16(sp)
    80002af0:	e44e                	sd	s3,8(sp)
    80002af2:	1800                	addi	s0,sp,48
    80002af4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002af6:	4585                	li	a1,1
    80002af8:	00000097          	auipc	ra,0x0
    80002afc:	a86080e7          	jalr	-1402(ra) # 8000257e <bread>
    80002b00:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b02:	00255997          	auipc	s3,0x255
    80002b06:	a8e98993          	addi	s3,s3,-1394 # 80257590 <sb>
    80002b0a:	02000613          	li	a2,32
    80002b0e:	05850593          	addi	a1,a0,88
    80002b12:	854e                	mv	a0,s3
    80002b14:	ffffe097          	auipc	ra,0xffffe
    80002b18:	808080e7          	jalr	-2040(ra) # 8000031c <memmove>
  brelse(bp);
    80002b1c:	8526                	mv	a0,s1
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	b90080e7          	jalr	-1136(ra) # 800026ae <brelse>
  if(sb.magic != FSMAGIC)
    80002b26:	0009a703          	lw	a4,0(s3)
    80002b2a:	102037b7          	lui	a5,0x10203
    80002b2e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b32:	02f71263          	bne	a4,a5,80002b56 <fsinit+0x70>
  initlog(dev, &sb);
    80002b36:	00255597          	auipc	a1,0x255
    80002b3a:	a5a58593          	addi	a1,a1,-1446 # 80257590 <sb>
    80002b3e:	854a                	mv	a0,s2
    80002b40:	00001097          	auipc	ra,0x1
    80002b44:	b74080e7          	jalr	-1164(ra) # 800036b4 <initlog>
}
    80002b48:	70a2                	ld	ra,40(sp)
    80002b4a:	7402                	ld	s0,32(sp)
    80002b4c:	64e2                	ld	s1,24(sp)
    80002b4e:	6942                	ld	s2,16(sp)
    80002b50:	69a2                	ld	s3,8(sp)
    80002b52:	6145                	addi	sp,sp,48
    80002b54:	8082                	ret
    panic("invalid file system");
    80002b56:	00006517          	auipc	a0,0x6
    80002b5a:	8ca50513          	addi	a0,a0,-1846 # 80008420 <etext+0x420>
    80002b5e:	00003097          	auipc	ra,0x3
    80002b62:	3b4080e7          	jalr	948(ra) # 80005f12 <panic>

0000000080002b66 <iinit>:
{
    80002b66:	7179                	addi	sp,sp,-48
    80002b68:	f406                	sd	ra,40(sp)
    80002b6a:	f022                	sd	s0,32(sp)
    80002b6c:	ec26                	sd	s1,24(sp)
    80002b6e:	e84a                	sd	s2,16(sp)
    80002b70:	e44e                	sd	s3,8(sp)
    80002b72:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b74:	00006597          	auipc	a1,0x6
    80002b78:	8c458593          	addi	a1,a1,-1852 # 80008438 <etext+0x438>
    80002b7c:	00255517          	auipc	a0,0x255
    80002b80:	a3450513          	addi	a0,a0,-1484 # 802575b0 <itable>
    80002b84:	00004097          	auipc	ra,0x4
    80002b88:	87a080e7          	jalr	-1926(ra) # 800063fe <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b8c:	00255497          	auipc	s1,0x255
    80002b90:	a4c48493          	addi	s1,s1,-1460 # 802575d8 <itable+0x28>
    80002b94:	00256997          	auipc	s3,0x256
    80002b98:	4d498993          	addi	s3,s3,1236 # 80259068 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b9c:	00006917          	auipc	s2,0x6
    80002ba0:	8a490913          	addi	s2,s2,-1884 # 80008440 <etext+0x440>
    80002ba4:	85ca                	mv	a1,s2
    80002ba6:	8526                	mv	a0,s1
    80002ba8:	00001097          	auipc	ra,0x1
    80002bac:	e66080e7          	jalr	-410(ra) # 80003a0e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bb0:	08848493          	addi	s1,s1,136
    80002bb4:	ff3498e3          	bne	s1,s3,80002ba4 <iinit+0x3e>
}
    80002bb8:	70a2                	ld	ra,40(sp)
    80002bba:	7402                	ld	s0,32(sp)
    80002bbc:	64e2                	ld	s1,24(sp)
    80002bbe:	6942                	ld	s2,16(sp)
    80002bc0:	69a2                	ld	s3,8(sp)
    80002bc2:	6145                	addi	sp,sp,48
    80002bc4:	8082                	ret

0000000080002bc6 <ialloc>:
{
    80002bc6:	7139                	addi	sp,sp,-64
    80002bc8:	fc06                	sd	ra,56(sp)
    80002bca:	f822                	sd	s0,48(sp)
    80002bcc:	f426                	sd	s1,40(sp)
    80002bce:	f04a                	sd	s2,32(sp)
    80002bd0:	ec4e                	sd	s3,24(sp)
    80002bd2:	e852                	sd	s4,16(sp)
    80002bd4:	e456                	sd	s5,8(sp)
    80002bd6:	e05a                	sd	s6,0(sp)
    80002bd8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bda:	00255717          	auipc	a4,0x255
    80002bde:	9c272703          	lw	a4,-1598(a4) # 8025759c <sb+0xc>
    80002be2:	4785                	li	a5,1
    80002be4:	04e7f863          	bgeu	a5,a4,80002c34 <ialloc+0x6e>
    80002be8:	8aaa                	mv	s5,a0
    80002bea:	8b2e                	mv	s6,a1
    80002bec:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002bee:	00255a17          	auipc	s4,0x255
    80002bf2:	9a2a0a13          	addi	s4,s4,-1630 # 80257590 <sb>
    80002bf6:	00495593          	srli	a1,s2,0x4
    80002bfa:	018a2783          	lw	a5,24(s4)
    80002bfe:	9dbd                	addw	a1,a1,a5
    80002c00:	8556                	mv	a0,s5
    80002c02:	00000097          	auipc	ra,0x0
    80002c06:	97c080e7          	jalr	-1668(ra) # 8000257e <bread>
    80002c0a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c0c:	05850993          	addi	s3,a0,88
    80002c10:	00f97793          	andi	a5,s2,15
    80002c14:	079a                	slli	a5,a5,0x6
    80002c16:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c18:	00099783          	lh	a5,0(s3)
    80002c1c:	c785                	beqz	a5,80002c44 <ialloc+0x7e>
    brelse(bp);
    80002c1e:	00000097          	auipc	ra,0x0
    80002c22:	a90080e7          	jalr	-1392(ra) # 800026ae <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c26:	0905                	addi	s2,s2,1
    80002c28:	00ca2703          	lw	a4,12(s4)
    80002c2c:	0009079b          	sext.w	a5,s2
    80002c30:	fce7e3e3          	bltu	a5,a4,80002bf6 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002c34:	00006517          	auipc	a0,0x6
    80002c38:	81450513          	addi	a0,a0,-2028 # 80008448 <etext+0x448>
    80002c3c:	00003097          	auipc	ra,0x3
    80002c40:	2d6080e7          	jalr	726(ra) # 80005f12 <panic>
      memset(dip, 0, sizeof(*dip));
    80002c44:	04000613          	li	a2,64
    80002c48:	4581                	li	a1,0
    80002c4a:	854e                	mv	a0,s3
    80002c4c:	ffffd097          	auipc	ra,0xffffd
    80002c50:	66c080e7          	jalr	1644(ra) # 800002b8 <memset>
      dip->type = type;
    80002c54:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c58:	8526                	mv	a0,s1
    80002c5a:	00001097          	auipc	ra,0x1
    80002c5e:	cd0080e7          	jalr	-816(ra) # 8000392a <log_write>
      brelse(bp);
    80002c62:	8526                	mv	a0,s1
    80002c64:	00000097          	auipc	ra,0x0
    80002c68:	a4a080e7          	jalr	-1462(ra) # 800026ae <brelse>
      return iget(dev, inum);
    80002c6c:	0009059b          	sext.w	a1,s2
    80002c70:	8556                	mv	a0,s5
    80002c72:	00000097          	auipc	ra,0x0
    80002c76:	db8080e7          	jalr	-584(ra) # 80002a2a <iget>
}
    80002c7a:	70e2                	ld	ra,56(sp)
    80002c7c:	7442                	ld	s0,48(sp)
    80002c7e:	74a2                	ld	s1,40(sp)
    80002c80:	7902                	ld	s2,32(sp)
    80002c82:	69e2                	ld	s3,24(sp)
    80002c84:	6a42                	ld	s4,16(sp)
    80002c86:	6aa2                	ld	s5,8(sp)
    80002c88:	6b02                	ld	s6,0(sp)
    80002c8a:	6121                	addi	sp,sp,64
    80002c8c:	8082                	ret

0000000080002c8e <iupdate>:
{
    80002c8e:	1101                	addi	sp,sp,-32
    80002c90:	ec06                	sd	ra,24(sp)
    80002c92:	e822                	sd	s0,16(sp)
    80002c94:	e426                	sd	s1,8(sp)
    80002c96:	e04a                	sd	s2,0(sp)
    80002c98:	1000                	addi	s0,sp,32
    80002c9a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c9c:	415c                	lw	a5,4(a0)
    80002c9e:	0047d79b          	srliw	a5,a5,0x4
    80002ca2:	00255597          	auipc	a1,0x255
    80002ca6:	9065a583          	lw	a1,-1786(a1) # 802575a8 <sb+0x18>
    80002caa:	9dbd                	addw	a1,a1,a5
    80002cac:	4108                	lw	a0,0(a0)
    80002cae:	00000097          	auipc	ra,0x0
    80002cb2:	8d0080e7          	jalr	-1840(ra) # 8000257e <bread>
    80002cb6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cb8:	05850793          	addi	a5,a0,88
    80002cbc:	40d8                	lw	a4,4(s1)
    80002cbe:	8b3d                	andi	a4,a4,15
    80002cc0:	071a                	slli	a4,a4,0x6
    80002cc2:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002cc4:	04449703          	lh	a4,68(s1)
    80002cc8:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002ccc:	04649703          	lh	a4,70(s1)
    80002cd0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002cd4:	04849703          	lh	a4,72(s1)
    80002cd8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cdc:	04a49703          	lh	a4,74(s1)
    80002ce0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002ce4:	44f8                	lw	a4,76(s1)
    80002ce6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ce8:	03400613          	li	a2,52
    80002cec:	05048593          	addi	a1,s1,80
    80002cf0:	00c78513          	addi	a0,a5,12
    80002cf4:	ffffd097          	auipc	ra,0xffffd
    80002cf8:	628080e7          	jalr	1576(ra) # 8000031c <memmove>
  log_write(bp);
    80002cfc:	854a                	mv	a0,s2
    80002cfe:	00001097          	auipc	ra,0x1
    80002d02:	c2c080e7          	jalr	-980(ra) # 8000392a <log_write>
  brelse(bp);
    80002d06:	854a                	mv	a0,s2
    80002d08:	00000097          	auipc	ra,0x0
    80002d0c:	9a6080e7          	jalr	-1626(ra) # 800026ae <brelse>
}
    80002d10:	60e2                	ld	ra,24(sp)
    80002d12:	6442                	ld	s0,16(sp)
    80002d14:	64a2                	ld	s1,8(sp)
    80002d16:	6902                	ld	s2,0(sp)
    80002d18:	6105                	addi	sp,sp,32
    80002d1a:	8082                	ret

0000000080002d1c <idup>:
{
    80002d1c:	1101                	addi	sp,sp,-32
    80002d1e:	ec06                	sd	ra,24(sp)
    80002d20:	e822                	sd	s0,16(sp)
    80002d22:	e426                	sd	s1,8(sp)
    80002d24:	1000                	addi	s0,sp,32
    80002d26:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d28:	00255517          	auipc	a0,0x255
    80002d2c:	88850513          	addi	a0,a0,-1912 # 802575b0 <itable>
    80002d30:	00003097          	auipc	ra,0x3
    80002d34:	762080e7          	jalr	1890(ra) # 80006492 <acquire>
  ip->ref++;
    80002d38:	449c                	lw	a5,8(s1)
    80002d3a:	2785                	addiw	a5,a5,1
    80002d3c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d3e:	00255517          	auipc	a0,0x255
    80002d42:	87250513          	addi	a0,a0,-1934 # 802575b0 <itable>
    80002d46:	00003097          	auipc	ra,0x3
    80002d4a:	7fc080e7          	jalr	2044(ra) # 80006542 <release>
}
    80002d4e:	8526                	mv	a0,s1
    80002d50:	60e2                	ld	ra,24(sp)
    80002d52:	6442                	ld	s0,16(sp)
    80002d54:	64a2                	ld	s1,8(sp)
    80002d56:	6105                	addi	sp,sp,32
    80002d58:	8082                	ret

0000000080002d5a <ilock>:
{
    80002d5a:	1101                	addi	sp,sp,-32
    80002d5c:	ec06                	sd	ra,24(sp)
    80002d5e:	e822                	sd	s0,16(sp)
    80002d60:	e426                	sd	s1,8(sp)
    80002d62:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d64:	c10d                	beqz	a0,80002d86 <ilock+0x2c>
    80002d66:	84aa                	mv	s1,a0
    80002d68:	451c                	lw	a5,8(a0)
    80002d6a:	00f05e63          	blez	a5,80002d86 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d6e:	0541                	addi	a0,a0,16
    80002d70:	00001097          	auipc	ra,0x1
    80002d74:	cd8080e7          	jalr	-808(ra) # 80003a48 <acquiresleep>
  if(ip->valid == 0){
    80002d78:	40bc                	lw	a5,64(s1)
    80002d7a:	cf99                	beqz	a5,80002d98 <ilock+0x3e>
}
    80002d7c:	60e2                	ld	ra,24(sp)
    80002d7e:	6442                	ld	s0,16(sp)
    80002d80:	64a2                	ld	s1,8(sp)
    80002d82:	6105                	addi	sp,sp,32
    80002d84:	8082                	ret
    80002d86:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002d88:	00005517          	auipc	a0,0x5
    80002d8c:	6d850513          	addi	a0,a0,1752 # 80008460 <etext+0x460>
    80002d90:	00003097          	auipc	ra,0x3
    80002d94:	182080e7          	jalr	386(ra) # 80005f12 <panic>
    80002d98:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d9a:	40dc                	lw	a5,4(s1)
    80002d9c:	0047d79b          	srliw	a5,a5,0x4
    80002da0:	00255597          	auipc	a1,0x255
    80002da4:	8085a583          	lw	a1,-2040(a1) # 802575a8 <sb+0x18>
    80002da8:	9dbd                	addw	a1,a1,a5
    80002daa:	4088                	lw	a0,0(s1)
    80002dac:	fffff097          	auipc	ra,0xfffff
    80002db0:	7d2080e7          	jalr	2002(ra) # 8000257e <bread>
    80002db4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002db6:	05850593          	addi	a1,a0,88
    80002dba:	40dc                	lw	a5,4(s1)
    80002dbc:	8bbd                	andi	a5,a5,15
    80002dbe:	079a                	slli	a5,a5,0x6
    80002dc0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dc2:	00059783          	lh	a5,0(a1)
    80002dc6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dca:	00259783          	lh	a5,2(a1)
    80002dce:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002dd2:	00459783          	lh	a5,4(a1)
    80002dd6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dda:	00659783          	lh	a5,6(a1)
    80002dde:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002de2:	459c                	lw	a5,8(a1)
    80002de4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002de6:	03400613          	li	a2,52
    80002dea:	05b1                	addi	a1,a1,12
    80002dec:	05048513          	addi	a0,s1,80
    80002df0:	ffffd097          	auipc	ra,0xffffd
    80002df4:	52c080e7          	jalr	1324(ra) # 8000031c <memmove>
    brelse(bp);
    80002df8:	854a                	mv	a0,s2
    80002dfa:	00000097          	auipc	ra,0x0
    80002dfe:	8b4080e7          	jalr	-1868(ra) # 800026ae <brelse>
    ip->valid = 1;
    80002e02:	4785                	li	a5,1
    80002e04:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e06:	04449783          	lh	a5,68(s1)
    80002e0a:	c399                	beqz	a5,80002e10 <ilock+0xb6>
    80002e0c:	6902                	ld	s2,0(sp)
    80002e0e:	b7bd                	j	80002d7c <ilock+0x22>
      panic("ilock: no type");
    80002e10:	00005517          	auipc	a0,0x5
    80002e14:	65850513          	addi	a0,a0,1624 # 80008468 <etext+0x468>
    80002e18:	00003097          	auipc	ra,0x3
    80002e1c:	0fa080e7          	jalr	250(ra) # 80005f12 <panic>

0000000080002e20 <iunlock>:
{
    80002e20:	1101                	addi	sp,sp,-32
    80002e22:	ec06                	sd	ra,24(sp)
    80002e24:	e822                	sd	s0,16(sp)
    80002e26:	e426                	sd	s1,8(sp)
    80002e28:	e04a                	sd	s2,0(sp)
    80002e2a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e2c:	c905                	beqz	a0,80002e5c <iunlock+0x3c>
    80002e2e:	84aa                	mv	s1,a0
    80002e30:	01050913          	addi	s2,a0,16
    80002e34:	854a                	mv	a0,s2
    80002e36:	00001097          	auipc	ra,0x1
    80002e3a:	cac080e7          	jalr	-852(ra) # 80003ae2 <holdingsleep>
    80002e3e:	cd19                	beqz	a0,80002e5c <iunlock+0x3c>
    80002e40:	449c                	lw	a5,8(s1)
    80002e42:	00f05d63          	blez	a5,80002e5c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e46:	854a                	mv	a0,s2
    80002e48:	00001097          	auipc	ra,0x1
    80002e4c:	c56080e7          	jalr	-938(ra) # 80003a9e <releasesleep>
}
    80002e50:	60e2                	ld	ra,24(sp)
    80002e52:	6442                	ld	s0,16(sp)
    80002e54:	64a2                	ld	s1,8(sp)
    80002e56:	6902                	ld	s2,0(sp)
    80002e58:	6105                	addi	sp,sp,32
    80002e5a:	8082                	ret
    panic("iunlock");
    80002e5c:	00005517          	auipc	a0,0x5
    80002e60:	61c50513          	addi	a0,a0,1564 # 80008478 <etext+0x478>
    80002e64:	00003097          	auipc	ra,0x3
    80002e68:	0ae080e7          	jalr	174(ra) # 80005f12 <panic>

0000000080002e6c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e6c:	7179                	addi	sp,sp,-48
    80002e6e:	f406                	sd	ra,40(sp)
    80002e70:	f022                	sd	s0,32(sp)
    80002e72:	ec26                	sd	s1,24(sp)
    80002e74:	e84a                	sd	s2,16(sp)
    80002e76:	e44e                	sd	s3,8(sp)
    80002e78:	1800                	addi	s0,sp,48
    80002e7a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e7c:	05050493          	addi	s1,a0,80
    80002e80:	08050913          	addi	s2,a0,128
    80002e84:	a021                	j	80002e8c <itrunc+0x20>
    80002e86:	0491                	addi	s1,s1,4
    80002e88:	01248d63          	beq	s1,s2,80002ea2 <itrunc+0x36>
    if(ip->addrs[i]){
    80002e8c:	408c                	lw	a1,0(s1)
    80002e8e:	dde5                	beqz	a1,80002e86 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e90:	0009a503          	lw	a0,0(s3)
    80002e94:	00000097          	auipc	ra,0x0
    80002e98:	92a080e7          	jalr	-1750(ra) # 800027be <bfree>
      ip->addrs[i] = 0;
    80002e9c:	0004a023          	sw	zero,0(s1)
    80002ea0:	b7dd                	j	80002e86 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002ea2:	0809a583          	lw	a1,128(s3)
    80002ea6:	ed99                	bnez	a1,80002ec4 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ea8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002eac:	854e                	mv	a0,s3
    80002eae:	00000097          	auipc	ra,0x0
    80002eb2:	de0080e7          	jalr	-544(ra) # 80002c8e <iupdate>
}
    80002eb6:	70a2                	ld	ra,40(sp)
    80002eb8:	7402                	ld	s0,32(sp)
    80002eba:	64e2                	ld	s1,24(sp)
    80002ebc:	6942                	ld	s2,16(sp)
    80002ebe:	69a2                	ld	s3,8(sp)
    80002ec0:	6145                	addi	sp,sp,48
    80002ec2:	8082                	ret
    80002ec4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ec6:	0009a503          	lw	a0,0(s3)
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	6b4080e7          	jalr	1716(ra) # 8000257e <bread>
    80002ed2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ed4:	05850493          	addi	s1,a0,88
    80002ed8:	45850913          	addi	s2,a0,1112
    80002edc:	a021                	j	80002ee4 <itrunc+0x78>
    80002ede:	0491                	addi	s1,s1,4
    80002ee0:	01248b63          	beq	s1,s2,80002ef6 <itrunc+0x8a>
      if(a[j])
    80002ee4:	408c                	lw	a1,0(s1)
    80002ee6:	dde5                	beqz	a1,80002ede <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002ee8:	0009a503          	lw	a0,0(s3)
    80002eec:	00000097          	auipc	ra,0x0
    80002ef0:	8d2080e7          	jalr	-1838(ra) # 800027be <bfree>
    80002ef4:	b7ed                	j	80002ede <itrunc+0x72>
    brelse(bp);
    80002ef6:	8552                	mv	a0,s4
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	7b6080e7          	jalr	1974(ra) # 800026ae <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f00:	0809a583          	lw	a1,128(s3)
    80002f04:	0009a503          	lw	a0,0(s3)
    80002f08:	00000097          	auipc	ra,0x0
    80002f0c:	8b6080e7          	jalr	-1866(ra) # 800027be <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f10:	0809a023          	sw	zero,128(s3)
    80002f14:	6a02                	ld	s4,0(sp)
    80002f16:	bf49                	j	80002ea8 <itrunc+0x3c>

0000000080002f18 <iput>:
{
    80002f18:	1101                	addi	sp,sp,-32
    80002f1a:	ec06                	sd	ra,24(sp)
    80002f1c:	e822                	sd	s0,16(sp)
    80002f1e:	e426                	sd	s1,8(sp)
    80002f20:	1000                	addi	s0,sp,32
    80002f22:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f24:	00254517          	auipc	a0,0x254
    80002f28:	68c50513          	addi	a0,a0,1676 # 802575b0 <itable>
    80002f2c:	00003097          	auipc	ra,0x3
    80002f30:	566080e7          	jalr	1382(ra) # 80006492 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f34:	4498                	lw	a4,8(s1)
    80002f36:	4785                	li	a5,1
    80002f38:	02f70263          	beq	a4,a5,80002f5c <iput+0x44>
  ip->ref--;
    80002f3c:	449c                	lw	a5,8(s1)
    80002f3e:	37fd                	addiw	a5,a5,-1
    80002f40:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f42:	00254517          	auipc	a0,0x254
    80002f46:	66e50513          	addi	a0,a0,1646 # 802575b0 <itable>
    80002f4a:	00003097          	auipc	ra,0x3
    80002f4e:	5f8080e7          	jalr	1528(ra) # 80006542 <release>
}
    80002f52:	60e2                	ld	ra,24(sp)
    80002f54:	6442                	ld	s0,16(sp)
    80002f56:	64a2                	ld	s1,8(sp)
    80002f58:	6105                	addi	sp,sp,32
    80002f5a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f5c:	40bc                	lw	a5,64(s1)
    80002f5e:	dff9                	beqz	a5,80002f3c <iput+0x24>
    80002f60:	04a49783          	lh	a5,74(s1)
    80002f64:	ffe1                	bnez	a5,80002f3c <iput+0x24>
    80002f66:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f68:	01048913          	addi	s2,s1,16
    80002f6c:	854a                	mv	a0,s2
    80002f6e:	00001097          	auipc	ra,0x1
    80002f72:	ada080e7          	jalr	-1318(ra) # 80003a48 <acquiresleep>
    release(&itable.lock);
    80002f76:	00254517          	auipc	a0,0x254
    80002f7a:	63a50513          	addi	a0,a0,1594 # 802575b0 <itable>
    80002f7e:	00003097          	auipc	ra,0x3
    80002f82:	5c4080e7          	jalr	1476(ra) # 80006542 <release>
    itrunc(ip);
    80002f86:	8526                	mv	a0,s1
    80002f88:	00000097          	auipc	ra,0x0
    80002f8c:	ee4080e7          	jalr	-284(ra) # 80002e6c <itrunc>
    ip->type = 0;
    80002f90:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f94:	8526                	mv	a0,s1
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	cf8080e7          	jalr	-776(ra) # 80002c8e <iupdate>
    ip->valid = 0;
    80002f9e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fa2:	854a                	mv	a0,s2
    80002fa4:	00001097          	auipc	ra,0x1
    80002fa8:	afa080e7          	jalr	-1286(ra) # 80003a9e <releasesleep>
    acquire(&itable.lock);
    80002fac:	00254517          	auipc	a0,0x254
    80002fb0:	60450513          	addi	a0,a0,1540 # 802575b0 <itable>
    80002fb4:	00003097          	auipc	ra,0x3
    80002fb8:	4de080e7          	jalr	1246(ra) # 80006492 <acquire>
    80002fbc:	6902                	ld	s2,0(sp)
    80002fbe:	bfbd                	j	80002f3c <iput+0x24>

0000000080002fc0 <iunlockput>:
{
    80002fc0:	1101                	addi	sp,sp,-32
    80002fc2:	ec06                	sd	ra,24(sp)
    80002fc4:	e822                	sd	s0,16(sp)
    80002fc6:	e426                	sd	s1,8(sp)
    80002fc8:	1000                	addi	s0,sp,32
    80002fca:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fcc:	00000097          	auipc	ra,0x0
    80002fd0:	e54080e7          	jalr	-428(ra) # 80002e20 <iunlock>
  iput(ip);
    80002fd4:	8526                	mv	a0,s1
    80002fd6:	00000097          	auipc	ra,0x0
    80002fda:	f42080e7          	jalr	-190(ra) # 80002f18 <iput>
}
    80002fde:	60e2                	ld	ra,24(sp)
    80002fe0:	6442                	ld	s0,16(sp)
    80002fe2:	64a2                	ld	s1,8(sp)
    80002fe4:	6105                	addi	sp,sp,32
    80002fe6:	8082                	ret

0000000080002fe8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fe8:	1141                	addi	sp,sp,-16
    80002fea:	e406                	sd	ra,8(sp)
    80002fec:	e022                	sd	s0,0(sp)
    80002fee:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ff0:	411c                	lw	a5,0(a0)
    80002ff2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ff4:	415c                	lw	a5,4(a0)
    80002ff6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ff8:	04451783          	lh	a5,68(a0)
    80002ffc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003000:	04a51783          	lh	a5,74(a0)
    80003004:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003008:	04c56783          	lwu	a5,76(a0)
    8000300c:	e99c                	sd	a5,16(a1)
}
    8000300e:	60a2                	ld	ra,8(sp)
    80003010:	6402                	ld	s0,0(sp)
    80003012:	0141                	addi	sp,sp,16
    80003014:	8082                	ret

0000000080003016 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003016:	457c                	lw	a5,76(a0)
    80003018:	0ed7ea63          	bltu	a5,a3,8000310c <readi+0xf6>
{
    8000301c:	7159                	addi	sp,sp,-112
    8000301e:	f486                	sd	ra,104(sp)
    80003020:	f0a2                	sd	s0,96(sp)
    80003022:	eca6                	sd	s1,88(sp)
    80003024:	fc56                	sd	s5,56(sp)
    80003026:	f85a                	sd	s6,48(sp)
    80003028:	f45e                	sd	s7,40(sp)
    8000302a:	ec66                	sd	s9,24(sp)
    8000302c:	1880                	addi	s0,sp,112
    8000302e:	8baa                	mv	s7,a0
    80003030:	8cae                	mv	s9,a1
    80003032:	8ab2                	mv	s5,a2
    80003034:	84b6                	mv	s1,a3
    80003036:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003038:	9f35                	addw	a4,a4,a3
    return 0;
    8000303a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000303c:	0ad76763          	bltu	a4,a3,800030ea <readi+0xd4>
    80003040:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003042:	00e7f463          	bgeu	a5,a4,8000304a <readi+0x34>
    n = ip->size - off;
    80003046:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000304a:	0a0b0f63          	beqz	s6,80003108 <readi+0xf2>
    8000304e:	e8ca                	sd	s2,80(sp)
    80003050:	e0d2                	sd	s4,64(sp)
    80003052:	f062                	sd	s8,32(sp)
    80003054:	e86a                	sd	s10,16(sp)
    80003056:	e46e                	sd	s11,8(sp)
    80003058:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    8000305a:	40000d93          	li	s11,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000305e:	5d7d                	li	s10,-1
    80003060:	a82d                	j	8000309a <readi+0x84>
    80003062:	020a1c13          	slli	s8,s4,0x20
    80003066:	020c5c13          	srli	s8,s8,0x20
    8000306a:	05890613          	addi	a2,s2,88
    8000306e:	86e2                	mv	a3,s8
    80003070:	963e                	add	a2,a2,a5
    80003072:	85d6                	mv	a1,s5
    80003074:	8566                	mv	a0,s9
    80003076:	fffff097          	auipc	ra,0xfffff
    8000307a:	a84080e7          	jalr	-1404(ra) # 80001afa <either_copyout>
    8000307e:	05a50963          	beq	a0,s10,800030d0 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003082:	854a                	mv	a0,s2
    80003084:	fffff097          	auipc	ra,0xfffff
    80003088:	62a080e7          	jalr	1578(ra) # 800026ae <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000308c:	013a09bb          	addw	s3,s4,s3
    80003090:	009a04bb          	addw	s1,s4,s1
    80003094:	9ae2                	add	s5,s5,s8
    80003096:	0769f363          	bgeu	s3,s6,800030fc <readi+0xe6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000309a:	000ba903          	lw	s2,0(s7)
    8000309e:	00a4d59b          	srliw	a1,s1,0xa
    800030a2:	855e                	mv	a0,s7
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	8b8080e7          	jalr	-1864(ra) # 8000295c <bmap>
    800030ac:	85aa                	mv	a1,a0
    800030ae:	854a                	mv	a0,s2
    800030b0:	fffff097          	auipc	ra,0xfffff
    800030b4:	4ce080e7          	jalr	1230(ra) # 8000257e <bread>
    800030b8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ba:	3ff4f793          	andi	a5,s1,1023
    800030be:	40fd873b          	subw	a4,s11,a5
    800030c2:	413b06bb          	subw	a3,s6,s3
    800030c6:	8a3a                	mv	s4,a4
    800030c8:	f8e6fde3          	bgeu	a3,a4,80003062 <readi+0x4c>
    800030cc:	8a36                	mv	s4,a3
    800030ce:	bf51                	j	80003062 <readi+0x4c>
      brelse(bp);
    800030d0:	854a                	mv	a0,s2
    800030d2:	fffff097          	auipc	ra,0xfffff
    800030d6:	5dc080e7          	jalr	1500(ra) # 800026ae <brelse>
      tot = -1;
    800030da:	59fd                	li	s3,-1
      break;
    800030dc:	6946                	ld	s2,80(sp)
    800030de:	6a06                	ld	s4,64(sp)
    800030e0:	7c02                	ld	s8,32(sp)
    800030e2:	6d42                	ld	s10,16(sp)
    800030e4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800030e6:	854e                	mv	a0,s3
    800030e8:	69a6                	ld	s3,72(sp)
}
    800030ea:	70a6                	ld	ra,104(sp)
    800030ec:	7406                	ld	s0,96(sp)
    800030ee:	64e6                	ld	s1,88(sp)
    800030f0:	7ae2                	ld	s5,56(sp)
    800030f2:	7b42                	ld	s6,48(sp)
    800030f4:	7ba2                	ld	s7,40(sp)
    800030f6:	6ce2                	ld	s9,24(sp)
    800030f8:	6165                	addi	sp,sp,112
    800030fa:	8082                	ret
    800030fc:	6946                	ld	s2,80(sp)
    800030fe:	6a06                	ld	s4,64(sp)
    80003100:	7c02                	ld	s8,32(sp)
    80003102:	6d42                	ld	s10,16(sp)
    80003104:	6da2                	ld	s11,8(sp)
    80003106:	b7c5                	j	800030e6 <readi+0xd0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003108:	89da                	mv	s3,s6
    8000310a:	bff1                	j	800030e6 <readi+0xd0>
    return 0;
    8000310c:	4501                	li	a0,0
}
    8000310e:	8082                	ret

0000000080003110 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003110:	457c                	lw	a5,76(a0)
    80003112:	10d7e963          	bltu	a5,a3,80003224 <writei+0x114>
{
    80003116:	7159                	addi	sp,sp,-112
    80003118:	f486                	sd	ra,104(sp)
    8000311a:	f0a2                	sd	s0,96(sp)
    8000311c:	e8ca                	sd	s2,80(sp)
    8000311e:	fc56                	sd	s5,56(sp)
    80003120:	f45e                	sd	s7,40(sp)
    80003122:	f062                	sd	s8,32(sp)
    80003124:	ec66                	sd	s9,24(sp)
    80003126:	1880                	addi	s0,sp,112
    80003128:	8baa                	mv	s7,a0
    8000312a:	8cae                	mv	s9,a1
    8000312c:	8ab2                	mv	s5,a2
    8000312e:	8936                	mv	s2,a3
    80003130:	8c3a                	mv	s8,a4
  if(off > ip->size || off + n < off)
    80003132:	00e687bb          	addw	a5,a3,a4
    80003136:	0ed7e963          	bltu	a5,a3,80003228 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000313a:	00043737          	lui	a4,0x43
    8000313e:	0ef76763          	bltu	a4,a5,8000322c <writei+0x11c>
    80003142:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003144:	0c0c0863          	beqz	s8,80003214 <writei+0x104>
    80003148:	eca6                	sd	s1,88(sp)
    8000314a:	e4ce                	sd	s3,72(sp)
    8000314c:	f85a                	sd	s6,48(sp)
    8000314e:	e86a                	sd	s10,16(sp)
    80003150:	e46e                	sd	s11,8(sp)
    80003152:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003154:	40000d93          	li	s11,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003158:	5d7d                	li	s10,-1
    8000315a:	a091                	j	8000319e <writei+0x8e>
    8000315c:	02099b13          	slli	s6,s3,0x20
    80003160:	020b5b13          	srli	s6,s6,0x20
    80003164:	05848513          	addi	a0,s1,88
    80003168:	86da                	mv	a3,s6
    8000316a:	8656                	mv	a2,s5
    8000316c:	85e6                	mv	a1,s9
    8000316e:	953e                	add	a0,a0,a5
    80003170:	fffff097          	auipc	ra,0xfffff
    80003174:	9e0080e7          	jalr	-1568(ra) # 80001b50 <either_copyin>
    80003178:	05a50e63          	beq	a0,s10,800031d4 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000317c:	8526                	mv	a0,s1
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	7ac080e7          	jalr	1964(ra) # 8000392a <log_write>
    brelse(bp);
    80003186:	8526                	mv	a0,s1
    80003188:	fffff097          	auipc	ra,0xfffff
    8000318c:	526080e7          	jalr	1318(ra) # 800026ae <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003190:	01498a3b          	addw	s4,s3,s4
    80003194:	0129893b          	addw	s2,s3,s2
    80003198:	9ada                	add	s5,s5,s6
    8000319a:	058a7263          	bgeu	s4,s8,800031de <writei+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    8000319e:	000ba483          	lw	s1,0(s7)
    800031a2:	00a9559b          	srliw	a1,s2,0xa
    800031a6:	855e                	mv	a0,s7
    800031a8:	fffff097          	auipc	ra,0xfffff
    800031ac:	7b4080e7          	jalr	1972(ra) # 8000295c <bmap>
    800031b0:	85aa                	mv	a1,a0
    800031b2:	8526                	mv	a0,s1
    800031b4:	fffff097          	auipc	ra,0xfffff
    800031b8:	3ca080e7          	jalr	970(ra) # 8000257e <bread>
    800031bc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031be:	3ff97793          	andi	a5,s2,1023
    800031c2:	40fd873b          	subw	a4,s11,a5
    800031c6:	414c06bb          	subw	a3,s8,s4
    800031ca:	89ba                	mv	s3,a4
    800031cc:	f8e6f8e3          	bgeu	a3,a4,8000315c <writei+0x4c>
    800031d0:	89b6                	mv	s3,a3
    800031d2:	b769                	j	8000315c <writei+0x4c>
      brelse(bp);
    800031d4:	8526                	mv	a0,s1
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	4d8080e7          	jalr	1240(ra) # 800026ae <brelse>
  }

  if(off > ip->size)
    800031de:	04cba783          	lw	a5,76(s7)
    800031e2:	0327fb63          	bgeu	a5,s2,80003218 <writei+0x108>
    ip->size = off;
    800031e6:	052ba623          	sw	s2,76(s7)
    800031ea:	64e6                	ld	s1,88(sp)
    800031ec:	69a6                	ld	s3,72(sp)
    800031ee:	7b42                	ld	s6,48(sp)
    800031f0:	6d42                	ld	s10,16(sp)
    800031f2:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031f4:	855e                	mv	a0,s7
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	a98080e7          	jalr	-1384(ra) # 80002c8e <iupdate>

  return tot;
    800031fe:	8552                	mv	a0,s4
    80003200:	6a06                	ld	s4,64(sp)
}
    80003202:	70a6                	ld	ra,104(sp)
    80003204:	7406                	ld	s0,96(sp)
    80003206:	6946                	ld	s2,80(sp)
    80003208:	7ae2                	ld	s5,56(sp)
    8000320a:	7ba2                	ld	s7,40(sp)
    8000320c:	7c02                	ld	s8,32(sp)
    8000320e:	6ce2                	ld	s9,24(sp)
    80003210:	6165                	addi	sp,sp,112
    80003212:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003214:	8a62                	mv	s4,s8
    80003216:	bff9                	j	800031f4 <writei+0xe4>
    80003218:	64e6                	ld	s1,88(sp)
    8000321a:	69a6                	ld	s3,72(sp)
    8000321c:	7b42                	ld	s6,48(sp)
    8000321e:	6d42                	ld	s10,16(sp)
    80003220:	6da2                	ld	s11,8(sp)
    80003222:	bfc9                	j	800031f4 <writei+0xe4>
    return -1;
    80003224:	557d                	li	a0,-1
}
    80003226:	8082                	ret
    return -1;
    80003228:	557d                	li	a0,-1
    8000322a:	bfe1                	j	80003202 <writei+0xf2>
    return -1;
    8000322c:	557d                	li	a0,-1
    8000322e:	bfd1                	j	80003202 <writei+0xf2>

0000000080003230 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003230:	1141                	addi	sp,sp,-16
    80003232:	e406                	sd	ra,8(sp)
    80003234:	e022                	sd	s0,0(sp)
    80003236:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003238:	4639                	li	a2,14
    8000323a:	ffffd097          	auipc	ra,0xffffd
    8000323e:	15a080e7          	jalr	346(ra) # 80000394 <strncmp>
}
    80003242:	60a2                	ld	ra,8(sp)
    80003244:	6402                	ld	s0,0(sp)
    80003246:	0141                	addi	sp,sp,16
    80003248:	8082                	ret

000000008000324a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000324a:	711d                	addi	sp,sp,-96
    8000324c:	ec86                	sd	ra,88(sp)
    8000324e:	e8a2                	sd	s0,80(sp)
    80003250:	e4a6                	sd	s1,72(sp)
    80003252:	e0ca                	sd	s2,64(sp)
    80003254:	fc4e                	sd	s3,56(sp)
    80003256:	f852                	sd	s4,48(sp)
    80003258:	f456                	sd	s5,40(sp)
    8000325a:	f05a                	sd	s6,32(sp)
    8000325c:	ec5e                	sd	s7,24(sp)
    8000325e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003260:	04451703          	lh	a4,68(a0)
    80003264:	4785                	li	a5,1
    80003266:	00f71f63          	bne	a4,a5,80003284 <dirlookup+0x3a>
    8000326a:	892a                	mv	s2,a0
    8000326c:	8aae                	mv	s5,a1
    8000326e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003270:	457c                	lw	a5,76(a0)
    80003272:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003274:	fa040a13          	addi	s4,s0,-96
    80003278:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000327a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000327e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003280:	e79d                	bnez	a5,800032ae <dirlookup+0x64>
    80003282:	a88d                	j	800032f4 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80003284:	00005517          	auipc	a0,0x5
    80003288:	1fc50513          	addi	a0,a0,508 # 80008480 <etext+0x480>
    8000328c:	00003097          	auipc	ra,0x3
    80003290:	c86080e7          	jalr	-890(ra) # 80005f12 <panic>
      panic("dirlookup read");
    80003294:	00005517          	auipc	a0,0x5
    80003298:	20450513          	addi	a0,a0,516 # 80008498 <etext+0x498>
    8000329c:	00003097          	auipc	ra,0x3
    800032a0:	c76080e7          	jalr	-906(ra) # 80005f12 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a4:	24c1                	addiw	s1,s1,16
    800032a6:	04c92783          	lw	a5,76(s2)
    800032aa:	04f4f463          	bgeu	s1,a5,800032f2 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032ae:	874e                	mv	a4,s3
    800032b0:	86a6                	mv	a3,s1
    800032b2:	8652                	mv	a2,s4
    800032b4:	4581                	li	a1,0
    800032b6:	854a                	mv	a0,s2
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	d5e080e7          	jalr	-674(ra) # 80003016 <readi>
    800032c0:	fd351ae3          	bne	a0,s3,80003294 <dirlookup+0x4a>
    if(de.inum == 0)
    800032c4:	fa045783          	lhu	a5,-96(s0)
    800032c8:	dff1                	beqz	a5,800032a4 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    800032ca:	85da                	mv	a1,s6
    800032cc:	8556                	mv	a0,s5
    800032ce:	00000097          	auipc	ra,0x0
    800032d2:	f62080e7          	jalr	-158(ra) # 80003230 <namecmp>
    800032d6:	f579                	bnez	a0,800032a4 <dirlookup+0x5a>
      if(poff)
    800032d8:	000b8463          	beqz	s7,800032e0 <dirlookup+0x96>
        *poff = off;
    800032dc:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800032e0:	fa045583          	lhu	a1,-96(s0)
    800032e4:	00092503          	lw	a0,0(s2)
    800032e8:	fffff097          	auipc	ra,0xfffff
    800032ec:	742080e7          	jalr	1858(ra) # 80002a2a <iget>
    800032f0:	a011                	j	800032f4 <dirlookup+0xaa>
  return 0;
    800032f2:	4501                	li	a0,0
}
    800032f4:	60e6                	ld	ra,88(sp)
    800032f6:	6446                	ld	s0,80(sp)
    800032f8:	64a6                	ld	s1,72(sp)
    800032fa:	6906                	ld	s2,64(sp)
    800032fc:	79e2                	ld	s3,56(sp)
    800032fe:	7a42                	ld	s4,48(sp)
    80003300:	7aa2                	ld	s5,40(sp)
    80003302:	7b02                	ld	s6,32(sp)
    80003304:	6be2                	ld	s7,24(sp)
    80003306:	6125                	addi	sp,sp,96
    80003308:	8082                	ret

000000008000330a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000330a:	711d                	addi	sp,sp,-96
    8000330c:	ec86                	sd	ra,88(sp)
    8000330e:	e8a2                	sd	s0,80(sp)
    80003310:	e4a6                	sd	s1,72(sp)
    80003312:	e0ca                	sd	s2,64(sp)
    80003314:	fc4e                	sd	s3,56(sp)
    80003316:	f852                	sd	s4,48(sp)
    80003318:	f456                	sd	s5,40(sp)
    8000331a:	f05a                	sd	s6,32(sp)
    8000331c:	ec5e                	sd	s7,24(sp)
    8000331e:	e862                	sd	s8,16(sp)
    80003320:	e466                	sd	s9,8(sp)
    80003322:	e06a                	sd	s10,0(sp)
    80003324:	1080                	addi	s0,sp,96
    80003326:	84aa                	mv	s1,a0
    80003328:	8b2e                	mv	s6,a1
    8000332a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000332c:	00054703          	lbu	a4,0(a0)
    80003330:	02f00793          	li	a5,47
    80003334:	02f70363          	beq	a4,a5,8000335a <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003338:	ffffe097          	auipc	ra,0xffffe
    8000333c:	d5e080e7          	jalr	-674(ra) # 80001096 <myproc>
    80003340:	15053503          	ld	a0,336(a0)
    80003344:	00000097          	auipc	ra,0x0
    80003348:	9d8080e7          	jalr	-1576(ra) # 80002d1c <idup>
    8000334c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000334e:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003352:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003354:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003356:	4b85                	li	s7,1
    80003358:	a87d                	j	80003416 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000335a:	4585                	li	a1,1
    8000335c:	852e                	mv	a0,a1
    8000335e:	fffff097          	auipc	ra,0xfffff
    80003362:	6cc080e7          	jalr	1740(ra) # 80002a2a <iget>
    80003366:	8a2a                	mv	s4,a0
    80003368:	b7dd                	j	8000334e <namex+0x44>
      iunlockput(ip);
    8000336a:	8552                	mv	a0,s4
    8000336c:	00000097          	auipc	ra,0x0
    80003370:	c54080e7          	jalr	-940(ra) # 80002fc0 <iunlockput>
      return 0;
    80003374:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003376:	8552                	mv	a0,s4
    80003378:	60e6                	ld	ra,88(sp)
    8000337a:	6446                	ld	s0,80(sp)
    8000337c:	64a6                	ld	s1,72(sp)
    8000337e:	6906                	ld	s2,64(sp)
    80003380:	79e2                	ld	s3,56(sp)
    80003382:	7a42                	ld	s4,48(sp)
    80003384:	7aa2                	ld	s5,40(sp)
    80003386:	7b02                	ld	s6,32(sp)
    80003388:	6be2                	ld	s7,24(sp)
    8000338a:	6c42                	ld	s8,16(sp)
    8000338c:	6ca2                	ld	s9,8(sp)
    8000338e:	6d02                	ld	s10,0(sp)
    80003390:	6125                	addi	sp,sp,96
    80003392:	8082                	ret
      iunlock(ip);
    80003394:	8552                	mv	a0,s4
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	a8a080e7          	jalr	-1398(ra) # 80002e20 <iunlock>
      return ip;
    8000339e:	bfe1                	j	80003376 <namex+0x6c>
      iunlockput(ip);
    800033a0:	8552                	mv	a0,s4
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	c1e080e7          	jalr	-994(ra) # 80002fc0 <iunlockput>
      return 0;
    800033aa:	8a4e                	mv	s4,s3
    800033ac:	b7e9                	j	80003376 <namex+0x6c>
  len = path - s;
    800033ae:	40998633          	sub	a2,s3,s1
    800033b2:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800033b6:	09ac5863          	bge	s8,s10,80003446 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800033ba:	8666                	mv	a2,s9
    800033bc:	85a6                	mv	a1,s1
    800033be:	8556                	mv	a0,s5
    800033c0:	ffffd097          	auipc	ra,0xffffd
    800033c4:	f5c080e7          	jalr	-164(ra) # 8000031c <memmove>
    800033c8:	84ce                	mv	s1,s3
  while(*path == '/')
    800033ca:	0004c783          	lbu	a5,0(s1)
    800033ce:	01279763          	bne	a5,s2,800033dc <namex+0xd2>
    path++;
    800033d2:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033d4:	0004c783          	lbu	a5,0(s1)
    800033d8:	ff278de3          	beq	a5,s2,800033d2 <namex+0xc8>
    ilock(ip);
    800033dc:	8552                	mv	a0,s4
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	97c080e7          	jalr	-1668(ra) # 80002d5a <ilock>
    if(ip->type != T_DIR){
    800033e6:	044a1783          	lh	a5,68(s4)
    800033ea:	f97790e3          	bne	a5,s7,8000336a <namex+0x60>
    if(nameiparent && *path == '\0'){
    800033ee:	000b0563          	beqz	s6,800033f8 <namex+0xee>
    800033f2:	0004c783          	lbu	a5,0(s1)
    800033f6:	dfd9                	beqz	a5,80003394 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033f8:	4601                	li	a2,0
    800033fa:	85d6                	mv	a1,s5
    800033fc:	8552                	mv	a0,s4
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	e4c080e7          	jalr	-436(ra) # 8000324a <dirlookup>
    80003406:	89aa                	mv	s3,a0
    80003408:	dd41                	beqz	a0,800033a0 <namex+0x96>
    iunlockput(ip);
    8000340a:	8552                	mv	a0,s4
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	bb4080e7          	jalr	-1100(ra) # 80002fc0 <iunlockput>
    ip = next;
    80003414:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003416:	0004c783          	lbu	a5,0(s1)
    8000341a:	01279763          	bne	a5,s2,80003428 <namex+0x11e>
    path++;
    8000341e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003420:	0004c783          	lbu	a5,0(s1)
    80003424:	ff278de3          	beq	a5,s2,8000341e <namex+0x114>
  if(*path == 0)
    80003428:	cb9d                	beqz	a5,8000345e <namex+0x154>
  while(*path != '/' && *path != 0)
    8000342a:	0004c783          	lbu	a5,0(s1)
    8000342e:	89a6                	mv	s3,s1
  len = path - s;
    80003430:	4d01                	li	s10,0
    80003432:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003434:	01278963          	beq	a5,s2,80003446 <namex+0x13c>
    80003438:	dbbd                	beqz	a5,800033ae <namex+0xa4>
    path++;
    8000343a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000343c:	0009c783          	lbu	a5,0(s3)
    80003440:	ff279ce3          	bne	a5,s2,80003438 <namex+0x12e>
    80003444:	b7ad                	j	800033ae <namex+0xa4>
    memmove(name, s, len);
    80003446:	2601                	sext.w	a2,a2
    80003448:	85a6                	mv	a1,s1
    8000344a:	8556                	mv	a0,s5
    8000344c:	ffffd097          	auipc	ra,0xffffd
    80003450:	ed0080e7          	jalr	-304(ra) # 8000031c <memmove>
    name[len] = 0;
    80003454:	9d56                	add	s10,s10,s5
    80003456:	000d0023          	sb	zero,0(s10)
    8000345a:	84ce                	mv	s1,s3
    8000345c:	b7bd                	j	800033ca <namex+0xc0>
  if(nameiparent){
    8000345e:	f00b0ce3          	beqz	s6,80003376 <namex+0x6c>
    iput(ip);
    80003462:	8552                	mv	a0,s4
    80003464:	00000097          	auipc	ra,0x0
    80003468:	ab4080e7          	jalr	-1356(ra) # 80002f18 <iput>
    return 0;
    8000346c:	4a01                	li	s4,0
    8000346e:	b721                	j	80003376 <namex+0x6c>

0000000080003470 <dirlink>:
{
    80003470:	715d                	addi	sp,sp,-80
    80003472:	e486                	sd	ra,72(sp)
    80003474:	e0a2                	sd	s0,64(sp)
    80003476:	f84a                	sd	s2,48(sp)
    80003478:	ec56                	sd	s5,24(sp)
    8000347a:	e85a                	sd	s6,16(sp)
    8000347c:	0880                	addi	s0,sp,80
    8000347e:	892a                	mv	s2,a0
    80003480:	8aae                	mv	s5,a1
    80003482:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003484:	4601                	li	a2,0
    80003486:	00000097          	auipc	ra,0x0
    8000348a:	dc4080e7          	jalr	-572(ra) # 8000324a <dirlookup>
    8000348e:	e129                	bnez	a0,800034d0 <dirlink+0x60>
    80003490:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003492:	04c92483          	lw	s1,76(s2)
    80003496:	cca9                	beqz	s1,800034f0 <dirlink+0x80>
    80003498:	f44e                	sd	s3,40(sp)
    8000349a:	f052                	sd	s4,32(sp)
    8000349c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000349e:	fb040a13          	addi	s4,s0,-80
    800034a2:	49c1                	li	s3,16
    800034a4:	874e                	mv	a4,s3
    800034a6:	86a6                	mv	a3,s1
    800034a8:	8652                	mv	a2,s4
    800034aa:	4581                	li	a1,0
    800034ac:	854a                	mv	a0,s2
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	b68080e7          	jalr	-1176(ra) # 80003016 <readi>
    800034b6:	03351363          	bne	a0,s3,800034dc <dirlink+0x6c>
    if(de.inum == 0)
    800034ba:	fb045783          	lhu	a5,-80(s0)
    800034be:	c79d                	beqz	a5,800034ec <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034c0:	24c1                	addiw	s1,s1,16
    800034c2:	04c92783          	lw	a5,76(s2)
    800034c6:	fcf4efe3          	bltu	s1,a5,800034a4 <dirlink+0x34>
    800034ca:	79a2                	ld	s3,40(sp)
    800034cc:	7a02                	ld	s4,32(sp)
    800034ce:	a00d                	j	800034f0 <dirlink+0x80>
    iput(ip);
    800034d0:	00000097          	auipc	ra,0x0
    800034d4:	a48080e7          	jalr	-1464(ra) # 80002f18 <iput>
    return -1;
    800034d8:	557d                	li	a0,-1
    800034da:	a0a9                	j	80003524 <dirlink+0xb4>
      panic("dirlink read");
    800034dc:	00005517          	auipc	a0,0x5
    800034e0:	fcc50513          	addi	a0,a0,-52 # 800084a8 <etext+0x4a8>
    800034e4:	00003097          	auipc	ra,0x3
    800034e8:	a2e080e7          	jalr	-1490(ra) # 80005f12 <panic>
    800034ec:	79a2                	ld	s3,40(sp)
    800034ee:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800034f0:	4639                	li	a2,14
    800034f2:	85d6                	mv	a1,s5
    800034f4:	fb240513          	addi	a0,s0,-78
    800034f8:	ffffd097          	auipc	ra,0xffffd
    800034fc:	ed6080e7          	jalr	-298(ra) # 800003ce <strncpy>
  de.inum = inum;
    80003500:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003504:	4741                	li	a4,16
    80003506:	86a6                	mv	a3,s1
    80003508:	fb040613          	addi	a2,s0,-80
    8000350c:	4581                	li	a1,0
    8000350e:	854a                	mv	a0,s2
    80003510:	00000097          	auipc	ra,0x0
    80003514:	c00080e7          	jalr	-1024(ra) # 80003110 <writei>
    80003518:	872a                	mv	a4,a0
    8000351a:	47c1                	li	a5,16
  return 0;
    8000351c:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000351e:	00f71a63          	bne	a4,a5,80003532 <dirlink+0xc2>
    80003522:	74e2                	ld	s1,56(sp)
}
    80003524:	60a6                	ld	ra,72(sp)
    80003526:	6406                	ld	s0,64(sp)
    80003528:	7942                	ld	s2,48(sp)
    8000352a:	6ae2                	ld	s5,24(sp)
    8000352c:	6b42                	ld	s6,16(sp)
    8000352e:	6161                	addi	sp,sp,80
    80003530:	8082                	ret
    80003532:	f44e                	sd	s3,40(sp)
    80003534:	f052                	sd	s4,32(sp)
    panic("dirlink");
    80003536:	00005517          	auipc	a0,0x5
    8000353a:	08250513          	addi	a0,a0,130 # 800085b8 <etext+0x5b8>
    8000353e:	00003097          	auipc	ra,0x3
    80003542:	9d4080e7          	jalr	-1580(ra) # 80005f12 <panic>

0000000080003546 <namei>:

struct inode*
namei(char *path)
{
    80003546:	1101                	addi	sp,sp,-32
    80003548:	ec06                	sd	ra,24(sp)
    8000354a:	e822                	sd	s0,16(sp)
    8000354c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000354e:	fe040613          	addi	a2,s0,-32
    80003552:	4581                	li	a1,0
    80003554:	00000097          	auipc	ra,0x0
    80003558:	db6080e7          	jalr	-586(ra) # 8000330a <namex>
}
    8000355c:	60e2                	ld	ra,24(sp)
    8000355e:	6442                	ld	s0,16(sp)
    80003560:	6105                	addi	sp,sp,32
    80003562:	8082                	ret

0000000080003564 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003564:	1141                	addi	sp,sp,-16
    80003566:	e406                	sd	ra,8(sp)
    80003568:	e022                	sd	s0,0(sp)
    8000356a:	0800                	addi	s0,sp,16
    8000356c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000356e:	4585                	li	a1,1
    80003570:	00000097          	auipc	ra,0x0
    80003574:	d9a080e7          	jalr	-614(ra) # 8000330a <namex>
}
    80003578:	60a2                	ld	ra,8(sp)
    8000357a:	6402                	ld	s0,0(sp)
    8000357c:	0141                	addi	sp,sp,16
    8000357e:	8082                	ret

0000000080003580 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003580:	1101                	addi	sp,sp,-32
    80003582:	ec06                	sd	ra,24(sp)
    80003584:	e822                	sd	s0,16(sp)
    80003586:	e426                	sd	s1,8(sp)
    80003588:	e04a                	sd	s2,0(sp)
    8000358a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000358c:	00256917          	auipc	s2,0x256
    80003590:	acc90913          	addi	s2,s2,-1332 # 80259058 <log>
    80003594:	01892583          	lw	a1,24(s2)
    80003598:	02892503          	lw	a0,40(s2)
    8000359c:	fffff097          	auipc	ra,0xfffff
    800035a0:	fe2080e7          	jalr	-30(ra) # 8000257e <bread>
    800035a4:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800035a6:	02c92603          	lw	a2,44(s2)
    800035aa:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035ac:	00c05f63          	blez	a2,800035ca <write_head+0x4a>
    800035b0:	00256717          	auipc	a4,0x256
    800035b4:	ad870713          	addi	a4,a4,-1320 # 80259088 <log+0x30>
    800035b8:	87aa                	mv	a5,a0
    800035ba:	060a                	slli	a2,a2,0x2
    800035bc:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800035be:	4314                	lw	a3,0(a4)
    800035c0:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800035c2:	0711                	addi	a4,a4,4
    800035c4:	0791                	addi	a5,a5,4
    800035c6:	fec79ce3          	bne	a5,a2,800035be <write_head+0x3e>
  }
  bwrite(buf);
    800035ca:	8526                	mv	a0,s1
    800035cc:	fffff097          	auipc	ra,0xfffff
    800035d0:	0a4080e7          	jalr	164(ra) # 80002670 <bwrite>
  brelse(buf);
    800035d4:	8526                	mv	a0,s1
    800035d6:	fffff097          	auipc	ra,0xfffff
    800035da:	0d8080e7          	jalr	216(ra) # 800026ae <brelse>
}
    800035de:	60e2                	ld	ra,24(sp)
    800035e0:	6442                	ld	s0,16(sp)
    800035e2:	64a2                	ld	s1,8(sp)
    800035e4:	6902                	ld	s2,0(sp)
    800035e6:	6105                	addi	sp,sp,32
    800035e8:	8082                	ret

00000000800035ea <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035ea:	00256797          	auipc	a5,0x256
    800035ee:	a9a7a783          	lw	a5,-1382(a5) # 80259084 <log+0x2c>
    800035f2:	0cf05063          	blez	a5,800036b2 <install_trans+0xc8>
{
    800035f6:	715d                	addi	sp,sp,-80
    800035f8:	e486                	sd	ra,72(sp)
    800035fa:	e0a2                	sd	s0,64(sp)
    800035fc:	fc26                	sd	s1,56(sp)
    800035fe:	f84a                	sd	s2,48(sp)
    80003600:	f44e                	sd	s3,40(sp)
    80003602:	f052                	sd	s4,32(sp)
    80003604:	ec56                	sd	s5,24(sp)
    80003606:	e85a                	sd	s6,16(sp)
    80003608:	e45e                	sd	s7,8(sp)
    8000360a:	0880                	addi	s0,sp,80
    8000360c:	8b2a                	mv	s6,a0
    8000360e:	00256a97          	auipc	s5,0x256
    80003612:	a7aa8a93          	addi	s5,s5,-1414 # 80259088 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003616:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003618:	00256997          	auipc	s3,0x256
    8000361c:	a4098993          	addi	s3,s3,-1472 # 80259058 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003620:	40000b93          	li	s7,1024
    80003624:	a00d                	j	80003646 <install_trans+0x5c>
    brelse(lbuf);
    80003626:	854a                	mv	a0,s2
    80003628:	fffff097          	auipc	ra,0xfffff
    8000362c:	086080e7          	jalr	134(ra) # 800026ae <brelse>
    brelse(dbuf);
    80003630:	8526                	mv	a0,s1
    80003632:	fffff097          	auipc	ra,0xfffff
    80003636:	07c080e7          	jalr	124(ra) # 800026ae <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000363a:	2a05                	addiw	s4,s4,1
    8000363c:	0a91                	addi	s5,s5,4
    8000363e:	02c9a783          	lw	a5,44(s3)
    80003642:	04fa5d63          	bge	s4,a5,8000369c <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003646:	0189a583          	lw	a1,24(s3)
    8000364a:	014585bb          	addw	a1,a1,s4
    8000364e:	2585                	addiw	a1,a1,1
    80003650:	0289a503          	lw	a0,40(s3)
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	f2a080e7          	jalr	-214(ra) # 8000257e <bread>
    8000365c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000365e:	000aa583          	lw	a1,0(s5)
    80003662:	0289a503          	lw	a0,40(s3)
    80003666:	fffff097          	auipc	ra,0xfffff
    8000366a:	f18080e7          	jalr	-232(ra) # 8000257e <bread>
    8000366e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003670:	865e                	mv	a2,s7
    80003672:	05890593          	addi	a1,s2,88
    80003676:	05850513          	addi	a0,a0,88
    8000367a:	ffffd097          	auipc	ra,0xffffd
    8000367e:	ca2080e7          	jalr	-862(ra) # 8000031c <memmove>
    bwrite(dbuf);  // write dst to disk
    80003682:	8526                	mv	a0,s1
    80003684:	fffff097          	auipc	ra,0xfffff
    80003688:	fec080e7          	jalr	-20(ra) # 80002670 <bwrite>
    if(recovering == 0)
    8000368c:	f80b1de3          	bnez	s6,80003626 <install_trans+0x3c>
      bunpin(dbuf);
    80003690:	8526                	mv	a0,s1
    80003692:	fffff097          	auipc	ra,0xfffff
    80003696:	0f0080e7          	jalr	240(ra) # 80002782 <bunpin>
    8000369a:	b771                	j	80003626 <install_trans+0x3c>
}
    8000369c:	60a6                	ld	ra,72(sp)
    8000369e:	6406                	ld	s0,64(sp)
    800036a0:	74e2                	ld	s1,56(sp)
    800036a2:	7942                	ld	s2,48(sp)
    800036a4:	79a2                	ld	s3,40(sp)
    800036a6:	7a02                	ld	s4,32(sp)
    800036a8:	6ae2                	ld	s5,24(sp)
    800036aa:	6b42                	ld	s6,16(sp)
    800036ac:	6ba2                	ld	s7,8(sp)
    800036ae:	6161                	addi	sp,sp,80
    800036b0:	8082                	ret
    800036b2:	8082                	ret

00000000800036b4 <initlog>:
{
    800036b4:	7179                	addi	sp,sp,-48
    800036b6:	f406                	sd	ra,40(sp)
    800036b8:	f022                	sd	s0,32(sp)
    800036ba:	ec26                	sd	s1,24(sp)
    800036bc:	e84a                	sd	s2,16(sp)
    800036be:	e44e                	sd	s3,8(sp)
    800036c0:	1800                	addi	s0,sp,48
    800036c2:	892a                	mv	s2,a0
    800036c4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036c6:	00256497          	auipc	s1,0x256
    800036ca:	99248493          	addi	s1,s1,-1646 # 80259058 <log>
    800036ce:	00005597          	auipc	a1,0x5
    800036d2:	dea58593          	addi	a1,a1,-534 # 800084b8 <etext+0x4b8>
    800036d6:	8526                	mv	a0,s1
    800036d8:	00003097          	auipc	ra,0x3
    800036dc:	d26080e7          	jalr	-730(ra) # 800063fe <initlock>
  log.start = sb->logstart;
    800036e0:	0149a583          	lw	a1,20(s3)
    800036e4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036e6:	0109a783          	lw	a5,16(s3)
    800036ea:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036ec:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036f0:	854a                	mv	a0,s2
    800036f2:	fffff097          	auipc	ra,0xfffff
    800036f6:	e8c080e7          	jalr	-372(ra) # 8000257e <bread>
  log.lh.n = lh->n;
    800036fa:	4d30                	lw	a2,88(a0)
    800036fc:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036fe:	00c05f63          	blez	a2,8000371c <initlog+0x68>
    80003702:	87aa                	mv	a5,a0
    80003704:	00256717          	auipc	a4,0x256
    80003708:	98470713          	addi	a4,a4,-1660 # 80259088 <log+0x30>
    8000370c:	060a                	slli	a2,a2,0x2
    8000370e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003710:	4ff4                	lw	a3,92(a5)
    80003712:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003714:	0791                	addi	a5,a5,4
    80003716:	0711                	addi	a4,a4,4
    80003718:	fec79ce3          	bne	a5,a2,80003710 <initlog+0x5c>
  brelse(buf);
    8000371c:	fffff097          	auipc	ra,0xfffff
    80003720:	f92080e7          	jalr	-110(ra) # 800026ae <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003724:	4505                	li	a0,1
    80003726:	00000097          	auipc	ra,0x0
    8000372a:	ec4080e7          	jalr	-316(ra) # 800035ea <install_trans>
  log.lh.n = 0;
    8000372e:	00256797          	auipc	a5,0x256
    80003732:	9407ab23          	sw	zero,-1706(a5) # 80259084 <log+0x2c>
  write_head(); // clear the log
    80003736:	00000097          	auipc	ra,0x0
    8000373a:	e4a080e7          	jalr	-438(ra) # 80003580 <write_head>
}
    8000373e:	70a2                	ld	ra,40(sp)
    80003740:	7402                	ld	s0,32(sp)
    80003742:	64e2                	ld	s1,24(sp)
    80003744:	6942                	ld	s2,16(sp)
    80003746:	69a2                	ld	s3,8(sp)
    80003748:	6145                	addi	sp,sp,48
    8000374a:	8082                	ret

000000008000374c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000374c:	1101                	addi	sp,sp,-32
    8000374e:	ec06                	sd	ra,24(sp)
    80003750:	e822                	sd	s0,16(sp)
    80003752:	e426                	sd	s1,8(sp)
    80003754:	e04a                	sd	s2,0(sp)
    80003756:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003758:	00256517          	auipc	a0,0x256
    8000375c:	90050513          	addi	a0,a0,-1792 # 80259058 <log>
    80003760:	00003097          	auipc	ra,0x3
    80003764:	d32080e7          	jalr	-718(ra) # 80006492 <acquire>
  while(1){
    if(log.committing){
    80003768:	00256497          	auipc	s1,0x256
    8000376c:	8f048493          	addi	s1,s1,-1808 # 80259058 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003770:	4979                	li	s2,30
    80003772:	a039                	j	80003780 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003774:	85a6                	mv	a1,s1
    80003776:	8526                	mv	a0,s1
    80003778:	ffffe097          	auipc	ra,0xffffe
    8000377c:	fe4080e7          	jalr	-28(ra) # 8000175c <sleep>
    if(log.committing){
    80003780:	50dc                	lw	a5,36(s1)
    80003782:	fbed                	bnez	a5,80003774 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003784:	5098                	lw	a4,32(s1)
    80003786:	2705                	addiw	a4,a4,1
    80003788:	0027179b          	slliw	a5,a4,0x2
    8000378c:	9fb9                	addw	a5,a5,a4
    8000378e:	0017979b          	slliw	a5,a5,0x1
    80003792:	54d4                	lw	a3,44(s1)
    80003794:	9fb5                	addw	a5,a5,a3
    80003796:	00f95963          	bge	s2,a5,800037a8 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000379a:	85a6                	mv	a1,s1
    8000379c:	8526                	mv	a0,s1
    8000379e:	ffffe097          	auipc	ra,0xffffe
    800037a2:	fbe080e7          	jalr	-66(ra) # 8000175c <sleep>
    800037a6:	bfe9                	j	80003780 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800037a8:	00256517          	auipc	a0,0x256
    800037ac:	8b050513          	addi	a0,a0,-1872 # 80259058 <log>
    800037b0:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800037b2:	00003097          	auipc	ra,0x3
    800037b6:	d90080e7          	jalr	-624(ra) # 80006542 <release>
      break;
    }
  }
}
    800037ba:	60e2                	ld	ra,24(sp)
    800037bc:	6442                	ld	s0,16(sp)
    800037be:	64a2                	ld	s1,8(sp)
    800037c0:	6902                	ld	s2,0(sp)
    800037c2:	6105                	addi	sp,sp,32
    800037c4:	8082                	ret

00000000800037c6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037c6:	7139                	addi	sp,sp,-64
    800037c8:	fc06                	sd	ra,56(sp)
    800037ca:	f822                	sd	s0,48(sp)
    800037cc:	f426                	sd	s1,40(sp)
    800037ce:	f04a                	sd	s2,32(sp)
    800037d0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037d2:	00256497          	auipc	s1,0x256
    800037d6:	88648493          	addi	s1,s1,-1914 # 80259058 <log>
    800037da:	8526                	mv	a0,s1
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	cb6080e7          	jalr	-842(ra) # 80006492 <acquire>
  log.outstanding -= 1;
    800037e4:	509c                	lw	a5,32(s1)
    800037e6:	37fd                	addiw	a5,a5,-1
    800037e8:	893e                	mv	s2,a5
    800037ea:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037ec:	50dc                	lw	a5,36(s1)
    800037ee:	e7b9                	bnez	a5,8000383c <end_op+0x76>
    panic("log.committing");
  if(log.outstanding == 0){
    800037f0:	06091263          	bnez	s2,80003854 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037f4:	00256497          	auipc	s1,0x256
    800037f8:	86448493          	addi	s1,s1,-1948 # 80259058 <log>
    800037fc:	4785                	li	a5,1
    800037fe:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003800:	8526                	mv	a0,s1
    80003802:	00003097          	auipc	ra,0x3
    80003806:	d40080e7          	jalr	-704(ra) # 80006542 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000380a:	54dc                	lw	a5,44(s1)
    8000380c:	06f04863          	bgtz	a5,8000387c <end_op+0xb6>
    acquire(&log.lock);
    80003810:	00256497          	auipc	s1,0x256
    80003814:	84848493          	addi	s1,s1,-1976 # 80259058 <log>
    80003818:	8526                	mv	a0,s1
    8000381a:	00003097          	auipc	ra,0x3
    8000381e:	c78080e7          	jalr	-904(ra) # 80006492 <acquire>
    log.committing = 0;
    80003822:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003826:	8526                	mv	a0,s1
    80003828:	ffffe097          	auipc	ra,0xffffe
    8000382c:	0ba080e7          	jalr	186(ra) # 800018e2 <wakeup>
    release(&log.lock);
    80003830:	8526                	mv	a0,s1
    80003832:	00003097          	auipc	ra,0x3
    80003836:	d10080e7          	jalr	-752(ra) # 80006542 <release>
}
    8000383a:	a81d                	j	80003870 <end_op+0xaa>
    8000383c:	ec4e                	sd	s3,24(sp)
    8000383e:	e852                	sd	s4,16(sp)
    80003840:	e456                	sd	s5,8(sp)
    80003842:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    80003844:	00005517          	auipc	a0,0x5
    80003848:	c7c50513          	addi	a0,a0,-900 # 800084c0 <etext+0x4c0>
    8000384c:	00002097          	auipc	ra,0x2
    80003850:	6c6080e7          	jalr	1734(ra) # 80005f12 <panic>
    wakeup(&log);
    80003854:	00256497          	auipc	s1,0x256
    80003858:	80448493          	addi	s1,s1,-2044 # 80259058 <log>
    8000385c:	8526                	mv	a0,s1
    8000385e:	ffffe097          	auipc	ra,0xffffe
    80003862:	084080e7          	jalr	132(ra) # 800018e2 <wakeup>
  release(&log.lock);
    80003866:	8526                	mv	a0,s1
    80003868:	00003097          	auipc	ra,0x3
    8000386c:	cda080e7          	jalr	-806(ra) # 80006542 <release>
}
    80003870:	70e2                	ld	ra,56(sp)
    80003872:	7442                	ld	s0,48(sp)
    80003874:	74a2                	ld	s1,40(sp)
    80003876:	7902                	ld	s2,32(sp)
    80003878:	6121                	addi	sp,sp,64
    8000387a:	8082                	ret
    8000387c:	ec4e                	sd	s3,24(sp)
    8000387e:	e852                	sd	s4,16(sp)
    80003880:	e456                	sd	s5,8(sp)
    80003882:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003884:	00256a97          	auipc	s5,0x256
    80003888:	804a8a93          	addi	s5,s5,-2044 # 80259088 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000388c:	00255a17          	auipc	s4,0x255
    80003890:	7cca0a13          	addi	s4,s4,1996 # 80259058 <log>
    memmove(to->data, from->data, BSIZE);
    80003894:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003898:	018a2583          	lw	a1,24(s4)
    8000389c:	012585bb          	addw	a1,a1,s2
    800038a0:	2585                	addiw	a1,a1,1
    800038a2:	028a2503          	lw	a0,40(s4)
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	cd8080e7          	jalr	-808(ra) # 8000257e <bread>
    800038ae:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800038b0:	000aa583          	lw	a1,0(s5)
    800038b4:	028a2503          	lw	a0,40(s4)
    800038b8:	fffff097          	auipc	ra,0xfffff
    800038bc:	cc6080e7          	jalr	-826(ra) # 8000257e <bread>
    800038c0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038c2:	865a                	mv	a2,s6
    800038c4:	05850593          	addi	a1,a0,88
    800038c8:	05848513          	addi	a0,s1,88
    800038cc:	ffffd097          	auipc	ra,0xffffd
    800038d0:	a50080e7          	jalr	-1456(ra) # 8000031c <memmove>
    bwrite(to);  // write the log
    800038d4:	8526                	mv	a0,s1
    800038d6:	fffff097          	auipc	ra,0xfffff
    800038da:	d9a080e7          	jalr	-614(ra) # 80002670 <bwrite>
    brelse(from);
    800038de:	854e                	mv	a0,s3
    800038e0:	fffff097          	auipc	ra,0xfffff
    800038e4:	dce080e7          	jalr	-562(ra) # 800026ae <brelse>
    brelse(to);
    800038e8:	8526                	mv	a0,s1
    800038ea:	fffff097          	auipc	ra,0xfffff
    800038ee:	dc4080e7          	jalr	-572(ra) # 800026ae <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038f2:	2905                	addiw	s2,s2,1
    800038f4:	0a91                	addi	s5,s5,4
    800038f6:	02ca2783          	lw	a5,44(s4)
    800038fa:	f8f94fe3          	blt	s2,a5,80003898 <end_op+0xd2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038fe:	00000097          	auipc	ra,0x0
    80003902:	c82080e7          	jalr	-894(ra) # 80003580 <write_head>
    install_trans(0); // Now install writes to home locations
    80003906:	4501                	li	a0,0
    80003908:	00000097          	auipc	ra,0x0
    8000390c:	ce2080e7          	jalr	-798(ra) # 800035ea <install_trans>
    log.lh.n = 0;
    80003910:	00255797          	auipc	a5,0x255
    80003914:	7607aa23          	sw	zero,1908(a5) # 80259084 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003918:	00000097          	auipc	ra,0x0
    8000391c:	c68080e7          	jalr	-920(ra) # 80003580 <write_head>
    80003920:	69e2                	ld	s3,24(sp)
    80003922:	6a42                	ld	s4,16(sp)
    80003924:	6aa2                	ld	s5,8(sp)
    80003926:	6b02                	ld	s6,0(sp)
    80003928:	b5e5                	j	80003810 <end_op+0x4a>

000000008000392a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000392a:	1101                	addi	sp,sp,-32
    8000392c:	ec06                	sd	ra,24(sp)
    8000392e:	e822                	sd	s0,16(sp)
    80003930:	e426                	sd	s1,8(sp)
    80003932:	e04a                	sd	s2,0(sp)
    80003934:	1000                	addi	s0,sp,32
    80003936:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003938:	00255917          	auipc	s2,0x255
    8000393c:	72090913          	addi	s2,s2,1824 # 80259058 <log>
    80003940:	854a                	mv	a0,s2
    80003942:	00003097          	auipc	ra,0x3
    80003946:	b50080e7          	jalr	-1200(ra) # 80006492 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000394a:	02c92603          	lw	a2,44(s2)
    8000394e:	47f5                	li	a5,29
    80003950:	06c7c563          	blt	a5,a2,800039ba <log_write+0x90>
    80003954:	00255797          	auipc	a5,0x255
    80003958:	7207a783          	lw	a5,1824(a5) # 80259074 <log+0x1c>
    8000395c:	37fd                	addiw	a5,a5,-1
    8000395e:	04f65e63          	bge	a2,a5,800039ba <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003962:	00255797          	auipc	a5,0x255
    80003966:	7167a783          	lw	a5,1814(a5) # 80259078 <log+0x20>
    8000396a:	06f05063          	blez	a5,800039ca <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000396e:	4781                	li	a5,0
    80003970:	06c05563          	blez	a2,800039da <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003974:	44cc                	lw	a1,12(s1)
    80003976:	00255717          	auipc	a4,0x255
    8000397a:	71270713          	addi	a4,a4,1810 # 80259088 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000397e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003980:	4314                	lw	a3,0(a4)
    80003982:	04b68c63          	beq	a3,a1,800039da <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003986:	2785                	addiw	a5,a5,1
    80003988:	0711                	addi	a4,a4,4
    8000398a:	fef61be3          	bne	a2,a5,80003980 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000398e:	0621                	addi	a2,a2,8
    80003990:	060a                	slli	a2,a2,0x2
    80003992:	00255797          	auipc	a5,0x255
    80003996:	6c678793          	addi	a5,a5,1734 # 80259058 <log>
    8000399a:	97b2                	add	a5,a5,a2
    8000399c:	44d8                	lw	a4,12(s1)
    8000399e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800039a0:	8526                	mv	a0,s1
    800039a2:	fffff097          	auipc	ra,0xfffff
    800039a6:	da4080e7          	jalr	-604(ra) # 80002746 <bpin>
    log.lh.n++;
    800039aa:	00255717          	auipc	a4,0x255
    800039ae:	6ae70713          	addi	a4,a4,1710 # 80259058 <log>
    800039b2:	575c                	lw	a5,44(a4)
    800039b4:	2785                	addiw	a5,a5,1
    800039b6:	d75c                	sw	a5,44(a4)
    800039b8:	a82d                	j	800039f2 <log_write+0xc8>
    panic("too big a transaction");
    800039ba:	00005517          	auipc	a0,0x5
    800039be:	b1650513          	addi	a0,a0,-1258 # 800084d0 <etext+0x4d0>
    800039c2:	00002097          	auipc	ra,0x2
    800039c6:	550080e7          	jalr	1360(ra) # 80005f12 <panic>
    panic("log_write outside of trans");
    800039ca:	00005517          	auipc	a0,0x5
    800039ce:	b1e50513          	addi	a0,a0,-1250 # 800084e8 <etext+0x4e8>
    800039d2:	00002097          	auipc	ra,0x2
    800039d6:	540080e7          	jalr	1344(ra) # 80005f12 <panic>
  log.lh.block[i] = b->blockno;
    800039da:	00878693          	addi	a3,a5,8
    800039de:	068a                	slli	a3,a3,0x2
    800039e0:	00255717          	auipc	a4,0x255
    800039e4:	67870713          	addi	a4,a4,1656 # 80259058 <log>
    800039e8:	9736                	add	a4,a4,a3
    800039ea:	44d4                	lw	a3,12(s1)
    800039ec:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039ee:	faf609e3          	beq	a2,a5,800039a0 <log_write+0x76>
  }
  release(&log.lock);
    800039f2:	00255517          	auipc	a0,0x255
    800039f6:	66650513          	addi	a0,a0,1638 # 80259058 <log>
    800039fa:	00003097          	auipc	ra,0x3
    800039fe:	b48080e7          	jalr	-1208(ra) # 80006542 <release>
}
    80003a02:	60e2                	ld	ra,24(sp)
    80003a04:	6442                	ld	s0,16(sp)
    80003a06:	64a2                	ld	s1,8(sp)
    80003a08:	6902                	ld	s2,0(sp)
    80003a0a:	6105                	addi	sp,sp,32
    80003a0c:	8082                	ret

0000000080003a0e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003a0e:	1101                	addi	sp,sp,-32
    80003a10:	ec06                	sd	ra,24(sp)
    80003a12:	e822                	sd	s0,16(sp)
    80003a14:	e426                	sd	s1,8(sp)
    80003a16:	e04a                	sd	s2,0(sp)
    80003a18:	1000                	addi	s0,sp,32
    80003a1a:	84aa                	mv	s1,a0
    80003a1c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a1e:	00005597          	auipc	a1,0x5
    80003a22:	aea58593          	addi	a1,a1,-1302 # 80008508 <etext+0x508>
    80003a26:	0521                	addi	a0,a0,8
    80003a28:	00003097          	auipc	ra,0x3
    80003a2c:	9d6080e7          	jalr	-1578(ra) # 800063fe <initlock>
  lk->name = name;
    80003a30:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a34:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a38:	0204a423          	sw	zero,40(s1)
}
    80003a3c:	60e2                	ld	ra,24(sp)
    80003a3e:	6442                	ld	s0,16(sp)
    80003a40:	64a2                	ld	s1,8(sp)
    80003a42:	6902                	ld	s2,0(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	e04a                	sd	s2,0(sp)
    80003a52:	1000                	addi	s0,sp,32
    80003a54:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a56:	00850913          	addi	s2,a0,8
    80003a5a:	854a                	mv	a0,s2
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	a36080e7          	jalr	-1482(ra) # 80006492 <acquire>
  while (lk->locked) {
    80003a64:	409c                	lw	a5,0(s1)
    80003a66:	cb89                	beqz	a5,80003a78 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a68:	85ca                	mv	a1,s2
    80003a6a:	8526                	mv	a0,s1
    80003a6c:	ffffe097          	auipc	ra,0xffffe
    80003a70:	cf0080e7          	jalr	-784(ra) # 8000175c <sleep>
  while (lk->locked) {
    80003a74:	409c                	lw	a5,0(s1)
    80003a76:	fbed                	bnez	a5,80003a68 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a78:	4785                	li	a5,1
    80003a7a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a7c:	ffffd097          	auipc	ra,0xffffd
    80003a80:	61a080e7          	jalr	1562(ra) # 80001096 <myproc>
    80003a84:	591c                	lw	a5,48(a0)
    80003a86:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a88:	854a                	mv	a0,s2
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	ab8080e7          	jalr	-1352(ra) # 80006542 <release>
}
    80003a92:	60e2                	ld	ra,24(sp)
    80003a94:	6442                	ld	s0,16(sp)
    80003a96:	64a2                	ld	s1,8(sp)
    80003a98:	6902                	ld	s2,0(sp)
    80003a9a:	6105                	addi	sp,sp,32
    80003a9c:	8082                	ret

0000000080003a9e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a9e:	1101                	addi	sp,sp,-32
    80003aa0:	ec06                	sd	ra,24(sp)
    80003aa2:	e822                	sd	s0,16(sp)
    80003aa4:	e426                	sd	s1,8(sp)
    80003aa6:	e04a                	sd	s2,0(sp)
    80003aa8:	1000                	addi	s0,sp,32
    80003aaa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003aac:	00850913          	addi	s2,a0,8
    80003ab0:	854a                	mv	a0,s2
    80003ab2:	00003097          	auipc	ra,0x3
    80003ab6:	9e0080e7          	jalr	-1568(ra) # 80006492 <acquire>
  lk->locked = 0;
    80003aba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003abe:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ac2:	8526                	mv	a0,s1
    80003ac4:	ffffe097          	auipc	ra,0xffffe
    80003ac8:	e1e080e7          	jalr	-482(ra) # 800018e2 <wakeup>
  release(&lk->lk);
    80003acc:	854a                	mv	a0,s2
    80003ace:	00003097          	auipc	ra,0x3
    80003ad2:	a74080e7          	jalr	-1420(ra) # 80006542 <release>
}
    80003ad6:	60e2                	ld	ra,24(sp)
    80003ad8:	6442                	ld	s0,16(sp)
    80003ada:	64a2                	ld	s1,8(sp)
    80003adc:	6902                	ld	s2,0(sp)
    80003ade:	6105                	addi	sp,sp,32
    80003ae0:	8082                	ret

0000000080003ae2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003ae2:	7179                	addi	sp,sp,-48
    80003ae4:	f406                	sd	ra,40(sp)
    80003ae6:	f022                	sd	s0,32(sp)
    80003ae8:	ec26                	sd	s1,24(sp)
    80003aea:	e84a                	sd	s2,16(sp)
    80003aec:	1800                	addi	s0,sp,48
    80003aee:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003af0:	00850913          	addi	s2,a0,8
    80003af4:	854a                	mv	a0,s2
    80003af6:	00003097          	auipc	ra,0x3
    80003afa:	99c080e7          	jalr	-1636(ra) # 80006492 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003afe:	409c                	lw	a5,0(s1)
    80003b00:	ef91                	bnez	a5,80003b1c <holdingsleep+0x3a>
    80003b02:	4481                	li	s1,0
  release(&lk->lk);
    80003b04:	854a                	mv	a0,s2
    80003b06:	00003097          	auipc	ra,0x3
    80003b0a:	a3c080e7          	jalr	-1476(ra) # 80006542 <release>
  return r;
}
    80003b0e:	8526                	mv	a0,s1
    80003b10:	70a2                	ld	ra,40(sp)
    80003b12:	7402                	ld	s0,32(sp)
    80003b14:	64e2                	ld	s1,24(sp)
    80003b16:	6942                	ld	s2,16(sp)
    80003b18:	6145                	addi	sp,sp,48
    80003b1a:	8082                	ret
    80003b1c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b1e:	0284a983          	lw	s3,40(s1)
    80003b22:	ffffd097          	auipc	ra,0xffffd
    80003b26:	574080e7          	jalr	1396(ra) # 80001096 <myproc>
    80003b2a:	5904                	lw	s1,48(a0)
    80003b2c:	413484b3          	sub	s1,s1,s3
    80003b30:	0014b493          	seqz	s1,s1
    80003b34:	69a2                	ld	s3,8(sp)
    80003b36:	b7f9                	j	80003b04 <holdingsleep+0x22>

0000000080003b38 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b38:	1141                	addi	sp,sp,-16
    80003b3a:	e406                	sd	ra,8(sp)
    80003b3c:	e022                	sd	s0,0(sp)
    80003b3e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b40:	00005597          	auipc	a1,0x5
    80003b44:	9d858593          	addi	a1,a1,-1576 # 80008518 <etext+0x518>
    80003b48:	00255517          	auipc	a0,0x255
    80003b4c:	65850513          	addi	a0,a0,1624 # 802591a0 <ftable>
    80003b50:	00003097          	auipc	ra,0x3
    80003b54:	8ae080e7          	jalr	-1874(ra) # 800063fe <initlock>
}
    80003b58:	60a2                	ld	ra,8(sp)
    80003b5a:	6402                	ld	s0,0(sp)
    80003b5c:	0141                	addi	sp,sp,16
    80003b5e:	8082                	ret

0000000080003b60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b60:	1101                	addi	sp,sp,-32
    80003b62:	ec06                	sd	ra,24(sp)
    80003b64:	e822                	sd	s0,16(sp)
    80003b66:	e426                	sd	s1,8(sp)
    80003b68:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b6a:	00255517          	auipc	a0,0x255
    80003b6e:	63650513          	addi	a0,a0,1590 # 802591a0 <ftable>
    80003b72:	00003097          	auipc	ra,0x3
    80003b76:	920080e7          	jalr	-1760(ra) # 80006492 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b7a:	00255497          	auipc	s1,0x255
    80003b7e:	63e48493          	addi	s1,s1,1598 # 802591b8 <ftable+0x18>
    80003b82:	00256717          	auipc	a4,0x256
    80003b86:	5d670713          	addi	a4,a4,1494 # 8025a158 <ftable+0xfb8>
    if(f->ref == 0){
    80003b8a:	40dc                	lw	a5,4(s1)
    80003b8c:	cf99                	beqz	a5,80003baa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b8e:	02848493          	addi	s1,s1,40
    80003b92:	fee49ce3          	bne	s1,a4,80003b8a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b96:	00255517          	auipc	a0,0x255
    80003b9a:	60a50513          	addi	a0,a0,1546 # 802591a0 <ftable>
    80003b9e:	00003097          	auipc	ra,0x3
    80003ba2:	9a4080e7          	jalr	-1628(ra) # 80006542 <release>
  return 0;
    80003ba6:	4481                	li	s1,0
    80003ba8:	a819                	j	80003bbe <filealloc+0x5e>
      f->ref = 1;
    80003baa:	4785                	li	a5,1
    80003bac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003bae:	00255517          	auipc	a0,0x255
    80003bb2:	5f250513          	addi	a0,a0,1522 # 802591a0 <ftable>
    80003bb6:	00003097          	auipc	ra,0x3
    80003bba:	98c080e7          	jalr	-1652(ra) # 80006542 <release>
}
    80003bbe:	8526                	mv	a0,s1
    80003bc0:	60e2                	ld	ra,24(sp)
    80003bc2:	6442                	ld	s0,16(sp)
    80003bc4:	64a2                	ld	s1,8(sp)
    80003bc6:	6105                	addi	sp,sp,32
    80003bc8:	8082                	ret

0000000080003bca <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bca:	1101                	addi	sp,sp,-32
    80003bcc:	ec06                	sd	ra,24(sp)
    80003bce:	e822                	sd	s0,16(sp)
    80003bd0:	e426                	sd	s1,8(sp)
    80003bd2:	1000                	addi	s0,sp,32
    80003bd4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bd6:	00255517          	auipc	a0,0x255
    80003bda:	5ca50513          	addi	a0,a0,1482 # 802591a0 <ftable>
    80003bde:	00003097          	auipc	ra,0x3
    80003be2:	8b4080e7          	jalr	-1868(ra) # 80006492 <acquire>
  if(f->ref < 1)
    80003be6:	40dc                	lw	a5,4(s1)
    80003be8:	02f05263          	blez	a5,80003c0c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bec:	2785                	addiw	a5,a5,1
    80003bee:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bf0:	00255517          	auipc	a0,0x255
    80003bf4:	5b050513          	addi	a0,a0,1456 # 802591a0 <ftable>
    80003bf8:	00003097          	auipc	ra,0x3
    80003bfc:	94a080e7          	jalr	-1718(ra) # 80006542 <release>
  return f;
}
    80003c00:	8526                	mv	a0,s1
    80003c02:	60e2                	ld	ra,24(sp)
    80003c04:	6442                	ld	s0,16(sp)
    80003c06:	64a2                	ld	s1,8(sp)
    80003c08:	6105                	addi	sp,sp,32
    80003c0a:	8082                	ret
    panic("filedup");
    80003c0c:	00005517          	auipc	a0,0x5
    80003c10:	91450513          	addi	a0,a0,-1772 # 80008520 <etext+0x520>
    80003c14:	00002097          	auipc	ra,0x2
    80003c18:	2fe080e7          	jalr	766(ra) # 80005f12 <panic>

0000000080003c1c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c1c:	7139                	addi	sp,sp,-64
    80003c1e:	fc06                	sd	ra,56(sp)
    80003c20:	f822                	sd	s0,48(sp)
    80003c22:	f426                	sd	s1,40(sp)
    80003c24:	0080                	addi	s0,sp,64
    80003c26:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c28:	00255517          	auipc	a0,0x255
    80003c2c:	57850513          	addi	a0,a0,1400 # 802591a0 <ftable>
    80003c30:	00003097          	auipc	ra,0x3
    80003c34:	862080e7          	jalr	-1950(ra) # 80006492 <acquire>
  if(f->ref < 1)
    80003c38:	40dc                	lw	a5,4(s1)
    80003c3a:	04f05a63          	blez	a5,80003c8e <fileclose+0x72>
    panic("fileclose");
  if(--f->ref > 0){
    80003c3e:	37fd                	addiw	a5,a5,-1
    80003c40:	c0dc                	sw	a5,4(s1)
    80003c42:	06f04263          	bgtz	a5,80003ca6 <fileclose+0x8a>
    80003c46:	f04a                	sd	s2,32(sp)
    80003c48:	ec4e                	sd	s3,24(sp)
    80003c4a:	e852                	sd	s4,16(sp)
    80003c4c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c4e:	0004a903          	lw	s2,0(s1)
    80003c52:	0094ca83          	lbu	s5,9(s1)
    80003c56:	0104ba03          	ld	s4,16(s1)
    80003c5a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c5e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c62:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c66:	00255517          	auipc	a0,0x255
    80003c6a:	53a50513          	addi	a0,a0,1338 # 802591a0 <ftable>
    80003c6e:	00003097          	auipc	ra,0x3
    80003c72:	8d4080e7          	jalr	-1836(ra) # 80006542 <release>

  if(ff.type == FD_PIPE){
    80003c76:	4785                	li	a5,1
    80003c78:	04f90463          	beq	s2,a5,80003cc0 <fileclose+0xa4>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c7c:	3979                	addiw	s2,s2,-2
    80003c7e:	4785                	li	a5,1
    80003c80:	0527fb63          	bgeu	a5,s2,80003cd6 <fileclose+0xba>
    80003c84:	7902                	ld	s2,32(sp)
    80003c86:	69e2                	ld	s3,24(sp)
    80003c88:	6a42                	ld	s4,16(sp)
    80003c8a:	6aa2                	ld	s5,8(sp)
    80003c8c:	a02d                	j	80003cb6 <fileclose+0x9a>
    80003c8e:	f04a                	sd	s2,32(sp)
    80003c90:	ec4e                	sd	s3,24(sp)
    80003c92:	e852                	sd	s4,16(sp)
    80003c94:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c96:	00005517          	auipc	a0,0x5
    80003c9a:	89250513          	addi	a0,a0,-1902 # 80008528 <etext+0x528>
    80003c9e:	00002097          	auipc	ra,0x2
    80003ca2:	274080e7          	jalr	628(ra) # 80005f12 <panic>
    release(&ftable.lock);
    80003ca6:	00255517          	auipc	a0,0x255
    80003caa:	4fa50513          	addi	a0,a0,1274 # 802591a0 <ftable>
    80003cae:	00003097          	auipc	ra,0x3
    80003cb2:	894080e7          	jalr	-1900(ra) # 80006542 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003cb6:	70e2                	ld	ra,56(sp)
    80003cb8:	7442                	ld	s0,48(sp)
    80003cba:	74a2                	ld	s1,40(sp)
    80003cbc:	6121                	addi	sp,sp,64
    80003cbe:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cc0:	85d6                	mv	a1,s5
    80003cc2:	8552                	mv	a0,s4
    80003cc4:	00000097          	auipc	ra,0x0
    80003cc8:	3ac080e7          	jalr	940(ra) # 80004070 <pipeclose>
    80003ccc:	7902                	ld	s2,32(sp)
    80003cce:	69e2                	ld	s3,24(sp)
    80003cd0:	6a42                	ld	s4,16(sp)
    80003cd2:	6aa2                	ld	s5,8(sp)
    80003cd4:	b7cd                	j	80003cb6 <fileclose+0x9a>
    begin_op();
    80003cd6:	00000097          	auipc	ra,0x0
    80003cda:	a76080e7          	jalr	-1418(ra) # 8000374c <begin_op>
    iput(ff.ip);
    80003cde:	854e                	mv	a0,s3
    80003ce0:	fffff097          	auipc	ra,0xfffff
    80003ce4:	238080e7          	jalr	568(ra) # 80002f18 <iput>
    end_op();
    80003ce8:	00000097          	auipc	ra,0x0
    80003cec:	ade080e7          	jalr	-1314(ra) # 800037c6 <end_op>
    80003cf0:	7902                	ld	s2,32(sp)
    80003cf2:	69e2                	ld	s3,24(sp)
    80003cf4:	6a42                	ld	s4,16(sp)
    80003cf6:	6aa2                	ld	s5,8(sp)
    80003cf8:	bf7d                	j	80003cb6 <fileclose+0x9a>

0000000080003cfa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cfa:	715d                	addi	sp,sp,-80
    80003cfc:	e486                	sd	ra,72(sp)
    80003cfe:	e0a2                	sd	s0,64(sp)
    80003d00:	fc26                	sd	s1,56(sp)
    80003d02:	f44e                	sd	s3,40(sp)
    80003d04:	0880                	addi	s0,sp,80
    80003d06:	84aa                	mv	s1,a0
    80003d08:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003d0a:	ffffd097          	auipc	ra,0xffffd
    80003d0e:	38c080e7          	jalr	908(ra) # 80001096 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003d12:	409c                	lw	a5,0(s1)
    80003d14:	37f9                	addiw	a5,a5,-2
    80003d16:	4705                	li	a4,1
    80003d18:	04f76a63          	bltu	a4,a5,80003d6c <filestat+0x72>
    80003d1c:	f84a                	sd	s2,48(sp)
    80003d1e:	f052                	sd	s4,32(sp)
    80003d20:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d22:	6c88                	ld	a0,24(s1)
    80003d24:	fffff097          	auipc	ra,0xfffff
    80003d28:	036080e7          	jalr	54(ra) # 80002d5a <ilock>
    stati(f->ip, &st);
    80003d2c:	fb840a13          	addi	s4,s0,-72
    80003d30:	85d2                	mv	a1,s4
    80003d32:	6c88                	ld	a0,24(s1)
    80003d34:	fffff097          	auipc	ra,0xfffff
    80003d38:	2b4080e7          	jalr	692(ra) # 80002fe8 <stati>
    iunlock(f->ip);
    80003d3c:	6c88                	ld	a0,24(s1)
    80003d3e:	fffff097          	auipc	ra,0xfffff
    80003d42:	0e2080e7          	jalr	226(ra) # 80002e20 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d46:	46e1                	li	a3,24
    80003d48:	8652                	mv	a2,s4
    80003d4a:	85ce                	mv	a1,s3
    80003d4c:	05093503          	ld	a0,80(s2)
    80003d50:	ffffd097          	auipc	ra,0xffffd
    80003d54:	f5e080e7          	jalr	-162(ra) # 80000cae <copyout>
    80003d58:	41f5551b          	sraiw	a0,a0,0x1f
    80003d5c:	7942                	ld	s2,48(sp)
    80003d5e:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003d60:	60a6                	ld	ra,72(sp)
    80003d62:	6406                	ld	s0,64(sp)
    80003d64:	74e2                	ld	s1,56(sp)
    80003d66:	79a2                	ld	s3,40(sp)
    80003d68:	6161                	addi	sp,sp,80
    80003d6a:	8082                	ret
  return -1;
    80003d6c:	557d                	li	a0,-1
    80003d6e:	bfcd                	j	80003d60 <filestat+0x66>

0000000080003d70 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d70:	7179                	addi	sp,sp,-48
    80003d72:	f406                	sd	ra,40(sp)
    80003d74:	f022                	sd	s0,32(sp)
    80003d76:	e84a                	sd	s2,16(sp)
    80003d78:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d7a:	00854783          	lbu	a5,8(a0)
    80003d7e:	cbc5                	beqz	a5,80003e2e <fileread+0xbe>
    80003d80:	ec26                	sd	s1,24(sp)
    80003d82:	e44e                	sd	s3,8(sp)
    80003d84:	84aa                	mv	s1,a0
    80003d86:	89ae                	mv	s3,a1
    80003d88:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d8a:	411c                	lw	a5,0(a0)
    80003d8c:	4705                	li	a4,1
    80003d8e:	04e78963          	beq	a5,a4,80003de0 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d92:	470d                	li	a4,3
    80003d94:	04e78f63          	beq	a5,a4,80003df2 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d98:	4709                	li	a4,2
    80003d9a:	08e79263          	bne	a5,a4,80003e1e <fileread+0xae>
    ilock(f->ip);
    80003d9e:	6d08                	ld	a0,24(a0)
    80003da0:	fffff097          	auipc	ra,0xfffff
    80003da4:	fba080e7          	jalr	-70(ra) # 80002d5a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003da8:	874a                	mv	a4,s2
    80003daa:	5094                	lw	a3,32(s1)
    80003dac:	864e                	mv	a2,s3
    80003dae:	4585                	li	a1,1
    80003db0:	6c88                	ld	a0,24(s1)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	264080e7          	jalr	612(ra) # 80003016 <readi>
    80003dba:	892a                	mv	s2,a0
    80003dbc:	00a05563          	blez	a0,80003dc6 <fileread+0x56>
      f->off += r;
    80003dc0:	509c                	lw	a5,32(s1)
    80003dc2:	9fa9                	addw	a5,a5,a0
    80003dc4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dc6:	6c88                	ld	a0,24(s1)
    80003dc8:	fffff097          	auipc	ra,0xfffff
    80003dcc:	058080e7          	jalr	88(ra) # 80002e20 <iunlock>
    80003dd0:	64e2                	ld	s1,24(sp)
    80003dd2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003dd4:	854a                	mv	a0,s2
    80003dd6:	70a2                	ld	ra,40(sp)
    80003dd8:	7402                	ld	s0,32(sp)
    80003dda:	6942                	ld	s2,16(sp)
    80003ddc:	6145                	addi	sp,sp,48
    80003dde:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003de0:	6908                	ld	a0,16(a0)
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	414080e7          	jalr	1044(ra) # 800041f6 <piperead>
    80003dea:	892a                	mv	s2,a0
    80003dec:	64e2                	ld	s1,24(sp)
    80003dee:	69a2                	ld	s3,8(sp)
    80003df0:	b7d5                	j	80003dd4 <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003df2:	02451783          	lh	a5,36(a0)
    80003df6:	03079693          	slli	a3,a5,0x30
    80003dfa:	92c1                	srli	a3,a3,0x30
    80003dfc:	4725                	li	a4,9
    80003dfe:	02d76a63          	bltu	a4,a3,80003e32 <fileread+0xc2>
    80003e02:	0792                	slli	a5,a5,0x4
    80003e04:	00255717          	auipc	a4,0x255
    80003e08:	2fc70713          	addi	a4,a4,764 # 80259100 <devsw>
    80003e0c:	97ba                	add	a5,a5,a4
    80003e0e:	639c                	ld	a5,0(a5)
    80003e10:	c78d                	beqz	a5,80003e3a <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003e12:	4505                	li	a0,1
    80003e14:	9782                	jalr	a5
    80003e16:	892a                	mv	s2,a0
    80003e18:	64e2                	ld	s1,24(sp)
    80003e1a:	69a2                	ld	s3,8(sp)
    80003e1c:	bf65                	j	80003dd4 <fileread+0x64>
    panic("fileread");
    80003e1e:	00004517          	auipc	a0,0x4
    80003e22:	71a50513          	addi	a0,a0,1818 # 80008538 <etext+0x538>
    80003e26:	00002097          	auipc	ra,0x2
    80003e2a:	0ec080e7          	jalr	236(ra) # 80005f12 <panic>
    return -1;
    80003e2e:	597d                	li	s2,-1
    80003e30:	b755                	j	80003dd4 <fileread+0x64>
      return -1;
    80003e32:	597d                	li	s2,-1
    80003e34:	64e2                	ld	s1,24(sp)
    80003e36:	69a2                	ld	s3,8(sp)
    80003e38:	bf71                	j	80003dd4 <fileread+0x64>
    80003e3a:	597d                	li	s2,-1
    80003e3c:	64e2                	ld	s1,24(sp)
    80003e3e:	69a2                	ld	s3,8(sp)
    80003e40:	bf51                	j	80003dd4 <fileread+0x64>

0000000080003e42 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e42:	00954783          	lbu	a5,9(a0)
    80003e46:	12078c63          	beqz	a5,80003f7e <filewrite+0x13c>
{
    80003e4a:	711d                	addi	sp,sp,-96
    80003e4c:	ec86                	sd	ra,88(sp)
    80003e4e:	e8a2                	sd	s0,80(sp)
    80003e50:	e0ca                	sd	s2,64(sp)
    80003e52:	f456                	sd	s5,40(sp)
    80003e54:	f05a                	sd	s6,32(sp)
    80003e56:	1080                	addi	s0,sp,96
    80003e58:	892a                	mv	s2,a0
    80003e5a:	8b2e                	mv	s6,a1
    80003e5c:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e5e:	411c                	lw	a5,0(a0)
    80003e60:	4705                	li	a4,1
    80003e62:	02e78963          	beq	a5,a4,80003e94 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e66:	470d                	li	a4,3
    80003e68:	02e78c63          	beq	a5,a4,80003ea0 <filewrite+0x5e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e6c:	4709                	li	a4,2
    80003e6e:	0ee79a63          	bne	a5,a4,80003f62 <filewrite+0x120>
    80003e72:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e74:	0cc05563          	blez	a2,80003f3e <filewrite+0xfc>
    80003e78:	e4a6                	sd	s1,72(sp)
    80003e7a:	fc4e                	sd	s3,56(sp)
    80003e7c:	ec5e                	sd	s7,24(sp)
    80003e7e:	e862                	sd	s8,16(sp)
    80003e80:	e466                	sd	s9,8(sp)
    int i = 0;
    80003e82:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003e84:	6b85                	lui	s7,0x1
    80003e86:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e8a:	6c85                	lui	s9,0x1
    80003e8c:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e90:	4c05                	li	s8,1
    80003e92:	a849                	j	80003f24 <filewrite+0xe2>
    ret = pipewrite(f->pipe, addr, n);
    80003e94:	6908                	ld	a0,16(a0)
    80003e96:	00000097          	auipc	ra,0x0
    80003e9a:	24a080e7          	jalr	586(ra) # 800040e0 <pipewrite>
    80003e9e:	a85d                	j	80003f54 <filewrite+0x112>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003ea0:	02451783          	lh	a5,36(a0)
    80003ea4:	03079693          	slli	a3,a5,0x30
    80003ea8:	92c1                	srli	a3,a3,0x30
    80003eaa:	4725                	li	a4,9
    80003eac:	0cd76b63          	bltu	a4,a3,80003f82 <filewrite+0x140>
    80003eb0:	0792                	slli	a5,a5,0x4
    80003eb2:	00255717          	auipc	a4,0x255
    80003eb6:	24e70713          	addi	a4,a4,590 # 80259100 <devsw>
    80003eba:	97ba                	add	a5,a5,a4
    80003ebc:	679c                	ld	a5,8(a5)
    80003ebe:	c7e1                	beqz	a5,80003f86 <filewrite+0x144>
    ret = devsw[f->major].write(1, addr, n);
    80003ec0:	4505                	li	a0,1
    80003ec2:	9782                	jalr	a5
    80003ec4:	a841                	j	80003f54 <filewrite+0x112>
      if(n1 > max)
    80003ec6:	2981                	sext.w	s3,s3
      begin_op();
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	884080e7          	jalr	-1916(ra) # 8000374c <begin_op>
      ilock(f->ip);
    80003ed0:	01893503          	ld	a0,24(s2)
    80003ed4:	fffff097          	auipc	ra,0xfffff
    80003ed8:	e86080e7          	jalr	-378(ra) # 80002d5a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003edc:	874e                	mv	a4,s3
    80003ede:	02092683          	lw	a3,32(s2)
    80003ee2:	016a0633          	add	a2,s4,s6
    80003ee6:	85e2                	mv	a1,s8
    80003ee8:	01893503          	ld	a0,24(s2)
    80003eec:	fffff097          	auipc	ra,0xfffff
    80003ef0:	224080e7          	jalr	548(ra) # 80003110 <writei>
    80003ef4:	84aa                	mv	s1,a0
    80003ef6:	00a05763          	blez	a0,80003f04 <filewrite+0xc2>
        f->off += r;
    80003efa:	02092783          	lw	a5,32(s2)
    80003efe:	9fa9                	addw	a5,a5,a0
    80003f00:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003f04:	01893503          	ld	a0,24(s2)
    80003f08:	fffff097          	auipc	ra,0xfffff
    80003f0c:	f18080e7          	jalr	-232(ra) # 80002e20 <iunlock>
      end_op();
    80003f10:	00000097          	auipc	ra,0x0
    80003f14:	8b6080e7          	jalr	-1866(ra) # 800037c6 <end_op>

      if(r != n1){
    80003f18:	02999563          	bne	s3,s1,80003f42 <filewrite+0x100>
        // error from writei
        break;
      }
      i += r;
    80003f1c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003f20:	015a5963          	bge	s4,s5,80003f32 <filewrite+0xf0>
      int n1 = n - i;
    80003f24:	414a87bb          	subw	a5,s5,s4
    80003f28:	89be                	mv	s3,a5
      if(n1 > max)
    80003f2a:	f8fbdee3          	bge	s7,a5,80003ec6 <filewrite+0x84>
    80003f2e:	89e6                	mv	s3,s9
    80003f30:	bf59                	j	80003ec6 <filewrite+0x84>
    80003f32:	64a6                	ld	s1,72(sp)
    80003f34:	79e2                	ld	s3,56(sp)
    80003f36:	6be2                	ld	s7,24(sp)
    80003f38:	6c42                	ld	s8,16(sp)
    80003f3a:	6ca2                	ld	s9,8(sp)
    80003f3c:	a801                	j	80003f4c <filewrite+0x10a>
    int i = 0;
    80003f3e:	4a01                	li	s4,0
    80003f40:	a031                	j	80003f4c <filewrite+0x10a>
    80003f42:	64a6                	ld	s1,72(sp)
    80003f44:	79e2                	ld	s3,56(sp)
    80003f46:	6be2                	ld	s7,24(sp)
    80003f48:	6c42                	ld	s8,16(sp)
    80003f4a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003f4c:	034a9f63          	bne	s5,s4,80003f8a <filewrite+0x148>
    80003f50:	8556                	mv	a0,s5
    80003f52:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f54:	60e6                	ld	ra,88(sp)
    80003f56:	6446                	ld	s0,80(sp)
    80003f58:	6906                	ld	s2,64(sp)
    80003f5a:	7aa2                	ld	s5,40(sp)
    80003f5c:	7b02                	ld	s6,32(sp)
    80003f5e:	6125                	addi	sp,sp,96
    80003f60:	8082                	ret
    80003f62:	e4a6                	sd	s1,72(sp)
    80003f64:	fc4e                	sd	s3,56(sp)
    80003f66:	f852                	sd	s4,48(sp)
    80003f68:	ec5e                	sd	s7,24(sp)
    80003f6a:	e862                	sd	s8,16(sp)
    80003f6c:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003f6e:	00004517          	auipc	a0,0x4
    80003f72:	5da50513          	addi	a0,a0,1498 # 80008548 <etext+0x548>
    80003f76:	00002097          	auipc	ra,0x2
    80003f7a:	f9c080e7          	jalr	-100(ra) # 80005f12 <panic>
    return -1;
    80003f7e:	557d                	li	a0,-1
}
    80003f80:	8082                	ret
      return -1;
    80003f82:	557d                	li	a0,-1
    80003f84:	bfc1                	j	80003f54 <filewrite+0x112>
    80003f86:	557d                	li	a0,-1
    80003f88:	b7f1                	j	80003f54 <filewrite+0x112>
    ret = (i == n ? n : -1);
    80003f8a:	557d                	li	a0,-1
    80003f8c:	7a42                	ld	s4,48(sp)
    80003f8e:	b7d9                	j	80003f54 <filewrite+0x112>

0000000080003f90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f90:	7179                	addi	sp,sp,-48
    80003f92:	f406                	sd	ra,40(sp)
    80003f94:	f022                	sd	s0,32(sp)
    80003f96:	ec26                	sd	s1,24(sp)
    80003f98:	e052                	sd	s4,0(sp)
    80003f9a:	1800                	addi	s0,sp,48
    80003f9c:	84aa                	mv	s1,a0
    80003f9e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003fa0:	0005b023          	sd	zero,0(a1)
    80003fa4:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003fa8:	00000097          	auipc	ra,0x0
    80003fac:	bb8080e7          	jalr	-1096(ra) # 80003b60 <filealloc>
    80003fb0:	e088                	sd	a0,0(s1)
    80003fb2:	cd49                	beqz	a0,8000404c <pipealloc+0xbc>
    80003fb4:	00000097          	auipc	ra,0x0
    80003fb8:	bac080e7          	jalr	-1108(ra) # 80003b60 <filealloc>
    80003fbc:	00aa3023          	sd	a0,0(s4)
    80003fc0:	c141                	beqz	a0,80004040 <pipealloc+0xb0>
    80003fc2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fc4:	ffffc097          	auipc	ra,0xffffc
    80003fc8:	25a080e7          	jalr	602(ra) # 8000021e <kalloc>
    80003fcc:	892a                	mv	s2,a0
    80003fce:	c13d                	beqz	a0,80004034 <pipealloc+0xa4>
    80003fd0:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003fd2:	4985                	li	s3,1
    80003fd4:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003fd8:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003fdc:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003fe0:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fe4:	00004597          	auipc	a1,0x4
    80003fe8:	57458593          	addi	a1,a1,1396 # 80008558 <etext+0x558>
    80003fec:	00002097          	auipc	ra,0x2
    80003ff0:	412080e7          	jalr	1042(ra) # 800063fe <initlock>
  (*f0)->type = FD_PIPE;
    80003ff4:	609c                	ld	a5,0(s1)
    80003ff6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ffa:	609c                	ld	a5,0(s1)
    80003ffc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004000:	609c                	ld	a5,0(s1)
    80004002:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004006:	609c                	ld	a5,0(s1)
    80004008:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000400c:	000a3783          	ld	a5,0(s4)
    80004010:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004014:	000a3783          	ld	a5,0(s4)
    80004018:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000401c:	000a3783          	ld	a5,0(s4)
    80004020:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004024:	000a3783          	ld	a5,0(s4)
    80004028:	0127b823          	sd	s2,16(a5)
  return 0;
    8000402c:	4501                	li	a0,0
    8000402e:	6942                	ld	s2,16(sp)
    80004030:	69a2                	ld	s3,8(sp)
    80004032:	a03d                	j	80004060 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004034:	6088                	ld	a0,0(s1)
    80004036:	c119                	beqz	a0,8000403c <pipealloc+0xac>
    80004038:	6942                	ld	s2,16(sp)
    8000403a:	a029                	j	80004044 <pipealloc+0xb4>
    8000403c:	6942                	ld	s2,16(sp)
    8000403e:	a039                	j	8000404c <pipealloc+0xbc>
    80004040:	6088                	ld	a0,0(s1)
    80004042:	c50d                	beqz	a0,8000406c <pipealloc+0xdc>
    fileclose(*f0);
    80004044:	00000097          	auipc	ra,0x0
    80004048:	bd8080e7          	jalr	-1064(ra) # 80003c1c <fileclose>
  if(*f1)
    8000404c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004050:	557d                	li	a0,-1
  if(*f1)
    80004052:	c799                	beqz	a5,80004060 <pipealloc+0xd0>
    fileclose(*f1);
    80004054:	853e                	mv	a0,a5
    80004056:	00000097          	auipc	ra,0x0
    8000405a:	bc6080e7          	jalr	-1082(ra) # 80003c1c <fileclose>
  return -1;
    8000405e:	557d                	li	a0,-1
}
    80004060:	70a2                	ld	ra,40(sp)
    80004062:	7402                	ld	s0,32(sp)
    80004064:	64e2                	ld	s1,24(sp)
    80004066:	6a02                	ld	s4,0(sp)
    80004068:	6145                	addi	sp,sp,48
    8000406a:	8082                	ret
  return -1;
    8000406c:	557d                	li	a0,-1
    8000406e:	bfcd                	j	80004060 <pipealloc+0xd0>

0000000080004070 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004070:	1101                	addi	sp,sp,-32
    80004072:	ec06                	sd	ra,24(sp)
    80004074:	e822                	sd	s0,16(sp)
    80004076:	e426                	sd	s1,8(sp)
    80004078:	e04a                	sd	s2,0(sp)
    8000407a:	1000                	addi	s0,sp,32
    8000407c:	84aa                	mv	s1,a0
    8000407e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004080:	00002097          	auipc	ra,0x2
    80004084:	412080e7          	jalr	1042(ra) # 80006492 <acquire>
  if(writable){
    80004088:	02090d63          	beqz	s2,800040c2 <pipeclose+0x52>
    pi->writeopen = 0;
    8000408c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004090:	21848513          	addi	a0,s1,536
    80004094:	ffffe097          	auipc	ra,0xffffe
    80004098:	84e080e7          	jalr	-1970(ra) # 800018e2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000409c:	2204b783          	ld	a5,544(s1)
    800040a0:	eb95                	bnez	a5,800040d4 <pipeclose+0x64>
    release(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	49e080e7          	jalr	1182(ra) # 80006542 <release>
    kfree((char*)pi);
    800040ac:	8526                	mv	a0,s1
    800040ae:	ffffc097          	auipc	ra,0xffffc
    800040b2:	006080e7          	jalr	6(ra) # 800000b4 <kfree>
  } else
    release(&pi->lock);
}
    800040b6:	60e2                	ld	ra,24(sp)
    800040b8:	6442                	ld	s0,16(sp)
    800040ba:	64a2                	ld	s1,8(sp)
    800040bc:	6902                	ld	s2,0(sp)
    800040be:	6105                	addi	sp,sp,32
    800040c0:	8082                	ret
    pi->readopen = 0;
    800040c2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040c6:	21c48513          	addi	a0,s1,540
    800040ca:	ffffe097          	auipc	ra,0xffffe
    800040ce:	818080e7          	jalr	-2024(ra) # 800018e2 <wakeup>
    800040d2:	b7e9                	j	8000409c <pipeclose+0x2c>
    release(&pi->lock);
    800040d4:	8526                	mv	a0,s1
    800040d6:	00002097          	auipc	ra,0x2
    800040da:	46c080e7          	jalr	1132(ra) # 80006542 <release>
}
    800040de:	bfe1                	j	800040b6 <pipeclose+0x46>

00000000800040e0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040e0:	7159                	addi	sp,sp,-112
    800040e2:	f486                	sd	ra,104(sp)
    800040e4:	f0a2                	sd	s0,96(sp)
    800040e6:	eca6                	sd	s1,88(sp)
    800040e8:	e8ca                	sd	s2,80(sp)
    800040ea:	e4ce                	sd	s3,72(sp)
    800040ec:	e0d2                	sd	s4,64(sp)
    800040ee:	fc56                	sd	s5,56(sp)
    800040f0:	1880                	addi	s0,sp,112
    800040f2:	84aa                	mv	s1,a0
    800040f4:	8aae                	mv	s5,a1
    800040f6:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040f8:	ffffd097          	auipc	ra,0xffffd
    800040fc:	f9e080e7          	jalr	-98(ra) # 80001096 <myproc>
    80004100:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004102:	8526                	mv	a0,s1
    80004104:	00002097          	auipc	ra,0x2
    80004108:	38e080e7          	jalr	910(ra) # 80006492 <acquire>
  while(i < n){
    8000410c:	0d405d63          	blez	s4,800041e6 <pipewrite+0x106>
    80004110:	f85a                	sd	s6,48(sp)
    80004112:	f45e                	sd	s7,40(sp)
    80004114:	f062                	sd	s8,32(sp)
    80004116:	ec66                	sd	s9,24(sp)
    80004118:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000411a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000411c:	f9f40c13          	addi	s8,s0,-97
    80004120:	4b85                	li	s7,1
    80004122:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004124:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004128:	21c48c93          	addi	s9,s1,540
    8000412c:	a099                	j	80004172 <pipewrite+0x92>
      release(&pi->lock);
    8000412e:	8526                	mv	a0,s1
    80004130:	00002097          	auipc	ra,0x2
    80004134:	412080e7          	jalr	1042(ra) # 80006542 <release>
      return -1;
    80004138:	597d                	li	s2,-1
    8000413a:	7b42                	ld	s6,48(sp)
    8000413c:	7ba2                	ld	s7,40(sp)
    8000413e:	7c02                	ld	s8,32(sp)
    80004140:	6ce2                	ld	s9,24(sp)
    80004142:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004144:	854a                	mv	a0,s2
    80004146:	70a6                	ld	ra,104(sp)
    80004148:	7406                	ld	s0,96(sp)
    8000414a:	64e6                	ld	s1,88(sp)
    8000414c:	6946                	ld	s2,80(sp)
    8000414e:	69a6                	ld	s3,72(sp)
    80004150:	6a06                	ld	s4,64(sp)
    80004152:	7ae2                	ld	s5,56(sp)
    80004154:	6165                	addi	sp,sp,112
    80004156:	8082                	ret
      wakeup(&pi->nread);
    80004158:	856a                	mv	a0,s10
    8000415a:	ffffd097          	auipc	ra,0xffffd
    8000415e:	788080e7          	jalr	1928(ra) # 800018e2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004162:	85a6                	mv	a1,s1
    80004164:	8566                	mv	a0,s9
    80004166:	ffffd097          	auipc	ra,0xffffd
    8000416a:	5f6080e7          	jalr	1526(ra) # 8000175c <sleep>
  while(i < n){
    8000416e:	05495b63          	bge	s2,s4,800041c4 <pipewrite+0xe4>
    if(pi->readopen == 0 || pr->killed){
    80004172:	2204a783          	lw	a5,544(s1)
    80004176:	dfc5                	beqz	a5,8000412e <pipewrite+0x4e>
    80004178:	0289a783          	lw	a5,40(s3)
    8000417c:	fbcd                	bnez	a5,8000412e <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000417e:	2184a783          	lw	a5,536(s1)
    80004182:	21c4a703          	lw	a4,540(s1)
    80004186:	2007879b          	addiw	a5,a5,512
    8000418a:	fcf707e3          	beq	a4,a5,80004158 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000418e:	86de                	mv	a3,s7
    80004190:	01590633          	add	a2,s2,s5
    80004194:	85e2                	mv	a1,s8
    80004196:	0509b503          	ld	a0,80(s3)
    8000419a:	ffffd097          	auipc	ra,0xffffd
    8000419e:	c34080e7          	jalr	-972(ra) # 80000dce <copyin>
    800041a2:	05650463          	beq	a0,s6,800041ea <pipewrite+0x10a>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800041a6:	21c4a783          	lw	a5,540(s1)
    800041aa:	0017871b          	addiw	a4,a5,1
    800041ae:	20e4ae23          	sw	a4,540(s1)
    800041b2:	1ff7f793          	andi	a5,a5,511
    800041b6:	97a6                	add	a5,a5,s1
    800041b8:	f9f44703          	lbu	a4,-97(s0)
    800041bc:	00e78c23          	sb	a4,24(a5)
      i++;
    800041c0:	2905                	addiw	s2,s2,1
    800041c2:	b775                	j	8000416e <pipewrite+0x8e>
    800041c4:	7b42                	ld	s6,48(sp)
    800041c6:	7ba2                	ld	s7,40(sp)
    800041c8:	7c02                	ld	s8,32(sp)
    800041ca:	6ce2                	ld	s9,24(sp)
    800041cc:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800041ce:	21848513          	addi	a0,s1,536
    800041d2:	ffffd097          	auipc	ra,0xffffd
    800041d6:	710080e7          	jalr	1808(ra) # 800018e2 <wakeup>
  release(&pi->lock);
    800041da:	8526                	mv	a0,s1
    800041dc:	00002097          	auipc	ra,0x2
    800041e0:	366080e7          	jalr	870(ra) # 80006542 <release>
  return i;
    800041e4:	b785                	j	80004144 <pipewrite+0x64>
  int i = 0;
    800041e6:	4901                	li	s2,0
    800041e8:	b7dd                	j	800041ce <pipewrite+0xee>
    800041ea:	7b42                	ld	s6,48(sp)
    800041ec:	7ba2                	ld	s7,40(sp)
    800041ee:	7c02                	ld	s8,32(sp)
    800041f0:	6ce2                	ld	s9,24(sp)
    800041f2:	6d42                	ld	s10,16(sp)
    800041f4:	bfe9                	j	800041ce <pipewrite+0xee>

00000000800041f6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041f6:	711d                	addi	sp,sp,-96
    800041f8:	ec86                	sd	ra,88(sp)
    800041fa:	e8a2                	sd	s0,80(sp)
    800041fc:	e4a6                	sd	s1,72(sp)
    800041fe:	e0ca                	sd	s2,64(sp)
    80004200:	fc4e                	sd	s3,56(sp)
    80004202:	f852                	sd	s4,48(sp)
    80004204:	f456                	sd	s5,40(sp)
    80004206:	1080                	addi	s0,sp,96
    80004208:	84aa                	mv	s1,a0
    8000420a:	892e                	mv	s2,a1
    8000420c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000420e:	ffffd097          	auipc	ra,0xffffd
    80004212:	e88080e7          	jalr	-376(ra) # 80001096 <myproc>
    80004216:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004218:	8526                	mv	a0,s1
    8000421a:	00002097          	auipc	ra,0x2
    8000421e:	278080e7          	jalr	632(ra) # 80006492 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004222:	2184a703          	lw	a4,536(s1)
    80004226:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000422a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000422e:	02f71863          	bne	a4,a5,8000425e <piperead+0x68>
    80004232:	2244a783          	lw	a5,548(s1)
    80004236:	cf9d                	beqz	a5,80004274 <piperead+0x7e>
    if(pr->killed){
    80004238:	028a2783          	lw	a5,40(s4)
    8000423c:	e78d                	bnez	a5,80004266 <piperead+0x70>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000423e:	85a6                	mv	a1,s1
    80004240:	854e                	mv	a0,s3
    80004242:	ffffd097          	auipc	ra,0xffffd
    80004246:	51a080e7          	jalr	1306(ra) # 8000175c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000424a:	2184a703          	lw	a4,536(s1)
    8000424e:	21c4a783          	lw	a5,540(s1)
    80004252:	fef700e3          	beq	a4,a5,80004232 <piperead+0x3c>
    80004256:	f05a                	sd	s6,32(sp)
    80004258:	ec5e                	sd	s7,24(sp)
    8000425a:	e862                	sd	s8,16(sp)
    8000425c:	a839                	j	8000427a <piperead+0x84>
    8000425e:	f05a                	sd	s6,32(sp)
    80004260:	ec5e                	sd	s7,24(sp)
    80004262:	e862                	sd	s8,16(sp)
    80004264:	a819                	j	8000427a <piperead+0x84>
      release(&pi->lock);
    80004266:	8526                	mv	a0,s1
    80004268:	00002097          	auipc	ra,0x2
    8000426c:	2da080e7          	jalr	730(ra) # 80006542 <release>
      return -1;
    80004270:	59fd                	li	s3,-1
    80004272:	a895                	j	800042e6 <piperead+0xf0>
    80004274:	f05a                	sd	s6,32(sp)
    80004276:	ec5e                	sd	s7,24(sp)
    80004278:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000427a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000427c:	faf40c13          	addi	s8,s0,-81
    80004280:	4b85                	li	s7,1
    80004282:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004284:	05505363          	blez	s5,800042ca <piperead+0xd4>
    if(pi->nread == pi->nwrite)
    80004288:	2184a783          	lw	a5,536(s1)
    8000428c:	21c4a703          	lw	a4,540(s1)
    80004290:	02f70d63          	beq	a4,a5,800042ca <piperead+0xd4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004294:	0017871b          	addiw	a4,a5,1
    80004298:	20e4ac23          	sw	a4,536(s1)
    8000429c:	1ff7f793          	andi	a5,a5,511
    800042a0:	97a6                	add	a5,a5,s1
    800042a2:	0187c783          	lbu	a5,24(a5)
    800042a6:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042aa:	86de                	mv	a3,s7
    800042ac:	8662                	mv	a2,s8
    800042ae:	85ca                	mv	a1,s2
    800042b0:	050a3503          	ld	a0,80(s4)
    800042b4:	ffffd097          	auipc	ra,0xffffd
    800042b8:	9fa080e7          	jalr	-1542(ra) # 80000cae <copyout>
    800042bc:	01650763          	beq	a0,s6,800042ca <piperead+0xd4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042c0:	2985                	addiw	s3,s3,1
    800042c2:	0905                	addi	s2,s2,1
    800042c4:	fd3a92e3          	bne	s5,s3,80004288 <piperead+0x92>
    800042c8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800042ca:	21c48513          	addi	a0,s1,540
    800042ce:	ffffd097          	auipc	ra,0xffffd
    800042d2:	614080e7          	jalr	1556(ra) # 800018e2 <wakeup>
  release(&pi->lock);
    800042d6:	8526                	mv	a0,s1
    800042d8:	00002097          	auipc	ra,0x2
    800042dc:	26a080e7          	jalr	618(ra) # 80006542 <release>
    800042e0:	7b02                	ld	s6,32(sp)
    800042e2:	6be2                	ld	s7,24(sp)
    800042e4:	6c42                	ld	s8,16(sp)
  return i;
}
    800042e6:	854e                	mv	a0,s3
    800042e8:	60e6                	ld	ra,88(sp)
    800042ea:	6446                	ld	s0,80(sp)
    800042ec:	64a6                	ld	s1,72(sp)
    800042ee:	6906                	ld	s2,64(sp)
    800042f0:	79e2                	ld	s3,56(sp)
    800042f2:	7a42                	ld	s4,48(sp)
    800042f4:	7aa2                	ld	s5,40(sp)
    800042f6:	6125                	addi	sp,sp,96
    800042f8:	8082                	ret

00000000800042fa <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042fa:	de010113          	addi	sp,sp,-544
    800042fe:	20113c23          	sd	ra,536(sp)
    80004302:	20813823          	sd	s0,528(sp)
    80004306:	20913423          	sd	s1,520(sp)
    8000430a:	21213023          	sd	s2,512(sp)
    8000430e:	1400                	addi	s0,sp,544
    80004310:	892a                	mv	s2,a0
    80004312:	dea43823          	sd	a0,-528(s0)
    80004316:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000431a:	ffffd097          	auipc	ra,0xffffd
    8000431e:	d7c080e7          	jalr	-644(ra) # 80001096 <myproc>
    80004322:	84aa                	mv	s1,a0

  begin_op();
    80004324:	fffff097          	auipc	ra,0xfffff
    80004328:	428080e7          	jalr	1064(ra) # 8000374c <begin_op>

  if((ip = namei(path)) == 0){
    8000432c:	854a                	mv	a0,s2
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	218080e7          	jalr	536(ra) # 80003546 <namei>
    80004336:	c525                	beqz	a0,8000439e <exec+0xa4>
    80004338:	fbd2                	sd	s4,496(sp)
    8000433a:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000433c:	fffff097          	auipc	ra,0xfffff
    80004340:	a1e080e7          	jalr	-1506(ra) # 80002d5a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004344:	04000713          	li	a4,64
    80004348:	4681                	li	a3,0
    8000434a:	e5040613          	addi	a2,s0,-432
    8000434e:	4581                	li	a1,0
    80004350:	8552                	mv	a0,s4
    80004352:	fffff097          	auipc	ra,0xfffff
    80004356:	cc4080e7          	jalr	-828(ra) # 80003016 <readi>
    8000435a:	04000793          	li	a5,64
    8000435e:	00f51a63          	bne	a0,a5,80004372 <exec+0x78>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004362:	e5042703          	lw	a4,-432(s0)
    80004366:	464c47b7          	lui	a5,0x464c4
    8000436a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000436e:	02f70e63          	beq	a4,a5,800043aa <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004372:	8552                	mv	a0,s4
    80004374:	fffff097          	auipc	ra,0xfffff
    80004378:	c4c080e7          	jalr	-948(ra) # 80002fc0 <iunlockput>
    end_op();
    8000437c:	fffff097          	auipc	ra,0xfffff
    80004380:	44a080e7          	jalr	1098(ra) # 800037c6 <end_op>
  }
  return -1;
    80004384:	557d                	li	a0,-1
    80004386:	7a5e                	ld	s4,496(sp)
}
    80004388:	21813083          	ld	ra,536(sp)
    8000438c:	21013403          	ld	s0,528(sp)
    80004390:	20813483          	ld	s1,520(sp)
    80004394:	20013903          	ld	s2,512(sp)
    80004398:	22010113          	addi	sp,sp,544
    8000439c:	8082                	ret
    end_op();
    8000439e:	fffff097          	auipc	ra,0xfffff
    800043a2:	428080e7          	jalr	1064(ra) # 800037c6 <end_op>
    return -1;
    800043a6:	557d                	li	a0,-1
    800043a8:	b7c5                	j	80004388 <exec+0x8e>
    800043aa:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800043ac:	8526                	mv	a0,s1
    800043ae:	ffffd097          	auipc	ra,0xffffd
    800043b2:	dac080e7          	jalr	-596(ra) # 8000115a <proc_pagetable>
    800043b6:	8b2a                	mv	s6,a0
    800043b8:	2a050863          	beqz	a0,80004668 <exec+0x36e>
    800043bc:	ffce                	sd	s3,504(sp)
    800043be:	f7d6                	sd	s5,488(sp)
    800043c0:	efde                	sd	s7,472(sp)
    800043c2:	ebe2                	sd	s8,464(sp)
    800043c4:	e7e6                	sd	s9,456(sp)
    800043c6:	e3ea                	sd	s10,448(sp)
    800043c8:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043ca:	e7042683          	lw	a3,-400(s0)
    800043ce:	e8845783          	lhu	a5,-376(s0)
    800043d2:	cbfd                	beqz	a5,800044c8 <exec+0x1ce>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043d4:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043d6:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800043d8:	03800d93          	li	s11,56
    if((ph.vaddr % PGSIZE) != 0)
    800043dc:	6c85                	lui	s9,0x1
    800043de:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800043e2:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800043e6:	6a85                	lui	s5,0x1
    800043e8:	a0b5                	j	80004454 <exec+0x15a>
      panic("loadseg: address should exist");
    800043ea:	00004517          	auipc	a0,0x4
    800043ee:	17650513          	addi	a0,a0,374 # 80008560 <etext+0x560>
    800043f2:	00002097          	auipc	ra,0x2
    800043f6:	b20080e7          	jalr	-1248(ra) # 80005f12 <panic>
    if(sz - i < PGSIZE)
    800043fa:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043fc:	874a                	mv	a4,s2
    800043fe:	009c06bb          	addw	a3,s8,s1
    80004402:	4581                	li	a1,0
    80004404:	8552                	mv	a0,s4
    80004406:	fffff097          	auipc	ra,0xfffff
    8000440a:	c10080e7          	jalr	-1008(ra) # 80003016 <readi>
    8000440e:	26a91163          	bne	s2,a0,80004670 <exec+0x376>
  for(i = 0; i < sz; i += PGSIZE){
    80004412:	009a84bb          	addw	s1,s5,s1
    80004416:	0334f463          	bgeu	s1,s3,8000443e <exec+0x144>
    pa = walkaddr(pagetable, va + i);
    8000441a:	02049593          	slli	a1,s1,0x20
    8000441e:	9181                	srli	a1,a1,0x20
    80004420:	95de                	add	a1,a1,s7
    80004422:	855a                	mv	a0,s6
    80004424:	ffffc097          	auipc	ra,0xffffc
    80004428:	232080e7          	jalr	562(ra) # 80000656 <walkaddr>
    8000442c:	862a                	mv	a2,a0
    if(pa == 0)
    8000442e:	dd55                	beqz	a0,800043ea <exec+0xf0>
    if(sz - i < PGSIZE)
    80004430:	409987bb          	subw	a5,s3,s1
    80004434:	893e                	mv	s2,a5
    80004436:	fcfcf2e3          	bgeu	s9,a5,800043fa <exec+0x100>
    8000443a:	8956                	mv	s2,s5
    8000443c:	bf7d                	j	800043fa <exec+0x100>
    sz = sz1;
    8000443e:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004442:	2d05                	addiw	s10,s10,1
    80004444:	e0843783          	ld	a5,-504(s0)
    80004448:	0387869b          	addiw	a3,a5,56
    8000444c:	e8845783          	lhu	a5,-376(s0)
    80004450:	06fd5d63          	bge	s10,a5,800044ca <exec+0x1d0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004454:	e0d43423          	sd	a3,-504(s0)
    80004458:	876e                	mv	a4,s11
    8000445a:	e1840613          	addi	a2,s0,-488
    8000445e:	4581                	li	a1,0
    80004460:	8552                	mv	a0,s4
    80004462:	fffff097          	auipc	ra,0xfffff
    80004466:	bb4080e7          	jalr	-1100(ra) # 80003016 <readi>
    8000446a:	21b51163          	bne	a0,s11,8000466c <exec+0x372>
    if(ph.type != ELF_PROG_LOAD)
    8000446e:	e1842783          	lw	a5,-488(s0)
    80004472:	4705                	li	a4,1
    80004474:	fce797e3          	bne	a5,a4,80004442 <exec+0x148>
    if(ph.memsz < ph.filesz)
    80004478:	e4043603          	ld	a2,-448(s0)
    8000447c:	e3843783          	ld	a5,-456(s0)
    80004480:	20f66863          	bltu	a2,a5,80004690 <exec+0x396>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004484:	e2843783          	ld	a5,-472(s0)
    80004488:	963e                	add	a2,a2,a5
    8000448a:	20f66663          	bltu	a2,a5,80004696 <exec+0x39c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000448e:	85a6                	mv	a1,s1
    80004490:	855a                	mv	a0,s6
    80004492:	ffffc097          	auipc	ra,0xffffc
    80004496:	588080e7          	jalr	1416(ra) # 80000a1a <uvmalloc>
    8000449a:	dea43c23          	sd	a0,-520(s0)
    8000449e:	1e050f63          	beqz	a0,8000469c <exec+0x3a2>
    if((ph.vaddr % PGSIZE) != 0)
    800044a2:	e2843b83          	ld	s7,-472(s0)
    800044a6:	de843783          	ld	a5,-536(s0)
    800044aa:	00fbf7b3          	and	a5,s7,a5
    800044ae:	1c079163          	bnez	a5,80004670 <exec+0x376>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044b2:	e2042c03          	lw	s8,-480(s0)
    800044b6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044ba:	00098463          	beqz	s3,800044c2 <exec+0x1c8>
    800044be:	4481                	li	s1,0
    800044c0:	bfa9                	j	8000441a <exec+0x120>
    sz = sz1;
    800044c2:	df843483          	ld	s1,-520(s0)
    800044c6:	bfb5                	j	80004442 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044c8:	4481                	li	s1,0
  iunlockput(ip);
    800044ca:	8552                	mv	a0,s4
    800044cc:	fffff097          	auipc	ra,0xfffff
    800044d0:	af4080e7          	jalr	-1292(ra) # 80002fc0 <iunlockput>
  end_op();
    800044d4:	fffff097          	auipc	ra,0xfffff
    800044d8:	2f2080e7          	jalr	754(ra) # 800037c6 <end_op>
  p = myproc();
    800044dc:	ffffd097          	auipc	ra,0xffffd
    800044e0:	bba080e7          	jalr	-1094(ra) # 80001096 <myproc>
    800044e4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800044e6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800044ea:	6985                	lui	s3,0x1
    800044ec:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800044ee:	99a6                	add	s3,s3,s1
    800044f0:	77fd                	lui	a5,0xfffff
    800044f2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044f6:	6609                	lui	a2,0x2
    800044f8:	964e                	add	a2,a2,s3
    800044fa:	85ce                	mv	a1,s3
    800044fc:	855a                	mv	a0,s6
    800044fe:	ffffc097          	auipc	ra,0xffffc
    80004502:	51c080e7          	jalr	1308(ra) # 80000a1a <uvmalloc>
    80004506:	8a2a                	mv	s4,a0
    80004508:	e115                	bnez	a0,8000452c <exec+0x232>
    proc_freepagetable(pagetable, sz);
    8000450a:	85ce                	mv	a1,s3
    8000450c:	855a                	mv	a0,s6
    8000450e:	ffffd097          	auipc	ra,0xffffd
    80004512:	ce8080e7          	jalr	-792(ra) # 800011f6 <proc_freepagetable>
  return -1;
    80004516:	557d                	li	a0,-1
    80004518:	79fe                	ld	s3,504(sp)
    8000451a:	7a5e                	ld	s4,496(sp)
    8000451c:	7abe                	ld	s5,488(sp)
    8000451e:	7b1e                	ld	s6,480(sp)
    80004520:	6bfe                	ld	s7,472(sp)
    80004522:	6c5e                	ld	s8,464(sp)
    80004524:	6cbe                	ld	s9,456(sp)
    80004526:	6d1e                	ld	s10,448(sp)
    80004528:	7dfa                	ld	s11,440(sp)
    8000452a:	bdb9                	j	80004388 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000452c:	75f9                	lui	a1,0xffffe
    8000452e:	95aa                	add	a1,a1,a0
    80004530:	855a                	mv	a0,s6
    80004532:	ffffc097          	auipc	ra,0xffffc
    80004536:	74a080e7          	jalr	1866(ra) # 80000c7c <uvmclear>
  stackbase = sp - PGSIZE;
    8000453a:	7bfd                	lui	s7,0xfffff
    8000453c:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    8000453e:	e0043783          	ld	a5,-512(s0)
    80004542:	6388                	ld	a0,0(a5)
  sp = sz;
    80004544:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004546:	4481                	li	s1,0
    ustack[argc] = sp;
    80004548:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    8000454c:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004550:	c135                	beqz	a0,800045b4 <exec+0x2ba>
    sp -= strlen(argv[argc]) + 1;
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	ef2080e7          	jalr	-270(ra) # 80000444 <strlen>
    8000455a:	0015079b          	addiw	a5,a0,1
    8000455e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004562:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004566:	13796e63          	bltu	s2,s7,800046a2 <exec+0x3a8>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000456a:	e0043d83          	ld	s11,-512(s0)
    8000456e:	000db983          	ld	s3,0(s11) # fffffffffffff000 <end+0xffffffff7fd98dc0>
    80004572:	854e                	mv	a0,s3
    80004574:	ffffc097          	auipc	ra,0xffffc
    80004578:	ed0080e7          	jalr	-304(ra) # 80000444 <strlen>
    8000457c:	0015069b          	addiw	a3,a0,1
    80004580:	864e                	mv	a2,s3
    80004582:	85ca                	mv	a1,s2
    80004584:	855a                	mv	a0,s6
    80004586:	ffffc097          	auipc	ra,0xffffc
    8000458a:	728080e7          	jalr	1832(ra) # 80000cae <copyout>
    8000458e:	10054c63          	bltz	a0,800046a6 <exec+0x3ac>
    ustack[argc] = sp;
    80004592:	00349793          	slli	a5,s1,0x3
    80004596:	97e6                	add	a5,a5,s9
    80004598:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7fd98dc0>
  for(argc = 0; argv[argc]; argc++) {
    8000459c:	0485                	addi	s1,s1,1
    8000459e:	008d8793          	addi	a5,s11,8
    800045a2:	e0f43023          	sd	a5,-512(s0)
    800045a6:	008db503          	ld	a0,8(s11)
    800045aa:	c509                	beqz	a0,800045b4 <exec+0x2ba>
    if(argc >= MAXARG)
    800045ac:	fb8493e3          	bne	s1,s8,80004552 <exec+0x258>
  sz = sz1;
    800045b0:	89d2                	mv	s3,s4
    800045b2:	bfa1                	j	8000450a <exec+0x210>
  ustack[argc] = 0;
    800045b4:	00349793          	slli	a5,s1,0x3
    800045b8:	f9078793          	addi	a5,a5,-112
    800045bc:	97a2                	add	a5,a5,s0
    800045be:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800045c2:	00148693          	addi	a3,s1,1
    800045c6:	068e                	slli	a3,a3,0x3
    800045c8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045cc:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800045d0:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800045d2:	f3796ce3          	bltu	s2,s7,8000450a <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045d6:	e9040613          	addi	a2,s0,-368
    800045da:	85ca                	mv	a1,s2
    800045dc:	855a                	mv	a0,s6
    800045de:	ffffc097          	auipc	ra,0xffffc
    800045e2:	6d0080e7          	jalr	1744(ra) # 80000cae <copyout>
    800045e6:	f20542e3          	bltz	a0,8000450a <exec+0x210>
  p->trapframe->a1 = sp;
    800045ea:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800045ee:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045f2:	df043783          	ld	a5,-528(s0)
    800045f6:	0007c703          	lbu	a4,0(a5)
    800045fa:	cf11                	beqz	a4,80004616 <exec+0x31c>
    800045fc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045fe:	02f00693          	li	a3,47
    80004602:	a029                	j	8000460c <exec+0x312>
  for(last=s=path; *s; s++)
    80004604:	0785                	addi	a5,a5,1
    80004606:	fff7c703          	lbu	a4,-1(a5)
    8000460a:	c711                	beqz	a4,80004616 <exec+0x31c>
    if(*s == '/')
    8000460c:	fed71ce3          	bne	a4,a3,80004604 <exec+0x30a>
      last = s+1;
    80004610:	def43823          	sd	a5,-528(s0)
    80004614:	bfc5                	j	80004604 <exec+0x30a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004616:	4641                	li	a2,16
    80004618:	df043583          	ld	a1,-528(s0)
    8000461c:	158a8513          	addi	a0,s5,344
    80004620:	ffffc097          	auipc	ra,0xffffc
    80004624:	dee080e7          	jalr	-530(ra) # 8000040e <safestrcpy>
  oldpagetable = p->pagetable;
    80004628:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000462c:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004630:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004634:	058ab783          	ld	a5,88(s5)
    80004638:	e6843703          	ld	a4,-408(s0)
    8000463c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000463e:	058ab783          	ld	a5,88(s5)
    80004642:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004646:	85ea                	mv	a1,s10
    80004648:	ffffd097          	auipc	ra,0xffffd
    8000464c:	bae080e7          	jalr	-1106(ra) # 800011f6 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004650:	0004851b          	sext.w	a0,s1
    80004654:	79fe                	ld	s3,504(sp)
    80004656:	7a5e                	ld	s4,496(sp)
    80004658:	7abe                	ld	s5,488(sp)
    8000465a:	7b1e                	ld	s6,480(sp)
    8000465c:	6bfe                	ld	s7,472(sp)
    8000465e:	6c5e                	ld	s8,464(sp)
    80004660:	6cbe                	ld	s9,456(sp)
    80004662:	6d1e                	ld	s10,448(sp)
    80004664:	7dfa                	ld	s11,440(sp)
    80004666:	b30d                	j	80004388 <exec+0x8e>
    80004668:	7b1e                	ld	s6,480(sp)
    8000466a:	b321                	j	80004372 <exec+0x78>
    8000466c:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004670:	df843583          	ld	a1,-520(s0)
    80004674:	855a                	mv	a0,s6
    80004676:	ffffd097          	auipc	ra,0xffffd
    8000467a:	b80080e7          	jalr	-1152(ra) # 800011f6 <proc_freepagetable>
  if(ip){
    8000467e:	79fe                	ld	s3,504(sp)
    80004680:	7abe                	ld	s5,488(sp)
    80004682:	7b1e                	ld	s6,480(sp)
    80004684:	6bfe                	ld	s7,472(sp)
    80004686:	6c5e                	ld	s8,464(sp)
    80004688:	6cbe                	ld	s9,456(sp)
    8000468a:	6d1e                	ld	s10,448(sp)
    8000468c:	7dfa                	ld	s11,440(sp)
    8000468e:	b1d5                	j	80004372 <exec+0x78>
    80004690:	de943c23          	sd	s1,-520(s0)
    80004694:	bff1                	j	80004670 <exec+0x376>
    80004696:	de943c23          	sd	s1,-520(s0)
    8000469a:	bfd9                	j	80004670 <exec+0x376>
    8000469c:	de943c23          	sd	s1,-520(s0)
    800046a0:	bfc1                	j	80004670 <exec+0x376>
  sz = sz1;
    800046a2:	89d2                	mv	s3,s4
    800046a4:	b59d                	j	8000450a <exec+0x210>
    800046a6:	89d2                	mv	s3,s4
    800046a8:	b58d                	j	8000450a <exec+0x210>

00000000800046aa <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800046aa:	7179                	addi	sp,sp,-48
    800046ac:	f406                	sd	ra,40(sp)
    800046ae:	f022                	sd	s0,32(sp)
    800046b0:	ec26                	sd	s1,24(sp)
    800046b2:	e84a                	sd	s2,16(sp)
    800046b4:	1800                	addi	s0,sp,48
    800046b6:	892e                	mv	s2,a1
    800046b8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    800046ba:	fdc40593          	addi	a1,s0,-36
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	b48080e7          	jalr	-1208(ra) # 80002206 <argint>
    800046c6:	04054063          	bltz	a0,80004706 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800046ca:	fdc42703          	lw	a4,-36(s0)
    800046ce:	47bd                	li	a5,15
    800046d0:	02e7ed63          	bltu	a5,a4,8000470a <argfd+0x60>
    800046d4:	ffffd097          	auipc	ra,0xffffd
    800046d8:	9c2080e7          	jalr	-1598(ra) # 80001096 <myproc>
    800046dc:	fdc42703          	lw	a4,-36(s0)
    800046e0:	01a70793          	addi	a5,a4,26
    800046e4:	078e                	slli	a5,a5,0x3
    800046e6:	953e                	add	a0,a0,a5
    800046e8:	611c                	ld	a5,0(a0)
    800046ea:	c395                	beqz	a5,8000470e <argfd+0x64>
    return -1;
  if(pfd)
    800046ec:	00090463          	beqz	s2,800046f4 <argfd+0x4a>
    *pfd = fd;
    800046f0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046f4:	4501                	li	a0,0
  if(pf)
    800046f6:	c091                	beqz	s1,800046fa <argfd+0x50>
    *pf = f;
    800046f8:	e09c                	sd	a5,0(s1)
}
    800046fa:	70a2                	ld	ra,40(sp)
    800046fc:	7402                	ld	s0,32(sp)
    800046fe:	64e2                	ld	s1,24(sp)
    80004700:	6942                	ld	s2,16(sp)
    80004702:	6145                	addi	sp,sp,48
    80004704:	8082                	ret
    return -1;
    80004706:	557d                	li	a0,-1
    80004708:	bfcd                	j	800046fa <argfd+0x50>
    return -1;
    8000470a:	557d                	li	a0,-1
    8000470c:	b7fd                	j	800046fa <argfd+0x50>
    8000470e:	557d                	li	a0,-1
    80004710:	b7ed                	j	800046fa <argfd+0x50>

0000000080004712 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004712:	1101                	addi	sp,sp,-32
    80004714:	ec06                	sd	ra,24(sp)
    80004716:	e822                	sd	s0,16(sp)
    80004718:	e426                	sd	s1,8(sp)
    8000471a:	1000                	addi	s0,sp,32
    8000471c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000471e:	ffffd097          	auipc	ra,0xffffd
    80004722:	978080e7          	jalr	-1672(ra) # 80001096 <myproc>
    80004726:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004728:	0d050793          	addi	a5,a0,208
    8000472c:	4501                	li	a0,0
    8000472e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004730:	6398                	ld	a4,0(a5)
    80004732:	cb19                	beqz	a4,80004748 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004734:	2505                	addiw	a0,a0,1
    80004736:	07a1                	addi	a5,a5,8
    80004738:	fed51ce3          	bne	a0,a3,80004730 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000473c:	557d                	li	a0,-1
}
    8000473e:	60e2                	ld	ra,24(sp)
    80004740:	6442                	ld	s0,16(sp)
    80004742:	64a2                	ld	s1,8(sp)
    80004744:	6105                	addi	sp,sp,32
    80004746:	8082                	ret
      p->ofile[fd] = f;
    80004748:	01a50793          	addi	a5,a0,26
    8000474c:	078e                	slli	a5,a5,0x3
    8000474e:	963e                	add	a2,a2,a5
    80004750:	e204                	sd	s1,0(a2)
      return fd;
    80004752:	b7f5                	j	8000473e <fdalloc+0x2c>

0000000080004754 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004754:	715d                	addi	sp,sp,-80
    80004756:	e486                	sd	ra,72(sp)
    80004758:	e0a2                	sd	s0,64(sp)
    8000475a:	fc26                	sd	s1,56(sp)
    8000475c:	f84a                	sd	s2,48(sp)
    8000475e:	f44e                	sd	s3,40(sp)
    80004760:	f052                	sd	s4,32(sp)
    80004762:	ec56                	sd	s5,24(sp)
    80004764:	0880                	addi	s0,sp,80
    80004766:	8aae                	mv	s5,a1
    80004768:	8a32                	mv	s4,a2
    8000476a:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000476c:	fb040593          	addi	a1,s0,-80
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	df4080e7          	jalr	-524(ra) # 80003564 <nameiparent>
    80004778:	892a                	mv	s2,a0
    8000477a:	12050c63          	beqz	a0,800048b2 <create+0x15e>
    return 0;

  ilock(dp);
    8000477e:	ffffe097          	auipc	ra,0xffffe
    80004782:	5dc080e7          	jalr	1500(ra) # 80002d5a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004786:	4601                	li	a2,0
    80004788:	fb040593          	addi	a1,s0,-80
    8000478c:	854a                	mv	a0,s2
    8000478e:	fffff097          	auipc	ra,0xfffff
    80004792:	abc080e7          	jalr	-1348(ra) # 8000324a <dirlookup>
    80004796:	84aa                	mv	s1,a0
    80004798:	c539                	beqz	a0,800047e6 <create+0x92>
    iunlockput(dp);
    8000479a:	854a                	mv	a0,s2
    8000479c:	fffff097          	auipc	ra,0xfffff
    800047a0:	824080e7          	jalr	-2012(ra) # 80002fc0 <iunlockput>
    ilock(ip);
    800047a4:	8526                	mv	a0,s1
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	5b4080e7          	jalr	1460(ra) # 80002d5a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800047ae:	4789                	li	a5,2
    800047b0:	02fa9463          	bne	s5,a5,800047d8 <create+0x84>
    800047b4:	0444d783          	lhu	a5,68(s1)
    800047b8:	37f9                	addiw	a5,a5,-2
    800047ba:	17c2                	slli	a5,a5,0x30
    800047bc:	93c1                	srli	a5,a5,0x30
    800047be:	4705                	li	a4,1
    800047c0:	00f76c63          	bltu	a4,a5,800047d8 <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800047c4:	8526                	mv	a0,s1
    800047c6:	60a6                	ld	ra,72(sp)
    800047c8:	6406                	ld	s0,64(sp)
    800047ca:	74e2                	ld	s1,56(sp)
    800047cc:	7942                	ld	s2,48(sp)
    800047ce:	79a2                	ld	s3,40(sp)
    800047d0:	7a02                	ld	s4,32(sp)
    800047d2:	6ae2                	ld	s5,24(sp)
    800047d4:	6161                	addi	sp,sp,80
    800047d6:	8082                	ret
    iunlockput(ip);
    800047d8:	8526                	mv	a0,s1
    800047da:	ffffe097          	auipc	ra,0xffffe
    800047de:	7e6080e7          	jalr	2022(ra) # 80002fc0 <iunlockput>
    return 0;
    800047e2:	4481                	li	s1,0
    800047e4:	b7c5                	j	800047c4 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047e6:	85d6                	mv	a1,s5
    800047e8:	00092503          	lw	a0,0(s2)
    800047ec:	ffffe097          	auipc	ra,0xffffe
    800047f0:	3da080e7          	jalr	986(ra) # 80002bc6 <ialloc>
    800047f4:	84aa                	mv	s1,a0
    800047f6:	c139                	beqz	a0,8000483c <create+0xe8>
  ilock(ip);
    800047f8:	ffffe097          	auipc	ra,0xffffe
    800047fc:	562080e7          	jalr	1378(ra) # 80002d5a <ilock>
  ip->major = major;
    80004800:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    80004804:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    80004808:	4985                	li	s3,1
    8000480a:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    8000480e:	8526                	mv	a0,s1
    80004810:	ffffe097          	auipc	ra,0xffffe
    80004814:	47e080e7          	jalr	1150(ra) # 80002c8e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004818:	033a8a63          	beq	s5,s3,8000484c <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    8000481c:	40d0                	lw	a2,4(s1)
    8000481e:	fb040593          	addi	a1,s0,-80
    80004822:	854a                	mv	a0,s2
    80004824:	fffff097          	auipc	ra,0xfffff
    80004828:	c4c080e7          	jalr	-948(ra) # 80003470 <dirlink>
    8000482c:	06054b63          	bltz	a0,800048a2 <create+0x14e>
  iunlockput(dp);
    80004830:	854a                	mv	a0,s2
    80004832:	ffffe097          	auipc	ra,0xffffe
    80004836:	78e080e7          	jalr	1934(ra) # 80002fc0 <iunlockput>
  return ip;
    8000483a:	b769                	j	800047c4 <create+0x70>
    panic("create: ialloc");
    8000483c:	00004517          	auipc	a0,0x4
    80004840:	d4450513          	addi	a0,a0,-700 # 80008580 <etext+0x580>
    80004844:	00001097          	auipc	ra,0x1
    80004848:	6ce080e7          	jalr	1742(ra) # 80005f12 <panic>
    dp->nlink++;  // for ".."
    8000484c:	04a95783          	lhu	a5,74(s2)
    80004850:	2785                	addiw	a5,a5,1
    80004852:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80004856:	854a                	mv	a0,s2
    80004858:	ffffe097          	auipc	ra,0xffffe
    8000485c:	436080e7          	jalr	1078(ra) # 80002c8e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004860:	40d0                	lw	a2,4(s1)
    80004862:	00004597          	auipc	a1,0x4
    80004866:	d2e58593          	addi	a1,a1,-722 # 80008590 <etext+0x590>
    8000486a:	8526                	mv	a0,s1
    8000486c:	fffff097          	auipc	ra,0xfffff
    80004870:	c04080e7          	jalr	-1020(ra) # 80003470 <dirlink>
    80004874:	00054f63          	bltz	a0,80004892 <create+0x13e>
    80004878:	00492603          	lw	a2,4(s2)
    8000487c:	00004597          	auipc	a1,0x4
    80004880:	d1c58593          	addi	a1,a1,-740 # 80008598 <etext+0x598>
    80004884:	8526                	mv	a0,s1
    80004886:	fffff097          	auipc	ra,0xfffff
    8000488a:	bea080e7          	jalr	-1046(ra) # 80003470 <dirlink>
    8000488e:	f80557e3          	bgez	a0,8000481c <create+0xc8>
      panic("create dots");
    80004892:	00004517          	auipc	a0,0x4
    80004896:	d0e50513          	addi	a0,a0,-754 # 800085a0 <etext+0x5a0>
    8000489a:	00001097          	auipc	ra,0x1
    8000489e:	678080e7          	jalr	1656(ra) # 80005f12 <panic>
    panic("create: dirlink");
    800048a2:	00004517          	auipc	a0,0x4
    800048a6:	d0e50513          	addi	a0,a0,-754 # 800085b0 <etext+0x5b0>
    800048aa:	00001097          	auipc	ra,0x1
    800048ae:	668080e7          	jalr	1640(ra) # 80005f12 <panic>
    return 0;
    800048b2:	84aa                	mv	s1,a0
    800048b4:	bf01                	j	800047c4 <create+0x70>

00000000800048b6 <sys_dup>:
{
    800048b6:	7179                	addi	sp,sp,-48
    800048b8:	f406                	sd	ra,40(sp)
    800048ba:	f022                	sd	s0,32(sp)
    800048bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800048be:	fd840613          	addi	a2,s0,-40
    800048c2:	4581                	li	a1,0
    800048c4:	4501                	li	a0,0
    800048c6:	00000097          	auipc	ra,0x0
    800048ca:	de4080e7          	jalr	-540(ra) # 800046aa <argfd>
    return -1;
    800048ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048d0:	02054763          	bltz	a0,800048fe <sys_dup+0x48>
    800048d4:	ec26                	sd	s1,24(sp)
    800048d6:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800048d8:	fd843903          	ld	s2,-40(s0)
    800048dc:	854a                	mv	a0,s2
    800048de:	00000097          	auipc	ra,0x0
    800048e2:	e34080e7          	jalr	-460(ra) # 80004712 <fdalloc>
    800048e6:	84aa                	mv	s1,a0
    return -1;
    800048e8:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048ea:	00054f63          	bltz	a0,80004908 <sys_dup+0x52>
  filedup(f);
    800048ee:	854a                	mv	a0,s2
    800048f0:	fffff097          	auipc	ra,0xfffff
    800048f4:	2da080e7          	jalr	730(ra) # 80003bca <filedup>
  return fd;
    800048f8:	87a6                	mv	a5,s1
    800048fa:	64e2                	ld	s1,24(sp)
    800048fc:	6942                	ld	s2,16(sp)
}
    800048fe:	853e                	mv	a0,a5
    80004900:	70a2                	ld	ra,40(sp)
    80004902:	7402                	ld	s0,32(sp)
    80004904:	6145                	addi	sp,sp,48
    80004906:	8082                	ret
    80004908:	64e2                	ld	s1,24(sp)
    8000490a:	6942                	ld	s2,16(sp)
    8000490c:	bfcd                	j	800048fe <sys_dup+0x48>

000000008000490e <sys_read>:
{
    8000490e:	7179                	addi	sp,sp,-48
    80004910:	f406                	sd	ra,40(sp)
    80004912:	f022                	sd	s0,32(sp)
    80004914:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004916:	fe840613          	addi	a2,s0,-24
    8000491a:	4581                	li	a1,0
    8000491c:	4501                	li	a0,0
    8000491e:	00000097          	auipc	ra,0x0
    80004922:	d8c080e7          	jalr	-628(ra) # 800046aa <argfd>
    return -1;
    80004926:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004928:	04054163          	bltz	a0,8000496a <sys_read+0x5c>
    8000492c:	fe440593          	addi	a1,s0,-28
    80004930:	4509                	li	a0,2
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	8d4080e7          	jalr	-1836(ra) # 80002206 <argint>
    return -1;
    8000493a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000493c:	02054763          	bltz	a0,8000496a <sys_read+0x5c>
    80004940:	fd840593          	addi	a1,s0,-40
    80004944:	4505                	li	a0,1
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	8e2080e7          	jalr	-1822(ra) # 80002228 <argaddr>
    return -1;
    8000494e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004950:	00054d63          	bltz	a0,8000496a <sys_read+0x5c>
  return fileread(f, p, n);
    80004954:	fe442603          	lw	a2,-28(s0)
    80004958:	fd843583          	ld	a1,-40(s0)
    8000495c:	fe843503          	ld	a0,-24(s0)
    80004960:	fffff097          	auipc	ra,0xfffff
    80004964:	410080e7          	jalr	1040(ra) # 80003d70 <fileread>
    80004968:	87aa                	mv	a5,a0
}
    8000496a:	853e                	mv	a0,a5
    8000496c:	70a2                	ld	ra,40(sp)
    8000496e:	7402                	ld	s0,32(sp)
    80004970:	6145                	addi	sp,sp,48
    80004972:	8082                	ret

0000000080004974 <sys_write>:
{
    80004974:	7179                	addi	sp,sp,-48
    80004976:	f406                	sd	ra,40(sp)
    80004978:	f022                	sd	s0,32(sp)
    8000497a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000497c:	fe840613          	addi	a2,s0,-24
    80004980:	4581                	li	a1,0
    80004982:	4501                	li	a0,0
    80004984:	00000097          	auipc	ra,0x0
    80004988:	d26080e7          	jalr	-730(ra) # 800046aa <argfd>
    return -1;
    8000498c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000498e:	04054163          	bltz	a0,800049d0 <sys_write+0x5c>
    80004992:	fe440593          	addi	a1,s0,-28
    80004996:	4509                	li	a0,2
    80004998:	ffffe097          	auipc	ra,0xffffe
    8000499c:	86e080e7          	jalr	-1938(ra) # 80002206 <argint>
    return -1;
    800049a0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049a2:	02054763          	bltz	a0,800049d0 <sys_write+0x5c>
    800049a6:	fd840593          	addi	a1,s0,-40
    800049aa:	4505                	li	a0,1
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	87c080e7          	jalr	-1924(ra) # 80002228 <argaddr>
    return -1;
    800049b4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049b6:	00054d63          	bltz	a0,800049d0 <sys_write+0x5c>
  return filewrite(f, p, n);
    800049ba:	fe442603          	lw	a2,-28(s0)
    800049be:	fd843583          	ld	a1,-40(s0)
    800049c2:	fe843503          	ld	a0,-24(s0)
    800049c6:	fffff097          	auipc	ra,0xfffff
    800049ca:	47c080e7          	jalr	1148(ra) # 80003e42 <filewrite>
    800049ce:	87aa                	mv	a5,a0
}
    800049d0:	853e                	mv	a0,a5
    800049d2:	70a2                	ld	ra,40(sp)
    800049d4:	7402                	ld	s0,32(sp)
    800049d6:	6145                	addi	sp,sp,48
    800049d8:	8082                	ret

00000000800049da <sys_close>:
{
    800049da:	1101                	addi	sp,sp,-32
    800049dc:	ec06                	sd	ra,24(sp)
    800049de:	e822                	sd	s0,16(sp)
    800049e0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049e2:	fe040613          	addi	a2,s0,-32
    800049e6:	fec40593          	addi	a1,s0,-20
    800049ea:	4501                	li	a0,0
    800049ec:	00000097          	auipc	ra,0x0
    800049f0:	cbe080e7          	jalr	-834(ra) # 800046aa <argfd>
    return -1;
    800049f4:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049f6:	02054463          	bltz	a0,80004a1e <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	69c080e7          	jalr	1692(ra) # 80001096 <myproc>
    80004a02:	fec42783          	lw	a5,-20(s0)
    80004a06:	07e9                	addi	a5,a5,26
    80004a08:	078e                	slli	a5,a5,0x3
    80004a0a:	953e                	add	a0,a0,a5
    80004a0c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004a10:	fe043503          	ld	a0,-32(s0)
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	208080e7          	jalr	520(ra) # 80003c1c <fileclose>
  return 0;
    80004a1c:	4781                	li	a5,0
}
    80004a1e:	853e                	mv	a0,a5
    80004a20:	60e2                	ld	ra,24(sp)
    80004a22:	6442                	ld	s0,16(sp)
    80004a24:	6105                	addi	sp,sp,32
    80004a26:	8082                	ret

0000000080004a28 <sys_fstat>:
{
    80004a28:	1101                	addi	sp,sp,-32
    80004a2a:	ec06                	sd	ra,24(sp)
    80004a2c:	e822                	sd	s0,16(sp)
    80004a2e:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a30:	fe840613          	addi	a2,s0,-24
    80004a34:	4581                	li	a1,0
    80004a36:	4501                	li	a0,0
    80004a38:	00000097          	auipc	ra,0x0
    80004a3c:	c72080e7          	jalr	-910(ra) # 800046aa <argfd>
    return -1;
    80004a40:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a42:	02054563          	bltz	a0,80004a6c <sys_fstat+0x44>
    80004a46:	fe040593          	addi	a1,s0,-32
    80004a4a:	4505                	li	a0,1
    80004a4c:	ffffd097          	auipc	ra,0xffffd
    80004a50:	7dc080e7          	jalr	2012(ra) # 80002228 <argaddr>
    return -1;
    80004a54:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a56:	00054b63          	bltz	a0,80004a6c <sys_fstat+0x44>
  return filestat(f, st);
    80004a5a:	fe043583          	ld	a1,-32(s0)
    80004a5e:	fe843503          	ld	a0,-24(s0)
    80004a62:	fffff097          	auipc	ra,0xfffff
    80004a66:	298080e7          	jalr	664(ra) # 80003cfa <filestat>
    80004a6a:	87aa                	mv	a5,a0
}
    80004a6c:	853e                	mv	a0,a5
    80004a6e:	60e2                	ld	ra,24(sp)
    80004a70:	6442                	ld	s0,16(sp)
    80004a72:	6105                	addi	sp,sp,32
    80004a74:	8082                	ret

0000000080004a76 <sys_link>:
{
    80004a76:	7169                	addi	sp,sp,-304
    80004a78:	f606                	sd	ra,296(sp)
    80004a7a:	f222                	sd	s0,288(sp)
    80004a7c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a7e:	08000613          	li	a2,128
    80004a82:	ed040593          	addi	a1,s0,-304
    80004a86:	4501                	li	a0,0
    80004a88:	ffffd097          	auipc	ra,0xffffd
    80004a8c:	7c2080e7          	jalr	1986(ra) # 8000224a <argstr>
    return -1;
    80004a90:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a92:	12054663          	bltz	a0,80004bbe <sys_link+0x148>
    80004a96:	08000613          	li	a2,128
    80004a9a:	f5040593          	addi	a1,s0,-176
    80004a9e:	4505                	li	a0,1
    80004aa0:	ffffd097          	auipc	ra,0xffffd
    80004aa4:	7aa080e7          	jalr	1962(ra) # 8000224a <argstr>
    return -1;
    80004aa8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004aaa:	10054a63          	bltz	a0,80004bbe <sys_link+0x148>
    80004aae:	ee26                	sd	s1,280(sp)
  begin_op();
    80004ab0:	fffff097          	auipc	ra,0xfffff
    80004ab4:	c9c080e7          	jalr	-868(ra) # 8000374c <begin_op>
  if((ip = namei(old)) == 0){
    80004ab8:	ed040513          	addi	a0,s0,-304
    80004abc:	fffff097          	auipc	ra,0xfffff
    80004ac0:	a8a080e7          	jalr	-1398(ra) # 80003546 <namei>
    80004ac4:	84aa                	mv	s1,a0
    80004ac6:	c949                	beqz	a0,80004b58 <sys_link+0xe2>
  ilock(ip);
    80004ac8:	ffffe097          	auipc	ra,0xffffe
    80004acc:	292080e7          	jalr	658(ra) # 80002d5a <ilock>
  if(ip->type == T_DIR){
    80004ad0:	04449703          	lh	a4,68(s1)
    80004ad4:	4785                	li	a5,1
    80004ad6:	08f70863          	beq	a4,a5,80004b66 <sys_link+0xf0>
    80004ada:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004adc:	04a4d783          	lhu	a5,74(s1)
    80004ae0:	2785                	addiw	a5,a5,1
    80004ae2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004ae6:	8526                	mv	a0,s1
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	1a6080e7          	jalr	422(ra) # 80002c8e <iupdate>
  iunlock(ip);
    80004af0:	8526                	mv	a0,s1
    80004af2:	ffffe097          	auipc	ra,0xffffe
    80004af6:	32e080e7          	jalr	814(ra) # 80002e20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004afa:	fd040593          	addi	a1,s0,-48
    80004afe:	f5040513          	addi	a0,s0,-176
    80004b02:	fffff097          	auipc	ra,0xfffff
    80004b06:	a62080e7          	jalr	-1438(ra) # 80003564 <nameiparent>
    80004b0a:	892a                	mv	s2,a0
    80004b0c:	cd35                	beqz	a0,80004b88 <sys_link+0x112>
  ilock(dp);
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	24c080e7          	jalr	588(ra) # 80002d5a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b16:	00092703          	lw	a4,0(s2)
    80004b1a:	409c                	lw	a5,0(s1)
    80004b1c:	06f71163          	bne	a4,a5,80004b7e <sys_link+0x108>
    80004b20:	40d0                	lw	a2,4(s1)
    80004b22:	fd040593          	addi	a1,s0,-48
    80004b26:	854a                	mv	a0,s2
    80004b28:	fffff097          	auipc	ra,0xfffff
    80004b2c:	948080e7          	jalr	-1720(ra) # 80003470 <dirlink>
    80004b30:	04054763          	bltz	a0,80004b7e <sys_link+0x108>
  iunlockput(dp);
    80004b34:	854a                	mv	a0,s2
    80004b36:	ffffe097          	auipc	ra,0xffffe
    80004b3a:	48a080e7          	jalr	1162(ra) # 80002fc0 <iunlockput>
  iput(ip);
    80004b3e:	8526                	mv	a0,s1
    80004b40:	ffffe097          	auipc	ra,0xffffe
    80004b44:	3d8080e7          	jalr	984(ra) # 80002f18 <iput>
  end_op();
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	c7e080e7          	jalr	-898(ra) # 800037c6 <end_op>
  return 0;
    80004b50:	4781                	li	a5,0
    80004b52:	64f2                	ld	s1,280(sp)
    80004b54:	6952                	ld	s2,272(sp)
    80004b56:	a0a5                	j	80004bbe <sys_link+0x148>
    end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	c6e080e7          	jalr	-914(ra) # 800037c6 <end_op>
    return -1;
    80004b60:	57fd                	li	a5,-1
    80004b62:	64f2                	ld	s1,280(sp)
    80004b64:	a8a9                	j	80004bbe <sys_link+0x148>
    iunlockput(ip);
    80004b66:	8526                	mv	a0,s1
    80004b68:	ffffe097          	auipc	ra,0xffffe
    80004b6c:	458080e7          	jalr	1112(ra) # 80002fc0 <iunlockput>
    end_op();
    80004b70:	fffff097          	auipc	ra,0xfffff
    80004b74:	c56080e7          	jalr	-938(ra) # 800037c6 <end_op>
    return -1;
    80004b78:	57fd                	li	a5,-1
    80004b7a:	64f2                	ld	s1,280(sp)
    80004b7c:	a089                	j	80004bbe <sys_link+0x148>
    iunlockput(dp);
    80004b7e:	854a                	mv	a0,s2
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	440080e7          	jalr	1088(ra) # 80002fc0 <iunlockput>
  ilock(ip);
    80004b88:	8526                	mv	a0,s1
    80004b8a:	ffffe097          	auipc	ra,0xffffe
    80004b8e:	1d0080e7          	jalr	464(ra) # 80002d5a <ilock>
  ip->nlink--;
    80004b92:	04a4d783          	lhu	a5,74(s1)
    80004b96:	37fd                	addiw	a5,a5,-1
    80004b98:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b9c:	8526                	mv	a0,s1
    80004b9e:	ffffe097          	auipc	ra,0xffffe
    80004ba2:	0f0080e7          	jalr	240(ra) # 80002c8e <iupdate>
  iunlockput(ip);
    80004ba6:	8526                	mv	a0,s1
    80004ba8:	ffffe097          	auipc	ra,0xffffe
    80004bac:	418080e7          	jalr	1048(ra) # 80002fc0 <iunlockput>
  end_op();
    80004bb0:	fffff097          	auipc	ra,0xfffff
    80004bb4:	c16080e7          	jalr	-1002(ra) # 800037c6 <end_op>
  return -1;
    80004bb8:	57fd                	li	a5,-1
    80004bba:	64f2                	ld	s1,280(sp)
    80004bbc:	6952                	ld	s2,272(sp)
}
    80004bbe:	853e                	mv	a0,a5
    80004bc0:	70b2                	ld	ra,296(sp)
    80004bc2:	7412                	ld	s0,288(sp)
    80004bc4:	6155                	addi	sp,sp,304
    80004bc6:	8082                	ret

0000000080004bc8 <sys_unlink>:
{
    80004bc8:	7111                	addi	sp,sp,-256
    80004bca:	fd86                	sd	ra,248(sp)
    80004bcc:	f9a2                	sd	s0,240(sp)
    80004bce:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    80004bd0:	08000613          	li	a2,128
    80004bd4:	f2040593          	addi	a1,s0,-224
    80004bd8:	4501                	li	a0,0
    80004bda:	ffffd097          	auipc	ra,0xffffd
    80004bde:	670080e7          	jalr	1648(ra) # 8000224a <argstr>
    80004be2:	1c054063          	bltz	a0,80004da2 <sys_unlink+0x1da>
    80004be6:	f5a6                	sd	s1,232(sp)
  begin_op();
    80004be8:	fffff097          	auipc	ra,0xfffff
    80004bec:	b64080e7          	jalr	-1180(ra) # 8000374c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bf0:	fa040593          	addi	a1,s0,-96
    80004bf4:	f2040513          	addi	a0,s0,-224
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	96c080e7          	jalr	-1684(ra) # 80003564 <nameiparent>
    80004c00:	84aa                	mv	s1,a0
    80004c02:	c165                	beqz	a0,80004ce2 <sys_unlink+0x11a>
  ilock(dp);
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	156080e7          	jalr	342(ra) # 80002d5a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c0c:	00004597          	auipc	a1,0x4
    80004c10:	98458593          	addi	a1,a1,-1660 # 80008590 <etext+0x590>
    80004c14:	fa040513          	addi	a0,s0,-96
    80004c18:	ffffe097          	auipc	ra,0xffffe
    80004c1c:	618080e7          	jalr	1560(ra) # 80003230 <namecmp>
    80004c20:	16050263          	beqz	a0,80004d84 <sys_unlink+0x1bc>
    80004c24:	00004597          	auipc	a1,0x4
    80004c28:	97458593          	addi	a1,a1,-1676 # 80008598 <etext+0x598>
    80004c2c:	fa040513          	addi	a0,s0,-96
    80004c30:	ffffe097          	auipc	ra,0xffffe
    80004c34:	600080e7          	jalr	1536(ra) # 80003230 <namecmp>
    80004c38:	14050663          	beqz	a0,80004d84 <sys_unlink+0x1bc>
    80004c3c:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c3e:	f1c40613          	addi	a2,s0,-228
    80004c42:	fa040593          	addi	a1,s0,-96
    80004c46:	8526                	mv	a0,s1
    80004c48:	ffffe097          	auipc	ra,0xffffe
    80004c4c:	602080e7          	jalr	1538(ra) # 8000324a <dirlookup>
    80004c50:	892a                	mv	s2,a0
    80004c52:	12050863          	beqz	a0,80004d82 <sys_unlink+0x1ba>
    80004c56:	edce                	sd	s3,216(sp)
  ilock(ip);
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	102080e7          	jalr	258(ra) # 80002d5a <ilock>
  if(ip->nlink < 1)
    80004c60:	04a91783          	lh	a5,74(s2)
    80004c64:	08f05663          	blez	a5,80004cf0 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c68:	04491703          	lh	a4,68(s2)
    80004c6c:	4785                	li	a5,1
    80004c6e:	08f70b63          	beq	a4,a5,80004d04 <sys_unlink+0x13c>
  memset(&de, 0, sizeof(de));
    80004c72:	fb040993          	addi	s3,s0,-80
    80004c76:	4641                	li	a2,16
    80004c78:	4581                	li	a1,0
    80004c7a:	854e                	mv	a0,s3
    80004c7c:	ffffb097          	auipc	ra,0xffffb
    80004c80:	63c080e7          	jalr	1596(ra) # 800002b8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c84:	4741                	li	a4,16
    80004c86:	f1c42683          	lw	a3,-228(s0)
    80004c8a:	864e                	mv	a2,s3
    80004c8c:	4581                	li	a1,0
    80004c8e:	8526                	mv	a0,s1
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	480080e7          	jalr	1152(ra) # 80003110 <writei>
    80004c98:	47c1                	li	a5,16
    80004c9a:	0af51f63          	bne	a0,a5,80004d58 <sys_unlink+0x190>
  if(ip->type == T_DIR){
    80004c9e:	04491703          	lh	a4,68(s2)
    80004ca2:	4785                	li	a5,1
    80004ca4:	0cf70463          	beq	a4,a5,80004d6c <sys_unlink+0x1a4>
  iunlockput(dp);
    80004ca8:	8526                	mv	a0,s1
    80004caa:	ffffe097          	auipc	ra,0xffffe
    80004cae:	316080e7          	jalr	790(ra) # 80002fc0 <iunlockput>
  ip->nlink--;
    80004cb2:	04a95783          	lhu	a5,74(s2)
    80004cb6:	37fd                	addiw	a5,a5,-1
    80004cb8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004cbc:	854a                	mv	a0,s2
    80004cbe:	ffffe097          	auipc	ra,0xffffe
    80004cc2:	fd0080e7          	jalr	-48(ra) # 80002c8e <iupdate>
  iunlockput(ip);
    80004cc6:	854a                	mv	a0,s2
    80004cc8:	ffffe097          	auipc	ra,0xffffe
    80004ccc:	2f8080e7          	jalr	760(ra) # 80002fc0 <iunlockput>
  end_op();
    80004cd0:	fffff097          	auipc	ra,0xfffff
    80004cd4:	af6080e7          	jalr	-1290(ra) # 800037c6 <end_op>
  return 0;
    80004cd8:	4501                	li	a0,0
    80004cda:	74ae                	ld	s1,232(sp)
    80004cdc:	790e                	ld	s2,224(sp)
    80004cde:	69ee                	ld	s3,216(sp)
    80004ce0:	a86d                	j	80004d9a <sys_unlink+0x1d2>
    end_op();
    80004ce2:	fffff097          	auipc	ra,0xfffff
    80004ce6:	ae4080e7          	jalr	-1308(ra) # 800037c6 <end_op>
    return -1;
    80004cea:	557d                	li	a0,-1
    80004cec:	74ae                	ld	s1,232(sp)
    80004cee:	a075                	j	80004d9a <sys_unlink+0x1d2>
    80004cf0:	e9d2                	sd	s4,208(sp)
    80004cf2:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    80004cf4:	00004517          	auipc	a0,0x4
    80004cf8:	8cc50513          	addi	a0,a0,-1844 # 800085c0 <etext+0x5c0>
    80004cfc:	00001097          	auipc	ra,0x1
    80004d00:	216080e7          	jalr	534(ra) # 80005f12 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d04:	04c92703          	lw	a4,76(s2)
    80004d08:	02000793          	li	a5,32
    80004d0c:	f6e7f3e3          	bgeu	a5,a4,80004c72 <sys_unlink+0xaa>
    80004d10:	e9d2                	sd	s4,208(sp)
    80004d12:	e5d6                	sd	s5,200(sp)
    80004d14:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d16:	f0840a93          	addi	s5,s0,-248
    80004d1a:	4a41                	li	s4,16
    80004d1c:	8752                	mv	a4,s4
    80004d1e:	86ce                	mv	a3,s3
    80004d20:	8656                	mv	a2,s5
    80004d22:	4581                	li	a1,0
    80004d24:	854a                	mv	a0,s2
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	2f0080e7          	jalr	752(ra) # 80003016 <readi>
    80004d2e:	01451d63          	bne	a0,s4,80004d48 <sys_unlink+0x180>
    if(de.inum != 0)
    80004d32:	f0845783          	lhu	a5,-248(s0)
    80004d36:	eba5                	bnez	a5,80004da6 <sys_unlink+0x1de>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d38:	29c1                	addiw	s3,s3,16
    80004d3a:	04c92783          	lw	a5,76(s2)
    80004d3e:	fcf9efe3          	bltu	s3,a5,80004d1c <sys_unlink+0x154>
    80004d42:	6a4e                	ld	s4,208(sp)
    80004d44:	6aae                	ld	s5,200(sp)
    80004d46:	b735                	j	80004c72 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004d48:	00004517          	auipc	a0,0x4
    80004d4c:	89050513          	addi	a0,a0,-1904 # 800085d8 <etext+0x5d8>
    80004d50:	00001097          	auipc	ra,0x1
    80004d54:	1c2080e7          	jalr	450(ra) # 80005f12 <panic>
    80004d58:	e9d2                	sd	s4,208(sp)
    80004d5a:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004d5c:	00004517          	auipc	a0,0x4
    80004d60:	89450513          	addi	a0,a0,-1900 # 800085f0 <etext+0x5f0>
    80004d64:	00001097          	auipc	ra,0x1
    80004d68:	1ae080e7          	jalr	430(ra) # 80005f12 <panic>
    dp->nlink--;
    80004d6c:	04a4d783          	lhu	a5,74(s1)
    80004d70:	37fd                	addiw	a5,a5,-1
    80004d72:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d76:	8526                	mv	a0,s1
    80004d78:	ffffe097          	auipc	ra,0xffffe
    80004d7c:	f16080e7          	jalr	-234(ra) # 80002c8e <iupdate>
    80004d80:	b725                	j	80004ca8 <sys_unlink+0xe0>
    80004d82:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004d84:	8526                	mv	a0,s1
    80004d86:	ffffe097          	auipc	ra,0xffffe
    80004d8a:	23a080e7          	jalr	570(ra) # 80002fc0 <iunlockput>
  end_op();
    80004d8e:	fffff097          	auipc	ra,0xfffff
    80004d92:	a38080e7          	jalr	-1480(ra) # 800037c6 <end_op>
  return -1;
    80004d96:	557d                	li	a0,-1
    80004d98:	74ae                	ld	s1,232(sp)
}
    80004d9a:	70ee                	ld	ra,248(sp)
    80004d9c:	744e                	ld	s0,240(sp)
    80004d9e:	6111                	addi	sp,sp,256
    80004da0:	8082                	ret
    return -1;
    80004da2:	557d                	li	a0,-1
    80004da4:	bfdd                	j	80004d9a <sys_unlink+0x1d2>
    iunlockput(ip);
    80004da6:	854a                	mv	a0,s2
    80004da8:	ffffe097          	auipc	ra,0xffffe
    80004dac:	218080e7          	jalr	536(ra) # 80002fc0 <iunlockput>
    goto bad;
    80004db0:	790e                	ld	s2,224(sp)
    80004db2:	69ee                	ld	s3,216(sp)
    80004db4:	6a4e                	ld	s4,208(sp)
    80004db6:	6aae                	ld	s5,200(sp)
    80004db8:	b7f1                	j	80004d84 <sys_unlink+0x1bc>

0000000080004dba <sys_open>:

uint64
sys_open(void)
{
    80004dba:	7131                	addi	sp,sp,-192
    80004dbc:	fd06                	sd	ra,184(sp)
    80004dbe:	f922                	sd	s0,176(sp)
    80004dc0:	f526                	sd	s1,168(sp)
    80004dc2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004dc4:	08000613          	li	a2,128
    80004dc8:	f5040593          	addi	a1,s0,-176
    80004dcc:	4501                	li	a0,0
    80004dce:	ffffd097          	auipc	ra,0xffffd
    80004dd2:	47c080e7          	jalr	1148(ra) # 8000224a <argstr>
    return -1;
    80004dd6:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004dd8:	0c054563          	bltz	a0,80004ea2 <sys_open+0xe8>
    80004ddc:	f4c40593          	addi	a1,s0,-180
    80004de0:	4505                	li	a0,1
    80004de2:	ffffd097          	auipc	ra,0xffffd
    80004de6:	424080e7          	jalr	1060(ra) # 80002206 <argint>
    80004dea:	0a054c63          	bltz	a0,80004ea2 <sys_open+0xe8>
    80004dee:	f14a                	sd	s2,160(sp)

  begin_op();
    80004df0:	fffff097          	auipc	ra,0xfffff
    80004df4:	95c080e7          	jalr	-1700(ra) # 8000374c <begin_op>

  if(omode & O_CREATE){
    80004df8:	f4c42783          	lw	a5,-180(s0)
    80004dfc:	2007f793          	andi	a5,a5,512
    80004e00:	cfcd                	beqz	a5,80004eba <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80004e02:	4681                	li	a3,0
    80004e04:	4601                	li	a2,0
    80004e06:	4589                	li	a1,2
    80004e08:	f5040513          	addi	a0,s0,-176
    80004e0c:	00000097          	auipc	ra,0x0
    80004e10:	948080e7          	jalr	-1720(ra) # 80004754 <create>
    80004e14:	892a                	mv	s2,a0
    if(ip == 0){
    80004e16:	cd41                	beqz	a0,80004eae <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e18:	04491703          	lh	a4,68(s2)
    80004e1c:	478d                	li	a5,3
    80004e1e:	00f71763          	bne	a4,a5,80004e2c <sys_open+0x72>
    80004e22:	04695703          	lhu	a4,70(s2)
    80004e26:	47a5                	li	a5,9
    80004e28:	0ee7e063          	bltu	a5,a4,80004f08 <sys_open+0x14e>
    80004e2c:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e2e:	fffff097          	auipc	ra,0xfffff
    80004e32:	d32080e7          	jalr	-718(ra) # 80003b60 <filealloc>
    80004e36:	89aa                	mv	s3,a0
    80004e38:	c96d                	beqz	a0,80004f2a <sys_open+0x170>
    80004e3a:	00000097          	auipc	ra,0x0
    80004e3e:	8d8080e7          	jalr	-1832(ra) # 80004712 <fdalloc>
    80004e42:	84aa                	mv	s1,a0
    80004e44:	0c054e63          	bltz	a0,80004f20 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e48:	04491703          	lh	a4,68(s2)
    80004e4c:	478d                	li	a5,3
    80004e4e:	0ef70b63          	beq	a4,a5,80004f44 <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e52:	4789                	li	a5,2
    80004e54:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e58:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e5c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e60:	f4c42783          	lw	a5,-180(s0)
    80004e64:	0017f713          	andi	a4,a5,1
    80004e68:	00174713          	xori	a4,a4,1
    80004e6c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e70:	0037f713          	andi	a4,a5,3
    80004e74:	00e03733          	snez	a4,a4
    80004e78:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e7c:	4007f793          	andi	a5,a5,1024
    80004e80:	c791                	beqz	a5,80004e8c <sys_open+0xd2>
    80004e82:	04491703          	lh	a4,68(s2)
    80004e86:	4789                	li	a5,2
    80004e88:	0cf70563          	beq	a4,a5,80004f52 <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80004e8c:	854a                	mv	a0,s2
    80004e8e:	ffffe097          	auipc	ra,0xffffe
    80004e92:	f92080e7          	jalr	-110(ra) # 80002e20 <iunlock>
  end_op();
    80004e96:	fffff097          	auipc	ra,0xfffff
    80004e9a:	930080e7          	jalr	-1744(ra) # 800037c6 <end_op>
    80004e9e:	790a                	ld	s2,160(sp)
    80004ea0:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004ea2:	8526                	mv	a0,s1
    80004ea4:	70ea                	ld	ra,184(sp)
    80004ea6:	744a                	ld	s0,176(sp)
    80004ea8:	74aa                	ld	s1,168(sp)
    80004eaa:	6129                	addi	sp,sp,192
    80004eac:	8082                	ret
      end_op();
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	918080e7          	jalr	-1768(ra) # 800037c6 <end_op>
      return -1;
    80004eb6:	790a                	ld	s2,160(sp)
    80004eb8:	b7ed                	j	80004ea2 <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80004eba:	f5040513          	addi	a0,s0,-176
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	688080e7          	jalr	1672(ra) # 80003546 <namei>
    80004ec6:	892a                	mv	s2,a0
    80004ec8:	c90d                	beqz	a0,80004efa <sys_open+0x140>
    ilock(ip);
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	e90080e7          	jalr	-368(ra) # 80002d5a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004ed2:	04491703          	lh	a4,68(s2)
    80004ed6:	4785                	li	a5,1
    80004ed8:	f4f710e3          	bne	a4,a5,80004e18 <sys_open+0x5e>
    80004edc:	f4c42783          	lw	a5,-180(s0)
    80004ee0:	d7b1                	beqz	a5,80004e2c <sys_open+0x72>
      iunlockput(ip);
    80004ee2:	854a                	mv	a0,s2
    80004ee4:	ffffe097          	auipc	ra,0xffffe
    80004ee8:	0dc080e7          	jalr	220(ra) # 80002fc0 <iunlockput>
      end_op();
    80004eec:	fffff097          	auipc	ra,0xfffff
    80004ef0:	8da080e7          	jalr	-1830(ra) # 800037c6 <end_op>
      return -1;
    80004ef4:	54fd                	li	s1,-1
    80004ef6:	790a                	ld	s2,160(sp)
    80004ef8:	b76d                	j	80004ea2 <sys_open+0xe8>
      end_op();
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	8cc080e7          	jalr	-1844(ra) # 800037c6 <end_op>
      return -1;
    80004f02:	54fd                	li	s1,-1
    80004f04:	790a                	ld	s2,160(sp)
    80004f06:	bf71                	j	80004ea2 <sys_open+0xe8>
    iunlockput(ip);
    80004f08:	854a                	mv	a0,s2
    80004f0a:	ffffe097          	auipc	ra,0xffffe
    80004f0e:	0b6080e7          	jalr	182(ra) # 80002fc0 <iunlockput>
    end_op();
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	8b4080e7          	jalr	-1868(ra) # 800037c6 <end_op>
    return -1;
    80004f1a:	54fd                	li	s1,-1
    80004f1c:	790a                	ld	s2,160(sp)
    80004f1e:	b751                	j	80004ea2 <sys_open+0xe8>
      fileclose(f);
    80004f20:	854e                	mv	a0,s3
    80004f22:	fffff097          	auipc	ra,0xfffff
    80004f26:	cfa080e7          	jalr	-774(ra) # 80003c1c <fileclose>
    iunlockput(ip);
    80004f2a:	854a                	mv	a0,s2
    80004f2c:	ffffe097          	auipc	ra,0xffffe
    80004f30:	094080e7          	jalr	148(ra) # 80002fc0 <iunlockput>
    end_op();
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	892080e7          	jalr	-1902(ra) # 800037c6 <end_op>
    return -1;
    80004f3c:	54fd                	li	s1,-1
    80004f3e:	790a                	ld	s2,160(sp)
    80004f40:	69ea                	ld	s3,152(sp)
    80004f42:	b785                	j	80004ea2 <sys_open+0xe8>
    f->type = FD_DEVICE;
    80004f44:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f48:	04691783          	lh	a5,70(s2)
    80004f4c:	02f99223          	sh	a5,36(s3)
    80004f50:	b731                	j	80004e5c <sys_open+0xa2>
    itrunc(ip);
    80004f52:	854a                	mv	a0,s2
    80004f54:	ffffe097          	auipc	ra,0xffffe
    80004f58:	f18080e7          	jalr	-232(ra) # 80002e6c <itrunc>
    80004f5c:	bf05                	j	80004e8c <sys_open+0xd2>

0000000080004f5e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f5e:	7175                	addi	sp,sp,-144
    80004f60:	e506                	sd	ra,136(sp)
    80004f62:	e122                	sd	s0,128(sp)
    80004f64:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f66:	ffffe097          	auipc	ra,0xffffe
    80004f6a:	7e6080e7          	jalr	2022(ra) # 8000374c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f6e:	08000613          	li	a2,128
    80004f72:	f7040593          	addi	a1,s0,-144
    80004f76:	4501                	li	a0,0
    80004f78:	ffffd097          	auipc	ra,0xffffd
    80004f7c:	2d2080e7          	jalr	722(ra) # 8000224a <argstr>
    80004f80:	02054963          	bltz	a0,80004fb2 <sys_mkdir+0x54>
    80004f84:	4681                	li	a3,0
    80004f86:	4601                	li	a2,0
    80004f88:	4585                	li	a1,1
    80004f8a:	f7040513          	addi	a0,s0,-144
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	7c6080e7          	jalr	1990(ra) # 80004754 <create>
    80004f96:	cd11                	beqz	a0,80004fb2 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f98:	ffffe097          	auipc	ra,0xffffe
    80004f9c:	028080e7          	jalr	40(ra) # 80002fc0 <iunlockput>
  end_op();
    80004fa0:	fffff097          	auipc	ra,0xfffff
    80004fa4:	826080e7          	jalr	-2010(ra) # 800037c6 <end_op>
  return 0;
    80004fa8:	4501                	li	a0,0
}
    80004faa:	60aa                	ld	ra,136(sp)
    80004fac:	640a                	ld	s0,128(sp)
    80004fae:	6149                	addi	sp,sp,144
    80004fb0:	8082                	ret
    end_op();
    80004fb2:	fffff097          	auipc	ra,0xfffff
    80004fb6:	814080e7          	jalr	-2028(ra) # 800037c6 <end_op>
    return -1;
    80004fba:	557d                	li	a0,-1
    80004fbc:	b7fd                	j	80004faa <sys_mkdir+0x4c>

0000000080004fbe <sys_mknod>:

uint64
sys_mknod(void)
{
    80004fbe:	7135                	addi	sp,sp,-160
    80004fc0:	ed06                	sd	ra,152(sp)
    80004fc2:	e922                	sd	s0,144(sp)
    80004fc4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	786080e7          	jalr	1926(ra) # 8000374c <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fce:	08000613          	li	a2,128
    80004fd2:	f7040593          	addi	a1,s0,-144
    80004fd6:	4501                	li	a0,0
    80004fd8:	ffffd097          	auipc	ra,0xffffd
    80004fdc:	272080e7          	jalr	626(ra) # 8000224a <argstr>
    80004fe0:	04054a63          	bltz	a0,80005034 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004fe4:	f6c40593          	addi	a1,s0,-148
    80004fe8:	4505                	li	a0,1
    80004fea:	ffffd097          	auipc	ra,0xffffd
    80004fee:	21c080e7          	jalr	540(ra) # 80002206 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004ff2:	04054163          	bltz	a0,80005034 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004ff6:	f6840593          	addi	a1,s0,-152
    80004ffa:	4509                	li	a0,2
    80004ffc:	ffffd097          	auipc	ra,0xffffd
    80005000:	20a080e7          	jalr	522(ra) # 80002206 <argint>
     argint(1, &major) < 0 ||
    80005004:	02054863          	bltz	a0,80005034 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005008:	f6841683          	lh	a3,-152(s0)
    8000500c:	f6c41603          	lh	a2,-148(s0)
    80005010:	458d                	li	a1,3
    80005012:	f7040513          	addi	a0,s0,-144
    80005016:	fffff097          	auipc	ra,0xfffff
    8000501a:	73e080e7          	jalr	1854(ra) # 80004754 <create>
     argint(2, &minor) < 0 ||
    8000501e:	c919                	beqz	a0,80005034 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005020:	ffffe097          	auipc	ra,0xffffe
    80005024:	fa0080e7          	jalr	-96(ra) # 80002fc0 <iunlockput>
  end_op();
    80005028:	ffffe097          	auipc	ra,0xffffe
    8000502c:	79e080e7          	jalr	1950(ra) # 800037c6 <end_op>
  return 0;
    80005030:	4501                	li	a0,0
    80005032:	a031                	j	8000503e <sys_mknod+0x80>
    end_op();
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	792080e7          	jalr	1938(ra) # 800037c6 <end_op>
    return -1;
    8000503c:	557d                	li	a0,-1
}
    8000503e:	60ea                	ld	ra,152(sp)
    80005040:	644a                	ld	s0,144(sp)
    80005042:	610d                	addi	sp,sp,160
    80005044:	8082                	ret

0000000080005046 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005046:	7135                	addi	sp,sp,-160
    80005048:	ed06                	sd	ra,152(sp)
    8000504a:	e922                	sd	s0,144(sp)
    8000504c:	e14a                	sd	s2,128(sp)
    8000504e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005050:	ffffc097          	auipc	ra,0xffffc
    80005054:	046080e7          	jalr	70(ra) # 80001096 <myproc>
    80005058:	892a                	mv	s2,a0
  
  begin_op();
    8000505a:	ffffe097          	auipc	ra,0xffffe
    8000505e:	6f2080e7          	jalr	1778(ra) # 8000374c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005062:	08000613          	li	a2,128
    80005066:	f6040593          	addi	a1,s0,-160
    8000506a:	4501                	li	a0,0
    8000506c:	ffffd097          	auipc	ra,0xffffd
    80005070:	1de080e7          	jalr	478(ra) # 8000224a <argstr>
    80005074:	04054d63          	bltz	a0,800050ce <sys_chdir+0x88>
    80005078:	e526                	sd	s1,136(sp)
    8000507a:	f6040513          	addi	a0,s0,-160
    8000507e:	ffffe097          	auipc	ra,0xffffe
    80005082:	4c8080e7          	jalr	1224(ra) # 80003546 <namei>
    80005086:	84aa                	mv	s1,a0
    80005088:	c131                	beqz	a0,800050cc <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	cd0080e7          	jalr	-816(ra) # 80002d5a <ilock>
  if(ip->type != T_DIR){
    80005092:	04449703          	lh	a4,68(s1)
    80005096:	4785                	li	a5,1
    80005098:	04f71163          	bne	a4,a5,800050da <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000509c:	8526                	mv	a0,s1
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	d82080e7          	jalr	-638(ra) # 80002e20 <iunlock>
  iput(p->cwd);
    800050a6:	15093503          	ld	a0,336(s2)
    800050aa:	ffffe097          	auipc	ra,0xffffe
    800050ae:	e6e080e7          	jalr	-402(ra) # 80002f18 <iput>
  end_op();
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	714080e7          	jalr	1812(ra) # 800037c6 <end_op>
  p->cwd = ip;
    800050ba:	14993823          	sd	s1,336(s2)
  return 0;
    800050be:	4501                	li	a0,0
    800050c0:	64aa                	ld	s1,136(sp)
}
    800050c2:	60ea                	ld	ra,152(sp)
    800050c4:	644a                	ld	s0,144(sp)
    800050c6:	690a                	ld	s2,128(sp)
    800050c8:	610d                	addi	sp,sp,160
    800050ca:	8082                	ret
    800050cc:	64aa                	ld	s1,136(sp)
    end_op();
    800050ce:	ffffe097          	auipc	ra,0xffffe
    800050d2:	6f8080e7          	jalr	1784(ra) # 800037c6 <end_op>
    return -1;
    800050d6:	557d                	li	a0,-1
    800050d8:	b7ed                	j	800050c2 <sys_chdir+0x7c>
    iunlockput(ip);
    800050da:	8526                	mv	a0,s1
    800050dc:	ffffe097          	auipc	ra,0xffffe
    800050e0:	ee4080e7          	jalr	-284(ra) # 80002fc0 <iunlockput>
    end_op();
    800050e4:	ffffe097          	auipc	ra,0xffffe
    800050e8:	6e2080e7          	jalr	1762(ra) # 800037c6 <end_op>
    return -1;
    800050ec:	557d                	li	a0,-1
    800050ee:	64aa                	ld	s1,136(sp)
    800050f0:	bfc9                	j	800050c2 <sys_chdir+0x7c>

00000000800050f2 <sys_exec>:

uint64
sys_exec(void)
{
    800050f2:	7105                	addi	sp,sp,-480
    800050f4:	ef86                	sd	ra,472(sp)
    800050f6:	eba2                	sd	s0,464(sp)
    800050f8:	e3ca                	sd	s2,448(sp)
    800050fa:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050fc:	08000613          	li	a2,128
    80005100:	f3040593          	addi	a1,s0,-208
    80005104:	4501                	li	a0,0
    80005106:	ffffd097          	auipc	ra,0xffffd
    8000510a:	144080e7          	jalr	324(ra) # 8000224a <argstr>
    return -1;
    8000510e:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005110:	10054963          	bltz	a0,80005222 <sys_exec+0x130>
    80005114:	e2840593          	addi	a1,s0,-472
    80005118:	4505                	li	a0,1
    8000511a:	ffffd097          	auipc	ra,0xffffd
    8000511e:	10e080e7          	jalr	270(ra) # 80002228 <argaddr>
    80005122:	10054063          	bltz	a0,80005222 <sys_exec+0x130>
    80005126:	e7a6                	sd	s1,456(sp)
    80005128:	ff4e                	sd	s3,440(sp)
    8000512a:	fb52                	sd	s4,432(sp)
    8000512c:	f756                	sd	s5,424(sp)
    8000512e:	f35a                	sd	s6,416(sp)
    80005130:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005132:	e3040a13          	addi	s4,s0,-464
    80005136:	10000613          	li	a2,256
    8000513a:	4581                	li	a1,0
    8000513c:	8552                	mv	a0,s4
    8000513e:	ffffb097          	auipc	ra,0xffffb
    80005142:	17a080e7          	jalr	378(ra) # 800002b8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005146:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005148:	89d2                	mv	s3,s4
    8000514a:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000514c:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005150:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005152:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005156:	00391513          	slli	a0,s2,0x3
    8000515a:	85d6                	mv	a1,s5
    8000515c:	e2843783          	ld	a5,-472(s0)
    80005160:	953e                	add	a0,a0,a5
    80005162:	ffffd097          	auipc	ra,0xffffd
    80005166:	00a080e7          	jalr	10(ra) # 8000216c <fetchaddr>
    8000516a:	02054a63          	bltz	a0,8000519e <sys_exec+0xac>
    if(uarg == 0){
    8000516e:	e2043783          	ld	a5,-480(s0)
    80005172:	cba9                	beqz	a5,800051c4 <sys_exec+0xd2>
    argv[i] = kalloc();
    80005174:	ffffb097          	auipc	ra,0xffffb
    80005178:	0aa080e7          	jalr	170(ra) # 8000021e <kalloc>
    8000517c:	85aa                	mv	a1,a0
    8000517e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005182:	cd11                	beqz	a0,8000519e <sys_exec+0xac>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005184:	865a                	mv	a2,s6
    80005186:	e2043503          	ld	a0,-480(s0)
    8000518a:	ffffd097          	auipc	ra,0xffffd
    8000518e:	034080e7          	jalr	52(ra) # 800021be <fetchstr>
    80005192:	00054663          	bltz	a0,8000519e <sys_exec+0xac>
    if(i >= NELEM(argv)){
    80005196:	0905                	addi	s2,s2,1
    80005198:	09a1                	addi	s3,s3,8
    8000519a:	fb791ee3          	bne	s2,s7,80005156 <sys_exec+0x64>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000519e:	100a0a13          	addi	s4,s4,256
    800051a2:	6088                	ld	a0,0(s1)
    800051a4:	c925                	beqz	a0,80005214 <sys_exec+0x122>
    kfree(argv[i]);
    800051a6:	ffffb097          	auipc	ra,0xffffb
    800051aa:	f0e080e7          	jalr	-242(ra) # 800000b4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051ae:	04a1                	addi	s1,s1,8
    800051b0:	ff4499e3          	bne	s1,s4,800051a2 <sys_exec+0xb0>
  return -1;
    800051b4:	597d                	li	s2,-1
    800051b6:	64be                	ld	s1,456(sp)
    800051b8:	79fa                	ld	s3,440(sp)
    800051ba:	7a5a                	ld	s4,432(sp)
    800051bc:	7aba                	ld	s5,424(sp)
    800051be:	7b1a                	ld	s6,416(sp)
    800051c0:	6bfa                	ld	s7,408(sp)
    800051c2:	a085                	j	80005222 <sys_exec+0x130>
      argv[i] = 0;
    800051c4:	0009079b          	sext.w	a5,s2
    800051c8:	e3040593          	addi	a1,s0,-464
    800051cc:	078e                	slli	a5,a5,0x3
    800051ce:	97ae                	add	a5,a5,a1
    800051d0:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800051d4:	f3040513          	addi	a0,s0,-208
    800051d8:	fffff097          	auipc	ra,0xfffff
    800051dc:	122080e7          	jalr	290(ra) # 800042fa <exec>
    800051e0:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051e2:	100a0a13          	addi	s4,s4,256
    800051e6:	6088                	ld	a0,0(s1)
    800051e8:	cd19                	beqz	a0,80005206 <sys_exec+0x114>
    kfree(argv[i]);
    800051ea:	ffffb097          	auipc	ra,0xffffb
    800051ee:	eca080e7          	jalr	-310(ra) # 800000b4 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051f2:	04a1                	addi	s1,s1,8
    800051f4:	ff4499e3          	bne	s1,s4,800051e6 <sys_exec+0xf4>
    800051f8:	64be                	ld	s1,456(sp)
    800051fa:	79fa                	ld	s3,440(sp)
    800051fc:	7a5a                	ld	s4,432(sp)
    800051fe:	7aba                	ld	s5,424(sp)
    80005200:	7b1a                	ld	s6,416(sp)
    80005202:	6bfa                	ld	s7,408(sp)
    80005204:	a839                	j	80005222 <sys_exec+0x130>
  return ret;
    80005206:	64be                	ld	s1,456(sp)
    80005208:	79fa                	ld	s3,440(sp)
    8000520a:	7a5a                	ld	s4,432(sp)
    8000520c:	7aba                	ld	s5,424(sp)
    8000520e:	7b1a                	ld	s6,416(sp)
    80005210:	6bfa                	ld	s7,408(sp)
    80005212:	a801                	j	80005222 <sys_exec+0x130>
  return -1;
    80005214:	597d                	li	s2,-1
    80005216:	64be                	ld	s1,456(sp)
    80005218:	79fa                	ld	s3,440(sp)
    8000521a:	7a5a                	ld	s4,432(sp)
    8000521c:	7aba                	ld	s5,424(sp)
    8000521e:	7b1a                	ld	s6,416(sp)
    80005220:	6bfa                	ld	s7,408(sp)
}
    80005222:	854a                	mv	a0,s2
    80005224:	60fe                	ld	ra,472(sp)
    80005226:	645e                	ld	s0,464(sp)
    80005228:	691e                	ld	s2,448(sp)
    8000522a:	613d                	addi	sp,sp,480
    8000522c:	8082                	ret

000000008000522e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000522e:	7139                	addi	sp,sp,-64
    80005230:	fc06                	sd	ra,56(sp)
    80005232:	f822                	sd	s0,48(sp)
    80005234:	f426                	sd	s1,40(sp)
    80005236:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005238:	ffffc097          	auipc	ra,0xffffc
    8000523c:	e5e080e7          	jalr	-418(ra) # 80001096 <myproc>
    80005240:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005242:	fd840593          	addi	a1,s0,-40
    80005246:	4501                	li	a0,0
    80005248:	ffffd097          	auipc	ra,0xffffd
    8000524c:	fe0080e7          	jalr	-32(ra) # 80002228 <argaddr>
    return -1;
    80005250:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005252:	0e054063          	bltz	a0,80005332 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005256:	fc840593          	addi	a1,s0,-56
    8000525a:	fd040513          	addi	a0,s0,-48
    8000525e:	fffff097          	auipc	ra,0xfffff
    80005262:	d32080e7          	jalr	-718(ra) # 80003f90 <pipealloc>
    return -1;
    80005266:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005268:	0c054563          	bltz	a0,80005332 <sys_pipe+0x104>
  fd0 = -1;
    8000526c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005270:	fd043503          	ld	a0,-48(s0)
    80005274:	fffff097          	auipc	ra,0xfffff
    80005278:	49e080e7          	jalr	1182(ra) # 80004712 <fdalloc>
    8000527c:	fca42223          	sw	a0,-60(s0)
    80005280:	08054c63          	bltz	a0,80005318 <sys_pipe+0xea>
    80005284:	fc843503          	ld	a0,-56(s0)
    80005288:	fffff097          	auipc	ra,0xfffff
    8000528c:	48a080e7          	jalr	1162(ra) # 80004712 <fdalloc>
    80005290:	fca42023          	sw	a0,-64(s0)
    80005294:	06054963          	bltz	a0,80005306 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005298:	4691                	li	a3,4
    8000529a:	fc440613          	addi	a2,s0,-60
    8000529e:	fd843583          	ld	a1,-40(s0)
    800052a2:	68a8                	ld	a0,80(s1)
    800052a4:	ffffc097          	auipc	ra,0xffffc
    800052a8:	a0a080e7          	jalr	-1526(ra) # 80000cae <copyout>
    800052ac:	02054063          	bltz	a0,800052cc <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052b0:	4691                	li	a3,4
    800052b2:	fc040613          	addi	a2,s0,-64
    800052b6:	fd843583          	ld	a1,-40(s0)
    800052ba:	95b6                	add	a1,a1,a3
    800052bc:	68a8                	ld	a0,80(s1)
    800052be:	ffffc097          	auipc	ra,0xffffc
    800052c2:	9f0080e7          	jalr	-1552(ra) # 80000cae <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052c6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052c8:	06055563          	bgez	a0,80005332 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800052cc:	fc442783          	lw	a5,-60(s0)
    800052d0:	07e9                	addi	a5,a5,26
    800052d2:	078e                	slli	a5,a5,0x3
    800052d4:	97a6                	add	a5,a5,s1
    800052d6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800052da:	fc042783          	lw	a5,-64(s0)
    800052de:	07e9                	addi	a5,a5,26
    800052e0:	078e                	slli	a5,a5,0x3
    800052e2:	00f48533          	add	a0,s1,a5
    800052e6:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    800052ea:	fd043503          	ld	a0,-48(s0)
    800052ee:	fffff097          	auipc	ra,0xfffff
    800052f2:	92e080e7          	jalr	-1746(ra) # 80003c1c <fileclose>
    fileclose(wf);
    800052f6:	fc843503          	ld	a0,-56(s0)
    800052fa:	fffff097          	auipc	ra,0xfffff
    800052fe:	922080e7          	jalr	-1758(ra) # 80003c1c <fileclose>
    return -1;
    80005302:	57fd                	li	a5,-1
    80005304:	a03d                	j	80005332 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005306:	fc442783          	lw	a5,-60(s0)
    8000530a:	0007c763          	bltz	a5,80005318 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000530e:	07e9                	addi	a5,a5,26
    80005310:	078e                	slli	a5,a5,0x3
    80005312:	97a6                	add	a5,a5,s1
    80005314:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005318:	fd043503          	ld	a0,-48(s0)
    8000531c:	fffff097          	auipc	ra,0xfffff
    80005320:	900080e7          	jalr	-1792(ra) # 80003c1c <fileclose>
    fileclose(wf);
    80005324:	fc843503          	ld	a0,-56(s0)
    80005328:	fffff097          	auipc	ra,0xfffff
    8000532c:	8f4080e7          	jalr	-1804(ra) # 80003c1c <fileclose>
    return -1;
    80005330:	57fd                	li	a5,-1
}
    80005332:	853e                	mv	a0,a5
    80005334:	70e2                	ld	ra,56(sp)
    80005336:	7442                	ld	s0,48(sp)
    80005338:	74a2                	ld	s1,40(sp)
    8000533a:	6121                	addi	sp,sp,64
    8000533c:	8082                	ret
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
    80005380:	cb9fc0ef          	jal	80002038 <kerneltrap>
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
    800053fc:	e406                	sd	ra,8(sp)
    800053fe:	e022                	sd	s0,0(sp)
    80005400:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005402:	0c000737          	lui	a4,0xc000
    80005406:	4785                	li	a5,1
    80005408:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000540a:	c35c                	sw	a5,4(a4)
}
    8000540c:	60a2                	ld	ra,8(sp)
    8000540e:	6402                	ld	s0,0(sp)
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
    80005420:	c46080e7          	jalr	-954(ra) # 80001062 <cpuid>
  
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
    80005458:	c0e080e7          	jalr	-1010(ra) # 80001062 <cpuid>
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
    80005480:	be6080e7          	jalr	-1050(ra) # 80001062 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005484:	00d5179b          	slliw	a5,a0,0xd
    80005488:	0c201737          	lui	a4,0xc201
    8000548c:	97ba                	add	a5,a5,a4
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
    800054a8:	00256717          	auipc	a4,0x256
    800054ac:	b5870713          	addi	a4,a4,-1192 # 8025b000 <disk>
    800054b0:	972a                	add	a4,a4,a0
    800054b2:	6789                	lui	a5,0x2
    800054b4:	97ba                	add	a5,a5,a4
    800054b6:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800054ba:	e7ad                	bnez	a5,80005524 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054bc:	00451793          	slli	a5,a0,0x4
    800054c0:	00258717          	auipc	a4,0x258
    800054c4:	b4070713          	addi	a4,a4,-1216 # 8025d000 <disk+0x2000>
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
    800054e8:	00256717          	auipc	a4,0x256
    800054ec:	b1870713          	addi	a4,a4,-1256 # 8025b000 <disk>
    800054f0:	972a                	add	a4,a4,a0
    800054f2:	6789                	lui	a5,0x2
    800054f4:	97ba                	add	a5,a5,a4
    800054f6:	4705                	li	a4,1
    800054f8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054fc:	00258517          	auipc	a0,0x258
    80005500:	b1c50513          	addi	a0,a0,-1252 # 8025d018 <disk+0x2018>
    80005504:	ffffc097          	auipc	ra,0xffffc
    80005508:	3de080e7          	jalr	990(ra) # 800018e2 <wakeup>
}
    8000550c:	60a2                	ld	ra,8(sp)
    8000550e:	6402                	ld	s0,0(sp)
    80005510:	0141                	addi	sp,sp,16
    80005512:	8082                	ret
    panic("free_desc 1");
    80005514:	00003517          	auipc	a0,0x3
    80005518:	0ec50513          	addi	a0,a0,236 # 80008600 <etext+0x600>
    8000551c:	00001097          	auipc	ra,0x1
    80005520:	9f6080e7          	jalr	-1546(ra) # 80005f12 <panic>
    panic("free_desc 2");
    80005524:	00003517          	auipc	a0,0x3
    80005528:	0ec50513          	addi	a0,a0,236 # 80008610 <etext+0x610>
    8000552c:	00001097          	auipc	ra,0x1
    80005530:	9e6080e7          	jalr	-1562(ra) # 80005f12 <panic>

0000000080005534 <virtio_disk_init>:
{
    80005534:	1141                	addi	sp,sp,-16
    80005536:	e406                	sd	ra,8(sp)
    80005538:	e022                	sd	s0,0(sp)
    8000553a:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000553c:	00003597          	auipc	a1,0x3
    80005540:	0e458593          	addi	a1,a1,228 # 80008620 <etext+0x620>
    80005544:	00258517          	auipc	a0,0x258
    80005548:	be450513          	addi	a0,a0,-1052 # 8025d128 <disk+0x2128>
    8000554c:	00001097          	auipc	ra,0x1
    80005550:	eb2080e7          	jalr	-334(ra) # 800063fe <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005554:	100017b7          	lui	a5,0x10001
    80005558:	4398                	lw	a4,0(a5)
    8000555a:	2701                	sext.w	a4,a4
    8000555c:	747277b7          	lui	a5,0x74727
    80005560:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005564:	0ef71563          	bne	a4,a5,8000564e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005568:	100017b7          	lui	a5,0x10001
    8000556c:	43dc                	lw	a5,4(a5)
    8000556e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005570:	4705                	li	a4,1
    80005572:	0ce79e63          	bne	a5,a4,8000564e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005576:	100017b7          	lui	a5,0x10001
    8000557a:	479c                	lw	a5,8(a5)
    8000557c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000557e:	4709                	li	a4,2
    80005580:	0ce79763          	bne	a5,a4,8000564e <virtio_disk_init+0x11a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005584:	100017b7          	lui	a5,0x10001
    80005588:	47d8                	lw	a4,12(a5)
    8000558a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000558c:	554d47b7          	lui	a5,0x554d4
    80005590:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005594:	0af71d63          	bne	a4,a5,8000564e <virtio_disk_init+0x11a>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005598:	100017b7          	lui	a5,0x10001
    8000559c:	4705                	li	a4,1
    8000559e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a0:	470d                	li	a4,3
    800055a2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055a4:	10001737          	lui	a4,0x10001
    800055a8:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055aa:	c7ffe6b7          	lui	a3,0xc7ffe
    800055ae:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47d9851f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055b2:	8f75                	and	a4,a4,a3
    800055b4:	100016b7          	lui	a3,0x10001
    800055b8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055ba:	472d                	li	a4,11
    800055bc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055be:	473d                	li	a4,15
    800055c0:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800055c2:	6705                	lui	a4,0x1
    800055c4:	d698                	sw	a4,40(a3)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055c6:	0206a823          	sw	zero,48(a3) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055ca:	5adc                	lw	a5,52(a3)
    800055cc:	2781                	sext.w	a5,a5
  if(max == 0)
    800055ce:	cbc1                	beqz	a5,8000565e <virtio_disk_init+0x12a>
  if(max < NUM)
    800055d0:	471d                	li	a4,7
    800055d2:	08f77e63          	bgeu	a4,a5,8000566e <virtio_disk_init+0x13a>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055d6:	100017b7          	lui	a5,0x10001
    800055da:	4721                	li	a4,8
    800055dc:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055de:	6609                	lui	a2,0x2
    800055e0:	4581                	li	a1,0
    800055e2:	00256517          	auipc	a0,0x256
    800055e6:	a1e50513          	addi	a0,a0,-1506 # 8025b000 <disk>
    800055ea:	ffffb097          	auipc	ra,0xffffb
    800055ee:	cce080e7          	jalr	-818(ra) # 800002b8 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800055f2:	00256717          	auipc	a4,0x256
    800055f6:	a0e70713          	addi	a4,a4,-1522 # 8025b000 <disk>
    800055fa:	00c75793          	srli	a5,a4,0xc
    800055fe:	2781                	sext.w	a5,a5
    80005600:	100016b7          	lui	a3,0x10001
    80005604:	c2bc                	sw	a5,64(a3)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005606:	00258797          	auipc	a5,0x258
    8000560a:	9fa78793          	addi	a5,a5,-1542 # 8025d000 <disk+0x2000>
    8000560e:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005610:	00256717          	auipc	a4,0x256
    80005614:	a7070713          	addi	a4,a4,-1424 # 8025b080 <disk+0x80>
    80005618:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000561a:	00257717          	auipc	a4,0x257
    8000561e:	9e670713          	addi	a4,a4,-1562 # 8025c000 <disk+0x1000>
    80005622:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005624:	4705                	li	a4,1
    80005626:	00e78c23          	sb	a4,24(a5)
    8000562a:	00e78ca3          	sb	a4,25(a5)
    8000562e:	00e78d23          	sb	a4,26(a5)
    80005632:	00e78da3          	sb	a4,27(a5)
    80005636:	00e78e23          	sb	a4,28(a5)
    8000563a:	00e78ea3          	sb	a4,29(a5)
    8000563e:	00e78f23          	sb	a4,30(a5)
    80005642:	00e78fa3          	sb	a4,31(a5)
}
    80005646:	60a2                	ld	ra,8(sp)
    80005648:	6402                	ld	s0,0(sp)
    8000564a:	0141                	addi	sp,sp,16
    8000564c:	8082                	ret
    panic("could not find virtio disk");
    8000564e:	00003517          	auipc	a0,0x3
    80005652:	fe250513          	addi	a0,a0,-30 # 80008630 <etext+0x630>
    80005656:	00001097          	auipc	ra,0x1
    8000565a:	8bc080e7          	jalr	-1860(ra) # 80005f12 <panic>
    panic("virtio disk has no queue 0");
    8000565e:	00003517          	auipc	a0,0x3
    80005662:	ff250513          	addi	a0,a0,-14 # 80008650 <etext+0x650>
    80005666:	00001097          	auipc	ra,0x1
    8000566a:	8ac080e7          	jalr	-1876(ra) # 80005f12 <panic>
    panic("virtio disk max queue too short");
    8000566e:	00003517          	auipc	a0,0x3
    80005672:	00250513          	addi	a0,a0,2 # 80008670 <etext+0x670>
    80005676:	00001097          	auipc	ra,0x1
    8000567a:	89c080e7          	jalr	-1892(ra) # 80005f12 <panic>

000000008000567e <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    8000567e:	711d                	addi	sp,sp,-96
    80005680:	ec86                	sd	ra,88(sp)
    80005682:	e8a2                	sd	s0,80(sp)
    80005684:	e4a6                	sd	s1,72(sp)
    80005686:	e0ca                	sd	s2,64(sp)
    80005688:	fc4e                	sd	s3,56(sp)
    8000568a:	f852                	sd	s4,48(sp)
    8000568c:	f456                	sd	s5,40(sp)
    8000568e:	f05a                	sd	s6,32(sp)
    80005690:	ec5e                	sd	s7,24(sp)
    80005692:	e862                	sd	s8,16(sp)
    80005694:	1080                	addi	s0,sp,96
    80005696:	89aa                	mv	s3,a0
    80005698:	8c2e                	mv	s8,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000569a:	00c52b83          	lw	s7,12(a0)
    8000569e:	001b9b9b          	slliw	s7,s7,0x1
    800056a2:	1b82                	slli	s7,s7,0x20
    800056a4:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800056a8:	00258517          	auipc	a0,0x258
    800056ac:	a8050513          	addi	a0,a0,-1408 # 8025d128 <disk+0x2128>
    800056b0:	00001097          	auipc	ra,0x1
    800056b4:	de2080e7          	jalr	-542(ra) # 80006492 <acquire>
  for(int i = 0; i < NUM; i++){
    800056b8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056ba:	00256b17          	auipc	s6,0x256
    800056be:	946b0b13          	addi	s6,s6,-1722 # 8025b000 <disk>
    800056c2:	6a89                	lui	s5,0x2
  for(int i = 0; i < 3; i++){
    800056c4:	4a0d                	li	s4,3
    800056c6:	a88d                	j	80005738 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800056c8:	00fb0733          	add	a4,s6,a5
    800056cc:	9756                	add	a4,a4,s5
    800056ce:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056d2:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056d4:	0207c563          	bltz	a5,800056fe <virtio_disk_rw+0x80>
  for(int i = 0; i < 3; i++){
    800056d8:	2905                	addiw	s2,s2,1
    800056da:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056dc:	1b490063          	beq	s2,s4,8000587c <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800056e0:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056e2:	00258717          	auipc	a4,0x258
    800056e6:	93670713          	addi	a4,a4,-1738 # 8025d018 <disk+0x2018>
    800056ea:	4781                	li	a5,0
    if(disk.free[i]){
    800056ec:	00074683          	lbu	a3,0(a4)
    800056f0:	fee1                	bnez	a3,800056c8 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    800056f2:	2785                	addiw	a5,a5,1
    800056f4:	0705                	addi	a4,a4,1
    800056f6:	fe979be3          	bne	a5,s1,800056ec <virtio_disk_rw+0x6e>
    idx[i] = alloc_desc();
    800056fa:	57fd                	li	a5,-1
    800056fc:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056fe:	03205163          	blez	s2,80005720 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005702:	fa042503          	lw	a0,-96(s0)
    80005706:	00000097          	auipc	ra,0x0
    8000570a:	d94080e7          	jalr	-620(ra) # 8000549a <free_desc>
      for(int j = 0; j < i; j++)
    8000570e:	4785                	li	a5,1
    80005710:	0127d863          	bge	a5,s2,80005720 <virtio_disk_rw+0xa2>
        free_desc(idx[j]);
    80005714:	fa442503          	lw	a0,-92(s0)
    80005718:	00000097          	auipc	ra,0x0
    8000571c:	d82080e7          	jalr	-638(ra) # 8000549a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005720:	00258597          	auipc	a1,0x258
    80005724:	a0858593          	addi	a1,a1,-1528 # 8025d128 <disk+0x2128>
    80005728:	00258517          	auipc	a0,0x258
    8000572c:	8f050513          	addi	a0,a0,-1808 # 8025d018 <disk+0x2018>
    80005730:	ffffc097          	auipc	ra,0xffffc
    80005734:	02c080e7          	jalr	44(ra) # 8000175c <sleep>
  for(int i = 0; i < 3; i++){
    80005738:	fa040613          	addi	a2,s0,-96
    8000573c:	4901                	li	s2,0
    8000573e:	b74d                	j	800056e0 <virtio_disk_rw+0x62>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005740:	00258717          	auipc	a4,0x258
    80005744:	8c073703          	ld	a4,-1856(a4) # 8025d000 <disk+0x2000>
    80005748:	973e                	add	a4,a4,a5
    8000574a:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000574e:	00256897          	auipc	a7,0x256
    80005752:	8b288893          	addi	a7,a7,-1870 # 8025b000 <disk>
    80005756:	00258717          	auipc	a4,0x258
    8000575a:	8aa70713          	addi	a4,a4,-1878 # 8025d000 <disk+0x2000>
    8000575e:	6314                	ld	a3,0(a4)
    80005760:	96be                	add	a3,a3,a5
    80005762:	00c6d583          	lhu	a1,12(a3) # 1000100c <_entry-0x6fffeff4>
    80005766:	0015e593          	ori	a1,a1,1
    8000576a:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    8000576e:	fa842683          	lw	a3,-88(s0)
    80005772:	630c                	ld	a1,0(a4)
    80005774:	97ae                	add	a5,a5,a1
    80005776:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000577a:	20050593          	addi	a1,a0,512
    8000577e:	0592                	slli	a1,a1,0x4
    80005780:	95c6                	add	a1,a1,a7
    80005782:	57fd                	li	a5,-1
    80005784:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005788:	00469793          	slli	a5,a3,0x4
    8000578c:	00073803          	ld	a6,0(a4)
    80005790:	983e                	add	a6,a6,a5
    80005792:	6689                	lui	a3,0x2
    80005794:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005798:	96b2                	add	a3,a3,a2
    8000579a:	96c6                	add	a3,a3,a7
    8000579c:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    800057a0:	6314                	ld	a3,0(a4)
    800057a2:	96be                	add	a3,a3,a5
    800057a4:	4605                	li	a2,1
    800057a6:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057a8:	6314                	ld	a3,0(a4)
    800057aa:	96be                	add	a3,a3,a5
    800057ac:	4809                	li	a6,2
    800057ae:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    800057b2:	6314                	ld	a3,0(a4)
    800057b4:	97b6                	add	a5,a5,a3
    800057b6:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057ba:	00c9a223          	sw	a2,4(s3)
  disk.info[idx[0]].b = b;
    800057be:	0335b423          	sd	s3,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057c2:	6714                	ld	a3,8(a4)
    800057c4:	0026d783          	lhu	a5,2(a3)
    800057c8:	8b9d                	andi	a5,a5,7
    800057ca:	0786                	slli	a5,a5,0x1
    800057cc:	96be                	add	a3,a3,a5
    800057ce:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800057d2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057d6:	6718                	ld	a4,8(a4)
    800057d8:	00275783          	lhu	a5,2(a4)
    800057dc:	2785                	addiw	a5,a5,1
    800057de:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057e2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057e6:	100017b7          	lui	a5,0x10001
    800057ea:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057ee:	0049a783          	lw	a5,4(s3)
    800057f2:	02c79163          	bne	a5,a2,80005814 <virtio_disk_rw+0x196>
    sleep(b, &disk.vdisk_lock);
    800057f6:	00258917          	auipc	s2,0x258
    800057fa:	93290913          	addi	s2,s2,-1742 # 8025d128 <disk+0x2128>
  while(b->disk == 1) {
    800057fe:	84b2                	mv	s1,a2
    sleep(b, &disk.vdisk_lock);
    80005800:	85ca                	mv	a1,s2
    80005802:	854e                	mv	a0,s3
    80005804:	ffffc097          	auipc	ra,0xffffc
    80005808:	f58080e7          	jalr	-168(ra) # 8000175c <sleep>
  while(b->disk == 1) {
    8000580c:	0049a783          	lw	a5,4(s3)
    80005810:	fe9788e3          	beq	a5,s1,80005800 <virtio_disk_rw+0x182>
  }

  disk.info[idx[0]].b = 0;
    80005814:	fa042903          	lw	s2,-96(s0)
    80005818:	20090713          	addi	a4,s2,512
    8000581c:	0712                	slli	a4,a4,0x4
    8000581e:	00255797          	auipc	a5,0x255
    80005822:	7e278793          	addi	a5,a5,2018 # 8025b000 <disk>
    80005826:	97ba                	add	a5,a5,a4
    80005828:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000582c:	00257997          	auipc	s3,0x257
    80005830:	7d498993          	addi	s3,s3,2004 # 8025d000 <disk+0x2000>
    80005834:	00491713          	slli	a4,s2,0x4
    80005838:	0009b783          	ld	a5,0(s3)
    8000583c:	97ba                	add	a5,a5,a4
    8000583e:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005842:	854a                	mv	a0,s2
    80005844:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005848:	00000097          	auipc	ra,0x0
    8000584c:	c52080e7          	jalr	-942(ra) # 8000549a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005850:	8885                	andi	s1,s1,1
    80005852:	f0ed                	bnez	s1,80005834 <virtio_disk_rw+0x1b6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005854:	00258517          	auipc	a0,0x258
    80005858:	8d450513          	addi	a0,a0,-1836 # 8025d128 <disk+0x2128>
    8000585c:	00001097          	auipc	ra,0x1
    80005860:	ce6080e7          	jalr	-794(ra) # 80006542 <release>
}
    80005864:	60e6                	ld	ra,88(sp)
    80005866:	6446                	ld	s0,80(sp)
    80005868:	64a6                	ld	s1,72(sp)
    8000586a:	6906                	ld	s2,64(sp)
    8000586c:	79e2                	ld	s3,56(sp)
    8000586e:	7a42                	ld	s4,48(sp)
    80005870:	7aa2                	ld	s5,40(sp)
    80005872:	7b02                	ld	s6,32(sp)
    80005874:	6be2                	ld	s7,24(sp)
    80005876:	6c42                	ld	s8,16(sp)
    80005878:	6125                	addi	sp,sp,96
    8000587a:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000587c:	fa042503          	lw	a0,-96(s0)
    80005880:	00451613          	slli	a2,a0,0x4
  if(write)
    80005884:	00255597          	auipc	a1,0x255
    80005888:	77c58593          	addi	a1,a1,1916 # 8025b000 <disk>
    8000588c:	20050793          	addi	a5,a0,512
    80005890:	0792                	slli	a5,a5,0x4
    80005892:	97ae                	add	a5,a5,a1
    80005894:	01803733          	snez	a4,s8
    80005898:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    8000589c:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    800058a0:	0b77b823          	sd	s7,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058a4:	00257717          	auipc	a4,0x257
    800058a8:	75c70713          	addi	a4,a4,1884 # 8025d000 <disk+0x2000>
    800058ac:	6314                	ld	a3,0(a4)
    800058ae:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058b0:	6789                	lui	a5,0x2
    800058b2:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    800058b6:	97b2                	add	a5,a5,a2
    800058b8:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058ba:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058bc:	631c                	ld	a5,0(a4)
    800058be:	97b2                	add	a5,a5,a2
    800058c0:	46c1                	li	a3,16
    800058c2:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058c4:	631c                	ld	a5,0(a4)
    800058c6:	97b2                	add	a5,a5,a2
    800058c8:	4685                	li	a3,1
    800058ca:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    800058ce:	fa442783          	lw	a5,-92(s0)
    800058d2:	6314                	ld	a3,0(a4)
    800058d4:	96b2                	add	a3,a3,a2
    800058d6:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058da:	0792                	slli	a5,a5,0x4
    800058dc:	6314                	ld	a3,0(a4)
    800058de:	96be                	add	a3,a3,a5
    800058e0:	05898593          	addi	a1,s3,88
    800058e4:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800058e6:	6318                	ld	a4,0(a4)
    800058e8:	973e                	add	a4,a4,a5
    800058ea:	40000693          	li	a3,1024
    800058ee:	c714                	sw	a3,8(a4)
  if(write)
    800058f0:	e40c18e3          	bnez	s8,80005740 <virtio_disk_rw+0xc2>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058f4:	00257717          	auipc	a4,0x257
    800058f8:	70c73703          	ld	a4,1804(a4) # 8025d000 <disk+0x2000>
    800058fc:	973e                	add	a4,a4,a5
    800058fe:	4689                	li	a3,2
    80005900:	00d71623          	sh	a3,12(a4)
    80005904:	b5a9                	j	8000574e <virtio_disk_rw+0xd0>

0000000080005906 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005906:	1101                	addi	sp,sp,-32
    80005908:	ec06                	sd	ra,24(sp)
    8000590a:	e822                	sd	s0,16(sp)
    8000590c:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000590e:	00258517          	auipc	a0,0x258
    80005912:	81a50513          	addi	a0,a0,-2022 # 8025d128 <disk+0x2128>
    80005916:	00001097          	auipc	ra,0x1
    8000591a:	b7c080e7          	jalr	-1156(ra) # 80006492 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000591e:	100017b7          	lui	a5,0x10001
    80005922:	53bc                	lw	a5,96(a5)
    80005924:	8b8d                	andi	a5,a5,3
    80005926:	10001737          	lui	a4,0x10001
    8000592a:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000592c:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005930:	00257797          	auipc	a5,0x257
    80005934:	6d078793          	addi	a5,a5,1744 # 8025d000 <disk+0x2000>
    80005938:	6b94                	ld	a3,16(a5)
    8000593a:	0207d703          	lhu	a4,32(a5)
    8000593e:	0026d783          	lhu	a5,2(a3)
    80005942:	06f70563          	beq	a4,a5,800059ac <virtio_disk_intr+0xa6>
    80005946:	e426                	sd	s1,8(sp)
    80005948:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000594a:	00255917          	auipc	s2,0x255
    8000594e:	6b690913          	addi	s2,s2,1718 # 8025b000 <disk>
    80005952:	00257497          	auipc	s1,0x257
    80005956:	6ae48493          	addi	s1,s1,1710 # 8025d000 <disk+0x2000>
    __sync_synchronize();
    8000595a:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000595e:	6898                	ld	a4,16(s1)
    80005960:	0204d783          	lhu	a5,32(s1)
    80005964:	8b9d                	andi	a5,a5,7
    80005966:	078e                	slli	a5,a5,0x3
    80005968:	97ba                	add	a5,a5,a4
    8000596a:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000596c:	20078713          	addi	a4,a5,512
    80005970:	0712                	slli	a4,a4,0x4
    80005972:	974a                	add	a4,a4,s2
    80005974:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005978:	e731                	bnez	a4,800059c4 <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000597a:	20078793          	addi	a5,a5,512
    8000597e:	0792                	slli	a5,a5,0x4
    80005980:	97ca                	add	a5,a5,s2
    80005982:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005984:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005988:	ffffc097          	auipc	ra,0xffffc
    8000598c:	f5a080e7          	jalr	-166(ra) # 800018e2 <wakeup>

    disk.used_idx += 1;
    80005990:	0204d783          	lhu	a5,32(s1)
    80005994:	2785                	addiw	a5,a5,1
    80005996:	17c2                	slli	a5,a5,0x30
    80005998:	93c1                	srli	a5,a5,0x30
    8000599a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000599e:	6898                	ld	a4,16(s1)
    800059a0:	00275703          	lhu	a4,2(a4)
    800059a4:	faf71be3          	bne	a4,a5,8000595a <virtio_disk_intr+0x54>
    800059a8:	64a2                	ld	s1,8(sp)
    800059aa:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    800059ac:	00257517          	auipc	a0,0x257
    800059b0:	77c50513          	addi	a0,a0,1916 # 8025d128 <disk+0x2128>
    800059b4:	00001097          	auipc	ra,0x1
    800059b8:	b8e080e7          	jalr	-1138(ra) # 80006542 <release>
}
    800059bc:	60e2                	ld	ra,24(sp)
    800059be:	6442                	ld	s0,16(sp)
    800059c0:	6105                	addi	sp,sp,32
    800059c2:	8082                	ret
      panic("virtio_disk_intr status");
    800059c4:	00003517          	auipc	a0,0x3
    800059c8:	ccc50513          	addi	a0,a0,-820 # 80008690 <etext+0x690>
    800059cc:	00000097          	auipc	ra,0x0
    800059d0:	546080e7          	jalr	1350(ra) # 80005f12 <panic>

00000000800059d4 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800059d4:	1141                	addi	sp,sp,-16
    800059d6:	e406                	sd	ra,8(sp)
    800059d8:	e022                	sd	s0,0(sp)
    800059da:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059dc:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059e0:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059e2:	0037961b          	slliw	a2,a5,0x3
    800059e6:	02004737          	lui	a4,0x2004
    800059ea:	963a                	add	a2,a2,a4
    800059ec:	0200c737          	lui	a4,0x200c
    800059f0:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800059f4:	000f46b7          	lui	a3,0xf4
    800059f8:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    800059fc:	9736                	add	a4,a4,a3
    800059fe:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a00:	00279713          	slli	a4,a5,0x2
    80005a04:	973e                	add	a4,a4,a5
    80005a06:	070e                	slli	a4,a4,0x3
    80005a08:	00258797          	auipc	a5,0x258
    80005a0c:	5f878793          	addi	a5,a5,1528 # 8025e000 <timer_scratch>
    80005a10:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    80005a12:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    80005a14:	f394                	sd	a3,32(a5)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a16:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a1a:	00000797          	auipc	a5,0x0
    80005a1e:	9b678793          	addi	a5,a5,-1610 # 800053d0 <timervec>
    80005a22:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a26:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a2a:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a2e:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a32:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a36:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a3a:	30479073          	csrw	mie,a5
}
    80005a3e:	60a2                	ld	ra,8(sp)
    80005a40:	6402                	ld	s0,0(sp)
    80005a42:	0141                	addi	sp,sp,16
    80005a44:	8082                	ret

0000000080005a46 <start>:
{
    80005a46:	1141                	addi	sp,sp,-16
    80005a48:	e406                	sd	ra,8(sp)
    80005a4a:	e022                	sd	s0,0(sp)
    80005a4c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a4e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a52:	7779                	lui	a4,0xffffe
    80005a54:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fd985bf>
    80005a58:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a5a:	6705                	lui	a4,0x1
    80005a5c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a60:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a62:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a66:	ffffb797          	auipc	a5,0xffffb
    80005a6a:	a0c78793          	addi	a5,a5,-1524 # 80000472 <main>
    80005a6e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a72:	4781                	li	a5,0
    80005a74:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a78:	67c1                	lui	a5,0x10
    80005a7a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a7c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a80:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a84:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a88:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a8c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a90:	57fd                	li	a5,-1
    80005a92:	83a9                	srli	a5,a5,0xa
    80005a94:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a98:	47bd                	li	a5,15
    80005a9a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a9e:	00000097          	auipc	ra,0x0
    80005aa2:	f36080e7          	jalr	-202(ra) # 800059d4 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005aa6:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005aaa:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005aac:	823e                	mv	tp,a5
  asm volatile("mret");
    80005aae:	30200073          	mret
}
    80005ab2:	60a2                	ld	ra,8(sp)
    80005ab4:	6402                	ld	s0,0(sp)
    80005ab6:	0141                	addi	sp,sp,16
    80005ab8:	8082                	ret

0000000080005aba <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005aba:	711d                	addi	sp,sp,-96
    80005abc:	ec86                	sd	ra,88(sp)
    80005abe:	e8a2                	sd	s0,80(sp)
    80005ac0:	e0ca                	sd	s2,64(sp)
    80005ac2:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80005ac4:	04c05c63          	blez	a2,80005b1c <consolewrite+0x62>
    80005ac8:	e4a6                	sd	s1,72(sp)
    80005aca:	fc4e                	sd	s3,56(sp)
    80005acc:	f852                	sd	s4,48(sp)
    80005ace:	f456                	sd	s5,40(sp)
    80005ad0:	f05a                	sd	s6,32(sp)
    80005ad2:	ec5e                	sd	s7,24(sp)
    80005ad4:	8a2a                	mv	s4,a0
    80005ad6:	84ae                	mv	s1,a1
    80005ad8:	89b2                	mv	s3,a2
    80005ada:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005adc:	faf40b93          	addi	s7,s0,-81
    80005ae0:	4b05                	li	s6,1
    80005ae2:	5afd                	li	s5,-1
    80005ae4:	86da                	mv	a3,s6
    80005ae6:	8626                	mv	a2,s1
    80005ae8:	85d2                	mv	a1,s4
    80005aea:	855e                	mv	a0,s7
    80005aec:	ffffc097          	auipc	ra,0xffffc
    80005af0:	064080e7          	jalr	100(ra) # 80001b50 <either_copyin>
    80005af4:	03550663          	beq	a0,s5,80005b20 <consolewrite+0x66>
      break;
    uartputc(c);
    80005af8:	faf44503          	lbu	a0,-81(s0)
    80005afc:	00000097          	auipc	ra,0x0
    80005b00:	7d4080e7          	jalr	2004(ra) # 800062d0 <uartputc>
  for(i = 0; i < n; i++){
    80005b04:	2905                	addiw	s2,s2,1
    80005b06:	0485                	addi	s1,s1,1
    80005b08:	fd299ee3          	bne	s3,s2,80005ae4 <consolewrite+0x2a>
    80005b0c:	894e                	mv	s2,s3
    80005b0e:	64a6                	ld	s1,72(sp)
    80005b10:	79e2                	ld	s3,56(sp)
    80005b12:	7a42                	ld	s4,48(sp)
    80005b14:	7aa2                	ld	s5,40(sp)
    80005b16:	7b02                	ld	s6,32(sp)
    80005b18:	6be2                	ld	s7,24(sp)
    80005b1a:	a809                	j	80005b2c <consolewrite+0x72>
    80005b1c:	4901                	li	s2,0
    80005b1e:	a039                	j	80005b2c <consolewrite+0x72>
    80005b20:	64a6                	ld	s1,72(sp)
    80005b22:	79e2                	ld	s3,56(sp)
    80005b24:	7a42                	ld	s4,48(sp)
    80005b26:	7aa2                	ld	s5,40(sp)
    80005b28:	7b02                	ld	s6,32(sp)
    80005b2a:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80005b2c:	854a                	mv	a0,s2
    80005b2e:	60e6                	ld	ra,88(sp)
    80005b30:	6446                	ld	s0,80(sp)
    80005b32:	6906                	ld	s2,64(sp)
    80005b34:	6125                	addi	sp,sp,96
    80005b36:	8082                	ret

0000000080005b38 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b38:	711d                	addi	sp,sp,-96
    80005b3a:	ec86                	sd	ra,88(sp)
    80005b3c:	e8a2                	sd	s0,80(sp)
    80005b3e:	e4a6                	sd	s1,72(sp)
    80005b40:	e0ca                	sd	s2,64(sp)
    80005b42:	fc4e                	sd	s3,56(sp)
    80005b44:	f852                	sd	s4,48(sp)
    80005b46:	f456                	sd	s5,40(sp)
    80005b48:	f05a                	sd	s6,32(sp)
    80005b4a:	1080                	addi	s0,sp,96
    80005b4c:	8aaa                	mv	s5,a0
    80005b4e:	8a2e                	mv	s4,a1
    80005b50:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b52:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    80005b54:	00260517          	auipc	a0,0x260
    80005b58:	5ec50513          	addi	a0,a0,1516 # 80266140 <cons>
    80005b5c:	00001097          	auipc	ra,0x1
    80005b60:	936080e7          	jalr	-1738(ra) # 80006492 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b64:	00260497          	auipc	s1,0x260
    80005b68:	5dc48493          	addi	s1,s1,1500 # 80266140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b6c:	00260917          	auipc	s2,0x260
    80005b70:	66c90913          	addi	s2,s2,1644 # 802661d8 <cons+0x98>
  while(n > 0){
    80005b74:	0d305263          	blez	s3,80005c38 <consoleread+0x100>
    while(cons.r == cons.w){
    80005b78:	0984a783          	lw	a5,152(s1)
    80005b7c:	09c4a703          	lw	a4,156(s1)
    80005b80:	0af71763          	bne	a4,a5,80005c2e <consoleread+0xf6>
      if(myproc()->killed){
    80005b84:	ffffb097          	auipc	ra,0xffffb
    80005b88:	512080e7          	jalr	1298(ra) # 80001096 <myproc>
    80005b8c:	551c                	lw	a5,40(a0)
    80005b8e:	e7ad                	bnez	a5,80005bf8 <consoleread+0xc0>
      sleep(&cons.r, &cons.lock);
    80005b90:	85a6                	mv	a1,s1
    80005b92:	854a                	mv	a0,s2
    80005b94:	ffffc097          	auipc	ra,0xffffc
    80005b98:	bc8080e7          	jalr	-1080(ra) # 8000175c <sleep>
    while(cons.r == cons.w){
    80005b9c:	0984a783          	lw	a5,152(s1)
    80005ba0:	09c4a703          	lw	a4,156(s1)
    80005ba4:	fef700e3          	beq	a4,a5,80005b84 <consoleread+0x4c>
    80005ba8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005baa:	00260717          	auipc	a4,0x260
    80005bae:	59670713          	addi	a4,a4,1430 # 80266140 <cons>
    80005bb2:	0017869b          	addiw	a3,a5,1
    80005bb6:	08d72c23          	sw	a3,152(a4)
    80005bba:	07f7f693          	andi	a3,a5,127
    80005bbe:	9736                	add	a4,a4,a3
    80005bc0:	01874703          	lbu	a4,24(a4)
    80005bc4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005bc8:	4691                	li	a3,4
    80005bca:	04db8a63          	beq	s7,a3,80005c1e <consoleread+0xe6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005bce:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bd2:	4685                	li	a3,1
    80005bd4:	faf40613          	addi	a2,s0,-81
    80005bd8:	85d2                	mv	a1,s4
    80005bda:	8556                	mv	a0,s5
    80005bdc:	ffffc097          	auipc	ra,0xffffc
    80005be0:	f1e080e7          	jalr	-226(ra) # 80001afa <either_copyout>
    80005be4:	57fd                	li	a5,-1
    80005be6:	04f50863          	beq	a0,a5,80005c36 <consoleread+0xfe>
      break;

    dst++;
    80005bea:	0a05                	addi	s4,s4,1
    --n;
    80005bec:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005bee:	47a9                	li	a5,10
    80005bf0:	04fb8f63          	beq	s7,a5,80005c4e <consoleread+0x116>
    80005bf4:	6be2                	ld	s7,24(sp)
    80005bf6:	bfbd                	j	80005b74 <consoleread+0x3c>
        release(&cons.lock);
    80005bf8:	00260517          	auipc	a0,0x260
    80005bfc:	54850513          	addi	a0,a0,1352 # 80266140 <cons>
    80005c00:	00001097          	auipc	ra,0x1
    80005c04:	942080e7          	jalr	-1726(ra) # 80006542 <release>
        return -1;
    80005c08:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005c0a:	60e6                	ld	ra,88(sp)
    80005c0c:	6446                	ld	s0,80(sp)
    80005c0e:	64a6                	ld	s1,72(sp)
    80005c10:	6906                	ld	s2,64(sp)
    80005c12:	79e2                	ld	s3,56(sp)
    80005c14:	7a42                	ld	s4,48(sp)
    80005c16:	7aa2                	ld	s5,40(sp)
    80005c18:	7b02                	ld	s6,32(sp)
    80005c1a:	6125                	addi	sp,sp,96
    80005c1c:	8082                	ret
      if(n < target){
    80005c1e:	0169fa63          	bgeu	s3,s6,80005c32 <consoleread+0xfa>
        cons.r--;
    80005c22:	00260717          	auipc	a4,0x260
    80005c26:	5af72b23          	sw	a5,1462(a4) # 802661d8 <cons+0x98>
    80005c2a:	6be2                	ld	s7,24(sp)
    80005c2c:	a031                	j	80005c38 <consoleread+0x100>
    80005c2e:	ec5e                	sd	s7,24(sp)
    80005c30:	bfad                	j	80005baa <consoleread+0x72>
    80005c32:	6be2                	ld	s7,24(sp)
    80005c34:	a011                	j	80005c38 <consoleread+0x100>
    80005c36:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005c38:	00260517          	auipc	a0,0x260
    80005c3c:	50850513          	addi	a0,a0,1288 # 80266140 <cons>
    80005c40:	00001097          	auipc	ra,0x1
    80005c44:	902080e7          	jalr	-1790(ra) # 80006542 <release>
  return target - n;
    80005c48:	413b053b          	subw	a0,s6,s3
    80005c4c:	bf7d                	j	80005c0a <consoleread+0xd2>
    80005c4e:	6be2                	ld	s7,24(sp)
    80005c50:	b7e5                	j	80005c38 <consoleread+0x100>

0000000080005c52 <consputc>:
{
    80005c52:	1141                	addi	sp,sp,-16
    80005c54:	e406                	sd	ra,8(sp)
    80005c56:	e022                	sd	s0,0(sp)
    80005c58:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c5a:	10000793          	li	a5,256
    80005c5e:	00f50a63          	beq	a0,a5,80005c72 <consputc+0x20>
    uartputc_sync(c);
    80005c62:	00000097          	auipc	ra,0x0
    80005c66:	590080e7          	jalr	1424(ra) # 800061f2 <uartputc_sync>
}
    80005c6a:	60a2                	ld	ra,8(sp)
    80005c6c:	6402                	ld	s0,0(sp)
    80005c6e:	0141                	addi	sp,sp,16
    80005c70:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c72:	4521                	li	a0,8
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	57e080e7          	jalr	1406(ra) # 800061f2 <uartputc_sync>
    80005c7c:	02000513          	li	a0,32
    80005c80:	00000097          	auipc	ra,0x0
    80005c84:	572080e7          	jalr	1394(ra) # 800061f2 <uartputc_sync>
    80005c88:	4521                	li	a0,8
    80005c8a:	00000097          	auipc	ra,0x0
    80005c8e:	568080e7          	jalr	1384(ra) # 800061f2 <uartputc_sync>
    80005c92:	bfe1                	j	80005c6a <consputc+0x18>

0000000080005c94 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c94:	7179                	addi	sp,sp,-48
    80005c96:	f406                	sd	ra,40(sp)
    80005c98:	f022                	sd	s0,32(sp)
    80005c9a:	ec26                	sd	s1,24(sp)
    80005c9c:	1800                	addi	s0,sp,48
    80005c9e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005ca0:	00260517          	auipc	a0,0x260
    80005ca4:	4a050513          	addi	a0,a0,1184 # 80266140 <cons>
    80005ca8:	00000097          	auipc	ra,0x0
    80005cac:	7ea080e7          	jalr	2026(ra) # 80006492 <acquire>

  switch(c){
    80005cb0:	47d5                	li	a5,21
    80005cb2:	0af48463          	beq	s1,a5,80005d5a <consoleintr+0xc6>
    80005cb6:	0297c963          	blt	a5,s1,80005ce8 <consoleintr+0x54>
    80005cba:	47a1                	li	a5,8
    80005cbc:	10f48063          	beq	s1,a5,80005dbc <consoleintr+0x128>
    80005cc0:	47c1                	li	a5,16
    80005cc2:	12f49363          	bne	s1,a5,80005de8 <consoleintr+0x154>
  case C('P'):  // Print process list.
    procdump();
    80005cc6:	ffffc097          	auipc	ra,0xffffc
    80005cca:	ee0080e7          	jalr	-288(ra) # 80001ba6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005cce:	00260517          	auipc	a0,0x260
    80005cd2:	47250513          	addi	a0,a0,1138 # 80266140 <cons>
    80005cd6:	00001097          	auipc	ra,0x1
    80005cda:	86c080e7          	jalr	-1940(ra) # 80006542 <release>
}
    80005cde:	70a2                	ld	ra,40(sp)
    80005ce0:	7402                	ld	s0,32(sp)
    80005ce2:	64e2                	ld	s1,24(sp)
    80005ce4:	6145                	addi	sp,sp,48
    80005ce6:	8082                	ret
  switch(c){
    80005ce8:	07f00793          	li	a5,127
    80005cec:	0cf48863          	beq	s1,a5,80005dbc <consoleintr+0x128>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cf0:	00260717          	auipc	a4,0x260
    80005cf4:	45070713          	addi	a4,a4,1104 # 80266140 <cons>
    80005cf8:	0a072783          	lw	a5,160(a4)
    80005cfc:	09872703          	lw	a4,152(a4)
    80005d00:	9f99                	subw	a5,a5,a4
    80005d02:	07f00713          	li	a4,127
    80005d06:	fcf764e3          	bltu	a4,a5,80005cce <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005d0a:	47b5                	li	a5,13
    80005d0c:	0ef48163          	beq	s1,a5,80005dee <consoleintr+0x15a>
      consputc(c);
    80005d10:	8526                	mv	a0,s1
    80005d12:	00000097          	auipc	ra,0x0
    80005d16:	f40080e7          	jalr	-192(ra) # 80005c52 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d1a:	00260797          	auipc	a5,0x260
    80005d1e:	42678793          	addi	a5,a5,1062 # 80266140 <cons>
    80005d22:	0a07a703          	lw	a4,160(a5)
    80005d26:	0017069b          	addiw	a3,a4,1
    80005d2a:	8636                	mv	a2,a3
    80005d2c:	0ad7a023          	sw	a3,160(a5)
    80005d30:	07f77713          	andi	a4,a4,127
    80005d34:	97ba                	add	a5,a5,a4
    80005d36:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005d3a:	47a9                	li	a5,10
    80005d3c:	0cf48f63          	beq	s1,a5,80005e1a <consoleintr+0x186>
    80005d40:	4791                	li	a5,4
    80005d42:	0cf48c63          	beq	s1,a5,80005e1a <consoleintr+0x186>
    80005d46:	00260797          	auipc	a5,0x260
    80005d4a:	4927a783          	lw	a5,1170(a5) # 802661d8 <cons+0x98>
    80005d4e:	0807879b          	addiw	a5,a5,128
    80005d52:	f6f69ee3          	bne	a3,a5,80005cce <consoleintr+0x3a>
    80005d56:	863e                	mv	a2,a5
    80005d58:	a0c9                	j	80005e1a <consoleintr+0x186>
    80005d5a:	e84a                	sd	s2,16(sp)
    80005d5c:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005d5e:	00260717          	auipc	a4,0x260
    80005d62:	3e270713          	addi	a4,a4,994 # 80266140 <cons>
    80005d66:	0a072783          	lw	a5,160(a4)
    80005d6a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d6e:	00260497          	auipc	s1,0x260
    80005d72:	3d248493          	addi	s1,s1,978 # 80266140 <cons>
    while(cons.e != cons.w &&
    80005d76:	4929                	li	s2,10
      consputc(BACKSPACE);
    80005d78:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005d7c:	02f70a63          	beq	a4,a5,80005db0 <consoleintr+0x11c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d80:	37fd                	addiw	a5,a5,-1
    80005d82:	07f7f713          	andi	a4,a5,127
    80005d86:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d88:	01874703          	lbu	a4,24(a4)
    80005d8c:	03270563          	beq	a4,s2,80005db6 <consoleintr+0x122>
      cons.e--;
    80005d90:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d94:	854e                	mv	a0,s3
    80005d96:	00000097          	auipc	ra,0x0
    80005d9a:	ebc080e7          	jalr	-324(ra) # 80005c52 <consputc>
    while(cons.e != cons.w &&
    80005d9e:	0a04a783          	lw	a5,160(s1)
    80005da2:	09c4a703          	lw	a4,156(s1)
    80005da6:	fcf71de3          	bne	a4,a5,80005d80 <consoleintr+0xec>
    80005daa:	6942                	ld	s2,16(sp)
    80005dac:	69a2                	ld	s3,8(sp)
    80005dae:	b705                	j	80005cce <consoleintr+0x3a>
    80005db0:	6942                	ld	s2,16(sp)
    80005db2:	69a2                	ld	s3,8(sp)
    80005db4:	bf29                	j	80005cce <consoleintr+0x3a>
    80005db6:	6942                	ld	s2,16(sp)
    80005db8:	69a2                	ld	s3,8(sp)
    80005dba:	bf11                	j	80005cce <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005dbc:	00260717          	auipc	a4,0x260
    80005dc0:	38470713          	addi	a4,a4,900 # 80266140 <cons>
    80005dc4:	0a072783          	lw	a5,160(a4)
    80005dc8:	09c72703          	lw	a4,156(a4)
    80005dcc:	f0f701e3          	beq	a4,a5,80005cce <consoleintr+0x3a>
      cons.e--;
    80005dd0:	37fd                	addiw	a5,a5,-1
    80005dd2:	00260717          	auipc	a4,0x260
    80005dd6:	40f72723          	sw	a5,1038(a4) # 802661e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005dda:	10000513          	li	a0,256
    80005dde:	00000097          	auipc	ra,0x0
    80005de2:	e74080e7          	jalr	-396(ra) # 80005c52 <consputc>
    80005de6:	b5e5                	j	80005cce <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005de8:	ee0483e3          	beqz	s1,80005cce <consoleintr+0x3a>
    80005dec:	b711                	j	80005cf0 <consoleintr+0x5c>
      consputc(c);
    80005dee:	4529                	li	a0,10
    80005df0:	00000097          	auipc	ra,0x0
    80005df4:	e62080e7          	jalr	-414(ra) # 80005c52 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005df8:	00260797          	auipc	a5,0x260
    80005dfc:	34878793          	addi	a5,a5,840 # 80266140 <cons>
    80005e00:	0a07a703          	lw	a4,160(a5)
    80005e04:	0017069b          	addiw	a3,a4,1
    80005e08:	8636                	mv	a2,a3
    80005e0a:	0ad7a023          	sw	a3,160(a5)
    80005e0e:	07f77713          	andi	a4,a4,127
    80005e12:	97ba                	add	a5,a5,a4
    80005e14:	4729                	li	a4,10
    80005e16:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e1a:	00260797          	auipc	a5,0x260
    80005e1e:	3cc7a123          	sw	a2,962(a5) # 802661dc <cons+0x9c>
        wakeup(&cons.r);
    80005e22:	00260517          	auipc	a0,0x260
    80005e26:	3b650513          	addi	a0,a0,950 # 802661d8 <cons+0x98>
    80005e2a:	ffffc097          	auipc	ra,0xffffc
    80005e2e:	ab8080e7          	jalr	-1352(ra) # 800018e2 <wakeup>
    80005e32:	bd71                	j	80005cce <consoleintr+0x3a>

0000000080005e34 <consoleinit>:

void
consoleinit(void)
{
    80005e34:	1141                	addi	sp,sp,-16
    80005e36:	e406                	sd	ra,8(sp)
    80005e38:	e022                	sd	s0,0(sp)
    80005e3a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e3c:	00003597          	auipc	a1,0x3
    80005e40:	86c58593          	addi	a1,a1,-1940 # 800086a8 <etext+0x6a8>
    80005e44:	00260517          	auipc	a0,0x260
    80005e48:	2fc50513          	addi	a0,a0,764 # 80266140 <cons>
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	5b2080e7          	jalr	1458(ra) # 800063fe <initlock>

  uartinit();
    80005e54:	00000097          	auipc	ra,0x0
    80005e58:	344080e7          	jalr	836(ra) # 80006198 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e5c:	00253797          	auipc	a5,0x253
    80005e60:	2a478793          	addi	a5,a5,676 # 80259100 <devsw>
    80005e64:	00000717          	auipc	a4,0x0
    80005e68:	cd470713          	addi	a4,a4,-812 # 80005b38 <consoleread>
    80005e6c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e6e:	00000717          	auipc	a4,0x0
    80005e72:	c4c70713          	addi	a4,a4,-948 # 80005aba <consolewrite>
    80005e76:	ef98                	sd	a4,24(a5)
}
    80005e78:	60a2                	ld	ra,8(sp)
    80005e7a:	6402                	ld	s0,0(sp)
    80005e7c:	0141                	addi	sp,sp,16
    80005e7e:	8082                	ret

0000000080005e80 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e80:	7179                	addi	sp,sp,-48
    80005e82:	f406                	sd	ra,40(sp)
    80005e84:	f022                	sd	s0,32(sp)
    80005e86:	ec26                	sd	s1,24(sp)
    80005e88:	e84a                	sd	s2,16(sp)
    80005e8a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e8c:	c219                	beqz	a2,80005e92 <printint+0x12>
    80005e8e:	06054e63          	bltz	a0,80005f0a <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80005e92:	4e01                	li	t3,0

  i = 0;
    80005e94:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005e98:	869a                	mv	a3,t1
  i = 0;
    80005e9a:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005e9c:	00003817          	auipc	a6,0x3
    80005ea0:	96c80813          	addi	a6,a6,-1684 # 80008808 <digits>
    80005ea4:	88be                	mv	a7,a5
    80005ea6:	0017861b          	addiw	a2,a5,1
    80005eaa:	87b2                	mv	a5,a2
    80005eac:	02b5773b          	remuw	a4,a0,a1
    80005eb0:	1702                	slli	a4,a4,0x20
    80005eb2:	9301                	srli	a4,a4,0x20
    80005eb4:	9742                	add	a4,a4,a6
    80005eb6:	00074703          	lbu	a4,0(a4)
    80005eba:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005ebe:	872a                	mv	a4,a0
    80005ec0:	02b5553b          	divuw	a0,a0,a1
    80005ec4:	0685                	addi	a3,a3,1
    80005ec6:	fcb77fe3          	bgeu	a4,a1,80005ea4 <printint+0x24>

  if(sign)
    80005eca:	000e0c63          	beqz	t3,80005ee2 <printint+0x62>
    buf[i++] = '-';
    80005ece:	fe060793          	addi	a5,a2,-32
    80005ed2:	00878633          	add	a2,a5,s0
    80005ed6:	02d00793          	li	a5,45
    80005eda:	fef60823          	sb	a5,-16(a2)
    80005ede:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    80005ee2:	fff7891b          	addiw	s2,a5,-1
    80005ee6:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    80005eea:	fff4c503          	lbu	a0,-1(s1)
    80005eee:	00000097          	auipc	ra,0x0
    80005ef2:	d64080e7          	jalr	-668(ra) # 80005c52 <consputc>
  while(--i >= 0)
    80005ef6:	397d                	addiw	s2,s2,-1
    80005ef8:	14fd                	addi	s1,s1,-1
    80005efa:	fe0958e3          	bgez	s2,80005eea <printint+0x6a>
}
    80005efe:	70a2                	ld	ra,40(sp)
    80005f00:	7402                	ld	s0,32(sp)
    80005f02:	64e2                	ld	s1,24(sp)
    80005f04:	6942                	ld	s2,16(sp)
    80005f06:	6145                	addi	sp,sp,48
    80005f08:	8082                	ret
    x = -xx;
    80005f0a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f0e:	4e05                	li	t3,1
    x = -xx;
    80005f10:	b751                	j	80005e94 <printint+0x14>

0000000080005f12 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f12:	1101                	addi	sp,sp,-32
    80005f14:	ec06                	sd	ra,24(sp)
    80005f16:	e822                	sd	s0,16(sp)
    80005f18:	e426                	sd	s1,8(sp)
    80005f1a:	1000                	addi	s0,sp,32
    80005f1c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f1e:	00260797          	auipc	a5,0x260
    80005f22:	2e07a123          	sw	zero,738(a5) # 80266200 <pr+0x18>
  printf("panic: ");
    80005f26:	00002517          	auipc	a0,0x2
    80005f2a:	78a50513          	addi	a0,a0,1930 # 800086b0 <etext+0x6b0>
    80005f2e:	00000097          	auipc	ra,0x0
    80005f32:	02e080e7          	jalr	46(ra) # 80005f5c <printf>
  printf(s);
    80005f36:	8526                	mv	a0,s1
    80005f38:	00000097          	auipc	ra,0x0
    80005f3c:	024080e7          	jalr	36(ra) # 80005f5c <printf>
  printf("\n");
    80005f40:	00002517          	auipc	a0,0x2
    80005f44:	0e850513          	addi	a0,a0,232 # 80008028 <etext+0x28>
    80005f48:	00000097          	auipc	ra,0x0
    80005f4c:	014080e7          	jalr	20(ra) # 80005f5c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f50:	4785                	li	a5,1
    80005f52:	00003717          	auipc	a4,0x3
    80005f56:	0cf72523          	sw	a5,202(a4) # 8000901c <panicked>
  for(;;)
    80005f5a:	a001                	j	80005f5a <panic+0x48>

0000000080005f5c <printf>:
{
    80005f5c:	7131                	addi	sp,sp,-192
    80005f5e:	fc86                	sd	ra,120(sp)
    80005f60:	f8a2                	sd	s0,112(sp)
    80005f62:	e8d2                	sd	s4,80(sp)
    80005f64:	ec6e                	sd	s11,24(sp)
    80005f66:	0100                	addi	s0,sp,128
    80005f68:	8a2a                	mv	s4,a0
    80005f6a:	e40c                	sd	a1,8(s0)
    80005f6c:	e810                	sd	a2,16(s0)
    80005f6e:	ec14                	sd	a3,24(s0)
    80005f70:	f018                	sd	a4,32(s0)
    80005f72:	f41c                	sd	a5,40(s0)
    80005f74:	03043823          	sd	a6,48(s0)
    80005f78:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f7c:	00260d97          	auipc	s11,0x260
    80005f80:	284dad83          	lw	s11,644(s11) # 80266200 <pr+0x18>
  if(locking)
    80005f84:	040d9463          	bnez	s11,80005fcc <printf+0x70>
  if (fmt == 0)
    80005f88:	040a0b63          	beqz	s4,80005fde <printf+0x82>
  va_start(ap, fmt);
    80005f8c:	00840793          	addi	a5,s0,8
    80005f90:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f94:	000a4503          	lbu	a0,0(s4)
    80005f98:	18050c63          	beqz	a0,80006130 <printf+0x1d4>
    80005f9c:	f4a6                	sd	s1,104(sp)
    80005f9e:	f0ca                	sd	s2,96(sp)
    80005fa0:	ecce                	sd	s3,88(sp)
    80005fa2:	e4d6                	sd	s5,72(sp)
    80005fa4:	e0da                	sd	s6,64(sp)
    80005fa6:	fc5e                	sd	s7,56(sp)
    80005fa8:	f862                	sd	s8,48(sp)
    80005faa:	f466                	sd	s9,40(sp)
    80005fac:	f06a                	sd	s10,32(sp)
    80005fae:	4981                	li	s3,0
    if(c != '%'){
    80005fb0:	02500b13          	li	s6,37
    switch(c){
    80005fb4:	07000b93          	li	s7,112
  consputc('x');
    80005fb8:	07800c93          	li	s9,120
    80005fbc:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fbe:	00003a97          	auipc	s5,0x3
    80005fc2:	84aa8a93          	addi	s5,s5,-1974 # 80008808 <digits>
    switch(c){
    80005fc6:	07300c13          	li	s8,115
    80005fca:	a0b9                	j	80006018 <printf+0xbc>
    acquire(&pr.lock);
    80005fcc:	00260517          	auipc	a0,0x260
    80005fd0:	21c50513          	addi	a0,a0,540 # 802661e8 <pr>
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	4be080e7          	jalr	1214(ra) # 80006492 <acquire>
    80005fdc:	b775                	j	80005f88 <printf+0x2c>
    80005fde:	f4a6                	sd	s1,104(sp)
    80005fe0:	f0ca                	sd	s2,96(sp)
    80005fe2:	ecce                	sd	s3,88(sp)
    80005fe4:	e4d6                	sd	s5,72(sp)
    80005fe6:	e0da                	sd	s6,64(sp)
    80005fe8:	fc5e                	sd	s7,56(sp)
    80005fea:	f862                	sd	s8,48(sp)
    80005fec:	f466                	sd	s9,40(sp)
    80005fee:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80005ff0:	00002517          	auipc	a0,0x2
    80005ff4:	6d050513          	addi	a0,a0,1744 # 800086c0 <etext+0x6c0>
    80005ff8:	00000097          	auipc	ra,0x0
    80005ffc:	f1a080e7          	jalr	-230(ra) # 80005f12 <panic>
      consputc(c);
    80006000:	00000097          	auipc	ra,0x0
    80006004:	c52080e7          	jalr	-942(ra) # 80005c52 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006008:	0019879b          	addiw	a5,s3,1
    8000600c:	89be                	mv	s3,a5
    8000600e:	97d2                	add	a5,a5,s4
    80006010:	0007c503          	lbu	a0,0(a5)
    80006014:	10050563          	beqz	a0,8000611e <printf+0x1c2>
    if(c != '%'){
    80006018:	ff6514e3          	bne	a0,s6,80006000 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000601c:	0019879b          	addiw	a5,s3,1
    80006020:	89be                	mv	s3,a5
    80006022:	97d2                	add	a5,a5,s4
    80006024:	0007c783          	lbu	a5,0(a5)
    80006028:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000602c:	10078a63          	beqz	a5,80006140 <printf+0x1e4>
    switch(c){
    80006030:	05778a63          	beq	a5,s7,80006084 <printf+0x128>
    80006034:	02fbf463          	bgeu	s7,a5,8000605c <printf+0x100>
    80006038:	09878763          	beq	a5,s8,800060c6 <printf+0x16a>
    8000603c:	0d979663          	bne	a5,s9,80006108 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    80006040:	f8843783          	ld	a5,-120(s0)
    80006044:	00878713          	addi	a4,a5,8
    80006048:	f8e43423          	sd	a4,-120(s0)
    8000604c:	4605                	li	a2,1
    8000604e:	85ea                	mv	a1,s10
    80006050:	4388                	lw	a0,0(a5)
    80006052:	00000097          	auipc	ra,0x0
    80006056:	e2e080e7          	jalr	-466(ra) # 80005e80 <printint>
      break;
    8000605a:	b77d                	j	80006008 <printf+0xac>
    switch(c){
    8000605c:	0b678063          	beq	a5,s6,800060fc <printf+0x1a0>
    80006060:	06400713          	li	a4,100
    80006064:	0ae79263          	bne	a5,a4,80006108 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    80006068:	f8843783          	ld	a5,-120(s0)
    8000606c:	00878713          	addi	a4,a5,8
    80006070:	f8e43423          	sd	a4,-120(s0)
    80006074:	4605                	li	a2,1
    80006076:	45a9                	li	a1,10
    80006078:	4388                	lw	a0,0(a5)
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	e06080e7          	jalr	-506(ra) # 80005e80 <printint>
      break;
    80006082:	b759                	j	80006008 <printf+0xac>
      printptr(va_arg(ap, uint64));
    80006084:	f8843783          	ld	a5,-120(s0)
    80006088:	00878713          	addi	a4,a5,8
    8000608c:	f8e43423          	sd	a4,-120(s0)
    80006090:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80006094:	03000513          	li	a0,48
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	bba080e7          	jalr	-1094(ra) # 80005c52 <consputc>
  consputc('x');
    800060a0:	8566                	mv	a0,s9
    800060a2:	00000097          	auipc	ra,0x0
    800060a6:	bb0080e7          	jalr	-1104(ra) # 80005c52 <consputc>
    800060aa:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060ac:	03c95793          	srli	a5,s2,0x3c
    800060b0:	97d6                	add	a5,a5,s5
    800060b2:	0007c503          	lbu	a0,0(a5)
    800060b6:	00000097          	auipc	ra,0x0
    800060ba:	b9c080e7          	jalr	-1124(ra) # 80005c52 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800060be:	0912                	slli	s2,s2,0x4
    800060c0:	34fd                	addiw	s1,s1,-1
    800060c2:	f4ed                	bnez	s1,800060ac <printf+0x150>
    800060c4:	b791                	j	80006008 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    800060c6:	f8843783          	ld	a5,-120(s0)
    800060ca:	00878713          	addi	a4,a5,8
    800060ce:	f8e43423          	sd	a4,-120(s0)
    800060d2:	6384                	ld	s1,0(a5)
    800060d4:	cc89                	beqz	s1,800060ee <printf+0x192>
      for(; *s; s++)
    800060d6:	0004c503          	lbu	a0,0(s1)
    800060da:	d51d                	beqz	a0,80006008 <printf+0xac>
        consputc(*s);
    800060dc:	00000097          	auipc	ra,0x0
    800060e0:	b76080e7          	jalr	-1162(ra) # 80005c52 <consputc>
      for(; *s; s++)
    800060e4:	0485                	addi	s1,s1,1
    800060e6:	0004c503          	lbu	a0,0(s1)
    800060ea:	f96d                	bnez	a0,800060dc <printf+0x180>
    800060ec:	bf31                	j	80006008 <printf+0xac>
        s = "(null)";
    800060ee:	00002497          	auipc	s1,0x2
    800060f2:	5ca48493          	addi	s1,s1,1482 # 800086b8 <etext+0x6b8>
      for(; *s; s++)
    800060f6:	02800513          	li	a0,40
    800060fa:	b7cd                	j	800060dc <printf+0x180>
      consputc('%');
    800060fc:	855a                	mv	a0,s6
    800060fe:	00000097          	auipc	ra,0x0
    80006102:	b54080e7          	jalr	-1196(ra) # 80005c52 <consputc>
      break;
    80006106:	b709                	j	80006008 <printf+0xac>
      consputc('%');
    80006108:	855a                	mv	a0,s6
    8000610a:	00000097          	auipc	ra,0x0
    8000610e:	b48080e7          	jalr	-1208(ra) # 80005c52 <consputc>
      consputc(c);
    80006112:	8526                	mv	a0,s1
    80006114:	00000097          	auipc	ra,0x0
    80006118:	b3e080e7          	jalr	-1218(ra) # 80005c52 <consputc>
      break;
    8000611c:	b5f5                	j	80006008 <printf+0xac>
    8000611e:	74a6                	ld	s1,104(sp)
    80006120:	7906                	ld	s2,96(sp)
    80006122:	69e6                	ld	s3,88(sp)
    80006124:	6aa6                	ld	s5,72(sp)
    80006126:	6b06                	ld	s6,64(sp)
    80006128:	7be2                	ld	s7,56(sp)
    8000612a:	7c42                	ld	s8,48(sp)
    8000612c:	7ca2                	ld	s9,40(sp)
    8000612e:	7d02                	ld	s10,32(sp)
  if(locking)
    80006130:	020d9263          	bnez	s11,80006154 <printf+0x1f8>
}
    80006134:	70e6                	ld	ra,120(sp)
    80006136:	7446                	ld	s0,112(sp)
    80006138:	6a46                	ld	s4,80(sp)
    8000613a:	6de2                	ld	s11,24(sp)
    8000613c:	6129                	addi	sp,sp,192
    8000613e:	8082                	ret
    80006140:	74a6                	ld	s1,104(sp)
    80006142:	7906                	ld	s2,96(sp)
    80006144:	69e6                	ld	s3,88(sp)
    80006146:	6aa6                	ld	s5,72(sp)
    80006148:	6b06                	ld	s6,64(sp)
    8000614a:	7be2                	ld	s7,56(sp)
    8000614c:	7c42                	ld	s8,48(sp)
    8000614e:	7ca2                	ld	s9,40(sp)
    80006150:	7d02                	ld	s10,32(sp)
    80006152:	bff9                	j	80006130 <printf+0x1d4>
    release(&pr.lock);
    80006154:	00260517          	auipc	a0,0x260
    80006158:	09450513          	addi	a0,a0,148 # 802661e8 <pr>
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	3e6080e7          	jalr	998(ra) # 80006542 <release>
}
    80006164:	bfc1                	j	80006134 <printf+0x1d8>

0000000080006166 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006166:	1101                	addi	sp,sp,-32
    80006168:	ec06                	sd	ra,24(sp)
    8000616a:	e822                	sd	s0,16(sp)
    8000616c:	e426                	sd	s1,8(sp)
    8000616e:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006170:	00260497          	auipc	s1,0x260
    80006174:	07848493          	addi	s1,s1,120 # 802661e8 <pr>
    80006178:	00002597          	auipc	a1,0x2
    8000617c:	55858593          	addi	a1,a1,1368 # 800086d0 <etext+0x6d0>
    80006180:	8526                	mv	a0,s1
    80006182:	00000097          	auipc	ra,0x0
    80006186:	27c080e7          	jalr	636(ra) # 800063fe <initlock>
  pr.locking = 1;
    8000618a:	4785                	li	a5,1
    8000618c:	cc9c                	sw	a5,24(s1)
}
    8000618e:	60e2                	ld	ra,24(sp)
    80006190:	6442                	ld	s0,16(sp)
    80006192:	64a2                	ld	s1,8(sp)
    80006194:	6105                	addi	sp,sp,32
    80006196:	8082                	ret

0000000080006198 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006198:	1141                	addi	sp,sp,-16
    8000619a:	e406                	sd	ra,8(sp)
    8000619c:	e022                	sd	s0,0(sp)
    8000619e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800061a0:	100007b7          	lui	a5,0x10000
    800061a4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061a8:	10000737          	lui	a4,0x10000
    800061ac:	f8000693          	li	a3,-128
    800061b0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061b4:	468d                	li	a3,3
    800061b6:	10000637          	lui	a2,0x10000
    800061ba:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800061be:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800061c2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800061c6:	8732                	mv	a4,a2
    800061c8:	461d                	li	a2,7
    800061ca:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800061ce:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    800061d2:	00002597          	auipc	a1,0x2
    800061d6:	50658593          	addi	a1,a1,1286 # 800086d8 <etext+0x6d8>
    800061da:	00260517          	auipc	a0,0x260
    800061de:	02e50513          	addi	a0,a0,46 # 80266208 <uart_tx_lock>
    800061e2:	00000097          	auipc	ra,0x0
    800061e6:	21c080e7          	jalr	540(ra) # 800063fe <initlock>
}
    800061ea:	60a2                	ld	ra,8(sp)
    800061ec:	6402                	ld	s0,0(sp)
    800061ee:	0141                	addi	sp,sp,16
    800061f0:	8082                	ret

00000000800061f2 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800061f2:	1101                	addi	sp,sp,-32
    800061f4:	ec06                	sd	ra,24(sp)
    800061f6:	e822                	sd	s0,16(sp)
    800061f8:	e426                	sd	s1,8(sp)
    800061fa:	1000                	addi	s0,sp,32
    800061fc:	84aa                	mv	s1,a0
  push_off();
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	248080e7          	jalr	584(ra) # 80006446 <push_off>

  if(panicked){
    80006206:	00003797          	auipc	a5,0x3
    8000620a:	e167a783          	lw	a5,-490(a5) # 8000901c <panicked>
    8000620e:	eb85                	bnez	a5,8000623e <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006210:	10000737          	lui	a4,0x10000
    80006214:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80006216:	00074783          	lbu	a5,0(a4)
    8000621a:	0207f793          	andi	a5,a5,32
    8000621e:	dfe5                	beqz	a5,80006216 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006220:	0ff4f513          	zext.b	a0,s1
    80006224:	100007b7          	lui	a5,0x10000
    80006228:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000622c:	00000097          	auipc	ra,0x0
    80006230:	2ba080e7          	jalr	698(ra) # 800064e6 <pop_off>
}
    80006234:	60e2                	ld	ra,24(sp)
    80006236:	6442                	ld	s0,16(sp)
    80006238:	64a2                	ld	s1,8(sp)
    8000623a:	6105                	addi	sp,sp,32
    8000623c:	8082                	ret
    for(;;)
    8000623e:	a001                	j	8000623e <uartputc_sync+0x4c>

0000000080006240 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006240:	00003797          	auipc	a5,0x3
    80006244:	de07b783          	ld	a5,-544(a5) # 80009020 <uart_tx_r>
    80006248:	00003717          	auipc	a4,0x3
    8000624c:	de073703          	ld	a4,-544(a4) # 80009028 <uart_tx_w>
    80006250:	06f70f63          	beq	a4,a5,800062ce <uartstart+0x8e>
{
    80006254:	7139                	addi	sp,sp,-64
    80006256:	fc06                	sd	ra,56(sp)
    80006258:	f822                	sd	s0,48(sp)
    8000625a:	f426                	sd	s1,40(sp)
    8000625c:	f04a                	sd	s2,32(sp)
    8000625e:	ec4e                	sd	s3,24(sp)
    80006260:	e852                	sd	s4,16(sp)
    80006262:	e456                	sd	s5,8(sp)
    80006264:	e05a                	sd	s6,0(sp)
    80006266:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006268:	10000937          	lui	s2,0x10000
    8000626c:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000626e:	00260a97          	auipc	s5,0x260
    80006272:	f9aa8a93          	addi	s5,s5,-102 # 80266208 <uart_tx_lock>
    uart_tx_r += 1;
    80006276:	00003497          	auipc	s1,0x3
    8000627a:	daa48493          	addi	s1,s1,-598 # 80009020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000627e:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80006282:	00003997          	auipc	s3,0x3
    80006286:	da698993          	addi	s3,s3,-602 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000628a:	00094703          	lbu	a4,0(s2)
    8000628e:	02077713          	andi	a4,a4,32
    80006292:	c705                	beqz	a4,800062ba <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006294:	01f7f713          	andi	a4,a5,31
    80006298:	9756                	add	a4,a4,s5
    8000629a:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000629e:	0785                	addi	a5,a5,1
    800062a0:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800062a2:	8526                	mv	a0,s1
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	63e080e7          	jalr	1598(ra) # 800018e2 <wakeup>
    WriteReg(THR, c);
    800062ac:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800062b0:	609c                	ld	a5,0(s1)
    800062b2:	0009b703          	ld	a4,0(s3)
    800062b6:	fcf71ae3          	bne	a4,a5,8000628a <uartstart+0x4a>
  }
}
    800062ba:	70e2                	ld	ra,56(sp)
    800062bc:	7442                	ld	s0,48(sp)
    800062be:	74a2                	ld	s1,40(sp)
    800062c0:	7902                	ld	s2,32(sp)
    800062c2:	69e2                	ld	s3,24(sp)
    800062c4:	6a42                	ld	s4,16(sp)
    800062c6:	6aa2                	ld	s5,8(sp)
    800062c8:	6b02                	ld	s6,0(sp)
    800062ca:	6121                	addi	sp,sp,64
    800062cc:	8082                	ret
    800062ce:	8082                	ret

00000000800062d0 <uartputc>:
{
    800062d0:	7179                	addi	sp,sp,-48
    800062d2:	f406                	sd	ra,40(sp)
    800062d4:	f022                	sd	s0,32(sp)
    800062d6:	e052                	sd	s4,0(sp)
    800062d8:	1800                	addi	s0,sp,48
    800062da:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062dc:	00260517          	auipc	a0,0x260
    800062e0:	f2c50513          	addi	a0,a0,-212 # 80266208 <uart_tx_lock>
    800062e4:	00000097          	auipc	ra,0x0
    800062e8:	1ae080e7          	jalr	430(ra) # 80006492 <acquire>
  if(panicked){
    800062ec:	00003797          	auipc	a5,0x3
    800062f0:	d307a783          	lw	a5,-720(a5) # 8000901c <panicked>
    800062f4:	c391                	beqz	a5,800062f8 <uartputc+0x28>
    for(;;)
    800062f6:	a001                	j	800062f6 <uartputc+0x26>
    800062f8:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062fa:	00003717          	auipc	a4,0x3
    800062fe:	d2e73703          	ld	a4,-722(a4) # 80009028 <uart_tx_w>
    80006302:	00003797          	auipc	a5,0x3
    80006306:	d1e7b783          	ld	a5,-738(a5) # 80009020 <uart_tx_r>
    8000630a:	02078793          	addi	a5,a5,32
    8000630e:	02e79f63          	bne	a5,a4,8000634c <uartputc+0x7c>
    80006312:	e84a                	sd	s2,16(sp)
    80006314:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    80006316:	00260997          	auipc	s3,0x260
    8000631a:	ef298993          	addi	s3,s3,-270 # 80266208 <uart_tx_lock>
    8000631e:	00003497          	auipc	s1,0x3
    80006322:	d0248493          	addi	s1,s1,-766 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006326:	00003917          	auipc	s2,0x3
    8000632a:	d0290913          	addi	s2,s2,-766 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000632e:	85ce                	mv	a1,s3
    80006330:	8526                	mv	a0,s1
    80006332:	ffffb097          	auipc	ra,0xffffb
    80006336:	42a080e7          	jalr	1066(ra) # 8000175c <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000633a:	00093703          	ld	a4,0(s2)
    8000633e:	609c                	ld	a5,0(s1)
    80006340:	02078793          	addi	a5,a5,32
    80006344:	fee785e3          	beq	a5,a4,8000632e <uartputc+0x5e>
    80006348:	6942                	ld	s2,16(sp)
    8000634a:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000634c:	00260497          	auipc	s1,0x260
    80006350:	ebc48493          	addi	s1,s1,-324 # 80266208 <uart_tx_lock>
    80006354:	01f77793          	andi	a5,a4,31
    80006358:	97a6                	add	a5,a5,s1
    8000635a:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    8000635e:	0705                	addi	a4,a4,1
    80006360:	00003797          	auipc	a5,0x3
    80006364:	cce7b423          	sd	a4,-824(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006368:	00000097          	auipc	ra,0x0
    8000636c:	ed8080e7          	jalr	-296(ra) # 80006240 <uartstart>
      release(&uart_tx_lock);
    80006370:	8526                	mv	a0,s1
    80006372:	00000097          	auipc	ra,0x0
    80006376:	1d0080e7          	jalr	464(ra) # 80006542 <release>
    8000637a:	64e2                	ld	s1,24(sp)
}
    8000637c:	70a2                	ld	ra,40(sp)
    8000637e:	7402                	ld	s0,32(sp)
    80006380:	6a02                	ld	s4,0(sp)
    80006382:	6145                	addi	sp,sp,48
    80006384:	8082                	ret

0000000080006386 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006386:	1141                	addi	sp,sp,-16
    80006388:	e406                	sd	ra,8(sp)
    8000638a:	e022                	sd	s0,0(sp)
    8000638c:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000638e:	100007b7          	lui	a5,0x10000
    80006392:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006396:	8b85                	andi	a5,a5,1
    80006398:	cb89                	beqz	a5,800063aa <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000639a:	100007b7          	lui	a5,0x10000
    8000639e:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800063a2:	60a2                	ld	ra,8(sp)
    800063a4:	6402                	ld	s0,0(sp)
    800063a6:	0141                	addi	sp,sp,16
    800063a8:	8082                	ret
    return -1;
    800063aa:	557d                	li	a0,-1
    800063ac:	bfdd                	j	800063a2 <uartgetc+0x1c>

00000000800063ae <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800063ae:	1101                	addi	sp,sp,-32
    800063b0:	ec06                	sd	ra,24(sp)
    800063b2:	e822                	sd	s0,16(sp)
    800063b4:	e426                	sd	s1,8(sp)
    800063b6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800063b8:	54fd                	li	s1,-1
    int c = uartgetc();
    800063ba:	00000097          	auipc	ra,0x0
    800063be:	fcc080e7          	jalr	-52(ra) # 80006386 <uartgetc>
    if(c == -1)
    800063c2:	00950763          	beq	a0,s1,800063d0 <uartintr+0x22>
      break;
    consoleintr(c);
    800063c6:	00000097          	auipc	ra,0x0
    800063ca:	8ce080e7          	jalr	-1842(ra) # 80005c94 <consoleintr>
  while(1){
    800063ce:	b7f5                	j	800063ba <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800063d0:	00260497          	auipc	s1,0x260
    800063d4:	e3848493          	addi	s1,s1,-456 # 80266208 <uart_tx_lock>
    800063d8:	8526                	mv	a0,s1
    800063da:	00000097          	auipc	ra,0x0
    800063de:	0b8080e7          	jalr	184(ra) # 80006492 <acquire>
  uartstart();
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	e5e080e7          	jalr	-418(ra) # 80006240 <uartstart>
  release(&uart_tx_lock);
    800063ea:	8526                	mv	a0,s1
    800063ec:	00000097          	auipc	ra,0x0
    800063f0:	156080e7          	jalr	342(ra) # 80006542 <release>
}
    800063f4:	60e2                	ld	ra,24(sp)
    800063f6:	6442                	ld	s0,16(sp)
    800063f8:	64a2                	ld	s1,8(sp)
    800063fa:	6105                	addi	sp,sp,32
    800063fc:	8082                	ret

00000000800063fe <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800063fe:	1141                	addi	sp,sp,-16
    80006400:	e406                	sd	ra,8(sp)
    80006402:	e022                	sd	s0,0(sp)
    80006404:	0800                	addi	s0,sp,16
  lk->name = name;
    80006406:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006408:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000640c:	00053823          	sd	zero,16(a0)
}
    80006410:	60a2                	ld	ra,8(sp)
    80006412:	6402                	ld	s0,0(sp)
    80006414:	0141                	addi	sp,sp,16
    80006416:	8082                	ret

0000000080006418 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006418:	411c                	lw	a5,0(a0)
    8000641a:	e399                	bnez	a5,80006420 <holding+0x8>
    8000641c:	4501                	li	a0,0
  return r;
}
    8000641e:	8082                	ret
{
    80006420:	1101                	addi	sp,sp,-32
    80006422:	ec06                	sd	ra,24(sp)
    80006424:	e822                	sd	s0,16(sp)
    80006426:	e426                	sd	s1,8(sp)
    80006428:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000642a:	6904                	ld	s1,16(a0)
    8000642c:	ffffb097          	auipc	ra,0xffffb
    80006430:	c4a080e7          	jalr	-950(ra) # 80001076 <mycpu>
    80006434:	40a48533          	sub	a0,s1,a0
    80006438:	00153513          	seqz	a0,a0
}
    8000643c:	60e2                	ld	ra,24(sp)
    8000643e:	6442                	ld	s0,16(sp)
    80006440:	64a2                	ld	s1,8(sp)
    80006442:	6105                	addi	sp,sp,32
    80006444:	8082                	ret

0000000080006446 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006446:	1101                	addi	sp,sp,-32
    80006448:	ec06                	sd	ra,24(sp)
    8000644a:	e822                	sd	s0,16(sp)
    8000644c:	e426                	sd	s1,8(sp)
    8000644e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006450:	100024f3          	csrr	s1,sstatus
    80006454:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006458:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000645a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000645e:	ffffb097          	auipc	ra,0xffffb
    80006462:	c18080e7          	jalr	-1000(ra) # 80001076 <mycpu>
    80006466:	5d3c                	lw	a5,120(a0)
    80006468:	cf89                	beqz	a5,80006482 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000646a:	ffffb097          	auipc	ra,0xffffb
    8000646e:	c0c080e7          	jalr	-1012(ra) # 80001076 <mycpu>
    80006472:	5d3c                	lw	a5,120(a0)
    80006474:	2785                	addiw	a5,a5,1
    80006476:	dd3c                	sw	a5,120(a0)
}
    80006478:	60e2                	ld	ra,24(sp)
    8000647a:	6442                	ld	s0,16(sp)
    8000647c:	64a2                	ld	s1,8(sp)
    8000647e:	6105                	addi	sp,sp,32
    80006480:	8082                	ret
    mycpu()->intena = old;
    80006482:	ffffb097          	auipc	ra,0xffffb
    80006486:	bf4080e7          	jalr	-1036(ra) # 80001076 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000648a:	8085                	srli	s1,s1,0x1
    8000648c:	8885                	andi	s1,s1,1
    8000648e:	dd64                	sw	s1,124(a0)
    80006490:	bfe9                	j	8000646a <push_off+0x24>

0000000080006492 <acquire>:
{
    80006492:	1101                	addi	sp,sp,-32
    80006494:	ec06                	sd	ra,24(sp)
    80006496:	e822                	sd	s0,16(sp)
    80006498:	e426                	sd	s1,8(sp)
    8000649a:	1000                	addi	s0,sp,32
    8000649c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    8000649e:	00000097          	auipc	ra,0x0
    800064a2:	fa8080e7          	jalr	-88(ra) # 80006446 <push_off>
  if(holding(lk))
    800064a6:	8526                	mv	a0,s1
    800064a8:	00000097          	auipc	ra,0x0
    800064ac:	f70080e7          	jalr	-144(ra) # 80006418 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064b0:	4705                	li	a4,1
  if(holding(lk))
    800064b2:	e115                	bnez	a0,800064d6 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064b4:	87ba                	mv	a5,a4
    800064b6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800064ba:	2781                	sext.w	a5,a5
    800064bc:	ffe5                	bnez	a5,800064b4 <acquire+0x22>
  __sync_synchronize();
    800064be:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800064c2:	ffffb097          	auipc	ra,0xffffb
    800064c6:	bb4080e7          	jalr	-1100(ra) # 80001076 <mycpu>
    800064ca:	e888                	sd	a0,16(s1)
}
    800064cc:	60e2                	ld	ra,24(sp)
    800064ce:	6442                	ld	s0,16(sp)
    800064d0:	64a2                	ld	s1,8(sp)
    800064d2:	6105                	addi	sp,sp,32
    800064d4:	8082                	ret
    panic("acquire");
    800064d6:	00002517          	auipc	a0,0x2
    800064da:	20a50513          	addi	a0,a0,522 # 800086e0 <etext+0x6e0>
    800064de:	00000097          	auipc	ra,0x0
    800064e2:	a34080e7          	jalr	-1484(ra) # 80005f12 <panic>

00000000800064e6 <pop_off>:

void
pop_off(void)
{
    800064e6:	1141                	addi	sp,sp,-16
    800064e8:	e406                	sd	ra,8(sp)
    800064ea:	e022                	sd	s0,0(sp)
    800064ec:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800064ee:	ffffb097          	auipc	ra,0xffffb
    800064f2:	b88080e7          	jalr	-1144(ra) # 80001076 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064f6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064fa:	8b89                	andi	a5,a5,2
  if(intr_get())
    800064fc:	e39d                	bnez	a5,80006522 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800064fe:	5d3c                	lw	a5,120(a0)
    80006500:	02f05963          	blez	a5,80006532 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80006504:	37fd                	addiw	a5,a5,-1
    80006506:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006508:	eb89                	bnez	a5,8000651a <pop_off+0x34>
    8000650a:	5d7c                	lw	a5,124(a0)
    8000650c:	c799                	beqz	a5,8000651a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000650e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006512:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006516:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000651a:	60a2                	ld	ra,8(sp)
    8000651c:	6402                	ld	s0,0(sp)
    8000651e:	0141                	addi	sp,sp,16
    80006520:	8082                	ret
    panic("pop_off - interruptible");
    80006522:	00002517          	auipc	a0,0x2
    80006526:	1c650513          	addi	a0,a0,454 # 800086e8 <etext+0x6e8>
    8000652a:	00000097          	auipc	ra,0x0
    8000652e:	9e8080e7          	jalr	-1560(ra) # 80005f12 <panic>
    panic("pop_off");
    80006532:	00002517          	auipc	a0,0x2
    80006536:	1ce50513          	addi	a0,a0,462 # 80008700 <etext+0x700>
    8000653a:	00000097          	auipc	ra,0x0
    8000653e:	9d8080e7          	jalr	-1576(ra) # 80005f12 <panic>

0000000080006542 <release>:
{
    80006542:	1101                	addi	sp,sp,-32
    80006544:	ec06                	sd	ra,24(sp)
    80006546:	e822                	sd	s0,16(sp)
    80006548:	e426                	sd	s1,8(sp)
    8000654a:	1000                	addi	s0,sp,32
    8000654c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000654e:	00000097          	auipc	ra,0x0
    80006552:	eca080e7          	jalr	-310(ra) # 80006418 <holding>
    80006556:	c115                	beqz	a0,8000657a <release+0x38>
  lk->cpu = 0;
    80006558:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000655c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006560:	0310000f          	fence	rw,w
    80006564:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006568:	00000097          	auipc	ra,0x0
    8000656c:	f7e080e7          	jalr	-130(ra) # 800064e6 <pop_off>
}
    80006570:	60e2                	ld	ra,24(sp)
    80006572:	6442                	ld	s0,16(sp)
    80006574:	64a2                	ld	s1,8(sp)
    80006576:	6105                	addi	sp,sp,32
    80006578:	8082                	ret
    panic("release");
    8000657a:	00002517          	auipc	a0,0x2
    8000657e:	18e50513          	addi	a0,a0,398 # 80008708 <etext+0x708>
    80006582:	00000097          	auipc	ra,0x0
    80006586:	990080e7          	jalr	-1648(ra) # 80005f12 <panic>
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
