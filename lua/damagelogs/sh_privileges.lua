-- edit the privileges on config/config.lua

local function checkSettings(self, value)
	if value == 1 or value == 2 then
		return GetRoundState() != ROUND_ACTIVE
	elseif value == 3 then
		return GetRoundState() != ROUND_ACTIVE or self:IsSpec()
	elseif value == 4 then
		return true
	end
	return false
end


local meta = FindMetaTable("Player")

function meta:CanUseDamagelog()
	for k,v in pairs(Damagelog.User_rights) do
		if self:IsUserGroup(k) then
			return checkSettings(self, v)
		end
	end
	return checkSettings(self, 2)
end

if SERVER then
	-- Needs to be called in Initialize hook, because damagelog addon is loaded before ULib, thus causing errors
	hook.Add("Initialize", "DamagelogsAddULXAccessString", function()
		if ulx then
			ULib.ucl.registerAccess( "ulx seerdmmanager", ULib.ACCESS_ADMIN, "Allows the user to manage RDMs", "Other" )
		end
	end)
end

function meta:CanUseRDMManager()
	for k,v in pairs(Damagelog.RDM_Manager_Rights) do
		if self:IsUserGroup(k) then
			return v
		end
	end
	return false
end
