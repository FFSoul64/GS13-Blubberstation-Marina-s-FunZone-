/datum/modular_persistence
	var/real_fat = 0
	var/perma_fat = 0

/mob/living/carbon/proc/save_persistent_fat(datum/modular_persistence/persistence)
	if (isnull(client))
		return
	
	if (isnull(client.prefs))
		return
	
	var/datum/preferences/prefs = client.prefs

	if (prefs.read_preference(/datum/preference/toggle/weight_gain_persistent))
		prefs.update_preference(GLOB.preference_entries[/datum/preference/numeric/starting_fatness], fatness_real)
		persistence.real_fat = fatness_real

	// prefs.update_preference(GLOB.preference_entries[/datum/preference/numeric/perma_fat_value], fatness_perma)
	persistence.perma_fat = fatness_perma

/mob/living/carbon/proc/load_persistent_fat(datum/modular_persistence/persistence)
	if (isnull(client))
		return
	
	if (isnull(client.prefs))
		return
	
	var/datum/preferences/prefs = client.prefs

	// if (prefs.read_preference(/datum/preference/toggle/weight_gain_persistent))
	// 	fatness_real = persistence.real_fat
	
	if (prefs.read_preference(/datum/preference/toggle/weight_gain_permanent))
		fatness_perma = persistence.perma_fat

