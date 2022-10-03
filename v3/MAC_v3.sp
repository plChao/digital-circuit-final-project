** Input Vector **
.vec 'MAC_pattern.vec'

.protect

.include '../../hw1/7nm_TT.pm'

.include '../../hw4/splib/asap7sc7p5t_AO_RVT.sp'
.include '../../hw4/splib/asap7sc7p5t_OA_RVT.sp'
.include '../../hw4/splib/asap7sc7p5t_INVBUF_RVT.sp'
.include '../../hw4/splib/asap7sc7p5t_SEQ_RVT.sp'
.include '../../hw4/splib/asap7sc7p5t_SIMPLE_RVT.sp'

.include '/home/RAID2/COURSE/dic/dic54/final_project/v3/Netlist/MAC_v3_SYN_new.sp'
.unprotect

.param voltage = 0.7v
.global vdd gnd 

Vvdd vdd gnd 'voltage'
vclk clk gnd pulse(0v 'voltage' 0ns 0.05ns 0.05ns 0.25ns 0.5ns)

** circuit **
X_mac_v3 gnd VDD  
+     in1_IFM[3] in1_IFM[2] in1_IFM[1] in1_IFM[0] 
+     in2_IFM[3] in2_IFM[2] in2_IFM[1] in2_IFM[0] 
+     out[9] out[8] out[7] out[6] out[5] out[4] out[3] out[2] out[1] out[0] 
+     clk rst_n in_valid out_valid
+     MAC_v3

.tran 0.1ns 10ns
.meas tran TpLH trig v(in1_IFM[0]) val = 'voltage/2'  rise = 1
+               targ V(out[1]) val = 'voltage/2' rise = 1
.meas tran TpHL trig v(in1_IFM[0]) val = 'voltage/2' fall = 1
+               targ V(out[1]) val = 'voltage/2' fall = 1

.meas tran pwr AVG power

.option post
.option probe			*with I/V in .lis
.probe v(*) i(*)
.option captab			*with cap value in .lis
.TEMP 25

.alter 
.param voltage = 0.6v

*.alter 
*.param voltage = 0.5v
.end 