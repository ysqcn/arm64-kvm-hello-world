volatile unsigned int * const UART0DR = (unsigned int *) 0x10000000;
volatile unsigned int * const UART1DR = (unsigned int *) 0x10008000;

void print_uart0(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
        *UART0DR = (unsigned int)(*s); /* Transmit char */
        s++; /* Next char */
    }
}

void print_uart1(const char *s) {
    while(*s != '\0') { /* Loop until end of string */
        *UART1DR = (unsigned int)(*s); /* Transmit char */
        s++; /* Next char */
    }
}

// Read MPIDR_EL1 to get CPU ID
unsigned long get_cpu_id() {
    unsigned long mpidr;
    asm volatile("mrs %0, mpidr_el1" : "=r" (mpidr));
    return mpidr & 0xFF; // Extract Aff0 field (CPU ID)
}

void main() {
    unsigned long cpu_id = get_cpu_id();
    
    if (cpu_id == 0) {
        print_uart0("C0!\n");
    } else if (cpu_id == 1) {
        print_uart1("C1!\n");
    } else {
        print_uart0("C?\n");
    }
}
