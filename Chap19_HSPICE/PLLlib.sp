**
** Library of PLL components
** Based on examples from RJ Baker's CMOS book.
** Implemented in 50nm technology.
** 
** set .option scale=50n in main netlist.
**

**--------------------------------------
** AT-cut XTAL, series resonant at 25 MHz
**
.subckt  xtal in  out 
Co     in   out  4.4p
Rxtal  in   xc1  55.4  
Cm     xc1  xc2  3.1832f
Lm     xc2  out  12.738m
.ends

**--------------------------------------
** Oscillator Circuit (inverter + xtal)
** 
.subckt xtalosc  VDD out
Xinv   VDD   in    out     inverter
Xxtal  in    out   xtal
Rf     in    out   300k   
Cd     out   0     2.7p
Cg     in    0     4.5p    
.ends 

.subckt	dby2	VDD	clock	dclock
M1	n1	dclock	VDD	VDD	P_50n L=1 W=20
M2	n2	clock	n1	VDD	P_50n L=1 W=20
M3	n2	dclock	0	0	N_50n L=1 W=10
M4	n3	clock	VDD	VDD	P_50n L=1 W=20
M5	n4	n2	n3	0	N_50n L=1 W=10
M6	n4	clock	0	0	N_50n L=1 W=10
M7	dclock	n3	VDD	VDD	P_50n L=1 W=20
M8	dclock	clock	n5	0	N_50n L=1 W=10
M9	n5	n3	0	0	N_50n L=1 W=10
.ends


.subckt dby16   VDD     in      out
xd2     VDD     in      d2      dby2 
xd4     VDD     d2      d4      dby2 
xd8     VDD     d4      d8      dby2 
xd16    VDD     d8      out     dby2 
.ends 


.subckt VCO VDD Vinvco clock
M5	vn	Vn	0	0	N_50n L=1 W=10
M6	vn	vp	VDD	VDD	P_50n L=1 W=20
M5R	vp	Vinvco	Vr	0	N_50n L=1 W=100
Rset	Vr	0	10k
M6R	vp	vp	VDD	VDD	P_50n L=1 W=20
X1	VDD	Vn	Vp	out21	out1	VCOstage
X2	VDD	Vn	Vp	out1	out2	VCOstage
X3	VDD	Vn	Vp	out2	out3	VCOstage
X4	VDD	Vn	Vp	out3	out4	VCOstage
X5	VDD	Vn	Vp	out4	out5	VCOstage
X6	VDD	Vn	Vp	out5	out6	VCOstage
X7	VDD	Vn	Vp	out6	out7	VCOstage
X8	VDD	Vn	Vp	out7	out8	VCOstage
X9	VDD	Vn	Vp	out8	out9	VCOstage
X10	VDD	Vn	Vp	out9	out10	VCOstage
X11	VDD	Vn	Vp	out10	out11	VCOstage
X12	VDD	Vn	Vp	out11	out12	VCOstage
X13	VDD	Vn	Vp	out12	out13	VCOstage
X14	VDD	Vn	Vp	out13	out14	VCOstage
X15	VDD	Vn	Vp	out14	out15	VCOstage
X16	VDD	Vn	Vp	out15	out16	VCOstage
X17	VDD	Vn	Vp	out16	out17	VCOstage
X18	VDD	Vn	Vp	out17	out18	VCOstage
X19	VDD	Vn	Vp	out18	out19	VCOstage
X20	VDD	Vn	Vp	out19	out20	VCOstage
X21	VDD	Vn	Vp	out20	out21	VCOstage
X22	VDD	out21	clock	inverter
.ends

.subckt VCO5stage VDD Vinvco clock
M5      vn      Vn      0       0       N_50n L=1 W=10
M6      vn      vp      VDD     VDD     P_50n L=1 W=20
M5R     vp      Vinvco  Vr      0       N_50n L=1 W=100
Rset    Vr      0       10k
M6R     vp      vp      VDD     VDD     P_50n L=1 W=20
X1      VDD     Vn      Vp      out5    out1    VCOstage
X2      VDD     Vn      Vp      out1    out2    VCOstage
X3      VDD     Vn      Vp      out2    out3    VCOstage
X4      VDD     Vn      Vp      out3    out4    VCOstage
X5      VDD     Vn      Vp      out4    out5    VCOstage
Xout     VDD     out5   clock   inverter
.ends

