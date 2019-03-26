local _, addon = ...
local DebtPayerPrototype = {}
DebtPayerPrototype.__index = DebtPayerPrototype

function addon.CreateDebtPayer()
	local debtPayer = {}
	setmetatable(debtPayer, DebtPayerPrototype)

	local eventRegister = addon.CreateEventRegister()
	debtPayer.eventRegister = eventRegister

	eventRegister:RegisterEvent("SEND_MAIL_MONEY_CHANGED")
	eventRegister:RegisterEvent("MAIL_SEND_SUCCESS")

	eventRegister.SEND_MAIL_MONEY_CHANGED = function()
		debtPayer.prevMoney = debtPayer.money
		debtPayer.money = GetSendMailMoney()
		debtPayer.lastUpdate = GetTime()
	end

	eventRegister.MAIL_SEND_SUCCESS = function()
		if not debtPayer.debt then return end
		local t = GetTime()
		if t == debtPayer.lastUpdate then
			if debtPayer.prevMoney == debtPayer.debt and debtPayer.money == 0 then
				debtPayer.debt = 0
				debtPayer.success = true
				addon:Debug("Successfully sent", GetCoinTextureString(debtPayer.prevMoney))
			end
		else
			addon:Debug(t-debtPayer.lastUpdate)
		end
	end

	return debtPayer
end

function DebtPayerPrototype:SetDebt(player, debt)
	self.player = player
	self.debt = debt
	self.success = false
end

function DebtPayerPrototype:ClearSuccess()
	self.success = false
end

function DebtPayerPrototype:AttemptSend()
	if self.player and self.debt > 0 and not self.success then
		if self.player ~= UnitName("player") then
			addon:Debug("Attempting to send", GetCoinTextureString(self.debt), "to", self.player)
			SetSendMailMoney(self.debt)
			SendMail(self.player, "Payment", "Payment to " .. self.player .. ": " .. GetCoinText(self.debt, ""))
		else
			addon:Debug("Skipping " .. self.player .. ": " .. GetCoinTextureString(self.debt))
			self.debt = 0
			self.success = true
		end
	end
end

function DebtPayerPrototype:Succeeded()
	return self.success
end
