# FPGA Packet Processing Engine

An FPGA-based packet processing engine for intelligent network traffic management, featuring **QoS control, packet classification, queue management, scheduling, congestion control, and performance monitoring**.

## Hardware & Tools

- **Board:** PYNQ-Z2
- **FPGA:** Xilinx Zynq-7000 — XC7Z020CLG400-1
- **HDL:** Verilog
- **Tool:** AMD/Xilinx Vivado
- **Simulation:** Vivado XSim

## Architecture
Traffic Generator
        ↓
Packet Parser
        ↓
Priority Classifier
        ↓
QoS Controller
        ↓
Queue Dispatcher
        ↓
   FIFO Queues
        ↓
    Scheduler
        ↓
   RED / WRED
        ↓
 Packet Output

Key Modules
Packet Generator & Parser
Priority Classifier
QoS Controller
Queue Dispatcher & FIFO
Packet Scheduler
RED / WRED Controllers
Adaptive QoS Engine
Network State Analyzer
Performance & Latency Monitor
Fairness Index Calculator

Project Structure
packet_processing_engine/
├── packet_processing_engine.srcs/
│   ├── sources_1/    # RTL
│   └── sim_1/        # Testbenches
├── packet_processing_engine.xpr
├── tb_top_behav.wcfg
└── README.md

Status
🚧 Active Development
Currently focused on RTL verification, simulation, timing analysis, and FPGA hardware validation.


