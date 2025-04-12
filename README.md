# **2-Level Cache Controller on a RISC-V Core**

## **Aim**
The aim of this project is to develop a Single cycle RISC-V processor integrated with a hierarchical cache system to reduce memory access latency. The design includes:  
- A functional RV32I processor core with basic arithmetic, logic, control, and memory instructions.  
- L1 and L2 caches with distinct mapping policies (L1: direct-mapped, L2: 4-way set associative).  
- Implementation of write-back and no-write allocate policies with Least Recently Used (LRU) replacement.  
- Testing and verification of a balanced set of Load/Store and ALU instructions on the integrated system.

## **Introduction**
The RISC-V architecture is an open-source instruction set architecture (ISA) known for its simplicity and flexibility. Originally developed at the University of California, Berkeley, it is part of the fifth generation of RISC processors.

A **Cache Controller** serves as an interface between the processor and memory, executing read and write requests (Load/Store instructions), and managing data flow across cache levels and main memory.

This project focuses on implementing a two-level cache system with a **Single-Cycle RISC-V processor**, offering hands-on experience in digital design and microprocessor architecture.

### **Technologies Used**
- **Xilinx Vivado IDE**
- **Ripes RISC-V Simulator**
- **GTKWave (debugging)**
- **Languages**: Verilog HDL, RISC-V Assembly

**Tools Description**:  
- **Xilinx Vivado**: FPGA design suite for synthesis, implementation, and verification  
- **Ripes**: Visual simulator for RISC-V, generates binary `.dat` files for instruction memory  
- **GTKWave**: Waveform viewer for efficient debugging

## **Literature Survey**
1. Implementation and comparison of different cache mappings  
2. Accel: Cache simulator  
3. Cache architecture studies  

## **Methodology**

### **Research Phase**
- **Memory Hierarchy Understanding**:  
  Studied **spatial** and **temporal locality** to optimize cache.
- **AMAT (Average Memory Access Time)**:  
  AMAT = Hit time + Miss rate × Miss penalty
- **Write Policy Analysis**:  
  Compared **Write-through** vs **Write-back**

### **Design Procedure**
- Developed **RV32I Processor Core** using Verilog HDL (5-stage pipeline):
  - Instruction Fetch (IF)
  - Instruction Decode (ID)
  - Execute (EX)
  - Memory Access (MEM)
  - Write Back (WB)

- Used **structural modeling** to define modules and integrate datapath and control path.

### **Cache Design**
- **Clock Rate**: Cache operates ~5× faster than the processor for optimal AMAT.
  
**L1 Cache (Direct-Mapped)**  
- Size: 64 bytes  
- Delay: 1 cycle  

**L2 Cache (4-Way Set Associative)**  
- Size: 512 bytes  
- Delay: 4 cycles  
- **Replacement Policy**: LRU  
 
**Main Memory**  
- Size: 4KB  
- Delay: 10 cycles  

**Policies Implemented**:  
- Write-Back  
- No Write-Allocate  

## **Implementation**

1. **Check Mode**: Ensure controller isn’t busy via the wait signal  
2. **Read Operation**:
   - Check L1 Cache  
   - **L1 Hit**: Return data to processor  
   - **L1 Miss**: Check L2  
   - **L2 Hit**: Delay 2 cycles, promote block to L1  
   - **L2 Miss**: Fetch from main memory (10-cycle delay)  
   - **Promotions**: L2 → L1 with evictions and write-backs if needed

3. **Write Operation**:
   - **L1 Hit**: Modify in L1  
   - **L1 Miss**: Check and modify in L2 if found  
   - **L2 Miss**: Modify directly in main memory  
   - **Policy**: No promotion on write, no eviction on write (No Write-Allocate)

## **Results**

**Test Program:**
```assembly
addi x5, x0, 0  
addi x6, x0, 0  
addi x7, x0, 4  
addi x6, x5, 0  
sw x7, 0(x6)  
lw x7, 0(x6)  
addi x6, x5, 4  
lw x7, 0(x6)  
addi x6, x5, 8  
```

- **Processor Speed**: 11.9 MHz (84 ns period)  
- **Cache Speed**: 500 MHz (2 ns period)  
- **Speedup (after L1 full)**: **3.75×**  
- *Observation point: PC = 0x4A; check hit1, hit2, and wait signals*

## **Conclusion and Future Scope**

The two-level cache controller significantly reduced memory latency and increased performance in the RISC-V system. Through integration with the RV32I core, substantial throughput gains were achieved compared to a baseline design.

### **Future Scope**
1. **Branch Prediction**: Reduce instruction fetch penalties  
2. **Advanced Cache Policies**: Write-through, Write-allocate, and even L3 Cache  
3. **Multicore Coherence**: Implement MESI/MOESI for shared caches  
4. **Adaptive Replacement**: Use DRRIP or ARC for better miss handling  
5. **Prefetching Mechanisms**: To reduce compulsory misses  
6. **FPGA Implementation**: Synthesize the full design to obtain power, area, and timing reports on hardware
