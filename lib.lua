--[[ oUF_PredatorSimple
	This is a layout for the incredibly awesome oUF by haste.
	
	PLEASE NOTE that this layout comes with no warranty and "as it is". It was created to fit my very own
	needs, so please understand, that I'll not put any effort in "fixing" something for you, "adding" something
	for you or make any changes to this.
	Anyway, when you read this, you've already downloaded my layout, so please, feel free to modify it to your
	own needs.
]]

local ADDON_NAME, NS = ...								-- get the addons namespace to exchange functions between core and layout
local lib = CreateFrame('Frame')

local settings = NS.settings							-- get the settings

--[[ FUNCTIONS
	Now we're starting with our library-functions. 
]]

	--[[ Debugging to ChatFrame
		VOID debugging(STRING text)
		Adds the given 'text' to the ChatFrame1
	]]
	lib.debugging = function(text)
		DEFAULT_CHAT_FRAME:AddMessage('|cffffd700oUF_PredatorSimple:|r |cffeeeeee'..text..'|r')
	end

	--[[ Shortening the values displayed on the Health- and Power-Bars
		STRING Shorten(INT value)
	]]
	lib.Shorten = function(value)
		if value >= 1e7 then
			return ('%.1fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
		elseif value >= 1e6 then
			return ('%.2fm'):format(value / 1e6):gsub('%.?0+([km])$', '%1')
		elseif value >= 1e5 then
			return ('%.0fk'):format(value / 1e3)
		elseif value >= 1e3 then
			return ('%.1fk'):format(value / 1e3):gsub('%.?0+([km])$', '%1')
		else
			return value
		end
	end

	--[[ Evaluates the level of our target
		STRING EvalLevel(INT level)
	]]
	lib.EvalLevel = function(level)
		if level < 0 then return '|cffff0000??' end
		local difference = level - UnitLevel('player')
		if (difference >= 5) then return '|cffff0000'..level
		elseif (difference >= 3) then return '|cffff0000'..level
		elseif (difference >= -2) then return '|cffffff00'..level
		elseif -difference <= GetQuestGreenRange() then return '|cff00cc00'..level
		else return '|cffaaaaaa'..level
		end
	end

	--[[ Is a value in a table?
	
	]]
	lib.in_array = function( e, t )
		-- lib.debugging('entering in_array() with spellID='..e)
		for _,v in pairs(t) do
			if ( v == e ) then
				-- lib.debugging('in_array(): v == e: '..v..'/'..e)
				return true
			end
		end
		return false
	end

	--[[ Creates a font-object
		FONTOBJECT CreateFontObject(FRAME parent, INT size, STRING font)
		Creates a font-object with the given 'parent' and 'size', using 'font'. Shadow and Outline are constant throughout the layout.
	]]
    lib.CreateFontObject = function(parent, size, font)
    	local fo = parent:CreateFontString(nil, 'OVERLAY')
    	fo:SetFont(font, size, 'OUTLINE')
    	fo:SetJustifyH('LEFT')
    	fo:SetShadowColor(0,0,0)
    	fo:SetShadowOffset(1, -1)
    	return fo
    end

    --[[ Provides the standard UF-menu
		VOID Menu(FRAME self)
	]]
	lib.Menu = function(self)
        local unit = self.unit:sub(1, -2)
    	local cunit = self.unit:gsub('(.)', string.upper, 1)

    	if(unit == 'party' or unit == 'partypet') then
            ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor', 0, 0)
        elseif(_G[cunit..'FrameDropDown']) then
            ToggleDropDownMenu(1, nil, _G[cunit..'FrameDropDown'], 'cursor', 0, 0)
        end
    end
	
	--[[ Apply a color to the border
		VOID SetBorderColor(FRAME self, FLOAT r, FLOAT g, FLOAT b)
	]]
	lib.SetBorderColor = function(self, r, g, b)
		if not self or type(self) ~= "table" then return end
		local i
		if not self.borderTextures then
			lib.CreateBorder(self)
		end
		if not r then
			r, g, b = 0.5, 0.5, 0.5
		end

		for i, tex in ipairs(self.borderTextures) do
			tex:SetVertexColor(r, g, b)
		end
	end

	--[[ Creates the borders for our frames
		VOID CreateBorder (FRAME frame, INT size)
	]]
	lib.CreateBorder = function(frame, size)
		if not frame or type(frame) ~= "table" or frame.borderTextures then return end
		if not size then size = settings.options.bordersize end
		local i

		frame.borderTextures = { }

		-- creating the textures
		local tex = frame.borderTextures
		for i = 1, 8 do
			tex[i] = frame:CreateTexture(nil, 'ARTWORK')
			tex[i]:SetTexture(settings.src.textures.bordertexture)
			tex[i]:SetWidth(size)
			tex[i]:SetHeight(size)
		end
		
		local x = size / 2 - 6

		tex[1].id = "TOPLEFT"
		tex[1]:SetTexCoord(0, 1/3, 0, 1/3)
		tex[1]:SetPoint("TOPLEFT", frame, -5 - x, 5 + x)

		tex[2].id = "TOPRIGHT"
		tex[2]:SetTexCoord(2/3, 1, 0, 1/3)
		tex[2]:SetPoint("TOPRIGHT", frame, 5 + x, 5 + x)

		tex[3].id = "TOP"
		tex[3]:SetTexCoord(1/3, 2/3, 0, 1/3)
		tex[3]:SetPoint("TOPLEFT", tex[1], "TOPRIGHT")
		tex[3]:SetPoint("TOPRIGHT", tex[2], "TOPLEFT")

		tex[4].id = "BOTTOMLEFT"
		tex[4]:SetTexCoord(0, 1/3, 2/3, 1)
		tex[4]:SetPoint("BOTTOMLEFT", frame, -5 - x, -5 - x)

		tex[5].id = "BOTTOMRIGHT"
		tex[5]:SetTexCoord(2/3, 1, 2/3, 1)
		tex[5]:SetPoint("BOTTOMRIGHT", frame, 5 + x, -5 - x)

		tex[6].id = "BOTTOM"
		tex[6]:SetTexCoord(1/3, 2/3, 2/3, 1)
		tex[6]:SetPoint("BOTTOMLEFT", tex[4], "BOTTOMRIGHT")
		tex[6]:SetPoint("BOTTOMRIGHT", tex[5], "BOTTOMLEFT")

		tex[7].id = "LEFT"
		tex[7]:SetTexCoord(0, 1/3, 1/3, 2/3)
		tex[7]:SetPoint("TOPLEFT", tex[1], "BOTTOMLEFT")
		tex[7]:SetPoint("BOTTOMLEFT", tex[4], "TOPLEFT")

		tex[8].id = "RIGHT"
		tex[8]:SetTexCoord(2/3, 1, 1/3, 2/3)
		tex[8]:SetPoint("TOPRIGHT", tex[2], "BOTTOMRIGHT")
		tex[8]:SetPoint("BOTTOMRIGHT", tex[5], "TOPRIGHT")

		lib.SetBorderColor(frame, 0.5, 0.5, 0.5)

		frame.SetBorderColor = lib.SetBorderColor

	end

	--[[ Creates a single buff-/debuff-icon
		FRAME CreateAuraIcon(FRAME icons, INT index)
	]]
	lib.CreateAuraIcon = function(icons, index)

		local button = CreateFrame('Frame', nil, icons)
		button:SetWidth(icons.size or 16)
		button:SetHeight(icons.size or 16)

		local icon = button:CreateTexture(nil, 'BACKGROUND')
		icon:SetAllPoints(button)
		button.icon = icon

		local count = button:CreateFontString(nil, 'OVERLAY')
		count:SetFontObject(NumberFontNormal)
		count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -1, 0)
		button.count = count

		local overlay = button:CreateTexture(nil, 'OVERLAY')
		button.overlay = overlay

		local cd = CreateFrame('Cooldown', nil, button)
		cd:SetAllPoints(button)
		button.cd = cd

		table.insert(icons, button)

		lib.CreateBorder(button, 10)

		button.parent = icons

		return button
	end

	--[[ Providing blacklisting. Returns "false" if the ID is found.
		BOOL FilterBlacklist(INT spellID, TABLE filterSRC)
	]]
	lib.FilterBlacklist = function(spellID, list)
		if ( #list ~= 0 ) then
			if ( lib.in_array(spellID, list) ) then
				return false
			end
		end
		return true
	end

	--[[ Providing whitelisting. Returns "true" if the ID is found.
		BOOL FilterWhitelist(INT spellID, TABLE filterSRC)
	]]
	lib.FilterWhitelist = function(spellID, list)
		-- lib.debugging('entering FilterWhitelist() with spellID='..spellID)
		if ( #list ~= 0 ) then
			if ( lib.in_array(spellID, list) ) then
				return true
			end
		end
		return false
	end

	--[[ Generic filter-function (distinction between blacklist and whitelist)
		BOOL FilterGeneric(INT spellID, TABLE filterSRC)
	]]
	lib.FilterGeneric = function(spellID, filterSRC)
		-- lib.debugging('entering FilterGeneric() with spellID='..spellID)
		if (filterSRC.mode == 'blacklist') then
			return lib.FilterBlacklist(spellID, filterSRC.list)
		else
			return lib.FilterWhitelist(spellID, filterSRC.list)
		end
	end

-- *****************************************************
NS.lib = lib											-- handover of the core-functions to the namespace