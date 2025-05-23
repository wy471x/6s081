
user/_call:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <g>:
#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int g(int x) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  return x+3;
}
   8:	250d                	addiw	a0,a0,3
   a:	60a2                	ld	ra,8(sp)
   c:	6402                	ld	s0,0(sp)
   e:	0141                	addi	sp,sp,16
  10:	8082                	ret

0000000000000012 <f>:

int f(int x) {
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  return g(x);
}
  1a:	250d                	addiw	a0,a0,3
  1c:	60a2                	ld	ra,8(sp)
  1e:	6402                	ld	s0,0(sp)
  20:	0141                	addi	sp,sp,16
  22:	8082                	ret

0000000000000024 <main>:

void main(void) {
  24:	1101                	addi	sp,sp,-32
  26:	ec06                	sd	ra,24(sp)
  28:	e822                	sd	s0,16(sp)
  2a:	1000                	addi	s0,sp,32
  printf("%d %d\n", f(8)+1, 13);
  2c:	4635                	li	a2,13
  2e:	45b1                	li	a1,12
  30:	00001517          	auipc	a0,0x1
  34:	81050513          	addi	a0,a0,-2032 # 840 <malloc+0xfc>
  38:	00000097          	auipc	ra,0x0
  3c:	650080e7          	jalr	1616(ra) # 688 <printf>
  unsigned int i = 0x00646c72;
  40:	006477b7          	lui	a5,0x647
  44:	c7278793          	addi	a5,a5,-910 # 646c72 <__global_pointer$+0x645b91>
  48:	fef42623          	sw	a5,-20(s0)
	printf("H%x Wo%s", 57616, &i);
  4c:	fec40613          	addi	a2,s0,-20
  50:	65b9                	lui	a1,0xe
  52:	11058593          	addi	a1,a1,272 # e110 <__global_pointer$+0xd02f>
  56:	00000517          	auipc	a0,0x0
  5a:	7fa50513          	addi	a0,a0,2042 # 850 <malloc+0x10c>
  5e:	00000097          	auipc	ra,0x0
  62:	62a080e7          	jalr	1578(ra) # 688 <printf>
  printf("x=%d y=%d", 3);
  66:	458d                	li	a1,3
  68:	00000517          	auipc	a0,0x0
  6c:	7f850513          	addi	a0,a0,2040 # 860 <malloc+0x11c>
  70:	00000097          	auipc	ra,0x0
  74:	618080e7          	jalr	1560(ra) # 688 <printf>
  exit(0);
  78:	4501                	li	a0,0
  7a:	00000097          	auipc	ra,0x0
  7e:	2a8080e7          	jalr	680(ra) # 322 <exit>

0000000000000082 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  82:	1141                	addi	sp,sp,-16
  84:	e406                	sd	ra,8(sp)
  86:	e022                	sd	s0,0(sp)
  88:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8a:	87aa                	mv	a5,a0
  8c:	0585                	addi	a1,a1,1
  8e:	0785                	addi	a5,a5,1
  90:	fff5c703          	lbu	a4,-1(a1)
  94:	fee78fa3          	sb	a4,-1(a5)
  98:	fb75                	bnez	a4,8c <strcpy+0xa>
    ;
  return os;
}
  9a:	60a2                	ld	ra,8(sp)
  9c:	6402                	ld	s0,0(sp)
  9e:	0141                	addi	sp,sp,16
  a0:	8082                	ret

00000000000000a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e406                	sd	ra,8(sp)
  a6:	e022                	sd	s0,0(sp)
  a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  aa:	00054783          	lbu	a5,0(a0)
  ae:	cb91                	beqz	a5,c2 <strcmp+0x20>
  b0:	0005c703          	lbu	a4,0(a1)
  b4:	00f71763          	bne	a4,a5,c2 <strcmp+0x20>
    p++, q++;
  b8:	0505                	addi	a0,a0,1
  ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  bc:	00054783          	lbu	a5,0(a0)
  c0:	fbe5                	bnez	a5,b0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  c2:	0005c503          	lbu	a0,0(a1)
}
  c6:	40a7853b          	subw	a0,a5,a0
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strlen>:

uint
strlen(const char *s)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf99                	beqz	a5,fc <strlen+0x2a>
  e0:	0505                	addi	a0,a0,1
  e2:	87aa                	mv	a5,a0
  e4:	86be                	mv	a3,a5
  e6:	0785                	addi	a5,a5,1
  e8:	fff7c703          	lbu	a4,-1(a5)
  ec:	ff65                	bnez	a4,e4 <strlen+0x12>
  ee:	40a6853b          	subw	a0,a3,a0
  f2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
  for(n = 0; s[n]; n++)
  fc:	4501                	li	a0,0
  fe:	bfdd                	j	f4 <strlen+0x22>

0000000000000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 108:	ca19                	beqz	a2,11e <memset+0x1e>
 10a:	87aa                	mv	a5,a0
 10c:	1602                	slli	a2,a2,0x20
 10e:	9201                	srli	a2,a2,0x20
 110:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 114:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 118:	0785                	addi	a5,a5,1
 11a:	fee79de3          	bne	a5,a4,114 <memset+0x14>
  }
  return dst;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf81                	beqz	a5,14a <strchr+0x24>
    if(*s == c)
 134:	00f58763          	beq	a1,a5,142 <strchr+0x1c>
  for(; *s; s++)
 138:	0505                	addi	a0,a0,1
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbfd                	bnez	a5,134 <strchr+0xe>
      return (char*)s;
  return 0;
 140:	4501                	li	a0,0
}
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret
  return 0;
 14a:	4501                	li	a0,0
 14c:	bfdd                	j	142 <strchr+0x1c>

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	7159                	addi	sp,sp,-112
 150:	f486                	sd	ra,104(sp)
 152:	f0a2                	sd	s0,96(sp)
 154:	eca6                	sd	s1,88(sp)
 156:	e8ca                	sd	s2,80(sp)
 158:	e4ce                	sd	s3,72(sp)
 15a:	e0d2                	sd	s4,64(sp)
 15c:	fc56                	sd	s5,56(sp)
 15e:	f85a                	sd	s6,48(sp)
 160:	f45e                	sd	s7,40(sp)
 162:	f062                	sd	s8,32(sp)
 164:	ec66                	sd	s9,24(sp)
 166:	e86a                	sd	s10,16(sp)
 168:	1880                	addi	s0,sp,112
 16a:	8caa                	mv	s9,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
 172:	f9f40b13          	addi	s6,s0,-97
 176:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 178:	4ba9                	li	s7,10
 17a:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 17c:	8d26                	mv	s10,s1
 17e:	0014899b          	addiw	s3,s1,1
 182:	84ce                	mv	s1,s3
 184:	0349d763          	bge	s3,s4,1b2 <gets+0x64>
    cc = read(0, &c, 1);
 188:	8656                	mv	a2,s5
 18a:	85da                	mv	a1,s6
 18c:	4501                	li	a0,0
 18e:	00000097          	auipc	ra,0x0
 192:	1ac080e7          	jalr	428(ra) # 33a <read>
    if(cc < 1)
 196:	00a05e63          	blez	a0,1b2 <gets+0x64>
    buf[i++] = c;
 19a:	f9f44783          	lbu	a5,-97(s0)
 19e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a2:	01778763          	beq	a5,s7,1b0 <gets+0x62>
 1a6:	0905                	addi	s2,s2,1
 1a8:	fd879ae3          	bne	a5,s8,17c <gets+0x2e>
    buf[i++] = c;
 1ac:	8d4e                	mv	s10,s3
 1ae:	a011                	j	1b2 <gets+0x64>
 1b0:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 1b2:	9d66                	add	s10,s10,s9
 1b4:	000d0023          	sb	zero,0(s10)
  return buf;
}
 1b8:	8566                	mv	a0,s9
 1ba:	70a6                	ld	ra,104(sp)
 1bc:	7406                	ld	s0,96(sp)
 1be:	64e6                	ld	s1,88(sp)
 1c0:	6946                	ld	s2,80(sp)
 1c2:	69a6                	ld	s3,72(sp)
 1c4:	6a06                	ld	s4,64(sp)
 1c6:	7ae2                	ld	s5,56(sp)
 1c8:	7b42                	ld	s6,48(sp)
 1ca:	7ba2                	ld	s7,40(sp)
 1cc:	7c02                	ld	s8,32(sp)
 1ce:	6ce2                	ld	s9,24(sp)
 1d0:	6d42                	ld	s10,16(sp)
 1d2:	6165                	addi	sp,sp,112
 1d4:	8082                	ret

00000000000001d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d6:	1101                	addi	sp,sp,-32
 1d8:	ec06                	sd	ra,24(sp)
 1da:	e822                	sd	s0,16(sp)
 1dc:	e04a                	sd	s2,0(sp)
 1de:	1000                	addi	s0,sp,32
 1e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e2:	4581                	li	a1,0
 1e4:	00000097          	auipc	ra,0x0
 1e8:	17e080e7          	jalr	382(ra) # 362 <open>
  if(fd < 0)
 1ec:	02054663          	bltz	a0,218 <stat+0x42>
 1f0:	e426                	sd	s1,8(sp)
 1f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f4:	85ca                	mv	a1,s2
 1f6:	00000097          	auipc	ra,0x0
 1fa:	184080e7          	jalr	388(ra) # 37a <fstat>
 1fe:	892a                	mv	s2,a0
  close(fd);
 200:	8526                	mv	a0,s1
 202:	00000097          	auipc	ra,0x0
 206:	148080e7          	jalr	328(ra) # 34a <close>
  return r;
 20a:	64a2                	ld	s1,8(sp)
}
 20c:	854a                	mv	a0,s2
 20e:	60e2                	ld	ra,24(sp)
 210:	6442                	ld	s0,16(sp)
 212:	6902                	ld	s2,0(sp)
 214:	6105                	addi	sp,sp,32
 216:	8082                	ret
    return -1;
 218:	597d                	li	s2,-1
 21a:	bfcd                	j	20c <stat+0x36>

000000000000021c <atoi>:

int
atoi(const char *s)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e406                	sd	ra,8(sp)
 220:	e022                	sd	s0,0(sp)
 222:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 224:	00054683          	lbu	a3,0(a0)
 228:	fd06879b          	addiw	a5,a3,-48
 22c:	0ff7f793          	zext.b	a5,a5
 230:	4625                	li	a2,9
 232:	02f66963          	bltu	a2,a5,264 <atoi+0x48>
 236:	872a                	mv	a4,a0
  n = 0;
 238:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 23a:	0705                	addi	a4,a4,1
 23c:	0025179b          	slliw	a5,a0,0x2
 240:	9fa9                	addw	a5,a5,a0
 242:	0017979b          	slliw	a5,a5,0x1
 246:	9fb5                	addw	a5,a5,a3
 248:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 24c:	00074683          	lbu	a3,0(a4)
 250:	fd06879b          	addiw	a5,a3,-48
 254:	0ff7f793          	zext.b	a5,a5
 258:	fef671e3          	bgeu	a2,a5,23a <atoi+0x1e>
  return n;
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  n = 0;
 264:	4501                	li	a0,0
 266:	bfdd                	j	25c <atoi+0x40>

0000000000000268 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 270:	02b57563          	bgeu	a0,a1,29a <memmove+0x32>
    while(n-- > 0)
 274:	00c05f63          	blez	a2,292 <memmove+0x2a>
 278:	1602                	slli	a2,a2,0x20
 27a:	9201                	srli	a2,a2,0x20
 27c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 280:	872a                	mv	a4,a0
      *dst++ = *src++;
 282:	0585                	addi	a1,a1,1
 284:	0705                	addi	a4,a4,1
 286:	fff5c683          	lbu	a3,-1(a1)
 28a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28e:	fee79ae3          	bne	a5,a4,282 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
    dst += n;
 29a:	00c50733          	add	a4,a0,a2
    src += n;
 29e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2a0:	fec059e3          	blez	a2,292 <memmove+0x2a>
 2a4:	fff6079b          	addiw	a5,a2,-1
 2a8:	1782                	slli	a5,a5,0x20
 2aa:	9381                	srli	a5,a5,0x20
 2ac:	fff7c793          	not	a5,a5
 2b0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2b2:	15fd                	addi	a1,a1,-1
 2b4:	177d                	addi	a4,a4,-1
 2b6:	0005c683          	lbu	a3,0(a1)
 2ba:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2be:	fef71ae3          	bne	a4,a5,2b2 <memmove+0x4a>
 2c2:	bfc1                	j	292 <memmove+0x2a>

