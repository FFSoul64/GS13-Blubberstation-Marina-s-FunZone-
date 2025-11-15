/datum/gas_recipe/crystallizer/calorite
	id = "calorite"
	name = "Lipoifium solidification"
	min_temp = 600
	max_temp = 1800
	energy_release = -4000000
	requirements = list(
		/datum/gas/lipoifium = 150,
		/datum/gas/water_vapor = 50,
		/datum/gas/oxygen = 50,
		/datum/gas/nitrogen = 50
		)
	products = list(/obj/item/stack/sheet/mineral/calorite = 1)
