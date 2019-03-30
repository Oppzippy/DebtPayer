-- luacheck: globals LibStub

local LibCopyPaste = LibStub:NewLibrary("LibCopyPaste-1.0", 3)
if not LibCopyPaste then return end

-- CopyPasteFrame Class

local CopyPasteFrame = {}
CopyPasteFrame.__index = CopyPasteFrame

function CopyPasteFrame:Create()
    local obj = {}
    setmetatable(obj, CopyPasteFrame)
    -- Main frame
    local frame = CreateFrame("Frame", nil, UIParent, "DialogBoxFrame")
    obj.button = frame:GetChildren()
    frame:EnableMouse(true)
    frame:EnableKeyboard(true)

    -- Child frames
    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalHugeBlack")
    title:SetPoint("TOP", 0, 0)
    title:SetTextColor(1, 1, 1, 1)
    title:Show()

    local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOP", 0, -30)
    scrollFrame:SetSize(650, 370)
    scrollFrame:Show()

    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMaxLetters(999999)
    editBox:SetSize(630, 350)
    editBox:SetFont(ChatFontNormal:GetFont())
    editBox:SetAutoFocus(true)
    editBox:SetMultiLine(true)
    editBox:Show()
    editBox:SetScript("OnEscapePressed", function(self)
        obj:Hide()
    end)

    scrollFrame:SetScrollChild(editBox)

    obj.frame = frame
    obj.editBox = editBox
    obj.title = title
    return obj
end

function CopyPasteFrame:ResetPosition()
    self.frame:SetSize(700, 450)
    self.frame:ClearAllPoints()
    self.frame:SetPoint("CENTER", self.frame:GetParent() or UIParent, "CENTER", 0, 0)
end

function CopyPasteFrame:Show()
    self:ResetPosition()
    self.frame:Show()
    self.editBox:SetFocus()
end

function CopyPasteFrame:SetTitle(title)
    self.title:SetText(title)
end

function CopyPasteFrame:SetText(text)
    self.editBox:SetText(text)
end

function CopyPasteFrame:GetTitle()
    return self.title:GetText()
end

function CopyPasteFrame:GetText()
    return self.editBox:GetText()
end

function CopyPasteFrame:IsOpen()
    return self.frame:IsShown()
end

-- Callback runs when Okay is clicked. Does not run when excape is pressed.
function CopyPasteFrame:SetCallback(callback)
    self.button:SetScript("OnClick", function()
        if callback then
            callback(self:GetText())
        end
        self:Hide()
    end)
end

function CopyPasteFrame:Hide()
    self:SetTitle("")
    self:SetText("")
    self:SetCallback(nil)
    self.frame:Hide()
end

-- Public API
local frame
-- Open a frame containing text for the user to copy
-- @param title Title of the copy window.
-- @param text Text to display in the window. This is what will be copied.
function LibCopyPaste:Copy(title, text)
    assert(type(title) == "string" and type(text) == "string", "Title and Text are required and must be strings. Usage: Copy(title, text)")
    if not frame then frame = CopyPasteFrame:Create() end
    frame:Hide()
    frame:SetTitle(title)
    frame:SetText(text)
    frame:Show()
end

-- Open a frame for the user to paste text into
-- @param title Title of the paste window.
-- @param callback Function that will be run when the paste window is closed. The function will be passed the pasted text as an argument.
function LibCopyPaste:Paste(title, callback)
    assert(type(title) == "string" and type(callback) == "function", "Title and Callback are required. title must be a string and callback must be a function. Usage: Copy(title, callback)")
    if not frame then frame = CopyPasteFrame:Create() end
    frame:Hide()
    frame:SetTitle(title)
    frame:SetCallback(callback)
    frame:Show()
end
