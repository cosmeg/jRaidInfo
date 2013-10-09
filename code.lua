-- /raidinfo is no longer broken but I've grown used to the text version

SLASH_JRI_RAIDINFO1 = '/ri'
function SlashCmdList.JRI_RAIDINFO(msg, editbox)
  for i = 1, GetNumSavedInstances() do
    local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(i)
    if locked and isRaid then
      print(GetSavedInstanceChatLink(i) ..
            " (" .. defeatedBosses .. "/" .. maxBosses .. ")")
    end
  end

  for i = 1, GetNumSavedWorldBosses() do
    local name, worldBossID, reset = GetSavedWorldBossInfo(i)
    print(name)
  end

  local flex_ids = {
    726,
    728,
    729,
    --730
  }
  for i, id in ipairs(flex_ids) do
    local dungeonName, typeId, subtypeID, minLvl, maxLvl, recLvl, minRecLvl, maxRecLvl, expansionId, groupId, textureName, difficulty, maxPlayers, dungeonDesc, isHoliday, repAmount, forceHide = GetLFGDungeonInfo(id)
    local numEncounters, numCompleted = GetLFGDungeonNumEncounters(id)
    print ("Flex " .. dungeonName .. ": " .. numCompleted .. "/4" )
  end

  local lfr_ids = {
    716,
    717,
    724,
    --725
  }
  for i, id in ipairs(lfr_ids) do
    local dungeonName, typeId, subtypeID, minLvl, maxLvl, recLvl, minRecLvl, maxRecLvl, expansionId, groupId, textureName, difficulty, maxPlayers, dungeonDesc, isHoliday, repAmount, forceHide = GetLFGDungeonInfo(id)
    local numEncounters, numCompleted = GetLFGDungeonNumEncounters(id)
    print ("LFR " .. dungeonName .. ": " .. numCompleted .. "/4" )
  end
end
