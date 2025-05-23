
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       8:	611c                	ld	a5,0(a0)
       a:	0017d693          	srli	a3,a5,0x1
       e:	c0000737          	lui	a4,0xc0000
      12:	0705                	addi	a4,a4,1 # ffffffffc0000001 <__global_pointer$+0xffffffffbfffe030>
      14:	1706                	slli	a4,a4,0x21
      16:	0725                	addi	a4,a4,9
      18:	02e6b733          	mulhu	a4,a3,a4
      1c:	8375                	srli	a4,a4,0x1d
      1e:	01e71693          	slli	a3,a4,0x1e
      22:	40e68733          	sub	a4,a3,a4
      26:	0706                	slli	a4,a4,0x1
      28:	8f99                	sub	a5,a5,a4
      2a:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      2c:	1fe406b7          	lui	a3,0x1fe40
      30:	b7968693          	addi	a3,a3,-1159 # 1fe3fb79 <__global_pointer$+0x1fe3dba8>
      34:	41a70737          	lui	a4,0x41a70
      38:	5af70713          	addi	a4,a4,1455 # 41a705af <__global_pointer$+0x41a6e5de>
      3c:	1702                	slli	a4,a4,0x20
      3e:	9736                	add	a4,a4,a3
      40:	02e79733          	mulh	a4,a5,a4
      44:	873d                	srai	a4,a4,0xf
      46:	43f7d693          	srai	a3,a5,0x3f
      4a:	8f15                	sub	a4,a4,a3
      4c:	66fd                	lui	a3,0x1f
      4e:	31d68693          	addi	a3,a3,797 # 1f31d <__global_pointer$+0x1d34c>
      52:	02d706b3          	mul	a3,a4,a3
      56:	8f95                	sub	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      58:	6691                	lui	a3,0x4
      5a:	1a768693          	addi	a3,a3,423 # 41a7 <__global_pointer$+0x21d6>
      5e:	02d787b3          	mul	a5,a5,a3
      62:	76fd                	lui	a3,0xfffff
      64:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <__global_pointer$+0xffffffffffffd51b>
      68:	02d70733          	mul	a4,a4,a3
      6c:	97ba                	add	a5,a5,a4
    if (x < 0)
      6e:	0007ca63          	bltz	a5,82 <do_rand+0x82>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      72:	17fd                	addi	a5,a5,-1
    *ctx = x;
      74:	e11c                	sd	a5,0(a0)
    return (x);
}
      76:	0007851b          	sext.w	a0,a5
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
        x += 0x7fffffff;
      82:	80000737          	lui	a4,0x80000
      86:	fff74713          	not	a4,a4
      8a:	97ba                	add	a5,a5,a4
      8c:	b7dd                	j	72 <do_rand+0x72>

000000000000008e <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      8e:	1141                	addi	sp,sp,-16
      90:	e406                	sd	ra,8(sp)
      92:	e022                	sd	s0,0(sp)
      94:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      96:	00001517          	auipc	a0,0x1
      9a:	74250513          	addi	a0,a0,1858 # 17d8 <rand_next>
      9e:	00000097          	auipc	ra,0x0
      a2:	f62080e7          	jalr	-158(ra) # 0 <do_rand>
}
      a6:	60a2                	ld	ra,8(sp)
      a8:	6402                	ld	s0,0(sp)
      aa:	0141                	addi	sp,sp,16
      ac:	8082                	ret

00000000000000ae <go>:

