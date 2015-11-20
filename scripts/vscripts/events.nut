/**
 * Called when a player leaves the start area
 *
 * NOTA: it seems to be called only when leaving the shelter of the first played map
 */
function OnGameEvent_player_left_start_area(params)
{
    ::ADV_STATS_LOGGER.debug("Event player_left_start_area");

	clearHUD();
}

/**
 * Called when a player leaves a checkpoint
 *
 * NOTA: this function seems to be called when survivors spawn inside shelter,
 *       which is not helpful for clearing the HUD
 */
function OnGameEvent_player_left_checkpoint(params)
{
	::ADV_STATS_LOGGER.debug("Event player_left_checkpoint");

	if (Director.HasAnySurvivorLeftSafeArea())
		clearHUD();
}

function OnGameEvent_finale_vehicle_ready(params)
{
	::ADV_STATS_LOGGER.debug("Event finale_vehicle_ready");
	
	::AdvStats.finale_win = true;
	
	showHUD();
}

function OnGameEvent_finale_escape_start(params)
{
	::ADV_STATS_LOGGER.debug("Event finale_escape_start");
	
	::AdvStats.finale_win = true;
	
	showHUD();
}

function OnGameEvent_finale_win(params)
{
	::ADV_STATS_LOGGER.debug("Event finale_win");
	
	::AdvStats.finale_win = true;
	
	showHUD();

	AdvStatsDebug()
}

/**
 * Hook before round starts
 */
function OnGameEvent_round_start_post_nav(params)
{
	::ADV_STATS_LOGGER.debug("Event round_start_post_nav");
	
	::AdvStats.load()
	
	showHUD()
	
	AdvStatsDebug()
}

/**
 * Hook when round ends
 */
function OnGameEvent_map_transition(params)
{
	::ADV_STATS_LOGGER.debug("Event map_transition");
	
	::AdvStats.save()
	
	AdvStatsDebug()
}

/**
 * Hook when round ends
 */
function OnGameEvent_mission_lost(params)
{
	::ADV_STATS_LOGGER.debug("Event mission_lost");
	
	::AdvStats.save()
	
	AdvStatsDebug()
}

/**
 * Hook when round ends
 */
function OnGameEvent_round_end(params)
{
	::ADV_STATS_LOGGER.debug("Event round_end");
	
	::AdvStats.save()
	
	AdvStatsDebug()
}

/**
 * Called when an infected (infected, witch) is hurt
 */
function OnGameEvent_infected_hurt(params)
{
	::ADV_STATS_LOGGER.debug("Event infected_hurt");

	if (::AdvStats.finale_win == true)
		return;

	if (!("attacker" in params && params.attacker != 0))
		return

	local victim = EntIndexToHScript(params.entityid)

	if (victim.GetClassname() != "witch")
		return
	
	local attacker = GetPlayerFromUserID(params.attacker)
	if (!attacker.IsSurvivor())
		return
	
	local sAttName = attacker.GetPlayerName()
	
	// We don't want to store stats for bots
	if (::AdvStats.isBot(sAttName))
		return;

	::ADV_STATS_LOGGER.debug("Witch Hurt", params)
	//DeepPrintTable(params)
	
	::ADV_STATS_LOGGER.info(sAttName + " dealt " + params.amount + " to Witch")
	
	::AdvStats.initPlayerCache(sAttName);
	::AdvStats.cache[sAttName].dmg.witches += params.amount
}

/**
 * Called when a player is dead
 *
 * NOTA: this event is also fired when a special infected die
 */
function OnGameEvent_player_death(params)
{
    ::ADV_STATS_LOGGER.debug("Event player_death");

	if (::AdvStats.finale_win == true)
		return;

	// We want only TK and killed SI
	//if (!("userid" in params && "attacker" in params && params.attacker != 0))
	if (params.attackerisbot == 1)
		return

	// We want only players kills
	local attacker = GetPlayerFromUserID(params.attacker)
	if (!attacker.IsSurvivor())
		return

	if (params.victimname == "Infected")
		return;

	::ADV_STATS_LOGGER.debug("Player Death", params)
	//DeepPrintTable(params)
	
	local victim = GetPlayerFromUserID(params.userid)
 	::ADV_STATS_LOGGER.debug("Victim's PlayerName:" + victim.GetPlayerName());

	//if (!victim.IsSurvivor())
	//	return

	local sAttName = attacker.GetPlayerName()//GetCharacterDisplayName(attacker)

	// We don't want to store stats for bots
	//if (::AdvStats.isBot(sAttName)) // NO NEED, already taken care of with params.attackerisbot
	//	return;

	local sVicName = victim.GetPlayerName()//GetCharacterDisplayName(victim)

	::ADV_STATS_LOGGER.info(sAttName + " killed " + sVicName);

	// TK
	if (victim.IsSurvivor())
	{
		::AdvStats.initPlayerCache(sAttName);
		if (!(sVicName in ::AdvStats.cache[sAttName].ff.tk))
			::AdvStats.cache[sAttName].ff.tk[sVicName] <- 0
		::AdvStats.cache[sAttName].ff.tk[sVicName] += 1
	}
	else
	{
		// Special Infected killed
		if (::AdvStats.isSpecialInfected(sVicName))
		{
			::AdvStats.initPlayerCache(sAttName);
			::AdvStats.cache[sAttName].specials.kills += 1
			if (params.headshot == 1)
				::AdvStats.cache[sAttName].specials.kills_hs += 1
		}
	}

	//AdvStatsDebug();
}

