--[[ oUF_PredatorSimple
	This is a layout for the incredibly awesome oUF by haste.
	
	PLEASE NOTE that this layout comes with no warranty and "as it is". It was created to fit my very own
	needs, so please understand, that I'll not put any effort in "fixing" something for you, "adding" something
	for you or make any changes to this.
	Anyway, when you read this, you've already downloaded my layout, so please, feel free to modify it to your
	own needs.
]]

local ADDON_NAME, NS = ...								-- get the addons namespace to exchange functions between core and layout
local core = CreateFrame('Frame')

local settings = NS.settings							-- get the settings
local lib = NS.lib										-- get the library

--[[ FUNCTIONS
	Now we're starting with our functions. 
	Note that in this file are only the functions, which are used by more than one layout-function.
]]

	--[[ Creates a HealthBar-object
		FRAME CreateHealthBar(FRAME self, INT height)
	]]
	core.CreateHealthBar = function(self, height)
		-- lib.debugging('entering CreateHealthBar()')

		local f = CreateFrame('StatusBar', nil, self)	
		f:SetHeight(height)
		f:SetStatusBarTexture(settings.src.textures.bartexture, 'BORDER')
		f:SetStatusBarColor(0.15, 0.15, 0.15, 1)
		f:SetPoint('TOPLEFT')
		f:SetPoint('TOPRIGHT')

		f.bg = f:CreateTexture(nil, 'BACKGROUND')
		f.bg:SetAllPoints(f)
		f.bg:SetVertexColor(0.3, 0.3, 0.3, 1)
		f.bg:SetTexture(settings.src.textures.bartexture)

		return f
	end

	--[[ Creates a PowerBar-object
		FRAME CreatePowerBar(FRAME self, INT height)
	]]
	core.CreatePowerBar = function(self, height)
		-- lib.debugging('entering CreatePowerBar()')

		local f = CreateFrame('StatusBar', nil, self)
		f:SetHeight(height)
		f:SetStatusBarTexture(settings.src.textures.bartexture, 'BORDER')
		f:SetPoint('LEFT')
		f:SetPoint('RIGHT')
		f:SetPoint('TOP', self.Health, 'BOTTOM', 0, 0)

		f.colorDisconnected = true
		f.colorClass = true
		f.colorReaction = true

		f.bg = f:CreateTexture(nil, 'BACKGROUND')
		f.bg:SetAllPoints(f)
		f.bg:SetTexture(settings.src.textures.bartexture)
		f.bg:SetAlpha(0.4)

		return f
	end

	--[[ Creates a CastBar
		FRAME CreateCastbar(FRAME self)
	]]
	core.CreateCastbar = function(self)
		local cb = CreateFrame('StatusBar', nil, self.Health)
		cb:SetStatusBarTexture(settings.src.textures.bartexture, 'ARTWORK')
		cb:SetStatusBarColor(.86, .5, 0, 1)

		cb.bg = cb:CreateTexture(nil, 'BACKGROUND')
		cb.bg:SetAllPoints(cb)
		cb.bg:SetTexture(settings.src.textures.bartexture)
		cb.bg:SetVertexColor(.15,.15,.15)

		cb.SafeZone = cb:CreateTexture(nil,'BORDER')
		cb.SafeZone:SetPoint('TOPRIGHT')
		cb.SafeZone:SetPoint('BOTTOMRIGHT')
		cb.SafeZone:SetHeight(22)
		cb.SafeZone:SetTexture(settings.src.textures.bartexture)
		cb.SafeZone:SetVertexColor(.69,.31,.31)

		cb.Text = lib.CreateFontObject(cb, 12, settings.src.fonts['Ebrima'])
		cb.Text:SetPoint('LEFT', 1, 1)
		cb.Text:SetTextColor(.84,.75,.65)

		cb.Time = lib.CreateFontObject(cb, 12, settings.src.fonts['Ebrima'])
		cb.Time:SetPoint('RIGHT', -1, 1)
		cb.Time:SetTextColor(.84,.75,.65)
		cb.Time:SetJustifyH('RIGHT')

		cb.Icon = cb:CreateTexture(nil, 'ARTWORK')
		cb.Icon:SetHeight(20)
		cb.Icon:SetWidth(20)
		cb.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
		cb.Icon:SetPoint('TOPRIGHT', cb, 'TOPLEFT', -5, 0)

		cb:SetPoint('TOPLEFT', self.Health, 'TOPLEFT', 0, 0)
		cb:SetPoint('BOTTOMRIGHT', self.Health, 'BOTTOMRIGHT', 0, 0)

		return cb
	end

	--[[ Creates a RuneFrame
		FRAME CreateRuneFrame(FRAME self)
	]]
	core.CreateRuneFrame = function(self)
		local i
		local rf = CreateFrame('Frame', nil, self)

		for i = 1, 6 do
			rf[i] = CreateFrame('StatusBar', nil, rf)
			rf[i]:SetHeight(10)
			rf[i]:SetWidth(33)
			rf[i]:SetStatusBarTexture(settings.src.textures.bartexture, 'BORDER')
			rf[i]:SetBackdrop(settings.src.backdrop)
			rf[i]:SetBackdropColor(0, 0, 0, 1)
			rf[i]:SetBackdropBorderColor(0, 0, 0, 0)
			rf[i].bg = rf[i]:CreateTexture(nil, 'BACKGROUND')
			rf[i].bg:SetAllPoints(rf[i])
			rf[i].bg:SetTexture(settings.src.textures.bartexture)
			rf[i].bg:SetVertexColor(0.3, 0.3, 0.3, 0.5)
			lib.CreateBorder(rf[i], 10)
			for _, tex in ipairs(rf[i].borderTextures) do
				tex:SetParent(rf[i])
			end
			if (i == 1) then
				rf[i]:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 10)
			else
				rf[i]:SetPoint('LEFT', rf[i-1], 'RIGHT', 5, 0)
			end
		end

		return rf
	end

	--[[ Creates a ComboPointFrame
		FRAME CreateComboPointFrame(FRAME self)
	]]
	core.CreateComboPointFrame = function(self)
		-- STUB: Fill this shit!
	end

	--[[ This must be done for all frames
		VOID AllFrames(FRAME self, INT bordersize)
	]]
	core.AllFrames = function(self, bordersize)
		-- lib.debugging('entering AllFrames()')

		self:SetBackdrop(settings.src.backdrop)
		self:SetBackdropColor(0, 0, 0, 1)
		self:SetBackdropBorderColor(0, 0, 0, 0)

	-- apply the menu to the frames
		self.menu = lib.Menu
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)
		self:RegisterForClicks('anyup')
		self:SetAttribute('*type2', 'menu')

	-- ***** Borders *****
		lib.CreateBorder(self, bordersize)
		for _, tex in ipairs(self.borderTextures) do
			tex:SetParent(self.Health)
		end

	-- ***** Fade out, if out-of-range *****
		if ( not unit ) then
			self.Range = {
				['insideAlpha'] = 1.0,
				['outsiteAlpha'] = 0.4
			}
		end
		
		self.Threat = CreateFrame('Frame', self, nil)
		self.Threat.Update = core.UpdateThreat 
	end

	--[[ Apply general oUF-plugins
		VOID ApplyPlugins(FRAME self)
	]]
	core.ApplyPlugins = function(self)
		-- lib.debugging('entering ApplyPlugins()')

		if(IsAddOnLoaded('oUF_HealComm4')) then
			self.HealCommBar = CreateFrame('StatusBar', nil, self.Health)
			self.HealCommBar:SetHeight(0)
			self.HealCommBar:SetWidth(0)
			self.HealCommBar:SetStatusBarTexture(settings.src.textures.bartexture)
			self.HealCommBar:SetStatusBarColor(0, 1, 0, 0.25)
			self.HealCommBar:SetAllPoints(self.Health)
			self.allowHealCommOverflow = false
		end

		if(IsAddOnLoaded('oUF_Smooth')) then
			self.Health.Smooth = true
			if (self.Power) then
				self.Power.Smooth = true
			end
		end

		if(IsAddOnLoaded('oUF_DebuffHighlight')) then					-- TODO: Make this shit VISIBLE!
			self.DebuffHighlight = self:CreateTexture(nil, 'ARTWORK')
			self.DebuffHighlight:SetAllPoints(self)
			self.DebuffHighlight:SetBlendMode('ADD')
			self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
			self.DebuffHighlightAlpha = 1
			self.DebuffHighlightFilter = true
			self.DebuffHighlight:SetTexture('Interface\\AddOns\\oUF_Predator\\gfx\\debuff_highlight')
		end

		if (IsAddOnLoaded('oUF_RessComm')) then							-- TODO: Make this shit VISIBLE!
			self.ResComm = self.Health:CreateTexture(nil, 'OVERLAY')
			self.ResComm:SetTexture([=[Interface\Icons\Spell_Holy_Resurrection]=])
			self.ResComm:SetAllPoints(self.Health)
			self.ResComm:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			self.ResComm:SetBlendMode("ADD")
			self.ResComm:SetAlpha(.25)
		end
	end

	--[[ Colors the border according to the current threat-situation
		VOID UpdateThreat(FRAME self, EVENT event, UNIT unit)
	]]
	core.UpdateThreat = function(self, event, unit)
		if (unit ~= self.unit) then return end
		local status = UnitThreatSituation(unit)
		if self.threatStatus == status then return end
		if not status then status = 0 end
		self.threatStatus = status
		local r, g, b = unpack(settings.src.threatColors[status])
		lib.SetBorderColor(self, r, g, b)
	end