00000000000002c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e406                	sd	ra,8(sp)
 2c8:	e022                	sd	s0,0(sp)
 2ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2cc:	ca0d                	beqz	a2,2fe <memcmp+0x3a>
 2ce:	fff6069b          	addiw	a3,a2,-1
 2d2:	1682                	slli	a3,a3,0x20
 2d4:	9281                	srli	a3,a3,0x20
 2d6:	0685                	addi	a3,a3,1
 2d8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2da:	00054783          	lbu	a5,0(a0)
 2de:	0005c703          	lbu	a4,0(a1)
 2e2:	00e79863          	bne	a5,a4,2f2 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 2e6:	0505                	addi	a0,a0,1
    p2++;
 2e8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ea:	fed518e3          	bne	a0,a3,2da <memcmp+0x16>
  }
  return 0;
 2ee:	4501                	li	a0,0
 2f0:	a019                	j	2f6 <memcmp+0x32>
      return *p1 - *p2;
 2f2:	40e7853b          	subw	a0,a5,a4
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret
  return 0;
 2fe:	4501                	li	a0,0
 300:	bfdd                	j	2f6 <memcmp+0x32>

0000000000000302 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 30a:	00000097          	auipc	ra,0x0
 30e:	f5e080e7          	jalr	-162(ra) # 268 <memmove>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exit>:
.global exit
exit:
 li a7, SYS_exit
 322:	4889                	li	a7,2
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <wait>:
.global wait
wait:
 li a7, SYS_wait
 32a:	488d                	li	a7,3
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 332:	4891                	li	a7,4
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <read>:
.global read
read:
 li a7, SYS_read
 33a:	4895                	li	a7,5
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <write>:
.global write
write:
 li a7, SYS_write
 342:	48c1                	li	a7,16
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <close>:
.global close
close:
 li a7, SYS_close
 34a:	48d5                	li	a7,21
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <kill>:
.global kill
kill:
 li a7, SYS_kill
 352:	4899                	li	a7,6
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exec>:
.global exec
exec:
 li a7, SYS_exec
 35a:	489d                	li	a7,7
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <open>:
.global open
open:
 li a7, SYS_open
 362:	48bd                	li	a7,15
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36a:	48c5                	li	a7,17
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 372:	48c9                	li	a7,18
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37a:	48a1                	li	a7,8
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <link>:
.global link
link:
 li a7, SYS_link
 382:	48cd                	li	a7,19
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38a:	48d1                	li	a7,20
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 392:	48a5                	li	a7,9
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <dup>:
.global dup
dup:
 li a7, SYS_dup
 39a:	48a9                	li	a7,10
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a2:	48ad                	li	a7,11
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3aa:	48b1                	li	a7,12
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3b2:	48b5                	li	a7,13
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ba:	48b9                	li	a7,14
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
 3c2:	48d9                	li	a7,22
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
 3ca:	48dd                	li	a7,23
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	00000097          	auipc	ra,0x0
 3e8:	f5e080e7          	jalr	-162(ra) # 342 <write>
}
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	7139                	addi	sp,sp,-64
 3f6:	fc06                	sd	ra,56(sp)
 3f8:	f822                	sd	s0,48(sp)
 3fa:	f426                	sd	s1,40(sp)
 3fc:	f04a                	sd	s2,32(sp)
 3fe:	ec4e                	sd	s3,24(sp)
 400:	0080                	addi	s0,sp,64
 402:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 404:	c299                	beqz	a3,40a <printint+0x16>
 406:	0805c063          	bltz	a1,486 <printint+0x92>
  neg = 0;
 40a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 40c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 410:	869a                	mv	a3,t1
  i = 0;
 412:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 414:	00000817          	auipc	a6,0x0
 418:	4bc80813          	addi	a6,a6,1212 # 8d0 <digits>
 41c:	88be                	mv	a7,a5
 41e:	0017851b          	addiw	a0,a5,1
 422:	87aa                	mv	a5,a0
 424:	02c5f73b          	remuw	a4,a1,a2
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	9742                	add	a4,a4,a6
 42e:	00074703          	lbu	a4,0(a4)
 432:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 436:	872e                	mv	a4,a1
 438:	02c5d5bb          	divuw	a1,a1,a2
 43c:	0685                	addi	a3,a3,1
 43e:	fcc77fe3          	bgeu	a4,a2,41c <printint+0x28>
  if(neg)
 442:	000e0c63          	beqz	t3,45a <printint+0x66>
    buf[i++] = '-';
 446:	fd050793          	addi	a5,a0,-48
 44a:	00878533          	add	a0,a5,s0
 44e:	02d00793          	li	a5,45
 452:	fef50823          	sb	a5,-16(a0)
 456:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 45a:	fff7899b          	addiw	s3,a5,-1
 45e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 462:	fff4c583          	lbu	a1,-1(s1)
 466:	854a                	mv	a0,s2
 468:	00000097          	auipc	ra,0x0
 46c:	f6a080e7          	jalr	-150(ra) # 3d2 <putc>
  while(--i >= 0)
 470:	39fd                	addiw	s3,s3,-1
 472:	14fd                	addi	s1,s1,-1
 474:	fe09d7e3          	bgez	s3,462 <printint+0x6e>
}
 478:	70e2                	ld	ra,56(sp)
 47a:	7442                	ld	s0,48(sp)
 47c:	74a2                	ld	s1,40(sp)
 47e:	7902                	ld	s2,32(sp)
 480:	69e2                	ld	s3,24(sp)
 482:	6121                	addi	sp,sp,64
 484:	8082                	ret
    x = -xx;
 486:	40b005bb          	negw	a1,a1
    neg = 1;
 48a:	4e05                	li	t3,1
    x = -xx;
 48c:	b741                	j	40c <printint+0x18>

