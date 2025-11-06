/obj/item/organ/cyberimp/brain/nif
	/// Do we want to drain using fatness?
	var/fat_drain = FALSE

/obj/item/organ/cyberimp/brain/nif/proc/toggle_fatness_drain(bypass = FALSE)
	if(!bypass && !fatness_check())
		return

	fat_drain = !fat_drain

	if(!fat_drain)
		power_usage += (NIF_FATNESS_DRAIN_RATE * NIF_ENERGY_PER_FATNESS)

		balloon_alert(linked_mob, "fat draining disabled")
		return

	power_usage -= (NIF_FATNESS_DRAIN_RATE * NIF_ENERGY_PER_FATNESS)
	balloon_alert(linked_mob, "fat draining enabled")

///Checks if the NIF is able to draw blood as a power source?
/obj/item/organ/cyberimp/brain/nif/proc/fatness_check()
	if(!linked_mob || !linked_mob.check_weight_prefs(FATTENING_TYPE_NANITES) || !linked_mob.fatness_real || (linked_mob.fatness_real <= NIF_FATNESS_DRAIN_RATE))
		return FALSE

	return TRUE

