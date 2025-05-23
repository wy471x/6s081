
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  12:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  14:	00001917          	auipc	s2,0x1
  18:	9a490913          	addi	s2,s2,-1628 # 9b8 <buf>
  1c:	20000a13          	li	s4,512
    if (write(1, buf, n) != n) {
  20:	4a85                	li	s5,1
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  22:	8652                	mv	a2,s4
  24:	85ca                	mv	a1,s2
  26:	854e                	mv	a0,s3
  28:	00000097          	auipc	ra,0x0
  2c:	3be080e7          	jalr	958(ra) # 3e6 <read>
  30:	84aa                	mv	s1,a0
  32:	02a05963          	blez	a0,64 <cat+0x64>
    if (write(1, buf, n) != n) {
  36:	8626                	mv	a2,s1
  38:	85ca                	mv	a1,s2
  3a:	8556                	mv	a0,s5
  3c:	00000097          	auipc	ra,0x0
  40:	3b2080e7          	jalr	946(ra) # 3ee <write>
  44:	fc950fe3          	beq	a0,s1,22 <cat+0x22>
      fprintf(2, "cat: write error\n");
  48:	00001597          	auipc	a1,0x1
  4c:	8a858593          	addi	a1,a1,-1880 # 8f0 <malloc+0x100>
  50:	4509                	li	a0,2
  52:	00000097          	auipc	ra,0x0
  56:	6b4080e7          	jalr	1716(ra) # 706 <fprintf>
      exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	372080e7          	jalr	882(ra) # 3ce <exit>
    }
  }
  if(n < 0){
  64:	00054b63          	bltz	a0,7a <cat+0x7a>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  68:	70e2                	ld	ra,56(sp)
  6a:	7442                	ld	s0,48(sp)
  6c:	74a2                	ld	s1,40(sp)
  6e:	7902                	ld	s2,32(sp)
  70:	69e2                	ld	s3,24(sp)
  72:	6a42                	ld	s4,16(sp)
  74:	6aa2                	ld	s5,8(sp)
  76:	6121                	addi	sp,sp,64
  78:	8082                	ret
    fprintf(2, "cat: read error\n");
  7a:	00001597          	auipc	a1,0x1
  7e:	88e58593          	addi	a1,a1,-1906 # 908 <malloc+0x118>
  82:	4509                	li	a0,2
  84:	00000097          	auipc	ra,0x0
  88:	682080e7          	jalr	1666(ra) # 706 <fprintf>
    exit(1);
  8c:	4505                	li	a0,1
  8e:	00000097          	auipc	ra,0x0
  92:	340080e7          	jalr	832(ra) # 3ce <exit>

0000000000000096 <main>:

int
main(int argc, char *argv[])
{
  96:	7179                	addi	sp,sp,-48
  98:	f406                	sd	ra,40(sp)
  9a:	f022                	sd	s0,32(sp)
  9c:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  9e:	4785                	li	a5,1
  a0:	04a7da63          	bge	a5,a0,f4 <main+0x5e>
  a4:	ec26                	sd	s1,24(sp)
  a6:	e84a                	sd	s2,16(sp)
  a8:	e44e                	sd	s3,8(sp)
  aa:	00858913          	addi	s2,a1,8
  ae:	ffe5099b          	addiw	s3,a0,-2
  b2:	02099793          	slli	a5,s3,0x20
  b6:	01d7d993          	srli	s3,a5,0x1d
  ba:	05c1                	addi	a1,a1,16
  bc:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  be:	4581                	li	a1,0
  c0:	00093503          	ld	a0,0(s2)
  c4:	00000097          	auipc	ra,0x0
  c8:	34a080e7          	jalr	842(ra) # 40e <open>
  cc:	84aa                	mv	s1,a0
  ce:	04054063          	bltz	a0,10e <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  d2:	00000097          	auipc	ra,0x0
  d6:	f2e080e7          	jalr	-210(ra) # 0 <cat>
    close(fd);
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	31a080e7          	jalr	794(ra) # 3f6 <close>
  for(i = 1; i < argc; i++){
  e4:	0921                	addi	s2,s2,8
  e6:	fd391ce3          	bne	s2,s3,be <main+0x28>
  }
  exit(0);
  ea:	4501                	li	a0,0
  ec:	00000097          	auipc	ra,0x0
  f0:	2e2080e7          	jalr	738(ra) # 3ce <exit>
  f4:	ec26                	sd	s1,24(sp)
  f6:	e84a                	sd	s2,16(sp)
  f8:	e44e                	sd	s3,8(sp)
    cat(0);
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	f04080e7          	jalr	-252(ra) # 0 <cat>
    exit(0);
 104:	4501                	li	a0,0
 106:	00000097          	auipc	ra,0x0
 10a:	2c8080e7          	jalr	712(ra) # 3ce <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 10e:	00093603          	ld	a2,0(s2)
 112:	00001597          	auipc	a1,0x1
 116:	80e58593          	addi	a1,a1,-2034 # 920 <malloc+0x130>
 11a:	4509                	li	a0,2
 11c:	00000097          	auipc	ra,0x0
 120:	5ea080e7          	jalr	1514(ra) # 706 <fprintf>
      exit(1);
 124:	4505                	li	a0,1
 126:	00000097          	auipc	ra,0x0
 12a:	2a8080e7          	jalr	680(ra) # 3ce <exit>

000000000000012e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 136:	87aa                	mv	a5,a0
 138:	0585                	addi	a1,a1,1
 13a:	0785                	addi	a5,a5,1
 13c:	fff5c703          	lbu	a4,-1(a1)
 140:	fee78fa3          	sb	a4,-1(a5)
 144:	fb75                	bnez	a4,138 <strcpy+0xa>
    ;
  return os;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret

000000000000014e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14e:	1141                	addi	sp,sp,-16
 150:	e406                	sd	ra,8(sp)
 152:	e022                	sd	s0,0(sp)
 154:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	cb91                	beqz	a5,16e <strcmp+0x20>
 15c:	0005c703          	lbu	a4,0(a1)
 160:	00f71763          	bne	a4,a5,16e <strcmp+0x20>
    p++, q++;
 164:	0505                	addi	a0,a0,1
 166:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 168:	00054783          	lbu	a5,0(a0)
 16c:	fbe5                	bnez	a5,15c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 16e:	0005c503          	lbu	a0,0(a1)
}
 172:	40a7853b          	subw	a0,a5,a0
 176:	60a2                	ld	ra,8(sp)
 178:	6402                	ld	s0,0(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strlen>:

uint
strlen(const char *s)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e406                	sd	ra,8(sp)
 182:	e022                	sd	s0,0(sp)
 184:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 186:	00054783          	lbu	a5,0(a0)
 18a:	cf99                	beqz	a5,1a8 <strlen+0x2a>
 18c:	0505                	addi	a0,a0,1
 18e:	87aa                	mv	a5,a0
 190:	86be                	mv	a3,a5
 192:	0785                	addi	a5,a5,1
 194:	fff7c703          	lbu	a4,-1(a5)
 198:	ff65                	bnez	a4,190 <strlen+0x12>
 19a:	40a6853b          	subw	a0,a3,a0
 19e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a0:	60a2                	ld	ra,8(sp)
 1a2:	6402                	ld	s0,0(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret
  for(n = 0; s[n]; n++)
 1a8:	4501                	li	a0,0
 1aa:	bfdd                	j	1a0 <strlen+0x22>

00000000000001ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b4:	ca19                	beqz	a2,1ca <memset+0x1e>
 1b6:	87aa                	mv	a5,a0
 1b8:	1602                	slli	a2,a2,0x20
 1ba:	9201                	srli	a2,a2,0x20
 1bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c4:	0785                	addi	a5,a5,1
 1c6:	fee79de3          	bne	a5,a4,1c0 <memset+0x14>
  }
  return dst;
}
 1ca:	60a2                	ld	ra,8(sp)
 1cc:	6402                	ld	s0,0(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret

00000000000001d2 <strchr>:

char*
strchr(const char *s, char c)
{
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1da:	00054783          	lbu	a5,0(a0)
 1de:	cf81                	beqz	a5,1f6 <strchr+0x24>
    if(*s == c)
 1e0:	00f58763          	beq	a1,a5,1ee <strchr+0x1c>
  for(; *s; s++)
 1e4:	0505                	addi	a0,a0,1
 1e6:	00054783          	lbu	a5,0(a0)
 1ea:	fbfd                	bnez	a5,1e0 <strchr+0xe>
      return (char*)s;
  return 0;
 1ec:	4501                	li	a0,0
}
 1ee:	60a2                	ld	ra,8(sp)
 1f0:	6402                	ld	s0,0(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret
  return 0;
 1f6:	4501                	li	a0,0
 1f8:	bfdd                	j	1ee <strchr+0x1c>

00000000000001fa <gets>:

char*
gets(char *buf, int max)
{
 1fa:	7159                	addi	sp,sp,-112
 1fc:	f486                	sd	ra,104(sp)
 1fe:	f0a2                	sd	s0,96(sp)
 200:	eca6                	sd	s1,88(sp)
 202:	e8ca                	sd	s2,80(sp)
 204:	e4ce                	sd	s3,72(sp)
 206:	e0d2                	sd	s4,64(sp)
 208:	fc56                	sd	s5,56(sp)
 20a:	f85a                	sd	s6,48(sp)
 20c:	f45e                	sd	s7,40(sp)
 20e:	f062                	sd	s8,32(sp)
 210:	ec66                	sd	s9,24(sp)
 212:	e86a                	sd	s10,16(sp)
 214:	1880                	addi	s0,sp,112
 216:	8caa                	mv	s9,a0
 218:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21a:	892a                	mv	s2,a0
 21c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 21e:	f9f40b13          	addi	s6,s0,-97
 222:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 224:	4ba9                	li	s7,10
 226:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 228:	8d26                	mv	s10,s1
 22a:	0014899b          	addiw	s3,s1,1
 22e:	84ce                	mv	s1,s3
 230:	0349d763          	bge	s3,s4,25e <gets+0x64>
    cc = read(0, &c, 1);
 234:	8656                	mv	a2,s5
 236:	85da                	mv	a1,s6
 238:	4501                	li	a0,0
 23a:	00000097          	auipc	ra,0x0
 23e:	1ac080e7          	jalr	428(ra) # 3e6 <read>
    if(cc < 1)
 242:	00a05e63          	blez	a0,25e <gets+0x64>
    buf[i++] = c;
 246:	f9f44783          	lbu	a5,-97(s0)
 24a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 24e:	01778763          	beq	a5,s7,25c <gets+0x62>
 252:	0905                	addi	s2,s2,1
 254:	fd879ae3          	bne	a5,s8,228 <gets+0x2e>
    buf[i++] = c;
 258:	8d4e                	mv	s10,s3
 25a:	a011                	j	25e <gets+0x64>
 25c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 25e:	9d66                	add	s10,s10,s9
 260:	000d0023          	sb	zero,0(s10)
  return buf;
}
 264:	8566                	mv	a0,s9
 266:	70a6                	ld	ra,104(sp)
 268:	7406                	ld	s0,96(sp)
 26a:	64e6                	ld	s1,88(sp)
 26c:	6946                	ld	s2,80(sp)
 26e:	69a6                	ld	s3,72(sp)
 270:	6a06                	ld	s4,64(sp)
 272:	7ae2                	ld	s5,56(sp)
 274:	7b42                	ld	s6,48(sp)
 276:	7ba2                	ld	s7,40(sp)
 278:	7c02                	ld	s8,32(sp)
 27a:	6ce2                	ld	s9,24(sp)
 27c:	6d42                	ld	s10,16(sp)
 27e:	6165                	addi	sp,sp,112
 280:	8082                	ret

0000000000000282 <stat>:

int
stat(const char *n, struct stat *st)
{
 282:	1101                	addi	sp,sp,-32
 284:	ec06                	sd	ra,24(sp)
 286:	e822                	sd	s0,16(sp)
 288:	e04a                	sd	s2,0(sp)
 28a:	1000                	addi	s0,sp,32
 28c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28e:	4581                	li	a1,0
 290:	00000097          	auipc	ra,0x0
 294:	17e080e7          	jalr	382(ra) # 40e <open>
  if(fd < 0)
 298:	02054663          	bltz	a0,2c4 <stat+0x42>
 29c:	e426                	sd	s1,8(sp)
 29e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2a0:	85ca                	mv	a1,s2
 2a2:	00000097          	auipc	ra,0x0
 2a6:	184080e7          	jalr	388(ra) # 426 <fstat>
 2aa:	892a                	mv	s2,a0
  close(fd);
 2ac:	8526                	mv	a0,s1
 2ae:	00000097          	auipc	ra,0x0
 2b2:	148080e7          	jalr	328(ra) # 3f6 <close>
  return r;
 2b6:	64a2                	ld	s1,8(sp)
}
 2b8:	854a                	mv	a0,s2
 2ba:	60e2                	ld	ra,24(sp)
 2bc:	6442                	ld	s0,16(sp)
 2be:	6902                	ld	s2,0(sp)
 2c0:	6105                	addi	sp,sp,32
 2c2:	8082                	ret
    return -1;
 2c4:	597d                	li	s2,-1
 2c6:	bfcd                	j	2b8 <stat+0x36>

00000000000002c8 <atoi>:

int
atoi(const char *s)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d0:	00054683          	lbu	a3,0(a0)
 2d4:	fd06879b          	addiw	a5,a3,-48
 2d8:	0ff7f793          	zext.b	a5,a5
 2dc:	4625                	li	a2,9
 2de:	02f66963          	bltu	a2,a5,310 <atoi+0x48>
 2e2:	872a                	mv	a4,a0
  n = 0;
 2e4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2e6:	0705                	addi	a4,a4,1
 2e8:	0025179b          	slliw	a5,a0,0x2
 2ec:	9fa9                	addw	a5,a5,a0
 2ee:	0017979b          	slliw	a5,a5,0x1
 2f2:	9fb5                	addw	a5,a5,a3
 2f4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2f8:	00074683          	lbu	a3,0(a4)
 2fc:	fd06879b          	addiw	a5,a3,-48
 300:	0ff7f793          	zext.b	a5,a5
 304:	fef671e3          	bgeu	a2,a5,2e6 <atoi+0x1e>
  return n;
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
  n = 0;
 310:	4501                	li	a0,0
 312:	bfdd                	j	308 <atoi+0x40>

0000000000000314 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31c:	02b57563          	bgeu	a0,a1,346 <memmove+0x32>
    while(n-- > 0)
 320:	00c05f63          	blez	a2,33e <memmove+0x2a>
 324:	1602                	slli	a2,a2,0x20
 326:	9201                	srli	a2,a2,0x20
 328:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32c:	872a                	mv	a4,a0
      *dst++ = *src++;
 32e:	0585                	addi	a1,a1,1
 330:	0705                	addi	a4,a4,1
 332:	fff5c683          	lbu	a3,-1(a1)
 336:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33a:	fee79ae3          	bne	a5,a4,32e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 33e:	60a2                	ld	ra,8(sp)
 340:	6402                	ld	s0,0(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
    dst += n;
 346:	00c50733          	add	a4,a0,a2
    src += n;
 34a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34c:	fec059e3          	blez	a2,33e <memmove+0x2a>
 350:	fff6079b          	addiw	a5,a2,-1
 354:	1782                	slli	a5,a5,0x20
 356:	9381                	srli	a5,a5,0x20
 358:	fff7c793          	not	a5,a5
 35c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35e:	15fd                	addi	a1,a1,-1
 360:	177d                	addi	a4,a4,-1
 362:	0005c683          	lbu	a3,0(a1)
 366:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36a:	fef71ae3          	bne	a4,a5,35e <memmove+0x4a>
 36e:	bfc1                	j	33e <memmove+0x2a>

0000000000000370 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 378:	ca0d                	beqz	a2,3aa <memcmp+0x3a>
 37a:	fff6069b          	addiw	a3,a2,-1
 37e:	1682                	slli	a3,a3,0x20
 380:	9281                	srli	a3,a3,0x20
 382:	0685                	addi	a3,a3,1
 384:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 386:	00054783          	lbu	a5,0(a0)
 38a:	0005c703          	lbu	a4,0(a1)
 38e:	00e79863          	bne	a5,a4,39e <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 392:	0505                	addi	a0,a0,1
    p2++;
 394:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 396:	fed518e3          	bne	a0,a3,386 <memcmp+0x16>
  }
  return 0;
 39a:	4501                	li	a0,0
 39c:	a019                	j	3a2 <memcmp+0x32>
      return *p1 - *p2;
 39e:	40e7853b          	subw	a0,a5,a4
}
 3a2:	60a2                	ld	ra,8(sp)
 3a4:	6402                	ld	s0,0(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfdd                	j	3a2 <memcmp+0x32>

00000000000003ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ae:	1141                	addi	sp,sp,-16
 3b0:	e406                	sd	ra,8(sp)
 3b2:	e022                	sd	s0,0(sp)
 3b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b6:	00000097          	auipc	ra,0x0
 3ba:	f5e080e7          	jalr	-162(ra) # 314 <memmove>
}
 3be:	60a2                	ld	ra,8(sp)
 3c0:	6402                	ld	s0,0(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret

00000000000003c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3c6:	4885                	li	a7,1
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 3ce:	4889                	li	a7,2
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3d6:	488d                	li	a7,3
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3de:	4891                	li	a7,4
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <read>:
.global read
read:
 li a7, SYS_read
 3e6:	4895                	li	a7,5
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <write>:
.global write
write:
 li a7, SYS_write
 3ee:	48c1                	li	a7,16
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <close>:
.global close
close:
 li a7, SYS_close
 3f6:	48d5                	li	a7,21
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 3fe:	4899                	li	a7,6
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <exec>:
.global exec
exec:
 li a7, SYS_exec
 406:	489d                	li	a7,7
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <open>:
.global open
open:
 li a7, SYS_open
 40e:	48bd                	li	a7,15
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 416:	48c5                	li	a7,17
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 41e:	48c9                	li	a7,18
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 426:	48a1                	li	a7,8
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <link>:
.global link
link:
 li a7, SYS_link
 42e:	48cd                	li	a7,19
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 436:	48d1                	li	a7,20
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 43e:	48a5                	li	a7,9
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <dup>:
.global dup
dup:
 li a7, SYS_dup
 446:	48a9                	li	a7,10
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 44e:	48ad                	li	a7,11
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 456:	48b1                	li	a7,12
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 45e:	48b5                	li	a7,13
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 466:	48b9                	li	a7,14
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 46e:	48d9                	li	a7,22
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 476:	48dd                	li	a7,23
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 47e:	1101                	addi	sp,sp,-32
 480:	ec06                	sd	ra,24(sp)
 482:	e822                	sd	s0,16(sp)
 484:	1000                	addi	s0,sp,32
 486:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48a:	4605                	li	a2,1
 48c:	fef40593          	addi	a1,s0,-17
 490:	00000097          	auipc	ra,0x0
 494:	f5e080e7          	jalr	-162(ra) # 3ee <write>
}
 498:	60e2                	ld	ra,24(sp)
 49a:	6442                	ld	s0,16(sp)
 49c:	6105                	addi	sp,sp,32
 49e:	8082                	ret

00000000000004a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a0:	7139                	addi	sp,sp,-64
 4a2:	fc06                	sd	ra,56(sp)
 4a4:	f822                	sd	s0,48(sp)
 4a6:	f426                	sd	s1,40(sp)
 4a8:	f04a                	sd	s2,32(sp)
 4aa:	ec4e                	sd	s3,24(sp)
 4ac:	0080                	addi	s0,sp,64
 4ae:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b0:	c299                	beqz	a3,4b6 <printint+0x16>
 4b2:	0805c063          	bltz	a1,532 <printint+0x92>
  neg = 0;
 4b6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 4b8:	fc040313          	addi	t1,s0,-64
  neg = 0;
 4bc:	869a                	mv	a3,t1
  i = 0;
 4be:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 4c0:	00000817          	auipc	a6,0x0
 4c4:	4d880813          	addi	a6,a6,1240 # 998 <digits>
 4c8:	88be                	mv	a7,a5
 4ca:	0017851b          	addiw	a0,a5,1
 4ce:	87aa                	mv	a5,a0
 4d0:	02c5f73b          	remuw	a4,a1,a2
 4d4:	1702                	slli	a4,a4,0x20
 4d6:	9301                	srli	a4,a4,0x20
 4d8:	9742                	add	a4,a4,a6
 4da:	00074703          	lbu	a4,0(a4)
 4de:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 4e2:	872e                	mv	a4,a1
 4e4:	02c5d5bb          	divuw	a1,a1,a2
 4e8:	0685                	addi	a3,a3,1
 4ea:	fcc77fe3          	bgeu	a4,a2,4c8 <printint+0x28>
  if(neg)
 4ee:	000e0c63          	beqz	t3,506 <printint+0x66>
    buf[i++] = '-';
 4f2:	fd050793          	addi	a5,a0,-48
 4f6:	00878533          	add	a0,a5,s0
 4fa:	02d00793          	li	a5,45
 4fe:	fef50823          	sb	a5,-16(a0)
 502:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 506:	fff7899b          	addiw	s3,a5,-1
 50a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 50e:	fff4c583          	lbu	a1,-1(s1)
 512:	854a                	mv	a0,s2
 514:	00000097          	auipc	ra,0x0
 518:	f6a080e7          	jalr	-150(ra) # 47e <putc>
  while(--i >= 0)
 51c:	39fd                	addiw	s3,s3,-1
 51e:	14fd                	addi	s1,s1,-1
 520:	fe09d7e3          	bgez	s3,50e <printint+0x6e>
}
 524:	70e2                	ld	ra,56(sp)
 526:	7442                	ld	s0,48(sp)
 528:	74a2                	ld	s1,40(sp)
 52a:	7902                	ld	s2,32(sp)
 52c:	69e2                	ld	s3,24(sp)
 52e:	6121                	addi	sp,sp,64
 530:	8082                	ret
    x = -xx;
 532:	40b005bb          	negw	a1,a1
    neg = 1;
 536:	4e05                	li	t3,1
    x = -xx;
 538:	b741                	j	4b8 <printint+0x18>

000000000000053a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53a:	715d                	addi	sp,sp,-80
 53c:	e486                	sd	ra,72(sp)
 53e:	e0a2                	sd	s0,64(sp)
 540:	f84a                	sd	s2,48(sp)
 542:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 544:	0005c903          	lbu	s2,0(a1)
 548:	1a090a63          	beqz	s2,6fc <vprintf+0x1c2>
 54c:	fc26                	sd	s1,56(sp)
 54e:	f44e                	sd	s3,40(sp)
 550:	f052                	sd	s4,32(sp)
 552:	ec56                	sd	s5,24(sp)
 554:	e85a                	sd	s6,16(sp)
 556:	e45e                	sd	s7,8(sp)
 558:	8aaa                	mv	s5,a0
 55a:	8bb2                	mv	s7,a2
 55c:	00158493          	addi	s1,a1,1
  state = 0;
 560:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 562:	02500a13          	li	s4,37
 566:	4b55                	li	s6,21
 568:	a839                	j	586 <vprintf+0x4c>
        putc(fd, c);
 56a:	85ca                	mv	a1,s2
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	f10080e7          	jalr	-240(ra) # 47e <putc>
 576:	a019                	j	57c <vprintf+0x42>
    } else if(state == '%'){
 578:	01498d63          	beq	s3,s4,592 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 57c:	0485                	addi	s1,s1,1
 57e:	fff4c903          	lbu	s2,-1(s1)
 582:	16090763          	beqz	s2,6f0 <vprintf+0x1b6>
    if(state == 0){
 586:	fe0999e3          	bnez	s3,578 <vprintf+0x3e>
      if(c == '%'){
 58a:	ff4910e3          	bne	s2,s4,56a <vprintf+0x30>
        state = '%';
 58e:	89d2                	mv	s3,s4
 590:	b7f5                	j	57c <vprintf+0x42>
      if(c == 'd'){
 592:	13490463          	beq	s2,s4,6ba <vprintf+0x180>
 596:	f9d9079b          	addiw	a5,s2,-99
 59a:	0ff7f793          	zext.b	a5,a5
 59e:	12fb6763          	bltu	s6,a5,6cc <vprintf+0x192>
 5a2:	f9d9079b          	addiw	a5,s2,-99
 5a6:	0ff7f713          	zext.b	a4,a5
 5aa:	12eb6163          	bltu	s6,a4,6cc <vprintf+0x192>
 5ae:	00271793          	slli	a5,a4,0x2
 5b2:	00000717          	auipc	a4,0x0
 5b6:	38e70713          	addi	a4,a4,910 # 940 <malloc+0x150>
 5ba:	97ba                	add	a5,a5,a4
 5bc:	439c                	lw	a5,0(a5)
 5be:	97ba                	add	a5,a5,a4
 5c0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c2:	008b8913          	addi	s2,s7,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	ed0080e7          	jalr	-304(ra) # 4a0 <printint>
 5d8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b745                	j	57c <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	8556                	mv	a0,s5
 5ec:	00000097          	auipc	ra,0x0
 5f0:	eb4080e7          	jalr	-332(ra) # 4a0 <printint>
 5f4:	8bca                	mv	s7,s2
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b751                	j	57c <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5fa:	008b8913          	addi	s2,s7,8
 5fe:	4681                	li	a3,0
 600:	4641                	li	a2,16
 602:	000ba583          	lw	a1,0(s7)
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	e98080e7          	jalr	-360(ra) # 4a0 <printint>
 610:	8bca                	mv	s7,s2
      state = 0;
 612:	4981                	li	s3,0
 614:	b7a5                	j	57c <vprintf+0x42>
 616:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 618:	008b8c13          	addi	s8,s7,8
 61c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 620:	03000593          	li	a1,48
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e58080e7          	jalr	-424(ra) # 47e <putc>
  putc(fd, 'x');
 62e:	07800593          	li	a1,120
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	e4a080e7          	jalr	-438(ra) # 47e <putc>
 63c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	00000b97          	auipc	s7,0x0
 642:	35ab8b93          	addi	s7,s7,858 # 998 <digits>
 646:	03c9d793          	srli	a5,s3,0x3c
 64a:	97de                	add	a5,a5,s7
 64c:	0007c583          	lbu	a1,0(a5)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	e2c080e7          	jalr	-468(ra) # 47e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 65a:	0992                	slli	s3,s3,0x4
 65c:	397d                	addiw	s2,s2,-1
 65e:	fe0914e3          	bnez	s2,646 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 662:	8be2                	mv	s7,s8
      state = 0;
 664:	4981                	li	s3,0
 666:	6c02                	ld	s8,0(sp)
 668:	bf11                	j	57c <vprintf+0x42>
        s = va_arg(ap, char*);
 66a:	008b8993          	addi	s3,s7,8
 66e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 672:	02090163          	beqz	s2,694 <vprintf+0x15a>
        while(*s != 0){
 676:	00094583          	lbu	a1,0(s2)
 67a:	c9a5                	beqz	a1,6ea <vprintf+0x1b0>
          putc(fd, *s);
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	e00080e7          	jalr	-512(ra) # 47e <putc>
          s++;
 686:	0905                	addi	s2,s2,1
        while(*s != 0){
 688:	00094583          	lbu	a1,0(s2)
 68c:	f9e5                	bnez	a1,67c <vprintf+0x142>
        s = va_arg(ap, char*);
 68e:	8bce                	mv	s7,s3
      state = 0;
 690:	4981                	li	s3,0
 692:	b5ed                	j	57c <vprintf+0x42>
          s = "(null)";
 694:	00000917          	auipc	s2,0x0
 698:	2a490913          	addi	s2,s2,676 # 938 <malloc+0x148>
        while(*s != 0){
 69c:	02800593          	li	a1,40
 6a0:	bff1                	j	67c <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	000bc583          	lbu	a1,0(s7)
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	dd2080e7          	jalr	-558(ra) # 47e <putc>
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b5d1                	j	57c <vprintf+0x42>
        putc(fd, c);
 6ba:	02500593          	li	a1,37
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	dbe080e7          	jalr	-578(ra) # 47e <putc>
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bd4d                	j	57c <vprintf+0x42>
        putc(fd, '%');
 6cc:	02500593          	li	a1,37
 6d0:	8556                	mv	a0,s5
 6d2:	00000097          	auipc	ra,0x0
 6d6:	dac080e7          	jalr	-596(ra) # 47e <putc>
        putc(fd, c);
 6da:	85ca                	mv	a1,s2
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	da0080e7          	jalr	-608(ra) # 47e <putc>
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bd51                	j	57c <vprintf+0x42>
        s = va_arg(ap, char*);
 6ea:	8bce                	mv	s7,s3
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b579                	j	57c <vprintf+0x42>
 6f0:	74e2                	ld	s1,56(sp)
 6f2:	79a2                	ld	s3,40(sp)
 6f4:	7a02                	ld	s4,32(sp)
 6f6:	6ae2                	ld	s5,24(sp)
 6f8:	6b42                	ld	s6,16(sp)
 6fa:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6fc:	60a6                	ld	ra,72(sp)
 6fe:	6406                	ld	s0,64(sp)
 700:	7942                	ld	s2,48(sp)
 702:	6161                	addi	sp,sp,80
 704:	8082                	ret

0000000000000706 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 706:	715d                	addi	sp,sp,-80
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	e010                	sd	a2,0(s0)
 710:	e414                	sd	a3,8(s0)
 712:	e818                	sd	a4,16(s0)
 714:	ec1c                	sd	a5,24(s0)
 716:	03043023          	sd	a6,32(s0)
 71a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71e:	8622                	mv	a2,s0
 720:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 724:	00000097          	auipc	ra,0x0
 728:	e16080e7          	jalr	-490(ra) # 53a <vprintf>
}
 72c:	60e2                	ld	ra,24(sp)
 72e:	6442                	ld	s0,16(sp)
 730:	6161                	addi	sp,sp,80
 732:	8082                	ret

0000000000000734 <printf>:

void
printf(const char *fmt, ...)
{
 734:	711d                	addi	sp,sp,-96
 736:	ec06                	sd	ra,24(sp)
 738:	e822                	sd	s0,16(sp)
 73a:	1000                	addi	s0,sp,32
 73c:	e40c                	sd	a1,8(s0)
 73e:	e810                	sd	a2,16(s0)
 740:	ec14                	sd	a3,24(s0)
 742:	f018                	sd	a4,32(s0)
 744:	f41c                	sd	a5,40(s0)
 746:	03043823          	sd	a6,48(s0)
 74a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74e:	00840613          	addi	a2,s0,8
 752:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 756:	85aa                	mv	a1,a0
 758:	4505                	li	a0,1
 75a:	00000097          	auipc	ra,0x0
 75e:	de0080e7          	jalr	-544(ra) # 53a <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6125                	addi	sp,sp,96
 768:	8082                	ret

000000000000076a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76a:	1141                	addi	sp,sp,-16
 76c:	e406                	sd	ra,8(sp)
 76e:	e022                	sd	s0,0(sp)
 770:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 772:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	00000797          	auipc	a5,0x0
 77a:	23a7b783          	ld	a5,570(a5) # 9b0 <freep>
 77e:	a02d                	j	7a8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 780:	4618                	lw	a4,8(a2)
 782:	9f2d                	addw	a4,a4,a1
 784:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	6398                	ld	a4,0(a5)
 78a:	6310                	ld	a2,0(a4)
 78c:	a83d                	j	7ca <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78e:	ff852703          	lw	a4,-8(a0)
 792:	9f31                	addw	a4,a4,a2
 794:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 796:	ff053683          	ld	a3,-16(a0)
 79a:	a091                	j	7de <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	6398                	ld	a4,0(a5)
 79e:	00e7e463          	bltu	a5,a4,7a6 <free+0x3c>
 7a2:	00e6ea63          	bltu	a3,a4,7b6 <free+0x4c>
{
 7a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	fed7fae3          	bgeu	a5,a3,79c <free+0x32>
 7ac:	6398                	ld	a4,0(a5)
 7ae:	00e6e463          	bltu	a3,a4,7b6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	fee7eae3          	bltu	a5,a4,7a6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 7b6:	ff852583          	lw	a1,-8(a0)
 7ba:	6390                	ld	a2,0(a5)
 7bc:	02059813          	slli	a6,a1,0x20
 7c0:	01c85713          	srli	a4,a6,0x1c
 7c4:	9736                	add	a4,a4,a3
 7c6:	fae60de3          	beq	a2,a4,780 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ce:	4790                	lw	a2,8(a5)
 7d0:	02061593          	slli	a1,a2,0x20
 7d4:	01c5d713          	srli	a4,a1,0x1c
 7d8:	973e                	add	a4,a4,a5
 7da:	fae68ae3          	beq	a3,a4,78e <free+0x24>
    p->s.ptr = bp->s.ptr;
 7de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7e0:	00000717          	auipc	a4,0x0
 7e4:	1cf73823          	sd	a5,464(a4) # 9b0 <freep>
}
 7e8:	60a2                	ld	ra,8(sp)
 7ea:	6402                	ld	s0,0(sp)
 7ec:	0141                	addi	sp,sp,16
 7ee:	8082                	ret

00000000000007f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f0:	7139                	addi	sp,sp,-64
 7f2:	fc06                	sd	ra,56(sp)
 7f4:	f822                	sd	s0,48(sp)
 7f6:	f04a                	sd	s2,32(sp)
 7f8:	ec4e                	sd	s3,24(sp)
 7fa:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fc:	02051993          	slli	s3,a0,0x20
 800:	0209d993          	srli	s3,s3,0x20
 804:	09bd                	addi	s3,s3,15
 806:	0049d993          	srli	s3,s3,0x4
 80a:	2985                	addiw	s3,s3,1
 80c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 80e:	00000517          	auipc	a0,0x0
 812:	1a253503          	ld	a0,418(a0) # 9b0 <freep>
 816:	c905                	beqz	a0,846 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81a:	4798                	lw	a4,8(a5)
 81c:	09377a63          	bgeu	a4,s3,8b0 <malloc+0xc0>
 820:	f426                	sd	s1,40(sp)
 822:	e852                	sd	s4,16(sp)
 824:	e456                	sd	s5,8(sp)
 826:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 828:	8a4e                	mv	s4,s3
 82a:	6705                	lui	a4,0x1
 82c:	00e9f363          	bgeu	s3,a4,832 <malloc+0x42>
 830:	6a05                	lui	s4,0x1
 832:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 836:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83a:	00000497          	auipc	s1,0x0
 83e:	17648493          	addi	s1,s1,374 # 9b0 <freep>
  if(p == (char*)-1)
 842:	5afd                	li	s5,-1
 844:	a089                	j	886 <malloc+0x96>
 846:	f426                	sd	s1,40(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 84e:	00000797          	auipc	a5,0x0
 852:	36a78793          	addi	a5,a5,874 # bb8 <base>
 856:	00000717          	auipc	a4,0x0
 85a:	14f73d23          	sd	a5,346(a4) # 9b0 <freep>
 85e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 860:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 864:	b7d1                	j	828 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 866:	6398                	ld	a4,0(a5)
 868:	e118                	sd	a4,0(a0)
 86a:	a8b9                	j	8c8 <malloc+0xd8>
  hp->s.size = nu;
 86c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 870:	0541                	addi	a0,a0,16
 872:	00000097          	auipc	ra,0x0
 876:	ef8080e7          	jalr	-264(ra) # 76a <free>
  return freep;
 87a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 87c:	c135                	beqz	a0,8e0 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 880:	4798                	lw	a4,8(a5)
 882:	03277363          	bgeu	a4,s2,8a8 <malloc+0xb8>
    if(p == freep)
 886:	6098                	ld	a4,0(s1)
 888:	853e                	mv	a0,a5
 88a:	fef71ae3          	bne	a4,a5,87e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 88e:	8552                	mv	a0,s4
 890:	00000097          	auipc	ra,0x0
 894:	bc6080e7          	jalr	-1082(ra) # 456 <sbrk>
  if(p == (char*)-1)
 898:	fd551ae3          	bne	a0,s5,86c <malloc+0x7c>
        return 0;
 89c:	4501                	li	a0,0
 89e:	74a2                	ld	s1,40(sp)
 8a0:	6a42                	ld	s4,16(sp)
 8a2:	6aa2                	ld	s5,8(sp)
 8a4:	6b02                	ld	s6,0(sp)
 8a6:	a03d                	j	8d4 <malloc+0xe4>
 8a8:	74a2                	ld	s1,40(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b0:	fae90be3          	beq	s2,a4,866 <malloc+0x76>
        p->s.size -= nunits;
 8b4:	4137073b          	subw	a4,a4,s3
 8b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ba:	02071693          	slli	a3,a4,0x20
 8be:	01c6d713          	srli	a4,a3,0x1c
 8c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c8:	00000717          	auipc	a4,0x0
 8cc:	0ea73423          	sd	a0,232(a4) # 9b0 <freep>
      return (void*)(p + 1);
 8d0:	01078513          	addi	a0,a5,16
  }
}
 8d4:	70e2                	ld	ra,56(sp)
 8d6:	7442                	ld	s0,48(sp)
 8d8:	7902                	ld	s2,32(sp)
 8da:	69e2                	ld	s3,24(sp)
 8dc:	6121                	addi	sp,sp,64
 8de:	8082                	ret
 8e0:	74a2                	ld	s1,40(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
 8e8:	b7f5                	j	8d4 <malloc+0xe4>
