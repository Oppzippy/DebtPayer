local LibCopyPaste = LibStub:GetLibrary("LibCopyPaste-1.0")

SLASH_DEBTPAYER1 = "/debtpayer"
SlashCmdList["DEBTPAYER"] = function()
    LibCopyPaste:Paste("Debt Payer", function(input)
        local debts = DebtPayer.FromCSV(input)
        DebtPayer.SetDebts(debts)
    end)
end
