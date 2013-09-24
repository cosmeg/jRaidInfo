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
end
