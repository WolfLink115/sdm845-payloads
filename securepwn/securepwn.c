//
// SPDX-FileCopyrightText: 2026 Daniel Grobert <danalexgro@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-or-later
//
#include <common.h>

__attribute__((section(".text.entry")))
void _entry(void)
{
    /*
        This payload initializes the UFS and boots XBL.
        Authentication is bypassed here by disabling
        Qualcomm Secure Boot. You may boot self signed
        binaries.
    */

    /* PBL Shared Data related stuff */
    memcpy(0x1481f000, 0x31f000, 0x1000);
    write32(0x1481f008, 0xd2800000);
    write32(0x1481f00c, 0xb9000020);
    write32(0x1481f010, 0x58000040);
    write32(0x1481f014, 0xd65f03c0);
    write32(0x1481f018, 0x5a9d3aa0);
    write32(0x1481f01c, 0x0);
    write32(0x148018f8, 0x1481f79b);
    pbl_invalidate_tlb();
    pbl_data_init(state);
    pbl_hw_get_boot_option(state);
    select_bdev(boot_ufs);
    pbl_invalidate_tlb();
    pbl_detect_bootable_media(state);
    pbl_modify_page_table_attributes(state);
    pbl_apps_load_auth_sbl(state);
    pbl_populate_share_data(state);
    pbl_exit(state); // Good night!
    pbl_cm_fault_detected();
}

