
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	89a50513          	addi	a0,a0,-1894 # 8a8 <malloc+0xfe>
  16:	00000097          	auipc	ra,0x0
  1a:	3c2080e7          	jalr	962(ra) # 3d8 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3ec080e7          	jalr	1004(ra) # 410 <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3e2080e7          	jalr	994(ra) # 410 <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	87a90913          	addi	s2,s2,-1926 # 8b0 <malloc+0x106>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6ae080e7          	jalr	1710(ra) # 6ee <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	348080e7          	jalr	840(ra) # 390 <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	346080e7          	jalr	838(ra) # 3a0 <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	89650513          	addi	a0,a0,-1898 # 900 <malloc+0x156>
  72:	00000097          	auipc	ra,0x0
  76:	67c080e7          	jalr	1660(ra) # 6ee <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	31c080e7          	jalr	796(ra) # 398 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	82050513          	addi	a0,a0,-2016 # 8a8 <malloc+0xfe>
  90:	00000097          	auipc	ra,0x0
  94:	350080e7          	jalr	848(ra) # 3e0 <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	80e50513          	addi	a0,a0,-2034 # 8a8 <malloc+0xfe>
  a2:	00000097          	auipc	ra,0x0
  a6:	336080e7          	jalr	822(ra) # 3d8 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	81c50513          	addi	a0,a0,-2020 # 8c8 <malloc+0x11e>
  b4:	00000097          	auipc	ra,0x0
  b8:	63a080e7          	jalr	1594(ra) # 6ee <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2da080e7          	jalr	730(ra) # 398 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	8d258593          	addi	a1,a1,-1838 # 998 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	81250513          	addi	a0,a0,-2030 # 8e0 <malloc+0x136>
  d6:	00000097          	auipc	ra,0x0
  da:	2fa080e7          	jalr	762(ra) # 3d0 <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	80a50513          	addi	a0,a0,-2038 # 8e8 <malloc+0x13e>
  e6:	00000097          	auipc	ra,0x0
  ea:	608080e7          	jalr	1544(ra) # 6ee <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	2a8080e7          	jalr	680(ra) # 398 <exit>

00000000000000f8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0xa>
    ;
  return os;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb91                	beqz	a5,138 <strcmp+0x20>
 126:	0005c703          	lbu	a4,0(a1)
 12a:	00f71763          	bne	a4,a5,138 <strcmp+0x20>
    p++, q++;
 12e:	0505                	addi	a0,a0,1
 130:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	fbe5                	bnez	a5,126 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 138:	0005c503          	lbu	a0,0(a1)
}
 13c:	40a7853b          	subw	a0,a5,a0
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf99                	beqz	a5,172 <strlen+0x2a>
 156:	0505                	addi	a0,a0,1
 158:	87aa                	mv	a5,a0
 15a:	86be                	mv	a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	ff65                	bnez	a4,15a <strlen+0x12>
 164:	40a6853b          	subw	a0,a3,a0
 168:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret
  for(n = 0; s[n]; n++)
 172:	4501                	li	a0,0
 174:	bfdd                	j	16a <strlen+0x22>

0000000000000176 <memset>:

void*
memset(void *dst, int c, uint n)
{
 176:	1141                	addi	sp,sp,-16
 178:	e406                	sd	ra,8(sp)
 17a:	e022                	sd	s0,0(sp)
 17c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17e:	ca19                	beqz	a2,194 <memset+0x1e>
 180:	87aa                	mv	a5,a0
 182:	1602                	slli	a2,a2,0x20
 184:	9201                	srli	a2,a2,0x20
 186:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 18a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18e:	0785                	addi	a5,a5,1
 190:	fee79de3          	bne	a5,a4,18a <memset+0x14>
  }
  return dst;
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <strchr>:

char*
strchr(const char *s, char c)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	cf81                	beqz	a5,1c0 <strchr+0x24>
    if(*s == c)
 1aa:	00f58763          	beq	a1,a5,1b8 <strchr+0x1c>
  for(; *s; s++)
 1ae:	0505                	addi	a0,a0,1
 1b0:	00054783          	lbu	a5,0(a0)
 1b4:	fbfd                	bnez	a5,1aa <strchr+0xe>
      return (char*)s;
  return 0;
 1b6:	4501                	li	a0,0
}
 1b8:	60a2                	ld	ra,8(sp)
 1ba:	6402                	ld	s0,0(sp)
 1bc:	0141                	addi	sp,sp,16
 1be:	8082                	ret
  return 0;
 1c0:	4501                	li	a0,0
 1c2:	bfdd                	j	1b8 <strchr+0x1c>

