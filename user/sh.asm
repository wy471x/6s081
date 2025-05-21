
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  // fprintf(2, "$ ");
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	2e658593          	addi	a1,a1,742 # 12f8 <malloc+0x102>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	dda080e7          	jalr	-550(ra) # df6 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	bb2080e7          	jalr	-1102(ra) # bdc <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	bec080e7          	jalr	-1044(ra) # c22 <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	addi	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0);
}

void
panic(char *s)
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	2a858593          	addi	a1,a1,680 # 1308 <malloc+0x112>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	0a6080e7          	jalr	166(ra) # 1110 <fprintf>
  exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	d62080e7          	jalr	-670(ra) # dd6 <exit>

000000000000007c <fork1>:
}

int
fork1(void)
{
      7c:	1141                	addi	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	d4a080e7          	jalr	-694(ra) # dce <fork>
  if(pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
    panic("fork");
  return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	addi	sp,sp,16
      98:	8082                	ret
    panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	27650513          	addi	a0,a0,630 # 1310 <malloc+0x11a>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	addi	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	1800                	addi	s0,sp,48
  if(cmd == 0)
      b2:	c115                	beqz	a0,d6 <runcmd+0x2c>
      b4:	ec26                	sd	s1,24(sp)
      b6:	84aa                	mv	s1,a0
  switch(cmd->type){
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e363          	bltu	a5,a4,e2 <runcmd+0x38>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	slli	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	34a70713          	addi	a4,a4,842 # 1410 <malloc+0x21a>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
    exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	cfc080e7          	jalr	-772(ra) # dd6 <exit>
    panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	23650513          	addi	a0,a0,566 # 1318 <malloc+0x122>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
    exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	addi	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	d14080e7          	jalr	-748(ra) # e0e <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	21c58593          	addi	a1,a1,540 # 1320 <malloc+0x12a>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	002080e7          	jalr	2(ra) # 1110 <fprintf>
  exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	cbe080e7          	jalr	-834(ra) # dd6 <exit>
      exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	cb4080e7          	jalr	-844(ra) # dd6 <exit>
    close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	cd2080e7          	jalr	-814(ra) # dfe <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	cde080e7          	jalr	-802(ra) # e16 <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
    runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	1e058593          	addi	a1,a1,480 # 1330 <malloc+0x13a>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	fb6080e7          	jalr	-74(ra) # 1110 <fprintf>
      exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	c72080e7          	jalr	-910(ra) # dd6 <exit>
    if(fork1() == 0)
     16c:	00000097          	auipc	ra,0x0
     170:	f10080e7          	jalr	-240(ra) # 7c <fork1>
     174:	e511                	bnez	a0,180 <runcmd+0xd6>
      runcmd(lcmd->left);
     176:	6488                	ld	a0,8(s1)
     178:	00000097          	auipc	ra,0x0
     17c:	f32080e7          	jalr	-206(ra) # aa <runcmd>
    wait(0);
     180:	4501                	li	a0,0
     182:	00001097          	auipc	ra,0x1
     186:	c5c080e7          	jalr	-932(ra) # dde <wait>
    runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
    if(pipe(p) < 0)
     194:	fd840513          	addi	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	c4e080e7          	jalr	-946(ra) # de6 <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
    if(fork1() == 0){
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
      close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	c4e080e7          	jalr	-946(ra) # dfe <close>
      dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	c92080e7          	jalr	-878(ra) # e4e <dup>
      close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	c36080e7          	jalr	-970(ra) # dfe <close>
      close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	c2a080e7          	jalr	-982(ra) # dfe <close>
      runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
      panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	15a50513          	addi	a0,a0,346 # 1340 <malloc+0x14a>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
    if(fork1() == 0){
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
      close(0);
     200:	00001097          	auipc	ra,0x1
     204:	bfe080e7          	jalr	-1026(ra) # dfe <close>
      dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	c42080e7          	jalr	-958(ra) # e4e <dup>
      close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	be6080e7          	jalr	-1050(ra) # dfe <close>
      close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	bda080e7          	jalr	-1062(ra) # dfe <close>
      runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
    close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	bc4080e7          	jalr	-1084(ra) # dfe <close>
    close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	bb8080e7          	jalr	-1096(ra) # dfe <close>
    wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	b8e080e7          	jalr	-1138(ra) # dde <wait>
    wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	b84080e7          	jalr	-1148(ra) # dde <wait>
    break;
     262:	bd55                	j	116 <runcmd+0x6c>
    if(fork1() == 0)
     264:	00000097          	auipc	ra,0x0
     268:	e18080e7          	jalr	-488(ra) # 7c <fork1>
     26c:	ea0515e3          	bnez	a0,116 <runcmd+0x6c>
      runcmd(bcmd->cmd);
     270:	6488                	ld	a0,8(s1)
     272:	00000097          	auipc	ra,0x0
     276:	e38080e7          	jalr	-456(ra) # aa <runcmd>

000000000000027a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     27a:	1101                	addi	sp,sp,-32
     27c:	ec06                	sd	ra,24(sp)
     27e:	e822                	sd	s0,16(sp)
     280:	e426                	sd	s1,8(sp)
     282:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	00001097          	auipc	ra,0x1
     28c:	f6e080e7          	jalr	-146(ra) # 11f6 <malloc>
     290:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	944080e7          	jalr	-1724(ra) # bdc <memset>
  cmd->type = EXEC;
     2a0:	4785                	li	a5,1
     2a2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a4:	8526                	mv	a0,s1
     2a6:	60e2                	ld	ra,24(sp)
     2a8:	6442                	ld	s0,16(sp)
     2aa:	64a2                	ld	s1,8(sp)
     2ac:	6105                	addi	sp,sp,32
     2ae:	8082                	ret

00000000000002b0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2b0:	7139                	addi	sp,sp,-64
     2b2:	fc06                	sd	ra,56(sp)
     2b4:	f822                	sd	s0,48(sp)
     2b6:	f426                	sd	s1,40(sp)
     2b8:	f04a                	sd	s2,32(sp)
     2ba:	ec4e                	sd	s3,24(sp)
     2bc:	e852                	sd	s4,16(sp)
     2be:	e456                	sd	s5,8(sp)
     2c0:	e05a                	sd	s6,0(sp)
     2c2:	0080                	addi	s0,sp,64
     2c4:	8b2a                	mv	s6,a0
     2c6:	8aae                	mv	s5,a1
     2c8:	8a32                	mv	s4,a2
     2ca:	89b6                	mv	s3,a3
     2cc:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ce:	02800513          	li	a0,40
     2d2:	00001097          	auipc	ra,0x1
     2d6:	f24080e7          	jalr	-220(ra) # 11f6 <malloc>
     2da:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	8fa080e7          	jalr	-1798(ra) # bdc <memset>
  cmd->type = REDIR;
     2ea:	4789                	li	a5,2
     2ec:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ee:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f2:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f6:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2fa:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fe:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	70e2                	ld	ra,56(sp)
     306:	7442                	ld	s0,48(sp)
     308:	74a2                	ld	s1,40(sp)
     30a:	7902                	ld	s2,32(sp)
     30c:	69e2                	ld	s3,24(sp)
     30e:	6a42                	ld	s4,16(sp)
     310:	6aa2                	ld	s5,8(sp)
     312:	6b02                	ld	s6,0(sp)
     314:	6121                	addi	sp,sp,64
     316:	8082                	ret

0000000000000318 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     318:	7179                	addi	sp,sp,-48
     31a:	f406                	sd	ra,40(sp)
     31c:	f022                	sd	s0,32(sp)
     31e:	ec26                	sd	s1,24(sp)
     320:	e84a                	sd	s2,16(sp)
     322:	e44e                	sd	s3,8(sp)
     324:	1800                	addi	s0,sp,48
     326:	89aa                	mv	s3,a0
     328:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     32a:	4561                	li	a0,24
     32c:	00001097          	auipc	ra,0x1
     330:	eca080e7          	jalr	-310(ra) # 11f6 <malloc>
     334:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	8a2080e7          	jalr	-1886(ra) # bdc <memset>
  cmd->type = PIPE;
     342:	478d                	li	a5,3
     344:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     346:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     34a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34e:	8526                	mv	a0,s1
     350:	70a2                	ld	ra,40(sp)
     352:	7402                	ld	s0,32(sp)
     354:	64e2                	ld	s1,24(sp)
     356:	6942                	ld	s2,16(sp)
     358:	69a2                	ld	s3,8(sp)
     35a:	6145                	addi	sp,sp,48
     35c:	8082                	ret

000000000000035e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35e:	7179                	addi	sp,sp,-48
     360:	f406                	sd	ra,40(sp)
     362:	f022                	sd	s0,32(sp)
     364:	ec26                	sd	s1,24(sp)
     366:	e84a                	sd	s2,16(sp)
     368:	e44e                	sd	s3,8(sp)
     36a:	1800                	addi	s0,sp,48
     36c:	89aa                	mv	s3,a0
     36e:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     370:	4561                	li	a0,24
     372:	00001097          	auipc	ra,0x1
     376:	e84080e7          	jalr	-380(ra) # 11f6 <malloc>
     37a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	85c080e7          	jalr	-1956(ra) # bdc <memset>
  cmd->type = LIST;
     388:	4791                	li	a5,4
     38a:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38c:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     390:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     394:	8526                	mv	a0,s1
     396:	70a2                	ld	ra,40(sp)
     398:	7402                	ld	s0,32(sp)
     39a:	64e2                	ld	s1,24(sp)
     39c:	6942                	ld	s2,16(sp)
     39e:	69a2                	ld	s3,8(sp)
     3a0:	6145                	addi	sp,sp,48
     3a2:	8082                	ret

00000000000003a4 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a4:	1101                	addi	sp,sp,-32
     3a6:	ec06                	sd	ra,24(sp)
     3a8:	e822                	sd	s0,16(sp)
     3aa:	e426                	sd	s1,8(sp)
     3ac:	e04a                	sd	s2,0(sp)
     3ae:	1000                	addi	s0,sp,32
     3b0:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b2:	4541                	li	a0,16
     3b4:	00001097          	auipc	ra,0x1
     3b8:	e42080e7          	jalr	-446(ra) # 11f6 <malloc>
     3bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	81a080e7          	jalr	-2022(ra) # bdc <memset>
  cmd->type = BACK;
     3ca:	4795                	li	a5,5
     3cc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ce:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d2:	8526                	mv	a0,s1
     3d4:	60e2                	ld	ra,24(sp)
     3d6:	6442                	ld	s0,16(sp)
     3d8:	64a2                	ld	s1,8(sp)
     3da:	6902                	ld	s2,0(sp)
     3dc:	6105                	addi	sp,sp,32
     3de:	8082                	ret

00000000000003e0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	7139                	addi	sp,sp,-64
     3e2:	fc06                	sd	ra,56(sp)
     3e4:	f822                	sd	s0,48(sp)
     3e6:	f426                	sd	s1,40(sp)
     3e8:	f04a                	sd	s2,32(sp)
     3ea:	ec4e                	sd	s3,24(sp)
     3ec:	e852                	sd	s4,16(sp)
     3ee:	e456                	sd	s5,8(sp)
     3f0:	e05a                	sd	s6,0(sp)
     3f2:	0080                	addi	s0,sp,64
     3f4:	8a2a                	mv	s4,a0
     3f6:	892e                	mv	s2,a1
     3f8:	8ab2                	mv	s5,a2
     3fa:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fc:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fe:	00001997          	auipc	s3,0x1
     402:	0ba98993          	addi	s3,s3,186 # 14b8 <whitespace>
     406:	00b4fe63          	bgeu	s1,a1,422 <gettoken+0x42>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	00000097          	auipc	ra,0x0
     414:	7ee080e7          	jalr	2030(ra) # bfe <strchr>
     418:	c509                	beqz	a0,422 <gettoken+0x42>
    s++;
     41a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41c:	fe9917e3          	bne	s2,s1,40a <gettoken+0x2a>
     420:	84ca                	mv	s1,s2
  if(q)
     422:	000a8463          	beqz	s5,42a <gettoken+0x4a>
    *q = s;
     426:	009ab023          	sd	s1,0(s5)
  ret = *s;
     42a:	0004c783          	lbu	a5,0(s1)
     42e:	00078a9b          	sext.w	s5,a5
  switch(*s){
     432:	03c00713          	li	a4,60
     436:	06f76663          	bltu	a4,a5,4a2 <gettoken+0xc2>
     43a:	03a00713          	li	a4,58
     43e:	00f76e63          	bltu	a4,a5,45a <gettoken+0x7a>
     442:	cf89                	beqz	a5,45c <gettoken+0x7c>
     444:	02600713          	li	a4,38
     448:	00e78963          	beq	a5,a4,45a <gettoken+0x7a>
     44c:	fd87879b          	addiw	a5,a5,-40
     450:	0ff7f793          	zext.b	a5,a5
     454:	4705                	li	a4,1
     456:	06f76d63          	bltu	a4,a5,4d0 <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     45a:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45c:	000b0463          	beqz	s6,464 <gettoken+0x84>
    *eq = s;
     460:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     464:	00001997          	auipc	s3,0x1
     468:	05498993          	addi	s3,s3,84 # 14b8 <whitespace>
     46c:	0124fe63          	bgeu	s1,s2,488 <gettoken+0xa8>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	00000097          	auipc	ra,0x0
     47a:	788080e7          	jalr	1928(ra) # bfe <strchr>
     47e:	c509                	beqz	a0,488 <gettoken+0xa8>
    s++;
     480:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     482:	fe9917e3          	bne	s2,s1,470 <gettoken+0x90>
     486:	84ca                	mv	s1,s2
  *ps = s;
     488:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48c:	8556                	mv	a0,s5
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6b02                	ld	s6,0(sp)
     49e:	6121                	addi	sp,sp,64
     4a0:	8082                	ret
  switch(*s){
     4a2:	03e00713          	li	a4,62
     4a6:	02e79163          	bne	a5,a4,4c8 <gettoken+0xe8>
    s++;
     4aa:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     4ae:	0014c703          	lbu	a4,1(s1)
     4b2:	03e00793          	li	a5,62
      s++;
     4b6:	0489                	addi	s1,s1,2
      ret = '+';
     4b8:	02b00a93          	li	s5,43
    if(*s == '>'){
     4bc:	faf700e3          	beq	a4,a5,45c <gettoken+0x7c>
    s++;
     4c0:	84b6                	mv	s1,a3
  ret = *s;
     4c2:	03e00a93          	li	s5,62
     4c6:	bf59                	j	45c <gettoken+0x7c>
  switch(*s){
     4c8:	07c00713          	li	a4,124
     4cc:	f8e787e3          	beq	a5,a4,45a <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4d0:	00001997          	auipc	s3,0x1
     4d4:	fe898993          	addi	s3,s3,-24 # 14b8 <whitespace>
     4d8:	00001a97          	auipc	s5,0x1
     4dc:	fd8a8a93          	addi	s5,s5,-40 # 14b0 <symbols>
     4e0:	0524f163          	bgeu	s1,s2,522 <gettoken+0x142>
     4e4:	0004c583          	lbu	a1,0(s1)
     4e8:	854e                	mv	a0,s3
     4ea:	00000097          	auipc	ra,0x0
     4ee:	714080e7          	jalr	1812(ra) # bfe <strchr>
     4f2:	e50d                	bnez	a0,51c <gettoken+0x13c>
     4f4:	0004c583          	lbu	a1,0(s1)
     4f8:	8556                	mv	a0,s5
     4fa:	00000097          	auipc	ra,0x0
     4fe:	704080e7          	jalr	1796(ra) # bfe <strchr>
     502:	e911                	bnez	a0,516 <gettoken+0x136>
      s++;
     504:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     506:	fc991fe3          	bne	s2,s1,4e4 <gettoken+0x104>
  if(eq)
     50a:	84ca                	mv	s1,s2
    ret = 'a';
     50c:	06100a93          	li	s5,97
  if(eq)
     510:	f40b18e3          	bnez	s6,460 <gettoken+0x80>
     514:	bf95                	j	488 <gettoken+0xa8>
    ret = 'a';
     516:	06100a93          	li	s5,97
     51a:	b789                	j	45c <gettoken+0x7c>
     51c:	06100a93          	li	s5,97
     520:	bf35                	j	45c <gettoken+0x7c>
     522:	06100a93          	li	s5,97
  if(eq)
     526:	f20b1de3          	bnez	s6,460 <gettoken+0x80>
     52a:	bfb9                	j	488 <gettoken+0xa8>

000000000000052c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     52c:	7139                	addi	sp,sp,-64
     52e:	fc06                	sd	ra,56(sp)
     530:	f822                	sd	s0,48(sp)
     532:	f426                	sd	s1,40(sp)
     534:	f04a                	sd	s2,32(sp)
     536:	ec4e                	sd	s3,24(sp)
     538:	e852                	sd	s4,16(sp)
     53a:	e456                	sd	s5,8(sp)
     53c:	0080                	addi	s0,sp,64
     53e:	8a2a                	mv	s4,a0
     540:	892e                	mv	s2,a1
     542:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     544:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     546:	00001997          	auipc	s3,0x1
     54a:	f7298993          	addi	s3,s3,-142 # 14b8 <whitespace>
     54e:	00b4fe63          	bgeu	s1,a1,56a <peek+0x3e>
     552:	0004c583          	lbu	a1,0(s1)
     556:	854e                	mv	a0,s3
     558:	00000097          	auipc	ra,0x0
     55c:	6a6080e7          	jalr	1702(ra) # bfe <strchr>
     560:	c509                	beqz	a0,56a <peek+0x3e>
    s++;
     562:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     564:	fe9917e3          	bne	s2,s1,552 <peek+0x26>
     568:	84ca                	mv	s1,s2
  *ps = s;
     56a:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     56e:	0004c583          	lbu	a1,0(s1)
     572:	4501                	li	a0,0
     574:	e991                	bnez	a1,588 <peek+0x5c>
}
     576:	70e2                	ld	ra,56(sp)
     578:	7442                	ld	s0,48(sp)
     57a:	74a2                	ld	s1,40(sp)
     57c:	7902                	ld	s2,32(sp)
     57e:	69e2                	ld	s3,24(sp)
     580:	6a42                	ld	s4,16(sp)
     582:	6aa2                	ld	s5,8(sp)
     584:	6121                	addi	sp,sp,64
     586:	8082                	ret
  return *s && strchr(toks, *s);
     588:	8556                	mv	a0,s5
     58a:	00000097          	auipc	ra,0x0
     58e:	674080e7          	jalr	1652(ra) # bfe <strchr>
     592:	00a03533          	snez	a0,a0
     596:	b7c5                	j	576 <peek+0x4a>

0000000000000598 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     598:	711d                	addi	sp,sp,-96
     59a:	ec86                	sd	ra,88(sp)
     59c:	e8a2                	sd	s0,80(sp)
     59e:	e4a6                	sd	s1,72(sp)
     5a0:	e0ca                	sd	s2,64(sp)
     5a2:	fc4e                	sd	s3,56(sp)
     5a4:	f852                	sd	s4,48(sp)
     5a6:	f456                	sd	s5,40(sp)
     5a8:	f05a                	sd	s6,32(sp)
     5aa:	ec5e                	sd	s7,24(sp)
     5ac:	1080                	addi	s0,sp,96
     5ae:	8a2a                	mv	s4,a0
     5b0:	89ae                	mv	s3,a1
     5b2:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b4:	00001a97          	auipc	s5,0x1
     5b8:	db4a8a93          	addi	s5,s5,-588 # 1368 <malloc+0x172>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5bc:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     5c0:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     5c4:	a02d                	j	5ee <parseredirs+0x56>
      panic("missing file for redirection");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	d8250513          	addi	a0,a0,-638 # 1348 <malloc+0x152>
     5ce:	00000097          	auipc	ra,0x0
     5d2:	a88080e7          	jalr	-1400(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d6:	4701                	li	a4,0
     5d8:	4681                	li	a3,0
     5da:	fa043603          	ld	a2,-96(s0)
     5de:	fa843583          	ld	a1,-88(s0)
     5e2:	8552                	mv	a0,s4
     5e4:	00000097          	auipc	ra,0x0
     5e8:	ccc080e7          	jalr	-820(ra) # 2b0 <redircmd>
     5ec:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
     5ee:	8656                	mv	a2,s5
     5f0:	85ca                	mv	a1,s2
     5f2:	854e                	mv	a0,s3
     5f4:	00000097          	auipc	ra,0x0
     5f8:	f38080e7          	jalr	-200(ra) # 52c <peek>
     5fc:	cd25                	beqz	a0,674 <parseredirs+0xdc>
    tok = gettoken(ps, es, 0, 0);
     5fe:	4681                	li	a3,0
     600:	4601                	li	a2,0
     602:	85ca                	mv	a1,s2
     604:	854e                	mv	a0,s3
     606:	00000097          	auipc	ra,0x0
     60a:	dda080e7          	jalr	-550(ra) # 3e0 <gettoken>
     60e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     610:	fa040693          	addi	a3,s0,-96
     614:	fa840613          	addi	a2,s0,-88
     618:	85ca                	mv	a1,s2
     61a:	854e                	mv	a0,s3
     61c:	00000097          	auipc	ra,0x0
     620:	dc4080e7          	jalr	-572(ra) # 3e0 <gettoken>
     624:	fb6511e3          	bne	a0,s6,5c6 <parseredirs+0x2e>
    switch(tok){
     628:	fb7487e3          	beq	s1,s7,5d6 <parseredirs+0x3e>
     62c:	03e00793          	li	a5,62
     630:	02f48463          	beq	s1,a5,658 <parseredirs+0xc0>
     634:	02b00793          	li	a5,43
     638:	faf49be3          	bne	s1,a5,5ee <parseredirs+0x56>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     63c:	4705                	li	a4,1
     63e:	20100693          	li	a3,513
     642:	fa043603          	ld	a2,-96(s0)
     646:	fa843583          	ld	a1,-88(s0)
     64a:	8552                	mv	a0,s4
     64c:	00000097          	auipc	ra,0x0
     650:	c64080e7          	jalr	-924(ra) # 2b0 <redircmd>
     654:	8a2a                	mv	s4,a0
      break;
     656:	bf61                	j	5ee <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     658:	4705                	li	a4,1
     65a:	60100693          	li	a3,1537
     65e:	fa043603          	ld	a2,-96(s0)
     662:	fa843583          	ld	a1,-88(s0)
     666:	8552                	mv	a0,s4
     668:	00000097          	auipc	ra,0x0
     66c:	c48080e7          	jalr	-952(ra) # 2b0 <redircmd>
     670:	8a2a                	mv	s4,a0
      break;
     672:	bfb5                	j	5ee <parseredirs+0x56>
    }
  }
  return cmd;
}
     674:	8552                	mv	a0,s4
     676:	60e6                	ld	ra,88(sp)
     678:	6446                	ld	s0,80(sp)
     67a:	64a6                	ld	s1,72(sp)
     67c:	6906                	ld	s2,64(sp)
     67e:	79e2                	ld	s3,56(sp)
     680:	7a42                	ld	s4,48(sp)
     682:	7aa2                	ld	s5,40(sp)
     684:	7b02                	ld	s6,32(sp)
     686:	6be2                	ld	s7,24(sp)
     688:	6125                	addi	sp,sp,96
     68a:	8082                	ret

000000000000068c <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     68c:	7159                	addi	sp,sp,-112
     68e:	f486                	sd	ra,104(sp)
     690:	f0a2                	sd	s0,96(sp)
     692:	eca6                	sd	s1,88(sp)
     694:	e0d2                	sd	s4,64(sp)
     696:	fc56                	sd	s5,56(sp)
     698:	1880                	addi	s0,sp,112
     69a:	8a2a                	mv	s4,a0
     69c:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     69e:	00001617          	auipc	a2,0x1
     6a2:	cd260613          	addi	a2,a2,-814 # 1370 <malloc+0x17a>
     6a6:	00000097          	auipc	ra,0x0
     6aa:	e86080e7          	jalr	-378(ra) # 52c <peek>
     6ae:	ed15                	bnez	a0,6ea <parseexec+0x5e>
     6b0:	e8ca                	sd	s2,80(sp)
     6b2:	e4ce                	sd	s3,72(sp)
     6b4:	f85a                	sd	s6,48(sp)
     6b6:	f45e                	sd	s7,40(sp)
     6b8:	f062                	sd	s8,32(sp)
     6ba:	ec66                	sd	s9,24(sp)
     6bc:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6be:	00000097          	auipc	ra,0x0
     6c2:	bbc080e7          	jalr	-1092(ra) # 27a <execcmd>
     6c6:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6c8:	8656                	mv	a2,s5
     6ca:	85d2                	mv	a1,s4
     6cc:	00000097          	auipc	ra,0x0
     6d0:	ecc080e7          	jalr	-308(ra) # 598 <parseredirs>
     6d4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6d6:	008c0913          	addi	s2,s8,8
     6da:	00001b17          	auipc	s6,0x1
     6de:	cb6b0b13          	addi	s6,s6,-842 # 1390 <malloc+0x19a>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6e2:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6e6:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6e8:	a081                	j	728 <parseexec+0x9c>
    return parseblock(ps, es);
     6ea:	85d6                	mv	a1,s5
     6ec:	8552                	mv	a0,s4
     6ee:	00000097          	auipc	ra,0x0
     6f2:	1bc080e7          	jalr	444(ra) # 8aa <parseblock>
     6f6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6f8:	8526                	mv	a0,s1
     6fa:	70a6                	ld	ra,104(sp)
     6fc:	7406                	ld	s0,96(sp)
     6fe:	64e6                	ld	s1,88(sp)
     700:	6a06                	ld	s4,64(sp)
     702:	7ae2                	ld	s5,56(sp)
     704:	6165                	addi	sp,sp,112
     706:	8082                	ret
      panic("syntax");
     708:	00001517          	auipc	a0,0x1
     70c:	c7050513          	addi	a0,a0,-912 # 1378 <malloc+0x182>
     710:	00000097          	auipc	ra,0x0
     714:	946080e7          	jalr	-1722(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     718:	8656                	mv	a2,s5
     71a:	85d2                	mv	a1,s4
     71c:	8526                	mv	a0,s1
     71e:	00000097          	auipc	ra,0x0
     722:	e7a080e7          	jalr	-390(ra) # 598 <parseredirs>
     726:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     728:	865a                	mv	a2,s6
     72a:	85d6                	mv	a1,s5
     72c:	8552                	mv	a0,s4
     72e:	00000097          	auipc	ra,0x0
     732:	dfe080e7          	jalr	-514(ra) # 52c <peek>
     736:	e131                	bnez	a0,77a <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     738:	f9040693          	addi	a3,s0,-112
     73c:	f9840613          	addi	a2,s0,-104
     740:	85d6                	mv	a1,s5
     742:	8552                	mv	a0,s4
     744:	00000097          	auipc	ra,0x0
     748:	c9c080e7          	jalr	-868(ra) # 3e0 <gettoken>
     74c:	c51d                	beqz	a0,77a <parseexec+0xee>
    if(tok != 'a')
     74e:	fb951de3          	bne	a0,s9,708 <parseexec+0x7c>
    cmd->argv[argc] = q;
     752:	f9843783          	ld	a5,-104(s0)
     756:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     75a:	f9043783          	ld	a5,-112(s0)
     75e:	04f93823          	sd	a5,80(s2)
    argc++;
     762:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     764:	0921                	addi	s2,s2,8
     766:	fb7999e3          	bne	s3,s7,718 <parseexec+0x8c>
      panic("too many args");
     76a:	00001517          	auipc	a0,0x1
     76e:	c1650513          	addi	a0,a0,-1002 # 1380 <malloc+0x18a>
     772:	00000097          	auipc	ra,0x0
     776:	8e4080e7          	jalr	-1820(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     77a:	098e                	slli	s3,s3,0x3
     77c:	9c4e                	add	s8,s8,s3
     77e:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     782:	040c3c23          	sd	zero,88(s8)
     786:	6946                	ld	s2,80(sp)
     788:	69a6                	ld	s3,72(sp)
     78a:	7b42                	ld	s6,48(sp)
     78c:	7ba2                	ld	s7,40(sp)
     78e:	7c02                	ld	s8,32(sp)
     790:	6ce2                	ld	s9,24(sp)
  return ret;
     792:	b79d                	j	6f8 <parseexec+0x6c>

0000000000000794 <parsepipe>:
{
     794:	7179                	addi	sp,sp,-48
     796:	f406                	sd	ra,40(sp)
     798:	f022                	sd	s0,32(sp)
     79a:	ec26                	sd	s1,24(sp)
     79c:	e84a                	sd	s2,16(sp)
     79e:	e44e                	sd	s3,8(sp)
     7a0:	1800                	addi	s0,sp,48
     7a2:	892a                	mv	s2,a0
     7a4:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7a6:	00000097          	auipc	ra,0x0
     7aa:	ee6080e7          	jalr	-282(ra) # 68c <parseexec>
     7ae:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7b0:	00001617          	auipc	a2,0x1
     7b4:	be860613          	addi	a2,a2,-1048 # 1398 <malloc+0x1a2>
     7b8:	85ce                	mv	a1,s3
     7ba:	854a                	mv	a0,s2
     7bc:	00000097          	auipc	ra,0x0
     7c0:	d70080e7          	jalr	-656(ra) # 52c <peek>
     7c4:	e909                	bnez	a0,7d6 <parsepipe+0x42>
}
     7c6:	8526                	mv	a0,s1
     7c8:	70a2                	ld	ra,40(sp)
     7ca:	7402                	ld	s0,32(sp)
     7cc:	64e2                	ld	s1,24(sp)
     7ce:	6942                	ld	s2,16(sp)
     7d0:	69a2                	ld	s3,8(sp)
     7d2:	6145                	addi	sp,sp,48
     7d4:	8082                	ret
    gettoken(ps, es, 0, 0);
     7d6:	4681                	li	a3,0
     7d8:	4601                	li	a2,0
     7da:	85ce                	mv	a1,s3
     7dc:	854a                	mv	a0,s2
     7de:	00000097          	auipc	ra,0x0
     7e2:	c02080e7          	jalr	-1022(ra) # 3e0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7e6:	85ce                	mv	a1,s3
     7e8:	854a                	mv	a0,s2
     7ea:	00000097          	auipc	ra,0x0
     7ee:	faa080e7          	jalr	-86(ra) # 794 <parsepipe>
     7f2:	85aa                	mv	a1,a0
     7f4:	8526                	mv	a0,s1
     7f6:	00000097          	auipc	ra,0x0
     7fa:	b22080e7          	jalr	-1246(ra) # 318 <pipecmd>
     7fe:	84aa                	mv	s1,a0
  return cmd;
     800:	b7d9                	j	7c6 <parsepipe+0x32>

0000000000000802 <parseline>:
{
     802:	7179                	addi	sp,sp,-48
     804:	f406                	sd	ra,40(sp)
     806:	f022                	sd	s0,32(sp)
     808:	ec26                	sd	s1,24(sp)
     80a:	e84a                	sd	s2,16(sp)
     80c:	e44e                	sd	s3,8(sp)
     80e:	e052                	sd	s4,0(sp)
     810:	1800                	addi	s0,sp,48
     812:	892a                	mv	s2,a0
     814:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     816:	00000097          	auipc	ra,0x0
     81a:	f7e080e7          	jalr	-130(ra) # 794 <parsepipe>
     81e:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     820:	00001a17          	auipc	s4,0x1
     824:	b80a0a13          	addi	s4,s4,-1152 # 13a0 <malloc+0x1aa>
     828:	a839                	j	846 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     82a:	4681                	li	a3,0
     82c:	4601                	li	a2,0
     82e:	85ce                	mv	a1,s3
     830:	854a                	mv	a0,s2
     832:	00000097          	auipc	ra,0x0
     836:	bae080e7          	jalr	-1106(ra) # 3e0 <gettoken>
    cmd = backcmd(cmd);
     83a:	8526                	mv	a0,s1
     83c:	00000097          	auipc	ra,0x0
     840:	b68080e7          	jalr	-1176(ra) # 3a4 <backcmd>
     844:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     846:	8652                	mv	a2,s4
     848:	85ce                	mv	a1,s3
     84a:	854a                	mv	a0,s2
     84c:	00000097          	auipc	ra,0x0
     850:	ce0080e7          	jalr	-800(ra) # 52c <peek>
     854:	f979                	bnez	a0,82a <parseline+0x28>
  if(peek(ps, es, ";")){
     856:	00001617          	auipc	a2,0x1
     85a:	b5260613          	addi	a2,a2,-1198 # 13a8 <malloc+0x1b2>
     85e:	85ce                	mv	a1,s3
     860:	854a                	mv	a0,s2
     862:	00000097          	auipc	ra,0x0
     866:	cca080e7          	jalr	-822(ra) # 52c <peek>
     86a:	e911                	bnez	a0,87e <parseline+0x7c>
}
     86c:	8526                	mv	a0,s1
     86e:	70a2                	ld	ra,40(sp)
     870:	7402                	ld	s0,32(sp)
     872:	64e2                	ld	s1,24(sp)
     874:	6942                	ld	s2,16(sp)
     876:	69a2                	ld	s3,8(sp)
     878:	6a02                	ld	s4,0(sp)
     87a:	6145                	addi	sp,sp,48
     87c:	8082                	ret
    gettoken(ps, es, 0, 0);
     87e:	4681                	li	a3,0
     880:	4601                	li	a2,0
     882:	85ce                	mv	a1,s3
     884:	854a                	mv	a0,s2
     886:	00000097          	auipc	ra,0x0
     88a:	b5a080e7          	jalr	-1190(ra) # 3e0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     88e:	85ce                	mv	a1,s3
     890:	854a                	mv	a0,s2
     892:	00000097          	auipc	ra,0x0
     896:	f70080e7          	jalr	-144(ra) # 802 <parseline>
     89a:	85aa                	mv	a1,a0
     89c:	8526                	mv	a0,s1
     89e:	00000097          	auipc	ra,0x0
     8a2:	ac0080e7          	jalr	-1344(ra) # 35e <listcmd>
     8a6:	84aa                	mv	s1,a0
  return cmd;
     8a8:	b7d1                	j	86c <parseline+0x6a>

00000000000008aa <parseblock>:
{
     8aa:	7179                	addi	sp,sp,-48
     8ac:	f406                	sd	ra,40(sp)
     8ae:	f022                	sd	s0,32(sp)
     8b0:	ec26                	sd	s1,24(sp)
     8b2:	e84a                	sd	s2,16(sp)
     8b4:	e44e                	sd	s3,8(sp)
     8b6:	1800                	addi	s0,sp,48
     8b8:	84aa                	mv	s1,a0
     8ba:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8bc:	00001617          	auipc	a2,0x1
     8c0:	ab460613          	addi	a2,a2,-1356 # 1370 <malloc+0x17a>
     8c4:	00000097          	auipc	ra,0x0
     8c8:	c68080e7          	jalr	-920(ra) # 52c <peek>
     8cc:	c12d                	beqz	a0,92e <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8ce:	4681                	li	a3,0
     8d0:	4601                	li	a2,0
     8d2:	85ca                	mv	a1,s2
     8d4:	8526                	mv	a0,s1
     8d6:	00000097          	auipc	ra,0x0
     8da:	b0a080e7          	jalr	-1270(ra) # 3e0 <gettoken>
  cmd = parseline(ps, es);
     8de:	85ca                	mv	a1,s2
     8e0:	8526                	mv	a0,s1
     8e2:	00000097          	auipc	ra,0x0
     8e6:	f20080e7          	jalr	-224(ra) # 802 <parseline>
     8ea:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8ec:	00001617          	auipc	a2,0x1
     8f0:	ad460613          	addi	a2,a2,-1324 # 13c0 <malloc+0x1ca>
     8f4:	85ca                	mv	a1,s2
     8f6:	8526                	mv	a0,s1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	c34080e7          	jalr	-972(ra) # 52c <peek>
     900:	cd1d                	beqz	a0,93e <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     902:	4681                	li	a3,0
     904:	4601                	li	a2,0
     906:	85ca                	mv	a1,s2
     908:	8526                	mv	a0,s1
     90a:	00000097          	auipc	ra,0x0
     90e:	ad6080e7          	jalr	-1322(ra) # 3e0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     912:	864a                	mv	a2,s2
     914:	85a6                	mv	a1,s1
     916:	854e                	mv	a0,s3
     918:	00000097          	auipc	ra,0x0
     91c:	c80080e7          	jalr	-896(ra) # 598 <parseredirs>
}
     920:	70a2                	ld	ra,40(sp)
     922:	7402                	ld	s0,32(sp)
     924:	64e2                	ld	s1,24(sp)
     926:	6942                	ld	s2,16(sp)
     928:	69a2                	ld	s3,8(sp)
     92a:	6145                	addi	sp,sp,48
     92c:	8082                	ret
    panic("parseblock");
     92e:	00001517          	auipc	a0,0x1
     932:	a8250513          	addi	a0,a0,-1406 # 13b0 <malloc+0x1ba>
     936:	fffff097          	auipc	ra,0xfffff
     93a:	720080e7          	jalr	1824(ra) # 56 <panic>
    panic("syntax - missing )");
     93e:	00001517          	auipc	a0,0x1
     942:	a8a50513          	addi	a0,a0,-1398 # 13c8 <malloc+0x1d2>
     946:	fffff097          	auipc	ra,0xfffff
     94a:	710080e7          	jalr	1808(ra) # 56 <panic>

000000000000094e <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     94e:	1101                	addi	sp,sp,-32
     950:	ec06                	sd	ra,24(sp)
     952:	e822                	sd	s0,16(sp)
     954:	e426                	sd	s1,8(sp)
     956:	1000                	addi	s0,sp,32
     958:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     95a:	c521                	beqz	a0,9a2 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     95c:	4118                	lw	a4,0(a0)
     95e:	4795                	li	a5,5
     960:	04e7e163          	bltu	a5,a4,9a2 <nulterminate+0x54>
     964:	00056783          	lwu	a5,0(a0)
     968:	078a                	slli	a5,a5,0x2
     96a:	00001717          	auipc	a4,0x1
     96e:	abe70713          	addi	a4,a4,-1346 # 1428 <malloc+0x232>
     972:	97ba                	add	a5,a5,a4
     974:	439c                	lw	a5,0(a5)
     976:	97ba                	add	a5,a5,a4
     978:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     97a:	651c                	ld	a5,8(a0)
     97c:	c39d                	beqz	a5,9a2 <nulterminate+0x54>
     97e:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     982:	67b8                	ld	a4,72(a5)
     984:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     988:	07a1                	addi	a5,a5,8
     98a:	ff87b703          	ld	a4,-8(a5)
     98e:	fb75                	bnez	a4,982 <nulterminate+0x34>
     990:	a809                	j	9a2 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     992:	6508                	ld	a0,8(a0)
     994:	00000097          	auipc	ra,0x0
     998:	fba080e7          	jalr	-70(ra) # 94e <nulterminate>
    *rcmd->efile = 0;
     99c:	6c9c                	ld	a5,24(s1)
     99e:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9a2:	8526                	mv	a0,s1
     9a4:	60e2                	ld	ra,24(sp)
     9a6:	6442                	ld	s0,16(sp)
     9a8:	64a2                	ld	s1,8(sp)
     9aa:	6105                	addi	sp,sp,32
     9ac:	8082                	ret
    nulterminate(pcmd->left);
     9ae:	6508                	ld	a0,8(a0)
     9b0:	00000097          	auipc	ra,0x0
     9b4:	f9e080e7          	jalr	-98(ra) # 94e <nulterminate>
    nulterminate(pcmd->right);
     9b8:	6888                	ld	a0,16(s1)
     9ba:	00000097          	auipc	ra,0x0
     9be:	f94080e7          	jalr	-108(ra) # 94e <nulterminate>
    break;
     9c2:	b7c5                	j	9a2 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9c4:	6508                	ld	a0,8(a0)
     9c6:	00000097          	auipc	ra,0x0
     9ca:	f88080e7          	jalr	-120(ra) # 94e <nulterminate>
    nulterminate(lcmd->right);
     9ce:	6888                	ld	a0,16(s1)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	f7e080e7          	jalr	-130(ra) # 94e <nulterminate>
    break;
     9d8:	b7e9                	j	9a2 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9da:	6508                	ld	a0,8(a0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	f72080e7          	jalr	-142(ra) # 94e <nulterminate>
    break;
     9e4:	bf7d                	j	9a2 <nulterminate+0x54>

00000000000009e6 <parsecmd>:
{
     9e6:	7179                	addi	sp,sp,-48
     9e8:	f406                	sd	ra,40(sp)
     9ea:	f022                	sd	s0,32(sp)
     9ec:	ec26                	sd	s1,24(sp)
     9ee:	e84a                	sd	s2,16(sp)
     9f0:	1800                	addi	s0,sp,48
     9f2:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9f6:	84aa                	mv	s1,a0
     9f8:	00000097          	auipc	ra,0x0
     9fc:	1ba080e7          	jalr	442(ra) # bb2 <strlen>
     a00:	1502                	slli	a0,a0,0x20
     a02:	9101                	srli	a0,a0,0x20
     a04:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a06:	85a6                	mv	a1,s1
     a08:	fd840513          	addi	a0,s0,-40
     a0c:	00000097          	auipc	ra,0x0
     a10:	df6080e7          	jalr	-522(ra) # 802 <parseline>
     a14:	892a                	mv	s2,a0
  peek(&s, es, "");
     a16:	00001617          	auipc	a2,0x1
     a1a:	8ea60613          	addi	a2,a2,-1814 # 1300 <malloc+0x10a>
     a1e:	85a6                	mv	a1,s1
     a20:	fd840513          	addi	a0,s0,-40
     a24:	00000097          	auipc	ra,0x0
     a28:	b08080e7          	jalr	-1272(ra) # 52c <peek>
  if(s != es){
     a2c:	fd843603          	ld	a2,-40(s0)
     a30:	00961e63          	bne	a2,s1,a4c <parsecmd+0x66>
  nulterminate(cmd);
     a34:	854a                	mv	a0,s2
     a36:	00000097          	auipc	ra,0x0
     a3a:	f18080e7          	jalr	-232(ra) # 94e <nulterminate>
}
     a3e:	854a                	mv	a0,s2
     a40:	70a2                	ld	ra,40(sp)
     a42:	7402                	ld	s0,32(sp)
     a44:	64e2                	ld	s1,24(sp)
     a46:	6942                	ld	s2,16(sp)
     a48:	6145                	addi	sp,sp,48
     a4a:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a4c:	00001597          	auipc	a1,0x1
     a50:	99458593          	addi	a1,a1,-1644 # 13e0 <malloc+0x1ea>
     a54:	4509                	li	a0,2
     a56:	00000097          	auipc	ra,0x0
     a5a:	6ba080e7          	jalr	1722(ra) # 1110 <fprintf>
    panic("syntax");
     a5e:	00001517          	auipc	a0,0x1
     a62:	91a50513          	addi	a0,a0,-1766 # 1378 <malloc+0x182>
     a66:	fffff097          	auipc	ra,0xfffff
     a6a:	5f0080e7          	jalr	1520(ra) # 56 <panic>

0000000000000a6e <main>:
{
     a6e:	7179                	addi	sp,sp,-48
     a70:	f406                	sd	ra,40(sp)
     a72:	f022                	sd	s0,32(sp)
     a74:	ec26                	sd	s1,24(sp)
     a76:	e84a                	sd	s2,16(sp)
     a78:	e44e                	sd	s3,8(sp)
     a7a:	e052                	sd	s4,0(sp)
     a7c:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     a7e:	00001497          	auipc	s1,0x1
     a82:	97248493          	addi	s1,s1,-1678 # 13f0 <malloc+0x1fa>
     a86:	4589                	li	a1,2
     a88:	8526                	mv	a0,s1
     a8a:	00000097          	auipc	ra,0x0
     a8e:	38c080e7          	jalr	908(ra) # e16 <open>
     a92:	00054963          	bltz	a0,aa4 <main+0x36>
    if(fd >= 3){
     a96:	4789                	li	a5,2
     a98:	fea7d7e3          	bge	a5,a0,a86 <main+0x18>
      close(fd);
     a9c:	00000097          	auipc	ra,0x0
     aa0:	362080e7          	jalr	866(ra) # dfe <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aa4:	00001497          	auipc	s1,0x1
     aa8:	a2448493          	addi	s1,s1,-1500 # 14c8 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aac:	06300913          	li	s2,99
     ab0:	02000993          	li	s3,32
     ab4:	a819                	j	aca <main+0x5c>
    if(fork1() == 0)
     ab6:	fffff097          	auipc	ra,0xfffff
     aba:	5c6080e7          	jalr	1478(ra) # 7c <fork1>
     abe:	c549                	beqz	a0,b48 <main+0xda>
    wait(0);
     ac0:	4501                	li	a0,0
     ac2:	00000097          	auipc	ra,0x0
     ac6:	31c080e7          	jalr	796(ra) # dde <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aca:	06400593          	li	a1,100
     ace:	8526                	mv	a0,s1
     ad0:	fffff097          	auipc	ra,0xfffff
     ad4:	530080e7          	jalr	1328(ra) # 0 <getcmd>
     ad8:	08054463          	bltz	a0,b60 <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     adc:	0004c783          	lbu	a5,0(s1)
     ae0:	fd279be3          	bne	a5,s2,ab6 <main+0x48>
     ae4:	0014c703          	lbu	a4,1(s1)
     ae8:	06400793          	li	a5,100
     aec:	fcf715e3          	bne	a4,a5,ab6 <main+0x48>
     af0:	0024c783          	lbu	a5,2(s1)
     af4:	fd3791e3          	bne	a5,s3,ab6 <main+0x48>
      buf[strlen(buf)-1] = 0;  // chop \n
     af8:	00001a17          	auipc	s4,0x1
     afc:	9d0a0a13          	addi	s4,s4,-1584 # 14c8 <buf.0>
     b00:	8552                	mv	a0,s4
     b02:	00000097          	auipc	ra,0x0
     b06:	0b0080e7          	jalr	176(ra) # bb2 <strlen>
     b0a:	fff5079b          	addiw	a5,a0,-1
     b0e:	1782                	slli	a5,a5,0x20
     b10:	9381                	srli	a5,a5,0x20
     b12:	9a3e                	add	s4,s4,a5
     b14:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     b18:	00001517          	auipc	a0,0x1
     b1c:	9b350513          	addi	a0,a0,-1613 # 14cb <buf.0+0x3>
     b20:	00000097          	auipc	ra,0x0
     b24:	326080e7          	jalr	806(ra) # e46 <chdir>
     b28:	fa0551e3          	bgez	a0,aca <main+0x5c>
        fprintf(2, "cannot cd %s\n", buf+3);
     b2c:	00001617          	auipc	a2,0x1
     b30:	99f60613          	addi	a2,a2,-1633 # 14cb <buf.0+0x3>
     b34:	00001597          	auipc	a1,0x1
     b38:	8c458593          	addi	a1,a1,-1852 # 13f8 <malloc+0x202>
     b3c:	4509                	li	a0,2
     b3e:	00000097          	auipc	ra,0x0
     b42:	5d2080e7          	jalr	1490(ra) # 1110 <fprintf>
     b46:	b751                	j	aca <main+0x5c>
      runcmd(parsecmd(buf));
     b48:	00001517          	auipc	a0,0x1
     b4c:	98050513          	addi	a0,a0,-1664 # 14c8 <buf.0>
     b50:	00000097          	auipc	ra,0x0
     b54:	e96080e7          	jalr	-362(ra) # 9e6 <parsecmd>
     b58:	fffff097          	auipc	ra,0xfffff
     b5c:	552080e7          	jalr	1362(ra) # aa <runcmd>
  exit(0);
     b60:	4501                	li	a0,0
     b62:	00000097          	auipc	ra,0x0
     b66:	274080e7          	jalr	628(ra) # dd6 <exit>

0000000000000b6a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     b6a:	1141                	addi	sp,sp,-16
     b6c:	e422                	sd	s0,8(sp)
     b6e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b70:	87aa                	mv	a5,a0
     b72:	0585                	addi	a1,a1,1
     b74:	0785                	addi	a5,a5,1
     b76:	fff5c703          	lbu	a4,-1(a1)
     b7a:	fee78fa3          	sb	a4,-1(a5)
     b7e:	fb75                	bnez	a4,b72 <strcpy+0x8>
    ;
  return os;
}
     b80:	6422                	ld	s0,8(sp)
     b82:	0141                	addi	sp,sp,16
     b84:	8082                	ret

0000000000000b86 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b86:	1141                	addi	sp,sp,-16
     b88:	e422                	sd	s0,8(sp)
     b8a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     b8c:	00054783          	lbu	a5,0(a0)
     b90:	cb91                	beqz	a5,ba4 <strcmp+0x1e>
     b92:	0005c703          	lbu	a4,0(a1)
     b96:	00f71763          	bne	a4,a5,ba4 <strcmp+0x1e>
    p++, q++;
     b9a:	0505                	addi	a0,a0,1
     b9c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     b9e:	00054783          	lbu	a5,0(a0)
     ba2:	fbe5                	bnez	a5,b92 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     ba4:	0005c503          	lbu	a0,0(a1)
}
     ba8:	40a7853b          	subw	a0,a5,a0
     bac:	6422                	ld	s0,8(sp)
     bae:	0141                	addi	sp,sp,16
     bb0:	8082                	ret

0000000000000bb2 <strlen>:

uint
strlen(const char *s)
{
     bb2:	1141                	addi	sp,sp,-16
     bb4:	e422                	sd	s0,8(sp)
     bb6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bb8:	00054783          	lbu	a5,0(a0)
     bbc:	cf91                	beqz	a5,bd8 <strlen+0x26>
     bbe:	0505                	addi	a0,a0,1
     bc0:	87aa                	mv	a5,a0
     bc2:	86be                	mv	a3,a5
     bc4:	0785                	addi	a5,a5,1
     bc6:	fff7c703          	lbu	a4,-1(a5)
     bca:	ff65                	bnez	a4,bc2 <strlen+0x10>
     bcc:	40a6853b          	subw	a0,a3,a0
     bd0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     bd2:	6422                	ld	s0,8(sp)
     bd4:	0141                	addi	sp,sp,16
     bd6:	8082                	ret
  for(n = 0; s[n]; n++)
     bd8:	4501                	li	a0,0
     bda:	bfe5                	j	bd2 <strlen+0x20>

0000000000000bdc <memset>:

void*
memset(void *dst, int c, uint n)
{
     bdc:	1141                	addi	sp,sp,-16
     bde:	e422                	sd	s0,8(sp)
     be0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     be2:	ca19                	beqz	a2,bf8 <memset+0x1c>
     be4:	87aa                	mv	a5,a0
     be6:	1602                	slli	a2,a2,0x20
     be8:	9201                	srli	a2,a2,0x20
     bea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     bee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     bf2:	0785                	addi	a5,a5,1
     bf4:	fee79de3          	bne	a5,a4,bee <memset+0x12>
  }
  return dst;
}
     bf8:	6422                	ld	s0,8(sp)
     bfa:	0141                	addi	sp,sp,16
     bfc:	8082                	ret

0000000000000bfe <strchr>:

char*
strchr(const char *s, char c)
{
     bfe:	1141                	addi	sp,sp,-16
     c00:	e422                	sd	s0,8(sp)
     c02:	0800                	addi	s0,sp,16
  for(; *s; s++)
     c04:	00054783          	lbu	a5,0(a0)
     c08:	cb99                	beqz	a5,c1e <strchr+0x20>
    if(*s == c)
     c0a:	00f58763          	beq	a1,a5,c18 <strchr+0x1a>
  for(; *s; s++)
     c0e:	0505                	addi	a0,a0,1
     c10:	00054783          	lbu	a5,0(a0)
     c14:	fbfd                	bnez	a5,c0a <strchr+0xc>
      return (char*)s;
  return 0;
     c16:	4501                	li	a0,0
}
     c18:	6422                	ld	s0,8(sp)
     c1a:	0141                	addi	sp,sp,16
     c1c:	8082                	ret
  return 0;
     c1e:	4501                	li	a0,0
     c20:	bfe5                	j	c18 <strchr+0x1a>

0000000000000c22 <gets>:

char*
gets(char *buf, int max)
{
     c22:	711d                	addi	sp,sp,-96
     c24:	ec86                	sd	ra,88(sp)
     c26:	e8a2                	sd	s0,80(sp)
     c28:	e4a6                	sd	s1,72(sp)
     c2a:	e0ca                	sd	s2,64(sp)
     c2c:	fc4e                	sd	s3,56(sp)
     c2e:	f852                	sd	s4,48(sp)
     c30:	f456                	sd	s5,40(sp)
     c32:	f05a                	sd	s6,32(sp)
     c34:	ec5e                	sd	s7,24(sp)
     c36:	1080                	addi	s0,sp,96
     c38:	8baa                	mv	s7,a0
     c3a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c3c:	892a                	mv	s2,a0
     c3e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c40:	4aa9                	li	s5,10
     c42:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c44:	89a6                	mv	s3,s1
     c46:	2485                	addiw	s1,s1,1
     c48:	0344d863          	bge	s1,s4,c78 <gets+0x56>
    cc = read(0, &c, 1);
     c4c:	4605                	li	a2,1
     c4e:	faf40593          	addi	a1,s0,-81
     c52:	4501                	li	a0,0
     c54:	00000097          	auipc	ra,0x0
     c58:	19a080e7          	jalr	410(ra) # dee <read>
    if(cc < 1)
     c5c:	00a05e63          	blez	a0,c78 <gets+0x56>
    buf[i++] = c;
     c60:	faf44783          	lbu	a5,-81(s0)
     c64:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c68:	01578763          	beq	a5,s5,c76 <gets+0x54>
     c6c:	0905                	addi	s2,s2,1
     c6e:	fd679be3          	bne	a5,s6,c44 <gets+0x22>
    buf[i++] = c;
     c72:	89a6                	mv	s3,s1
     c74:	a011                	j	c78 <gets+0x56>
     c76:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c78:	99de                	add	s3,s3,s7
     c7a:	00098023          	sb	zero,0(s3)
  return buf;
}
     c7e:	855e                	mv	a0,s7
     c80:	60e6                	ld	ra,88(sp)
     c82:	6446                	ld	s0,80(sp)
     c84:	64a6                	ld	s1,72(sp)
     c86:	6906                	ld	s2,64(sp)
     c88:	79e2                	ld	s3,56(sp)
     c8a:	7a42                	ld	s4,48(sp)
     c8c:	7aa2                	ld	s5,40(sp)
     c8e:	7b02                	ld	s6,32(sp)
     c90:	6be2                	ld	s7,24(sp)
     c92:	6125                	addi	sp,sp,96
     c94:	8082                	ret

0000000000000c96 <stat>:

int
stat(const char *n, struct stat *st)
{
     c96:	1101                	addi	sp,sp,-32
     c98:	ec06                	sd	ra,24(sp)
     c9a:	e822                	sd	s0,16(sp)
     c9c:	e04a                	sd	s2,0(sp)
     c9e:	1000                	addi	s0,sp,32
     ca0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ca2:	4581                	li	a1,0
     ca4:	00000097          	auipc	ra,0x0
     ca8:	172080e7          	jalr	370(ra) # e16 <open>
  if(fd < 0)
     cac:	02054663          	bltz	a0,cd8 <stat+0x42>
     cb0:	e426                	sd	s1,8(sp)
     cb2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cb4:	85ca                	mv	a1,s2
     cb6:	00000097          	auipc	ra,0x0
     cba:	178080e7          	jalr	376(ra) # e2e <fstat>
     cbe:	892a                	mv	s2,a0
  close(fd);
     cc0:	8526                	mv	a0,s1
     cc2:	00000097          	auipc	ra,0x0
     cc6:	13c080e7          	jalr	316(ra) # dfe <close>
  return r;
     cca:	64a2                	ld	s1,8(sp)
}
     ccc:	854a                	mv	a0,s2
     cce:	60e2                	ld	ra,24(sp)
     cd0:	6442                	ld	s0,16(sp)
     cd2:	6902                	ld	s2,0(sp)
     cd4:	6105                	addi	sp,sp,32
     cd6:	8082                	ret
    return -1;
     cd8:	597d                	li	s2,-1
     cda:	bfcd                	j	ccc <stat+0x36>

0000000000000cdc <atoi>:

int
atoi(const char *s)
{
     cdc:	1141                	addi	sp,sp,-16
     cde:	e422                	sd	s0,8(sp)
     ce0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ce2:	00054683          	lbu	a3,0(a0)
     ce6:	fd06879b          	addiw	a5,a3,-48
     cea:	0ff7f793          	zext.b	a5,a5
     cee:	4625                	li	a2,9
     cf0:	02f66863          	bltu	a2,a5,d20 <atoi+0x44>
     cf4:	872a                	mv	a4,a0
  n = 0;
     cf6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     cf8:	0705                	addi	a4,a4,1
     cfa:	0025179b          	slliw	a5,a0,0x2
     cfe:	9fa9                	addw	a5,a5,a0
     d00:	0017979b          	slliw	a5,a5,0x1
     d04:	9fb5                	addw	a5,a5,a3
     d06:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     d0a:	00074683          	lbu	a3,0(a4)
     d0e:	fd06879b          	addiw	a5,a3,-48
     d12:	0ff7f793          	zext.b	a5,a5
     d16:	fef671e3          	bgeu	a2,a5,cf8 <atoi+0x1c>
  return n;
}
     d1a:	6422                	ld	s0,8(sp)
     d1c:	0141                	addi	sp,sp,16
     d1e:	8082                	ret
  n = 0;
     d20:	4501                	li	a0,0
     d22:	bfe5                	j	d1a <atoi+0x3e>

0000000000000d24 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d24:	1141                	addi	sp,sp,-16
     d26:	e422                	sd	s0,8(sp)
     d28:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d2a:	02b57463          	bgeu	a0,a1,d52 <memmove+0x2e>
    while(n-- > 0)
     d2e:	00c05f63          	blez	a2,d4c <memmove+0x28>
     d32:	1602                	slli	a2,a2,0x20
     d34:	9201                	srli	a2,a2,0x20
     d36:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d3a:	872a                	mv	a4,a0
      *dst++ = *src++;
     d3c:	0585                	addi	a1,a1,1
     d3e:	0705                	addi	a4,a4,1
     d40:	fff5c683          	lbu	a3,-1(a1)
     d44:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d48:	fef71ae3          	bne	a4,a5,d3c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d4c:	6422                	ld	s0,8(sp)
     d4e:	0141                	addi	sp,sp,16
     d50:	8082                	ret
    dst += n;
     d52:	00c50733          	add	a4,a0,a2
    src += n;
     d56:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d58:	fec05ae3          	blez	a2,d4c <memmove+0x28>
     d5c:	fff6079b          	addiw	a5,a2,-1
     d60:	1782                	slli	a5,a5,0x20
     d62:	9381                	srli	a5,a5,0x20
     d64:	fff7c793          	not	a5,a5
     d68:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d6a:	15fd                	addi	a1,a1,-1
     d6c:	177d                	addi	a4,a4,-1
     d6e:	0005c683          	lbu	a3,0(a1)
     d72:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     d76:	fee79ae3          	bne	a5,a4,d6a <memmove+0x46>
     d7a:	bfc9                	j	d4c <memmove+0x28>

0000000000000d7c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     d7c:	1141                	addi	sp,sp,-16
     d7e:	e422                	sd	s0,8(sp)
     d80:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     d82:	ca05                	beqz	a2,db2 <memcmp+0x36>
     d84:	fff6069b          	addiw	a3,a2,-1
     d88:	1682                	slli	a3,a3,0x20
     d8a:	9281                	srli	a3,a3,0x20
     d8c:	0685                	addi	a3,a3,1
     d8e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     d90:	00054783          	lbu	a5,0(a0)
     d94:	0005c703          	lbu	a4,0(a1)
     d98:	00e79863          	bne	a5,a4,da8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     d9c:	0505                	addi	a0,a0,1
    p2++;
     d9e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     da0:	fed518e3          	bne	a0,a3,d90 <memcmp+0x14>
  }
  return 0;
     da4:	4501                	li	a0,0
     da6:	a019                	j	dac <memcmp+0x30>
      return *p1 - *p2;
     da8:	40e7853b          	subw	a0,a5,a4
}
     dac:	6422                	ld	s0,8(sp)
     dae:	0141                	addi	sp,sp,16
     db0:	8082                	ret
  return 0;
     db2:	4501                	li	a0,0
     db4:	bfe5                	j	dac <memcmp+0x30>

0000000000000db6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     db6:	1141                	addi	sp,sp,-16
     db8:	e406                	sd	ra,8(sp)
     dba:	e022                	sd	s0,0(sp)
     dbc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     dbe:	00000097          	auipc	ra,0x0
     dc2:	f66080e7          	jalr	-154(ra) # d24 <memmove>
}
     dc6:	60a2                	ld	ra,8(sp)
     dc8:	6402                	ld	s0,0(sp)
     dca:	0141                	addi	sp,sp,16
     dcc:	8082                	ret

0000000000000dce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     dce:	4885                	li	a7,1
 ecall
     dd0:	00000073          	ecall
 ret
     dd4:	8082                	ret

0000000000000dd6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     dd6:	4889                	li	a7,2
 ecall
     dd8:	00000073          	ecall
 ret
     ddc:	8082                	ret

0000000000000dde <wait>:
.global wait
wait:
 li a7, SYS_wait
     dde:	488d                	li	a7,3
 ecall
     de0:	00000073          	ecall
 ret
     de4:	8082                	ret

0000000000000de6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     de6:	4891                	li	a7,4
 ecall
     de8:	00000073          	ecall
 ret
     dec:	8082                	ret

0000000000000dee <read>:
.global read
read:
 li a7, SYS_read
     dee:	4895                	li	a7,5
 ecall
     df0:	00000073          	ecall
 ret
     df4:	8082                	ret

0000000000000df6 <write>:
.global write
write:
 li a7, SYS_write
     df6:	48c1                	li	a7,16
 ecall
     df8:	00000073          	ecall
 ret
     dfc:	8082                	ret

0000000000000dfe <close>:
.global close
close:
 li a7, SYS_close
     dfe:	48d5                	li	a7,21
 ecall
     e00:	00000073          	ecall
 ret
     e04:	8082                	ret

0000000000000e06 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e06:	4899                	li	a7,6
 ecall
     e08:	00000073          	ecall
 ret
     e0c:	8082                	ret

0000000000000e0e <exec>:
.global exec
exec:
 li a7, SYS_exec
     e0e:	489d                	li	a7,7
 ecall
     e10:	00000073          	ecall
 ret
     e14:	8082                	ret

0000000000000e16 <open>:
.global open
open:
 li a7, SYS_open
     e16:	48bd                	li	a7,15
 ecall
     e18:	00000073          	ecall
 ret
     e1c:	8082                	ret

0000000000000e1e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e1e:	48c5                	li	a7,17
 ecall
     e20:	00000073          	ecall
 ret
     e24:	8082                	ret

0000000000000e26 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e26:	48c9                	li	a7,18
 ecall
     e28:	00000073          	ecall
 ret
     e2c:	8082                	ret

0000000000000e2e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e2e:	48a1                	li	a7,8
 ecall
     e30:	00000073          	ecall
 ret
     e34:	8082                	ret

0000000000000e36 <link>:
.global link
link:
 li a7, SYS_link
     e36:	48cd                	li	a7,19
 ecall
     e38:	00000073          	ecall
 ret
     e3c:	8082                	ret

0000000000000e3e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e3e:	48d1                	li	a7,20
 ecall
     e40:	00000073          	ecall
 ret
     e44:	8082                	ret

0000000000000e46 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e46:	48a5                	li	a7,9
 ecall
     e48:	00000073          	ecall
 ret
     e4c:	8082                	ret

0000000000000e4e <dup>:
.global dup
dup:
 li a7, SYS_dup
     e4e:	48a9                	li	a7,10
 ecall
     e50:	00000073          	ecall
 ret
     e54:	8082                	ret

0000000000000e56 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e56:	48ad                	li	a7,11
 ecall
     e58:	00000073          	ecall
 ret
     e5c:	8082                	ret

0000000000000e5e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e5e:	48b1                	li	a7,12
 ecall
     e60:	00000073          	ecall
 ret
     e64:	8082                	ret

0000000000000e66 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e66:	48b5                	li	a7,13
 ecall
     e68:	00000073          	ecall
 ret
     e6c:	8082                	ret

0000000000000e6e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     e6e:	48b9                	li	a7,14
 ecall
     e70:	00000073          	ecall
 ret
     e74:	8082                	ret

0000000000000e76 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     e76:	1101                	addi	sp,sp,-32
     e78:	ec06                	sd	ra,24(sp)
     e7a:	e822                	sd	s0,16(sp)
     e7c:	1000                	addi	s0,sp,32
     e7e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     e82:	4605                	li	a2,1
     e84:	fef40593          	addi	a1,s0,-17
     e88:	00000097          	auipc	ra,0x0
     e8c:	f6e080e7          	jalr	-146(ra) # df6 <write>
}
     e90:	60e2                	ld	ra,24(sp)
     e92:	6442                	ld	s0,16(sp)
     e94:	6105                	addi	sp,sp,32
     e96:	8082                	ret

0000000000000e98 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e98:	7139                	addi	sp,sp,-64
     e9a:	fc06                	sd	ra,56(sp)
     e9c:	f822                	sd	s0,48(sp)
     e9e:	f426                	sd	s1,40(sp)
     ea0:	0080                	addi	s0,sp,64
     ea2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ea4:	c299                	beqz	a3,eaa <printint+0x12>
     ea6:	0805cb63          	bltz	a1,f3c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     eaa:	2581                	sext.w	a1,a1
  neg = 0;
     eac:	4881                	li	a7,0
     eae:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     eb2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     eb4:	2601                	sext.w	a2,a2
     eb6:	00000517          	auipc	a0,0x0
     eba:	5e250513          	addi	a0,a0,1506 # 1498 <digits>
     ebe:	883a                	mv	a6,a4
     ec0:	2705                	addiw	a4,a4,1
     ec2:	02c5f7bb          	remuw	a5,a1,a2
     ec6:	1782                	slli	a5,a5,0x20
     ec8:	9381                	srli	a5,a5,0x20
     eca:	97aa                	add	a5,a5,a0
     ecc:	0007c783          	lbu	a5,0(a5)
     ed0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ed4:	0005879b          	sext.w	a5,a1
     ed8:	02c5d5bb          	divuw	a1,a1,a2
     edc:	0685                	addi	a3,a3,1
     ede:	fec7f0e3          	bgeu	a5,a2,ebe <printint+0x26>
  if(neg)
     ee2:	00088c63          	beqz	a7,efa <printint+0x62>
    buf[i++] = '-';
     ee6:	fd070793          	addi	a5,a4,-48
     eea:	00878733          	add	a4,a5,s0
     eee:	02d00793          	li	a5,45
     ef2:	fef70823          	sb	a5,-16(a4)
     ef6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     efa:	02e05c63          	blez	a4,f32 <printint+0x9a>
     efe:	f04a                	sd	s2,32(sp)
     f00:	ec4e                	sd	s3,24(sp)
     f02:	fc040793          	addi	a5,s0,-64
     f06:	00e78933          	add	s2,a5,a4
     f0a:	fff78993          	addi	s3,a5,-1
     f0e:	99ba                	add	s3,s3,a4
     f10:	377d                	addiw	a4,a4,-1
     f12:	1702                	slli	a4,a4,0x20
     f14:	9301                	srli	a4,a4,0x20
     f16:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f1a:	fff94583          	lbu	a1,-1(s2)
     f1e:	8526                	mv	a0,s1
     f20:	00000097          	auipc	ra,0x0
     f24:	f56080e7          	jalr	-170(ra) # e76 <putc>
  while(--i >= 0)
     f28:	197d                	addi	s2,s2,-1
     f2a:	ff3918e3          	bne	s2,s3,f1a <printint+0x82>
     f2e:	7902                	ld	s2,32(sp)
     f30:	69e2                	ld	s3,24(sp)
}
     f32:	70e2                	ld	ra,56(sp)
     f34:	7442                	ld	s0,48(sp)
     f36:	74a2                	ld	s1,40(sp)
     f38:	6121                	addi	sp,sp,64
     f3a:	8082                	ret
    x = -xx;
     f3c:	40b005bb          	negw	a1,a1
    neg = 1;
     f40:	4885                	li	a7,1
    x = -xx;
     f42:	b7b5                	j	eae <printint+0x16>

0000000000000f44 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f44:	715d                	addi	sp,sp,-80
     f46:	e486                	sd	ra,72(sp)
     f48:	e0a2                	sd	s0,64(sp)
     f4a:	f84a                	sd	s2,48(sp)
     f4c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     f4e:	0005c903          	lbu	s2,0(a1)
     f52:	1a090a63          	beqz	s2,1106 <vprintf+0x1c2>
     f56:	fc26                	sd	s1,56(sp)
     f58:	f44e                	sd	s3,40(sp)
     f5a:	f052                	sd	s4,32(sp)
     f5c:	ec56                	sd	s5,24(sp)
     f5e:	e85a                	sd	s6,16(sp)
     f60:	e45e                	sd	s7,8(sp)
     f62:	8aaa                	mv	s5,a0
     f64:	8bb2                	mv	s7,a2
     f66:	00158493          	addi	s1,a1,1
  state = 0;
     f6a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     f6c:	02500a13          	li	s4,37
     f70:	4b55                	li	s6,21
     f72:	a839                	j	f90 <vprintf+0x4c>
        putc(fd, c);
     f74:	85ca                	mv	a1,s2
     f76:	8556                	mv	a0,s5
     f78:	00000097          	auipc	ra,0x0
     f7c:	efe080e7          	jalr	-258(ra) # e76 <putc>
     f80:	a019                	j	f86 <vprintf+0x42>
    } else if(state == '%'){
     f82:	01498d63          	beq	s3,s4,f9c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     f86:	0485                	addi	s1,s1,1
     f88:	fff4c903          	lbu	s2,-1(s1)
     f8c:	16090763          	beqz	s2,10fa <vprintf+0x1b6>
    if(state == 0){
     f90:	fe0999e3          	bnez	s3,f82 <vprintf+0x3e>
      if(c == '%'){
     f94:	ff4910e3          	bne	s2,s4,f74 <vprintf+0x30>
        state = '%';
     f98:	89d2                	mv	s3,s4
     f9a:	b7f5                	j	f86 <vprintf+0x42>
      if(c == 'd'){
     f9c:	13490463          	beq	s2,s4,10c4 <vprintf+0x180>
     fa0:	f9d9079b          	addiw	a5,s2,-99
     fa4:	0ff7f793          	zext.b	a5,a5
     fa8:	12fb6763          	bltu	s6,a5,10d6 <vprintf+0x192>
     fac:	f9d9079b          	addiw	a5,s2,-99
     fb0:	0ff7f713          	zext.b	a4,a5
     fb4:	12eb6163          	bltu	s6,a4,10d6 <vprintf+0x192>
     fb8:	00271793          	slli	a5,a4,0x2
     fbc:	00000717          	auipc	a4,0x0
     fc0:	48470713          	addi	a4,a4,1156 # 1440 <malloc+0x24a>
     fc4:	97ba                	add	a5,a5,a4
     fc6:	439c                	lw	a5,0(a5)
     fc8:	97ba                	add	a5,a5,a4
     fca:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     fcc:	008b8913          	addi	s2,s7,8
     fd0:	4685                	li	a3,1
     fd2:	4629                	li	a2,10
     fd4:	000ba583          	lw	a1,0(s7)
     fd8:	8556                	mv	a0,s5
     fda:	00000097          	auipc	ra,0x0
     fde:	ebe080e7          	jalr	-322(ra) # e98 <printint>
     fe2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     fe4:	4981                	li	s3,0
     fe6:	b745                	j	f86 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     fe8:	008b8913          	addi	s2,s7,8
     fec:	4681                	li	a3,0
     fee:	4629                	li	a2,10
     ff0:	000ba583          	lw	a1,0(s7)
     ff4:	8556                	mv	a0,s5
     ff6:	00000097          	auipc	ra,0x0
     ffa:	ea2080e7          	jalr	-350(ra) # e98 <printint>
     ffe:	8bca                	mv	s7,s2
      state = 0;
    1000:	4981                	li	s3,0
    1002:	b751                	j	f86 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1004:	008b8913          	addi	s2,s7,8
    1008:	4681                	li	a3,0
    100a:	4641                	li	a2,16
    100c:	000ba583          	lw	a1,0(s7)
    1010:	8556                	mv	a0,s5
    1012:	00000097          	auipc	ra,0x0
    1016:	e86080e7          	jalr	-378(ra) # e98 <printint>
    101a:	8bca                	mv	s7,s2
      state = 0;
    101c:	4981                	li	s3,0
    101e:	b7a5                	j	f86 <vprintf+0x42>
    1020:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1022:	008b8c13          	addi	s8,s7,8
    1026:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    102a:	03000593          	li	a1,48
    102e:	8556                	mv	a0,s5
    1030:	00000097          	auipc	ra,0x0
    1034:	e46080e7          	jalr	-442(ra) # e76 <putc>
  putc(fd, 'x');
    1038:	07800593          	li	a1,120
    103c:	8556                	mv	a0,s5
    103e:	00000097          	auipc	ra,0x0
    1042:	e38080e7          	jalr	-456(ra) # e76 <putc>
    1046:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1048:	00000b97          	auipc	s7,0x0
    104c:	450b8b93          	addi	s7,s7,1104 # 1498 <digits>
    1050:	03c9d793          	srli	a5,s3,0x3c
    1054:	97de                	add	a5,a5,s7
    1056:	0007c583          	lbu	a1,0(a5)
    105a:	8556                	mv	a0,s5
    105c:	00000097          	auipc	ra,0x0
    1060:	e1a080e7          	jalr	-486(ra) # e76 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1064:	0992                	slli	s3,s3,0x4
    1066:	397d                	addiw	s2,s2,-1
    1068:	fe0914e3          	bnez	s2,1050 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    106c:	8be2                	mv	s7,s8
      state = 0;
    106e:	4981                	li	s3,0
    1070:	6c02                	ld	s8,0(sp)
    1072:	bf11                	j	f86 <vprintf+0x42>
        s = va_arg(ap, char*);
    1074:	008b8993          	addi	s3,s7,8
    1078:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    107c:	02090163          	beqz	s2,109e <vprintf+0x15a>
        while(*s != 0){
    1080:	00094583          	lbu	a1,0(s2)
    1084:	c9a5                	beqz	a1,10f4 <vprintf+0x1b0>
          putc(fd, *s);
    1086:	8556                	mv	a0,s5
    1088:	00000097          	auipc	ra,0x0
    108c:	dee080e7          	jalr	-530(ra) # e76 <putc>
          s++;
    1090:	0905                	addi	s2,s2,1
        while(*s != 0){
    1092:	00094583          	lbu	a1,0(s2)
    1096:	f9e5                	bnez	a1,1086 <vprintf+0x142>
        s = va_arg(ap, char*);
    1098:	8bce                	mv	s7,s3
      state = 0;
    109a:	4981                	li	s3,0
    109c:	b5ed                	j	f86 <vprintf+0x42>
          s = "(null)";
    109e:	00000917          	auipc	s2,0x0
    10a2:	36a90913          	addi	s2,s2,874 # 1408 <malloc+0x212>
        while(*s != 0){
    10a6:	02800593          	li	a1,40
    10aa:	bff1                	j	1086 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    10ac:	008b8913          	addi	s2,s7,8
    10b0:	000bc583          	lbu	a1,0(s7)
    10b4:	8556                	mv	a0,s5
    10b6:	00000097          	auipc	ra,0x0
    10ba:	dc0080e7          	jalr	-576(ra) # e76 <putc>
    10be:	8bca                	mv	s7,s2
      state = 0;
    10c0:	4981                	li	s3,0
    10c2:	b5d1                	j	f86 <vprintf+0x42>
        putc(fd, c);
    10c4:	02500593          	li	a1,37
    10c8:	8556                	mv	a0,s5
    10ca:	00000097          	auipc	ra,0x0
    10ce:	dac080e7          	jalr	-596(ra) # e76 <putc>
      state = 0;
    10d2:	4981                	li	s3,0
    10d4:	bd4d                	j	f86 <vprintf+0x42>
        putc(fd, '%');
    10d6:	02500593          	li	a1,37
    10da:	8556                	mv	a0,s5
    10dc:	00000097          	auipc	ra,0x0
    10e0:	d9a080e7          	jalr	-614(ra) # e76 <putc>
        putc(fd, c);
    10e4:	85ca                	mv	a1,s2
    10e6:	8556                	mv	a0,s5
    10e8:	00000097          	auipc	ra,0x0
    10ec:	d8e080e7          	jalr	-626(ra) # e76 <putc>
      state = 0;
    10f0:	4981                	li	s3,0
    10f2:	bd51                	j	f86 <vprintf+0x42>
        s = va_arg(ap, char*);
    10f4:	8bce                	mv	s7,s3
      state = 0;
    10f6:	4981                	li	s3,0
    10f8:	b579                	j	f86 <vprintf+0x42>
    10fa:	74e2                	ld	s1,56(sp)
    10fc:	79a2                	ld	s3,40(sp)
    10fe:	7a02                	ld	s4,32(sp)
    1100:	6ae2                	ld	s5,24(sp)
    1102:	6b42                	ld	s6,16(sp)
    1104:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1106:	60a6                	ld	ra,72(sp)
    1108:	6406                	ld	s0,64(sp)
    110a:	7942                	ld	s2,48(sp)
    110c:	6161                	addi	sp,sp,80
    110e:	8082                	ret

0000000000001110 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1110:	715d                	addi	sp,sp,-80
    1112:	ec06                	sd	ra,24(sp)
    1114:	e822                	sd	s0,16(sp)
    1116:	1000                	addi	s0,sp,32
    1118:	e010                	sd	a2,0(s0)
    111a:	e414                	sd	a3,8(s0)
    111c:	e818                	sd	a4,16(s0)
    111e:	ec1c                	sd	a5,24(s0)
    1120:	03043023          	sd	a6,32(s0)
    1124:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1128:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    112c:	8622                	mv	a2,s0
    112e:	00000097          	auipc	ra,0x0
    1132:	e16080e7          	jalr	-490(ra) # f44 <vprintf>
}
    1136:	60e2                	ld	ra,24(sp)
    1138:	6442                	ld	s0,16(sp)
    113a:	6161                	addi	sp,sp,80
    113c:	8082                	ret

000000000000113e <printf>:

void
printf(const char *fmt, ...)
{
    113e:	711d                	addi	sp,sp,-96
    1140:	ec06                	sd	ra,24(sp)
    1142:	e822                	sd	s0,16(sp)
    1144:	1000                	addi	s0,sp,32
    1146:	e40c                	sd	a1,8(s0)
    1148:	e810                	sd	a2,16(s0)
    114a:	ec14                	sd	a3,24(s0)
    114c:	f018                	sd	a4,32(s0)
    114e:	f41c                	sd	a5,40(s0)
    1150:	03043823          	sd	a6,48(s0)
    1154:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1158:	00840613          	addi	a2,s0,8
    115c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1160:	85aa                	mv	a1,a0
    1162:	4505                	li	a0,1
    1164:	00000097          	auipc	ra,0x0
    1168:	de0080e7          	jalr	-544(ra) # f44 <vprintf>
}
    116c:	60e2                	ld	ra,24(sp)
    116e:	6442                	ld	s0,16(sp)
    1170:	6125                	addi	sp,sp,96
    1172:	8082                	ret

0000000000001174 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1174:	1141                	addi	sp,sp,-16
    1176:	e422                	sd	s0,8(sp)
    1178:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    117a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    117e:	00000797          	auipc	a5,0x0
    1182:	3427b783          	ld	a5,834(a5) # 14c0 <freep>
    1186:	a02d                	j	11b0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1188:	4618                	lw	a4,8(a2)
    118a:	9f2d                	addw	a4,a4,a1
    118c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1190:	6398                	ld	a4,0(a5)
    1192:	6310                	ld	a2,0(a4)
    1194:	a83d                	j	11d2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1196:	ff852703          	lw	a4,-8(a0)
    119a:	9f31                	addw	a4,a4,a2
    119c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    119e:	ff053683          	ld	a3,-16(a0)
    11a2:	a091                	j	11e6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11a4:	6398                	ld	a4,0(a5)
    11a6:	00e7e463          	bltu	a5,a4,11ae <free+0x3a>
    11aa:	00e6ea63          	bltu	a3,a4,11be <free+0x4a>
{
    11ae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11b0:	fed7fae3          	bgeu	a5,a3,11a4 <free+0x30>
    11b4:	6398                	ld	a4,0(a5)
    11b6:	00e6e463          	bltu	a3,a4,11be <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11ba:	fee7eae3          	bltu	a5,a4,11ae <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    11be:	ff852583          	lw	a1,-8(a0)
    11c2:	6390                	ld	a2,0(a5)
    11c4:	02059813          	slli	a6,a1,0x20
    11c8:	01c85713          	srli	a4,a6,0x1c
    11cc:	9736                	add	a4,a4,a3
    11ce:	fae60de3          	beq	a2,a4,1188 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    11d2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    11d6:	4790                	lw	a2,8(a5)
    11d8:	02061593          	slli	a1,a2,0x20
    11dc:	01c5d713          	srli	a4,a1,0x1c
    11e0:	973e                	add	a4,a4,a5
    11e2:	fae68ae3          	beq	a3,a4,1196 <free+0x22>
    p->s.ptr = bp->s.ptr;
    11e6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    11e8:	00000717          	auipc	a4,0x0
    11ec:	2cf73c23          	sd	a5,728(a4) # 14c0 <freep>
}
    11f0:	6422                	ld	s0,8(sp)
    11f2:	0141                	addi	sp,sp,16
    11f4:	8082                	ret

00000000000011f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11f6:	7139                	addi	sp,sp,-64
    11f8:	fc06                	sd	ra,56(sp)
    11fa:	f822                	sd	s0,48(sp)
    11fc:	f426                	sd	s1,40(sp)
    11fe:	ec4e                	sd	s3,24(sp)
    1200:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1202:	02051493          	slli	s1,a0,0x20
    1206:	9081                	srli	s1,s1,0x20
    1208:	04bd                	addi	s1,s1,15
    120a:	8091                	srli	s1,s1,0x4
    120c:	0014899b          	addiw	s3,s1,1
    1210:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1212:	00000517          	auipc	a0,0x0
    1216:	2ae53503          	ld	a0,686(a0) # 14c0 <freep>
    121a:	c915                	beqz	a0,124e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    121c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    121e:	4798                	lw	a4,8(a5)
    1220:	08977e63          	bgeu	a4,s1,12bc <malloc+0xc6>
    1224:	f04a                	sd	s2,32(sp)
    1226:	e852                	sd	s4,16(sp)
    1228:	e456                	sd	s5,8(sp)
    122a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    122c:	8a4e                	mv	s4,s3
    122e:	0009871b          	sext.w	a4,s3
    1232:	6685                	lui	a3,0x1
    1234:	00d77363          	bgeu	a4,a3,123a <malloc+0x44>
    1238:	6a05                	lui	s4,0x1
    123a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    123e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1242:	00000917          	auipc	s2,0x0
    1246:	27e90913          	addi	s2,s2,638 # 14c0 <freep>
  if(p == (char*)-1)
    124a:	5afd                	li	s5,-1
    124c:	a091                	j	1290 <malloc+0x9a>
    124e:	f04a                	sd	s2,32(sp)
    1250:	e852                	sd	s4,16(sp)
    1252:	e456                	sd	s5,8(sp)
    1254:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1256:	00000797          	auipc	a5,0x0
    125a:	2da78793          	addi	a5,a5,730 # 1530 <base>
    125e:	00000717          	auipc	a4,0x0
    1262:	26f73123          	sd	a5,610(a4) # 14c0 <freep>
    1266:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1268:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    126c:	b7c1                	j	122c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    126e:	6398                	ld	a4,0(a5)
    1270:	e118                	sd	a4,0(a0)
    1272:	a08d                	j	12d4 <malloc+0xde>
  hp->s.size = nu;
    1274:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1278:	0541                	addi	a0,a0,16
    127a:	00000097          	auipc	ra,0x0
    127e:	efa080e7          	jalr	-262(ra) # 1174 <free>
  return freep;
    1282:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1286:	c13d                	beqz	a0,12ec <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1288:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    128a:	4798                	lw	a4,8(a5)
    128c:	02977463          	bgeu	a4,s1,12b4 <malloc+0xbe>
    if(p == freep)
    1290:	00093703          	ld	a4,0(s2)
    1294:	853e                	mv	a0,a5
    1296:	fef719e3          	bne	a4,a5,1288 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    129a:	8552                	mv	a0,s4
    129c:	00000097          	auipc	ra,0x0
    12a0:	bc2080e7          	jalr	-1086(ra) # e5e <sbrk>
  if(p == (char*)-1)
    12a4:	fd5518e3          	bne	a0,s5,1274 <malloc+0x7e>
        return 0;
    12a8:	4501                	li	a0,0
    12aa:	7902                	ld	s2,32(sp)
    12ac:	6a42                	ld	s4,16(sp)
    12ae:	6aa2                	ld	s5,8(sp)
    12b0:	6b02                	ld	s6,0(sp)
    12b2:	a03d                	j	12e0 <malloc+0xea>
    12b4:	7902                	ld	s2,32(sp)
    12b6:	6a42                	ld	s4,16(sp)
    12b8:	6aa2                	ld	s5,8(sp)
    12ba:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    12bc:	fae489e3          	beq	s1,a4,126e <malloc+0x78>
        p->s.size -= nunits;
    12c0:	4137073b          	subw	a4,a4,s3
    12c4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    12c6:	02071693          	slli	a3,a4,0x20
    12ca:	01c6d713          	srli	a4,a3,0x1c
    12ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    12d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    12d4:	00000717          	auipc	a4,0x0
    12d8:	1ea73623          	sd	a0,492(a4) # 14c0 <freep>
      return (void*)(p + 1);
    12dc:	01078513          	addi	a0,a5,16
  }
}
    12e0:	70e2                	ld	ra,56(sp)
    12e2:	7442                	ld	s0,48(sp)
    12e4:	74a2                	ld	s1,40(sp)
    12e6:	69e2                	ld	s3,24(sp)
    12e8:	6121                	addi	sp,sp,64
    12ea:	8082                	ret
    12ec:	7902                	ld	s2,32(sp)
    12ee:	6a42                	ld	s4,16(sp)
    12f0:	6aa2                	ld	s5,8(sp)
    12f2:	6b02                	ld	s6,0(sp)
    12f4:	b7f5                	j	12e0 <malloc+0xea>
