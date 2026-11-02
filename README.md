# SPI IP Verification Environment

## Overview

A complete **SystemVerilog-based verification environment** developed to verify the **OpenCores SPI IP**. The project focuses on validating the SPI controller's Wishbone interface, SPI data transfers, configuration modes, and transaction-level behavior.

## Verification Environment

The testbench follows a modular, class-based architecture with separate components for stimulus generation, bus driving, SPI monitoring, checking, and coverage.

```text
                    +----------------------+
                    |     SPI Testbench    |
                    +----------+-----------+
                               |
                    +----------v-----------+
                    |      Generator       |
                    |   Transactions       |
                    +----------+-----------+
                               |
                    +----------v-----------+
                    |         BFM          |
                    | Wishbone + SPI Drive |
                    +----------+-----------+
                               |
                               v
                    +----------------------+
                    |   OpenCores SPI IP   |
                    |         DUT          |
                    +----------+-----------+
                               |
              +----------------+----------------+
              |                                 |
      +-------v--------+                +-------v--------+
      |    SPI Monitor |                | Wishbone/Data  |
      | MOSI / MISO /  |                |    Monitor     |
      |     SCK        |                |                |
      +-------+--------+                +-------+--------+
              |                                 |
              +----------------+----------------+
                               |
                    +----------v-----------+
                    |     Scoreboard       |
                    | Transaction Checking |
                    +----------------------+

                    +----------------------+
                    | Functional Coverage  |
                    |       + SVA          |
                    +----------------------+
```

## Verification Features
<img width="1671" height="1226" alt="{D3F40662-DEFF-4A92-9E9C-9A552A08AA70}" src="https://github.com/user-attachments/assets/cb191eb9-52b3-4720-9aff-cbb3d1daebf3" />


Reported verification achievements:

100% functional coverage — all defined functional coverage bins were exercised.

### Reason for toggle percentage
<img width="1837" height="654" alt="{A6C66B24-0352-4EC9-AF8E-B9CBBA1058AB}" src="https://github.com/user-attachments/assets/3a0389e1-8833-46dd-88d8-2dd9c0840f34" />
| Signal | Reason |
|---|---|
| `clkcnt[11]` | The largest clock divider is `0x7FF` (11 bits), so bit 11 is never used. |
| `mstr`, `spcr[4]` | The master-mode bit is forced to 1 on reset and on every write (`spcr <= dat_i \| 8'h10`). |
| `rreg[7:0]` | The register is declared but never used in the RTL. |
| `spsr[5:4]` | These status bits are tied to 0 (`assign spsr[5:4] = 2'b00`). |

###  Expression Coverage
<img width="2978" height="382" alt="{3E058842-ABDB-4D2F-B146-E95DBE14E09F}" src="https://github.com/user-attachments/assets/76d74be7-6e99-4c74-938a-35e6ce799dc5" />
<img width="3067" height="380" alt="image" src="https://github.com/user-attachments/assets/130e1a04-e338-4be3-a51a-d33d97cf14e1" />
<img width="2993" height="313" alt="{26886467-4680-4C8F-B136-6B7A56D9EF84}" src="https://github.com/user-attachments/assets/289d0b7c-6425-4536-93da-b932d5968b84" />

| Expression | Uncovered term | Reason |
|---|---|---|
| `cyc_i & stb_i` | `cyc_i = 0` | It needs `stb_i` asserted without `cyc_i`. `STB_I` is only valid inside an active `CYC_I`, so this is not legal Wishbone. |
| `((wb_acc & adr_i==2) & ack_o) & we_i` | `wb_acc = 0` | It needs `ack_o = 1` with no active request. The DUT generates `ack_o` only from `wb_acc` (`ack_o <= wb_acc & ~ack_o`), and a compliant master holds the request until `ack_o`. |
### Transaction-Based Verification

SystemVerilog transaction classes are used to generate and transfer stimulus through the testbench components.

### Wishbone Interface Verification

The environment verifies register accesses and Wishbone transactions, including:

* Read transactions
* Write transactions
* Address and data handling
* `ACK` generation
* SPI configuration programming

### SPI Transfer Verification

SPI transactions are monitored and checked for:

* `SCK` behavior
* `MOSI` data
* `MISO` data
* 8-bit data transfers
* Received data correctness

### Scoreboard

A scoreboard compares the expected transaction data against the data observed from the DUT and reports matching or mismatching transactions.

### SystemVerilog Assertions

Nine concurrent assertions are bound to the DUT and check the following:

* `ack_one_cycle` — `ACK` is asserted for exactly one clock cycle per access.
* `write_en_ack` — every Wishbone write receives an `ACK`.
* `read_gets_ack` — every Wishbone read receives an `ACK`.
* `read_data_known` — read data contains no `X`/`Z` when `ACK` is returned.
* `sck_low_when_disabled` — `SCK` stays low while SPI is disabled.
* `fsm_idle_when_disabled` — the FSM returns to idle when SPI is disabled.
* `sck_stable_state01` — `SCK` holds its value in the first half of a clock period unless enabled.
* `sck_toggle_state01` — `SCK` toggles in FSM state `01` on an enable tick.
* `sck_toggle_state11` — `SCK` toggles in FSM state `11` on an enable tick, except for the final bit in CPHA=1 mode.

### Functional Coverage

Functional coverage is implemented in three covergroups that exercise SPI configurations, register accesses, and FIFO conditions:

* **Transaction coverage:** Wishbone address, read/write, `CPOL`, `CPHA`, `SPR`, and `SPRE`, with `CPOL` × `CPHA` and `CPOL` × `CPHA` × `SPR` crosses.
* **Register access coverage:** SPCR, SPSR, data FIFO, and SPER read/write combinations, `SPIE` and `SPE` settings, `ICNT` values, SPSR flag-clear values, and the write/read FIFO full, empty, and collision flags.
* **Clock-rate coverage:** `SPR` × `SPRE` cross sampled when data is pushed to the write FIFO.
  
## Python-Based Automation and Scripting

Python scripting is utilized within the verification workflow to manage execution and analyze simulation data. Key capabilities include:

* **Regression Automation:** Scripts to run individual tests or batch simulation runs using different seed values and configurations.
* **Log Parsing:** Post-simulation log processing to scan for warnings, UVM/SystemVerilog errors, and test pass/fail status.

## Project Objective

The objective of this project is to build a reusable verification environment around an existing OpenCores SPI IP and verify its functional behavior. This is achieved through transaction-based stimulus, monitoring, scoreboard checking, assertions, and functional coverage, supported by Python scripting for simulation automation and workflow efficiency.
