
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	158080e7          	jalr	344(ra) # 164 <strlen>
  14:	862a                	mv	a2,a0
  16:	85a6                	mv	a1,s1
  18:	4505                	li	a0,1
  1a:	00000097          	auipc	ra,0x0
  1e:	3ba080e7          	jalr	954(ra) # 3d4 <write>
}
  22:	60e2                	ld	ra,24(sp)
  24:	6442                	ld	s0,16(sp)
  26:	64a2                	ld	s1,8(sp)
  28:	6105                	addi	sp,sp,32
  2a:	8082                	ret

000000000000002c <forktest>:

void
forktest(void)
{
  2c:	1101                	addi	sp,sp,-32
  2e:	ec06                	sd	ra,24(sp)
  30:	e822                	sd	s0,16(sp)
  32:	e426                	sd	s1,8(sp)
  34:	e04a                	sd	s2,0(sp)
  36:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  38:	00000517          	auipc	a0,0x0
  3c:	43050513          	addi	a0,a0,1072 # 468 <sigreturn+0xc>
  40:	00000097          	auipc	ra,0x0
  44:	fc0080e7          	jalr	-64(ra) # 0 <print>

  for(n=0; n<N; n++){
  48:	4481                	li	s1,0
  4a:	3e800913          	li	s2,1000
    pid = fork();
  4e:	00000097          	auipc	ra,0x0
  52:	35e080e7          	jalr	862(ra) # 3ac <fork>
    if(pid < 0)
  56:	06054163          	bltz	a0,b8 <forktest+0x8c>
      break;
    if(pid == 0)
  5a:	c10d                	beqz	a0,7c <forktest+0x50>
  for(n=0; n<N; n++){
  5c:	2485                	addiw	s1,s1,1
  5e:	ff2498e3          	bne	s1,s2,4e <forktest+0x22>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  62:	00000517          	auipc	a0,0x0
  66:	45650513          	addi	a0,a0,1110 # 4b8 <sigreturn+0x5c>
  6a:	00000097          	auipc	ra,0x0
  6e:	f96080e7          	jalr	-106(ra) # 0 <print>
    exit(1);
  72:	4505                	li	a0,1
  74:	00000097          	auipc	ra,0x0
  78:	340080e7          	jalr	832(ra) # 3b4 <exit>
      exit(0);
  7c:	00000097          	auipc	ra,0x0
  80:	338080e7          	jalr	824(ra) # 3b4 <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
      print("wait stopped early\n");
  84:	00000517          	auipc	a0,0x0
  88:	3f450513          	addi	a0,a0,1012 # 478 <sigreturn+0x1c>
  8c:	00000097          	auipc	ra,0x0
  90:	f74080e7          	jalr	-140(ra) # 0 <print>
      exit(1);
  94:	4505                	li	a0,1
  96:	00000097          	auipc	ra,0x0
  9a:	31e080e7          	jalr	798(ra) # 3b4 <exit>
    }
  }

  if(wait(0) != -1){
    print("wait got too many\n");
  9e:	00000517          	auipc	a0,0x0
  a2:	3f250513          	addi	a0,a0,1010 # 490 <sigreturn+0x34>
  a6:	00000097          	auipc	ra,0x0
  aa:	f5a080e7          	jalr	-166(ra) # 0 <print>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	304080e7          	jalr	772(ra) # 3b4 <exit>
  for(; n > 0; n--){
  b8:	00905b63          	blez	s1,ce <forktest+0xa2>
    if(wait(0) < 0){
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	2fe080e7          	jalr	766(ra) # 3bc <wait>
  c6:	fa054fe3          	bltz	a0,84 <forktest+0x58>
  for(; n > 0; n--){
  ca:	34fd                	addiw	s1,s1,-1
  cc:	f8e5                	bnez	s1,bc <forktest+0x90>
  if(wait(0) != -1){
  ce:	4501                	li	a0,0
  d0:	00000097          	auipc	ra,0x0
  d4:	2ec080e7          	jalr	748(ra) # 3bc <wait>
  d8:	57fd                	li	a5,-1
  da:	fcf512e3          	bne	a0,a5,9e <forktest+0x72>
  }

  print("fork test OK\n");
  de:	00000517          	auipc	a0,0x0
  e2:	3ca50513          	addi	a0,a0,970 # 4a8 <sigreturn+0x4c>
  e6:	00000097          	auipc	ra,0x0
  ea:	f1a080e7          	jalr	-230(ra) # 0 <print>
}
  ee:	60e2                	ld	ra,24(sp)
  f0:	6442                	ld	s0,16(sp)
  f2:	64a2                	ld	s1,8(sp)
  f4:	6902                	ld	s2,0(sp)
  f6:	6105                	addi	sp,sp,32
  f8:	8082                	ret

00000000000000fa <main>:

int
main(void)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  forktest();
 102:	00000097          	auipc	ra,0x0
 106:	f2a080e7          	jalr	-214(ra) # 2c <forktest>
  exit(0);
 10a:	4501                	li	a0,0
 10c:	00000097          	auipc	ra,0x0
 110:	2a8080e7          	jalr	680(ra) # 3b4 <exit>

0000000000000114 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 114:	1141                	addi	sp,sp,-16
 116:	e406                	sd	ra,8(sp)
 118:	e022                	sd	s0,0(sp)
 11a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11c:	87aa                	mv	a5,a0
 11e:	0585                	addi	a1,a1,1
 120:	0785                	addi	a5,a5,1
 122:	fff5c703          	lbu	a4,-1(a1)
 126:	fee78fa3          	sb	a4,-1(a5)
 12a:	fb75                	bnez	a4,11e <strcpy+0xa>
    ;
  return os;
}
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cb91                	beqz	a5,154 <strcmp+0x20>
 142:	0005c703          	lbu	a4,0(a1)
 146:	00f71763          	bne	a4,a5,154 <strcmp+0x20>
    p++, q++;
 14a:	0505                	addi	a0,a0,1
 14c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbe5                	bnez	a5,142 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 154:	0005c503          	lbu	a0,0(a1)
}
 158:	40a7853b          	subw	a0,a5,a0
 15c:	60a2                	ld	ra,8(sp)
 15e:	6402                	ld	s0,0(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strlen>:

uint
strlen(const char *s)
{
 164:	1141                	addi	sp,sp,-16
 166:	e406                	sd	ra,8(sp)
 168:	e022                	sd	s0,0(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf99                	beqz	a5,18e <strlen+0x2a>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	86be                	mv	a3,a5
 178:	0785                	addi	a5,a5,1
 17a:	fff7c703          	lbu	a4,-1(a5)
 17e:	ff65                	bnez	a4,176 <strlen+0x12>
 180:	40a6853b          	subw	a0,a3,a0
 184:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 186:	60a2                	ld	ra,8(sp)
 188:	6402                	ld	s0,0(sp)
 18a:	0141                	addi	sp,sp,16
 18c:	8082                	ret
  for(n = 0; s[n]; n++)
 18e:	4501                	li	a0,0
 190:	bfdd                	j	186 <strlen+0x22>

0000000000000192 <memset>:

void*
memset(void *dst, int c, uint n)
{
 192:	1141                	addi	sp,sp,-16
 194:	e406                	sd	ra,8(sp)
 196:	e022                	sd	s0,0(sp)
 198:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19a:	ca19                	beqz	a2,1b0 <memset+0x1e>
 19c:	87aa                	mv	a5,a0
 19e:	1602                	slli	a2,a2,0x20
 1a0:	9201                	srli	a2,a2,0x20
 1a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1aa:	0785                	addi	a5,a5,1
 1ac:	fee79de3          	bne	a5,a4,1a6 <memset+0x14>
  }
  return dst;
}
 1b0:	60a2                	ld	ra,8(sp)
 1b2:	6402                	ld	s0,0(sp)
 1b4:	0141                	addi	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strchr>:

char*
strchr(const char *s, char c)
{
 1b8:	1141                	addi	sp,sp,-16
 1ba:	e406                	sd	ra,8(sp)
 1bc:	e022                	sd	s0,0(sp)
 1be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cf81                	beqz	a5,1dc <strchr+0x24>
    if(*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1c>
  for(; *s; s++)
 1ca:	0505                	addi	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xe>
      return (char*)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	60a2                	ld	ra,8(sp)
 1d6:	6402                	ld	s0,0(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  return 0;
 1dc:	4501                	li	a0,0
 1de:	bfdd                	j	1d4 <strchr+0x1c>

00000000000001e0 <gets>:

char*
gets(char *buf, int max)
{
 1e0:	7159                	addi	sp,sp,-112
 1e2:	f486                	sd	ra,104(sp)
 1e4:	f0a2                	sd	s0,96(sp)
 1e6:	eca6                	sd	s1,88(sp)
 1e8:	e8ca                	sd	s2,80(sp)
 1ea:	e4ce                	sd	s3,72(sp)
 1ec:	e0d2                	sd	s4,64(sp)
 1ee:	fc56                	sd	s5,56(sp)
 1f0:	f85a                	sd	s6,48(sp)
 1f2:	f45e                	sd	s7,40(sp)
 1f4:	f062                	sd	s8,32(sp)
 1f6:	ec66                	sd	s9,24(sp)
 1f8:	e86a                	sd	s10,16(sp)
 1fa:	1880                	addi	s0,sp,112
 1fc:	8caa                	mv	s9,a0
 1fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 200:	892a                	mv	s2,a0
 202:	4481                	li	s1,0
    cc = read(0, &c, 1);
 204:	f9f40b13          	addi	s6,s0,-97
 208:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20a:	4ba9                	li	s7,10
 20c:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 20e:	8d26                	mv	s10,s1
 210:	0014899b          	addiw	s3,s1,1
 214:	84ce                	mv	s1,s3
 216:	0349d763          	bge	s3,s4,244 <gets+0x64>
    cc = read(0, &c, 1);
 21a:	8656                	mv	a2,s5
 21c:	85da                	mv	a1,s6
 21e:	4501                	li	a0,0
 220:	00000097          	auipc	ra,0x0
 224:	1ac080e7          	jalr	428(ra) # 3cc <read>
    if(cc < 1)
 228:	00a05e63          	blez	a0,244 <gets+0x64>
    buf[i++] = c;
 22c:	f9f44783          	lbu	a5,-97(s0)
 230:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 234:	01778763          	beq	a5,s7,242 <gets+0x62>
 238:	0905                	addi	s2,s2,1
 23a:	fd879ae3          	bne	a5,s8,20e <gets+0x2e>
    buf[i++] = c;
 23e:	8d4e                	mv	s10,s3
 240:	a011                	j	244 <gets+0x64>
 242:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 244:	9d66                	add	s10,s10,s9
 246:	000d0023          	sb	zero,0(s10)
  return buf;
}
 24a:	8566                	mv	a0,s9
 24c:	70a6                	ld	ra,104(sp)
 24e:	7406                	ld	s0,96(sp)
 250:	64e6                	ld	s1,88(sp)
 252:	6946                	ld	s2,80(sp)
 254:	69a6                	ld	s3,72(sp)
 256:	6a06                	ld	s4,64(sp)
 258:	7ae2                	ld	s5,56(sp)
 25a:	7b42                	ld	s6,48(sp)
 25c:	7ba2                	ld	s7,40(sp)
 25e:	7c02                	ld	s8,32(sp)
 260:	6ce2                	ld	s9,24(sp)
 262:	6d42                	ld	s10,16(sp)
 264:	6165                	addi	sp,sp,112
 266:	8082                	ret

0000000000000268 <stat>:

int
stat(const char *n, struct stat *st)
{
 268:	1101                	addi	sp,sp,-32
 26a:	ec06                	sd	ra,24(sp)
 26c:	e822                	sd	s0,16(sp)
 26e:	e04a                	sd	s2,0(sp)
 270:	1000                	addi	s0,sp,32
 272:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 274:	4581                	li	a1,0
 276:	00000097          	auipc	ra,0x0
 27a:	17e080e7          	jalr	382(ra) # 3f4 <open>
  if(fd < 0)
 27e:	02054663          	bltz	a0,2aa <stat+0x42>
 282:	e426                	sd	s1,8(sp)
 284:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 286:	85ca                	mv	a1,s2
 288:	00000097          	auipc	ra,0x0
 28c:	184080e7          	jalr	388(ra) # 40c <fstat>
 290:	892a                	mv	s2,a0
  close(fd);
 292:	8526                	mv	a0,s1
 294:	00000097          	auipc	ra,0x0
 298:	148080e7          	jalr	328(ra) # 3dc <close>
  return r;
 29c:	64a2                	ld	s1,8(sp)
}
 29e:	854a                	mv	a0,s2
 2a0:	60e2                	ld	ra,24(sp)
 2a2:	6442                	ld	s0,16(sp)
 2a4:	6902                	ld	s2,0(sp)
 2a6:	6105                	addi	sp,sp,32
 2a8:	8082                	ret
    return -1;
 2aa:	597d                	li	s2,-1
 2ac:	bfcd                	j	29e <stat+0x36>

00000000000002ae <atoi>:

int
atoi(const char *s)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b6:	00054683          	lbu	a3,0(a0)
 2ba:	fd06879b          	addiw	a5,a3,-48
 2be:	0ff7f793          	zext.b	a5,a5
 2c2:	4625                	li	a2,9
 2c4:	02f66963          	bltu	a2,a5,2f6 <atoi+0x48>
 2c8:	872a                	mv	a4,a0
  n = 0;
 2ca:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2cc:	0705                	addi	a4,a4,1
 2ce:	0025179b          	slliw	a5,a0,0x2
 2d2:	9fa9                	addw	a5,a5,a0
 2d4:	0017979b          	slliw	a5,a5,0x1
 2d8:	9fb5                	addw	a5,a5,a3
 2da:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2de:	00074683          	lbu	a3,0(a4)
 2e2:	fd06879b          	addiw	a5,a3,-48
 2e6:	0ff7f793          	zext.b	a5,a5
 2ea:	fef671e3          	bgeu	a2,a5,2cc <atoi+0x1e>
  return n;
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  n = 0;
 2f6:	4501                	li	a0,0
 2f8:	bfdd                	j	2ee <atoi+0x40>

00000000000002fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 302:	02b57563          	bgeu	a0,a1,32c <memmove+0x32>
    while(n-- > 0)
 306:	00c05f63          	blez	a2,324 <memmove+0x2a>
 30a:	1602                	slli	a2,a2,0x20
 30c:	9201                	srli	a2,a2,0x20
 30e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 312:	872a                	mv	a4,a0
      *dst++ = *src++;
 314:	0585                	addi	a1,a1,1
 316:	0705                	addi	a4,a4,1
 318:	fff5c683          	lbu	a3,-1(a1)
 31c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 320:	fee79ae3          	bne	a5,a4,314 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 324:	60a2                	ld	ra,8(sp)
 326:	6402                	ld	s0,0(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
    dst += n;
 32c:	00c50733          	add	a4,a0,a2
    src += n;
 330:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 332:	fec059e3          	blez	a2,324 <memmove+0x2a>
 336:	fff6079b          	addiw	a5,a2,-1
 33a:	1782                	slli	a5,a5,0x20
 33c:	9381                	srli	a5,a5,0x20
 33e:	fff7c793          	not	a5,a5
 342:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 344:	15fd                	addi	a1,a1,-1
 346:	177d                	addi	a4,a4,-1
 348:	0005c683          	lbu	a3,0(a1)
 34c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 350:	fef71ae3          	bne	a4,a5,344 <memmove+0x4a>
 354:	bfc1                	j	324 <memmove+0x2a>

0000000000000356 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35e:	ca0d                	beqz	a2,390 <memcmp+0x3a>
 360:	fff6069b          	addiw	a3,a2,-1
 364:	1682                	slli	a3,a3,0x20
 366:	9281                	srli	a3,a3,0x20
 368:	0685                	addi	a3,a3,1
 36a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36c:	00054783          	lbu	a5,0(a0)
 370:	0005c703          	lbu	a4,0(a1)
 374:	00e79863          	bne	a5,a4,384 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 378:	0505                	addi	a0,a0,1
    p2++;
 37a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 37c:	fed518e3          	bne	a0,a3,36c <memcmp+0x16>
  }
  return 0;
 380:	4501                	li	a0,0
 382:	a019                	j	388 <memcmp+0x32>
      return *p1 - *p2;
 384:	40e7853b          	subw	a0,a5,a4
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  return 0;
 390:	4501                	li	a0,0
 392:	bfdd                	j	388 <memcmp+0x32>

0000000000000394 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 39c:	00000097          	auipc	ra,0x0
 3a0:	f5e080e7          	jalr	-162(ra) # 2fa <memmove>
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ac:	4885                	li	a7,1
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b4:	4889                	li	a7,2
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3bc:	488d                	li	a7,3
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c4:	4891                	li	a7,4
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <read>:
.global read
read:
 li a7, SYS_read
 3cc:	4895                	li	a7,5
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <write>:
.global write
write:
 li a7, SYS_write
 3d4:	48c1                	li	a7,16
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <close>:
.global close
close:
 li a7, SYS_close
 3dc:	48d5                	li	a7,21
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e4:	4899                	li	a7,6
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ec:	489d                	li	a7,7
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <open>:
.global open
open:
 li a7, SYS_open
 3f4:	48bd                	li	a7,15
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fc:	48c5                	li	a7,17
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 404:	48c9                	li	a7,18
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40c:	48a1                	li	a7,8
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <link>:
.global link
link:
 li a7, SYS_link
 414:	48cd                	li	a7,19
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41c:	48d1                	li	a7,20
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 424:	48a5                	li	a7,9
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <dup>:
.global dup
dup:
 li a7, SYS_dup
 42c:	48a9                	li	a7,10
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 434:	48ad                	li	a7,11
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43c:	48b1                	li	a7,12
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 444:	48b5                	li	a7,13
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44c:	48b9                	li	a7,14
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 454:	48d9                	li	a7,22
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 45c:	48dd                	li	a7,23
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret
