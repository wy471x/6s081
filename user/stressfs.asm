
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	8ea78793          	addi	a5,a5,-1814 # 908 <malloc+0x12a>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	8a450513          	addi	a0,a0,-1884 # 8d8 <malloc+0xfa>
  3c:	00000097          	auipc	ra,0x0
  40:	6e6080e7          	jalr	1766(ra) # 722 <printf>
  memset(data, 'a', sizeof(data));
  44:	20000613          	li	a2,512
  48:	06100593          	li	a1,97
  4c:	dc040513          	addi	a0,s0,-576
  50:	00000097          	auipc	ra,0x0
  54:	14a080e7          	jalr	330(ra) # 19a <memset>

  for(i = 0; i < 4; i++)
  58:	4481                	li	s1,0
  5a:	4911                	li	s2,4
    if(fork() > 0)
  5c:	00000097          	auipc	ra,0x0
  60:	358080e7          	jalr	856(ra) # 3b4 <fork>
  64:	00a04563          	bgtz	a0,6e <main+0x6e>
  for(i = 0; i < 4; i++)
  68:	2485                	addiw	s1,s1,1
  6a:	ff2499e3          	bne	s1,s2,5c <main+0x5c>
      break;

  printf("write %d\n", i);
  6e:	85a6                	mv	a1,s1
  70:	00001517          	auipc	a0,0x1
  74:	88050513          	addi	a0,a0,-1920 # 8f0 <malloc+0x112>
  78:	00000097          	auipc	ra,0x0
  7c:	6aa080e7          	jalr	1706(ra) # 722 <printf>

  path[8] += i;
  80:	fc844783          	lbu	a5,-56(s0)
  84:	9fa5                	addw	a5,a5,s1
  86:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  8a:	20200593          	li	a1,514
  8e:	fc040513          	addi	a0,s0,-64
  92:	00000097          	auipc	ra,0x0
  96:	36a080e7          	jalr	874(ra) # 3fc <open>
  9a:	892a                	mv	s2,a0
  9c:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  9e:	dc040a13          	addi	s4,s0,-576
  a2:	20000993          	li	s3,512
  a6:	864e                	mv	a2,s3
  a8:	85d2                	mv	a1,s4
  aa:	854a                	mv	a0,s2
  ac:	00000097          	auipc	ra,0x0
  b0:	330080e7          	jalr	816(ra) # 3dc <write>
  for(i = 0; i < 20; i++)
  b4:	34fd                	addiw	s1,s1,-1
  b6:	f8e5                	bnez	s1,a6 <main+0xa6>
  close(fd);
  b8:	854a                	mv	a0,s2
  ba:	00000097          	auipc	ra,0x0
  be:	32a080e7          	jalr	810(ra) # 3e4 <close>

  printf("read\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	83e50513          	addi	a0,a0,-1986 # 900 <malloc+0x122>
  ca:	00000097          	auipc	ra,0x0
  ce:	658080e7          	jalr	1624(ra) # 722 <printf>

  fd = open(path, O_RDONLY);
  d2:	4581                	li	a1,0
  d4:	fc040513          	addi	a0,s0,-64
  d8:	00000097          	auipc	ra,0x0
  dc:	324080e7          	jalr	804(ra) # 3fc <open>
  e0:	892a                	mv	s2,a0
  e2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e4:	dc040a13          	addi	s4,s0,-576
  e8:	20000993          	li	s3,512
  ec:	864e                	mv	a2,s3
  ee:	85d2                	mv	a1,s4
  f0:	854a                	mv	a0,s2
  f2:	00000097          	auipc	ra,0x0
  f6:	2e2080e7          	jalr	738(ra) # 3d4 <read>
  for (i = 0; i < 20; i++)
  fa:	34fd                	addiw	s1,s1,-1
  fc:	f8e5                	bnez	s1,ec <main+0xec>
  close(fd);
  fe:	854a                	mv	a0,s2
 100:	00000097          	auipc	ra,0x0
 104:	2e4080e7          	jalr	740(ra) # 3e4 <close>

  wait(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	2ba080e7          	jalr	698(ra) # 3c4 <wait>

  exit(0);
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	2a8080e7          	jalr	680(ra) # 3bc <exit>

000000000000011c <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0xa>
    ;
  return os;
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret

000000000000013c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13c:	1141                	addi	sp,sp,-16
 13e:	e406                	sd	ra,8(sp)
 140:	e022                	sd	s0,0(sp)
 142:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	cb91                	beqz	a5,15c <strcmp+0x20>
 14a:	0005c703          	lbu	a4,0(a1)
 14e:	00f71763          	bne	a4,a5,15c <strcmp+0x20>
    p++, q++;
 152:	0505                	addi	a0,a0,1
 154:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	fbe5                	bnez	a5,14a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 15c:	0005c503          	lbu	a0,0(a1)
}
 160:	40a7853b          	subw	a0,a5,a0
 164:	60a2                	ld	ra,8(sp)
 166:	6402                	ld	s0,0(sp)
 168:	0141                	addi	sp,sp,16
 16a:	8082                	ret

000000000000016c <strlen>:

uint
strlen(const char *s)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e406                	sd	ra,8(sp)
 170:	e022                	sd	s0,0(sp)
 172:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf99                	beqz	a5,196 <strlen+0x2a>
 17a:	0505                	addi	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	addi	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x12>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18e:	60a2                	ld	ra,8(sp)
 190:	6402                	ld	s0,0(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret
  for(n = 0; s[n]; n++)
 196:	4501                	li	a0,0
 198:	bfdd                	j	18e <strlen+0x22>

000000000000019a <memset>:

void*
memset(void *dst, int c, uint n)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a2:	ca19                	beqz	a2,1b8 <memset+0x1e>
 1a4:	87aa                	mv	a5,a0
 1a6:	1602                	slli	a2,a2,0x20
 1a8:	9201                	srli	a2,a2,0x20
 1aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1b2:	0785                	addi	a5,a5,1
 1b4:	fee79de3          	bne	a5,a4,1ae <memset+0x14>
  }
  return dst;
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret

00000000000001c0 <strchr>:

char*
strchr(const char *s, char c)
{
 1c0:	1141                	addi	sp,sp,-16
 1c2:	e406                	sd	ra,8(sp)
 1c4:	e022                	sd	s0,0(sp)
 1c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	cf81                	beqz	a5,1e4 <strchr+0x24>
    if(*s == c)
 1ce:	00f58763          	beq	a1,a5,1dc <strchr+0x1c>
  for(; *s; s++)
 1d2:	0505                	addi	a0,a0,1
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	fbfd                	bnez	a5,1ce <strchr+0xe>
      return (char*)s;
  return 0;
 1da:	4501                	li	a0,0
}
 1dc:	60a2                	ld	ra,8(sp)
 1de:	6402                	ld	s0,0(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  return 0;
 1e4:	4501                	li	a0,0
 1e6:	bfdd                	j	1dc <strchr+0x1c>

00000000000001e8 <gets>:

char*
gets(char *buf, int max)
{
 1e8:	7159                	addi	sp,sp,-112
 1ea:	f486                	sd	ra,104(sp)
 1ec:	f0a2                	sd	s0,96(sp)
 1ee:	eca6                	sd	s1,88(sp)
 1f0:	e8ca                	sd	s2,80(sp)
 1f2:	e4ce                	sd	s3,72(sp)
 1f4:	e0d2                	sd	s4,64(sp)
 1f6:	fc56                	sd	s5,56(sp)
 1f8:	f85a                	sd	s6,48(sp)
 1fa:	f45e                	sd	s7,40(sp)
 1fc:	f062                	sd	s8,32(sp)
 1fe:	ec66                	sd	s9,24(sp)
 200:	e86a                	sd	s10,16(sp)
 202:	1880                	addi	s0,sp,112
 204:	8caa                	mv	s9,a0
 206:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 208:	892a                	mv	s2,a0
 20a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 20c:	f9f40b13          	addi	s6,s0,-97
 210:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 212:	4ba9                	li	s7,10
 214:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 216:	8d26                	mv	s10,s1
 218:	0014899b          	addiw	s3,s1,1
 21c:	84ce                	mv	s1,s3
 21e:	0349d763          	bge	s3,s4,24c <gets+0x64>
    cc = read(0, &c, 1);
 222:	8656                	mv	a2,s5
 224:	85da                	mv	a1,s6
 226:	4501                	li	a0,0
 228:	00000097          	auipc	ra,0x0
 22c:	1ac080e7          	jalr	428(ra) # 3d4 <read>
    if(cc < 1)
 230:	00a05e63          	blez	a0,24c <gets+0x64>
    buf[i++] = c;
 234:	f9f44783          	lbu	a5,-97(s0)
 238:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 23c:	01778763          	beq	a5,s7,24a <gets+0x62>
 240:	0905                	addi	s2,s2,1
 242:	fd879ae3          	bne	a5,s8,216 <gets+0x2e>
    buf[i++] = c;
 246:	8d4e                	mv	s10,s3
 248:	a011                	j	24c <gets+0x64>
 24a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 24c:	9d66                	add	s10,s10,s9
 24e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 252:	8566                	mv	a0,s9
 254:	70a6                	ld	ra,104(sp)
 256:	7406                	ld	s0,96(sp)
 258:	64e6                	ld	s1,88(sp)
 25a:	6946                	ld	s2,80(sp)
 25c:	69a6                	ld	s3,72(sp)
 25e:	6a06                	ld	s4,64(sp)
 260:	7ae2                	ld	s5,56(sp)
 262:	7b42                	ld	s6,48(sp)
 264:	7ba2                	ld	s7,40(sp)
 266:	7c02                	ld	s8,32(sp)
 268:	6ce2                	ld	s9,24(sp)
 26a:	6d42                	ld	s10,16(sp)
 26c:	6165                	addi	sp,sp,112
 26e:	8082                	ret

0000000000000270 <stat>:

int
stat(const char *n, struct stat *st)
{
 270:	1101                	addi	sp,sp,-32
 272:	ec06                	sd	ra,24(sp)
 274:	e822                	sd	s0,16(sp)
 276:	e04a                	sd	s2,0(sp)
 278:	1000                	addi	s0,sp,32
 27a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27c:	4581                	li	a1,0
 27e:	00000097          	auipc	ra,0x0
 282:	17e080e7          	jalr	382(ra) # 3fc <open>
  if(fd < 0)
 286:	02054663          	bltz	a0,2b2 <stat+0x42>
 28a:	e426                	sd	s1,8(sp)
 28c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28e:	85ca                	mv	a1,s2
 290:	00000097          	auipc	ra,0x0
 294:	184080e7          	jalr	388(ra) # 414 <fstat>
 298:	892a                	mv	s2,a0
  close(fd);
 29a:	8526                	mv	a0,s1
 29c:	00000097          	auipc	ra,0x0
 2a0:	148080e7          	jalr	328(ra) # 3e4 <close>
  return r;
 2a4:	64a2                	ld	s1,8(sp)
}
 2a6:	854a                	mv	a0,s2
 2a8:	60e2                	ld	ra,24(sp)
 2aa:	6442                	ld	s0,16(sp)
 2ac:	6902                	ld	s2,0(sp)
 2ae:	6105                	addi	sp,sp,32
 2b0:	8082                	ret
    return -1;
 2b2:	597d                	li	s2,-1
 2b4:	bfcd                	j	2a6 <stat+0x36>

00000000000002b6 <atoi>:

int
atoi(const char *s)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2be:	00054683          	lbu	a3,0(a0)
 2c2:	fd06879b          	addiw	a5,a3,-48
 2c6:	0ff7f793          	zext.b	a5,a5
 2ca:	4625                	li	a2,9
 2cc:	02f66963          	bltu	a2,a5,2fe <atoi+0x48>
 2d0:	872a                	mv	a4,a0
  n = 0;
 2d2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d4:	0705                	addi	a4,a4,1
 2d6:	0025179b          	slliw	a5,a0,0x2
 2da:	9fa9                	addw	a5,a5,a0
 2dc:	0017979b          	slliw	a5,a5,0x1
 2e0:	9fb5                	addw	a5,a5,a3
 2e2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e6:	00074683          	lbu	a3,0(a4)
 2ea:	fd06879b          	addiw	a5,a3,-48
 2ee:	0ff7f793          	zext.b	a5,a5
 2f2:	fef671e3          	bgeu	a2,a5,2d4 <atoi+0x1e>
  return n;
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  n = 0;
 2fe:	4501                	li	a0,0
 300:	bfdd                	j	2f6 <atoi+0x40>

0000000000000302 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 30a:	02b57563          	bgeu	a0,a1,334 <memmove+0x32>
    while(n-- > 0)
 30e:	00c05f63          	blez	a2,32c <memmove+0x2a>
 312:	1602                	slli	a2,a2,0x20
 314:	9201                	srli	a2,a2,0x20
 316:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 31a:	872a                	mv	a4,a0
      *dst++ = *src++;
 31c:	0585                	addi	a1,a1,1
 31e:	0705                	addi	a4,a4,1
 320:	fff5c683          	lbu	a3,-1(a1)
 324:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 328:	fee79ae3          	bne	a5,a4,31c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 32c:	60a2                	ld	ra,8(sp)
 32e:	6402                	ld	s0,0(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
    dst += n;
 334:	00c50733          	add	a4,a0,a2
    src += n;
 338:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 33a:	fec059e3          	blez	a2,32c <memmove+0x2a>
 33e:	fff6079b          	addiw	a5,a2,-1
 342:	1782                	slli	a5,a5,0x20
 344:	9381                	srli	a5,a5,0x20
 346:	fff7c793          	not	a5,a5
 34a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 34c:	15fd                	addi	a1,a1,-1
 34e:	177d                	addi	a4,a4,-1
 350:	0005c683          	lbu	a3,0(a1)
 354:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 358:	fef71ae3          	bne	a4,a5,34c <memmove+0x4a>
 35c:	bfc1                	j	32c <memmove+0x2a>

000000000000035e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 366:	ca0d                	beqz	a2,398 <memcmp+0x3a>
 368:	fff6069b          	addiw	a3,a2,-1
 36c:	1682                	slli	a3,a3,0x20
 36e:	9281                	srli	a3,a3,0x20
 370:	0685                	addi	a3,a3,1
 372:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 374:	00054783          	lbu	a5,0(a0)
 378:	0005c703          	lbu	a4,0(a1)
 37c:	00e79863          	bne	a5,a4,38c <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 380:	0505                	addi	a0,a0,1
    p2++;
 382:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 384:	fed518e3          	bne	a0,a3,374 <memcmp+0x16>
  }
  return 0;
 388:	4501                	li	a0,0
 38a:	a019                	j	390 <memcmp+0x32>
      return *p1 - *p2;
 38c:	40e7853b          	subw	a0,a5,a4
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret
  return 0;
 398:	4501                	li	a0,0
 39a:	bfdd                	j	390 <memcmp+0x32>

000000000000039c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 39c:	1141                	addi	sp,sp,-16
 39e:	e406                	sd	ra,8(sp)
 3a0:	e022                	sd	s0,0(sp)
 3a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3a4:	00000097          	auipc	ra,0x0
 3a8:	f5e080e7          	jalr	-162(ra) # 302 <memmove>
}
 3ac:	60a2                	ld	ra,8(sp)
 3ae:	6402                	ld	s0,0(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret

00000000000003b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b4:	4885                	li	a7,1
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 3bc:	4889                	li	a7,2
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c4:	488d                	li	a7,3
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3cc:	4891                	li	a7,4
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <read>:
.global read
read:
 li a7, SYS_read
 3d4:	4895                	li	a7,5
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <write>:
.global write
write:
 li a7, SYS_write
 3dc:	48c1                	li	a7,16
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <close>:
.global close
close:
 li a7, SYS_close
 3e4:	48d5                	li	a7,21
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ec:	4899                	li	a7,6
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f4:	489d                	li	a7,7
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <open>:
.global open
open:
 li a7, SYS_open
 3fc:	48bd                	li	a7,15
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 404:	48c5                	li	a7,17
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 40c:	48c9                	li	a7,18
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 414:	48a1                	li	a7,8
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <link>:
.global link
link:
 li a7, SYS_link
 41c:	48cd                	li	a7,19
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 424:	48d1                	li	a7,20
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 42c:	48a5                	li	a7,9
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <dup>:
.global dup
dup:
 li a7, SYS_dup
 434:	48a9                	li	a7,10
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 43c:	48ad                	li	a7,11
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 444:	48b1                	li	a7,12
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 44c:	48b5                	li	a7,13
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 454:	48b9                	li	a7,14
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 45c:	48d9                	li	a7,22
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 464:	48dd                	li	a7,23
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	1000                	addi	s0,sp,32
 474:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 478:	4605                	li	a2,1
 47a:	fef40593          	addi	a1,s0,-17
 47e:	00000097          	auipc	ra,0x0
 482:	f5e080e7          	jalr	-162(ra) # 3dc <write>
}
 486:	60e2                	ld	ra,24(sp)
 488:	6442                	ld	s0,16(sp)
 48a:	6105                	addi	sp,sp,32
 48c:	8082                	ret

000000000000048e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48e:	7139                	addi	sp,sp,-64
 490:	fc06                	sd	ra,56(sp)
 492:	f822                	sd	s0,48(sp)
 494:	f426                	sd	s1,40(sp)
 496:	f04a                	sd	s2,32(sp)
 498:	ec4e                	sd	s3,24(sp)
 49a:	0080                	addi	s0,sp,64
 49c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 49e:	c299                	beqz	a3,4a4 <printint+0x16>
 4a0:	0805c063          	bltz	a1,520 <printint+0x92>
  neg = 0;
 4a4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4a6:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4aa:	869a                	mv	a3,t1
  i = 0;
 4ac:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4ae:	00000817          	auipc	a6,0x0
 4b2:	4ca80813          	addi	a6,a6,1226 # 978 <digits>
 4b6:	88be                	mv	a7,a5
 4b8:	0017851b          	addiw	a0,a5,1
 4bc:	87aa                	mv	a5,a0
 4be:	02c5f73b          	remuw	a4,a1,a2
 4c2:	1702                	slli	a4,a4,0x20
 4c4:	9301                	srli	a4,a4,0x20
 4c6:	9742                	add	a4,a4,a6
 4c8:	00074703          	lbu	a4,0(a4)
 4cc:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4d0:	872e                	mv	a4,a1
 4d2:	02c5d5bb          	divuw	a1,a1,a2
 4d6:	0685                	addi	a3,a3,1
 4d8:	fcc77fe3          	bgeu	a4,a2,4b6 <printint+0x28>
  if(neg)
 4dc:	000e0c63          	beqz	t3,4f4 <printint+0x66>
    buf[i++] = '-';
 4e0:	fd050793          	addi	a5,a0,-48
 4e4:	00878533          	add	a0,a5,s0
 4e8:	02d00793          	li	a5,45
 4ec:	fef50823          	sb	a5,-16(a0)
 4f0:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4f4:	fff7899b          	addiw	s3,a5,-1
 4f8:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4fc:	fff4c583          	lbu	a1,-1(s1)
 500:	854a                	mv	a0,s2
 502:	00000097          	auipc	ra,0x0
 506:	f6a080e7          	jalr	-150(ra) # 46c <putc>
  while(--i >= 0)
 50a:	39fd                	addiw	s3,s3,-1
 50c:	14fd                	addi	s1,s1,-1
 50e:	fe09d7e3          	bgez	s3,4fc <printint+0x6e>
}
 512:	70e2                	ld	ra,56(sp)
 514:	7442                	ld	s0,48(sp)
 516:	74a2                	ld	s1,40(sp)
 518:	7902                	ld	s2,32(sp)
 51a:	69e2                	ld	s3,24(sp)
 51c:	6121                	addi	sp,sp,64
 51e:	8082                	ret
    x = -xx;
 520:	40b005bb          	negw	a1,a1
    neg = 1;
 524:	4e05                	li	t3,1
    x = -xx;
 526:	b741                	j	4a6 <printint+0x18>

0000000000000528 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 528:	715d                	addi	sp,sp,-80
 52a:	e486                	sd	ra,72(sp)
 52c:	e0a2                	sd	s0,64(sp)
 52e:	f84a                	sd	s2,48(sp)
 530:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 532:	0005c903          	lbu	s2,0(a1)
 536:	1a090a63          	beqz	s2,6ea <vprintf+0x1c2>
 53a:	fc26                	sd	s1,56(sp)
 53c:	f44e                	sd	s3,40(sp)
 53e:	f052                	sd	s4,32(sp)
 540:	ec56                	sd	s5,24(sp)
 542:	e85a                	sd	s6,16(sp)
 544:	e45e                	sd	s7,8(sp)
 546:	8aaa                	mv	s5,a0
 548:	8bb2                	mv	s7,a2
 54a:	00158493          	addi	s1,a1,1
  state = 0;
 54e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 550:	02500a13          	li	s4,37
 554:	4b55                	li	s6,21
 556:	a839                	j	574 <vprintf+0x4c>
        putc(fd, c);
 558:	85ca                	mv	a1,s2
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	f10080e7          	jalr	-240(ra) # 46c <putc>
 564:	a019                	j	56a <vprintf+0x42>
    } else if(state == '%'){
 566:	01498d63          	beq	s3,s4,580 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 56a:	0485                	addi	s1,s1,1
 56c:	fff4c903          	lbu	s2,-1(s1)
 570:	16090763          	beqz	s2,6de <vprintf+0x1b6>
    if(state == 0){
 574:	fe0999e3          	bnez	s3,566 <vprintf+0x3e>
      if(c == '%'){
 578:	ff4910e3          	bne	s2,s4,558 <vprintf+0x30>
        state = '%';
 57c:	89d2                	mv	s3,s4
 57e:	b7f5                	j	56a <vprintf+0x42>
      if(c == 'd'){
 580:	13490463          	beq	s2,s4,6a8 <vprintf+0x180>
 584:	f9d9079b          	addiw	a5,s2,-99
 588:	0ff7f793          	zext.b	a5,a5
 58c:	12fb6763          	bltu	s6,a5,6ba <vprintf+0x192>
 590:	f9d9079b          	addiw	a5,s2,-99
 594:	0ff7f713          	zext.b	a4,a5
 598:	12eb6163          	bltu	s6,a4,6ba <vprintf+0x192>
 59c:	00271793          	slli	a5,a4,0x2
 5a0:	00000717          	auipc	a4,0x0
 5a4:	38070713          	addi	a4,a4,896 # 920 <malloc+0x142>
 5a8:	97ba                	add	a5,a5,a4
 5aa:	439c                	lw	a5,0(a5)
 5ac:	97ba                	add	a5,a5,a4
 5ae:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	8556                	mv	a0,s5
 5be:	00000097          	auipc	ra,0x0
 5c2:	ed0080e7          	jalr	-304(ra) # 48e <printint>
 5c6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	b745                	j	56a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	008b8913          	addi	s2,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4629                	li	a2,10
 5d4:	000ba583          	lw	a1,0(s7)
 5d8:	8556                	mv	a0,s5
 5da:	00000097          	auipc	ra,0x0
 5de:	eb4080e7          	jalr	-332(ra) # 48e <printint>
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b751                	j	56a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4641                	li	a2,16
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e98080e7          	jalr	-360(ra) # 48e <printint>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	b7a5                	j	56a <vprintf+0x42>
 604:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 606:	008b8c13          	addi	s8,s7,8
 60a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60e:	03000593          	li	a1,48
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e58080e7          	jalr	-424(ra) # 46c <putc>
  putc(fd, 'x');
 61c:	07800593          	li	a1,120
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e4a080e7          	jalr	-438(ra) # 46c <putc>
 62a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 62c:	00000b97          	auipc	s7,0x0
 630:	34cb8b93          	addi	s7,s7,844 # 978 <digits>
 634:	03c9d793          	srli	a5,s3,0x3c
 638:	97de                	add	a5,a5,s7
 63a:	0007c583          	lbu	a1,0(a5)
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	e2c080e7          	jalr	-468(ra) # 46c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 648:	0992                	slli	s3,s3,0x4
 64a:	397d                	addiw	s2,s2,-1
 64c:	fe0914e3          	bnez	s2,634 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 650:	8be2                	mv	s7,s8
      state = 0;
 652:	4981                	li	s3,0
 654:	6c02                	ld	s8,0(sp)
 656:	bf11                	j	56a <vprintf+0x42>
        s = va_arg(ap, char*);
 658:	008b8993          	addi	s3,s7,8
 65c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 660:	02090163          	beqz	s2,682 <vprintf+0x15a>
        while(*s != 0){
 664:	00094583          	lbu	a1,0(s2)
 668:	c9a5                	beqz	a1,6d8 <vprintf+0x1b0>
          putc(fd, *s);
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	e00080e7          	jalr	-512(ra) # 46c <putc>
          s++;
 674:	0905                	addi	s2,s2,1
        while(*s != 0){
 676:	00094583          	lbu	a1,0(s2)
 67a:	f9e5                	bnez	a1,66a <vprintf+0x142>
        s = va_arg(ap, char*);
 67c:	8bce                	mv	s7,s3
      state = 0;
 67e:	4981                	li	s3,0
 680:	b5ed                	j	56a <vprintf+0x42>
          s = "(null)";
 682:	00000917          	auipc	s2,0x0
 686:	29690913          	addi	s2,s2,662 # 918 <malloc+0x13a>
        while(*s != 0){
 68a:	02800593          	li	a1,40
 68e:	bff1                	j	66a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 690:	008b8913          	addi	s2,s7,8
 694:	000bc583          	lbu	a1,0(s7)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	dd2080e7          	jalr	-558(ra) # 46c <putc>
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b5d1                	j	56a <vprintf+0x42>
        putc(fd, c);
 6a8:	02500593          	li	a1,37
 6ac:	8556                	mv	a0,s5
 6ae:	00000097          	auipc	ra,0x0
 6b2:	dbe080e7          	jalr	-578(ra) # 46c <putc>
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bd4d                	j	56a <vprintf+0x42>
        putc(fd, '%');
 6ba:	02500593          	li	a1,37
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	dac080e7          	jalr	-596(ra) # 46c <putc>
        putc(fd, c);
 6c8:	85ca                	mv	a1,s2
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	da0080e7          	jalr	-608(ra) # 46c <putc>
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bd51                	j	56a <vprintf+0x42>
        s = va_arg(ap, char*);
 6d8:	8bce                	mv	s7,s3
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b579                	j	56a <vprintf+0x42>
 6de:	74e2                	ld	s1,56(sp)
 6e0:	79a2                	ld	s3,40(sp)
 6e2:	7a02                	ld	s4,32(sp)
 6e4:	6ae2                	ld	s5,24(sp)
 6e6:	6b42                	ld	s6,16(sp)
 6e8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6ea:	60a6                	ld	ra,72(sp)
 6ec:	6406                	ld	s0,64(sp)
 6ee:	7942                	ld	s2,48(sp)
 6f0:	6161                	addi	sp,sp,80
 6f2:	8082                	ret

00000000000006f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f4:	715d                	addi	sp,sp,-80
 6f6:	ec06                	sd	ra,24(sp)
 6f8:	e822                	sd	s0,16(sp)
 6fa:	1000                	addi	s0,sp,32
 6fc:	e010                	sd	a2,0(s0)
 6fe:	e414                	sd	a3,8(s0)
 700:	e818                	sd	a4,16(s0)
 702:	ec1c                	sd	a5,24(s0)
 704:	03043023          	sd	a6,32(s0)
 708:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 70c:	8622                	mv	a2,s0
 70e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 712:	00000097          	auipc	ra,0x0
 716:	e16080e7          	jalr	-490(ra) # 528 <vprintf>
}
 71a:	60e2                	ld	ra,24(sp)
 71c:	6442                	ld	s0,16(sp)
 71e:	6161                	addi	sp,sp,80
 720:	8082                	ret

0000000000000722 <printf>:

void
printf(const char *fmt, ...)
{
 722:	711d                	addi	sp,sp,-96
 724:	ec06                	sd	ra,24(sp)
 726:	e822                	sd	s0,16(sp)
 728:	1000                	addi	s0,sp,32
 72a:	e40c                	sd	a1,8(s0)
 72c:	e810                	sd	a2,16(s0)
 72e:	ec14                	sd	a3,24(s0)
 730:	f018                	sd	a4,32(s0)
 732:	f41c                	sd	a5,40(s0)
 734:	03043823          	sd	a6,48(s0)
 738:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 73c:	00840613          	addi	a2,s0,8
 740:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 744:	85aa                	mv	a1,a0
 746:	4505                	li	a0,1
 748:	00000097          	auipc	ra,0x0
 74c:	de0080e7          	jalr	-544(ra) # 528 <vprintf>
}
 750:	60e2                	ld	ra,24(sp)
 752:	6442                	ld	s0,16(sp)
 754:	6125                	addi	sp,sp,96
 756:	8082                	ret

0000000000000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	1141                	addi	sp,sp,-16
 75a:	e406                	sd	ra,8(sp)
 75c:	e022                	sd	s0,0(sp)
 75e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 760:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 764:	00000797          	auipc	a5,0x0
 768:	22c7b783          	ld	a5,556(a5) # 990 <freep>
 76c:	a02d                	j	796 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 76e:	4618                	lw	a4,8(a2)
 770:	9f2d                	addw	a4,a4,a1
 772:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 776:	6398                	ld	a4,0(a5)
 778:	6310                	ld	a2,0(a4)
 77a:	a83d                	j	7b8 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 77c:	ff852703          	lw	a4,-8(a0)
 780:	9f31                	addw	a4,a4,a2
 782:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 784:	ff053683          	ld	a3,-16(a0)
 788:	a091                	j	7cc <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78a:	6398                	ld	a4,0(a5)
 78c:	00e7e463          	bltu	a5,a4,794 <free+0x3c>
 790:	00e6ea63          	bltu	a3,a4,7a4 <free+0x4c>
{
 794:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 796:	fed7fae3          	bgeu	a5,a3,78a <free+0x32>
 79a:	6398                	ld	a4,0(a5)
 79c:	00e6e463          	bltu	a3,a4,7a4 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	fee7eae3          	bltu	a5,a4,794 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7a4:	ff852583          	lw	a1,-8(a0)
 7a8:	6390                	ld	a2,0(a5)
 7aa:	02059813          	slli	a6,a1,0x20
 7ae:	01c85713          	srli	a4,a6,0x1c
 7b2:	9736                	add	a4,a4,a3
 7b4:	fae60de3          	beq	a2,a4,76e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7bc:	4790                	lw	a2,8(a5)
 7be:	02061593          	slli	a1,a2,0x20
 7c2:	01c5d713          	srli	a4,a1,0x1c
 7c6:	973e                	add	a4,a4,a5
 7c8:	fae68ae3          	beq	a3,a4,77c <free+0x24>
    p->s.ptr = bp->s.ptr;
 7cc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ce:	00000717          	auipc	a4,0x0
 7d2:	1cf73123          	sd	a5,450(a4) # 990 <freep>
}
 7d6:	60a2                	ld	ra,8(sp)
 7d8:	6402                	ld	s0,0(sp)
 7da:	0141                	addi	sp,sp,16
 7dc:	8082                	ret

00000000000007de <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7de:	7139                	addi	sp,sp,-64
 7e0:	fc06                	sd	ra,56(sp)
 7e2:	f822                	sd	s0,48(sp)
 7e4:	f04a                	sd	s2,32(sp)
 7e6:	ec4e                	sd	s3,24(sp)
 7e8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ea:	02051993          	slli	s3,a0,0x20
 7ee:	0209d993          	srli	s3,s3,0x20
 7f2:	09bd                	addi	s3,s3,15
 7f4:	0049d993          	srli	s3,s3,0x4
 7f8:	2985                	addiw	s3,s3,1
 7fa:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7fc:	00000517          	auipc	a0,0x0
 800:	19453503          	ld	a0,404(a0) # 990 <freep>
 804:	c905                	beqz	a0,834 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 806:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 808:	4798                	lw	a4,8(a5)
 80a:	09377a63          	bgeu	a4,s3,89e <malloc+0xc0>
 80e:	f426                	sd	s1,40(sp)
 810:	e852                	sd	s4,16(sp)
 812:	e456                	sd	s5,8(sp)
 814:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 816:	8a4e                	mv	s4,s3
 818:	6705                	lui	a4,0x1
 81a:	00e9f363          	bgeu	s3,a4,820 <malloc+0x42>
 81e:	6a05                	lui	s4,0x1
 820:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 824:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 828:	00000497          	auipc	s1,0x0
 82c:	16848493          	addi	s1,s1,360 # 990 <freep>
  if(p == (char*)-1)
 830:	5afd                	li	s5,-1
 832:	a089                	j	874 <malloc+0x96>
 834:	f426                	sd	s1,40(sp)
 836:	e852                	sd	s4,16(sp)
 838:	e456                	sd	s5,8(sp)
 83a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 83c:	00000797          	auipc	a5,0x0
 840:	15c78793          	addi	a5,a5,348 # 998 <base>
 844:	00000717          	auipc	a4,0x0
 848:	14f73623          	sd	a5,332(a4) # 990 <freep>
 84c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 852:	b7d1                	j	816 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 854:	6398                	ld	a4,0(a5)
 856:	e118                	sd	a4,0(a0)
 858:	a8b9                	j	8b6 <malloc+0xd8>
  hp->s.size = nu;
 85a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 85e:	0541                	addi	a0,a0,16
 860:	00000097          	auipc	ra,0x0
 864:	ef8080e7          	jalr	-264(ra) # 758 <free>
  return freep;
 868:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 86a:	c135                	beqz	a0,8ce <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86e:	4798                	lw	a4,8(a5)
 870:	03277363          	bgeu	a4,s2,896 <malloc+0xb8>
    if(p == freep)
 874:	6098                	ld	a4,0(s1)
 876:	853e                	mv	a0,a5
 878:	fef71ae3          	bne	a4,a5,86c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 87c:	8552                	mv	a0,s4
 87e:	00000097          	auipc	ra,0x0
 882:	bc6080e7          	jalr	-1082(ra) # 444 <sbrk>
  if(p == (char*)-1)
 886:	fd551ae3          	bne	a0,s5,85a <malloc+0x7c>
        return 0;
 88a:	4501                	li	a0,0
 88c:	74a2                	ld	s1,40(sp)
 88e:	6a42                	ld	s4,16(sp)
 890:	6aa2                	ld	s5,8(sp)
 892:	6b02                	ld	s6,0(sp)
 894:	a03d                	j	8c2 <malloc+0xe4>
 896:	74a2                	ld	s1,40(sp)
 898:	6a42                	ld	s4,16(sp)
 89a:	6aa2                	ld	s5,8(sp)
 89c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89e:	fae90be3          	beq	s2,a4,854 <malloc+0x76>
        p->s.size -= nunits;
 8a2:	4137073b          	subw	a4,a4,s3
 8a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a8:	02071693          	slli	a3,a4,0x20
 8ac:	01c6d713          	srli	a4,a3,0x1c
 8b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b6:	00000717          	auipc	a4,0x0
 8ba:	0ca73d23          	sd	a0,218(a4) # 990 <freep>
      return (void*)(p + 1);
 8be:	01078513          	addi	a0,a5,16
  }
}
 8c2:	70e2                	ld	ra,56(sp)
 8c4:	7442                	ld	s0,48(sp)
 8c6:	7902                	ld	s2,32(sp)
 8c8:	69e2                	ld	s3,24(sp)
 8ca:	6121                	addi	sp,sp,64
 8cc:	8082                	ret
 8ce:	74a2                	ld	s1,40(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	b7f5                	j	8c2 <malloc+0xe4>
