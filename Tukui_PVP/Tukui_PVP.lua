local T, C, L = Tukui:unpack()

local DataText = T["DataTexts"]
local GetPVPLifetimeStats = GetPVPLifetimeStats
local KILLS = KILLS

local OnEnter = function(self)
	GameTooltip:SetOwner(self:GetTooltipAnchor())
	
	local HK, DK = GetPVPSessionStats()
	local Rank = UnitPVPRank("player")
	
	if (Rank > 0) then
		local Name, Number = GetPVPRankInfo(Rank, "player")
		
		DT.tooltip:AddDoubleLine(Name, format("%s %s", RANK, Number))
		DT.tooltip:AddLine(" ")
	end
	
	if (HK > 0) then
		DT.tooltip:AddLine(HONOR_TODAY)
		DT.tooltip:AddDoubleLine(HONORABLE_KILLS, T.Comma(HK), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddDoubleLine(DISHONORABLE_KILLS, T.Comma(DK), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddLine(" ")
	end
	
	HK, DK = GetPVPLifetimeStats()
	
	if (HK > 0) then
		DT.tooltip:AddLine(HONOR_LIFETIME)
		DT.tooltip:AddDoubleLine(HONORABLE_KILLS, T.Comma(HK), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddDoubleLine(DISHONORABLE_KILLS, T.Comma(DK), 1, 1, 1, 1, 1, 1)
	end
	
	GameTooltip:Show()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local OnMouseUp = function()
	if T.Classic then
		ToggleCharacter("HonorFrame")
	elseif T.WotLK then
		TogglePVPFrame()
	else
		ToggleCharacter("PVPFrame")
	end
end

local Update = function(self)
	self.Text:SetFormattedText("%s%s:|r %s%s|r", DataText.NameColor, KILLS, DataText.ValueColor, T.Comma(GetPVPLifetimeStats()))
end

local Enable = function(self)
	self:RegisterEvent("PLAYER_PVP_KILLS_CHANGED")
	self:SetScript("OnEvent", Update)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:SetScript("OnMouseUp", OnMouseUp)
	
	self:Update()
end

local Disable = function(self)
	self:UnregisterEvent("PLAYER_PVP_KILLS_CHANGED")
	self:SetScript("OnEvent", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseUp", nil)
	
	self.Text:SetText("")
end

DataText:Register(PVP, Enable, Disable, Update)