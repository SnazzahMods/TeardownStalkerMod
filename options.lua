#include "util.lua"
#include "version.lua"

--#region effects
	local effects = {}

	table.insert(effects, {
		title = "Invisible",
		titleColor = Vec(0.61, 0.35, 0.71),
		description = "The stalker is invisible to the naked eye. Need to rely on other senses.",
		getValue = function()
			return not figureVisible
		end,
		click = function(newVal)
			if newVal == nil then newVal = figureVisible end
			SetBool(moddataPrefix .. "Invisible", newVal)
			figureVisible = not newVal
		end
	})

	table.insert(effects, {
		title = "Silent",
		titleColor = Vec(0.4, 0.4, 0.4),
		description = "The stalker is silent. Not even your heartbeat can sense it's presence.",
		getValue = function()
			return figureSilent
		end,
		click = function(newVal)
			if newVal == nil then newVal = not figureSilent end
			SetBool(moddataPrefix .. "Silent", newVal)
			figureSilent = newVal
		end
	})

	table.insert(effects, {
		title = "Destructive",
		titleColor = Vec(0.9, 0.49, 0.13),
		description = "The stalker destroys everything in it's path.",
		getValue = function()
			return figureDestructive
		end,
		click = function(newVal)
			if newVal == nil then newVal = not figureDestructive end
			SetBool(moddataPrefix .. "Destructive", newVal)
			figureDestructive = newVal
		end
	})

	table.insert(effects, {
		title = "Terrible Fog",
		titleColor = Vec(0.9, 0.9, 0.9),
		description = "Can't see much in this fog.",
		getValue = function()
			return fogDifficult
		end,
		click = function(newVal)
			if newVal == nil then newVal = not fogDifficult end
			SetBool(moddataPrefix .. "BadFog", newVal)
			fogDifficult = newVal
		end
	})

	table.insert(effects, {
		title = "Rushed Out",
		titleColor = Vec(0.9, 0, 0),
		description = "Not enough time to prepare. Not enough time to survive.",
		getValue = function()
			return timeHalf
		end,
		click = function(newVal)
			if newVal == nil then newVal = not timeHalf end
			SetBool(moddataPrefix .. "HalfTime", newVal)
			timeHalf = newVal
		end
	})

	table.insert(effects, {
		title = "Swift Killer",
		titleColor = Vec(0.9, 0.9, 1),
		description = "You should be moving at all times.",
		getValue = function()
			return figureMoreSpeed
		end,
		click = function(newVal)
			if newVal == nil then newVal = not figureMoreSpeed end
			SetBool(moddataPrefix .. "MoreSpeed", newVal)
			figureMoreSpeed = newVal
		end
	})
--#endregion

--#region sprites
	local sprites = {}
	local spriteIndex = 1

	table.insert(sprites, {
		file = "default",
		title = "Demon"
	})

	table.insert(sprites, {
		file = "sanic",
		title = "SANIC"
	})

	table.insert(sprites, {
		file = "doomguy",
		title = "Doom Guy"
	})

	table.insert(sprites, {
		file = "spooky",
		title = "Spooky"
	})

	table.insert(sprites, {
		file = "spookyalt",
		title = "Spooky (Alt)"
	})

	table.insert(sprites, {
		file = "spec8",
		title = "Specimen 8"
	})

	table.insert(sprites, {
		file = "spec14",
		title = "Specimen 14"
	})

	table.insert(sprites, {
		file = "shrek",
		title = "Shrek..."
	})

	table.insert(sprites, {
		file = "aooni",
		title = "Ao Oni"
	})

	table.insert(sprites, {
		file = "1up",
		title = "Green Demon"
	})

	function updateSprite()
		local sprite = sprites[spriteIndex]
		if sprite == nil then return end
		SetString(moddataPrefix .. "Sprite", sprite.file)
	end
--#endregion

--#region sound loops
	local sounds = {}
	local soundIndex = 1

	table.insert(sounds, {
		file = "whisper",
		title = "Whispers"
	})

	table.insert(sounds, {
		file = "sanic",
		title = "SANIC"
	})

	table.insert(sounds, {
		file = "circus",
		title = "Circus Music"
	})

	table.insert(sounds, {
		file = "fnafcircus",
		title = "FNAF1 Circus"
	})

	table.insert(sounds, {
		file = "sorting",
		title = "Sorting Algorithms"
	})

	table.insert(sounds, {
		file = "glitch",
		title = "Glitching"
	})

	table.insert(sounds, {
		file = "1up",
		title = "SM64 1Up"
	})

	function updateSound()
		local sound = sounds[soundIndex]
		if sound == nil then return end
		SetString(moddataPrefix .. "SoundLoop", sound.file)
	end
--#endregion

animTime = 0
local playingLoop = false

