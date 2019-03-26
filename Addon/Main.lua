local _, addon = ...
DebtPayer = {}

function addon:Debug(...)
	print(...)
end

local debtPayer = addon.CreateDebtPayer()

do
	local ticker
	local debts
	local i

	local function UpdateText()
		local text = {}
		local count = #debts
		for j = i, count do
			local debt = debts[j]
			tinsert(text, debt.player)
			tinsert(text, " = ")
			tinsert(text, GetCoinTextureString(debt.debt))
			tinsert(text, "\n")
		end
		addon.debtFrame.text:SetText(table.concat(text))

	end

	local function SendDebt()
		if debtPayer:Succeeded() then
			i = i + 1
			UpdateText()
		end
		local debt = debts[i]
		if debt then
			debtPayer:SetDebt(debt.player, debt.debt)
			debtPayer:AttemptSend()
		else
			addon.debtFrame:Hide()
			ticker:Cancel()
		end
	end

	function DebtPayer.SetDebts(newDebts)
		debts = newDebts
		if ticker then
			ticker:Cancel()
		end
		debtPayer:ClearSuccess()
		i = 1
		UpdateText()
		addon.debtFrame:Show()
		ticker = C_Timer.NewTicker(0.5, SendDebt)
	end

	function DebtPayer.FromCSV(csv)
		local t = {}
		local pattern = "([^\n]+),(%d+)"
		for player, debt in string.gmatch(csv, pattern) do
			tinsert(t, {
				["player"] = player,
				["debt"] = tonumber(debt),
			})
		end

		return t
	end
end
