local _, addon = ...

local debtFrame = CreateFrame("Frame", nil, UIParent)
addon.debtFrame = debtFrame

debtFrame.text = debtFrame:CreateFontString(nil, "OVERLAY")

debtFrame:SetScript("OnUpdate", function(self)
	if self:IsShown() then
		local x, y = GetCursorPosition()
		local scale = UIParent:GetEffectiveScale()
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x / scale + 40, y / scale)
	end
end)

debtFrame.text:SetFont("Fonts\\FRIZQT__.ttf", 16, "OUTLINE")

debtFrame.text:ClearAllPoints()
debtFrame.text:SetPoint("TOPLEFT", debtFrame, "TOPLEFT")
debtFrame.text:SetJustifyH("LEFT")
debtFrame.text:Show()

debtFrame:SetFrameStrata("TOOLTIP")
debtFrame:SetSize(500, 1000)