-- /raidinfo is no longer broken but I've grown used to the test version
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

  for i = 1, GetNumRFDungeons() do
    local id, name, typeID, subtype, minLevel, maxLevel, level3, level4, level5, result09, result10, result11, name2, result13, raidSize, description, result16, result17, result18 = GetRFDungeonInfo(i)
    local numEncounters, numCompleted = GetLFGDungeonNumEncounters(id);
    -- https://github.com/tekkub/wow-ui-source/blob/233e69aa6e44523d3b439c16b91013362059328e/FrameXML/LFGFrame.lua#L1553
    -- not sure if there's a good way to show the bosses I *haven't* looted
    for j = 1, numEncounters do
      local bossName, texture, isKilled = GetLFGDungeonEncounterInfo(id, j)
      if isKilled then
        print(name .. ": " .. bossName)
      end
    end
  end
end