-- *****************************************************	

	--[[ Health-value of the player-frame
		VOID UpdateHealth_player(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_player = function(health, unit, min, max)
		if (min ~= max) then
			health.value:SetFormattedText('|cffCC0000-%s|r|cffDDDDDD | %s|r', lib.Shorten((max-min)), lib.Shorten(min))
		else
			health.value:SetText(min)
		end
	end

	--[[ Health-value with current value and percent
		VOID UpdateHealth_min_percent(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_min_percent = function(health, unit, min, max)
		if (min ~= max) then
			health.value:SetFormattedText('|cffDDDDDD%s | %d%%|r', lib.Shorten(min), (min/max)*100)
		else
			health.value:SetText(min)
		end
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Health-value, only current value
		VOID UpdateHealth_min(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_min = function(health, unit, min, max)
		health.value:SetText(min)
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Health-value, deficit (healermode)
		VOID UpdateHealth_deficit(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_deficit = function(health, unit, min, max)
		if (min ~= max) then
			health.value:SetFormattedText('|cffCC0000-%s|r', lib.Shorten((max-min)))
		else
			health.value:SetText(min)
		end
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Health-value, deficit, replacing the name
		VOID UpdateHealth_player(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_deficit_name = function(health, unit, min, max)
		if (min ~= max) then
			health:GetParent().Name:Hide()
			health.value:SetFormattedText('|cffCC0000-%s|r', lib.Shorten((max-min)))
			health.value:Show()
		else
			health:GetParent().Name:Show()
			health.value:Hide()
		end
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Health-value in percent, replacing the name
		VOID UpdateHealth_player(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_percent_name = function(health, unit, min, max)
		if (min ~= max) then
			health:GetParent().Name:Hide()
			health.value:SetFormattedText('|cffDDDDDD%d%%|r', (min/max)*100)
			health.value:Show()
		else
			health:GetParent().Name:Show()
			health.value:Hide()
		end
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Power-value
		VOID UpdatePower(FRAME power, UNIT unit, INT min, INT max)
	]]
	core.UpdatePower = function(power, unit, min, max)
		local unitPower = UnitPowerType(unit)
		if ( (unitPower == 1) or (unitPower == 6) ) then		-- Rage, Runic Power
			power.value:SetText('')
		elseif ( (unitPower == 2) or (unitPower == 3) ) then	-- Focus, Energy
			power.value:SetFormattedText('|cffCC0000%s|r', min)
		else													-- seems to be MANA
			if (min == max) then
				power.value:SetFormattedText('|cffDDDDDD%d|r', max)
			else
				if (unit ~= 'player') then
					power.value:SetFormattedText('|cffDDDDDD%s | %d%%|r', lib.Shorten(min), (min/max)*100)
				else
					power.value:SetFormattedText('|cffCC0000-%s|r |cffDDDDDD %s | %d%%|r', lib.Shorten((max-min)), lib.Shorten(min), (min/max)*100)
				end
			end
		end
		power:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ NOOP
		VOID UpdateHealth_dummy(FRAME health, UNIT unit, INT min, INT max)
		This function is called, when a frame without Name-string wants to refresh the Name
	]]
	core.UpdateName_dummy = function(self, event, unit)
		return
	end

	--[[ Display the name of the target including its level
		VOID UpdateName_target(FRAME self, EVENT event, UNIT unit)
	]]
	core.UpdateName_target = function(self, event, unit)
		local lvl = UnitLevel(unit)
		local name = lib.EvalLevel(lvl)..'|r '..UnitName(unit)
		if string.len(name) > 29 then name = name:sub(1,28)..'...' end
		self.Name:SetText(name)
	end

	--[[ Displays a (shortened) name
		VOID UpdateName_4(FRAME self, EVENT event, UNIT unit)
	]]
	core.UpdateName_4 = function(self, event, unit)
		self.Name:SetText(UnitName(unit):sub(1,4))
	end

	--[[ Displays a (shortened) name
		VOID UpdateName_6(FRAME self, EVENT event, UNIT unit)
	]]
	core.UpdateName_6 = function(self, event, unit)
		self.Name:SetText(UnitName(unit):sub(1,6))
	end

	--[[ Displays a (shortened) name
		VOID UpdateName_10(FRAME self, EVENT event, UNIT unit)
	]]
	core.UpdateName_10 = function(self, event, unit)
		self.Name:SetText(UnitName(unit):sub(1,10))
	end

	--[[ Displays a (shortened) name
		VOID UpdateName_16(FRAME self, EVENT event, UNIT unit)
	]]
	core.UpdateName_16 = function(self, event, unit)
		local name = UnitName(unit)
		if string.len(name) > 17 then
			self.Name:SetText(name:sub(1,16)..'..')
		else
			self.Name:SetText(name)
		end
	end

-- *****************************************************

	--[[ Filter the players buffs
		BOOL FilterBuffs_player(..., INT spellID)
	]]
	core.FilterBuffs_player = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		-- lib.debugging(spellID..'('..name..')')
		return lib.FilterGeneric(spellID, settings.options.playerBuffs)
	end

	--[[ Filter the players debuffs
		BOOL FilterDebuffs_player(..., INT spellID)
	]]
	core.FilterDebuffs_player = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		return lib.FilterGeneric(spellID, settings.options.playerDebuffs)
	end

	--[[ Filter buffs
		BOOL FilterBuffs(..., INT spellID)
	]]
	core.FilterBuffs = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		-- lib.debugging('##############################################')
		-- lib.debugging('entering FilterBuffs() with spellID='..spellID)
		if ( UnitIsFriend(unit, 'player') ) then
			return lib.FilterGeneric(spellID, settings.options.friendsBuffs)
		else
			return lib.FilterGeneric(spellID, settings.options.enemyBuffs)
		end
	end

	--[[ Filter debuffs
		BOOL FilterDebuffs(..., INT spellID)
	]]
	core.FilterDebuffs = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		if ( UnitIsFriend(unit, 'player') ) then
			return lib.FilterGeneric(spellID, settings.options.friendsDebuffs)
		else
			return lib.FilterGeneric(spellID, settings.options.enemyDebuffs)
		end
	end

-- *****************************************************
NS.core = core											-- handover of the core-functions to the namespace