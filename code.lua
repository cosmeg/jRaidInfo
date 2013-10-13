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
    {type="Flex", id=726, size=4},
    {type="Flex", id=728, size=4},
    {type="Flex", id=729, size=3},
    --{type="Flex", id=730, size=3}
    {type="LFR", id=716, size=4},
    {type="LFR", id=717, size=4},
    {type="LFR", id=724, size=3}
    --{type="LFR", id=725, size=3}
  }
  for i, t in ipairs(flex_ids) do
    local dungeonName, typeId, subtypeID, minLvl, maxLvl, recLvl, minRecLvl, maxRecLvl, expansionId, groupId, textureName, difficulty, maxPlayers, dungeonDesc, isHoliday, repAmount, forceHide = GetLFGDungeonInfo(t.id)
    local numEncounters, numCompleted = GetLFGDungeonNumEncounters(t.id)
    print (t.type.." "..dungeonName..": "..numCompleted.."/"..t.size)
  end
end
