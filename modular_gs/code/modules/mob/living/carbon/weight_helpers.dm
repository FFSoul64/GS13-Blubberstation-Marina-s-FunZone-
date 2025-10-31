/// Calculates how much fatness_to_calculate would be in pounds.
/mob/living/carbon/proc/calculate_fatness_weight_in_pounds(fatness_to_calculate)
	return round(((fatness_to_calculate*FATNESS_TO_WEIGHT_RATIO)) * (dna.current_body_size ** 2))

/// Returns the weight of all of the mob's fatness in pounds.
/mob/living/carbon/proc/calculate_total_fatness_weight_in_pounds()
	return round(((fatness*FATNESS_TO_WEIGHT_RATIO)) * (dna.current_body_size ** 2))	// huff, being bigger really does raise the number on that scale by quite a bit huh~?
	//return round((140 + (fatness*FATNESS_TO_WEIGHT_RATIO))*(size_multiplier**2)*((dna.features["taur"] != "None") ? 2.5: 1))

/// Calculates how much muscle_to_calculate would be in pounds.
/mob/living/carbon/proc/calculate_muscle_weight_in_pounds(muscle_to_calculate)
	return round(((muscle_to_calculate*MUSCLE_TO_WEIGHT_RATIO)) * (dna.current_body_size ** 2))

/// Returns the weight of all of the mob's muscles in pounds.
/mob/living/carbon/proc/calculate_total_muscle_weight_in_pounds()
	return round(((muscle*MUSCLE_TO_WEIGHT_RATIO)) * (dna.current_body_size ** 2))

/mob/living/carbon/proc/calculate_weight_in_pounds()
	return calculate_total_fatness_weight_in_pounds() + calculate_total_muscle_weight_in_pounds() + (BASE_WEIGHT_VALUE * (dna.current_body_size ** 2))

// Datum containing weight information about a mob.
/datum/weigh_out
	var/total_weight_pounds = 0
	var/total_weight = 0

	var/fatness_total_pounds = 0
	var/fatness_real_pounds = 0
	var/fatness_perma_pounds = 0
	var/fatness_other_pounds = 0

	var/fatness_total = 0
	var/fatness_real = 0
	var/fatness_perma = 0
	var/fatness_other = 0

	var/muscle_total_pounds = 0
	var/muscle_real_pounds = 0
	var/muscle_other_pounds = 0

	var/muscle_total = 0
	var/muscle_real = 0
	var/muscle_other = 0

	var/weight_gain_rate = 0
	var/weight_loss_rate = 0
	var/muscle_gain_rate = 0
	var/muscle_loss_rate = 0

/datum/weigh_out/proc/generate_list()
	var/list/category_list = list()


	/*
	category_list["Totals"] = list(
		"Weight" = total_weight_pounds,
		"Weight (Adjusted BFI/MMI)" = total_weight,
	)
	*/

	category_list["Fat"] = list(
	//	"Total Fat" = list(fatness_total_pounds, fatness_total),
		"Regular Fat" = list(fatness_real_pounds, fatness_real),
		"Long-Term Fat" = list(fatness_perma_pounds, fatness_perma),
		"Other Non-Muscle Mass" = list(fatness_other_pounds, fatness_other),
	)

	category_list["Muscle"] = list(
	//	"Total Muscle" = list(muscle_total_pounds, muscle_total),
		"Regular Muscle" = list(muscle_real_pounds, muscle_real),
		"Other Muscle" = list(muscle_other_pounds, muscle_other),
	)

	/*
	category_list["Mass Alteration Rates"] = list(
		"Weight Gain Rate" = weight_gain_rate,
		"Weight Loss Rate" = weight_loss_rate,
		"Muscle Gain Rate" = muscle_gain_rate,
		"Muscle Loss Rate" = muscle_loss_rate,
	)
	*/

	return category_list

/// Updates the variables of the datum based on that of `target_mob`
/datum/weigh_out/proc/weigh(mob/living/carbon/target_mob)
	if(!istype(target_mob))
		return FALSE

	total_weight_pounds = target_mob.calculate_weight_in_pounds()
	total_weight = (target_mob.fatness + target_mob.muscle)

	fatness_total = target_mob.fatness
	fatness_real = target_mob.fatness_real
	fatness_perma = target_mob.fatness_perma
	fatness_other = (fatness_total - (fatness_real + fatness_perma))

	fatness_total_pounds = target_mob.calculate_total_fatness_weight_in_pounds()
	fatness_real_pounds =  target_mob.calculate_fatness_weight_in_pounds(fatness_real)
	fatness_perma_pounds = target_mob.calculate_fatness_weight_in_pounds(fatness_perma)
	fatness_other_pounds = target_mob.calculate_fatness_weight_in_pounds(fatness_other)

	muscle_total = target_mob.muscle
	muscle_real = target_mob.muscle_real
	muscle_other = (muscle_total - muscle_real)

	muscle_total_pounds = target_mob.calculate_total_muscle_weight_in_pounds()
	muscle_real_pounds = target_mob.calculate_muscle_weight_in_pounds(muscle_real)
	muscle_other_pounds = target_mob.calculate_muscle_weight_in_pounds(muscle_other)

	weight_gain_rate = target_mob.weight_gain_rate
	weight_loss_rate = target_mob.weight_loss_rate
	muscle_gain_rate = target_mob.muscle_gain_rate
	muscle_loss_rate = target_mob.muscle_loss_rate

	return TRUE

