//
// SPDX-FileCopyrightText: 2026 Daniel Grobert <danalexgro@gmail.com>
// SPDX-License-Identifier: AGPL-3.0-or-later
//
#include <common.h>

__attribute__((section(".text.entry")))
void _entry(void)
{
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

    /* 
       Some devices, such as Sony ones for example,
       require this or else it will try to boot 
       off of the UFS when entering pbl_apps_load_auth_sbl.
    */
    select_bdev(boot_qusb);

    pbl_invalidate_tlb();
    pbl_detect_bootable_media(state);
    pbl_modify_page_table_attributes(state);
    pbl_apps_load_auth_sbl(state);
    pbl_populate_share_data(state);

    pbl_memset(0x1481e000, 0x0, 0x1000);

    write32(0x1481e000, FUN_00306c28());
    write32(0x1481e004, FUN_00305c90((long **)0x1481e300, 1));
    write32(0x1481e008, FUN_00305cc0((uintptr_t *)0x1481e300, 1, 0x0, 4));
    write32(0x1481e00c, FUN_00305cc0((uintptr_t *)0x1481e300, 2, (long *)&read32(0x1481f000), 0x20));  
    write32(0x1481e010, FUN_00305cc0((uintptr_t *)0x1481e300, 1, 0x0, 4));  
    write32(0x1481e014, FUN_00305610((uintptr_t **)0x1481e300, (uintptr_t *)0x1481e100, 1, (uintptr_t **)0x1481e110));  
    write32(0x1481e018, read32(0x78208c)); 

    // patch XBL_SEC
    write32(0x1469f9a8, 0xaa1e03f4);
    write32(0x1469f9ac, 0xd2800020);
    write32(0x1469f9b0, 0x58000163);
    write32(0x1469f9b4, 0xd63f0060);
    write32(0x1469f9b8, 0x58000163);
    write32(0x1469f9bc, 0xd63f0060);
    write32(0x1469f9c0, 0xd2800020);
    write32(0x1469f9c4, 0xd2800001);
    write32(0x1469f9c8, 0xd2800002);
    write32(0x1469f9cc, 0x58000103);
    write32(0x1469f9d0, 0xd63f0060);
    write32(0x1469f9d4, 0xaa1403fe);
    write32(0x1469f9d8, 0xd65f03c0);
    write32(0x1469f9dc, 0x1469c6dc);
    write32(0x1469f9e0, 0);
    write32(0x1469f9e4, 0x146a479c);
    write32(0x1469f9e8, 0);
    write32(0x1469f9ec, 0x146a01cc);
    write32(0x1469f9f0, 0);

    pbl_exit(state); // Good night!
    pbl_cm_fault_detected();
    asm volatile (".ascii \"Coyote-Napali\"");
}