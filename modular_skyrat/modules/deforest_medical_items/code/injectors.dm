// Pen basetype where the icon is gotten from

/obj/item/reagent_containers/hypospray/medipen/deforest
	name = "non-functional Deforest autoinjector"
	desc = "A Deforest branded autoinjector, though this one seems to be both empty and non-functional."
	icon = 'modular_skyrat/modules/deforest_medical_items/icons/injectors.dmi'
	icon_state = "default"
	volume = 20
	list_reagents = list()
	/// If this pen has a timer for injecting others with, just for safety with some of the drugs in these
	var/inject_others_time = 1.5 SECONDS

/obj/item/reagent_containers/hypospray/medipen/deforest/Initialize(mapload)
	. = ..()
	amount_per_transfer_from_this = volume

/obj/item/reagent_containers/hypospray/medipen/deforest/inject(mob/living/affected_mob, mob/user)
	if(!reagents.total_volume)
		to_chat(user, span_warning("[src] is empty!"))
		return FALSE
	if(!iscarbon(affected_mob))
		return FALSE

	if((affected_mob != user) && inject_others_time)
		affected_mob.visible_message(span_danger("[user] is trying to inject [affected_mob]!"), \
				span_userdanger("[user] is trying to inject something into you!"))
		if(!do_after(user, CHEM_INTERACT_DELAY(inject_others_time, user), affected_mob))
			return FALSE

	//Always log attemped injects for admins
	var/list/injected = list()
	for(var/datum/reagent/injected_reagent in reagents.reagent_list)
		injected += injected_reagent.name
	var/contained = english_list(injected)
	log_combat(user, affected_mob, "attempted to inject", src, "([contained])")

	if(reagents.total_volume && (ignore_flags || affected_mob.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))) // Ignore flag should be checked first or there will be an error message.
		to_chat(affected_mob, span_warning("You feel a tiny prick!"))
		to_chat(user, span_notice("You inject [affected_mob] with [src]."))
		if(!stealthy)
			playsound(affected_mob, 'sound/items/hypospray.ogg', 50, TRUE)
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)

		if(affected_mob.reagents)
			var/trans = 0
			if(!infinite)
				trans = reagents.trans_to(affected_mob, amount_per_transfer_from_this, transferred_by = user, methods = INJECT)
			else
				reagents.expose(affected_mob, INJECT, fraction)
				trans = reagents.copy_to(affected_mob, amount_per_transfer_from_this)
			to_chat(user, span_notice("[trans] unit\s injected. [reagents.total_volume] unit\s remaining in [src]."))
			log_combat(user, affected_mob, "injected", src, "([contained])")
		return TRUE
	return FALSE

// Sensory restoration, heals eyes and ears with a bit of impurity

/obj/item/reagent_containers/hypospray/medipen/deforest/occuisate
	name = "occuisate sensory restoration injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of reagents to restore your vision and hearing to operation."
	icon_state = "occuisate"
	list_reagents = list(
		/datum/reagent/medicine/inacusiate = 7,
		/datum/reagent/medicine/oculine = 7,
		/datum/reagent/impurity/inacusiate = 3,
		/datum/reagent/inverse/oculine = 3,
	)

// Adrenaline, fills you with determination (and also stimulants)

/obj/item/reagent_containers/hypospray/medipen/deforest/adrenaline
	name = "adrenaline injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of reagents to intentionally give yourself fight or flight on demand."
	icon_state = "adrenaline"
	list_reagents = list(
		/datum/reagent/medicine/stimulants= 5,
		/datum/reagent/medicine/inaprovaline = 5,
		/datum/reagent/determination = 10,
	)

// Morpital, heals a small amount of damage and kills pain for a bit

/obj/item/reagent_containers/hypospray/medipen/deforest/morpital
	name = "morpital regenerative stimulant injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of reagents to numb pain and repair small amounts of physical damage."
	icon_state = "morpital"
	list_reagents = list(
		/datum/reagent/medicine/morphine = 5,
		/datum/reagent/impurity/healing/medicine_failure = 15,
	)

// Lipital, heals more damage than morpital but doesnt work much at higher damages

/obj/item/reagent_containers/hypospray/medipen/deforest/lipital
	name = "lipital regenerative stimulant injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of reagents to numb pain and repair small amounts of physical damage. \
		Works most effectively against lower amounts of physical damage."
	icon_state = "lipital"
	list_reagents = list(
		/datum/reagent/medicine/lidocaine = 5,
		/datum/reagent/medicine/granibitaluri = 15,
	)