00000000000001c4 <gets>:

char*
gets(char *buf, int max)
{
 1c4:	7159                	addi	sp,sp,-112
 1c6:	f486                	sd	ra,104(sp)
 1c8:	f0a2                	sd	s0,96(sp)
 1ca:	eca6                	sd	s1,88(sp)
 1cc:	e8ca                	sd	s2,80(sp)
 1ce:	e4ce                	sd	s3,72(sp)
 1d0:	e0d2                	sd	s4,64(sp)
 1d2:	fc56                	sd	s5,56(sp)
 1d4:	f85a                	sd	s6,48(sp)
 1d6:	f45e                	sd	s7,40(sp)
 1d8:	f062                	sd	s8,32(sp)
 1da:	ec66                	sd	s9,24(sp)
 1dc:	e86a                	sd	s10,16(sp)
 1de:	1880                	addi	s0,sp,112
 1e0:	8caa                	mv	s9,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e8:	f9f40b13          	addi	s6,s0,-97
 1ec:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ee:	4ba9                	li	s7,10
 1f0:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 1f2:	8d26                	mv	s10,s1
 1f4:	0014899b          	addiw	s3,s1,1
 1f8:	84ce                	mv	s1,s3
 1fa:	0349d763          	bge	s3,s4,228 <gets+0x64>
    cc = read(0, &c, 1);
 1fe:	8656                	mv	a2,s5
 200:	85da                	mv	a1,s6
 202:	4501                	li	a0,0
 204:	00000097          	auipc	ra,0x0
 208:	1ac080e7          	jalr	428(ra) # 3b0 <read>
    if(cc < 1)
 20c:	00a05e63          	blez	a0,228 <gets+0x64>
    buf[i++] = c;
 210:	f9f44783          	lbu	a5,-97(s0)
 214:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 218:	01778763          	beq	a5,s7,226 <gets+0x62>
 21c:	0905                	addi	s2,s2,1
 21e:	fd879ae3          	bne	a5,s8,1f2 <gets+0x2e>
    buf[i++] = c;
 222:	8d4e                	mv	s10,s3
 224:	a011                	j	228 <gets+0x64>
 226:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 228:	9d66                	add	s10,s10,s9
 22a:	000d0023          	sb	zero,0(s10)
  return buf;
}
 22e:	8566                	mv	a0,s9
 230:	70a6                	ld	ra,104(sp)
 232:	7406                	ld	s0,96(sp)
 234:	64e6                	ld	s1,88(sp)
 236:	6946                	ld	s2,80(sp)
 238:	69a6                	ld	s3,72(sp)
 23a:	6a06                	ld	s4,64(sp)
 23c:	7ae2                	ld	s5,56(sp)
 23e:	7b42                	ld	s6,48(sp)
 240:	7ba2                	ld	s7,40(sp)
 242:	7c02                	ld	s8,32(sp)
 244:	6ce2                	ld	s9,24(sp)
 246:	6d42                	ld	s10,16(sp)
 248:	6165                	addi	sp,sp,112
 24a:	8082                	ret

000000000000024c <stat>:

int
stat(const char *n, struct stat *st)
{
 24c:	1101                	addi	sp,sp,-32
 24e:	ec06                	sd	ra,24(sp)
 250:	e822                	sd	s0,16(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	00000097          	auipc	ra,0x0
 25e:	17e080e7          	jalr	382(ra) # 3d8 <open>
  if(fd < 0)
 262:	02054663          	bltz	a0,28e <stat+0x42>
 266:	e426                	sd	s1,8(sp)
 268:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26a:	85ca                	mv	a1,s2
 26c:	00000097          	auipc	ra,0x0
 270:	184080e7          	jalr	388(ra) # 3f0 <fstat>
 274:	892a                	mv	s2,a0
  close(fd);
 276:	8526                	mv	a0,s1
 278:	00000097          	auipc	ra,0x0
 27c:	148080e7          	jalr	328(ra) # 3c0 <close>
  return r;
 280:	64a2                	ld	s1,8(sp)
}
 282:	854a                	mv	a0,s2
 284:	60e2                	ld	ra,24(sp)
 286:	6442                	ld	s0,16(sp)
 288:	6902                	ld	s2,0(sp)
 28a:	6105                	addi	sp,sp,32
 28c:	8082                	ret
    return -1;
 28e:	597d                	li	s2,-1
 290:	bfcd                	j	282 <stat+0x36>

0000000000000292 <atoi>:

int
atoi(const char *s)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29a:	00054683          	lbu	a3,0(a0)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	4625                	li	a2,9
 2a8:	02f66963          	bltu	a2,a5,2da <atoi+0x48>
 2ac:	872a                	mv	a4,a0
  n = 0;
 2ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b0:	0705                	addi	a4,a4,1
 2b2:	0025179b          	slliw	a5,a0,0x2
 2b6:	9fa9                	addw	a5,a5,a0
 2b8:	0017979b          	slliw	a5,a5,0x1
 2bc:	9fb5                	addw	a5,a5,a3
 2be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c2:	00074683          	lbu	a3,0(a4)
 2c6:	fd06879b          	addiw	a5,a3,-48
 2ca:	0ff7f793          	zext.b	a5,a5
 2ce:	fef671e3          	bgeu	a2,a5,2b0 <atoi+0x1e>
  return n;
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfdd                	j	2d2 <atoi+0x40>

00000000000002de <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57563          	bgeu	a0,a1,310 <memmove+0x32>
    while(n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x2a>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    dst += n;
 310:	00c50733          	add	a4,a0,a2
    src += n;
 314:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 316:	fec059e3          	blez	a2,308 <memmove+0x2a>
 31a:	fff6079b          	addiw	a5,a2,-1
 31e:	1782                	slli	a5,a5,0x20
 320:	9381                	srli	a5,a5,0x20
 322:	fff7c793          	not	a5,a5
 326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 328:	15fd                	addi	a1,a1,-1
 32a:	177d                	addi	a4,a4,-1
 32c:	0005c683          	lbu	a3,0(a1)
 330:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 334:	fef71ae3          	bne	a4,a5,328 <memmove+0x4a>
 338:	bfc1                	j	308 <memmove+0x2a>

000000000000033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 342:	ca0d                	beqz	a2,374 <memcmp+0x3a>
 344:	fff6069b          	addiw	a3,a2,-1
 348:	1682                	slli	a3,a3,0x20
 34a:	9281                	srli	a3,a3,0x20
 34c:	0685                	addi	a3,a3,1
 34e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 350:	00054783          	lbu	a5,0(a0)
 354:	0005c703          	lbu	a4,0(a1)
 358:	00e79863          	bne	a5,a4,368 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 35c:	0505                	addi	a0,a0,1
    p2++;
 35e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 360:	fed518e3          	bne	a0,a3,350 <memcmp+0x16>
  }
  return 0;
 364:	4501                	li	a0,0
 366:	a019                	j	36c <memcmp+0x32>
      return *p1 - *p2;
 368:	40e7853b          	subw	a0,a5,a4
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret
  return 0;
 374:	4501                	li	a0,0
 376:	bfdd                	j	36c <memcmp+0x32>

0000000000000378 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e406                	sd	ra,8(sp)
 37c:	e022                	sd	s0,0(sp)
 37e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 380:	00000097          	auipc	ra,0x0
 384:	f5e080e7          	jalr	-162(ra) # 2de <memmove>
}
 388:	60a2                	ld	ra,8(sp)
 38a:	6402                	ld	s0,0(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret

0000000000000390 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 390:	4885                	li	a7,1
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <exit>:
.global exit
exit:
 li a7, SYS_exit
 398:	4889                	li	a7,2
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a0:	488d                	li	a7,3
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a8:	4891                	li	a7,4
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <read>:
.global read
read:
 li a7, SYS_read
 3b0:	4895                	li	a7,5
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <write>:
.global write
write:
 li a7, SYS_write
 3b8:	48c1                	li	a7,16
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <close>:
.global close
close:
 li a7, SYS_close
 3c0:	48d5                	li	a7,21
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c8:	4899                	li	a7,6
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d0:	489d                	li	a7,7
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <open>:
.global open
open:
 li a7, SYS_open
 3d8:	48bd                	li	a7,15
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e0:	48c5                	li	a7,17
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e8:	48c9                	li	a7,18
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f0:	48a1                	li	a7,8
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <link>:
.global link
link:
 li a7, SYS_link
 3f8:	48cd                	li	a7,19
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 400:	48d1                	li	a7,20
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 408:	48a5                	li	a7,9
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <dup>:
.global dup
dup:
 li a7, SYS_dup
 410:	48a9                	li	a7,10
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 418:	48ad                	li	a7,11
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 420:	48b1                	li	a7,12
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 428:	48b5                	li	a7,13
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 430:	48b9                	li	a7,14
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 438:	1101                	addi	sp,sp,-32
 43a:	ec06                	sd	ra,24(sp)
 43c:	e822                	sd	s0,16(sp)
 43e:	1000                	addi	s0,sp,32
 440:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 444:	4605                	li	a2,1
 446:	fef40593          	addi	a1,s0,-17
 44a:	00000097          	auipc	ra,0x0
 44e:	f6e080e7          	jalr	-146(ra) # 3b8 <write>
}
 452:	60e2                	ld	ra,24(sp)
 454:	6442                	ld	s0,16(sp)
 456:	6105                	addi	sp,sp,32
 458:	8082                	ret

