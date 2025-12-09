/datum/modular_persistence
	var/real_fat = 0
	var/perma_fat = 0
	var/micro_calorite_poisoning = 0

/mob/living/carbon/proc/save_persistent_fat(datum/modular_persistence/persistence)
	// we save this without having to check prefs
	persistence.real_fat = fatness_real

	persistence.perma_fat = fatness_perma

	if (isnull(client))
		return
	
	if (isnull(client.prefs))
		return
	
	var/datum/preferences/prefs = client.prefs

	// we save this if we have the right prefs

	if (prefs.read_preference(/datum/preference/toggle/severe_fatness_penalty))
		persistence.micro_calorite_poisoning = micro_calorite_poisoning

/mob/living/carbon/proc/load_persistent_fat(datum/modular_persistence/persistence)
	if (isnull(client))
		return
	
	if (isnull(client.prefs))
		return
	
	var/datum/preferences/prefs = client.prefs

	if (prefs.read_preference(/datum/preference/toggle/weight_gain_persistent))
		fatness_real = persistence.real_fat
	
	if (prefs.read_preference(/datum/preference/toggle/weight_gain_permanent))
		fatness_perma = persistence.perma_fat
	
	if (prefs.read_preference(/datum/preference/toggle/severe_fatness_penalty))
		micro_calorite_poisoning = persistence.micro_calorite_poisoning
	else
		persistence.micro_calorite_poisoning = 0

