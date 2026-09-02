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

SVA is used to check important protocol and DUT behaviors, including:

* Wishbone `ACK` behavior
* Read/write transaction responses
* SPI enable/disable behavior
* `SCK` behavior
* FSM-related conditions
* Validity of read data

### Functional Coverage

Functional coverage is included to ensure that important SPI configurations and transaction scenarios are exercised during verification.

Coverage includes SPI configuration combinations such as:

* `CPOL`
* `CPHA`
* SPI enable configuration
* Different SPI control register values
* Read/write transactions
  
## Project Objective

The objective of this project is to build a **complete reusable verification environment around an existing OpenCores SPI IP** and verify its functional behavior through transaction-based stimulus, monitoring, scoreboard checking, assertions, and functional coverage.
