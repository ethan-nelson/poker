pokerinfo = GetAddOnMetadata("Poker", "Version");

function Poker_OnLoad(self)

	SLASH_POKER1, SLASH_POKER2 = "/poker", "/Poker";
	DEFAULT_CHAT_FRAME:AddMessage("Poker raid addon has loaded; you must be in a raid to use this addon!", 1, 1, 1);
	
end


function Poker_Print(statement)
	DEFAULT_CHAT_FRAME:AddMessage("{P}: " .. statement, 0.5, 0.5, 1);
end


function Poker_Tell_Raid(statement)
	SendChatMessage("{P}: " .. statement,"RAID",nil,nil);
end


function SlashCmdList.POKER(self)
	local output = {}
	rolls = {};
	cards = {};
	Poker_Rolls();
	Poker_Determine_Suit_and_Card();
	output = cards[1] .. cards[2] .. cards[3] .. cards[4] .. cards[5];
	Poker_Tell_Raid(output);
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


function Poker_Determine_Suit_and_Card()
	
	for i = 1, 5 do
		if (rolls[i] >= 1 and rolls[i] <= 13) then
			if (rolls[i] == 1) then
				cards[i] = "A♣ ";
			elseif (rolls[i] == 11) then
				cards[i] = "J♣ ";
			elseif (rolls[i] == 12) then
				cards[i] = "Q♣ ";
			elseif (rolls[i] == 13) then
				cards[i] = "K♣ ";
			else
				cards[i] = tostring(rolls[i]) .. "♣ ";
			end
		elseif (rolls[i] >= 14 and rolls[i] <= 26) then
			if (rolls[i] == 1+13) then
				cards[i] = "A♦ ";
			elseif (rolls[i] == 11+13) then
				cards[i] = "J♦ ";
			elseif (rolls[i] == 12+13) then
				cards[i] = "Q♦ ";
			elseif (rolls[i] == 13+13) then
				cards[i] = "K♦ ";
			else
				cards[i] = tostring(rolls[i]-13) .. "♦ ";
			end
		elseif (rolls[i] >= 27 and rolls[i] <= 39) then
			if (rolls[i] == 1+26) then
				cards[i] = "A♥ ";
			elseif (rolls[i] == 11+26) then
				cards[i] = "J♥ ";
			elseif (rolls[i] == 12+26) then
				cards[i] = "Q♥ ";
			elseif (rolls[i] == 13+26) then
				cards[i] = "K♥ ";
			else
				cards[i] = tostring(rolls[i]-26) .. "♥ ";
			end
		elseif (rolls[i] >= 40 and rolls[i] <= 52) then
			if (rolls[i] == 1+39) then
				cards[i] = "A♠ ";
			elseif (rolls[i] == 11+39) then
				cards[i] = "J♠ ";
			elseif (rolls[i] == 12+39) then
				cards[i] = "Q♠ ";
			elseif (rolls[i] == 13+39) then
				cards[i] = "K♠ ";
			else
				cards[i] = tostring(rolls[i]-39) .. "♠ ";
			end
		else
			Poker_Print("ERROR IN POKER PROGRAM. PLEASE SUBMIT TO info@forthewynn.info THAT YOU ROLLED A " .. rolls[i]);
			Poker_Print("ALSO MENTION YOU ARE USING VERSION " .. pokerinfo);
		end
	end
end

