/datum/nifsoft/fat_scanner
	name = "Weight Watcher"
	program_desc = "Allows the user to accurately judge the weight of those they look at."
	active_mode = TRUE
	active_cost = 0.01
	compatible_nifs = list(/obj/item/organ/cyberimp/brain/nif/standard)
	buying_category = NIFSOFT_CATEGORY_UTILITY
	ui_icon = "coins"

/datum/nifsoft/money_sense/activate()
	. = ..()
	if(active)
		ADD_TRAIT(linked_mob, TRAIT_FAT_SCANNER, REF(src))
		return

	REMOVE_TRAIT(linked_mob, TRAIT_FAT_SCANNER, REF(src))

