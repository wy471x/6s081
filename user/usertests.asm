
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	b54080e7          	jalr	-1196(ra) # 5b64 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	b42080e7          	jalr	-1214(ra) # 5b64 <open>
    if(fd >= 0){
      2a:	55fd                	li	a1,-1
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	00250513          	addi	a0,a0,2 # 6040 <malloc+0xfa>
      46:	00006097          	auipc	ra,0x6
      4a:	e44080e7          	jalr	-444(ra) # 5e8a <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	ad4080e7          	jalr	-1324(ra) # 5b24 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	94878793          	addi	a5,a5,-1720 # 99a0 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	05068693          	addi	a3,a3,80 # c0b0 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	fe050513          	addi	a0,a0,-32 # 6060 <malloc+0x11a>
      88:	00006097          	auipc	ra,0x6
      8c:	e02080e7          	jalr	-510(ra) # 5e8a <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	a92080e7          	jalr	-1390(ra) # 5b24 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	fd050513          	addi	a0,a0,-48 # 6078 <malloc+0x132>
      b0:	00006097          	auipc	ra,0x6
      b4:	ab4080e7          	jalr	-1356(ra) # 5b64 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	a90080e7          	jalr	-1392(ra) # 5b4c <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	fd250513          	addi	a0,a0,-46 # 6098 <malloc+0x152>
      ce:	00006097          	auipc	ra,0x6
      d2:	a96080e7          	jalr	-1386(ra) # 5b64 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	f9a50513          	addi	a0,a0,-102 # 6080 <malloc+0x13a>
      ee:	00006097          	auipc	ra,0x6
      f2:	d9c080e7          	jalr	-612(ra) # 5e8a <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	a2c080e7          	jalr	-1492(ra) # 5b24 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	fa650513          	addi	a0,a0,-90 # 60a8 <malloc+0x162>
     10a:	00006097          	auipc	ra,0x6
     10e:	d80080e7          	jalr	-640(ra) # 5e8a <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	a10080e7          	jalr	-1520(ra) # 5b24 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	fa450513          	addi	a0,a0,-92 # 60d0 <malloc+0x18a>
     134:	00006097          	auipc	ra,0x6
     138:	a40080e7          	jalr	-1472(ra) # 5b74 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	f9050513          	addi	a0,a0,-112 # 60d0 <malloc+0x18a>
     148:	00006097          	auipc	ra,0x6
     14c:	a1c080e7          	jalr	-1508(ra) # 5b64 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	f8c58593          	addi	a1,a1,-116 # 60e0 <malloc+0x19a>
     15c:	00006097          	auipc	ra,0x6
     160:	9e8080e7          	jalr	-1560(ra) # 5b44 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	f6850513          	addi	a0,a0,-152 # 60d0 <malloc+0x18a>
     170:	00006097          	auipc	ra,0x6
     174:	9f4080e7          	jalr	-1548(ra) # 5b64 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	f6c58593          	addi	a1,a1,-148 # 60e8 <malloc+0x1a2>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	9be080e7          	jalr	-1602(ra) # 5b44 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	f3c50513          	addi	a0,a0,-196 # 60d0 <malloc+0x18a>
     19c:	00006097          	auipc	ra,0x6
     1a0:	9d8080e7          	jalr	-1576(ra) # 5b74 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	9a6080e7          	jalr	-1626(ra) # 5b4c <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	99c080e7          	jalr	-1636(ra) # 5b4c <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	f2650513          	addi	a0,a0,-218 # 60f0 <malloc+0x1aa>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	cb8080e7          	jalr	-840(ra) # 5e8a <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	948080e7          	jalr	-1720(ra) # 5b24 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7139                	addi	sp,sp,-64
     1e6:	fc06                	sd	ra,56(sp)
     1e8:	f822                	sd	s0,48(sp)
     1ea:	f426                	sd	s1,40(sp)
     1ec:	f04a                	sd	s2,32(sp)
     1ee:	ec4e                	sd	s3,24(sp)
     1f0:	e852                	sd	s4,16(sp)
     1f2:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1f4:	06100793          	li	a5,97
     1f8:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1fc:	fc040523          	sb	zero,-54(s0)
     200:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     204:	fc840a13          	addi	s4,s0,-56
     208:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     20c:	06400913          	li	s2,100
    name[1] = '0' + i;
     210:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     214:	85ce                	mv	a1,s3
     216:	8552                	mv	a0,s4
     218:	00006097          	auipc	ra,0x6
     21c:	94c080e7          	jalr	-1716(ra) # 5b64 <open>
    close(fd);
     220:	00006097          	auipc	ra,0x6
     224:	92c080e7          	jalr	-1748(ra) # 5b4c <close>
  for(i = 0; i < N; i++){
     228:	2485                	addiw	s1,s1,1
     22a:	0ff4f493          	zext.b	s1,s1
     22e:	ff2491e3          	bne	s1,s2,210 <createtest+0x2c>
  name[0] = 'a';
     232:	06100793          	li	a5,97
     236:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     23a:	fc040523          	sb	zero,-54(s0)
     23e:	03000493          	li	s1,48
    unlink(name);
     242:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     246:	06400913          	li	s2,100
    name[1] = '0' + i;
     24a:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     24e:	854e                	mv	a0,s3
     250:	00006097          	auipc	ra,0x6
     254:	924080e7          	jalr	-1756(ra) # 5b74 <unlink>
  for(i = 0; i < N; i++){
     258:	2485                	addiw	s1,s1,1
     25a:	0ff4f493          	zext.b	s1,s1
     25e:	ff2496e3          	bne	s1,s2,24a <createtest+0x66>
}
     262:	70e2                	ld	ra,56(sp)
     264:	7442                	ld	s0,48(sp)
     266:	74a2                	ld	s1,40(sp)
     268:	7902                	ld	s2,32(sp)
     26a:	69e2                	ld	s3,24(sp)
     26c:	6a42                	ld	s4,16(sp)
     26e:	6121                	addi	sp,sp,64
     270:	8082                	ret

0000000000000272 <bigwrite>:
{
     272:	715d                	addi	sp,sp,-80
     274:	e486                	sd	ra,72(sp)
     276:	e0a2                	sd	s0,64(sp)
     278:	fc26                	sd	s1,56(sp)
     27a:	f84a                	sd	s2,48(sp)
     27c:	f44e                	sd	s3,40(sp)
     27e:	f052                	sd	s4,32(sp)
     280:	ec56                	sd	s5,24(sp)
     282:	e85a                	sd	s6,16(sp)
     284:	e45e                	sd	s7,8(sp)
     286:	e062                	sd	s8,0(sp)
     288:	0880                	addi	s0,sp,80
     28a:	8c2a                	mv	s8,a0
  unlink("bigwrite");
     28c:	00006517          	auipc	a0,0x6
     290:	e8c50513          	addi	a0,a0,-372 # 6118 <malloc+0x1d2>
     294:	00006097          	auipc	ra,0x6
     298:	8e0080e7          	jalr	-1824(ra) # 5b74 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     29c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a0:	20200b93          	li	s7,514
     2a4:	00006a97          	auipc	s5,0x6
     2a8:	e74a8a93          	addi	s5,s5,-396 # 6118 <malloc+0x1d2>
      int cc = write(fd, buf, sz);
     2ac:	0000ca17          	auipc	s4,0xc
     2b0:	e04a0a13          	addi	s4,s4,-508 # c0b0 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <exitiputtest+0x3f>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	85de                	mv	a1,s7
     2bc:	8556                	mv	a0,s5
     2be:	00006097          	auipc	ra,0x6
     2c2:	8a6080e7          	jalr	-1882(ra) # 5b64 <open>
     2c6:	892a                	mv	s2,a0
    if(fd < 0){
     2c8:	04054e63          	bltz	a0,324 <bigwrite+0xb2>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	00006097          	auipc	ra,0x6
     2d4:	874080e7          	jalr	-1932(ra) # 5b44 <write>
     2d8:	89aa                	mv	s3,a0
      if(cc != sz){
     2da:	06a49363          	bne	s1,a0,340 <bigwrite+0xce>
      int cc = write(fd, buf, sz);
     2de:	8626                	mv	a2,s1
     2e0:	85d2                	mv	a1,s4
     2e2:	854a                	mv	a0,s2
     2e4:	00006097          	auipc	ra,0x6
     2e8:	860080e7          	jalr	-1952(ra) # 5b44 <write>
      if(cc != sz){
     2ec:	04951b63          	bne	a0,s1,342 <bigwrite+0xd0>
    close(fd);
     2f0:	854a                	mv	a0,s2
     2f2:	00006097          	auipc	ra,0x6
     2f6:	85a080e7          	jalr	-1958(ra) # 5b4c <close>
    unlink("bigwrite");
     2fa:	8556                	mv	a0,s5
     2fc:	00006097          	auipc	ra,0x6
     300:	878080e7          	jalr	-1928(ra) # 5b74 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     304:	1d74849b          	addiw	s1,s1,471
     308:	fb6499e3          	bne	s1,s6,2ba <bigwrite+0x48>
}
     30c:	60a6                	ld	ra,72(sp)
     30e:	6406                	ld	s0,64(sp)
     310:	74e2                	ld	s1,56(sp)
     312:	7942                	ld	s2,48(sp)
     314:	79a2                	ld	s3,40(sp)
     316:	7a02                	ld	s4,32(sp)
     318:	6ae2                	ld	s5,24(sp)
     31a:	6b42                	ld	s6,16(sp)
     31c:	6ba2                	ld	s7,8(sp)
     31e:	6c02                	ld	s8,0(sp)
     320:	6161                	addi	sp,sp,80
     322:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     324:	85e2                	mv	a1,s8
     326:	00006517          	auipc	a0,0x6
     32a:	e0250513          	addi	a0,a0,-510 # 6128 <malloc+0x1e2>
     32e:	00006097          	auipc	ra,0x6
     332:	b5c080e7          	jalr	-1188(ra) # 5e8a <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	7ec080e7          	jalr	2028(ra) # 5b24 <exit>
      if(cc != sz){
     340:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     342:	86aa                	mv	a3,a0
     344:	864e                	mv	a2,s3
     346:	85e2                	mv	a1,s8
     348:	00006517          	auipc	a0,0x6
     34c:	e0050513          	addi	a0,a0,-512 # 6148 <malloc+0x202>
     350:	00006097          	auipc	ra,0x6
     354:	b3a080e7          	jalr	-1222(ra) # 5e8a <printf>
        exit(1);
     358:	4505                	li	a0,1
     35a:	00005097          	auipc	ra,0x5
     35e:	7ca080e7          	jalr	1994(ra) # 5b24 <exit>

0000000000000362 <copyin>:
{
     362:	7159                	addi	sp,sp,-112
     364:	f486                	sd	ra,104(sp)
     366:	f0a2                	sd	s0,96(sp)
     368:	eca6                	sd	s1,88(sp)
     36a:	e8ca                	sd	s2,80(sp)
     36c:	e4ce                	sd	s3,72(sp)
     36e:	e0d2                	sd	s4,64(sp)
     370:	fc56                	sd	s5,56(sp)
     372:	f85a                	sd	s6,48(sp)
     374:	f45e                	sd	s7,40(sp)
     376:	f062                	sd	s8,32(sp)
     378:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     37a:	4785                	li	a5,1
     37c:	07fe                	slli	a5,a5,0x1f
     37e:	faf43023          	sd	a5,-96(s0)
     382:	57fd                	li	a5,-1
     384:	faf43423          	sd	a5,-88(s0)
  for(int ai = 0; ai < 2; ai++){
     388:	fa040913          	addi	s2,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     38c:	20100b93          	li	s7,513
     390:	00006a97          	auipc	s5,0x6
     394:	dd0a8a93          	addi	s5,s5,-560 # 6160 <malloc+0x21a>
    int n = write(fd, (void*)addr, 8192);
     398:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     39a:	4b05                	li	s6,1
    if(pipe(fds) < 0){
     39c:	f9840c13          	addi	s8,s0,-104
    uint64 addr = addrs[ai];
     3a0:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     3a4:	85de                	mv	a1,s7
     3a6:	8556                	mv	a0,s5
     3a8:	00005097          	auipc	ra,0x5
     3ac:	7bc080e7          	jalr	1980(ra) # 5b64 <open>
     3b0:	84aa                	mv	s1,a0
    if(fd < 0){
     3b2:	08054b63          	bltz	a0,448 <copyin+0xe6>
    int n = write(fd, (void*)addr, 8192);
     3b6:	8652                	mv	a2,s4
     3b8:	85ce                	mv	a1,s3
     3ba:	00005097          	auipc	ra,0x5
     3be:	78a080e7          	jalr	1930(ra) # 5b44 <write>
    if(n >= 0){
     3c2:	0a055063          	bgez	a0,462 <copyin+0x100>
    close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	00005097          	auipc	ra,0x5
     3cc:	784080e7          	jalr	1924(ra) # 5b4c <close>
    unlink("copyin1");
     3d0:	8556                	mv	a0,s5
     3d2:	00005097          	auipc	ra,0x5
     3d6:	7a2080e7          	jalr	1954(ra) # 5b74 <unlink>
    n = write(1, (char*)addr, 8192);
     3da:	8652                	mv	a2,s4
     3dc:	85ce                	mv	a1,s3
     3de:	855a                	mv	a0,s6
     3e0:	00005097          	auipc	ra,0x5
     3e4:	764080e7          	jalr	1892(ra) # 5b44 <write>
    if(n > 0){
     3e8:	08a04c63          	bgtz	a0,480 <copyin+0x11e>
    if(pipe(fds) < 0){
     3ec:	8562                	mv	a0,s8
     3ee:	00005097          	auipc	ra,0x5
     3f2:	746080e7          	jalr	1862(ra) # 5b34 <pipe>
     3f6:	0a054463          	bltz	a0,49e <copyin+0x13c>
    n = write(fds[1], (char*)addr, 8192);
     3fa:	8652                	mv	a2,s4
     3fc:	85ce                	mv	a1,s3
     3fe:	f9c42503          	lw	a0,-100(s0)
     402:	00005097          	auipc	ra,0x5
     406:	742080e7          	jalr	1858(ra) # 5b44 <write>
    if(n > 0){
     40a:	0aa04763          	bgtz	a0,4b8 <copyin+0x156>
    close(fds[0]);
     40e:	f9842503          	lw	a0,-104(s0)
     412:	00005097          	auipc	ra,0x5
     416:	73a080e7          	jalr	1850(ra) # 5b4c <close>
    close(fds[1]);
     41a:	f9c42503          	lw	a0,-100(s0)
     41e:	00005097          	auipc	ra,0x5
     422:	72e080e7          	jalr	1838(ra) # 5b4c <close>
  for(int ai = 0; ai < 2; ai++){
     426:	0921                	addi	s2,s2,8
     428:	fb040793          	addi	a5,s0,-80
     42c:	f6f91ae3          	bne	s2,a5,3a0 <copyin+0x3e>
}
     430:	70a6                	ld	ra,104(sp)
     432:	7406                	ld	s0,96(sp)
     434:	64e6                	ld	s1,88(sp)
     436:	6946                	ld	s2,80(sp)
     438:	69a6                	ld	s3,72(sp)
     43a:	6a06                	ld	s4,64(sp)
     43c:	7ae2                	ld	s5,56(sp)
     43e:	7b42                	ld	s6,48(sp)
     440:	7ba2                	ld	s7,40(sp)
     442:	7c02                	ld	s8,32(sp)
     444:	6165                	addi	sp,sp,112
     446:	8082                	ret
      printf("open(copyin1) failed\n");
     448:	00006517          	auipc	a0,0x6
     44c:	d2050513          	addi	a0,a0,-736 # 6168 <malloc+0x222>
     450:	00006097          	auipc	ra,0x6
     454:	a3a080e7          	jalr	-1478(ra) # 5e8a <printf>
      exit(1);
     458:	4505                	li	a0,1
     45a:	00005097          	auipc	ra,0x5
     45e:	6ca080e7          	jalr	1738(ra) # 5b24 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     462:	862a                	mv	a2,a0
     464:	85ce                	mv	a1,s3
     466:	00006517          	auipc	a0,0x6
     46a:	d1a50513          	addi	a0,a0,-742 # 6180 <malloc+0x23a>
     46e:	00006097          	auipc	ra,0x6
     472:	a1c080e7          	jalr	-1508(ra) # 5e8a <printf>
      exit(1);
     476:	4505                	li	a0,1
     478:	00005097          	auipc	ra,0x5
     47c:	6ac080e7          	jalr	1708(ra) # 5b24 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     480:	862a                	mv	a2,a0
     482:	85ce                	mv	a1,s3
     484:	00006517          	auipc	a0,0x6
     488:	d2c50513          	addi	a0,a0,-724 # 61b0 <malloc+0x26a>
     48c:	00006097          	auipc	ra,0x6
     490:	9fe080e7          	jalr	-1538(ra) # 5e8a <printf>
      exit(1);
     494:	4505                	li	a0,1
     496:	00005097          	auipc	ra,0x5
     49a:	68e080e7          	jalr	1678(ra) # 5b24 <exit>
      printf("pipe() failed\n");
     49e:	00006517          	auipc	a0,0x6
     4a2:	d4250513          	addi	a0,a0,-702 # 61e0 <malloc+0x29a>
     4a6:	00006097          	auipc	ra,0x6
     4aa:	9e4080e7          	jalr	-1564(ra) # 5e8a <printf>
      exit(1);
     4ae:	4505                	li	a0,1
     4b0:	00005097          	auipc	ra,0x5
     4b4:	674080e7          	jalr	1652(ra) # 5b24 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4b8:	862a                	mv	a2,a0
     4ba:	85ce                	mv	a1,s3
     4bc:	00006517          	auipc	a0,0x6
     4c0:	d3450513          	addi	a0,a0,-716 # 61f0 <malloc+0x2aa>
     4c4:	00006097          	auipc	ra,0x6
     4c8:	9c6080e7          	jalr	-1594(ra) # 5e8a <printf>
      exit(1);
     4cc:	4505                	li	a0,1
     4ce:	00005097          	auipc	ra,0x5
     4d2:	656080e7          	jalr	1622(ra) # 5b24 <exit>

00000000000004d6 <copyout>:
{
     4d6:	7159                	addi	sp,sp,-112
     4d8:	f486                	sd	ra,104(sp)
     4da:	f0a2                	sd	s0,96(sp)
     4dc:	eca6                	sd	s1,88(sp)
     4de:	e8ca                	sd	s2,80(sp)
     4e0:	e4ce                	sd	s3,72(sp)
     4e2:	e0d2                	sd	s4,64(sp)
     4e4:	fc56                	sd	s5,56(sp)
     4e6:	f85a                	sd	s6,48(sp)
     4e8:	f45e                	sd	s7,40(sp)
     4ea:	f062                	sd	s8,32(sp)
     4ec:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4ee:	4785                	li	a5,1
     4f0:	07fe                	slli	a5,a5,0x1f
     4f2:	faf43023          	sd	a5,-96(s0)
     4f6:	57fd                	li	a5,-1
     4f8:	faf43423          	sd	a5,-88(s0)
  for(int ai = 0; ai < 2; ai++){
     4fc:	fa040913          	addi	s2,s0,-96
    int fd = open("README", 0);
     500:	00006b97          	auipc	s7,0x6
     504:	d20b8b93          	addi	s7,s7,-736 # 6220 <malloc+0x2da>
    int n = read(fd, (void*)addr, 8192);
     508:	6a09                	lui	s4,0x2
    if(pipe(fds) < 0){
     50a:	f9840b13          	addi	s6,s0,-104
    n = write(fds[1], "x", 1);
     50e:	4a85                	li	s5,1
     510:	00006c17          	auipc	s8,0x6
     514:	bd8c0c13          	addi	s8,s8,-1064 # 60e8 <malloc+0x1a2>
    uint64 addr = addrs[ai];
     518:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     51c:	4581                	li	a1,0
     51e:	855e                	mv	a0,s7
     520:	00005097          	auipc	ra,0x5
     524:	644080e7          	jalr	1604(ra) # 5b64 <open>
     528:	84aa                	mv	s1,a0
    if(fd < 0){
     52a:	08054763          	bltz	a0,5b8 <copyout+0xe2>
    int n = read(fd, (void*)addr, 8192);
     52e:	8652                	mv	a2,s4
     530:	85ce                	mv	a1,s3
     532:	00005097          	auipc	ra,0x5
     536:	60a080e7          	jalr	1546(ra) # 5b3c <read>
    if(n > 0){
     53a:	08a04c63          	bgtz	a0,5d2 <copyout+0xfc>
    close(fd);
     53e:	8526                	mv	a0,s1
     540:	00005097          	auipc	ra,0x5
     544:	60c080e7          	jalr	1548(ra) # 5b4c <close>
    if(pipe(fds) < 0){
     548:	855a                	mv	a0,s6
     54a:	00005097          	auipc	ra,0x5
     54e:	5ea080e7          	jalr	1514(ra) # 5b34 <pipe>
     552:	08054f63          	bltz	a0,5f0 <copyout+0x11a>
    n = write(fds[1], "x", 1);
     556:	8656                	mv	a2,s5
     558:	85e2                	mv	a1,s8
     55a:	f9c42503          	lw	a0,-100(s0)
     55e:	00005097          	auipc	ra,0x5
     562:	5e6080e7          	jalr	1510(ra) # 5b44 <write>
    if(n != 1){
     566:	0b551263          	bne	a0,s5,60a <copyout+0x134>
    n = read(fds[0], (void*)addr, 8192);
     56a:	8652                	mv	a2,s4
     56c:	85ce                	mv	a1,s3
     56e:	f9842503          	lw	a0,-104(s0)
     572:	00005097          	auipc	ra,0x5
     576:	5ca080e7          	jalr	1482(ra) # 5b3c <read>
    if(n > 0){
     57a:	0aa04563          	bgtz	a0,624 <copyout+0x14e>
    close(fds[0]);
     57e:	f9842503          	lw	a0,-104(s0)
     582:	00005097          	auipc	ra,0x5
     586:	5ca080e7          	jalr	1482(ra) # 5b4c <close>
    close(fds[1]);
     58a:	f9c42503          	lw	a0,-100(s0)
     58e:	00005097          	auipc	ra,0x5
     592:	5be080e7          	jalr	1470(ra) # 5b4c <close>
  for(int ai = 0; ai < 2; ai++){
     596:	0921                	addi	s2,s2,8
     598:	fb040793          	addi	a5,s0,-80
     59c:	f6f91ee3          	bne	s2,a5,518 <copyout+0x42>
}
     5a0:	70a6                	ld	ra,104(sp)
     5a2:	7406                	ld	s0,96(sp)
     5a4:	64e6                	ld	s1,88(sp)
     5a6:	6946                	ld	s2,80(sp)
     5a8:	69a6                	ld	s3,72(sp)
     5aa:	6a06                	ld	s4,64(sp)
     5ac:	7ae2                	ld	s5,56(sp)
     5ae:	7b42                	ld	s6,48(sp)
     5b0:	7ba2                	ld	s7,40(sp)
     5b2:	7c02                	ld	s8,32(sp)
     5b4:	6165                	addi	sp,sp,112
     5b6:	8082                	ret
      printf("open(README) failed\n");
     5b8:	00006517          	auipc	a0,0x6
     5bc:	c7050513          	addi	a0,a0,-912 # 6228 <malloc+0x2e2>
     5c0:	00006097          	auipc	ra,0x6
     5c4:	8ca080e7          	jalr	-1846(ra) # 5e8a <printf>
      exit(1);
     5c8:	4505                	li	a0,1
     5ca:	00005097          	auipc	ra,0x5
     5ce:	55a080e7          	jalr	1370(ra) # 5b24 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5d2:	862a                	mv	a2,a0
     5d4:	85ce                	mv	a1,s3
     5d6:	00006517          	auipc	a0,0x6
     5da:	c6a50513          	addi	a0,a0,-918 # 6240 <malloc+0x2fa>
     5de:	00006097          	auipc	ra,0x6
     5e2:	8ac080e7          	jalr	-1876(ra) # 5e8a <printf>
      exit(1);
     5e6:	4505                	li	a0,1
     5e8:	00005097          	auipc	ra,0x5
     5ec:	53c080e7          	jalr	1340(ra) # 5b24 <exit>
      printf("pipe() failed\n");
     5f0:	00006517          	auipc	a0,0x6
     5f4:	bf050513          	addi	a0,a0,-1040 # 61e0 <malloc+0x29a>
     5f8:	00006097          	auipc	ra,0x6
     5fc:	892080e7          	jalr	-1902(ra) # 5e8a <printf>
      exit(1);
     600:	4505                	li	a0,1
     602:	00005097          	auipc	ra,0x5
     606:	522080e7          	jalr	1314(ra) # 5b24 <exit>
      printf("pipe write failed\n");
     60a:	00006517          	auipc	a0,0x6
     60e:	c6650513          	addi	a0,a0,-922 # 6270 <malloc+0x32a>
     612:	00006097          	auipc	ra,0x6
     616:	878080e7          	jalr	-1928(ra) # 5e8a <printf>
      exit(1);
     61a:	4505                	li	a0,1
     61c:	00005097          	auipc	ra,0x5
     620:	508080e7          	jalr	1288(ra) # 5b24 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     624:	862a                	mv	a2,a0
     626:	85ce                	mv	a1,s3
     628:	00006517          	auipc	a0,0x6
     62c:	c6050513          	addi	a0,a0,-928 # 6288 <malloc+0x342>
     630:	00006097          	auipc	ra,0x6
     634:	85a080e7          	jalr	-1958(ra) # 5e8a <printf>
      exit(1);
     638:	4505                	li	a0,1
     63a:	00005097          	auipc	ra,0x5
     63e:	4ea080e7          	jalr	1258(ra) # 5b24 <exit>

0000000000000642 <truncate1>:
{
     642:	711d                	addi	sp,sp,-96
     644:	ec86                	sd	ra,88(sp)
     646:	e8a2                	sd	s0,80(sp)
     648:	e4a6                	sd	s1,72(sp)
     64a:	e0ca                	sd	s2,64(sp)
     64c:	fc4e                	sd	s3,56(sp)
     64e:	f852                	sd	s4,48(sp)
     650:	f456                	sd	s5,40(sp)
     652:	1080                	addi	s0,sp,96
     654:	8aaa                	mv	s5,a0
  unlink("truncfile");
     656:	00006517          	auipc	a0,0x6
     65a:	a7a50513          	addi	a0,a0,-1414 # 60d0 <malloc+0x18a>
     65e:	00005097          	auipc	ra,0x5
     662:	516080e7          	jalr	1302(ra) # 5b74 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     666:	60100593          	li	a1,1537
     66a:	00006517          	auipc	a0,0x6
     66e:	a6650513          	addi	a0,a0,-1434 # 60d0 <malloc+0x18a>
     672:	00005097          	auipc	ra,0x5
     676:	4f2080e7          	jalr	1266(ra) # 5b64 <open>
     67a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     67c:	4611                	li	a2,4
     67e:	00006597          	auipc	a1,0x6
     682:	a6258593          	addi	a1,a1,-1438 # 60e0 <malloc+0x19a>
     686:	00005097          	auipc	ra,0x5
     68a:	4be080e7          	jalr	1214(ra) # 5b44 <write>
  close(fd1);
     68e:	8526                	mv	a0,s1
     690:	00005097          	auipc	ra,0x5
     694:	4bc080e7          	jalr	1212(ra) # 5b4c <close>
  int fd2 = open("truncfile", O_RDONLY);
     698:	4581                	li	a1,0
     69a:	00006517          	auipc	a0,0x6
     69e:	a3650513          	addi	a0,a0,-1482 # 60d0 <malloc+0x18a>
     6a2:	00005097          	auipc	ra,0x5
     6a6:	4c2080e7          	jalr	1218(ra) # 5b64 <open>
     6aa:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     6ac:	02000613          	li	a2,32
     6b0:	fa040593          	addi	a1,s0,-96
     6b4:	00005097          	auipc	ra,0x5
     6b8:	488080e7          	jalr	1160(ra) # 5b3c <read>
  if(n != 4){
     6bc:	4791                	li	a5,4
     6be:	0cf51e63          	bne	a0,a5,79a <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     6c2:	40100593          	li	a1,1025
     6c6:	00006517          	auipc	a0,0x6
     6ca:	a0a50513          	addi	a0,a0,-1526 # 60d0 <malloc+0x18a>
     6ce:	00005097          	auipc	ra,0x5
     6d2:	496080e7          	jalr	1174(ra) # 5b64 <open>
     6d6:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6d8:	4581                	li	a1,0
     6da:	00006517          	auipc	a0,0x6
     6de:	9f650513          	addi	a0,a0,-1546 # 60d0 <malloc+0x18a>
     6e2:	00005097          	auipc	ra,0x5
     6e6:	482080e7          	jalr	1154(ra) # 5b64 <open>
     6ea:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6ec:	02000613          	li	a2,32
     6f0:	fa040593          	addi	a1,s0,-96
     6f4:	00005097          	auipc	ra,0x5
     6f8:	448080e7          	jalr	1096(ra) # 5b3c <read>
     6fc:	8a2a                	mv	s4,a0
  if(n != 0){
     6fe:	ed4d                	bnez	a0,7b8 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     700:	02000613          	li	a2,32
     704:	fa040593          	addi	a1,s0,-96
     708:	8526                	mv	a0,s1
     70a:	00005097          	auipc	ra,0x5
     70e:	432080e7          	jalr	1074(ra) # 5b3c <read>
     712:	8a2a                	mv	s4,a0
  if(n != 0){
     714:	e971                	bnez	a0,7e8 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     716:	4619                	li	a2,6
     718:	00006597          	auipc	a1,0x6
     71c:	c0058593          	addi	a1,a1,-1024 # 6318 <malloc+0x3d2>
     720:	854e                	mv	a0,s3
     722:	00005097          	auipc	ra,0x5
     726:	422080e7          	jalr	1058(ra) # 5b44 <write>
  n = read(fd3, buf, sizeof(buf));
     72a:	02000613          	li	a2,32
     72e:	fa040593          	addi	a1,s0,-96
     732:	854a                	mv	a0,s2
     734:	00005097          	auipc	ra,0x5
     738:	408080e7          	jalr	1032(ra) # 5b3c <read>
  if(n != 6){
     73c:	4799                	li	a5,6
     73e:	0cf51d63          	bne	a0,a5,818 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     742:	02000613          	li	a2,32
     746:	fa040593          	addi	a1,s0,-96
     74a:	8526                	mv	a0,s1
     74c:	00005097          	auipc	ra,0x5
     750:	3f0080e7          	jalr	1008(ra) # 5b3c <read>
  if(n != 2){
     754:	4789                	li	a5,2
     756:	0ef51063          	bne	a0,a5,836 <truncate1+0x1f4>
  unlink("truncfile");
     75a:	00006517          	auipc	a0,0x6
     75e:	97650513          	addi	a0,a0,-1674 # 60d0 <malloc+0x18a>
     762:	00005097          	auipc	ra,0x5
     766:	412080e7          	jalr	1042(ra) # 5b74 <unlink>
  close(fd1);
     76a:	854e                	mv	a0,s3
     76c:	00005097          	auipc	ra,0x5
     770:	3e0080e7          	jalr	992(ra) # 5b4c <close>
  close(fd2);
     774:	8526                	mv	a0,s1
     776:	00005097          	auipc	ra,0x5
     77a:	3d6080e7          	jalr	982(ra) # 5b4c <close>
  close(fd3);
     77e:	854a                	mv	a0,s2
     780:	00005097          	auipc	ra,0x5
     784:	3cc080e7          	jalr	972(ra) # 5b4c <close>
}
     788:	60e6                	ld	ra,88(sp)
     78a:	6446                	ld	s0,80(sp)
     78c:	64a6                	ld	s1,72(sp)
     78e:	6906                	ld	s2,64(sp)
     790:	79e2                	ld	s3,56(sp)
     792:	7a42                	ld	s4,48(sp)
     794:	7aa2                	ld	s5,40(sp)
     796:	6125                	addi	sp,sp,96
     798:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     79a:	862a                	mv	a2,a0
     79c:	85d6                	mv	a1,s5
     79e:	00006517          	auipc	a0,0x6
     7a2:	b1a50513          	addi	a0,a0,-1254 # 62b8 <malloc+0x372>
     7a6:	00005097          	auipc	ra,0x5
     7aa:	6e4080e7          	jalr	1764(ra) # 5e8a <printf>
    exit(1);
     7ae:	4505                	li	a0,1
     7b0:	00005097          	auipc	ra,0x5
     7b4:	374080e7          	jalr	884(ra) # 5b24 <exit>
    printf("aaa fd3=%d\n", fd3);
     7b8:	85ca                	mv	a1,s2
     7ba:	00006517          	auipc	a0,0x6
     7be:	b1e50513          	addi	a0,a0,-1250 # 62d8 <malloc+0x392>
     7c2:	00005097          	auipc	ra,0x5
     7c6:	6c8080e7          	jalr	1736(ra) # 5e8a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7ca:	8652                	mv	a2,s4
     7cc:	85d6                	mv	a1,s5
     7ce:	00006517          	auipc	a0,0x6
     7d2:	b1a50513          	addi	a0,a0,-1254 # 62e8 <malloc+0x3a2>
     7d6:	00005097          	auipc	ra,0x5
     7da:	6b4080e7          	jalr	1716(ra) # 5e8a <printf>
    exit(1);
     7de:	4505                	li	a0,1
     7e0:	00005097          	auipc	ra,0x5
     7e4:	344080e7          	jalr	836(ra) # 5b24 <exit>
    printf("bbb fd2=%d\n", fd2);
     7e8:	85a6                	mv	a1,s1
     7ea:	00006517          	auipc	a0,0x6
     7ee:	b1e50513          	addi	a0,a0,-1250 # 6308 <malloc+0x3c2>
     7f2:	00005097          	auipc	ra,0x5
     7f6:	698080e7          	jalr	1688(ra) # 5e8a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7fa:	8652                	mv	a2,s4
     7fc:	85d6                	mv	a1,s5
     7fe:	00006517          	auipc	a0,0x6
     802:	aea50513          	addi	a0,a0,-1302 # 62e8 <malloc+0x3a2>
     806:	00005097          	auipc	ra,0x5
     80a:	684080e7          	jalr	1668(ra) # 5e8a <printf>
    exit(1);
     80e:	4505                	li	a0,1
     810:	00005097          	auipc	ra,0x5
     814:	314080e7          	jalr	788(ra) # 5b24 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     818:	862a                	mv	a2,a0
     81a:	85d6                	mv	a1,s5
     81c:	00006517          	auipc	a0,0x6
     820:	b0450513          	addi	a0,a0,-1276 # 6320 <malloc+0x3da>
     824:	00005097          	auipc	ra,0x5
     828:	666080e7          	jalr	1638(ra) # 5e8a <printf>
    exit(1);
     82c:	4505                	li	a0,1
     82e:	00005097          	auipc	ra,0x5
     832:	2f6080e7          	jalr	758(ra) # 5b24 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     836:	862a                	mv	a2,a0
     838:	85d6                	mv	a1,s5
     83a:	00006517          	auipc	a0,0x6
     83e:	b0650513          	addi	a0,a0,-1274 # 6340 <malloc+0x3fa>
     842:	00005097          	auipc	ra,0x5
     846:	648080e7          	jalr	1608(ra) # 5e8a <printf>
    exit(1);
     84a:	4505                	li	a0,1
     84c:	00005097          	auipc	ra,0x5
     850:	2d8080e7          	jalr	728(ra) # 5b24 <exit>

0000000000000854 <writetest>:
{
     854:	715d                	addi	sp,sp,-80
     856:	e486                	sd	ra,72(sp)
     858:	e0a2                	sd	s0,64(sp)
     85a:	fc26                	sd	s1,56(sp)
     85c:	f84a                	sd	s2,48(sp)
     85e:	f44e                	sd	s3,40(sp)
     860:	f052                	sd	s4,32(sp)
     862:	ec56                	sd	s5,24(sp)
     864:	e85a                	sd	s6,16(sp)
     866:	e45e                	sd	s7,8(sp)
     868:	0880                	addi	s0,sp,80
     86a:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     86c:	20200593          	li	a1,514
     870:	00006517          	auipc	a0,0x6
     874:	af050513          	addi	a0,a0,-1296 # 6360 <malloc+0x41a>
     878:	00005097          	auipc	ra,0x5
     87c:	2ec080e7          	jalr	748(ra) # 5b64 <open>
  if(fd < 0){
     880:	0a054d63          	bltz	a0,93a <writetest+0xe6>
     884:	89aa                	mv	s3,a0
     886:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     888:	44a9                	li	s1,10
     88a:	00006a17          	auipc	s4,0x6
     88e:	afea0a13          	addi	s4,s4,-1282 # 6388 <malloc+0x442>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     892:	00006b17          	auipc	s6,0x6
     896:	b2eb0b13          	addi	s6,s6,-1234 # 63c0 <malloc+0x47a>
  for(i = 0; i < N; i++){
     89a:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     89e:	8626                	mv	a2,s1
     8a0:	85d2                	mv	a1,s4
     8a2:	854e                	mv	a0,s3
     8a4:	00005097          	auipc	ra,0x5
     8a8:	2a0080e7          	jalr	672(ra) # 5b44 <write>
     8ac:	0a951563          	bne	a0,s1,956 <writetest+0x102>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b0:	8626                	mv	a2,s1
     8b2:	85da                	mv	a1,s6
     8b4:	854e                	mv	a0,s3
     8b6:	00005097          	auipc	ra,0x5
     8ba:	28e080e7          	jalr	654(ra) # 5b44 <write>
     8be:	0a951b63          	bne	a0,s1,974 <writetest+0x120>
  for(i = 0; i < N; i++){
     8c2:	2905                	addiw	s2,s2,1
     8c4:	fd591de3          	bne	s2,s5,89e <writetest+0x4a>
  close(fd);
     8c8:	854e                	mv	a0,s3
     8ca:	00005097          	auipc	ra,0x5
     8ce:	282080e7          	jalr	642(ra) # 5b4c <close>
  fd = open("small", O_RDONLY);
     8d2:	4581                	li	a1,0
     8d4:	00006517          	auipc	a0,0x6
     8d8:	a8c50513          	addi	a0,a0,-1396 # 6360 <malloc+0x41a>
     8dc:	00005097          	auipc	ra,0x5
     8e0:	288080e7          	jalr	648(ra) # 5b64 <open>
     8e4:	84aa                	mv	s1,a0
  if(fd < 0){
     8e6:	0a054663          	bltz	a0,992 <writetest+0x13e>
  i = read(fd, buf, N*SZ*2);
     8ea:	7d000613          	li	a2,2000
     8ee:	0000b597          	auipc	a1,0xb
     8f2:	7c258593          	addi	a1,a1,1986 # c0b0 <buf>
     8f6:	00005097          	auipc	ra,0x5
     8fa:	246080e7          	jalr	582(ra) # 5b3c <read>
  if(i != N*SZ*2){
     8fe:	7d000793          	li	a5,2000
     902:	0af51663          	bne	a0,a5,9ae <writetest+0x15a>
  close(fd);
     906:	8526                	mv	a0,s1
     908:	00005097          	auipc	ra,0x5
     90c:	244080e7          	jalr	580(ra) # 5b4c <close>
  if(unlink("small") < 0){
     910:	00006517          	auipc	a0,0x6
     914:	a5050513          	addi	a0,a0,-1456 # 6360 <malloc+0x41a>
     918:	00005097          	auipc	ra,0x5
     91c:	25c080e7          	jalr	604(ra) # 5b74 <unlink>
     920:	0a054563          	bltz	a0,9ca <writetest+0x176>
}
     924:	60a6                	ld	ra,72(sp)
     926:	6406                	ld	s0,64(sp)
     928:	74e2                	ld	s1,56(sp)
     92a:	7942                	ld	s2,48(sp)
     92c:	79a2                	ld	s3,40(sp)
     92e:	7a02                	ld	s4,32(sp)
     930:	6ae2                	ld	s5,24(sp)
     932:	6b42                	ld	s6,16(sp)
     934:	6ba2                	ld	s7,8(sp)
     936:	6161                	addi	sp,sp,80
     938:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     93a:	85de                	mv	a1,s7
     93c:	00006517          	auipc	a0,0x6
     940:	a2c50513          	addi	a0,a0,-1492 # 6368 <malloc+0x422>
     944:	00005097          	auipc	ra,0x5
     948:	546080e7          	jalr	1350(ra) # 5e8a <printf>
    exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	1d6080e7          	jalr	470(ra) # 5b24 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	864a                	mv	a2,s2
     958:	85de                	mv	a1,s7
     95a:	00006517          	auipc	a0,0x6
     95e:	a3e50513          	addi	a0,a0,-1474 # 6398 <malloc+0x452>
     962:	00005097          	auipc	ra,0x5
     966:	528080e7          	jalr	1320(ra) # 5e8a <printf>
      exit(1);
     96a:	4505                	li	a0,1
     96c:	00005097          	auipc	ra,0x5
     970:	1b8080e7          	jalr	440(ra) # 5b24 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     974:	864a                	mv	a2,s2
     976:	85de                	mv	a1,s7
     978:	00006517          	auipc	a0,0x6
     97c:	a5850513          	addi	a0,a0,-1448 # 63d0 <malloc+0x48a>
     980:	00005097          	auipc	ra,0x5
     984:	50a080e7          	jalr	1290(ra) # 5e8a <printf>
      exit(1);
     988:	4505                	li	a0,1
     98a:	00005097          	auipc	ra,0x5
     98e:	19a080e7          	jalr	410(ra) # 5b24 <exit>
    printf("%s: error: open small failed!\n", s);
     992:	85de                	mv	a1,s7
     994:	00006517          	auipc	a0,0x6
     998:	a6450513          	addi	a0,a0,-1436 # 63f8 <malloc+0x4b2>
     99c:	00005097          	auipc	ra,0x5
     9a0:	4ee080e7          	jalr	1262(ra) # 5e8a <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	00005097          	auipc	ra,0x5
     9aa:	17e080e7          	jalr	382(ra) # 5b24 <exit>
    printf("%s: read failed\n", s);
     9ae:	85de                	mv	a1,s7
     9b0:	00006517          	auipc	a0,0x6
     9b4:	a6850513          	addi	a0,a0,-1432 # 6418 <malloc+0x4d2>
     9b8:	00005097          	auipc	ra,0x5
     9bc:	4d2080e7          	jalr	1234(ra) # 5e8a <printf>
    exit(1);
     9c0:	4505                	li	a0,1
     9c2:	00005097          	auipc	ra,0x5
     9c6:	162080e7          	jalr	354(ra) # 5b24 <exit>
    printf("%s: unlink small failed\n", s);
     9ca:	85de                	mv	a1,s7
     9cc:	00006517          	auipc	a0,0x6
     9d0:	a6450513          	addi	a0,a0,-1436 # 6430 <malloc+0x4ea>
     9d4:	00005097          	auipc	ra,0x5
     9d8:	4b6080e7          	jalr	1206(ra) # 5e8a <printf>
    exit(1);
     9dc:	4505                	li	a0,1
     9de:	00005097          	auipc	ra,0x5
     9e2:	146080e7          	jalr	326(ra) # 5b24 <exit>

00000000000009e6 <writebig>:
{
     9e6:	7139                	addi	sp,sp,-64
     9e8:	fc06                	sd	ra,56(sp)
     9ea:	f822                	sd	s0,48(sp)
     9ec:	f426                	sd	s1,40(sp)
     9ee:	f04a                	sd	s2,32(sp)
     9f0:	ec4e                	sd	s3,24(sp)
     9f2:	e852                	sd	s4,16(sp)
     9f4:	e456                	sd	s5,8(sp)
     9f6:	e05a                	sd	s6,0(sp)
     9f8:	0080                	addi	s0,sp,64
     9fa:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     9fc:	20200593          	li	a1,514
     a00:	00006517          	auipc	a0,0x6
     a04:	a5050513          	addi	a0,a0,-1456 # 6450 <malloc+0x50a>
     a08:	00005097          	auipc	ra,0x5
     a0c:	15c080e7          	jalr	348(ra) # 5b64 <open>
  if(fd < 0){
     a10:	08054263          	bltz	a0,a94 <writebig+0xae>
     a14:	8a2a                	mv	s4,a0
     a16:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     a18:	0000b997          	auipc	s3,0xb
     a1c:	69898993          	addi	s3,s3,1688 # c0b0 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     a20:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     a24:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
     a28:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     a2c:	864a                	mv	a2,s2
     a2e:	85ce                	mv	a1,s3
     a30:	8552                	mv	a0,s4
     a32:	00005097          	auipc	ra,0x5
     a36:	112080e7          	jalr	274(ra) # 5b44 <write>
     a3a:	07251b63          	bne	a0,s2,ab0 <writebig+0xca>
  for(i = 0; i < MAXFILE; i++){
     a3e:	2485                	addiw	s1,s1,1
     a40:	ff5494e3          	bne	s1,s5,a28 <writebig+0x42>
  close(fd);
     a44:	8552                	mv	a0,s4
     a46:	00005097          	auipc	ra,0x5
     a4a:	106080e7          	jalr	262(ra) # 5b4c <close>
  fd = open("big", O_RDONLY);
     a4e:	4581                	li	a1,0
     a50:	00006517          	auipc	a0,0x6
     a54:	a0050513          	addi	a0,a0,-1536 # 6450 <malloc+0x50a>
     a58:	00005097          	auipc	ra,0x5
     a5c:	10c080e7          	jalr	268(ra) # 5b64 <open>
     a60:	8a2a                	mv	s4,a0
  n = 0;
     a62:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a64:	40000993          	li	s3,1024
     a68:	0000b917          	auipc	s2,0xb
     a6c:	64890913          	addi	s2,s2,1608 # c0b0 <buf>
  if(fd < 0){
     a70:	04054f63          	bltz	a0,ace <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a74:	864e                	mv	a2,s3
     a76:	85ca                	mv	a1,s2
     a78:	8552                	mv	a0,s4
     a7a:	00005097          	auipc	ra,0x5
     a7e:	0c2080e7          	jalr	194(ra) # 5b3c <read>
    if(i == 0){
     a82:	c525                	beqz	a0,aea <writebig+0x104>
    } else if(i != BSIZE){
     a84:	0b351f63          	bne	a0,s3,b42 <writebig+0x15c>
    if(((int*)buf)[0] != n){
     a88:	00092683          	lw	a3,0(s2)
     a8c:	0c969a63          	bne	a3,s1,b60 <writebig+0x17a>
    n++;
     a90:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a92:	b7cd                	j	a74 <writebig+0x8e>
    printf("%s: error: creat big failed!\n", s);
     a94:	85da                	mv	a1,s6
     a96:	00006517          	auipc	a0,0x6
     a9a:	9c250513          	addi	a0,a0,-1598 # 6458 <malloc+0x512>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	3ec080e7          	jalr	1004(ra) # 5e8a <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	07c080e7          	jalr	124(ra) # 5b24 <exit>
      printf("%s: error: write big file failed\n", s, i);
     ab0:	8626                	mv	a2,s1
     ab2:	85da                	mv	a1,s6
     ab4:	00006517          	auipc	a0,0x6
     ab8:	9c450513          	addi	a0,a0,-1596 # 6478 <malloc+0x532>
     abc:	00005097          	auipc	ra,0x5
     ac0:	3ce080e7          	jalr	974(ra) # 5e8a <printf>
      exit(1);
     ac4:	4505                	li	a0,1
     ac6:	00005097          	auipc	ra,0x5
     aca:	05e080e7          	jalr	94(ra) # 5b24 <exit>
    printf("%s: error: open big failed!\n", s);
     ace:	85da                	mv	a1,s6
     ad0:	00006517          	auipc	a0,0x6
     ad4:	9d050513          	addi	a0,a0,-1584 # 64a0 <malloc+0x55a>
     ad8:	00005097          	auipc	ra,0x5
     adc:	3b2080e7          	jalr	946(ra) # 5e8a <printf>
    exit(1);
     ae0:	4505                	li	a0,1
     ae2:	00005097          	auipc	ra,0x5
     ae6:	042080e7          	jalr	66(ra) # 5b24 <exit>
      if(n == MAXFILE - 1){
     aea:	10b00793          	li	a5,267
     aee:	02f48b63          	beq	s1,a5,b24 <writebig+0x13e>
  close(fd);
     af2:	8552                	mv	a0,s4
     af4:	00005097          	auipc	ra,0x5
     af8:	058080e7          	jalr	88(ra) # 5b4c <close>
  if(unlink("big") < 0){
     afc:	00006517          	auipc	a0,0x6
     b00:	95450513          	addi	a0,a0,-1708 # 6450 <malloc+0x50a>
     b04:	00005097          	auipc	ra,0x5
     b08:	070080e7          	jalr	112(ra) # 5b74 <unlink>
     b0c:	06054963          	bltz	a0,b7e <writebig+0x198>
}
     b10:	70e2                	ld	ra,56(sp)
     b12:	7442                	ld	s0,48(sp)
     b14:	74a2                	ld	s1,40(sp)
     b16:	7902                	ld	s2,32(sp)
     b18:	69e2                	ld	s3,24(sp)
     b1a:	6a42                	ld	s4,16(sp)
     b1c:	6aa2                	ld	s5,8(sp)
     b1e:	6b02                	ld	s6,0(sp)
     b20:	6121                	addi	sp,sp,64
     b22:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b24:	863e                	mv	a2,a5
     b26:	85da                	mv	a1,s6
     b28:	00006517          	auipc	a0,0x6
     b2c:	99850513          	addi	a0,a0,-1640 # 64c0 <malloc+0x57a>
     b30:	00005097          	auipc	ra,0x5
     b34:	35a080e7          	jalr	858(ra) # 5e8a <printf>
        exit(1);
     b38:	4505                	li	a0,1
     b3a:	00005097          	auipc	ra,0x5
     b3e:	fea080e7          	jalr	-22(ra) # 5b24 <exit>
      printf("%s: read failed %d\n", s, i);
     b42:	862a                	mv	a2,a0
     b44:	85da                	mv	a1,s6
     b46:	00006517          	auipc	a0,0x6
     b4a:	9a250513          	addi	a0,a0,-1630 # 64e8 <malloc+0x5a2>
     b4e:	00005097          	auipc	ra,0x5
     b52:	33c080e7          	jalr	828(ra) # 5e8a <printf>
      exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	fcc080e7          	jalr	-52(ra) # 5b24 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b60:	8626                	mv	a2,s1
     b62:	85da                	mv	a1,s6
     b64:	00006517          	auipc	a0,0x6
     b68:	99c50513          	addi	a0,a0,-1636 # 6500 <malloc+0x5ba>
     b6c:	00005097          	auipc	ra,0x5
     b70:	31e080e7          	jalr	798(ra) # 5e8a <printf>
      exit(1);
     b74:	4505                	li	a0,1
     b76:	00005097          	auipc	ra,0x5
     b7a:	fae080e7          	jalr	-82(ra) # 5b24 <exit>
    printf("%s: unlink big failed\n", s);
     b7e:	85da                	mv	a1,s6
     b80:	00006517          	auipc	a0,0x6
     b84:	9a850513          	addi	a0,a0,-1624 # 6528 <malloc+0x5e2>
     b88:	00005097          	auipc	ra,0x5
     b8c:	302080e7          	jalr	770(ra) # 5e8a <printf>
    exit(1);
     b90:	4505                	li	a0,1
     b92:	00005097          	auipc	ra,0x5
     b96:	f92080e7          	jalr	-110(ra) # 5b24 <exit>

0000000000000b9a <unlinkread>:
{
     b9a:	7179                	addi	sp,sp,-48
     b9c:	f406                	sd	ra,40(sp)
     b9e:	f022                	sd	s0,32(sp)
     ba0:	ec26                	sd	s1,24(sp)
     ba2:	e84a                	sd	s2,16(sp)
     ba4:	e44e                	sd	s3,8(sp)
     ba6:	1800                	addi	s0,sp,48
     ba8:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     baa:	20200593          	li	a1,514
     bae:	00006517          	auipc	a0,0x6
     bb2:	99250513          	addi	a0,a0,-1646 # 6540 <malloc+0x5fa>
     bb6:	00005097          	auipc	ra,0x5
     bba:	fae080e7          	jalr	-82(ra) # 5b64 <open>
  if(fd < 0){
     bbe:	0e054563          	bltz	a0,ca8 <unlinkread+0x10e>
     bc2:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     bc4:	4615                	li	a2,5
     bc6:	00006597          	auipc	a1,0x6
     bca:	9aa58593          	addi	a1,a1,-1622 # 6570 <malloc+0x62a>
     bce:	00005097          	auipc	ra,0x5
     bd2:	f76080e7          	jalr	-138(ra) # 5b44 <write>
  close(fd);
     bd6:	8526                	mv	a0,s1
     bd8:	00005097          	auipc	ra,0x5
     bdc:	f74080e7          	jalr	-140(ra) # 5b4c <close>
  fd = open("unlinkread", O_RDWR);
     be0:	4589                	li	a1,2
     be2:	00006517          	auipc	a0,0x6
     be6:	95e50513          	addi	a0,a0,-1698 # 6540 <malloc+0x5fa>
     bea:	00005097          	auipc	ra,0x5
     bee:	f7a080e7          	jalr	-134(ra) # 5b64 <open>
     bf2:	84aa                	mv	s1,a0
  if(fd < 0){
     bf4:	0c054863          	bltz	a0,cc4 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bf8:	00006517          	auipc	a0,0x6
     bfc:	94850513          	addi	a0,a0,-1720 # 6540 <malloc+0x5fa>
     c00:	00005097          	auipc	ra,0x5
     c04:	f74080e7          	jalr	-140(ra) # 5b74 <unlink>
     c08:	ed61                	bnez	a0,ce0 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     c0a:	20200593          	li	a1,514
     c0e:	00006517          	auipc	a0,0x6
     c12:	93250513          	addi	a0,a0,-1742 # 6540 <malloc+0x5fa>
     c16:	00005097          	auipc	ra,0x5
     c1a:	f4e080e7          	jalr	-178(ra) # 5b64 <open>
     c1e:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     c20:	460d                	li	a2,3
     c22:	00006597          	auipc	a1,0x6
     c26:	99658593          	addi	a1,a1,-1642 # 65b8 <malloc+0x672>
     c2a:	00005097          	auipc	ra,0x5
     c2e:	f1a080e7          	jalr	-230(ra) # 5b44 <write>
  close(fd1);
     c32:	854a                	mv	a0,s2
     c34:	00005097          	auipc	ra,0x5
     c38:	f18080e7          	jalr	-232(ra) # 5b4c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c3c:	660d                	lui	a2,0x3
     c3e:	0000b597          	auipc	a1,0xb
     c42:	47258593          	addi	a1,a1,1138 # c0b0 <buf>
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	ef4080e7          	jalr	-268(ra) # 5b3c <read>
     c50:	4795                	li	a5,5
     c52:	0af51563          	bne	a0,a5,cfc <unlinkread+0x162>
  if(buf[0] != 'h'){
     c56:	0000b717          	auipc	a4,0xb
     c5a:	45a74703          	lbu	a4,1114(a4) # c0b0 <buf>
     c5e:	06800793          	li	a5,104
     c62:	0af71b63          	bne	a4,a5,d18 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c66:	4629                	li	a2,10
     c68:	0000b597          	auipc	a1,0xb
     c6c:	44858593          	addi	a1,a1,1096 # c0b0 <buf>
     c70:	8526                	mv	a0,s1
     c72:	00005097          	auipc	ra,0x5
     c76:	ed2080e7          	jalr	-302(ra) # 5b44 <write>
     c7a:	47a9                	li	a5,10
     c7c:	0af51c63          	bne	a0,a5,d34 <unlinkread+0x19a>
  close(fd);
     c80:	8526                	mv	a0,s1
     c82:	00005097          	auipc	ra,0x5
     c86:	eca080e7          	jalr	-310(ra) # 5b4c <close>
  unlink("unlinkread");
     c8a:	00006517          	auipc	a0,0x6
     c8e:	8b650513          	addi	a0,a0,-1866 # 6540 <malloc+0x5fa>
     c92:	00005097          	auipc	ra,0x5
     c96:	ee2080e7          	jalr	-286(ra) # 5b74 <unlink>
}
     c9a:	70a2                	ld	ra,40(sp)
     c9c:	7402                	ld	s0,32(sp)
     c9e:	64e2                	ld	s1,24(sp)
     ca0:	6942                	ld	s2,16(sp)
     ca2:	69a2                	ld	s3,8(sp)
     ca4:	6145                	addi	sp,sp,48
     ca6:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     ca8:	85ce                	mv	a1,s3
     caa:	00006517          	auipc	a0,0x6
     cae:	8a650513          	addi	a0,a0,-1882 # 6550 <malloc+0x60a>
     cb2:	00005097          	auipc	ra,0x5
     cb6:	1d8080e7          	jalr	472(ra) # 5e8a <printf>
    exit(1);
     cba:	4505                	li	a0,1
     cbc:	00005097          	auipc	ra,0x5
     cc0:	e68080e7          	jalr	-408(ra) # 5b24 <exit>
    printf("%s: open unlinkread failed\n", s);
     cc4:	85ce                	mv	a1,s3
     cc6:	00006517          	auipc	a0,0x6
     cca:	8b250513          	addi	a0,a0,-1870 # 6578 <malloc+0x632>
     cce:	00005097          	auipc	ra,0x5
     cd2:	1bc080e7          	jalr	444(ra) # 5e8a <printf>
    exit(1);
     cd6:	4505                	li	a0,1
     cd8:	00005097          	auipc	ra,0x5
     cdc:	e4c080e7          	jalr	-436(ra) # 5b24 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ce0:	85ce                	mv	a1,s3
     ce2:	00006517          	auipc	a0,0x6
     ce6:	8b650513          	addi	a0,a0,-1866 # 6598 <malloc+0x652>
     cea:	00005097          	auipc	ra,0x5
     cee:	1a0080e7          	jalr	416(ra) # 5e8a <printf>
    exit(1);
     cf2:	4505                	li	a0,1
     cf4:	00005097          	auipc	ra,0x5
     cf8:	e30080e7          	jalr	-464(ra) # 5b24 <exit>
    printf("%s: unlinkread read failed", s);
     cfc:	85ce                	mv	a1,s3
     cfe:	00006517          	auipc	a0,0x6
     d02:	8c250513          	addi	a0,a0,-1854 # 65c0 <malloc+0x67a>
     d06:	00005097          	auipc	ra,0x5
     d0a:	184080e7          	jalr	388(ra) # 5e8a <printf>
    exit(1);
     d0e:	4505                	li	a0,1
     d10:	00005097          	auipc	ra,0x5
     d14:	e14080e7          	jalr	-492(ra) # 5b24 <exit>
    printf("%s: unlinkread wrong data\n", s);
     d18:	85ce                	mv	a1,s3
     d1a:	00006517          	auipc	a0,0x6
     d1e:	8c650513          	addi	a0,a0,-1850 # 65e0 <malloc+0x69a>
     d22:	00005097          	auipc	ra,0x5
     d26:	168080e7          	jalr	360(ra) # 5e8a <printf>
    exit(1);
     d2a:	4505                	li	a0,1
     d2c:	00005097          	auipc	ra,0x5
     d30:	df8080e7          	jalr	-520(ra) # 5b24 <exit>
    printf("%s: unlinkread write failed\n", s);
     d34:	85ce                	mv	a1,s3
     d36:	00006517          	auipc	a0,0x6
     d3a:	8ca50513          	addi	a0,a0,-1846 # 6600 <malloc+0x6ba>
     d3e:	00005097          	auipc	ra,0x5
     d42:	14c080e7          	jalr	332(ra) # 5e8a <printf>
    exit(1);
     d46:	4505                	li	a0,1
     d48:	00005097          	auipc	ra,0x5
     d4c:	ddc080e7          	jalr	-548(ra) # 5b24 <exit>

0000000000000d50 <linktest>:
{
     d50:	1101                	addi	sp,sp,-32
     d52:	ec06                	sd	ra,24(sp)
     d54:	e822                	sd	s0,16(sp)
     d56:	e426                	sd	s1,8(sp)
     d58:	e04a                	sd	s2,0(sp)
     d5a:	1000                	addi	s0,sp,32
     d5c:	892a                	mv	s2,a0
  unlink("lf1");
     d5e:	00006517          	auipc	a0,0x6
     d62:	8c250513          	addi	a0,a0,-1854 # 6620 <malloc+0x6da>
     d66:	00005097          	auipc	ra,0x5
     d6a:	e0e080e7          	jalr	-498(ra) # 5b74 <unlink>
  unlink("lf2");
     d6e:	00006517          	auipc	a0,0x6
     d72:	8ba50513          	addi	a0,a0,-1862 # 6628 <malloc+0x6e2>
     d76:	00005097          	auipc	ra,0x5
     d7a:	dfe080e7          	jalr	-514(ra) # 5b74 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d7e:	20200593          	li	a1,514
     d82:	00006517          	auipc	a0,0x6
     d86:	89e50513          	addi	a0,a0,-1890 # 6620 <malloc+0x6da>
     d8a:	00005097          	auipc	ra,0x5
     d8e:	dda080e7          	jalr	-550(ra) # 5b64 <open>
  if(fd < 0){
     d92:	10054763          	bltz	a0,ea0 <linktest+0x150>
     d96:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d98:	4615                	li	a2,5
     d9a:	00005597          	auipc	a1,0x5
     d9e:	7d658593          	addi	a1,a1,2006 # 6570 <malloc+0x62a>
     da2:	00005097          	auipc	ra,0x5
     da6:	da2080e7          	jalr	-606(ra) # 5b44 <write>
     daa:	4795                	li	a5,5
     dac:	10f51863          	bne	a0,a5,ebc <linktest+0x16c>
  close(fd);
     db0:	8526                	mv	a0,s1
     db2:	00005097          	auipc	ra,0x5
     db6:	d9a080e7          	jalr	-614(ra) # 5b4c <close>
  if(link("lf1", "lf2") < 0){
     dba:	00006597          	auipc	a1,0x6
     dbe:	86e58593          	addi	a1,a1,-1938 # 6628 <malloc+0x6e2>
     dc2:	00006517          	auipc	a0,0x6
     dc6:	85e50513          	addi	a0,a0,-1954 # 6620 <malloc+0x6da>
     dca:	00005097          	auipc	ra,0x5
     dce:	dba080e7          	jalr	-582(ra) # 5b84 <link>
     dd2:	10054363          	bltz	a0,ed8 <linktest+0x188>
  unlink("lf1");
     dd6:	00006517          	auipc	a0,0x6
     dda:	84a50513          	addi	a0,a0,-1974 # 6620 <malloc+0x6da>
     dde:	00005097          	auipc	ra,0x5
     de2:	d96080e7          	jalr	-618(ra) # 5b74 <unlink>
  if(open("lf1", 0) >= 0){
     de6:	4581                	li	a1,0
     de8:	00006517          	auipc	a0,0x6
     dec:	83850513          	addi	a0,a0,-1992 # 6620 <malloc+0x6da>
     df0:	00005097          	auipc	ra,0x5
     df4:	d74080e7          	jalr	-652(ra) # 5b64 <open>
     df8:	0e055e63          	bgez	a0,ef4 <linktest+0x1a4>
  fd = open("lf2", 0);
     dfc:	4581                	li	a1,0
     dfe:	00006517          	auipc	a0,0x6
     e02:	82a50513          	addi	a0,a0,-2006 # 6628 <malloc+0x6e2>
     e06:	00005097          	auipc	ra,0x5
     e0a:	d5e080e7          	jalr	-674(ra) # 5b64 <open>
     e0e:	84aa                	mv	s1,a0
  if(fd < 0){
     e10:	10054063          	bltz	a0,f10 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     e14:	660d                	lui	a2,0x3
     e16:	0000b597          	auipc	a1,0xb
     e1a:	29a58593          	addi	a1,a1,666 # c0b0 <buf>
     e1e:	00005097          	auipc	ra,0x5
     e22:	d1e080e7          	jalr	-738(ra) # 5b3c <read>
     e26:	4795                	li	a5,5
     e28:	10f51263          	bne	a0,a5,f2c <linktest+0x1dc>
  close(fd);
     e2c:	8526                	mv	a0,s1
     e2e:	00005097          	auipc	ra,0x5
     e32:	d1e080e7          	jalr	-738(ra) # 5b4c <close>
  if(link("lf2", "lf2") >= 0){
     e36:	00005597          	auipc	a1,0x5
     e3a:	7f258593          	addi	a1,a1,2034 # 6628 <malloc+0x6e2>
     e3e:	852e                	mv	a0,a1
     e40:	00005097          	auipc	ra,0x5
     e44:	d44080e7          	jalr	-700(ra) # 5b84 <link>
     e48:	10055063          	bgez	a0,f48 <linktest+0x1f8>
  unlink("lf2");
     e4c:	00005517          	auipc	a0,0x5
     e50:	7dc50513          	addi	a0,a0,2012 # 6628 <malloc+0x6e2>
     e54:	00005097          	auipc	ra,0x5
     e58:	d20080e7          	jalr	-736(ra) # 5b74 <unlink>
  if(link("lf2", "lf1") >= 0){
     e5c:	00005597          	auipc	a1,0x5
     e60:	7c458593          	addi	a1,a1,1988 # 6620 <malloc+0x6da>
     e64:	00005517          	auipc	a0,0x5
     e68:	7c450513          	addi	a0,a0,1988 # 6628 <malloc+0x6e2>
     e6c:	00005097          	auipc	ra,0x5
     e70:	d18080e7          	jalr	-744(ra) # 5b84 <link>
     e74:	0e055863          	bgez	a0,f64 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e78:	00005597          	auipc	a1,0x5
     e7c:	7a858593          	addi	a1,a1,1960 # 6620 <malloc+0x6da>
     e80:	00006517          	auipc	a0,0x6
     e84:	8b050513          	addi	a0,a0,-1872 # 6730 <malloc+0x7ea>
     e88:	00005097          	auipc	ra,0x5
     e8c:	cfc080e7          	jalr	-772(ra) # 5b84 <link>
     e90:	0e055863          	bgez	a0,f80 <linktest+0x230>
}
     e94:	60e2                	ld	ra,24(sp)
     e96:	6442                	ld	s0,16(sp)
     e98:	64a2                	ld	s1,8(sp)
     e9a:	6902                	ld	s2,0(sp)
     e9c:	6105                	addi	sp,sp,32
     e9e:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     ea0:	85ca                	mv	a1,s2
     ea2:	00005517          	auipc	a0,0x5
     ea6:	78e50513          	addi	a0,a0,1934 # 6630 <malloc+0x6ea>
     eaa:	00005097          	auipc	ra,0x5
     eae:	fe0080e7          	jalr	-32(ra) # 5e8a <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	c70080e7          	jalr	-912(ra) # 5b24 <exit>
    printf("%s: write lf1 failed\n", s);
     ebc:	85ca                	mv	a1,s2
     ebe:	00005517          	auipc	a0,0x5
     ec2:	78a50513          	addi	a0,a0,1930 # 6648 <malloc+0x702>
     ec6:	00005097          	auipc	ra,0x5
     eca:	fc4080e7          	jalr	-60(ra) # 5e8a <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	c54080e7          	jalr	-940(ra) # 5b24 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ed8:	85ca                	mv	a1,s2
     eda:	00005517          	auipc	a0,0x5
     ede:	78650513          	addi	a0,a0,1926 # 6660 <malloc+0x71a>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	fa8080e7          	jalr	-88(ra) # 5e8a <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	c38080e7          	jalr	-968(ra) # 5b24 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ef4:	85ca                	mv	a1,s2
     ef6:	00005517          	auipc	a0,0x5
     efa:	78a50513          	addi	a0,a0,1930 # 6680 <malloc+0x73a>
     efe:	00005097          	auipc	ra,0x5
     f02:	f8c080e7          	jalr	-116(ra) # 5e8a <printf>
    exit(1);
     f06:	4505                	li	a0,1
     f08:	00005097          	auipc	ra,0x5
     f0c:	c1c080e7          	jalr	-996(ra) # 5b24 <exit>
    printf("%s: open lf2 failed\n", s);
     f10:	85ca                	mv	a1,s2
     f12:	00005517          	auipc	a0,0x5
     f16:	79e50513          	addi	a0,a0,1950 # 66b0 <malloc+0x76a>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	f70080e7          	jalr	-144(ra) # 5e8a <printf>
    exit(1);
     f22:	4505                	li	a0,1
     f24:	00005097          	auipc	ra,0x5
     f28:	c00080e7          	jalr	-1024(ra) # 5b24 <exit>
    printf("%s: read lf2 failed\n", s);
     f2c:	85ca                	mv	a1,s2
     f2e:	00005517          	auipc	a0,0x5
     f32:	79a50513          	addi	a0,a0,1946 # 66c8 <malloc+0x782>
     f36:	00005097          	auipc	ra,0x5
     f3a:	f54080e7          	jalr	-172(ra) # 5e8a <printf>
    exit(1);
     f3e:	4505                	li	a0,1
     f40:	00005097          	auipc	ra,0x5
     f44:	be4080e7          	jalr	-1052(ra) # 5b24 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f48:	85ca                	mv	a1,s2
     f4a:	00005517          	auipc	a0,0x5
     f4e:	79650513          	addi	a0,a0,1942 # 66e0 <malloc+0x79a>
     f52:	00005097          	auipc	ra,0x5
     f56:	f38080e7          	jalr	-200(ra) # 5e8a <printf>
    exit(1);
     f5a:	4505                	li	a0,1
     f5c:	00005097          	auipc	ra,0x5
     f60:	bc8080e7          	jalr	-1080(ra) # 5b24 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     f64:	85ca                	mv	a1,s2
     f66:	00005517          	auipc	a0,0x5
     f6a:	7a250513          	addi	a0,a0,1954 # 6708 <malloc+0x7c2>
     f6e:	00005097          	auipc	ra,0x5
     f72:	f1c080e7          	jalr	-228(ra) # 5e8a <printf>
    exit(1);
     f76:	4505                	li	a0,1
     f78:	00005097          	auipc	ra,0x5
     f7c:	bac080e7          	jalr	-1108(ra) # 5b24 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f80:	85ca                	mv	a1,s2
     f82:	00005517          	auipc	a0,0x5
     f86:	7b650513          	addi	a0,a0,1974 # 6738 <malloc+0x7f2>
     f8a:	00005097          	auipc	ra,0x5
     f8e:	f00080e7          	jalr	-256(ra) # 5e8a <printf>
    exit(1);
     f92:	4505                	li	a0,1
     f94:	00005097          	auipc	ra,0x5
     f98:	b90080e7          	jalr	-1136(ra) # 5b24 <exit>

0000000000000f9c <bigdir>:
{
     f9c:	711d                	addi	sp,sp,-96
     f9e:	ec86                	sd	ra,88(sp)
     fa0:	e8a2                	sd	s0,80(sp)
     fa2:	e4a6                	sd	s1,72(sp)
     fa4:	e0ca                	sd	s2,64(sp)
     fa6:	fc4e                	sd	s3,56(sp)
     fa8:	f852                	sd	s4,48(sp)
     faa:	f456                	sd	s5,40(sp)
     fac:	f05a                	sd	s6,32(sp)
     fae:	ec5e                	sd	s7,24(sp)
     fb0:	1080                	addi	s0,sp,96
     fb2:	89aa                	mv	s3,a0
  unlink("bd");
     fb4:	00005517          	auipc	a0,0x5
     fb8:	7a450513          	addi	a0,a0,1956 # 6758 <malloc+0x812>
     fbc:	00005097          	auipc	ra,0x5
     fc0:	bb8080e7          	jalr	-1096(ra) # 5b74 <unlink>
  fd = open("bd", O_CREATE);
     fc4:	20000593          	li	a1,512
     fc8:	00005517          	auipc	a0,0x5
     fcc:	79050513          	addi	a0,a0,1936 # 6758 <malloc+0x812>
     fd0:	00005097          	auipc	ra,0x5
     fd4:	b94080e7          	jalr	-1132(ra) # 5b64 <open>
  if(fd < 0){
     fd8:	0c054c63          	bltz	a0,10b0 <bigdir+0x114>
  close(fd);
     fdc:	00005097          	auipc	ra,0x5
     fe0:	b70080e7          	jalr	-1168(ra) # 5b4c <close>
  for(i = 0; i < N; i++){
     fe4:	4901                	li	s2,0
    name[0] = 'x';
     fe6:	07800b13          	li	s6,120
    if(link("bd", name) != 0){
     fea:	fa040a93          	addi	s5,s0,-96
     fee:	00005a17          	auipc	s4,0x5
     ff2:	76aa0a13          	addi	s4,s4,1898 # 6758 <malloc+0x812>
  for(i = 0; i < N; i++){
     ff6:	1f400b93          	li	s7,500
    name[0] = 'x';
     ffa:	fb640023          	sb	s6,-96(s0)
    name[1] = '0' + (i / 64);
     ffe:	41f9571b          	sraiw	a4,s2,0x1f
    1002:	01a7571b          	srliw	a4,a4,0x1a
    1006:	012707bb          	addw	a5,a4,s2
    100a:	4067d69b          	sraiw	a3,a5,0x6
    100e:	0306869b          	addiw	a3,a3,48
    1012:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
    1016:	03f7f793          	andi	a5,a5,63
    101a:	9f99                	subw	a5,a5,a4
    101c:	0307879b          	addiw	a5,a5,48
    1020:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
    1024:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
    1028:	85d6                	mv	a1,s5
    102a:	8552                	mv	a0,s4
    102c:	00005097          	auipc	ra,0x5
    1030:	b58080e7          	jalr	-1192(ra) # 5b84 <link>
    1034:	84aa                	mv	s1,a0
    1036:	e959                	bnez	a0,10cc <bigdir+0x130>
  for(i = 0; i < N; i++){
    1038:	2905                	addiw	s2,s2,1
    103a:	fd7910e3          	bne	s2,s7,ffa <bigdir+0x5e>
  unlink("bd");
    103e:	00005517          	auipc	a0,0x5
    1042:	71a50513          	addi	a0,a0,1818 # 6758 <malloc+0x812>
    1046:	00005097          	auipc	ra,0x5
    104a:	b2e080e7          	jalr	-1234(ra) # 5b74 <unlink>
    name[0] = 'x';
    104e:	07800a13          	li	s4,120
    if(unlink(name) != 0){
    1052:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
    1056:	1f400a93          	li	s5,500
    name[0] = 'x';
    105a:	fb440023          	sb	s4,-96(s0)
    name[1] = '0' + (i / 64);
    105e:	41f4d71b          	sraiw	a4,s1,0x1f
    1062:	01a7571b          	srliw	a4,a4,0x1a
    1066:	009707bb          	addw	a5,a4,s1
    106a:	4067d69b          	sraiw	a3,a5,0x6
    106e:	0306869b          	addiw	a3,a3,48
    1072:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
    1076:	03f7f793          	andi	a5,a5,63
    107a:	9f99                	subw	a5,a5,a4
    107c:	0307879b          	addiw	a5,a5,48
    1080:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
    1084:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
    1088:	854a                	mv	a0,s2
    108a:	00005097          	auipc	ra,0x5
    108e:	aea080e7          	jalr	-1302(ra) # 5b74 <unlink>
    1092:	ed29                	bnez	a0,10ec <bigdir+0x150>
  for(i = 0; i < N; i++){
    1094:	2485                	addiw	s1,s1,1
    1096:	fd5492e3          	bne	s1,s5,105a <bigdir+0xbe>
}
    109a:	60e6                	ld	ra,88(sp)
    109c:	6446                	ld	s0,80(sp)
    109e:	64a6                	ld	s1,72(sp)
    10a0:	6906                	ld	s2,64(sp)
    10a2:	79e2                	ld	s3,56(sp)
    10a4:	7a42                	ld	s4,48(sp)
    10a6:	7aa2                	ld	s5,40(sp)
    10a8:	7b02                	ld	s6,32(sp)
    10aa:	6be2                	ld	s7,24(sp)
    10ac:	6125                	addi	sp,sp,96
    10ae:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    10b0:	85ce                	mv	a1,s3
    10b2:	00005517          	auipc	a0,0x5
    10b6:	6ae50513          	addi	a0,a0,1710 # 6760 <malloc+0x81a>
    10ba:	00005097          	auipc	ra,0x5
    10be:	dd0080e7          	jalr	-560(ra) # 5e8a <printf>
    exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00005097          	auipc	ra,0x5
    10c8:	a60080e7          	jalr	-1440(ra) # 5b24 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    10cc:	fa040613          	addi	a2,s0,-96
    10d0:	85ce                	mv	a1,s3
    10d2:	00005517          	auipc	a0,0x5
    10d6:	6ae50513          	addi	a0,a0,1710 # 6780 <malloc+0x83a>
    10da:	00005097          	auipc	ra,0x5
    10de:	db0080e7          	jalr	-592(ra) # 5e8a <printf>
      exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	a40080e7          	jalr	-1472(ra) # 5b24 <exit>
      printf("%s: bigdir unlink failed", s);
    10ec:	85ce                	mv	a1,s3
    10ee:	00005517          	auipc	a0,0x5
    10f2:	6b250513          	addi	a0,a0,1714 # 67a0 <malloc+0x85a>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	d94080e7          	jalr	-620(ra) # 5e8a <printf>
      exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	a24080e7          	jalr	-1500(ra) # 5b24 <exit>

0000000000001108 <validatetest>:
{
    1108:	7139                	addi	sp,sp,-64
    110a:	fc06                	sd	ra,56(sp)
    110c:	f822                	sd	s0,48(sp)
    110e:	f426                	sd	s1,40(sp)
    1110:	f04a                	sd	s2,32(sp)
    1112:	ec4e                	sd	s3,24(sp)
    1114:	e852                	sd	s4,16(sp)
    1116:	e456                	sd	s5,8(sp)
    1118:	e05a                	sd	s6,0(sp)
    111a:	0080                	addi	s0,sp,64
    111c:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    111e:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1120:	00005997          	auipc	s3,0x5
    1124:	6a098993          	addi	s3,s3,1696 # 67c0 <malloc+0x87a>
    1128:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    112a:	6a85                	lui	s5,0x1
    112c:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1130:	85a6                	mv	a1,s1
    1132:	854e                	mv	a0,s3
    1134:	00005097          	auipc	ra,0x5
    1138:	a50080e7          	jalr	-1456(ra) # 5b84 <link>
    113c:	01251f63          	bne	a0,s2,115a <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1140:	94d6                	add	s1,s1,s5
    1142:	ff4497e3          	bne	s1,s4,1130 <validatetest+0x28>
}
    1146:	70e2                	ld	ra,56(sp)
    1148:	7442                	ld	s0,48(sp)
    114a:	74a2                	ld	s1,40(sp)
    114c:	7902                	ld	s2,32(sp)
    114e:	69e2                	ld	s3,24(sp)
    1150:	6a42                	ld	s4,16(sp)
    1152:	6aa2                	ld	s5,8(sp)
    1154:	6b02                	ld	s6,0(sp)
    1156:	6121                	addi	sp,sp,64
    1158:	8082                	ret
      printf("%s: link should not succeed\n", s);
    115a:	85da                	mv	a1,s6
    115c:	00005517          	auipc	a0,0x5
    1160:	67450513          	addi	a0,a0,1652 # 67d0 <malloc+0x88a>
    1164:	00005097          	auipc	ra,0x5
    1168:	d26080e7          	jalr	-730(ra) # 5e8a <printf>
      exit(1);
    116c:	4505                	li	a0,1
    116e:	00005097          	auipc	ra,0x5
    1172:	9b6080e7          	jalr	-1610(ra) # 5b24 <exit>

0000000000001176 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1176:	7179                	addi	sp,sp,-48
    1178:	f406                	sd	ra,40(sp)
    117a:	f022                	sd	s0,32(sp)
    117c:	ec26                	sd	s1,24(sp)
    117e:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1180:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1184:	678d                	lui	a5,0x3
    1186:	f5e78793          	addi	a5,a5,-162 # 2f5e <fourteen+0x4e>
    118a:	eaeb14b7          	lui	s1,0xeaeb1
    118e:	b5b48493          	addi	s1,s1,-1189 # ffffffffeaeb0b5b <__BSS_END__+0xffffffffeaea1a9b>
    1192:	1482                	slli	s1,s1,0x20
    1194:	94be                	add	s1,s1,a5
    1196:	fd840593          	addi	a1,s0,-40
    119a:	8526                	mv	a0,s1
    119c:	00005097          	auipc	ra,0x5
    11a0:	9c0080e7          	jalr	-1600(ra) # 5b5c <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    11a4:	8526                	mv	a0,s1
    11a6:	00005097          	auipc	ra,0x5
    11aa:	98e080e7          	jalr	-1650(ra) # 5b34 <pipe>

  exit(0);
    11ae:	4501                	li	a0,0
    11b0:	00005097          	auipc	ra,0x5
    11b4:	974080e7          	jalr	-1676(ra) # 5b24 <exit>

00000000000011b8 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    11b8:	7139                	addi	sp,sp,-64
    11ba:	fc06                	sd	ra,56(sp)
    11bc:	f822                	sd	s0,48(sp)
    11be:	f426                	sd	s1,40(sp)
    11c0:	f04a                	sd	s2,32(sp)
    11c2:	ec4e                	sd	s3,24(sp)
    11c4:	e852                	sd	s4,16(sp)
    11c6:	0080                	addi	s0,sp,64
    11c8:	64b1                	lui	s1,0xc
    11ca:	35048493          	addi	s1,s1,848 # c350 <buf+0x2a0>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    11ce:	597d                	li	s2,-1
    11d0:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    11d4:	fc040a13          	addi	s4,s0,-64
    11d8:	00005997          	auipc	s3,0x5
    11dc:	ea098993          	addi	s3,s3,-352 # 6078 <malloc+0x132>
    argv[0] = (char*)0xffffffff;
    11e0:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    11e4:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    11e8:	85d2                	mv	a1,s4
    11ea:	854e                	mv	a0,s3
    11ec:	00005097          	auipc	ra,0x5
    11f0:	970080e7          	jalr	-1680(ra) # 5b5c <exec>
  for(int i = 0; i < 50000; i++){
    11f4:	34fd                	addiw	s1,s1,-1
    11f6:	f4ed                	bnez	s1,11e0 <badarg+0x28>
  }
  
  exit(0);
    11f8:	4501                	li	a0,0
    11fa:	00005097          	auipc	ra,0x5
    11fe:	92a080e7          	jalr	-1750(ra) # 5b24 <exit>

0000000000001202 <copyinstr2>:
{
    1202:	7155                	addi	sp,sp,-208
    1204:	e586                	sd	ra,200(sp)
    1206:	e1a2                	sd	s0,192(sp)
    1208:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    120a:	f6840793          	addi	a5,s0,-152
    120e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1212:	07800713          	li	a4,120
    1216:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    121a:	0785                	addi	a5,a5,1
    121c:	fed79de3          	bne	a5,a3,1216 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1220:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1224:	f6840513          	addi	a0,s0,-152
    1228:	00005097          	auipc	ra,0x5
    122c:	94c080e7          	jalr	-1716(ra) # 5b74 <unlink>
  if(ret != -1){
    1230:	57fd                	li	a5,-1
    1232:	0ef51063          	bne	a0,a5,1312 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    1236:	20100593          	li	a1,513
    123a:	f6840513          	addi	a0,s0,-152
    123e:	00005097          	auipc	ra,0x5
    1242:	926080e7          	jalr	-1754(ra) # 5b64 <open>
  if(fd != -1){
    1246:	57fd                	li	a5,-1
    1248:	0ef51563          	bne	a0,a5,1332 <copyinstr2+0x130>
  ret = link(b, b);
    124c:	f6840513          	addi	a0,s0,-152
    1250:	85aa                	mv	a1,a0
    1252:	00005097          	auipc	ra,0x5
    1256:	932080e7          	jalr	-1742(ra) # 5b84 <link>
  if(ret != -1){
    125a:	57fd                	li	a5,-1
    125c:	0ef51b63          	bne	a0,a5,1352 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1260:	00006797          	auipc	a5,0x6
    1264:	76878793          	addi	a5,a5,1896 # 79c8 <malloc+0x1a82>
    1268:	f4f43c23          	sd	a5,-168(s0)
    126c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1270:	f5840593          	addi	a1,s0,-168
    1274:	f6840513          	addi	a0,s0,-152
    1278:	00005097          	auipc	ra,0x5
    127c:	8e4080e7          	jalr	-1820(ra) # 5b5c <exec>
  if(ret != -1){
    1280:	57fd                	li	a5,-1
    1282:	0ef51963          	bne	a0,a5,1374 <copyinstr2+0x172>
  int pid = fork();
    1286:	00005097          	auipc	ra,0x5
    128a:	896080e7          	jalr	-1898(ra) # 5b1c <fork>
  if(pid < 0){
    128e:	10054363          	bltz	a0,1394 <copyinstr2+0x192>
  if(pid == 0){
    1292:	12051463          	bnez	a0,13ba <copyinstr2+0x1b8>
    1296:	00007797          	auipc	a5,0x7
    129a:	70278793          	addi	a5,a5,1794 # 8998 <big.0>
    129e:	00008697          	auipc	a3,0x8
    12a2:	6fa68693          	addi	a3,a3,1786 # 9998 <__global_pointer$+0x90f>
      big[i] = 'x';
    12a6:	07800713          	li	a4,120
    12aa:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    12ae:	0785                	addi	a5,a5,1
    12b0:	fed79de3          	bne	a5,a3,12aa <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    12b4:	00008797          	auipc	a5,0x8
    12b8:	6e078223          	sb	zero,1764(a5) # 9998 <__global_pointer$+0x90f>
    char *args2[] = { big, big, big, 0 };
    12bc:	00007797          	auipc	a5,0x7
    12c0:	15478793          	addi	a5,a5,340 # 8410 <malloc+0x24ca>
    12c4:	6390                	ld	a2,0(a5)
    12c6:	6794                	ld	a3,8(a5)
    12c8:	6b98                	ld	a4,16(a5)
    12ca:	6f9c                	ld	a5,24(a5)
    12cc:	f2c43823          	sd	a2,-208(s0)
    12d0:	f2d43c23          	sd	a3,-200(s0)
    12d4:	f4e43023          	sd	a4,-192(s0)
    12d8:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    12dc:	f3040593          	addi	a1,s0,-208
    12e0:	00005517          	auipc	a0,0x5
    12e4:	d9850513          	addi	a0,a0,-616 # 6078 <malloc+0x132>
    12e8:	00005097          	auipc	ra,0x5
    12ec:	874080e7          	jalr	-1932(ra) # 5b5c <exec>
    if(ret != -1){
    12f0:	57fd                	li	a5,-1
    12f2:	0af50e63          	beq	a0,a5,13ae <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12f6:	85be                	mv	a1,a5
    12f8:	00005517          	auipc	a0,0x5
    12fc:	58050513          	addi	a0,a0,1408 # 6878 <malloc+0x932>
    1300:	00005097          	auipc	ra,0x5
    1304:	b8a080e7          	jalr	-1142(ra) # 5e8a <printf>
      exit(1);
    1308:	4505                	li	a0,1
    130a:	00005097          	auipc	ra,0x5
    130e:	81a080e7          	jalr	-2022(ra) # 5b24 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1312:	862a                	mv	a2,a0
    1314:	f6840593          	addi	a1,s0,-152
    1318:	00005517          	auipc	a0,0x5
    131c:	4d850513          	addi	a0,a0,1240 # 67f0 <malloc+0x8aa>
    1320:	00005097          	auipc	ra,0x5
    1324:	b6a080e7          	jalr	-1174(ra) # 5e8a <printf>
    exit(1);
    1328:	4505                	li	a0,1
    132a:	00004097          	auipc	ra,0x4
    132e:	7fa080e7          	jalr	2042(ra) # 5b24 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1332:	862a                	mv	a2,a0
    1334:	f6840593          	addi	a1,s0,-152
    1338:	00005517          	auipc	a0,0x5
    133c:	4d850513          	addi	a0,a0,1240 # 6810 <malloc+0x8ca>
    1340:	00005097          	auipc	ra,0x5
    1344:	b4a080e7          	jalr	-1206(ra) # 5e8a <printf>
    exit(1);
    1348:	4505                	li	a0,1
    134a:	00004097          	auipc	ra,0x4
    134e:	7da080e7          	jalr	2010(ra) # 5b24 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1352:	f6840593          	addi	a1,s0,-152
    1356:	86aa                	mv	a3,a0
    1358:	862e                	mv	a2,a1
    135a:	00005517          	auipc	a0,0x5
    135e:	4d650513          	addi	a0,a0,1238 # 6830 <malloc+0x8ea>
    1362:	00005097          	auipc	ra,0x5
    1366:	b28080e7          	jalr	-1240(ra) # 5e8a <printf>
    exit(1);
    136a:	4505                	li	a0,1
    136c:	00004097          	auipc	ra,0x4
    1370:	7b8080e7          	jalr	1976(ra) # 5b24 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1374:	863e                	mv	a2,a5
    1376:	f6840593          	addi	a1,s0,-152
    137a:	00005517          	auipc	a0,0x5
    137e:	4de50513          	addi	a0,a0,1246 # 6858 <malloc+0x912>
    1382:	00005097          	auipc	ra,0x5
    1386:	b08080e7          	jalr	-1272(ra) # 5e8a <printf>
    exit(1);
    138a:	4505                	li	a0,1
    138c:	00004097          	auipc	ra,0x4
    1390:	798080e7          	jalr	1944(ra) # 5b24 <exit>
    printf("fork failed\n");
    1394:	00006517          	auipc	a0,0x6
    1398:	95c50513          	addi	a0,a0,-1700 # 6cf0 <malloc+0xdaa>
    139c:	00005097          	auipc	ra,0x5
    13a0:	aee080e7          	jalr	-1298(ra) # 5e8a <printf>
    exit(1);
    13a4:	4505                	li	a0,1
    13a6:	00004097          	auipc	ra,0x4
    13aa:	77e080e7          	jalr	1918(ra) # 5b24 <exit>
    exit(747); // OK
    13ae:	2eb00513          	li	a0,747
    13b2:	00004097          	auipc	ra,0x4
    13b6:	772080e7          	jalr	1906(ra) # 5b24 <exit>
  int st = 0;
    13ba:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    13be:	f5440513          	addi	a0,s0,-172
    13c2:	00004097          	auipc	ra,0x4
    13c6:	76a080e7          	jalr	1898(ra) # 5b2c <wait>
  if(st != 747){
    13ca:	f5442703          	lw	a4,-172(s0)
    13ce:	2eb00793          	li	a5,747
    13d2:	00f71663          	bne	a4,a5,13de <copyinstr2+0x1dc>
}
    13d6:	60ae                	ld	ra,200(sp)
    13d8:	640e                	ld	s0,192(sp)
    13da:	6169                	addi	sp,sp,208
    13dc:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    13de:	00005517          	auipc	a0,0x5
    13e2:	4c250513          	addi	a0,a0,1218 # 68a0 <malloc+0x95a>
    13e6:	00005097          	auipc	ra,0x5
    13ea:	aa4080e7          	jalr	-1372(ra) # 5e8a <printf>
    exit(1);
    13ee:	4505                	li	a0,1
    13f0:	00004097          	auipc	ra,0x4
    13f4:	734080e7          	jalr	1844(ra) # 5b24 <exit>

00000000000013f8 <truncate3>:
{
    13f8:	7175                	addi	sp,sp,-144
    13fa:	e506                	sd	ra,136(sp)
    13fc:	e122                	sd	s0,128(sp)
    13fe:	ecd6                	sd	s5,88(sp)
    1400:	0900                	addi	s0,sp,144
    1402:	8aaa                	mv	s5,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1404:	60100593          	li	a1,1537
    1408:	00005517          	auipc	a0,0x5
    140c:	cc850513          	addi	a0,a0,-824 # 60d0 <malloc+0x18a>
    1410:	00004097          	auipc	ra,0x4
    1414:	754080e7          	jalr	1876(ra) # 5b64 <open>
    1418:	00004097          	auipc	ra,0x4
    141c:	734080e7          	jalr	1844(ra) # 5b4c <close>
  pid = fork();
    1420:	00004097          	auipc	ra,0x4
    1424:	6fc080e7          	jalr	1788(ra) # 5b1c <fork>
  if(pid < 0){
    1428:	08054b63          	bltz	a0,14be <truncate3+0xc6>
  if(pid == 0){
    142c:	ed65                	bnez	a0,1524 <truncate3+0x12c>
    142e:	fca6                	sd	s1,120(sp)
    1430:	f8ca                	sd	s2,112(sp)
    1432:	f4ce                	sd	s3,104(sp)
    1434:	f0d2                	sd	s4,96(sp)
    1436:	e8da                	sd	s6,80(sp)
    1438:	e4de                	sd	s7,72(sp)
    143a:	e0e2                	sd	s8,64(sp)
    143c:	fc66                	sd	s9,56(sp)
    143e:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    1442:	4b05                	li	s6,1
    1444:	00005997          	auipc	s3,0x5
    1448:	c8c98993          	addi	s3,s3,-884 # 60d0 <malloc+0x18a>
      int n = write(fd, "1234567890", 10);
    144c:	4a29                	li	s4,10
    144e:	00005b97          	auipc	s7,0x5
    1452:	4b2b8b93          	addi	s7,s7,1202 # 6900 <malloc+0x9ba>
      read(fd, buf, sizeof(buf));
    1456:	f7840c93          	addi	s9,s0,-136
    145a:	02000c13          	li	s8,32
      int fd = open("truncfile", O_WRONLY);
    145e:	85da                	mv	a1,s6
    1460:	854e                	mv	a0,s3
    1462:	00004097          	auipc	ra,0x4
    1466:	702080e7          	jalr	1794(ra) # 5b64 <open>
    146a:	84aa                	mv	s1,a0
      if(fd < 0){
    146c:	06054f63          	bltz	a0,14ea <truncate3+0xf2>
      int n = write(fd, "1234567890", 10);
    1470:	8652                	mv	a2,s4
    1472:	85de                	mv	a1,s7
    1474:	00004097          	auipc	ra,0x4
    1478:	6d0080e7          	jalr	1744(ra) # 5b44 <write>
      if(n != 10){
    147c:	09451563          	bne	a0,s4,1506 <truncate3+0x10e>
      close(fd);
    1480:	8526                	mv	a0,s1
    1482:	00004097          	auipc	ra,0x4
    1486:	6ca080e7          	jalr	1738(ra) # 5b4c <close>
      fd = open("truncfile", O_RDONLY);
    148a:	4581                	li	a1,0
    148c:	854e                	mv	a0,s3
    148e:	00004097          	auipc	ra,0x4
    1492:	6d6080e7          	jalr	1750(ra) # 5b64 <open>
    1496:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1498:	8662                	mv	a2,s8
    149a:	85e6                	mv	a1,s9
    149c:	00004097          	auipc	ra,0x4
    14a0:	6a0080e7          	jalr	1696(ra) # 5b3c <read>
      close(fd);
    14a4:	8526                	mv	a0,s1
    14a6:	00004097          	auipc	ra,0x4
    14aa:	6a6080e7          	jalr	1702(ra) # 5b4c <close>
    for(int i = 0; i < 100; i++){
    14ae:	397d                	addiw	s2,s2,-1
    14b0:	fa0917e3          	bnez	s2,145e <truncate3+0x66>
    exit(0);
    14b4:	4501                	li	a0,0
    14b6:	00004097          	auipc	ra,0x4
    14ba:	66e080e7          	jalr	1646(ra) # 5b24 <exit>
    14be:	fca6                	sd	s1,120(sp)
    14c0:	f8ca                	sd	s2,112(sp)
    14c2:	f4ce                	sd	s3,104(sp)
    14c4:	f0d2                	sd	s4,96(sp)
    14c6:	e8da                	sd	s6,80(sp)
    14c8:	e4de                	sd	s7,72(sp)
    14ca:	e0e2                	sd	s8,64(sp)
    14cc:	fc66                	sd	s9,56(sp)
    printf("%s: fork failed\n", s);
    14ce:	85d6                	mv	a1,s5
    14d0:	00005517          	auipc	a0,0x5
    14d4:	40050513          	addi	a0,a0,1024 # 68d0 <malloc+0x98a>
    14d8:	00005097          	auipc	ra,0x5
    14dc:	9b2080e7          	jalr	-1614(ra) # 5e8a <printf>
    exit(1);
    14e0:	4505                	li	a0,1
    14e2:	00004097          	auipc	ra,0x4
    14e6:	642080e7          	jalr	1602(ra) # 5b24 <exit>
        printf("%s: open failed\n", s);
    14ea:	85d6                	mv	a1,s5
    14ec:	00005517          	auipc	a0,0x5
    14f0:	3fc50513          	addi	a0,a0,1020 # 68e8 <malloc+0x9a2>
    14f4:	00005097          	auipc	ra,0x5
    14f8:	996080e7          	jalr	-1642(ra) # 5e8a <printf>
        exit(1);
    14fc:	4505                	li	a0,1
    14fe:	00004097          	auipc	ra,0x4
    1502:	626080e7          	jalr	1574(ra) # 5b24 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1506:	862a                	mv	a2,a0
    1508:	85d6                	mv	a1,s5
    150a:	00005517          	auipc	a0,0x5
    150e:	40650513          	addi	a0,a0,1030 # 6910 <malloc+0x9ca>
    1512:	00005097          	auipc	ra,0x5
    1516:	978080e7          	jalr	-1672(ra) # 5e8a <printf>
        exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	608080e7          	jalr	1544(ra) # 5b24 <exit>
    1524:	fca6                	sd	s1,120(sp)
    1526:	f8ca                	sd	s2,112(sp)
    1528:	f4ce                	sd	s3,104(sp)
    152a:	f0d2                	sd	s4,96(sp)
    152c:	e8da                	sd	s6,80(sp)
    152e:	e4de                	sd	s7,72(sp)
    1530:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1534:	60100b13          	li	s6,1537
    1538:	00005a17          	auipc	s4,0x5
    153c:	b98a0a13          	addi	s4,s4,-1128 # 60d0 <malloc+0x18a>
    int n = write(fd, "xxx", 3);
    1540:	498d                	li	s3,3
    1542:	00005b97          	auipc	s7,0x5
    1546:	3eeb8b93          	addi	s7,s7,1006 # 6930 <malloc+0x9ea>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    154a:	85da                	mv	a1,s6
    154c:	8552                	mv	a0,s4
    154e:	00004097          	auipc	ra,0x4
    1552:	616080e7          	jalr	1558(ra) # 5b64 <open>
    1556:	84aa                	mv	s1,a0
    if(fd < 0){
    1558:	04054863          	bltz	a0,15a8 <truncate3+0x1b0>
    int n = write(fd, "xxx", 3);
    155c:	864e                	mv	a2,s3
    155e:	85de                	mv	a1,s7
    1560:	00004097          	auipc	ra,0x4
    1564:	5e4080e7          	jalr	1508(ra) # 5b44 <write>
    if(n != 3){
    1568:	07351063          	bne	a0,s3,15c8 <truncate3+0x1d0>
    close(fd);
    156c:	8526                	mv	a0,s1
    156e:	00004097          	auipc	ra,0x4
    1572:	5de080e7          	jalr	1502(ra) # 5b4c <close>
  for(int i = 0; i < 150; i++){
    1576:	397d                	addiw	s2,s2,-1
    1578:	fc0919e3          	bnez	s2,154a <truncate3+0x152>
    157c:	e0e2                	sd	s8,64(sp)
    157e:	fc66                	sd	s9,56(sp)
  wait(&xstatus);
    1580:	f9c40513          	addi	a0,s0,-100
    1584:	00004097          	auipc	ra,0x4
    1588:	5a8080e7          	jalr	1448(ra) # 5b2c <wait>
  unlink("truncfile");
    158c:	00005517          	auipc	a0,0x5
    1590:	b4450513          	addi	a0,a0,-1212 # 60d0 <malloc+0x18a>
    1594:	00004097          	auipc	ra,0x4
    1598:	5e0080e7          	jalr	1504(ra) # 5b74 <unlink>
  exit(xstatus);
    159c:	f9c42503          	lw	a0,-100(s0)
    15a0:	00004097          	auipc	ra,0x4
    15a4:	584080e7          	jalr	1412(ra) # 5b24 <exit>
    15a8:	e0e2                	sd	s8,64(sp)
    15aa:	fc66                	sd	s9,56(sp)
      printf("%s: open failed\n", s);
    15ac:	85d6                	mv	a1,s5
    15ae:	00005517          	auipc	a0,0x5
    15b2:	33a50513          	addi	a0,a0,826 # 68e8 <malloc+0x9a2>
    15b6:	00005097          	auipc	ra,0x5
    15ba:	8d4080e7          	jalr	-1836(ra) # 5e8a <printf>
      exit(1);
    15be:	4505                	li	a0,1
    15c0:	00004097          	auipc	ra,0x4
    15c4:	564080e7          	jalr	1380(ra) # 5b24 <exit>
    15c8:	e0e2                	sd	s8,64(sp)
    15ca:	fc66                	sd	s9,56(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    15cc:	862a                	mv	a2,a0
    15ce:	85d6                	mv	a1,s5
    15d0:	00005517          	auipc	a0,0x5
    15d4:	36850513          	addi	a0,a0,872 # 6938 <malloc+0x9f2>
    15d8:	00005097          	auipc	ra,0x5
    15dc:	8b2080e7          	jalr	-1870(ra) # 5e8a <printf>
      exit(1);
    15e0:	4505                	li	a0,1
    15e2:	00004097          	auipc	ra,0x4
    15e6:	542080e7          	jalr	1346(ra) # 5b24 <exit>

00000000000015ea <exectest>:
{
    15ea:	715d                	addi	sp,sp,-80
    15ec:	e486                	sd	ra,72(sp)
    15ee:	e0a2                	sd	s0,64(sp)
    15f0:	f84a                	sd	s2,48(sp)
    15f2:	0880                	addi	s0,sp,80
    15f4:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    15f6:	00005797          	auipc	a5,0x5
    15fa:	a8278793          	addi	a5,a5,-1406 # 6078 <malloc+0x132>
    15fe:	fcf43023          	sd	a5,-64(s0)
    1602:	00005797          	auipc	a5,0x5
    1606:	35678793          	addi	a5,a5,854 # 6958 <malloc+0xa12>
    160a:	fcf43423          	sd	a5,-56(s0)
    160e:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1612:	00005517          	auipc	a0,0x5
    1616:	34e50513          	addi	a0,a0,846 # 6960 <malloc+0xa1a>
    161a:	00004097          	auipc	ra,0x4
    161e:	55a080e7          	jalr	1370(ra) # 5b74 <unlink>
  pid = fork();
    1622:	00004097          	auipc	ra,0x4
    1626:	4fa080e7          	jalr	1274(ra) # 5b1c <fork>
  if(pid < 0) {
    162a:	04054763          	bltz	a0,1678 <exectest+0x8e>
    162e:	fc26                	sd	s1,56(sp)
    1630:	84aa                	mv	s1,a0
  if(pid == 0) {
    1632:	ed41                	bnez	a0,16ca <exectest+0xe0>
    close(1);
    1634:	4505                	li	a0,1
    1636:	00004097          	auipc	ra,0x4
    163a:	516080e7          	jalr	1302(ra) # 5b4c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    163e:	20100593          	li	a1,513
    1642:	00005517          	auipc	a0,0x5
    1646:	31e50513          	addi	a0,a0,798 # 6960 <malloc+0xa1a>
    164a:	00004097          	auipc	ra,0x4
    164e:	51a080e7          	jalr	1306(ra) # 5b64 <open>
    if(fd < 0) {
    1652:	04054263          	bltz	a0,1696 <exectest+0xac>
    if(fd != 1) {
    1656:	4785                	li	a5,1
    1658:	04f50d63          	beq	a0,a5,16b2 <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	32250513          	addi	a0,a0,802 # 6980 <malloc+0xa3a>
    1666:	00005097          	auipc	ra,0x5
    166a:	824080e7          	jalr	-2012(ra) # 5e8a <printf>
      exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	4b4080e7          	jalr	1204(ra) # 5b24 <exit>
    1678:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	25450513          	addi	a0,a0,596 # 68d0 <malloc+0x98a>
    1684:	00005097          	auipc	ra,0x5
    1688:	806080e7          	jalr	-2042(ra) # 5e8a <printf>
     exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	496080e7          	jalr	1174(ra) # 5b24 <exit>
      printf("%s: create failed\n", s);
    1696:	85ca                	mv	a1,s2
    1698:	00005517          	auipc	a0,0x5
    169c:	2d050513          	addi	a0,a0,720 # 6968 <malloc+0xa22>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	7ea080e7          	jalr	2026(ra) # 5e8a <printf>
      exit(1);
    16a8:	4505                	li	a0,1
    16aa:	00004097          	auipc	ra,0x4
    16ae:	47a080e7          	jalr	1146(ra) # 5b24 <exit>
    if(exec("echo", echoargv) < 0){
    16b2:	fc040593          	addi	a1,s0,-64
    16b6:	00005517          	auipc	a0,0x5
    16ba:	9c250513          	addi	a0,a0,-1598 # 6078 <malloc+0x132>
    16be:	00004097          	auipc	ra,0x4
    16c2:	49e080e7          	jalr	1182(ra) # 5b5c <exec>
    16c6:	02054163          	bltz	a0,16e8 <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    16ca:	fdc40513          	addi	a0,s0,-36
    16ce:	00004097          	auipc	ra,0x4
    16d2:	45e080e7          	jalr	1118(ra) # 5b2c <wait>
    16d6:	02951763          	bne	a0,s1,1704 <exectest+0x11a>
  if(xstatus != 0)
    16da:	fdc42503          	lw	a0,-36(s0)
    16de:	cd0d                	beqz	a0,1718 <exectest+0x12e>
    exit(xstatus);
    16e0:	00004097          	auipc	ra,0x4
    16e4:	444080e7          	jalr	1092(ra) # 5b24 <exit>
      printf("%s: exec echo failed\n", s);
    16e8:	85ca                	mv	a1,s2
    16ea:	00005517          	auipc	a0,0x5
    16ee:	2a650513          	addi	a0,a0,678 # 6990 <malloc+0xa4a>
    16f2:	00004097          	auipc	ra,0x4
    16f6:	798080e7          	jalr	1944(ra) # 5e8a <printf>
      exit(1);
    16fa:	4505                	li	a0,1
    16fc:	00004097          	auipc	ra,0x4
    1700:	428080e7          	jalr	1064(ra) # 5b24 <exit>
    printf("%s: wait failed!\n", s);
    1704:	85ca                	mv	a1,s2
    1706:	00005517          	auipc	a0,0x5
    170a:	2a250513          	addi	a0,a0,674 # 69a8 <malloc+0xa62>
    170e:	00004097          	auipc	ra,0x4
    1712:	77c080e7          	jalr	1916(ra) # 5e8a <printf>
    1716:	b7d1                	j	16da <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    1718:	4581                	li	a1,0
    171a:	00005517          	auipc	a0,0x5
    171e:	24650513          	addi	a0,a0,582 # 6960 <malloc+0xa1a>
    1722:	00004097          	auipc	ra,0x4
    1726:	442080e7          	jalr	1090(ra) # 5b64 <open>
  if(fd < 0) {
    172a:	02054a63          	bltz	a0,175e <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    172e:	4609                	li	a2,2
    1730:	fb840593          	addi	a1,s0,-72
    1734:	00004097          	auipc	ra,0x4
    1738:	408080e7          	jalr	1032(ra) # 5b3c <read>
    173c:	4789                	li	a5,2
    173e:	02f50e63          	beq	a0,a5,177a <exectest+0x190>
    printf("%s: read failed\n", s);
    1742:	85ca                	mv	a1,s2
    1744:	00005517          	auipc	a0,0x5
    1748:	cd450513          	addi	a0,a0,-812 # 6418 <malloc+0x4d2>
    174c:	00004097          	auipc	ra,0x4
    1750:	73e080e7          	jalr	1854(ra) # 5e8a <printf>
    exit(1);
    1754:	4505                	li	a0,1
    1756:	00004097          	auipc	ra,0x4
    175a:	3ce080e7          	jalr	974(ra) # 5b24 <exit>
    printf("%s: open failed\n", s);
    175e:	85ca                	mv	a1,s2
    1760:	00005517          	auipc	a0,0x5
    1764:	18850513          	addi	a0,a0,392 # 68e8 <malloc+0x9a2>
    1768:	00004097          	auipc	ra,0x4
    176c:	722080e7          	jalr	1826(ra) # 5e8a <printf>
    exit(1);
    1770:	4505                	li	a0,1
    1772:	00004097          	auipc	ra,0x4
    1776:	3b2080e7          	jalr	946(ra) # 5b24 <exit>
  unlink("echo-ok");
    177a:	00005517          	auipc	a0,0x5
    177e:	1e650513          	addi	a0,a0,486 # 6960 <malloc+0xa1a>
    1782:	00004097          	auipc	ra,0x4
    1786:	3f2080e7          	jalr	1010(ra) # 5b74 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    178a:	fb844703          	lbu	a4,-72(s0)
    178e:	04f00793          	li	a5,79
    1792:	00f71863          	bne	a4,a5,17a2 <exectest+0x1b8>
    1796:	fb944703          	lbu	a4,-71(s0)
    179a:	04b00793          	li	a5,75
    179e:	02f70063          	beq	a4,a5,17be <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    17a2:	85ca                	mv	a1,s2
    17a4:	00005517          	auipc	a0,0x5
    17a8:	21c50513          	addi	a0,a0,540 # 69c0 <malloc+0xa7a>
    17ac:	00004097          	auipc	ra,0x4
    17b0:	6de080e7          	jalr	1758(ra) # 5e8a <printf>
    exit(1);
    17b4:	4505                	li	a0,1
    17b6:	00004097          	auipc	ra,0x4
    17ba:	36e080e7          	jalr	878(ra) # 5b24 <exit>
    exit(0);
    17be:	4501                	li	a0,0
    17c0:	00004097          	auipc	ra,0x4
    17c4:	364080e7          	jalr	868(ra) # 5b24 <exit>

00000000000017c8 <pipe1>:
{
    17c8:	711d                	addi	sp,sp,-96
    17ca:	ec86                	sd	ra,88(sp)
    17cc:	e8a2                	sd	s0,80(sp)
    17ce:	e0ca                	sd	s2,64(sp)
    17d0:	1080                	addi	s0,sp,96
    17d2:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    17d4:	fa840513          	addi	a0,s0,-88
    17d8:	00004097          	auipc	ra,0x4
    17dc:	35c080e7          	jalr	860(ra) # 5b34 <pipe>
    17e0:	ed2d                	bnez	a0,185a <pipe1+0x92>
    17e2:	e4a6                	sd	s1,72(sp)
    17e4:	f852                	sd	s4,48(sp)
    17e6:	84aa                	mv	s1,a0
  pid = fork();
    17e8:	00004097          	auipc	ra,0x4
    17ec:	334080e7          	jalr	820(ra) # 5b1c <fork>
    17f0:	8a2a                	mv	s4,a0
  if(pid == 0){
    17f2:	c949                	beqz	a0,1884 <pipe1+0xbc>
  } else if(pid > 0){
    17f4:	18a05c63          	blez	a0,198c <pipe1+0x1c4>
    17f8:	fc4e                	sd	s3,56(sp)
    17fa:	f456                	sd	s5,40(sp)
    close(fds[1]);
    17fc:	fac42503          	lw	a0,-84(s0)
    1800:	00004097          	auipc	ra,0x4
    1804:	34c080e7          	jalr	844(ra) # 5b4c <close>
    total = 0;
    1808:	8a26                	mv	s4,s1
    cc = 1;
    180a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    180c:	0000ba97          	auipc	s5,0xb
    1810:	8a4a8a93          	addi	s5,s5,-1884 # c0b0 <buf>
    1814:	864e                	mv	a2,s3
    1816:	85d6                	mv	a1,s5
    1818:	fa842503          	lw	a0,-88(s0)
    181c:	00004097          	auipc	ra,0x4
    1820:	320080e7          	jalr	800(ra) # 5b3c <read>
    1824:	10a05963          	blez	a0,1936 <pipe1+0x16e>
    1828:	0000b717          	auipc	a4,0xb
    182c:	88870713          	addi	a4,a4,-1912 # c0b0 <buf>
    1830:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1834:	00074683          	lbu	a3,0(a4)
    1838:	0ff4f793          	zext.b	a5,s1
    183c:	2485                	addiw	s1,s1,1
    183e:	0cf69a63          	bne	a3,a5,1912 <pipe1+0x14a>
      for(i = 0; i < n; i++){
    1842:	0705                	addi	a4,a4,1
    1844:	fec498e3          	bne	s1,a2,1834 <pipe1+0x6c>
      total += n;
    1848:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    184c:	0019999b          	slliw	s3,s3,0x1
      if(cc > sizeof(buf))
    1850:	678d                	lui	a5,0x3
    1852:	fd37f1e3          	bgeu	a5,s3,1814 <pipe1+0x4c>
        cc = sizeof(buf);
    1856:	89be                	mv	s3,a5
    1858:	bf75                	j	1814 <pipe1+0x4c>
    185a:	e4a6                	sd	s1,72(sp)
    185c:	fc4e                	sd	s3,56(sp)
    185e:	f852                	sd	s4,48(sp)
    1860:	f456                	sd	s5,40(sp)
    1862:	f05a                	sd	s6,32(sp)
    1864:	ec5e                	sd	s7,24(sp)
    1866:	e862                	sd	s8,16(sp)
    printf("%s: pipe() failed\n", s);
    1868:	85ca                	mv	a1,s2
    186a:	00005517          	auipc	a0,0x5
    186e:	16e50513          	addi	a0,a0,366 # 69d8 <malloc+0xa92>
    1872:	00004097          	auipc	ra,0x4
    1876:	618080e7          	jalr	1560(ra) # 5e8a <printf>
    exit(1);
    187a:	4505                	li	a0,1
    187c:	00004097          	auipc	ra,0x4
    1880:	2a8080e7          	jalr	680(ra) # 5b24 <exit>
    1884:	fc4e                	sd	s3,56(sp)
    1886:	f456                	sd	s5,40(sp)
    1888:	f05a                	sd	s6,32(sp)
    188a:	ec5e                	sd	s7,24(sp)
    188c:	e862                	sd	s8,16(sp)
    close(fds[0]);
    188e:	fa842503          	lw	a0,-88(s0)
    1892:	00004097          	auipc	ra,0x4
    1896:	2ba080e7          	jalr	698(ra) # 5b4c <close>
    for(n = 0; n < N; n++){
    189a:	0000bb97          	auipc	s7,0xb
    189e:	816b8b93          	addi	s7,s7,-2026 # c0b0 <buf>
    18a2:	417004bb          	negw	s1,s7
    18a6:	0ff4f493          	zext.b	s1,s1
    18aa:	409b8993          	addi	s3,s7,1033
      if(write(fds[1], buf, SZ) != SZ){
    18ae:	40900a93          	li	s5,1033
    18b2:	8c5e                	mv	s8,s7
    for(n = 0; n < N; n++){
    18b4:	6b05                	lui	s6,0x1
    18b6:	42db0b13          	addi	s6,s6,1069 # 142d <truncate3+0x35>
{
    18ba:	87de                	mv	a5,s7
        buf[i] = seq++;
    18bc:	0097873b          	addw	a4,a5,s1
    18c0:	00e78023          	sb	a4,0(a5) # 3000 <fourteen+0xf0>
      for(i = 0; i < SZ; i++)
    18c4:	0785                	addi	a5,a5,1
    18c6:	ff379be3          	bne	a5,s3,18bc <pipe1+0xf4>
    18ca:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    18ce:	8656                	mv	a2,s5
    18d0:	85e2                	mv	a1,s8
    18d2:	fac42503          	lw	a0,-84(s0)
    18d6:	00004097          	auipc	ra,0x4
    18da:	26e080e7          	jalr	622(ra) # 5b44 <write>
    18de:	01551c63          	bne	a0,s5,18f6 <pipe1+0x12e>
    for(n = 0; n < N; n++){
    18e2:	24a5                	addiw	s1,s1,9
    18e4:	0ff4f493          	zext.b	s1,s1
    18e8:	fd6a19e3          	bne	s4,s6,18ba <pipe1+0xf2>
    exit(0);
    18ec:	4501                	li	a0,0
    18ee:	00004097          	auipc	ra,0x4
    18f2:	236080e7          	jalr	566(ra) # 5b24 <exit>
        printf("%s: pipe1 oops 1\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	0f850513          	addi	a0,a0,248 # 69f0 <malloc+0xaaa>
    1900:	00004097          	auipc	ra,0x4
    1904:	58a080e7          	jalr	1418(ra) # 5e8a <printf>
        exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	21a080e7          	jalr	538(ra) # 5b24 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1912:	85ca                	mv	a1,s2
    1914:	00005517          	auipc	a0,0x5
    1918:	0f450513          	addi	a0,a0,244 # 6a08 <malloc+0xac2>
    191c:	00004097          	auipc	ra,0x4
    1920:	56e080e7          	jalr	1390(ra) # 5e8a <printf>
          return;
    1924:	64a6                	ld	s1,72(sp)
    1926:	79e2                	ld	s3,56(sp)
    1928:	7a42                	ld	s4,48(sp)
    192a:	7aa2                	ld	s5,40(sp)
}
    192c:	60e6                	ld	ra,88(sp)
    192e:	6446                	ld	s0,80(sp)
    1930:	6906                	ld	s2,64(sp)
    1932:	6125                	addi	sp,sp,96
    1934:	8082                	ret
    if(total != N * SZ){
    1936:	6785                	lui	a5,0x1
    1938:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x35>
    193c:	02fa0363          	beq	s4,a5,1962 <pipe1+0x19a>
    1940:	f05a                	sd	s6,32(sp)
    1942:	ec5e                	sd	s7,24(sp)
    1944:	e862                	sd	s8,16(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1946:	85d2                	mv	a1,s4
    1948:	00005517          	auipc	a0,0x5
    194c:	0d850513          	addi	a0,a0,216 # 6a20 <malloc+0xada>
    1950:	00004097          	auipc	ra,0x4
    1954:	53a080e7          	jalr	1338(ra) # 5e8a <printf>
      exit(1);
    1958:	4505                	li	a0,1
    195a:	00004097          	auipc	ra,0x4
    195e:	1ca080e7          	jalr	458(ra) # 5b24 <exit>
    1962:	f05a                	sd	s6,32(sp)
    1964:	ec5e                	sd	s7,24(sp)
    1966:	e862                	sd	s8,16(sp)
    close(fds[0]);
    1968:	fa842503          	lw	a0,-88(s0)
    196c:	00004097          	auipc	ra,0x4
    1970:	1e0080e7          	jalr	480(ra) # 5b4c <close>
    wait(&xstatus);
    1974:	fa440513          	addi	a0,s0,-92
    1978:	00004097          	auipc	ra,0x4
    197c:	1b4080e7          	jalr	436(ra) # 5b2c <wait>
    exit(xstatus);
    1980:	fa442503          	lw	a0,-92(s0)
    1984:	00004097          	auipc	ra,0x4
    1988:	1a0080e7          	jalr	416(ra) # 5b24 <exit>
    198c:	fc4e                	sd	s3,56(sp)
    198e:	f456                	sd	s5,40(sp)
    1990:	f05a                	sd	s6,32(sp)
    1992:	ec5e                	sd	s7,24(sp)
    1994:	e862                	sd	s8,16(sp)
    printf("%s: fork() failed\n", s);
    1996:	85ca                	mv	a1,s2
    1998:	00005517          	auipc	a0,0x5
    199c:	0a850513          	addi	a0,a0,168 # 6a40 <malloc+0xafa>
    19a0:	00004097          	auipc	ra,0x4
    19a4:	4ea080e7          	jalr	1258(ra) # 5e8a <printf>
    exit(1);
    19a8:	4505                	li	a0,1
    19aa:	00004097          	auipc	ra,0x4
    19ae:	17a080e7          	jalr	378(ra) # 5b24 <exit>

00000000000019b2 <exitwait>:
{
    19b2:	715d                	addi	sp,sp,-80
    19b4:	e486                	sd	ra,72(sp)
    19b6:	e0a2                	sd	s0,64(sp)
    19b8:	fc26                	sd	s1,56(sp)
    19ba:	f84a                	sd	s2,48(sp)
    19bc:	f44e                	sd	s3,40(sp)
    19be:	f052                	sd	s4,32(sp)
    19c0:	ec56                	sd	s5,24(sp)
    19c2:	0880                	addi	s0,sp,80
    19c4:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    19c6:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    19c8:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    19cc:	06400a13          	li	s4,100
    pid = fork();
    19d0:	00004097          	auipc	ra,0x4
    19d4:	14c080e7          	jalr	332(ra) # 5b1c <fork>
    19d8:	84aa                	mv	s1,a0
    if(pid < 0){
    19da:	02054a63          	bltz	a0,1a0e <exitwait+0x5c>
    if(pid){
    19de:	c151                	beqz	a0,1a62 <exitwait+0xb0>
      if(wait(&xstate) != pid){
    19e0:	854e                	mv	a0,s3
    19e2:	00004097          	auipc	ra,0x4
    19e6:	14a080e7          	jalr	330(ra) # 5b2c <wait>
    19ea:	04951063          	bne	a0,s1,1a2a <exitwait+0x78>
      if(i != xstate) {
    19ee:	fbc42783          	lw	a5,-68(s0)
    19f2:	05279a63          	bne	a5,s2,1a46 <exitwait+0x94>
  for(i = 0; i < 100; i++){
    19f6:	2905                	addiw	s2,s2,1
    19f8:	fd491ce3          	bne	s2,s4,19d0 <exitwait+0x1e>
}
    19fc:	60a6                	ld	ra,72(sp)
    19fe:	6406                	ld	s0,64(sp)
    1a00:	74e2                	ld	s1,56(sp)
    1a02:	7942                	ld	s2,48(sp)
    1a04:	79a2                	ld	s3,40(sp)
    1a06:	7a02                	ld	s4,32(sp)
    1a08:	6ae2                	ld	s5,24(sp)
    1a0a:	6161                	addi	sp,sp,80
    1a0c:	8082                	ret
      printf("%s: fork failed\n", s);
    1a0e:	85d6                	mv	a1,s5
    1a10:	00005517          	auipc	a0,0x5
    1a14:	ec050513          	addi	a0,a0,-320 # 68d0 <malloc+0x98a>
    1a18:	00004097          	auipc	ra,0x4
    1a1c:	472080e7          	jalr	1138(ra) # 5e8a <printf>
      exit(1);
    1a20:	4505                	li	a0,1
    1a22:	00004097          	auipc	ra,0x4
    1a26:	102080e7          	jalr	258(ra) # 5b24 <exit>
        printf("%s: wait wrong pid\n", s);
    1a2a:	85d6                	mv	a1,s5
    1a2c:	00005517          	auipc	a0,0x5
    1a30:	02c50513          	addi	a0,a0,44 # 6a58 <malloc+0xb12>
    1a34:	00004097          	auipc	ra,0x4
    1a38:	456080e7          	jalr	1110(ra) # 5e8a <printf>
        exit(1);
    1a3c:	4505                	li	a0,1
    1a3e:	00004097          	auipc	ra,0x4
    1a42:	0e6080e7          	jalr	230(ra) # 5b24 <exit>
        printf("%s: wait wrong exit status\n", s);
    1a46:	85d6                	mv	a1,s5
    1a48:	00005517          	auipc	a0,0x5
    1a4c:	02850513          	addi	a0,a0,40 # 6a70 <malloc+0xb2a>
    1a50:	00004097          	auipc	ra,0x4
    1a54:	43a080e7          	jalr	1082(ra) # 5e8a <printf>
        exit(1);
    1a58:	4505                	li	a0,1
    1a5a:	00004097          	auipc	ra,0x4
    1a5e:	0ca080e7          	jalr	202(ra) # 5b24 <exit>
      exit(i);
    1a62:	854a                	mv	a0,s2
    1a64:	00004097          	auipc	ra,0x4
    1a68:	0c0080e7          	jalr	192(ra) # 5b24 <exit>

0000000000001a6c <twochildren>:
{
    1a6c:	1101                	addi	sp,sp,-32
    1a6e:	ec06                	sd	ra,24(sp)
    1a70:	e822                	sd	s0,16(sp)
    1a72:	e426                	sd	s1,8(sp)
    1a74:	e04a                	sd	s2,0(sp)
    1a76:	1000                	addi	s0,sp,32
    1a78:	892a                	mv	s2,a0
    1a7a:	3e800493          	li	s1,1000
    int pid1 = fork();
    1a7e:	00004097          	auipc	ra,0x4
    1a82:	09e080e7          	jalr	158(ra) # 5b1c <fork>
    if(pid1 < 0){
    1a86:	02054c63          	bltz	a0,1abe <twochildren+0x52>
    if(pid1 == 0){
    1a8a:	c921                	beqz	a0,1ada <twochildren+0x6e>
      int pid2 = fork();
    1a8c:	00004097          	auipc	ra,0x4
    1a90:	090080e7          	jalr	144(ra) # 5b1c <fork>
      if(pid2 < 0){
    1a94:	04054763          	bltz	a0,1ae2 <twochildren+0x76>
      if(pid2 == 0){
    1a98:	c13d                	beqz	a0,1afe <twochildren+0x92>
        wait(0);
    1a9a:	4501                	li	a0,0
    1a9c:	00004097          	auipc	ra,0x4
    1aa0:	090080e7          	jalr	144(ra) # 5b2c <wait>
        wait(0);
    1aa4:	4501                	li	a0,0
    1aa6:	00004097          	auipc	ra,0x4
    1aaa:	086080e7          	jalr	134(ra) # 5b2c <wait>
  for(int i = 0; i < 1000; i++){
    1aae:	34fd                	addiw	s1,s1,-1
    1ab0:	f4f9                	bnez	s1,1a7e <twochildren+0x12>
}
    1ab2:	60e2                	ld	ra,24(sp)
    1ab4:	6442                	ld	s0,16(sp)
    1ab6:	64a2                	ld	s1,8(sp)
    1ab8:	6902                	ld	s2,0(sp)
    1aba:	6105                	addi	sp,sp,32
    1abc:	8082                	ret
      printf("%s: fork failed\n", s);
    1abe:	85ca                	mv	a1,s2
    1ac0:	00005517          	auipc	a0,0x5
    1ac4:	e1050513          	addi	a0,a0,-496 # 68d0 <malloc+0x98a>
    1ac8:	00004097          	auipc	ra,0x4
    1acc:	3c2080e7          	jalr	962(ra) # 5e8a <printf>
      exit(1);
    1ad0:	4505                	li	a0,1
    1ad2:	00004097          	auipc	ra,0x4
    1ad6:	052080e7          	jalr	82(ra) # 5b24 <exit>
      exit(0);
    1ada:	00004097          	auipc	ra,0x4
    1ade:	04a080e7          	jalr	74(ra) # 5b24 <exit>
        printf("%s: fork failed\n", s);
    1ae2:	85ca                	mv	a1,s2
    1ae4:	00005517          	auipc	a0,0x5
    1ae8:	dec50513          	addi	a0,a0,-532 # 68d0 <malloc+0x98a>
    1aec:	00004097          	auipc	ra,0x4
    1af0:	39e080e7          	jalr	926(ra) # 5e8a <printf>
        exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	02e080e7          	jalr	46(ra) # 5b24 <exit>
        exit(0);
    1afe:	00004097          	auipc	ra,0x4
    1b02:	026080e7          	jalr	38(ra) # 5b24 <exit>

0000000000001b06 <forkfork>:
{
    1b06:	7179                	addi	sp,sp,-48
    1b08:	f406                	sd	ra,40(sp)
    1b0a:	f022                	sd	s0,32(sp)
    1b0c:	ec26                	sd	s1,24(sp)
    1b0e:	1800                	addi	s0,sp,48
    1b10:	84aa                	mv	s1,a0
    int pid = fork();
    1b12:	00004097          	auipc	ra,0x4
    1b16:	00a080e7          	jalr	10(ra) # 5b1c <fork>
    if(pid < 0){
    1b1a:	04054163          	bltz	a0,1b5c <forkfork+0x56>
    if(pid == 0){
    1b1e:	cd29                	beqz	a0,1b78 <forkfork+0x72>
    int pid = fork();
    1b20:	00004097          	auipc	ra,0x4
    1b24:	ffc080e7          	jalr	-4(ra) # 5b1c <fork>
    if(pid < 0){
    1b28:	02054a63          	bltz	a0,1b5c <forkfork+0x56>
    if(pid == 0){
    1b2c:	c531                	beqz	a0,1b78 <forkfork+0x72>
    wait(&xstatus);
    1b2e:	fdc40513          	addi	a0,s0,-36
    1b32:	00004097          	auipc	ra,0x4
    1b36:	ffa080e7          	jalr	-6(ra) # 5b2c <wait>
    if(xstatus != 0) {
    1b3a:	fdc42783          	lw	a5,-36(s0)
    1b3e:	ebbd                	bnez	a5,1bb4 <forkfork+0xae>
    wait(&xstatus);
    1b40:	fdc40513          	addi	a0,s0,-36
    1b44:	00004097          	auipc	ra,0x4
    1b48:	fe8080e7          	jalr	-24(ra) # 5b2c <wait>
    if(xstatus != 0) {
    1b4c:	fdc42783          	lw	a5,-36(s0)
    1b50:	e3b5                	bnez	a5,1bb4 <forkfork+0xae>
}
    1b52:	70a2                	ld	ra,40(sp)
    1b54:	7402                	ld	s0,32(sp)
    1b56:	64e2                	ld	s1,24(sp)
    1b58:	6145                	addi	sp,sp,48
    1b5a:	8082                	ret
      printf("%s: fork failed", s);
    1b5c:	85a6                	mv	a1,s1
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	f3250513          	addi	a0,a0,-206 # 6a90 <malloc+0xb4a>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	324080e7          	jalr	804(ra) # 5e8a <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	fb4080e7          	jalr	-76(ra) # 5b24 <exit>
{
    1b78:	0c800493          	li	s1,200
        int pid1 = fork();
    1b7c:	00004097          	auipc	ra,0x4
    1b80:	fa0080e7          	jalr	-96(ra) # 5b1c <fork>
        if(pid1 < 0){
    1b84:	00054f63          	bltz	a0,1ba2 <forkfork+0x9c>
        if(pid1 == 0){
    1b88:	c115                	beqz	a0,1bac <forkfork+0xa6>
        wait(0);
    1b8a:	4501                	li	a0,0
    1b8c:	00004097          	auipc	ra,0x4
    1b90:	fa0080e7          	jalr	-96(ra) # 5b2c <wait>
      for(int j = 0; j < 200; j++){
    1b94:	34fd                	addiw	s1,s1,-1
    1b96:	f0fd                	bnez	s1,1b7c <forkfork+0x76>
      exit(0);
    1b98:	4501                	li	a0,0
    1b9a:	00004097          	auipc	ra,0x4
    1b9e:	f8a080e7          	jalr	-118(ra) # 5b24 <exit>
          exit(1);
    1ba2:	4505                	li	a0,1
    1ba4:	00004097          	auipc	ra,0x4
    1ba8:	f80080e7          	jalr	-128(ra) # 5b24 <exit>
          exit(0);
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	f78080e7          	jalr	-136(ra) # 5b24 <exit>
      printf("%s: fork in child failed", s);
    1bb4:	85a6                	mv	a1,s1
    1bb6:	00005517          	auipc	a0,0x5
    1bba:	eea50513          	addi	a0,a0,-278 # 6aa0 <malloc+0xb5a>
    1bbe:	00004097          	auipc	ra,0x4
    1bc2:	2cc080e7          	jalr	716(ra) # 5e8a <printf>
      exit(1);
    1bc6:	4505                	li	a0,1
    1bc8:	00004097          	auipc	ra,0x4
    1bcc:	f5c080e7          	jalr	-164(ra) # 5b24 <exit>

0000000000001bd0 <reparent2>:
{
    1bd0:	1101                	addi	sp,sp,-32
    1bd2:	ec06                	sd	ra,24(sp)
    1bd4:	e822                	sd	s0,16(sp)
    1bd6:	e426                	sd	s1,8(sp)
    1bd8:	1000                	addi	s0,sp,32
    1bda:	32000493          	li	s1,800
    int pid1 = fork();
    1bde:	00004097          	auipc	ra,0x4
    1be2:	f3e080e7          	jalr	-194(ra) # 5b1c <fork>
    if(pid1 < 0){
    1be6:	00054f63          	bltz	a0,1c04 <reparent2+0x34>
    if(pid1 == 0){
    1bea:	c915                	beqz	a0,1c1e <reparent2+0x4e>
    wait(0);
    1bec:	4501                	li	a0,0
    1bee:	00004097          	auipc	ra,0x4
    1bf2:	f3e080e7          	jalr	-194(ra) # 5b2c <wait>
  for(int i = 0; i < 800; i++){
    1bf6:	34fd                	addiw	s1,s1,-1
    1bf8:	f0fd                	bnez	s1,1bde <reparent2+0xe>
  exit(0);
    1bfa:	4501                	li	a0,0
    1bfc:	00004097          	auipc	ra,0x4
    1c00:	f28080e7          	jalr	-216(ra) # 5b24 <exit>
      printf("fork failed\n");
    1c04:	00005517          	auipc	a0,0x5
    1c08:	0ec50513          	addi	a0,a0,236 # 6cf0 <malloc+0xdaa>
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	27e080e7          	jalr	638(ra) # 5e8a <printf>
      exit(1);
    1c14:	4505                	li	a0,1
    1c16:	00004097          	auipc	ra,0x4
    1c1a:	f0e080e7          	jalr	-242(ra) # 5b24 <exit>
      fork();
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	efe080e7          	jalr	-258(ra) # 5b1c <fork>
      fork();
    1c26:	00004097          	auipc	ra,0x4
    1c2a:	ef6080e7          	jalr	-266(ra) # 5b1c <fork>
      exit(0);
    1c2e:	4501                	li	a0,0
    1c30:	00004097          	auipc	ra,0x4
    1c34:	ef4080e7          	jalr	-268(ra) # 5b24 <exit>

0000000000001c38 <createdelete>:
{
    1c38:	7175                	addi	sp,sp,-144
    1c3a:	e506                	sd	ra,136(sp)
    1c3c:	e122                	sd	s0,128(sp)
    1c3e:	fca6                	sd	s1,120(sp)
    1c40:	f8ca                	sd	s2,112(sp)
    1c42:	f4ce                	sd	s3,104(sp)
    1c44:	f0d2                	sd	s4,96(sp)
    1c46:	ecd6                	sd	s5,88(sp)
    1c48:	e8da                	sd	s6,80(sp)
    1c4a:	e4de                	sd	s7,72(sp)
    1c4c:	e0e2                	sd	s8,64(sp)
    1c4e:	fc66                	sd	s9,56(sp)
    1c50:	f86a                	sd	s10,48(sp)
    1c52:	0900                	addi	s0,sp,144
    1c54:	8d2a                	mv	s10,a0
  for(pi = 0; pi < NCHILD; pi++){
    1c56:	4901                	li	s2,0
    1c58:	4991                	li	s3,4
    pid = fork();
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	ec2080e7          	jalr	-318(ra) # 5b1c <fork>
    1c62:	84aa                	mv	s1,a0
    if(pid < 0){
    1c64:	04054063          	bltz	a0,1ca4 <createdelete+0x6c>
    if(pid == 0){
    1c68:	cd21                	beqz	a0,1cc0 <createdelete+0x88>
  for(pi = 0; pi < NCHILD; pi++){
    1c6a:	2905                	addiw	s2,s2,1
    1c6c:	ff3917e3          	bne	s2,s3,1c5a <createdelete+0x22>
    1c70:	4491                	li	s1,4
    wait(&xstatus);
    1c72:	f7c40993          	addi	s3,s0,-132
    1c76:	854e                	mv	a0,s3
    1c78:	00004097          	auipc	ra,0x4
    1c7c:	eb4080e7          	jalr	-332(ra) # 5b2c <wait>
    if(xstatus != 0)
    1c80:	f7c42903          	lw	s2,-132(s0)
    1c84:	0e091463          	bnez	s2,1d6c <createdelete+0x134>
  for(pi = 0; pi < NCHILD; pi++){
    1c88:	34fd                	addiw	s1,s1,-1
    1c8a:	f4f5                	bnez	s1,1c76 <createdelete+0x3e>
  name[0] = name[1] = name[2] = 0;
    1c8c:	f8040123          	sb	zero,-126(s0)
    1c90:	03000993          	li	s3,48
    1c94:	5afd                	li	s5,-1
    1c96:	07000c93          	li	s9,112
      if((i == 0 || i >= N/2) && fd < 0){
    1c9a:	4ba5                	li	s7,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1c9c:	4c21                	li	s8,8
    for(pi = 0; pi < NCHILD; pi++){
    1c9e:	07400b13          	li	s6,116
    1ca2:	a295                	j	1e06 <createdelete+0x1ce>
      printf("fork failed\n", s);
    1ca4:	85ea                	mv	a1,s10
    1ca6:	00005517          	auipc	a0,0x5
    1caa:	04a50513          	addi	a0,a0,74 # 6cf0 <malloc+0xdaa>
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	1dc080e7          	jalr	476(ra) # 5e8a <printf>
      exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	e6c080e7          	jalr	-404(ra) # 5b24 <exit>
      name[0] = 'p' + pi;
    1cc0:	0709091b          	addiw	s2,s2,112
    1cc4:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1cc8:	f8040123          	sb	zero,-126(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1ccc:	f8040913          	addi	s2,s0,-128
    1cd0:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1cd4:	4a51                	li	s4,20
    1cd6:	a081                	j	1d16 <createdelete+0xde>
          printf("%s: create failed\n", s);
    1cd8:	85ea                	mv	a1,s10
    1cda:	00005517          	auipc	a0,0x5
    1cde:	c8e50513          	addi	a0,a0,-882 # 6968 <malloc+0xa22>
    1ce2:	00004097          	auipc	ra,0x4
    1ce6:	1a8080e7          	jalr	424(ra) # 5e8a <printf>
          exit(1);
    1cea:	4505                	li	a0,1
    1cec:	00004097          	auipc	ra,0x4
    1cf0:	e38080e7          	jalr	-456(ra) # 5b24 <exit>
          name[1] = '0' + (i / 2);
    1cf4:	01f4d79b          	srliw	a5,s1,0x1f
    1cf8:	9fa5                	addw	a5,a5,s1
    1cfa:	4017d79b          	sraiw	a5,a5,0x1
    1cfe:	0307879b          	addiw	a5,a5,48
    1d02:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1d06:	854a                	mv	a0,s2
    1d08:	00004097          	auipc	ra,0x4
    1d0c:	e6c080e7          	jalr	-404(ra) # 5b74 <unlink>
    1d10:	04054063          	bltz	a0,1d50 <createdelete+0x118>
      for(i = 0; i < N; i++){
    1d14:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1d16:	0304879b          	addiw	a5,s1,48
    1d1a:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1d1e:	85ce                	mv	a1,s3
    1d20:	854a                	mv	a0,s2
    1d22:	00004097          	auipc	ra,0x4
    1d26:	e42080e7          	jalr	-446(ra) # 5b64 <open>
        if(fd < 0){
    1d2a:	fa0547e3          	bltz	a0,1cd8 <createdelete+0xa0>
        close(fd);
    1d2e:	00004097          	auipc	ra,0x4
    1d32:	e1e080e7          	jalr	-482(ra) # 5b4c <close>
        if(i > 0 && (i % 2 ) == 0){
    1d36:	fc905fe3          	blez	s1,1d14 <createdelete+0xdc>
    1d3a:	0014f793          	andi	a5,s1,1
    1d3e:	dbdd                	beqz	a5,1cf4 <createdelete+0xbc>
      for(i = 0; i < N; i++){
    1d40:	2485                	addiw	s1,s1,1
    1d42:	fd449ae3          	bne	s1,s4,1d16 <createdelete+0xde>
      exit(0);
    1d46:	4501                	li	a0,0
    1d48:	00004097          	auipc	ra,0x4
    1d4c:	ddc080e7          	jalr	-548(ra) # 5b24 <exit>
            printf("%s: unlink failed\n", s);
    1d50:	85ea                	mv	a1,s10
    1d52:	00005517          	auipc	a0,0x5
    1d56:	d6e50513          	addi	a0,a0,-658 # 6ac0 <malloc+0xb7a>
    1d5a:	00004097          	auipc	ra,0x4
    1d5e:	130080e7          	jalr	304(ra) # 5e8a <printf>
            exit(1);
    1d62:	4505                	li	a0,1
    1d64:	00004097          	auipc	ra,0x4
    1d68:	dc0080e7          	jalr	-576(ra) # 5b24 <exit>
      exit(1);
    1d6c:	4505                	li	a0,1
    1d6e:	00004097          	auipc	ra,0x4
    1d72:	db6080e7          	jalr	-586(ra) # 5b24 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1d76:	f8040613          	addi	a2,s0,-128
    1d7a:	85ea                	mv	a1,s10
    1d7c:	00005517          	auipc	a0,0x5
    1d80:	d5c50513          	addi	a0,a0,-676 # 6ad8 <malloc+0xb92>
    1d84:	00004097          	auipc	ra,0x4
    1d88:	106080e7          	jalr	262(ra) # 5e8a <printf>
        exit(1);
    1d8c:	4505                	li	a0,1
    1d8e:	00004097          	auipc	ra,0x4
    1d92:	d96080e7          	jalr	-618(ra) # 5b24 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d96:	035c7e63          	bgeu	s8,s5,1dd2 <createdelete+0x19a>
      if(fd >= 0)
    1d9a:	02055763          	bgez	a0,1dc8 <createdelete+0x190>
    for(pi = 0; pi < NCHILD; pi++){
    1d9e:	2485                	addiw	s1,s1,1
    1da0:	0ff4f493          	zext.b	s1,s1
    1da4:	05648963          	beq	s1,s6,1df6 <createdelete+0x1be>
      name[0] = 'p' + pi;
    1da8:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1dac:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1db0:	4581                	li	a1,0
    1db2:	8552                	mv	a0,s4
    1db4:	00004097          	auipc	ra,0x4
    1db8:	db0080e7          	jalr	-592(ra) # 5b64 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1dbc:	00090463          	beqz	s2,1dc4 <createdelete+0x18c>
    1dc0:	fd2bdbe3          	bge	s7,s2,1d96 <createdelete+0x15e>
    1dc4:	fa0549e3          	bltz	a0,1d76 <createdelete+0x13e>
        close(fd);
    1dc8:	00004097          	auipc	ra,0x4
    1dcc:	d84080e7          	jalr	-636(ra) # 5b4c <close>
    1dd0:	b7f9                	j	1d9e <createdelete+0x166>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dd2:	fc0546e3          	bltz	a0,1d9e <createdelete+0x166>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1dd6:	f8040613          	addi	a2,s0,-128
    1dda:	85ea                	mv	a1,s10
    1ddc:	00005517          	auipc	a0,0x5
    1de0:	d2450513          	addi	a0,a0,-732 # 6b00 <malloc+0xbba>
    1de4:	00004097          	auipc	ra,0x4
    1de8:	0a6080e7          	jalr	166(ra) # 5e8a <printf>
        exit(1);
    1dec:	4505                	li	a0,1
    1dee:	00004097          	auipc	ra,0x4
    1df2:	d36080e7          	jalr	-714(ra) # 5b24 <exit>
  for(i = 0; i < N; i++){
    1df6:	2905                	addiw	s2,s2,1
    1df8:	2a85                	addiw	s5,s5,1
    1dfa:	2985                	addiw	s3,s3,1
    1dfc:	0ff9f993          	zext.b	s3,s3
    1e00:	47d1                	li	a5,20
    1e02:	00f90663          	beq	s2,a5,1e0e <createdelete+0x1d6>
    for(pi = 0; pi < NCHILD; pi++){
    1e06:	84e6                	mv	s1,s9
      fd = open(name, 0);
    1e08:	f8040a13          	addi	s4,s0,-128
    1e0c:	bf71                	j	1da8 <createdelete+0x170>
    1e0e:	03000993          	li	s3,48
    1e12:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1e16:	4b11                	li	s6,4
      unlink(name);
    1e18:	f8040a13          	addi	s4,s0,-128
  for(i = 0; i < N; i++){
    1e1c:	08400a93          	li	s5,132
  name[0] = name[1] = name[2] = 0;
    1e20:	84da                	mv	s1,s6
      name[0] = 'p' + i;
    1e22:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1e26:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1e2a:	8552                	mv	a0,s4
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	d48080e7          	jalr	-696(ra) # 5b74 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1e34:	34fd                	addiw	s1,s1,-1
    1e36:	f4f5                	bnez	s1,1e22 <createdelete+0x1ea>
  for(i = 0; i < N; i++){
    1e38:	2905                	addiw	s2,s2,1
    1e3a:	0ff97913          	zext.b	s2,s2
    1e3e:	2985                	addiw	s3,s3,1
    1e40:	0ff9f993          	zext.b	s3,s3
    1e44:	fd591ee3          	bne	s2,s5,1e20 <createdelete+0x1e8>
}
    1e48:	60aa                	ld	ra,136(sp)
    1e4a:	640a                	ld	s0,128(sp)
    1e4c:	74e6                	ld	s1,120(sp)
    1e4e:	7946                	ld	s2,112(sp)
    1e50:	79a6                	ld	s3,104(sp)
    1e52:	7a06                	ld	s4,96(sp)
    1e54:	6ae6                	ld	s5,88(sp)
    1e56:	6b46                	ld	s6,80(sp)
    1e58:	6ba6                	ld	s7,72(sp)
    1e5a:	6c06                	ld	s8,64(sp)
    1e5c:	7ce2                	ld	s9,56(sp)
    1e5e:	7d42                	ld	s10,48(sp)
    1e60:	6149                	addi	sp,sp,144
    1e62:	8082                	ret

0000000000001e64 <linkunlink>:
{
    1e64:	711d                	addi	sp,sp,-96
    1e66:	ec86                	sd	ra,88(sp)
    1e68:	e8a2                	sd	s0,80(sp)
    1e6a:	e4a6                	sd	s1,72(sp)
    1e6c:	e0ca                	sd	s2,64(sp)
    1e6e:	fc4e                	sd	s3,56(sp)
    1e70:	f852                	sd	s4,48(sp)
    1e72:	f456                	sd	s5,40(sp)
    1e74:	f05a                	sd	s6,32(sp)
    1e76:	ec5e                	sd	s7,24(sp)
    1e78:	e862                	sd	s8,16(sp)
    1e7a:	e466                	sd	s9,8(sp)
    1e7c:	e06a                	sd	s10,0(sp)
    1e7e:	1080                	addi	s0,sp,96
    1e80:	84aa                	mv	s1,a0
  unlink("x");
    1e82:	00004517          	auipc	a0,0x4
    1e86:	26650513          	addi	a0,a0,614 # 60e8 <malloc+0x1a2>
    1e8a:	00004097          	auipc	ra,0x4
    1e8e:	cea080e7          	jalr	-790(ra) # 5b74 <unlink>
  pid = fork();
    1e92:	00004097          	auipc	ra,0x4
    1e96:	c8a080e7          	jalr	-886(ra) # 5b1c <fork>
  if(pid < 0){
    1e9a:	04054363          	bltz	a0,1ee0 <linkunlink+0x7c>
    1e9e:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1ea0:	06100913          	li	s2,97
    1ea4:	c111                	beqz	a0,1ea8 <linkunlink+0x44>
    1ea6:	4905                	li	s2,1
    1ea8:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1eac:	41c65ab7          	lui	s5,0x41c65
    1eb0:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <__BSS_END__+0x41c55dad>
    1eb4:	6a0d                	lui	s4,0x3
    1eb6:	039a0a1b          	addiw	s4,s4,57 # 3039 <fourteen+0x129>
    if((x % 3) == 0){
    1eba:	000ab9b7          	lui	s3,0xab
    1ebe:	aab98993          	addi	s3,s3,-1365 # aaaab <__BSS_END__+0x9b9eb>
    1ec2:	09b2                	slli	s3,s3,0xc
    1ec4:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1ec8:	4b85                	li	s7,1
      unlink("x");
    1eca:	00004b17          	auipc	s6,0x4
    1ece:	21eb0b13          	addi	s6,s6,542 # 60e8 <malloc+0x1a2>
      link("cat", "x");
    1ed2:	00005c97          	auipc	s9,0x5
    1ed6:	c56c8c93          	addi	s9,s9,-938 # 6b28 <malloc+0xbe2>
      close(open("x", O_RDWR | O_CREATE));
    1eda:	20200c13          	li	s8,514
    1ede:	a089                	j	1f20 <linkunlink+0xbc>
    printf("%s: fork failed\n", s);
    1ee0:	85a6                	mv	a1,s1
    1ee2:	00005517          	auipc	a0,0x5
    1ee6:	9ee50513          	addi	a0,a0,-1554 # 68d0 <malloc+0x98a>
    1eea:	00004097          	auipc	ra,0x4
    1eee:	fa0080e7          	jalr	-96(ra) # 5e8a <printf>
    exit(1);
    1ef2:	4505                	li	a0,1
    1ef4:	00004097          	auipc	ra,0x4
    1ef8:	c30080e7          	jalr	-976(ra) # 5b24 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1efc:	85e2                	mv	a1,s8
    1efe:	855a                	mv	a0,s6
    1f00:	00004097          	auipc	ra,0x4
    1f04:	c64080e7          	jalr	-924(ra) # 5b64 <open>
    1f08:	00004097          	auipc	ra,0x4
    1f0c:	c44080e7          	jalr	-956(ra) # 5b4c <close>
    1f10:	a031                	j	1f1c <linkunlink+0xb8>
      unlink("x");
    1f12:	855a                	mv	a0,s6
    1f14:	00004097          	auipc	ra,0x4
    1f18:	c60080e7          	jalr	-928(ra) # 5b74 <unlink>
  for(i = 0; i < 100; i++){
    1f1c:	34fd                	addiw	s1,s1,-1
    1f1e:	c895                	beqz	s1,1f52 <linkunlink+0xee>
    x = x * 1103515245 + 12345;
    1f20:	035907bb          	mulw	a5,s2,s5
    1f24:	00fa07bb          	addw	a5,s4,a5
    1f28:	893e                	mv	s2,a5
    if((x % 3) == 0){
    1f2a:	02079713          	slli	a4,a5,0x20
    1f2e:	9301                	srli	a4,a4,0x20
    1f30:	03370733          	mul	a4,a4,s3
    1f34:	9305                	srli	a4,a4,0x21
    1f36:	0017169b          	slliw	a3,a4,0x1
    1f3a:	9f35                	addw	a4,a4,a3
    1f3c:	9f99                	subw	a5,a5,a4
    1f3e:	dfdd                	beqz	a5,1efc <linkunlink+0x98>
    } else if((x % 3) == 1){
    1f40:	fd7799e3          	bne	a5,s7,1f12 <linkunlink+0xae>
      link("cat", "x");
    1f44:	85da                	mv	a1,s6
    1f46:	8566                	mv	a0,s9
    1f48:	00004097          	auipc	ra,0x4
    1f4c:	c3c080e7          	jalr	-964(ra) # 5b84 <link>
    1f50:	b7f1                	j	1f1c <linkunlink+0xb8>
  if(pid)
    1f52:	020d0563          	beqz	s10,1f7c <linkunlink+0x118>
    wait(0);
    1f56:	4501                	li	a0,0
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	bd4080e7          	jalr	-1068(ra) # 5b2c <wait>
}
    1f60:	60e6                	ld	ra,88(sp)
    1f62:	6446                	ld	s0,80(sp)
    1f64:	64a6                	ld	s1,72(sp)
    1f66:	6906                	ld	s2,64(sp)
    1f68:	79e2                	ld	s3,56(sp)
    1f6a:	7a42                	ld	s4,48(sp)
    1f6c:	7aa2                	ld	s5,40(sp)
    1f6e:	7b02                	ld	s6,32(sp)
    1f70:	6be2                	ld	s7,24(sp)
    1f72:	6c42                	ld	s8,16(sp)
    1f74:	6ca2                	ld	s9,8(sp)
    1f76:	6d02                	ld	s10,0(sp)
    1f78:	6125                	addi	sp,sp,96
    1f7a:	8082                	ret
    exit(0);
    1f7c:	4501                	li	a0,0
    1f7e:	00004097          	auipc	ra,0x4
    1f82:	ba6080e7          	jalr	-1114(ra) # 5b24 <exit>

0000000000001f86 <manywrites>:
{
    1f86:	7159                	addi	sp,sp,-112
    1f88:	f486                	sd	ra,104(sp)
    1f8a:	f0a2                	sd	s0,96(sp)
    1f8c:	eca6                	sd	s1,88(sp)
    1f8e:	e8ca                	sd	s2,80(sp)
    1f90:	e4ce                	sd	s3,72(sp)
    1f92:	fc56                	sd	s5,56(sp)
    1f94:	1880                	addi	s0,sp,112
    1f96:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1f98:	4901                	li	s2,0
    1f9a:	4991                	li	s3,4
    int pid = fork();
    1f9c:	00004097          	auipc	ra,0x4
    1fa0:	b80080e7          	jalr	-1152(ra) # 5b1c <fork>
    1fa4:	84aa                	mv	s1,a0
    if(pid < 0){
    1fa6:	04054163          	bltz	a0,1fe8 <manywrites+0x62>
    if(pid == 0){
    1faa:	c135                	beqz	a0,200e <manywrites+0x88>
  for(int ci = 0; ci < nchildren; ci++){
    1fac:	2905                	addiw	s2,s2,1
    1fae:	ff3917e3          	bne	s2,s3,1f9c <manywrites+0x16>
    1fb2:	4491                	li	s1,4
    wait(&st);
    1fb4:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1fb8:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1fbc:	854a                	mv	a0,s2
    1fbe:	00004097          	auipc	ra,0x4
    1fc2:	b6e080e7          	jalr	-1170(ra) # 5b2c <wait>
    if(st != 0)
    1fc6:	f9842503          	lw	a0,-104(s0)
    1fca:	12051063          	bnez	a0,20ea <manywrites+0x164>
  for(int ci = 0; ci < nchildren; ci++){
    1fce:	34fd                	addiw	s1,s1,-1
    1fd0:	f4e5                	bnez	s1,1fb8 <manywrites+0x32>
    1fd2:	e0d2                	sd	s4,64(sp)
    1fd4:	f85a                	sd	s6,48(sp)
    1fd6:	f45e                	sd	s7,40(sp)
    1fd8:	f062                	sd	s8,32(sp)
    1fda:	ec66                	sd	s9,24(sp)
    1fdc:	e86a                	sd	s10,16(sp)
  exit(0);
    1fde:	4501                	li	a0,0
    1fe0:	00004097          	auipc	ra,0x4
    1fe4:	b44080e7          	jalr	-1212(ra) # 5b24 <exit>
    1fe8:	e0d2                	sd	s4,64(sp)
    1fea:	f85a                	sd	s6,48(sp)
    1fec:	f45e                	sd	s7,40(sp)
    1fee:	f062                	sd	s8,32(sp)
    1ff0:	ec66                	sd	s9,24(sp)
    1ff2:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1ff4:	00005517          	auipc	a0,0x5
    1ff8:	cfc50513          	addi	a0,a0,-772 # 6cf0 <malloc+0xdaa>
    1ffc:	00004097          	auipc	ra,0x4
    2000:	e8e080e7          	jalr	-370(ra) # 5e8a <printf>
      exit(1);
    2004:	4505                	li	a0,1
    2006:	00004097          	auipc	ra,0x4
    200a:	b1e080e7          	jalr	-1250(ra) # 5b24 <exit>
    200e:	e0d2                	sd	s4,64(sp)
    2010:	f85a                	sd	s6,48(sp)
    2012:	f45e                	sd	s7,40(sp)
    2014:	f062                	sd	s8,32(sp)
    2016:	ec66                	sd	s9,24(sp)
    2018:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    201a:	06200793          	li	a5,98
    201e:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    2022:	0619079b          	addiw	a5,s2,97
    2026:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    202a:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    202e:	f9840513          	addi	a0,s0,-104
    2032:	00004097          	auipc	ra,0x4
    2036:	b42080e7          	jalr	-1214(ra) # 5b74 <unlink>
    203a:	4d79                	li	s10,30
          int fd = open(name, O_CREATE | O_RDWR);
    203c:	f9840c13          	addi	s8,s0,-104
    2040:	20200b93          	li	s7,514
          int cc = write(fd, buf, sz);
    2044:	6b0d                	lui	s6,0x3
    2046:	0000ac97          	auipc	s9,0xa
    204a:	06ac8c93          	addi	s9,s9,106 # c0b0 <buf>
        for(int i = 0; i < ci+1; i++){
    204e:	8a26                	mv	s4,s1
          int fd = open(name, O_CREATE | O_RDWR);
    2050:	85de                	mv	a1,s7
    2052:	8562                	mv	a0,s8
    2054:	00004097          	auipc	ra,0x4
    2058:	b10080e7          	jalr	-1264(ra) # 5b64 <open>
    205c:	89aa                	mv	s3,a0
          if(fd < 0){
    205e:	04054663          	bltz	a0,20aa <manywrites+0x124>
          int cc = write(fd, buf, sz);
    2062:	865a                	mv	a2,s6
    2064:	85e6                	mv	a1,s9
    2066:	00004097          	auipc	ra,0x4
    206a:	ade080e7          	jalr	-1314(ra) # 5b44 <write>
          if(cc != sz){
    206e:	05651e63          	bne	a0,s6,20ca <manywrites+0x144>
          close(fd);
    2072:	854e                	mv	a0,s3
    2074:	00004097          	auipc	ra,0x4
    2078:	ad8080e7          	jalr	-1320(ra) # 5b4c <close>
        for(int i = 0; i < ci+1; i++){
    207c:	2a05                	addiw	s4,s4,1
    207e:	fd4959e3          	bge	s2,s4,2050 <manywrites+0xca>
        unlink(name);
    2082:	f9840513          	addi	a0,s0,-104
    2086:	00004097          	auipc	ra,0x4
    208a:	aee080e7          	jalr	-1298(ra) # 5b74 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    208e:	3d7d                	addiw	s10,s10,-1
    2090:	fa0d1fe3          	bnez	s10,204e <manywrites+0xc8>
      unlink(name);
    2094:	f9840513          	addi	a0,s0,-104
    2098:	00004097          	auipc	ra,0x4
    209c:	adc080e7          	jalr	-1316(ra) # 5b74 <unlink>
      exit(0);
    20a0:	4501                	li	a0,0
    20a2:	00004097          	auipc	ra,0x4
    20a6:	a82080e7          	jalr	-1406(ra) # 5b24 <exit>
            printf("%s: cannot create %s\n", s, name);
    20aa:	f9840613          	addi	a2,s0,-104
    20ae:	85d6                	mv	a1,s5
    20b0:	00005517          	auipc	a0,0x5
    20b4:	a8050513          	addi	a0,a0,-1408 # 6b30 <malloc+0xbea>
    20b8:	00004097          	auipc	ra,0x4
    20bc:	dd2080e7          	jalr	-558(ra) # 5e8a <printf>
            exit(1);
    20c0:	4505                	li	a0,1
    20c2:	00004097          	auipc	ra,0x4
    20c6:	a62080e7          	jalr	-1438(ra) # 5b24 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    20ca:	86aa                	mv	a3,a0
    20cc:	660d                	lui	a2,0x3
    20ce:	85d6                	mv	a1,s5
    20d0:	00004517          	auipc	a0,0x4
    20d4:	07850513          	addi	a0,a0,120 # 6148 <malloc+0x202>
    20d8:	00004097          	auipc	ra,0x4
    20dc:	db2080e7          	jalr	-590(ra) # 5e8a <printf>
            exit(1);
    20e0:	4505                	li	a0,1
    20e2:	00004097          	auipc	ra,0x4
    20e6:	a42080e7          	jalr	-1470(ra) # 5b24 <exit>
    20ea:	e0d2                	sd	s4,64(sp)
    20ec:	f85a                	sd	s6,48(sp)
    20ee:	f45e                	sd	s7,40(sp)
    20f0:	f062                	sd	s8,32(sp)
    20f2:	ec66                	sd	s9,24(sp)
    20f4:	e86a                	sd	s10,16(sp)
      exit(st);
    20f6:	00004097          	auipc	ra,0x4
    20fa:	a2e080e7          	jalr	-1490(ra) # 5b24 <exit>

00000000000020fe <forktest>:
{
    20fe:	7179                	addi	sp,sp,-48
    2100:	f406                	sd	ra,40(sp)
    2102:	f022                	sd	s0,32(sp)
    2104:	ec26                	sd	s1,24(sp)
    2106:	e84a                	sd	s2,16(sp)
    2108:	e44e                	sd	s3,8(sp)
    210a:	1800                	addi	s0,sp,48
    210c:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    210e:	4481                	li	s1,0
    2110:	3e800913          	li	s2,1000
    pid = fork();
    2114:	00004097          	auipc	ra,0x4
    2118:	a08080e7          	jalr	-1528(ra) # 5b1c <fork>
    if(pid < 0)
    211c:	08054263          	bltz	a0,21a0 <forktest+0xa2>
    if(pid == 0)
    2120:	c115                	beqz	a0,2144 <forktest+0x46>
  for(n=0; n<N; n++){
    2122:	2485                	addiw	s1,s1,1
    2124:	ff2498e3          	bne	s1,s2,2114 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2128:	85ce                	mv	a1,s3
    212a:	00005517          	auipc	a0,0x5
    212e:	a6650513          	addi	a0,a0,-1434 # 6b90 <malloc+0xc4a>
    2132:	00004097          	auipc	ra,0x4
    2136:	d58080e7          	jalr	-680(ra) # 5e8a <printf>
    exit(1);
    213a:	4505                	li	a0,1
    213c:	00004097          	auipc	ra,0x4
    2140:	9e8080e7          	jalr	-1560(ra) # 5b24 <exit>
      exit(0);
    2144:	00004097          	auipc	ra,0x4
    2148:	9e0080e7          	jalr	-1568(ra) # 5b24 <exit>
    printf("%s: no fork at all!\n", s);
    214c:	85ce                	mv	a1,s3
    214e:	00005517          	auipc	a0,0x5
    2152:	9fa50513          	addi	a0,a0,-1542 # 6b48 <malloc+0xc02>
    2156:	00004097          	auipc	ra,0x4
    215a:	d34080e7          	jalr	-716(ra) # 5e8a <printf>
    exit(1);
    215e:	4505                	li	a0,1
    2160:	00004097          	auipc	ra,0x4
    2164:	9c4080e7          	jalr	-1596(ra) # 5b24 <exit>
      printf("%s: wait stopped early\n", s);
    2168:	85ce                	mv	a1,s3
    216a:	00005517          	auipc	a0,0x5
    216e:	9f650513          	addi	a0,a0,-1546 # 6b60 <malloc+0xc1a>
    2172:	00004097          	auipc	ra,0x4
    2176:	d18080e7          	jalr	-744(ra) # 5e8a <printf>
      exit(1);
    217a:	4505                	li	a0,1
    217c:	00004097          	auipc	ra,0x4
    2180:	9a8080e7          	jalr	-1624(ra) # 5b24 <exit>
    printf("%s: wait got too many\n", s);
    2184:	85ce                	mv	a1,s3
    2186:	00005517          	auipc	a0,0x5
    218a:	9f250513          	addi	a0,a0,-1550 # 6b78 <malloc+0xc32>
    218e:	00004097          	auipc	ra,0x4
    2192:	cfc080e7          	jalr	-772(ra) # 5e8a <printf>
    exit(1);
    2196:	4505                	li	a0,1
    2198:	00004097          	auipc	ra,0x4
    219c:	98c080e7          	jalr	-1652(ra) # 5b24 <exit>
  if (n == 0) {
    21a0:	d4d5                	beqz	s1,214c <forktest+0x4e>
    if(wait(0) < 0){
    21a2:	4501                	li	a0,0
    21a4:	00004097          	auipc	ra,0x4
    21a8:	988080e7          	jalr	-1656(ra) # 5b2c <wait>
    21ac:	fa054ee3          	bltz	a0,2168 <forktest+0x6a>
  for(; n > 0; n--){
    21b0:	34fd                	addiw	s1,s1,-1
    21b2:	fe9048e3          	bgtz	s1,21a2 <forktest+0xa4>
  if(wait(0) != -1){
    21b6:	4501                	li	a0,0
    21b8:	00004097          	auipc	ra,0x4
    21bc:	974080e7          	jalr	-1676(ra) # 5b2c <wait>
    21c0:	57fd                	li	a5,-1
    21c2:	fcf511e3          	bne	a0,a5,2184 <forktest+0x86>
}
    21c6:	70a2                	ld	ra,40(sp)
    21c8:	7402                	ld	s0,32(sp)
    21ca:	64e2                	ld	s1,24(sp)
    21cc:	6942                	ld	s2,16(sp)
    21ce:	69a2                	ld	s3,8(sp)
    21d0:	6145                	addi	sp,sp,48
    21d2:	8082                	ret

00000000000021d4 <kernmem>:
{
    21d4:	715d                	addi	sp,sp,-80
    21d6:	e486                	sd	ra,72(sp)
    21d8:	e0a2                	sd	s0,64(sp)
    21da:	fc26                	sd	s1,56(sp)
    21dc:	f84a                	sd	s2,48(sp)
    21de:	f44e                	sd	s3,40(sp)
    21e0:	f052                	sd	s4,32(sp)
    21e2:	ec56                	sd	s5,24(sp)
    21e4:	e85a                	sd	s6,16(sp)
    21e6:	0880                	addi	s0,sp,80
    21e8:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21ea:	4485                	li	s1,1
    21ec:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    21ee:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    21f2:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21f4:	69b1                	lui	s3,0xc
    21f6:	35098993          	addi	s3,s3,848 # c350 <buf+0x2a0>
    21fa:	1003d937          	lui	s2,0x1003d
    21fe:	090e                	slli	s2,s2,0x3
    2200:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e3c0>
    pid = fork();
    2204:	00004097          	auipc	ra,0x4
    2208:	918080e7          	jalr	-1768(ra) # 5b1c <fork>
    if(pid < 0){
    220c:	02054963          	bltz	a0,223e <kernmem+0x6a>
    if(pid == 0){
    2210:	c529                	beqz	a0,225a <kernmem+0x86>
    wait(&xstatus);
    2212:	8556                	mv	a0,s5
    2214:	00004097          	auipc	ra,0x4
    2218:	918080e7          	jalr	-1768(ra) # 5b2c <wait>
    if(xstatus != -1)  // did kernel kill child?
    221c:	fbc42783          	lw	a5,-68(s0)
    2220:	05479e63          	bne	a5,s4,227c <kernmem+0xa8>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2224:	94ce                	add	s1,s1,s3
    2226:	fd249fe3          	bne	s1,s2,2204 <kernmem+0x30>
}
    222a:	60a6                	ld	ra,72(sp)
    222c:	6406                	ld	s0,64(sp)
    222e:	74e2                	ld	s1,56(sp)
    2230:	7942                	ld	s2,48(sp)
    2232:	79a2                	ld	s3,40(sp)
    2234:	7a02                	ld	s4,32(sp)
    2236:	6ae2                	ld	s5,24(sp)
    2238:	6b42                	ld	s6,16(sp)
    223a:	6161                	addi	sp,sp,80
    223c:	8082                	ret
      printf("%s: fork failed\n", s);
    223e:	85da                	mv	a1,s6
    2240:	00004517          	auipc	a0,0x4
    2244:	69050513          	addi	a0,a0,1680 # 68d0 <malloc+0x98a>
    2248:	00004097          	auipc	ra,0x4
    224c:	c42080e7          	jalr	-958(ra) # 5e8a <printf>
      exit(1);
    2250:	4505                	li	a0,1
    2252:	00004097          	auipc	ra,0x4
    2256:	8d2080e7          	jalr	-1838(ra) # 5b24 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    225a:	0004c683          	lbu	a3,0(s1)
    225e:	8626                	mv	a2,s1
    2260:	85da                	mv	a1,s6
    2262:	00005517          	auipc	a0,0x5
    2266:	95650513          	addi	a0,a0,-1706 # 6bb8 <malloc+0xc72>
    226a:	00004097          	auipc	ra,0x4
    226e:	c20080e7          	jalr	-992(ra) # 5e8a <printf>
      exit(1);
    2272:	4505                	li	a0,1
    2274:	00004097          	auipc	ra,0x4
    2278:	8b0080e7          	jalr	-1872(ra) # 5b24 <exit>
      exit(1);
    227c:	4505                	li	a0,1
    227e:	00004097          	auipc	ra,0x4
    2282:	8a6080e7          	jalr	-1882(ra) # 5b24 <exit>

0000000000002286 <MAXVAplus>:
{
    2286:	7139                	addi	sp,sp,-64
    2288:	fc06                	sd	ra,56(sp)
    228a:	f822                	sd	s0,48(sp)
    228c:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    228e:	4785                	li	a5,1
    2290:	179a                	slli	a5,a5,0x26
    2292:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    2296:	fc843783          	ld	a5,-56(s0)
    229a:	c3b9                	beqz	a5,22e0 <MAXVAplus+0x5a>
    229c:	f426                	sd	s1,40(sp)
    229e:	f04a                	sd	s2,32(sp)
    22a0:	ec4e                	sd	s3,24(sp)
    22a2:	89aa                	mv	s3,a0
    wait(&xstatus);
    22a4:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    22a8:	54fd                	li	s1,-1
    pid = fork();
    22aa:	00004097          	auipc	ra,0x4
    22ae:	872080e7          	jalr	-1934(ra) # 5b1c <fork>
    if(pid < 0){
    22b2:	02054b63          	bltz	a0,22e8 <MAXVAplus+0x62>
    if(pid == 0){
    22b6:	c539                	beqz	a0,2304 <MAXVAplus+0x7e>
    wait(&xstatus);
    22b8:	854a                	mv	a0,s2
    22ba:	00004097          	auipc	ra,0x4
    22be:	872080e7          	jalr	-1934(ra) # 5b2c <wait>
    if(xstatus != -1)  // did kernel kill child?
    22c2:	fc442783          	lw	a5,-60(s0)
    22c6:	06979563          	bne	a5,s1,2330 <MAXVAplus+0xaa>
  for( ; a != 0; a <<= 1){
    22ca:	fc843783          	ld	a5,-56(s0)
    22ce:	0786                	slli	a5,a5,0x1
    22d0:	fcf43423          	sd	a5,-56(s0)
    22d4:	fc843783          	ld	a5,-56(s0)
    22d8:	fbe9                	bnez	a5,22aa <MAXVAplus+0x24>
    22da:	74a2                	ld	s1,40(sp)
    22dc:	7902                	ld	s2,32(sp)
    22de:	69e2                	ld	s3,24(sp)
}
    22e0:	70e2                	ld	ra,56(sp)
    22e2:	7442                	ld	s0,48(sp)
    22e4:	6121                	addi	sp,sp,64
    22e6:	8082                	ret
      printf("%s: fork failed\n", s);
    22e8:	85ce                	mv	a1,s3
    22ea:	00004517          	auipc	a0,0x4
    22ee:	5e650513          	addi	a0,a0,1510 # 68d0 <malloc+0x98a>
    22f2:	00004097          	auipc	ra,0x4
    22f6:	b98080e7          	jalr	-1128(ra) # 5e8a <printf>
      exit(1);
    22fa:	4505                	li	a0,1
    22fc:	00004097          	auipc	ra,0x4
    2300:	828080e7          	jalr	-2008(ra) # 5b24 <exit>
      *(char*)a = 99;
    2304:	fc843783          	ld	a5,-56(s0)
    2308:	06300713          	li	a4,99
    230c:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    2310:	fc843603          	ld	a2,-56(s0)
    2314:	85ce                	mv	a1,s3
    2316:	00005517          	auipc	a0,0x5
    231a:	8c250513          	addi	a0,a0,-1854 # 6bd8 <malloc+0xc92>
    231e:	00004097          	auipc	ra,0x4
    2322:	b6c080e7          	jalr	-1172(ra) # 5e8a <printf>
      exit(1);
    2326:	4505                	li	a0,1
    2328:	00003097          	auipc	ra,0x3
    232c:	7fc080e7          	jalr	2044(ra) # 5b24 <exit>
      exit(1);
    2330:	4505                	li	a0,1
    2332:	00003097          	auipc	ra,0x3
    2336:	7f2080e7          	jalr	2034(ra) # 5b24 <exit>

000000000000233a <bigargtest>:
{
    233a:	7179                	addi	sp,sp,-48
    233c:	f406                	sd	ra,40(sp)
    233e:	f022                	sd	s0,32(sp)
    2340:	ec26                	sd	s1,24(sp)
    2342:	1800                	addi	s0,sp,48
    2344:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2346:	00005517          	auipc	a0,0x5
    234a:	8aa50513          	addi	a0,a0,-1878 # 6bf0 <malloc+0xcaa>
    234e:	00004097          	auipc	ra,0x4
    2352:	826080e7          	jalr	-2010(ra) # 5b74 <unlink>
  pid = fork();
    2356:	00003097          	auipc	ra,0x3
    235a:	7c6080e7          	jalr	1990(ra) # 5b1c <fork>
  if(pid == 0){
    235e:	c121                	beqz	a0,239e <bigargtest+0x64>
  } else if(pid < 0){
    2360:	0a054063          	bltz	a0,2400 <bigargtest+0xc6>
  wait(&xstatus);
    2364:	fdc40513          	addi	a0,s0,-36
    2368:	00003097          	auipc	ra,0x3
    236c:	7c4080e7          	jalr	1988(ra) # 5b2c <wait>
  if(xstatus != 0)
    2370:	fdc42503          	lw	a0,-36(s0)
    2374:	e545                	bnez	a0,241c <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2376:	4581                	li	a1,0
    2378:	00005517          	auipc	a0,0x5
    237c:	87850513          	addi	a0,a0,-1928 # 6bf0 <malloc+0xcaa>
    2380:	00003097          	auipc	ra,0x3
    2384:	7e4080e7          	jalr	2020(ra) # 5b64 <open>
  if(fd < 0){
    2388:	08054e63          	bltz	a0,2424 <bigargtest+0xea>
  close(fd);
    238c:	00003097          	auipc	ra,0x3
    2390:	7c0080e7          	jalr	1984(ra) # 5b4c <close>
}
    2394:	70a2                	ld	ra,40(sp)
    2396:	7402                	ld	s0,32(sp)
    2398:	64e2                	ld	s1,24(sp)
    239a:	6145                	addi	sp,sp,48
    239c:	8082                	ret
    239e:	00006797          	auipc	a5,0x6
    23a2:	4fa78793          	addi	a5,a5,1274 # 8898 <args.1>
    23a6:	00006697          	auipc	a3,0x6
    23aa:	5ea68693          	addi	a3,a3,1514 # 8990 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    23ae:	00005717          	auipc	a4,0x5
    23b2:	85270713          	addi	a4,a4,-1966 # 6c00 <malloc+0xcba>
    23b6:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    23b8:	07a1                	addi	a5,a5,8
    23ba:	fed79ee3          	bne	a5,a3,23b6 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    23be:	00006597          	auipc	a1,0x6
    23c2:	4da58593          	addi	a1,a1,1242 # 8898 <args.1>
    23c6:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    23ca:	00004517          	auipc	a0,0x4
    23ce:	cae50513          	addi	a0,a0,-850 # 6078 <malloc+0x132>
    23d2:	00003097          	auipc	ra,0x3
    23d6:	78a080e7          	jalr	1930(ra) # 5b5c <exec>
    fd = open("bigarg-ok", O_CREATE);
    23da:	20000593          	li	a1,512
    23de:	00005517          	auipc	a0,0x5
    23e2:	81250513          	addi	a0,a0,-2030 # 6bf0 <malloc+0xcaa>
    23e6:	00003097          	auipc	ra,0x3
    23ea:	77e080e7          	jalr	1918(ra) # 5b64 <open>
    close(fd);
    23ee:	00003097          	auipc	ra,0x3
    23f2:	75e080e7          	jalr	1886(ra) # 5b4c <close>
    exit(0);
    23f6:	4501                	li	a0,0
    23f8:	00003097          	auipc	ra,0x3
    23fc:	72c080e7          	jalr	1836(ra) # 5b24 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2400:	85a6                	mv	a1,s1
    2402:	00005517          	auipc	a0,0x5
    2406:	8de50513          	addi	a0,a0,-1826 # 6ce0 <malloc+0xd9a>
    240a:	00004097          	auipc	ra,0x4
    240e:	a80080e7          	jalr	-1408(ra) # 5e8a <printf>
    exit(1);
    2412:	4505                	li	a0,1
    2414:	00003097          	auipc	ra,0x3
    2418:	710080e7          	jalr	1808(ra) # 5b24 <exit>
    exit(xstatus);
    241c:	00003097          	auipc	ra,0x3
    2420:	708080e7          	jalr	1800(ra) # 5b24 <exit>
    printf("%s: bigarg test failed!\n", s);
    2424:	85a6                	mv	a1,s1
    2426:	00005517          	auipc	a0,0x5
    242a:	8da50513          	addi	a0,a0,-1830 # 6d00 <malloc+0xdba>
    242e:	00004097          	auipc	ra,0x4
    2432:	a5c080e7          	jalr	-1444(ra) # 5e8a <printf>
    exit(1);
    2436:	4505                	li	a0,1
    2438:	00003097          	auipc	ra,0x3
    243c:	6ec080e7          	jalr	1772(ra) # 5b24 <exit>

0000000000002440 <stacktest>:
{
    2440:	7179                	addi	sp,sp,-48
    2442:	f406                	sd	ra,40(sp)
    2444:	f022                	sd	s0,32(sp)
    2446:	ec26                	sd	s1,24(sp)
    2448:	1800                	addi	s0,sp,48
    244a:	84aa                	mv	s1,a0
  pid = fork();
    244c:	00003097          	auipc	ra,0x3
    2450:	6d0080e7          	jalr	1744(ra) # 5b1c <fork>
  if(pid == 0) {
    2454:	c115                	beqz	a0,2478 <stacktest+0x38>
  } else if(pid < 0){
    2456:	04054463          	bltz	a0,249e <stacktest+0x5e>
  wait(&xstatus);
    245a:	fdc40513          	addi	a0,s0,-36
    245e:	00003097          	auipc	ra,0x3
    2462:	6ce080e7          	jalr	1742(ra) # 5b2c <wait>
  if(xstatus == -1)  // kernel killed child?
    2466:	fdc42503          	lw	a0,-36(s0)
    246a:	57fd                	li	a5,-1
    246c:	04f50763          	beq	a0,a5,24ba <stacktest+0x7a>
    exit(xstatus);
    2470:	00003097          	auipc	ra,0x3
    2474:	6b4080e7          	jalr	1716(ra) # 5b24 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2478:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    247a:	77fd                	lui	a5,0xfffff
    247c:	97ba                	add	a5,a5,a4
    247e:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xfffffffffffeff40>
    2482:	85a6                	mv	a1,s1
    2484:	00005517          	auipc	a0,0x5
    2488:	89c50513          	addi	a0,a0,-1892 # 6d20 <malloc+0xdda>
    248c:	00004097          	auipc	ra,0x4
    2490:	9fe080e7          	jalr	-1538(ra) # 5e8a <printf>
    exit(1);
    2494:	4505                	li	a0,1
    2496:	00003097          	auipc	ra,0x3
    249a:	68e080e7          	jalr	1678(ra) # 5b24 <exit>
    printf("%s: fork failed\n", s);
    249e:	85a6                	mv	a1,s1
    24a0:	00004517          	auipc	a0,0x4
    24a4:	43050513          	addi	a0,a0,1072 # 68d0 <malloc+0x98a>
    24a8:	00004097          	auipc	ra,0x4
    24ac:	9e2080e7          	jalr	-1566(ra) # 5e8a <printf>
    exit(1);
    24b0:	4505                	li	a0,1
    24b2:	00003097          	auipc	ra,0x3
    24b6:	672080e7          	jalr	1650(ra) # 5b24 <exit>
    exit(0);
    24ba:	4501                	li	a0,0
    24bc:	00003097          	auipc	ra,0x3
    24c0:	668080e7          	jalr	1640(ra) # 5b24 <exit>

00000000000024c4 <copyinstr3>:
{
    24c4:	7179                	addi	sp,sp,-48
    24c6:	f406                	sd	ra,40(sp)
    24c8:	f022                	sd	s0,32(sp)
    24ca:	ec26                	sd	s1,24(sp)
    24cc:	1800                	addi	s0,sp,48
  sbrk(8192);
    24ce:	6509                	lui	a0,0x2
    24d0:	00003097          	auipc	ra,0x3
    24d4:	6dc080e7          	jalr	1756(ra) # 5bac <sbrk>
  uint64 top = (uint64) sbrk(0);
    24d8:	4501                	li	a0,0
    24da:	00003097          	auipc	ra,0x3
    24de:	6d2080e7          	jalr	1746(ra) # 5bac <sbrk>
  if((top % PGSIZE) != 0){
    24e2:	03451793          	slli	a5,a0,0x34
    24e6:	e3c9                	bnez	a5,2568 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    24e8:	4501                	li	a0,0
    24ea:	00003097          	auipc	ra,0x3
    24ee:	6c2080e7          	jalr	1730(ra) # 5bac <sbrk>
  if(top % PGSIZE){
    24f2:	03451793          	slli	a5,a0,0x34
    24f6:	e7c1                	bnez	a5,257e <copyinstr3+0xba>
  char *b = (char *) (top - 1);
    24f8:	fff50493          	addi	s1,a0,-1 # 1fff <manywrites+0x79>
  *b = 'x';
    24fc:	07800793          	li	a5,120
    2500:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2504:	8526                	mv	a0,s1
    2506:	00003097          	auipc	ra,0x3
    250a:	66e080e7          	jalr	1646(ra) # 5b74 <unlink>
  if(ret != -1){
    250e:	57fd                	li	a5,-1
    2510:	08f51463          	bne	a0,a5,2598 <copyinstr3+0xd4>
  int fd = open(b, O_CREATE | O_WRONLY);
    2514:	20100593          	li	a1,513
    2518:	8526                	mv	a0,s1
    251a:	00003097          	auipc	ra,0x3
    251e:	64a080e7          	jalr	1610(ra) # 5b64 <open>
  if(fd != -1){
    2522:	57fd                	li	a5,-1
    2524:	08f51963          	bne	a0,a5,25b6 <copyinstr3+0xf2>
  ret = link(b, b);
    2528:	85a6                	mv	a1,s1
    252a:	8526                	mv	a0,s1
    252c:	00003097          	auipc	ra,0x3
    2530:	658080e7          	jalr	1624(ra) # 5b84 <link>
  if(ret != -1){
    2534:	57fd                	li	a5,-1
    2536:	08f51f63          	bne	a0,a5,25d4 <copyinstr3+0x110>
  char *args[] = { "xx", 0 };
    253a:	00005797          	auipc	a5,0x5
    253e:	48e78793          	addi	a5,a5,1166 # 79c8 <malloc+0x1a82>
    2542:	fcf43823          	sd	a5,-48(s0)
    2546:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    254a:	fd040593          	addi	a1,s0,-48
    254e:	8526                	mv	a0,s1
    2550:	00003097          	auipc	ra,0x3
    2554:	60c080e7          	jalr	1548(ra) # 5b5c <exec>
  if(ret != -1){
    2558:	57fd                	li	a5,-1
    255a:	08f51d63          	bne	a0,a5,25f4 <copyinstr3+0x130>
}
    255e:	70a2                	ld	ra,40(sp)
    2560:	7402                	ld	s0,32(sp)
    2562:	64e2                	ld	s1,24(sp)
    2564:	6145                	addi	sp,sp,48
    2566:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2568:	6785                	lui	a5,0x1
    256a:	fff78713          	addi	a4,a5,-1 # fff <bigdir+0x63>
    256e:	8d79                	and	a0,a0,a4
    2570:	40a7853b          	subw	a0,a5,a0
    2574:	00003097          	auipc	ra,0x3
    2578:	638080e7          	jalr	1592(ra) # 5bac <sbrk>
    257c:	b7b5                	j	24e8 <copyinstr3+0x24>
    printf("oops\n");
    257e:	00004517          	auipc	a0,0x4
    2582:	7ca50513          	addi	a0,a0,1994 # 6d48 <malloc+0xe02>
    2586:	00004097          	auipc	ra,0x4
    258a:	904080e7          	jalr	-1788(ra) # 5e8a <printf>
    exit(1);
    258e:	4505                	li	a0,1
    2590:	00003097          	auipc	ra,0x3
    2594:	594080e7          	jalr	1428(ra) # 5b24 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2598:	862a                	mv	a2,a0
    259a:	85a6                	mv	a1,s1
    259c:	00004517          	auipc	a0,0x4
    25a0:	25450513          	addi	a0,a0,596 # 67f0 <malloc+0x8aa>
    25a4:	00004097          	auipc	ra,0x4
    25a8:	8e6080e7          	jalr	-1818(ra) # 5e8a <printf>
    exit(1);
    25ac:	4505                	li	a0,1
    25ae:	00003097          	auipc	ra,0x3
    25b2:	576080e7          	jalr	1398(ra) # 5b24 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    25b6:	862a                	mv	a2,a0
    25b8:	85a6                	mv	a1,s1
    25ba:	00004517          	auipc	a0,0x4
    25be:	25650513          	addi	a0,a0,598 # 6810 <malloc+0x8ca>
    25c2:	00004097          	auipc	ra,0x4
    25c6:	8c8080e7          	jalr	-1848(ra) # 5e8a <printf>
    exit(1);
    25ca:	4505                	li	a0,1
    25cc:	00003097          	auipc	ra,0x3
    25d0:	558080e7          	jalr	1368(ra) # 5b24 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    25d4:	86aa                	mv	a3,a0
    25d6:	8626                	mv	a2,s1
    25d8:	85a6                	mv	a1,s1
    25da:	00004517          	auipc	a0,0x4
    25de:	25650513          	addi	a0,a0,598 # 6830 <malloc+0x8ea>
    25e2:	00004097          	auipc	ra,0x4
    25e6:	8a8080e7          	jalr	-1880(ra) # 5e8a <printf>
    exit(1);
    25ea:	4505                	li	a0,1
    25ec:	00003097          	auipc	ra,0x3
    25f0:	538080e7          	jalr	1336(ra) # 5b24 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    25f4:	863e                	mv	a2,a5
    25f6:	85a6                	mv	a1,s1
    25f8:	00004517          	auipc	a0,0x4
    25fc:	26050513          	addi	a0,a0,608 # 6858 <malloc+0x912>
    2600:	00004097          	auipc	ra,0x4
    2604:	88a080e7          	jalr	-1910(ra) # 5e8a <printf>
    exit(1);
    2608:	4505                	li	a0,1
    260a:	00003097          	auipc	ra,0x3
    260e:	51a080e7          	jalr	1306(ra) # 5b24 <exit>

0000000000002612 <rwsbrk>:
{
    2612:	1101                	addi	sp,sp,-32
    2614:	ec06                	sd	ra,24(sp)
    2616:	e822                	sd	s0,16(sp)
    2618:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    261a:	6509                	lui	a0,0x2
    261c:	00003097          	auipc	ra,0x3
    2620:	590080e7          	jalr	1424(ra) # 5bac <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2624:	57fd                	li	a5,-1
    2626:	06f50463          	beq	a0,a5,268e <rwsbrk+0x7c>
    262a:	e426                	sd	s1,8(sp)
    262c:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    262e:	7579                	lui	a0,0xffffe
    2630:	00003097          	auipc	ra,0x3
    2634:	57c080e7          	jalr	1404(ra) # 5bac <sbrk>
    2638:	57fd                	li	a5,-1
    263a:	06f50963          	beq	a0,a5,26ac <rwsbrk+0x9a>
    263e:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2640:	20100593          	li	a1,513
    2644:	00004517          	auipc	a0,0x4
    2648:	74450513          	addi	a0,a0,1860 # 6d88 <malloc+0xe42>
    264c:	00003097          	auipc	ra,0x3
    2650:	518080e7          	jalr	1304(ra) # 5b64 <open>
    2654:	892a                	mv	s2,a0
  if(fd < 0){
    2656:	06054963          	bltz	a0,26c8 <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    265a:	6785                	lui	a5,0x1
    265c:	94be                	add	s1,s1,a5
    265e:	40000613          	li	a2,1024
    2662:	85a6                	mv	a1,s1
    2664:	00003097          	auipc	ra,0x3
    2668:	4e0080e7          	jalr	1248(ra) # 5b44 <write>
    266c:	862a                	mv	a2,a0
  if(n >= 0){
    266e:	06054a63          	bltz	a0,26e2 <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    2672:	85a6                	mv	a1,s1
    2674:	00004517          	auipc	a0,0x4
    2678:	73450513          	addi	a0,a0,1844 # 6da8 <malloc+0xe62>
    267c:	00004097          	auipc	ra,0x4
    2680:	80e080e7          	jalr	-2034(ra) # 5e8a <printf>
    exit(1);
    2684:	4505                	li	a0,1
    2686:	00003097          	auipc	ra,0x3
    268a:	49e080e7          	jalr	1182(ra) # 5b24 <exit>
    268e:	e426                	sd	s1,8(sp)
    2690:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2692:	00004517          	auipc	a0,0x4
    2696:	6be50513          	addi	a0,a0,1726 # 6d50 <malloc+0xe0a>
    269a:	00003097          	auipc	ra,0x3
    269e:	7f0080e7          	jalr	2032(ra) # 5e8a <printf>
    exit(1);
    26a2:	4505                	li	a0,1
    26a4:	00003097          	auipc	ra,0x3
    26a8:	480080e7          	jalr	1152(ra) # 5b24 <exit>
    26ac:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    26ae:	00004517          	auipc	a0,0x4
    26b2:	6ba50513          	addi	a0,a0,1722 # 6d68 <malloc+0xe22>
    26b6:	00003097          	auipc	ra,0x3
    26ba:	7d4080e7          	jalr	2004(ra) # 5e8a <printf>
    exit(1);
    26be:	4505                	li	a0,1
    26c0:	00003097          	auipc	ra,0x3
    26c4:	464080e7          	jalr	1124(ra) # 5b24 <exit>
    printf("open(rwsbrk) failed\n");
    26c8:	00004517          	auipc	a0,0x4
    26cc:	6c850513          	addi	a0,a0,1736 # 6d90 <malloc+0xe4a>
    26d0:	00003097          	auipc	ra,0x3
    26d4:	7ba080e7          	jalr	1978(ra) # 5e8a <printf>
    exit(1);
    26d8:	4505                	li	a0,1
    26da:	00003097          	auipc	ra,0x3
    26de:	44a080e7          	jalr	1098(ra) # 5b24 <exit>
  close(fd);
    26e2:	854a                	mv	a0,s2
    26e4:	00003097          	auipc	ra,0x3
    26e8:	468080e7          	jalr	1128(ra) # 5b4c <close>
  unlink("rwsbrk");
    26ec:	00004517          	auipc	a0,0x4
    26f0:	69c50513          	addi	a0,a0,1692 # 6d88 <malloc+0xe42>
    26f4:	00003097          	auipc	ra,0x3
    26f8:	480080e7          	jalr	1152(ra) # 5b74 <unlink>
  fd = open("README", O_RDONLY);
    26fc:	4581                	li	a1,0
    26fe:	00004517          	auipc	a0,0x4
    2702:	b2250513          	addi	a0,a0,-1246 # 6220 <malloc+0x2da>
    2706:	00003097          	auipc	ra,0x3
    270a:	45e080e7          	jalr	1118(ra) # 5b64 <open>
    270e:	892a                	mv	s2,a0
  if(fd < 0){
    2710:	02054963          	bltz	a0,2742 <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    2714:	4629                	li	a2,10
    2716:	85a6                	mv	a1,s1
    2718:	00003097          	auipc	ra,0x3
    271c:	424080e7          	jalr	1060(ra) # 5b3c <read>
    2720:	862a                	mv	a2,a0
  if(n >= 0){
    2722:	02054d63          	bltz	a0,275c <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    2726:	85a6                	mv	a1,s1
    2728:	00004517          	auipc	a0,0x4
    272c:	6b050513          	addi	a0,a0,1712 # 6dd8 <malloc+0xe92>
    2730:	00003097          	auipc	ra,0x3
    2734:	75a080e7          	jalr	1882(ra) # 5e8a <printf>
    exit(1);
    2738:	4505                	li	a0,1
    273a:	00003097          	auipc	ra,0x3
    273e:	3ea080e7          	jalr	1002(ra) # 5b24 <exit>
    printf("open(rwsbrk) failed\n");
    2742:	00004517          	auipc	a0,0x4
    2746:	64e50513          	addi	a0,a0,1614 # 6d90 <malloc+0xe4a>
    274a:	00003097          	auipc	ra,0x3
    274e:	740080e7          	jalr	1856(ra) # 5e8a <printf>
    exit(1);
    2752:	4505                	li	a0,1
    2754:	00003097          	auipc	ra,0x3
    2758:	3d0080e7          	jalr	976(ra) # 5b24 <exit>
  close(fd);
    275c:	854a                	mv	a0,s2
    275e:	00003097          	auipc	ra,0x3
    2762:	3ee080e7          	jalr	1006(ra) # 5b4c <close>
  exit(0);
    2766:	4501                	li	a0,0
    2768:	00003097          	auipc	ra,0x3
    276c:	3bc080e7          	jalr	956(ra) # 5b24 <exit>

0000000000002770 <sbrkbasic>:
{
    2770:	715d                	addi	sp,sp,-80
    2772:	e486                	sd	ra,72(sp)
    2774:	e0a2                	sd	s0,64(sp)
    2776:	ec56                	sd	s5,24(sp)
    2778:	0880                	addi	s0,sp,80
    277a:	8aaa                	mv	s5,a0
  pid = fork();
    277c:	00003097          	auipc	ra,0x3
    2780:	3a0080e7          	jalr	928(ra) # 5b1c <fork>
  if(pid < 0){
    2784:	04054063          	bltz	a0,27c4 <sbrkbasic+0x54>
  if(pid == 0){
    2788:	e925                	bnez	a0,27f8 <sbrkbasic+0x88>
    a = sbrk(TOOMUCH);
    278a:	40000537          	lui	a0,0x40000
    278e:	00003097          	auipc	ra,0x3
    2792:	41e080e7          	jalr	1054(ra) # 5bac <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2796:	57fd                	li	a5,-1
    2798:	04f50763          	beq	a0,a5,27e6 <sbrkbasic+0x76>
    279c:	fc26                	sd	s1,56(sp)
    279e:	f84a                	sd	s2,48(sp)
    27a0:	f44e                	sd	s3,40(sp)
    27a2:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    27a4:	400007b7          	lui	a5,0x40000
    27a8:	97aa                	add	a5,a5,a0
      *b = 99;
    27aa:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    27ae:	6705                	lui	a4,0x1
      *b = 99;
    27b0:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff0f40>
    for(b = a; b < a+TOOMUCH; b += 4096){
    27b4:	953a                	add	a0,a0,a4
    27b6:	fef51de3          	bne	a0,a5,27b0 <sbrkbasic+0x40>
    exit(1);
    27ba:	4505                	li	a0,1
    27bc:	00003097          	auipc	ra,0x3
    27c0:	368080e7          	jalr	872(ra) # 5b24 <exit>
    27c4:	fc26                	sd	s1,56(sp)
    27c6:	f84a                	sd	s2,48(sp)
    27c8:	f44e                	sd	s3,40(sp)
    27ca:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    27cc:	00004517          	auipc	a0,0x4
    27d0:	63450513          	addi	a0,a0,1588 # 6e00 <malloc+0xeba>
    27d4:	00003097          	auipc	ra,0x3
    27d8:	6b6080e7          	jalr	1718(ra) # 5e8a <printf>
    exit(1);
    27dc:	4505                	li	a0,1
    27de:	00003097          	auipc	ra,0x3
    27e2:	346080e7          	jalr	838(ra) # 5b24 <exit>
    27e6:	fc26                	sd	s1,56(sp)
    27e8:	f84a                	sd	s2,48(sp)
    27ea:	f44e                	sd	s3,40(sp)
    27ec:	f052                	sd	s4,32(sp)
      exit(0);
    27ee:	4501                	li	a0,0
    27f0:	00003097          	auipc	ra,0x3
    27f4:	334080e7          	jalr	820(ra) # 5b24 <exit>
  wait(&xstatus);
    27f8:	fbc40513          	addi	a0,s0,-68
    27fc:	00003097          	auipc	ra,0x3
    2800:	330080e7          	jalr	816(ra) # 5b2c <wait>
  if(xstatus == 1){
    2804:	fbc42703          	lw	a4,-68(s0)
    2808:	4785                	li	a5,1
    280a:	02f70263          	beq	a4,a5,282e <sbrkbasic+0xbe>
    280e:	fc26                	sd	s1,56(sp)
    2810:	f84a                	sd	s2,48(sp)
    2812:	f44e                	sd	s3,40(sp)
    2814:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    2816:	4501                	li	a0,0
    2818:	00003097          	auipc	ra,0x3
    281c:	394080e7          	jalr	916(ra) # 5bac <sbrk>
    2820:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2822:	4901                	li	s2,0
    b = sbrk(1);
    2824:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    2826:	6a05                	lui	s4,0x1
    2828:	388a0a13          	addi	s4,s4,904 # 1388 <copyinstr2+0x186>
    282c:	a025                	j	2854 <sbrkbasic+0xe4>
    282e:	fc26                	sd	s1,56(sp)
    2830:	f84a                	sd	s2,48(sp)
    2832:	f44e                	sd	s3,40(sp)
    2834:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2836:	85d6                	mv	a1,s5
    2838:	00004517          	auipc	a0,0x4
    283c:	5e850513          	addi	a0,a0,1512 # 6e20 <malloc+0xeda>
    2840:	00003097          	auipc	ra,0x3
    2844:	64a080e7          	jalr	1610(ra) # 5e8a <printf>
    exit(1);
    2848:	4505                	li	a0,1
    284a:	00003097          	auipc	ra,0x3
    284e:	2da080e7          	jalr	730(ra) # 5b24 <exit>
    2852:	84be                	mv	s1,a5
    b = sbrk(1);
    2854:	854e                	mv	a0,s3
    2856:	00003097          	auipc	ra,0x3
    285a:	356080e7          	jalr	854(ra) # 5bac <sbrk>
    if(b != a){
    285e:	04951b63          	bne	a0,s1,28b4 <sbrkbasic+0x144>
    *b = 1;
    2862:	01348023          	sb	s3,0(s1)
    a = b + 1;
    2866:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    286a:	2905                	addiw	s2,s2,1
    286c:	ff4913e3          	bne	s2,s4,2852 <sbrkbasic+0xe2>
  pid = fork();
    2870:	00003097          	auipc	ra,0x3
    2874:	2ac080e7          	jalr	684(ra) # 5b1c <fork>
    2878:	892a                	mv	s2,a0
  if(pid < 0){
    287a:	04054e63          	bltz	a0,28d6 <sbrkbasic+0x166>
  c = sbrk(1);
    287e:	4505                	li	a0,1
    2880:	00003097          	auipc	ra,0x3
    2884:	32c080e7          	jalr	812(ra) # 5bac <sbrk>
  c = sbrk(1);
    2888:	4505                	li	a0,1
    288a:	00003097          	auipc	ra,0x3
    288e:	322080e7          	jalr	802(ra) # 5bac <sbrk>
  if(c != a + 1){
    2892:	0489                	addi	s1,s1,2
    2894:	04a48f63          	beq	s1,a0,28f2 <sbrkbasic+0x182>
    printf("%s: sbrk test failed post-fork\n", s);
    2898:	85d6                	mv	a1,s5
    289a:	00004517          	auipc	a0,0x4
    289e:	5e650513          	addi	a0,a0,1510 # 6e80 <malloc+0xf3a>
    28a2:	00003097          	auipc	ra,0x3
    28a6:	5e8080e7          	jalr	1512(ra) # 5e8a <printf>
    exit(1);
    28aa:	4505                	li	a0,1
    28ac:	00003097          	auipc	ra,0x3
    28b0:	278080e7          	jalr	632(ra) # 5b24 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    28b4:	872a                	mv	a4,a0
    28b6:	86a6                	mv	a3,s1
    28b8:	864a                	mv	a2,s2
    28ba:	85d6                	mv	a1,s5
    28bc:	00004517          	auipc	a0,0x4
    28c0:	58450513          	addi	a0,a0,1412 # 6e40 <malloc+0xefa>
    28c4:	00003097          	auipc	ra,0x3
    28c8:	5c6080e7          	jalr	1478(ra) # 5e8a <printf>
      exit(1);
    28cc:	4505                	li	a0,1
    28ce:	00003097          	auipc	ra,0x3
    28d2:	256080e7          	jalr	598(ra) # 5b24 <exit>
    printf("%s: sbrk test fork failed\n", s);
    28d6:	85d6                	mv	a1,s5
    28d8:	00004517          	auipc	a0,0x4
    28dc:	58850513          	addi	a0,a0,1416 # 6e60 <malloc+0xf1a>
    28e0:	00003097          	auipc	ra,0x3
    28e4:	5aa080e7          	jalr	1450(ra) # 5e8a <printf>
    exit(1);
    28e8:	4505                	li	a0,1
    28ea:	00003097          	auipc	ra,0x3
    28ee:	23a080e7          	jalr	570(ra) # 5b24 <exit>
  if(pid == 0)
    28f2:	00091763          	bnez	s2,2900 <sbrkbasic+0x190>
    exit(0);
    28f6:	4501                	li	a0,0
    28f8:	00003097          	auipc	ra,0x3
    28fc:	22c080e7          	jalr	556(ra) # 5b24 <exit>
  wait(&xstatus);
    2900:	fbc40513          	addi	a0,s0,-68
    2904:	00003097          	auipc	ra,0x3
    2908:	228080e7          	jalr	552(ra) # 5b2c <wait>
  exit(xstatus);
    290c:	fbc42503          	lw	a0,-68(s0)
    2910:	00003097          	auipc	ra,0x3
    2914:	214080e7          	jalr	532(ra) # 5b24 <exit>

0000000000002918 <sbrkmuch>:
{
    2918:	7179                	addi	sp,sp,-48
    291a:	f406                	sd	ra,40(sp)
    291c:	f022                	sd	s0,32(sp)
    291e:	ec26                	sd	s1,24(sp)
    2920:	e84a                	sd	s2,16(sp)
    2922:	e44e                	sd	s3,8(sp)
    2924:	e052                	sd	s4,0(sp)
    2926:	1800                	addi	s0,sp,48
    2928:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    292a:	4501                	li	a0,0
    292c:	00003097          	auipc	ra,0x3
    2930:	280080e7          	jalr	640(ra) # 5bac <sbrk>
    2934:	892a                	mv	s2,a0
  a = sbrk(0);
    2936:	4501                	li	a0,0
    2938:	00003097          	auipc	ra,0x3
    293c:	274080e7          	jalr	628(ra) # 5bac <sbrk>
    2940:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2942:	06400537          	lui	a0,0x6400
    2946:	9d05                	subw	a0,a0,s1
    2948:	00003097          	auipc	ra,0x3
    294c:	264080e7          	jalr	612(ra) # 5bac <sbrk>
  if (p != a) {
    2950:	0ca49863          	bne	s1,a0,2a20 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2954:	4501                	li	a0,0
    2956:	00003097          	auipc	ra,0x3
    295a:	256080e7          	jalr	598(ra) # 5bac <sbrk>
    295e:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2960:	00a4f963          	bgeu	s1,a0,2972 <sbrkmuch+0x5a>
    *pp = 1;
    2964:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2966:	6705                	lui	a4,0x1
    *pp = 1;
    2968:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    296c:	94ba                	add	s1,s1,a4
    296e:	fef4ede3          	bltu	s1,a5,2968 <sbrkmuch+0x50>
  *lastaddr = 99;
    2972:	064007b7          	lui	a5,0x6400
    2976:	06300713          	li	a4,99
    297a:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f0f3f>
  a = sbrk(0);
    297e:	4501                	li	a0,0
    2980:	00003097          	auipc	ra,0x3
    2984:	22c080e7          	jalr	556(ra) # 5bac <sbrk>
    2988:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    298a:	757d                	lui	a0,0xfffff
    298c:	00003097          	auipc	ra,0x3
    2990:	220080e7          	jalr	544(ra) # 5bac <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2994:	57fd                	li	a5,-1
    2996:	0af50363          	beq	a0,a5,2a3c <sbrkmuch+0x124>
  c = sbrk(0);
    299a:	4501                	li	a0,0
    299c:	00003097          	auipc	ra,0x3
    29a0:	210080e7          	jalr	528(ra) # 5bac <sbrk>
  if(c != a - PGSIZE){
    29a4:	77fd                	lui	a5,0xfffff
    29a6:	97a6                	add	a5,a5,s1
    29a8:	0af51863          	bne	a0,a5,2a58 <sbrkmuch+0x140>
  a = sbrk(0);
    29ac:	4501                	li	a0,0
    29ae:	00003097          	auipc	ra,0x3
    29b2:	1fe080e7          	jalr	510(ra) # 5bac <sbrk>
    29b6:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    29b8:	6505                	lui	a0,0x1
    29ba:	00003097          	auipc	ra,0x3
    29be:	1f2080e7          	jalr	498(ra) # 5bac <sbrk>
    29c2:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    29c4:	0aa49a63          	bne	s1,a0,2a78 <sbrkmuch+0x160>
    29c8:	4501                	li	a0,0
    29ca:	00003097          	auipc	ra,0x3
    29ce:	1e2080e7          	jalr	482(ra) # 5bac <sbrk>
    29d2:	6785                	lui	a5,0x1
    29d4:	97a6                	add	a5,a5,s1
    29d6:	0af51163          	bne	a0,a5,2a78 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    29da:	064007b7          	lui	a5,0x6400
    29de:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f0f3f>
    29e2:	06300793          	li	a5,99
    29e6:	0af70963          	beq	a4,a5,2a98 <sbrkmuch+0x180>
  a = sbrk(0);
    29ea:	4501                	li	a0,0
    29ec:	00003097          	auipc	ra,0x3
    29f0:	1c0080e7          	jalr	448(ra) # 5bac <sbrk>
    29f4:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    29f6:	4501                	li	a0,0
    29f8:	00003097          	auipc	ra,0x3
    29fc:	1b4080e7          	jalr	436(ra) # 5bac <sbrk>
    2a00:	40a9053b          	subw	a0,s2,a0
    2a04:	00003097          	auipc	ra,0x3
    2a08:	1a8080e7          	jalr	424(ra) # 5bac <sbrk>
  if(c != a){
    2a0c:	0aa49463          	bne	s1,a0,2ab4 <sbrkmuch+0x19c>
}
    2a10:	70a2                	ld	ra,40(sp)
    2a12:	7402                	ld	s0,32(sp)
    2a14:	64e2                	ld	s1,24(sp)
    2a16:	6942                	ld	s2,16(sp)
    2a18:	69a2                	ld	s3,8(sp)
    2a1a:	6a02                	ld	s4,0(sp)
    2a1c:	6145                	addi	sp,sp,48
    2a1e:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2a20:	85ce                	mv	a1,s3
    2a22:	00004517          	auipc	a0,0x4
    2a26:	47e50513          	addi	a0,a0,1150 # 6ea0 <malloc+0xf5a>
    2a2a:	00003097          	auipc	ra,0x3
    2a2e:	460080e7          	jalr	1120(ra) # 5e8a <printf>
    exit(1);
    2a32:	4505                	li	a0,1
    2a34:	00003097          	auipc	ra,0x3
    2a38:	0f0080e7          	jalr	240(ra) # 5b24 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2a3c:	85ce                	mv	a1,s3
    2a3e:	00004517          	auipc	a0,0x4
    2a42:	4aa50513          	addi	a0,a0,1194 # 6ee8 <malloc+0xfa2>
    2a46:	00003097          	auipc	ra,0x3
    2a4a:	444080e7          	jalr	1092(ra) # 5e8a <printf>
    exit(1);
    2a4e:	4505                	li	a0,1
    2a50:	00003097          	auipc	ra,0x3
    2a54:	0d4080e7          	jalr	212(ra) # 5b24 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2a58:	86aa                	mv	a3,a0
    2a5a:	8626                	mv	a2,s1
    2a5c:	85ce                	mv	a1,s3
    2a5e:	00004517          	auipc	a0,0x4
    2a62:	4aa50513          	addi	a0,a0,1194 # 6f08 <malloc+0xfc2>
    2a66:	00003097          	auipc	ra,0x3
    2a6a:	424080e7          	jalr	1060(ra) # 5e8a <printf>
    exit(1);
    2a6e:	4505                	li	a0,1
    2a70:	00003097          	auipc	ra,0x3
    2a74:	0b4080e7          	jalr	180(ra) # 5b24 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2a78:	86d2                	mv	a3,s4
    2a7a:	8626                	mv	a2,s1
    2a7c:	85ce                	mv	a1,s3
    2a7e:	00004517          	auipc	a0,0x4
    2a82:	4ca50513          	addi	a0,a0,1226 # 6f48 <malloc+0x1002>
    2a86:	00003097          	auipc	ra,0x3
    2a8a:	404080e7          	jalr	1028(ra) # 5e8a <printf>
    exit(1);
    2a8e:	4505                	li	a0,1
    2a90:	00003097          	auipc	ra,0x3
    2a94:	094080e7          	jalr	148(ra) # 5b24 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2a98:	85ce                	mv	a1,s3
    2a9a:	00004517          	auipc	a0,0x4
    2a9e:	4de50513          	addi	a0,a0,1246 # 6f78 <malloc+0x1032>
    2aa2:	00003097          	auipc	ra,0x3
    2aa6:	3e8080e7          	jalr	1000(ra) # 5e8a <printf>
    exit(1);
    2aaa:	4505                	li	a0,1
    2aac:	00003097          	auipc	ra,0x3
    2ab0:	078080e7          	jalr	120(ra) # 5b24 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2ab4:	86aa                	mv	a3,a0
    2ab6:	8626                	mv	a2,s1
    2ab8:	85ce                	mv	a1,s3
    2aba:	00004517          	auipc	a0,0x4
    2abe:	4f650513          	addi	a0,a0,1270 # 6fb0 <malloc+0x106a>
    2ac2:	00003097          	auipc	ra,0x3
    2ac6:	3c8080e7          	jalr	968(ra) # 5e8a <printf>
    exit(1);
    2aca:	4505                	li	a0,1
    2acc:	00003097          	auipc	ra,0x3
    2ad0:	058080e7          	jalr	88(ra) # 5b24 <exit>

0000000000002ad4 <sbrkarg>:
{
    2ad4:	7179                	addi	sp,sp,-48
    2ad6:	f406                	sd	ra,40(sp)
    2ad8:	f022                	sd	s0,32(sp)
    2ada:	ec26                	sd	s1,24(sp)
    2adc:	e84a                	sd	s2,16(sp)
    2ade:	e44e                	sd	s3,8(sp)
    2ae0:	1800                	addi	s0,sp,48
    2ae2:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2ae4:	6505                	lui	a0,0x1
    2ae6:	00003097          	auipc	ra,0x3
    2aea:	0c6080e7          	jalr	198(ra) # 5bac <sbrk>
    2aee:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2af0:	20100593          	li	a1,513
    2af4:	00004517          	auipc	a0,0x4
    2af8:	4e450513          	addi	a0,a0,1252 # 6fd8 <malloc+0x1092>
    2afc:	00003097          	auipc	ra,0x3
    2b00:	068080e7          	jalr	104(ra) # 5b64 <open>
    2b04:	84aa                	mv	s1,a0
  unlink("sbrk");
    2b06:	00004517          	auipc	a0,0x4
    2b0a:	4d250513          	addi	a0,a0,1234 # 6fd8 <malloc+0x1092>
    2b0e:	00003097          	auipc	ra,0x3
    2b12:	066080e7          	jalr	102(ra) # 5b74 <unlink>
  if(fd < 0)  {
    2b16:	0404c163          	bltz	s1,2b58 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2b1a:	6605                	lui	a2,0x1
    2b1c:	85ca                	mv	a1,s2
    2b1e:	8526                	mv	a0,s1
    2b20:	00003097          	auipc	ra,0x3
    2b24:	024080e7          	jalr	36(ra) # 5b44 <write>
    2b28:	04054663          	bltz	a0,2b74 <sbrkarg+0xa0>
  close(fd);
    2b2c:	8526                	mv	a0,s1
    2b2e:	00003097          	auipc	ra,0x3
    2b32:	01e080e7          	jalr	30(ra) # 5b4c <close>
  a = sbrk(PGSIZE);
    2b36:	6505                	lui	a0,0x1
    2b38:	00003097          	auipc	ra,0x3
    2b3c:	074080e7          	jalr	116(ra) # 5bac <sbrk>
  if(pipe((int *) a) != 0){
    2b40:	00003097          	auipc	ra,0x3
    2b44:	ff4080e7          	jalr	-12(ra) # 5b34 <pipe>
    2b48:	e521                	bnez	a0,2b90 <sbrkarg+0xbc>
}
    2b4a:	70a2                	ld	ra,40(sp)
    2b4c:	7402                	ld	s0,32(sp)
    2b4e:	64e2                	ld	s1,24(sp)
    2b50:	6942                	ld	s2,16(sp)
    2b52:	69a2                	ld	s3,8(sp)
    2b54:	6145                	addi	sp,sp,48
    2b56:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2b58:	85ce                	mv	a1,s3
    2b5a:	00004517          	auipc	a0,0x4
    2b5e:	48650513          	addi	a0,a0,1158 # 6fe0 <malloc+0x109a>
    2b62:	00003097          	auipc	ra,0x3
    2b66:	328080e7          	jalr	808(ra) # 5e8a <printf>
    exit(1);
    2b6a:	4505                	li	a0,1
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	fb8080e7          	jalr	-72(ra) # 5b24 <exit>
    printf("%s: write sbrk failed\n", s);
    2b74:	85ce                	mv	a1,s3
    2b76:	00004517          	auipc	a0,0x4
    2b7a:	48250513          	addi	a0,a0,1154 # 6ff8 <malloc+0x10b2>
    2b7e:	00003097          	auipc	ra,0x3
    2b82:	30c080e7          	jalr	780(ra) # 5e8a <printf>
    exit(1);
    2b86:	4505                	li	a0,1
    2b88:	00003097          	auipc	ra,0x3
    2b8c:	f9c080e7          	jalr	-100(ra) # 5b24 <exit>
    printf("%s: pipe() failed\n", s);
    2b90:	85ce                	mv	a1,s3
    2b92:	00004517          	auipc	a0,0x4
    2b96:	e4650513          	addi	a0,a0,-442 # 69d8 <malloc+0xa92>
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	2f0080e7          	jalr	752(ra) # 5e8a <printf>
    exit(1);
    2ba2:	4505                	li	a0,1
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	f80080e7          	jalr	-128(ra) # 5b24 <exit>

0000000000002bac <argptest>:
{
    2bac:	1101                	addi	sp,sp,-32
    2bae:	ec06                	sd	ra,24(sp)
    2bb0:	e822                	sd	s0,16(sp)
    2bb2:	e426                	sd	s1,8(sp)
    2bb4:	e04a                	sd	s2,0(sp)
    2bb6:	1000                	addi	s0,sp,32
    2bb8:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2bba:	4581                	li	a1,0
    2bbc:	00004517          	auipc	a0,0x4
    2bc0:	45450513          	addi	a0,a0,1108 # 7010 <malloc+0x10ca>
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	fa0080e7          	jalr	-96(ra) # 5b64 <open>
  if (fd < 0) {
    2bcc:	02054b63          	bltz	a0,2c02 <argptest+0x56>
    2bd0:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2bd2:	4501                	li	a0,0
    2bd4:	00003097          	auipc	ra,0x3
    2bd8:	fd8080e7          	jalr	-40(ra) # 5bac <sbrk>
    2bdc:	567d                	li	a2,-1
    2bde:	00c505b3          	add	a1,a0,a2
    2be2:	8526                	mv	a0,s1
    2be4:	00003097          	auipc	ra,0x3
    2be8:	f58080e7          	jalr	-168(ra) # 5b3c <read>
  close(fd);
    2bec:	8526                	mv	a0,s1
    2bee:	00003097          	auipc	ra,0x3
    2bf2:	f5e080e7          	jalr	-162(ra) # 5b4c <close>
}
    2bf6:	60e2                	ld	ra,24(sp)
    2bf8:	6442                	ld	s0,16(sp)
    2bfa:	64a2                	ld	s1,8(sp)
    2bfc:	6902                	ld	s2,0(sp)
    2bfe:	6105                	addi	sp,sp,32
    2c00:	8082                	ret
    printf("%s: open failed\n", s);
    2c02:	85ca                	mv	a1,s2
    2c04:	00004517          	auipc	a0,0x4
    2c08:	ce450513          	addi	a0,a0,-796 # 68e8 <malloc+0x9a2>
    2c0c:	00003097          	auipc	ra,0x3
    2c10:	27e080e7          	jalr	638(ra) # 5e8a <printf>
    exit(1);
    2c14:	4505                	li	a0,1
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	f0e080e7          	jalr	-242(ra) # 5b24 <exit>

0000000000002c1e <sbrkbugs>:
{
    2c1e:	1141                	addi	sp,sp,-16
    2c20:	e406                	sd	ra,8(sp)
    2c22:	e022                	sd	s0,0(sp)
    2c24:	0800                	addi	s0,sp,16
  int pid = fork();
    2c26:	00003097          	auipc	ra,0x3
    2c2a:	ef6080e7          	jalr	-266(ra) # 5b1c <fork>
  if(pid < 0){
    2c2e:	02054263          	bltz	a0,2c52 <sbrkbugs+0x34>
  if(pid == 0){
    2c32:	ed0d                	bnez	a0,2c6c <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2c34:	00003097          	auipc	ra,0x3
    2c38:	f78080e7          	jalr	-136(ra) # 5bac <sbrk>
    sbrk(-sz);
    2c3c:	40a0053b          	negw	a0,a0
    2c40:	00003097          	auipc	ra,0x3
    2c44:	f6c080e7          	jalr	-148(ra) # 5bac <sbrk>
    exit(0);
    2c48:	4501                	li	a0,0
    2c4a:	00003097          	auipc	ra,0x3
    2c4e:	eda080e7          	jalr	-294(ra) # 5b24 <exit>
    printf("fork failed\n");
    2c52:	00004517          	auipc	a0,0x4
    2c56:	09e50513          	addi	a0,a0,158 # 6cf0 <malloc+0xdaa>
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	230080e7          	jalr	560(ra) # 5e8a <printf>
    exit(1);
    2c62:	4505                	li	a0,1
    2c64:	00003097          	auipc	ra,0x3
    2c68:	ec0080e7          	jalr	-320(ra) # 5b24 <exit>
  wait(0);
    2c6c:	4501                	li	a0,0
    2c6e:	00003097          	auipc	ra,0x3
    2c72:	ebe080e7          	jalr	-322(ra) # 5b2c <wait>
  pid = fork();
    2c76:	00003097          	auipc	ra,0x3
    2c7a:	ea6080e7          	jalr	-346(ra) # 5b1c <fork>
  if(pid < 0){
    2c7e:	02054563          	bltz	a0,2ca8 <sbrkbugs+0x8a>
  if(pid == 0){
    2c82:	e121                	bnez	a0,2cc2 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2c84:	00003097          	auipc	ra,0x3
    2c88:	f28080e7          	jalr	-216(ra) # 5bac <sbrk>
    sbrk(-(sz - 3500));
    2c8c:	6785                	lui	a5,0x1
    2c8e:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x5c>
    2c92:	40a7853b          	subw	a0,a5,a0
    2c96:	00003097          	auipc	ra,0x3
    2c9a:	f16080e7          	jalr	-234(ra) # 5bac <sbrk>
    exit(0);
    2c9e:	4501                	li	a0,0
    2ca0:	00003097          	auipc	ra,0x3
    2ca4:	e84080e7          	jalr	-380(ra) # 5b24 <exit>
    printf("fork failed\n");
    2ca8:	00004517          	auipc	a0,0x4
    2cac:	04850513          	addi	a0,a0,72 # 6cf0 <malloc+0xdaa>
    2cb0:	00003097          	auipc	ra,0x3
    2cb4:	1da080e7          	jalr	474(ra) # 5e8a <printf>
    exit(1);
    2cb8:	4505                	li	a0,1
    2cba:	00003097          	auipc	ra,0x3
    2cbe:	e6a080e7          	jalr	-406(ra) # 5b24 <exit>
  wait(0);
    2cc2:	4501                	li	a0,0
    2cc4:	00003097          	auipc	ra,0x3
    2cc8:	e68080e7          	jalr	-408(ra) # 5b2c <wait>
  pid = fork();
    2ccc:	00003097          	auipc	ra,0x3
    2cd0:	e50080e7          	jalr	-432(ra) # 5b1c <fork>
  if(pid < 0){
    2cd4:	02054a63          	bltz	a0,2d08 <sbrkbugs+0xea>
  if(pid == 0){
    2cd8:	e529                	bnez	a0,2d22 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2cda:	00003097          	auipc	ra,0x3
    2cde:	ed2080e7          	jalr	-302(ra) # 5bac <sbrk>
    2ce2:	67ad                	lui	a5,0xb
    2ce4:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0xe60>
    2ce8:	40a7853b          	subw	a0,a5,a0
    2cec:	00003097          	auipc	ra,0x3
    2cf0:	ec0080e7          	jalr	-320(ra) # 5bac <sbrk>
    sbrk(-10);
    2cf4:	5559                	li	a0,-10
    2cf6:	00003097          	auipc	ra,0x3
    2cfa:	eb6080e7          	jalr	-330(ra) # 5bac <sbrk>
    exit(0);
    2cfe:	4501                	li	a0,0
    2d00:	00003097          	auipc	ra,0x3
    2d04:	e24080e7          	jalr	-476(ra) # 5b24 <exit>
    printf("fork failed\n");
    2d08:	00004517          	auipc	a0,0x4
    2d0c:	fe850513          	addi	a0,a0,-24 # 6cf0 <malloc+0xdaa>
    2d10:	00003097          	auipc	ra,0x3
    2d14:	17a080e7          	jalr	378(ra) # 5e8a <printf>
    exit(1);
    2d18:	4505                	li	a0,1
    2d1a:	00003097          	auipc	ra,0x3
    2d1e:	e0a080e7          	jalr	-502(ra) # 5b24 <exit>
  wait(0);
    2d22:	4501                	li	a0,0
    2d24:	00003097          	auipc	ra,0x3
    2d28:	e08080e7          	jalr	-504(ra) # 5b2c <wait>
  exit(0);
    2d2c:	4501                	li	a0,0
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	df6080e7          	jalr	-522(ra) # 5b24 <exit>

0000000000002d36 <sbrklast>:
{
    2d36:	7179                	addi	sp,sp,-48
    2d38:	f406                	sd	ra,40(sp)
    2d3a:	f022                	sd	s0,32(sp)
    2d3c:	ec26                	sd	s1,24(sp)
    2d3e:	e84a                	sd	s2,16(sp)
    2d40:	e44e                	sd	s3,8(sp)
    2d42:	e052                	sd	s4,0(sp)
    2d44:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2d46:	4501                	li	a0,0
    2d48:	00003097          	auipc	ra,0x3
    2d4c:	e64080e7          	jalr	-412(ra) # 5bac <sbrk>
  if((top % 4096) != 0)
    2d50:	03451793          	slli	a5,a0,0x34
    2d54:	ebd9                	bnez	a5,2dea <sbrklast+0xb4>
  sbrk(4096);
    2d56:	6505                	lui	a0,0x1
    2d58:	00003097          	auipc	ra,0x3
    2d5c:	e54080e7          	jalr	-428(ra) # 5bac <sbrk>
  sbrk(10);
    2d60:	4529                	li	a0,10
    2d62:	00003097          	auipc	ra,0x3
    2d66:	e4a080e7          	jalr	-438(ra) # 5bac <sbrk>
  sbrk(-20);
    2d6a:	5531                	li	a0,-20
    2d6c:	00003097          	auipc	ra,0x3
    2d70:	e40080e7          	jalr	-448(ra) # 5bac <sbrk>
  top = (uint64) sbrk(0);
    2d74:	4501                	li	a0,0
    2d76:	00003097          	auipc	ra,0x3
    2d7a:	e36080e7          	jalr	-458(ra) # 5bac <sbrk>
    2d7e:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2d80:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x24>
  p[0] = 'x';
    2d84:	07800a13          	li	s4,120
    2d88:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2d8c:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2d90:	20200593          	li	a1,514
    2d94:	854a                	mv	a0,s2
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	dce080e7          	jalr	-562(ra) # 5b64 <open>
    2d9e:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2da0:	4605                	li	a2,1
    2da2:	85ca                	mv	a1,s2
    2da4:	00003097          	auipc	ra,0x3
    2da8:	da0080e7          	jalr	-608(ra) # 5b44 <write>
  close(fd);
    2dac:	854e                	mv	a0,s3
    2dae:	00003097          	auipc	ra,0x3
    2db2:	d9e080e7          	jalr	-610(ra) # 5b4c <close>
  fd = open(p, O_RDWR);
    2db6:	4589                	li	a1,2
    2db8:	854a                	mv	a0,s2
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	daa080e7          	jalr	-598(ra) # 5b64 <open>
  p[0] = '\0';
    2dc2:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2dc6:	4605                	li	a2,1
    2dc8:	85ca                	mv	a1,s2
    2dca:	00003097          	auipc	ra,0x3
    2dce:	d72080e7          	jalr	-654(ra) # 5b3c <read>
  if(p[0] != 'x')
    2dd2:	fc04c783          	lbu	a5,-64(s1)
    2dd6:	03479563          	bne	a5,s4,2e00 <sbrklast+0xca>
}
    2dda:	70a2                	ld	ra,40(sp)
    2ddc:	7402                	ld	s0,32(sp)
    2dde:	64e2                	ld	s1,24(sp)
    2de0:	6942                	ld	s2,16(sp)
    2de2:	69a2                	ld	s3,8(sp)
    2de4:	6a02                	ld	s4,0(sp)
    2de6:	6145                	addi	sp,sp,48
    2de8:	8082                	ret
    sbrk(4096 - (top % 4096));
    2dea:	6785                	lui	a5,0x1
    2dec:	fff78713          	addi	a4,a5,-1 # fff <bigdir+0x63>
    2df0:	8d79                	and	a0,a0,a4
    2df2:	40a7853b          	subw	a0,a5,a0
    2df6:	00003097          	auipc	ra,0x3
    2dfa:	db6080e7          	jalr	-586(ra) # 5bac <sbrk>
    2dfe:	bfa1                	j	2d56 <sbrklast+0x20>
    exit(1);
    2e00:	4505                	li	a0,1
    2e02:	00003097          	auipc	ra,0x3
    2e06:	d22080e7          	jalr	-734(ra) # 5b24 <exit>

0000000000002e0a <sbrk8000>:
{
    2e0a:	1141                	addi	sp,sp,-16
    2e0c:	e406                	sd	ra,8(sp)
    2e0e:	e022                	sd	s0,0(sp)
    2e10:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2e12:	80000537          	lui	a0,0x80000
    2e16:	0511                	addi	a0,a0,4 # ffffffff80000004 <__BSS_END__+0xffffffff7fff0f44>
    2e18:	00003097          	auipc	ra,0x3
    2e1c:	d94080e7          	jalr	-620(ra) # 5bac <sbrk>
  volatile char *top = sbrk(0);
    2e20:	4501                	li	a0,0
    2e22:	00003097          	auipc	ra,0x3
    2e26:	d8a080e7          	jalr	-630(ra) # 5bac <sbrk>
  *(top-1) = *(top-1) + 1;
    2e2a:	fff54783          	lbu	a5,-1(a0)
    2e2e:	0785                	addi	a5,a5,1
    2e30:	0ff7f793          	zext.b	a5,a5
    2e34:	fef50fa3          	sb	a5,-1(a0)
}
    2e38:	60a2                	ld	ra,8(sp)
    2e3a:	6402                	ld	s0,0(sp)
    2e3c:	0141                	addi	sp,sp,16
    2e3e:	8082                	ret

0000000000002e40 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2e40:	711d                	addi	sp,sp,-96
    2e42:	ec86                	sd	ra,88(sp)
    2e44:	e8a2                	sd	s0,80(sp)
    2e46:	e4a6                	sd	s1,72(sp)
    2e48:	e0ca                	sd	s2,64(sp)
    2e4a:	fc4e                	sd	s3,56(sp)
    2e4c:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    2e4e:	4901                	li	s2,0
    2e50:	49bd                	li	s3,15
    int pid = fork();
    2e52:	00003097          	auipc	ra,0x3
    2e56:	cca080e7          	jalr	-822(ra) # 5b1c <fork>
    2e5a:	84aa                	mv	s1,a0
    if(pid < 0){
    2e5c:	02054263          	bltz	a0,2e80 <execout+0x40>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2e60:	cd1d                	beqz	a0,2e9e <execout+0x5e>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2e62:	4501                	li	a0,0
    2e64:	00003097          	auipc	ra,0x3
    2e68:	cc8080e7          	jalr	-824(ra) # 5b2c <wait>
  for(int avail = 0; avail < 15; avail++){
    2e6c:	2905                	addiw	s2,s2,1
    2e6e:	ff3912e3          	bne	s2,s3,2e52 <execout+0x12>
    2e72:	f852                	sd	s4,48(sp)
    2e74:	f456                	sd	s5,40(sp)
    }
  }

  exit(0);
    2e76:	4501                	li	a0,0
    2e78:	00003097          	auipc	ra,0x3
    2e7c:	cac080e7          	jalr	-852(ra) # 5b24 <exit>
    2e80:	f852                	sd	s4,48(sp)
    2e82:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    2e84:	00004517          	auipc	a0,0x4
    2e88:	e6c50513          	addi	a0,a0,-404 # 6cf0 <malloc+0xdaa>
    2e8c:	00003097          	auipc	ra,0x3
    2e90:	ffe080e7          	jalr	-2(ra) # 5e8a <printf>
      exit(1);
    2e94:	4505                	li	a0,1
    2e96:	00003097          	auipc	ra,0x3
    2e9a:	c8e080e7          	jalr	-882(ra) # 5b24 <exit>
    2e9e:	f852                	sd	s4,48(sp)
    2ea0:	f456                	sd	s5,40(sp)
        uint64 a = (uint64) sbrk(4096);
    2ea2:	6985                	lui	s3,0x1
        if(a == 0xffffffffffffffffLL)
    2ea4:	5a7d                	li	s4,-1
        *(char*)(a + 4096 - 1) = 1;
    2ea6:	4a85                	li	s5,1
        uint64 a = (uint64) sbrk(4096);
    2ea8:	854e                	mv	a0,s3
    2eaa:	00003097          	auipc	ra,0x3
    2eae:	d02080e7          	jalr	-766(ra) # 5bac <sbrk>
        if(a == 0xffffffffffffffffLL)
    2eb2:	01450663          	beq	a0,s4,2ebe <execout+0x7e>
        *(char*)(a + 4096 - 1) = 1;
    2eb6:	954e                	add	a0,a0,s3
    2eb8:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    2ebc:	b7f5                	j	2ea8 <execout+0x68>
        sbrk(-4096);
    2ebe:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    2ec0:	01205a63          	blez	s2,2ed4 <execout+0x94>
        sbrk(-4096);
    2ec4:	854e                	mv	a0,s3
    2ec6:	00003097          	auipc	ra,0x3
    2eca:	ce6080e7          	jalr	-794(ra) # 5bac <sbrk>
      for(int i = 0; i < avail; i++)
    2ece:	2485                	addiw	s1,s1,1
    2ed0:	ff249ae3          	bne	s1,s2,2ec4 <execout+0x84>
      close(1);
    2ed4:	4505                	li	a0,1
    2ed6:	00003097          	auipc	ra,0x3
    2eda:	c76080e7          	jalr	-906(ra) # 5b4c <close>
      char *args[] = { "echo", "x", 0 };
    2ede:	00003517          	auipc	a0,0x3
    2ee2:	19a50513          	addi	a0,a0,410 # 6078 <malloc+0x132>
    2ee6:	faa43423          	sd	a0,-88(s0)
    2eea:	00003797          	auipc	a5,0x3
    2eee:	1fe78793          	addi	a5,a5,510 # 60e8 <malloc+0x1a2>
    2ef2:	faf43823          	sd	a5,-80(s0)
    2ef6:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    2efa:	fa840593          	addi	a1,s0,-88
    2efe:	00003097          	auipc	ra,0x3
    2f02:	c5e080e7          	jalr	-930(ra) # 5b5c <exec>
      exit(0);
    2f06:	4501                	li	a0,0
    2f08:	00003097          	auipc	ra,0x3
    2f0c:	c1c080e7          	jalr	-996(ra) # 5b24 <exit>

0000000000002f10 <fourteen>:
{
    2f10:	1101                	addi	sp,sp,-32
    2f12:	ec06                	sd	ra,24(sp)
    2f14:	e822                	sd	s0,16(sp)
    2f16:	e426                	sd	s1,8(sp)
    2f18:	1000                	addi	s0,sp,32
    2f1a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2f1c:	00004517          	auipc	a0,0x4
    2f20:	2cc50513          	addi	a0,a0,716 # 71e8 <malloc+0x12a2>
    2f24:	00003097          	auipc	ra,0x3
    2f28:	c68080e7          	jalr	-920(ra) # 5b8c <mkdir>
    2f2c:	e165                	bnez	a0,300c <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2f2e:	00004517          	auipc	a0,0x4
    2f32:	11250513          	addi	a0,a0,274 # 7040 <malloc+0x10fa>
    2f36:	00003097          	auipc	ra,0x3
    2f3a:	c56080e7          	jalr	-938(ra) # 5b8c <mkdir>
    2f3e:	e56d                	bnez	a0,3028 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2f40:	20000593          	li	a1,512
    2f44:	00004517          	auipc	a0,0x4
    2f48:	15450513          	addi	a0,a0,340 # 7098 <malloc+0x1152>
    2f4c:	00003097          	auipc	ra,0x3
    2f50:	c18080e7          	jalr	-1000(ra) # 5b64 <open>
  if(fd < 0){
    2f54:	0e054863          	bltz	a0,3044 <fourteen+0x134>
  close(fd);
    2f58:	00003097          	auipc	ra,0x3
    2f5c:	bf4080e7          	jalr	-1036(ra) # 5b4c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2f60:	4581                	li	a1,0
    2f62:	00004517          	auipc	a0,0x4
    2f66:	1ae50513          	addi	a0,a0,430 # 7110 <malloc+0x11ca>
    2f6a:	00003097          	auipc	ra,0x3
    2f6e:	bfa080e7          	jalr	-1030(ra) # 5b64 <open>
  if(fd < 0){
    2f72:	0e054763          	bltz	a0,3060 <fourteen+0x150>
  close(fd);
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	bd6080e7          	jalr	-1066(ra) # 5b4c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	20250513          	addi	a0,a0,514 # 7180 <malloc+0x123a>
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	c06080e7          	jalr	-1018(ra) # 5b8c <mkdir>
    2f8e:	c57d                	beqz	a0,307c <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2f90:	00004517          	auipc	a0,0x4
    2f94:	24850513          	addi	a0,a0,584 # 71d8 <malloc+0x1292>
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	bf4080e7          	jalr	-1036(ra) # 5b8c <mkdir>
    2fa0:	cd65                	beqz	a0,3098 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2fa2:	00004517          	auipc	a0,0x4
    2fa6:	23650513          	addi	a0,a0,566 # 71d8 <malloc+0x1292>
    2faa:	00003097          	auipc	ra,0x3
    2fae:	bca080e7          	jalr	-1078(ra) # 5b74 <unlink>
  unlink("12345678901234/12345678901234");
    2fb2:	00004517          	auipc	a0,0x4
    2fb6:	1ce50513          	addi	a0,a0,462 # 7180 <malloc+0x123a>
    2fba:	00003097          	auipc	ra,0x3
    2fbe:	bba080e7          	jalr	-1094(ra) # 5b74 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2fc2:	00004517          	auipc	a0,0x4
    2fc6:	14e50513          	addi	a0,a0,334 # 7110 <malloc+0x11ca>
    2fca:	00003097          	auipc	ra,0x3
    2fce:	baa080e7          	jalr	-1110(ra) # 5b74 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2fd2:	00004517          	auipc	a0,0x4
    2fd6:	0c650513          	addi	a0,a0,198 # 7098 <malloc+0x1152>
    2fda:	00003097          	auipc	ra,0x3
    2fde:	b9a080e7          	jalr	-1126(ra) # 5b74 <unlink>
  unlink("12345678901234/123456789012345");
    2fe2:	00004517          	auipc	a0,0x4
    2fe6:	05e50513          	addi	a0,a0,94 # 7040 <malloc+0x10fa>
    2fea:	00003097          	auipc	ra,0x3
    2fee:	b8a080e7          	jalr	-1142(ra) # 5b74 <unlink>
  unlink("12345678901234");
    2ff2:	00004517          	auipc	a0,0x4
    2ff6:	1f650513          	addi	a0,a0,502 # 71e8 <malloc+0x12a2>
    2ffa:	00003097          	auipc	ra,0x3
    2ffe:	b7a080e7          	jalr	-1158(ra) # 5b74 <unlink>
}
    3002:	60e2                	ld	ra,24(sp)
    3004:	6442                	ld	s0,16(sp)
    3006:	64a2                	ld	s1,8(sp)
    3008:	6105                	addi	sp,sp,32
    300a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    300c:	85a6                	mv	a1,s1
    300e:	00004517          	auipc	a0,0x4
    3012:	00a50513          	addi	a0,a0,10 # 7018 <malloc+0x10d2>
    3016:	00003097          	auipc	ra,0x3
    301a:	e74080e7          	jalr	-396(ra) # 5e8a <printf>
    exit(1);
    301e:	4505                	li	a0,1
    3020:	00003097          	auipc	ra,0x3
    3024:	b04080e7          	jalr	-1276(ra) # 5b24 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    3028:	85a6                	mv	a1,s1
    302a:	00004517          	auipc	a0,0x4
    302e:	03650513          	addi	a0,a0,54 # 7060 <malloc+0x111a>
    3032:	00003097          	auipc	ra,0x3
    3036:	e58080e7          	jalr	-424(ra) # 5e8a <printf>
    exit(1);
    303a:	4505                	li	a0,1
    303c:	00003097          	auipc	ra,0x3
    3040:	ae8080e7          	jalr	-1304(ra) # 5b24 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3044:	85a6                	mv	a1,s1
    3046:	00004517          	auipc	a0,0x4
    304a:	08250513          	addi	a0,a0,130 # 70c8 <malloc+0x1182>
    304e:	00003097          	auipc	ra,0x3
    3052:	e3c080e7          	jalr	-452(ra) # 5e8a <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	00003097          	auipc	ra,0x3
    305c:	acc080e7          	jalr	-1332(ra) # 5b24 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3060:	85a6                	mv	a1,s1
    3062:	00004517          	auipc	a0,0x4
    3066:	0de50513          	addi	a0,a0,222 # 7140 <malloc+0x11fa>
    306a:	00003097          	auipc	ra,0x3
    306e:	e20080e7          	jalr	-480(ra) # 5e8a <printf>
    exit(1);
    3072:	4505                	li	a0,1
    3074:	00003097          	auipc	ra,0x3
    3078:	ab0080e7          	jalr	-1360(ra) # 5b24 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    307c:	85a6                	mv	a1,s1
    307e:	00004517          	auipc	a0,0x4
    3082:	12250513          	addi	a0,a0,290 # 71a0 <malloc+0x125a>
    3086:	00003097          	auipc	ra,0x3
    308a:	e04080e7          	jalr	-508(ra) # 5e8a <printf>
    exit(1);
    308e:	4505                	li	a0,1
    3090:	00003097          	auipc	ra,0x3
    3094:	a94080e7          	jalr	-1388(ra) # 5b24 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    3098:	85a6                	mv	a1,s1
    309a:	00004517          	auipc	a0,0x4
    309e:	15e50513          	addi	a0,a0,350 # 71f8 <malloc+0x12b2>
    30a2:	00003097          	auipc	ra,0x3
    30a6:	de8080e7          	jalr	-536(ra) # 5e8a <printf>
    exit(1);
    30aa:	4505                	li	a0,1
    30ac:	00003097          	auipc	ra,0x3
    30b0:	a78080e7          	jalr	-1416(ra) # 5b24 <exit>

00000000000030b4 <iputtest>:
{
    30b4:	1101                	addi	sp,sp,-32
    30b6:	ec06                	sd	ra,24(sp)
    30b8:	e822                	sd	s0,16(sp)
    30ba:	e426                	sd	s1,8(sp)
    30bc:	1000                	addi	s0,sp,32
    30be:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    30c0:	00004517          	auipc	a0,0x4
    30c4:	17050513          	addi	a0,a0,368 # 7230 <malloc+0x12ea>
    30c8:	00003097          	auipc	ra,0x3
    30cc:	ac4080e7          	jalr	-1340(ra) # 5b8c <mkdir>
    30d0:	04054563          	bltz	a0,311a <iputtest+0x66>
  if(chdir("iputdir") < 0){
    30d4:	00004517          	auipc	a0,0x4
    30d8:	15c50513          	addi	a0,a0,348 # 7230 <malloc+0x12ea>
    30dc:	00003097          	auipc	ra,0x3
    30e0:	ab8080e7          	jalr	-1352(ra) # 5b94 <chdir>
    30e4:	04054963          	bltz	a0,3136 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    30e8:	00004517          	auipc	a0,0x4
    30ec:	18850513          	addi	a0,a0,392 # 7270 <malloc+0x132a>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	a84080e7          	jalr	-1404(ra) # 5b74 <unlink>
    30f8:	04054d63          	bltz	a0,3152 <iputtest+0x9e>
  if(chdir("/") < 0){
    30fc:	00004517          	auipc	a0,0x4
    3100:	1a450513          	addi	a0,a0,420 # 72a0 <malloc+0x135a>
    3104:	00003097          	auipc	ra,0x3
    3108:	a90080e7          	jalr	-1392(ra) # 5b94 <chdir>
    310c:	06054163          	bltz	a0,316e <iputtest+0xba>
}
    3110:	60e2                	ld	ra,24(sp)
    3112:	6442                	ld	s0,16(sp)
    3114:	64a2                	ld	s1,8(sp)
    3116:	6105                	addi	sp,sp,32
    3118:	8082                	ret
    printf("%s: mkdir failed\n", s);
    311a:	85a6                	mv	a1,s1
    311c:	00004517          	auipc	a0,0x4
    3120:	11c50513          	addi	a0,a0,284 # 7238 <malloc+0x12f2>
    3124:	00003097          	auipc	ra,0x3
    3128:	d66080e7          	jalr	-666(ra) # 5e8a <printf>
    exit(1);
    312c:	4505                	li	a0,1
    312e:	00003097          	auipc	ra,0x3
    3132:	9f6080e7          	jalr	-1546(ra) # 5b24 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3136:	85a6                	mv	a1,s1
    3138:	00004517          	auipc	a0,0x4
    313c:	11850513          	addi	a0,a0,280 # 7250 <malloc+0x130a>
    3140:	00003097          	auipc	ra,0x3
    3144:	d4a080e7          	jalr	-694(ra) # 5e8a <printf>
    exit(1);
    3148:	4505                	li	a0,1
    314a:	00003097          	auipc	ra,0x3
    314e:	9da080e7          	jalr	-1574(ra) # 5b24 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3152:	85a6                	mv	a1,s1
    3154:	00004517          	auipc	a0,0x4
    3158:	12c50513          	addi	a0,a0,300 # 7280 <malloc+0x133a>
    315c:	00003097          	auipc	ra,0x3
    3160:	d2e080e7          	jalr	-722(ra) # 5e8a <printf>
    exit(1);
    3164:	4505                	li	a0,1
    3166:	00003097          	auipc	ra,0x3
    316a:	9be080e7          	jalr	-1602(ra) # 5b24 <exit>
    printf("%s: chdir / failed\n", s);
    316e:	85a6                	mv	a1,s1
    3170:	00004517          	auipc	a0,0x4
    3174:	13850513          	addi	a0,a0,312 # 72a8 <malloc+0x1362>
    3178:	00003097          	auipc	ra,0x3
    317c:	d12080e7          	jalr	-750(ra) # 5e8a <printf>
    exit(1);
    3180:	4505                	li	a0,1
    3182:	00003097          	auipc	ra,0x3
    3186:	9a2080e7          	jalr	-1630(ra) # 5b24 <exit>

000000000000318a <exitiputtest>:
{
    318a:	7179                	addi	sp,sp,-48
    318c:	f406                	sd	ra,40(sp)
    318e:	f022                	sd	s0,32(sp)
    3190:	ec26                	sd	s1,24(sp)
    3192:	1800                	addi	s0,sp,48
    3194:	84aa                	mv	s1,a0
  pid = fork();
    3196:	00003097          	auipc	ra,0x3
    319a:	986080e7          	jalr	-1658(ra) # 5b1c <fork>
  if(pid < 0){
    319e:	04054663          	bltz	a0,31ea <exitiputtest+0x60>
  if(pid == 0){
    31a2:	ed45                	bnez	a0,325a <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    31a4:	00004517          	auipc	a0,0x4
    31a8:	08c50513          	addi	a0,a0,140 # 7230 <malloc+0x12ea>
    31ac:	00003097          	auipc	ra,0x3
    31b0:	9e0080e7          	jalr	-1568(ra) # 5b8c <mkdir>
    31b4:	04054963          	bltz	a0,3206 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    31b8:	00004517          	auipc	a0,0x4
    31bc:	07850513          	addi	a0,a0,120 # 7230 <malloc+0x12ea>
    31c0:	00003097          	auipc	ra,0x3
    31c4:	9d4080e7          	jalr	-1580(ra) # 5b94 <chdir>
    31c8:	04054d63          	bltz	a0,3222 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    31cc:	00004517          	auipc	a0,0x4
    31d0:	0a450513          	addi	a0,a0,164 # 7270 <malloc+0x132a>
    31d4:	00003097          	auipc	ra,0x3
    31d8:	9a0080e7          	jalr	-1632(ra) # 5b74 <unlink>
    31dc:	06054163          	bltz	a0,323e <exitiputtest+0xb4>
    exit(0);
    31e0:	4501                	li	a0,0
    31e2:	00003097          	auipc	ra,0x3
    31e6:	942080e7          	jalr	-1726(ra) # 5b24 <exit>
    printf("%s: fork failed\n", s);
    31ea:	85a6                	mv	a1,s1
    31ec:	00003517          	auipc	a0,0x3
    31f0:	6e450513          	addi	a0,a0,1764 # 68d0 <malloc+0x98a>
    31f4:	00003097          	auipc	ra,0x3
    31f8:	c96080e7          	jalr	-874(ra) # 5e8a <printf>
    exit(1);
    31fc:	4505                	li	a0,1
    31fe:	00003097          	auipc	ra,0x3
    3202:	926080e7          	jalr	-1754(ra) # 5b24 <exit>
      printf("%s: mkdir failed\n", s);
    3206:	85a6                	mv	a1,s1
    3208:	00004517          	auipc	a0,0x4
    320c:	03050513          	addi	a0,a0,48 # 7238 <malloc+0x12f2>
    3210:	00003097          	auipc	ra,0x3
    3214:	c7a080e7          	jalr	-902(ra) # 5e8a <printf>
      exit(1);
    3218:	4505                	li	a0,1
    321a:	00003097          	auipc	ra,0x3
    321e:	90a080e7          	jalr	-1782(ra) # 5b24 <exit>
      printf("%s: child chdir failed\n", s);
    3222:	85a6                	mv	a1,s1
    3224:	00004517          	auipc	a0,0x4
    3228:	09c50513          	addi	a0,a0,156 # 72c0 <malloc+0x137a>
    322c:	00003097          	auipc	ra,0x3
    3230:	c5e080e7          	jalr	-930(ra) # 5e8a <printf>
      exit(1);
    3234:	4505                	li	a0,1
    3236:	00003097          	auipc	ra,0x3
    323a:	8ee080e7          	jalr	-1810(ra) # 5b24 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    323e:	85a6                	mv	a1,s1
    3240:	00004517          	auipc	a0,0x4
    3244:	04050513          	addi	a0,a0,64 # 7280 <malloc+0x133a>
    3248:	00003097          	auipc	ra,0x3
    324c:	c42080e7          	jalr	-958(ra) # 5e8a <printf>
      exit(1);
    3250:	4505                	li	a0,1
    3252:	00003097          	auipc	ra,0x3
    3256:	8d2080e7          	jalr	-1838(ra) # 5b24 <exit>
  wait(&xstatus);
    325a:	fdc40513          	addi	a0,s0,-36
    325e:	00003097          	auipc	ra,0x3
    3262:	8ce080e7          	jalr	-1842(ra) # 5b2c <wait>
  exit(xstatus);
    3266:	fdc42503          	lw	a0,-36(s0)
    326a:	00003097          	auipc	ra,0x3
    326e:	8ba080e7          	jalr	-1862(ra) # 5b24 <exit>

0000000000003272 <dirtest>:
{
    3272:	1101                	addi	sp,sp,-32
    3274:	ec06                	sd	ra,24(sp)
    3276:	e822                	sd	s0,16(sp)
    3278:	e426                	sd	s1,8(sp)
    327a:	1000                	addi	s0,sp,32
    327c:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    327e:	00004517          	auipc	a0,0x4
    3282:	05a50513          	addi	a0,a0,90 # 72d8 <malloc+0x1392>
    3286:	00003097          	auipc	ra,0x3
    328a:	906080e7          	jalr	-1786(ra) # 5b8c <mkdir>
    328e:	04054563          	bltz	a0,32d8 <dirtest+0x66>
  if(chdir("dir0") < 0){
    3292:	00004517          	auipc	a0,0x4
    3296:	04650513          	addi	a0,a0,70 # 72d8 <malloc+0x1392>
    329a:	00003097          	auipc	ra,0x3
    329e:	8fa080e7          	jalr	-1798(ra) # 5b94 <chdir>
    32a2:	04054963          	bltz	a0,32f4 <dirtest+0x82>
  if(chdir("..") < 0){
    32a6:	00004517          	auipc	a0,0x4
    32aa:	05250513          	addi	a0,a0,82 # 72f8 <malloc+0x13b2>
    32ae:	00003097          	auipc	ra,0x3
    32b2:	8e6080e7          	jalr	-1818(ra) # 5b94 <chdir>
    32b6:	04054d63          	bltz	a0,3310 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    32ba:	00004517          	auipc	a0,0x4
    32be:	01e50513          	addi	a0,a0,30 # 72d8 <malloc+0x1392>
    32c2:	00003097          	auipc	ra,0x3
    32c6:	8b2080e7          	jalr	-1870(ra) # 5b74 <unlink>
    32ca:	06054163          	bltz	a0,332c <dirtest+0xba>
}
    32ce:	60e2                	ld	ra,24(sp)
    32d0:	6442                	ld	s0,16(sp)
    32d2:	64a2                	ld	s1,8(sp)
    32d4:	6105                	addi	sp,sp,32
    32d6:	8082                	ret
    printf("%s: mkdir failed\n", s);
    32d8:	85a6                	mv	a1,s1
    32da:	00004517          	auipc	a0,0x4
    32de:	f5e50513          	addi	a0,a0,-162 # 7238 <malloc+0x12f2>
    32e2:	00003097          	auipc	ra,0x3
    32e6:	ba8080e7          	jalr	-1112(ra) # 5e8a <printf>
    exit(1);
    32ea:	4505                	li	a0,1
    32ec:	00003097          	auipc	ra,0x3
    32f0:	838080e7          	jalr	-1992(ra) # 5b24 <exit>
    printf("%s: chdir dir0 failed\n", s);
    32f4:	85a6                	mv	a1,s1
    32f6:	00004517          	auipc	a0,0x4
    32fa:	fea50513          	addi	a0,a0,-22 # 72e0 <malloc+0x139a>
    32fe:	00003097          	auipc	ra,0x3
    3302:	b8c080e7          	jalr	-1140(ra) # 5e8a <printf>
    exit(1);
    3306:	4505                	li	a0,1
    3308:	00003097          	auipc	ra,0x3
    330c:	81c080e7          	jalr	-2020(ra) # 5b24 <exit>
    printf("%s: chdir .. failed\n", s);
    3310:	85a6                	mv	a1,s1
    3312:	00004517          	auipc	a0,0x4
    3316:	fee50513          	addi	a0,a0,-18 # 7300 <malloc+0x13ba>
    331a:	00003097          	auipc	ra,0x3
    331e:	b70080e7          	jalr	-1168(ra) # 5e8a <printf>
    exit(1);
    3322:	4505                	li	a0,1
    3324:	00003097          	auipc	ra,0x3
    3328:	800080e7          	jalr	-2048(ra) # 5b24 <exit>
    printf("%s: unlink dir0 failed\n", s);
    332c:	85a6                	mv	a1,s1
    332e:	00004517          	auipc	a0,0x4
    3332:	fea50513          	addi	a0,a0,-22 # 7318 <malloc+0x13d2>
    3336:	00003097          	auipc	ra,0x3
    333a:	b54080e7          	jalr	-1196(ra) # 5e8a <printf>
    exit(1);
    333e:	4505                	li	a0,1
    3340:	00002097          	auipc	ra,0x2
    3344:	7e4080e7          	jalr	2020(ra) # 5b24 <exit>

0000000000003348 <subdir>:
{
    3348:	1101                	addi	sp,sp,-32
    334a:	ec06                	sd	ra,24(sp)
    334c:	e822                	sd	s0,16(sp)
    334e:	e426                	sd	s1,8(sp)
    3350:	e04a                	sd	s2,0(sp)
    3352:	1000                	addi	s0,sp,32
    3354:	892a                	mv	s2,a0
  unlink("ff");
    3356:	00004517          	auipc	a0,0x4
    335a:	10a50513          	addi	a0,a0,266 # 7460 <malloc+0x151a>
    335e:	00003097          	auipc	ra,0x3
    3362:	816080e7          	jalr	-2026(ra) # 5b74 <unlink>
  if(mkdir("dd") != 0){
    3366:	00004517          	auipc	a0,0x4
    336a:	fca50513          	addi	a0,a0,-54 # 7330 <malloc+0x13ea>
    336e:	00003097          	auipc	ra,0x3
    3372:	81e080e7          	jalr	-2018(ra) # 5b8c <mkdir>
    3376:	38051663          	bnez	a0,3702 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    337a:	20200593          	li	a1,514
    337e:	00004517          	auipc	a0,0x4
    3382:	fd250513          	addi	a0,a0,-46 # 7350 <malloc+0x140a>
    3386:	00002097          	auipc	ra,0x2
    338a:	7de080e7          	jalr	2014(ra) # 5b64 <open>
    338e:	84aa                	mv	s1,a0
  if(fd < 0){
    3390:	38054763          	bltz	a0,371e <subdir+0x3d6>
  write(fd, "ff", 2);
    3394:	4609                	li	a2,2
    3396:	00004597          	auipc	a1,0x4
    339a:	0ca58593          	addi	a1,a1,202 # 7460 <malloc+0x151a>
    339e:	00002097          	auipc	ra,0x2
    33a2:	7a6080e7          	jalr	1958(ra) # 5b44 <write>
  close(fd);
    33a6:	8526                	mv	a0,s1
    33a8:	00002097          	auipc	ra,0x2
    33ac:	7a4080e7          	jalr	1956(ra) # 5b4c <close>
  if(unlink("dd") >= 0){
    33b0:	00004517          	auipc	a0,0x4
    33b4:	f8050513          	addi	a0,a0,-128 # 7330 <malloc+0x13ea>
    33b8:	00002097          	auipc	ra,0x2
    33bc:	7bc080e7          	jalr	1980(ra) # 5b74 <unlink>
    33c0:	36055d63          	bgez	a0,373a <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    33c4:	00004517          	auipc	a0,0x4
    33c8:	fe450513          	addi	a0,a0,-28 # 73a8 <malloc+0x1462>
    33cc:	00002097          	auipc	ra,0x2
    33d0:	7c0080e7          	jalr	1984(ra) # 5b8c <mkdir>
    33d4:	38051163          	bnez	a0,3756 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    33d8:	20200593          	li	a1,514
    33dc:	00004517          	auipc	a0,0x4
    33e0:	ff450513          	addi	a0,a0,-12 # 73d0 <malloc+0x148a>
    33e4:	00002097          	auipc	ra,0x2
    33e8:	780080e7          	jalr	1920(ra) # 5b64 <open>
    33ec:	84aa                	mv	s1,a0
  if(fd < 0){
    33ee:	38054263          	bltz	a0,3772 <subdir+0x42a>
  write(fd, "FF", 2);
    33f2:	4609                	li	a2,2
    33f4:	00004597          	auipc	a1,0x4
    33f8:	00c58593          	addi	a1,a1,12 # 7400 <malloc+0x14ba>
    33fc:	00002097          	auipc	ra,0x2
    3400:	748080e7          	jalr	1864(ra) # 5b44 <write>
  close(fd);
    3404:	8526                	mv	a0,s1
    3406:	00002097          	auipc	ra,0x2
    340a:	746080e7          	jalr	1862(ra) # 5b4c <close>
  fd = open("dd/dd/../ff", 0);
    340e:	4581                	li	a1,0
    3410:	00004517          	auipc	a0,0x4
    3414:	ff850513          	addi	a0,a0,-8 # 7408 <malloc+0x14c2>
    3418:	00002097          	auipc	ra,0x2
    341c:	74c080e7          	jalr	1868(ra) # 5b64 <open>
    3420:	84aa                	mv	s1,a0
  if(fd < 0){
    3422:	36054663          	bltz	a0,378e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3426:	660d                	lui	a2,0x3
    3428:	00009597          	auipc	a1,0x9
    342c:	c8858593          	addi	a1,a1,-888 # c0b0 <buf>
    3430:	00002097          	auipc	ra,0x2
    3434:	70c080e7          	jalr	1804(ra) # 5b3c <read>
  if(cc != 2 || buf[0] != 'f'){
    3438:	4789                	li	a5,2
    343a:	36f51863          	bne	a0,a5,37aa <subdir+0x462>
    343e:	00009717          	auipc	a4,0x9
    3442:	c7274703          	lbu	a4,-910(a4) # c0b0 <buf>
    3446:	06600793          	li	a5,102
    344a:	36f71063          	bne	a4,a5,37aa <subdir+0x462>
  close(fd);
    344e:	8526                	mv	a0,s1
    3450:	00002097          	auipc	ra,0x2
    3454:	6fc080e7          	jalr	1788(ra) # 5b4c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3458:	00004597          	auipc	a1,0x4
    345c:	00058593          	mv	a1,a1
    3460:	00004517          	auipc	a0,0x4
    3464:	f7050513          	addi	a0,a0,-144 # 73d0 <malloc+0x148a>
    3468:	00002097          	auipc	ra,0x2
    346c:	71c080e7          	jalr	1820(ra) # 5b84 <link>
    3470:	34051b63          	bnez	a0,37c6 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3474:	00004517          	auipc	a0,0x4
    3478:	f5c50513          	addi	a0,a0,-164 # 73d0 <malloc+0x148a>
    347c:	00002097          	auipc	ra,0x2
    3480:	6f8080e7          	jalr	1784(ra) # 5b74 <unlink>
    3484:	34051f63          	bnez	a0,37e2 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3488:	4581                	li	a1,0
    348a:	00004517          	auipc	a0,0x4
    348e:	f4650513          	addi	a0,a0,-186 # 73d0 <malloc+0x148a>
    3492:	00002097          	auipc	ra,0x2
    3496:	6d2080e7          	jalr	1746(ra) # 5b64 <open>
    349a:	36055263          	bgez	a0,37fe <subdir+0x4b6>
  if(chdir("dd") != 0){
    349e:	00004517          	auipc	a0,0x4
    34a2:	e9250513          	addi	a0,a0,-366 # 7330 <malloc+0x13ea>
    34a6:	00002097          	auipc	ra,0x2
    34aa:	6ee080e7          	jalr	1774(ra) # 5b94 <chdir>
    34ae:	36051663          	bnez	a0,381a <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    34b2:	00004517          	auipc	a0,0x4
    34b6:	03e50513          	addi	a0,a0,62 # 74f0 <malloc+0x15aa>
    34ba:	00002097          	auipc	ra,0x2
    34be:	6da080e7          	jalr	1754(ra) # 5b94 <chdir>
    34c2:	36051a63          	bnez	a0,3836 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    34c6:	00004517          	auipc	a0,0x4
    34ca:	05a50513          	addi	a0,a0,90 # 7520 <malloc+0x15da>
    34ce:	00002097          	auipc	ra,0x2
    34d2:	6c6080e7          	jalr	1734(ra) # 5b94 <chdir>
    34d6:	36051e63          	bnez	a0,3852 <subdir+0x50a>
  if(chdir("./..") != 0){
    34da:	00004517          	auipc	a0,0x4
    34de:	07650513          	addi	a0,a0,118 # 7550 <malloc+0x160a>
    34e2:	00002097          	auipc	ra,0x2
    34e6:	6b2080e7          	jalr	1714(ra) # 5b94 <chdir>
    34ea:	38051263          	bnez	a0,386e <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    34ee:	4581                	li	a1,0
    34f0:	00004517          	auipc	a0,0x4
    34f4:	f6850513          	addi	a0,a0,-152 # 7458 <malloc+0x1512>
    34f8:	00002097          	auipc	ra,0x2
    34fc:	66c080e7          	jalr	1644(ra) # 5b64 <open>
    3500:	84aa                	mv	s1,a0
  if(fd < 0){
    3502:	38054463          	bltz	a0,388a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3506:	660d                	lui	a2,0x3
    3508:	00009597          	auipc	a1,0x9
    350c:	ba858593          	addi	a1,a1,-1112 # c0b0 <buf>
    3510:	00002097          	auipc	ra,0x2
    3514:	62c080e7          	jalr	1580(ra) # 5b3c <read>
    3518:	4789                	li	a5,2
    351a:	38f51663          	bne	a0,a5,38a6 <subdir+0x55e>
  close(fd);
    351e:	8526                	mv	a0,s1
    3520:	00002097          	auipc	ra,0x2
    3524:	62c080e7          	jalr	1580(ra) # 5b4c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3528:	4581                	li	a1,0
    352a:	00004517          	auipc	a0,0x4
    352e:	ea650513          	addi	a0,a0,-346 # 73d0 <malloc+0x148a>
    3532:	00002097          	auipc	ra,0x2
    3536:	632080e7          	jalr	1586(ra) # 5b64 <open>
    353a:	38055463          	bgez	a0,38c2 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    353e:	20200593          	li	a1,514
    3542:	00004517          	auipc	a0,0x4
    3546:	09e50513          	addi	a0,a0,158 # 75e0 <malloc+0x169a>
    354a:	00002097          	auipc	ra,0x2
    354e:	61a080e7          	jalr	1562(ra) # 5b64 <open>
    3552:	38055663          	bgez	a0,38de <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3556:	20200593          	li	a1,514
    355a:	00004517          	auipc	a0,0x4
    355e:	0b650513          	addi	a0,a0,182 # 7610 <malloc+0x16ca>
    3562:	00002097          	auipc	ra,0x2
    3566:	602080e7          	jalr	1538(ra) # 5b64 <open>
    356a:	38055863          	bgez	a0,38fa <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    356e:	20000593          	li	a1,512
    3572:	00004517          	auipc	a0,0x4
    3576:	dbe50513          	addi	a0,a0,-578 # 7330 <malloc+0x13ea>
    357a:	00002097          	auipc	ra,0x2
    357e:	5ea080e7          	jalr	1514(ra) # 5b64 <open>
    3582:	38055a63          	bgez	a0,3916 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3586:	4589                	li	a1,2
    3588:	00004517          	auipc	a0,0x4
    358c:	da850513          	addi	a0,a0,-600 # 7330 <malloc+0x13ea>
    3590:	00002097          	auipc	ra,0x2
    3594:	5d4080e7          	jalr	1492(ra) # 5b64 <open>
    3598:	38055d63          	bgez	a0,3932 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    359c:	4585                	li	a1,1
    359e:	00004517          	auipc	a0,0x4
    35a2:	d9250513          	addi	a0,a0,-622 # 7330 <malloc+0x13ea>
    35a6:	00002097          	auipc	ra,0x2
    35aa:	5be080e7          	jalr	1470(ra) # 5b64 <open>
    35ae:	3a055063          	bgez	a0,394e <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    35b2:	00004597          	auipc	a1,0x4
    35b6:	0ee58593          	addi	a1,a1,238 # 76a0 <malloc+0x175a>
    35ba:	00004517          	auipc	a0,0x4
    35be:	02650513          	addi	a0,a0,38 # 75e0 <malloc+0x169a>
    35c2:	00002097          	auipc	ra,0x2
    35c6:	5c2080e7          	jalr	1474(ra) # 5b84 <link>
    35ca:	3a050063          	beqz	a0,396a <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    35ce:	00004597          	auipc	a1,0x4
    35d2:	0d258593          	addi	a1,a1,210 # 76a0 <malloc+0x175a>
    35d6:	00004517          	auipc	a0,0x4
    35da:	03a50513          	addi	a0,a0,58 # 7610 <malloc+0x16ca>
    35de:	00002097          	auipc	ra,0x2
    35e2:	5a6080e7          	jalr	1446(ra) # 5b84 <link>
    35e6:	3a050063          	beqz	a0,3986 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    35ea:	00004597          	auipc	a1,0x4
    35ee:	e6e58593          	addi	a1,a1,-402 # 7458 <malloc+0x1512>
    35f2:	00004517          	auipc	a0,0x4
    35f6:	d5e50513          	addi	a0,a0,-674 # 7350 <malloc+0x140a>
    35fa:	00002097          	auipc	ra,0x2
    35fe:	58a080e7          	jalr	1418(ra) # 5b84 <link>
    3602:	3a050063          	beqz	a0,39a2 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3606:	00004517          	auipc	a0,0x4
    360a:	fda50513          	addi	a0,a0,-38 # 75e0 <malloc+0x169a>
    360e:	00002097          	auipc	ra,0x2
    3612:	57e080e7          	jalr	1406(ra) # 5b8c <mkdir>
    3616:	3a050463          	beqz	a0,39be <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    361a:	00004517          	auipc	a0,0x4
    361e:	ff650513          	addi	a0,a0,-10 # 7610 <malloc+0x16ca>
    3622:	00002097          	auipc	ra,0x2
    3626:	56a080e7          	jalr	1386(ra) # 5b8c <mkdir>
    362a:	3a050863          	beqz	a0,39da <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    362e:	00004517          	auipc	a0,0x4
    3632:	e2a50513          	addi	a0,a0,-470 # 7458 <malloc+0x1512>
    3636:	00002097          	auipc	ra,0x2
    363a:	556080e7          	jalr	1366(ra) # 5b8c <mkdir>
    363e:	3a050c63          	beqz	a0,39f6 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3642:	00004517          	auipc	a0,0x4
    3646:	fce50513          	addi	a0,a0,-50 # 7610 <malloc+0x16ca>
    364a:	00002097          	auipc	ra,0x2
    364e:	52a080e7          	jalr	1322(ra) # 5b74 <unlink>
    3652:	3c050063          	beqz	a0,3a12 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3656:	00004517          	auipc	a0,0x4
    365a:	f8a50513          	addi	a0,a0,-118 # 75e0 <malloc+0x169a>
    365e:	00002097          	auipc	ra,0x2
    3662:	516080e7          	jalr	1302(ra) # 5b74 <unlink>
    3666:	3c050463          	beqz	a0,3a2e <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    366a:	00004517          	auipc	a0,0x4
    366e:	ce650513          	addi	a0,a0,-794 # 7350 <malloc+0x140a>
    3672:	00002097          	auipc	ra,0x2
    3676:	522080e7          	jalr	1314(ra) # 5b94 <chdir>
    367a:	3c050863          	beqz	a0,3a4a <subdir+0x702>
  if(chdir("dd/xx") == 0){
    367e:	00004517          	auipc	a0,0x4
    3682:	17250513          	addi	a0,a0,370 # 77f0 <malloc+0x18aa>
    3686:	00002097          	auipc	ra,0x2
    368a:	50e080e7          	jalr	1294(ra) # 5b94 <chdir>
    368e:	3c050c63          	beqz	a0,3a66 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3692:	00004517          	auipc	a0,0x4
    3696:	dc650513          	addi	a0,a0,-570 # 7458 <malloc+0x1512>
    369a:	00002097          	auipc	ra,0x2
    369e:	4da080e7          	jalr	1242(ra) # 5b74 <unlink>
    36a2:	3e051063          	bnez	a0,3a82 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    36a6:	00004517          	auipc	a0,0x4
    36aa:	caa50513          	addi	a0,a0,-854 # 7350 <malloc+0x140a>
    36ae:	00002097          	auipc	ra,0x2
    36b2:	4c6080e7          	jalr	1222(ra) # 5b74 <unlink>
    36b6:	3e051463          	bnez	a0,3a9e <subdir+0x756>
  if(unlink("dd") == 0){
    36ba:	00004517          	auipc	a0,0x4
    36be:	c7650513          	addi	a0,a0,-906 # 7330 <malloc+0x13ea>
    36c2:	00002097          	auipc	ra,0x2
    36c6:	4b2080e7          	jalr	1202(ra) # 5b74 <unlink>
    36ca:	3e050863          	beqz	a0,3aba <subdir+0x772>
  if(unlink("dd/dd") < 0){
    36ce:	00004517          	auipc	a0,0x4
    36d2:	19250513          	addi	a0,a0,402 # 7860 <malloc+0x191a>
    36d6:	00002097          	auipc	ra,0x2
    36da:	49e080e7          	jalr	1182(ra) # 5b74 <unlink>
    36de:	3e054c63          	bltz	a0,3ad6 <subdir+0x78e>
  if(unlink("dd") < 0){
    36e2:	00004517          	auipc	a0,0x4
    36e6:	c4e50513          	addi	a0,a0,-946 # 7330 <malloc+0x13ea>
    36ea:	00002097          	auipc	ra,0x2
    36ee:	48a080e7          	jalr	1162(ra) # 5b74 <unlink>
    36f2:	40054063          	bltz	a0,3af2 <subdir+0x7aa>
}
    36f6:	60e2                	ld	ra,24(sp)
    36f8:	6442                	ld	s0,16(sp)
    36fa:	64a2                	ld	s1,8(sp)
    36fc:	6902                	ld	s2,0(sp)
    36fe:	6105                	addi	sp,sp,32
    3700:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3702:	85ca                	mv	a1,s2
    3704:	00004517          	auipc	a0,0x4
    3708:	c3450513          	addi	a0,a0,-972 # 7338 <malloc+0x13f2>
    370c:	00002097          	auipc	ra,0x2
    3710:	77e080e7          	jalr	1918(ra) # 5e8a <printf>
    exit(1);
    3714:	4505                	li	a0,1
    3716:	00002097          	auipc	ra,0x2
    371a:	40e080e7          	jalr	1038(ra) # 5b24 <exit>
    printf("%s: create dd/ff failed\n", s);
    371e:	85ca                	mv	a1,s2
    3720:	00004517          	auipc	a0,0x4
    3724:	c3850513          	addi	a0,a0,-968 # 7358 <malloc+0x1412>
    3728:	00002097          	auipc	ra,0x2
    372c:	762080e7          	jalr	1890(ra) # 5e8a <printf>
    exit(1);
    3730:	4505                	li	a0,1
    3732:	00002097          	auipc	ra,0x2
    3736:	3f2080e7          	jalr	1010(ra) # 5b24 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    373a:	85ca                	mv	a1,s2
    373c:	00004517          	auipc	a0,0x4
    3740:	c3c50513          	addi	a0,a0,-964 # 7378 <malloc+0x1432>
    3744:	00002097          	auipc	ra,0x2
    3748:	746080e7          	jalr	1862(ra) # 5e8a <printf>
    exit(1);
    374c:	4505                	li	a0,1
    374e:	00002097          	auipc	ra,0x2
    3752:	3d6080e7          	jalr	982(ra) # 5b24 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3756:	85ca                	mv	a1,s2
    3758:	00004517          	auipc	a0,0x4
    375c:	c5850513          	addi	a0,a0,-936 # 73b0 <malloc+0x146a>
    3760:	00002097          	auipc	ra,0x2
    3764:	72a080e7          	jalr	1834(ra) # 5e8a <printf>
    exit(1);
    3768:	4505                	li	a0,1
    376a:	00002097          	auipc	ra,0x2
    376e:	3ba080e7          	jalr	954(ra) # 5b24 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3772:	85ca                	mv	a1,s2
    3774:	00004517          	auipc	a0,0x4
    3778:	c6c50513          	addi	a0,a0,-916 # 73e0 <malloc+0x149a>
    377c:	00002097          	auipc	ra,0x2
    3780:	70e080e7          	jalr	1806(ra) # 5e8a <printf>
    exit(1);
    3784:	4505                	li	a0,1
    3786:	00002097          	auipc	ra,0x2
    378a:	39e080e7          	jalr	926(ra) # 5b24 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    378e:	85ca                	mv	a1,s2
    3790:	00004517          	auipc	a0,0x4
    3794:	c8850513          	addi	a0,a0,-888 # 7418 <malloc+0x14d2>
    3798:	00002097          	auipc	ra,0x2
    379c:	6f2080e7          	jalr	1778(ra) # 5e8a <printf>
    exit(1);
    37a0:	4505                	li	a0,1
    37a2:	00002097          	auipc	ra,0x2
    37a6:	382080e7          	jalr	898(ra) # 5b24 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    37aa:	85ca                	mv	a1,s2
    37ac:	00004517          	auipc	a0,0x4
    37b0:	c8c50513          	addi	a0,a0,-884 # 7438 <malloc+0x14f2>
    37b4:	00002097          	auipc	ra,0x2
    37b8:	6d6080e7          	jalr	1750(ra) # 5e8a <printf>
    exit(1);
    37bc:	4505                	li	a0,1
    37be:	00002097          	auipc	ra,0x2
    37c2:	366080e7          	jalr	870(ra) # 5b24 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    37c6:	85ca                	mv	a1,s2
    37c8:	00004517          	auipc	a0,0x4
    37cc:	ca050513          	addi	a0,a0,-864 # 7468 <malloc+0x1522>
    37d0:	00002097          	auipc	ra,0x2
    37d4:	6ba080e7          	jalr	1722(ra) # 5e8a <printf>
    exit(1);
    37d8:	4505                	li	a0,1
    37da:	00002097          	auipc	ra,0x2
    37de:	34a080e7          	jalr	842(ra) # 5b24 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    37e2:	85ca                	mv	a1,s2
    37e4:	00004517          	auipc	a0,0x4
    37e8:	cac50513          	addi	a0,a0,-852 # 7490 <malloc+0x154a>
    37ec:	00002097          	auipc	ra,0x2
    37f0:	69e080e7          	jalr	1694(ra) # 5e8a <printf>
    exit(1);
    37f4:	4505                	li	a0,1
    37f6:	00002097          	auipc	ra,0x2
    37fa:	32e080e7          	jalr	814(ra) # 5b24 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    37fe:	85ca                	mv	a1,s2
    3800:	00004517          	auipc	a0,0x4
    3804:	cb050513          	addi	a0,a0,-848 # 74b0 <malloc+0x156a>
    3808:	00002097          	auipc	ra,0x2
    380c:	682080e7          	jalr	1666(ra) # 5e8a <printf>
    exit(1);
    3810:	4505                	li	a0,1
    3812:	00002097          	auipc	ra,0x2
    3816:	312080e7          	jalr	786(ra) # 5b24 <exit>
    printf("%s: chdir dd failed\n", s);
    381a:	85ca                	mv	a1,s2
    381c:	00004517          	auipc	a0,0x4
    3820:	cbc50513          	addi	a0,a0,-836 # 74d8 <malloc+0x1592>
    3824:	00002097          	auipc	ra,0x2
    3828:	666080e7          	jalr	1638(ra) # 5e8a <printf>
    exit(1);
    382c:	4505                	li	a0,1
    382e:	00002097          	auipc	ra,0x2
    3832:	2f6080e7          	jalr	758(ra) # 5b24 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3836:	85ca                	mv	a1,s2
    3838:	00004517          	auipc	a0,0x4
    383c:	cc850513          	addi	a0,a0,-824 # 7500 <malloc+0x15ba>
    3840:	00002097          	auipc	ra,0x2
    3844:	64a080e7          	jalr	1610(ra) # 5e8a <printf>
    exit(1);
    3848:	4505                	li	a0,1
    384a:	00002097          	auipc	ra,0x2
    384e:	2da080e7          	jalr	730(ra) # 5b24 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3852:	85ca                	mv	a1,s2
    3854:	00004517          	auipc	a0,0x4
    3858:	cdc50513          	addi	a0,a0,-804 # 7530 <malloc+0x15ea>
    385c:	00002097          	auipc	ra,0x2
    3860:	62e080e7          	jalr	1582(ra) # 5e8a <printf>
    exit(1);
    3864:	4505                	li	a0,1
    3866:	00002097          	auipc	ra,0x2
    386a:	2be080e7          	jalr	702(ra) # 5b24 <exit>
    printf("%s: chdir ./.. failed\n", s);
    386e:	85ca                	mv	a1,s2
    3870:	00004517          	auipc	a0,0x4
    3874:	ce850513          	addi	a0,a0,-792 # 7558 <malloc+0x1612>
    3878:	00002097          	auipc	ra,0x2
    387c:	612080e7          	jalr	1554(ra) # 5e8a <printf>
    exit(1);
    3880:	4505                	li	a0,1
    3882:	00002097          	auipc	ra,0x2
    3886:	2a2080e7          	jalr	674(ra) # 5b24 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    388a:	85ca                	mv	a1,s2
    388c:	00004517          	auipc	a0,0x4
    3890:	ce450513          	addi	a0,a0,-796 # 7570 <malloc+0x162a>
    3894:	00002097          	auipc	ra,0x2
    3898:	5f6080e7          	jalr	1526(ra) # 5e8a <printf>
    exit(1);
    389c:	4505                	li	a0,1
    389e:	00002097          	auipc	ra,0x2
    38a2:	286080e7          	jalr	646(ra) # 5b24 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    38a6:	85ca                	mv	a1,s2
    38a8:	00004517          	auipc	a0,0x4
    38ac:	ce850513          	addi	a0,a0,-792 # 7590 <malloc+0x164a>
    38b0:	00002097          	auipc	ra,0x2
    38b4:	5da080e7          	jalr	1498(ra) # 5e8a <printf>
    exit(1);
    38b8:	4505                	li	a0,1
    38ba:	00002097          	auipc	ra,0x2
    38be:	26a080e7          	jalr	618(ra) # 5b24 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    38c2:	85ca                	mv	a1,s2
    38c4:	00004517          	auipc	a0,0x4
    38c8:	cec50513          	addi	a0,a0,-788 # 75b0 <malloc+0x166a>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	5be080e7          	jalr	1470(ra) # 5e8a <printf>
    exit(1);
    38d4:	4505                	li	a0,1
    38d6:	00002097          	auipc	ra,0x2
    38da:	24e080e7          	jalr	590(ra) # 5b24 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    38de:	85ca                	mv	a1,s2
    38e0:	00004517          	auipc	a0,0x4
    38e4:	d1050513          	addi	a0,a0,-752 # 75f0 <malloc+0x16aa>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	5a2080e7          	jalr	1442(ra) # 5e8a <printf>
    exit(1);
    38f0:	4505                	li	a0,1
    38f2:	00002097          	auipc	ra,0x2
    38f6:	232080e7          	jalr	562(ra) # 5b24 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    38fa:	85ca                	mv	a1,s2
    38fc:	00004517          	auipc	a0,0x4
    3900:	d2450513          	addi	a0,a0,-732 # 7620 <malloc+0x16da>
    3904:	00002097          	auipc	ra,0x2
    3908:	586080e7          	jalr	1414(ra) # 5e8a <printf>
    exit(1);
    390c:	4505                	li	a0,1
    390e:	00002097          	auipc	ra,0x2
    3912:	216080e7          	jalr	534(ra) # 5b24 <exit>
    printf("%s: create dd succeeded!\n", s);
    3916:	85ca                	mv	a1,s2
    3918:	00004517          	auipc	a0,0x4
    391c:	d2850513          	addi	a0,a0,-728 # 7640 <malloc+0x16fa>
    3920:	00002097          	auipc	ra,0x2
    3924:	56a080e7          	jalr	1386(ra) # 5e8a <printf>
    exit(1);
    3928:	4505                	li	a0,1
    392a:	00002097          	auipc	ra,0x2
    392e:	1fa080e7          	jalr	506(ra) # 5b24 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3932:	85ca                	mv	a1,s2
    3934:	00004517          	auipc	a0,0x4
    3938:	d2c50513          	addi	a0,a0,-724 # 7660 <malloc+0x171a>
    393c:	00002097          	auipc	ra,0x2
    3940:	54e080e7          	jalr	1358(ra) # 5e8a <printf>
    exit(1);
    3944:	4505                	li	a0,1
    3946:	00002097          	auipc	ra,0x2
    394a:	1de080e7          	jalr	478(ra) # 5b24 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    394e:	85ca                	mv	a1,s2
    3950:	00004517          	auipc	a0,0x4
    3954:	d3050513          	addi	a0,a0,-720 # 7680 <malloc+0x173a>
    3958:	00002097          	auipc	ra,0x2
    395c:	532080e7          	jalr	1330(ra) # 5e8a <printf>
    exit(1);
    3960:	4505                	li	a0,1
    3962:	00002097          	auipc	ra,0x2
    3966:	1c2080e7          	jalr	450(ra) # 5b24 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    396a:	85ca                	mv	a1,s2
    396c:	00004517          	auipc	a0,0x4
    3970:	d4450513          	addi	a0,a0,-700 # 76b0 <malloc+0x176a>
    3974:	00002097          	auipc	ra,0x2
    3978:	516080e7          	jalr	1302(ra) # 5e8a <printf>
    exit(1);
    397c:	4505                	li	a0,1
    397e:	00002097          	auipc	ra,0x2
    3982:	1a6080e7          	jalr	422(ra) # 5b24 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3986:	85ca                	mv	a1,s2
    3988:	00004517          	auipc	a0,0x4
    398c:	d5050513          	addi	a0,a0,-688 # 76d8 <malloc+0x1792>
    3990:	00002097          	auipc	ra,0x2
    3994:	4fa080e7          	jalr	1274(ra) # 5e8a <printf>
    exit(1);
    3998:	4505                	li	a0,1
    399a:	00002097          	auipc	ra,0x2
    399e:	18a080e7          	jalr	394(ra) # 5b24 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    39a2:	85ca                	mv	a1,s2
    39a4:	00004517          	auipc	a0,0x4
    39a8:	d5c50513          	addi	a0,a0,-676 # 7700 <malloc+0x17ba>
    39ac:	00002097          	auipc	ra,0x2
    39b0:	4de080e7          	jalr	1246(ra) # 5e8a <printf>
    exit(1);
    39b4:	4505                	li	a0,1
    39b6:	00002097          	auipc	ra,0x2
    39ba:	16e080e7          	jalr	366(ra) # 5b24 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    39be:	85ca                	mv	a1,s2
    39c0:	00004517          	auipc	a0,0x4
    39c4:	d6850513          	addi	a0,a0,-664 # 7728 <malloc+0x17e2>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	4c2080e7          	jalr	1218(ra) # 5e8a <printf>
    exit(1);
    39d0:	4505                	li	a0,1
    39d2:	00002097          	auipc	ra,0x2
    39d6:	152080e7          	jalr	338(ra) # 5b24 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    39da:	85ca                	mv	a1,s2
    39dc:	00004517          	auipc	a0,0x4
    39e0:	d6c50513          	addi	a0,a0,-660 # 7748 <malloc+0x1802>
    39e4:	00002097          	auipc	ra,0x2
    39e8:	4a6080e7          	jalr	1190(ra) # 5e8a <printf>
    exit(1);
    39ec:	4505                	li	a0,1
    39ee:	00002097          	auipc	ra,0x2
    39f2:	136080e7          	jalr	310(ra) # 5b24 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    39f6:	85ca                	mv	a1,s2
    39f8:	00004517          	auipc	a0,0x4
    39fc:	d7050513          	addi	a0,a0,-656 # 7768 <malloc+0x1822>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	48a080e7          	jalr	1162(ra) # 5e8a <printf>
    exit(1);
    3a08:	4505                	li	a0,1
    3a0a:	00002097          	auipc	ra,0x2
    3a0e:	11a080e7          	jalr	282(ra) # 5b24 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3a12:	85ca                	mv	a1,s2
    3a14:	00004517          	auipc	a0,0x4
    3a18:	d7c50513          	addi	a0,a0,-644 # 7790 <malloc+0x184a>
    3a1c:	00002097          	auipc	ra,0x2
    3a20:	46e080e7          	jalr	1134(ra) # 5e8a <printf>
    exit(1);
    3a24:	4505                	li	a0,1
    3a26:	00002097          	auipc	ra,0x2
    3a2a:	0fe080e7          	jalr	254(ra) # 5b24 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3a2e:	85ca                	mv	a1,s2
    3a30:	00004517          	auipc	a0,0x4
    3a34:	d8050513          	addi	a0,a0,-640 # 77b0 <malloc+0x186a>
    3a38:	00002097          	auipc	ra,0x2
    3a3c:	452080e7          	jalr	1106(ra) # 5e8a <printf>
    exit(1);
    3a40:	4505                	li	a0,1
    3a42:	00002097          	auipc	ra,0x2
    3a46:	0e2080e7          	jalr	226(ra) # 5b24 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3a4a:	85ca                	mv	a1,s2
    3a4c:	00004517          	auipc	a0,0x4
    3a50:	d8450513          	addi	a0,a0,-636 # 77d0 <malloc+0x188a>
    3a54:	00002097          	auipc	ra,0x2
    3a58:	436080e7          	jalr	1078(ra) # 5e8a <printf>
    exit(1);
    3a5c:	4505                	li	a0,1
    3a5e:	00002097          	auipc	ra,0x2
    3a62:	0c6080e7          	jalr	198(ra) # 5b24 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3a66:	85ca                	mv	a1,s2
    3a68:	00004517          	auipc	a0,0x4
    3a6c:	d9050513          	addi	a0,a0,-624 # 77f8 <malloc+0x18b2>
    3a70:	00002097          	auipc	ra,0x2
    3a74:	41a080e7          	jalr	1050(ra) # 5e8a <printf>
    exit(1);
    3a78:	4505                	li	a0,1
    3a7a:	00002097          	auipc	ra,0x2
    3a7e:	0aa080e7          	jalr	170(ra) # 5b24 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3a82:	85ca                	mv	a1,s2
    3a84:	00004517          	auipc	a0,0x4
    3a88:	a0c50513          	addi	a0,a0,-1524 # 7490 <malloc+0x154a>
    3a8c:	00002097          	auipc	ra,0x2
    3a90:	3fe080e7          	jalr	1022(ra) # 5e8a <printf>
    exit(1);
    3a94:	4505                	li	a0,1
    3a96:	00002097          	auipc	ra,0x2
    3a9a:	08e080e7          	jalr	142(ra) # 5b24 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3a9e:	85ca                	mv	a1,s2
    3aa0:	00004517          	auipc	a0,0x4
    3aa4:	d7850513          	addi	a0,a0,-648 # 7818 <malloc+0x18d2>
    3aa8:	00002097          	auipc	ra,0x2
    3aac:	3e2080e7          	jalr	994(ra) # 5e8a <printf>
    exit(1);
    3ab0:	4505                	li	a0,1
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	072080e7          	jalr	114(ra) # 5b24 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3aba:	85ca                	mv	a1,s2
    3abc:	00004517          	auipc	a0,0x4
    3ac0:	d7c50513          	addi	a0,a0,-644 # 7838 <malloc+0x18f2>
    3ac4:	00002097          	auipc	ra,0x2
    3ac8:	3c6080e7          	jalr	966(ra) # 5e8a <printf>
    exit(1);
    3acc:	4505                	li	a0,1
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	056080e7          	jalr	86(ra) # 5b24 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3ad6:	85ca                	mv	a1,s2
    3ad8:	00004517          	auipc	a0,0x4
    3adc:	d9050513          	addi	a0,a0,-624 # 7868 <malloc+0x1922>
    3ae0:	00002097          	auipc	ra,0x2
    3ae4:	3aa080e7          	jalr	938(ra) # 5e8a <printf>
    exit(1);
    3ae8:	4505                	li	a0,1
    3aea:	00002097          	auipc	ra,0x2
    3aee:	03a080e7          	jalr	58(ra) # 5b24 <exit>
    printf("%s: unlink dd failed\n", s);
    3af2:	85ca                	mv	a1,s2
    3af4:	00004517          	auipc	a0,0x4
    3af8:	d9450513          	addi	a0,a0,-620 # 7888 <malloc+0x1942>
    3afc:	00002097          	auipc	ra,0x2
    3b00:	38e080e7          	jalr	910(ra) # 5e8a <printf>
    exit(1);
    3b04:	4505                	li	a0,1
    3b06:	00002097          	auipc	ra,0x2
    3b0a:	01e080e7          	jalr	30(ra) # 5b24 <exit>

0000000000003b0e <rmdot>:
{
    3b0e:	1101                	addi	sp,sp,-32
    3b10:	ec06                	sd	ra,24(sp)
    3b12:	e822                	sd	s0,16(sp)
    3b14:	e426                	sd	s1,8(sp)
    3b16:	1000                	addi	s0,sp,32
    3b18:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3b1a:	00004517          	auipc	a0,0x4
    3b1e:	d8650513          	addi	a0,a0,-634 # 78a0 <malloc+0x195a>
    3b22:	00002097          	auipc	ra,0x2
    3b26:	06a080e7          	jalr	106(ra) # 5b8c <mkdir>
    3b2a:	e549                	bnez	a0,3bb4 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3b2c:	00004517          	auipc	a0,0x4
    3b30:	d7450513          	addi	a0,a0,-652 # 78a0 <malloc+0x195a>
    3b34:	00002097          	auipc	ra,0x2
    3b38:	060080e7          	jalr	96(ra) # 5b94 <chdir>
    3b3c:	e951                	bnez	a0,3bd0 <rmdot+0xc2>
  if(unlink(".") == 0){
    3b3e:	00003517          	auipc	a0,0x3
    3b42:	bf250513          	addi	a0,a0,-1038 # 6730 <malloc+0x7ea>
    3b46:	00002097          	auipc	ra,0x2
    3b4a:	02e080e7          	jalr	46(ra) # 5b74 <unlink>
    3b4e:	cd59                	beqz	a0,3bec <rmdot+0xde>
  if(unlink("..") == 0){
    3b50:	00003517          	auipc	a0,0x3
    3b54:	7a850513          	addi	a0,a0,1960 # 72f8 <malloc+0x13b2>
    3b58:	00002097          	auipc	ra,0x2
    3b5c:	01c080e7          	jalr	28(ra) # 5b74 <unlink>
    3b60:	c545                	beqz	a0,3c08 <rmdot+0xfa>
  if(chdir("/") != 0){
    3b62:	00003517          	auipc	a0,0x3
    3b66:	73e50513          	addi	a0,a0,1854 # 72a0 <malloc+0x135a>
    3b6a:	00002097          	auipc	ra,0x2
    3b6e:	02a080e7          	jalr	42(ra) # 5b94 <chdir>
    3b72:	e94d                	bnez	a0,3c24 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3b74:	00004517          	auipc	a0,0x4
    3b78:	d9450513          	addi	a0,a0,-620 # 7908 <malloc+0x19c2>
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	ff8080e7          	jalr	-8(ra) # 5b74 <unlink>
    3b84:	cd55                	beqz	a0,3c40 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	daa50513          	addi	a0,a0,-598 # 7930 <malloc+0x19ea>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	fe6080e7          	jalr	-26(ra) # 5b74 <unlink>
    3b96:	c179                	beqz	a0,3c5c <rmdot+0x14e>
  if(unlink("dots") != 0){
    3b98:	00004517          	auipc	a0,0x4
    3b9c:	d0850513          	addi	a0,a0,-760 # 78a0 <malloc+0x195a>
    3ba0:	00002097          	auipc	ra,0x2
    3ba4:	fd4080e7          	jalr	-44(ra) # 5b74 <unlink>
    3ba8:	e961                	bnez	a0,3c78 <rmdot+0x16a>
}
    3baa:	60e2                	ld	ra,24(sp)
    3bac:	6442                	ld	s0,16(sp)
    3bae:	64a2                	ld	s1,8(sp)
    3bb0:	6105                	addi	sp,sp,32
    3bb2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3bb4:	85a6                	mv	a1,s1
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	cf250513          	addi	a0,a0,-782 # 78a8 <malloc+0x1962>
    3bbe:	00002097          	auipc	ra,0x2
    3bc2:	2cc080e7          	jalr	716(ra) # 5e8a <printf>
    exit(1);
    3bc6:	4505                	li	a0,1
    3bc8:	00002097          	auipc	ra,0x2
    3bcc:	f5c080e7          	jalr	-164(ra) # 5b24 <exit>
    printf("%s: chdir dots failed\n", s);
    3bd0:	85a6                	mv	a1,s1
    3bd2:	00004517          	auipc	a0,0x4
    3bd6:	cee50513          	addi	a0,a0,-786 # 78c0 <malloc+0x197a>
    3bda:	00002097          	auipc	ra,0x2
    3bde:	2b0080e7          	jalr	688(ra) # 5e8a <printf>
    exit(1);
    3be2:	4505                	li	a0,1
    3be4:	00002097          	auipc	ra,0x2
    3be8:	f40080e7          	jalr	-192(ra) # 5b24 <exit>
    printf("%s: rm . worked!\n", s);
    3bec:	85a6                	mv	a1,s1
    3bee:	00004517          	auipc	a0,0x4
    3bf2:	cea50513          	addi	a0,a0,-790 # 78d8 <malloc+0x1992>
    3bf6:	00002097          	auipc	ra,0x2
    3bfa:	294080e7          	jalr	660(ra) # 5e8a <printf>
    exit(1);
    3bfe:	4505                	li	a0,1
    3c00:	00002097          	auipc	ra,0x2
    3c04:	f24080e7          	jalr	-220(ra) # 5b24 <exit>
    printf("%s: rm .. worked!\n", s);
    3c08:	85a6                	mv	a1,s1
    3c0a:	00004517          	auipc	a0,0x4
    3c0e:	ce650513          	addi	a0,a0,-794 # 78f0 <malloc+0x19aa>
    3c12:	00002097          	auipc	ra,0x2
    3c16:	278080e7          	jalr	632(ra) # 5e8a <printf>
    exit(1);
    3c1a:	4505                	li	a0,1
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	f08080e7          	jalr	-248(ra) # 5b24 <exit>
    printf("%s: chdir / failed\n", s);
    3c24:	85a6                	mv	a1,s1
    3c26:	00003517          	auipc	a0,0x3
    3c2a:	68250513          	addi	a0,a0,1666 # 72a8 <malloc+0x1362>
    3c2e:	00002097          	auipc	ra,0x2
    3c32:	25c080e7          	jalr	604(ra) # 5e8a <printf>
    exit(1);
    3c36:	4505                	li	a0,1
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	eec080e7          	jalr	-276(ra) # 5b24 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3c40:	85a6                	mv	a1,s1
    3c42:	00004517          	auipc	a0,0x4
    3c46:	cce50513          	addi	a0,a0,-818 # 7910 <malloc+0x19ca>
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	240080e7          	jalr	576(ra) # 5e8a <printf>
    exit(1);
    3c52:	4505                	li	a0,1
    3c54:	00002097          	auipc	ra,0x2
    3c58:	ed0080e7          	jalr	-304(ra) # 5b24 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3c5c:	85a6                	mv	a1,s1
    3c5e:	00004517          	auipc	a0,0x4
    3c62:	cda50513          	addi	a0,a0,-806 # 7938 <malloc+0x19f2>
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	224080e7          	jalr	548(ra) # 5e8a <printf>
    exit(1);
    3c6e:	4505                	li	a0,1
    3c70:	00002097          	auipc	ra,0x2
    3c74:	eb4080e7          	jalr	-332(ra) # 5b24 <exit>
    printf("%s: unlink dots failed!\n", s);
    3c78:	85a6                	mv	a1,s1
    3c7a:	00004517          	auipc	a0,0x4
    3c7e:	cde50513          	addi	a0,a0,-802 # 7958 <malloc+0x1a12>
    3c82:	00002097          	auipc	ra,0x2
    3c86:	208080e7          	jalr	520(ra) # 5e8a <printf>
    exit(1);
    3c8a:	4505                	li	a0,1
    3c8c:	00002097          	auipc	ra,0x2
    3c90:	e98080e7          	jalr	-360(ra) # 5b24 <exit>

0000000000003c94 <dirfile>:
{
    3c94:	1101                	addi	sp,sp,-32
    3c96:	ec06                	sd	ra,24(sp)
    3c98:	e822                	sd	s0,16(sp)
    3c9a:	e426                	sd	s1,8(sp)
    3c9c:	e04a                	sd	s2,0(sp)
    3c9e:	1000                	addi	s0,sp,32
    3ca0:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3ca2:	20000593          	li	a1,512
    3ca6:	00004517          	auipc	a0,0x4
    3caa:	cd250513          	addi	a0,a0,-814 # 7978 <malloc+0x1a32>
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	eb6080e7          	jalr	-330(ra) # 5b64 <open>
  if(fd < 0){
    3cb6:	0e054d63          	bltz	a0,3db0 <dirfile+0x11c>
  close(fd);
    3cba:	00002097          	auipc	ra,0x2
    3cbe:	e92080e7          	jalr	-366(ra) # 5b4c <close>
  if(chdir("dirfile") == 0){
    3cc2:	00004517          	auipc	a0,0x4
    3cc6:	cb650513          	addi	a0,a0,-842 # 7978 <malloc+0x1a32>
    3cca:	00002097          	auipc	ra,0x2
    3cce:	eca080e7          	jalr	-310(ra) # 5b94 <chdir>
    3cd2:	cd6d                	beqz	a0,3dcc <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3cd4:	4581                	li	a1,0
    3cd6:	00004517          	auipc	a0,0x4
    3cda:	cea50513          	addi	a0,a0,-790 # 79c0 <malloc+0x1a7a>
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	e86080e7          	jalr	-378(ra) # 5b64 <open>
  if(fd >= 0){
    3ce6:	10055163          	bgez	a0,3de8 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    3cea:	20000593          	li	a1,512
    3cee:	00004517          	auipc	a0,0x4
    3cf2:	cd250513          	addi	a0,a0,-814 # 79c0 <malloc+0x1a7a>
    3cf6:	00002097          	auipc	ra,0x2
    3cfa:	e6e080e7          	jalr	-402(ra) # 5b64 <open>
  if(fd >= 0){
    3cfe:	10055363          	bgez	a0,3e04 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3d02:	00004517          	auipc	a0,0x4
    3d06:	cbe50513          	addi	a0,a0,-834 # 79c0 <malloc+0x1a7a>
    3d0a:	00002097          	auipc	ra,0x2
    3d0e:	e82080e7          	jalr	-382(ra) # 5b8c <mkdir>
    3d12:	10050763          	beqz	a0,3e20 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3d16:	00004517          	auipc	a0,0x4
    3d1a:	caa50513          	addi	a0,a0,-854 # 79c0 <malloc+0x1a7a>
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	e56080e7          	jalr	-426(ra) # 5b74 <unlink>
    3d26:	10050b63          	beqz	a0,3e3c <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3d2a:	00004597          	auipc	a1,0x4
    3d2e:	c9658593          	addi	a1,a1,-874 # 79c0 <malloc+0x1a7a>
    3d32:	00002517          	auipc	a0,0x2
    3d36:	4ee50513          	addi	a0,a0,1262 # 6220 <malloc+0x2da>
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	e4a080e7          	jalr	-438(ra) # 5b84 <link>
    3d42:	10050b63          	beqz	a0,3e58 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3d46:	00004517          	auipc	a0,0x4
    3d4a:	c3250513          	addi	a0,a0,-974 # 7978 <malloc+0x1a32>
    3d4e:	00002097          	auipc	ra,0x2
    3d52:	e26080e7          	jalr	-474(ra) # 5b74 <unlink>
    3d56:	10051f63          	bnez	a0,3e74 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3d5a:	4589                	li	a1,2
    3d5c:	00003517          	auipc	a0,0x3
    3d60:	9d450513          	addi	a0,a0,-1580 # 6730 <malloc+0x7ea>
    3d64:	00002097          	auipc	ra,0x2
    3d68:	e00080e7          	jalr	-512(ra) # 5b64 <open>
  if(fd >= 0){
    3d6c:	12055263          	bgez	a0,3e90 <dirfile+0x1fc>
  fd = open(".", 0);
    3d70:	4581                	li	a1,0
    3d72:	00003517          	auipc	a0,0x3
    3d76:	9be50513          	addi	a0,a0,-1602 # 6730 <malloc+0x7ea>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	dea080e7          	jalr	-534(ra) # 5b64 <open>
    3d82:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3d84:	4605                	li	a2,1
    3d86:	00002597          	auipc	a1,0x2
    3d8a:	36258593          	addi	a1,a1,866 # 60e8 <malloc+0x1a2>
    3d8e:	00002097          	auipc	ra,0x2
    3d92:	db6080e7          	jalr	-586(ra) # 5b44 <write>
    3d96:	10a04b63          	bgtz	a0,3eac <dirfile+0x218>
  close(fd);
    3d9a:	8526                	mv	a0,s1
    3d9c:	00002097          	auipc	ra,0x2
    3da0:	db0080e7          	jalr	-592(ra) # 5b4c <close>
}
    3da4:	60e2                	ld	ra,24(sp)
    3da6:	6442                	ld	s0,16(sp)
    3da8:	64a2                	ld	s1,8(sp)
    3daa:	6902                	ld	s2,0(sp)
    3dac:	6105                	addi	sp,sp,32
    3dae:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3db0:	85ca                	mv	a1,s2
    3db2:	00004517          	auipc	a0,0x4
    3db6:	bce50513          	addi	a0,a0,-1074 # 7980 <malloc+0x1a3a>
    3dba:	00002097          	auipc	ra,0x2
    3dbe:	0d0080e7          	jalr	208(ra) # 5e8a <printf>
    exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	d60080e7          	jalr	-672(ra) # 5b24 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3dcc:	85ca                	mv	a1,s2
    3dce:	00004517          	auipc	a0,0x4
    3dd2:	bd250513          	addi	a0,a0,-1070 # 79a0 <malloc+0x1a5a>
    3dd6:	00002097          	auipc	ra,0x2
    3dda:	0b4080e7          	jalr	180(ra) # 5e8a <printf>
    exit(1);
    3dde:	4505                	li	a0,1
    3de0:	00002097          	auipc	ra,0x2
    3de4:	d44080e7          	jalr	-700(ra) # 5b24 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3de8:	85ca                	mv	a1,s2
    3dea:	00004517          	auipc	a0,0x4
    3dee:	be650513          	addi	a0,a0,-1050 # 79d0 <malloc+0x1a8a>
    3df2:	00002097          	auipc	ra,0x2
    3df6:	098080e7          	jalr	152(ra) # 5e8a <printf>
    exit(1);
    3dfa:	4505                	li	a0,1
    3dfc:	00002097          	auipc	ra,0x2
    3e00:	d28080e7          	jalr	-728(ra) # 5b24 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3e04:	85ca                	mv	a1,s2
    3e06:	00004517          	auipc	a0,0x4
    3e0a:	bca50513          	addi	a0,a0,-1078 # 79d0 <malloc+0x1a8a>
    3e0e:	00002097          	auipc	ra,0x2
    3e12:	07c080e7          	jalr	124(ra) # 5e8a <printf>
    exit(1);
    3e16:	4505                	li	a0,1
    3e18:	00002097          	auipc	ra,0x2
    3e1c:	d0c080e7          	jalr	-756(ra) # 5b24 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3e20:	85ca                	mv	a1,s2
    3e22:	00004517          	auipc	a0,0x4
    3e26:	bd650513          	addi	a0,a0,-1066 # 79f8 <malloc+0x1ab2>
    3e2a:	00002097          	auipc	ra,0x2
    3e2e:	060080e7          	jalr	96(ra) # 5e8a <printf>
    exit(1);
    3e32:	4505                	li	a0,1
    3e34:	00002097          	auipc	ra,0x2
    3e38:	cf0080e7          	jalr	-784(ra) # 5b24 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3e3c:	85ca                	mv	a1,s2
    3e3e:	00004517          	auipc	a0,0x4
    3e42:	be250513          	addi	a0,a0,-1054 # 7a20 <malloc+0x1ada>
    3e46:	00002097          	auipc	ra,0x2
    3e4a:	044080e7          	jalr	68(ra) # 5e8a <printf>
    exit(1);
    3e4e:	4505                	li	a0,1
    3e50:	00002097          	auipc	ra,0x2
    3e54:	cd4080e7          	jalr	-812(ra) # 5b24 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3e58:	85ca                	mv	a1,s2
    3e5a:	00004517          	auipc	a0,0x4
    3e5e:	bee50513          	addi	a0,a0,-1042 # 7a48 <malloc+0x1b02>
    3e62:	00002097          	auipc	ra,0x2
    3e66:	028080e7          	jalr	40(ra) # 5e8a <printf>
    exit(1);
    3e6a:	4505                	li	a0,1
    3e6c:	00002097          	auipc	ra,0x2
    3e70:	cb8080e7          	jalr	-840(ra) # 5b24 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3e74:	85ca                	mv	a1,s2
    3e76:	00004517          	auipc	a0,0x4
    3e7a:	bfa50513          	addi	a0,a0,-1030 # 7a70 <malloc+0x1b2a>
    3e7e:	00002097          	auipc	ra,0x2
    3e82:	00c080e7          	jalr	12(ra) # 5e8a <printf>
    exit(1);
    3e86:	4505                	li	a0,1
    3e88:	00002097          	auipc	ra,0x2
    3e8c:	c9c080e7          	jalr	-868(ra) # 5b24 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3e90:	85ca                	mv	a1,s2
    3e92:	00004517          	auipc	a0,0x4
    3e96:	bfe50513          	addi	a0,a0,-1026 # 7a90 <malloc+0x1b4a>
    3e9a:	00002097          	auipc	ra,0x2
    3e9e:	ff0080e7          	jalr	-16(ra) # 5e8a <printf>
    exit(1);
    3ea2:	4505                	li	a0,1
    3ea4:	00002097          	auipc	ra,0x2
    3ea8:	c80080e7          	jalr	-896(ra) # 5b24 <exit>
    printf("%s: write . succeeded!\n", s);
    3eac:	85ca                	mv	a1,s2
    3eae:	00004517          	auipc	a0,0x4
    3eb2:	c0a50513          	addi	a0,a0,-1014 # 7ab8 <malloc+0x1b72>
    3eb6:	00002097          	auipc	ra,0x2
    3eba:	fd4080e7          	jalr	-44(ra) # 5e8a <printf>
    exit(1);
    3ebe:	4505                	li	a0,1
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	c64080e7          	jalr	-924(ra) # 5b24 <exit>

0000000000003ec8 <iref>:
{
    3ec8:	715d                	addi	sp,sp,-80
    3eca:	e486                	sd	ra,72(sp)
    3ecc:	e0a2                	sd	s0,64(sp)
    3ece:	fc26                	sd	s1,56(sp)
    3ed0:	f84a                	sd	s2,48(sp)
    3ed2:	f44e                	sd	s3,40(sp)
    3ed4:	f052                	sd	s4,32(sp)
    3ed6:	ec56                	sd	s5,24(sp)
    3ed8:	e85a                	sd	s6,16(sp)
    3eda:	e45e                	sd	s7,8(sp)
    3edc:	0880                	addi	s0,sp,80
    3ede:	8baa                	mv	s7,a0
    3ee0:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3ee4:	00004a97          	auipc	s5,0x4
    3ee8:	beca8a93          	addi	s5,s5,-1044 # 7ad0 <malloc+0x1b8a>
    mkdir("");
    3eec:	00003497          	auipc	s1,0x3
    3ef0:	6ec48493          	addi	s1,s1,1772 # 75d8 <malloc+0x1692>
    link("README", "");
    3ef4:	00002b17          	auipc	s6,0x2
    3ef8:	32cb0b13          	addi	s6,s6,812 # 6220 <malloc+0x2da>
    fd = open("", O_CREATE);
    3efc:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3f00:	00004997          	auipc	s3,0x4
    3f04:	ac898993          	addi	s3,s3,-1336 # 79c8 <malloc+0x1a82>
    3f08:	a891                	j	3f5c <iref+0x94>
      printf("%s: mkdir irefd failed\n", s);
    3f0a:	85de                	mv	a1,s7
    3f0c:	00004517          	auipc	a0,0x4
    3f10:	bcc50513          	addi	a0,a0,-1076 # 7ad8 <malloc+0x1b92>
    3f14:	00002097          	auipc	ra,0x2
    3f18:	f76080e7          	jalr	-138(ra) # 5e8a <printf>
      exit(1);
    3f1c:	4505                	li	a0,1
    3f1e:	00002097          	auipc	ra,0x2
    3f22:	c06080e7          	jalr	-1018(ra) # 5b24 <exit>
      printf("%s: chdir irefd failed\n", s);
    3f26:	85de                	mv	a1,s7
    3f28:	00004517          	auipc	a0,0x4
    3f2c:	bc850513          	addi	a0,a0,-1080 # 7af0 <malloc+0x1baa>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	f5a080e7          	jalr	-166(ra) # 5e8a <printf>
      exit(1);
    3f38:	4505                	li	a0,1
    3f3a:	00002097          	auipc	ra,0x2
    3f3e:	bea080e7          	jalr	-1046(ra) # 5b24 <exit>
      close(fd);
    3f42:	00002097          	auipc	ra,0x2
    3f46:	c0a080e7          	jalr	-1014(ra) # 5b4c <close>
    3f4a:	a881                	j	3f9a <iref+0xd2>
    unlink("xx");
    3f4c:	854e                	mv	a0,s3
    3f4e:	00002097          	auipc	ra,0x2
    3f52:	c26080e7          	jalr	-986(ra) # 5b74 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3f56:	397d                	addiw	s2,s2,-1
    3f58:	04090e63          	beqz	s2,3fb4 <iref+0xec>
    if(mkdir("irefd") != 0){
    3f5c:	8556                	mv	a0,s5
    3f5e:	00002097          	auipc	ra,0x2
    3f62:	c2e080e7          	jalr	-978(ra) # 5b8c <mkdir>
    3f66:	f155                	bnez	a0,3f0a <iref+0x42>
    if(chdir("irefd") != 0){
    3f68:	8556                	mv	a0,s5
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	c2a080e7          	jalr	-982(ra) # 5b94 <chdir>
    3f72:	f955                	bnez	a0,3f26 <iref+0x5e>
    mkdir("");
    3f74:	8526                	mv	a0,s1
    3f76:	00002097          	auipc	ra,0x2
    3f7a:	c16080e7          	jalr	-1002(ra) # 5b8c <mkdir>
    link("README", "");
    3f7e:	85a6                	mv	a1,s1
    3f80:	855a                	mv	a0,s6
    3f82:	00002097          	auipc	ra,0x2
    3f86:	c02080e7          	jalr	-1022(ra) # 5b84 <link>
    fd = open("", O_CREATE);
    3f8a:	85d2                	mv	a1,s4
    3f8c:	8526                	mv	a0,s1
    3f8e:	00002097          	auipc	ra,0x2
    3f92:	bd6080e7          	jalr	-1066(ra) # 5b64 <open>
    if(fd >= 0)
    3f96:	fa0556e3          	bgez	a0,3f42 <iref+0x7a>
    fd = open("xx", O_CREATE);
    3f9a:	85d2                	mv	a1,s4
    3f9c:	854e                	mv	a0,s3
    3f9e:	00002097          	auipc	ra,0x2
    3fa2:	bc6080e7          	jalr	-1082(ra) # 5b64 <open>
    if(fd >= 0)
    3fa6:	fa0543e3          	bltz	a0,3f4c <iref+0x84>
      close(fd);
    3faa:	00002097          	auipc	ra,0x2
    3fae:	ba2080e7          	jalr	-1118(ra) # 5b4c <close>
    3fb2:	bf69                	j	3f4c <iref+0x84>
    3fb4:	03300493          	li	s1,51
    chdir("..");
    3fb8:	00003997          	auipc	s3,0x3
    3fbc:	34098993          	addi	s3,s3,832 # 72f8 <malloc+0x13b2>
    unlink("irefd");
    3fc0:	00004917          	auipc	s2,0x4
    3fc4:	b1090913          	addi	s2,s2,-1264 # 7ad0 <malloc+0x1b8a>
    chdir("..");
    3fc8:	854e                	mv	a0,s3
    3fca:	00002097          	auipc	ra,0x2
    3fce:	bca080e7          	jalr	-1078(ra) # 5b94 <chdir>
    unlink("irefd");
    3fd2:	854a                	mv	a0,s2
    3fd4:	00002097          	auipc	ra,0x2
    3fd8:	ba0080e7          	jalr	-1120(ra) # 5b74 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3fdc:	34fd                	addiw	s1,s1,-1
    3fde:	f4ed                	bnez	s1,3fc8 <iref+0x100>
  chdir("/");
    3fe0:	00003517          	auipc	a0,0x3
    3fe4:	2c050513          	addi	a0,a0,704 # 72a0 <malloc+0x135a>
    3fe8:	00002097          	auipc	ra,0x2
    3fec:	bac080e7          	jalr	-1108(ra) # 5b94 <chdir>
}
    3ff0:	60a6                	ld	ra,72(sp)
    3ff2:	6406                	ld	s0,64(sp)
    3ff4:	74e2                	ld	s1,56(sp)
    3ff6:	7942                	ld	s2,48(sp)
    3ff8:	79a2                	ld	s3,40(sp)
    3ffa:	7a02                	ld	s4,32(sp)
    3ffc:	6ae2                	ld	s5,24(sp)
    3ffe:	6b42                	ld	s6,16(sp)
    4000:	6ba2                	ld	s7,8(sp)
    4002:	6161                	addi	sp,sp,80
    4004:	8082                	ret

0000000000004006 <openiputtest>:
{
    4006:	7179                	addi	sp,sp,-48
    4008:	f406                	sd	ra,40(sp)
    400a:	f022                	sd	s0,32(sp)
    400c:	ec26                	sd	s1,24(sp)
    400e:	1800                	addi	s0,sp,48
    4010:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4012:	00004517          	auipc	a0,0x4
    4016:	af650513          	addi	a0,a0,-1290 # 7b08 <malloc+0x1bc2>
    401a:	00002097          	auipc	ra,0x2
    401e:	b72080e7          	jalr	-1166(ra) # 5b8c <mkdir>
    4022:	04054263          	bltz	a0,4066 <openiputtest+0x60>
  pid = fork();
    4026:	00002097          	auipc	ra,0x2
    402a:	af6080e7          	jalr	-1290(ra) # 5b1c <fork>
  if(pid < 0){
    402e:	04054a63          	bltz	a0,4082 <openiputtest+0x7c>
  if(pid == 0){
    4032:	e93d                	bnez	a0,40a8 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4034:	4589                	li	a1,2
    4036:	00004517          	auipc	a0,0x4
    403a:	ad250513          	addi	a0,a0,-1326 # 7b08 <malloc+0x1bc2>
    403e:	00002097          	auipc	ra,0x2
    4042:	b26080e7          	jalr	-1242(ra) # 5b64 <open>
    if(fd >= 0){
    4046:	04054c63          	bltz	a0,409e <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    404a:	85a6                	mv	a1,s1
    404c:	00004517          	auipc	a0,0x4
    4050:	adc50513          	addi	a0,a0,-1316 # 7b28 <malloc+0x1be2>
    4054:	00002097          	auipc	ra,0x2
    4058:	e36080e7          	jalr	-458(ra) # 5e8a <printf>
      exit(1);
    405c:	4505                	li	a0,1
    405e:	00002097          	auipc	ra,0x2
    4062:	ac6080e7          	jalr	-1338(ra) # 5b24 <exit>
    printf("%s: mkdir oidir failed\n", s);
    4066:	85a6                	mv	a1,s1
    4068:	00004517          	auipc	a0,0x4
    406c:	aa850513          	addi	a0,a0,-1368 # 7b10 <malloc+0x1bca>
    4070:	00002097          	auipc	ra,0x2
    4074:	e1a080e7          	jalr	-486(ra) # 5e8a <printf>
    exit(1);
    4078:	4505                	li	a0,1
    407a:	00002097          	auipc	ra,0x2
    407e:	aaa080e7          	jalr	-1366(ra) # 5b24 <exit>
    printf("%s: fork failed\n", s);
    4082:	85a6                	mv	a1,s1
    4084:	00003517          	auipc	a0,0x3
    4088:	84c50513          	addi	a0,a0,-1972 # 68d0 <malloc+0x98a>
    408c:	00002097          	auipc	ra,0x2
    4090:	dfe080e7          	jalr	-514(ra) # 5e8a <printf>
    exit(1);
    4094:	4505                	li	a0,1
    4096:	00002097          	auipc	ra,0x2
    409a:	a8e080e7          	jalr	-1394(ra) # 5b24 <exit>
    exit(0);
    409e:	4501                	li	a0,0
    40a0:	00002097          	auipc	ra,0x2
    40a4:	a84080e7          	jalr	-1404(ra) # 5b24 <exit>
  sleep(1);
    40a8:	4505                	li	a0,1
    40aa:	00002097          	auipc	ra,0x2
    40ae:	b0a080e7          	jalr	-1270(ra) # 5bb4 <sleep>
  if(unlink("oidir") != 0){
    40b2:	00004517          	auipc	a0,0x4
    40b6:	a5650513          	addi	a0,a0,-1450 # 7b08 <malloc+0x1bc2>
    40ba:	00002097          	auipc	ra,0x2
    40be:	aba080e7          	jalr	-1350(ra) # 5b74 <unlink>
    40c2:	cd19                	beqz	a0,40e0 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    40c4:	85a6                	mv	a1,s1
    40c6:	00003517          	auipc	a0,0x3
    40ca:	9fa50513          	addi	a0,a0,-1542 # 6ac0 <malloc+0xb7a>
    40ce:	00002097          	auipc	ra,0x2
    40d2:	dbc080e7          	jalr	-580(ra) # 5e8a <printf>
    exit(1);
    40d6:	4505                	li	a0,1
    40d8:	00002097          	auipc	ra,0x2
    40dc:	a4c080e7          	jalr	-1460(ra) # 5b24 <exit>
  wait(&xstatus);
    40e0:	fdc40513          	addi	a0,s0,-36
    40e4:	00002097          	auipc	ra,0x2
    40e8:	a48080e7          	jalr	-1464(ra) # 5b2c <wait>
  exit(xstatus);
    40ec:	fdc42503          	lw	a0,-36(s0)
    40f0:	00002097          	auipc	ra,0x2
    40f4:	a34080e7          	jalr	-1484(ra) # 5b24 <exit>

00000000000040f8 <forkforkfork>:
{
    40f8:	1101                	addi	sp,sp,-32
    40fa:	ec06                	sd	ra,24(sp)
    40fc:	e822                	sd	s0,16(sp)
    40fe:	e426                	sd	s1,8(sp)
    4100:	1000                	addi	s0,sp,32
    4102:	84aa                	mv	s1,a0
  unlink("stopforking");
    4104:	00004517          	auipc	a0,0x4
    4108:	a4c50513          	addi	a0,a0,-1460 # 7b50 <malloc+0x1c0a>
    410c:	00002097          	auipc	ra,0x2
    4110:	a68080e7          	jalr	-1432(ra) # 5b74 <unlink>
  int pid = fork();
    4114:	00002097          	auipc	ra,0x2
    4118:	a08080e7          	jalr	-1528(ra) # 5b1c <fork>
  if(pid < 0){
    411c:	04054563          	bltz	a0,4166 <forkforkfork+0x6e>
  if(pid == 0){
    4120:	c12d                	beqz	a0,4182 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4122:	4551                	li	a0,20
    4124:	00002097          	auipc	ra,0x2
    4128:	a90080e7          	jalr	-1392(ra) # 5bb4 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    412c:	20200593          	li	a1,514
    4130:	00004517          	auipc	a0,0x4
    4134:	a2050513          	addi	a0,a0,-1504 # 7b50 <malloc+0x1c0a>
    4138:	00002097          	auipc	ra,0x2
    413c:	a2c080e7          	jalr	-1492(ra) # 5b64 <open>
    4140:	00002097          	auipc	ra,0x2
    4144:	a0c080e7          	jalr	-1524(ra) # 5b4c <close>
  wait(0);
    4148:	4501                	li	a0,0
    414a:	00002097          	auipc	ra,0x2
    414e:	9e2080e7          	jalr	-1566(ra) # 5b2c <wait>
  sleep(10); // one second
    4152:	4529                	li	a0,10
    4154:	00002097          	auipc	ra,0x2
    4158:	a60080e7          	jalr	-1440(ra) # 5bb4 <sleep>
}
    415c:	60e2                	ld	ra,24(sp)
    415e:	6442                	ld	s0,16(sp)
    4160:	64a2                	ld	s1,8(sp)
    4162:	6105                	addi	sp,sp,32
    4164:	8082                	ret
    printf("%s: fork failed", s);
    4166:	85a6                	mv	a1,s1
    4168:	00003517          	auipc	a0,0x3
    416c:	92850513          	addi	a0,a0,-1752 # 6a90 <malloc+0xb4a>
    4170:	00002097          	auipc	ra,0x2
    4174:	d1a080e7          	jalr	-742(ra) # 5e8a <printf>
    exit(1);
    4178:	4505                	li	a0,1
    417a:	00002097          	auipc	ra,0x2
    417e:	9aa080e7          	jalr	-1622(ra) # 5b24 <exit>
      int fd = open("stopforking", 0);
    4182:	00004497          	auipc	s1,0x4
    4186:	9ce48493          	addi	s1,s1,-1586 # 7b50 <malloc+0x1c0a>
    418a:	4581                	li	a1,0
    418c:	8526                	mv	a0,s1
    418e:	00002097          	auipc	ra,0x2
    4192:	9d6080e7          	jalr	-1578(ra) # 5b64 <open>
      if(fd >= 0){
    4196:	02055763          	bgez	a0,41c4 <forkforkfork+0xcc>
      if(fork() < 0){
    419a:	00002097          	auipc	ra,0x2
    419e:	982080e7          	jalr	-1662(ra) # 5b1c <fork>
    41a2:	fe0554e3          	bgez	a0,418a <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    41a6:	20200593          	li	a1,514
    41aa:	00004517          	auipc	a0,0x4
    41ae:	9a650513          	addi	a0,a0,-1626 # 7b50 <malloc+0x1c0a>
    41b2:	00002097          	auipc	ra,0x2
    41b6:	9b2080e7          	jalr	-1614(ra) # 5b64 <open>
    41ba:	00002097          	auipc	ra,0x2
    41be:	992080e7          	jalr	-1646(ra) # 5b4c <close>
    41c2:	b7e1                	j	418a <forkforkfork+0x92>
        exit(0);
    41c4:	4501                	li	a0,0
    41c6:	00002097          	auipc	ra,0x2
    41ca:	95e080e7          	jalr	-1698(ra) # 5b24 <exit>

00000000000041ce <killstatus>:
{
    41ce:	715d                	addi	sp,sp,-80
    41d0:	e486                	sd	ra,72(sp)
    41d2:	e0a2                	sd	s0,64(sp)
    41d4:	fc26                	sd	s1,56(sp)
    41d6:	f84a                	sd	s2,48(sp)
    41d8:	f44e                	sd	s3,40(sp)
    41da:	f052                	sd	s4,32(sp)
    41dc:	ec56                	sd	s5,24(sp)
    41de:	e85a                	sd	s6,16(sp)
    41e0:	0880                	addi	s0,sp,80
    41e2:	8b2a                	mv	s6,a0
    41e4:	06400913          	li	s2,100
    sleep(1);
    41e8:	4a85                	li	s5,1
    wait(&xst);
    41ea:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    41ee:	59fd                	li	s3,-1
    int pid1 = fork();
    41f0:	00002097          	auipc	ra,0x2
    41f4:	92c080e7          	jalr	-1748(ra) # 5b1c <fork>
    41f8:	84aa                	mv	s1,a0
    if(pid1 < 0){
    41fa:	02054e63          	bltz	a0,4236 <killstatus+0x68>
    if(pid1 == 0){
    41fe:	c931                	beqz	a0,4252 <killstatus+0x84>
    sleep(1);
    4200:	8556                	mv	a0,s5
    4202:	00002097          	auipc	ra,0x2
    4206:	9b2080e7          	jalr	-1614(ra) # 5bb4 <sleep>
    kill(pid1);
    420a:	8526                	mv	a0,s1
    420c:	00002097          	auipc	ra,0x2
    4210:	948080e7          	jalr	-1720(ra) # 5b54 <kill>
    wait(&xst);
    4214:	8552                	mv	a0,s4
    4216:	00002097          	auipc	ra,0x2
    421a:	916080e7          	jalr	-1770(ra) # 5b2c <wait>
    if(xst != -1) {
    421e:	fbc42783          	lw	a5,-68(s0)
    4222:	03379d63          	bne	a5,s3,425c <killstatus+0x8e>
  for(int i = 0; i < 100; i++){
    4226:	397d                	addiw	s2,s2,-1
    4228:	fc0914e3          	bnez	s2,41f0 <killstatus+0x22>
  exit(0);
    422c:	4501                	li	a0,0
    422e:	00002097          	auipc	ra,0x2
    4232:	8f6080e7          	jalr	-1802(ra) # 5b24 <exit>
      printf("%s: fork failed\n", s);
    4236:	85da                	mv	a1,s6
    4238:	00002517          	auipc	a0,0x2
    423c:	69850513          	addi	a0,a0,1688 # 68d0 <malloc+0x98a>
    4240:	00002097          	auipc	ra,0x2
    4244:	c4a080e7          	jalr	-950(ra) # 5e8a <printf>
      exit(1);
    4248:	4505                	li	a0,1
    424a:	00002097          	auipc	ra,0x2
    424e:	8da080e7          	jalr	-1830(ra) # 5b24 <exit>
        getpid();
    4252:	00002097          	auipc	ra,0x2
    4256:	952080e7          	jalr	-1710(ra) # 5ba4 <getpid>
      while(1) {
    425a:	bfe5                	j	4252 <killstatus+0x84>
       printf("%s: status should be -1\n", s);
    425c:	85da                	mv	a1,s6
    425e:	00004517          	auipc	a0,0x4
    4262:	90250513          	addi	a0,a0,-1790 # 7b60 <malloc+0x1c1a>
    4266:	00002097          	auipc	ra,0x2
    426a:	c24080e7          	jalr	-988(ra) # 5e8a <printf>
       exit(1);
    426e:	4505                	li	a0,1
    4270:	00002097          	auipc	ra,0x2
    4274:	8b4080e7          	jalr	-1868(ra) # 5b24 <exit>

0000000000004278 <preempt>:
{
    4278:	7139                	addi	sp,sp,-64
    427a:	fc06                	sd	ra,56(sp)
    427c:	f822                	sd	s0,48(sp)
    427e:	f426                	sd	s1,40(sp)
    4280:	f04a                	sd	s2,32(sp)
    4282:	ec4e                	sd	s3,24(sp)
    4284:	e852                	sd	s4,16(sp)
    4286:	0080                	addi	s0,sp,64
    4288:	892a                	mv	s2,a0
  pid1 = fork();
    428a:	00002097          	auipc	ra,0x2
    428e:	892080e7          	jalr	-1902(ra) # 5b1c <fork>
  if(pid1 < 0) {
    4292:	00054563          	bltz	a0,429c <preempt+0x24>
    4296:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4298:	e105                	bnez	a0,42b8 <preempt+0x40>
    for(;;)
    429a:	a001                	j	429a <preempt+0x22>
    printf("%s: fork failed", s);
    429c:	85ca                	mv	a1,s2
    429e:	00002517          	auipc	a0,0x2
    42a2:	7f250513          	addi	a0,a0,2034 # 6a90 <malloc+0xb4a>
    42a6:	00002097          	auipc	ra,0x2
    42aa:	be4080e7          	jalr	-1052(ra) # 5e8a <printf>
    exit(1);
    42ae:	4505                	li	a0,1
    42b0:	00002097          	auipc	ra,0x2
    42b4:	874080e7          	jalr	-1932(ra) # 5b24 <exit>
  pid2 = fork();
    42b8:	00002097          	auipc	ra,0x2
    42bc:	864080e7          	jalr	-1948(ra) # 5b1c <fork>
    42c0:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    42c2:	00054463          	bltz	a0,42ca <preempt+0x52>
  if(pid2 == 0)
    42c6:	e105                	bnez	a0,42e6 <preempt+0x6e>
    for(;;)
    42c8:	a001                	j	42c8 <preempt+0x50>
    printf("%s: fork failed\n", s);
    42ca:	85ca                	mv	a1,s2
    42cc:	00002517          	auipc	a0,0x2
    42d0:	60450513          	addi	a0,a0,1540 # 68d0 <malloc+0x98a>
    42d4:	00002097          	auipc	ra,0x2
    42d8:	bb6080e7          	jalr	-1098(ra) # 5e8a <printf>
    exit(1);
    42dc:	4505                	li	a0,1
    42de:	00002097          	auipc	ra,0x2
    42e2:	846080e7          	jalr	-1978(ra) # 5b24 <exit>
  pipe(pfds);
    42e6:	fc840513          	addi	a0,s0,-56
    42ea:	00002097          	auipc	ra,0x2
    42ee:	84a080e7          	jalr	-1974(ra) # 5b34 <pipe>
  pid3 = fork();
    42f2:	00002097          	auipc	ra,0x2
    42f6:	82a080e7          	jalr	-2006(ra) # 5b1c <fork>
    42fa:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    42fc:	02054e63          	bltz	a0,4338 <preempt+0xc0>
  if(pid3 == 0){
    4300:	e525                	bnez	a0,4368 <preempt+0xf0>
    close(pfds[0]);
    4302:	fc842503          	lw	a0,-56(s0)
    4306:	00002097          	auipc	ra,0x2
    430a:	846080e7          	jalr	-1978(ra) # 5b4c <close>
    if(write(pfds[1], "x", 1) != 1)
    430e:	4605                	li	a2,1
    4310:	00002597          	auipc	a1,0x2
    4314:	dd858593          	addi	a1,a1,-552 # 60e8 <malloc+0x1a2>
    4318:	fcc42503          	lw	a0,-52(s0)
    431c:	00002097          	auipc	ra,0x2
    4320:	828080e7          	jalr	-2008(ra) # 5b44 <write>
    4324:	4785                	li	a5,1
    4326:	02f51763          	bne	a0,a5,4354 <preempt+0xdc>
    close(pfds[1]);
    432a:	fcc42503          	lw	a0,-52(s0)
    432e:	00002097          	auipc	ra,0x2
    4332:	81e080e7          	jalr	-2018(ra) # 5b4c <close>
    for(;;)
    4336:	a001                	j	4336 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4338:	85ca                	mv	a1,s2
    433a:	00002517          	auipc	a0,0x2
    433e:	59650513          	addi	a0,a0,1430 # 68d0 <malloc+0x98a>
    4342:	00002097          	auipc	ra,0x2
    4346:	b48080e7          	jalr	-1208(ra) # 5e8a <printf>
     exit(1);
    434a:	4505                	li	a0,1
    434c:	00001097          	auipc	ra,0x1
    4350:	7d8080e7          	jalr	2008(ra) # 5b24 <exit>
      printf("%s: preempt write error", s);
    4354:	85ca                	mv	a1,s2
    4356:	00004517          	auipc	a0,0x4
    435a:	82a50513          	addi	a0,a0,-2006 # 7b80 <malloc+0x1c3a>
    435e:	00002097          	auipc	ra,0x2
    4362:	b2c080e7          	jalr	-1236(ra) # 5e8a <printf>
    4366:	b7d1                	j	432a <preempt+0xb2>
  close(pfds[1]);
    4368:	fcc42503          	lw	a0,-52(s0)
    436c:	00001097          	auipc	ra,0x1
    4370:	7e0080e7          	jalr	2016(ra) # 5b4c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4374:	660d                	lui	a2,0x3
    4376:	00008597          	auipc	a1,0x8
    437a:	d3a58593          	addi	a1,a1,-710 # c0b0 <buf>
    437e:	fc842503          	lw	a0,-56(s0)
    4382:	00001097          	auipc	ra,0x1
    4386:	7ba080e7          	jalr	1978(ra) # 5b3c <read>
    438a:	4785                	li	a5,1
    438c:	02f50363          	beq	a0,a5,43b2 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4390:	85ca                	mv	a1,s2
    4392:	00004517          	auipc	a0,0x4
    4396:	80650513          	addi	a0,a0,-2042 # 7b98 <malloc+0x1c52>
    439a:	00002097          	auipc	ra,0x2
    439e:	af0080e7          	jalr	-1296(ra) # 5e8a <printf>
}
    43a2:	70e2                	ld	ra,56(sp)
    43a4:	7442                	ld	s0,48(sp)
    43a6:	74a2                	ld	s1,40(sp)
    43a8:	7902                	ld	s2,32(sp)
    43aa:	69e2                	ld	s3,24(sp)
    43ac:	6a42                	ld	s4,16(sp)
    43ae:	6121                	addi	sp,sp,64
    43b0:	8082                	ret
  close(pfds[0]);
    43b2:	fc842503          	lw	a0,-56(s0)
    43b6:	00001097          	auipc	ra,0x1
    43ba:	796080e7          	jalr	1942(ra) # 5b4c <close>
  printf("kill... ");
    43be:	00003517          	auipc	a0,0x3
    43c2:	7f250513          	addi	a0,a0,2034 # 7bb0 <malloc+0x1c6a>
    43c6:	00002097          	auipc	ra,0x2
    43ca:	ac4080e7          	jalr	-1340(ra) # 5e8a <printf>
  kill(pid1);
    43ce:	8526                	mv	a0,s1
    43d0:	00001097          	auipc	ra,0x1
    43d4:	784080e7          	jalr	1924(ra) # 5b54 <kill>
  kill(pid2);
    43d8:	854e                	mv	a0,s3
    43da:	00001097          	auipc	ra,0x1
    43de:	77a080e7          	jalr	1914(ra) # 5b54 <kill>
  kill(pid3);
    43e2:	8552                	mv	a0,s4
    43e4:	00001097          	auipc	ra,0x1
    43e8:	770080e7          	jalr	1904(ra) # 5b54 <kill>
  printf("wait... ");
    43ec:	00003517          	auipc	a0,0x3
    43f0:	7d450513          	addi	a0,a0,2004 # 7bc0 <malloc+0x1c7a>
    43f4:	00002097          	auipc	ra,0x2
    43f8:	a96080e7          	jalr	-1386(ra) # 5e8a <printf>
  wait(0);
    43fc:	4501                	li	a0,0
    43fe:	00001097          	auipc	ra,0x1
    4402:	72e080e7          	jalr	1838(ra) # 5b2c <wait>
  wait(0);
    4406:	4501                	li	a0,0
    4408:	00001097          	auipc	ra,0x1
    440c:	724080e7          	jalr	1828(ra) # 5b2c <wait>
  wait(0);
    4410:	4501                	li	a0,0
    4412:	00001097          	auipc	ra,0x1
    4416:	71a080e7          	jalr	1818(ra) # 5b2c <wait>
    441a:	b761                	j	43a2 <preempt+0x12a>

000000000000441c <reparent>:
{
    441c:	7179                	addi	sp,sp,-48
    441e:	f406                	sd	ra,40(sp)
    4420:	f022                	sd	s0,32(sp)
    4422:	ec26                	sd	s1,24(sp)
    4424:	e84a                	sd	s2,16(sp)
    4426:	e44e                	sd	s3,8(sp)
    4428:	e052                	sd	s4,0(sp)
    442a:	1800                	addi	s0,sp,48
    442c:	89aa                	mv	s3,a0
  int master_pid = getpid();
    442e:	00001097          	auipc	ra,0x1
    4432:	776080e7          	jalr	1910(ra) # 5ba4 <getpid>
    4436:	8a2a                	mv	s4,a0
    4438:	0c800913          	li	s2,200
    int pid = fork();
    443c:	00001097          	auipc	ra,0x1
    4440:	6e0080e7          	jalr	1760(ra) # 5b1c <fork>
    4444:	84aa                	mv	s1,a0
    if(pid < 0){
    4446:	02054263          	bltz	a0,446a <reparent+0x4e>
    if(pid){
    444a:	cd21                	beqz	a0,44a2 <reparent+0x86>
      if(wait(0) != pid){
    444c:	4501                	li	a0,0
    444e:	00001097          	auipc	ra,0x1
    4452:	6de080e7          	jalr	1758(ra) # 5b2c <wait>
    4456:	02951863          	bne	a0,s1,4486 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    445a:	397d                	addiw	s2,s2,-1
    445c:	fe0910e3          	bnez	s2,443c <reparent+0x20>
  exit(0);
    4460:	4501                	li	a0,0
    4462:	00001097          	auipc	ra,0x1
    4466:	6c2080e7          	jalr	1730(ra) # 5b24 <exit>
      printf("%s: fork failed\n", s);
    446a:	85ce                	mv	a1,s3
    446c:	00002517          	auipc	a0,0x2
    4470:	46450513          	addi	a0,a0,1124 # 68d0 <malloc+0x98a>
    4474:	00002097          	auipc	ra,0x2
    4478:	a16080e7          	jalr	-1514(ra) # 5e8a <printf>
      exit(1);
    447c:	4505                	li	a0,1
    447e:	00001097          	auipc	ra,0x1
    4482:	6a6080e7          	jalr	1702(ra) # 5b24 <exit>
        printf("%s: wait wrong pid\n", s);
    4486:	85ce                	mv	a1,s3
    4488:	00002517          	auipc	a0,0x2
    448c:	5d050513          	addi	a0,a0,1488 # 6a58 <malloc+0xb12>
    4490:	00002097          	auipc	ra,0x2
    4494:	9fa080e7          	jalr	-1542(ra) # 5e8a <printf>
        exit(1);
    4498:	4505                	li	a0,1
    449a:	00001097          	auipc	ra,0x1
    449e:	68a080e7          	jalr	1674(ra) # 5b24 <exit>
      int pid2 = fork();
    44a2:	00001097          	auipc	ra,0x1
    44a6:	67a080e7          	jalr	1658(ra) # 5b1c <fork>
      if(pid2 < 0){
    44aa:	00054763          	bltz	a0,44b8 <reparent+0x9c>
      exit(0);
    44ae:	4501                	li	a0,0
    44b0:	00001097          	auipc	ra,0x1
    44b4:	674080e7          	jalr	1652(ra) # 5b24 <exit>
        kill(master_pid);
    44b8:	8552                	mv	a0,s4
    44ba:	00001097          	auipc	ra,0x1
    44be:	69a080e7          	jalr	1690(ra) # 5b54 <kill>
        exit(1);
    44c2:	4505                	li	a0,1
    44c4:	00001097          	auipc	ra,0x1
    44c8:	660080e7          	jalr	1632(ra) # 5b24 <exit>

00000000000044cc <sbrkfail>:
{
    44cc:	7175                	addi	sp,sp,-144
    44ce:	e506                	sd	ra,136(sp)
    44d0:	e122                	sd	s0,128(sp)
    44d2:	fca6                	sd	s1,120(sp)
    44d4:	f8ca                	sd	s2,112(sp)
    44d6:	f4ce                	sd	s3,104(sp)
    44d8:	f0d2                	sd	s4,96(sp)
    44da:	ecd6                	sd	s5,88(sp)
    44dc:	e8da                	sd	s6,80(sp)
    44de:	e4de                	sd	s7,72(sp)
    44e0:	0900                	addi	s0,sp,144
    44e2:	8baa                	mv	s7,a0
  if(pipe(fds) != 0){
    44e4:	fa040513          	addi	a0,s0,-96
    44e8:	00001097          	auipc	ra,0x1
    44ec:	64c080e7          	jalr	1612(ra) # 5b34 <pipe>
    44f0:	e919                	bnez	a0,4506 <sbrkfail+0x3a>
    44f2:	f7040493          	addi	s1,s0,-144
    44f6:	f9840993          	addi	s3,s0,-104
    44fa:	8926                	mv	s2,s1
    if(pids[i] != -1)
    44fc:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    44fe:	f9f40b13          	addi	s6,s0,-97
    4502:	4a85                	li	s5,1
    4504:	a08d                	j	4566 <sbrkfail+0x9a>
    printf("%s: pipe() failed\n", s);
    4506:	85de                	mv	a1,s7
    4508:	00002517          	auipc	a0,0x2
    450c:	4d050513          	addi	a0,a0,1232 # 69d8 <malloc+0xa92>
    4510:	00002097          	auipc	ra,0x2
    4514:	97a080e7          	jalr	-1670(ra) # 5e8a <printf>
    exit(1);
    4518:	4505                	li	a0,1
    451a:	00001097          	auipc	ra,0x1
    451e:	60a080e7          	jalr	1546(ra) # 5b24 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4522:	00001097          	auipc	ra,0x1
    4526:	68a080e7          	jalr	1674(ra) # 5bac <sbrk>
    452a:	064007b7          	lui	a5,0x6400
    452e:	40a7853b          	subw	a0,a5,a0
    4532:	00001097          	auipc	ra,0x1
    4536:	67a080e7          	jalr	1658(ra) # 5bac <sbrk>
      write(fds[1], "x", 1);
    453a:	4605                	li	a2,1
    453c:	00002597          	auipc	a1,0x2
    4540:	bac58593          	addi	a1,a1,-1108 # 60e8 <malloc+0x1a2>
    4544:	fa442503          	lw	a0,-92(s0)
    4548:	00001097          	auipc	ra,0x1
    454c:	5fc080e7          	jalr	1532(ra) # 5b44 <write>
      for(;;) sleep(1000);
    4550:	3e800493          	li	s1,1000
    4554:	8526                	mv	a0,s1
    4556:	00001097          	auipc	ra,0x1
    455a:	65e080e7          	jalr	1630(ra) # 5bb4 <sleep>
    455e:	bfdd                	j	4554 <sbrkfail+0x88>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4560:	0911                	addi	s2,s2,4
    4562:	03390463          	beq	s2,s3,458a <sbrkfail+0xbe>
    if((pids[i] = fork()) == 0){
    4566:	00001097          	auipc	ra,0x1
    456a:	5b6080e7          	jalr	1462(ra) # 5b1c <fork>
    456e:	00a92023          	sw	a0,0(s2)
    4572:	d945                	beqz	a0,4522 <sbrkfail+0x56>
    if(pids[i] != -1)
    4574:	ff4506e3          	beq	a0,s4,4560 <sbrkfail+0x94>
      read(fds[0], &scratch, 1);
    4578:	8656                	mv	a2,s5
    457a:	85da                	mv	a1,s6
    457c:	fa042503          	lw	a0,-96(s0)
    4580:	00001097          	auipc	ra,0x1
    4584:	5bc080e7          	jalr	1468(ra) # 5b3c <read>
    4588:	bfe1                	j	4560 <sbrkfail+0x94>
  c = sbrk(PGSIZE);
    458a:	6505                	lui	a0,0x1
    458c:	00001097          	auipc	ra,0x1
    4590:	620080e7          	jalr	1568(ra) # 5bac <sbrk>
    4594:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4596:	597d                	li	s2,-1
    4598:	a021                	j	45a0 <sbrkfail+0xd4>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    459a:	0491                	addi	s1,s1,4
    459c:	01348f63          	beq	s1,s3,45ba <sbrkfail+0xee>
    if(pids[i] == -1)
    45a0:	4088                	lw	a0,0(s1)
    45a2:	ff250ce3          	beq	a0,s2,459a <sbrkfail+0xce>
    kill(pids[i]);
    45a6:	00001097          	auipc	ra,0x1
    45aa:	5ae080e7          	jalr	1454(ra) # 5b54 <kill>
    wait(0);
    45ae:	4501                	li	a0,0
    45b0:	00001097          	auipc	ra,0x1
    45b4:	57c080e7          	jalr	1404(ra) # 5b2c <wait>
    45b8:	b7cd                	j	459a <sbrkfail+0xce>
  if(c == (char*)0xffffffffffffffffL){
    45ba:	57fd                	li	a5,-1
    45bc:	04fa0363          	beq	s4,a5,4602 <sbrkfail+0x136>
  pid = fork();
    45c0:	00001097          	auipc	ra,0x1
    45c4:	55c080e7          	jalr	1372(ra) # 5b1c <fork>
    45c8:	84aa                	mv	s1,a0
  if(pid < 0){
    45ca:	04054a63          	bltz	a0,461e <sbrkfail+0x152>
  if(pid == 0){
    45ce:	c535                	beqz	a0,463a <sbrkfail+0x16e>
  wait(&xstatus);
    45d0:	fac40513          	addi	a0,s0,-84
    45d4:	00001097          	auipc	ra,0x1
    45d8:	558080e7          	jalr	1368(ra) # 5b2c <wait>
  if(xstatus != -1 && xstatus != 2)
    45dc:	fac42783          	lw	a5,-84(s0)
    45e0:	577d                	li	a4,-1
    45e2:	00e78563          	beq	a5,a4,45ec <sbrkfail+0x120>
    45e6:	4709                	li	a4,2
    45e8:	08e79f63          	bne	a5,a4,4686 <sbrkfail+0x1ba>
}
    45ec:	60aa                	ld	ra,136(sp)
    45ee:	640a                	ld	s0,128(sp)
    45f0:	74e6                	ld	s1,120(sp)
    45f2:	7946                	ld	s2,112(sp)
    45f4:	79a6                	ld	s3,104(sp)
    45f6:	7a06                	ld	s4,96(sp)
    45f8:	6ae6                	ld	s5,88(sp)
    45fa:	6b46                	ld	s6,80(sp)
    45fc:	6ba6                	ld	s7,72(sp)
    45fe:	6149                	addi	sp,sp,144
    4600:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4602:	85de                	mv	a1,s7
    4604:	00003517          	auipc	a0,0x3
    4608:	5cc50513          	addi	a0,a0,1484 # 7bd0 <malloc+0x1c8a>
    460c:	00002097          	auipc	ra,0x2
    4610:	87e080e7          	jalr	-1922(ra) # 5e8a <printf>
    exit(1);
    4614:	4505                	li	a0,1
    4616:	00001097          	auipc	ra,0x1
    461a:	50e080e7          	jalr	1294(ra) # 5b24 <exit>
    printf("%s: fork failed\n", s);
    461e:	85de                	mv	a1,s7
    4620:	00002517          	auipc	a0,0x2
    4624:	2b050513          	addi	a0,a0,688 # 68d0 <malloc+0x98a>
    4628:	00002097          	auipc	ra,0x2
    462c:	862080e7          	jalr	-1950(ra) # 5e8a <printf>
    exit(1);
    4630:	4505                	li	a0,1
    4632:	00001097          	auipc	ra,0x1
    4636:	4f2080e7          	jalr	1266(ra) # 5b24 <exit>
    a = sbrk(0);
    463a:	4501                	li	a0,0
    463c:	00001097          	auipc	ra,0x1
    4640:	570080e7          	jalr	1392(ra) # 5bac <sbrk>
    4644:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4646:	3e800537          	lui	a0,0x3e800
    464a:	00001097          	auipc	ra,0x1
    464e:	562080e7          	jalr	1378(ra) # 5bac <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4652:	87ca                	mv	a5,s2
    4654:	3e800737          	lui	a4,0x3e800
    4658:	993a                	add	s2,s2,a4
    465a:	6705                	lui	a4,0x1
      n += *(a+i);
    465c:	0007c603          	lbu	a2,0(a5) # 6400000 <__BSS_END__+0x63f0f40>
    4660:	9e25                	addw	a2,a2,s1
    4662:	84b2                	mv	s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4664:	97ba                	add	a5,a5,a4
    4666:	fef91be3          	bne	s2,a5,465c <sbrkfail+0x190>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    466a:	85de                	mv	a1,s7
    466c:	00003517          	auipc	a0,0x3
    4670:	58450513          	addi	a0,a0,1412 # 7bf0 <malloc+0x1caa>
    4674:	00002097          	auipc	ra,0x2
    4678:	816080e7          	jalr	-2026(ra) # 5e8a <printf>
    exit(1);
    467c:	4505                	li	a0,1
    467e:	00001097          	auipc	ra,0x1
    4682:	4a6080e7          	jalr	1190(ra) # 5b24 <exit>
    exit(1);
    4686:	4505                	li	a0,1
    4688:	00001097          	auipc	ra,0x1
    468c:	49c080e7          	jalr	1180(ra) # 5b24 <exit>

0000000000004690 <mem>:
{
    4690:	7139                	addi	sp,sp,-64
    4692:	fc06                	sd	ra,56(sp)
    4694:	f822                	sd	s0,48(sp)
    4696:	f426                	sd	s1,40(sp)
    4698:	f04a                	sd	s2,32(sp)
    469a:	ec4e                	sd	s3,24(sp)
    469c:	0080                	addi	s0,sp,64
    469e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    46a0:	00001097          	auipc	ra,0x1
    46a4:	47c080e7          	jalr	1148(ra) # 5b1c <fork>
    m1 = 0;
    46a8:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    46aa:	6909                	lui	s2,0x2
    46ac:	71190913          	addi	s2,s2,1809 # 2711 <rwsbrk+0xff>
  if((pid = fork()) == 0){
    46b0:	c115                	beqz	a0,46d4 <mem+0x44>
    wait(&xstatus);
    46b2:	fcc40513          	addi	a0,s0,-52
    46b6:	00001097          	auipc	ra,0x1
    46ba:	476080e7          	jalr	1142(ra) # 5b2c <wait>
    if(xstatus == -1){
    46be:	fcc42503          	lw	a0,-52(s0)
    46c2:	57fd                	li	a5,-1
    46c4:	06f50363          	beq	a0,a5,472a <mem+0x9a>
    exit(xstatus);
    46c8:	00001097          	auipc	ra,0x1
    46cc:	45c080e7          	jalr	1116(ra) # 5b24 <exit>
      *(char**)m2 = m1;
    46d0:	e104                	sd	s1,0(a0)
      m1 = m2;
    46d2:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    46d4:	854a                	mv	a0,s2
    46d6:	00002097          	auipc	ra,0x2
    46da:	870080e7          	jalr	-1936(ra) # 5f46 <malloc>
    46de:	f96d                	bnez	a0,46d0 <mem+0x40>
    while(m1){
    46e0:	c881                	beqz	s1,46f0 <mem+0x60>
      m2 = *(char**)m1;
    46e2:	8526                	mv	a0,s1
    46e4:	6084                	ld	s1,0(s1)
      free(m1);
    46e6:	00001097          	auipc	ra,0x1
    46ea:	7da080e7          	jalr	2010(ra) # 5ec0 <free>
    while(m1){
    46ee:	f8f5                	bnez	s1,46e2 <mem+0x52>
    m1 = malloc(1024*20);
    46f0:	6515                	lui	a0,0x5
    46f2:	00002097          	auipc	ra,0x2
    46f6:	854080e7          	jalr	-1964(ra) # 5f46 <malloc>
    if(m1 == 0){
    46fa:	c911                	beqz	a0,470e <mem+0x7e>
    free(m1);
    46fc:	00001097          	auipc	ra,0x1
    4700:	7c4080e7          	jalr	1988(ra) # 5ec0 <free>
    exit(0);
    4704:	4501                	li	a0,0
    4706:	00001097          	auipc	ra,0x1
    470a:	41e080e7          	jalr	1054(ra) # 5b24 <exit>
      printf("couldn't allocate mem?!!\n", s);
    470e:	85ce                	mv	a1,s3
    4710:	00003517          	auipc	a0,0x3
    4714:	51050513          	addi	a0,a0,1296 # 7c20 <malloc+0x1cda>
    4718:	00001097          	auipc	ra,0x1
    471c:	772080e7          	jalr	1906(ra) # 5e8a <printf>
      exit(1);
    4720:	4505                	li	a0,1
    4722:	00001097          	auipc	ra,0x1
    4726:	402080e7          	jalr	1026(ra) # 5b24 <exit>
      exit(0);
    472a:	4501                	li	a0,0
    472c:	00001097          	auipc	ra,0x1
    4730:	3f8080e7          	jalr	1016(ra) # 5b24 <exit>

0000000000004734 <sharedfd>:
{
    4734:	7119                	addi	sp,sp,-128
    4736:	fc86                	sd	ra,120(sp)
    4738:	f8a2                	sd	s0,112(sp)
    473a:	e0da                	sd	s6,64(sp)
    473c:	0100                	addi	s0,sp,128
    473e:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    4740:	00003517          	auipc	a0,0x3
    4744:	50050513          	addi	a0,a0,1280 # 7c40 <malloc+0x1cfa>
    4748:	00001097          	auipc	ra,0x1
    474c:	42c080e7          	jalr	1068(ra) # 5b74 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4750:	20200593          	li	a1,514
    4754:	00003517          	auipc	a0,0x3
    4758:	4ec50513          	addi	a0,a0,1260 # 7c40 <malloc+0x1cfa>
    475c:	00001097          	auipc	ra,0x1
    4760:	408080e7          	jalr	1032(ra) # 5b64 <open>
  if(fd < 0){
    4764:	06054363          	bltz	a0,47ca <sharedfd+0x96>
    4768:	f4a6                	sd	s1,104(sp)
    476a:	f0ca                	sd	s2,96(sp)
    476c:	ecce                	sd	s3,88(sp)
    476e:	e8d2                	sd	s4,80(sp)
    4770:	e4d6                	sd	s5,72(sp)
    4772:	89aa                	mv	s3,a0
  pid = fork();
    4774:	00001097          	auipc	ra,0x1
    4778:	3a8080e7          	jalr	936(ra) # 5b1c <fork>
    477c:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    477e:	07000593          	li	a1,112
    4782:	e119                	bnez	a0,4788 <sharedfd+0x54>
    4784:	06300593          	li	a1,99
    4788:	4629                	li	a2,10
    478a:	f9040513          	addi	a0,s0,-112
    478e:	00001097          	auipc	ra,0x1
    4792:	174080e7          	jalr	372(ra) # 5902 <memset>
    4796:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    479a:	f9040a13          	addi	s4,s0,-112
    479e:	4929                	li	s2,10
    47a0:	864a                	mv	a2,s2
    47a2:	85d2                	mv	a1,s4
    47a4:	854e                	mv	a0,s3
    47a6:	00001097          	auipc	ra,0x1
    47aa:	39e080e7          	jalr	926(ra) # 5b44 <write>
    47ae:	05251463          	bne	a0,s2,47f6 <sharedfd+0xc2>
  for(i = 0; i < N; i++){
    47b2:	34fd                	addiw	s1,s1,-1
    47b4:	f4f5                	bnez	s1,47a0 <sharedfd+0x6c>
  if(pid == 0) {
    47b6:	060a9163          	bnez	s5,4818 <sharedfd+0xe4>
    47ba:	fc5e                	sd	s7,56(sp)
    47bc:	f862                	sd	s8,48(sp)
    47be:	f466                	sd	s9,40(sp)
    exit(0);
    47c0:	4501                	li	a0,0
    47c2:	00001097          	auipc	ra,0x1
    47c6:	362080e7          	jalr	866(ra) # 5b24 <exit>
    47ca:	f4a6                	sd	s1,104(sp)
    47cc:	f0ca                	sd	s2,96(sp)
    47ce:	ecce                	sd	s3,88(sp)
    47d0:	e8d2                	sd	s4,80(sp)
    47d2:	e4d6                	sd	s5,72(sp)
    47d4:	fc5e                	sd	s7,56(sp)
    47d6:	f862                	sd	s8,48(sp)
    47d8:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    47da:	85da                	mv	a1,s6
    47dc:	00003517          	auipc	a0,0x3
    47e0:	47450513          	addi	a0,a0,1140 # 7c50 <malloc+0x1d0a>
    47e4:	00001097          	auipc	ra,0x1
    47e8:	6a6080e7          	jalr	1702(ra) # 5e8a <printf>
    exit(1);
    47ec:	4505                	li	a0,1
    47ee:	00001097          	auipc	ra,0x1
    47f2:	336080e7          	jalr	822(ra) # 5b24 <exit>
    47f6:	fc5e                	sd	s7,56(sp)
    47f8:	f862                	sd	s8,48(sp)
    47fa:	f466                	sd	s9,40(sp)
      printf("%s: write sharedfd failed\n", s);
    47fc:	85da                	mv	a1,s6
    47fe:	00003517          	auipc	a0,0x3
    4802:	47a50513          	addi	a0,a0,1146 # 7c78 <malloc+0x1d32>
    4806:	00001097          	auipc	ra,0x1
    480a:	684080e7          	jalr	1668(ra) # 5e8a <printf>
      exit(1);
    480e:	4505                	li	a0,1
    4810:	00001097          	auipc	ra,0x1
    4814:	314080e7          	jalr	788(ra) # 5b24 <exit>
    wait(&xstatus);
    4818:	f8c40513          	addi	a0,s0,-116
    481c:	00001097          	auipc	ra,0x1
    4820:	310080e7          	jalr	784(ra) # 5b2c <wait>
    if(xstatus != 0)
    4824:	f8c42a03          	lw	s4,-116(s0)
    4828:	000a0a63          	beqz	s4,483c <sharedfd+0x108>
    482c:	fc5e                	sd	s7,56(sp)
    482e:	f862                	sd	s8,48(sp)
    4830:	f466                	sd	s9,40(sp)
      exit(xstatus);
    4832:	8552                	mv	a0,s4
    4834:	00001097          	auipc	ra,0x1
    4838:	2f0080e7          	jalr	752(ra) # 5b24 <exit>
    483c:	fc5e                	sd	s7,56(sp)
  close(fd);
    483e:	854e                	mv	a0,s3
    4840:	00001097          	auipc	ra,0x1
    4844:	30c080e7          	jalr	780(ra) # 5b4c <close>
  fd = open("sharedfd", 0);
    4848:	4581                	li	a1,0
    484a:	00003517          	auipc	a0,0x3
    484e:	3f650513          	addi	a0,a0,1014 # 7c40 <malloc+0x1cfa>
    4852:	00001097          	auipc	ra,0x1
    4856:	312080e7          	jalr	786(ra) # 5b64 <open>
    485a:	8baa                	mv	s7,a0
  nc = np = 0;
    485c:	89d2                	mv	s3,s4
  if(fd < 0){
    485e:	02054963          	bltz	a0,4890 <sharedfd+0x15c>
    4862:	f862                	sd	s8,48(sp)
    4864:	f466                	sd	s9,40(sp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4866:	f9040c93          	addi	s9,s0,-112
    486a:	4c29                	li	s8,10
    486c:	f9a40913          	addi	s2,s0,-102
      if(buf[i] == 'c')
    4870:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4874:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4878:	8662                	mv	a2,s8
    487a:	85e6                	mv	a1,s9
    487c:	855e                	mv	a0,s7
    487e:	00001097          	auipc	ra,0x1
    4882:	2be080e7          	jalr	702(ra) # 5b3c <read>
    4886:	04a05163          	blez	a0,48c8 <sharedfd+0x194>
    488a:	f9040793          	addi	a5,s0,-112
    488e:	a02d                	j	48b8 <sharedfd+0x184>
    4890:	f862                	sd	s8,48(sp)
    4892:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for reading\n", s);
    4894:	85da                	mv	a1,s6
    4896:	00003517          	auipc	a0,0x3
    489a:	40250513          	addi	a0,a0,1026 # 7c98 <malloc+0x1d52>
    489e:	00001097          	auipc	ra,0x1
    48a2:	5ec080e7          	jalr	1516(ra) # 5e8a <printf>
    exit(1);
    48a6:	4505                	li	a0,1
    48a8:	00001097          	auipc	ra,0x1
    48ac:	27c080e7          	jalr	636(ra) # 5b24 <exit>
        nc++;
    48b0:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    48b2:	0785                	addi	a5,a5,1
    48b4:	fd2782e3          	beq	a5,s2,4878 <sharedfd+0x144>
      if(buf[i] == 'c')
    48b8:	0007c703          	lbu	a4,0(a5)
    48bc:	fe970ae3          	beq	a4,s1,48b0 <sharedfd+0x17c>
      if(buf[i] == 'p')
    48c0:	ff5719e3          	bne	a4,s5,48b2 <sharedfd+0x17e>
        np++;
    48c4:	2985                	addiw	s3,s3,1
    48c6:	b7f5                	j	48b2 <sharedfd+0x17e>
  close(fd);
    48c8:	855e                	mv	a0,s7
    48ca:	00001097          	auipc	ra,0x1
    48ce:	282080e7          	jalr	642(ra) # 5b4c <close>
  unlink("sharedfd");
    48d2:	00003517          	auipc	a0,0x3
    48d6:	36e50513          	addi	a0,a0,878 # 7c40 <malloc+0x1cfa>
    48da:	00001097          	auipc	ra,0x1
    48de:	29a080e7          	jalr	666(ra) # 5b74 <unlink>
  if(nc == N*SZ && np == N*SZ){
    48e2:	6789                	lui	a5,0x2
    48e4:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0xfe>
    48e8:	00fa1763          	bne	s4,a5,48f6 <sharedfd+0x1c2>
    48ec:	6789                	lui	a5,0x2
    48ee:	71078793          	addi	a5,a5,1808 # 2710 <rwsbrk+0xfe>
    48f2:	02f98063          	beq	s3,a5,4912 <sharedfd+0x1de>
    printf("%s: nc/np test fails\n", s);
    48f6:	85da                	mv	a1,s6
    48f8:	00003517          	auipc	a0,0x3
    48fc:	3c850513          	addi	a0,a0,968 # 7cc0 <malloc+0x1d7a>
    4900:	00001097          	auipc	ra,0x1
    4904:	58a080e7          	jalr	1418(ra) # 5e8a <printf>
    exit(1);
    4908:	4505                	li	a0,1
    490a:	00001097          	auipc	ra,0x1
    490e:	21a080e7          	jalr	538(ra) # 5b24 <exit>
    exit(0);
    4912:	4501                	li	a0,0
    4914:	00001097          	auipc	ra,0x1
    4918:	210080e7          	jalr	528(ra) # 5b24 <exit>

000000000000491c <fourfiles>:
{
    491c:	7135                	addi	sp,sp,-160
    491e:	ed06                	sd	ra,152(sp)
    4920:	e922                	sd	s0,144(sp)
    4922:	e526                	sd	s1,136(sp)
    4924:	e14a                	sd	s2,128(sp)
    4926:	fcce                	sd	s3,120(sp)
    4928:	f8d2                	sd	s4,112(sp)
    492a:	f4d6                	sd	s5,104(sp)
    492c:	f0da                	sd	s6,96(sp)
    492e:	ecde                	sd	s7,88(sp)
    4930:	e8e2                	sd	s8,80(sp)
    4932:	e4e6                	sd	s9,72(sp)
    4934:	e0ea                	sd	s10,64(sp)
    4936:	fc6e                	sd	s11,56(sp)
    4938:	1100                	addi	s0,sp,160
    493a:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    493c:	00003797          	auipc	a5,0x3
    4940:	39c78793          	addi	a5,a5,924 # 7cd8 <malloc+0x1d92>
    4944:	f6f43823          	sd	a5,-144(s0)
    4948:	00003797          	auipc	a5,0x3
    494c:	39878793          	addi	a5,a5,920 # 7ce0 <malloc+0x1d9a>
    4950:	f6f43c23          	sd	a5,-136(s0)
    4954:	00003797          	auipc	a5,0x3
    4958:	39478793          	addi	a5,a5,916 # 7ce8 <malloc+0x1da2>
    495c:	f8f43023          	sd	a5,-128(s0)
    4960:	00003797          	auipc	a5,0x3
    4964:	39078793          	addi	a5,a5,912 # 7cf0 <malloc+0x1daa>
    4968:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    496c:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4970:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4972:	4481                	li	s1,0
    4974:	4a11                	li	s4,4
    fname = names[pi];
    4976:	00093983          	ld	s3,0(s2)
    unlink(fname);
    497a:	854e                	mv	a0,s3
    497c:	00001097          	auipc	ra,0x1
    4980:	1f8080e7          	jalr	504(ra) # 5b74 <unlink>
    pid = fork();
    4984:	00001097          	auipc	ra,0x1
    4988:	198080e7          	jalr	408(ra) # 5b1c <fork>
    if(pid < 0){
    498c:	04054263          	bltz	a0,49d0 <fourfiles+0xb4>
    if(pid == 0){
    4990:	cd31                	beqz	a0,49ec <fourfiles+0xd0>
  for(pi = 0; pi < NCHILD; pi++){
    4992:	2485                	addiw	s1,s1,1
    4994:	0921                	addi	s2,s2,8
    4996:	ff4490e3          	bne	s1,s4,4976 <fourfiles+0x5a>
    499a:	4491                	li	s1,4
    wait(&xstatus);
    499c:	f6c40913          	addi	s2,s0,-148
    49a0:	854a                	mv	a0,s2
    49a2:	00001097          	auipc	ra,0x1
    49a6:	18a080e7          	jalr	394(ra) # 5b2c <wait>
    if(xstatus != 0)
    49aa:	f6c42b03          	lw	s6,-148(s0)
    49ae:	0c0b1863          	bnez	s6,4a7e <fourfiles+0x162>
  for(pi = 0; pi < NCHILD; pi++){
    49b2:	34fd                	addiw	s1,s1,-1
    49b4:	f4f5                	bnez	s1,49a0 <fourfiles+0x84>
    49b6:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    49ba:	6a8d                	lui	s5,0x3
    49bc:	00007a17          	auipc	s4,0x7
    49c0:	6f4a0a13          	addi	s4,s4,1780 # c0b0 <buf>
    if(total != N*SZ){
    49c4:	6d05                	lui	s10,0x1
    49c6:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x186>
  for(i = 0; i < NCHILD; i++){
    49ca:	03400d93          	li	s11,52
    49ce:	a8dd                	j	4ac4 <fourfiles+0x1a8>
      printf("fork failed\n", s);
    49d0:	85e6                	mv	a1,s9
    49d2:	00002517          	auipc	a0,0x2
    49d6:	31e50513          	addi	a0,a0,798 # 6cf0 <malloc+0xdaa>
    49da:	00001097          	auipc	ra,0x1
    49de:	4b0080e7          	jalr	1200(ra) # 5e8a <printf>
      exit(1);
    49e2:	4505                	li	a0,1
    49e4:	00001097          	auipc	ra,0x1
    49e8:	140080e7          	jalr	320(ra) # 5b24 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    49ec:	20200593          	li	a1,514
    49f0:	854e                	mv	a0,s3
    49f2:	00001097          	auipc	ra,0x1
    49f6:	172080e7          	jalr	370(ra) # 5b64 <open>
    49fa:	892a                	mv	s2,a0
      if(fd < 0){
    49fc:	04054663          	bltz	a0,4a48 <fourfiles+0x12c>
      memset(buf, '0'+pi, SZ);
    4a00:	1f400613          	li	a2,500
    4a04:	0304859b          	addiw	a1,s1,48
    4a08:	00007517          	auipc	a0,0x7
    4a0c:	6a850513          	addi	a0,a0,1704 # c0b0 <buf>
    4a10:	00001097          	auipc	ra,0x1
    4a14:	ef2080e7          	jalr	-270(ra) # 5902 <memset>
    4a18:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4a1a:	1f400993          	li	s3,500
    4a1e:	00007a17          	auipc	s4,0x7
    4a22:	692a0a13          	addi	s4,s4,1682 # c0b0 <buf>
    4a26:	864e                	mv	a2,s3
    4a28:	85d2                	mv	a1,s4
    4a2a:	854a                	mv	a0,s2
    4a2c:	00001097          	auipc	ra,0x1
    4a30:	118080e7          	jalr	280(ra) # 5b44 <write>
    4a34:	85aa                	mv	a1,a0
    4a36:	03351763          	bne	a0,s3,4a64 <fourfiles+0x148>
      for(i = 0; i < N; i++){
    4a3a:	34fd                	addiw	s1,s1,-1
    4a3c:	f4ed                	bnez	s1,4a26 <fourfiles+0x10a>
      exit(0);
    4a3e:	4501                	li	a0,0
    4a40:	00001097          	auipc	ra,0x1
    4a44:	0e4080e7          	jalr	228(ra) # 5b24 <exit>
        printf("create failed\n", s);
    4a48:	85e6                	mv	a1,s9
    4a4a:	00003517          	auipc	a0,0x3
    4a4e:	2ae50513          	addi	a0,a0,686 # 7cf8 <malloc+0x1db2>
    4a52:	00001097          	auipc	ra,0x1
    4a56:	438080e7          	jalr	1080(ra) # 5e8a <printf>
        exit(1);
    4a5a:	4505                	li	a0,1
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	0c8080e7          	jalr	200(ra) # 5b24 <exit>
          printf("write failed %d\n", n);
    4a64:	00003517          	auipc	a0,0x3
    4a68:	2a450513          	addi	a0,a0,676 # 7d08 <malloc+0x1dc2>
    4a6c:	00001097          	auipc	ra,0x1
    4a70:	41e080e7          	jalr	1054(ra) # 5e8a <printf>
          exit(1);
    4a74:	4505                	li	a0,1
    4a76:	00001097          	auipc	ra,0x1
    4a7a:	0ae080e7          	jalr	174(ra) # 5b24 <exit>
      exit(xstatus);
    4a7e:	855a                	mv	a0,s6
    4a80:	00001097          	auipc	ra,0x1
    4a84:	0a4080e7          	jalr	164(ra) # 5b24 <exit>
          printf("wrong char\n", s);
    4a88:	85e6                	mv	a1,s9
    4a8a:	00003517          	auipc	a0,0x3
    4a8e:	29650513          	addi	a0,a0,662 # 7d20 <malloc+0x1dda>
    4a92:	00001097          	auipc	ra,0x1
    4a96:	3f8080e7          	jalr	1016(ra) # 5e8a <printf>
          exit(1);
    4a9a:	4505                	li	a0,1
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	088080e7          	jalr	136(ra) # 5b24 <exit>
    close(fd);
    4aa4:	854e                	mv	a0,s3
    4aa6:	00001097          	auipc	ra,0x1
    4aaa:	0a6080e7          	jalr	166(ra) # 5b4c <close>
    if(total != N*SZ){
    4aae:	05a91e63          	bne	s2,s10,4b0a <fourfiles+0x1ee>
    unlink(fname);
    4ab2:	8562                	mv	a0,s8
    4ab4:	00001097          	auipc	ra,0x1
    4ab8:	0c0080e7          	jalr	192(ra) # 5b74 <unlink>
  for(i = 0; i < NCHILD; i++){
    4abc:	0ba1                	addi	s7,s7,8
    4abe:	2485                	addiw	s1,s1,1
    4ac0:	07b48363          	beq	s1,s11,4b26 <fourfiles+0x20a>
    fname = names[i];
    4ac4:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4ac8:	4581                	li	a1,0
    4aca:	8562                	mv	a0,s8
    4acc:	00001097          	auipc	ra,0x1
    4ad0:	098080e7          	jalr	152(ra) # 5b64 <open>
    4ad4:	89aa                	mv	s3,a0
    total = 0;
    4ad6:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4ad8:	8656                	mv	a2,s5
    4ada:	85d2                	mv	a1,s4
    4adc:	854e                	mv	a0,s3
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	05e080e7          	jalr	94(ra) # 5b3c <read>
    4ae6:	faa05fe3          	blez	a0,4aa4 <fourfiles+0x188>
    4aea:	00007797          	auipc	a5,0x7
    4aee:	5c678793          	addi	a5,a5,1478 # c0b0 <buf>
    4af2:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4af6:	0007c703          	lbu	a4,0(a5)
    4afa:	f89717e3          	bne	a4,s1,4a88 <fourfiles+0x16c>
      for(j = 0; j < n; j++){
    4afe:	0785                	addi	a5,a5,1
    4b00:	fed79be3          	bne	a5,a3,4af6 <fourfiles+0x1da>
      total += n;
    4b04:	00a9093b          	addw	s2,s2,a0
    4b08:	bfc1                	j	4ad8 <fourfiles+0x1bc>
      printf("wrong length %d\n", total);
    4b0a:	85ca                	mv	a1,s2
    4b0c:	00003517          	auipc	a0,0x3
    4b10:	22450513          	addi	a0,a0,548 # 7d30 <malloc+0x1dea>
    4b14:	00001097          	auipc	ra,0x1
    4b18:	376080e7          	jalr	886(ra) # 5e8a <printf>
      exit(1);
    4b1c:	4505                	li	a0,1
    4b1e:	00001097          	auipc	ra,0x1
    4b22:	006080e7          	jalr	6(ra) # 5b24 <exit>
}
    4b26:	60ea                	ld	ra,152(sp)
    4b28:	644a                	ld	s0,144(sp)
    4b2a:	64aa                	ld	s1,136(sp)
    4b2c:	690a                	ld	s2,128(sp)
    4b2e:	79e6                	ld	s3,120(sp)
    4b30:	7a46                	ld	s4,112(sp)
    4b32:	7aa6                	ld	s5,104(sp)
    4b34:	7b06                	ld	s6,96(sp)
    4b36:	6be6                	ld	s7,88(sp)
    4b38:	6c46                	ld	s8,80(sp)
    4b3a:	6ca6                	ld	s9,72(sp)
    4b3c:	6d06                	ld	s10,64(sp)
    4b3e:	7de2                	ld	s11,56(sp)
    4b40:	610d                	addi	sp,sp,160
    4b42:	8082                	ret

0000000000004b44 <concreate>:
{
    4b44:	7171                	addi	sp,sp,-176
    4b46:	f506                	sd	ra,168(sp)
    4b48:	f122                	sd	s0,160(sp)
    4b4a:	ed26                	sd	s1,152(sp)
    4b4c:	e94a                	sd	s2,144(sp)
    4b4e:	e54e                	sd	s3,136(sp)
    4b50:	e152                	sd	s4,128(sp)
    4b52:	fcd6                	sd	s5,120(sp)
    4b54:	f8da                	sd	s6,112(sp)
    4b56:	f4de                	sd	s7,104(sp)
    4b58:	f0e2                	sd	s8,96(sp)
    4b5a:	ece6                	sd	s9,88(sp)
    4b5c:	e8ea                	sd	s10,80(sp)
    4b5e:	1900                	addi	s0,sp,176
    4b60:	8baa                	mv	s7,a0
  file[0] = 'C';
    4b62:	04300793          	li	a5,67
    4b66:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    4b6a:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    4b6e:	4901                	li	s2,0
    unlink(file);
    4b70:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    4b74:	55555b37          	lui	s6,0x55555
    4b78:	556b0b13          	addi	s6,s6,1366 # 55555556 <__BSS_END__+0x55546496>
    4b7c:	4c05                	li	s8,1
      fd = open(file, O_CREATE | O_RDWR);
    4b7e:	20200c93          	li	s9,514
      link("C0", file);
    4b82:	00003d17          	auipc	s10,0x3
    4b86:	1c6d0d13          	addi	s10,s10,454 # 7d48 <malloc+0x1e02>
      wait(&xstatus);
    4b8a:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    4b8e:	02800a13          	li	s4,40
    4b92:	a4dd                	j	4e78 <concreate+0x334>
      link("C0", file);
    4b94:	85ce                	mv	a1,s3
    4b96:	856a                	mv	a0,s10
    4b98:	00001097          	auipc	ra,0x1
    4b9c:	fec080e7          	jalr	-20(ra) # 5b84 <link>
    if(pid == 0) {
    4ba0:	a4c1                	j	4e60 <concreate+0x31c>
    } else if(pid == 0 && (i % 5) == 1){
    4ba2:	666667b7          	lui	a5,0x66666
    4ba6:	66778793          	addi	a5,a5,1639 # 66666667 <__BSS_END__+0x666575a7>
    4baa:	02f907b3          	mul	a5,s2,a5
    4bae:	9785                	srai	a5,a5,0x21
    4bb0:	41f9571b          	sraiw	a4,s2,0x1f
    4bb4:	9f99                	subw	a5,a5,a4
    4bb6:	0027971b          	slliw	a4,a5,0x2
    4bba:	9fb9                	addw	a5,a5,a4
    4bbc:	40f9093b          	subw	s2,s2,a5
    4bc0:	4785                	li	a5,1
    4bc2:	02f90b63          	beq	s2,a5,4bf8 <concreate+0xb4>
      fd = open(file, O_CREATE | O_RDWR);
    4bc6:	20200593          	li	a1,514
    4bca:	f9840513          	addi	a0,s0,-104
    4bce:	00001097          	auipc	ra,0x1
    4bd2:	f96080e7          	jalr	-106(ra) # 5b64 <open>
      if(fd < 0){
    4bd6:	26055c63          	bgez	a0,4e4e <concreate+0x30a>
        printf("concreate create %s failed\n", file);
    4bda:	f9840593          	addi	a1,s0,-104
    4bde:	00003517          	auipc	a0,0x3
    4be2:	17250513          	addi	a0,a0,370 # 7d50 <malloc+0x1e0a>
    4be6:	00001097          	auipc	ra,0x1
    4bea:	2a4080e7          	jalr	676(ra) # 5e8a <printf>
        exit(1);
    4bee:	4505                	li	a0,1
    4bf0:	00001097          	auipc	ra,0x1
    4bf4:	f34080e7          	jalr	-204(ra) # 5b24 <exit>
      link("C0", file);
    4bf8:	f9840593          	addi	a1,s0,-104
    4bfc:	00003517          	auipc	a0,0x3
    4c00:	14c50513          	addi	a0,a0,332 # 7d48 <malloc+0x1e02>
    4c04:	00001097          	auipc	ra,0x1
    4c08:	f80080e7          	jalr	-128(ra) # 5b84 <link>
      exit(0);
    4c0c:	4501                	li	a0,0
    4c0e:	00001097          	auipc	ra,0x1
    4c12:	f16080e7          	jalr	-234(ra) # 5b24 <exit>
        exit(1);
    4c16:	4505                	li	a0,1
    4c18:	00001097          	auipc	ra,0x1
    4c1c:	f0c080e7          	jalr	-244(ra) # 5b24 <exit>
  memset(fa, 0, sizeof(fa));
    4c20:	02800613          	li	a2,40
    4c24:	4581                	li	a1,0
    4c26:	f7040513          	addi	a0,s0,-144
    4c2a:	00001097          	auipc	ra,0x1
    4c2e:	cd8080e7          	jalr	-808(ra) # 5902 <memset>
  fd = open(".", 0);
    4c32:	4581                	li	a1,0
    4c34:	00002517          	auipc	a0,0x2
    4c38:	afc50513          	addi	a0,a0,-1284 # 6730 <malloc+0x7ea>
    4c3c:	00001097          	auipc	ra,0x1
    4c40:	f28080e7          	jalr	-216(ra) # 5b64 <open>
    4c44:	892a                	mv	s2,a0
  n = 0;
    4c46:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    4c48:	f6040a13          	addi	s4,s0,-160
    4c4c:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4c4e:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    4c52:	02700c13          	li	s8,39
      fa[i] = 1;
    4c56:	4c85                	li	s9,1
  while(read(fd, &de, sizeof(de)) > 0){
    4c58:	864e                	mv	a2,s3
    4c5a:	85d2                	mv	a1,s4
    4c5c:	854a                	mv	a0,s2
    4c5e:	00001097          	auipc	ra,0x1
    4c62:	ede080e7          	jalr	-290(ra) # 5b3c <read>
    4c66:	06a05f63          	blez	a0,4ce4 <concreate+0x1a0>
    if(de.inum == 0)
    4c6a:	f6045783          	lhu	a5,-160(s0)
    4c6e:	d7ed                	beqz	a5,4c58 <concreate+0x114>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4c70:	f6244783          	lbu	a5,-158(s0)
    4c74:	ff5792e3          	bne	a5,s5,4c58 <concreate+0x114>
    4c78:	f6444783          	lbu	a5,-156(s0)
    4c7c:	fff1                	bnez	a5,4c58 <concreate+0x114>
      i = de.name[1] - '0';
    4c7e:	f6344783          	lbu	a5,-157(s0)
    4c82:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    4c86:	00fc6f63          	bltu	s8,a5,4ca4 <concreate+0x160>
      if(fa[i]){
    4c8a:	fa078713          	addi	a4,a5,-96
    4c8e:	9722                	add	a4,a4,s0
    4c90:	fd074703          	lbu	a4,-48(a4) # fd0 <bigdir+0x34>
    4c94:	eb05                	bnez	a4,4cc4 <concreate+0x180>
      fa[i] = 1;
    4c96:	fa078793          	addi	a5,a5,-96
    4c9a:	97a2                	add	a5,a5,s0
    4c9c:	fd978823          	sb	s9,-48(a5)
      n++;
    4ca0:	2b05                	addiw	s6,s6,1
    4ca2:	bf5d                	j	4c58 <concreate+0x114>
        printf("%s: concreate weird file %s\n", s, de.name);
    4ca4:	f6240613          	addi	a2,s0,-158
    4ca8:	85de                	mv	a1,s7
    4caa:	00003517          	auipc	a0,0x3
    4cae:	0c650513          	addi	a0,a0,198 # 7d70 <malloc+0x1e2a>
    4cb2:	00001097          	auipc	ra,0x1
    4cb6:	1d8080e7          	jalr	472(ra) # 5e8a <printf>
        exit(1);
    4cba:	4505                	li	a0,1
    4cbc:	00001097          	auipc	ra,0x1
    4cc0:	e68080e7          	jalr	-408(ra) # 5b24 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4cc4:	f6240613          	addi	a2,s0,-158
    4cc8:	85de                	mv	a1,s7
    4cca:	00003517          	auipc	a0,0x3
    4cce:	0c650513          	addi	a0,a0,198 # 7d90 <malloc+0x1e4a>
    4cd2:	00001097          	auipc	ra,0x1
    4cd6:	1b8080e7          	jalr	440(ra) # 5e8a <printf>
        exit(1);
    4cda:	4505                	li	a0,1
    4cdc:	00001097          	auipc	ra,0x1
    4ce0:	e48080e7          	jalr	-440(ra) # 5b24 <exit>
  close(fd);
    4ce4:	854a                	mv	a0,s2
    4ce6:	00001097          	auipc	ra,0x1
    4cea:	e66080e7          	jalr	-410(ra) # 5b4c <close>
  if(n != N){
    4cee:	02800793          	li	a5,40
    4cf2:	00fb1b63          	bne	s6,a5,4d08 <concreate+0x1c4>
    if(((i % 3) == 0 && pid == 0) ||
    4cf6:	55555a37          	lui	s4,0x55555
    4cfa:	556a0a13          	addi	s4,s4,1366 # 55555556 <__BSS_END__+0x55546496>
      close(open(file, 0));
    4cfe:	f9840993          	addi	s3,s0,-104
    if(((i % 3) == 0 && pid == 0) ||
    4d02:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4d04:	8abe                	mv	s5,a5
    4d06:	a0d9                	j	4dcc <concreate+0x288>
    printf("%s: concreate not enough files in directory listing\n", s);
    4d08:	85de                	mv	a1,s7
    4d0a:	00003517          	auipc	a0,0x3
    4d0e:	0ae50513          	addi	a0,a0,174 # 7db8 <malloc+0x1e72>
    4d12:	00001097          	auipc	ra,0x1
    4d16:	178080e7          	jalr	376(ra) # 5e8a <printf>
    exit(1);
    4d1a:	4505                	li	a0,1
    4d1c:	00001097          	auipc	ra,0x1
    4d20:	e08080e7          	jalr	-504(ra) # 5b24 <exit>
      printf("%s: fork failed\n", s);
    4d24:	85de                	mv	a1,s7
    4d26:	00002517          	auipc	a0,0x2
    4d2a:	baa50513          	addi	a0,a0,-1110 # 68d0 <malloc+0x98a>
    4d2e:	00001097          	auipc	ra,0x1
    4d32:	15c080e7          	jalr	348(ra) # 5e8a <printf>
      exit(1);
    4d36:	4505                	li	a0,1
    4d38:	00001097          	auipc	ra,0x1
    4d3c:	dec080e7          	jalr	-532(ra) # 5b24 <exit>
      close(open(file, 0));
    4d40:	4581                	li	a1,0
    4d42:	854e                	mv	a0,s3
    4d44:	00001097          	auipc	ra,0x1
    4d48:	e20080e7          	jalr	-480(ra) # 5b64 <open>
    4d4c:	00001097          	auipc	ra,0x1
    4d50:	e00080e7          	jalr	-512(ra) # 5b4c <close>
      close(open(file, 0));
    4d54:	4581                	li	a1,0
    4d56:	854e                	mv	a0,s3
    4d58:	00001097          	auipc	ra,0x1
    4d5c:	e0c080e7          	jalr	-500(ra) # 5b64 <open>
    4d60:	00001097          	auipc	ra,0x1
    4d64:	dec080e7          	jalr	-532(ra) # 5b4c <close>
      close(open(file, 0));
    4d68:	4581                	li	a1,0
    4d6a:	854e                	mv	a0,s3
    4d6c:	00001097          	auipc	ra,0x1
    4d70:	df8080e7          	jalr	-520(ra) # 5b64 <open>
    4d74:	00001097          	auipc	ra,0x1
    4d78:	dd8080e7          	jalr	-552(ra) # 5b4c <close>
      close(open(file, 0));
    4d7c:	4581                	li	a1,0
    4d7e:	854e                	mv	a0,s3
    4d80:	00001097          	auipc	ra,0x1
    4d84:	de4080e7          	jalr	-540(ra) # 5b64 <open>
    4d88:	00001097          	auipc	ra,0x1
    4d8c:	dc4080e7          	jalr	-572(ra) # 5b4c <close>
      close(open(file, 0));
    4d90:	4581                	li	a1,0
    4d92:	854e                	mv	a0,s3
    4d94:	00001097          	auipc	ra,0x1
    4d98:	dd0080e7          	jalr	-560(ra) # 5b64 <open>
    4d9c:	00001097          	auipc	ra,0x1
    4da0:	db0080e7          	jalr	-592(ra) # 5b4c <close>
      close(open(file, 0));
    4da4:	4581                	li	a1,0
    4da6:	854e                	mv	a0,s3
    4da8:	00001097          	auipc	ra,0x1
    4dac:	dbc080e7          	jalr	-580(ra) # 5b64 <open>
    4db0:	00001097          	auipc	ra,0x1
    4db4:	d9c080e7          	jalr	-612(ra) # 5b4c <close>
    if(pid == 0)
    4db8:	08090663          	beqz	s2,4e44 <concreate+0x300>
      wait(0);
    4dbc:	4501                	li	a0,0
    4dbe:	00001097          	auipc	ra,0x1
    4dc2:	d6e080e7          	jalr	-658(ra) # 5b2c <wait>
  for(i = 0; i < N; i++){
    4dc6:	2485                	addiw	s1,s1,1
    4dc8:	0f548d63          	beq	s1,s5,4ec2 <concreate+0x37e>
    file[1] = '0' + i;
    4dcc:	0304879b          	addiw	a5,s1,48
    4dd0:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    4dd4:	00001097          	auipc	ra,0x1
    4dd8:	d48080e7          	jalr	-696(ra) # 5b1c <fork>
    4ddc:	892a                	mv	s2,a0
    if(pid < 0){
    4dde:	f40543e3          	bltz	a0,4d24 <concreate+0x1e0>
    if(((i % 3) == 0 && pid == 0) ||
    4de2:	03448733          	mul	a4,s1,s4
    4de6:	9301                	srli	a4,a4,0x20
    4de8:	41f4d79b          	sraiw	a5,s1,0x1f
    4dec:	9f1d                	subw	a4,a4,a5
    4dee:	0017179b          	slliw	a5,a4,0x1
    4df2:	9fb9                	addw	a5,a5,a4
    4df4:	40f487bb          	subw	a5,s1,a5
    4df8:	873e                	mv	a4,a5
    4dfa:	8fc9                	or	a5,a5,a0
    4dfc:	2781                	sext.w	a5,a5
    4dfe:	d3a9                	beqz	a5,4d40 <concreate+0x1fc>
    4e00:	01671363          	bne	a4,s6,4e06 <concreate+0x2c2>
       ((i % 3) == 1 && pid != 0)){
    4e04:	fd15                	bnez	a0,4d40 <concreate+0x1fc>
      unlink(file);
    4e06:	854e                	mv	a0,s3
    4e08:	00001097          	auipc	ra,0x1
    4e0c:	d6c080e7          	jalr	-660(ra) # 5b74 <unlink>
      unlink(file);
    4e10:	854e                	mv	a0,s3
    4e12:	00001097          	auipc	ra,0x1
    4e16:	d62080e7          	jalr	-670(ra) # 5b74 <unlink>
      unlink(file);
    4e1a:	854e                	mv	a0,s3
    4e1c:	00001097          	auipc	ra,0x1
    4e20:	d58080e7          	jalr	-680(ra) # 5b74 <unlink>
      unlink(file);
    4e24:	854e                	mv	a0,s3
    4e26:	00001097          	auipc	ra,0x1
    4e2a:	d4e080e7          	jalr	-690(ra) # 5b74 <unlink>
      unlink(file);
    4e2e:	854e                	mv	a0,s3
    4e30:	00001097          	auipc	ra,0x1
    4e34:	d44080e7          	jalr	-700(ra) # 5b74 <unlink>
      unlink(file);
    4e38:	854e                	mv	a0,s3
    4e3a:	00001097          	auipc	ra,0x1
    4e3e:	d3a080e7          	jalr	-710(ra) # 5b74 <unlink>
    4e42:	bf9d                	j	4db8 <concreate+0x274>
      exit(0);
    4e44:	4501                	li	a0,0
    4e46:	00001097          	auipc	ra,0x1
    4e4a:	cde080e7          	jalr	-802(ra) # 5b24 <exit>
      close(fd);
    4e4e:	00001097          	auipc	ra,0x1
    4e52:	cfe080e7          	jalr	-770(ra) # 5b4c <close>
    if(pid == 0) {
    4e56:	bb5d                	j	4c0c <concreate+0xc8>
      close(fd);
    4e58:	00001097          	auipc	ra,0x1
    4e5c:	cf4080e7          	jalr	-780(ra) # 5b4c <close>
      wait(&xstatus);
    4e60:	8556                	mv	a0,s5
    4e62:	00001097          	auipc	ra,0x1
    4e66:	cca080e7          	jalr	-822(ra) # 5b2c <wait>
      if(xstatus != 0)
    4e6a:	f5c42483          	lw	s1,-164(s0)
    4e6e:	da0494e3          	bnez	s1,4c16 <concreate+0xd2>
  for(i = 0; i < N; i++){
    4e72:	2905                	addiw	s2,s2,1
    4e74:	db4906e3          	beq	s2,s4,4c20 <concreate+0xdc>
    file[1] = '0' + i;
    4e78:	0309079b          	addiw	a5,s2,48
    4e7c:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4e80:	854e                	mv	a0,s3
    4e82:	00001097          	auipc	ra,0x1
    4e86:	cf2080e7          	jalr	-782(ra) # 5b74 <unlink>
    pid = fork();
    4e8a:	00001097          	auipc	ra,0x1
    4e8e:	c92080e7          	jalr	-878(ra) # 5b1c <fork>
    if(pid && (i % 3) == 1){
    4e92:	d00508e3          	beqz	a0,4ba2 <concreate+0x5e>
    4e96:	036907b3          	mul	a5,s2,s6
    4e9a:	9381                	srli	a5,a5,0x20
    4e9c:	41f9571b          	sraiw	a4,s2,0x1f
    4ea0:	9f99                	subw	a5,a5,a4
    4ea2:	0017971b          	slliw	a4,a5,0x1
    4ea6:	9fb9                	addw	a5,a5,a4
    4ea8:	40f907bb          	subw	a5,s2,a5
    4eac:	cf8784e3          	beq	a5,s8,4b94 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    4eb0:	85e6                	mv	a1,s9
    4eb2:	854e                	mv	a0,s3
    4eb4:	00001097          	auipc	ra,0x1
    4eb8:	cb0080e7          	jalr	-848(ra) # 5b64 <open>
      if(fd < 0){
    4ebc:	f8055ee3          	bgez	a0,4e58 <concreate+0x314>
    4ec0:	bb29                	j	4bda <concreate+0x96>
}
    4ec2:	70aa                	ld	ra,168(sp)
    4ec4:	740a                	ld	s0,160(sp)
    4ec6:	64ea                	ld	s1,152(sp)
    4ec8:	694a                	ld	s2,144(sp)
    4eca:	69aa                	ld	s3,136(sp)
    4ecc:	6a0a                	ld	s4,128(sp)
    4ece:	7ae6                	ld	s5,120(sp)
    4ed0:	7b46                	ld	s6,112(sp)
    4ed2:	7ba6                	ld	s7,104(sp)
    4ed4:	7c06                	ld	s8,96(sp)
    4ed6:	6ce6                	ld	s9,88(sp)
    4ed8:	6d46                	ld	s10,80(sp)
    4eda:	614d                	addi	sp,sp,176
    4edc:	8082                	ret

0000000000004ede <bigfile>:
{
    4ede:	7139                	addi	sp,sp,-64
    4ee0:	fc06                	sd	ra,56(sp)
    4ee2:	f822                	sd	s0,48(sp)
    4ee4:	f426                	sd	s1,40(sp)
    4ee6:	f04a                	sd	s2,32(sp)
    4ee8:	ec4e                	sd	s3,24(sp)
    4eea:	e852                	sd	s4,16(sp)
    4eec:	e456                	sd	s5,8(sp)
    4eee:	e05a                	sd	s6,0(sp)
    4ef0:	0080                	addi	s0,sp,64
    4ef2:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    4ef4:	00003517          	auipc	a0,0x3
    4ef8:	efc50513          	addi	a0,a0,-260 # 7df0 <malloc+0x1eaa>
    4efc:	00001097          	auipc	ra,0x1
    4f00:	c78080e7          	jalr	-904(ra) # 5b74 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4f04:	20200593          	li	a1,514
    4f08:	00003517          	auipc	a0,0x3
    4f0c:	ee850513          	addi	a0,a0,-280 # 7df0 <malloc+0x1eaa>
    4f10:	00001097          	auipc	ra,0x1
    4f14:	c54080e7          	jalr	-940(ra) # 5b64 <open>
  if(fd < 0){
    4f18:	0a054463          	bltz	a0,4fc0 <bigfile+0xe2>
    4f1c:	8a2a                	mv	s4,a0
    4f1e:	4481                	li	s1,0
    memset(buf, i, SZ);
    4f20:	25800913          	li	s2,600
    4f24:	00007997          	auipc	s3,0x7
    4f28:	18c98993          	addi	s3,s3,396 # c0b0 <buf>
  for(i = 0; i < N; i++){
    4f2c:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    4f2e:	864a                	mv	a2,s2
    4f30:	85a6                	mv	a1,s1
    4f32:	854e                	mv	a0,s3
    4f34:	00001097          	auipc	ra,0x1
    4f38:	9ce080e7          	jalr	-1586(ra) # 5902 <memset>
    if(write(fd, buf, SZ) != SZ){
    4f3c:	864a                	mv	a2,s2
    4f3e:	85ce                	mv	a1,s3
    4f40:	8552                	mv	a0,s4
    4f42:	00001097          	auipc	ra,0x1
    4f46:	c02080e7          	jalr	-1022(ra) # 5b44 <write>
    4f4a:	09251963          	bne	a0,s2,4fdc <bigfile+0xfe>
  for(i = 0; i < N; i++){
    4f4e:	2485                	addiw	s1,s1,1
    4f50:	fd549fe3          	bne	s1,s5,4f2e <bigfile+0x50>
  close(fd);
    4f54:	8552                	mv	a0,s4
    4f56:	00001097          	auipc	ra,0x1
    4f5a:	bf6080e7          	jalr	-1034(ra) # 5b4c <close>
  fd = open("bigfile.dat", 0);
    4f5e:	4581                	li	a1,0
    4f60:	00003517          	auipc	a0,0x3
    4f64:	e9050513          	addi	a0,a0,-368 # 7df0 <malloc+0x1eaa>
    4f68:	00001097          	auipc	ra,0x1
    4f6c:	bfc080e7          	jalr	-1028(ra) # 5b64 <open>
    4f70:	8aaa                	mv	s5,a0
  total = 0;
    4f72:	4a01                	li	s4,0
  for(i = 0; ; i++){
    4f74:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4f76:	12c00993          	li	s3,300
    4f7a:	00007917          	auipc	s2,0x7
    4f7e:	13690913          	addi	s2,s2,310 # c0b0 <buf>
  if(fd < 0){
    4f82:	06054b63          	bltz	a0,4ff8 <bigfile+0x11a>
    cc = read(fd, buf, SZ/2);
    4f86:	864e                	mv	a2,s3
    4f88:	85ca                	mv	a1,s2
    4f8a:	8556                	mv	a0,s5
    4f8c:	00001097          	auipc	ra,0x1
    4f90:	bb0080e7          	jalr	-1104(ra) # 5b3c <read>
    if(cc < 0){
    4f94:	08054063          	bltz	a0,5014 <bigfile+0x136>
    if(cc == 0)
    4f98:	c961                	beqz	a0,5068 <bigfile+0x18a>
    if(cc != SZ/2){
    4f9a:	09351b63          	bne	a0,s3,5030 <bigfile+0x152>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4f9e:	01f4d79b          	srliw	a5,s1,0x1f
    4fa2:	9fa5                	addw	a5,a5,s1
    4fa4:	4017d79b          	sraiw	a5,a5,0x1
    4fa8:	00094703          	lbu	a4,0(s2)
    4fac:	0af71063          	bne	a4,a5,504c <bigfile+0x16e>
    4fb0:	12b94703          	lbu	a4,299(s2)
    4fb4:	08f71c63          	bne	a4,a5,504c <bigfile+0x16e>
    total += cc;
    4fb8:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    4fbc:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4fbe:	b7e1                	j	4f86 <bigfile+0xa8>
    printf("%s: cannot create bigfile", s);
    4fc0:	85da                	mv	a1,s6
    4fc2:	00003517          	auipc	a0,0x3
    4fc6:	e3e50513          	addi	a0,a0,-450 # 7e00 <malloc+0x1eba>
    4fca:	00001097          	auipc	ra,0x1
    4fce:	ec0080e7          	jalr	-320(ra) # 5e8a <printf>
    exit(1);
    4fd2:	4505                	li	a0,1
    4fd4:	00001097          	auipc	ra,0x1
    4fd8:	b50080e7          	jalr	-1200(ra) # 5b24 <exit>
      printf("%s: write bigfile failed\n", s);
    4fdc:	85da                	mv	a1,s6
    4fde:	00003517          	auipc	a0,0x3
    4fe2:	e4250513          	addi	a0,a0,-446 # 7e20 <malloc+0x1eda>
    4fe6:	00001097          	auipc	ra,0x1
    4fea:	ea4080e7          	jalr	-348(ra) # 5e8a <printf>
      exit(1);
    4fee:	4505                	li	a0,1
    4ff0:	00001097          	auipc	ra,0x1
    4ff4:	b34080e7          	jalr	-1228(ra) # 5b24 <exit>
    printf("%s: cannot open bigfile\n", s);
    4ff8:	85da                	mv	a1,s6
    4ffa:	00003517          	auipc	a0,0x3
    4ffe:	e4650513          	addi	a0,a0,-442 # 7e40 <malloc+0x1efa>
    5002:	00001097          	auipc	ra,0x1
    5006:	e88080e7          	jalr	-376(ra) # 5e8a <printf>
    exit(1);
    500a:	4505                	li	a0,1
    500c:	00001097          	auipc	ra,0x1
    5010:	b18080e7          	jalr	-1256(ra) # 5b24 <exit>
      printf("%s: read bigfile failed\n", s);
    5014:	85da                	mv	a1,s6
    5016:	00003517          	auipc	a0,0x3
    501a:	e4a50513          	addi	a0,a0,-438 # 7e60 <malloc+0x1f1a>
    501e:	00001097          	auipc	ra,0x1
    5022:	e6c080e7          	jalr	-404(ra) # 5e8a <printf>
      exit(1);
    5026:	4505                	li	a0,1
    5028:	00001097          	auipc	ra,0x1
    502c:	afc080e7          	jalr	-1284(ra) # 5b24 <exit>
      printf("%s: short read bigfile\n", s);
    5030:	85da                	mv	a1,s6
    5032:	00003517          	auipc	a0,0x3
    5036:	e4e50513          	addi	a0,a0,-434 # 7e80 <malloc+0x1f3a>
    503a:	00001097          	auipc	ra,0x1
    503e:	e50080e7          	jalr	-432(ra) # 5e8a <printf>
      exit(1);
    5042:	4505                	li	a0,1
    5044:	00001097          	auipc	ra,0x1
    5048:	ae0080e7          	jalr	-1312(ra) # 5b24 <exit>
      printf("%s: read bigfile wrong data\n", s);
    504c:	85da                	mv	a1,s6
    504e:	00003517          	auipc	a0,0x3
    5052:	e4a50513          	addi	a0,a0,-438 # 7e98 <malloc+0x1f52>
    5056:	00001097          	auipc	ra,0x1
    505a:	e34080e7          	jalr	-460(ra) # 5e8a <printf>
      exit(1);
    505e:	4505                	li	a0,1
    5060:	00001097          	auipc	ra,0x1
    5064:	ac4080e7          	jalr	-1340(ra) # 5b24 <exit>
  close(fd);
    5068:	8556                	mv	a0,s5
    506a:	00001097          	auipc	ra,0x1
    506e:	ae2080e7          	jalr	-1310(ra) # 5b4c <close>
  if(total != N*SZ){
    5072:	678d                	lui	a5,0x3
    5074:	ee078793          	addi	a5,a5,-288 # 2ee0 <execout+0xa0>
    5078:	02fa1463          	bne	s4,a5,50a0 <bigfile+0x1c2>
  unlink("bigfile.dat");
    507c:	00003517          	auipc	a0,0x3
    5080:	d7450513          	addi	a0,a0,-652 # 7df0 <malloc+0x1eaa>
    5084:	00001097          	auipc	ra,0x1
    5088:	af0080e7          	jalr	-1296(ra) # 5b74 <unlink>
}
    508c:	70e2                	ld	ra,56(sp)
    508e:	7442                	ld	s0,48(sp)
    5090:	74a2                	ld	s1,40(sp)
    5092:	7902                	ld	s2,32(sp)
    5094:	69e2                	ld	s3,24(sp)
    5096:	6a42                	ld	s4,16(sp)
    5098:	6aa2                	ld	s5,8(sp)
    509a:	6b02                	ld	s6,0(sp)
    509c:	6121                	addi	sp,sp,64
    509e:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    50a0:	85da                	mv	a1,s6
    50a2:	00003517          	auipc	a0,0x3
    50a6:	e1650513          	addi	a0,a0,-490 # 7eb8 <malloc+0x1f72>
    50aa:	00001097          	auipc	ra,0x1
    50ae:	de0080e7          	jalr	-544(ra) # 5e8a <printf>
    exit(1);
    50b2:	4505                	li	a0,1
    50b4:	00001097          	auipc	ra,0x1
    50b8:	a70080e7          	jalr	-1424(ra) # 5b24 <exit>

00000000000050bc <fsfull>:
{
    50bc:	7171                	addi	sp,sp,-176
    50be:	f506                	sd	ra,168(sp)
    50c0:	f122                	sd	s0,160(sp)
    50c2:	ed26                	sd	s1,152(sp)
    50c4:	e94a                	sd	s2,144(sp)
    50c6:	e54e                	sd	s3,136(sp)
    50c8:	e152                	sd	s4,128(sp)
    50ca:	fcd6                	sd	s5,120(sp)
    50cc:	f8da                	sd	s6,112(sp)
    50ce:	f4de                	sd	s7,104(sp)
    50d0:	f0e2                	sd	s8,96(sp)
    50d2:	ece6                	sd	s9,88(sp)
    50d4:	e8ea                	sd	s10,80(sp)
    50d6:	e4ee                	sd	s11,72(sp)
    50d8:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    50da:	00003517          	auipc	a0,0x3
    50de:	dfe50513          	addi	a0,a0,-514 # 7ed8 <malloc+0x1f92>
    50e2:	00001097          	auipc	ra,0x1
    50e6:	da8080e7          	jalr	-600(ra) # 5e8a <printf>
  for(nfiles = 0; ; nfiles++){
    50ea:	4481                	li	s1,0
    name[0] = 'f';
    50ec:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    50f0:	10625cb7          	lui	s9,0x10625
    50f4:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <__BSS_END__+0x10615d13>
    name[2] = '0' + (nfiles % 1000) / 100;
    50f8:	51eb8ab7          	lui	s5,0x51eb8
    50fc:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <__BSS_END__+0x51ea945f>
    name[3] = '0' + (nfiles % 100) / 10;
    5100:	66666a37          	lui	s4,0x66666
    5104:	667a0a13          	addi	s4,s4,1639 # 66666667 <__BSS_END__+0x666575a7>
    printf("writing %s\n", name);
    5108:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    510c:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    5110:	039487b3          	mul	a5,s1,s9
    5114:	9799                	srai	a5,a5,0x26
    5116:	41f4d69b          	sraiw	a3,s1,0x1f
    511a:	9f95                	subw	a5,a5,a3
    511c:	0307871b          	addiw	a4,a5,48
    5120:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5124:	3e800713          	li	a4,1000
    5128:	02f707bb          	mulw	a5,a4,a5
    512c:	40f487bb          	subw	a5,s1,a5
    5130:	03578733          	mul	a4,a5,s5
    5134:	9715                	srai	a4,a4,0x25
    5136:	41f7d79b          	sraiw	a5,a5,0x1f
    513a:	40f707bb          	subw	a5,a4,a5
    513e:	0307879b          	addiw	a5,a5,48
    5142:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5146:	035487b3          	mul	a5,s1,s5
    514a:	9795                	srai	a5,a5,0x25
    514c:	9f95                	subw	a5,a5,a3
    514e:	06400713          	li	a4,100
    5152:	02f707bb          	mulw	a5,a4,a5
    5156:	40f487bb          	subw	a5,s1,a5
    515a:	03478733          	mul	a4,a5,s4
    515e:	9709                	srai	a4,a4,0x22
    5160:	41f7d79b          	sraiw	a5,a5,0x1f
    5164:	40f707bb          	subw	a5,a4,a5
    5168:	0307879b          	addiw	a5,a5,48
    516c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5170:	03448733          	mul	a4,s1,s4
    5174:	9709                	srai	a4,a4,0x22
    5176:	9f15                	subw	a4,a4,a3
    5178:	0027179b          	slliw	a5,a4,0x2
    517c:	9fb9                	addw	a5,a5,a4
    517e:	0017979b          	slliw	a5,a5,0x1
    5182:	40f487bb          	subw	a5,s1,a5
    5186:	0307879b          	addiw	a5,a5,48
    518a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    518e:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    5192:	85ea                	mv	a1,s10
    5194:	00003517          	auipc	a0,0x3
    5198:	d5450513          	addi	a0,a0,-684 # 7ee8 <malloc+0x1fa2>
    519c:	00001097          	auipc	ra,0x1
    51a0:	cee080e7          	jalr	-786(ra) # 5e8a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    51a4:	20200593          	li	a1,514
    51a8:	856a                	mv	a0,s10
    51aa:	00001097          	auipc	ra,0x1
    51ae:	9ba080e7          	jalr	-1606(ra) # 5b64 <open>
    51b2:	892a                	mv	s2,a0
    if(fd < 0){
    51b4:	0e055e63          	bgez	a0,52b0 <fsfull+0x1f4>
      printf("open %s failed\n", name);
    51b8:	f5040593          	addi	a1,s0,-176
    51bc:	00003517          	auipc	a0,0x3
    51c0:	d3c50513          	addi	a0,a0,-708 # 7ef8 <malloc+0x1fb2>
    51c4:	00001097          	auipc	ra,0x1
    51c8:	cc6080e7          	jalr	-826(ra) # 5e8a <printf>
    name[0] = 'f';
    51cc:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    51d0:	10625a37          	lui	s4,0x10625
    51d4:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <__BSS_END__+0x10615d13>
    name[2] = '0' + (nfiles % 1000) / 100;
    51d8:	3e800b93          	li	s7,1000
    51dc:	51eb89b7          	lui	s3,0x51eb8
    51e0:	51f98993          	addi	s3,s3,1311 # 51eb851f <__BSS_END__+0x51ea945f>
    name[3] = '0' + (nfiles % 100) / 10;
    51e4:	06400b13          	li	s6,100
    51e8:	66666937          	lui	s2,0x66666
    51ec:	66790913          	addi	s2,s2,1639 # 66666667 <__BSS_END__+0x666575a7>
    unlink(name);
    51f0:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    51f4:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    51f8:	034487b3          	mul	a5,s1,s4
    51fc:	9799                	srai	a5,a5,0x26
    51fe:	41f4d69b          	sraiw	a3,s1,0x1f
    5202:	9f95                	subw	a5,a5,a3
    5204:	0307871b          	addiw	a4,a5,48
    5208:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    520c:	02fb87bb          	mulw	a5,s7,a5
    5210:	40f487bb          	subw	a5,s1,a5
    5214:	03378733          	mul	a4,a5,s3
    5218:	9715                	srai	a4,a4,0x25
    521a:	41f7d79b          	sraiw	a5,a5,0x1f
    521e:	40f707bb          	subw	a5,a4,a5
    5222:	0307879b          	addiw	a5,a5,48
    5226:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    522a:	033487b3          	mul	a5,s1,s3
    522e:	9795                	srai	a5,a5,0x25
    5230:	9f95                	subw	a5,a5,a3
    5232:	02fb07bb          	mulw	a5,s6,a5
    5236:	40f487bb          	subw	a5,s1,a5
    523a:	03278733          	mul	a4,a5,s2
    523e:	9709                	srai	a4,a4,0x22
    5240:	41f7d79b          	sraiw	a5,a5,0x1f
    5244:	40f707bb          	subw	a5,a4,a5
    5248:	0307879b          	addiw	a5,a5,48
    524c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    5250:	03248733          	mul	a4,s1,s2
    5254:	9709                	srai	a4,a4,0x22
    5256:	9f15                	subw	a4,a4,a3
    5258:	0027179b          	slliw	a5,a4,0x2
    525c:	9fb9                	addw	a5,a5,a4
    525e:	0017979b          	slliw	a5,a5,0x1
    5262:	40f487bb          	subw	a5,s1,a5
    5266:	0307879b          	addiw	a5,a5,48
    526a:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    526e:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    5272:	8556                	mv	a0,s5
    5274:	00001097          	auipc	ra,0x1
    5278:	900080e7          	jalr	-1792(ra) # 5b74 <unlink>
    nfiles--;
    527c:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    527e:	f604dbe3          	bgez	s1,51f4 <fsfull+0x138>
  printf("fsfull test finished\n");
    5282:	00003517          	auipc	a0,0x3
    5286:	c9650513          	addi	a0,a0,-874 # 7f18 <malloc+0x1fd2>
    528a:	00001097          	auipc	ra,0x1
    528e:	c00080e7          	jalr	-1024(ra) # 5e8a <printf>
}
    5292:	70aa                	ld	ra,168(sp)
    5294:	740a                	ld	s0,160(sp)
    5296:	64ea                	ld	s1,152(sp)
    5298:	694a                	ld	s2,144(sp)
    529a:	69aa                	ld	s3,136(sp)
    529c:	6a0a                	ld	s4,128(sp)
    529e:	7ae6                	ld	s5,120(sp)
    52a0:	7b46                	ld	s6,112(sp)
    52a2:	7ba6                	ld	s7,104(sp)
    52a4:	7c06                	ld	s8,96(sp)
    52a6:	6ce6                	ld	s9,88(sp)
    52a8:	6d46                	ld	s10,80(sp)
    52aa:	6da6                	ld	s11,72(sp)
    52ac:	614d                	addi	sp,sp,176
    52ae:	8082                	ret
    int total = 0;
    52b0:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    52b2:	40000c13          	li	s8,1024
    52b6:	00007b97          	auipc	s7,0x7
    52ba:	dfab8b93          	addi	s7,s7,-518 # c0b0 <buf>
      if(cc < BSIZE)
    52be:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    52c2:	8662                	mv	a2,s8
    52c4:	85de                	mv	a1,s7
    52c6:	854a                	mv	a0,s2
    52c8:	00001097          	auipc	ra,0x1
    52cc:	87c080e7          	jalr	-1924(ra) # 5b44 <write>
      if(cc < BSIZE)
    52d0:	00ab5563          	bge	s6,a0,52da <fsfull+0x21e>
      total += cc;
    52d4:	00a989bb          	addw	s3,s3,a0
    while(1){
    52d8:	b7ed                	j	52c2 <fsfull+0x206>
    printf("wrote %d bytes\n", total);
    52da:	85ce                	mv	a1,s3
    52dc:	00003517          	auipc	a0,0x3
    52e0:	c2c50513          	addi	a0,a0,-980 # 7f08 <malloc+0x1fc2>
    52e4:	00001097          	auipc	ra,0x1
    52e8:	ba6080e7          	jalr	-1114(ra) # 5e8a <printf>
    close(fd);
    52ec:	854a                	mv	a0,s2
    52ee:	00001097          	auipc	ra,0x1
    52f2:	85e080e7          	jalr	-1954(ra) # 5b4c <close>
    if(total == 0)
    52f6:	ec098be3          	beqz	s3,51cc <fsfull+0x110>
  for(nfiles = 0; ; nfiles++){
    52fa:	2485                	addiw	s1,s1,1
    52fc:	bd01                	j	510c <fsfull+0x50>

00000000000052fe <badwrite>:
{
    52fe:	7139                	addi	sp,sp,-64
    5300:	fc06                	sd	ra,56(sp)
    5302:	f822                	sd	s0,48(sp)
    5304:	f426                	sd	s1,40(sp)
    5306:	f04a                	sd	s2,32(sp)
    5308:	ec4e                	sd	s3,24(sp)
    530a:	e852                	sd	s4,16(sp)
    530c:	e456                	sd	s5,8(sp)
    530e:	e05a                	sd	s6,0(sp)
    5310:	0080                	addi	s0,sp,64
  unlink("junk");
    5312:	00003517          	auipc	a0,0x3
    5316:	c1e50513          	addi	a0,a0,-994 # 7f30 <malloc+0x1fea>
    531a:	00001097          	auipc	ra,0x1
    531e:	85a080e7          	jalr	-1958(ra) # 5b74 <unlink>
    5322:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    5326:	20100a93          	li	s5,513
    532a:	00003997          	auipc	s3,0x3
    532e:	c0698993          	addi	s3,s3,-1018 # 7f30 <malloc+0x1fea>
    write(fd, (char*)0xffffffffffL, 1);
    5332:	4b05                	li	s6,1
    5334:	5a7d                	li	s4,-1
    5336:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    533a:	85d6                	mv	a1,s5
    533c:	854e                	mv	a0,s3
    533e:	00001097          	auipc	ra,0x1
    5342:	826080e7          	jalr	-2010(ra) # 5b64 <open>
    5346:	84aa                	mv	s1,a0
    if(fd < 0){
    5348:	06054b63          	bltz	a0,53be <badwrite+0xc0>
    write(fd, (char*)0xffffffffffL, 1);
    534c:	865a                	mv	a2,s6
    534e:	85d2                	mv	a1,s4
    5350:	00000097          	auipc	ra,0x0
    5354:	7f4080e7          	jalr	2036(ra) # 5b44 <write>
    close(fd);
    5358:	8526                	mv	a0,s1
    535a:	00000097          	auipc	ra,0x0
    535e:	7f2080e7          	jalr	2034(ra) # 5b4c <close>
    unlink("junk");
    5362:	854e                	mv	a0,s3
    5364:	00001097          	auipc	ra,0x1
    5368:	810080e7          	jalr	-2032(ra) # 5b74 <unlink>
  for(int i = 0; i < assumed_free; i++){
    536c:	397d                	addiw	s2,s2,-1
    536e:	fc0916e3          	bnez	s2,533a <badwrite+0x3c>
  int fd = open("junk", O_CREATE|O_WRONLY);
    5372:	20100593          	li	a1,513
    5376:	00003517          	auipc	a0,0x3
    537a:	bba50513          	addi	a0,a0,-1094 # 7f30 <malloc+0x1fea>
    537e:	00000097          	auipc	ra,0x0
    5382:	7e6080e7          	jalr	2022(ra) # 5b64 <open>
    5386:	84aa                	mv	s1,a0
  if(fd < 0){
    5388:	04054863          	bltz	a0,53d8 <badwrite+0xda>
  if(write(fd, "x", 1) != 1){
    538c:	4605                	li	a2,1
    538e:	00001597          	auipc	a1,0x1
    5392:	d5a58593          	addi	a1,a1,-678 # 60e8 <malloc+0x1a2>
    5396:	00000097          	auipc	ra,0x0
    539a:	7ae080e7          	jalr	1966(ra) # 5b44 <write>
    539e:	4785                	li	a5,1
    53a0:	04f50963          	beq	a0,a5,53f2 <badwrite+0xf4>
    printf("write failed\n");
    53a4:	00003517          	auipc	a0,0x3
    53a8:	bac50513          	addi	a0,a0,-1108 # 7f50 <malloc+0x200a>
    53ac:	00001097          	auipc	ra,0x1
    53b0:	ade080e7          	jalr	-1314(ra) # 5e8a <printf>
    exit(1);
    53b4:	4505                	li	a0,1
    53b6:	00000097          	auipc	ra,0x0
    53ba:	76e080e7          	jalr	1902(ra) # 5b24 <exit>
      printf("open junk failed\n");
    53be:	00003517          	auipc	a0,0x3
    53c2:	b7a50513          	addi	a0,a0,-1158 # 7f38 <malloc+0x1ff2>
    53c6:	00001097          	auipc	ra,0x1
    53ca:	ac4080e7          	jalr	-1340(ra) # 5e8a <printf>
      exit(1);
    53ce:	4505                	li	a0,1
    53d0:	00000097          	auipc	ra,0x0
    53d4:	754080e7          	jalr	1876(ra) # 5b24 <exit>
    printf("open junk failed\n");
    53d8:	00003517          	auipc	a0,0x3
    53dc:	b6050513          	addi	a0,a0,-1184 # 7f38 <malloc+0x1ff2>
    53e0:	00001097          	auipc	ra,0x1
    53e4:	aaa080e7          	jalr	-1366(ra) # 5e8a <printf>
    exit(1);
    53e8:	4505                	li	a0,1
    53ea:	00000097          	auipc	ra,0x0
    53ee:	73a080e7          	jalr	1850(ra) # 5b24 <exit>
  close(fd);
    53f2:	8526                	mv	a0,s1
    53f4:	00000097          	auipc	ra,0x0
    53f8:	758080e7          	jalr	1880(ra) # 5b4c <close>
  unlink("junk");
    53fc:	00003517          	auipc	a0,0x3
    5400:	b3450513          	addi	a0,a0,-1228 # 7f30 <malloc+0x1fea>
    5404:	00000097          	auipc	ra,0x0
    5408:	770080e7          	jalr	1904(ra) # 5b74 <unlink>
  exit(0);
    540c:	4501                	li	a0,0
    540e:	00000097          	auipc	ra,0x0
    5412:	716080e7          	jalr	1814(ra) # 5b24 <exit>

0000000000005416 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5416:	7139                	addi	sp,sp,-64
    5418:	fc06                	sd	ra,56(sp)
    541a:	f822                	sd	s0,48(sp)
    541c:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    541e:	fc840513          	addi	a0,s0,-56
    5422:	00000097          	auipc	ra,0x0
    5426:	712080e7          	jalr	1810(ra) # 5b34 <pipe>
    542a:	06054b63          	bltz	a0,54a0 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    542e:	00000097          	auipc	ra,0x0
    5432:	6ee080e7          	jalr	1774(ra) # 5b1c <fork>

  if(pid < 0){
    5436:	08054663          	bltz	a0,54c2 <countfree+0xac>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    543a:	e955                	bnez	a0,54ee <countfree+0xd8>
    543c:	f426                	sd	s1,40(sp)
    543e:	f04a                	sd	s2,32(sp)
    5440:	ec4e                	sd	s3,24(sp)
    5442:	e852                	sd	s4,16(sp)
    close(fds[0]);
    5444:	fc842503          	lw	a0,-56(s0)
    5448:	00000097          	auipc	ra,0x0
    544c:	704080e7          	jalr	1796(ra) # 5b4c <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    5450:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
    5452:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5454:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5456:	00001a17          	auipc	s4,0x1
    545a:	c92a0a13          	addi	s4,s4,-878 # 60e8 <malloc+0x1a2>
      uint64 a = (uint64) sbrk(4096);
    545e:	854a                	mv	a0,s2
    5460:	00000097          	auipc	ra,0x0
    5464:	74c080e7          	jalr	1868(ra) # 5bac <sbrk>
      if(a == 0xffffffffffffffff){
    5468:	07350e63          	beq	a0,s3,54e4 <countfree+0xce>
      *(char *)(a + 4096 - 1) = 1;
    546c:	954a                	add	a0,a0,s2
    546e:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
    5472:	8626                	mv	a2,s1
    5474:	85d2                	mv	a1,s4
    5476:	fcc42503          	lw	a0,-52(s0)
    547a:	00000097          	auipc	ra,0x0
    547e:	6ca080e7          	jalr	1738(ra) # 5b44 <write>
    5482:	fc950ee3          	beq	a0,s1,545e <countfree+0x48>
        printf("write() failed in countfree()\n");
    5486:	00003517          	auipc	a0,0x3
    548a:	b1a50513          	addi	a0,a0,-1254 # 7fa0 <malloc+0x205a>
    548e:	00001097          	auipc	ra,0x1
    5492:	9fc080e7          	jalr	-1540(ra) # 5e8a <printf>
        exit(1);
    5496:	4505                	li	a0,1
    5498:	00000097          	auipc	ra,0x0
    549c:	68c080e7          	jalr	1676(ra) # 5b24 <exit>
    54a0:	f426                	sd	s1,40(sp)
    54a2:	f04a                	sd	s2,32(sp)
    54a4:	ec4e                	sd	s3,24(sp)
    54a6:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
    54a8:	00003517          	auipc	a0,0x3
    54ac:	ab850513          	addi	a0,a0,-1352 # 7f60 <malloc+0x201a>
    54b0:	00001097          	auipc	ra,0x1
    54b4:	9da080e7          	jalr	-1574(ra) # 5e8a <printf>
    exit(1);
    54b8:	4505                	li	a0,1
    54ba:	00000097          	auipc	ra,0x0
    54be:	66a080e7          	jalr	1642(ra) # 5b24 <exit>
    54c2:	f426                	sd	s1,40(sp)
    54c4:	f04a                	sd	s2,32(sp)
    54c6:	ec4e                	sd	s3,24(sp)
    54c8:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
    54ca:	00003517          	auipc	a0,0x3
    54ce:	ab650513          	addi	a0,a0,-1354 # 7f80 <malloc+0x203a>
    54d2:	00001097          	auipc	ra,0x1
    54d6:	9b8080e7          	jalr	-1608(ra) # 5e8a <printf>
    exit(1);
    54da:	4505                	li	a0,1
    54dc:	00000097          	auipc	ra,0x0
    54e0:	648080e7          	jalr	1608(ra) # 5b24 <exit>
      }
    }

    exit(0);
    54e4:	4501                	li	a0,0
    54e6:	00000097          	auipc	ra,0x0
    54ea:	63e080e7          	jalr	1598(ra) # 5b24 <exit>
    54ee:	f426                	sd	s1,40(sp)
    54f0:	f04a                	sd	s2,32(sp)
    54f2:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
    54f4:	fcc42503          	lw	a0,-52(s0)
    54f8:	00000097          	auipc	ra,0x0
    54fc:	654080e7          	jalr	1620(ra) # 5b4c <close>

  int n = 0;
    5500:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5502:	fc740993          	addi	s3,s0,-57
    5506:	4905                	li	s2,1
    5508:	864a                	mv	a2,s2
    550a:	85ce                	mv	a1,s3
    550c:	fc842503          	lw	a0,-56(s0)
    5510:	00000097          	auipc	ra,0x0
    5514:	62c080e7          	jalr	1580(ra) # 5b3c <read>
    if(cc < 0){
    5518:	00054563          	bltz	a0,5522 <countfree+0x10c>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    551c:	c10d                	beqz	a0,553e <countfree+0x128>
      break;
    n += 1;
    551e:	2485                	addiw	s1,s1,1
  while(1){
    5520:	b7e5                	j	5508 <countfree+0xf2>
    5522:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
    5524:	00003517          	auipc	a0,0x3
    5528:	a9c50513          	addi	a0,a0,-1380 # 7fc0 <malloc+0x207a>
    552c:	00001097          	auipc	ra,0x1
    5530:	95e080e7          	jalr	-1698(ra) # 5e8a <printf>
      exit(1);
    5534:	4505                	li	a0,1
    5536:	00000097          	auipc	ra,0x0
    553a:	5ee080e7          	jalr	1518(ra) # 5b24 <exit>
  }

  close(fds[0]);
    553e:	fc842503          	lw	a0,-56(s0)
    5542:	00000097          	auipc	ra,0x0
    5546:	60a080e7          	jalr	1546(ra) # 5b4c <close>
  wait((int*)0);
    554a:	4501                	li	a0,0
    554c:	00000097          	auipc	ra,0x0
    5550:	5e0080e7          	jalr	1504(ra) # 5b2c <wait>
  
  return n;
}
    5554:	8526                	mv	a0,s1
    5556:	74a2                	ld	s1,40(sp)
    5558:	7902                	ld	s2,32(sp)
    555a:	69e2                	ld	s3,24(sp)
    555c:	70e2                	ld	ra,56(sp)
    555e:	7442                	ld	s0,48(sp)
    5560:	6121                	addi	sp,sp,64
    5562:	8082                	ret

0000000000005564 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5564:	7179                	addi	sp,sp,-48
    5566:	f406                	sd	ra,40(sp)
    5568:	f022                	sd	s0,32(sp)
    556a:	ec26                	sd	s1,24(sp)
    556c:	e84a                	sd	s2,16(sp)
    556e:	1800                	addi	s0,sp,48
    5570:	84aa                	mv	s1,a0
    5572:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5574:	00003517          	auipc	a0,0x3
    5578:	a6c50513          	addi	a0,a0,-1428 # 7fe0 <malloc+0x209a>
    557c:	00001097          	auipc	ra,0x1
    5580:	90e080e7          	jalr	-1778(ra) # 5e8a <printf>
  if((pid = fork()) < 0) {
    5584:	00000097          	auipc	ra,0x0
    5588:	598080e7          	jalr	1432(ra) # 5b1c <fork>
    558c:	02054e63          	bltz	a0,55c8 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5590:	c929                	beqz	a0,55e2 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5592:	fdc40513          	addi	a0,s0,-36
    5596:	00000097          	auipc	ra,0x0
    559a:	596080e7          	jalr	1430(ra) # 5b2c <wait>
    if(xstatus != 0) 
    559e:	fdc42783          	lw	a5,-36(s0)
    55a2:	c7b9                	beqz	a5,55f0 <run+0x8c>
      printf("FAILED\n");
    55a4:	00003517          	auipc	a0,0x3
    55a8:	a6450513          	addi	a0,a0,-1436 # 8008 <malloc+0x20c2>
    55ac:	00001097          	auipc	ra,0x1
    55b0:	8de080e7          	jalr	-1826(ra) # 5e8a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55b4:	fdc42503          	lw	a0,-36(s0)
  }
}
    55b8:	00153513          	seqz	a0,a0
    55bc:	70a2                	ld	ra,40(sp)
    55be:	7402                	ld	s0,32(sp)
    55c0:	64e2                	ld	s1,24(sp)
    55c2:	6942                	ld	s2,16(sp)
    55c4:	6145                	addi	sp,sp,48
    55c6:	8082                	ret
    printf("runtest: fork error\n");
    55c8:	00003517          	auipc	a0,0x3
    55cc:	a2850513          	addi	a0,a0,-1496 # 7ff0 <malloc+0x20aa>
    55d0:	00001097          	auipc	ra,0x1
    55d4:	8ba080e7          	jalr	-1862(ra) # 5e8a <printf>
    exit(1);
    55d8:	4505                	li	a0,1
    55da:	00000097          	auipc	ra,0x0
    55de:	54a080e7          	jalr	1354(ra) # 5b24 <exit>
    f(s);
    55e2:	854a                	mv	a0,s2
    55e4:	9482                	jalr	s1
    exit(0);
    55e6:	4501                	li	a0,0
    55e8:	00000097          	auipc	ra,0x0
    55ec:	53c080e7          	jalr	1340(ra) # 5b24 <exit>
      printf("OK\n");
    55f0:	00003517          	auipc	a0,0x3
    55f4:	a2050513          	addi	a0,a0,-1504 # 8010 <malloc+0x20ca>
    55f8:	00001097          	auipc	ra,0x1
    55fc:	892080e7          	jalr	-1902(ra) # 5e8a <printf>
    5600:	bf55                	j	55b4 <run+0x50>

0000000000005602 <main>:

int
main(int argc, char *argv[])
{
    5602:	bd010113          	addi	sp,sp,-1072
    5606:	42113423          	sd	ra,1064(sp)
    560a:	42813023          	sd	s0,1056(sp)
    560e:	41313423          	sd	s3,1032(sp)
    5612:	41413023          	sd	s4,1024(sp)
    5616:	43010413          	addi	s0,sp,1072
    561a:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    561c:	4789                	li	a5,2
    561e:	0af50963          	beq	a0,a5,56d0 <main+0xce>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    5622:	4785                	li	a5,1
    5624:	16a7c163          	blt	a5,a0,5786 <main+0x184>
  char *justone = 0;
    5628:	4a01                	li	s4,0
    562a:	40913c23          	sd	s1,1048(sp)
    562e:	41213823          	sd	s2,1040(sp)
    5632:	3f513c23          	sd	s5,1016(sp)
    5636:	3f613823          	sd	s6,1008(sp)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    563a:	00003797          	auipc	a5,0x3
    563e:	df678793          	addi	a5,a5,-522 # 8430 <malloc+0x24ea>
    5642:	bd040713          	addi	a4,s0,-1072
    5646:	00003697          	auipc	a3,0x3
    564a:	1da68693          	addi	a3,a3,474 # 8820 <malloc+0x28da>
    564e:	0007b303          	ld	t1,0(a5)
    5652:	0087b883          	ld	a7,8(a5)
    5656:	0107b803          	ld	a6,16(a5)
    565a:	6f88                	ld	a0,24(a5)
    565c:	738c                	ld	a1,32(a5)
    565e:	7790                	ld	a2,40(a5)
    5660:	00673023          	sd	t1,0(a4)
    5664:	01173423          	sd	a7,8(a4)
    5668:	01073823          	sd	a6,16(a4)
    566c:	ef08                	sd	a0,24(a4)
    566e:	f30c                	sd	a1,32(a4)
    5670:	f710                	sd	a2,40(a4)
    5672:	03078793          	addi	a5,a5,48
    5676:	03070713          	addi	a4,a4,48
    567a:	fcd79ae3          	bne	a5,a3,564e <main+0x4c>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    567e:	00003517          	auipc	a0,0x3
    5682:	a5250513          	addi	a0,a0,-1454 # 80d0 <malloc+0x218a>
    5686:	00001097          	auipc	ra,0x1
    568a:	804080e7          	jalr	-2044(ra) # 5e8a <printf>
  int free0 = countfree();
    568e:	00000097          	auipc	ra,0x0
    5692:	d88080e7          	jalr	-632(ra) # 5416 <countfree>
    5696:	8aaa                	mv	s5,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5698:	bd843903          	ld	s2,-1064(s0)
    569c:	bd040493          	addi	s1,s0,-1072
  int fail = 0;
    56a0:	4981                	li	s3,0
  for (struct test *t = tests; t->s != 0; t++) {
    56a2:	14091a63          	bnez	s2,57f6 <main+0x1f4>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    56a6:	00000097          	auipc	ra,0x0
    56aa:	d70080e7          	jalr	-656(ra) # 5416 <countfree>
    56ae:	85aa                	mv	a1,a0
    56b0:	17555c63          	bge	a0,s5,5828 <main+0x226>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    56b4:	8656                	mv	a2,s5
    56b6:	00003517          	auipc	a0,0x3
    56ba:	9d250513          	addi	a0,a0,-1582 # 8088 <malloc+0x2142>
    56be:	00000097          	auipc	ra,0x0
    56c2:	7cc080e7          	jalr	1996(ra) # 5e8a <printf>
    exit(1);
    56c6:	4505                	li	a0,1
    56c8:	00000097          	auipc	ra,0x0
    56cc:	45c080e7          	jalr	1116(ra) # 5b24 <exit>
    56d0:	40913c23          	sd	s1,1048(sp)
    56d4:	41213823          	sd	s2,1040(sp)
    56d8:	3f513c23          	sd	s5,1016(sp)
    56dc:	3f613823          	sd	s6,1008(sp)
    56e0:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    56e2:	00003597          	auipc	a1,0x3
    56e6:	93658593          	addi	a1,a1,-1738 # 8018 <malloc+0x20d2>
    56ea:	6488                	ld	a0,8(s1)
    56ec:	00000097          	auipc	ra,0x0
    56f0:	1b8080e7          	jalr	440(ra) # 58a4 <strcmp>
    56f4:	e535                	bnez	a0,5760 <main+0x15e>
    continuous = 1;
    56f6:	4985                	li	s3,1
  } tests[] = {
    56f8:	00003797          	auipc	a5,0x3
    56fc:	d3878793          	addi	a5,a5,-712 # 8430 <malloc+0x24ea>
    5700:	bd040713          	addi	a4,s0,-1072
    5704:	00003697          	auipc	a3,0x3
    5708:	11c68693          	addi	a3,a3,284 # 8820 <malloc+0x28da>
    570c:	0007b303          	ld	t1,0(a5)
    5710:	0087b883          	ld	a7,8(a5)
    5714:	0107b803          	ld	a6,16(a5)
    5718:	6f88                	ld	a0,24(a5)
    571a:	738c                	ld	a1,32(a5)
    571c:	7790                	ld	a2,40(a5)
    571e:	00673023          	sd	t1,0(a4)
    5722:	01173423          	sd	a7,8(a4)
    5726:	01073823          	sd	a6,16(a4)
    572a:	ef08                	sd	a0,24(a4)
    572c:	f30c                	sd	a1,32(a4)
    572e:	f710                	sd	a2,40(a4)
    5730:	03078793          	addi	a5,a5,48
    5734:	03070713          	addi	a4,a4,48
    5738:	fcd79ae3          	bne	a5,a3,570c <main+0x10a>
    printf("continuous usertests starting\n");
    573c:	00003517          	auipc	a0,0x3
    5740:	9ac50513          	addi	a0,a0,-1620 # 80e8 <malloc+0x21a2>
    5744:	00000097          	auipc	ra,0x0
    5748:	746080e7          	jalr	1862(ra) # 5e8a <printf>
        printf("SOME TESTS FAILED\n");
    574c:	00003a97          	auipc	s5,0x3
    5750:	924a8a93          	addi	s5,s5,-1756 # 8070 <malloc+0x212a>
        if(continuous != 2)
    5754:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    5756:	00003b17          	auipc	s6,0x3
    575a:	8fab0b13          	addi	s6,s6,-1798 # 8050 <malloc+0x210a>
    575e:	a8fd                	j	585c <main+0x25a>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5760:	00003597          	auipc	a1,0x3
    5764:	8c058593          	addi	a1,a1,-1856 # 8020 <malloc+0x20da>
    5768:	6488                	ld	a0,8(s1)
    576a:	00000097          	auipc	ra,0x0
    576e:	13a080e7          	jalr	314(ra) # 58a4 <strcmp>
    5772:	d159                	beqz	a0,56f8 <main+0xf6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5774:	0084ba03          	ld	s4,8(s1)
    5778:	000a4703          	lbu	a4,0(s4)
    577c:	02d00793          	li	a5,45
    5780:	eaf71de3          	bne	a4,a5,563a <main+0x38>
    5784:	a809                	j	5796 <main+0x194>
    5786:	40913c23          	sd	s1,1048(sp)
    578a:	41213823          	sd	s2,1040(sp)
    578e:	3f513c23          	sd	s5,1016(sp)
    5792:	3f613823          	sd	s6,1008(sp)
    printf("Usage: usertests [-c] [testname]\n");
    5796:	00003517          	auipc	a0,0x3
    579a:	89250513          	addi	a0,a0,-1902 # 8028 <malloc+0x20e2>
    579e:	00000097          	auipc	ra,0x0
    57a2:	6ec080e7          	jalr	1772(ra) # 5e8a <printf>
    exit(1);
    57a6:	4505                	li	a0,1
    57a8:	00000097          	auipc	ra,0x0
    57ac:	37c080e7          	jalr	892(ra) # 5b24 <exit>
          exit(1);
    57b0:	4505                	li	a0,1
    57b2:	00000097          	auipc	ra,0x0
    57b6:	372080e7          	jalr	882(ra) # 5b24 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    57ba:	40a905bb          	subw	a1,s2,a0
    57be:	855a                	mv	a0,s6
    57c0:	00000097          	auipc	ra,0x0
    57c4:	6ca080e7          	jalr	1738(ra) # 5e8a <printf>
        if(continuous != 2)
    57c8:	09498a63          	beq	s3,s4,585c <main+0x25a>
          exit(1);
    57cc:	4505                	li	a0,1
    57ce:	00000097          	auipc	ra,0x0
    57d2:	356080e7          	jalr	854(ra) # 5b24 <exit>
      if(!run(t->f, t->s))
    57d6:	85ca                	mv	a1,s2
    57d8:	6088                	ld	a0,0(s1)
    57da:	00000097          	auipc	ra,0x0
    57de:	d8a080e7          	jalr	-630(ra) # 5564 <run>
    57e2:	00153513          	seqz	a0,a0
    57e6:	00a9e9b3          	or	s3,s3,a0
    57ea:	2981                	sext.w	s3,s3
  for (struct test *t = tests; t->s != 0; t++) {
    57ec:	04c1                	addi	s1,s1,16
    57ee:	0084b903          	ld	s2,8(s1)
    57f2:	00090c63          	beqz	s2,580a <main+0x208>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    57f6:	fe0a00e3          	beqz	s4,57d6 <main+0x1d4>
    57fa:	85d2                	mv	a1,s4
    57fc:	854a                	mv	a0,s2
    57fe:	00000097          	auipc	ra,0x0
    5802:	0a6080e7          	jalr	166(ra) # 58a4 <strcmp>
    5806:	f17d                	bnez	a0,57ec <main+0x1ea>
    5808:	b7f9                	j	57d6 <main+0x1d4>
  if(fail){
    580a:	e8098ee3          	beqz	s3,56a6 <main+0xa4>
    printf("SOME TESTS FAILED\n");
    580e:	00003517          	auipc	a0,0x3
    5812:	86250513          	addi	a0,a0,-1950 # 8070 <malloc+0x212a>
    5816:	00000097          	auipc	ra,0x0
    581a:	674080e7          	jalr	1652(ra) # 5e8a <printf>
    exit(1);
    581e:	4505                	li	a0,1
    5820:	00000097          	auipc	ra,0x0
    5824:	304080e7          	jalr	772(ra) # 5b24 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    5828:	00003517          	auipc	a0,0x3
    582c:	89050513          	addi	a0,a0,-1904 # 80b8 <malloc+0x2172>
    5830:	00000097          	auipc	ra,0x0
    5834:	65a080e7          	jalr	1626(ra) # 5e8a <printf>
    exit(0);
    5838:	4501                	li	a0,0
    583a:	00000097          	auipc	ra,0x0
    583e:	2ea080e7          	jalr	746(ra) # 5b24 <exit>
        printf("SOME TESTS FAILED\n");
    5842:	8556                	mv	a0,s5
    5844:	00000097          	auipc	ra,0x0
    5848:	646080e7          	jalr	1606(ra) # 5e8a <printf>
        if(continuous != 2)
    584c:	f74992e3          	bne	s3,s4,57b0 <main+0x1ae>
      int free1 = countfree();
    5850:	00000097          	auipc	ra,0x0
    5854:	bc6080e7          	jalr	-1082(ra) # 5416 <countfree>
      if(free1 < free0){
    5858:	f72541e3          	blt	a0,s2,57ba <main+0x1b8>
      int free0 = countfree();
    585c:	00000097          	auipc	ra,0x0
    5860:	bba080e7          	jalr	-1094(ra) # 5416 <countfree>
    5864:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    5866:	bd843583          	ld	a1,-1064(s0)
    586a:	d1fd                	beqz	a1,5850 <main+0x24e>
    586c:	bd040493          	addi	s1,s0,-1072
        if(!run(t->f, t->s)){
    5870:	6088                	ld	a0,0(s1)
    5872:	00000097          	auipc	ra,0x0
    5876:	cf2080e7          	jalr	-782(ra) # 5564 <run>
    587a:	d561                	beqz	a0,5842 <main+0x240>
      for (struct test *t = tests; t->s != 0; t++) {
    587c:	04c1                	addi	s1,s1,16
    587e:	648c                	ld	a1,8(s1)
    5880:	f9e5                	bnez	a1,5870 <main+0x26e>
    5882:	b7f9                	j	5850 <main+0x24e>

0000000000005884 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    5884:	1141                	addi	sp,sp,-16
    5886:	e406                	sd	ra,8(sp)
    5888:	e022                	sd	s0,0(sp)
    588a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    588c:	87aa                	mv	a5,a0
    588e:	0585                	addi	a1,a1,1
    5890:	0785                	addi	a5,a5,1
    5892:	fff5c703          	lbu	a4,-1(a1)
    5896:	fee78fa3          	sb	a4,-1(a5)
    589a:	fb75                	bnez	a4,588e <strcpy+0xa>
    ;
  return os;
}
    589c:	60a2                	ld	ra,8(sp)
    589e:	6402                	ld	s0,0(sp)
    58a0:	0141                	addi	sp,sp,16
    58a2:	8082                	ret

00000000000058a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    58a4:	1141                	addi	sp,sp,-16
    58a6:	e406                	sd	ra,8(sp)
    58a8:	e022                	sd	s0,0(sp)
    58aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    58ac:	00054783          	lbu	a5,0(a0)
    58b0:	cb91                	beqz	a5,58c4 <strcmp+0x20>
    58b2:	0005c703          	lbu	a4,0(a1)
    58b6:	00f71763          	bne	a4,a5,58c4 <strcmp+0x20>
    p++, q++;
    58ba:	0505                	addi	a0,a0,1
    58bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    58be:	00054783          	lbu	a5,0(a0)
    58c2:	fbe5                	bnez	a5,58b2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    58c4:	0005c503          	lbu	a0,0(a1)
}
    58c8:	40a7853b          	subw	a0,a5,a0
    58cc:	60a2                	ld	ra,8(sp)
    58ce:	6402                	ld	s0,0(sp)
    58d0:	0141                	addi	sp,sp,16
    58d2:	8082                	ret

00000000000058d4 <strlen>:

uint
strlen(const char *s)
{
    58d4:	1141                	addi	sp,sp,-16
    58d6:	e406                	sd	ra,8(sp)
    58d8:	e022                	sd	s0,0(sp)
    58da:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    58dc:	00054783          	lbu	a5,0(a0)
    58e0:	cf99                	beqz	a5,58fe <strlen+0x2a>
    58e2:	0505                	addi	a0,a0,1
    58e4:	87aa                	mv	a5,a0
    58e6:	86be                	mv	a3,a5
    58e8:	0785                	addi	a5,a5,1
    58ea:	fff7c703          	lbu	a4,-1(a5)
    58ee:	ff65                	bnez	a4,58e6 <strlen+0x12>
    58f0:	40a6853b          	subw	a0,a3,a0
    58f4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    58f6:	60a2                	ld	ra,8(sp)
    58f8:	6402                	ld	s0,0(sp)
    58fa:	0141                	addi	sp,sp,16
    58fc:	8082                	ret
  for(n = 0; s[n]; n++)
    58fe:	4501                	li	a0,0
    5900:	bfdd                	j	58f6 <strlen+0x22>

0000000000005902 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5902:	1141                	addi	sp,sp,-16
    5904:	e406                	sd	ra,8(sp)
    5906:	e022                	sd	s0,0(sp)
    5908:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    590a:	ca19                	beqz	a2,5920 <memset+0x1e>
    590c:	87aa                	mv	a5,a0
    590e:	1602                	slli	a2,a2,0x20
    5910:	9201                	srli	a2,a2,0x20
    5912:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5916:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    591a:	0785                	addi	a5,a5,1
    591c:	fee79de3          	bne	a5,a4,5916 <memset+0x14>
  }
  return dst;
}
    5920:	60a2                	ld	ra,8(sp)
    5922:	6402                	ld	s0,0(sp)
    5924:	0141                	addi	sp,sp,16
    5926:	8082                	ret

0000000000005928 <strchr>:

char*
strchr(const char *s, char c)
{
    5928:	1141                	addi	sp,sp,-16
    592a:	e406                	sd	ra,8(sp)
    592c:	e022                	sd	s0,0(sp)
    592e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5930:	00054783          	lbu	a5,0(a0)
    5934:	cf81                	beqz	a5,594c <strchr+0x24>
    if(*s == c)
    5936:	00f58763          	beq	a1,a5,5944 <strchr+0x1c>
  for(; *s; s++)
    593a:	0505                	addi	a0,a0,1
    593c:	00054783          	lbu	a5,0(a0)
    5940:	fbfd                	bnez	a5,5936 <strchr+0xe>
      return (char*)s;
  return 0;
    5942:	4501                	li	a0,0
}
    5944:	60a2                	ld	ra,8(sp)
    5946:	6402                	ld	s0,0(sp)
    5948:	0141                	addi	sp,sp,16
    594a:	8082                	ret
  return 0;
    594c:	4501                	li	a0,0
    594e:	bfdd                	j	5944 <strchr+0x1c>

0000000000005950 <gets>:

char*
gets(char *buf, int max)
{
    5950:	7159                	addi	sp,sp,-112
    5952:	f486                	sd	ra,104(sp)
    5954:	f0a2                	sd	s0,96(sp)
    5956:	eca6                	sd	s1,88(sp)
    5958:	e8ca                	sd	s2,80(sp)
    595a:	e4ce                	sd	s3,72(sp)
    595c:	e0d2                	sd	s4,64(sp)
    595e:	fc56                	sd	s5,56(sp)
    5960:	f85a                	sd	s6,48(sp)
    5962:	f45e                	sd	s7,40(sp)
    5964:	f062                	sd	s8,32(sp)
    5966:	ec66                	sd	s9,24(sp)
    5968:	e86a                	sd	s10,16(sp)
    596a:	1880                	addi	s0,sp,112
    596c:	8caa                	mv	s9,a0
    596e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5970:	892a                	mv	s2,a0
    5972:	4481                	li	s1,0
    cc = read(0, &c, 1);
    5974:	f9f40b13          	addi	s6,s0,-97
    5978:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    597a:	4ba9                	li	s7,10
    597c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
    597e:	8d26                	mv	s10,s1
    5980:	0014899b          	addiw	s3,s1,1
    5984:	84ce                	mv	s1,s3
    5986:	0349d763          	bge	s3,s4,59b4 <gets+0x64>
    cc = read(0, &c, 1);
    598a:	8656                	mv	a2,s5
    598c:	85da                	mv	a1,s6
    598e:	4501                	li	a0,0
    5990:	00000097          	auipc	ra,0x0
    5994:	1ac080e7          	jalr	428(ra) # 5b3c <read>
    if(cc < 1)
    5998:	00a05e63          	blez	a0,59b4 <gets+0x64>
    buf[i++] = c;
    599c:	f9f44783          	lbu	a5,-97(s0)
    59a0:	00f90023          	sb	a5,0(s2) # 1000 <bigdir+0x64>
    if(c == '\n' || c == '\r')
    59a4:	01778763          	beq	a5,s7,59b2 <gets+0x62>
    59a8:	0905                	addi	s2,s2,1
    59aa:	fd879ae3          	bne	a5,s8,597e <gets+0x2e>
    buf[i++] = c;
    59ae:	8d4e                	mv	s10,s3
    59b0:	a011                	j	59b4 <gets+0x64>
    59b2:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
    59b4:	9d66                	add	s10,s10,s9
    59b6:	000d0023          	sb	zero,0(s10)
  return buf;
}
    59ba:	8566                	mv	a0,s9
    59bc:	70a6                	ld	ra,104(sp)
    59be:	7406                	ld	s0,96(sp)
    59c0:	64e6                	ld	s1,88(sp)
    59c2:	6946                	ld	s2,80(sp)
    59c4:	69a6                	ld	s3,72(sp)
    59c6:	6a06                	ld	s4,64(sp)
    59c8:	7ae2                	ld	s5,56(sp)
    59ca:	7b42                	ld	s6,48(sp)
    59cc:	7ba2                	ld	s7,40(sp)
    59ce:	7c02                	ld	s8,32(sp)
    59d0:	6ce2                	ld	s9,24(sp)
    59d2:	6d42                	ld	s10,16(sp)
    59d4:	6165                	addi	sp,sp,112
    59d6:	8082                	ret

00000000000059d8 <stat>:

int
stat(const char *n, struct stat *st)
{
    59d8:	1101                	addi	sp,sp,-32
    59da:	ec06                	sd	ra,24(sp)
    59dc:	e822                	sd	s0,16(sp)
    59de:	e04a                	sd	s2,0(sp)
    59e0:	1000                	addi	s0,sp,32
    59e2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    59e4:	4581                	li	a1,0
    59e6:	00000097          	auipc	ra,0x0
    59ea:	17e080e7          	jalr	382(ra) # 5b64 <open>
  if(fd < 0)
    59ee:	02054663          	bltz	a0,5a1a <stat+0x42>
    59f2:	e426                	sd	s1,8(sp)
    59f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    59f6:	85ca                	mv	a1,s2
    59f8:	00000097          	auipc	ra,0x0
    59fc:	184080e7          	jalr	388(ra) # 5b7c <fstat>
    5a00:	892a                	mv	s2,a0
  close(fd);
    5a02:	8526                	mv	a0,s1
    5a04:	00000097          	auipc	ra,0x0
    5a08:	148080e7          	jalr	328(ra) # 5b4c <close>
  return r;
    5a0c:	64a2                	ld	s1,8(sp)
}
    5a0e:	854a                	mv	a0,s2
    5a10:	60e2                	ld	ra,24(sp)
    5a12:	6442                	ld	s0,16(sp)
    5a14:	6902                	ld	s2,0(sp)
    5a16:	6105                	addi	sp,sp,32
    5a18:	8082                	ret
    return -1;
    5a1a:	597d                	li	s2,-1
    5a1c:	bfcd                	j	5a0e <stat+0x36>

0000000000005a1e <atoi>:

int
atoi(const char *s)
{
    5a1e:	1141                	addi	sp,sp,-16
    5a20:	e406                	sd	ra,8(sp)
    5a22:	e022                	sd	s0,0(sp)
    5a24:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5a26:	00054683          	lbu	a3,0(a0)
    5a2a:	fd06879b          	addiw	a5,a3,-48
    5a2e:	0ff7f793          	zext.b	a5,a5
    5a32:	4625                	li	a2,9
    5a34:	02f66963          	bltu	a2,a5,5a66 <atoi+0x48>
    5a38:	872a                	mv	a4,a0
  n = 0;
    5a3a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    5a3c:	0705                	addi	a4,a4,1
    5a3e:	0025179b          	slliw	a5,a0,0x2
    5a42:	9fa9                	addw	a5,a5,a0
    5a44:	0017979b          	slliw	a5,a5,0x1
    5a48:	9fb5                	addw	a5,a5,a3
    5a4a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5a4e:	00074683          	lbu	a3,0(a4)
    5a52:	fd06879b          	addiw	a5,a3,-48
    5a56:	0ff7f793          	zext.b	a5,a5
    5a5a:	fef671e3          	bgeu	a2,a5,5a3c <atoi+0x1e>
  return n;
}
    5a5e:	60a2                	ld	ra,8(sp)
    5a60:	6402                	ld	s0,0(sp)
    5a62:	0141                	addi	sp,sp,16
    5a64:	8082                	ret
  n = 0;
    5a66:	4501                	li	a0,0
    5a68:	bfdd                	j	5a5e <atoi+0x40>

0000000000005a6a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5a6a:	1141                	addi	sp,sp,-16
    5a6c:	e406                	sd	ra,8(sp)
    5a6e:	e022                	sd	s0,0(sp)
    5a70:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5a72:	02b57563          	bgeu	a0,a1,5a9c <memmove+0x32>
    while(n-- > 0)
    5a76:	00c05f63          	blez	a2,5a94 <memmove+0x2a>
    5a7a:	1602                	slli	a2,a2,0x20
    5a7c:	9201                	srli	a2,a2,0x20
    5a7e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5a82:	872a                	mv	a4,a0
      *dst++ = *src++;
    5a84:	0585                	addi	a1,a1,1
    5a86:	0705                	addi	a4,a4,1
    5a88:	fff5c683          	lbu	a3,-1(a1)
    5a8c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5a90:	fee79ae3          	bne	a5,a4,5a84 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5a94:	60a2                	ld	ra,8(sp)
    5a96:	6402                	ld	s0,0(sp)
    5a98:	0141                	addi	sp,sp,16
    5a9a:	8082                	ret
    dst += n;
    5a9c:	00c50733          	add	a4,a0,a2
    src += n;
    5aa0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5aa2:	fec059e3          	blez	a2,5a94 <memmove+0x2a>
    5aa6:	fff6079b          	addiw	a5,a2,-1 # 2fff <fourteen+0xef>
    5aaa:	1782                	slli	a5,a5,0x20
    5aac:	9381                	srli	a5,a5,0x20
    5aae:	fff7c793          	not	a5,a5
    5ab2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5ab4:	15fd                	addi	a1,a1,-1
    5ab6:	177d                	addi	a4,a4,-1
    5ab8:	0005c683          	lbu	a3,0(a1)
    5abc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5ac0:	fef71ae3          	bne	a4,a5,5ab4 <memmove+0x4a>
    5ac4:	bfc1                	j	5a94 <memmove+0x2a>

0000000000005ac6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5ac6:	1141                	addi	sp,sp,-16
    5ac8:	e406                	sd	ra,8(sp)
    5aca:	e022                	sd	s0,0(sp)
    5acc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5ace:	ca0d                	beqz	a2,5b00 <memcmp+0x3a>
    5ad0:	fff6069b          	addiw	a3,a2,-1
    5ad4:	1682                	slli	a3,a3,0x20
    5ad6:	9281                	srli	a3,a3,0x20
    5ad8:	0685                	addi	a3,a3,1
    5ada:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5adc:	00054783          	lbu	a5,0(a0)
    5ae0:	0005c703          	lbu	a4,0(a1)
    5ae4:	00e79863          	bne	a5,a4,5af4 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
    5ae8:	0505                	addi	a0,a0,1
    p2++;
    5aea:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5aec:	fed518e3          	bne	a0,a3,5adc <memcmp+0x16>
  }
  return 0;
    5af0:	4501                	li	a0,0
    5af2:	a019                	j	5af8 <memcmp+0x32>
      return *p1 - *p2;
    5af4:	40e7853b          	subw	a0,a5,a4
}
    5af8:	60a2                	ld	ra,8(sp)
    5afa:	6402                	ld	s0,0(sp)
    5afc:	0141                	addi	sp,sp,16
    5afe:	8082                	ret
  return 0;
    5b00:	4501                	li	a0,0
    5b02:	bfdd                	j	5af8 <memcmp+0x32>

0000000000005b04 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5b04:	1141                	addi	sp,sp,-16
    5b06:	e406                	sd	ra,8(sp)
    5b08:	e022                	sd	s0,0(sp)
    5b0a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5b0c:	00000097          	auipc	ra,0x0
    5b10:	f5e080e7          	jalr	-162(ra) # 5a6a <memmove>
}
    5b14:	60a2                	ld	ra,8(sp)
    5b16:	6402                	ld	s0,0(sp)
    5b18:	0141                	addi	sp,sp,16
    5b1a:	8082                	ret

0000000000005b1c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5b1c:	4885                	li	a7,1
 ecall
    5b1e:	00000073          	ecall
 ret
    5b22:	8082                	ret

0000000000005b24 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5b24:	4889                	li	a7,2
 ecall
    5b26:	00000073          	ecall
 ret
    5b2a:	8082                	ret

0000000000005b2c <wait>:
.global wait
wait:
 li a7, SYS_wait
    5b2c:	488d                	li	a7,3
 ecall
    5b2e:	00000073          	ecall
 ret
    5b32:	8082                	ret

0000000000005b34 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5b34:	4891                	li	a7,4
 ecall
    5b36:	00000073          	ecall
 ret
    5b3a:	8082                	ret

0000000000005b3c <read>:
.global read
read:
 li a7, SYS_read
    5b3c:	4895                	li	a7,5
 ecall
    5b3e:	00000073          	ecall
 ret
    5b42:	8082                	ret

0000000000005b44 <write>:
.global write
write:
 li a7, SYS_write
    5b44:	48c1                	li	a7,16
 ecall
    5b46:	00000073          	ecall
 ret
    5b4a:	8082                	ret

0000000000005b4c <close>:
.global close
close:
 li a7, SYS_close
    5b4c:	48d5                	li	a7,21
 ecall
    5b4e:	00000073          	ecall
 ret
    5b52:	8082                	ret

0000000000005b54 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5b54:	4899                	li	a7,6
 ecall
    5b56:	00000073          	ecall
 ret
    5b5a:	8082                	ret

0000000000005b5c <exec>:
.global exec
exec:
 li a7, SYS_exec
    5b5c:	489d                	li	a7,7
 ecall
    5b5e:	00000073          	ecall
 ret
    5b62:	8082                	ret

0000000000005b64 <open>:
.global open
open:
 li a7, SYS_open
    5b64:	48bd                	li	a7,15
 ecall
    5b66:	00000073          	ecall
 ret
    5b6a:	8082                	ret

0000000000005b6c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5b6c:	48c5                	li	a7,17
 ecall
    5b6e:	00000073          	ecall
 ret
    5b72:	8082                	ret

0000000000005b74 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5b74:	48c9                	li	a7,18
 ecall
    5b76:	00000073          	ecall
 ret
    5b7a:	8082                	ret

0000000000005b7c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5b7c:	48a1                	li	a7,8
 ecall
    5b7e:	00000073          	ecall
 ret
    5b82:	8082                	ret

0000000000005b84 <link>:
.global link
link:
 li a7, SYS_link
    5b84:	48cd                	li	a7,19
 ecall
    5b86:	00000073          	ecall
 ret
    5b8a:	8082                	ret

0000000000005b8c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5b8c:	48d1                	li	a7,20
 ecall
    5b8e:	00000073          	ecall
 ret
    5b92:	8082                	ret

0000000000005b94 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5b94:	48a5                	li	a7,9
 ecall
    5b96:	00000073          	ecall
 ret
    5b9a:	8082                	ret

0000000000005b9c <dup>:
.global dup
dup:
 li a7, SYS_dup
    5b9c:	48a9                	li	a7,10
 ecall
    5b9e:	00000073          	ecall
 ret
    5ba2:	8082                	ret

0000000000005ba4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5ba4:	48ad                	li	a7,11
 ecall
    5ba6:	00000073          	ecall
 ret
    5baa:	8082                	ret

0000000000005bac <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5bac:	48b1                	li	a7,12
 ecall
    5bae:	00000073          	ecall
 ret
    5bb2:	8082                	ret

0000000000005bb4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5bb4:	48b5                	li	a7,13
 ecall
    5bb6:	00000073          	ecall
 ret
    5bba:	8082                	ret

0000000000005bbc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5bbc:	48b9                	li	a7,14
 ecall
    5bbe:	00000073          	ecall
 ret
    5bc2:	8082                	ret

0000000000005bc4 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
    5bc4:	48d9                	li	a7,22
 ecall
    5bc6:	00000073          	ecall
 ret
    5bca:	8082                	ret

0000000000005bcc <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
    5bcc:	48dd                	li	a7,23
 ecall
    5bce:	00000073          	ecall
 ret
    5bd2:	8082                	ret

0000000000005bd4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5bd4:	1101                	addi	sp,sp,-32
    5bd6:	ec06                	sd	ra,24(sp)
    5bd8:	e822                	sd	s0,16(sp)
    5bda:	1000                	addi	s0,sp,32
    5bdc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5be0:	4605                	li	a2,1
    5be2:	fef40593          	addi	a1,s0,-17
    5be6:	00000097          	auipc	ra,0x0
    5bea:	f5e080e7          	jalr	-162(ra) # 5b44 <write>
}
    5bee:	60e2                	ld	ra,24(sp)
    5bf0:	6442                	ld	s0,16(sp)
    5bf2:	6105                	addi	sp,sp,32
    5bf4:	8082                	ret

0000000000005bf6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5bf6:	7139                	addi	sp,sp,-64
    5bf8:	fc06                	sd	ra,56(sp)
    5bfa:	f822                	sd	s0,48(sp)
    5bfc:	f426                	sd	s1,40(sp)
    5bfe:	f04a                	sd	s2,32(sp)
    5c00:	ec4e                	sd	s3,24(sp)
    5c02:	0080                	addi	s0,sp,64
    5c04:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5c06:	c299                	beqz	a3,5c0c <printint+0x16>
    5c08:	0805c063          	bltz	a1,5c88 <printint+0x92>
  neg = 0;
    5c0c:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    5c0e:	fc040313          	addi	t1,s0,-64
  neg = 0;
    5c12:	869a                	mv	a3,t1
  i = 0;
    5c14:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    5c16:	00003817          	auipc	a6,0x3
    5c1a:	c6280813          	addi	a6,a6,-926 # 8878 <digits>
    5c1e:	88be                	mv	a7,a5
    5c20:	0017851b          	addiw	a0,a5,1
    5c24:	87aa                	mv	a5,a0
    5c26:	02c5f73b          	remuw	a4,a1,a2
    5c2a:	1702                	slli	a4,a4,0x20
    5c2c:	9301                	srli	a4,a4,0x20
    5c2e:	9742                	add	a4,a4,a6
    5c30:	00074703          	lbu	a4,0(a4)
    5c34:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    5c38:	872e                	mv	a4,a1
    5c3a:	02c5d5bb          	divuw	a1,a1,a2
    5c3e:	0685                	addi	a3,a3,1
    5c40:	fcc77fe3          	bgeu	a4,a2,5c1e <printint+0x28>
  if(neg)
    5c44:	000e0c63          	beqz	t3,5c5c <printint+0x66>
    buf[i++] = '-';
    5c48:	fd050793          	addi	a5,a0,-48
    5c4c:	00878533          	add	a0,a5,s0
    5c50:	02d00793          	li	a5,45
    5c54:	fef50823          	sb	a5,-16(a0)
    5c58:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    5c5c:	fff7899b          	addiw	s3,a5,-1
    5c60:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    5c64:	fff4c583          	lbu	a1,-1(s1)
    5c68:	854a                	mv	a0,s2
    5c6a:	00000097          	auipc	ra,0x0
    5c6e:	f6a080e7          	jalr	-150(ra) # 5bd4 <putc>
  while(--i >= 0)
    5c72:	39fd                	addiw	s3,s3,-1
    5c74:	14fd                	addi	s1,s1,-1
    5c76:	fe09d7e3          	bgez	s3,5c64 <printint+0x6e>
}
    5c7a:	70e2                	ld	ra,56(sp)
    5c7c:	7442                	ld	s0,48(sp)
    5c7e:	74a2                	ld	s1,40(sp)
    5c80:	7902                	ld	s2,32(sp)
    5c82:	69e2                	ld	s3,24(sp)
    5c84:	6121                	addi	sp,sp,64
    5c86:	8082                	ret
    x = -xx;
    5c88:	40b005bb          	negw	a1,a1
    neg = 1;
    5c8c:	4e05                	li	t3,1
    x = -xx;
    5c8e:	b741                	j	5c0e <printint+0x18>

0000000000005c90 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5c90:	715d                	addi	sp,sp,-80
    5c92:	e486                	sd	ra,72(sp)
    5c94:	e0a2                	sd	s0,64(sp)
    5c96:	f84a                	sd	s2,48(sp)
    5c98:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5c9a:	0005c903          	lbu	s2,0(a1)
    5c9e:	1a090a63          	beqz	s2,5e52 <vprintf+0x1c2>
    5ca2:	fc26                	sd	s1,56(sp)
    5ca4:	f44e                	sd	s3,40(sp)
    5ca6:	f052                	sd	s4,32(sp)
    5ca8:	ec56                	sd	s5,24(sp)
    5caa:	e85a                	sd	s6,16(sp)
    5cac:	e45e                	sd	s7,8(sp)
    5cae:	8aaa                	mv	s5,a0
    5cb0:	8bb2                	mv	s7,a2
    5cb2:	00158493          	addi	s1,a1,1
  state = 0;
    5cb6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5cb8:	02500a13          	li	s4,37
    5cbc:	4b55                	li	s6,21
    5cbe:	a839                	j	5cdc <vprintf+0x4c>
        putc(fd, c);
    5cc0:	85ca                	mv	a1,s2
    5cc2:	8556                	mv	a0,s5
    5cc4:	00000097          	auipc	ra,0x0
    5cc8:	f10080e7          	jalr	-240(ra) # 5bd4 <putc>
    5ccc:	a019                	j	5cd2 <vprintf+0x42>
    } else if(state == '%'){
    5cce:	01498d63          	beq	s3,s4,5ce8 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5cd2:	0485                	addi	s1,s1,1
    5cd4:	fff4c903          	lbu	s2,-1(s1)
    5cd8:	16090763          	beqz	s2,5e46 <vprintf+0x1b6>
    if(state == 0){
    5cdc:	fe0999e3          	bnez	s3,5cce <vprintf+0x3e>
      if(c == '%'){
    5ce0:	ff4910e3          	bne	s2,s4,5cc0 <vprintf+0x30>
        state = '%';
    5ce4:	89d2                	mv	s3,s4
    5ce6:	b7f5                	j	5cd2 <vprintf+0x42>
      if(c == 'd'){
    5ce8:	13490463          	beq	s2,s4,5e10 <vprintf+0x180>
    5cec:	f9d9079b          	addiw	a5,s2,-99
    5cf0:	0ff7f793          	zext.b	a5,a5
    5cf4:	12fb6763          	bltu	s6,a5,5e22 <vprintf+0x192>
    5cf8:	f9d9079b          	addiw	a5,s2,-99
    5cfc:	0ff7f713          	zext.b	a4,a5
    5d00:	12eb6163          	bltu	s6,a4,5e22 <vprintf+0x192>
    5d04:	00271793          	slli	a5,a4,0x2
    5d08:	00003717          	auipc	a4,0x3
    5d0c:	b1870713          	addi	a4,a4,-1256 # 8820 <malloc+0x28da>
    5d10:	97ba                	add	a5,a5,a4
    5d12:	439c                	lw	a5,0(a5)
    5d14:	97ba                	add	a5,a5,a4
    5d16:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5d18:	008b8913          	addi	s2,s7,8
    5d1c:	4685                	li	a3,1
    5d1e:	4629                	li	a2,10
    5d20:	000ba583          	lw	a1,0(s7)
    5d24:	8556                	mv	a0,s5
    5d26:	00000097          	auipc	ra,0x0
    5d2a:	ed0080e7          	jalr	-304(ra) # 5bf6 <printint>
    5d2e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5d30:	4981                	li	s3,0
    5d32:	b745                	j	5cd2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5d34:	008b8913          	addi	s2,s7,8
    5d38:	4681                	li	a3,0
    5d3a:	4629                	li	a2,10
    5d3c:	000ba583          	lw	a1,0(s7)
    5d40:	8556                	mv	a0,s5
    5d42:	00000097          	auipc	ra,0x0
    5d46:	eb4080e7          	jalr	-332(ra) # 5bf6 <printint>
    5d4a:	8bca                	mv	s7,s2
      state = 0;
    5d4c:	4981                	li	s3,0
    5d4e:	b751                	j	5cd2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5d50:	008b8913          	addi	s2,s7,8
    5d54:	4681                	li	a3,0
    5d56:	4641                	li	a2,16
    5d58:	000ba583          	lw	a1,0(s7)
    5d5c:	8556                	mv	a0,s5
    5d5e:	00000097          	auipc	ra,0x0
    5d62:	e98080e7          	jalr	-360(ra) # 5bf6 <printint>
    5d66:	8bca                	mv	s7,s2
      state = 0;
    5d68:	4981                	li	s3,0
    5d6a:	b7a5                	j	5cd2 <vprintf+0x42>
    5d6c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5d6e:	008b8c13          	addi	s8,s7,8
    5d72:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5d76:	03000593          	li	a1,48
    5d7a:	8556                	mv	a0,s5
    5d7c:	00000097          	auipc	ra,0x0
    5d80:	e58080e7          	jalr	-424(ra) # 5bd4 <putc>
  putc(fd, 'x');
    5d84:	07800593          	li	a1,120
    5d88:	8556                	mv	a0,s5
    5d8a:	00000097          	auipc	ra,0x0
    5d8e:	e4a080e7          	jalr	-438(ra) # 5bd4 <putc>
    5d92:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5d94:	00003b97          	auipc	s7,0x3
    5d98:	ae4b8b93          	addi	s7,s7,-1308 # 8878 <digits>
    5d9c:	03c9d793          	srli	a5,s3,0x3c
    5da0:	97de                	add	a5,a5,s7
    5da2:	0007c583          	lbu	a1,0(a5)
    5da6:	8556                	mv	a0,s5
    5da8:	00000097          	auipc	ra,0x0
    5dac:	e2c080e7          	jalr	-468(ra) # 5bd4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5db0:	0992                	slli	s3,s3,0x4
    5db2:	397d                	addiw	s2,s2,-1
    5db4:	fe0914e3          	bnez	s2,5d9c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5db8:	8be2                	mv	s7,s8
      state = 0;
    5dba:	4981                	li	s3,0
    5dbc:	6c02                	ld	s8,0(sp)
    5dbe:	bf11                	j	5cd2 <vprintf+0x42>
        s = va_arg(ap, char*);
    5dc0:	008b8993          	addi	s3,s7,8
    5dc4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5dc8:	02090163          	beqz	s2,5dea <vprintf+0x15a>
        while(*s != 0){
    5dcc:	00094583          	lbu	a1,0(s2)
    5dd0:	c9a5                	beqz	a1,5e40 <vprintf+0x1b0>
          putc(fd, *s);
    5dd2:	8556                	mv	a0,s5
    5dd4:	00000097          	auipc	ra,0x0
    5dd8:	e00080e7          	jalr	-512(ra) # 5bd4 <putc>
          s++;
    5ddc:	0905                	addi	s2,s2,1
        while(*s != 0){
    5dde:	00094583          	lbu	a1,0(s2)
    5de2:	f9e5                	bnez	a1,5dd2 <vprintf+0x142>
        s = va_arg(ap, char*);
    5de4:	8bce                	mv	s7,s3
      state = 0;
    5de6:	4981                	li	s3,0
    5de8:	b5ed                	j	5cd2 <vprintf+0x42>
          s = "(null)";
    5dea:	00002917          	auipc	s2,0x2
    5dee:	61e90913          	addi	s2,s2,1566 # 8408 <malloc+0x24c2>
        while(*s != 0){
    5df2:	02800593          	li	a1,40
    5df6:	bff1                	j	5dd2 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5df8:	008b8913          	addi	s2,s7,8
    5dfc:	000bc583          	lbu	a1,0(s7)
    5e00:	8556                	mv	a0,s5
    5e02:	00000097          	auipc	ra,0x0
    5e06:	dd2080e7          	jalr	-558(ra) # 5bd4 <putc>
    5e0a:	8bca                	mv	s7,s2
      state = 0;
    5e0c:	4981                	li	s3,0
    5e0e:	b5d1                	j	5cd2 <vprintf+0x42>
        putc(fd, c);
    5e10:	02500593          	li	a1,37
    5e14:	8556                	mv	a0,s5
    5e16:	00000097          	auipc	ra,0x0
    5e1a:	dbe080e7          	jalr	-578(ra) # 5bd4 <putc>
      state = 0;
    5e1e:	4981                	li	s3,0
    5e20:	bd4d                	j	5cd2 <vprintf+0x42>
        putc(fd, '%');
    5e22:	02500593          	li	a1,37
    5e26:	8556                	mv	a0,s5
    5e28:	00000097          	auipc	ra,0x0
    5e2c:	dac080e7          	jalr	-596(ra) # 5bd4 <putc>
        putc(fd, c);
    5e30:	85ca                	mv	a1,s2
    5e32:	8556                	mv	a0,s5
    5e34:	00000097          	auipc	ra,0x0
    5e38:	da0080e7          	jalr	-608(ra) # 5bd4 <putc>
      state = 0;
    5e3c:	4981                	li	s3,0
    5e3e:	bd51                	j	5cd2 <vprintf+0x42>
        s = va_arg(ap, char*);
    5e40:	8bce                	mv	s7,s3
      state = 0;
    5e42:	4981                	li	s3,0
    5e44:	b579                	j	5cd2 <vprintf+0x42>
    5e46:	74e2                	ld	s1,56(sp)
    5e48:	79a2                	ld	s3,40(sp)
    5e4a:	7a02                	ld	s4,32(sp)
    5e4c:	6ae2                	ld	s5,24(sp)
    5e4e:	6b42                	ld	s6,16(sp)
    5e50:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5e52:	60a6                	ld	ra,72(sp)
    5e54:	6406                	ld	s0,64(sp)
    5e56:	7942                	ld	s2,48(sp)
    5e58:	6161                	addi	sp,sp,80
    5e5a:	8082                	ret

0000000000005e5c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5e5c:	715d                	addi	sp,sp,-80
    5e5e:	ec06                	sd	ra,24(sp)
    5e60:	e822                	sd	s0,16(sp)
    5e62:	1000                	addi	s0,sp,32
    5e64:	e010                	sd	a2,0(s0)
    5e66:	e414                	sd	a3,8(s0)
    5e68:	e818                	sd	a4,16(s0)
    5e6a:	ec1c                	sd	a5,24(s0)
    5e6c:	03043023          	sd	a6,32(s0)
    5e70:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5e74:	8622                	mv	a2,s0
    5e76:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5e7a:	00000097          	auipc	ra,0x0
    5e7e:	e16080e7          	jalr	-490(ra) # 5c90 <vprintf>
}
    5e82:	60e2                	ld	ra,24(sp)
    5e84:	6442                	ld	s0,16(sp)
    5e86:	6161                	addi	sp,sp,80
    5e88:	8082                	ret

0000000000005e8a <printf>:

void
printf(const char *fmt, ...)
{
    5e8a:	711d                	addi	sp,sp,-96
    5e8c:	ec06                	sd	ra,24(sp)
    5e8e:	e822                	sd	s0,16(sp)
    5e90:	1000                	addi	s0,sp,32
    5e92:	e40c                	sd	a1,8(s0)
    5e94:	e810                	sd	a2,16(s0)
    5e96:	ec14                	sd	a3,24(s0)
    5e98:	f018                	sd	a4,32(s0)
    5e9a:	f41c                	sd	a5,40(s0)
    5e9c:	03043823          	sd	a6,48(s0)
    5ea0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5ea4:	00840613          	addi	a2,s0,8
    5ea8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5eac:	85aa                	mv	a1,a0
    5eae:	4505                	li	a0,1
    5eb0:	00000097          	auipc	ra,0x0
    5eb4:	de0080e7          	jalr	-544(ra) # 5c90 <vprintf>
}
    5eb8:	60e2                	ld	ra,24(sp)
    5eba:	6442                	ld	s0,16(sp)
    5ebc:	6125                	addi	sp,sp,96
    5ebe:	8082                	ret

0000000000005ec0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5ec0:	1141                	addi	sp,sp,-16
    5ec2:	e406                	sd	ra,8(sp)
    5ec4:	e022                	sd	s0,0(sp)
    5ec6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5ec8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5ecc:	00003797          	auipc	a5,0x3
    5ed0:	9c47b783          	ld	a5,-1596(a5) # 8890 <freep>
    5ed4:	a02d                	j	5efe <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5ed6:	4618                	lw	a4,8(a2)
    5ed8:	9f2d                	addw	a4,a4,a1
    5eda:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5ede:	6398                	ld	a4,0(a5)
    5ee0:	6310                	ld	a2,0(a4)
    5ee2:	a83d                	j	5f20 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5ee4:	ff852703          	lw	a4,-8(a0)
    5ee8:	9f31                	addw	a4,a4,a2
    5eea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5eec:	ff053683          	ld	a3,-16(a0)
    5ef0:	a091                	j	5f34 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5ef2:	6398                	ld	a4,0(a5)
    5ef4:	00e7e463          	bltu	a5,a4,5efc <free+0x3c>
    5ef8:	00e6ea63          	bltu	a3,a4,5f0c <free+0x4c>
{
    5efc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5efe:	fed7fae3          	bgeu	a5,a3,5ef2 <free+0x32>
    5f02:	6398                	ld	a4,0(a5)
    5f04:	00e6e463          	bltu	a3,a4,5f0c <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f08:	fee7eae3          	bltu	a5,a4,5efc <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    5f0c:	ff852583          	lw	a1,-8(a0)
    5f10:	6390                	ld	a2,0(a5)
    5f12:	02059813          	slli	a6,a1,0x20
    5f16:	01c85713          	srli	a4,a6,0x1c
    5f1a:	9736                	add	a4,a4,a3
    5f1c:	fae60de3          	beq	a2,a4,5ed6 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    5f20:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5f24:	4790                	lw	a2,8(a5)
    5f26:	02061593          	slli	a1,a2,0x20
    5f2a:	01c5d713          	srli	a4,a1,0x1c
    5f2e:	973e                	add	a4,a4,a5
    5f30:	fae68ae3          	beq	a3,a4,5ee4 <free+0x24>
    p->s.ptr = bp->s.ptr;
    5f34:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5f36:	00003717          	auipc	a4,0x3
    5f3a:	94f73d23          	sd	a5,-1702(a4) # 8890 <freep>
}
    5f3e:	60a2                	ld	ra,8(sp)
    5f40:	6402                	ld	s0,0(sp)
    5f42:	0141                	addi	sp,sp,16
    5f44:	8082                	ret

0000000000005f46 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5f46:	7139                	addi	sp,sp,-64
    5f48:	fc06                	sd	ra,56(sp)
    5f4a:	f822                	sd	s0,48(sp)
    5f4c:	f04a                	sd	s2,32(sp)
    5f4e:	ec4e                	sd	s3,24(sp)
    5f50:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5f52:	02051993          	slli	s3,a0,0x20
    5f56:	0209d993          	srli	s3,s3,0x20
    5f5a:	09bd                	addi	s3,s3,15
    5f5c:	0049d993          	srli	s3,s3,0x4
    5f60:	2985                	addiw	s3,s3,1
    5f62:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    5f64:	00003517          	auipc	a0,0x3
    5f68:	92c53503          	ld	a0,-1748(a0) # 8890 <freep>
    5f6c:	c905                	beqz	a0,5f9c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5f6e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5f70:	4798                	lw	a4,8(a5)
    5f72:	09377a63          	bgeu	a4,s3,6006 <malloc+0xc0>
    5f76:	f426                	sd	s1,40(sp)
    5f78:	e852                	sd	s4,16(sp)
    5f7a:	e456                	sd	s5,8(sp)
    5f7c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5f7e:	8a4e                	mv	s4,s3
    5f80:	6705                	lui	a4,0x1
    5f82:	00e9f363          	bgeu	s3,a4,5f88 <malloc+0x42>
    5f86:	6a05                	lui	s4,0x1
    5f88:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5f8c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5f90:	00003497          	auipc	s1,0x3
    5f94:	90048493          	addi	s1,s1,-1792 # 8890 <freep>
  if(p == (char*)-1)
    5f98:	5afd                	li	s5,-1
    5f9a:	a089                	j	5fdc <malloc+0x96>
    5f9c:	f426                	sd	s1,40(sp)
    5f9e:	e852                	sd	s4,16(sp)
    5fa0:	e456                	sd	s5,8(sp)
    5fa2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5fa4:	00009797          	auipc	a5,0x9
    5fa8:	10c78793          	addi	a5,a5,268 # f0b0 <base>
    5fac:	00003717          	auipc	a4,0x3
    5fb0:	8ef73223          	sd	a5,-1820(a4) # 8890 <freep>
    5fb4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5fb6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5fba:	b7d1                	j	5f7e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5fbc:	6398                	ld	a4,0(a5)
    5fbe:	e118                	sd	a4,0(a0)
    5fc0:	a8b9                	j	601e <malloc+0xd8>
  hp->s.size = nu;
    5fc2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5fc6:	0541                	addi	a0,a0,16
    5fc8:	00000097          	auipc	ra,0x0
    5fcc:	ef8080e7          	jalr	-264(ra) # 5ec0 <free>
  return freep;
    5fd0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5fd2:	c135                	beqz	a0,6036 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5fd4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5fd6:	4798                	lw	a4,8(a5)
    5fd8:	03277363          	bgeu	a4,s2,5ffe <malloc+0xb8>
    if(p == freep)
    5fdc:	6098                	ld	a4,0(s1)
    5fde:	853e                	mv	a0,a5
    5fe0:	fef71ae3          	bne	a4,a5,5fd4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    5fe4:	8552                	mv	a0,s4
    5fe6:	00000097          	auipc	ra,0x0
    5fea:	bc6080e7          	jalr	-1082(ra) # 5bac <sbrk>
  if(p == (char*)-1)
    5fee:	fd551ae3          	bne	a0,s5,5fc2 <malloc+0x7c>
        return 0;
    5ff2:	4501                	li	a0,0
    5ff4:	74a2                	ld	s1,40(sp)
    5ff6:	6a42                	ld	s4,16(sp)
    5ff8:	6aa2                	ld	s5,8(sp)
    5ffa:	6b02                	ld	s6,0(sp)
    5ffc:	a03d                	j	602a <malloc+0xe4>
    5ffe:	74a2                	ld	s1,40(sp)
    6000:	6a42                	ld	s4,16(sp)
    6002:	6aa2                	ld	s5,8(sp)
    6004:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    6006:	fae90be3          	beq	s2,a4,5fbc <malloc+0x76>
        p->s.size -= nunits;
    600a:	4137073b          	subw	a4,a4,s3
    600e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6010:	02071693          	slli	a3,a4,0x20
    6014:	01c6d713          	srli	a4,a3,0x1c
    6018:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    601a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    601e:	00003717          	auipc	a4,0x3
    6022:	86a73923          	sd	a0,-1934(a4) # 8890 <freep>
      return (void*)(p + 1);
    6026:	01078513          	addi	a0,a5,16
  }
}
    602a:	70e2                	ld	ra,56(sp)
    602c:	7442                	ld	s0,48(sp)
    602e:	7902                	ld	s2,32(sp)
    6030:	69e2                	ld	s3,24(sp)
    6032:	6121                	addi	sp,sp,64
    6034:	8082                	ret
    6036:	74a2                	ld	s1,40(sp)
    6038:	6a42                	ld	s4,16(sp)
    603a:	6aa2                	ld	s5,8(sp)
    603c:	6b02                	ld	s6,0(sp)
    603e:	b7f5                	j	602a <malloc+0xe4>