void
go(int which_child)
{
      ae:	7171                	addi	sp,sp,-176
      b0:	f506                	sd	ra,168(sp)
      b2:	f122                	sd	s0,160(sp)
      b4:	ed26                	sd	s1,152(sp)
      b6:	1900                	addi	s0,sp,176
      b8:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      ba:	4501                	li	a0,0
      bc:	00001097          	auipc	ra,0x1
      c0:	ea4080e7          	jalr	-348(ra) # f60 <sbrk>
      c4:	f4a43c23          	sd	a0,-168(s0)
  uint64 iters = 0;

  mkdir("grindir");
      c8:	00001517          	auipc	a0,0x1
      cc:	33050513          	addi	a0,a0,816 # 13f8 <malloc+0xfe>
      d0:	00001097          	auipc	ra,0x1
      d4:	e70080e7          	jalr	-400(ra) # f40 <mkdir>
  if(chdir("grindir") != 0){
      d8:	00001517          	auipc	a0,0x1
      dc:	32050513          	addi	a0,a0,800 # 13f8 <malloc+0xfe>
      e0:	00001097          	auipc	ra,0x1
      e4:	e68080e7          	jalr	-408(ra) # f48 <chdir>
      e8:	c905                	beqz	a0,118 <go+0x6a>
      ea:	e94a                	sd	s2,144(sp)
      ec:	e54e                	sd	s3,136(sp)
      ee:	e152                	sd	s4,128(sp)
      f0:	fcd6                	sd	s5,120(sp)
      f2:	f8da                	sd	s6,112(sp)
      f4:	f4de                	sd	s7,104(sp)
      f6:	f0e2                	sd	s8,96(sp)
      f8:	ece6                	sd	s9,88(sp)
      fa:	e8ea                	sd	s10,80(sp)
      fc:	e4ee                	sd	s11,72(sp)
    printf("grind: chdir grindir failed\n");
      fe:	00001517          	auipc	a0,0x1
     102:	30250513          	addi	a0,a0,770 # 1400 <malloc+0x106>
     106:	00001097          	auipc	ra,0x1
     10a:	138080e7          	jalr	312(ra) # 123e <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00001097          	auipc	ra,0x1
     114:	dc8080e7          	jalr	-568(ra) # ed8 <exit>
     118:	e94a                	sd	s2,144(sp)
     11a:	e54e                	sd	s3,136(sp)
     11c:	e152                	sd	s4,128(sp)
     11e:	fcd6                	sd	s5,120(sp)
     120:	f8da                	sd	s6,112(sp)
     122:	f4de                	sd	s7,104(sp)
     124:	f0e2                	sd	s8,96(sp)
     126:	ece6                	sd	s9,88(sp)
     128:	e8ea                	sd	s10,80(sp)
     12a:	e4ee                	sd	s11,72(sp)
  }
  chdir("/");
     12c:	00001517          	auipc	a0,0x1
     130:	2fc50513          	addi	a0,a0,764 # 1428 <malloc+0x12e>
     134:	00001097          	auipc	ra,0x1
     138:	e14080e7          	jalr	-492(ra) # f48 <chdir>
     13c:	00001c17          	auipc	s8,0x1
     140:	2fcc0c13          	addi	s8,s8,764 # 1438 <malloc+0x13e>
     144:	c489                	beqz	s1,14e <go+0xa0>
     146:	00001c17          	auipc	s8,0x1
     14a:	2eac0c13          	addi	s8,s8,746 # 1430 <malloc+0x136>
  uint64 iters = 0;
     14e:	4481                	li	s1,0
  int fd = -1;
     150:	5cfd                	li	s9,-1
  
  while(1){
    iters++;
    if((iters % 500) == 0)
     152:	e353f7b7          	lui	a5,0xe353f
     156:	7cf78793          	addi	a5,a5,1999 # ffffffffe353f7cf <__global_pointer$+0xffffffffe353d7fe>
     15a:	20c4a9b7          	lui	s3,0x20c4a
     15e:	ba698993          	addi	s3,s3,-1114 # 20c49ba6 <__global_pointer$+0x20c47bd5>
     162:	1982                	slli	s3,s3,0x20
     164:	99be                	add	s3,s3,a5
     166:	1f400b13          	li	s6,500
      write(1, which_child?"B":"A", 1);
     16a:	4b85                	li	s7,1
    int what = rand() % 23;
     16c:	b2164a37          	lui	s4,0xb2164
     170:	2c9a0a13          	addi	s4,s4,713 # ffffffffb21642c9 <__global_pointer$+0xffffffffb21622f8>
     174:	4ad9                	li	s5,22
     176:	00001917          	auipc	s2,0x1
     17a:	59290913          	addi	s2,s2,1426 # 1708 <malloc+0x40e>
      close(fd1);
      unlink("c");
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     17e:	f6840d93          	addi	s11,s0,-152
     182:	a839                	j	1a0 <go+0xf2>
      close(open("grindir/../a", O_CREATE|O_RDWR));
     184:	20200593          	li	a1,514
     188:	00001517          	auipc	a0,0x1
     18c:	2b850513          	addi	a0,a0,696 # 1440 <malloc+0x146>
     190:	00001097          	auipc	ra,0x1
     194:	d88080e7          	jalr	-632(ra) # f18 <open>
     198:	00001097          	auipc	ra,0x1
     19c:	d68080e7          	jalr	-664(ra) # f00 <close>
    iters++;
     1a0:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     1a2:	0024d793          	srli	a5,s1,0x2
     1a6:	0337b7b3          	mulhu	a5,a5,s3
     1aa:	8391                	srli	a5,a5,0x4
     1ac:	036787b3          	mul	a5,a5,s6
     1b0:	00f49963          	bne	s1,a5,1c2 <go+0x114>
      write(1, which_child?"B":"A", 1);
     1b4:	865e                	mv	a2,s7
     1b6:	85e2                	mv	a1,s8
     1b8:	855e                	mv	a0,s7
     1ba:	00001097          	auipc	ra,0x1
     1be:	d3e080e7          	jalr	-706(ra) # ef8 <write>
    int what = rand() % 23;
     1c2:	00000097          	auipc	ra,0x0
     1c6:	ecc080e7          	jalr	-308(ra) # 8e <rand>
     1ca:	034507b3          	mul	a5,a0,s4
     1ce:	9381                	srli	a5,a5,0x20
     1d0:	9fa9                	addw	a5,a5,a0
     1d2:	4047d79b          	sraiw	a5,a5,0x4
     1d6:	41f5571b          	sraiw	a4,a0,0x1f
     1da:	9f99                	subw	a5,a5,a4
     1dc:	0017971b          	slliw	a4,a5,0x1
     1e0:	9f3d                	addw	a4,a4,a5
     1e2:	0037171b          	slliw	a4,a4,0x3
     1e6:	40f707bb          	subw	a5,a4,a5
     1ea:	9d1d                	subw	a0,a0,a5
     1ec:	faaaeae3          	bltu	s5,a0,1a0 <go+0xf2>
     1f0:	02051793          	slli	a5,a0,0x20
     1f4:	01e7d513          	srli	a0,a5,0x1e
     1f8:	954a                	add	a0,a0,s2
     1fa:	411c                	lw	a5,0(a0)
     1fc:	97ca                	add	a5,a5,s2
     1fe:	8782                	jr	a5
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     200:	20200593          	li	a1,514
     204:	00001517          	auipc	a0,0x1
     208:	24c50513          	addi	a0,a0,588 # 1450 <malloc+0x156>
     20c:	00001097          	auipc	ra,0x1
     210:	d0c080e7          	jalr	-756(ra) # f18 <open>
     214:	00001097          	auipc	ra,0x1
     218:	cec080e7          	jalr	-788(ra) # f00 <close>
     21c:	b751                	j	1a0 <go+0xf2>
      unlink("grindir/../a");
     21e:	00001517          	auipc	a0,0x1
     222:	22250513          	addi	a0,a0,546 # 1440 <malloc+0x146>
     226:	00001097          	auipc	ra,0x1
     22a:	d02080e7          	jalr	-766(ra) # f28 <unlink>
     22e:	bf8d                	j	1a0 <go+0xf2>
      if(chdir("grindir") != 0){
     230:	00001517          	auipc	a0,0x1
     234:	1c850513          	addi	a0,a0,456 # 13f8 <malloc+0xfe>
     238:	00001097          	auipc	ra,0x1
     23c:	d10080e7          	jalr	-752(ra) # f48 <chdir>
     240:	e115                	bnez	a0,264 <go+0x1b6>
      unlink("../b");
     242:	00001517          	auipc	a0,0x1
     246:	22650513          	addi	a0,a0,550 # 1468 <malloc+0x16e>
     24a:	00001097          	auipc	ra,0x1
     24e:	cde080e7          	jalr	-802(ra) # f28 <unlink>
      chdir("/");
     252:	00001517          	auipc	a0,0x1
     256:	1d650513          	addi	a0,a0,470 # 1428 <malloc+0x12e>
     25a:	00001097          	auipc	ra,0x1
     25e:	cee080e7          	jalr	-786(ra) # f48 <chdir>
     262:	bf3d                	j	1a0 <go+0xf2>
        printf("grind: chdir grindir failed\n");
     264:	00001517          	auipc	a0,0x1
     268:	19c50513          	addi	a0,a0,412 # 1400 <malloc+0x106>
     26c:	00001097          	auipc	ra,0x1
     270:	fd2080e7          	jalr	-46(ra) # 123e <printf>
        exit(1);
     274:	4505                	li	a0,1
     276:	00001097          	auipc	ra,0x1
     27a:	c62080e7          	jalr	-926(ra) # ed8 <exit>
      close(fd);
     27e:	8566                	mv	a0,s9
     280:	00001097          	auipc	ra,0x1
     284:	c80080e7          	jalr	-896(ra) # f00 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     288:	20200593          	li	a1,514
     28c:	00001517          	auipc	a0,0x1
     290:	1e450513          	addi	a0,a0,484 # 1470 <malloc+0x176>
     294:	00001097          	auipc	ra,0x1
     298:	c84080e7          	jalr	-892(ra) # f18 <open>
     29c:	8caa                	mv	s9,a0
     29e:	b709                	j	1a0 <go+0xf2>
      close(fd);
     2a0:	8566                	mv	a0,s9
     2a2:	00001097          	auipc	ra,0x1
     2a6:	c5e080e7          	jalr	-930(ra) # f00 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     2aa:	20200593          	li	a1,514
     2ae:	00001517          	auipc	a0,0x1
     2b2:	1d250513          	addi	a0,a0,466 # 1480 <malloc+0x186>
     2b6:	00001097          	auipc	ra,0x1
     2ba:	c62080e7          	jalr	-926(ra) # f18 <open>
     2be:	8caa                	mv	s9,a0
     2c0:	b5c5                	j	1a0 <go+0xf2>
      write(fd, buf, sizeof(buf));
     2c2:	3e700613          	li	a2,999
     2c6:	00001597          	auipc	a1,0x1
     2ca:	52258593          	addi	a1,a1,1314 # 17e8 <buf.0>
     2ce:	8566                	mv	a0,s9
     2d0:	00001097          	auipc	ra,0x1
     2d4:	c28080e7          	jalr	-984(ra) # ef8 <write>
     2d8:	b5e1                	j	1a0 <go+0xf2>
      read(fd, buf, sizeof(buf));
     2da:	3e700613          	li	a2,999
     2de:	00001597          	auipc	a1,0x1
     2e2:	50a58593          	addi	a1,a1,1290 # 17e8 <buf.0>
     2e6:	8566                	mv	a0,s9
     2e8:	00001097          	auipc	ra,0x1
     2ec:	c08080e7          	jalr	-1016(ra) # ef0 <read>
     2f0:	bd45                	j	1a0 <go+0xf2>
      mkdir("grindir/../a");
     2f2:	00001517          	auipc	a0,0x1
     2f6:	14e50513          	addi	a0,a0,334 # 1440 <malloc+0x146>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	c46080e7          	jalr	-954(ra) # f40 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     302:	20200593          	li	a1,514
     306:	00001517          	auipc	a0,0x1
     30a:	19250513          	addi	a0,a0,402 # 1498 <malloc+0x19e>
     30e:	00001097          	auipc	ra,0x1
     312:	c0a080e7          	jalr	-1014(ra) # f18 <open>
     316:	00001097          	auipc	ra,0x1
     31a:	bea080e7          	jalr	-1046(ra) # f00 <close>
      unlink("a/a");
     31e:	00001517          	auipc	a0,0x1
     322:	18a50513          	addi	a0,a0,394 # 14a8 <malloc+0x1ae>
     326:	00001097          	auipc	ra,0x1
     32a:	c02080e7          	jalr	-1022(ra) # f28 <unlink>
     32e:	bd8d                	j	1a0 <go+0xf2>
      mkdir("/../b");
     330:	00001517          	auipc	a0,0x1
     334:	18050513          	addi	a0,a0,384 # 14b0 <malloc+0x1b6>
     338:	00001097          	auipc	ra,0x1
     33c:	c08080e7          	jalr	-1016(ra) # f40 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     340:	20200593          	li	a1,514
     344:	00001517          	auipc	a0,0x1
     348:	17450513          	addi	a0,a0,372 # 14b8 <malloc+0x1be>
     34c:	00001097          	auipc	ra,0x1
     350:	bcc080e7          	jalr	-1076(ra) # f18 <open>
     354:	00001097          	auipc	ra,0x1
     358:	bac080e7          	jalr	-1108(ra) # f00 <close>
      unlink("b/b");
     35c:	00001517          	auipc	a0,0x1
     360:	16c50513          	addi	a0,a0,364 # 14c8 <malloc+0x1ce>
     364:	00001097          	auipc	ra,0x1
     368:	bc4080e7          	jalr	-1084(ra) # f28 <unlink>
     36c:	bd15                	j	1a0 <go+0xf2>
      unlink("b");
     36e:	00001517          	auipc	a0,0x1
     372:	16250513          	addi	a0,a0,354 # 14d0 <malloc+0x1d6>
     376:	00001097          	auipc	ra,0x1
     37a:	bb2080e7          	jalr	-1102(ra) # f28 <unlink>
      link("../grindir/./../a", "../b");
     37e:	00001597          	auipc	a1,0x1
     382:	0ea58593          	addi	a1,a1,234 # 1468 <malloc+0x16e>
     386:	00001517          	auipc	a0,0x1
     38a:	15250513          	addi	a0,a0,338 # 14d8 <malloc+0x1de>
     38e:	00001097          	auipc	ra,0x1
     392:	baa080e7          	jalr	-1110(ra) # f38 <link>
     396:	b529                	j	1a0 <go+0xf2>
      unlink("../grindir/../a");
     398:	00001517          	auipc	a0,0x1
     39c:	15850513          	addi	a0,a0,344 # 14f0 <malloc+0x1f6>
     3a0:	00001097          	auipc	ra,0x1
     3a4:	b88080e7          	jalr	-1144(ra) # f28 <unlink>
      link(".././b", "/grindir/../a");
     3a8:	00001597          	auipc	a1,0x1
     3ac:	0c858593          	addi	a1,a1,200 # 1470 <malloc+0x176>
     3b0:	00001517          	auipc	a0,0x1
     3b4:	15050513          	addi	a0,a0,336 # 1500 <malloc+0x206>
     3b8:	00001097          	auipc	ra,0x1
     3bc:	b80080e7          	jalr	-1152(ra) # f38 <link>
     3c0:	b3c5                	j	1a0 <go+0xf2>
      int pid = fork();
     3c2:	00001097          	auipc	ra,0x1
     3c6:	b0e080e7          	jalr	-1266(ra) # ed0 <fork>
      if(pid == 0){
     3ca:	c909                	beqz	a0,3dc <go+0x32e>
      } else if(pid < 0){
     3cc:	00054c63          	bltz	a0,3e4 <go+0x336>
      wait(0);
     3d0:	4501                	li	a0,0
     3d2:	00001097          	auipc	ra,0x1
     3d6:	b0e080e7          	jalr	-1266(ra) # ee0 <wait>
     3da:	b3d9                	j	1a0 <go+0xf2>
        exit(0);
     3dc:	00001097          	auipc	ra,0x1
     3e0:	afc080e7          	jalr	-1284(ra) # ed8 <exit>
        printf("grind: fork failed\n");
     3e4:	00001517          	auipc	a0,0x1
     3e8:	12450513          	addi	a0,a0,292 # 1508 <malloc+0x20e>
     3ec:	00001097          	auipc	ra,0x1
     3f0:	e52080e7          	jalr	-430(ra) # 123e <printf>
        exit(1);
     3f4:	4505                	li	a0,1
     3f6:	00001097          	auipc	ra,0x1
     3fa:	ae2080e7          	jalr	-1310(ra) # ed8 <exit>
      int pid = fork();
     3fe:	00001097          	auipc	ra,0x1
     402:	ad2080e7          	jalr	-1326(ra) # ed0 <fork>
      if(pid == 0){
     406:	c909                	beqz	a0,418 <go+0x36a>
      } else if(pid < 0){
     408:	02054563          	bltz	a0,432 <go+0x384>
      wait(0);
     40c:	4501                	li	a0,0
     40e:	00001097          	auipc	ra,0x1
     412:	ad2080e7          	jalr	-1326(ra) # ee0 <wait>
     416:	b369                	j	1a0 <go+0xf2>
        fork();
     418:	00001097          	auipc	ra,0x1
     41c:	ab8080e7          	jalr	-1352(ra) # ed0 <fork>
        fork();
     420:	00001097          	auipc	ra,0x1
     424:	ab0080e7          	jalr	-1360(ra) # ed0 <fork>
        exit(0);
     428:	4501                	li	a0,0
     42a:	00001097          	auipc	ra,0x1
     42e:	aae080e7          	jalr	-1362(ra) # ed8 <exit>
        printf("grind: fork failed\n");
     432:	00001517          	auipc	a0,0x1
     436:	0d650513          	addi	a0,a0,214 # 1508 <malloc+0x20e>
     43a:	00001097          	auipc	ra,0x1
     43e:	e04080e7          	jalr	-508(ra) # 123e <printf>
        exit(1);
     442:	4505                	li	a0,1
     444:	00001097          	auipc	ra,0x1
     448:	a94080e7          	jalr	-1388(ra) # ed8 <exit>
      sbrk(6011);
     44c:	6505                	lui	a0,0x1
     44e:	77b50513          	addi	a0,a0,1915 # 177b <malloc+0x481>
     452:	00001097          	auipc	ra,0x1
     456:	b0e080e7          	jalr	-1266(ra) # f60 <sbrk>
     45a:	b399                	j	1a0 <go+0xf2>
      if(sbrk(0) > break0)
     45c:	4501                	li	a0,0
     45e:	00001097          	auipc	ra,0x1
     462:	b02080e7          	jalr	-1278(ra) # f60 <sbrk>
     466:	f5843783          	ld	a5,-168(s0)
     46a:	d2a7fbe3          	bgeu	a5,a0,1a0 <go+0xf2>
        sbrk(-(sbrk(0) - break0));
     46e:	4501                	li	a0,0
     470:	00001097          	auipc	ra,0x1
     474:	af0080e7          	jalr	-1296(ra) # f60 <sbrk>
     478:	f5843783          	ld	a5,-168(s0)
     47c:	40a7853b          	subw	a0,a5,a0
     480:	00001097          	auipc	ra,0x1
     484:	ae0080e7          	jalr	-1312(ra) # f60 <sbrk>
     488:	bb21                	j	1a0 <go+0xf2>
      int pid = fork();
     48a:	00001097          	auipc	ra,0x1
     48e:	a46080e7          	jalr	-1466(ra) # ed0 <fork>
     492:	8d2a                	mv	s10,a0
      if(pid == 0){
     494:	c51d                	beqz	a0,4c2 <go+0x414>
      } else if(pid < 0){
     496:	04054963          	bltz	a0,4e8 <go+0x43a>
      if(chdir("../grindir/..") != 0){
     49a:	00001517          	auipc	a0,0x1
     49e:	08e50513          	addi	a0,a0,142 # 1528 <malloc+0x22e>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	aa6080e7          	jalr	-1370(ra) # f48 <chdir>
     4aa:	ed21                	bnez	a0,502 <go+0x454>
      kill(pid);
     4ac:	856a                	mv	a0,s10
     4ae:	00001097          	auipc	ra,0x1
     4b2:	a5a080e7          	jalr	-1446(ra) # f08 <kill>
      wait(0);
     4b6:	4501                	li	a0,0
     4b8:	00001097          	auipc	ra,0x1
     4bc:	a28080e7          	jalr	-1496(ra) # ee0 <wait>
     4c0:	b1c5                	j	1a0 <go+0xf2>
        close(open("a", O_CREATE|O_RDWR));
     4c2:	20200593          	li	a1,514
     4c6:	00001517          	auipc	a0,0x1
     4ca:	05a50513          	addi	a0,a0,90 # 1520 <malloc+0x226>
     4ce:	00001097          	auipc	ra,0x1
     4d2:	a4a080e7          	jalr	-1462(ra) # f18 <open>
     4d6:	00001097          	auipc	ra,0x1
     4da:	a2a080e7          	jalr	-1494(ra) # f00 <close>
        exit(0);
     4de:	4501                	li	a0,0
     4e0:	00001097          	auipc	ra,0x1
     4e4:	9f8080e7          	jalr	-1544(ra) # ed8 <exit>
        printf("grind: fork failed\n");
     4e8:	00001517          	auipc	a0,0x1
     4ec:	02050513          	addi	a0,a0,32 # 1508 <malloc+0x20e>
     4f0:	00001097          	auipc	ra,0x1
     4f4:	d4e080e7          	jalr	-690(ra) # 123e <printf>
        exit(1);
     4f8:	4505                	li	a0,1
     4fa:	00001097          	auipc	ra,0x1
     4fe:	9de080e7          	jalr	-1570(ra) # ed8 <exit>
        printf("grind: chdir failed\n");
     502:	00001517          	auipc	a0,0x1
     506:	03650513          	addi	a0,a0,54 # 1538 <malloc+0x23e>
     50a:	00001097          	auipc	ra,0x1
     50e:	d34080e7          	jalr	-716(ra) # 123e <printf>
        exit(1);
     512:	4505                	li	a0,1
     514:	00001097          	auipc	ra,0x1
     518:	9c4080e7          	jalr	-1596(ra) # ed8 <exit>
      int pid = fork();
     51c:	00001097          	auipc	ra,0x1
     520:	9b4080e7          	jalr	-1612(ra) # ed0 <fork>
      if(pid == 0){
     524:	c909                	beqz	a0,536 <go+0x488>
      } else if(pid < 0){
     526:	02054563          	bltz	a0,550 <go+0x4a2>
      wait(0);
     52a:	4501                	li	a0,0
     52c:	00001097          	auipc	ra,0x1
     530:	9b4080e7          	jalr	-1612(ra) # ee0 <wait>
     534:	b1b5                	j	1a0 <go+0xf2>
        kill(getpid());
     536:	00001097          	auipc	ra,0x1
     53a:	a22080e7          	jalr	-1502(ra) # f58 <getpid>
     53e:	00001097          	auipc	ra,0x1
     542:	9ca080e7          	jalr	-1590(ra) # f08 <kill>
        exit(0);
     546:	4501                	li	a0,0
     548:	00001097          	auipc	ra,0x1
     54c:	990080e7          	jalr	-1648(ra) # ed8 <exit>
        printf("grind: fork failed\n");
     550:	00001517          	auipc	a0,0x1
     554:	fb850513          	addi	a0,a0,-72 # 1508 <malloc+0x20e>
     558:	00001097          	auipc	ra,0x1
     55c:	ce6080e7          	jalr	-794(ra) # 123e <printf>
        exit(1);
     560:	4505                	li	a0,1
     562:	00001097          	auipc	ra,0x1
     566:	976080e7          	jalr	-1674(ra) # ed8 <exit>
      if(pipe(fds) < 0){
     56a:	f7840513          	addi	a0,s0,-136
     56e:	00001097          	auipc	ra,0x1
     572:	97a080e7          	jalr	-1670(ra) # ee8 <pipe>
     576:	02054b63          	bltz	a0,5ac <go+0x4fe>
      int pid = fork();
     57a:	00001097          	auipc	ra,0x1
     57e:	956080e7          	jalr	-1706(ra) # ed0 <fork>
      if(pid == 0){
     582:	c131                	beqz	a0,5c6 <go+0x518>
      } else if(pid < 0){
     584:	0a054a63          	bltz	a0,638 <go+0x58a>
      close(fds[0]);
     588:	f7842503          	lw	a0,-136(s0)
     58c:	00001097          	auipc	ra,0x1
     590:	974080e7          	jalr	-1676(ra) # f00 <close>
      close(fds[1]);
     594:	f7c42503          	lw	a0,-132(s0)
     598:	00001097          	auipc	ra,0x1
     59c:	968080e7          	jalr	-1688(ra) # f00 <close>
      wait(0);
     5a0:	4501                	li	a0,0
     5a2:	00001097          	auipc	ra,0x1
     5a6:	93e080e7          	jalr	-1730(ra) # ee0 <wait>
     5aa:	bedd                	j	1a0 <go+0xf2>
        printf("grind: pipe failed\n");
     5ac:	00001517          	auipc	a0,0x1
     5b0:	fa450513          	addi	a0,a0,-92 # 1550 <malloc+0x256>
     5b4:	00001097          	auipc	ra,0x1
     5b8:	c8a080e7          	jalr	-886(ra) # 123e <printf>
        exit(1);
     5bc:	4505                	li	a0,1
     5be:	00001097          	auipc	ra,0x1
     5c2:	91a080e7          	jalr	-1766(ra) # ed8 <exit>
        fork();
     5c6:	00001097          	auipc	ra,0x1
     5ca:	90a080e7          	jalr	-1782(ra) # ed0 <fork>
        fork();
     5ce:	00001097          	auipc	ra,0x1
     5d2:	902080e7          	jalr	-1790(ra) # ed0 <fork>
        if(write(fds[1], "x", 1) != 1)
     5d6:	4605                	li	a2,1
     5d8:	00001597          	auipc	a1,0x1
     5dc:	f9058593          	addi	a1,a1,-112 # 1568 <malloc+0x26e>
     5e0:	f7c42503          	lw	a0,-132(s0)
     5e4:	00001097          	auipc	ra,0x1
     5e8:	914080e7          	jalr	-1772(ra) # ef8 <write>
     5ec:	4785                	li	a5,1
     5ee:	02f51363          	bne	a0,a5,614 <go+0x566>
        if(read(fds[0], &c, 1) != 1)
     5f2:	4605                	li	a2,1
     5f4:	f7040593          	addi	a1,s0,-144
     5f8:	f7842503          	lw	a0,-136(s0)
     5fc:	00001097          	auipc	ra,0x1
     600:	8f4080e7          	jalr	-1804(ra) # ef0 <read>
     604:	4785                	li	a5,1
     606:	02f51063          	bne	a0,a5,626 <go+0x578>
        exit(0);
     60a:	4501                	li	a0,0
     60c:	00001097          	auipc	ra,0x1
     610:	8cc080e7          	jalr	-1844(ra) # ed8 <exit>
          printf("grind: pipe write failed\n");
     614:	00001517          	auipc	a0,0x1
     618:	f5c50513          	addi	a0,a0,-164 # 1570 <malloc+0x276>
     61c:	00001097          	auipc	ra,0x1
     620:	c22080e7          	jalr	-990(ra) # 123e <printf>
     624:	b7f9                	j	5f2 <go+0x544>
          printf("grind: pipe read failed\n");
     626:	00001517          	auipc	a0,0x1
     62a:	f6a50513          	addi	a0,a0,-150 # 1590 <malloc+0x296>
     62e:	00001097          	auipc	ra,0x1
     632:	c10080e7          	jalr	-1008(ra) # 123e <printf>
     636:	bfd1                	j	60a <go+0x55c>
        printf("grind: fork failed\n");
     638:	00001517          	auipc	a0,0x1
     63c:	ed050513          	addi	a0,a0,-304 # 1508 <malloc+0x20e>
     640:	00001097          	auipc	ra,0x1
     644:	bfe080e7          	jalr	-1026(ra) # 123e <printf>
        exit(1);
     648:	4505                	li	a0,1
     64a:	00001097          	auipc	ra,0x1
     64e:	88e080e7          	jalr	-1906(ra) # ed8 <exit>
      int pid = fork();
     652:	00001097          	auipc	ra,0x1
     656:	87e080e7          	jalr	-1922(ra) # ed0 <fork>
      if(pid == 0){
     65a:	c909                	beqz	a0,66c <go+0x5be>
      } else if(pid < 0){
     65c:	06054f63          	bltz	a0,6da <go+0x62c>
      wait(0);
     660:	4501                	li	a0,0
     662:	00001097          	auipc	ra,0x1
     666:	87e080e7          	jalr	-1922(ra) # ee0 <wait>
     66a:	be1d                	j	1a0 <go+0xf2>
        unlink("a");
     66c:	00001517          	auipc	a0,0x1
     670:	eb450513          	addi	a0,a0,-332 # 1520 <malloc+0x226>
     674:	00001097          	auipc	ra,0x1
     678:	8b4080e7          	jalr	-1868(ra) # f28 <unlink>
        mkdir("a");
     67c:	00001517          	auipc	a0,0x1
     680:	ea450513          	addi	a0,a0,-348 # 1520 <malloc+0x226>
     684:	00001097          	auipc	ra,0x1
     688:	8bc080e7          	jalr	-1860(ra) # f40 <mkdir>
        chdir("a");
     68c:	00001517          	auipc	a0,0x1
     690:	e9450513          	addi	a0,a0,-364 # 1520 <malloc+0x226>
     694:	00001097          	auipc	ra,0x1
     698:	8b4080e7          	jalr	-1868(ra) # f48 <chdir>
        unlink("../a");
     69c:	00001517          	auipc	a0,0x1
     6a0:	f1450513          	addi	a0,a0,-236 # 15b0 <malloc+0x2b6>
     6a4:	00001097          	auipc	ra,0x1
     6a8:	884080e7          	jalr	-1916(ra) # f28 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     6ac:	20200593          	li	a1,514
     6b0:	00001517          	auipc	a0,0x1
     6b4:	eb850513          	addi	a0,a0,-328 # 1568 <malloc+0x26e>
     6b8:	00001097          	auipc	ra,0x1
     6bc:	860080e7          	jalr	-1952(ra) # f18 <open>
        unlink("x");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	ea850513          	addi	a0,a0,-344 # 1568 <malloc+0x26e>
     6c8:	00001097          	auipc	ra,0x1
     6cc:	860080e7          	jalr	-1952(ra) # f28 <unlink>
        exit(0);
     6d0:	4501                	li	a0,0
     6d2:	00001097          	auipc	ra,0x1
     6d6:	806080e7          	jalr	-2042(ra) # ed8 <exit>
        printf("grind: fork failed\n");
     6da:	00001517          	auipc	a0,0x1
     6de:	e2e50513          	addi	a0,a0,-466 # 1508 <malloc+0x20e>
     6e2:	00001097          	auipc	ra,0x1
     6e6:	b5c080e7          	jalr	-1188(ra) # 123e <printf>
        exit(1);
     6ea:	4505                	li	a0,1
     6ec:	00000097          	auipc	ra,0x0
     6f0:	7ec080e7          	jalr	2028(ra) # ed8 <exit>
      unlink("c");
     6f4:	00001517          	auipc	a0,0x1
     6f8:	ec450513          	addi	a0,a0,-316 # 15b8 <malloc+0x2be>
     6fc:	00001097          	auipc	ra,0x1
     700:	82c080e7          	jalr	-2004(ra) # f28 <unlink>
      int fd1 = open("c", O_CREATE|O_RDWR);
     704:	20200593          	li	a1,514
     708:	00001517          	auipc	a0,0x1
     70c:	eb050513          	addi	a0,a0,-336 # 15b8 <malloc+0x2be>
     710:	00001097          	auipc	ra,0x1
     714:	808080e7          	jalr	-2040(ra) # f18 <open>
     718:	8d2a                	mv	s10,a0
      if(fd1 < 0){
     71a:	04054d63          	bltz	a0,774 <go+0x6c6>
      if(write(fd1, "x", 1) != 1){
     71e:	865e                	mv	a2,s7
     720:	00001597          	auipc	a1,0x1
     724:	e4858593          	addi	a1,a1,-440 # 1568 <malloc+0x26e>
     728:	00000097          	auipc	ra,0x0
     72c:	7d0080e7          	jalr	2000(ra) # ef8 <write>
     730:	05751f63          	bne	a0,s7,78e <go+0x6e0>
      if(fstat(fd1, &st) != 0){
     734:	f7840593          	addi	a1,s0,-136
     738:	856a                	mv	a0,s10
     73a:	00000097          	auipc	ra,0x0
     73e:	7f6080e7          	jalr	2038(ra) # f30 <fstat>
     742:	e13d                	bnez	a0,7a8 <go+0x6fa>
      if(st.size != 1){
     744:	f8843583          	ld	a1,-120(s0)
     748:	07759d63          	bne	a1,s7,7c2 <go+0x714>
      if(st.ino > 200){
     74c:	f7c42583          	lw	a1,-132(s0)
     750:	0c800793          	li	a5,200
     754:	08b7e563          	bltu	a5,a1,7de <go+0x730>
      close(fd1);
     758:	856a                	mv	a0,s10
     75a:	00000097          	auipc	ra,0x0
     75e:	7a6080e7          	jalr	1958(ra) # f00 <close>
      unlink("c");
     762:	00001517          	auipc	a0,0x1
     766:	e5650513          	addi	a0,a0,-426 # 15b8 <malloc+0x2be>
     76a:	00000097          	auipc	ra,0x0
     76e:	7be080e7          	jalr	1982(ra) # f28 <unlink>
     772:	b43d                	j	1a0 <go+0xf2>
        printf("grind: create c failed\n");
     774:	00001517          	auipc	a0,0x1
     778:	e4c50513          	addi	a0,a0,-436 # 15c0 <malloc+0x2c6>
     77c:	00001097          	auipc	ra,0x1
     780:	ac2080e7          	jalr	-1342(ra) # 123e <printf>
        exit(1);
     784:	4505                	li	a0,1
     786:	00000097          	auipc	ra,0x0
     78a:	752080e7          	jalr	1874(ra) # ed8 <exit>
        printf("grind: write c failed\n");
     78e:	00001517          	auipc	a0,0x1
     792:	e4a50513          	addi	a0,a0,-438 # 15d8 <malloc+0x2de>
     796:	00001097          	auipc	ra,0x1
     79a:	aa8080e7          	jalr	-1368(ra) # 123e <printf>
        exit(1);
     79e:	4505                	li	a0,1
     7a0:	00000097          	auipc	ra,0x0
     7a4:	738080e7          	jalr	1848(ra) # ed8 <exit>
        printf("grind: fstat failed\n");
     7a8:	00001517          	auipc	a0,0x1
     7ac:	e4850513          	addi	a0,a0,-440 # 15f0 <malloc+0x2f6>
     7b0:	00001097          	auipc	ra,0x1
     7b4:	a8e080e7          	jalr	-1394(ra) # 123e <printf>
        exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00000097          	auipc	ra,0x0
     7be:	71e080e7          	jalr	1822(ra) # ed8 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     7c2:	2581                	sext.w	a1,a1
     7c4:	00001517          	auipc	a0,0x1
     7c8:	e4450513          	addi	a0,a0,-444 # 1608 <malloc+0x30e>
     7cc:	00001097          	auipc	ra,0x1
     7d0:	a72080e7          	jalr	-1422(ra) # 123e <printf>
        exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00000097          	auipc	ra,0x0
     7da:	702080e7          	jalr	1794(ra) # ed8 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     7de:	00001517          	auipc	a0,0x1
     7e2:	e5250513          	addi	a0,a0,-430 # 1630 <malloc+0x336>
     7e6:	00001097          	auipc	ra,0x1
     7ea:	a58080e7          	jalr	-1448(ra) # 123e <printf>
        exit(1);
     7ee:	4505                	li	a0,1
     7f0:	00000097          	auipc	ra,0x0
     7f4:	6e8080e7          	jalr	1768(ra) # ed8 <exit>
      if(pipe(aa) < 0){
     7f8:	856e                	mv	a0,s11
     7fa:	00000097          	auipc	ra,0x0
     7fe:	6ee080e7          	jalr	1774(ra) # ee8 <pipe>
     802:	10054063          	bltz	a0,902 <go+0x854>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     806:	f7040513          	addi	a0,s0,-144
     80a:	00000097          	auipc	ra,0x0
     80e:	6de080e7          	jalr	1758(ra) # ee8 <pipe>
     812:	10054663          	bltz	a0,91e <go+0x870>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     816:	00000097          	auipc	ra,0x0
     81a:	6ba080e7          	jalr	1722(ra) # ed0 <fork>
      if(pid1 == 0){
     81e:	10050e63          	beqz	a0,93a <go+0x88c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     822:	1c054663          	bltz	a0,9ee <go+0x940>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     826:	00000097          	auipc	ra,0x0
     82a:	6aa080e7          	jalr	1706(ra) # ed0 <fork>
      if(pid2 == 0){
     82e:	1c050e63          	beqz	a0,a0a <go+0x95c>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     832:	2a054a63          	bltz	a0,ae6 <go+0xa38>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     836:	f6842503          	lw	a0,-152(s0)
     83a:	00000097          	auipc	ra,0x0
     83e:	6c6080e7          	jalr	1734(ra) # f00 <close>
      close(aa[1]);
     842:	f6c42503          	lw	a0,-148(s0)
     846:	00000097          	auipc	ra,0x0
     84a:	6ba080e7          	jalr	1722(ra) # f00 <close>
      close(bb[1]);
     84e:	f7442503          	lw	a0,-140(s0)
     852:	00000097          	auipc	ra,0x0
     856:	6ae080e7          	jalr	1710(ra) # f00 <close>
      char buf[4] = { 0, 0, 0, 0 };
     85a:	f6042023          	sw	zero,-160(s0)
      read(bb[0], buf+0, 1);
     85e:	865e                	mv	a2,s7
     860:	f6040593          	addi	a1,s0,-160
     864:	f7042503          	lw	a0,-144(s0)
     868:	00000097          	auipc	ra,0x0
     86c:	688080e7          	jalr	1672(ra) # ef0 <read>
      read(bb[0], buf+1, 1);
     870:	865e                	mv	a2,s7
     872:	f6140593          	addi	a1,s0,-159
     876:	f7042503          	lw	a0,-144(s0)
     87a:	00000097          	auipc	ra,0x0
     87e:	676080e7          	jalr	1654(ra) # ef0 <read>
      read(bb[0], buf+2, 1);
     882:	865e                	mv	a2,s7
     884:	f6240593          	addi	a1,s0,-158
     888:	f7042503          	lw	a0,-144(s0)
     88c:	00000097          	auipc	ra,0x0
     890:	664080e7          	jalr	1636(ra) # ef0 <read>
      close(bb[0]);
     894:	f7042503          	lw	a0,-144(s0)
     898:	00000097          	auipc	ra,0x0
     89c:	668080e7          	jalr	1640(ra) # f00 <close>
      int st1, st2;
      wait(&st1);
     8a0:	f6440513          	addi	a0,s0,-156
     8a4:	00000097          	auipc	ra,0x0
     8a8:	63c080e7          	jalr	1596(ra) # ee0 <wait>
      wait(&st2);
     8ac:	f7840513          	addi	a0,s0,-136
     8b0:	00000097          	auipc	ra,0x0
     8b4:	630080e7          	jalr	1584(ra) # ee0 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     8b8:	f6442783          	lw	a5,-156(s0)
     8bc:	f7842703          	lw	a4,-136(s0)
     8c0:	8fd9                	or	a5,a5,a4
     8c2:	ef89                	bnez	a5,8dc <go+0x82e>
     8c4:	00001597          	auipc	a1,0x1
     8c8:	e0c58593          	addi	a1,a1,-500 # 16d0 <malloc+0x3d6>
     8cc:	f6040513          	addi	a0,s0,-160
     8d0:	00000097          	auipc	ra,0x0
     8d4:	388080e7          	jalr	904(ra) # c58 <strcmp>
     8d8:	8c0504e3          	beqz	a0,1a0 <go+0xf2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     8dc:	f6040693          	addi	a3,s0,-160
     8e0:	f7842603          	lw	a2,-136(s0)
     8e4:	f6442583          	lw	a1,-156(s0)
     8e8:	00001517          	auipc	a0,0x1
     8ec:	df050513          	addi	a0,a0,-528 # 16d8 <malloc+0x3de>
     8f0:	00001097          	auipc	ra,0x1
     8f4:	94e080e7          	jalr	-1714(ra) # 123e <printf>
        exit(1);
     8f8:	4505                	li	a0,1
     8fa:	00000097          	auipc	ra,0x0
     8fe:	5de080e7          	jalr	1502(ra) # ed8 <exit>
        fprintf(2, "grind: pipe failed\n");
     902:	00001597          	auipc	a1,0x1
     906:	c4e58593          	addi	a1,a1,-946 # 1550 <malloc+0x256>
     90a:	4509                	li	a0,2
     90c:	00001097          	auipc	ra,0x1
     910:	904080e7          	jalr	-1788(ra) # 1210 <fprintf>
        exit(1);
     914:	4505                	li	a0,1
     916:	00000097          	auipc	ra,0x0
     91a:	5c2080e7          	jalr	1474(ra) # ed8 <exit>
        fprintf(2, "grind: pipe failed\n");
     91e:	00001597          	auipc	a1,0x1
     922:	c3258593          	addi	a1,a1,-974 # 1550 <malloc+0x256>
     926:	4509                	li	a0,2
     928:	00001097          	auipc	ra,0x1
     92c:	8e8080e7          	jalr	-1816(ra) # 1210 <fprintf>
        exit(1);
     930:	4505                	li	a0,1
     932:	00000097          	auipc	ra,0x0
     936:	5a6080e7          	jalr	1446(ra) # ed8 <exit>
        close(bb[0]);
     93a:	f7042503          	lw	a0,-144(s0)
     93e:	00000097          	auipc	ra,0x0
     942:	5c2080e7          	jalr	1474(ra) # f00 <close>
        close(bb[1]);
     946:	f7442503          	lw	a0,-140(s0)
     94a:	00000097          	auipc	ra,0x0
     94e:	5b6080e7          	jalr	1462(ra) # f00 <close>
        close(aa[0]);
     952:	f6842503          	lw	a0,-152(s0)
     956:	00000097          	auipc	ra,0x0
     95a:	5aa080e7          	jalr	1450(ra) # f00 <close>
        close(1);
     95e:	4505                	li	a0,1
     960:	00000097          	auipc	ra,0x0
     964:	5a0080e7          	jalr	1440(ra) # f00 <close>
        if(dup(aa[1]) != 1){
     968:	f6c42503          	lw	a0,-148(s0)
     96c:	00000097          	auipc	ra,0x0
     970:	5e4080e7          	jalr	1508(ra) # f50 <dup>
     974:	4785                	li	a5,1
     976:	02f50063          	beq	a0,a5,996 <go+0x8e8>
          fprintf(2, "grind: dup failed\n");
     97a:	00001597          	auipc	a1,0x1
     97e:	cde58593          	addi	a1,a1,-802 # 1658 <malloc+0x35e>
     982:	4509                	li	a0,2
     984:	00001097          	auipc	ra,0x1
     988:	88c080e7          	jalr	-1908(ra) # 1210 <fprintf>
          exit(1);
     98c:	4505                	li	a0,1
     98e:	00000097          	auipc	ra,0x0
     992:	54a080e7          	jalr	1354(ra) # ed8 <exit>
        close(aa[1]);
     996:	f6c42503          	lw	a0,-148(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	566080e7          	jalr	1382(ra) # f00 <close>
        char *args[3] = { "echo", "hi", 0 };
     9a2:	00001797          	auipc	a5,0x1
     9a6:	cce78793          	addi	a5,a5,-818 # 1670 <malloc+0x376>
     9aa:	f6f43c23          	sd	a5,-136(s0)
     9ae:	00001797          	auipc	a5,0x1
     9b2:	cca78793          	addi	a5,a5,-822 # 1678 <malloc+0x37e>
     9b6:	f8f43023          	sd	a5,-128(s0)
     9ba:	f8043423          	sd	zero,-120(s0)
        exec("grindir/../echo", args);
     9be:	f7840593          	addi	a1,s0,-136
     9c2:	00001517          	auipc	a0,0x1
     9c6:	cbe50513          	addi	a0,a0,-834 # 1680 <malloc+0x386>
     9ca:	00000097          	auipc	ra,0x0
     9ce:	546080e7          	jalr	1350(ra) # f10 <exec>
        fprintf(2, "grind: echo: not found\n");
     9d2:	00001597          	auipc	a1,0x1
     9d6:	cbe58593          	addi	a1,a1,-834 # 1690 <malloc+0x396>
     9da:	4509                	li	a0,2
     9dc:	00001097          	auipc	ra,0x1
     9e0:	834080e7          	jalr	-1996(ra) # 1210 <fprintf>
        exit(2);
     9e4:	4509                	li	a0,2
     9e6:	00000097          	auipc	ra,0x0
     9ea:	4f2080e7          	jalr	1266(ra) # ed8 <exit>
        fprintf(2, "grind: fork failed\n");
     9ee:	00001597          	auipc	a1,0x1
     9f2:	b1a58593          	addi	a1,a1,-1254 # 1508 <malloc+0x20e>
     9f6:	4509                	li	a0,2
     9f8:	00001097          	auipc	ra,0x1
     9fc:	818080e7          	jalr	-2024(ra) # 1210 <fprintf>
        exit(3);
     a00:	450d                	li	a0,3
     a02:	00000097          	auipc	ra,0x0
     a06:	4d6080e7          	jalr	1238(ra) # ed8 <exit>
        close(aa[1]);
     a0a:	f6c42503          	lw	a0,-148(s0)
     a0e:	00000097          	auipc	ra,0x0
     a12:	4f2080e7          	jalr	1266(ra) # f00 <close>
        close(bb[0]);
     a16:	f7042503          	lw	a0,-144(s0)
     a1a:	00000097          	auipc	ra,0x0
     a1e:	4e6080e7          	jalr	1254(ra) # f00 <close>
        close(0);
     a22:	4501                	li	a0,0
     a24:	00000097          	auipc	ra,0x0
     a28:	4dc080e7          	jalr	1244(ra) # f00 <close>
        if(dup(aa[0]) != 0){
     a2c:	f6842503          	lw	a0,-152(s0)
     a30:	00000097          	auipc	ra,0x0
     a34:	520080e7          	jalr	1312(ra) # f50 <dup>
     a38:	cd19                	beqz	a0,a56 <go+0x9a8>
          fprintf(2, "grind: dup failed\n");
     a3a:	00001597          	auipc	a1,0x1
     a3e:	c1e58593          	addi	a1,a1,-994 # 1658 <malloc+0x35e>
     a42:	4509                	li	a0,2
     a44:	00000097          	auipc	ra,0x0
     a48:	7cc080e7          	jalr	1996(ra) # 1210 <fprintf>
          exit(4);
     a4c:	4511                	li	a0,4
     a4e:	00000097          	auipc	ra,0x0
     a52:	48a080e7          	jalr	1162(ra) # ed8 <exit>
        close(aa[0]);
     a56:	f6842503          	lw	a0,-152(s0)
     a5a:	00000097          	auipc	ra,0x0
     a5e:	4a6080e7          	jalr	1190(ra) # f00 <close>
        close(1);
     a62:	4505                	li	a0,1
     a64:	00000097          	auipc	ra,0x0
     a68:	49c080e7          	jalr	1180(ra) # f00 <close>
        if(dup(bb[1]) != 1){
     a6c:	f7442503          	lw	a0,-140(s0)
     a70:	00000097          	auipc	ra,0x0
     a74:	4e0080e7          	jalr	1248(ra) # f50 <dup>
     a78:	4785                	li	a5,1
     a7a:	02f50063          	beq	a0,a5,a9a <go+0x9ec>
          fprintf(2, "grind: dup failed\n");
     a7e:	00001597          	auipc	a1,0x1
     a82:	bda58593          	addi	a1,a1,-1062 # 1658 <malloc+0x35e>
     a86:	4509                	li	a0,2
     a88:	00000097          	auipc	ra,0x0
     a8c:	788080e7          	jalr	1928(ra) # 1210 <fprintf>
          exit(5);
     a90:	4515                	li	a0,5
     a92:	00000097          	auipc	ra,0x0
     a96:	446080e7          	jalr	1094(ra) # ed8 <exit>
        close(bb[1]);
     a9a:	f7442503          	lw	a0,-140(s0)
     a9e:	00000097          	auipc	ra,0x0
     aa2:	462080e7          	jalr	1122(ra) # f00 <close>
        char *args[2] = { "cat", 0 };
     aa6:	00001797          	auipc	a5,0x1
     aaa:	c0278793          	addi	a5,a5,-1022 # 16a8 <malloc+0x3ae>
     aae:	f6f43c23          	sd	a5,-136(s0)
     ab2:	f8043023          	sd	zero,-128(s0)
        exec("/cat", args);
     ab6:	f7840593          	addi	a1,s0,-136
     aba:	00001517          	auipc	a0,0x1
     abe:	bf650513          	addi	a0,a0,-1034 # 16b0 <malloc+0x3b6>
     ac2:	00000097          	auipc	ra,0x0
     ac6:	44e080e7          	jalr	1102(ra) # f10 <exec>
        fprintf(2, "grind: cat: not found\n");
     aca:	00001597          	auipc	a1,0x1
     ace:	bee58593          	addi	a1,a1,-1042 # 16b8 <malloc+0x3be>
     ad2:	4509                	li	a0,2
     ad4:	00000097          	auipc	ra,0x0
     ad8:	73c080e7          	jalr	1852(ra) # 1210 <fprintf>
        exit(6);
     adc:	4519                	li	a0,6
     ade:	00000097          	auipc	ra,0x0
     ae2:	3fa080e7          	jalr	1018(ra) # ed8 <exit>
        fprintf(2, "grind: fork failed\n");
     ae6:	00001597          	auipc	a1,0x1
     aea:	a2258593          	addi	a1,a1,-1502 # 1508 <malloc+0x20e>
     aee:	4509                	li	a0,2
     af0:	00000097          	auipc	ra,0x0
     af4:	720080e7          	jalr	1824(ra) # 1210 <fprintf>
        exit(7);
     af8:	451d                	li	a0,7
     afa:	00000097          	auipc	ra,0x0
     afe:	3de080e7          	jalr	990(ra) # ed8 <exit>

0000000000000b02 <iter>:
  }
}

void
iter()
{
     b02:	7179                	addi	sp,sp,-48
     b04:	f406                	sd	ra,40(sp)
     b06:	f022                	sd	s0,32(sp)
     b08:	1800                	addi	s0,sp,48
  unlink("a");
     b0a:	00001517          	auipc	a0,0x1
     b0e:	a1650513          	addi	a0,a0,-1514 # 1520 <malloc+0x226>
     b12:	00000097          	auipc	ra,0x0
     b16:	416080e7          	jalr	1046(ra) # f28 <unlink>
  unlink("b");
     b1a:	00001517          	auipc	a0,0x1
     b1e:	9b650513          	addi	a0,a0,-1610 # 14d0 <malloc+0x1d6>
     b22:	00000097          	auipc	ra,0x0
     b26:	406080e7          	jalr	1030(ra) # f28 <unlink>
  
  int pid1 = fork();
     b2a:	00000097          	auipc	ra,0x0
     b2e:	3a6080e7          	jalr	934(ra) # ed0 <fork>
  if(pid1 < 0){
     b32:	02054063          	bltz	a0,b52 <iter+0x50>
     b36:	ec26                	sd	s1,24(sp)
     b38:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     b3a:	e91d                	bnez	a0,b70 <iter+0x6e>
     b3c:	e84a                	sd	s2,16(sp)
    rand_next = 31;
     b3e:	47fd                	li	a5,31
     b40:	00001717          	auipc	a4,0x1
     b44:	c8f73c23          	sd	a5,-872(a4) # 17d8 <rand_next>
    go(0);
     b48:	4501                	li	a0,0
     b4a:	fffff097          	auipc	ra,0xfffff
     b4e:	564080e7          	jalr	1380(ra) # ae <go>
     b52:	ec26                	sd	s1,24(sp)
     b54:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     b56:	00001517          	auipc	a0,0x1
     b5a:	9b250513          	addi	a0,a0,-1614 # 1508 <malloc+0x20e>
     b5e:	00000097          	auipc	ra,0x0
     b62:	6e0080e7          	jalr	1760(ra) # 123e <printf>
    exit(1);
     b66:	4505                	li	a0,1
     b68:	00000097          	auipc	ra,0x0
     b6c:	370080e7          	jalr	880(ra) # ed8 <exit>
     b70:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     b72:	00000097          	auipc	ra,0x0
     b76:	35e080e7          	jalr	862(ra) # ed0 <fork>
     b7a:	892a                	mv	s2,a0
  if(pid2 < 0){
     b7c:	00054f63          	bltz	a0,b9a <iter+0x98>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     b80:	e915                	bnez	a0,bb4 <iter+0xb2>
    rand_next = 7177;
     b82:	6789                	lui	a5,0x2
     b84:	c0978793          	addi	a5,a5,-1015 # 1c09 <__BSS_END__+0x29>
     b88:	00001717          	auipc	a4,0x1
     b8c:	c4f73823          	sd	a5,-944(a4) # 17d8 <rand_next>
    go(1);
     b90:	4505                	li	a0,1
     b92:	fffff097          	auipc	ra,0xfffff
     b96:	51c080e7          	jalr	1308(ra) # ae <go>
    printf("grind: fork failed\n");
     b9a:	00001517          	auipc	a0,0x1
     b9e:	96e50513          	addi	a0,a0,-1682 # 1508 <malloc+0x20e>
     ba2:	00000097          	auipc	ra,0x0
     ba6:	69c080e7          	jalr	1692(ra) # 123e <printf>
    exit(1);
     baa:	4505                	li	a0,1
     bac:	00000097          	auipc	ra,0x0
     bb0:	32c080e7          	jalr	812(ra) # ed8 <exit>
    exit(0);
  }

  int st1 = -1;
     bb4:	57fd                	li	a5,-1
     bb6:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     bba:	fdc40513          	addi	a0,s0,-36
     bbe:	00000097          	auipc	ra,0x0
     bc2:	322080e7          	jalr	802(ra) # ee0 <wait>
  if(st1 != 0){
     bc6:	fdc42783          	lw	a5,-36(s0)
     bca:	ef99                	bnez	a5,be8 <iter+0xe6>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     bcc:	57fd                	li	a5,-1
     bce:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     bd2:	fd840513          	addi	a0,s0,-40
     bd6:	00000097          	auipc	ra,0x0
     bda:	30a080e7          	jalr	778(ra) # ee0 <wait>

  exit(0);
     bde:	4501                	li	a0,0
     be0:	00000097          	auipc	ra,0x0
     be4:	2f8080e7          	jalr	760(ra) # ed8 <exit>
    kill(pid1);
     be8:	8526                	mv	a0,s1
     bea:	00000097          	auipc	ra,0x0
     bee:	31e080e7          	jalr	798(ra) # f08 <kill>
    kill(pid2);
     bf2:	854a                	mv	a0,s2
     bf4:	00000097          	auipc	ra,0x0
     bf8:	314080e7          	jalr	788(ra) # f08 <kill>
     bfc:	bfc1                	j	bcc <iter+0xca>

0000000000000bfe <main>:
}

int
main()
{
     bfe:	1101                	addi	sp,sp,-32
     c00:	ec06                	sd	ra,24(sp)
     c02:	e822                	sd	s0,16(sp)
     c04:	e426                	sd	s1,8(sp)
     c06:	1000                	addi	s0,sp,32
      exit(0);
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
     c08:	44d1                	li	s1,20
     c0a:	a811                	j	c1e <main+0x20>
      iter();
     c0c:	00000097          	auipc	ra,0x0
     c10:	ef6080e7          	jalr	-266(ra) # b02 <iter>
    sleep(20);
     c14:	8526                	mv	a0,s1
     c16:	00000097          	auipc	ra,0x0
     c1a:	352080e7          	jalr	850(ra) # f68 <sleep>
    int pid = fork();
     c1e:	00000097          	auipc	ra,0x0
     c22:	2b2080e7          	jalr	690(ra) # ed0 <fork>
    if(pid == 0){
     c26:	d17d                	beqz	a0,c0c <main+0xe>
    if(pid > 0){
     c28:	fea056e3          	blez	a0,c14 <main+0x16>
      wait(0);
     c2c:	4501                	li	a0,0
     c2e:	00000097          	auipc	ra,0x0
     c32:	2b2080e7          	jalr	690(ra) # ee0 <wait>
     c36:	bff9                	j	c14 <main+0x16>

0000000000000c38 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     c38:	1141                	addi	sp,sp,-16
     c3a:	e406                	sd	ra,8(sp)
     c3c:	e022                	sd	s0,0(sp)
     c3e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c40:	87aa                	mv	a5,a0
     c42:	0585                	addi	a1,a1,1
     c44:	0785                	addi	a5,a5,1
     c46:	fff5c703          	lbu	a4,-1(a1)
     c4a:	fee78fa3          	sb	a4,-1(a5)
     c4e:	fb75                	bnez	a4,c42 <strcpy+0xa>
    ;
  return os;
}
     c50:	60a2                	ld	ra,8(sp)
     c52:	6402                	ld	s0,0(sp)
     c54:	0141                	addi	sp,sp,16
     c56:	8082                	ret

0000000000000c58 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c58:	1141                	addi	sp,sp,-16
     c5a:	e406                	sd	ra,8(sp)
     c5c:	e022                	sd	s0,0(sp)
     c5e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c60:	00054783          	lbu	a5,0(a0)
     c64:	cb91                	beqz	a5,c78 <strcmp+0x20>
     c66:	0005c703          	lbu	a4,0(a1)
     c6a:	00f71763          	bne	a4,a5,c78 <strcmp+0x20>
    p++, q++;
     c6e:	0505                	addi	a0,a0,1
     c70:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c72:	00054783          	lbu	a5,0(a0)
     c76:	fbe5                	bnez	a5,c66 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     c78:	0005c503          	lbu	a0,0(a1)
}
     c7c:	40a7853b          	subw	a0,a5,a0
     c80:	60a2                	ld	ra,8(sp)
     c82:	6402                	ld	s0,0(sp)
     c84:	0141                	addi	sp,sp,16
     c86:	8082                	ret

0000000000000c88 <strlen>:

uint
strlen(const char *s)
{
     c88:	1141                	addi	sp,sp,-16
     c8a:	e406                	sd	ra,8(sp)
     c8c:	e022                	sd	s0,0(sp)
     c8e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c90:	00054783          	lbu	a5,0(a0)
     c94:	cf99                	beqz	a5,cb2 <strlen+0x2a>
     c96:	0505                	addi	a0,a0,1
     c98:	87aa                	mv	a5,a0
     c9a:	86be                	mv	a3,a5
     c9c:	0785                	addi	a5,a5,1
     c9e:	fff7c703          	lbu	a4,-1(a5)
     ca2:	ff65                	bnez	a4,c9a <strlen+0x12>
     ca4:	40a6853b          	subw	a0,a3,a0
     ca8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     caa:	60a2                	ld	ra,8(sp)
     cac:	6402                	ld	s0,0(sp)
     cae:	0141                	addi	sp,sp,16
     cb0:	8082                	ret
  for(n = 0; s[n]; n++)
     cb2:	4501                	li	a0,0
     cb4:	bfdd                	j	caa <strlen+0x22>

0000000000000cb6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     cb6:	1141                	addi	sp,sp,-16
     cb8:	e406                	sd	ra,8(sp)
     cba:	e022                	sd	s0,0(sp)
     cbc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     cbe:	ca19                	beqz	a2,cd4 <memset+0x1e>
     cc0:	87aa                	mv	a5,a0
     cc2:	1602                	slli	a2,a2,0x20
     cc4:	9201                	srli	a2,a2,0x20
     cc6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     cca:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     cce:	0785                	addi	a5,a5,1
     cd0:	fee79de3          	bne	a5,a4,cca <memset+0x14>
  }
  return dst;
}
     cd4:	60a2                	ld	ra,8(sp)
     cd6:	6402                	ld	s0,0(sp)
     cd8:	0141                	addi	sp,sp,16
     cda:	8082                	ret

0000000000000cdc <strchr>:

char*
strchr(const char *s, char c)
{
     cdc:	1141                	addi	sp,sp,-16
     cde:	e406                	sd	ra,8(sp)
     ce0:	e022                	sd	s0,0(sp)
     ce2:	0800                	addi	s0,sp,16
  for(; *s; s++)
     ce4:	00054783          	lbu	a5,0(a0)
     ce8:	cf81                	beqz	a5,d00 <strchr+0x24>
    if(*s == c)
     cea:	00f58763          	beq	a1,a5,cf8 <strchr+0x1c>
  for(; *s; s++)
     cee:	0505                	addi	a0,a0,1
     cf0:	00054783          	lbu	a5,0(a0)
     cf4:	fbfd                	bnez	a5,cea <strchr+0xe>
      return (char*)s;
  return 0;
     cf6:	4501                	li	a0,0
}
     cf8:	60a2                	ld	ra,8(sp)
     cfa:	6402                	ld	s0,0(sp)
     cfc:	0141                	addi	sp,sp,16
     cfe:	8082                	ret
  return 0;
     d00:	4501                	li	a0,0
     d02:	bfdd                	j	cf8 <strchr+0x1c>

0000000000000d04 <gets>:

char*
gets(char *buf, int max)
{
     d04:	7159                	addi	sp,sp,-112
     d06:	f486                	sd	ra,104(sp)
     d08:	f0a2                	sd	s0,96(sp)
     d0a:	eca6                	sd	s1,88(sp)
     d0c:	e8ca                	sd	s2,80(sp)
     d0e:	e4ce                	sd	s3,72(sp)
     d10:	e0d2                	sd	s4,64(sp)
     d12:	fc56                	sd	s5,56(sp)
     d14:	f85a                	sd	s6,48(sp)
     d16:	f45e                	sd	s7,40(sp)
     d18:	f062                	sd	s8,32(sp)
     d1a:	ec66                	sd	s9,24(sp)
     d1c:	e86a                	sd	s10,16(sp)
     d1e:	1880                	addi	s0,sp,112
     d20:	8caa                	mv	s9,a0
     d22:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d24:	892a                	mv	s2,a0
     d26:	4481                	li	s1,0
    cc = read(0, &c, 1);
     d28:	f9f40b13          	addi	s6,s0,-97
     d2c:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     d2e:	4ba9                	li	s7,10
     d30:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     d32:	8d26                	mv	s10,s1
     d34:	0014899b          	addiw	s3,s1,1
     d38:	84ce                	mv	s1,s3
     d3a:	0349d763          	bge	s3,s4,d68 <gets+0x64>
    cc = read(0, &c, 1);
     d3e:	8656                	mv	a2,s5
     d40:	85da                	mv	a1,s6
     d42:	4501                	li	a0,0
     d44:	00000097          	auipc	ra,0x0
     d48:	1ac080e7          	jalr	428(ra) # ef0 <read>
    if(cc < 1)
     d4c:	00a05e63          	blez	a0,d68 <gets+0x64>
    buf[i++] = c;
     d50:	f9f44783          	lbu	a5,-97(s0)
     d54:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d58:	01778763          	beq	a5,s7,d66 <gets+0x62>
     d5c:	0905                	addi	s2,s2,1
     d5e:	fd879ae3          	bne	a5,s8,d32 <gets+0x2e>
    buf[i++] = c;
     d62:	8d4e                	mv	s10,s3
     d64:	a011                	j	d68 <gets+0x64>
     d66:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     d68:	9d66                	add	s10,s10,s9
     d6a:	000d0023          	sb	zero,0(s10)
  return buf;
}
     d6e:	8566                	mv	a0,s9
     d70:	70a6                	ld	ra,104(sp)
     d72:	7406                	ld	s0,96(sp)
     d74:	64e6                	ld	s1,88(sp)
     d76:	6946                	ld	s2,80(sp)
     d78:	69a6                	ld	s3,72(sp)
     d7a:	6a06                	ld	s4,64(sp)
     d7c:	7ae2                	ld	s5,56(sp)
     d7e:	7b42                	ld	s6,48(sp)
     d80:	7ba2                	ld	s7,40(sp)
     d82:	7c02                	ld	s8,32(sp)
     d84:	6ce2                	ld	s9,24(sp)
     d86:	6d42                	ld	s10,16(sp)
     d88:	6165                	addi	sp,sp,112
     d8a:	8082                	ret

0000000000000d8c <stat>:

int
stat(const char *n, struct stat *st)
{
     d8c:	1101                	addi	sp,sp,-32
     d8e:	ec06                	sd	ra,24(sp)
     d90:	e822                	sd	s0,16(sp)
     d92:	e04a                	sd	s2,0(sp)
     d94:	1000                	addi	s0,sp,32
     d96:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d98:	4581                	li	a1,0
     d9a:	00000097          	auipc	ra,0x0
     d9e:	17e080e7          	jalr	382(ra) # f18 <open>
  if(fd < 0)
     da2:	02054663          	bltz	a0,dce <stat+0x42>
     da6:	e426                	sd	s1,8(sp)
     da8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     daa:	85ca                	mv	a1,s2
     dac:	00000097          	auipc	ra,0x0
     db0:	184080e7          	jalr	388(ra) # f30 <fstat>
     db4:	892a                	mv	s2,a0
  close(fd);
     db6:	8526                	mv	a0,s1
     db8:	00000097          	auipc	ra,0x0
     dbc:	148080e7          	jalr	328(ra) # f00 <close>
  return r;
     dc0:	64a2                	ld	s1,8(sp)
}
     dc2:	854a                	mv	a0,s2
     dc4:	60e2                	ld	ra,24(sp)
     dc6:	6442                	ld	s0,16(sp)
     dc8:	6902                	ld	s2,0(sp)
     dca:	6105                	addi	sp,sp,32
     dcc:	8082                	ret
    return -1;
     dce:	597d                	li	s2,-1
     dd0:	bfcd                	j	dc2 <stat+0x36>

0000000000000dd2 <atoi>:

int
atoi(const char *s)
{
     dd2:	1141                	addi	sp,sp,-16
     dd4:	e406                	sd	ra,8(sp)
     dd6:	e022                	sd	s0,0(sp)
     dd8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     dda:	00054683          	lbu	a3,0(a0)
     dde:	fd06879b          	addiw	a5,a3,-48
     de2:	0ff7f793          	zext.b	a5,a5
     de6:	4625                	li	a2,9
     de8:	02f66963          	bltu	a2,a5,e1a <atoi+0x48>
     dec:	872a                	mv	a4,a0
  n = 0;
     dee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     df0:	0705                	addi	a4,a4,1
     df2:	0025179b          	slliw	a5,a0,0x2
     df6:	9fa9                	addw	a5,a5,a0
     df8:	0017979b          	slliw	a5,a5,0x1
     dfc:	9fb5                	addw	a5,a5,a3
     dfe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     e02:	00074683          	lbu	a3,0(a4)
     e06:	fd06879b          	addiw	a5,a3,-48
     e0a:	0ff7f793          	zext.b	a5,a5
     e0e:	fef671e3          	bgeu	a2,a5,df0 <atoi+0x1e>
  return n;
}
     e12:	60a2                	ld	ra,8(sp)
     e14:	6402                	ld	s0,0(sp)
     e16:	0141                	addi	sp,sp,16
     e18:	8082                	ret
  n = 0;
     e1a:	4501                	li	a0,0
     e1c:	bfdd                	j	e12 <atoi+0x40>

0000000000000e1e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e1e:	1141                	addi	sp,sp,-16
     e20:	e406                	sd	ra,8(sp)
     e22:	e022                	sd	s0,0(sp)
     e24:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     e26:	02b57563          	bgeu	a0,a1,e50 <memmove+0x32>
    while(n-- > 0)
     e2a:	00c05f63          	blez	a2,e48 <memmove+0x2a>
     e2e:	1602                	slli	a2,a2,0x20
     e30:	9201                	srli	a2,a2,0x20
     e32:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     e36:	872a                	mv	a4,a0
      *dst++ = *src++;
     e38:	0585                	addi	a1,a1,1
     e3a:	0705                	addi	a4,a4,1
     e3c:	fff5c683          	lbu	a3,-1(a1)
     e40:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     e44:	fee79ae3          	bne	a5,a4,e38 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     e48:	60a2                	ld	ra,8(sp)
     e4a:	6402                	ld	s0,0(sp)
     e4c:	0141                	addi	sp,sp,16
     e4e:	8082                	ret
    dst += n;
     e50:	00c50733          	add	a4,a0,a2
    src += n;
     e54:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e56:	fec059e3          	blez	a2,e48 <memmove+0x2a>
     e5a:	fff6079b          	addiw	a5,a2,-1
     e5e:	1782                	slli	a5,a5,0x20
     e60:	9381                	srli	a5,a5,0x20
     e62:	fff7c793          	not	a5,a5
     e66:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e68:	15fd                	addi	a1,a1,-1
     e6a:	177d                	addi	a4,a4,-1
     e6c:	0005c683          	lbu	a3,0(a1)
     e70:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e74:	fef71ae3          	bne	a4,a5,e68 <memmove+0x4a>
     e78:	bfc1                	j	e48 <memmove+0x2a>

0000000000000e7a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e7a:	1141                	addi	sp,sp,-16
     e7c:	e406                	sd	ra,8(sp)
     e7e:	e022                	sd	s0,0(sp)
     e80:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e82:	ca0d                	beqz	a2,eb4 <memcmp+0x3a>
     e84:	fff6069b          	addiw	a3,a2,-1
     e88:	1682                	slli	a3,a3,0x20
     e8a:	9281                	srli	a3,a3,0x20
     e8c:	0685                	addi	a3,a3,1
     e8e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e90:	00054783          	lbu	a5,0(a0)
     e94:	0005c703          	lbu	a4,0(a1)
     e98:	00e79863          	bne	a5,a4,ea8 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     e9c:	0505                	addi	a0,a0,1
    p2++;
     e9e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ea0:	fed518e3          	bne	a0,a3,e90 <memcmp+0x16>
  }
  return 0;
     ea4:	4501                	li	a0,0
     ea6:	a019                	j	eac <memcmp+0x32>
      return *p1 - *p2;
     ea8:	40e7853b          	subw	a0,a5,a4
}
     eac:	60a2                	ld	ra,8(sp)
     eae:	6402                	ld	s0,0(sp)
     eb0:	0141                	addi	sp,sp,16
     eb2:	8082                	ret
  return 0;
     eb4:	4501                	li	a0,0
     eb6:	bfdd                	j	eac <memcmp+0x32>

0000000000000eb8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     eb8:	1141                	addi	sp,sp,-16
     eba:	e406                	sd	ra,8(sp)
     ebc:	e022                	sd	s0,0(sp)
     ebe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ec0:	00000097          	auipc	ra,0x0
     ec4:	f5e080e7          	jalr	-162(ra) # e1e <memmove>
}
     ec8:	60a2                	ld	ra,8(sp)
     eca:	6402                	ld	s0,0(sp)
     ecc:	0141                	addi	sp,sp,16
     ece:	8082                	ret

0000000000000ed0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ed0:	4885                	li	a7,1
 ecall
     ed2:	00000073          	ecall
 ret
     ed6:	8082                	ret

0000000000000ed8 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ed8:	4889                	li	a7,2
 ecall
     eda:	00000073          	ecall
 ret
     ede:	8082                	ret

0000000000000ee0 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ee0:	488d                	li	a7,3
 ecall
     ee2:	00000073          	ecall
 ret
     ee6:	8082                	ret

0000000000000ee8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ee8:	4891                	li	a7,4
 ecall
     eea:	00000073          	ecall
 ret
     eee:	8082                	ret

0000000000000ef0 <read>:
.global read
read:
 li a7, SYS_read
     ef0:	4895                	li	a7,5
 ecall
     ef2:	00000073          	ecall
 ret
     ef6:	8082                	ret

0000000000000ef8 <write>:
.global write
write:
 li a7, SYS_write
     ef8:	48c1                	li	a7,16
 ecall
     efa:	00000073          	ecall
 ret
     efe:	8082                	ret

0000000000000f00 <close>:
.global close
close:
 li a7, SYS_close
     f00:	48d5                	li	a7,21
 ecall
     f02:	00000073          	ecall
 ret
     f06:	8082                	ret

0000000000000f08 <kill>:
.global kill
kill:
 li a7, SYS_kill
     f08:	4899                	li	a7,6
 ecall
     f0a:	00000073          	ecall
 ret
     f0e:	8082                	ret

0000000000000f10 <exec>:
.global exec
exec:
 li a7, SYS_exec
     f10:	489d                	li	a7,7
 ecall
     f12:	00000073          	ecall
 ret
     f16:	8082                	ret

0000000000000f18 <open>:
.global open
open:
 li a7, SYS_open
     f18:	48bd                	li	a7,15
 ecall
     f1a:	00000073          	ecall
 ret
     f1e:	8082                	ret

0000000000000f20 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     f20:	48c5                	li	a7,17
 ecall
     f22:	00000073          	ecall
 ret
     f26:	8082                	ret

0000000000000f28 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     f28:	48c9                	li	a7,18
 ecall
     f2a:	00000073          	ecall
 ret
     f2e:	8082                	ret

0000000000000f30 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     f30:	48a1                	li	a7,8
 ecall
     f32:	00000073          	ecall
 ret
     f36:	8082                	ret

0000000000000f38 <link>:
.global link
link:
 li a7, SYS_link
     f38:	48cd                	li	a7,19
 ecall
     f3a:	00000073          	ecall
 ret
     f3e:	8082                	ret

0000000000000f40 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     f40:	48d1                	li	a7,20
 ecall
     f42:	00000073          	ecall
 ret
     f46:	8082                	ret

0000000000000f48 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     f48:	48a5                	li	a7,9
 ecall
     f4a:	00000073          	ecall
 ret
     f4e:	8082                	ret

0000000000000f50 <dup>:
.global dup
dup:
 li a7, SYS_dup
     f50:	48a9                	li	a7,10
 ecall
     f52:	00000073          	ecall
 ret
     f56:	8082                	ret

0000000000000f58 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f58:	48ad                	li	a7,11
 ecall
     f5a:	00000073          	ecall
 ret
     f5e:	8082                	ret

0000000000000f60 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f60:	48b1                	li	a7,12
 ecall
     f62:	00000073          	ecall
 ret
     f66:	8082                	ret

0000000000000f68 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f68:	48b5                	li	a7,13
 ecall
     f6a:	00000073          	ecall
 ret
     f6e:	8082                	ret

0000000000000f70 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f70:	48b9                	li	a7,14
 ecall
     f72:	00000073          	ecall
 ret
     f76:	8082                	ret

0000000000000f78 <sigalarm>:
.global sigalarm
sigalarm:
 li a7, SYS_sigalarm
     f78:	48d9                	li	a7,22
 ecall
     f7a:	00000073          	ecall
 ret
     f7e:	8082                	ret

0000000000000f80 <sigreturn>:
.global sigreturn
sigreturn:
 li a7, SYS_sigreturn
     f80:	48dd                	li	a7,23
 ecall
     f82:	00000073          	ecall
 ret
     f86:	8082                	ret

0000000000000f88 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f88:	1101                	addi	sp,sp,-32
     f8a:	ec06                	sd	ra,24(sp)
     f8c:	e822                	sd	s0,16(sp)
     f8e:	1000                	addi	s0,sp,32
     f90:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f94:	4605                	li	a2,1
     f96:	fef40593          	addi	a1,s0,-17
     f9a:	00000097          	auipc	ra,0x0
     f9e:	f5e080e7          	jalr	-162(ra) # ef8 <write>
}
     fa2:	60e2                	ld	ra,24(sp)
     fa4:	6442                	ld	s0,16(sp)
     fa6:	6105                	addi	sp,sp,32
     fa8:	8082                	ret

0000000000000faa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     faa:	7139                	addi	sp,sp,-64
     fac:	fc06                	sd	ra,56(sp)
     fae:	f822                	sd	s0,48(sp)
     fb0:	f426                	sd	s1,40(sp)
     fb2:	f04a                	sd	s2,32(sp)
     fb4:	ec4e                	sd	s3,24(sp)
     fb6:	0080                	addi	s0,sp,64
     fb8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     fba:	c299                	beqz	a3,fc0 <printint+0x16>
     fbc:	0805c063          	bltz	a1,103c <printint+0x92>
  neg = 0;
     fc0:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     fc2:	fc040313          	addi	t1,s0,-64
  neg = 0;
     fc6:	869a                	mv	a3,t1
  i = 0;
     fc8:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     fca:	00000817          	auipc	a6,0x0
     fce:	7f680813          	addi	a6,a6,2038 # 17c0 <digits>
     fd2:	88be                	mv	a7,a5
     fd4:	0017851b          	addiw	a0,a5,1
     fd8:	87aa                	mv	a5,a0
     fda:	02c5f73b          	remuw	a4,a1,a2
     fde:	1702                	slli	a4,a4,0x20
     fe0:	9301                	srli	a4,a4,0x20
     fe2:	9742                	add	a4,a4,a6
     fe4:	00074703          	lbu	a4,0(a4)
     fe8:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     fec:	872e                	mv	a4,a1
     fee:	02c5d5bb          	divuw	a1,a1,a2
     ff2:	0685                	addi	a3,a3,1
     ff4:	fcc77fe3          	bgeu	a4,a2,fd2 <printint+0x28>
  if(neg)
     ff8:	000e0c63          	beqz	t3,1010 <printint+0x66>
    buf[i++] = '-';
     ffc:	fd050793          	addi	a5,a0,-48
    1000:	00878533          	add	a0,a5,s0
    1004:	02d00793          	li	a5,45
    1008:	fef50823          	sb	a5,-16(a0)
    100c:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    1010:	fff7899b          	addiw	s3,a5,-1
    1014:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    1018:	fff4c583          	lbu	a1,-1(s1)
    101c:	854a                	mv	a0,s2
    101e:	00000097          	auipc	ra,0x0
    1022:	f6a080e7          	jalr	-150(ra) # f88 <putc>
  while(--i >= 0)
    1026:	39fd                	addiw	s3,s3,-1
    1028:	14fd                	addi	s1,s1,-1
    102a:	fe09d7e3          	bgez	s3,1018 <printint+0x6e>
}
    102e:	70e2                	ld	ra,56(sp)
    1030:	7442                	ld	s0,48(sp)
    1032:	74a2                	ld	s1,40(sp)
    1034:	7902                	ld	s2,32(sp)
    1036:	69e2                	ld	s3,24(sp)
    1038:	6121                	addi	sp,sp,64
    103a:	8082                	ret
    x = -xx;
    103c:	40b005bb          	negw	a1,a1
    neg = 1;
    1040:	4e05                	li	t3,1
    x = -xx;
    1042:	b741                	j	fc2 <printint+0x18>

0000000000001044 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1044:	715d                	addi	sp,sp,-80
    1046:	e486                	sd	ra,72(sp)
    1048:	e0a2                	sd	s0,64(sp)
    104a:	f84a                	sd	s2,48(sp)
    104c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    104e:	0005c903          	lbu	s2,0(a1)
    1052:	1a090a63          	beqz	s2,1206 <vprintf+0x1c2>
    1056:	fc26                	sd	s1,56(sp)
    1058:	f44e                	sd	s3,40(sp)
    105a:	f052                	sd	s4,32(sp)
    105c:	ec56                	sd	s5,24(sp)
    105e:	e85a                	sd	s6,16(sp)
    1060:	e45e                	sd	s7,8(sp)
    1062:	8aaa                	mv	s5,a0
    1064:	8bb2                	mv	s7,a2
    1066:	00158493          	addi	s1,a1,1
  state = 0;
    106a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    106c:	02500a13          	li	s4,37
    1070:	4b55                	li	s6,21
    1072:	a839                	j	1090 <vprintf+0x4c>
        putc(fd, c);
    1074:	85ca                	mv	a1,s2
    1076:	8556                	mv	a0,s5
    1078:	00000097          	auipc	ra,0x0
    107c:	f10080e7          	jalr	-240(ra) # f88 <putc>
    1080:	a019                	j	1086 <vprintf+0x42>
    } else if(state == '%'){
    1082:	01498d63          	beq	s3,s4,109c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    1086:	0485                	addi	s1,s1,1
    1088:	fff4c903          	lbu	s2,-1(s1)
    108c:	16090763          	beqz	s2,11fa <vprintf+0x1b6>
    if(state == 0){
    1090:	fe0999e3          	bnez	s3,1082 <vprintf+0x3e>
      if(c == '%'){
    1094:	ff4910e3          	bne	s2,s4,1074 <vprintf+0x30>
        state = '%';
    1098:	89d2                	mv	s3,s4
    109a:	b7f5                	j	1086 <vprintf+0x42>
      if(c == 'd'){
    109c:	13490463          	beq	s2,s4,11c4 <vprintf+0x180>
    10a0:	f9d9079b          	addiw	a5,s2,-99
    10a4:	0ff7f793          	zext.b	a5,a5
    10a8:	12fb6763          	bltu	s6,a5,11d6 <vprintf+0x192>
    10ac:	f9d9079b          	addiw	a5,s2,-99
    10b0:	0ff7f713          	zext.b	a4,a5
    10b4:	12eb6163          	bltu	s6,a4,11d6 <vprintf+0x192>
    10b8:	00271793          	slli	a5,a4,0x2
    10bc:	00000717          	auipc	a4,0x0
    10c0:	6ac70713          	addi	a4,a4,1708 # 1768 <malloc+0x46e>
    10c4:	97ba                	add	a5,a5,a4
    10c6:	439c                	lw	a5,0(a5)
    10c8:	97ba                	add	a5,a5,a4
    10ca:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    10cc:	008b8913          	addi	s2,s7,8
    10d0:	4685                	li	a3,1
    10d2:	4629                	li	a2,10
    10d4:	000ba583          	lw	a1,0(s7)
    10d8:	8556                	mv	a0,s5
    10da:	00000097          	auipc	ra,0x0
    10de:	ed0080e7          	jalr	-304(ra) # faa <printint>
    10e2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    10e4:	4981                	li	s3,0
    10e6:	b745                	j	1086 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10e8:	008b8913          	addi	s2,s7,8
    10ec:	4681                	li	a3,0
    10ee:	4629                	li	a2,10
    10f0:	000ba583          	lw	a1,0(s7)
    10f4:	8556                	mv	a0,s5
    10f6:	00000097          	auipc	ra,0x0
    10fa:	eb4080e7          	jalr	-332(ra) # faa <printint>
    10fe:	8bca                	mv	s7,s2
      state = 0;
    1100:	4981                	li	s3,0
    1102:	b751                	j	1086 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1104:	008b8913          	addi	s2,s7,8
    1108:	4681                	li	a3,0
    110a:	4641                	li	a2,16
    110c:	000ba583          	lw	a1,0(s7)
    1110:	8556                	mv	a0,s5
    1112:	00000097          	auipc	ra,0x0
    1116:	e98080e7          	jalr	-360(ra) # faa <printint>
    111a:	8bca                	mv	s7,s2
      state = 0;
    111c:	4981                	li	s3,0
    111e:	b7a5                	j	1086 <vprintf+0x42>
    1120:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1122:	008b8c13          	addi	s8,s7,8
    1126:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    112a:	03000593          	li	a1,48
    112e:	8556                	mv	a0,s5
    1130:	00000097          	auipc	ra,0x0
    1134:	e58080e7          	jalr	-424(ra) # f88 <putc>
  putc(fd, 'x');
    1138:	07800593          	li	a1,120
    113c:	8556                	mv	a0,s5
    113e:	00000097          	auipc	ra,0x0
    1142:	e4a080e7          	jalr	-438(ra) # f88 <putc>
    1146:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1148:	00000b97          	auipc	s7,0x0
    114c:	678b8b93          	addi	s7,s7,1656 # 17c0 <digits>
    1150:	03c9d793          	srli	a5,s3,0x3c
    1154:	97de                	add	a5,a5,s7
    1156:	0007c583          	lbu	a1,0(a5)
    115a:	8556                	mv	a0,s5
    115c:	00000097          	auipc	ra,0x0
    1160:	e2c080e7          	jalr	-468(ra) # f88 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1164:	0992                	slli	s3,s3,0x4
    1166:	397d                	addiw	s2,s2,-1
    1168:	fe0914e3          	bnez	s2,1150 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    116c:	8be2                	mv	s7,s8
      state = 0;
    116e:	4981                	li	s3,0
    1170:	6c02                	ld	s8,0(sp)
    1172:	bf11                	j	1086 <vprintf+0x42>
        s = va_arg(ap, char*);
    1174:	008b8993          	addi	s3,s7,8
    1178:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    117c:	02090163          	beqz	s2,119e <vprintf+0x15a>
        while(*s != 0){
    1180:	00094583          	lbu	a1,0(s2)
    1184:	c9a5                	beqz	a1,11f4 <vprintf+0x1b0>
          putc(fd, *s);
    1186:	8556                	mv	a0,s5
    1188:	00000097          	auipc	ra,0x0
    118c:	e00080e7          	jalr	-512(ra) # f88 <putc>
          s++;
    1190:	0905                	addi	s2,s2,1
        while(*s != 0){
    1192:	00094583          	lbu	a1,0(s2)
    1196:	f9e5                	bnez	a1,1186 <vprintf+0x142>
        s = va_arg(ap, char*);
    1198:	8bce                	mv	s7,s3
      state = 0;
    119a:	4981                	li	s3,0
    119c:	b5ed                	j	1086 <vprintf+0x42>
          s = "(null)";
    119e:	00000917          	auipc	s2,0x0
    11a2:	56290913          	addi	s2,s2,1378 # 1700 <malloc+0x406>
        while(*s != 0){
    11a6:	02800593          	li	a1,40
    11aa:	bff1                	j	1186 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    11ac:	008b8913          	addi	s2,s7,8
    11b0:	000bc583          	lbu	a1,0(s7)
    11b4:	8556                	mv	a0,s5
    11b6:	00000097          	auipc	ra,0x0
    11ba:	dd2080e7          	jalr	-558(ra) # f88 <putc>
    11be:	8bca                	mv	s7,s2
      state = 0;
    11c0:	4981                	li	s3,0
    11c2:	b5d1                	j	1086 <vprintf+0x42>
        putc(fd, c);
    11c4:	02500593          	li	a1,37
    11c8:	8556                	mv	a0,s5
    11ca:	00000097          	auipc	ra,0x0
    11ce:	dbe080e7          	jalr	-578(ra) # f88 <putc>
      state = 0;
    11d2:	4981                	li	s3,0
    11d4:	bd4d                	j	1086 <vprintf+0x42>
        putc(fd, '%');
    11d6:	02500593          	li	a1,37
    11da:	8556                	mv	a0,s5
    11dc:	00000097          	auipc	ra,0x0
    11e0:	dac080e7          	jalr	-596(ra) # f88 <putc>
        putc(fd, c);
    11e4:	85ca                	mv	a1,s2
    11e6:	8556                	mv	a0,s5
    11e8:	00000097          	auipc	ra,0x0
    11ec:	da0080e7          	jalr	-608(ra) # f88 <putc>
      state = 0;
    11f0:	4981                	li	s3,0
    11f2:	bd51                	j	1086 <vprintf+0x42>
        s = va_arg(ap, char*);
    11f4:	8bce                	mv	s7,s3
      state = 0;
    11f6:	4981                	li	s3,0
    11f8:	b579                	j	1086 <vprintf+0x42>
    11fa:	74e2                	ld	s1,56(sp)
    11fc:	79a2                	ld	s3,40(sp)
    11fe:	7a02                	ld	s4,32(sp)
    1200:	6ae2                	ld	s5,24(sp)
    1202:	6b42                	ld	s6,16(sp)
    1204:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1206:	60a6                	ld	ra,72(sp)
    1208:	6406                	ld	s0,64(sp)
    120a:	7942                	ld	s2,48(sp)
    120c:	6161                	addi	sp,sp,80
    120e:	8082                	ret

0000000000001210 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1210:	715d                	addi	sp,sp,-80
    1212:	ec06                	sd	ra,24(sp)
    1214:	e822                	sd	s0,16(sp)
    1216:	1000                	addi	s0,sp,32
    1218:	e010                	sd	a2,0(s0)
    121a:	e414                	sd	a3,8(s0)
    121c:	e818                	sd	a4,16(s0)
    121e:	ec1c                	sd	a5,24(s0)
    1220:	03043023          	sd	a6,32(s0)
    1224:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1228:	8622                	mv	a2,s0
    122a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    122e:	00000097          	auipc	ra,0x0
    1232:	e16080e7          	jalr	-490(ra) # 1044 <vprintf>
}
    1236:	60e2                	ld	ra,24(sp)
    1238:	6442                	ld	s0,16(sp)
    123a:	6161                	addi	sp,sp,80
    123c:	8082                	ret

000000000000123e <printf>:

void
printf(const char *fmt, ...)
{
    123e:	711d                	addi	sp,sp,-96
    1240:	ec06                	sd	ra,24(sp)
    1242:	e822                	sd	s0,16(sp)
    1244:	1000                	addi	s0,sp,32
    1246:	e40c                	sd	a1,8(s0)
    1248:	e810                	sd	a2,16(s0)
    124a:	ec14                	sd	a3,24(s0)
    124c:	f018                	sd	a4,32(s0)
    124e:	f41c                	sd	a5,40(s0)
    1250:	03043823          	sd	a6,48(s0)
    1254:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1258:	00840613          	addi	a2,s0,8
    125c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1260:	85aa                	mv	a1,a0
    1262:	4505                	li	a0,1
    1264:	00000097          	auipc	ra,0x0
    1268:	de0080e7          	jalr	-544(ra) # 1044 <vprintf>
}
    126c:	60e2                	ld	ra,24(sp)
    126e:	6442                	ld	s0,16(sp)
    1270:	6125                	addi	sp,sp,96
    1272:	8082                	ret

0000000000001274 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1274:	1141                	addi	sp,sp,-16
    1276:	e406                	sd	ra,8(sp)
    1278:	e022                	sd	s0,0(sp)
    127a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    127c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1280:	00000797          	auipc	a5,0x0
    1284:	5607b783          	ld	a5,1376(a5) # 17e0 <freep>
    1288:	a02d                	j	12b2 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    128a:	4618                	lw	a4,8(a2)
    128c:	9f2d                	addw	a4,a4,a1
    128e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1292:	6398                	ld	a4,0(a5)
    1294:	6310                	ld	a2,0(a4)
    1296:	a83d                	j	12d4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1298:	ff852703          	lw	a4,-8(a0)
    129c:	9f31                	addw	a4,a4,a2
    129e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    12a0:	ff053683          	ld	a3,-16(a0)
    12a4:	a091                	j	12e8 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12a6:	6398                	ld	a4,0(a5)
    12a8:	00e7e463          	bltu	a5,a4,12b0 <free+0x3c>
    12ac:	00e6ea63          	bltu	a3,a4,12c0 <free+0x4c>
{
    12b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    12b2:	fed7fae3          	bgeu	a5,a3,12a6 <free+0x32>
    12b6:	6398                	ld	a4,0(a5)
    12b8:	00e6e463          	bltu	a3,a4,12c0 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    12bc:	fee7eae3          	bltu	a5,a4,12b0 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    12c0:	ff852583          	lw	a1,-8(a0)
    12c4:	6390                	ld	a2,0(a5)
    12c6:	02059813          	slli	a6,a1,0x20
    12ca:	01c85713          	srli	a4,a6,0x1c
    12ce:	9736                	add	a4,a4,a3
    12d0:	fae60de3          	beq	a2,a4,128a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    12d4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12d8:	4790                	lw	a2,8(a5)
    12da:	02061593          	slli	a1,a2,0x20
    12de:	01c5d713          	srli	a4,a1,0x1c
    12e2:	973e                	add	a4,a4,a5
    12e4:	fae68ae3          	beq	a3,a4,1298 <free+0x24>
    p->s.ptr = bp->s.ptr;
    12e8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    12ea:	00000717          	auipc	a4,0x0
    12ee:	4ef73b23          	sd	a5,1270(a4) # 17e0 <freep>
}
    12f2:	60a2                	ld	ra,8(sp)
    12f4:	6402                	ld	s0,0(sp)
    12f6:	0141                	addi	sp,sp,16
    12f8:	8082                	ret

00000000000012fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12fa:	7139                	addi	sp,sp,-64
    12fc:	fc06                	sd	ra,56(sp)
    12fe:	f822                	sd	s0,48(sp)
    1300:	f04a                	sd	s2,32(sp)
    1302:	ec4e                	sd	s3,24(sp)
    1304:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1306:	02051993          	slli	s3,a0,0x20
    130a:	0209d993          	srli	s3,s3,0x20
    130e:	09bd                	addi	s3,s3,15
    1310:	0049d993          	srli	s3,s3,0x4
    1314:	2985                	addiw	s3,s3,1
    1316:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1318:	00000517          	auipc	a0,0x0
    131c:	4c853503          	ld	a0,1224(a0) # 17e0 <freep>
    1320:	c905                	beqz	a0,1350 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1322:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1324:	4798                	lw	a4,8(a5)
    1326:	09377a63          	bgeu	a4,s3,13ba <malloc+0xc0>
    132a:	f426                	sd	s1,40(sp)
    132c:	e852                	sd	s4,16(sp)
    132e:	e456                	sd	s5,8(sp)
    1330:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1332:	8a4e                	mv	s4,s3
    1334:	6705                	lui	a4,0x1
    1336:	00e9f363          	bgeu	s3,a4,133c <malloc+0x42>
    133a:	6a05                	lui	s4,0x1
    133c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1340:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1344:	00000497          	auipc	s1,0x0
    1348:	49c48493          	addi	s1,s1,1180 # 17e0 <freep>
  if(p == (char*)-1)
    134c:	5afd                	li	s5,-1
    134e:	a089                	j	1390 <malloc+0x96>
    1350:	f426                	sd	s1,40(sp)
    1352:	e852                	sd	s4,16(sp)
    1354:	e456                	sd	s5,8(sp)
    1356:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1358:	00001797          	auipc	a5,0x1
    135c:	87878793          	addi	a5,a5,-1928 # 1bd0 <base>
    1360:	00000717          	auipc	a4,0x0
    1364:	48f73023          	sd	a5,1152(a4) # 17e0 <freep>
    1368:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    136a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    136e:	b7d1                	j	1332 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1370:	6398                	ld	a4,0(a5)
    1372:	e118                	sd	a4,0(a0)
    1374:	a8b9                	j	13d2 <malloc+0xd8>
  hp->s.size = nu;
    1376:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    137a:	0541                	addi	a0,a0,16
    137c:	00000097          	auipc	ra,0x0
    1380:	ef8080e7          	jalr	-264(ra) # 1274 <free>
  return freep;
    1384:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1386:	c135                	beqz	a0,13ea <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1388:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    138a:	4798                	lw	a4,8(a5)
    138c:	03277363          	bgeu	a4,s2,13b2 <malloc+0xb8>
    if(p == freep)
    1390:	6098                	ld	a4,0(s1)
    1392:	853e                	mv	a0,a5
    1394:	fef71ae3          	bne	a4,a5,1388 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1398:	8552                	mv	a0,s4
    139a:	00000097          	auipc	ra,0x0
    139e:	bc6080e7          	jalr	-1082(ra) # f60 <sbrk>
  if(p == (char*)-1)
    13a2:	fd551ae3          	bne	a0,s5,1376 <malloc+0x7c>
        return 0;
    13a6:	4501                	li	a0,0
    13a8:	74a2                	ld	s1,40(sp)
    13aa:	6a42                	ld	s4,16(sp)
    13ac:	6aa2                	ld	s5,8(sp)
    13ae:	6b02                	ld	s6,0(sp)
    13b0:	a03d                	j	13de <malloc+0xe4>
    13b2:	74a2                	ld	s1,40(sp)
    13b4:	6a42                	ld	s4,16(sp)
    13b6:	6aa2                	ld	s5,8(sp)
    13b8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    13ba:	fae90be3          	beq	s2,a4,1370 <malloc+0x76>
        p->s.size -= nunits;
    13be:	4137073b          	subw	a4,a4,s3
    13c2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    13c4:	02071693          	slli	a3,a4,0x20
    13c8:	01c6d713          	srli	a4,a3,0x1c
    13cc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    13ce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    13d2:	00000717          	auipc	a4,0x0
    13d6:	40a73723          	sd	a0,1038(a4) # 17e0 <freep>
      return (void*)(p + 1);
    13da:	01078513          	addi	a0,a5,16
  }
}
    13de:	70e2                	ld	ra,56(sp)
    13e0:	7442                	ld	s0,48(sp)
    13e2:	7902                	ld	s2,32(sp)
    13e4:	69e2                	ld	s3,24(sp)
    13e6:	6121                	addi	sp,sp,64
    13e8:	8082                	ret
    13ea:	74a2                	ld	s1,40(sp)
    13ec:	6a42                	ld	s4,16(sp)
    13ee:	6aa2                	ld	s5,8(sp)
    13f0:	6b02                	ld	s6,0(sp)
    13f2:	b7f5                	j	13de <malloc+0xe4>
