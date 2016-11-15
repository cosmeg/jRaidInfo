-- /raidinfo is no longer broken but I've grown used to the text version

SLASH_JRI_RAIDINFO1 = '/ri'
function SlashCmdList.JRI_RAIDINFO(msg, editbox)
  for i = 1, GetNumSavedInstances() do
    local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig, isRaid, maxPlayers, difficultyName, maxBosses, defeatedBosses = GetSavedInstanceInfo(i)
    if locked then
      print(difficultyName .. " " .. GetSavedInstanceChatLink(i) ..
            " (" .. defeatedBosses .. "/" .. maxBosses .. ")")
    end
  end

  for i = 1, GetNumSavedWorldBosses() do
    local name, worldBossID, reset = GetSavedWorldBossInfo(i)
    print(name)
  end

  --[[
  -- Uncomment to list IDs, for below
  local accountExpansionLevel = GetAccountExpansionLevel()
  for i = 1, GetNumRFDungeons() do
    local id, name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, bonusRepAmount, minPlayers = GetRFDungeonInfo(i)
    if expansionLevel == accountExpansionLevel then
      local isAvailable, isAvailableToPlayer, hideIfUnmet = IsLFGDungeonJoinable(id)
      print(id.." - "..typeID..":"..subtypeID.." - "..name.." "..tostring(isAvailable))
    end
  end
  ]]

  local wings = {
    {type="LFR", id=1287, size=3},  -- Darkbough
    {type="LFR", id=1288, size=3},  -- Tormented Guardians
    {type="LFR", id=1289, size=1},  -- Rift of Aln
    {type="LFR", id=1411, size=3},  -- Trial of Valor
    {type="LFR", id=1290, size=3},  -- Arcing Aqueducts
    {type="LFR", id=1291, size=3},  -- Royal Athenaeum
    {type="LFR", id=1292, size=3},  -- Nightspire
    {type="LFR", id=1293, size=1}  -- Betrayer's Rise
  }
  for i, t in ipairs(wings) do
    local isAvailable, _, _ = IsLFGDungeonJoinable(t.id)
    if isAvailable then
      local dungeonName, typeId, subtypeID, minLvl, maxLvl, recLvl, minRecLvl, maxRecLvl, expansionId, groupId, textureName, difficulty, maxPlayers, dungeonDesc, isHoliday, repAmount, forceHide = GetLFGDungeonInfo(t.id)
      local numEncounters, numCompleted = GetLFGDungeonNumEncounters(t.id)
      local color = numCompleted < t.size and "|CFFFF0000" or ""

      print(t.type.." "..dungeonName..": "..color..numCompleted.."|r/"..t.size)
    end
  end
end
