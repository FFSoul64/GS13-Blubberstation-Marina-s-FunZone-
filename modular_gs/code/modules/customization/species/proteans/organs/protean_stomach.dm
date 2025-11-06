//	GS13 Protean stomach edits
//	Protean stomach does not remove nutrition from food
//	Proteans gain some fatness from eating stuff that gives them metal

/obj/item/organ/stomach/protean/on_life(seconds_per_tick, times_fired)
	var/datum/species/protean/species = owner?.dna.species
	var/obj/item/mod/control/pre_equipped/protean/suit = species.species_modsuit
	if(owner.loc == suit)
		return
	/// Zero out any nutrition. We do not use hunger in this species.
	//for(var/datum/reagent/consumable/food in reagents.reagent_list)
	//	food.nutriment_factor = 0
	. = ..()
	handle_protean_hunger(owner, seconds_per_tick)

/obj/item/organ/stomach/protean/after_eat(atom/edible)
	..()
	if(istype(edible, /obj/item/food/golem_food))
		owner.adjust_fatness(10, FATTENING_TYPE_FOOD)
		
