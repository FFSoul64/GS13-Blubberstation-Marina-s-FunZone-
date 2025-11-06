/obj/item/gun/energy/fatoray/weak/cyborg
	name = "cyborg fatoray"
	desc = "An integrated fatoray for cyborg use."
	icon = 'modular_gs/icons/obj/weapons/fatoray.dmi'
	icon_state = "fatoray_weak"
	can_charge = FALSE
	selfcharge = EGUN_SELFCHARGE_BORG
	cell_type = /obj/item/stock_parts/cell/secborg
	charge_delay = 5

/obj/item/borg/upgrade/fatoray
	name = "cyborg fatoray module"
	desc = "An extra module that allows cyborgs to use fatoray weapons."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/fatoray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/fatoray/weak/cyborg/S = new(R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/fatoray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/fatoray/weak/cyborg/S = locate() in R.module
		R.module.remove_module(S, TRUE)
