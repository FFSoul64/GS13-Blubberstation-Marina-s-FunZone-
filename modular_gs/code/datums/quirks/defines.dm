#define FAT_AFFINITY_COOLDOWN				"fatty_examine"
#define FAT_AFFINITY_ACTIVATION_COOLDOWN	"same_fatty_cooldown"
#define PLEASANTLY_SOFT_COOLDOWN			"pleasantly_soft_examine"
#define FAT_AVERSION_COOLDOWN				"fat_aversion"

// /mob/living		// this was a cancer solution
// 	var/number_of_helplessness_quirks = 0

/datum/quirk/helplessness/add_to_holder(mob/living/new_holder, quirk_transfer, client/client_source, unique, announce)
	. = ..()
	// if (!HAS_TRAIT(new_holder, TRAIT_UNIVERSAL_GAINER))
	ADD_TRAIT(new_holder, TRAIT_UNIVERSAL_GAINER, mob_trait)
	// new_holder.number_of_helplessness_quirks += 1

/datum/quirk/helplessness/remove_from_current_holder(quirk_transfer)
	if (!quirk_holder)
		CRASH("Attempted to remove quirk from the current holder when it has no current holder.")

	// quirk_holder.number_of_helplessness_quirks -= 1

	// if (quirk_holder.number_of_helplessness_quirks == 0 && HAS_TRAIT(quirk_holder, TRAIT_UNIVERSAL_GAINER))
	REMOVE_TRAIT(quirk_holder, TRAIT_UNIVERSAL_GAINER, mob_trait)

	. = ..()
