local _, addon = ...
local EventRegisterPrototype = {}
EventRegisterPrototype.__index = EventRegisterPrototype

function addon.CreateEventRegister()
	local eventRegister = {}
	setmetatable(eventRegister, EventRegisterPrototype)
	
	eventRegister.frame = CreateFrame("Frame")
	
	eventRegister.frame:SetScript("OnEvent", function(self, event, ...)
		local func = eventRegister[event]
		if type(func) == "function" then
			func(event, ...)
		end
	end)
	
	return eventRegister
end

function EventRegisterPrototype:RegisterEvent(event)
	self.frame:RegisterEvent(event)
end