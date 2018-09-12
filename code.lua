-- /raidinfo is no longer broken but I've grown used to the text version


local function bonusText(role)
  local currentRole = GetSpecializationRole(GetSpecialization())
  if currentRole == role then
    return "|CFF00FF00"..role.."|r"
  else
    return "|CFFFFFF00"..role.."|r"
  end
end


local function shortageBonusRoles(id)
    local eligible, forTank, forHealer, forDamage, itemCount, money, xp =
      GetLFGRoleShortageRewards(id, LFG_ROLE_SHORTAGE_RARE)
    local canBeTank, canBeHealer, canBeDamager = C_LFGList.GetAvailableRoles()

    local bonuses = {}

    -- Some types (i.e. legion normal?) may have a shortage but not actually
    -- give any rewards
    if eligible and (itemCount > 0 or money > 0 or xp > 0) then
      if forTank and canBeTank then
        table.insert(bonuses, bonusText("TANK"))
      elseif forHealer and canBeHealer then
        table.insert(bonuses, bonusText("HEALER"))
      elseif forDamage and canBeDamager then
        table.insert(bonuses, bonusText("DAMAGER"))
      end
    end

    return table.concat(bonuses, " ")
end


SLASH_JRI_RAIDINFO1 = '/ri'
function SlashCmdList.JRI_RAIDINFO(msg, editbox)
  -- It's likely this information won't be correct until the next call
  RequestRaidInfo()
  RequestLFDPlayerLockInfo()

  -- Traditional instances - shown in /raidinfo
  for i = 1, GetNumSavedInstances() do
    local _, _, _, _, locked, _, _, _, _, difficultyName, maxBosses,
      defeatedBosses = GetSavedInstanceInfo(i)
    if locked then
      print(difficultyName .. " " .. GetSavedInstanceChatLink(i) ..
            " (" .. defeatedBosses .. "/" .. maxBosses .. ")")
    end
  end

  -- World bosses. Does not work for Legion
  for i = 1, GetNumSavedWorldBosses() do
    local name, worldBossID, reset = GetSavedWorldBossInfo(i)
    print(name)
  end

  -- World bosses
  -- Note this tracks the associated world quest, so may not be accurate if for
  -- some reason you kill the boss and the quest is not completed. It shouldn't
  -- give a false negative however.
  local worldBossQuests = {
    52181,  -- t'zane
    52169,  -- ji'arak
    52157,  -- hailstone construct
    52163,  -- azurethos
    52166,  -- warbringer yenajz
    52196   -- dunegorger kraulok
  }
  local worldBossKilled = false
  for _, id in ipairs(worldBossQuests) do
    if IsQuestFlaggedCompleted(id) then
      worldBossKilled = true
      print(GetQuestLink(id))
    end
  end
  if not worldBossKilled then
    print("|CFFFF0000World boss|r")
  end
  do
    -- Attempt to determine which world boss is up
    local zones = {
      875,  -- zandalar
      876,  -- kul'tiras
      14    -- arathi highlands
    }
    for _, mapId in ipairs(zones) do
      local quests = C_TaskQuest.GetQuestsForPlayerByMapID(mapId)
      for _, q in ipairs(quests) do
        local _, _, _, rarity, isElite, _ = GetQuestTagInfo(q.questId)
        if rarity == LE_WORLD_QUEST_QUALITY_EPIC and isElite then
          print("|CFFFF0000Epic elite world quest:|r "..GetQuestLink(q.questId))
        end
      end
    end
  end

  -- Raid Finder
  for i = 1, GetNumRFDungeons() do
    local dungeonInfo = { GetRFDungeonInfo(i) }
    local id = dungeonInfo[1]
    local name = dungeonInfo[2]
    local isAvailable, _ = IsLFGDungeonJoinable(id)
    if isAvailable then
      local numEncounters, numCompleted = GetLFGDungeonNumEncounters(id)
      local color = numCompleted < numEncounters and "|CFFFF0000" or ""
      local out = "LFR "..name..": "..color..numCompleted.."|r/"..numEncounters

      local bonuses = shortageBonusRoles(id)
      if string.len(bonuses) > 0 then
        out = out.." ("..bonuses..")"
      end

      print(out)
    end
  end

  -- Daily heroic
  local bestChoice = GetRandomDungeonBestChoice()
  do
    local id = bestChoice
    local dungeonInfo = { GetLFGDungeonInfo(id) }
    local name = dungeonInfo[1]
    local isAvailable, _ = IsLFGDungeonJoinable(id)
    if isAvailable then
      local doneToday, _ = GetLFGDungeonRewards(id)
      local color = not doneToday and "|CFFFF0000" or ""
      local out = color..name.."|r"

      local bonuses = shortageBonusRoles(id)
      if string.len(bonuses) > 0 then
        out = out.." ("..bonuses..")"
      end

      print(out)
    end
  end

  -- Other LFD dungeons - with shortage only
  for i = 1, GetNumRandomDungeons() do
    local id, name = GetLFGRandomDungeonInfo(i)
    local isAvailable, _ = IsLFGDungeonJoinable(id)
    if isAvailable and id ~= bestChoice then
      local bonuses = shortageBonusRoles(id)
      if string.len(bonuses) > 0 then
        print(name.." ("..bonuses..")")
      end
    end
  end
end