// Anti-poisoning injector, with a little bit of radiation healing as a treat

/obj/item/reagent_containers/hypospray/medipen/deforest/meridine
	name = "meridine antidote injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of reagents to serve as antidote to most galactic toxins."
	icon_state = "meridine"
	list_reagents = list(
		/datum/reagent/medicine/ammoniated_mercury = 10,
		/datum/reagent/medicine/potass_iodide = 10,
	)

// Epinephrine and helps a little bit against stuns and stamina damage

/obj/item/reagent_containers/hypospray/medipen/deforest/synephrine
	name = "synephrine emergency stimulant injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of reagents to stabilize critical condition and recover from stamina deficits."
	icon_state = "synephrine"
	list_reagents = list(
		/datum/reagent/medicine/epinephrine = 10,
		/datum/reagent/medicine/synaptizine = 5,
		/datum/reagent/medicine/synaphydramine = 5,
	)

// Critical condition stabilizer

/obj/item/reagent_containers/hypospray/medipen/deforest/calopine
	name = "calopine emergency stabilizant injector"
	desc = "A Deforest branded autoinjector, loaded with a stabilizing mix of reagents to repair critical conditions."
	icon_state = "calopine"
	list_reagents = list(
		/datum/reagent/medicine/atropine = 10,
		/datum/reagent/medicine/calomel = 5,
		/datum/reagent/medicine/salbutamol = 5,
	)

// Coagulant, really not a whole lot more

/obj/item/reagent_containers/hypospray/medipen/deforest/coagulants
	name = "coagulant-S injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of coagulants to prevent and stop bleeding."
	icon_state = "coagulant"
	list_reagents = list(
		/datum/reagent/medicine/coagulant = 10,
		/datum/reagent/medicine/coagulant/seraka_extract = 5,
		/datum/reagent/medicine/salglu_solution = 5,
	)

// Stimulant centered around ondansetron

/obj/item/reagent_containers/hypospray/medipen/deforest/krotozine
	name = "krotozine manipulative stimulant injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of stimulants of weak healing agents."
	icon_state = "krotozine"
	list_reagents = list(
		/datum/reagent/medicine/ondansetron = 5,
		/datum/reagent/drug/kronkaine = 5,
		/datum/reagent/medicine/omnizine/protozine = 10,
	)

// You ever needed to juice on stims to exercise harder? No? Do you want to?

/obj/item/reagent_containers/hypospray/medipen/deforest/vitatate
	name = "vitatate supplement injector"
	desc = "A Deforest branded autoinjector, loaded with an unusual mix of reagents that many claim increase exercise and physical performance in general."
	icon_state = "vitatate"
	list_reagents = list(
		/datum/reagent/drug/pumpup = 5,
		/datum/reagent/toxin/leadacetate = 5,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)

// Stuff really good at healing burn stuff and stabilizing temps

/obj/item/reagent_containers/hypospray/medipen/deforest/lepoturi
	name = "lepoturi burn treatment injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of medicines to rapidly treat burns."
	icon_state = "lepoturi"
	list_reagents = list(
		/datum/reagent/medicine/mine_salve = 5,
		/datum/reagent/medicine/leporazine = 5,
		/datum/reagent/medicine/c2/lenturi = 10,
	)

// Stabilizes a lot of stats like drowsiness, sanity, dizziness, so on

/obj/item/reagent_containers/hypospray/medipen/deforest/psifinil
	name = "psifinil personal recovery injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of medicines to remedy many common ailments, such as drowsiness, pain, instability, the like."
	icon_state = "psifinil"
	list_reagents = list(
		/datum/reagent/medicine/modafinil = 10,
		/datum/reagent/medicine/psicodine = 10,
	)

// Helps with liver failure and some drugs, also alcohol

/obj/item/reagent_containers/hypospray/medipen/deforest/halobinin
	name = "halobinin soberant injector"
	desc = "A Deforest branded autoinjector, loaded with a mix of medicines to remedy the effects of liver failure and common drugs."
	icon_state = "halobinin"
	list_reagents = list(
		/datum/reagent/medicine/haloperidol = 5,
		/datum/reagent/medicine/antihol = 5,
		/datum/reagent/medicine/higadrite = 5,
		/datum/reagent/medicine/silibinin = 5,
	)
