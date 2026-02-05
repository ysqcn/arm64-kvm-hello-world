# About

This project is based on: https://github.com/Lenz-K/arm64-kvm-hello-world.git

**Note**: This fork only modifies `bare-metal-aarch64` and `kvm_test.cpp` to demonstrate 2 VCPUs running in parallel. The `bare-metal-aarch64-qemu` folder remains unchanged from the original repository, but may be broken and not work properly due to the changes in other parts of the project.



# Two-VCPU Support

The KVM test program now supports **two VCPUs**. Key changes include:

- **Parallel Execution**: Each VCPU runs in its own pthread thread, allowing true parallel execution
- **CPU Identification**: Each VCPU can identify itself using the MPIDR_EL1 register (Aff0 field contains CPU ID)
- **Independent Stack Space**: Each CPU has its own 64KB stack space (CPU 0: 0x04020000, CPU 1: 0x04030000)
- **Separate UART Devices**: CPU 0 writes to UART0 (0x10000000), CPU 1 writes to UART1 (0x10008000)
- **Exit Detection**: The program uses '\n' (newline) in the message to determine when a VCPU has completed its output
- **PSCI Handling**: If one VCPU calls `system_off` via HVC (Hypervisor Call), it will shutdown the entire VM, while another VCPU may still be working

The bare-metal code has been adapted to:
- Read the CPU ID from MPIDR_EL1 register
- Print different messages based on CPU ID ("C0!\n" for CPU 0, "C1!\n" for CPU 1)
- Use WFI (Wait For Interrupt) loop instead of immediately shutting down after main() returns
