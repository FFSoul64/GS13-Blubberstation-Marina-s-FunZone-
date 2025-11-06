/mob/proc/can_see_bfi()
	return (stat == DEAD) || HAS_TRAIT(src, TRAIT_FAT_SCANNER)

