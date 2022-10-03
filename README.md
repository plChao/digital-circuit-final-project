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
## Time comparison
![image](https://user-images.githubusercontent.com/32629259/193569489-ae2e3afd-4408-4565-b9aa-265391f43019.png)
## Area comparison
![image](https://user-images.githubusercontent.com/32629259/193569661-adc69f62-a014-479e-9527-51e4166a693e.png)
## Circuit stimulation delay comparison 
![image](https://user-images.githubusercontent.com/32629259/193569958-546db30f-e09c-4158-bd8a-d57ad4a9ce72.png)
## 結論
* 使用 Wallace Tree 的 delay 與 power 皆較小，但 area 較大 ( 比較 type 4 與 type 5 )
* 使用 Carry Select Adder 或 Carry Ripple Adder 的 power 與 delay 皆小於 Combinational Adder ( 比較 type 1 與 type 3、type 4 )
* 使用 Wallace Tree Multiplier 搭配 Carry Select Adder 是所有實驗組合裡面最好的 ( type 3 )
  * 但是在 layout 上可能會有更高的 cost，這會是設計上的一個 trade-off
