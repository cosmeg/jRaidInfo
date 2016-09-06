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
  for i = 1, GetNumRFDungeons() do
    local id, name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, bonusRepAmount, minPlayers = GetRFDungeonInfo(i)
    if expansionLevel == GetAccountExpansionLevel() then
      print(id.." - "..typeID..":"..subtypeID.." - "..name)
    end
  end
  ]]

  local flex_ids = {
    -- No LFR yet in legion
    --[[
    {type="LFR", id=849, size=3},  -- Walled City
    {type="LFR", id=850, size=3},  -- Arcane Sanctum
    {type="LFR", id=851, size=1},  -- Imperator's Rise
    {type="LFR", id=847, size=3},  -- Slagworks
    {type="LFR", id=846, size=3},  -- The Black Forge
    {type="LFR", id=848, size=3},  -- Iron Assembly
    {type="LFR", id=823, size=1},  -- Blackhand's Crucible
    {type="LFR", id=982, size=3},  -- Hellbreach
    {type="LFR", id=983, size=3},  -- Halls of Blood
    {type="LFR", id=984, size=3},  -- Basion of Shadows
    {type="LFR", id=985, size=3},  -- Destructor's Rise
    {type="LFR", id=986, size=1}   -- The Black Gate
    ]]
  }
  for i, t in ipairs(flex_ids) do
    local dungeonName, typeId, subtypeID, minLvl, maxLvl, recLvl, minRecLvl, maxRecLvl, expansionId, groupId, textureName, difficulty, maxPlayers, dungeonDesc, isHoliday, repAmount, forceHide = GetLFGDungeonInfo(t.id)
    local numEncounters, numCompleted = GetLFGDungeonNumEncounters(t.id)
    local color = numCompleted < t.size and "|CFFFF0000" or ""

    print (t.type.." "..dungeonName..": "..color..numCompleted.."|r/"..t.size)
  end
end
