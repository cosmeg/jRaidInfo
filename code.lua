-- /raidinfo is no longer broken but I've grown used to the text version

SLASH_JRI_RAIDINFO1 = '/ri'
function SlashCmdList.JRI_RAIDINFO(msg, editbox)
  -- It's likely this information won't be correct until the next call
  RequestRaidInfo()

  for i = 1, GetNumSavedInstances() do
    local _, _, _, _, locked, _, _, _, _, difficultyName, maxBosses,
      defeatedBosses = GetSavedInstanceInfo(i)
    if locked then
      print(difficultyName .. " " .. GetSavedInstanceChatLink(i) ..
            " (" .. defeatedBosses .. "/" .. maxBosses .. ")")
    end
  end

  for i = 1, GetNumSavedWorldBosses() do
    local name, worldBossID, reset = GetSavedWorldBossInfo(i)
    print(name)
  end

  for i = 1, GetNumRFDungeons() do
    local dungeonInfo = { GetRFDungeonInfo(i) }
    local id = dungeonInfo[1]
    local name = dungeonInfo[2]
    local isAvailable, _, _ = IsLFGDungeonJoinable(id)
    if isAvailable then
      local numEncounters, numCompleted = GetLFGDungeonNumEncounters(id)
      local color = numCompleted < numEncounters and "|CFFFF0000" or ""
      print("LFR "..name..": "..color..numCompleted.."|r/"..numEncounters)
    end
  end
end
