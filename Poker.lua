pokerinfo = GetAddOnMetadata("Poker", "Version");

function Poker_OnLoad(self)

	SLASH_POKER1, SLASH_POKER2 = "/poker", "/Poker";
	DEFAULT_CHAT_FRAME:AddMessage("{Poker} raid addon has loaded; you must be in a raid to use this addon!", 1, 1, 1);
	
end


function Poker_Print(statement)
	DEFAULT_CHAT_FRAME:AddMessage("{Poker}: " .. statement, 0.5, 0.5, 1);
end


function Poker_Tell_Raid(statement)
	SendChatMessage("{Poker}: " .. statement,"RAID",nil,nil);
end


function SlashCmdList.POKER(self)
	rolls = {};
	cards = {};
	Poker_Rolls();
	Poker_Tell_Raid("Incoming hand: ");
	Poker_Determine_Suit();
end


function Poker_Rolls()
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


function Poker_Determine_Suit()
	
	for i = 1, 5 do
		if (rolls[i] >= 1 and rolls[i] <= 13) then
			cards[i] = tostring(rolls[i]) .. " of Spades.";
		elseif (rolls[i] >= 14 and rolls[i] <= 26) then
			cards[i] = tostring(rolls[i]-13) .. " of Clubs.";
		elseif (rolls[i] >= 27 and rolls[i] <= 39) then
			cards[i] = tostring(rolls[i]-26) .. " of Hearts.";
		elseif (rolls[i] >= 40 and rolls[i] <= 52) then
			cards[i] = tostring(rolls[i]-39) .. " of Diamonds.";
		else
			Poker_Print("ERROR IN POKER PROGRAM. PLEASE SUBMIT TO bugs@forthewynn.info THAT YOU ROLLED A " .. rolls[i]);
			Poker_Print("ALSO MENTION YOU ARE USING VERSION " .. pokerinfo);
		end
		Poker_Tell_Raid(cards[i])
	end
end

