--[[ oUF_PredatorSimple
	This is a layout for the incredibly awesome oUF by haste.
	
	PLEASE NOTE that this layout comes with no warranty and "as it is". It was created to fit my very own
	needs, so please understand, that I'll not put any effort in "fixing" something for you, "adding" something
	for you or make any changes to this.
	Anyway, when you read this, you've already downloaded my layout, so please, feel free to modify it to your
	own needs.
]]

local ADDON_NAME, ns = ...								-- get the addons namespace to exchange functions between core and layout
local core = CreateFrame('Frame')

local settings = ns.settings							-- get the settings
local lib = ns.lib										-- get the library
-- local menu = ns.menu									-- get the menu

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

		-- Heal Prediction
		if (settings.options.healPrediction) then
			local mhpb = CreateFrame('Statusbar', nil, self)
			mhpb:SetPoint('TOPLEFT', f:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:SetPoint('BOTTOMLEFT', f:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			-- mhpb:SetPoint('RIGHT', self, 'RIGHT', 0, 0)
			mhpb:SetWidth(self:GetWidth())
			mhpb:SetStatusBarTexture(settings.src.textures.bartexture, 'BORDER')
			mhpb:SetStatusBarColor(0, 0.7, 0, 0.5)
			
			local ohpb = CreateFrame('Statusbar', nil, self)
			ohpb:SetPoint('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:SetPoint('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			-- ohpb:SetPoint('RIGHT', self, 'RIGHT', 0, 0)
			ohpb:SetWidth(self:GetWidth())
			ohpb:SetStatusBarTexture(settings.src.textures.bartexture, 'BORDER')
			ohpb:SetStatusBarColor(1, 1, 0, 0.3)

			self.HealPrediction = {}
			self.HealPrediction.myBar = mhpb
			self.HealPrediction.otherBar = ohpb
			self.HealPrediction.maxOverflow = 1.0
		end

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

	--[[ Creates a HolyPowerFrame
		FRAME CreateHolyPowerFrame(FRAME self)
	]]
	core.CreateHolyPowerFrame = function(self)
		local hpf = CreateFrame('Frame', nil, self)
		hpf:SetWidth(110)
		hpf:SetHeight(10)

		hpf[1] = hpf:CreateTexture(nil, 'BORDER')
		hpf[1]:SetTexture(settings.src.textures.bartexture)
		hpf[1]:SetVertexColor(0.7, 0.5, 0, 1)
		hpf[1]:SetPoint('TOPLEFT', hpf, 'TOPLEFT', 0, 0)
		hpf[1]:SetPoint('BOTTOMRIGHT', hpf, 'BOTTOMLEFT', 30, 0)

		hpf[2] = hpf:CreateTexture(nil, 'BORDER')
		hpf[2]:SetTexture(settings.src.textures.bartexture)
		hpf[2]:SetVertexColor(0.7, 0.5, 0, 1)
		hpf[2]:SetPoint('TOPLEFT', hpf, 'TOP', -15, 0)
		hpf[2]:SetPoint('BOTTOMRIGHT', hpf, 'BOTTOM', 15, 0)

		hpf[3] = hpf:CreateTexture(nil, 'BORDER')
		hpf[3]:SetTexture(settings.src.textures.bartexture)
		hpf[3]:SetVertexColor(0.7, 0.5, 0, 1)
		hpf[3]:SetPoint('TOPLEFT', hpf, 'TOPRIGHT', -30, 0)
		hpf[3]:SetPoint('BOTTOMRIGHT', hpf, 'BOTTOMRIGHT', 0, 0)

		hpf.shard1 = CreateFrame('Frame', nil, hpf)
		hpf.shard1:SetAllPoints(hpf[1])
		hpf.shard1.back = hpf.shard1:CreateTexture(nil, 'BORDER')
		hpf.shard1.back:SetTexture(settings.src.textures.bartexture)
		hpf.shard1.back:SetVertexColor(0.7, 0.5, 0, 0.3)
		hpf.shard1.back:SetAllPoints(hpf.shard1)
		lib.CreateBorder(hpf.shard1, 10)

		hpf.shard2 = CreateFrame('Frame', nil, hpf)
		hpf.shard2:SetAllPoints(hpf[2])
		hpf.shard2.back = hpf.shard2:CreateTexture(nil, 'BORDER')
		hpf.shard2.back:SetTexture(settings.src.textures.bartexture)
		hpf.shard2.back:SetVertexColor(0.7, 0.5, 0, 0.3)
		hpf.shard2.back:SetAllPoints(hpf.shard2)
		lib.CreateBorder(hpf.shard2, 10)

		hpf.shard3 = CreateFrame('Frame', nil, hpf)
		hpf.shard3:SetAllPoints(hpf[3])
		hpf.shard3.back = hpf.shard3:CreateTexture(nil, 'BORDER')
		hpf.shard3.back:SetTexture(settings.src.textures.bartexture)
		hpf.shard3.back:SetVertexColor(0.7, 0.5, 0, 0.3)
		hpf.shard3.back:SetAllPoints(hpf.shard3)
		lib.CreateBorder(hpf.shard3, 10)
		
		return hpf
	end

	--[[ Creates an EclipseBar
		FRAME CreateEclipseBar(FRAME self)
	]]
	core.CreateEclipseBar = function(self)
		local eb = CreateFrame('Frame', nil, self)
		local width = self:GetWidth()
		eb:SetWidth(width)
		eb:SetHeight(10)
		
		eb.Border = CreateFrame('Frame', nil, eb)
		eb.Border:SetAllPoints(eb)
		eb.Border:SetFrameLevel(eb:GetFrameLevel()+3)
		
		eb.LunarBar = CreateFrame('StatusBar', nil, eb)
		eb.LunarBar:SetPoint('LEFT', eb, 'LEFT', 0, 0)
		eb.LunarBar:SetSize(width, 10)
		eb.LunarBar:SetStatusBarTexture(settings.src.textures.bartexture)
		eb.LunarBar:SetStatusBarColor(0.34, 0.1, 0.86)

		eb.SolarBar = CreateFrame('StatusBar', nil, eb)
		eb.SolarBar:SetPoint('LEFT', eb.LunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
		eb.SolarBar:SetSize(width, 10)
		eb.SolarBar:SetStatusBarTexture(settings.src.textures.bartexture)
		eb.SolarBar:SetStatusBarColor(0.95, 0.73, 0.15)

		lib.CreateBorder(eb.Border, 10)
		for _, tex in ipairs(eb.Border.borderTextures) do
			tex:SetParent(eb.Border)
		end
	
		return eb
	end

	--[[
	
	]]
	core.UpdateEclipseBarVisibility = function(unit)
		if(powerType ~= 'ECLIPSE') then return end

		local eb = self.EclipseBar

		local power = UnitPower(unit, SPELL_POWER_ECLIPSE)
		local maxPower = UnitPowerMax(unit, SPELL_POWER_ECLIPSE)

		if(eb.LunarBar) then
			eb.LunarBar:SetMinMaxValues(-maxPower, maxPower)
			eb.LunarBar:SetValue(power)
		end

		if(eb.SolarBar) then
			eb.SolarBar:SetMinMaxValues(-maxPower, maxPower)
			eb.SolarBar:SetValue(power * -1)
		end
	end
	
	--[[
	
	]]
	core.CreateSoulShardFrame = function(self)
		local ssf = CreateFrame('Frame', nil, self)
		ssf:SetWidth(110)
		ssf:SetHeight(10)

		ssf[1] = ssf:CreateTexture(nil, 'BORDER')
		ssf[1]:SetTexture(settings.src.textures.bartexture)
		ssf[1]:SetVertexColor(1, 0.2, 0.7, 1)
		ssf[1]:SetPoint('TOPLEFT', ssf, 'TOPLEFT', 0, 0)
		ssf[1]:SetPoint('BOTTOMRIGHT', ssf, 'BOTTOMLEFT', 30, 0)

		ssf[2] = ssf:CreateTexture(nil, 'BORDER')
		ssf[2]:SetTexture(settings.src.textures.bartexture)
		ssf[2]:SetVertexColor(1, 0.2, 0.7, 1)
		ssf[2]:SetPoint('TOPLEFT', ssf, 'TOP', -15, 0)
		ssf[2]:SetPoint('BOTTOMRIGHT', ssf, 'BOTTOM', 15, 0)

		ssf[3] = ssf:CreateTexture(nil, 'BORDER')
		ssf[3]:SetTexture(settings.src.textures.bartexture)
		ssf[3]:SetVertexColor(1, 0.2, 0.7, 1)
		ssf[3]:SetPoint('TOPLEFT', ssf, 'TOPRIGHT', -30, 0)
		ssf[3]:SetPoint('BOTTOMRIGHT', ssf, 'BOTTOMRIGHT', 0, 0)

		ssf.shard1 = CreateFrame('Frame', nil, ssf)
		ssf.shard1:SetAllPoints(ssf[1])
		ssf.shard1.back = ssf.shard1:CreateTexture(nil, 'BORDER')
		ssf.shard1.back:SetTexture(settings.src.textures.bartexture)
		ssf.shard1.back:SetVertexColor(1, 0.2, 0.7, 0.3)
		ssf.shard1.back:SetAllPoints(ssf.shard1)
		lib.CreateBorder(ssf.shard1, 10)

		ssf.shard2 = CreateFrame('Frame', nil, ssf)
		ssf.shard2:SetAllPoints(ssf[2])
		ssf.shard2.back = ssf.shard2:CreateTexture(nil, 'BORDER')
		ssf.shard2.back:SetTexture(settings.src.textures.bartexture)
		ssf.shard2.back:SetVertexColor(1, 0.2, 0.7, 0.3)
		ssf.shard2.back:SetAllPoints(ssf.shard2)
		lib.CreateBorder(ssf.shard2, 10)

		ssf.shard3 = CreateFrame('Frame', nil, ssf)
		ssf.shard3:SetAllPoints(ssf[3])
		ssf.shard3.back = ssf.shard3:CreateTexture(nil, 'BORDER')
		ssf.shard3.back:SetTexture(settings.src.textures.bartexture)
		ssf.shard3.back:SetVertexColor(1, 0.2, 0.7, 0.3)
		ssf.shard3.back:SetAllPoints(ssf.shard3)
		lib.CreateBorder(ssf.shard3, 10)
		
		return ssf
	end

	--[[
	
	]]
	core.CreateTotemBar = function(self)
		local i
		local tb = CreateFrame('Frame', nil, self)
		tb:SetWidth(170)
		tb:SetHeight(10)

		for i = 1, 4 do
			tb[i] = CreateFrame('Frame', nil, tb)
			tb[i]:SetWidth(35)
			tb[i]:SetHeight(10)
			tb[i].StatusBar = CreateFrame('StatusBar', nil, tb[i])
			tb[i].StatusBar:SetPoint('TOPLEFT', tb[i], 'TOPLEFT', 10, 0)
			tb[i].StatusBar:SetPoint('BOTTOMRIGHT', tb[i], 'BOTTOMRIGHT', 0, 0)
			tb[i].StatusBar:SetStatusBarTexture(settings.src.textures.bartexture)
			tb[i].Icon = tb[i]:CreateTexture(nil, "ARTWORK")
			tb[i].Icon:SetWidth(10)
			tb[i].Icon:SetHeight(10)
			tb[i].Icon:SetPoint('TOPLEFT', tb[i], 'TOPLEFT', 0, 0)
			tb[i].bg = tb[i]:CreateTexture(nil, 'BORDER')
			tb[i].bg:SetAllPoints(tb[i])
			tb[i].bg:SetTexture(settings.src.textures.bartexture)
		end

		tb[1]:SetPoint('TOPLEFT', tb, 'TOPLEFT', 0, 0)
		tb[1].StatusBar:SetStatusBarColor(0.15, 0.15, 0.15, 1)
		tb[1].bg:SetVertexColor(0, 0.6, 0, 0.3)
		tb[2]:SetPoint('TOPLEFT', tb[1], 'TOPRIGHT', 10, 0)
		tb[2].StatusBar:SetStatusBarColor(0.15, 0.15, 0.15, 1)
		tb[2].bg:SetVertexColor(0, 0.6, 0, 0.3)
		tb[3]:SetPoint('TOPLEFT', tb[2], 'TOPRIGHT', 10, 0)
		tb[3].StatusBar:SetStatusBarColor(0.15, 0.15, 0.15, 1)
		tb[3].bg:SetVertexColor(0, 0.6, 0, 0.3)
		tb[4]:SetPoint('TOPLEFT', tb[3], 'TOPRIGHT', 10, 0)
		tb[4].StatusBar:SetStatusBarColor(0.15, 0.15, 0.15, 1)
		tb[4].bg:SetVertexColor(0, 0.6, 0, 0.3)

		tb.border1 = CreateFrame('Frame', nil, tb[1])
		tb.border1:SetAllPoints(tb[1])
		tb:SetFrameLevel(tb[1]:GetFrameLevel()+3)
		lib.CreateBorder(tb.border1, 10)
		tb.border2 = CreateFrame('Frame', nil, tb[2])
		tb.border2:SetAllPoints(tb[2])
		tb:SetFrameLevel(tb[2]:GetFrameLevel()+3)
		lib.CreateBorder(tb.border2, 10)
		tb.border3 = CreateFrame('Frame', nil, tb[3])
		tb.border3:SetAllPoints(tb[3])
		tb:SetFrameLevel(tb[3]:GetFrameLevel()+3)
		lib.CreateBorder(tb.border3, 10)
		tb.border4 = CreateFrame('Frame', nil, tb[4])
		tb.border4:SetAllPoints(tb[4])
		tb:SetFrameLevel(tb[4]:GetFrameLevel()+3)
		lib.CreateBorder(tb.border4, 10)
		
		tb.Destroy = true
		
		return tb
	end

	--[[ Creates a ComboPointFrame
		FRAME CreateComboPointFrame(FRAME self)
	]]
	core.CreateComboPointFrame = function(self)
		local i
		-- local width = self:GetAttribute('initial-width')
		local width = self:GetWidth()
		local cpWidth = (width / 5) - (20/5)
		local cp = CreateFrame('Frame', nil, self)
		cp:SetWidth(width)
		cp:SetHeight(10)
		-- for i = 5, 1, -1 do
			-- cp[i] = CreateFrame('FRAME', nil, cp)
			-- cp[i]:SetWidth(width/5)
			-- cp[i]:SetHeight(10)
			-- cp[i].tex = cp[i]:CreateTexture(nil, 'BORDER')
			-- cp[i].tex:SetAllPoints(cp[i])
			-- cp[i].tex:SetTexture(settings.src.textures.bartexture)
			-- cp[i].tex:SetVertexColor(0.9, 0.3, 0.1, 1)
			-- if (i == 5) then
				-- cp[i]:SetPoint('TOPRIGHT', cp, 'TOPRIGHT', 0, 0)
			-- else
				-- cp[i]:SetPoint('TOPRIGHT', cp[i+1], 'TOPLEFT', 0, 0)
			-- end
		-- end
		-- new code
		for i = 1, 5 do
			cp[i] = CreateFrame('Frame', nil, cp)
			cp[i]:SetWidth(cpWidth)
			cp[i]:SetHeight(10)
			cp[i].tex = cp[i]:CreateTexture(nil, 'BORDER')
			cp[i].tex:SetAllPoints(cp[i])
			cp[i].tex:SetTexture(settings.src.textures.bartexture)
			cp[i]:SetFrameLevel(cp:GetFrameLevel()-1)
		end
		cp[1].tex:SetVertexColor(0, 0.5, 0, 1)
		cp[1]:SetPoint('TOPLEFT', cp, 'TOPLEFT', 0, 0)
		cp[2].tex:SetVertexColor(1, 0.8, 0, 1)
		cp[2]:SetPoint('TOPLEFT', cp[1], 'TOPRIGHT', 5, 0)
		cp[3].tex:SetVertexColor(1, 0.8, 0, 1)
		cp[3]:SetPoint('TOPLEFT', cp[2], 'TOPRIGHT', 5, 0)
		cp[4].tex:SetVertexColor(1, 0.8, 0, 1)
		cp[4]:SetPoint('TOPLEFT', cp[3], 'TOPRIGHT', 5, 0)
		cp[5].tex:SetVertexColor(1, 0.1, 0, 1)
		cp[5]:SetPoint('TOPLEFT', cp[4], 'TOPRIGHT', 5, 0)
		-- new code
		cp[1].back = cp[1]:CreateTexture(nil, 'BACKGROUND')
		cp[1].back:SetAllPoints(cp)
		cp[1].back:SetTexture(settings.src.textures.bartexture)
		cp[1].back:SetVertexColor(0, 0, 0, 1)
		lib.CreateBorder(cp, 10)
		for _, tex in ipairs(cp.borderTextures) do
			tex:SetParent(cp)
		end

		return cp
	end

	--[[
		VOID ComboPointUpdate(FRAME self, STRING event, STRING unit)
	]]
	core.ComboPointUpdate = function(self, event, unit)
		if(unit == 'pet') then return end

		local cp
		if(UnitExists'vehicle') then
			cp = GetComboPoints('vehicle', 'target')
		else
			cp = GetComboPoints('player', 'target')
		end

		local cpoints = self.CPoints
		for i=1, MAX_COMBO_POINTS do
			if(i <= cp) then
				-- cpoints[i]:Show()
				cpoints[i]:SetAlpha(1)
			else
				-- cpoints[i]:Hide()
				cpoints[i]:SetAlpha(0.15)
			end
		end

		if ( cp > 0 ) then
			self.Debuffs:SetPoint('BOTTOM', self.CPoints, 'TOP', 0, 10)
			cpoints:Show()
		else
			self.Debuffs:SetPoint('BOTTOM', self, 'TOP', 0, 15)
			cpoints:Hide()
		end
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
		-- self.Range = CreateFrame('Frame', self, nil)
		-- self.Range.insideAlpha = 1
		-- self.Range.outsideAlpha = 0.4

		self.Threat = CreateFrame('Frame', self, nil)
		self.Threat.Override = core.UpdateThreat 
	end

	--[[ Apply general oUF-plugins
		VOID ApplyPlugins(FRAME self)
	]]
	core.ApplyPlugins = function(self)
		-- lib.debugging('entering ApplyPlugins()')

		if(IsAddOnLoaded('oUF_DebuffHighlight')) then					-- TODO: Make this shit VISIBLE!
			self.DebuffHighlight = self.Health:CreateTexture(nil, 'ARTWORK')
			self.DebuffHighlight:SetTexture('Interface\\AddOns\\oUF_Predator\\gfx\\debuff_highlight')
			self.DebuffHighlight:SetBlendMode('ADD')
			self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
			self.DebuffHighlight:SetAllPoints(self)
			self.DebuffHighlightAlpha = 0.5
			self.DebuffHighlightFilter = true
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

-- ************************************************************************************************	

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
		if (UnitIsDead(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.dead)
		elseif (UnitIsGhost(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.ghost)
		elseif (not UnitIsConnected(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.offline)
		else
			if (min ~= max) then
				health.value:SetFormattedText('|cffDDDDDD%s | %d%%|r', lib.Shorten(min), (min/max)*100)
			else
				health.value:SetText(min)
			end
		end
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Health-value, only current value
		VOID UpdateHealth_min(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_min = function(health, unit, min, max)
		if (UnitIsDead(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.dead)
		elseif (UnitIsGhost(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.ghost)
		elseif (not UnitIsConnected(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.offline)
		else
			health.value:SetText(min)
		end
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Health-value, deficit (healermode)
		VOID UpdateHealth_deficit(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_deficit = function(health, unit, min, max)
		if (UnitIsDead(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.dead)
		elseif (UnitIsGhost(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.ghost)
		elseif (not UnitIsConnected(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.offline)
		else
			if (min ~= max) then
				health.value:SetFormattedText('|cffCC0000-%s|r', lib.Shorten((max-min)))
			else
				health.value:SetText(min)
			end
		end
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Health-value, deficit, replacing the name
		VOID UpdateHealth_player(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_deficit_name = function(health, unit, min, max)
		if (UnitIsDead(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.dead)
			health:GetParent().Name:Hide()
			health.value:Show()
		elseif (UnitIsGhost(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.ghost)
			health:GetParent().Name:Hide()
			health.value:Show()
		elseif (not UnitIsConnected(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.offline)
			health:GetParent().Name:Hide()
			health.value:Show()
		else
			if (min ~= max) then
				health:GetParent().Name:Hide()
				health.value:SetFormattedText('|cffCC0000-%s|r', lib.Shorten((max-min)))
				health.value:Show()
			else
				health:GetParent().Name:Show()
				health.value:Hide()
			end
		end
		health:GetParent():UNIT_NAME_UPDATE(event, unit)
	end

	--[[ Health-value in percent, replacing the name
		VOID UpdateHealth_player(FRAME health, UNIT unit, INT min, INT max)
	]]
	core.UpdateHealth_percent_name = function(health, unit, min, max)
		if (UnitIsDead(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.dead)
			health:GetParent().Name:Hide()
			health.value:Show()
		elseif (UnitIsGhost(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.ghost)
			health:GetParent().Name:Hide()
			health.value:Show()
		elseif (not UnitIsConnected(unit)) then
			health:SetValue(0)
			health.value:SetText(settings.options.strings.offline)
			health:GetParent().Name:Hide()
			health.value:Show()
		else
			if (min ~= max) then
				health:GetParent().Name:Hide()
				health.value:SetFormattedText('|cffDDDDDD%d%%|r', (min/max)*100)
				health.value:Show()
			else
				health:GetParent().Name:Show()
				health.value:Hide()
			end
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

-- ************************************************************************************************

	--[[ Filter the players buffs
		BOOL FilterBuffs_player(..., INT spellID)
	]]
	core.FilterBuffs_player = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		-- lib.debugging(spellID..'('..name..')')
		return lib.FilterGeneric(spellID, name, settings.options.playerBuffs, icon, caster)
	end

	--[[ Filter the players debuffs
		BOOL FilterDebuffs_player(..., INT spellID)
	]]
	core.FilterDebuffs_player = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		return lib.FilterGeneric(spellID, name, settings.options.playerDebuffs, icon, caster)
	end

	--[[ Filter buffs
		BOOL FilterBuffs(..., INT spellID)
	]]
	core.FilterBuffs = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		-- lib.debugging('entering FilterBuffs() with spellID='..spellID)
		if ( UnitIsFriend(unit, 'player') ) then
			return lib.FilterGeneric(spellID, name, settings.options.friendsBuffs, icon, caster)
		else
			return lib.FilterGeneric(spellID, name, settings.options.enemyBuffs, icon, caster)
		end
	end

	--[[ Filter debuffs
		BOOL FilterDebuffs(..., INT spellID)
	]]
	core.FilterDebuffs = function(icons, unit, icon, name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID)
		if ( UnitIsFriend(unit, 'player') ) then
			return lib.FilterGeneric(spellID, name, settings.options.friendsDebuffs, icon, caster)
		else
			return lib.FilterGeneric(spellID, name, settings.options.enemyDebuffs, icon, caster)
		end
	end

	--[[
	
	]]
	core.PostUpdateIcon = function(icons, unit, icon, index, offset, filter, isDebuff)
		if ( settings.src.playerUnits[icon.caster] ) then
			icon.icon:SetDesaturated(false)	
		else
			icon.icon:SetDesaturated(true)	
		end
	end

-- ************************************************************************************************
ns.core = core											-- handover of the core-functions to the namespace