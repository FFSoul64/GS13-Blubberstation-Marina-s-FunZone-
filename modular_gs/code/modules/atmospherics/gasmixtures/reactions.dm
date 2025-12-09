/datum/gas_reaction/lipoifium_formation
	priority_group = PRIORITY_FORMATION
	name = "Lipoifium Formation"
	id = "lipoifium_formation"
	desc = "Plasma is has characteristics similar to hydrocarbons. Cooling it with tritium around causes the creation of a highly fattening gas."

/datum/gas_reaction/lipoifium_formation/init_reqs()
	requirements = list(
		"MAX_TEMP" = 100,
		/datum/gas/plasma = MINIMUM_MOLE_COUNT,
		/datum/gas/tritium = MINIMUM_MOLE_COUNT
	)

/datum/gas_reaction/lipoifium_formation/react(datum/gas_mixture/air, datum/holder)
	var/list/cached_gases = air.gases
	var/list/plasma = cached_gases[/datum/gas/plasma]
	var/list/tritium = cached_gases[/datum/gas/tritium]
	if (plasma[MOLES] < MINIMUM_MOLE_COUNT || tritium[MOLES] < MINIMUM_MOLE_COUNT)
		return NO_REACTION

	var/temperature = air.temperature
	var/reaction_efficiency = 0
	if (temperature <= 5)
		reaction_efficiency = 1
	else if (temperature >= 100)
		return NO_REACTION
	else
		reaction_efficiency = -((temperature - 5) / 95) + 1		// will equal 1 at 5 kelvin, and will linearly fall until 0 at 100k


	var/old_heat_capacity = air.heat_capacity()

	var/used_moles = min((reaction_efficiency * min(plasma[MOLES], tritium[MOLES]) * 0.5), 10)
	var/energy_released = used_moles * FIRE_CARBON_ENERGY_RELEASED

	ASSERT_GAS(/datum/gas/lipoifium, air)
	cached_gases[/datum/gas/lipoifium][MOLES] += used_moles
	cached_gases[/datum/gas/plasma][MOLES] -= used_moles
	cached_gases[/datum/gas/tritium][MOLES] -= used_moles
	var/new_heat_capacity = air.heat_capacity()
	if(new_heat_capacity > MINIMUM_HEAT_CAPACITY)
		air.temperature = (max((temperature * old_heat_capacity + energy_released) / new_heat_capacity, TCMB))

	return REACTING
