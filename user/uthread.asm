
user/_uthread:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   8:	00001797          	auipc	a5,0x1
   c:	d4078793          	addi	a5,a5,-704 # d48 <all_thread>
  10:	00001717          	auipc	a4,0x1
  14:	d2f73423          	sd	a5,-728(a4) # d38 <current_thread>
  current_thread->state = RUNNING;
  18:	4785                	li	a5,1
  1a:	00003717          	auipc	a4,0x3
  1e:	d2f72723          	sw	a5,-722(a4) # 2d48 <__global_pointer$+0x182f>
}
  22:	60a2                	ld	ra,8(sp)
  24:	6402                	ld	s0,0(sp)
  26:	0141                	addi	sp,sp,16
  28:	8082                	ret

000000000000002a <thread_schedule>:
{
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2a:	00001897          	auipc	a7,0x1
  2e:	d0e8b883          	ld	a7,-754(a7) # d38 <current_thread>
  32:	6789                	lui	a5,0x2
  34:	0791                	addi	a5,a5,4 # 2004 <__global_pointer$+0xaeb>
  36:	97c6                	add	a5,a5,a7
  38:	4711                	li	a4,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  3a:	00009817          	auipc	a6,0x9
  3e:	d1e80813          	addi	a6,a6,-738 # 8d58 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  42:	6509                	lui	a0,0x2
  44:	4589                	li	a1,2
      next_thread = t;
      break;
    }
    t = t + 1;
  46:	00e50633          	add	a2,a0,a4
  4a:	a809                	j	5c <thread_schedule+0x32>
    if(t->state == RUNNABLE) {
  4c:	00a786b3          	add	a3,a5,a0
  50:	4294                	lw	a3,0(a3)
  52:	02b68d63          	beq	a3,a1,8c <thread_schedule+0x62>
    t = t + 1;
  56:	97b2                	add	a5,a5,a2
  for(int i = 0; i < MAX_THREAD; i++){
  58:	377d                	addiw	a4,a4,-1
  5a:	cb01                	beqz	a4,6a <thread_schedule+0x40>
    if(t >= all_thread + MAX_THREAD)
  5c:	ff07e8e3          	bltu	a5,a6,4c <thread_schedule+0x22>
      t = all_thread;
  60:	00001797          	auipc	a5,0x1
  64:	ce878793          	addi	a5,a5,-792 # d48 <all_thread>
  68:	b7d5                	j	4c <thread_schedule+0x22>
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e406                	sd	ra,8(sp)
  6e:	e022                	sd	s0,0(sp)
  70:	0800                	addi	s0,sp,16
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  72:	00001517          	auipc	a0,0x1
  76:	b3650513          	addi	a0,a0,-1226 # ba8 <malloc+0x100>
  7a:	00001097          	auipc	ra,0x1
  7e:	972080e7          	jalr	-1678(ra) # 9ec <printf>
    exit(-1);
  82:	557d                	li	a0,-1
  84:	00000097          	auipc	ra,0x0
  88:	612080e7          	jalr	1554(ra) # 696 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8c:	00f88b63          	beq	a7,a5,a2 <thread_schedule+0x78>
    next_thread->state = RUNNING;
  90:	6709                	lui	a4,0x2
  92:	973e                	add	a4,a4,a5
  94:	4685                	li	a3,1
  96:	c314                	sw	a3,0(a4)
    t = current_thread;
    current_thread = next_thread;
  98:	00001717          	auipc	a4,0x1
  9c:	caf73023          	sd	a5,-864(a4) # d38 <current_thread>
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
  } else
    next_thread = 0;
}
  a0:	8082                	ret
  a2:	8082                	ret

00000000000000a4 <thread_create>:

void 
thread_create(void (*func)())
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  ac:	00003797          	auipc	a5,0x3
  b0:	ca078793          	addi	a5,a5,-864 # 2d4c <__global_pointer$+0x1833>
  b4:	0000b597          	auipc	a1,0xb
  b8:	ca858593          	addi	a1,a1,-856 # ad5c <__BSS_END__+0x1ff4>
  bc:	6609                	lui	a2,0x2
  be:	0611                	addi	a2,a2,4 # 2004 <__global_pointer$+0xaeb>
    if (t->state == FREE) break;
  c0:	873e                	mv	a4,a5
  c2:	ffc7a683          	lw	a3,-4(a5)
  c6:	ce81                	beqz	a3,de <thread_create+0x3a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c8:	97b2                	add	a5,a5,a2
  ca:	feb79be3          	bne	a5,a1,c0 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  ce:	6789                	lui	a5,0x2
  d0:	973e                	add	a4,a4,a5
  d2:	4789                	li	a5,2
  d4:	c31c                	sw	a5,0(a4)
  // YOUR CODE HERE
}
  d6:	60a2                	ld	ra,8(sp)
  d8:	6402                	ld	s0,0(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  de:	7779                	lui	a4,0xffffe
  e0:	1771                	addi	a4,a4,-4 # ffffffffffffdffc <__BSS_END__+0xffffffffffff5294>
  e2:	973e                	add	a4,a4,a5
  e4:	b7ed                	j	ce <thread_create+0x2a>

00000000000000e6 <thread_yield>:

void 
thread_yield(void)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
  ee:	00001797          	auipc	a5,0x1
  f2:	c4a7b783          	ld	a5,-950(a5) # d38 <current_thread>
  f6:	6709                	lui	a4,0x2
  f8:	97ba                	add	a5,a5,a4
  fa:	4709                	li	a4,2
  fc:	c398                	sw	a4,0(a5)
  thread_schedule();
  fe:	00000097          	auipc	ra,0x0
 102:	f2c080e7          	jalr	-212(ra) # 2a <thread_schedule>
}
 106:	60a2                	ld	ra,8(sp)
 108:	6402                	ld	s0,0(sp)
 10a:	0141                	addi	sp,sp,16
 10c:	8082                	ret