.subckt	VCOstage	VDD	Vn	Vp	in	out
M1	vd1	vn	0	0	N_50n 	L=1	W=10
M2	out	in	Vd1	0	N_50n 	L=1	W=10
M3	out	in	Vd4	VDD	P_50n	L=1	W=20
M4	Vd4	vp	VDD	VDD	P_50n	L=1	W=20
.ends


*
* Charge pump: tri-state output 
* Current set by 10uA mirror
.subckt cp      VDD     up      down    out
Xinv1	VDD	up	upi	inverter
Xinv2	VDD	down	downi	inverter
M2L	vnx	up	Vpup	VDD	P_50n L=1 W=20
M2R	out	upi	vpup	VDD	P_50n L=1 W=20
M1L	vnx	downi	vndwn	0	N_50n L=1 W=10
M1R	out	down	vndwn	0	N_50n L=1 W=10
Mpb	Vp	Vp	VDD	VDD	P_50n L=2 W=100
Ibias	Vp	Vn	DC	10u
Mnb	Vn	Vn	0	0	N_50n L=2 W=50
Mpup	Vpup	Vp	VDD	VDD	P_50n L=2 W=100
Mndwn	Vndwn	Vn	0	0	N_50n L=2 W=50
.ends 


** 
** D- flip flop PFD
**	
.subckt	pfd	VDD	data	dclock	up 	down
X1	VDD	data	n1	inverter
X2	VDD	n1	n5	n2	nand
X3	VDD	n2	n3	inverter
X4	VDD	n3	n4	inverter
X5	VDD	n4	n6	reset	n5	nand3
X6	VDD	n5	up	inverter
X7	VDD	n2	n7	n6	nand
X8	VDD	n6	reset	n7	nand
X9	VDD	reset	n8	n9	nand
X10	VDD	n9	n11	n8	nand
X11	VDD	n6	n2	n11	n8	reset	nand4
X12	VDD	dclock	n10	inverter
X13	VDD	n10	n14	n11	nand
X14	VDD	n11	n12	inverter
X15	VDD	n12	n13	inverter
X16	VDD	reset	n8	n13	n14	nand3
X17	VDD	n14	down	inverter
.ends

.subckt nand	VDD	A	B	ANANDB
M1	n1	A	0	0	N_50n	L=1 	W=10
M2	ANANDB	B	n1	0	N_50n 	L=1	W=10
M3	ANANDB	A	VDD	VDD	P_50n	L=1	W=20
M4	ANANDB	B	VDD	VDD	P_50n	L=1	W=20
.ends

.subckt inverter	VDD	in	out	
M1	out	in	0	0	N_50n	L=1	W=10
M2	out	in	VDD	VDD	P_50n	L=1	W=20
.ends

.subckt nand3	VDD	A	B	C	OUT
M1	n1	A	0	0	N_50n	L=1 	W=10
M2	n2	B	n1	0	N_50n 	L=1	W=10
M3	OUT	C	n2	0	N_50n 	L=1	W=10
M4	OUT	A	VDD	VDD	P_50n	L=1	W=20
M5	OUT	B	VDD	VDD	P_50n	L=1	W=20
M6	OUT	C	VDD	VDD	P_50n	L=1	W=20
.ends

.subckt nand4	VDD	A	B	C	D	OUT
M1	n1	A	0	0	N_50n	L=1 	W=10
M2	n2	B	n1	0	N_50n 	L=1	W=10
M3	n3	C	n2	0	N_50n 	L=1	W=10
M4	OUT	D	n3	0	N_50n	L=1	W=10
M5	OUT	A	VDD	VDD	P_50n	L=1	W=20
M6	OUT	B	VDD	VDD	P_50n	L=1	W=20
M7	OUT	C	VDD	VDD	P_50n	L=1	W=20
M8	OUT	D	VDD	VDD	P_50n	L=1	W=20
.ends

.include cmosedu_models.txt
   

