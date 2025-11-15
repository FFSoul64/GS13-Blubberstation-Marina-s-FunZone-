#define CHOICE_TRANSFER "Initiate Crew Transfer"
#define CHOICE_CONTINUE "Continue Playing"

/datum/vote/transfer_vote/tiebreaker(list/winners)
	return CHOICE_CONTINUE

#undef CHOICE_TRANSFER
#undef CHOICE_CONTINUE
