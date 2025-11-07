/datum/storyteller/relaxed
	name = "General Station 13 (GS13 Unique)"
	desc = "Go ahead-sit down, grab a bite to eat. What's the worst that could happen? \
	Make sure your gut doesn't get caught on the door when you're running (or waddling) away."
	welcome_text = "Mrrow Mrrow Purr Purr :3."

	track_data = /datum/storyteller_data/tracks/relaxed

	guarantees_roundstart_crewset = FALSE
	tag_multipliers = list(
		TAG_DESTRUCTIVE = 1.2,
		TAG_CHAOTIC = 1.2,
		TAG_POSITIVE = 0.5,
		TAG_COMBAT = 1.1,
		TAG_CREW_ANTAG = 0.1,
		TAG_OUTSIDER_ANTAG = 0.1,
		TAG_TEAM_ANTAG = 0.1 //spawn an antag and I will eat you storyteller
	)
	antag_divisor = 128 //god please let this spawn no antags. Please.
	event_repetition_multiplier = 1 //lowered event totals mean we need to increase the frequency of repetitive events
	storyteller_type = STORYTELLER_TYPE_GS

/datum/storyteller_data/tracks/relaxed
	threshold_mundane = 900
	threshold_moderate = 2700
	threshold_major = 8000
	threshold_crewset = 999999999
	threshold_ghostset = 999999999
