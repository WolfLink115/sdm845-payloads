//
// SPDX-FileCopyrightText: 2026 Daniel Grobert <danalexgro@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-or-later
//
#include "stdint.h"
#include "pbl_calls.h"

#define pbl_stack 0x1480fbb0UL
#define state     pbl_stack
#define boot_ufs 0
#define boot_ufs_and_sdcc 1
#define boot_sdcc 2
#define boot_qusb 3
#define boot_spi 4 // 5 too

#define read32(addr) \
    (*(volatile uint32_t *)(uintptr_t)(addr))

#define write32(addr, value) \
    (*(volatile uint32_t *)(uintptr_t)(addr) = (uint32_t)(value))

#define select_bdev(flash_status) \
    write32(state + 4, flash_status);
