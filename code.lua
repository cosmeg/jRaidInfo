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
    local _, forTank, forHealer, forDamage, _ =
      GetLFGRoleShortageRewards(id, LFG_ROLE_SHORTAGE_RARE)
    local canBeTank, canBeHealer, canBeDamager = C_LFGList.GetAvailableRoles()

    local bonuses = {}

    if forTank and canBeTank then
      table.insert(bonuses, bonusText("TANK"))
    elseif forHealer and canBeHealer then
      table.insert(bonuses, bonusText("HEALER"))
    elseif forDamage and canBeDamager then
      table.insert(bonuses, bonusText("DAMAGER"))
    end

    return table.concat(bonuses, " ")
end


SLASH_JRI_RAIDINFO1 = '/ri'
function SlashCmdList.JRI_RAIDINFO(msg, editbox)
  -- It's likely this information won't be correct until the next call
  RequestRaidInfo()

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

  -- Raid Finder
  for i = 1, GetNumRFDungeons() do
    local dungeonInfo = { GetRFDungeonInfo(i) }
    local id = dungeonInfo[1]
    local name = dungeonInfo[2]
    local isAvailable, _, _ = IsLFGDungeonJoinable(id)
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
end
