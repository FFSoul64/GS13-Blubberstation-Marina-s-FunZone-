/obj/projectile
	var/fat_added = 0		// GS13 - allow EVERY projectile to be fattening. Only good things can come from this

/obj/projectile/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()

	if (. == BULLET_ACT_BLOCK)
		return .

	if (iscarbon(target))
		var/mob/living/carbon/carbon_target = target
		carbon_target.adjust_fatness(fat_added, FATTENING_TYPE_WEAPON)
	
	return .