000000000000045a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45a:	7139                	addi	sp,sp,-64
 45c:	fc06                	sd	ra,56(sp)
 45e:	f822                	sd	s0,48(sp)
 460:	f426                	sd	s1,40(sp)
 462:	f04a                	sd	s2,32(sp)
 464:	ec4e                	sd	s3,24(sp)
 466:	0080                	addi	s0,sp,64
 468:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46a:	c299                	beqz	a3,470 <printint+0x16>
 46c:	0805c063          	bltz	a1,4ec <printint+0x92>
  neg = 0;
 470:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 472:	fc040313          	addi	t1,s0,-64
  neg = 0;
 476:	869a                	mv	a3,t1
  i = 0;
 478:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 47a:	00000817          	auipc	a6,0x0
 47e:	50680813          	addi	a6,a6,1286 # 980 <digits>
 482:	88be                	mv	a7,a5
 484:	0017851b          	addiw	a0,a5,1
 488:	87aa                	mv	a5,a0
 48a:	02c5f73b          	remuw	a4,a1,a2
 48e:	1702                	slli	a4,a4,0x20
 490:	9301                	srli	a4,a4,0x20
 492:	9742                	add	a4,a4,a6
 494:	00074703          	lbu	a4,0(a4)
 498:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 49c:	872e                	mv	a4,a1
 49e:	02c5d5bb          	divuw	a1,a1,a2
 4a2:	0685                	addi	a3,a3,1
 4a4:	fcc77fe3          	bgeu	a4,a2,482 <printint+0x28>
  if(neg)
 4a8:	000e0c63          	beqz	t3,4c0 <printint+0x66>
    buf[i++] = '-';
 4ac:	fd050793          	addi	a5,a0,-48
 4b0:	00878533          	add	a0,a5,s0
 4b4:	02d00793          	li	a5,45
 4b8:	fef50823          	sb	a5,-16(a0)
 4bc:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 4c0:	fff7899b          	addiw	s3,a5,-1
 4c4:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 4c8:	fff4c583          	lbu	a1,-1(s1)
 4cc:	854a                	mv	a0,s2
 4ce:	00000097          	auipc	ra,0x0
 4d2:	f6a080e7          	jalr	-150(ra) # 438 <putc>
  while(--i >= 0)
 4d6:	39fd                	addiw	s3,s3,-1
 4d8:	14fd                	addi	s1,s1,-1
 4da:	fe09d7e3          	bgez	s3,4c8 <printint+0x6e>
}
 4de:	70e2                	ld	ra,56(sp)
 4e0:	7442                	ld	s0,48(sp)
 4e2:	74a2                	ld	s1,40(sp)
 4e4:	7902                	ld	s2,32(sp)
 4e6:	69e2                	ld	s3,24(sp)
 4e8:	6121                	addi	sp,sp,64
 4ea:	8082                	ret
    x = -xx;
 4ec:	40b005bb          	negw	a1,a1
    neg = 1;
 4f0:	4e05                	li	t3,1
    x = -xx;
 4f2:	b741                	j	472 <printint+0x18>

