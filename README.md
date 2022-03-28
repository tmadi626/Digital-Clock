# Digital-Clock
A Digital Clock is created through the use of VHDL, and was tested, as well as implemented in DE1-SoC FPGA


<h1 align="center">Digital Clock</h1>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)](https://github.com/tmadi626/BudgetTracker)
[![GitHub Issues](https://img.shields.io/github/issues/tmadi626/BudgetTracker.svg)](https://github.com/tmadi626/BudgetTracker/issues)
[![GitHub Pull Requests](https://img.shields.io/bitbucket/pr/tmadi626/BudgetTracker)](https://github.com/tmadi626/BudgetTracker/pulls)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

## 😄 Why Use it? 

If you ever wondered how do digital (24HR) clocks work, or simply want to make one yourself but dont know how? This Repo is for you. 😛

## 📝 Table of Contents

- [About](#about)
- [Files](#files)
- [Built Using](#built_using)
- [Authors](#authors)

## 🤔 About <a name = "about"></a>

The Digital Clock was created in an effort to learn Digital Systems via applications, as well as to incorperate counters and combinational circuits to create a large intricate system.
It is implemented on DE1-SoC, and it uses its internal 50MHz clock, as well as the 6 HEX displays, and the input buttons for resetting and setting hours/minutes by the input swithces.
## 🧐 Files <a name = "files"></a>

<ul>
  <li> Counter26Bit.vhd</li>
  <ul>
    <li> Since DE1-SoC has a 50MHz internal clock, the 26Bit component is used to transalte 50MHz into 1 second output.</li>
  </ul>
  <li> Counter4Bit.vhd</li>
  <ul>
    <li> Each unit in the clock (XX:XX:XX) make use of a 4 bit counter. Why? because each unit in the clock can count up until 9, hence 4 bit.</li>
  </ul>
  <li> Compare.vhd</li>
  <ul>
    <li> This component is used to check once the clock reached is in the 20s(Hr) for example: (23:59:59) that the 1st hr(here being a 3) cant be more than 3.</li>
  </ul>
  <li> Indicator.vhd</li>
  <ul>
    <li> This component is used to indicate which input switches are ON or OFF in the hour/min setting phase, by lighting the LEDRs.</li>
  </ul>
  <li> SevSegDecoder.vhd</li>
  <ul>
    <li> This component is used to display the time (decimal) onto the HEX Displays. It is a mux that takes in the bits from each 4bit counter, and simply transaltes it to the displays.</li>
  </ul>
  <li> Clock.vhd</li>
  <ul>
    <li> This module is the top level deisgn of the Clock that make use of previously described components. Connected together via "wires" and combinational circuits to display the time, as well as setting the time.</li>
  </ul>
</ul>


## ⛏️ Built Using <a name = "built_using"></a>

- VHDL
- Quartus Prime 20.1
- JTAG
- DE1_SoC (Cyclone V - 5CSEMAF31C)

## ✍️ Authors <a name = "authors"></a>

- [Taha Madi](https://github.com/tmadi626)
