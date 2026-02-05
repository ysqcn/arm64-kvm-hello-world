.global _start
_start:
    /* Read MPIDR_EL1 to get CPU ID */
    mrs x0, mpidr_el1       /* Read Multiprocessor Affinity Register */
    and x0, x0, #0xFF       /* Extract Aff0 (CPU ID) */
    
    /* Calculate stack pointer for this CPU */
    /* CPU 0: 0x04020000, CPU 1: 0x04030000, etc. */
    ldr x30, =stack_top     /* Base stack address */
    mov x1, #0x10000        /* 64KB stack per CPU */
    madd x30, x0, x1, x30   /* stack_top + (cpu_id * 0x10000) */
    mov sp, x30             /* Set stack address */
    
    bl main                 /* Branch to main() */
    
    /* After main returns, enter WFI loop instead of shutting down */
    /* This allows all VCPUs to complete their work */
sleep:
    wfi                     /* Wait for interrupt */
    b sleep                 /* Endless loop */

.global system_off
system_off:
    ldr x0, =0x84000008     /* SYSTEM_OFF function ID - shutdown entire VM */
    hvc #0                  /* Hypervisor call */
    b sleep                 /* Fallback to sleep if HVC returns */

