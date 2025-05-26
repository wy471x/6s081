
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	c7a50513          	addi	a0,a0,-902 # c88 <malloc+0xfa>
  16:	00001097          	auipc	ra,0x1
  1a:	abc080e7          	jalr	-1348(ra) # ad2 <printf>
  
  char *p = sbrk(sz);
  1e:	05555537          	lui	a0,0x5555
  22:	55450513          	addi	a0,a0,1364 # 5555554 <__BSS_END__+0x5550704>
  26:	00000097          	auipc	ra,0x0
  2a:	7de080e7          	jalr	2014(ra) # 804 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  2e:	57fd                	li	a5,-1
  30:	06f50563          	beq	a0,a5,9a <simpletest+0x9a>
  34:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  36:	05556937          	lui	s2,0x5556
  3a:	992a                	add	s2,s2,a0
  3c:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  3e:	00000097          	auipc	ra,0x0
  42:	7be080e7          	jalr	1982(ra) # 7fc <getpid>
  46:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  48:	94ce                	add	s1,s1,s3
  4a:	fe991ae3          	bne	s2,s1,3e <simpletest+0x3e>
  }

  int pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	726080e7          	jalr	1830(ra) # 774 <fork>
  if(pid < 0){
  56:	06054363          	bltz	a0,bc <simpletest+0xbc>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  5a:	cd35                	beqz	a0,d6 <simpletest+0xd6>
    exit(0);

  wait(0);
  5c:	4501                	li	a0,0
  5e:	00000097          	auipc	ra,0x0
  62:	726080e7          	jalr	1830(ra) # 784 <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  66:	faaab537          	lui	a0,0xfaaab
  6a:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <__BSS_END__+0xfffffffffaaa5c5c>
  6e:	00000097          	auipc	ra,0x0
  72:	796080e7          	jalr	1942(ra) # 804 <sbrk>
  76:	57fd                	li	a5,-1
  78:	06f50363          	beq	a0,a5,de <simpletest+0xde>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  7c:	00001517          	auipc	a0,0x1
  80:	c5c50513          	addi	a0,a0,-932 # cd8 <malloc+0x14a>
  84:	00001097          	auipc	ra,0x1
  88:	a4e080e7          	jalr	-1458(ra) # ad2 <printf>
}
  8c:	70a2                	ld	ra,40(sp)
  8e:	7402                	ld	s0,32(sp)
  90:	64e2                	ld	s1,24(sp)
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	6145                	addi	sp,sp,48
  98:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  9a:	055555b7          	lui	a1,0x5555
  9e:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x5550704>
  a2:	00001517          	auipc	a0,0x1
  a6:	bf650513          	addi	a0,a0,-1034 # c98 <malloc+0x10a>
  aa:	00001097          	auipc	ra,0x1
  ae:	a28080e7          	jalr	-1496(ra) # ad2 <printf>
    exit(-1);
  b2:	557d                	li	a0,-1
  b4:	00000097          	auipc	ra,0x0
  b8:	6c8080e7          	jalr	1736(ra) # 77c <exit>
    printf("fork() failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	bf450513          	addi	a0,a0,-1036 # cb0 <malloc+0x122>
  c4:	00001097          	auipc	ra,0x1
  c8:	a0e080e7          	jalr	-1522(ra) # ad2 <printf>
    exit(-1);
  cc:	557d                	li	a0,-1
  ce:	00000097          	auipc	ra,0x0
  d2:	6ae080e7          	jalr	1710(ra) # 77c <exit>
    exit(0);
  d6:	00000097          	auipc	ra,0x0
  da:	6a6080e7          	jalr	1702(ra) # 77c <exit>
    printf("sbrk(-%d) failed\n", sz);
  de:	055555b7          	lui	a1,0x5555
  e2:	55458593          	addi	a1,a1,1364 # 5555554 <__BSS_END__+0x5550704>
  e6:	00001517          	auipc	a0,0x1
  ea:	bda50513          	addi	a0,a0,-1062 # cc0 <malloc+0x132>
  ee:	00001097          	auipc	ra,0x1
  f2:	9e4080e7          	jalr	-1564(ra) # ad2 <printf>
    exit(-1);
  f6:	557d                	li	a0,-1
  f8:	00000097          	auipc	ra,0x0
  fc:	684080e7          	jalr	1668(ra) # 77c <exit>

0000000000000100 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
 100:	7179                	addi	sp,sp,-48
 102:	f406                	sd	ra,40(sp)
 104:	f022                	sd	s0,32(sp)
 106:	ec26                	sd	s1,24(sp)
 108:	e84a                	sd	s2,16(sp)
 10a:	e44e                	sd	s3,8(sp)
 10c:	e052                	sd	s4,0(sp)
 10e:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
 110:	00001517          	auipc	a0,0x1
 114:	bd050513          	addi	a0,a0,-1072 # ce0 <malloc+0x152>
 118:	00001097          	auipc	ra,0x1
 11c:	9ba080e7          	jalr	-1606(ra) # ad2 <printf>
  
  char *p = sbrk(sz);
 120:	02000537          	lui	a0,0x2000
 124:	00000097          	auipc	ra,0x0
 128:	6e0080e7          	jalr	1760(ra) # 804 <sbrk>
  if(p == (char*)0xffffffffffffffffL){
 12c:	57fd                	li	a5,-1
 12e:	08f50763          	beq	a0,a5,1bc <threetest+0xbc>
 132:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
 134:	00000097          	auipc	ra,0x0
 138:	640080e7          	jalr	1600(ra) # 774 <fork>
  if(pid1 < 0){
 13c:	08054f63          	bltz	a0,1da <threetest+0xda>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
 140:	c955                	beqz	a0,1f4 <threetest+0xf4>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
 142:	020009b7          	lui	s3,0x2000
 146:	99a6                	add	s3,s3,s1
 148:	8926                	mv	s2,s1
 14a:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 14c:	00000097          	auipc	ra,0x0
 150:	6b0080e7          	jalr	1712(ra) # 7fc <getpid>
 154:	00a92023          	sw	a0,0(s2) # 5556000 <__BSS_END__+0x55511b0>
  for(char *q = p; q < p + sz; q += 4096){
 158:	9952                	add	s2,s2,s4
 15a:	ff3919e3          	bne	s2,s3,14c <threetest+0x4c>
  }

  wait(0);
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	624080e7          	jalr	1572(ra) # 784 <wait>

  sleep(1);
 168:	4505                	li	a0,1
 16a:	00000097          	auipc	ra,0x0
 16e:	6a2080e7          	jalr	1698(ra) # 80c <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 172:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 174:	0004a903          	lw	s2,0(s1)
 178:	00000097          	auipc	ra,0x0
 17c:	684080e7          	jalr	1668(ra) # 7fc <getpid>
 180:	10a91a63          	bne	s2,a0,294 <threetest+0x194>
  for(char *q = p; q < p + sz; q += 4096){
 184:	94d2                	add	s1,s1,s4
 186:	ff3497e3          	bne	s1,s3,174 <threetest+0x74>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 18a:	fe000537          	lui	a0,0xfe000
 18e:	00000097          	auipc	ra,0x0
 192:	676080e7          	jalr	1654(ra) # 804 <sbrk>
 196:	57fd                	li	a5,-1
 198:	10f50b63          	beq	a0,a5,2ae <threetest+0x1ae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 19c:	00001517          	auipc	a0,0x1
 1a0:	b3c50513          	addi	a0,a0,-1220 # cd8 <malloc+0x14a>
 1a4:	00001097          	auipc	ra,0x1
 1a8:	92e080e7          	jalr	-1746(ra) # ad2 <printf>
}
 1ac:	70a2                	ld	ra,40(sp)
 1ae:	7402                	ld	s0,32(sp)
 1b0:	64e2                	ld	s1,24(sp)
 1b2:	6942                	ld	s2,16(sp)
 1b4:	69a2                	ld	s3,8(sp)
 1b6:	6a02                	ld	s4,0(sp)
 1b8:	6145                	addi	sp,sp,48
 1ba:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 1bc:	020005b7          	lui	a1,0x2000
 1c0:	00001517          	auipc	a0,0x1
 1c4:	ad850513          	addi	a0,a0,-1320 # c98 <malloc+0x10a>
 1c8:	00001097          	auipc	ra,0x1
 1cc:	90a080e7          	jalr	-1782(ra) # ad2 <printf>
    exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	00000097          	auipc	ra,0x0
 1d6:	5aa080e7          	jalr	1450(ra) # 77c <exit>
    printf("fork failed\n");
 1da:	00001517          	auipc	a0,0x1
 1de:	b0e50513          	addi	a0,a0,-1266 # ce8 <malloc+0x15a>
 1e2:	00001097          	auipc	ra,0x1
 1e6:	8f0080e7          	jalr	-1808(ra) # ad2 <printf>
    exit(-1);
 1ea:	557d                	li	a0,-1
 1ec:	00000097          	auipc	ra,0x0
 1f0:	590080e7          	jalr	1424(ra) # 77c <exit>
    pid2 = fork();
 1f4:	00000097          	auipc	ra,0x0
 1f8:	580080e7          	jalr	1408(ra) # 774 <fork>
    if(pid2 < 0){
 1fc:	04054263          	bltz	a0,240 <threetest+0x140>
    if(pid2 == 0){
 200:	ed29                	bnez	a0,25a <threetest+0x15a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 202:	0199a9b7          	lui	s3,0x199a
 206:	99a6                	add	s3,s3,s1
 208:	8926                	mv	s2,s1
 20a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 20c:	00000097          	auipc	ra,0x0
 210:	5f0080e7          	jalr	1520(ra) # 7fc <getpid>
 214:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 218:	9952                	add	s2,s2,s4
 21a:	ff3919e3          	bne	s2,s3,20c <threetest+0x10c>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 21e:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 220:	0004a903          	lw	s2,0(s1)
 224:	00000097          	auipc	ra,0x0
 228:	5d8080e7          	jalr	1496(ra) # 7fc <getpid>
 22c:	04a91763          	bne	s2,a0,27a <threetest+0x17a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 230:	94d2                	add	s1,s1,s4
 232:	ff3497e3          	bne	s1,s3,220 <threetest+0x120>
      exit(-1);
 236:	557d                	li	a0,-1
 238:	00000097          	auipc	ra,0x0
 23c:	544080e7          	jalr	1348(ra) # 77c <exit>
      printf("fork failed");
 240:	00001517          	auipc	a0,0x1
 244:	ab850513          	addi	a0,a0,-1352 # cf8 <malloc+0x16a>
 248:	00001097          	auipc	ra,0x1
 24c:	88a080e7          	jalr	-1910(ra) # ad2 <printf>
      exit(-1);
 250:	557d                	li	a0,-1
 252:	00000097          	auipc	ra,0x0
 256:	52a080e7          	jalr	1322(ra) # 77c <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 25a:	01000737          	lui	a4,0x1000
 25e:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 260:	6789                	lui	a5,0x2
 262:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x8cf>
    for(char *q = p; q < p + (sz/2); q += 4096){
 266:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 268:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 26a:	94b6                	add	s1,s1,a3
 26c:	fee49ee3          	bne	s1,a4,268 <threetest+0x168>
    exit(0);
 270:	4501                	li	a0,0
 272:	00000097          	auipc	ra,0x0
 276:	50a080e7          	jalr	1290(ra) # 77c <exit>
          printf("wrong content\n");
 27a:	00001517          	auipc	a0,0x1
 27e:	a8e50513          	addi	a0,a0,-1394 # d08 <malloc+0x17a>
 282:	00001097          	auipc	ra,0x1
 286:	850080e7          	jalr	-1968(ra) # ad2 <printf>
          exit(-1);
 28a:	557d                	li	a0,-1
 28c:	00000097          	auipc	ra,0x0
 290:	4f0080e7          	jalr	1264(ra) # 77c <exit>
      printf("wrong content\n");
 294:	00001517          	auipc	a0,0x1
 298:	a7450513          	addi	a0,a0,-1420 # d08 <malloc+0x17a>
 29c:	00001097          	auipc	ra,0x1
 2a0:	836080e7          	jalr	-1994(ra) # ad2 <printf>
      exit(-1);
 2a4:	557d                	li	a0,-1
 2a6:	00000097          	auipc	ra,0x0
 2aa:	4d6080e7          	jalr	1238(ra) # 77c <exit>
    printf("sbrk(-%d) failed\n", sz);
 2ae:	020005b7          	lui	a1,0x2000
 2b2:	00001517          	auipc	a0,0x1
 2b6:	a0e50513          	addi	a0,a0,-1522 # cc0 <malloc+0x132>
 2ba:	00001097          	auipc	ra,0x1
 2be:	818080e7          	jalr	-2024(ra) # ad2 <printf>
    exit(-1);
 2c2:	557d                	li	a0,-1
 2c4:	00000097          	auipc	ra,0x0
 2c8:	4b8080e7          	jalr	1208(ra) # 77c <exit>

00000000000002cc <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 2cc:	7139                	addi	sp,sp,-64
 2ce:	fc06                	sd	ra,56(sp)
 2d0:	f822                	sd	s0,48(sp)
 2d2:	f426                	sd	s1,40(sp)
 2d4:	f04a                	sd	s2,32(sp)
 2d6:	ec4e                	sd	s3,24(sp)
 2d8:	e852                	sd	s4,16(sp)
 2da:	0080                	addi	s0,sp,64
  printf("file: ");
 2dc:	00001517          	auipc	a0,0x1
 2e0:	a3c50513          	addi	a0,a0,-1476 # d18 <malloc+0x18a>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	7ee080e7          	jalr	2030(ra) # ad2 <printf>
  
  buf[0] = 99;
 2ec:	06300793          	li	a5,99
 2f0:	00002717          	auipc	a4,0x2
 2f4:	b4f70823          	sb	a5,-1200(a4) # 1e40 <buf>

  for(int i = 0; i < 4; i++){
 2f8:	fc042423          	sw	zero,-56(s0)
    if(pipe(fds) != 0){
 2fc:	00001497          	auipc	s1,0x1
 300:	b3448493          	addi	s1,s1,-1228 # e30 <fds>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 304:	fc840a13          	addi	s4,s0,-56
 308:	4911                	li	s2,4
  for(int i = 0; i < 4; i++){
 30a:	498d                	li	s3,3
    if(pipe(fds) != 0){
 30c:	8526                	mv	a0,s1
 30e:	00000097          	auipc	ra,0x0
 312:	47e080e7          	jalr	1150(ra) # 78c <pipe>
 316:	e141                	bnez	a0,396 <filetest+0xca>
    int pid = fork();
 318:	00000097          	auipc	ra,0x0
 31c:	45c080e7          	jalr	1116(ra) # 774 <fork>
    if(pid < 0){
 320:	08054863          	bltz	a0,3b0 <filetest+0xe4>
    if(pid == 0){
 324:	c15d                	beqz	a0,3ca <filetest+0xfe>
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 326:	864a                	mv	a2,s2
 328:	85d2                	mv	a1,s4
 32a:	40c8                	lw	a0,4(s1)
 32c:	00000097          	auipc	ra,0x0
 330:	470080e7          	jalr	1136(ra) # 79c <write>
 334:	11251c63          	bne	a0,s2,44c <filetest+0x180>
  for(int i = 0; i < 4; i++){
 338:	fc842783          	lw	a5,-56(s0)
 33c:	2785                	addiw	a5,a5,1
 33e:	fcf42423          	sw	a5,-56(s0)
 342:	fcf9d5e3          	bge	s3,a5,30c <filetest+0x40>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 346:	fc042623          	sw	zero,-52(s0)
 34a:	4491                	li	s1,4
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
 34c:	fcc40913          	addi	s2,s0,-52
 350:	854a                	mv	a0,s2
 352:	00000097          	auipc	ra,0x0
 356:	432080e7          	jalr	1074(ra) # 784 <wait>
    if(xstatus != 0) {
 35a:	fcc42783          	lw	a5,-52(s0)
 35e:	10079463          	bnez	a5,466 <filetest+0x19a>
  for(int i = 0; i < 4; i++) {
 362:	34fd                	addiw	s1,s1,-1
 364:	f4f5                	bnez	s1,350 <filetest+0x84>
      exit(1);
    }
  }

  if(buf[0] != 99){
 366:	00002717          	auipc	a4,0x2
 36a:	ada74703          	lbu	a4,-1318(a4) # 1e40 <buf>
 36e:	06300793          	li	a5,99
 372:	0ef71f63          	bne	a4,a5,470 <filetest+0x1a4>
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 376:	00001517          	auipc	a0,0x1
 37a:	96250513          	addi	a0,a0,-1694 # cd8 <malloc+0x14a>
 37e:	00000097          	auipc	ra,0x0
 382:	754080e7          	jalr	1876(ra) # ad2 <printf>
}
 386:	70e2                	ld	ra,56(sp)
 388:	7442                	ld	s0,48(sp)
 38a:	74a2                	ld	s1,40(sp)
 38c:	7902                	ld	s2,32(sp)
 38e:	69e2                	ld	s3,24(sp)
 390:	6a42                	ld	s4,16(sp)
 392:	6121                	addi	sp,sp,64
 394:	8082                	ret
      printf("pipe() failed\n");
 396:	00001517          	auipc	a0,0x1
 39a:	98a50513          	addi	a0,a0,-1654 # d20 <malloc+0x192>
 39e:	00000097          	auipc	ra,0x0
 3a2:	734080e7          	jalr	1844(ra) # ad2 <printf>
      exit(-1);
 3a6:	557d                	li	a0,-1
 3a8:	00000097          	auipc	ra,0x0
 3ac:	3d4080e7          	jalr	980(ra) # 77c <exit>
      printf("fork failed\n");
 3b0:	00001517          	auipc	a0,0x1
 3b4:	93850513          	addi	a0,a0,-1736 # ce8 <malloc+0x15a>
 3b8:	00000097          	auipc	ra,0x0
 3bc:	71a080e7          	jalr	1818(ra) # ad2 <printf>
      exit(-1);
 3c0:	557d                	li	a0,-1
 3c2:	00000097          	auipc	ra,0x0
 3c6:	3ba080e7          	jalr	954(ra) # 77c <exit>
      sleep(1);
 3ca:	4505                	li	a0,1
 3cc:	00000097          	auipc	ra,0x0
 3d0:	440080e7          	jalr	1088(ra) # 80c <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 3d4:	4611                	li	a2,4
 3d6:	00002597          	auipc	a1,0x2
 3da:	a6a58593          	addi	a1,a1,-1430 # 1e40 <buf>
 3de:	00001517          	auipc	a0,0x1
 3e2:	a5252503          	lw	a0,-1454(a0) # e30 <fds>
 3e6:	00000097          	auipc	ra,0x0
 3ea:	3ae080e7          	jalr	942(ra) # 794 <read>
 3ee:	4791                	li	a5,4
 3f0:	02f51c63          	bne	a0,a5,428 <filetest+0x15c>
      sleep(1);
 3f4:	4505                	li	a0,1
 3f6:	00000097          	auipc	ra,0x0
 3fa:	416080e7          	jalr	1046(ra) # 80c <sleep>
      if(j != i){
 3fe:	fc842703          	lw	a4,-56(s0)
 402:	00002797          	auipc	a5,0x2
 406:	a3e7a783          	lw	a5,-1474(a5) # 1e40 <buf>
 40a:	02f70c63          	beq	a4,a5,442 <filetest+0x176>
        printf("error: read the wrong value\n");
 40e:	00001517          	auipc	a0,0x1
 412:	93a50513          	addi	a0,a0,-1734 # d48 <malloc+0x1ba>
 416:	00000097          	auipc	ra,0x0
 41a:	6bc080e7          	jalr	1724(ra) # ad2 <printf>
        exit(1);
 41e:	4505                	li	a0,1
 420:	00000097          	auipc	ra,0x0
 424:	35c080e7          	jalr	860(ra) # 77c <exit>
        printf("error: read failed\n");
 428:	00001517          	auipc	a0,0x1
 42c:	90850513          	addi	a0,a0,-1784 # d30 <malloc+0x1a2>
 430:	00000097          	auipc	ra,0x0
 434:	6a2080e7          	jalr	1698(ra) # ad2 <printf>
        exit(1);
 438:	4505                	li	a0,1
 43a:	00000097          	auipc	ra,0x0
 43e:	342080e7          	jalr	834(ra) # 77c <exit>
      exit(0);
 442:	4501                	li	a0,0
 444:	00000097          	auipc	ra,0x0
 448:	338080e7          	jalr	824(ra) # 77c <exit>
      printf("error: write failed\n");
 44c:	00001517          	auipc	a0,0x1
 450:	91c50513          	addi	a0,a0,-1764 # d68 <malloc+0x1da>
 454:	00000097          	auipc	ra,0x0
 458:	67e080e7          	jalr	1662(ra) # ad2 <printf>
      exit(-1);
 45c:	557d                	li	a0,-1
 45e:	00000097          	auipc	ra,0x0
 462:	31e080e7          	jalr	798(ra) # 77c <exit>
      exit(1);
 466:	4505                	li	a0,1
 468:	00000097          	auipc	ra,0x0
 46c:	314080e7          	jalr	788(ra) # 77c <exit>
    printf("error: child overwrote parent\n");
 470:	00001517          	auipc	a0,0x1
 474:	91050513          	addi	a0,a0,-1776 # d80 <malloc+0x1f2>
 478:	00000097          	auipc	ra,0x0
 47c:	65a080e7          	jalr	1626(ra) # ad2 <printf>
    exit(1);
 480:	4505                	li	a0,1
 482:	00000097          	auipc	ra,0x0
 486:	2fa080e7          	jalr	762(ra) # 77c <exit>

000000000000048a <main>:

int
main(int argc, char *argv[])
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e406                	sd	ra,8(sp)
 48e:	e022                	sd	s0,0(sp)
 490:	0800                	addi	s0,sp,16
  simpletest();
 492:	00000097          	auipc	ra,0x0
 496:	b6e080e7          	jalr	-1170(ra) # 0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 49a:	00000097          	auipc	ra,0x0
 49e:	b66080e7          	jalr	-1178(ra) # 0 <simpletest>

  threetest();
 4a2:	00000097          	auipc	ra,0x0
 4a6:	c5e080e7          	jalr	-930(ra) # 100 <threetest>
  threetest();
 4aa:	00000097          	auipc	ra,0x0
 4ae:	c56080e7          	jalr	-938(ra) # 100 <threetest>
  threetest();
 4b2:	00000097          	auipc	ra,0x0
 4b6:	c4e080e7          	jalr	-946(ra) # 100 <threetest>

  filetest();
 4ba:	00000097          	auipc	ra,0x0
 4be:	e12080e7          	jalr	-494(ra) # 2cc <filetest>

  printf("ALL COW TESTS PASSED\n");
 4c2:	00001517          	auipc	a0,0x1
 4c6:	8de50513          	addi	a0,a0,-1826 # da0 <malloc+0x212>
 4ca:	00000097          	auipc	ra,0x0
 4ce:	608080e7          	jalr	1544(ra) # ad2 <printf>

  exit(0);
 4d2:	4501                	li	a0,0
 4d4:	00000097          	auipc	ra,0x0
 4d8:	2a8080e7          	jalr	680(ra) # 77c <exit>

00000000000004dc <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 4dc:	1141                	addi	sp,sp,-16
 4de:	e406                	sd	ra,8(sp)
 4e0:	e022                	sd	s0,0(sp)
 4e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4e4:	87aa                	mv	a5,a0
 4e6:	0585                	addi	a1,a1,1
 4e8:	0785                	addi	a5,a5,1
 4ea:	fff5c703          	lbu	a4,-1(a1)
 4ee:	fee78fa3          	sb	a4,-1(a5)
 4f2:	fb75                	bnez	a4,4e6 <strcpy+0xa>
    ;
  return os;
}
 4f4:	60a2                	ld	ra,8(sp)
 4f6:	6402                	ld	s0,0(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret

00000000000004fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4fc:	1141                	addi	sp,sp,-16
 4fe:	e406                	sd	ra,8(sp)
 500:	e022                	sd	s0,0(sp)
 502:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 504:	00054783          	lbu	a5,0(a0)
 508:	cb91                	beqz	a5,51c <strcmp+0x20>
 50a:	0005c703          	lbu	a4,0(a1)
 50e:	00f71763          	bne	a4,a5,51c <strcmp+0x20>
    p++, q++;
 512:	0505                	addi	a0,a0,1
 514:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 516:	00054783          	lbu	a5,0(a0)
 51a:	fbe5                	bnez	a5,50a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 51c:	0005c503          	lbu	a0,0(a1)
}
 520:	40a7853b          	subw	a0,a5,a0
 524:	60a2                	ld	ra,8(sp)
 526:	6402                	ld	s0,0(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret

000000000000052c <strlen>:

uint
strlen(const char *s)
{
 52c:	1141                	addi	sp,sp,-16
 52e:	e406                	sd	ra,8(sp)
 530:	e022                	sd	s0,0(sp)
 532:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 534:	00054783          	lbu	a5,0(a0)
 538:	cf99                	beqz	a5,556 <strlen+0x2a>
 53a:	0505                	addi	a0,a0,1
 53c:	87aa                	mv	a5,a0
 53e:	86be                	mv	a3,a5
 540:	0785                	addi	a5,a5,1
 542:	fff7c703          	lbu	a4,-1(a5)
 546:	ff65                	bnez	a4,53e <strlen+0x12>
 548:	40a6853b          	subw	a0,a3,a0
 54c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 54e:	60a2                	ld	ra,8(sp)
 550:	6402                	ld	s0,0(sp)
 552:	0141                	addi	sp,sp,16
 554:	8082                	ret
  for(n = 0; s[n]; n++)
 556:	4501                	li	a0,0
 558:	bfdd                	j	54e <strlen+0x22>

000000000000055a <memset>:

void*
memset(void *dst, int c, uint n)
{
 55a:	1141                	addi	sp,sp,-16
 55c:	e406                	sd	ra,8(sp)
 55e:	e022                	sd	s0,0(sp)
 560:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 562:	ca19                	beqz	a2,578 <memset+0x1e>
 564:	87aa                	mv	a5,a0
 566:	1602                	slli	a2,a2,0x20
 568:	9201                	srli	a2,a2,0x20
 56a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 56e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 572:	0785                	addi	a5,a5,1
 574:	fee79de3          	bne	a5,a4,56e <memset+0x14>
  }
  return dst;
}
 578:	60a2                	ld	ra,8(sp)
 57a:	6402                	ld	s0,0(sp)
 57c:	0141                	addi	sp,sp,16
 57e:	8082                	ret

0000000000000580 <strchr>:

char*
strchr(const char *s, char c)
{
 580:	1141                	addi	sp,sp,-16
 582:	e406                	sd	ra,8(sp)
 584:	e022                	sd	s0,0(sp)
 586:	0800                	addi	s0,sp,16
  for(; *s; s++)
 588:	00054783          	lbu	a5,0(a0)
 58c:	cf81                	beqz	a5,5a4 <strchr+0x24>
    if(*s == c)
 58e:	00f58763          	beq	a1,a5,59c <strchr+0x1c>
  for(; *s; s++)
 592:	0505                	addi	a0,a0,1
 594:	00054783          	lbu	a5,0(a0)
 598:	fbfd                	bnez	a5,58e <strchr+0xe>
      return (char*)s;
  return 0;
 59a:	4501                	li	a0,0
}
 59c:	60a2                	ld	ra,8(sp)
 59e:	6402                	ld	s0,0(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret
  return 0;
 5a4:	4501                	li	a0,0
 5a6:	bfdd                	j	59c <strchr+0x1c>

00000000000005a8 <gets>:

char*
gets(char *buf, int max)
{
 5a8:	7159                	addi	sp,sp,-112
 5aa:	f486                	sd	ra,104(sp)
 5ac:	f0a2                	sd	s0,96(sp)
 5ae:	eca6                	sd	s1,88(sp)
 5b0:	e8ca                	sd	s2,80(sp)
 5b2:	e4ce                	sd	s3,72(sp)
 5b4:	e0d2                	sd	s4,64(sp)
 5b6:	fc56                	sd	s5,56(sp)
 5b8:	f85a                	sd	s6,48(sp)
 5ba:	f45e                	sd	s7,40(sp)
 5bc:	f062                	sd	s8,32(sp)
 5be:	ec66                	sd	s9,24(sp)
 5c0:	e86a                	sd	s10,16(sp)
 5c2:	1880                	addi	s0,sp,112
 5c4:	8caa                	mv	s9,a0
 5c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5c8:	892a                	mv	s2,a0
 5ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
 5cc:	f9f40b13          	addi	s6,s0,-97
 5d0:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 5d2:	4ba9                	li	s7,10
 5d4:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 5d6:	8d26                	mv	s10,s1
 5d8:	0014899b          	addiw	s3,s1,1
 5dc:	84ce                	mv	s1,s3
 5de:	0349d763          	bge	s3,s4,60c <gets+0x64>
    cc = read(0, &c, 1);
 5e2:	8656                	mv	a2,s5
 5e4:	85da                	mv	a1,s6
 5e6:	4501                	li	a0,0
 5e8:	00000097          	auipc	ra,0x0
 5ec:	1ac080e7          	jalr	428(ra) # 794 <read>
    if(cc < 1)
 5f0:	00a05e63          	blez	a0,60c <gets+0x64>
    buf[i++] = c;
 5f4:	f9f44783          	lbu	a5,-97(s0)
 5f8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5fc:	01778763          	beq	a5,s7,60a <gets+0x62>
 600:	0905                	addi	s2,s2,1
 602:	fd879ae3          	bne	a5,s8,5d6 <gets+0x2e>
    buf[i++] = c;
 606:	8d4e                	mv	s10,s3
 608:	a011                	j	60c <gets+0x64>
 60a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 60c:	9d66                	add	s10,s10,s9
 60e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 612:	8566                	mv	a0,s9
 614:	70a6                	ld	ra,104(sp)
 616:	7406                	ld	s0,96(sp)
 618:	64e6                	ld	s1,88(sp)
 61a:	6946                	ld	s2,80(sp)
 61c:	69a6                	ld	s3,72(sp)
 61e:	6a06                	ld	s4,64(sp)
 620:	7ae2                	ld	s5,56(sp)
 622:	7b42                	ld	s6,48(sp)
 624:	7ba2                	ld	s7,40(sp)
 626:	7c02                	ld	s8,32(sp)
 628:	6ce2                	ld	s9,24(sp)
 62a:	6d42                	ld	s10,16(sp)
 62c:	6165                	addi	sp,sp,112
 62e:	8082                	ret

0000000000000630 <stat>:

int
stat(const char *n, struct stat *st)
{
 630:	1101                	addi	sp,sp,-32
 632:	ec06                	sd	ra,24(sp)
 634:	e822                	sd	s0,16(sp)
 636:	e04a                	sd	s2,0(sp)
 638:	1000                	addi	s0,sp,32
 63a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 63c:	4581                	li	a1,0
 63e:	00000097          	auipc	ra,0x0
 642:	17e080e7          	jalr	382(ra) # 7bc <open>
  if(fd < 0)
 646:	02054663          	bltz	a0,672 <stat+0x42>
 64a:	e426                	sd	s1,8(sp)
 64c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 64e:	85ca                	mv	a1,s2
 650:	00000097          	auipc	ra,0x0
 654:	184080e7          	jalr	388(ra) # 7d4 <fstat>
 658:	892a                	mv	s2,a0
  close(fd);
 65a:	8526                	mv	a0,s1
 65c:	00000097          	auipc	ra,0x0
 660:	148080e7          	jalr	328(ra) # 7a4 <close>
  return r;
 664:	64a2                	ld	s1,8(sp)
}
 666:	854a                	mv	a0,s2
 668:	60e2                	ld	ra,24(sp)
 66a:	6442                	ld	s0,16(sp)
 66c:	6902                	ld	s2,0(sp)
 66e:	6105                	addi	sp,sp,32
 670:	8082                	ret
    return -1;
 672:	597d                	li	s2,-1
 674:	bfcd                	j	666 <stat+0x36>

0000000000000676 <atoi>:

int
atoi(const char *s)
{
 676:	1141                	addi	sp,sp,-16
 678:	e406                	sd	ra,8(sp)
 67a:	e022                	sd	s0,0(sp)
 67c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 67e:	00054683          	lbu	a3,0(a0)
 682:	fd06879b          	addiw	a5,a3,-48 # fd0 <junk3+0x190>
 686:	0ff7f793          	zext.b	a5,a5
 68a:	4625                	li	a2,9
 68c:	02f66963          	bltu	a2,a5,6be <atoi+0x48>
 690:	872a                	mv	a4,a0
  n = 0;
 692:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 694:	0705                	addi	a4,a4,1
 696:	0025179b          	slliw	a5,a0,0x2
 69a:	9fa9                	addw	a5,a5,a0
 69c:	0017979b          	slliw	a5,a5,0x1
 6a0:	9fb5                	addw	a5,a5,a3
 6a2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6a6:	00074683          	lbu	a3,0(a4)
 6aa:	fd06879b          	addiw	a5,a3,-48
 6ae:	0ff7f793          	zext.b	a5,a5
 6b2:	fef671e3          	bgeu	a2,a5,694 <atoi+0x1e>
  return n;
}
 6b6:	60a2                	ld	ra,8(sp)
 6b8:	6402                	ld	s0,0(sp)
 6ba:	0141                	addi	sp,sp,16
 6bc:	8082                	ret
  n = 0;
 6be:	4501                	li	a0,0
 6c0:	bfdd                	j	6b6 <atoi+0x40>

00000000000006c2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6c2:	1141                	addi	sp,sp,-16
 6c4:	e406                	sd	ra,8(sp)
 6c6:	e022                	sd	s0,0(sp)
 6c8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6ca:	02b57563          	bgeu	a0,a1,6f4 <memmove+0x32>
    while(n-- > 0)
 6ce:	00c05f63          	blez	a2,6ec <memmove+0x2a>
 6d2:	1602                	slli	a2,a2,0x20
 6d4:	9201                	srli	a2,a2,0x20
 6d6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 6da:	872a                	mv	a4,a0
      *dst++ = *src++;
 6dc:	0585                	addi	a1,a1,1
 6de:	0705                	addi	a4,a4,1
 6e0:	fff5c683          	lbu	a3,-1(a1)
 6e4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 6e8:	fee79ae3          	bne	a5,a4,6dc <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 6ec:	60a2                	ld	ra,8(sp)
 6ee:	6402                	ld	s0,0(sp)
 6f0:	0141                	addi	sp,sp,16
 6f2:	8082                	ret
    dst += n;
 6f4:	00c50733          	add	a4,a0,a2
    src += n;
 6f8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 6fa:	fec059e3          	blez	a2,6ec <memmove+0x2a>
 6fe:	fff6079b          	addiw	a5,a2,-1
 702:	1782                	slli	a5,a5,0x20
 704:	9381                	srli	a5,a5,0x20
 706:	fff7c793          	not	a5,a5
 70a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 70c:	15fd                	addi	a1,a1,-1
 70e:	177d                	addi	a4,a4,-1
 710:	0005c683          	lbu	a3,0(a1)
 714:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 718:	fef71ae3          	bne	a4,a5,70c <memmove+0x4a>
 71c:	bfc1                	j	6ec <memmove+0x2a>

000000000000071e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 71e:	1141                	addi	sp,sp,-16
 720:	e406                	sd	ra,8(sp)
 722:	e022                	sd	s0,0(sp)
 724:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 726:	ca0d                	beqz	a2,758 <memcmp+0x3a>
 728:	fff6069b          	addiw	a3,a2,-1
 72c:	1682                	slli	a3,a3,0x20
 72e:	9281                	srli	a3,a3,0x20
 730:	0685                	addi	a3,a3,1
 732:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 734:	00054783          	lbu	a5,0(a0)
 738:	0005c703          	lbu	a4,0(a1)
 73c:	00e79863          	bne	a5,a4,74c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 740:	0505                	addi	a0,a0,1
    p2++;
 742:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 744:	fed518e3          	bne	a0,a3,734 <memcmp+0x16>
  }
  return 0;
 748:	4501                	li	a0,0
 74a:	a019                	j	750 <memcmp+0x32>
      return *p1 - *p2;
 74c:	40e7853b          	subw	a0,a5,a4
}
 750:	60a2                	ld	ra,8(sp)
 752:	6402                	ld	s0,0(sp)
 754:	0141                	addi	sp,sp,16
 756:	8082                	ret
  return 0;
 758:	4501                	li	a0,0
 75a:	bfdd                	j	750 <memcmp+0x32>

000000000000075c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 75c:	1141                	addi	sp,sp,-16
 75e:	e406                	sd	ra,8(sp)
 760:	e022                	sd	s0,0(sp)
 762:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 764:	00000097          	auipc	ra,0x0
 768:	f5e080e7          	jalr	-162(ra) # 6c2 <memmove>
}
 76c:	60a2                	ld	ra,8(sp)
 76e:	6402                	ld	s0,0(sp)
 770:	0141                	addi	sp,sp,16
 772:	8082                	ret

0000000000000774 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 774:	4885                	li	a7,1
 ecall
 776:	00000073          	ecall
 ret
 77a:	8082                	ret

000000000000077c <exit>:
.global exit
exit:
 li a7, SYS_exit
 77c:	4889                	li	a7,2
 ecall
 77e:	00000073          	ecall
 ret
 782:	8082                	ret

0000000000000784 <wait>:
.global wait
wait:
 li a7, SYS_wait
 784:	488d                	li	a7,3
 ecall
 786:	00000073          	ecall
 ret
 78a:	8082                	ret

000000000000078c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 78c:	4891                	li	a7,4
 ecall
 78e:	00000073          	ecall
 ret
 792:	8082                	ret

0000000000000794 <read>:
.global read
read:
 li a7, SYS_read
 794:	4895                	li	a7,5
 ecall
 796:	00000073          	ecall
 ret
 79a:	8082                	ret

000000000000079c <write>:
.global write
write:
 li a7, SYS_write
 79c:	48c1                	li	a7,16
 ecall
 79e:	00000073          	ecall
 ret
 7a2:	8082                	ret

00000000000007a4 <close>:
.global close
close:
 li a7, SYS_close
 7a4:	48d5                	li	a7,21
 ecall
 7a6:	00000073          	ecall
 ret
 7aa:	8082                	ret

00000000000007ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 7ac:	4899                	li	a7,6
 ecall
 7ae:	00000073          	ecall
 ret
 7b2:	8082                	ret

00000000000007b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 7b4:	489d                	li	a7,7
 ecall
 7b6:	00000073          	ecall
 ret
 7ba:	8082                	ret

00000000000007bc <open>:
.global open
open:
 li a7, SYS_open
 7bc:	48bd                	li	a7,15
 ecall
 7be:	00000073          	ecall
 ret
 7c2:	8082                	ret

00000000000007c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 7c4:	48c5                	li	a7,17
 ecall
 7c6:	00000073          	ecall
 ret
 7ca:	8082                	ret

00000000000007cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 7cc:	48c9                	li	a7,18
 ecall
 7ce:	00000073          	ecall
 ret
 7d2:	8082                	ret

00000000000007d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 7d4:	48a1                	li	a7,8
 ecall
 7d6:	00000073          	ecall
 ret
 7da:	8082                	ret

00000000000007dc <link>:
.global link
link:
 li a7, SYS_link
 7dc:	48cd                	li	a7,19
 ecall
 7de:	00000073          	ecall
 ret
 7e2:	8082                	ret

00000000000007e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7e4:	48d1                	li	a7,20
 ecall
 7e6:	00000073          	ecall
 ret
 7ea:	8082                	ret

00000000000007ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7ec:	48a5                	li	a7,9
 ecall
 7ee:	00000073          	ecall
 ret
 7f2:	8082                	ret

00000000000007f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7f4:	48a9                	li	a7,10
 ecall
 7f6:	00000073          	ecall
 ret
 7fa:	8082                	ret

00000000000007fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7fc:	48ad                	li	a7,11
 ecall
 7fe:	00000073          	ecall
 ret
 802:	8082                	ret

0000000000000804 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 804:	48b1                	li	a7,12
 ecall
 806:	00000073          	ecall
 ret
 80a:	8082                	ret

000000000000080c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 80c:	48b5                	li	a7,13
 ecall
 80e:	00000073          	ecall
 ret
 812:	8082                	ret

0000000000000814 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 814:	48b9                	li	a7,14
 ecall
 816:	00000073          	ecall
 ret
 81a:	8082                	ret

000000000000081c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 81c:	1101                	addi	sp,sp,-32
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 828:	4605                	li	a2,1
 82a:	fef40593          	addi	a1,s0,-17
 82e:	00000097          	auipc	ra,0x0
 832:	f6e080e7          	jalr	-146(ra) # 79c <write>
}
 836:	60e2                	ld	ra,24(sp)
 838:	6442                	ld	s0,16(sp)
 83a:	6105                	addi	sp,sp,32
 83c:	8082                	ret

000000000000083e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 83e:	7139                	addi	sp,sp,-64
 840:	fc06                	sd	ra,56(sp)
 842:	f822                	sd	s0,48(sp)
 844:	f426                	sd	s1,40(sp)
 846:	f04a                	sd	s2,32(sp)
 848:	ec4e                	sd	s3,24(sp)
 84a:	0080                	addi	s0,sp,64
 84c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 84e:	c299                	beqz	a3,854 <printint+0x16>
 850:	0805c063          	bltz	a1,8d0 <printint+0x92>
  neg = 0;
 854:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 856:	fc040313          	addi	t1,s0,-64
  neg = 0;
 85a:	869a                	mv	a3,t1
  i = 0;
 85c:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 85e:	00000817          	auipc	a6,0x0
 862:	5ba80813          	addi	a6,a6,1466 # e18 <digits>
 866:	88be                	mv	a7,a5
 868:	0017851b          	addiw	a0,a5,1
 86c:	87aa                	mv	a5,a0
 86e:	02c5f73b          	remuw	a4,a1,a2
 872:	1702                	slli	a4,a4,0x20
 874:	9301                	srli	a4,a4,0x20
 876:	9742                	add	a4,a4,a6
 878:	00074703          	lbu	a4,0(a4)
 87c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 880:	872e                	mv	a4,a1
 882:	02c5d5bb          	divuw	a1,a1,a2
 886:	0685                	addi	a3,a3,1
 888:	fcc77fe3          	bgeu	a4,a2,866 <printint+0x28>
  if(neg)
 88c:	000e0c63          	beqz	t3,8a4 <printint+0x66>
    buf[i++] = '-';
 890:	fd050793          	addi	a5,a0,-48
 894:	00878533          	add	a0,a5,s0
 898:	02d00793          	li	a5,45
 89c:	fef50823          	sb	a5,-16(a0)
 8a0:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 8a4:	fff7899b          	addiw	s3,a5,-1
 8a8:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 8ac:	fff4c583          	lbu	a1,-1(s1)
 8b0:	854a                	mv	a0,s2
 8b2:	00000097          	auipc	ra,0x0
 8b6:	f6a080e7          	jalr	-150(ra) # 81c <putc>
  while(--i >= 0)
 8ba:	39fd                	addiw	s3,s3,-1 # 1999fff <__BSS_END__+0x19951af>
 8bc:	14fd                	addi	s1,s1,-1
 8be:	fe09d7e3          	bgez	s3,8ac <printint+0x6e>
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	7902                	ld	s2,32(sp)
 8ca:	69e2                	ld	s3,24(sp)
 8cc:	6121                	addi	sp,sp,64
 8ce:	8082                	ret
    x = -xx;
 8d0:	40b005bb          	negw	a1,a1
    neg = 1;
 8d4:	4e05                	li	t3,1
    x = -xx;
 8d6:	b741                	j	856 <printint+0x18>

00000000000008d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 8d8:	715d                	addi	sp,sp,-80
 8da:	e486                	sd	ra,72(sp)
 8dc:	e0a2                	sd	s0,64(sp)
 8de:	f84a                	sd	s2,48(sp)
 8e0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8e2:	0005c903          	lbu	s2,0(a1)
 8e6:	1a090a63          	beqz	s2,a9a <vprintf+0x1c2>
 8ea:	fc26                	sd	s1,56(sp)
 8ec:	f44e                	sd	s3,40(sp)
 8ee:	f052                	sd	s4,32(sp)
 8f0:	ec56                	sd	s5,24(sp)
 8f2:	e85a                	sd	s6,16(sp)
 8f4:	e45e                	sd	s7,8(sp)
 8f6:	8aaa                	mv	s5,a0
 8f8:	8bb2                	mv	s7,a2
 8fa:	00158493          	addi	s1,a1,1
  state = 0;
 8fe:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 900:	02500a13          	li	s4,37
 904:	4b55                	li	s6,21
 906:	a839                	j	924 <vprintf+0x4c>
        putc(fd, c);
 908:	85ca                	mv	a1,s2
 90a:	8556                	mv	a0,s5
 90c:	00000097          	auipc	ra,0x0
 910:	f10080e7          	jalr	-240(ra) # 81c <putc>
 914:	a019                	j	91a <vprintf+0x42>
    } else if(state == '%'){
 916:	01498d63          	beq	s3,s4,930 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 91a:	0485                	addi	s1,s1,1
 91c:	fff4c903          	lbu	s2,-1(s1)
 920:	16090763          	beqz	s2,a8e <vprintf+0x1b6>
    if(state == 0){
 924:	fe0999e3          	bnez	s3,916 <vprintf+0x3e>
      if(c == '%'){
 928:	ff4910e3          	bne	s2,s4,908 <vprintf+0x30>
        state = '%';
 92c:	89d2                	mv	s3,s4
 92e:	b7f5                	j	91a <vprintf+0x42>
      if(c == 'd'){
 930:	13490463          	beq	s2,s4,a58 <vprintf+0x180>
 934:	f9d9079b          	addiw	a5,s2,-99
 938:	0ff7f793          	zext.b	a5,a5
 93c:	12fb6763          	bltu	s6,a5,a6a <vprintf+0x192>
 940:	f9d9079b          	addiw	a5,s2,-99
 944:	0ff7f713          	zext.b	a4,a5
 948:	12eb6163          	bltu	s6,a4,a6a <vprintf+0x192>
 94c:	00271793          	slli	a5,a4,0x2
 950:	00000717          	auipc	a4,0x0
 954:	47070713          	addi	a4,a4,1136 # dc0 <malloc+0x232>
 958:	97ba                	add	a5,a5,a4
 95a:	439c                	lw	a5,0(a5)
 95c:	97ba                	add	a5,a5,a4
 95e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 960:	008b8913          	addi	s2,s7,8
 964:	4685                	li	a3,1
 966:	4629                	li	a2,10
 968:	000ba583          	lw	a1,0(s7)
 96c:	8556                	mv	a0,s5
 96e:	00000097          	auipc	ra,0x0
 972:	ed0080e7          	jalr	-304(ra) # 83e <printint>
 976:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 978:	4981                	li	s3,0
 97a:	b745                	j	91a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 97c:	008b8913          	addi	s2,s7,8
 980:	4681                	li	a3,0
 982:	4629                	li	a2,10
 984:	000ba583          	lw	a1,0(s7)
 988:	8556                	mv	a0,s5
 98a:	00000097          	auipc	ra,0x0
 98e:	eb4080e7          	jalr	-332(ra) # 83e <printint>
 992:	8bca                	mv	s7,s2
      state = 0;
 994:	4981                	li	s3,0
 996:	b751                	j	91a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 998:	008b8913          	addi	s2,s7,8
 99c:	4681                	li	a3,0
 99e:	4641                	li	a2,16
 9a0:	000ba583          	lw	a1,0(s7)
 9a4:	8556                	mv	a0,s5
 9a6:	00000097          	auipc	ra,0x0
 9aa:	e98080e7          	jalr	-360(ra) # 83e <printint>
 9ae:	8bca                	mv	s7,s2
      state = 0;
 9b0:	4981                	li	s3,0
 9b2:	b7a5                	j	91a <vprintf+0x42>
 9b4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9b6:	008b8c13          	addi	s8,s7,8
 9ba:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9be:	03000593          	li	a1,48
 9c2:	8556                	mv	a0,s5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	e58080e7          	jalr	-424(ra) # 81c <putc>
  putc(fd, 'x');
 9cc:	07800593          	li	a1,120
 9d0:	8556                	mv	a0,s5
 9d2:	00000097          	auipc	ra,0x0
 9d6:	e4a080e7          	jalr	-438(ra) # 81c <putc>
 9da:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9dc:	00000b97          	auipc	s7,0x0
 9e0:	43cb8b93          	addi	s7,s7,1084 # e18 <digits>
 9e4:	03c9d793          	srli	a5,s3,0x3c
 9e8:	97de                	add	a5,a5,s7
 9ea:	0007c583          	lbu	a1,0(a5)
 9ee:	8556                	mv	a0,s5
 9f0:	00000097          	auipc	ra,0x0
 9f4:	e2c080e7          	jalr	-468(ra) # 81c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9f8:	0992                	slli	s3,s3,0x4
 9fa:	397d                	addiw	s2,s2,-1
 9fc:	fe0914e3          	bnez	s2,9e4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 a00:	8be2                	mv	s7,s8
      state = 0;
 a02:	4981                	li	s3,0
 a04:	6c02                	ld	s8,0(sp)
 a06:	bf11                	j	91a <vprintf+0x42>
        s = va_arg(ap, char*);
 a08:	008b8993          	addi	s3,s7,8
 a0c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 a10:	02090163          	beqz	s2,a32 <vprintf+0x15a>
        while(*s != 0){
 a14:	00094583          	lbu	a1,0(s2)
 a18:	c9a5                	beqz	a1,a88 <vprintf+0x1b0>
          putc(fd, *s);
 a1a:	8556                	mv	a0,s5
 a1c:	00000097          	auipc	ra,0x0
 a20:	e00080e7          	jalr	-512(ra) # 81c <putc>
          s++;
 a24:	0905                	addi	s2,s2,1
        while(*s != 0){
 a26:	00094583          	lbu	a1,0(s2)
 a2a:	f9e5                	bnez	a1,a1a <vprintf+0x142>
        s = va_arg(ap, char*);
 a2c:	8bce                	mv	s7,s3
      state = 0;
 a2e:	4981                	li	s3,0
 a30:	b5ed                	j	91a <vprintf+0x42>
          s = "(null)";
 a32:	00000917          	auipc	s2,0x0
 a36:	38690913          	addi	s2,s2,902 # db8 <malloc+0x22a>
        while(*s != 0){
 a3a:	02800593          	li	a1,40
 a3e:	bff1                	j	a1a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 a40:	008b8913          	addi	s2,s7,8
 a44:	000bc583          	lbu	a1,0(s7)
 a48:	8556                	mv	a0,s5
 a4a:	00000097          	auipc	ra,0x0
 a4e:	dd2080e7          	jalr	-558(ra) # 81c <putc>
 a52:	8bca                	mv	s7,s2
      state = 0;
 a54:	4981                	li	s3,0
 a56:	b5d1                	j	91a <vprintf+0x42>
        putc(fd, c);
 a58:	02500593          	li	a1,37
 a5c:	8556                	mv	a0,s5
 a5e:	00000097          	auipc	ra,0x0
 a62:	dbe080e7          	jalr	-578(ra) # 81c <putc>
      state = 0;
 a66:	4981                	li	s3,0
 a68:	bd4d                	j	91a <vprintf+0x42>
        putc(fd, '%');
 a6a:	02500593          	li	a1,37
 a6e:	8556                	mv	a0,s5
 a70:	00000097          	auipc	ra,0x0
 a74:	dac080e7          	jalr	-596(ra) # 81c <putc>
        putc(fd, c);
 a78:	85ca                	mv	a1,s2
 a7a:	8556                	mv	a0,s5
 a7c:	00000097          	auipc	ra,0x0
 a80:	da0080e7          	jalr	-608(ra) # 81c <putc>
      state = 0;
 a84:	4981                	li	s3,0
 a86:	bd51                	j	91a <vprintf+0x42>
        s = va_arg(ap, char*);
 a88:	8bce                	mv	s7,s3
      state = 0;
 a8a:	4981                	li	s3,0
 a8c:	b579                	j	91a <vprintf+0x42>
 a8e:	74e2                	ld	s1,56(sp)
 a90:	79a2                	ld	s3,40(sp)
 a92:	7a02                	ld	s4,32(sp)
 a94:	6ae2                	ld	s5,24(sp)
 a96:	6b42                	ld	s6,16(sp)
 a98:	6ba2                	ld	s7,8(sp)
    }
  }
}
 a9a:	60a6                	ld	ra,72(sp)
 a9c:	6406                	ld	s0,64(sp)
 a9e:	7942                	ld	s2,48(sp)
 aa0:	6161                	addi	sp,sp,80
 aa2:	8082                	ret

0000000000000aa4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 aa4:	715d                	addi	sp,sp,-80
 aa6:	ec06                	sd	ra,24(sp)
 aa8:	e822                	sd	s0,16(sp)
 aaa:	1000                	addi	s0,sp,32
 aac:	e010                	sd	a2,0(s0)
 aae:	e414                	sd	a3,8(s0)
 ab0:	e818                	sd	a4,16(s0)
 ab2:	ec1c                	sd	a5,24(s0)
 ab4:	03043023          	sd	a6,32(s0)
 ab8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 abc:	8622                	mv	a2,s0
 abe:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 ac2:	00000097          	auipc	ra,0x0
 ac6:	e16080e7          	jalr	-490(ra) # 8d8 <vprintf>
}
 aca:	60e2                	ld	ra,24(sp)
 acc:	6442                	ld	s0,16(sp)
 ace:	6161                	addi	sp,sp,80
 ad0:	8082                	ret

0000000000000ad2 <printf>:

void
printf(const char *fmt, ...)
{
 ad2:	711d                	addi	sp,sp,-96
 ad4:	ec06                	sd	ra,24(sp)
 ad6:	e822                	sd	s0,16(sp)
 ad8:	1000                	addi	s0,sp,32
 ada:	e40c                	sd	a1,8(s0)
 adc:	e810                	sd	a2,16(s0)
 ade:	ec14                	sd	a3,24(s0)
 ae0:	f018                	sd	a4,32(s0)
 ae2:	f41c                	sd	a5,40(s0)
 ae4:	03043823          	sd	a6,48(s0)
 ae8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 aec:	00840613          	addi	a2,s0,8
 af0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 af4:	85aa                	mv	a1,a0
 af6:	4505                	li	a0,1
 af8:	00000097          	auipc	ra,0x0
 afc:	de0080e7          	jalr	-544(ra) # 8d8 <vprintf>
}
 b00:	60e2                	ld	ra,24(sp)
 b02:	6442                	ld	s0,16(sp)
 b04:	6125                	addi	sp,sp,96
 b06:	8082                	ret

0000000000000b08 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b08:	1141                	addi	sp,sp,-16
 b0a:	e406                	sd	ra,8(sp)
 b0c:	e022                	sd	s0,0(sp)
 b0e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b10:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b14:	00000797          	auipc	a5,0x0
 b18:	3247b783          	ld	a5,804(a5) # e38 <freep>
 b1c:	a02d                	j	b46 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b1e:	4618                	lw	a4,8(a2)
 b20:	9f2d                	addw	a4,a4,a1
 b22:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b26:	6398                	ld	a4,0(a5)
 b28:	6310                	ld	a2,0(a4)
 b2a:	a83d                	j	b68 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b2c:	ff852703          	lw	a4,-8(a0)
 b30:	9f31                	addw	a4,a4,a2
 b32:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b34:	ff053683          	ld	a3,-16(a0)
 b38:	a091                	j	b7c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b3a:	6398                	ld	a4,0(a5)
 b3c:	00e7e463          	bltu	a5,a4,b44 <free+0x3c>
 b40:	00e6ea63          	bltu	a3,a4,b54 <free+0x4c>
{
 b44:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b46:	fed7fae3          	bgeu	a5,a3,b3a <free+0x32>
 b4a:	6398                	ld	a4,0(a5)
 b4c:	00e6e463          	bltu	a3,a4,b54 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b50:	fee7eae3          	bltu	a5,a4,b44 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 b54:	ff852583          	lw	a1,-8(a0)
 b58:	6390                	ld	a2,0(a5)
 b5a:	02059813          	slli	a6,a1,0x20
 b5e:	01c85713          	srli	a4,a6,0x1c
 b62:	9736                	add	a4,a4,a3
 b64:	fae60de3          	beq	a2,a4,b1e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 b68:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b6c:	4790                	lw	a2,8(a5)
 b6e:	02061593          	slli	a1,a2,0x20
 b72:	01c5d713          	srli	a4,a1,0x1c
 b76:	973e                	add	a4,a4,a5
 b78:	fae68ae3          	beq	a3,a4,b2c <free+0x24>
    p->s.ptr = bp->s.ptr;
 b7c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b7e:	00000717          	auipc	a4,0x0
 b82:	2af73d23          	sd	a5,698(a4) # e38 <freep>
}
 b86:	60a2                	ld	ra,8(sp)
 b88:	6402                	ld	s0,0(sp)
 b8a:	0141                	addi	sp,sp,16
 b8c:	8082                	ret

0000000000000b8e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b8e:	7139                	addi	sp,sp,-64
 b90:	fc06                	sd	ra,56(sp)
 b92:	f822                	sd	s0,48(sp)
 b94:	f04a                	sd	s2,32(sp)
 b96:	ec4e                	sd	s3,24(sp)
 b98:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b9a:	02051993          	slli	s3,a0,0x20
 b9e:	0209d993          	srli	s3,s3,0x20
 ba2:	09bd                	addi	s3,s3,15
 ba4:	0049d993          	srli	s3,s3,0x4
 ba8:	2985                	addiw	s3,s3,1
 baa:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 bac:	00000517          	auipc	a0,0x0
 bb0:	28c53503          	ld	a0,652(a0) # e38 <freep>
 bb4:	c905                	beqz	a0,be4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bb8:	4798                	lw	a4,8(a5)
 bba:	09377a63          	bgeu	a4,s3,c4e <malloc+0xc0>
 bbe:	f426                	sd	s1,40(sp)
 bc0:	e852                	sd	s4,16(sp)
 bc2:	e456                	sd	s5,8(sp)
 bc4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 bc6:	8a4e                	mv	s4,s3
 bc8:	6705                	lui	a4,0x1
 bca:	00e9f363          	bgeu	s3,a4,bd0 <malloc+0x42>
 bce:	6a05                	lui	s4,0x1
 bd0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 bd4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bd8:	00000497          	auipc	s1,0x0
 bdc:	26048493          	addi	s1,s1,608 # e38 <freep>
  if(p == (char*)-1)
 be0:	5afd                	li	s5,-1
 be2:	a089                	j	c24 <malloc+0x96>
 be4:	f426                	sd	s1,40(sp)
 be6:	e852                	sd	s4,16(sp)
 be8:	e456                	sd	s5,8(sp)
 bea:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 bec:	00004797          	auipc	a5,0x4
 bf0:	25478793          	addi	a5,a5,596 # 4e40 <base>
 bf4:	00000717          	auipc	a4,0x0
 bf8:	24f73223          	sd	a5,580(a4) # e38 <freep>
 bfc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 bfe:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c02:	b7d1                	j	bc6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 c04:	6398                	ld	a4,0(a5)
 c06:	e118                	sd	a4,0(a0)
 c08:	a8b9                	j	c66 <malloc+0xd8>
  hp->s.size = nu;
 c0a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c0e:	0541                	addi	a0,a0,16
 c10:	00000097          	auipc	ra,0x0
 c14:	ef8080e7          	jalr	-264(ra) # b08 <free>
  return freep;
 c18:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 c1a:	c135                	beqz	a0,c7e <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c1c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c1e:	4798                	lw	a4,8(a5)
 c20:	03277363          	bgeu	a4,s2,c46 <malloc+0xb8>
    if(p == freep)
 c24:	6098                	ld	a4,0(s1)
 c26:	853e                	mv	a0,a5
 c28:	fef71ae3          	bne	a4,a5,c1c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c2c:	8552                	mv	a0,s4
 c2e:	00000097          	auipc	ra,0x0
 c32:	bd6080e7          	jalr	-1066(ra) # 804 <sbrk>
  if(p == (char*)-1)
 c36:	fd551ae3          	bne	a0,s5,c0a <malloc+0x7c>
        return 0;
 c3a:	4501                	li	a0,0
 c3c:	74a2                	ld	s1,40(sp)
 c3e:	6a42                	ld	s4,16(sp)
 c40:	6aa2                	ld	s5,8(sp)
 c42:	6b02                	ld	s6,0(sp)
 c44:	a03d                	j	c72 <malloc+0xe4>
 c46:	74a2                	ld	s1,40(sp)
 c48:	6a42                	ld	s4,16(sp)
 c4a:	6aa2                	ld	s5,8(sp)
 c4c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 c4e:	fae90be3          	beq	s2,a4,c04 <malloc+0x76>
        p->s.size -= nunits;
 c52:	4137073b          	subw	a4,a4,s3
 c56:	c798                	sw	a4,8(a5)
        p += p->s.size;
 c58:	02071693          	slli	a3,a4,0x20
 c5c:	01c6d713          	srli	a4,a3,0x1c
 c60:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c62:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c66:	00000717          	auipc	a4,0x0
 c6a:	1ca73923          	sd	a0,466(a4) # e38 <freep>
      return (void*)(p + 1);
 c6e:	01078513          	addi	a0,a5,16
  }
}
 c72:	70e2                	ld	ra,56(sp)
 c74:	7442                	ld	s0,48(sp)
 c76:	7902                	ld	s2,32(sp)
 c78:	69e2                	ld	s3,24(sp)
 c7a:	6121                	addi	sp,sp,64
 c7c:	8082                	ret
 c7e:	74a2                	ld	s1,40(sp)
 c80:	6a42                	ld	s4,16(sp)
 c82:	6aa2                	ld	s5,8(sp)
 c84:	6b02                	ld	s6,0(sp)
 c86:	b7f5                	j	c72 <malloc+0xe4>
