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
        Authentication is not bypassed here and every
        NHLOS partition must be signed by the OEM.
    */
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