000000000000010e <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 10e:	7179                	addi	sp,sp,-48
 110:	f406                	sd	ra,40(sp)
 112:	f022                	sd	s0,32(sp)
 114:	ec26                	sd	s1,24(sp)
 116:	e84a                	sd	s2,16(sp)
 118:	e44e                	sd	s3,8(sp)
 11a:	e052                	sd	s4,0(sp)
 11c:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 11e:	00001517          	auipc	a0,0x1
 122:	ab250513          	addi	a0,a0,-1358 # bd0 <malloc+0x128>
 126:	00001097          	auipc	ra,0x1
 12a:	8c6080e7          	jalr	-1850(ra) # 9ec <printf>
  a_started = 1;
 12e:	4785                	li	a5,1
 130:	00001717          	auipc	a4,0x1
 134:	c0f72223          	sw	a5,-1020(a4) # d34 <a_started>
  while(b_started == 0 || c_started == 0)
 138:	00001497          	auipc	s1,0x1
 13c:	bf848493          	addi	s1,s1,-1032 # d30 <b_started>
 140:	00001917          	auipc	s2,0x1
 144:	bec90913          	addi	s2,s2,-1044 # d2c <c_started>
 148:	a029                	j	152 <thread_a+0x44>
    thread_yield();
 14a:	00000097          	auipc	ra,0x0
 14e:	f9c080e7          	jalr	-100(ra) # e6 <thread_yield>
  while(b_started == 0 || c_started == 0)
 152:	409c                	lw	a5,0(s1)
 154:	2781                	sext.w	a5,a5
 156:	dbf5                	beqz	a5,14a <thread_a+0x3c>
 158:	00092783          	lw	a5,0(s2)
 15c:	2781                	sext.w	a5,a5
 15e:	d7f5                	beqz	a5,14a <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 160:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 162:	00001a17          	auipc	s4,0x1
 166:	a86a0a13          	addi	s4,s4,-1402 # be8 <malloc+0x140>
    a_n += 1;
 16a:	00001917          	auipc	s2,0x1
 16e:	bbe90913          	addi	s2,s2,-1090 # d28 <a_n>
  for (i = 0; i < 100; i++) {
 172:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 176:	85a6                	mv	a1,s1
 178:	8552                	mv	a0,s4
 17a:	00001097          	auipc	ra,0x1
 17e:	872080e7          	jalr	-1934(ra) # 9ec <printf>
    a_n += 1;
 182:	00092783          	lw	a5,0(s2)
 186:	2785                	addiw	a5,a5,1
 188:	00f92023          	sw	a5,0(s2)
    thread_yield();
 18c:	00000097          	auipc	ra,0x0
 190:	f5a080e7          	jalr	-166(ra) # e6 <thread_yield>
  for (i = 0; i < 100; i++) {
 194:	2485                	addiw	s1,s1,1
 196:	ff3490e3          	bne	s1,s3,176 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 19a:	00001597          	auipc	a1,0x1
 19e:	b8e5a583          	lw	a1,-1138(a1) # d28 <a_n>
 1a2:	00001517          	auipc	a0,0x1
 1a6:	a5650513          	addi	a0,a0,-1450 # bf8 <malloc+0x150>
 1aa:	00001097          	auipc	ra,0x1
 1ae:	842080e7          	jalr	-1982(ra) # 9ec <printf>

  current_thread->state = FREE;
 1b2:	00001797          	auipc	a5,0x1
 1b6:	b867b783          	ld	a5,-1146(a5) # d38 <current_thread>
 1ba:	6709                	lui	a4,0x2
 1bc:	97ba                	add	a5,a5,a4
 1be:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1c2:	00000097          	auipc	ra,0x0
 1c6:	e68080e7          	jalr	-408(ra) # 2a <thread_schedule>
}
 1ca:	70a2                	ld	ra,40(sp)
 1cc:	7402                	ld	s0,32(sp)
 1ce:	64e2                	ld	s1,24(sp)
 1d0:	6942                	ld	s2,16(sp)
 1d2:	69a2                	ld	s3,8(sp)
 1d4:	6a02                	ld	s4,0(sp)
 1d6:	6145                	addi	sp,sp,48
 1d8:	8082                	ret

00000000000001da <thread_b>:

void 
thread_b(void)
{
 1da:	7179                	addi	sp,sp,-48
 1dc:	f406                	sd	ra,40(sp)
 1de:	f022                	sd	s0,32(sp)
 1e0:	ec26                	sd	s1,24(sp)
 1e2:	e84a                	sd	s2,16(sp)
 1e4:	e44e                	sd	s3,8(sp)
 1e6:	e052                	sd	s4,0(sp)
 1e8:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	a2e50513          	addi	a0,a0,-1490 # c18 <malloc+0x170>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	7fa080e7          	jalr	2042(ra) # 9ec <printf>
  b_started = 1;
 1fa:	4785                	li	a5,1
 1fc:	00001717          	auipc	a4,0x1
 200:	b2f72a23          	sw	a5,-1228(a4) # d30 <b_started>
  while(a_started == 0 || c_started == 0)
 204:	00001497          	auipc	s1,0x1
 208:	b3048493          	addi	s1,s1,-1232 # d34 <a_started>
 20c:	00001917          	auipc	s2,0x1
 210:	b2090913          	addi	s2,s2,-1248 # d2c <c_started>
 214:	a029                	j	21e <thread_b+0x44>
    thread_yield();
 216:	00000097          	auipc	ra,0x0
 21a:	ed0080e7          	jalr	-304(ra) # e6 <thread_yield>
  while(a_started == 0 || c_started == 0)
 21e:	409c                	lw	a5,0(s1)
 220:	2781                	sext.w	a5,a5
 222:	dbf5                	beqz	a5,216 <thread_b+0x3c>
 224:	00092783          	lw	a5,0(s2)
 228:	2781                	sext.w	a5,a5
 22a:	d7f5                	beqz	a5,216 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 22c:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 22e:	00001a17          	auipc	s4,0x1
 232:	a02a0a13          	addi	s4,s4,-1534 # c30 <malloc+0x188>
    b_n += 1;
 236:	00001917          	auipc	s2,0x1
 23a:	aee90913          	addi	s2,s2,-1298 # d24 <b_n>
  for (i = 0; i < 100; i++) {
 23e:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 242:	85a6                	mv	a1,s1
 244:	8552                	mv	a0,s4
 246:	00000097          	auipc	ra,0x0
 24a:	7a6080e7          	jalr	1958(ra) # 9ec <printf>
    b_n += 1;
 24e:	00092783          	lw	a5,0(s2)
 252:	2785                	addiw	a5,a5,1
 254:	00f92023          	sw	a5,0(s2)
    thread_yield();
 258:	00000097          	auipc	ra,0x0
 25c:	e8e080e7          	jalr	-370(ra) # e6 <thread_yield>
  for (i = 0; i < 100; i++) {
 260:	2485                	addiw	s1,s1,1
 262:	ff3490e3          	bne	s1,s3,242 <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 266:	00001597          	auipc	a1,0x1
 26a:	abe5a583          	lw	a1,-1346(a1) # d24 <b_n>
 26e:	00001517          	auipc	a0,0x1
 272:	9d250513          	addi	a0,a0,-1582 # c40 <malloc+0x198>
 276:	00000097          	auipc	ra,0x0
 27a:	776080e7          	jalr	1910(ra) # 9ec <printf>

  current_thread->state = FREE;
 27e:	00001797          	auipc	a5,0x1
 282:	aba7b783          	ld	a5,-1350(a5) # d38 <current_thread>
 286:	6709                	lui	a4,0x2
 288:	97ba                	add	a5,a5,a4
 28a:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 28e:	00000097          	auipc	ra,0x0
 292:	d9c080e7          	jalr	-612(ra) # 2a <thread_schedule>
}
 296:	70a2                	ld	ra,40(sp)
 298:	7402                	ld	s0,32(sp)
 29a:	64e2                	ld	s1,24(sp)
 29c:	6942                	ld	s2,16(sp)
 29e:	69a2                	ld	s3,8(sp)
 2a0:	6a02                	ld	s4,0(sp)
 2a2:	6145                	addi	sp,sp,48
 2a4:	8082                	ret

00000000000002a6 <thread_c>:

void 
thread_c(void)
{
 2a6:	7179                	addi	sp,sp,-48
 2a8:	f406                	sd	ra,40(sp)
 2aa:	f022                	sd	s0,32(sp)
 2ac:	ec26                	sd	s1,24(sp)
 2ae:	e84a                	sd	s2,16(sp)
 2b0:	e44e                	sd	s3,8(sp)
 2b2:	e052                	sd	s4,0(sp)
 2b4:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2b6:	00001517          	auipc	a0,0x1
 2ba:	9aa50513          	addi	a0,a0,-1622 # c60 <malloc+0x1b8>
 2be:	00000097          	auipc	ra,0x0
 2c2:	72e080e7          	jalr	1838(ra) # 9ec <printf>
  c_started = 1;
 2c6:	4785                	li	a5,1
 2c8:	00001717          	auipc	a4,0x1
 2cc:	a6f72223          	sw	a5,-1436(a4) # d2c <c_started>
  while(a_started == 0 || b_started == 0)
 2d0:	00001497          	auipc	s1,0x1
 2d4:	a6448493          	addi	s1,s1,-1436 # d34 <a_started>
 2d8:	00001917          	auipc	s2,0x1
 2dc:	a5890913          	addi	s2,s2,-1448 # d30 <b_started>
 2e0:	a029                	j	2ea <thread_c+0x44>
    thread_yield();
 2e2:	00000097          	auipc	ra,0x0
 2e6:	e04080e7          	jalr	-508(ra) # e6 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2ea:	409c                	lw	a5,0(s1)
 2ec:	2781                	sext.w	a5,a5
 2ee:	dbf5                	beqz	a5,2e2 <thread_c+0x3c>
 2f0:	00092783          	lw	a5,0(s2)
 2f4:	2781                	sext.w	a5,a5
 2f6:	d7f5                	beqz	a5,2e2 <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 2f8:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 2fa:	00001a17          	auipc	s4,0x1
 2fe:	97ea0a13          	addi	s4,s4,-1666 # c78 <malloc+0x1d0>
    c_n += 1;
 302:	00001917          	auipc	s2,0x1
 306:	a1e90913          	addi	s2,s2,-1506 # d20 <c_n>
  for (i = 0; i < 100; i++) {
 30a:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 30e:	85a6                	mv	a1,s1
 310:	8552                	mv	a0,s4
 312:	00000097          	auipc	ra,0x0
 316:	6da080e7          	jalr	1754(ra) # 9ec <printf>
    c_n += 1;
 31a:	00092783          	lw	a5,0(s2)
 31e:	2785                	addiw	a5,a5,1
 320:	00f92023          	sw	a5,0(s2)
    thread_yield();
 324:	00000097          	auipc	ra,0x0
 328:	dc2080e7          	jalr	-574(ra) # e6 <thread_yield>
  for (i = 0; i < 100; i++) {
 32c:	2485                	addiw	s1,s1,1
 32e:	ff3490e3          	bne	s1,s3,30e <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 332:	00001597          	auipc	a1,0x1
 336:	9ee5a583          	lw	a1,-1554(a1) # d20 <c_n>
 33a:	00001517          	auipc	a0,0x1
 33e:	94e50513          	addi	a0,a0,-1714 # c88 <malloc+0x1e0>
 342:	00000097          	auipc	ra,0x0
 346:	6aa080e7          	jalr	1706(ra) # 9ec <printf>

  current_thread->state = FREE;
 34a:	00001797          	auipc	a5,0x1
 34e:	9ee7b783          	ld	a5,-1554(a5) # d38 <current_thread>
 352:	6709                	lui	a4,0x2
 354:	97ba                	add	a5,a5,a4
 356:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 35a:	00000097          	auipc	ra,0x0
 35e:	cd0080e7          	jalr	-816(ra) # 2a <thread_schedule>
}
 362:	70a2                	ld	ra,40(sp)
 364:	7402                	ld	s0,32(sp)
 366:	64e2                	ld	s1,24(sp)
 368:	6942                	ld	s2,16(sp)
 36a:	69a2                	ld	s3,8(sp)
 36c:	6a02                	ld	s4,0(sp)
 36e:	6145                	addi	sp,sp,48
 370:	8082                	ret

0000000000000372 <main>:

int 
main(int argc, char *argv[]) 
{
 372:	1141                	addi	sp,sp,-16
 374:	e406                	sd	ra,8(sp)
 376:	e022                	sd	s0,0(sp)
 378:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 37a:	00001797          	auipc	a5,0x1
 37e:	9a07a923          	sw	zero,-1614(a5) # d2c <c_started>
 382:	00001797          	auipc	a5,0x1
 386:	9a07a723          	sw	zero,-1618(a5) # d30 <b_started>
 38a:	00001797          	auipc	a5,0x1
 38e:	9a07a523          	sw	zero,-1622(a5) # d34 <a_started>
  a_n = b_n = c_n = 0;
 392:	00001797          	auipc	a5,0x1
 396:	9807a723          	sw	zero,-1650(a5) # d20 <c_n>
 39a:	00001797          	auipc	a5,0x1
 39e:	9807a523          	sw	zero,-1654(a5) # d24 <b_n>
 3a2:	00001797          	auipc	a5,0x1
 3a6:	9807a323          	sw	zero,-1658(a5) # d28 <a_n>
  thread_init();
 3aa:	00000097          	auipc	ra,0x0
 3ae:	c56080e7          	jalr	-938(ra) # 0 <thread_init>
  thread_create(thread_a);
 3b2:	00000517          	auipc	a0,0x0
 3b6:	d5c50513          	addi	a0,a0,-676 # 10e <thread_a>
 3ba:	00000097          	auipc	ra,0x0
 3be:	cea080e7          	jalr	-790(ra) # a4 <thread_create>
  thread_create(thread_b);
 3c2:	00000517          	auipc	a0,0x0
 3c6:	e1850513          	addi	a0,a0,-488 # 1da <thread_b>
 3ca:	00000097          	auipc	ra,0x0
 3ce:	cda080e7          	jalr	-806(ra) # a4 <thread_create>
  thread_create(thread_c);
 3d2:	00000517          	auipc	a0,0x0
 3d6:	ed450513          	addi	a0,a0,-300 # 2a6 <thread_c>
 3da:	00000097          	auipc	ra,0x0
 3de:	cca080e7          	jalr	-822(ra) # a4 <thread_create>
  thread_schedule();
 3e2:	00000097          	auipc	ra,0x0
 3e6:	c48080e7          	jalr	-952(ra) # 2a <thread_schedule>
  exit(0);
 3ea:	4501                	li	a0,0
 3ec:	00000097          	auipc	ra,0x0
 3f0:	2aa080e7          	jalr	682(ra) # 696 <exit>

00000000000003f4 <thread_switch>:
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	ret    /* return to ra */
 3f4:	8082                	ret

00000000000003f6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 3f6:	1141                	addi	sp,sp,-16
 3f8:	e406                	sd	ra,8(sp)
 3fa:	e022                	sd	s0,0(sp)
 3fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3fe:	87aa                	mv	a5,a0
 400:	0585                	addi	a1,a1,1
 402:	0785                	addi	a5,a5,1
 404:	fff5c703          	lbu	a4,-1(a1)
 408:	fee78fa3          	sb	a4,-1(a5)
 40c:	fb75                	bnez	a4,400 <strcpy+0xa>
    ;
  return os;
}
 40e:	60a2                	ld	ra,8(sp)
 410:	6402                	ld	s0,0(sp)
 412:	0141                	addi	sp,sp,16
 414:	8082                	ret

0000000000000416 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 416:	1141                	addi	sp,sp,-16
 418:	e406                	sd	ra,8(sp)
 41a:	e022                	sd	s0,0(sp)
 41c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 41e:	00054783          	lbu	a5,0(a0)
 422:	cb91                	beqz	a5,436 <strcmp+0x20>
 424:	0005c703          	lbu	a4,0(a1)
 428:	00f71763          	bne	a4,a5,436 <strcmp+0x20>
    p++, q++;
 42c:	0505                	addi	a0,a0,1
 42e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 430:	00054783          	lbu	a5,0(a0)
 434:	fbe5                	bnez	a5,424 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 436:	0005c503          	lbu	a0,0(a1)
}
 43a:	40a7853b          	subw	a0,a5,a0
 43e:	60a2                	ld	ra,8(sp)
 440:	6402                	ld	s0,0(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret

0000000000000446 <strlen>:

uint
strlen(const char *s)
{
 446:	1141                	addi	sp,sp,-16
 448:	e406                	sd	ra,8(sp)
 44a:	e022                	sd	s0,0(sp)
 44c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 44e:	00054783          	lbu	a5,0(a0)
 452:	cf99                	beqz	a5,470 <strlen+0x2a>
 454:	0505                	addi	a0,a0,1
 456:	87aa                	mv	a5,a0
 458:	86be                	mv	a3,a5
 45a:	0785                	addi	a5,a5,1
 45c:	fff7c703          	lbu	a4,-1(a5)
 460:	ff65                	bnez	a4,458 <strlen+0x12>
 462:	40a6853b          	subw	a0,a3,a0
 466:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 468:	60a2                	ld	ra,8(sp)
 46a:	6402                	ld	s0,0(sp)
 46c:	0141                	addi	sp,sp,16
 46e:	8082                	ret
  for(n = 0; s[n]; n++)
 470:	4501                	li	a0,0
 472:	bfdd                	j	468 <strlen+0x22>

0000000000000474 <memset>:

void*
memset(void *dst, int c, uint n)
{
 474:	1141                	addi	sp,sp,-16
 476:	e406                	sd	ra,8(sp)
 478:	e022                	sd	s0,0(sp)
 47a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 47c:	ca19                	beqz	a2,492 <memset+0x1e>
 47e:	87aa                	mv	a5,a0
 480:	1602                	slli	a2,a2,0x20
 482:	9201                	srli	a2,a2,0x20
 484:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 488:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 48c:	0785                	addi	a5,a5,1
 48e:	fee79de3          	bne	a5,a4,488 <memset+0x14>
  }
  return dst;
}
 492:	60a2                	ld	ra,8(sp)
 494:	6402                	ld	s0,0(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret

000000000000049a <strchr>:

char*
strchr(const char *s, char c)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e406                	sd	ra,8(sp)
 49e:	e022                	sd	s0,0(sp)
 4a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	cf81                	beqz	a5,4be <strchr+0x24>
    if(*s == c)
 4a8:	00f58763          	beq	a1,a5,4b6 <strchr+0x1c>
  for(; *s; s++)
 4ac:	0505                	addi	a0,a0,1
 4ae:	00054783          	lbu	a5,0(a0)
 4b2:	fbfd                	bnez	a5,4a8 <strchr+0xe>
      return (char*)s;
  return 0;
 4b4:	4501                	li	a0,0
}
 4b6:	60a2                	ld	ra,8(sp)
 4b8:	6402                	ld	s0,0(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret
  return 0;
 4be:	4501                	li	a0,0
 4c0:	bfdd                	j	4b6 <strchr+0x1c>

00000000000004c2 <gets>:

char*
gets(char *buf, int max)
{
 4c2:	7159                	addi	sp,sp,-112
 4c4:	f486                	sd	ra,104(sp)
 4c6:	f0a2                	sd	s0,96(sp)
 4c8:	eca6                	sd	s1,88(sp)
 4ca:	e8ca                	sd	s2,80(sp)
 4cc:	e4ce                	sd	s3,72(sp)
 4ce:	e0d2                	sd	s4,64(sp)
 4d0:	fc56                	sd	s5,56(sp)
 4d2:	f85a                	sd	s6,48(sp)
 4d4:	f45e                	sd	s7,40(sp)
 4d6:	f062                	sd	s8,32(sp)
 4d8:	ec66                	sd	s9,24(sp)
 4da:	e86a                	sd	s10,16(sp)
 4dc:	1880                	addi	s0,sp,112
 4de:	8caa                	mv	s9,a0
 4e0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e2:	892a                	mv	s2,a0
 4e4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 4e6:	f9f40b13          	addi	s6,s0,-97
 4ea:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4ec:	4ba9                	li	s7,10
 4ee:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 4f0:	8d26                	mv	s10,s1
 4f2:	0014899b          	addiw	s3,s1,1
 4f6:	84ce                	mv	s1,s3
 4f8:	0349d763          	bge	s3,s4,526 <gets+0x64>
    cc = read(0, &c, 1);
 4fc:	8656                	mv	a2,s5
 4fe:	85da                	mv	a1,s6
 500:	4501                	li	a0,0
 502:	00000097          	auipc	ra,0x0
 506:	1ac080e7          	jalr	428(ra) # 6ae <read>
    if(cc < 1)
 50a:	00a05e63          	blez	a0,526 <gets+0x64>
    buf[i++] = c;
 50e:	f9f44783          	lbu	a5,-97(s0)
 512:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 516:	01778763          	beq	a5,s7,524 <gets+0x62>
 51a:	0905                	addi	s2,s2,1
 51c:	fd879ae3          	bne	a5,s8,4f0 <gets+0x2e>
    buf[i++] = c;
 520:	8d4e                	mv	s10,s3
 522:	a011                	j	526 <gets+0x64>
 524:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 526:	9d66                	add	s10,s10,s9
 528:	000d0023          	sb	zero,0(s10)
  return buf;
}
 52c:	8566                	mv	a0,s9
 52e:	70a6                	ld	ra,104(sp)
 530:	7406                	ld	s0,96(sp)
 532:	64e6                	ld	s1,88(sp)
 534:	6946                	ld	s2,80(sp)
 536:	69a6                	ld	s3,72(sp)
 538:	6a06                	ld	s4,64(sp)
 53a:	7ae2                	ld	s5,56(sp)
 53c:	7b42                	ld	s6,48(sp)
 53e:	7ba2                	ld	s7,40(sp)
 540:	7c02                	ld	s8,32(sp)
 542:	6ce2                	ld	s9,24(sp)
 544:	6d42                	ld	s10,16(sp)
 546:	6165                	addi	sp,sp,112
 548:	8082                	ret

000000000000054a <stat>:

int
stat(const char *n, struct stat *st)
{
 54a:	1101                	addi	sp,sp,-32
 54c:	ec06                	sd	ra,24(sp)
 54e:	e822                	sd	s0,16(sp)
 550:	e04a                	sd	s2,0(sp)
 552:	1000                	addi	s0,sp,32
 554:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 556:	4581                	li	a1,0
 558:	00000097          	auipc	ra,0x0
 55c:	17e080e7          	jalr	382(ra) # 6d6 <open>
  if(fd < 0)
 560:	02054663          	bltz	a0,58c <stat+0x42>
 564:	e426                	sd	s1,8(sp)
 566:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 568:	85ca                	mv	a1,s2
 56a:	00000097          	auipc	ra,0x0
 56e:	184080e7          	jalr	388(ra) # 6ee <fstat>
 572:	892a                	mv	s2,a0
  close(fd);
 574:	8526                	mv	a0,s1
 576:	00000097          	auipc	ra,0x0
 57a:	148080e7          	jalr	328(ra) # 6be <close>
  return r;
 57e:	64a2                	ld	s1,8(sp)
}
 580:	854a                	mv	a0,s2
 582:	60e2                	ld	ra,24(sp)
 584:	6442                	ld	s0,16(sp)
 586:	6902                	ld	s2,0(sp)
 588:	6105                	addi	sp,sp,32
 58a:	8082                	ret
    return -1;
 58c:	597d                	li	s2,-1
 58e:	bfcd                	j	580 <stat+0x36>

0000000000000590 <atoi>:

int
atoi(const char *s)
{
 590:	1141                	addi	sp,sp,-16
 592:	e406                	sd	ra,8(sp)
 594:	e022                	sd	s0,0(sp)
 596:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 598:	00054683          	lbu	a3,0(a0)
 59c:	fd06879b          	addiw	a5,a3,-48
 5a0:	0ff7f793          	zext.b	a5,a5
 5a4:	4625                	li	a2,9
 5a6:	02f66963          	bltu	a2,a5,5d8 <atoi+0x48>
 5aa:	872a                	mv	a4,a0
  n = 0;
 5ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5ae:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0xae8>
 5b0:	0025179b          	slliw	a5,a0,0x2
 5b4:	9fa9                	addw	a5,a5,a0
 5b6:	0017979b          	slliw	a5,a5,0x1
 5ba:	9fb5                	addw	a5,a5,a3
 5bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5c0:	00074683          	lbu	a3,0(a4)
 5c4:	fd06879b          	addiw	a5,a3,-48
 5c8:	0ff7f793          	zext.b	a5,a5
 5cc:	fef671e3          	bgeu	a2,a5,5ae <atoi+0x1e>
  return n;
}
 5d0:	60a2                	ld	ra,8(sp)
 5d2:	6402                	ld	s0,0(sp)
 5d4:	0141                	addi	sp,sp,16
 5d6:	8082                	ret
  n = 0;
 5d8:	4501                	li	a0,0
 5da:	bfdd                	j	5d0 <atoi+0x40>

00000000000005dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5dc:	1141                	addi	sp,sp,-16
 5de:	e406                	sd	ra,8(sp)
 5e0:	e022                	sd	s0,0(sp)
 5e2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 5e4:	02b57563          	bgeu	a0,a1,60e <memmove+0x32>
    while(n-- > 0)
 5e8:	00c05f63          	blez	a2,606 <memmove+0x2a>
 5ec:	1602                	slli	a2,a2,0x20
 5ee:	9201                	srli	a2,a2,0x20
 5f0:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5f4:	872a                	mv	a4,a0
      *dst++ = *src++;
 5f6:	0585                	addi	a1,a1,1
 5f8:	0705                	addi	a4,a4,1
 5fa:	fff5c683          	lbu	a3,-1(a1)
 5fe:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 602:	fee79ae3          	bne	a5,a4,5f6 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 606:	60a2                	ld	ra,8(sp)
 608:	6402                	ld	s0,0(sp)
 60a:	0141                	addi	sp,sp,16
 60c:	8082                	ret
    dst += n;
 60e:	00c50733          	add	a4,a0,a2
    src += n;
 612:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 614:	fec059e3          	blez	a2,606 <memmove+0x2a>
 618:	fff6079b          	addiw	a5,a2,-1
 61c:	1782                	slli	a5,a5,0x20
 61e:	9381                	srli	a5,a5,0x20
 620:	fff7c793          	not	a5,a5
 624:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 626:	15fd                	addi	a1,a1,-1
 628:	177d                	addi	a4,a4,-1
 62a:	0005c683          	lbu	a3,0(a1)
 62e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 632:	fef71ae3          	bne	a4,a5,626 <memmove+0x4a>
 636:	bfc1                	j	606 <memmove+0x2a>

0000000000000638 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 638:	1141                	addi	sp,sp,-16
 63a:	e406                	sd	ra,8(sp)
 63c:	e022                	sd	s0,0(sp)
 63e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 640:	ca0d                	beqz	a2,672 <memcmp+0x3a>
 642:	fff6069b          	addiw	a3,a2,-1
 646:	1682                	slli	a3,a3,0x20
 648:	9281                	srli	a3,a3,0x20
 64a:	0685                	addi	a3,a3,1
 64c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 64e:	00054783          	lbu	a5,0(a0)
 652:	0005c703          	lbu	a4,0(a1)
 656:	00e79863          	bne	a5,a4,666 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 65a:	0505                	addi	a0,a0,1
    p2++;
 65c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 65e:	fed518e3          	bne	a0,a3,64e <memcmp+0x16>
  }
  return 0;
 662:	4501                	li	a0,0
 664:	a019                	j	66a <memcmp+0x32>
      return *p1 - *p2;
 666:	40e7853b          	subw	a0,a5,a4
}
 66a:	60a2                	ld	ra,8(sp)
 66c:	6402                	ld	s0,0(sp)
 66e:	0141                	addi	sp,sp,16
 670:	8082                	ret
  return 0;
 672:	4501                	li	a0,0
 674:	bfdd                	j	66a <memcmp+0x32>

0000000000000676 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 676:	1141                	addi	sp,sp,-16
 678:	e406                	sd	ra,8(sp)
 67a:	e022                	sd	s0,0(sp)
 67c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 67e:	00000097          	auipc	ra,0x0
 682:	f5e080e7          	jalr	-162(ra) # 5dc <memmove>
}
 686:	60a2                	ld	ra,8(sp)
 688:	6402                	ld	s0,0(sp)
 68a:	0141                	addi	sp,sp,16
 68c:	8082                	ret

000000000000068e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 68e:	4885                	li	a7,1
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <exit>:
.global exit
exit:
 li a7, SYS_exit
 696:	4889                	li	a7,2
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <wait>:
.global wait
wait:
 li a7, SYS_wait
 69e:	488d                	li	a7,3
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6a6:	4891                	li	a7,4
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <read>:
.global read
read:
 li a7, SYS_read
 6ae:	4895                	li	a7,5
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <write>:
.global write
write:
 li a7, SYS_write
 6b6:	48c1                	li	a7,16
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <close>:
.global close
close:
 li a7, SYS_close
 6be:	48d5                	li	a7,21
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6c6:	4899                	li	a7,6
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 6ce:	489d                	li	a7,7
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <open>:
.global open
open:
 li a7, SYS_open
 6d6:	48bd                	li	a7,15
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 6de:	48c5                	li	a7,17
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 6e6:	48c9                	li	a7,18
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 6ee:	48a1                	li	a7,8
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <link>:
.global link
link:
 li a7, SYS_link
 6f6:	48cd                	li	a7,19
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6fe:	48d1                	li	a7,20
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 706:	48a5                	li	a7,9
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <dup>:
.global dup
dup:
 li a7, SYS_dup
 70e:	48a9                	li	a7,10
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 716:	48ad                	li	a7,11
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 71e:	48b1                	li	a7,12
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 726:	48b5                	li	a7,13
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 72e:	48b9                	li	a7,14
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 736:	1101                	addi	sp,sp,-32
 738:	ec06                	sd	ra,24(sp)
 73a:	e822                	sd	s0,16(sp)
 73c:	1000                	addi	s0,sp,32
 73e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 742:	4605                	li	a2,1
 744:	fef40593          	addi	a1,s0,-17
 748:	00000097          	auipc	ra,0x0
 74c:	f6e080e7          	jalr	-146(ra) # 6b6 <write>
}
 750:	60e2                	ld	ra,24(sp)
 752:	6442                	ld	s0,16(sp)
 754:	6105                	addi	sp,sp,32
 756:	8082                	ret

0000000000000758 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 758:	7139                	addi	sp,sp,-64
 75a:	fc06                	sd	ra,56(sp)
 75c:	f822                	sd	s0,48(sp)
 75e:	f426                	sd	s1,40(sp)
 760:	f04a                	sd	s2,32(sp)
 762:	ec4e                	sd	s3,24(sp)
 764:	0080                	addi	s0,sp,64
 766:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 768:	c299                	beqz	a3,76e <printint+0x16>
 76a:	0805c063          	bltz	a1,7ea <printint+0x92>
  neg = 0;
 76e:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 770:	fc040313          	addi	t1,s0,-64
  neg = 0;
 774:	869a                	mv	a3,t1
  i = 0;
 776:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 778:	00000817          	auipc	a6,0x0
 77c:	59080813          	addi	a6,a6,1424 # d08 <digits>
 780:	88be                	mv	a7,a5
 782:	0017851b          	addiw	a0,a5,1
 786:	87aa                	mv	a5,a0
 788:	02c5f73b          	remuw	a4,a1,a2
 78c:	1702                	slli	a4,a4,0x20
 78e:	9301                	srli	a4,a4,0x20
 790:	9742                	add	a4,a4,a6
 792:	00074703          	lbu	a4,0(a4)
 796:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 79a:	872e                	mv	a4,a1
 79c:	02c5d5bb          	divuw	a1,a1,a2
 7a0:	0685                	addi	a3,a3,1
 7a2:	fcc77fe3          	bgeu	a4,a2,780 <printint+0x28>
  if(neg)
 7a6:	000e0c63          	beqz	t3,7be <printint+0x66>
    buf[i++] = '-';
 7aa:	fd050793          	addi	a5,a0,-48
 7ae:	00878533          	add	a0,a5,s0
 7b2:	02d00793          	li	a5,45
 7b6:	fef50823          	sb	a5,-16(a0)
 7ba:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 7be:	fff7899b          	addiw	s3,a5,-1
 7c2:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 7c6:	fff4c583          	lbu	a1,-1(s1)
 7ca:	854a                	mv	a0,s2
 7cc:	00000097          	auipc	ra,0x0
 7d0:	f6a080e7          	jalr	-150(ra) # 736 <putc>
  while(--i >= 0)
 7d4:	39fd                	addiw	s3,s3,-1
 7d6:	14fd                	addi	s1,s1,-1
 7d8:	fe09d7e3          	bgez	s3,7c6 <printint+0x6e>
}
 7dc:	70e2                	ld	ra,56(sp)
 7de:	7442                	ld	s0,48(sp)
 7e0:	74a2                	ld	s1,40(sp)
 7e2:	7902                	ld	s2,32(sp)
 7e4:	69e2                	ld	s3,24(sp)
 7e6:	6121                	addi	sp,sp,64
 7e8:	8082                	ret
    x = -xx;
 7ea:	40b005bb          	negw	a1,a1
    neg = 1;
 7ee:	4e05                	li	t3,1
    x = -xx;
 7f0:	b741                	j	770 <printint+0x18>

00000000000007f2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7f2:	715d                	addi	sp,sp,-80
 7f4:	e486                	sd	ra,72(sp)
 7f6:	e0a2                	sd	s0,64(sp)
 7f8:	f84a                	sd	s2,48(sp)
 7fa:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7fc:	0005c903          	lbu	s2,0(a1)
 800:	1a090a63          	beqz	s2,9b4 <vprintf+0x1c2>
 804:	fc26                	sd	s1,56(sp)
 806:	f44e                	sd	s3,40(sp)
 808:	f052                	sd	s4,32(sp)
 80a:	ec56                	sd	s5,24(sp)
 80c:	e85a                	sd	s6,16(sp)
 80e:	e45e                	sd	s7,8(sp)
 810:	8aaa                	mv	s5,a0
 812:	8bb2                	mv	s7,a2
 814:	00158493          	addi	s1,a1,1
  state = 0;
 818:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 81a:	02500a13          	li	s4,37
 81e:	4b55                	li	s6,21
 820:	a839                	j	83e <vprintf+0x4c>
        putc(fd, c);
 822:	85ca                	mv	a1,s2
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	f10080e7          	jalr	-240(ra) # 736 <putc>
 82e:	a019                	j	834 <vprintf+0x42>
    } else if(state == '%'){
 830:	01498d63          	beq	s3,s4,84a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 834:	0485                	addi	s1,s1,1
 836:	fff4c903          	lbu	s2,-1(s1)
 83a:	16090763          	beqz	s2,9a8 <vprintf+0x1b6>
    if(state == 0){
 83e:	fe0999e3          	bnez	s3,830 <vprintf+0x3e>
      if(c == '%'){
 842:	ff4910e3          	bne	s2,s4,822 <vprintf+0x30>
        state = '%';
 846:	89d2                	mv	s3,s4
 848:	b7f5                	j	834 <vprintf+0x42>
      if(c == 'd'){
 84a:	13490463          	beq	s2,s4,972 <vprintf+0x180>
 84e:	f9d9079b          	addiw	a5,s2,-99
 852:	0ff7f793          	zext.b	a5,a5
 856:	12fb6763          	bltu	s6,a5,984 <vprintf+0x192>
 85a:	f9d9079b          	addiw	a5,s2,-99
 85e:	0ff7f713          	zext.b	a4,a5
 862:	12eb6163          	bltu	s6,a4,984 <vprintf+0x192>
 866:	00271793          	slli	a5,a4,0x2
 86a:	00000717          	auipc	a4,0x0
 86e:	44670713          	addi	a4,a4,1094 # cb0 <malloc+0x208>
 872:	97ba                	add	a5,a5,a4
 874:	439c                	lw	a5,0(a5)
 876:	97ba                	add	a5,a5,a4
 878:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 87a:	008b8913          	addi	s2,s7,8
 87e:	4685                	li	a3,1
 880:	4629                	li	a2,10
 882:	000ba583          	lw	a1,0(s7)
 886:	8556                	mv	a0,s5
 888:	00000097          	auipc	ra,0x0
 88c:	ed0080e7          	jalr	-304(ra) # 758 <printint>
 890:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 892:	4981                	li	s3,0
 894:	b745                	j	834 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 896:	008b8913          	addi	s2,s7,8
 89a:	4681                	li	a3,0
 89c:	4629                	li	a2,10
 89e:	000ba583          	lw	a1,0(s7)
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	eb4080e7          	jalr	-332(ra) # 758 <printint>
 8ac:	8bca                	mv	s7,s2
      state = 0;
 8ae:	4981                	li	s3,0
 8b0:	b751                	j	834 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 8b2:	008b8913          	addi	s2,s7,8
 8b6:	4681                	li	a3,0
 8b8:	4641                	li	a2,16
 8ba:	000ba583          	lw	a1,0(s7)
 8be:	8556                	mv	a0,s5
 8c0:	00000097          	auipc	ra,0x0
 8c4:	e98080e7          	jalr	-360(ra) # 758 <printint>
 8c8:	8bca                	mv	s7,s2
      state = 0;
 8ca:	4981                	li	s3,0
 8cc:	b7a5                	j	834 <vprintf+0x42>
 8ce:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 8d0:	008b8c13          	addi	s8,s7,8
 8d4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8d8:	03000593          	li	a1,48
 8dc:	8556                	mv	a0,s5
 8de:	00000097          	auipc	ra,0x0
 8e2:	e58080e7          	jalr	-424(ra) # 736 <putc>
  putc(fd, 'x');
 8e6:	07800593          	li	a1,120
 8ea:	8556                	mv	a0,s5
 8ec:	00000097          	auipc	ra,0x0
 8f0:	e4a080e7          	jalr	-438(ra) # 736 <putc>
 8f4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8f6:	00000b97          	auipc	s7,0x0
 8fa:	412b8b93          	addi	s7,s7,1042 # d08 <digits>
 8fe:	03c9d793          	srli	a5,s3,0x3c
 902:	97de                	add	a5,a5,s7
 904:	0007c583          	lbu	a1,0(a5)
 908:	8556                	mv	a0,s5
 90a:	00000097          	auipc	ra,0x0
 90e:	e2c080e7          	jalr	-468(ra) # 736 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 912:	0992                	slli	s3,s3,0x4
 914:	397d                	addiw	s2,s2,-1
 916:	fe0914e3          	bnez	s2,8fe <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 91a:	8be2                	mv	s7,s8
      state = 0;
 91c:	4981                	li	s3,0
 91e:	6c02                	ld	s8,0(sp)
 920:	bf11                	j	834 <vprintf+0x42>
        s = va_arg(ap, char*);
 922:	008b8993          	addi	s3,s7,8
 926:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 92a:	02090163          	beqz	s2,94c <vprintf+0x15a>
        while(*s != 0){
 92e:	00094583          	lbu	a1,0(s2)
 932:	c9a5                	beqz	a1,9a2 <vprintf+0x1b0>
          putc(fd, *s);
 934:	8556                	mv	a0,s5
 936:	00000097          	auipc	ra,0x0
 93a:	e00080e7          	jalr	-512(ra) # 736 <putc>
          s++;
 93e:	0905                	addi	s2,s2,1
        while(*s != 0){
 940:	00094583          	lbu	a1,0(s2)
 944:	f9e5                	bnez	a1,934 <vprintf+0x142>
        s = va_arg(ap, char*);
 946:	8bce                	mv	s7,s3
      state = 0;
 948:	4981                	li	s3,0
 94a:	b5ed                	j	834 <vprintf+0x42>
          s = "(null)";
 94c:	00000917          	auipc	s2,0x0
 950:	35c90913          	addi	s2,s2,860 # ca8 <malloc+0x200>
        while(*s != 0){
 954:	02800593          	li	a1,40
 958:	bff1                	j	934 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 95a:	008b8913          	addi	s2,s7,8
 95e:	000bc583          	lbu	a1,0(s7)
 962:	8556                	mv	a0,s5
 964:	00000097          	auipc	ra,0x0
 968:	dd2080e7          	jalr	-558(ra) # 736 <putc>
 96c:	8bca                	mv	s7,s2
      state = 0;
 96e:	4981                	li	s3,0
 970:	b5d1                	j	834 <vprintf+0x42>
        putc(fd, c);
 972:	02500593          	li	a1,37
 976:	8556                	mv	a0,s5
 978:	00000097          	auipc	ra,0x0
 97c:	dbe080e7          	jalr	-578(ra) # 736 <putc>
      state = 0;
 980:	4981                	li	s3,0
 982:	bd4d                	j	834 <vprintf+0x42>
        putc(fd, '%');
 984:	02500593          	li	a1,37
 988:	8556                	mv	a0,s5
 98a:	00000097          	auipc	ra,0x0
 98e:	dac080e7          	jalr	-596(ra) # 736 <putc>
        putc(fd, c);
 992:	85ca                	mv	a1,s2
 994:	8556                	mv	a0,s5
 996:	00000097          	auipc	ra,0x0
 99a:	da0080e7          	jalr	-608(ra) # 736 <putc>
      state = 0;
 99e:	4981                	li	s3,0
 9a0:	bd51                	j	834 <vprintf+0x42>
        s = va_arg(ap, char*);
 9a2:	8bce                	mv	s7,s3
      state = 0;
 9a4:	4981                	li	s3,0
 9a6:	b579                	j	834 <vprintf+0x42>
 9a8:	74e2                	ld	s1,56(sp)
 9aa:	79a2                	ld	s3,40(sp)
 9ac:	7a02                	ld	s4,32(sp)
 9ae:	6ae2                	ld	s5,24(sp)
 9b0:	6b42                	ld	s6,16(sp)
 9b2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 9b4:	60a6                	ld	ra,72(sp)
 9b6:	6406                	ld	s0,64(sp)
 9b8:	7942                	ld	s2,48(sp)
 9ba:	6161                	addi	sp,sp,80
 9bc:	8082                	ret

00000000000009be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9be:	715d                	addi	sp,sp,-80
 9c0:	ec06                	sd	ra,24(sp)
 9c2:	e822                	sd	s0,16(sp)
 9c4:	1000                	addi	s0,sp,32
 9c6:	e010                	sd	a2,0(s0)
 9c8:	e414                	sd	a3,8(s0)
 9ca:	e818                	sd	a4,16(s0)
 9cc:	ec1c                	sd	a5,24(s0)
 9ce:	03043023          	sd	a6,32(s0)
 9d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9d6:	8622                	mv	a2,s0
 9d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9dc:	00000097          	auipc	ra,0x0
 9e0:	e16080e7          	jalr	-490(ra) # 7f2 <vprintf>
}
 9e4:	60e2                	ld	ra,24(sp)
 9e6:	6442                	ld	s0,16(sp)
 9e8:	6161                	addi	sp,sp,80
 9ea:	8082                	ret

00000000000009ec <printf>:

void
printf(const char *fmt, ...)
{
 9ec:	711d                	addi	sp,sp,-96
 9ee:	ec06                	sd	ra,24(sp)
 9f0:	e822                	sd	s0,16(sp)
 9f2:	1000                	addi	s0,sp,32
 9f4:	e40c                	sd	a1,8(s0)
 9f6:	e810                	sd	a2,16(s0)
 9f8:	ec14                	sd	a3,24(s0)
 9fa:	f018                	sd	a4,32(s0)
 9fc:	f41c                	sd	a5,40(s0)
 9fe:	03043823          	sd	a6,48(s0)
 a02:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a06:	00840613          	addi	a2,s0,8
 a0a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a0e:	85aa                	mv	a1,a0
 a10:	4505                	li	a0,1
 a12:	00000097          	auipc	ra,0x0
 a16:	de0080e7          	jalr	-544(ra) # 7f2 <vprintf>
}
 a1a:	60e2                	ld	ra,24(sp)
 a1c:	6442                	ld	s0,16(sp)
 a1e:	6125                	addi	sp,sp,96
 a20:	8082                	ret

0000000000000a22 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a22:	1141                	addi	sp,sp,-16
 a24:	e406                	sd	ra,8(sp)
 a26:	e022                	sd	s0,0(sp)
 a28:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a2a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a2e:	00000797          	auipc	a5,0x0
 a32:	3127b783          	ld	a5,786(a5) # d40 <freep>
 a36:	a02d                	j	a60 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a38:	4618                	lw	a4,8(a2)
 a3a:	9f2d                	addw	a4,a4,a1
 a3c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a40:	6398                	ld	a4,0(a5)
 a42:	6310                	ld	a2,0(a4)
 a44:	a83d                	j	a82 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a46:	ff852703          	lw	a4,-8(a0)
 a4a:	9f31                	addw	a4,a4,a2
 a4c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a4e:	ff053683          	ld	a3,-16(a0)
 a52:	a091                	j	a96 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a54:	6398                	ld	a4,0(a5)
 a56:	00e7e463          	bltu	a5,a4,a5e <free+0x3c>
 a5a:	00e6ea63          	bltu	a3,a4,a6e <free+0x4c>
{
 a5e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a60:	fed7fae3          	bgeu	a5,a3,a54 <free+0x32>
 a64:	6398                	ld	a4,0(a5)
 a66:	00e6e463          	bltu	a3,a4,a6e <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a6a:	fee7eae3          	bltu	a5,a4,a5e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 a6e:	ff852583          	lw	a1,-8(a0)
 a72:	6390                	ld	a2,0(a5)
 a74:	02059813          	slli	a6,a1,0x20
 a78:	01c85713          	srli	a4,a6,0x1c
 a7c:	9736                	add	a4,a4,a3
 a7e:	fae60de3          	beq	a2,a4,a38 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 a82:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a86:	4790                	lw	a2,8(a5)
 a88:	02061593          	slli	a1,a2,0x20
 a8c:	01c5d713          	srli	a4,a1,0x1c
 a90:	973e                	add	a4,a4,a5
 a92:	fae68ae3          	beq	a3,a4,a46 <free+0x24>
    p->s.ptr = bp->s.ptr;
 a96:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a98:	00000717          	auipc	a4,0x0
 a9c:	2af73423          	sd	a5,680(a4) # d40 <freep>
}
 aa0:	60a2                	ld	ra,8(sp)
 aa2:	6402                	ld	s0,0(sp)
 aa4:	0141                	addi	sp,sp,16
 aa6:	8082                	ret

0000000000000aa8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 aa8:	7139                	addi	sp,sp,-64
 aaa:	fc06                	sd	ra,56(sp)
 aac:	f822                	sd	s0,48(sp)
 aae:	f04a                	sd	s2,32(sp)
 ab0:	ec4e                	sd	s3,24(sp)
 ab2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ab4:	02051993          	slli	s3,a0,0x20
 ab8:	0209d993          	srli	s3,s3,0x20
 abc:	09bd                	addi	s3,s3,15
 abe:	0049d993          	srli	s3,s3,0x4
 ac2:	2985                	addiw	s3,s3,1
 ac4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 ac6:	00000517          	auipc	a0,0x0
 aca:	27a53503          	ld	a0,634(a0) # d40 <freep>
 ace:	c905                	beqz	a0,afe <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad2:	4798                	lw	a4,8(a5)
 ad4:	09377a63          	bgeu	a4,s3,b68 <malloc+0xc0>
 ad8:	f426                	sd	s1,40(sp)
 ada:	e852                	sd	s4,16(sp)
 adc:	e456                	sd	s5,8(sp)
 ade:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 ae0:	8a4e                	mv	s4,s3
 ae2:	6705                	lui	a4,0x1
 ae4:	00e9f363          	bgeu	s3,a4,aea <malloc+0x42>
 ae8:	6a05                	lui	s4,0x1
 aea:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 aee:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 af2:	00000497          	auipc	s1,0x0
 af6:	24e48493          	addi	s1,s1,590 # d40 <freep>
  if(p == (char*)-1)
 afa:	5afd                	li	s5,-1
 afc:	a089                	j	b3e <malloc+0x96>
 afe:	f426                	sd	s1,40(sp)
 b00:	e852                	sd	s4,16(sp)
 b02:	e456                	sd	s5,8(sp)
 b04:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b06:	00008797          	auipc	a5,0x8
 b0a:	25278793          	addi	a5,a5,594 # 8d58 <base>
 b0e:	00000717          	auipc	a4,0x0
 b12:	22f73923          	sd	a5,562(a4) # d40 <freep>
 b16:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b18:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b1c:	b7d1                	j	ae0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b1e:	6398                	ld	a4,0(a5)
 b20:	e118                	sd	a4,0(a0)
 b22:	a8b9                	j	b80 <malloc+0xd8>
  hp->s.size = nu;
 b24:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b28:	0541                	addi	a0,a0,16
 b2a:	00000097          	auipc	ra,0x0
 b2e:	ef8080e7          	jalr	-264(ra) # a22 <free>
  return freep;
 b32:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b34:	c135                	beqz	a0,b98 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b36:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b38:	4798                	lw	a4,8(a5)
 b3a:	03277363          	bgeu	a4,s2,b60 <malloc+0xb8>
    if(p == freep)
 b3e:	6098                	ld	a4,0(s1)
 b40:	853e                	mv	a0,a5
 b42:	fef71ae3          	bne	a4,a5,b36 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b46:	8552                	mv	a0,s4
 b48:	00000097          	auipc	ra,0x0
 b4c:	bd6080e7          	jalr	-1066(ra) # 71e <sbrk>
  if(p == (char*)-1)
 b50:	fd551ae3          	bne	a0,s5,b24 <malloc+0x7c>
        return 0;
 b54:	4501                	li	a0,0
 b56:	74a2                	ld	s1,40(sp)
 b58:	6a42                	ld	s4,16(sp)
 b5a:	6aa2                	ld	s5,8(sp)
 b5c:	6b02                	ld	s6,0(sp)
 b5e:	a03d                	j	b8c <malloc+0xe4>
 b60:	74a2                	ld	s1,40(sp)
 b62:	6a42                	ld	s4,16(sp)
 b64:	6aa2                	ld	s5,8(sp)
 b66:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b68:	fae90be3          	beq	s2,a4,b1e <malloc+0x76>
        p->s.size -= nunits;
 b6c:	4137073b          	subw	a4,a4,s3
 b70:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b72:	02071693          	slli	a3,a4,0x20
 b76:	01c6d713          	srli	a4,a3,0x1c
 b7a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b7c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b80:	00000717          	auipc	a4,0x0
 b84:	1ca73023          	sd	a0,448(a4) # d40 <freep>
      return (void*)(p + 1);
 b88:	01078513          	addi	a0,a5,16
  }
}
 b8c:	70e2                	ld	ra,56(sp)
 b8e:	7442                	ld	s0,48(sp)
 b90:	7902                	ld	s2,32(sp)
 b92:	69e2                	ld	s3,24(sp)
 b94:	6121                	addi	sp,sp,64
 b96:	8082                	ret
 b98:	74a2                	ld	s1,40(sp)
 b9a:	6a42                	ld	s4,16(sp)
 b9c:	6aa2                	ld	s5,8(sp)
 b9e:	6b02                	ld	s6,0(sp)
 ba0:	b7f5                	j	b8c <malloc+0xe4>
