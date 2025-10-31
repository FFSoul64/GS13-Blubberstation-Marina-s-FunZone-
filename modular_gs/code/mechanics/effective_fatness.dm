/// Calculates how much the mob will weigh after offsets and modifiers.
/mob/living/carbon/proc/calculate_effective_fatness(list/skip_tags)
	if(!fatness) // We don't have any fatness to work with.
		return FALSE
	var/effective_fatness = fatness

	if(!(EW_SKIP_MUSCLE in skip_tags))
		effective_fatness -= muscle

	effective_fatness = max(effective_fatness, 0)
	return effective_fatness