function init()
	dataInit()
	SetValue("animTime", 1, "easeout", 0.5)

	for i=1, #sprites do
		if sprites[i].file == figureSpriteFile then
			spriteIndex = i
		end
	end

	for i=1, #sounds do
		sounds[i].handle = LoadLoop("MOD/sfx/stalker/" .. sounds[i].file .. ".ogg")
		if sounds[i].file == figureSoundFile then
			soundIndex = i
		end
	end
end

function createPanel(w, h, a)
	if a == nil then a = 0.5 end
	UiColor(0,0,0, a)
	UiImageBox("ui/common/box-solid-shadow-50.png", w, h, -50, -50)
	UiWindow(w, h, true)
end

function draw()
	local windowWidth, windowHeight
	-- Background
	UiPush()
		UiColor(1, 1, 1, animTime)
		UiImage("ui/menu/slideshow/caveisland3.jpg")
	UiPop()

	-- Title
	UiPush()
		UiAlign("top center")
		UiTranslate(UiWidth()/2, 50 - (1 - animTime) * 100)

		UiTextShadow(0, 0, 0, 0.5, 2.0)

		UiFont("MOD/ui/stranger.ttf", 100)
		local w, h = UiGetTextSize("Stalker Mod")
		UiColor(1, 0.25, 0.25, animTime)
		UiText("Stalker Mod")

		UiAlign("left middle")
		UiFont("MOD/ui/stranger.ttf", 26)
		UiTranslate((w/2) + 5, 20)
		UiColor(0.4, 0.4, 0.4, animTime)
		UiText("v" .. modVersion)
		UiTranslate(-5, 20)
		UiText("dv" .. dataVersion)

		UiAlign("left center")
		UiColor(1, 1, 1, animTime)
		UiTranslate(-((w/2)), 50)
		UiFont("regular.ttf", 26)
		UiText("by Snazzah")
	UiPop()

	-- Exit Button
	UiPush()
		UiAlign("bottom center")
		UiTranslate(UiWidth()/2, UiHeight() - 50 + (1 - animTime) * 100)

		UiFont("regular.ttf", 26)
		UiColor(1, 1, 1, animTime)
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6, 1, 1, 1, animTime)
		if UiTextButton("Save and Exit", 200, 50) then
			UiSound("MOD/ui/click.ogg")
			Menu()
		end
	UiPop()

	-- Modifiers
	UiPush()
		windowWidth = 400
		windowHeight = 600
		UiAlign("top left")
		UiTranslate(UiCenter() - (windowWidth + 20) - (1 - animTime) * 100, UiMiddle() - (windowHeight/2))
		createPanel(windowWidth, windowHeight, animTime/2)

		-- Title
		UiPush()
			UiFont("bold.ttf", 48)
			UiColor(1,1,1)
			UiAlign("center")
			UiTranslate(UiCenter(), 50)
			UiText("Modifiers")
		UiPop()

		UiTranslate(0, 85)

		for i=1, #effects do
			local effect = effects[i]
			local isEffectOn = effect.getValue()

			local button = false
			local btnSound
			local w, h

			if isEffectOn then
				UiButtonImageBox("ui/common/box-solid-4.png", 4, 4, 0.15, 0.68, 0.38)
				UiColor(1, 1, 1)
				button = UiImageButton("MOD/ui/check.png", 50, 50)
				btnSound = "MOD/ui/off.ogg"
			else
				UiButtonImageBox("ui/common/box-solid-4.png", 4, 4)
				UiColor(1, 0.25, 0.25)
				button = UiBlankButton(50, 50)
				btnSound = "MOD/ui/on.ogg"
			end

			if button then
				UiSound(btnSound)
				effect.click()
			end

			if effect.titleColor then
				UiColor(effect.titleColor[1], effect.titleColor[2], effect.titleColor[3])
			else
				UiColor(1, 1, 1)
			end

			UiWordWrap(340)

			UiTranslate(60, 0)
			UiFont("bold.ttf", 26)
			w, h = UiGetTextSize(effect.title)
			UiText(effect.title)

			UiTranslate(0, h)
			UiColor(0.8, 0.8, 0.8)
			UiFont("regular.ttf", 20)
			w, h = UiGetTextSize(effect.description)
			UiText(effect.description)

			UiTranslate(-60, math.min(60, h + 10))
		end

		UiTranslate(0, 40)

		UiFont("regular.ttf", 26)
		UiColor(1, 1, 1)
		UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)

		if UiTextButton("Enable All", 190, 50) then
			UiSound("MOD/ui/click.ogg")
			UiSound("MOD/ui/on.ogg")
			for i=1, #effects do
				local effect = effects[i]
				effect.click(true)
			end
		end

		UiTranslate(200, 0)

		if UiTextButton("Disable All", 190, 50) then
			UiSound("MOD/ui/click.ogg")
			UiSound("MOD/ui/off.ogg")
			for i=1, #effects do
				local effect = effects[i]
				effect.click(false)
			end
		end

		-- UiTranslate(-220, 60)
	UiPop()

	-- Sprite
	UiPush()
		windowWidth = 400
		windowHeight = 540
		UiAlign("top left")
		UiTranslate(UiCenter() + 20 + (1 - animTime) * 100, UiMiddle() - (windowHeight/2 + 50))
		createPanel(windowWidth, windowHeight, animTime/2)

		-- Title
		UiPush()
			UiFont("bold.ttf", 48)
			UiColor(1, 1, 1)
			UiAlign("center")
			UiTranslate(UiCenter(), 50)
			UiText("Sprite")
		UiPop()

		-- Sprite Navigation
		UiPush()
			UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
			UiTranslate(0, 80)
			UiColor(1, 1, 1)

			if spriteIndex ~= 1 then
				if UiImageButton("MOD/ui/left.png", 40, 40) then
					UiSound("MOD/ui/click.ogg")
					spriteIndex = spriteIndex - 1
					updateSprite()
				end
			end

			UiTranslate(360, 0)
			if spriteIndex ~= #sprites then
				if UiImageButton("MOD/ui/right.png", 40, 40) then
					UiSound("MOD/ui/click.ogg")
					spriteIndex = spriteIndex + 1
					updateSprite()
				end
			end
		UiPop()

		-- Sprite Title
		UiPush()
			UiTranslate(UiWidth()/2, 100)
			UiAlign("center middle")
			UiColor(1, 1, 1)
			UiFont("regular.ttf", 30)
			UiText(sprites[spriteIndex].title)
		UiPop()

		-- Sprite Image
		UiPush()
			UiTranslate(0, 140)
			UiWindow(400, 400, true)
			UiColor(0.3, 0.3, 0.3, 0.5)
			UiImageBox("ui/common/box-solid-6.png", UiWidth(), UiHeight(), 6, 6)
			UiColor(1, 1, 1)
			UiTranslate(20, 20)
			UiImageBox("MOD/sprites/stalkers/" .. sprites[spriteIndex].file .. ".png", UiWidth() - 40, UiHeight() - 40, 0, 0)
		UiPop()
	UiPop()

	-- Sound Loop
	UiPush()
		windowWidth = 400
		windowHeight = 130
		UiAlign("top left")
		UiTranslate(UiCenter() + 20 + (1 - animTime) * 100, UiMiddle() + 250)
		createPanel(windowWidth, windowHeight, animTime/2)

		-- Title
		UiPush()
			UiFont("bold.ttf", 48)
			UiColor(1, 1, 1)
			UiAlign("center")
			UiTranslate(UiCenter(), 50)
			UiText("Sound Loop")
		UiPop()

		-- Sound Navigation
		UiPush()
			UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
			UiTranslate(0, 80)
			UiColor(1, 1, 1)

			if soundIndex ~= 1 then
				if UiImageButton("MOD/ui/left.png", 40, 40) then
					UiSound("MOD/ui/click.ogg")
					playingLoop = false
					soundIndex = soundIndex - 1
					updateSound()
				end
			end

			UiTranslate(310, 0)
			if soundIndex ~= #sounds then
				if UiImageButton("MOD/ui/right.png", 40, 40) then
					UiSound("MOD/ui/click.ogg")
					playingLoop = false
					soundIndex = soundIndex + 1
					updateSound()
				end
			end
		UiPop()

		-- Sound Preview
		UiPush()
			UiButtonImageBox("ui/common/box-outline-6.png", 6, 6)
			UiTranslate(UiWidth() - 40, 80)
			UiColor(1, 1, 1)

			local soundButton

			if playingLoop then
				soundButton = UiImageButton("MOD/ui/pause.png", 40, 40)
			else
				soundButton = UiImageButton("MOD/ui/play.png", 40, 40)
			end

			if soundButton then
				playingLoop = not playingLoop
			end

			-- UiSoundLoop isnt working for some reason
			-- if playingLoop then
			-- 	UiSoundLoop("MOD/sfx/stalker/" .. sounds[soundIndex].file .. ".ogg", 0.5)
			-- end

		UiPop()

		-- Sound Title
		UiPush()
			UiTranslate((UiWidth() - 40)/2, 100)
			UiAlign("center middle")
			UiColor(1, 1, 1)
			UiFont("regular.ttf", 30)
			UiText(sounds[soundIndex].title)
		UiPop()
	UiPop()
end

function tick()
	if playingLoop then
		PlayLoop(sounds[soundIndex].handle, GetCameraTransform().pos)
	end
end