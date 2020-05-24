local T, C, L = Tukui:unpack()

local DataText = T["DataTexts"]
local GetPVPLifetimeStats = GetPVPLifetimeStats
local Label = KILLS

local OnEnter = function(self)
	GameTooltip:SetOwner(self:GetTooltipAnchor())
	
	local Honorable, Dishonorable = GetPVPLifetimeStats()
	local Rank = UnitPVPRank("player")
	
	if (Rank > 0) then
		local Name, Number = GetPVPRankInfo(Rank, "player")
		
		GameTooltip:AddDoubleLine(Name, format("%s %s", RANK, Number))
		GameTooltip:AddLine(" ")
	end
	
	GameTooltip:AddDoubleLine(HONORABLE_KILLS, T.Comma(Honorable), 1, 1, 1, 1, 1, 1)
	GameTooltip:AddDoubleLine(DISHONORABLE_KILLS, T.Comma(Dishonorable), 1, 1, 1, 1, 1, 1)
	
	GameTooltip:Show()
end

local OnLeave = function()
	GameTooltip:Hide()
end

local OnMouseUp = function()
	ToggleCharacter("HonorFrame")
end

local Update = function(self)
	self.Text:SetFormattedText("%s%s:|r %s%s|r", DataText.NameColor, Label, DataText.ValueColor, T.Comma(GetPVPLifetimeStats()))
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