local TimesForrestRan = 0;
local WindowFlag = 0;
MsgPrefix = "FTWP";

pokerinfo = GetAddOnMetadata("Poker", "Version");

function Poker_OnLoad(self)
	local RegisterSuccess = {}
	local a = {}

	SLASH_POKER1, SLASH_POKER2 = "/poker", "/Poker";
	Poker_Print("The poker addon (version " .. pokerinfo .. ") has successfully loaded!");	
	SlashCmdList["POKER"] = forrest;
	
	RegisterAddonMessagePrefix(MsgPrefix);
end


function Poker_Print(statement)
	DEFAULT_CHAT_FRAME:AddMessage("{P}: " .. statement, 1, 1, 1);
end


function forrest(msg)

	if TimesForrestRan == 0 then
		Check_Preference()
	end
	
	if string.upper(msg) == "HELP" or string.upper(msg) == "H" then
		Poker_Print("Type /poker to roll. To select the channel rolls occur in, type /poker channelname. " ..
			"Valid channel names are guild, say, party, raid, and instance.")
	elseif string.upper(msg) == "GUILD" then
		ChatPreference = "GUILD";
		Poker_Print("Channel preference now set to guild.");
	elseif string.upper(msg) == "PARTY" then
		ChatPreference = "PARTY";
		Poker_Print("Channel preference now set to party.");
	elseif string.upper(msg) == "RAID" then
		ChatPreference = "RAID";
		Poker_Print("Channel preference now set to raid.");
	elseif msg ~= nil then
		Draw_Hand()
	else
		Draw_Hand()
	end
	
	TimesForrestRan = TimesForrestRan + 1;
end

function Draw_Hand()
	local output = {};
	local output2 = {};
	
	outrolls = {};
	outcards = {};
	Poker_Rolls(outrolls);
	outcards = Poker_Determine_Suit_and_Card(outrolls);
	output = outcards[1] .. " " .. outcards[2] .. " " .. outcards[3] .. " " .. outcards[4] .. " " .. outcards[5];
	Poker_Tell_Raid(output);
	output2 = outrolls[1] .. " " .. outrolls[2] .. " " .. outrolls[3] .. " " .. outrolls[4] .. " " .. outrolls[5];
	SendAddonMessage(MsgPrefix,output2,ChatPreference);
end


function Check_Preference()
	if ChatPreference == nil then
		ChatPreference = "GUILD";
		Poker_Print("You haven't set up a default channel, so guild is default.");
		Poker_Print("To change channel, type /poker channelname; no /1 or /2.");
	else
		Poker_Print("Channel for rolls is currently set to " .. string.lower(ChatPreference) .. ".")
	end
end


function Poker_Rolls(rolls)
	local flag = 0;
	
	for i = 1, 5 do
		repeat
			flag = 0;
			rolls[i] = math.random(1,52)
			for j = 1, 5 do
				if j ~= i and rolls[i] ~= rolls[j] then
					flag = flag + 1;
				end
			end
		until flag == 4
	end
end


function Poker_Determine_Suit_and_Card(rolls)
	local cards = {}
	for i = 1, 5 do
		if (rolls[i] >= 1 and rolls[i] <= 13) then
			if (rolls[i] == 1) then
				cards[i] = "A♣";
			elseif (rolls[i] == 11) then
				cards[i] = "J♣";
			elseif (rolls[i] == 12) then
				cards[i] = "Q♣";
			elseif (rolls[i] == 13) then
				cards[i] = "K♣";
			else
				cards[i] = tostring(rolls[i]) .. "♣";
			end
		elseif (rolls[i] >= 14 and rolls[i] <= 26) then
			if (rolls[i] == 1+13) then
				cards[i] = "A♦";
			elseif (rolls[i] == 11+13) then
				cards[i] = "J♦";
			elseif (rolls[i] == 12+13) then
				cards[i] = "Q♦";
			elseif (rolls[i] == 13+13) then
				cards[i] = "K♦";
			else
				cards[i] = tostring(rolls[i]-13) .. "♦";
			end
		elseif (rolls[i] >= 27 and rolls[i] <= 39) then
			if (rolls[i] == 1+26) then
				cards[i] = "A♥";
			elseif (rolls[i] == 11+26) then
				cards[i] = "J♥";
			elseif (rolls[i] == 12+26) then
				cards[i] = "Q♥";
			elseif (rolls[i] == 13+26) then
				cards[i] = "K♥";
			else
				cards[i] = tostring(rolls[i]-26) .. "♥";
			end
		elseif (rolls[i] >= 40 and rolls[i] <= 52) then
			if (rolls[i] == 1+39) then
				cards[i] = "A♠";
			elseif (rolls[i] == 11+39) then
				cards[i] = "J♠";
			elseif (rolls[i] == 12+39) then
				cards[i] = "Q♠";
			elseif (rolls[i] == 13+39) then
				cards[i] = "K♠";
			else
				cards[i] = tostring(rolls[i]-39) .. "♠";
			end
		else
			Poker_Print("ERROR IN POKER PROGRAM. PLEASE SUBMIT TO info@forthewynn.info THAT YOU ROLLED A " .. rolls[i]);
			Poker_Print("ALSO MENTION YOU ARE USING VERSION " .. pokerinfo);
		end
	end
	return cards
end


function Poker_Tell_Raid(statement)
	SendChatMessage("{P}: " .. statement,ChatPreference,nil,nil);
end

function Poker_Event(self, event, prefix, message, channel, sender)
	local outcard = {}
	if prefix == MsgPrefix then
		if WindowFlag == 0 then
			Frame:SetPoint("CENTER", UIParent, "CENTER");
			Frame:SetWidth(400);
			Frame:SetHeight(100);
			Frame:SetFontObject("GameFontNormal");
			local Back = Frame:CreateTexture("ARTWORK")
			Back:SetAllPoints();
			Back:SetTexture(0.2, 0.2, 0.2, 0.5);
			Frame:AddMessage(string.format("%s: %s", sender, message));
			Frame:Show();
			WindowFlag = 1;
		else
			Frame:AddMessage(string.format("%s: %s", sender, message));
		end
	end
end

Frame = CreateFrame("ScrollingMessageFrame", "Frame", UIParent);
Frame:RegisterEvent("CHAT_MSG_ADDON");
Frame:EnableMouse(True);
Frame:SetFading(False)
Frame:SetScript("OnEvent", Poker_Event);
