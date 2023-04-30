local T, C, L = Tukui:unpack()

local DataText = T["DataTexts"]
local GetPVPLifetimeStats = GetPVPLifetimeStats
local KILLS = KILLS

local OnEnter = function(self)
	GameTooltip:SetOwner(self:GetTooltipAnchor())

	local HK = GetPVPSessionStats()
	local LHK = GetPVPLifetimeStats()
	local Rank = UnitPVPRank("player")

	if (Rank > 0) then
		local Name, Number = GetPVPRankInfo(Rank, "player")

		GameTooltip:AddDoubleLine(Name, format("%s %s", RANK, Number))
	end

	if (HK > 0) then
		if (Rank and Rank > 0) then
			GameTooltip:AddLine(" ")
		end

		GameTooltip:AddLine(HONOR_TODAY)
		GameTooltip:AddDoubleLine(HONORABLE_KILLS, T.Comma(HK), 1, 1, 1, 1, 1, 1)
	end

	if (LHK > 0) then
		if (Rank and Rank > 0 and HK == 0) or (HK > 0) then
			GameTooltip:AddLine(" ")
		end

		GameTooltip:AddLine(HONOR_LIFETIME)
		GameTooltip:AddDoubleLine(HONORABLE_KILLS, T.Comma(LHK), 1, 1, 1, 1, 1, 1)
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
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:SetScript("OnEvent", Update)
	self:SetScript("OnEnter", OnEnter)
	self:SetScript("OnLeave", OnLeave)
	self:SetScript("OnMouseUp", OnMouseUp)

	self:Update()
end

local Disable = function(self)
	self:UnregisterEvent("PLAYER_PVP_KILLS_CHANGED")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:SetScript("OnEvent", nil)
	self:SetScript("OnEnter", nil)
	self:SetScript("OnLeave", nil)
	self:SetScript("OnMouseUp", nil)

	self.Text:SetText("")
end

DataText:Register(PVP, Enable, Disable, Update)