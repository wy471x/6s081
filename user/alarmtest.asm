
user/_alarmtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <periodic>:

volatile static int count;

void
periodic()
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  count = count + 1;
   8:	00001797          	auipc	a5,0x1
   c:	df07a783          	lw	a5,-528(a5) # df8 <count>
  10:	2785                	addiw	a5,a5,1
  12:	00001717          	auipc	a4,0x1
  16:	def72323          	sw	a5,-538(a4) # df8 <count>
  printf("alarm!\n");
  1a:	00001517          	auipc	a0,0x1
  1e:	bce50513          	addi	a0,a0,-1074 # be8 <malloc+0x100>
  22:	00001097          	auipc	ra,0x1
  26:	a0a080e7          	jalr	-1526(ra) # a2c <printf>
  sigreturn();
  2a:	00000097          	auipc	ra,0x0
  2e:	744080e7          	jalr	1860(ra) # 76e <sigreturn>
}
  32:	60a2                	ld	ra,8(sp)
  34:	6402                	ld	s0,0(sp)
  36:	0141                	addi	sp,sp,16
  38:	8082                	ret

000000000000003a <slow_handler>:
  }
}

void
slow_handler()
{
  3a:	1101                	addi	sp,sp,-32
  3c:	ec06                	sd	ra,24(sp)
  3e:	e822                	sd	s0,16(sp)
  40:	e426                	sd	s1,8(sp)
  42:	1000                	addi	s0,sp,32
  count++;
  44:	00001497          	auipc	s1,0x1
  48:	db448493          	addi	s1,s1,-588 # df8 <count>
  4c:	00001797          	auipc	a5,0x1
  50:	dac7a783          	lw	a5,-596(a5) # df8 <count>
  54:	2785                	addiw	a5,a5,1
  56:	c09c                	sw	a5,0(s1)
  printf("alarm!\n");
  58:	00001517          	auipc	a0,0x1
  5c:	b9050513          	addi	a0,a0,-1136 # be8 <malloc+0x100>
  60:	00001097          	auipc	ra,0x1
  64:	9cc080e7          	jalr	-1588(ra) # a2c <printf>
  if (count > 1) {
  68:	4098                	lw	a4,0(s1)
  6a:	2701                	sext.w	a4,a4
  6c:	4685                	li	a3,1
  6e:	1dcd67b7          	lui	a5,0x1dcd6
  72:	50078793          	addi	a5,a5,1280 # 1dcd6500 <__global_pointer$+0x1dcd4f0f>
  76:	02e6c463          	blt	a3,a4,9e <slow_handler+0x64>
    printf("test2 failed: alarm handler called more than once\n");
    exit(1);
  }
  for (int i = 0; i < 1000*500000; i++) {
    asm volatile("nop"); // avoid compiler optimizing away loop
  7a:	0001                	nop
  for (int i = 0; i < 1000*500000; i++) {
  7c:	37fd                	addiw	a5,a5,-1
  7e:	fff5                	bnez	a5,7a <slow_handler+0x40>
  }
  sigalarm(0, 0);
  80:	4581                	li	a1,0
  82:	4501                	li	a0,0
  84:	00000097          	auipc	ra,0x0
  88:	6e2080e7          	jalr	1762(ra) # 766 <sigalarm>
  sigreturn();
  8c:	00000097          	auipc	ra,0x0
  90:	6e2080e7          	jalr	1762(ra) # 76e <sigreturn>
}
  94:	60e2                	ld	ra,24(sp)
  96:	6442                	ld	s0,16(sp)
  98:	64a2                	ld	s1,8(sp)
  9a:	6105                	addi	sp,sp,32
  9c:	8082                	ret
    printf("test2 failed: alarm handler called more than once\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	b5250513          	addi	a0,a0,-1198 # bf0 <malloc+0x108>
  a6:	00001097          	auipc	ra,0x1
  aa:	986080e7          	jalr	-1658(ra) # a2c <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	616080e7          	jalr	1558(ra) # 6c6 <exit>

00000000000000b8 <test0>:
{
  b8:	715d                	addi	sp,sp,-80
  ba:	e486                	sd	ra,72(sp)
  bc:	e0a2                	sd	s0,64(sp)
  be:	fc26                	sd	s1,56(sp)
  c0:	f84a                	sd	s2,48(sp)
  c2:	f44e                	sd	s3,40(sp)
  c4:	f052                	sd	s4,32(sp)
  c6:	ec56                	sd	s5,24(sp)
  c8:	e85a                	sd	s6,16(sp)
  ca:	e45e                	sd	s7,8(sp)
  cc:	e062                	sd	s8,0(sp)
  ce:	0880                	addi	s0,sp,80
  printf("test0 start\n");
  d0:	00001517          	auipc	a0,0x1
  d4:	b5850513          	addi	a0,a0,-1192 # c28 <malloc+0x140>
  d8:	00001097          	auipc	ra,0x1
  dc:	954080e7          	jalr	-1708(ra) # a2c <printf>
  count = 0;
  e0:	00001797          	auipc	a5,0x1
  e4:	d007ac23          	sw	zero,-744(a5) # df8 <count>
  sigalarm(2, periodic);
  e8:	00000597          	auipc	a1,0x0
  ec:	f1858593          	addi	a1,a1,-232 # 0 <periodic>
  f0:	4509                	li	a0,2
  f2:	00000097          	auipc	ra,0x0
  f6:	674080e7          	jalr	1652(ra) # 766 <sigalarm>
  for(i = 0; i < 1000*500000; i++){
  fa:	4481                	li	s1,0
    if((i % 1000000) == 0)
  fc:	431be9b7          	lui	s3,0x431be
 100:	e8398993          	addi	s3,s3,-381 # 431bde83 <__global_pointer$+0x431bc892>
 104:	000f4937          	lui	s2,0xf4
 108:	2409091b          	addiw	s2,s2,576 # f4240 <__global_pointer$+0xf2c4f>
      write(2, ".", 1);
 10c:	4c05                	li	s8,1
 10e:	00001b97          	auipc	s7,0x1
 112:	b2ab8b93          	addi	s7,s7,-1238 # c38 <malloc+0x150>
 116:	4b09                	li	s6,2
    if(count > 0)
 118:	00001a97          	auipc	s5,0x1
 11c:	ce0a8a93          	addi	s5,s5,-800 # df8 <count>
  for(i = 0; i < 1000*500000; i++){
 120:	1dcd6a37          	lui	s4,0x1dcd6
 124:	500a0a13          	addi	s4,s4,1280 # 1dcd6500 <__global_pointer$+0x1dcd4f0f>
 128:	a809                	j	13a <test0+0x82>
    if(count > 0)
 12a:	000aa783          	lw	a5,0(s5)
 12e:	2781                	sext.w	a5,a5
 130:	02f04863          	bgtz	a5,160 <test0+0xa8>
  for(i = 0; i < 1000*500000; i++){
 134:	2485                	addiw	s1,s1,1
 136:	03448563          	beq	s1,s4,160 <test0+0xa8>
    if((i % 1000000) == 0)
 13a:	033487b3          	mul	a5,s1,s3
 13e:	97c9                	srai	a5,a5,0x32
 140:	41f4d71b          	sraiw	a4,s1,0x1f
 144:	9f99                	subw	a5,a5,a4
 146:	02f907bb          	mulw	a5,s2,a5
 14a:	40f487bb          	subw	a5,s1,a5
 14e:	fff1                	bnez	a5,12a <test0+0x72>
      write(2, ".", 1);
 150:	8662                	mv	a2,s8
 152:	85de                	mv	a1,s7
 154:	855a                	mv	a0,s6
 156:	00000097          	auipc	ra,0x0
 15a:	590080e7          	jalr	1424(ra) # 6e6 <write>
 15e:	b7f1                	j	12a <test0+0x72>
  sigalarm(0, 0);
 160:	4581                	li	a1,0
 162:	4501                	li	a0,0
 164:	00000097          	auipc	ra,0x0
 168:	602080e7          	jalr	1538(ra) # 766 <sigalarm>
  if(count > 0){
 16c:	00001797          	auipc	a5,0x1
 170:	c8c7a783          	lw	a5,-884(a5) # df8 <count>
 174:	02f05663          	blez	a5,1a0 <test0+0xe8>
    printf("test0 passed\n");
 178:	00001517          	auipc	a0,0x1
 17c:	ac850513          	addi	a0,a0,-1336 # c40 <malloc+0x158>
 180:	00001097          	auipc	ra,0x1
 184:	8ac080e7          	jalr	-1876(ra) # a2c <printf>
}
 188:	60a6                	ld	ra,72(sp)
 18a:	6406                	ld	s0,64(sp)
 18c:	74e2                	ld	s1,56(sp)
 18e:	7942                	ld	s2,48(sp)
 190:	79a2                	ld	s3,40(sp)
 192:	7a02                	ld	s4,32(sp)
 194:	6ae2                	ld	s5,24(sp)
 196:	6b42                	ld	s6,16(sp)
 198:	6ba2                	ld	s7,8(sp)
 19a:	6c02                	ld	s8,0(sp)
 19c:	6161                	addi	sp,sp,80
 19e:	8082                	ret
    printf("\ntest0 failed: the kernel never called the alarm handler\n");
 1a0:	00001517          	auipc	a0,0x1
 1a4:	ab050513          	addi	a0,a0,-1360 # c50 <malloc+0x168>
 1a8:	00001097          	auipc	ra,0x1
 1ac:	884080e7          	jalr	-1916(ra) # a2c <printf>
}
 1b0:	bfe1                	j	188 <test0+0xd0>

00000000000001b2 <foo>:
void __attribute__ ((noinline)) foo(int i, int *j) {
 1b2:	1101                	addi	sp,sp,-32
 1b4:	ec06                	sd	ra,24(sp)
 1b6:	e822                	sd	s0,16(sp)
 1b8:	e426                	sd	s1,8(sp)
 1ba:	1000                	addi	s0,sp,32
 1bc:	84ae                	mv	s1,a1
  if((i % 2500000) == 0) {
 1be:	6b5fd7b7          	lui	a5,0x6b5fd
 1c2:	a6b78793          	addi	a5,a5,-1429 # 6b5fca6b <__global_pointer$+0x6b5fb47a>
 1c6:	02f507b3          	mul	a5,a0,a5
 1ca:	97d1                	srai	a5,a5,0x34
 1cc:	41f5571b          	sraiw	a4,a0,0x1f
 1d0:	9f99                	subw	a5,a5,a4
 1d2:	00262737          	lui	a4,0x262
 1d6:	5a07071b          	addiw	a4,a4,1440 # 2625a0 <__global_pointer$+0x260faf>
 1da:	02f707bb          	mulw	a5,a4,a5
 1de:	9d1d                	subw	a0,a0,a5
 1e0:	c909                	beqz	a0,1f2 <foo+0x40>
  *j += 1;
 1e2:	409c                	lw	a5,0(s1)
 1e4:	2785                	addiw	a5,a5,1
 1e6:	c09c                	sw	a5,0(s1)
}
 1e8:	60e2                	ld	ra,24(sp)
 1ea:	6442                	ld	s0,16(sp)
 1ec:	64a2                	ld	s1,8(sp)
 1ee:	6105                	addi	sp,sp,32
 1f0:	8082                	ret
    write(2, ".", 1);
 1f2:	4605                	li	a2,1
 1f4:	00001597          	auipc	a1,0x1
 1f8:	a4458593          	addi	a1,a1,-1468 # c38 <malloc+0x150>
 1fc:	4509                	li	a0,2
 1fe:	00000097          	auipc	ra,0x0
 202:	4e8080e7          	jalr	1256(ra) # 6e6 <write>
 206:	bff1                	j	1e2 <foo+0x30>

0000000000000208 <test1>:
{
 208:	715d                	addi	sp,sp,-80
 20a:	e486                	sd	ra,72(sp)
 20c:	e0a2                	sd	s0,64(sp)
 20e:	fc26                	sd	s1,56(sp)
 210:	f84a                	sd	s2,48(sp)
 212:	f44e                	sd	s3,40(sp)
 214:	f052                	sd	s4,32(sp)
 216:	ec56                	sd	s5,24(sp)
 218:	0880                	addi	s0,sp,80
  printf("test1 start\n");
 21a:	00001517          	auipc	a0,0x1
 21e:	a7650513          	addi	a0,a0,-1418 # c90 <malloc+0x1a8>
 222:	00001097          	auipc	ra,0x1
 226:	80a080e7          	jalr	-2038(ra) # a2c <printf>
  count = 0;
 22a:	00001797          	auipc	a5,0x1
 22e:	bc07a723          	sw	zero,-1074(a5) # df8 <count>
  j = 0;
 232:	fa042e23          	sw	zero,-68(s0)
  sigalarm(2, periodic);
 236:	00000597          	auipc	a1,0x0
 23a:	dca58593          	addi	a1,a1,-566 # 0 <periodic>
 23e:	4509                	li	a0,2
 240:	00000097          	auipc	ra,0x0
 244:	526080e7          	jalr	1318(ra) # 766 <sigalarm>
  for(i = 0; i < 500000000; i++){
 248:	4481                	li	s1,0
    if(count >= 10)
 24a:	00001a17          	auipc	s4,0x1
 24e:	baea0a13          	addi	s4,s4,-1106 # df8 <count>
 252:	49a5                	li	s3,9
    foo(i, &j);
 254:	fbc40a93          	addi	s5,s0,-68
  for(i = 0; i < 500000000; i++){
 258:	1dcd6937          	lui	s2,0x1dcd6
 25c:	50090913          	addi	s2,s2,1280 # 1dcd6500 <__global_pointer$+0x1dcd4f0f>
    if(count >= 10)
 260:	000a2783          	lw	a5,0(s4)
 264:	2781                	sext.w	a5,a5
 266:	00f9cb63          	blt	s3,a5,27c <test1+0x74>
    foo(i, &j);
 26a:	85d6                	mv	a1,s5
 26c:	8526                	mv	a0,s1
 26e:	00000097          	auipc	ra,0x0
 272:	f44080e7          	jalr	-188(ra) # 1b2 <foo>
  for(i = 0; i < 500000000; i++){
 276:	2485                	addiw	s1,s1,1
 278:	ff2494e3          	bne	s1,s2,260 <test1+0x58>
  if(count < 10){
 27c:	00001717          	auipc	a4,0x1
 280:	b7c72703          	lw	a4,-1156(a4) # df8 <count>
 284:	47a5                	li	a5,9
 286:	02e7d763          	bge	a5,a4,2b4 <test1+0xac>
  } else if(i != j){
 28a:	fbc42783          	lw	a5,-68(s0)
 28e:	02978c63          	beq	a5,s1,2c6 <test1+0xbe>
    printf("\ntest1 failed: foo() executed fewer times than it was called\n");
 292:	00001517          	auipc	a0,0x1
 296:	a3e50513          	addi	a0,a0,-1474 # cd0 <malloc+0x1e8>
 29a:	00000097          	auipc	ra,0x0
 29e:	792080e7          	jalr	1938(ra) # a2c <printf>
}
 2a2:	60a6                	ld	ra,72(sp)
 2a4:	6406                	ld	s0,64(sp)
 2a6:	74e2                	ld	s1,56(sp)
 2a8:	7942                	ld	s2,48(sp)
 2aa:	79a2                	ld	s3,40(sp)
 2ac:	7a02                	ld	s4,32(sp)
 2ae:	6ae2                	ld	s5,24(sp)
 2b0:	6161                	addi	sp,sp,80
 2b2:	8082                	ret
    printf("\ntest1 failed: too few calls to the handler\n");
 2b4:	00001517          	auipc	a0,0x1
 2b8:	9ec50513          	addi	a0,a0,-1556 # ca0 <malloc+0x1b8>
 2bc:	00000097          	auipc	ra,0x0
 2c0:	770080e7          	jalr	1904(ra) # a2c <printf>
 2c4:	bff9                	j	2a2 <test1+0x9a>
    printf("test1 passed\n");
 2c6:	00001517          	auipc	a0,0x1
 2ca:	a4a50513          	addi	a0,a0,-1462 # d10 <malloc+0x228>
 2ce:	00000097          	auipc	ra,0x0
 2d2:	75e080e7          	jalr	1886(ra) # a2c <printf>
}
 2d6:	b7f1                	j	2a2 <test1+0x9a>

00000000000002d8 <test2>:
{
 2d8:	711d                	addi	sp,sp,-96
 2da:	ec86                	sd	ra,88(sp)
 2dc:	e8a2                	sd	s0,80(sp)
 2de:	1080                	addi	s0,sp,96
  printf("test2 start\n");
 2e0:	00001517          	auipc	a0,0x1
 2e4:	a4050513          	addi	a0,a0,-1472 # d20 <malloc+0x238>
 2e8:	00000097          	auipc	ra,0x0
 2ec:	744080e7          	jalr	1860(ra) # a2c <printf>
  if ((pid = fork()) < 0) {
 2f0:	00000097          	auipc	ra,0x0
 2f4:	3ce080e7          	jalr	974(ra) # 6be <fork>
 2f8:	06054063          	bltz	a0,358 <test2+0x80>
 2fc:	e4a6                	sd	s1,72(sp)
 2fe:	84aa                	mv	s1,a0
  if (pid == 0) {
 300:	e17d                	bnez	a0,3e6 <test2+0x10e>
 302:	e0ca                	sd	s2,64(sp)
 304:	fc4e                	sd	s3,56(sp)
 306:	f852                	sd	s4,48(sp)
 308:	f456                	sd	s5,40(sp)
 30a:	f05a                	sd	s6,32(sp)
 30c:	ec5e                	sd	s7,24(sp)
 30e:	e862                	sd	s8,16(sp)
    count = 0;
 310:	00001797          	auipc	a5,0x1
 314:	ae07a423          	sw	zero,-1304(a5) # df8 <count>
    sigalarm(2, slow_handler);
 318:	00000597          	auipc	a1,0x0
 31c:	d2258593          	addi	a1,a1,-734 # 3a <slow_handler>
 320:	4509                	li	a0,2
 322:	00000097          	auipc	ra,0x0
 326:	444080e7          	jalr	1092(ra) # 766 <sigalarm>
      if((i % 1000000) == 0)
 32a:	431be9b7          	lui	s3,0x431be
 32e:	e8398993          	addi	s3,s3,-381 # 431bde83 <__global_pointer$+0x431bc892>
 332:	000f4937          	lui	s2,0xf4
 336:	2409091b          	addiw	s2,s2,576 # f4240 <__global_pointer$+0xf2c4f>
        write(2, ".", 1);
 33a:	4c05                	li	s8,1
 33c:	00001b97          	auipc	s7,0x1
 340:	8fcb8b93          	addi	s7,s7,-1796 # c38 <malloc+0x150>
 344:	4b09                	li	s6,2
      if(count > 0)
 346:	00001a97          	auipc	s5,0x1
 34a:	ab2a8a93          	addi	s5,s5,-1358 # df8 <count>
    for(i = 0; i < 1000*500000; i++){
 34e:	1dcd6a37          	lui	s4,0x1dcd6
 352:	500a0a13          	addi	s4,s4,1280 # 1dcd6500 <__global_pointer$+0x1dcd4f0f>
 356:	a835                	j	392 <test2+0xba>
    printf("test2: fork failed\n");
 358:	00001517          	auipc	a0,0x1
 35c:	9d850513          	addi	a0,a0,-1576 # d30 <malloc+0x248>
 360:	00000097          	auipc	ra,0x0
 364:	6cc080e7          	jalr	1740(ra) # a2c <printf>
  wait(&status);
 368:	fac40513          	addi	a0,s0,-84
 36c:	00000097          	auipc	ra,0x0
 370:	362080e7          	jalr	866(ra) # 6ce <wait>
  if (status == 0) {
 374:	fac42783          	lw	a5,-84(s0)
 378:	cbad                	beqz	a5,3ea <test2+0x112>
}
 37a:	60e6                	ld	ra,88(sp)
 37c:	6446                	ld	s0,80(sp)
 37e:	6125                	addi	sp,sp,96
 380:	8082                	ret
      if(count > 0)
 382:	000aa783          	lw	a5,0(s5)
 386:	2781                	sext.w	a5,a5
 388:	02f04863          	bgtz	a5,3b8 <test2+0xe0>
    for(i = 0; i < 1000*500000; i++){
 38c:	2485                	addiw	s1,s1,1
 38e:	03448563          	beq	s1,s4,3b8 <test2+0xe0>
      if((i % 1000000) == 0)
 392:	033487b3          	mul	a5,s1,s3
 396:	97c9                	srai	a5,a5,0x32
 398:	41f4d71b          	sraiw	a4,s1,0x1f
 39c:	9f99                	subw	a5,a5,a4
 39e:	02f907bb          	mulw	a5,s2,a5
 3a2:	40f487bb          	subw	a5,s1,a5
 3a6:	fff1                	bnez	a5,382 <test2+0xaa>
        write(2, ".", 1);
 3a8:	8662                	mv	a2,s8
 3aa:	85de                	mv	a1,s7
 3ac:	855a                	mv	a0,s6
 3ae:	00000097          	auipc	ra,0x0
 3b2:	338080e7          	jalr	824(ra) # 6e6 <write>
 3b6:	b7f1                	j	382 <test2+0xaa>
    if (count == 0) {
 3b8:	00001797          	auipc	a5,0x1
 3bc:	a407a783          	lw	a5,-1472(a5) # df8 <count>
 3c0:	ef91                	bnez	a5,3dc <test2+0x104>
      printf("\ntest2 failed: alarm not called\n");
 3c2:	00001517          	auipc	a0,0x1
 3c6:	98650513          	addi	a0,a0,-1658 # d48 <malloc+0x260>
 3ca:	00000097          	auipc	ra,0x0
 3ce:	662080e7          	jalr	1634(ra) # a2c <printf>
      exit(1);
 3d2:	4505                	li	a0,1
 3d4:	00000097          	auipc	ra,0x0
 3d8:	2f2080e7          	jalr	754(ra) # 6c6 <exit>
    exit(0);
 3dc:	4501                	li	a0,0
 3de:	00000097          	auipc	ra,0x0
 3e2:	2e8080e7          	jalr	744(ra) # 6c6 <exit>
 3e6:	64a6                	ld	s1,72(sp)
 3e8:	b741                	j	368 <test2+0x90>
    printf("test2 passed\n");
 3ea:	00001517          	auipc	a0,0x1
 3ee:	98650513          	addi	a0,a0,-1658 # d70 <malloc+0x288>
 3f2:	00000097          	auipc	ra,0x0
 3f6:	63a080e7          	jalr	1594(ra) # a2c <printf>
}
 3fa:	b741                	j	37a <test2+0xa2>

00000000000003fc <main>:
{
 3fc:	1141                	addi	sp,sp,-16
 3fe:	e406                	sd	ra,8(sp)
 400:	e022                	sd	s0,0(sp)
 402:	0800                	addi	s0,sp,16
  test0();
 404:	00000097          	auipc	ra,0x0
 408:	cb4080e7          	jalr	-844(ra) # b8 <test0>
  test1();
 40c:	00000097          	auipc	ra,0x0
 410:	dfc080e7          	jalr	-516(ra) # 208 <test1>
  test2();
 414:	00000097          	auipc	ra,0x0
 418:	ec4080e7          	jalr	-316(ra) # 2d8 <test2>
  exit(0);
 41c:	4501                	li	a0,0
 41e:	00000097          	auipc	ra,0x0
 422:	2a8080e7          	jalr	680(ra) # 6c6 <exit>

0000000000000426 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 426:	1141                	addi	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 42e:	87aa                	mv	a5,a0
 430:	0585                	addi	a1,a1,1
 432:	0785                	addi	a5,a5,1
 434:	fff5c703          	lbu	a4,-1(a1)
 438:	fee78fa3          	sb	a4,-1(a5)
 43c:	fb75                	bnez	a4,430 <strcpy+0xa>
    ;
  return os;
}
 43e:	60a2                	ld	ra,8(sp)
 440:	6402                	ld	s0,0(sp)
 442:	0141                	addi	sp,sp,16
 444:	8082                	ret

0000000000000446 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 446:	1141                	addi	sp,sp,-16
 448:	e406                	sd	ra,8(sp)
 44a:	e022                	sd	s0,0(sp)
 44c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 44e:	00054783          	lbu	a5,0(a0)
 452:	cb91                	beqz	a5,466 <strcmp+0x20>
 454:	0005c703          	lbu	a4,0(a1)
 458:	00f71763          	bne	a4,a5,466 <strcmp+0x20>
    p++, q++;
 45c:	0505                	addi	a0,a0,1
 45e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 460:	00054783          	lbu	a5,0(a0)
 464:	fbe5                	bnez	a5,454 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 466:	0005c503          	lbu	a0,0(a1)
}
 46a:	40a7853b          	subw	a0,a5,a0
 46e:	60a2                	ld	ra,8(sp)
 470:	6402                	ld	s0,0(sp)
 472:	0141                	addi	sp,sp,16
 474:	8082                	ret

0000000000000476 <strlen>:

uint
strlen(const char *s)
{
 476:	1141                	addi	sp,sp,-16
 478:	e406                	sd	ra,8(sp)
 47a:	e022                	sd	s0,0(sp)
 47c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 47e:	00054783          	lbu	a5,0(a0)
 482:	cf99                	beqz	a5,4a0 <strlen+0x2a>
 484:	0505                	addi	a0,a0,1
 486:	87aa                	mv	a5,a0
 488:	86be                	mv	a3,a5
 48a:	0785                	addi	a5,a5,1
 48c:	fff7c703          	lbu	a4,-1(a5)
 490:	ff65                	bnez	a4,488 <strlen+0x12>
 492:	40a6853b          	subw	a0,a3,a0
 496:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 498:	60a2                	ld	ra,8(sp)
 49a:	6402                	ld	s0,0(sp)
 49c:	0141                	addi	sp,sp,16
 49e:	8082                	ret
  for(n = 0; s[n]; n++)
 4a0:	4501                	li	a0,0
 4a2:	bfdd                	j	498 <strlen+0x22>

00000000000004a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4a4:	1141                	addi	sp,sp,-16
 4a6:	e406                	sd	ra,8(sp)
 4a8:	e022                	sd	s0,0(sp)
 4aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4ac:	ca19                	beqz	a2,4c2 <memset+0x1e>
 4ae:	87aa                	mv	a5,a0
 4b0:	1602                	slli	a2,a2,0x20
 4b2:	9201                	srli	a2,a2,0x20
 4b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4bc:	0785                	addi	a5,a5,1
 4be:	fee79de3          	bne	a5,a4,4b8 <memset+0x14>
  }
  return dst;
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <strchr>:

char*
strchr(const char *s, char c)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e406                	sd	ra,8(sp)
 4ce:	e022                	sd	s0,0(sp)
 4d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 4d2:	00054783          	lbu	a5,0(a0)
 4d6:	cf81                	beqz	a5,4ee <strchr+0x24>
    if(*s == c)
 4d8:	00f58763          	beq	a1,a5,4e6 <strchr+0x1c>
  for(; *s; s++)
 4dc:	0505                	addi	a0,a0,1
 4de:	00054783          	lbu	a5,0(a0)
 4e2:	fbfd                	bnez	a5,4d8 <strchr+0xe>
      return (char*)s;
  return 0;
 4e4:	4501                	li	a0,0
}
 4e6:	60a2                	ld	ra,8(sp)
 4e8:	6402                	ld	s0,0(sp)
 4ea:	0141                	addi	sp,sp,16
 4ec:	8082                	ret
  return 0;
 4ee:	4501                	li	a0,0
 4f0:	bfdd                	j	4e6 <strchr+0x1c>

00000000000004f2 <gets>:

char*
gets(char *buf, int max)
{
 4f2:	7159                	addi	sp,sp,-112
 4f4:	f486                	sd	ra,104(sp)
 4f6:	f0a2                	sd	s0,96(sp)
 4f8:	eca6                	sd	s1,88(sp)
 4fa:	e8ca                	sd	s2,80(sp)
 4fc:	e4ce                	sd	s3,72(sp)
 4fe:	e0d2                	sd	s4,64(sp)
 500:	fc56                	sd	s5,56(sp)
 502:	f85a                	sd	s6,48(sp)
 504:	f45e                	sd	s7,40(sp)
 506:	f062                	sd	s8,32(sp)
 508:	ec66                	sd	s9,24(sp)
 50a:	e86a                	sd	s10,16(sp)
 50c:	1880                	addi	s0,sp,112
 50e:	8caa                	mv	s9,a0
 510:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 512:	892a                	mv	s2,a0
 514:	4481                	li	s1,0
    cc = read(0, &c, 1);
 516:	f9f40b13          	addi	s6,s0,-97
 51a:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 51c:	4ba9                	li	s7,10
 51e:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 520:	8d26                	mv	s10,s1
 522:	0014899b          	addiw	s3,s1,1
 526:	84ce                	mv	s1,s3
 528:	0349d763          	bge	s3,s4,556 <gets+0x64>
    cc = read(0, &c, 1);
 52c:	8656                	mv	a2,s5
 52e:	85da                	mv	a1,s6
 530:	4501                	li	a0,0
 532:	00000097          	auipc	ra,0x0
 536:	1ac080e7          	jalr	428(ra) # 6de <read>
    if(cc < 1)
 53a:	00a05e63          	blez	a0,556 <gets+0x64>
    buf[i++] = c;
 53e:	f9f44783          	lbu	a5,-97(s0)
 542:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 546:	01778763          	beq	a5,s7,554 <gets+0x62>
 54a:	0905                	addi	s2,s2,1
 54c:	fd879ae3          	bne	a5,s8,520 <gets+0x2e>
    buf[i++] = c;
 550:	8d4e                	mv	s10,s3
 552:	a011                	j	556 <gets+0x64>
 554:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 556:	9d66                	add	s10,s10,s9
 558:	000d0023          	sb	zero,0(s10)
  return buf;
}
 55c:	8566                	mv	a0,s9
 55e:	70a6                	ld	ra,104(sp)
 560:	7406                	ld	s0,96(sp)
 562:	64e6                	ld	s1,88(sp)
 564:	6946                	ld	s2,80(sp)
 566:	69a6                	ld	s3,72(sp)
 568:	6a06                	ld	s4,64(sp)
 56a:	7ae2                	ld	s5,56(sp)
 56c:	7b42                	ld	s6,48(sp)
 56e:	7ba2                	ld	s7,40(sp)
 570:	7c02                	ld	s8,32(sp)
 572:	6ce2                	ld	s9,24(sp)
 574:	6d42                	ld	s10,16(sp)
 576:	6165                	addi	sp,sp,112
 578:	8082                	ret

000000000000057a <stat>:

int
stat(const char *n, struct stat *st)
{
 57a:	1101                	addi	sp,sp,-32
 57c:	ec06                	sd	ra,24(sp)
 57e:	e822                	sd	s0,16(sp)
 580:	e04a                	sd	s2,0(sp)
 582:	1000                	addi	s0,sp,32
 584:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 586:	4581                	li	a1,0
 588:	00000097          	auipc	ra,0x0
 58c:	17e080e7          	jalr	382(ra) # 706 <open>
  if(fd < 0)
 590:	02054663          	bltz	a0,5bc <stat+0x42>
 594:	e426                	sd	s1,8(sp)
 596:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 598:	85ca                	mv	a1,s2
 59a:	00000097          	auipc	ra,0x0
 59e:	184080e7          	jalr	388(ra) # 71e <fstat>
 5a2:	892a                	mv	s2,a0
  close(fd);
 5a4:	8526                	mv	a0,s1
 5a6:	00000097          	auipc	ra,0x0
 5aa:	148080e7          	jalr	328(ra) # 6ee <close>
  return r;
 5ae:	64a2                	ld	s1,8(sp)
}
 5b0:	854a                	mv	a0,s2
 5b2:	60e2                	ld	ra,24(sp)
 5b4:	6442                	ld	s0,16(sp)
 5b6:	6902                	ld	s2,0(sp)
 5b8:	6105                	addi	sp,sp,32
 5ba:	8082                	ret
    return -1;
 5bc:	597d                	li	s2,-1
 5be:	bfcd                	j	5b0 <stat+0x36>

00000000000005c0 <atoi>:

int
atoi(const char *s)
{
 5c0:	1141                	addi	sp,sp,-16
 5c2:	e406                	sd	ra,8(sp)
 5c4:	e022                	sd	s0,0(sp)
 5c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5c8:	00054683          	lbu	a3,0(a0)
 5cc:	fd06879b          	addiw	a5,a3,-48
 5d0:	0ff7f793          	zext.b	a5,a5
 5d4:	4625                	li	a2,9
 5d6:	02f66963          	bltu	a2,a5,608 <atoi+0x48>
 5da:	872a                	mv	a4,a0
  n = 0;
 5dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5de:	0705                	addi	a4,a4,1
 5e0:	0025179b          	slliw	a5,a0,0x2
 5e4:	9fa9                	addw	a5,a5,a0
 5e6:	0017979b          	slliw	a5,a5,0x1
 5ea:	9fb5                	addw	a5,a5,a3
 5ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 5f0:	00074683          	lbu	a3,0(a4)
 5f4:	fd06879b          	addiw	a5,a3,-48
 5f8:	0ff7f793          	zext.b	a5,a5
 5fc:	fef671e3          	bgeu	a2,a5,5de <atoi+0x1e>
  return n;
}
 600:	60a2                	ld	ra,8(sp)
 602:	6402                	ld	s0,0(sp)
 604:	0141                	addi	sp,sp,16
 606:	8082                	ret
  n = 0;
 608:	4501                	li	a0,0
 60a:	bfdd                	j	600 <atoi+0x40>

000000000000060c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 60c:	1141                	addi	sp,sp,-16
 60e:	e406                	sd	ra,8(sp)
 610:	e022                	sd	s0,0(sp)
 612:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 614:	02b57563          	bgeu	a0,a1,63e <memmove+0x32>
    while(n-- > 0)
 618:	00c05f63          	blez	a2,636 <memmove+0x2a>
 61c:	1602                	slli	a2,a2,0x20
 61e:	9201                	srli	a2,a2,0x20
 620:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 624:	872a                	mv	a4,a0
      *dst++ = *src++;
 626:	0585                	addi	a1,a1,1
 628:	0705                	addi	a4,a4,1
 62a:	fff5c683          	lbu	a3,-1(a1)
 62e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 632:	fee79ae3          	bne	a5,a4,626 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 636:	60a2                	ld	ra,8(sp)
 638:	6402                	ld	s0,0(sp)
 63a:	0141                	addi	sp,sp,16
 63c:	8082                	ret
    dst += n;
 63e:	00c50733          	add	a4,a0,a2
    src += n;
 642:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 644:	fec059e3          	blez	a2,636 <memmove+0x2a>
 648:	fff6079b          	addiw	a5,a2,-1
 64c:	1782                	slli	a5,a5,0x20
 64e:	9381                	srli	a5,a5,0x20
 650:	fff7c793          	not	a5,a5
 654:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 656:	15fd                	addi	a1,a1,-1
 658:	177d                	addi	a4,a4,-1
 65a:	0005c683          	lbu	a3,0(a1)
 65e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 662:	fef71ae3          	bne	a4,a5,656 <memmove+0x4a>
 666:	bfc1                	j	636 <memmove+0x2a>

0000000000000668 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 668:	1141                	addi	sp,sp,-16
 66a:	e406                	sd	ra,8(sp)
 66c:	e022                	sd	s0,0(sp)
 66e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 670:	ca0d                	beqz	a2,6a2 <memcmp+0x3a>
 672:	fff6069b          	addiw	a3,a2,-1
 676:	1682                	slli	a3,a3,0x20
 678:	9281                	srli	a3,a3,0x20
 67a:	0685                	addi	a3,a3,1
 67c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 67e:	00054783          	lbu	a5,0(a0)
 682:	0005c703          	lbu	a4,0(a1)
 686:	00e79863          	bne	a5,a4,696 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 68a:	0505                	addi	a0,a0,1
    p2++;
 68c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 68e:	fed518e3          	bne	a0,a3,67e <memcmp+0x16>
  }
  return 0;
 692:	4501                	li	a0,0
 694:	a019                	j	69a <memcmp+0x32>
      return *p1 - *p2;
 696:	40e7853b          	subw	a0,a5,a4
}
 69a:	60a2                	ld	ra,8(sp)
 69c:	6402                	ld	s0,0(sp)
 69e:	0141                	addi	sp,sp,16
 6a0:	8082                	ret
  return 0;
 6a2:	4501                	li	a0,0
 6a4:	bfdd                	j	69a <memcmp+0x32>

00000000000006a6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6a6:	1141                	addi	sp,sp,-16
 6a8:	e406                	sd	ra,8(sp)
 6aa:	e022                	sd	s0,0(sp)
 6ac:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6ae:	00000097          	auipc	ra,0x0
 6b2:	f5e080e7          	jalr	-162(ra) # 60c <memmove>
}
 6b6:	60a2                	ld	ra,8(sp)
 6b8:	6402                	ld	s0,0(sp)
 6ba:	0141                	addi	sp,sp,16
 6bc:	8082                	ret

00000000000006be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6be:	4885                	li	a7,1
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6c6:	4889                	li	a7,2
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 6ce:	488d                	li	a7,3
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6d6:	4891                	li	a7,4
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <read>:
.global read
read:
 li a7, SYS_read
 6de:	4895                	li	a7,5
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <write>:
.global write
write:
 li a7, SYS_write
 6e6:	48c1                	li	a7,16
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <close>:
.global close
close:
 li a7, SYS_close
 6ee:	48d5                	li	a7,21
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 6f6:	4899                	li	a7,6
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 6fe:	489d                	li	a7,7
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <open>:
.global open
open:
 li a7, SYS_open
 706:	48bd                	li	a7,15
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 70e:	48c5                	li	a7,17
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 716:	48c9                	li	a7,18
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 71e:	48a1                	li	a7,8
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <link>:
.global link
link:
 li a7, SYS_link
 726:	48cd                	li	a7,19
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 72e:	48d1                	li	a7,20
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 736:	48a5                	li	a7,9
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <dup>:
.global dup
dup:
 li a7, SYS_dup
 73e:	48a9                	li	a7,10
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 746:	48ad                	li	a7,11
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 74e:	48b1                	li	a7,12
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 756:	48b5                	li	a7,13
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 75e:	48b9                	li	a7,14
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 766:	48d9                	li	a7,22
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 76e:	48dd                	li	a7,23
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 776:	1101                	addi	sp,sp,-32
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 782:	4605                	li	a2,1
 784:	fef40593          	addi	a1,s0,-17
 788:	00000097          	auipc	ra,0x0
 78c:	f5e080e7          	jalr	-162(ra) # 6e6 <write>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6105                	addi	sp,sp,32
 796:	8082                	ret

0000000000000798 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 798:	7139                	addi	sp,sp,-64
 79a:	fc06                	sd	ra,56(sp)
 79c:	f822                	sd	s0,48(sp)
 79e:	f426                	sd	s1,40(sp)
 7a0:	f04a                	sd	s2,32(sp)
 7a2:	ec4e                	sd	s3,24(sp)
 7a4:	0080                	addi	s0,sp,64
 7a6:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7a8:	c299                	beqz	a3,7ae <printint+0x16>
 7aa:	0805c063          	bltz	a1,82a <printint+0x92>
  neg = 0;
 7ae:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 7b0:	fc040313          	addi	t1,s0,-64
  neg = 0;
 7b4:	869a                	mv	a3,t1
  i = 0;
 7b6:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 7b8:	00000817          	auipc	a6,0x0
 7bc:	62880813          	addi	a6,a6,1576 # de0 <digits>
 7c0:	88be                	mv	a7,a5
 7c2:	0017851b          	addiw	a0,a5,1
 7c6:	87aa                	mv	a5,a0
 7c8:	02c5f73b          	remuw	a4,a1,a2
 7cc:	1702                	slli	a4,a4,0x20
 7ce:	9301                	srli	a4,a4,0x20
 7d0:	9742                	add	a4,a4,a6
 7d2:	00074703          	lbu	a4,0(a4)
 7d6:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 7da:	872e                	mv	a4,a1
 7dc:	02c5d5bb          	divuw	a1,a1,a2
 7e0:	0685                	addi	a3,a3,1
 7e2:	fcc77fe3          	bgeu	a4,a2,7c0 <printint+0x28>
  if(neg)
 7e6:	000e0c63          	beqz	t3,7fe <printint+0x66>
    buf[i++] = '-';
 7ea:	fd050793          	addi	a5,a0,-48
 7ee:	00878533          	add	a0,a5,s0
 7f2:	02d00793          	li	a5,45
 7f6:	fef50823          	sb	a5,-16(a0)
 7fa:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 7fe:	fff7899b          	addiw	s3,a5,-1
 802:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 806:	fff4c583          	lbu	a1,-1(s1)
 80a:	854a                	mv	a0,s2
 80c:	00000097          	auipc	ra,0x0
 810:	f6a080e7          	jalr	-150(ra) # 776 <putc>
  while(--i >= 0)
 814:	39fd                	addiw	s3,s3,-1
 816:	14fd                	addi	s1,s1,-1
 818:	fe09d7e3          	bgez	s3,806 <printint+0x6e>
}
 81c:	70e2                	ld	ra,56(sp)
 81e:	7442                	ld	s0,48(sp)
 820:	74a2                	ld	s1,40(sp)
 822:	7902                	ld	s2,32(sp)
 824:	69e2                	ld	s3,24(sp)
 826:	6121                	addi	sp,sp,64
 828:	8082                	ret
    x = -xx;
 82a:	40b005bb          	negw	a1,a1
    neg = 1;
 82e:	4e05                	li	t3,1
    x = -xx;
 830:	b741                	j	7b0 <printint+0x18>

0000000000000832 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 832:	715d                	addi	sp,sp,-80
 834:	e486                	sd	ra,72(sp)
 836:	e0a2                	sd	s0,64(sp)
 838:	f84a                	sd	s2,48(sp)
 83a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 83c:	0005c903          	lbu	s2,0(a1)
 840:	1a090a63          	beqz	s2,9f4 <vprintf+0x1c2>
 844:	fc26                	sd	s1,56(sp)
 846:	f44e                	sd	s3,40(sp)
 848:	f052                	sd	s4,32(sp)
 84a:	ec56                	sd	s5,24(sp)
 84c:	e85a                	sd	s6,16(sp)
 84e:	e45e                	sd	s7,8(sp)
 850:	8aaa                	mv	s5,a0
 852:	8bb2                	mv	s7,a2
 854:	00158493          	addi	s1,a1,1
  state = 0;
 858:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 85a:	02500a13          	li	s4,37
 85e:	4b55                	li	s6,21
 860:	a839                	j	87e <vprintf+0x4c>
        putc(fd, c);
 862:	85ca                	mv	a1,s2
 864:	8556                	mv	a0,s5
 866:	00000097          	auipc	ra,0x0
 86a:	f10080e7          	jalr	-240(ra) # 776 <putc>
 86e:	a019                	j	874 <vprintf+0x42>
    } else if(state == '%'){
 870:	01498d63          	beq	s3,s4,88a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 874:	0485                	addi	s1,s1,1
 876:	fff4c903          	lbu	s2,-1(s1)
 87a:	16090763          	beqz	s2,9e8 <vprintf+0x1b6>
    if(state == 0){
 87e:	fe0999e3          	bnez	s3,870 <vprintf+0x3e>
      if(c == '%'){
 882:	ff4910e3          	bne	s2,s4,862 <vprintf+0x30>
        state = '%';
 886:	89d2                	mv	s3,s4
 888:	b7f5                	j	874 <vprintf+0x42>
      if(c == 'd'){
 88a:	13490463          	beq	s2,s4,9b2 <vprintf+0x180>
 88e:	f9d9079b          	addiw	a5,s2,-99
 892:	0ff7f793          	zext.b	a5,a5
 896:	12fb6763          	bltu	s6,a5,9c4 <vprintf+0x192>
 89a:	f9d9079b          	addiw	a5,s2,-99
 89e:	0ff7f713          	zext.b	a4,a5
 8a2:	12eb6163          	bltu	s6,a4,9c4 <vprintf+0x192>
 8a6:	00271793          	slli	a5,a4,0x2
 8aa:	00000717          	auipc	a4,0x0
 8ae:	4de70713          	addi	a4,a4,1246 # d88 <malloc+0x2a0>
 8b2:	97ba                	add	a5,a5,a4
 8b4:	439c                	lw	a5,0(a5)
 8b6:	97ba                	add	a5,a5,a4
 8b8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8ba:	008b8913          	addi	s2,s7,8
 8be:	4685                	li	a3,1
 8c0:	4629                	li	a2,10
 8c2:	000ba583          	lw	a1,0(s7)
 8c6:	8556                	mv	a0,s5
 8c8:	00000097          	auipc	ra,0x0
 8cc:	ed0080e7          	jalr	-304(ra) # 798 <printint>
 8d0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	b745                	j	874 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8d6:	008b8913          	addi	s2,s7,8
 8da:	4681                	li	a3,0
 8dc:	4629                	li	a2,10
 8de:	000ba583          	lw	a1,0(s7)
 8e2:	8556                	mv	a0,s5
 8e4:	00000097          	auipc	ra,0x0
 8e8:	eb4080e7          	jalr	-332(ra) # 798 <printint>
 8ec:	8bca                	mv	s7,s2
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	b751                	j	874 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 8f2:	008b8913          	addi	s2,s7,8
 8f6:	4681                	li	a3,0
 8f8:	4641                	li	a2,16
 8fa:	000ba583          	lw	a1,0(s7)
 8fe:	8556                	mv	a0,s5
 900:	00000097          	auipc	ra,0x0
 904:	e98080e7          	jalr	-360(ra) # 798 <printint>
 908:	8bca                	mv	s7,s2
      state = 0;
 90a:	4981                	li	s3,0
 90c:	b7a5                	j	874 <vprintf+0x42>
 90e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 910:	008b8c13          	addi	s8,s7,8
 914:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 918:	03000593          	li	a1,48
 91c:	8556                	mv	a0,s5
 91e:	00000097          	auipc	ra,0x0
 922:	e58080e7          	jalr	-424(ra) # 776 <putc>
  putc(fd, 'x');
 926:	07800593          	li	a1,120
 92a:	8556                	mv	a0,s5
 92c:	00000097          	auipc	ra,0x0
 930:	e4a080e7          	jalr	-438(ra) # 776 <putc>
 934:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 936:	00000b97          	auipc	s7,0x0
 93a:	4aab8b93          	addi	s7,s7,1194 # de0 <digits>
 93e:	03c9d793          	srli	a5,s3,0x3c
 942:	97de                	add	a5,a5,s7
 944:	0007c583          	lbu	a1,0(a5)
 948:	8556                	mv	a0,s5
 94a:	00000097          	auipc	ra,0x0
 94e:	e2c080e7          	jalr	-468(ra) # 776 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 952:	0992                	slli	s3,s3,0x4
 954:	397d                	addiw	s2,s2,-1
 956:	fe0914e3          	bnez	s2,93e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 95a:	8be2                	mv	s7,s8
      state = 0;
 95c:	4981                	li	s3,0
 95e:	6c02                	ld	s8,0(sp)
 960:	bf11                	j	874 <vprintf+0x42>
        s = va_arg(ap, char*);
 962:	008b8993          	addi	s3,s7,8
 966:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 96a:	02090163          	beqz	s2,98c <vprintf+0x15a>
        while(*s != 0){
 96e:	00094583          	lbu	a1,0(s2)
 972:	c9a5                	beqz	a1,9e2 <vprintf+0x1b0>
          putc(fd, *s);
 974:	8556                	mv	a0,s5
 976:	00000097          	auipc	ra,0x0
 97a:	e00080e7          	jalr	-512(ra) # 776 <putc>
          s++;
 97e:	0905                	addi	s2,s2,1
        while(*s != 0){
 980:	00094583          	lbu	a1,0(s2)
 984:	f9e5                	bnez	a1,974 <vprintf+0x142>
        s = va_arg(ap, char*);
 986:	8bce                	mv	s7,s3
      state = 0;
 988:	4981                	li	s3,0
 98a:	b5ed                	j	874 <vprintf+0x42>
          s = "(null)";
 98c:	00000917          	auipc	s2,0x0
 990:	3f490913          	addi	s2,s2,1012 # d80 <malloc+0x298>
        while(*s != 0){
 994:	02800593          	li	a1,40
 998:	bff1                	j	974 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 99a:	008b8913          	addi	s2,s7,8
 99e:	000bc583          	lbu	a1,0(s7)
 9a2:	8556                	mv	a0,s5
 9a4:	00000097          	auipc	ra,0x0
 9a8:	dd2080e7          	jalr	-558(ra) # 776 <putc>
 9ac:	8bca                	mv	s7,s2
      state = 0;
 9ae:	4981                	li	s3,0
 9b0:	b5d1                	j	874 <vprintf+0x42>
        putc(fd, c);
 9b2:	02500593          	li	a1,37
 9b6:	8556                	mv	a0,s5
 9b8:	00000097          	auipc	ra,0x0
 9bc:	dbe080e7          	jalr	-578(ra) # 776 <putc>
      state = 0;
 9c0:	4981                	li	s3,0
 9c2:	bd4d                	j	874 <vprintf+0x42>
        putc(fd, '%');
 9c4:	02500593          	li	a1,37
 9c8:	8556                	mv	a0,s5
 9ca:	00000097          	auipc	ra,0x0
 9ce:	dac080e7          	jalr	-596(ra) # 776 <putc>
        putc(fd, c);
 9d2:	85ca                	mv	a1,s2
 9d4:	8556                	mv	a0,s5
 9d6:	00000097          	auipc	ra,0x0
 9da:	da0080e7          	jalr	-608(ra) # 776 <putc>
      state = 0;
 9de:	4981                	li	s3,0
 9e0:	bd51                	j	874 <vprintf+0x42>
        s = va_arg(ap, char*);
 9e2:	8bce                	mv	s7,s3
      state = 0;
 9e4:	4981                	li	s3,0
 9e6:	b579                	j	874 <vprintf+0x42>
 9e8:	74e2                	ld	s1,56(sp)
 9ea:	79a2                	ld	s3,40(sp)
 9ec:	7a02                	ld	s4,32(sp)
 9ee:	6ae2                	ld	s5,24(sp)
 9f0:	6b42                	ld	s6,16(sp)
 9f2:	6ba2                	ld	s7,8(sp)
    }
  }
}
 9f4:	60a6                	ld	ra,72(sp)
 9f6:	6406                	ld	s0,64(sp)
 9f8:	7942                	ld	s2,48(sp)
 9fa:	6161                	addi	sp,sp,80
 9fc:	8082                	ret

00000000000009fe <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9fe:	715d                	addi	sp,sp,-80
 a00:	ec06                	sd	ra,24(sp)
 a02:	e822                	sd	s0,16(sp)
 a04:	1000                	addi	s0,sp,32
 a06:	e010                	sd	a2,0(s0)
 a08:	e414                	sd	a3,8(s0)
 a0a:	e818                	sd	a4,16(s0)
 a0c:	ec1c                	sd	a5,24(s0)
 a0e:	03043023          	sd	a6,32(s0)
 a12:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a16:	8622                	mv	a2,s0
 a18:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a1c:	00000097          	auipc	ra,0x0
 a20:	e16080e7          	jalr	-490(ra) # 832 <vprintf>
}
 a24:	60e2                	ld	ra,24(sp)
 a26:	6442                	ld	s0,16(sp)
 a28:	6161                	addi	sp,sp,80
 a2a:	8082                	ret

0000000000000a2c <printf>:

void
printf(const char *fmt, ...)
{
 a2c:	711d                	addi	sp,sp,-96
 a2e:	ec06                	sd	ra,24(sp)
 a30:	e822                	sd	s0,16(sp)
 a32:	1000                	addi	s0,sp,32
 a34:	e40c                	sd	a1,8(s0)
 a36:	e810                	sd	a2,16(s0)
 a38:	ec14                	sd	a3,24(s0)
 a3a:	f018                	sd	a4,32(s0)
 a3c:	f41c                	sd	a5,40(s0)
 a3e:	03043823          	sd	a6,48(s0)
 a42:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a46:	00840613          	addi	a2,s0,8
 a4a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a4e:	85aa                	mv	a1,a0
 a50:	4505                	li	a0,1
 a52:	00000097          	auipc	ra,0x0
 a56:	de0080e7          	jalr	-544(ra) # 832 <vprintf>
}
 a5a:	60e2                	ld	ra,24(sp)
 a5c:	6442                	ld	s0,16(sp)
 a5e:	6125                	addi	sp,sp,96
 a60:	8082                	ret

0000000000000a62 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a62:	1141                	addi	sp,sp,-16
 a64:	e406                	sd	ra,8(sp)
 a66:	e022                	sd	s0,0(sp)
 a68:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a6a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a6e:	00000797          	auipc	a5,0x0
 a72:	3927b783          	ld	a5,914(a5) # e00 <freep>
 a76:	a02d                	j	aa0 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a78:	4618                	lw	a4,8(a2)
 a7a:	9f2d                	addw	a4,a4,a1
 a7c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a80:	6398                	ld	a4,0(a5)
 a82:	6310                	ld	a2,0(a4)
 a84:	a83d                	j	ac2 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a86:	ff852703          	lw	a4,-8(a0)
 a8a:	9f31                	addw	a4,a4,a2
 a8c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a8e:	ff053683          	ld	a3,-16(a0)
 a92:	a091                	j	ad6 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a94:	6398                	ld	a4,0(a5)
 a96:	00e7e463          	bltu	a5,a4,a9e <free+0x3c>
 a9a:	00e6ea63          	bltu	a3,a4,aae <free+0x4c>
{
 a9e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa0:	fed7fae3          	bgeu	a5,a3,a94 <free+0x32>
 aa4:	6398                	ld	a4,0(a5)
 aa6:	00e6e463          	bltu	a3,a4,aae <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aaa:	fee7eae3          	bltu	a5,a4,a9e <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 aae:	ff852583          	lw	a1,-8(a0)
 ab2:	6390                	ld	a2,0(a5)
 ab4:	02059813          	slli	a6,a1,0x20
 ab8:	01c85713          	srli	a4,a6,0x1c
 abc:	9736                	add	a4,a4,a3
 abe:	fae60de3          	beq	a2,a4,a78 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 ac2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ac6:	4790                	lw	a2,8(a5)
 ac8:	02061593          	slli	a1,a2,0x20
 acc:	01c5d713          	srli	a4,a1,0x1c
 ad0:	973e                	add	a4,a4,a5
 ad2:	fae68ae3          	beq	a3,a4,a86 <free+0x24>
    p->s.ptr = bp->s.ptr;
 ad6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ad8:	00000717          	auipc	a4,0x0
 adc:	32f73423          	sd	a5,808(a4) # e00 <freep>
}
 ae0:	60a2                	ld	ra,8(sp)
 ae2:	6402                	ld	s0,0(sp)
 ae4:	0141                	addi	sp,sp,16
 ae6:	8082                	ret

0000000000000ae8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 ae8:	7139                	addi	sp,sp,-64
 aea:	fc06                	sd	ra,56(sp)
 aec:	f822                	sd	s0,48(sp)
 aee:	f04a                	sd	s2,32(sp)
 af0:	ec4e                	sd	s3,24(sp)
 af2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 af4:	02051993          	slli	s3,a0,0x20
 af8:	0209d993          	srli	s3,s3,0x20
 afc:	09bd                	addi	s3,s3,15
 afe:	0049d993          	srli	s3,s3,0x4
 b02:	2985                	addiw	s3,s3,1
 b04:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 b06:	00000517          	auipc	a0,0x0
 b0a:	2fa53503          	ld	a0,762(a0) # e00 <freep>
 b0e:	c905                	beqz	a0,b3e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b10:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b12:	4798                	lw	a4,8(a5)
 b14:	09377a63          	bgeu	a4,s3,ba8 <malloc+0xc0>
 b18:	f426                	sd	s1,40(sp)
 b1a:	e852                	sd	s4,16(sp)
 b1c:	e456                	sd	s5,8(sp)
 b1e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b20:	8a4e                	mv	s4,s3
 b22:	6705                	lui	a4,0x1
 b24:	00e9f363          	bgeu	s3,a4,b2a <malloc+0x42>
 b28:	6a05                	lui	s4,0x1
 b2a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b2e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b32:	00000497          	auipc	s1,0x0
 b36:	2ce48493          	addi	s1,s1,718 # e00 <freep>
  if(p == (char*)-1)
 b3a:	5afd                	li	s5,-1
 b3c:	a089                	j	b7e <malloc+0x96>
 b3e:	f426                	sd	s1,40(sp)
 b40:	e852                	sd	s4,16(sp)
 b42:	e456                	sd	s5,8(sp)
 b44:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b46:	00000797          	auipc	a5,0x0
 b4a:	2c278793          	addi	a5,a5,706 # e08 <base>
 b4e:	00000717          	auipc	a4,0x0
 b52:	2af73923          	sd	a5,690(a4) # e00 <freep>
 b56:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b58:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b5c:	b7d1                	j	b20 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b5e:	6398                	ld	a4,0(a5)
 b60:	e118                	sd	a4,0(a0)
 b62:	a8b9                	j	bc0 <malloc+0xd8>
  hp->s.size = nu;
 b64:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b68:	0541                	addi	a0,a0,16
 b6a:	00000097          	auipc	ra,0x0
 b6e:	ef8080e7          	jalr	-264(ra) # a62 <free>
  return freep;
 b72:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 b74:	c135                	beqz	a0,bd8 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b76:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b78:	4798                	lw	a4,8(a5)
 b7a:	03277363          	bgeu	a4,s2,ba0 <malloc+0xb8>
    if(p == freep)
 b7e:	6098                	ld	a4,0(s1)
 b80:	853e                	mv	a0,a5
 b82:	fef71ae3          	bne	a4,a5,b76 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b86:	8552                	mv	a0,s4
 b88:	00000097          	auipc	ra,0x0
 b8c:	bc6080e7          	jalr	-1082(ra) # 74e <sbrk>
  if(p == (char*)-1)
 b90:	fd551ae3          	bne	a0,s5,b64 <malloc+0x7c>
        return 0;
 b94:	4501                	li	a0,0
 b96:	74a2                	ld	s1,40(sp)
 b98:	6a42                	ld	s4,16(sp)
 b9a:	6aa2                	ld	s5,8(sp)
 b9c:	6b02                	ld	s6,0(sp)
 b9e:	a03d                	j	bcc <malloc+0xe4>
 ba0:	74a2                	ld	s1,40(sp)
 ba2:	6a42                	ld	s4,16(sp)
 ba4:	6aa2                	ld	s5,8(sp)
 ba6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ba8:	fae90be3          	beq	s2,a4,b5e <malloc+0x76>
        p->s.size -= nunits;
 bac:	4137073b          	subw	a4,a4,s3
 bb0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bb2:	02071693          	slli	a3,a4,0x20
 bb6:	01c6d713          	srli	a4,a3,0x1c
 bba:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bbc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bc0:	00000717          	auipc	a4,0x0
 bc4:	24a73023          	sd	a0,576(a4) # e00 <freep>
      return (void*)(p + 1);
 bc8:	01078513          	addi	a0,a5,16
  }
}
 bcc:	70e2                	ld	ra,56(sp)
 bce:	7442                	ld	s0,48(sp)
 bd0:	7902                	ld	s2,32(sp)
 bd2:	69e2                	ld	s3,24(sp)
 bd4:	6121                	addi	sp,sp,64
 bd6:	8082                	ret
 bd8:	74a2                	ld	s1,40(sp)
 bda:	6a42                	ld	s4,16(sp)
 bdc:	6aa2                	ld	s5,8(sp)
 bde:	6b02                	ld	s6,0(sp)
 be0:	b7f5                	j	bcc <malloc+0xe4>