000000000000048e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48e:	715d                	addi	sp,sp,-80
 490:	e486                	sd	ra,72(sp)
 492:	e0a2                	sd	s0,64(sp)
 494:	f84a                	sd	s2,48(sp)
 496:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 498:	0005c903          	lbu	s2,0(a1)
 49c:	1a090a63          	beqz	s2,650 <vprintf+0x1c2>
 4a0:	fc26                	sd	s1,56(sp)
 4a2:	f44e                	sd	s3,40(sp)
 4a4:	f052                	sd	s4,32(sp)
 4a6:	ec56                	sd	s5,24(sp)
 4a8:	e85a                	sd	s6,16(sp)
 4aa:	e45e                	sd	s7,8(sp)
 4ac:	8aaa                	mv	s5,a0
 4ae:	8bb2                	mv	s7,a2
 4b0:	00158493          	addi	s1,a1,1
  state = 0;
 4b4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b6:	02500a13          	li	s4,37
 4ba:	4b55                	li	s6,21
 4bc:	a839                	j	4da <vprintf+0x4c>
        putc(fd, c);
 4be:	85ca                	mv	a1,s2
 4c0:	8556                	mv	a0,s5
 4c2:	00000097          	auipc	ra,0x0
 4c6:	f10080e7          	jalr	-240(ra) # 3d2 <putc>
 4ca:	a019                	j	4d0 <vprintf+0x42>
    } else if(state == '%'){
 4cc:	01498d63          	beq	s3,s4,4e6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4d0:	0485                	addi	s1,s1,1
 4d2:	fff4c903          	lbu	s2,-1(s1)
 4d6:	16090763          	beqz	s2,644 <vprintf+0x1b6>
    if(state == 0){
 4da:	fe0999e3          	bnez	s3,4cc <vprintf+0x3e>
      if(c == '%'){
 4de:	ff4910e3          	bne	s2,s4,4be <vprintf+0x30>
        state = '%';
 4e2:	89d2                	mv	s3,s4
 4e4:	b7f5                	j	4d0 <vprintf+0x42>
      if(c == 'd'){
 4e6:	13490463          	beq	s2,s4,60e <vprintf+0x180>
 4ea:	f9d9079b          	addiw	a5,s2,-99
 4ee:	0ff7f793          	zext.b	a5,a5
 4f2:	12fb6763          	bltu	s6,a5,620 <vprintf+0x192>
 4f6:	f9d9079b          	addiw	a5,s2,-99
 4fa:	0ff7f713          	zext.b	a4,a5
 4fe:	12eb6163          	bltu	s6,a4,620 <vprintf+0x192>
 502:	00271793          	slli	a5,a4,0x2
 506:	00000717          	auipc	a4,0x0
 50a:	37270713          	addi	a4,a4,882 # 878 <malloc+0x134>
 50e:	97ba                	add	a5,a5,a4
 510:	439c                	lw	a5,0(a5)
 512:	97ba                	add	a5,a5,a4
 514:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 516:	008b8913          	addi	s2,s7,8
 51a:	4685                	li	a3,1
 51c:	4629                	li	a2,10
 51e:	000ba583          	lw	a1,0(s7)
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	ed0080e7          	jalr	-304(ra) # 3f4 <printint>
 52c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52e:	4981                	li	s3,0
 530:	b745                	j	4d0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 532:	008b8913          	addi	s2,s7,8
 536:	4681                	li	a3,0
 538:	4629                	li	a2,10
 53a:	000ba583          	lw	a1,0(s7)
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	eb4080e7          	jalr	-332(ra) # 3f4 <printint>
 548:	8bca                	mv	s7,s2
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b751                	j	4d0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 54e:	008b8913          	addi	s2,s7,8
 552:	4681                	li	a3,0
 554:	4641                	li	a2,16
 556:	000ba583          	lw	a1,0(s7)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e98080e7          	jalr	-360(ra) # 3f4 <printint>
 564:	8bca                	mv	s7,s2
      state = 0;
 566:	4981                	li	s3,0
 568:	b7a5                	j	4d0 <vprintf+0x42>
 56a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 56c:	008b8c13          	addi	s8,s7,8
 570:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 574:	03000593          	li	a1,48
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e58080e7          	jalr	-424(ra) # 3d2 <putc>
  putc(fd, 'x');
 582:	07800593          	li	a1,120
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e4a080e7          	jalr	-438(ra) # 3d2 <putc>
 590:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 592:	00000b97          	auipc	s7,0x0
 596:	33eb8b93          	addi	s7,s7,830 # 8d0 <digits>
 59a:	03c9d793          	srli	a5,s3,0x3c
 59e:	97de                	add	a5,a5,s7
 5a0:	0007c583          	lbu	a1,0(a5)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e2c080e7          	jalr	-468(ra) # 3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ae:	0992                	slli	s3,s3,0x4
 5b0:	397d                	addiw	s2,s2,-1
 5b2:	fe0914e3          	bnez	s2,59a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5b6:	8be2                	mv	s7,s8
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	6c02                	ld	s8,0(sp)
 5bc:	bf11                	j	4d0 <vprintf+0x42>
        s = va_arg(ap, char*);
 5be:	008b8993          	addi	s3,s7,8
 5c2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5c6:	02090163          	beqz	s2,5e8 <vprintf+0x15a>
        while(*s != 0){
 5ca:	00094583          	lbu	a1,0(s2)
 5ce:	c9a5                	beqz	a1,63e <vprintf+0x1b0>
          putc(fd, *s);
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e00080e7          	jalr	-512(ra) # 3d2 <putc>
          s++;
 5da:	0905                	addi	s2,s2,1
        while(*s != 0){
 5dc:	00094583          	lbu	a1,0(s2)
 5e0:	f9e5                	bnez	a1,5d0 <vprintf+0x142>
        s = va_arg(ap, char*);
 5e2:	8bce                	mv	s7,s3
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b5ed                	j	4d0 <vprintf+0x42>
          s = "(null)";
 5e8:	00000917          	auipc	s2,0x0
 5ec:	28890913          	addi	s2,s2,648 # 870 <malloc+0x12c>
        while(*s != 0){
 5f0:	02800593          	li	a1,40
 5f4:	bff1                	j	5d0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5f6:	008b8913          	addi	s2,s7,8
 5fa:	000bc583          	lbu	a1,0(s7)
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	dd2080e7          	jalr	-558(ra) # 3d2 <putc>
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b5d1                	j	4d0 <vprintf+0x42>
        putc(fd, c);
 60e:	02500593          	li	a1,37
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	dbe080e7          	jalr	-578(ra) # 3d2 <putc>
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bd4d                	j	4d0 <vprintf+0x42>
        putc(fd, '%');
 620:	02500593          	li	a1,37
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	dac080e7          	jalr	-596(ra) # 3d2 <putc>
        putc(fd, c);
 62e:	85ca                	mv	a1,s2
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	da0080e7          	jalr	-608(ra) # 3d2 <putc>
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bd51                	j	4d0 <vprintf+0x42>
        s = va_arg(ap, char*);
 63e:	8bce                	mv	s7,s3
      state = 0;
 640:	4981                	li	s3,0
 642:	b579                	j	4d0 <vprintf+0x42>
 644:	74e2                	ld	s1,56(sp)
 646:	79a2                	ld	s3,40(sp)
 648:	7a02                	ld	s4,32(sp)
 64a:	6ae2                	ld	s5,24(sp)
 64c:	6b42                	ld	s6,16(sp)
 64e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 650:	60a6                	ld	ra,72(sp)
 652:	6406                	ld	s0,64(sp)
 654:	7942                	ld	s2,48(sp)
 656:	6161                	addi	sp,sp,80
 658:	8082                	ret

000000000000065a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 65a:	715d                	addi	sp,sp,-80
 65c:	ec06                	sd	ra,24(sp)
 65e:	e822                	sd	s0,16(sp)
 660:	1000                	addi	s0,sp,32
 662:	e010                	sd	a2,0(s0)
 664:	e414                	sd	a3,8(s0)
 666:	e818                	sd	a4,16(s0)
 668:	ec1c                	sd	a5,24(s0)
 66a:	03043023          	sd	a6,32(s0)
 66e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 672:	8622                	mv	a2,s0
 674:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 678:	00000097          	auipc	ra,0x0
 67c:	e16080e7          	jalr	-490(ra) # 48e <vprintf>
}
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6161                	addi	sp,sp,80
 686:	8082                	ret

0000000000000688 <printf>:

void
printf(const char *fmt, ...)
{
 688:	711d                	addi	sp,sp,-96
 68a:	ec06                	sd	ra,24(sp)
 68c:	e822                	sd	s0,16(sp)
 68e:	1000                	addi	s0,sp,32
 690:	e40c                	sd	a1,8(s0)
 692:	e810                	sd	a2,16(s0)
 694:	ec14                	sd	a3,24(s0)
 696:	f018                	sd	a4,32(s0)
 698:	f41c                	sd	a5,40(s0)
 69a:	03043823          	sd	a6,48(s0)
 69e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	00840613          	addi	a2,s0,8
 6a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6aa:	85aa                	mv	a1,a0
 6ac:	4505                	li	a0,1
 6ae:	00000097          	auipc	ra,0x0
 6b2:	de0080e7          	jalr	-544(ra) # 48e <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6125                	addi	sp,sp,96
 6bc:	8082                	ret

00000000000006be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6be:	1141                	addi	sp,sp,-16
 6c0:	e406                	sd	ra,8(sp)
 6c2:	e022                	sd	s0,0(sp)
 6c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ca:	00000797          	auipc	a5,0x0
 6ce:	21e7b783          	ld	a5,542(a5) # 8e8 <freep>
 6d2:	a02d                	j	6fc <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d4:	4618                	lw	a4,8(a2)
 6d6:	9f2d                	addw	a4,a4,a1
 6d8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6dc:	6398                	ld	a4,0(a5)
 6de:	6310                	ld	a2,0(a4)
 6e0:	a83d                	j	71e <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e2:	ff852703          	lw	a4,-8(a0)
 6e6:	9f31                	addw	a4,a4,a2
 6e8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6ea:	ff053683          	ld	a3,-16(a0)
 6ee:	a091                	j	732 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	6398                	ld	a4,0(a5)
 6f2:	00e7e463          	bltu	a5,a4,6fa <free+0x3c>
 6f6:	00e6ea63          	bltu	a3,a4,70a <free+0x4c>
{
 6fa:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fc:	fed7fae3          	bgeu	a5,a3,6f0 <free+0x32>
 700:	6398                	ld	a4,0(a5)
 702:	00e6e463          	bltu	a3,a4,70a <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 706:	fee7eae3          	bltu	a5,a4,6fa <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 70a:	ff852583          	lw	a1,-8(a0)
 70e:	6390                	ld	a2,0(a5)
 710:	02059813          	slli	a6,a1,0x20
 714:	01c85713          	srli	a4,a6,0x1c
 718:	9736                	add	a4,a4,a3
 71a:	fae60de3          	beq	a2,a4,6d4 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 71e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 722:	4790                	lw	a2,8(a5)
 724:	02061593          	slli	a1,a2,0x20
 728:	01c5d713          	srli	a4,a1,0x1c
 72c:	973e                	add	a4,a4,a5
 72e:	fae68ae3          	beq	a3,a4,6e2 <free+0x24>
    p->s.ptr = bp->s.ptr;
 732:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 734:	00000717          	auipc	a4,0x0
 738:	1af73a23          	sd	a5,436(a4) # 8e8 <freep>
}
 73c:	60a2                	ld	ra,8(sp)
 73e:	6402                	ld	s0,0(sp)
 740:	0141                	addi	sp,sp,16
 742:	8082                	ret

0000000000000744 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 744:	7139                	addi	sp,sp,-64
 746:	fc06                	sd	ra,56(sp)
 748:	f822                	sd	s0,48(sp)
 74a:	f04a                	sd	s2,32(sp)
 74c:	ec4e                	sd	s3,24(sp)
 74e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 750:	02051993          	slli	s3,a0,0x20
 754:	0209d993          	srli	s3,s3,0x20
 758:	09bd                	addi	s3,s3,15
 75a:	0049d993          	srli	s3,s3,0x4
 75e:	2985                	addiw	s3,s3,1
 760:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 762:	00000517          	auipc	a0,0x0
 766:	18653503          	ld	a0,390(a0) # 8e8 <freep>
 76a:	c905                	beqz	a0,79a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76e:	4798                	lw	a4,8(a5)
 770:	09377a63          	bgeu	a4,s3,804 <malloc+0xc0>
 774:	f426                	sd	s1,40(sp)
 776:	e852                	sd	s4,16(sp)
 778:	e456                	sd	s5,8(sp)
 77a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 77c:	8a4e                	mv	s4,s3
 77e:	6705                	lui	a4,0x1
 780:	00e9f363          	bgeu	s3,a4,786 <malloc+0x42>
 784:	6a05                	lui	s4,0x1
 786:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 78a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78e:	00000497          	auipc	s1,0x0
 792:	15a48493          	addi	s1,s1,346 # 8e8 <freep>
  if(p == (char*)-1)
 796:	5afd                	li	s5,-1
 798:	a089                	j	7da <malloc+0x96>
 79a:	f426                	sd	s1,40(sp)
 79c:	e852                	sd	s4,16(sp)
 79e:	e456                	sd	s5,8(sp)
 7a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7a2:	00000797          	auipc	a5,0x0
 7a6:	14e78793          	addi	a5,a5,334 # 8f0 <base>
 7aa:	00000717          	auipc	a4,0x0
 7ae:	12f73f23          	sd	a5,318(a4) # 8e8 <freep>
 7b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b8:	b7d1                	j	77c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7ba:	6398                	ld	a4,0(a5)
 7bc:	e118                	sd	a4,0(a0)
 7be:	a8b9                	j	81c <malloc+0xd8>
  hp->s.size = nu;
 7c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7c4:	0541                	addi	a0,a0,16
 7c6:	00000097          	auipc	ra,0x0
 7ca:	ef8080e7          	jalr	-264(ra) # 6be <free>
  return freep;
 7ce:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 7d0:	c135                	beqz	a0,834 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d4:	4798                	lw	a4,8(a5)
 7d6:	03277363          	bgeu	a4,s2,7fc <malloc+0xb8>
    if(p == freep)
 7da:	6098                	ld	a4,0(s1)
 7dc:	853e                	mv	a0,a5
 7de:	fef71ae3          	bne	a4,a5,7d2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7e2:	8552                	mv	a0,s4
 7e4:	00000097          	auipc	ra,0x0
 7e8:	bc6080e7          	jalr	-1082(ra) # 3aa <sbrk>
  if(p == (char*)-1)
 7ec:	fd551ae3          	bne	a0,s5,7c0 <malloc+0x7c>
        return 0;
 7f0:	4501                	li	a0,0
 7f2:	74a2                	ld	s1,40(sp)
 7f4:	6a42                	ld	s4,16(sp)
 7f6:	6aa2                	ld	s5,8(sp)
 7f8:	6b02                	ld	s6,0(sp)
 7fa:	a03d                	j	828 <malloc+0xe4>
 7fc:	74a2                	ld	s1,40(sp)
 7fe:	6a42                	ld	s4,16(sp)
 800:	6aa2                	ld	s5,8(sp)
 802:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 804:	fae90be3          	beq	s2,a4,7ba <malloc+0x76>
        p->s.size -= nunits;
 808:	4137073b          	subw	a4,a4,s3
 80c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 80e:	02071693          	slli	a3,a4,0x20
 812:	01c6d713          	srli	a4,a3,0x1c
 816:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 818:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 81c:	00000717          	auipc	a4,0x0
 820:	0ca73623          	sd	a0,204(a4) # 8e8 <freep>
      return (void*)(p + 1);
 824:	01078513          	addi	a0,a5,16
  }
}
 828:	70e2                	ld	ra,56(sp)
 82a:	7442                	ld	s0,48(sp)
 82c:	7902                	ld	s2,32(sp)
 82e:	69e2                	ld	s3,24(sp)
 830:	6121                	addi	sp,sp,64
 832:	8082                	ret
 834:	74a2                	ld	s1,40(sp)
 836:	6a42                	ld	s4,16(sp)
 838:	6aa2                	ld	s5,8(sp)
 83a:	6b02                	ld	s6,0(sp)
 83c:	b7f5                	j	828 <malloc+0xe4>