00000000000004f4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f4:	715d                	addi	sp,sp,-80
 4f6:	e486                	sd	ra,72(sp)
 4f8:	e0a2                	sd	s0,64(sp)
 4fa:	f84a                	sd	s2,48(sp)
 4fc:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fe:	0005c903          	lbu	s2,0(a1)
 502:	1a090a63          	beqz	s2,6b6 <vprintf+0x1c2>
 506:	fc26                	sd	s1,56(sp)
 508:	f44e                	sd	s3,40(sp)
 50a:	f052                	sd	s4,32(sp)
 50c:	ec56                	sd	s5,24(sp)
 50e:	e85a                	sd	s6,16(sp)
 510:	e45e                	sd	s7,8(sp)
 512:	8aaa                	mv	s5,a0
 514:	8bb2                	mv	s7,a2
 516:	00158493          	addi	s1,a1,1
  state = 0;
 51a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 51c:	02500a13          	li	s4,37
 520:	4b55                	li	s6,21
 522:	a839                	j	540 <vprintf+0x4c>
        putc(fd, c);
 524:	85ca                	mv	a1,s2
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	f10080e7          	jalr	-240(ra) # 438 <putc>
 530:	a019                	j	536 <vprintf+0x42>
    } else if(state == '%'){
 532:	01498d63          	beq	s3,s4,54c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 536:	0485                	addi	s1,s1,1
 538:	fff4c903          	lbu	s2,-1(s1)
 53c:	16090763          	beqz	s2,6aa <vprintf+0x1b6>
    if(state == 0){
 540:	fe0999e3          	bnez	s3,532 <vprintf+0x3e>
      if(c == '%'){
 544:	ff4910e3          	bne	s2,s4,524 <vprintf+0x30>
        state = '%';
 548:	89d2                	mv	s3,s4
 54a:	b7f5                	j	536 <vprintf+0x42>
      if(c == 'd'){
 54c:	13490463          	beq	s2,s4,674 <vprintf+0x180>
 550:	f9d9079b          	addiw	a5,s2,-99
 554:	0ff7f793          	zext.b	a5,a5
 558:	12fb6763          	bltu	s6,a5,686 <vprintf+0x192>
 55c:	f9d9079b          	addiw	a5,s2,-99
 560:	0ff7f713          	zext.b	a4,a5
 564:	12eb6163          	bltu	s6,a4,686 <vprintf+0x192>
 568:	00271793          	slli	a5,a4,0x2
 56c:	00000717          	auipc	a4,0x0
 570:	3bc70713          	addi	a4,a4,956 # 928 <malloc+0x17e>
 574:	97ba                	add	a5,a5,a4
 576:	439c                	lw	a5,0(a5)
 578:	97ba                	add	a5,a5,a4
 57a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 57c:	008b8913          	addi	s2,s7,8
 580:	4685                	li	a3,1
 582:	4629                	li	a2,10
 584:	000ba583          	lw	a1,0(s7)
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	ed0080e7          	jalr	-304(ra) # 45a <printint>
 592:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 594:	4981                	li	s3,0
 596:	b745                	j	536 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 598:	008b8913          	addi	s2,s7,8
 59c:	4681                	li	a3,0
 59e:	4629                	li	a2,10
 5a0:	000ba583          	lw	a1,0(s7)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	eb4080e7          	jalr	-332(ra) # 45a <printint>
 5ae:	8bca                	mv	s7,s2
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b751                	j	536 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5b4:	008b8913          	addi	s2,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4641                	li	a2,16
 5bc:	000ba583          	lw	a1,0(s7)
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e98080e7          	jalr	-360(ra) # 45a <printint>
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	b7a5                	j	536 <vprintf+0x42>
 5d0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5d2:	008b8c13          	addi	s8,s7,8
 5d6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5da:	03000593          	li	a1,48
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	e58080e7          	jalr	-424(ra) # 438 <putc>
  putc(fd, 'x');
 5e8:	07800593          	li	a1,120
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e4a080e7          	jalr	-438(ra) # 438 <putc>
 5f6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f8:	00000b97          	auipc	s7,0x0
 5fc:	388b8b93          	addi	s7,s7,904 # 980 <digits>
 600:	03c9d793          	srli	a5,s3,0x3c
 604:	97de                	add	a5,a5,s7
 606:	0007c583          	lbu	a1,0(a5)
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e2c080e7          	jalr	-468(ra) # 438 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 614:	0992                	slli	s3,s3,0x4
 616:	397d                	addiw	s2,s2,-1
 618:	fe0914e3          	bnez	s2,600 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 61c:	8be2                	mv	s7,s8
      state = 0;
 61e:	4981                	li	s3,0
 620:	6c02                	ld	s8,0(sp)
 622:	bf11                	j	536 <vprintf+0x42>
        s = va_arg(ap, char*);
 624:	008b8993          	addi	s3,s7,8
 628:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 62c:	02090163          	beqz	s2,64e <vprintf+0x15a>
        while(*s != 0){
 630:	00094583          	lbu	a1,0(s2)
 634:	c9a5                	beqz	a1,6a4 <vprintf+0x1b0>
          putc(fd, *s);
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	e00080e7          	jalr	-512(ra) # 438 <putc>
          s++;
 640:	0905                	addi	s2,s2,1
        while(*s != 0){
 642:	00094583          	lbu	a1,0(s2)
 646:	f9e5                	bnez	a1,636 <vprintf+0x142>
        s = va_arg(ap, char*);
 648:	8bce                	mv	s7,s3
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b5ed                	j	536 <vprintf+0x42>
          s = "(null)";
 64e:	00000917          	auipc	s2,0x0
 652:	2d290913          	addi	s2,s2,722 # 920 <malloc+0x176>
        while(*s != 0){
 656:	02800593          	li	a1,40
 65a:	bff1                	j	636 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 65c:	008b8913          	addi	s2,s7,8
 660:	000bc583          	lbu	a1,0(s7)
 664:	8556                	mv	a0,s5
 666:	00000097          	auipc	ra,0x0
 66a:	dd2080e7          	jalr	-558(ra) # 438 <putc>
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
 672:	b5d1                	j	536 <vprintf+0x42>
        putc(fd, c);
 674:	02500593          	li	a1,37
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	dbe080e7          	jalr	-578(ra) # 438 <putc>
      state = 0;
 682:	4981                	li	s3,0
 684:	bd4d                	j	536 <vprintf+0x42>
        putc(fd, '%');
 686:	02500593          	li	a1,37
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	dac080e7          	jalr	-596(ra) # 438 <putc>
        putc(fd, c);
 694:	85ca                	mv	a1,s2
 696:	8556                	mv	a0,s5
 698:	00000097          	auipc	ra,0x0
 69c:	da0080e7          	jalr	-608(ra) # 438 <putc>
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	bd51                	j	536 <vprintf+0x42>
        s = va_arg(ap, char*);
 6a4:	8bce                	mv	s7,s3
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b579                	j	536 <vprintf+0x42>
 6aa:	74e2                	ld	s1,56(sp)
 6ac:	79a2                	ld	s3,40(sp)
 6ae:	7a02                	ld	s4,32(sp)
 6b0:	6ae2                	ld	s5,24(sp)
 6b2:	6b42                	ld	s6,16(sp)
 6b4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6b6:	60a6                	ld	ra,72(sp)
 6b8:	6406                	ld	s0,64(sp)
 6ba:	7942                	ld	s2,48(sp)
 6bc:	6161                	addi	sp,sp,80
 6be:	8082                	ret

00000000000006c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c0:	715d                	addi	sp,sp,-80
 6c2:	ec06                	sd	ra,24(sp)
 6c4:	e822                	sd	s0,16(sp)
 6c6:	1000                	addi	s0,sp,32
 6c8:	e010                	sd	a2,0(s0)
 6ca:	e414                	sd	a3,8(s0)
 6cc:	e818                	sd	a4,16(s0)
 6ce:	ec1c                	sd	a5,24(s0)
 6d0:	03043023          	sd	a6,32(s0)
 6d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d8:	8622                	mv	a2,s0
 6da:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6de:	00000097          	auipc	ra,0x0
 6e2:	e16080e7          	jalr	-490(ra) # 4f4 <vprintf>
}
 6e6:	60e2                	ld	ra,24(sp)
 6e8:	6442                	ld	s0,16(sp)
 6ea:	6161                	addi	sp,sp,80
 6ec:	8082                	ret

00000000000006ee <printf>:

void
printf(const char *fmt, ...)
{
 6ee:	711d                	addi	sp,sp,-96
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	e822                	sd	s0,16(sp)
 6f4:	1000                	addi	s0,sp,32
 6f6:	e40c                	sd	a1,8(s0)
 6f8:	e810                	sd	a2,16(s0)
 6fa:	ec14                	sd	a3,24(s0)
 6fc:	f018                	sd	a4,32(s0)
 6fe:	f41c                	sd	a5,40(s0)
 700:	03043823          	sd	a6,48(s0)
 704:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 708:	00840613          	addi	a2,s0,8
 70c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 710:	85aa                	mv	a1,a0
 712:	4505                	li	a0,1
 714:	00000097          	auipc	ra,0x0
 718:	de0080e7          	jalr	-544(ra) # 4f4 <vprintf>
}
 71c:	60e2                	ld	ra,24(sp)
 71e:	6442                	ld	s0,16(sp)
 720:	6125                	addi	sp,sp,96
 722:	8082                	ret

0000000000000724 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 724:	1141                	addi	sp,sp,-16
 726:	e406                	sd	ra,8(sp)
 728:	e022                	sd	s0,0(sp)
 72a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 72c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 730:	00000797          	auipc	a5,0x0
 734:	2787b783          	ld	a5,632(a5) # 9a8 <freep>
 738:	a02d                	j	762 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 73a:	4618                	lw	a4,8(a2)
 73c:	9f2d                	addw	a4,a4,a1
 73e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 742:	6398                	ld	a4,0(a5)
 744:	6310                	ld	a2,0(a4)
 746:	a83d                	j	784 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 748:	ff852703          	lw	a4,-8(a0)
 74c:	9f31                	addw	a4,a4,a2
 74e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 750:	ff053683          	ld	a3,-16(a0)
 754:	a091                	j	798 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 756:	6398                	ld	a4,0(a5)
 758:	00e7e463          	bltu	a5,a4,760 <free+0x3c>
 75c:	00e6ea63          	bltu	a3,a4,770 <free+0x4c>
{
 760:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 762:	fed7fae3          	bgeu	a5,a3,756 <free+0x32>
 766:	6398                	ld	a4,0(a5)
 768:	00e6e463          	bltu	a3,a4,770 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76c:	fee7eae3          	bltu	a5,a4,760 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 770:	ff852583          	lw	a1,-8(a0)
 774:	6390                	ld	a2,0(a5)
 776:	02059813          	slli	a6,a1,0x20
 77a:	01c85713          	srli	a4,a6,0x1c
 77e:	9736                	add	a4,a4,a3
 780:	fae60de3          	beq	a2,a4,73a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 788:	4790                	lw	a2,8(a5)
 78a:	02061593          	slli	a1,a2,0x20
 78e:	01c5d713          	srli	a4,a1,0x1c
 792:	973e                	add	a4,a4,a5
 794:	fae68ae3          	beq	a3,a4,748 <free+0x24>
    p->s.ptr = bp->s.ptr;
 798:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 79a:	00000717          	auipc	a4,0x0
 79e:	20f73723          	sd	a5,526(a4) # 9a8 <freep>
}
 7a2:	60a2                	ld	ra,8(sp)
 7a4:	6402                	ld	s0,0(sp)
 7a6:	0141                	addi	sp,sp,16
 7a8:	8082                	ret

00000000000007aa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7aa:	7139                	addi	sp,sp,-64
 7ac:	fc06                	sd	ra,56(sp)
 7ae:	f822                	sd	s0,48(sp)
 7b0:	f04a                	sd	s2,32(sp)
 7b2:	ec4e                	sd	s3,24(sp)
 7b4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b6:	02051993          	slli	s3,a0,0x20
 7ba:	0209d993          	srli	s3,s3,0x20
 7be:	09bd                	addi	s3,s3,15
 7c0:	0049d993          	srli	s3,s3,0x4
 7c4:	2985                	addiw	s3,s3,1
 7c6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7c8:	00000517          	auipc	a0,0x0
 7cc:	1e053503          	ld	a0,480(a0) # 9a8 <freep>
 7d0:	c905                	beqz	a0,800 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d4:	4798                	lw	a4,8(a5)
 7d6:	09377a63          	bgeu	a4,s3,86a <malloc+0xc0>
 7da:	f426                	sd	s1,40(sp)
 7dc:	e852                	sd	s4,16(sp)
 7de:	e456                	sd	s5,8(sp)
 7e0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e2:	8a4e                	mv	s4,s3
 7e4:	6705                	lui	a4,0x1
 7e6:	00e9f363          	bgeu	s3,a4,7ec <malloc+0x42>
 7ea:	6a05                	lui	s4,0x1
 7ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f4:	00000497          	auipc	s1,0x0
 7f8:	1b448493          	addi	s1,s1,436 # 9a8 <freep>
  if(p == (char*)-1)
 7fc:	5afd                	li	s5,-1
 7fe:	a089                	j	840 <malloc+0x96>
 800:	f426                	sd	s1,40(sp)
 802:	e852                	sd	s4,16(sp)
 804:	e456                	sd	s5,8(sp)
 806:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 808:	00000797          	auipc	a5,0x0
 80c:	1a878793          	addi	a5,a5,424 # 9b0 <base>
 810:	00000717          	auipc	a4,0x0
 814:	18f73c23          	sd	a5,408(a4) # 9a8 <freep>
 818:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 81a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 81e:	b7d1                	j	7e2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	e118                	sd	a4,0(a0)
 824:	a8b9                	j	882 <malloc+0xd8>
  hp->s.size = nu;
 826:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 82a:	0541                	addi	a0,a0,16
 82c:	00000097          	auipc	ra,0x0
 830:	ef8080e7          	jalr	-264(ra) # 724 <free>
  return freep;
 834:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 836:	c135                	beqz	a0,89a <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 838:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 83a:	4798                	lw	a4,8(a5)
 83c:	03277363          	bgeu	a4,s2,862 <malloc+0xb8>
    if(p == freep)
 840:	6098                	ld	a4,0(s1)
 842:	853e                	mv	a0,a5
 844:	fef71ae3          	bne	a4,a5,838 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 848:	8552                	mv	a0,s4
 84a:	00000097          	auipc	ra,0x0
 84e:	bd6080e7          	jalr	-1066(ra) # 420 <sbrk>
  if(p == (char*)-1)
 852:	fd551ae3          	bne	a0,s5,826 <malloc+0x7c>
        return 0;
 856:	4501                	li	a0,0
 858:	74a2                	ld	s1,40(sp)
 85a:	6a42                	ld	s4,16(sp)
 85c:	6aa2                	ld	s5,8(sp)
 85e:	6b02                	ld	s6,0(sp)
 860:	a03d                	j	88e <malloc+0xe4>
 862:	74a2                	ld	s1,40(sp)
 864:	6a42                	ld	s4,16(sp)
 866:	6aa2                	ld	s5,8(sp)
 868:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 86a:	fae90be3          	beq	s2,a4,820 <malloc+0x76>
        p->s.size -= nunits;
 86e:	4137073b          	subw	a4,a4,s3
 872:	c798                	sw	a4,8(a5)
        p += p->s.size;
 874:	02071693          	slli	a3,a4,0x20
 878:	01c6d713          	srli	a4,a3,0x1c
 87c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 87e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 882:	00000717          	auipc	a4,0x0
 886:	12a73323          	sd	a0,294(a4) # 9a8 <freep>
      return (void*)(p + 1);
 88a:	01078513          	addi	a0,a5,16
  }
}
 88e:	70e2                	ld	ra,56(sp)
 890:	7442                	ld	s0,48(sp)
 892:	7902                	ld	s2,32(sp)
 894:	69e2                	ld	s3,24(sp)
 896:	6121                	addi	sp,sp,64
 898:	8082                	ret
 89a:	74a2                	ld	s1,40(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
 8a2:	b7f5                	j	88e <malloc+0xe4>
