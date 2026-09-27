#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <unistd.h>

/* ============================================================
 *  DVCon 2026 - ChipUp Team 188
 *  Task-Aware Object Selection Accelerator - Test Application
 *
 *  DRAM writeback target moved to the top of the 1GB DRAM range
 *  (0xBFF00000+) to reduce collision risk with memory Linux/kernel
 *  is actively using near the bottom of RAM. This lowers risk, it
 *  does not eliminate it - no confirmed-reserved address for this
 *  purpose has been provided yet.
 * ============================================================ */

#define ACCEL_BASE       0x20040000UL
#define ACCEL_MAP_SIZE   0x1000UL

#define REG_CONF_WEIGHT(base, n)   (*(volatile unsigned long *)((base) + (n) * 0x08))
#define REG_START(base)            (*(volatile unsigned long *)((base) + 0x28))
#define REG_RESULT0(base)          (*(volatile unsigned long *)((base) + 0x30))
#define REG_RESULT1(base)          (*(volatile unsigned long *)((base) + 0x38))
#define REG_VALID_MASK(base)       (*(volatile unsigned long *)((base) + 0x40))
#define REG_READY(base)            (*(volatile unsigned long *)((base) + 0x48))
#define REG_RESULT_BASE_ADDR(base) (*(volatile unsigned long *)((base) + 0x50))
#define REG_DONE(base)             (*(volatile unsigned long *)((base) + 0x58))

/* Moved-address writeback target, per discussion. Not confirmed-safe
 * by C-DAC - reduces risk statistically, does not eliminate it. */
#define TEST_SLOT_PHYS(i)  (0xBFF00000UL + ((unsigned long)(i) * 0x40UL))

#define POLL_TIMEOUT   20000000UL

static const char *task_names[5] = {
    "Water the Plant",
    "Step On Something",
    "Dig a Hole",
    "Sit Comfortably",
    "Extinguish the Fire"
};

static int poll_done(volatile unsigned char *accel_base, const char *label)
{
    unsigned long i;
    for (i = 0; i < POLL_TIMEOUT; i++) {
        if (REG_DONE(accel_base) & 0x1)
            return 1;
    }
    printf("  [ERROR] Timed out waiting for DONE on \"%s\" "
           "(ready=0x%lx done=0x%lx)\n",
           label, REG_READY(accel_base), REG_DONE(accel_base));
    fflush(stdout);
    return 0;
}

static void run_test(volatile unsigned char *accel_base,
                      unsigned int test_idx,
                      unsigned short c0, unsigned short w0,
                      unsigned short c1, unsigned short w1,
                      unsigned short c2, unsigned short w2,
                      unsigned short c3, unsigned short w3,
                      unsigned short c4, unsigned short w4)
{
    unsigned long cw[5];
    unsigned int i;

    cw[0] = ((unsigned long)w0 << 16) | c0;
    cw[1] = ((unsigned long)w1 << 16) | c1;
    cw[2] = ((unsigned long)w2 << 16) | c2;
    cw[3] = ((unsigned long)w3 << 16) | c3;
    cw[4] = ((unsigned long)w4 << 16) | c4;

    for (i = 0; i < 5; i++)
        REG_CONF_WEIGHT(accel_base, i) = cw[i];

    /* Explicitly set writeback target every test - do not leave unset. */
    REG_RESULT_BASE_ADDR(accel_base) = TEST_SLOT_PHYS(test_idx);

    REG_START(accel_base) = 0x1;

    printf("\n[Test %u] %-22s : running...\n", test_idx, task_names[test_idx]);
    fflush(stdout);

    if (!poll_done(accel_base, task_names[test_idx])) {
        REG_START(accel_base) = 0x0;
        return;
    }

    unsigned long result0    = REG_RESULT0(accel_base);
    unsigned long result1    = REG_RESULT1(accel_base);
    unsigned long valid_mask = REG_VALID_MASK(accel_base) & 0x1F;

    unsigned int  primary_index     = result0 & 0x7;
    unsigned long primary_score     = (result0 >> 32) & 0xFFFFFFFFUL;
    unsigned int  alternative_index = result1 & 0x7;
    unsigned long alternative_score = (result1 >> 32) & 0xFFFFFFFFUL;

    printf("  ---------------- RESULT ----------------\n");
    printf("  Task        : %s\n", task_names[test_idx]);
    printf("  Primary     -> Index %u  (Score %lu)\n", primary_index, primary_score);
    printf("  Alternative -> Index %u  (Score %lu)\n", alternative_index, alternative_score);
    printf("  Valid mask  -> 0x%02lx\n", valid_mask);
    printf("  -----------------------------------------\n");
    fflush(stdout);

    REG_START(accel_base) = 0x0;
}

int main(void)
{
    int fd;
    void *map_base;
    volatile unsigned char *accel_base;

    printf("========================================================\n");
    printf("  DVCon 2026 - ChipUp Team 188\n");
    printf("  Task-Aware Object Selection Accelerator - Test App\n");
    printf("========================================================\n");
    fflush(stdout);

    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        perror("Cannot open /dev/mem");
        return 1;
    }

    map_base = mmap(NULL, ACCEL_MAP_SIZE, PROT_READ | PROT_WRITE,
                     MAP_SHARED, fd, ACCEL_BASE);
    if (map_base == MAP_FAILED) {
        perror("mmap failed");
        close(fd);
        return 1;
    }

    accel_base = (volatile unsigned char *)map_base;

    printf("Accelerator ready register (0x48) = 0x%lx\n", REG_READY(accel_base));
    fflush(stdout);

    run_test(accel_base, 0, 811, 900, 584, 400, 850, 200, 800, 200, 750, 200);
    run_test(accel_base, 1, 735, 700, 677, 700, 900, 200, 850, 200, 800, 200);
    run_test(accel_base, 2, 900, 700, 850, 500, 100, 200, 200, 200, 900, 500);
    run_test(accel_base, 3, 600, 900, 850, 700, 780, 500, 700, 400, 100, 200);
    run_test(accel_base, 4, 300, 200, 350, 200, 250, 200, 380, 200, 200, 200);

    printf("\n========================================================\n");
    printf("  All 5 test cases completed.\n");
    printf("========================================================\n");
    fflush(stdout);

    munmap(map_base, ACCEL_MAP_SIZE);

    if (close(fd) == -1) {
        perror("Error closing /dev/mem");
        return 1;
    }

    return 0;
}
