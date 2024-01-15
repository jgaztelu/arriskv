Arriskv is a test RISCV implementation in systemverilog. 
The goal is to revisit different concepts from computer architecture classes with a modern architecture and make a working RISCV implementation.

# Random info
## GCC Compilation Options
`./configure --prefix=/opt/riscv --enable-multilib --with-multilib-generator="rv32i-ilp32--c rv32im-ilp32--c rv32iac-ilp32-- rv32imac-ilp32-- rv32imafc-ilp32f-rv32imafdc- rv64imac-lp64-- rv64imafdc-lp64d--"`

## Good video on compiling freestanding programs with gcc
https://www.youtube.com/watch?v=iml0DBo5yqo

# TO-DO
- [x] Implement base instruction set (RV32I)
- [ ] Compile simple programs in gcc freestanding mode to test CPU
- [ ] Setup cocotb for simulation
- [ ] Implement multiplication extensions (RV32M)
- [ ] Implement floating point extensions (RV32F)(maybe?)
- [ ] Implement remaining extensions for general-purpose software (RV32G)
- [ ] Run Linux (one can dream 😁)