/**
 * Called when a player is incapacitated
 */
function OnGameEvent_player_incapacitated(params)
{
    ::ADV_STATS_LOGGER.debug("Event player_incapacitated");

	if (::AdvStats.finale_win == true)
		return;

	// We want only incap dealt by survivors
	if (!("userid" in params && "attacker" in params && params.attacker != 0))
		return
		
	local attacker = GetPlayerFromUserID(params.attacker)
	if (!attacker.IsSurvivor())
		return

	local victim = GetPlayerFromUserID(params.userid)
	if (!victim.IsSurvivor())
		return
	local sAttName = attacker.GetPlayerName()

	// We don't want to store stats for bots
	if (::AdvStats.isBot(sAttName))
		return;
	
	local sVicName = victim.GetPlayerName()

	::ADV_STATS_LOGGER.debug("Player Incapacitated", params)
	//DeepPrintTable(params)

	//FireGameEvent("game_message", {target = 1, text = sAttName + " incapacitatedss " + sVicName})
	//ShowMessage(sAttName + " incapacitatedss " + sVicName)

	::ADV_STATS_LOGGER.info(sAttName + " incapacitated " + sVicName);
	
	::AdvStats.initPlayerCache(sAttName);
	if (!(sVicName in ::AdvStats.cache[sAttName].ff.incap))
		::AdvStats.cache[sAttName].ff.incap[sVicName] <- 0
	::AdvStats.cache[sAttName].ff.incap[sVicName] += 1
}

/**
 * Called when a player got hurt
 */
function OnGameEvent_player_hurt(params)
{
	::ADV_STATS_LOGGER.debug("Event player_hurt");

	if (::AdvStats.finale_win == true)
		return;

	if (!params.rawin("userid") || ((!params.rawin("attackerentid") || params.attackerentid == 0) && params.attacker == 0))
		return

	::ADV_STATS_LOGGER.debug("Player hurt", params);
	
	local victim = GetPlayerFromUserID(params.userid)
	local sVicName = victim.GetPlayerName()

	::ADV_STATS_LOGGER.debug("Victim name: " + sVicName);
	
	// Not hit by a player (survivor, special infected, tank)
	if (!("attacker" in params && params.attacker != 0))
	{
		// We don't want to store stats for bots
		if (::AdvStats.isBot(sVicName))
			return;

		// Player hit by an infected or witch
		if ("attackerentid" in params && params.attackerentid != 0 && victim.IsSurvivor())
		{
			local infAttacker = EntIndexToHScript(params.attackerentid)
			// Do not count hits when we are incapacitated
			if (infAttacker.GetClassname() == "infected" && params.dmg_health != 0 && !victim.IsIncapacitated())
			{
				::ADV_STATS_LOGGER.info(sVicName + " got hit by an infected for " + params.dmg_health + " points");
				::AdvStats.initPlayerCache(sVicName);
				::AdvStats.cache[sVicName].hits.infected += 1;
			}
		}

		return
	}
	
	local attacker = GetPlayerFromUserID(params.attacker)
	local sAttName = attacker.GetPlayerName();
	
	// Damage dealt by special infected. Beware: special infected are also Players
	if (!(::AdvStats.isBot(sVicName)) && !(::AdvStats.isSpecialInfected(sVicName)) && ::AdvStats.isSpecialInfected(sAttName) && params.dmg_health != 0 && !victim.IsIncapacitated())
	{
		::ADV_STATS_LOGGER.info(sVicName + " received damage by a " + sAttName + " for " + params.dmg_health + " points");
		::AdvStats.initPlayerCache(sVicName);
		::AdvStats.cache[sVicName].hits.si_dmg += params.dmg_health;
		::AdvStats.cache[sVicName].hits.si_hits += 1;
		
		return;
	}

	//
	// From now on we only take care with damage dealt by survivors
	//
	if (!attacker.IsSurvivor()) {
		::ADV_STATS_LOGGER.debug("Attacker not a survivor!");
		return;
	}

	local sAttName = attacker.GetPlayerName()//GetCharacterDisplayName(attacker)

	// We don't want to store stats for bots
	if (::AdvStats.isBot(sAttName))
		return;

	//
	// Damage to tanks
	//
	if (!victim.IsSurvivor())
	{
		if (sVicName == "Tank")
		{
			::ADV_STATS_LOGGER.info(sAttName + " dealt " + params.dmg_health + " to Tank");
			
			::AdvStats.initPlayerCache(sAttName);
			::AdvStats.cache[sAttName].dmg.tanks += params.dmg_health
		}
		else
		{
			// Damage to Special Infected
			if (::AdvStats.isSpecialInfected(sVicName))
			{
				::AdvStats.initPlayerCache(sAttName);
				::AdvStats.cache[sAttName].specials.dmg += params.dmg_health
			}
		}

		return
	}
	
	//
	// Damage to other players
	//
	::ADV_STATS_LOGGER.info(sAttName + " hurt " + sVicName + " for " + params.dmg_health + " HP");

	::AdvStats.initPlayerCache(sAttName);
	if (!(sVicName in ::AdvStats.cache[sAttName].ff.dmg))
		::AdvStats.cache[sAttName].ff.dmg[sVicName] <- 0
	::AdvStats.cache[sAttName].ff.dmg[sVicName] += params.dmg_health
}