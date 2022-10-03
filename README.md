# 數位電路 Final Report
## 成員
1. 楊士偉
2. 張繼哲
3. 陳若霖
4. 趙秉濂
## 使用方式
1. 用 `cd v1` 進入資料夾
2. 用 `./01_run_Behavior_sim.txt` 測試 MAC.v 在 transistor level 的正確性
3. 用 `./02_run_Synthesis.tcl` 來合成電路，並生成 Area, Time 等報告
4. 用 `./03_run_Gate_sim.txt` 測試 MAC_SYN. 在 gate level 的正確性
5. 用 `./Verilog2Spice` 修正 MAC_SYN.sp 的腳位，生成 MAC_SYN_new.sp
6. 用 `hspice ./MAC.sp` 來模擬 MAC_SYN_new.sp 輸入 MAC_pattern.vec 訊號的情況，產生延遲時間測試以及波形圖
7. 用 wave 查看波形圖看模擬情況
## 嘗試 MAC 組合
|type|code folder|Multiplier|Adder|
|-|-|-|-|
|type 1|v1|Wallace tree|Combinational|
|type 2|v2|Combinational|Combinational|
|type 3|v3|Wallace tree|Carry select|
|type 4|v4|Wallace tree|Ripple carry|
|type 5|v5|Combinational|Ripple carry|
