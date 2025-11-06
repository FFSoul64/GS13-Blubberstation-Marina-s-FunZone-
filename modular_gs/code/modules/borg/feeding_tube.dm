//cyborg regen feeding tube

/obj/item/reagent_containers/borghypo/feeding_tube
	name = "cyborg feeding tube"
	desc = "A feeding tube module for a cyborg."
	icon = 'modular_gs/icons/obj/feeding_tube.dmi'
	icon_state = "borg_tube"
	possible_transfer_amounts = list(5,10,20)
	charge_cost = 20
	recharge_time = 3
	reagent_ids = list(/datum/reagent/consumable/cream, /datum/reagent/consumable/milk, /datum/reagent/consumable/nutriment)
	var/starttime = 0
	var/chemtoadd = 5

/obj/item/reagent_containers/borghypo/feeding_tube/attack(mob/living/carbon/M, mob/user)
	var/datum/reagents/R = reagent_list[mode]
	if(!R.total_volume)
		to_chat(user, "<span class='notice'>The injector is empty.</span>")
		return
	if(!istype(M))
		return
	if(R.total_volume && M.can_inject(user, 1, user.zone_selected,bypass_protection))

		if(M == user.pulling && ishuman(user.pulling))
			starttime = world.time
			while(starttime + 300 > world.time && in_range(user, M))
				if(do_mob(user, M, 10, 0, 1))
					M.reagents.add_reagent(/datum/reagent/consumable/nutriment, chemtoadd)
					M.visible_message("<span class='danger'>[user] pumps some liquid in [M]!</span>","<span class='userdanger'>[user] pumps some liquid in you!</span>")
		else
			to_chat(M, "<span class='warning'>You feel the cyborg's feeding tube pour liquid down your throat!</span>")
			to_chat(user, "<span class='warning'>You feed [M] with the integrated feeding tube.</span>")
			visible_message("<span class='warning'>The cyborg's feeding tube pours liquid down [M]'s throat!</span>")
			var/fraction = min(amount_per_transfer_from_this/R.total_volume, 1)
			R.reaction(M, INJECT, fraction)
			if(M.reagents)
				var/trans = R.trans_to(M, amount_per_transfer_from_this)
				to_chat(user, "<span class='notice'>[trans] unit\s injected.  [R.total_volume] unit\s remaining.</span>")

/obj/item/reagent_containers/borghypo/feeding_tube/regenerate_reagents()
	if(iscyborg(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		if(R && R.cell)
			for(var/i in modes) //Lots of reagents in this one, so it's best to regenrate them all at once to keep it from being tedious.
				var/valueofi = modes[i]
				var/datum/reagents/RG = reagent_list[valueofi]
				if(RG.total_volume < RG.maximum_volume)
					R.cell.use(charge_cost)
					RG.add_reagent(reagent_ids[valueofi], 5)


/obj/item/borg/upgrade/feedtube
	name = "cyborg feeding tube module"
	desc = "An extra module that allows cyborgs to use an integrated feeding tube along with a synthesizer."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/feedtube/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/reagent_containers/borghypo/feeding_tube/S = new(R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/feedtube/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/reagent_containers/borghypo/feeding_tube/S = locate() in R.module
		R.module.remove_module(S, TRUE)
