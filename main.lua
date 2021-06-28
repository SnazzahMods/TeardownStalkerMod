#include "ui.lua"
#include "util.lua"
#include "debug.lua"

-- Globals
debugFlip = false
disableMod = false

-- Assets
figureSprite = 0
heartbeatSound = 0
heartbeat2Sound = 0
deathSound = 0
droneLoop = 0
spsawnLoop = 0
whisperLoop = 0
fogSprite = 0

-- Figure Variables
figureSpawned = false
figurePaused = false
ttsDefault = 10
timeTillSpawn = ttsDefault
figurePos = Vec(0, 0, 0)
distance = 10000
killed = false
baseWalkSpeed = 4
walkSpeed = baseWalkSpeed

-- Options
figureVisible = true
figureSpritePath = "MOD/sprites/stalkers/default.png"
figureSoundPath = "MOD/sfx/stalker/whisper.ogg"
figureSilent = false
figureDestructive = false
fogDifficult = false
timeHalf = false

-- FX variables
heartbeatTimer = 0
renderFog = true

-- UI variables
uiShowSpawnFX = false
uiSpawnFXTime = 1

function init()
	dataInit()

	-- Load assets
	fogSprite = LoadSprite("MOD/sprites/square.png")
	figureSprite = LoadSprite(figureSpritePath)
	heartbeatSound = LoadSound("MOD/sfx/heartbeat.ogg")
	heartbeat2Sound = LoadSound("MOD/sfx/heartbeat2.ogg")
	deathSound = LoadSound("MOD/sfx/death.ogg")
	droneLoop = LoadLoop("MOD/sfx/droneloop.ogg")
	spawnLoop = LoadLoop("MOD/sfx/spawnloop.ogg")
	whisperLoop = LoadLoop(figureSoundPath)

	-- Disable Mod in certain levels
	local id = GetString("game.levelid")
	if string.find(id,  "hub") or id == "about" then
		disableMod = true
		return
	end

	-- Set position
	local playerPos = GetPlayerTransform().pos
	playerPos[2] = playerPos[2] + 1
	figurePos = playerPos
end

function tick(dt)
	debugTick()
	uiTick()

	local playerPos = GetPlayerTransform().pos
	playerPos[2] = playerPos[2] + 1

	distance = VecDistance(figurePos, playerPos)
	local cameraTransform = GetCameraTransform()
	local cameraPos = GetCameraTransform().pos

	-- Speed up figure from long distances
	local distanceMult = (math.min(math.max(distance, 20), 100) / 20)
	walkSpeed = baseWalkSpeed * distanceMult

	-- Failsafe if player wasn't actually killed
	if killed and GetPlayerHealth() ~= 0 then
		killed = false
	end

	-- Background Loop
	if figureSpawned and not disableMod then
		PlayLoop(spawnLoop, cameraPos, 0.5)
	else
		PlayLoop(droneLoop, cameraPos, 0.5)
	end

	-- Render Sprite
	if figureSpawned and figureVisible and not killed then
		local cameraPos = VecCopy(cameraTransform.pos)
		local dirToPlayer = VecDirection(figurePos, cameraPos)
		local spriteRot = QuatLookAt(figurePos, cameraPos)
		local spriteTransform = Transform(figurePos, spriteRot)
		DrawSprite(figureSprite, spriteTransform, 2.5, 2.5, 1, 1, 1, 1, true, false)
	end

	-- Fog
	if renderFog then
		local forwardDirection = TransformToParentVec(cameraTransform, Vec(0, 0, -2))

		local fogStep = 1
		local fogLayers = 100
		local fogStart = 50

		for i = 1, fogLayers do
			local spritePos = VecAdd(cameraTransform.pos, VecScale(forwardDirection, fogStart - i * fogStep))
			local spriteRot = QuatLookAt(spritePos, cameraTransform.pos)

			local fogColor = 0.1
			if fogDifficult then
				fogColor = 0.25
			end

			DrawSprite(fogSprite, Transform(spritePos, spriteRot), 200, 200, fogColor, fogColor, fogColor, 0.5, true, true)
		end
	end

	-- Figure Behavior
	if figureSpawned then
		if not figurePaused then
			--  Movement
			local dirVector = VecDirection(figurePos, playerPos)
			local newPos = VecCopy(figurePos)
			local movedDistance = VecScale(dirVector, walkSpeed * GetTimeStep())
			newPos = VecAdd(newPos, movedDistance)
			figurePos = newPos

			if figureDestructive then
				MakeHole(figurePos, 1.2, 1.2, 1.2, figureSilent)
			end

			if distance < 1.5 and not killed then
				killed = true
				SetPlayerHealth(0)
				SetString("level.state", "fail_stalker")
				PlaySound(deathSound)
			end
		end

		-- Heartbeat
		if heartbeatTimer <= 0 and not killed and not figureSilent then
			if distance < 5 then
				heartbeatTimer = 0.3
				PlaySound(heartbeat2Sound)
			elseif distance < 10 then
				heartbeatTimer = 0.5
				PlaySound(heartbeat2Sound)
			elseif distance < 20 then
				heartbeatTimer = 1
				PlaySound(heartbeatSound)
			else
				heartbeatTimer = 0.1
			end
		else
			heartbeatTimer = heartbeatTimer - GetTimeStep()
		end

		-- Sound Loop
		if not figureSilent and not killed then
			PlayLoop(whisperLoop, figurePos, 0.5)
		end
	end

	-- Timer
	if not figurePaused and timeTillSpawn <= 0 and not figureSpawned then
		figureSpawned = true
		uiShowSpawnFX = true
		if figureDestructive then
			Explosion(figurePos, 1)
		end
	elseif not figurePaused and not disableMod then
		if timeTillSpawn < 3 and not figureSpawned then
			SpawnParticle("smoke", figurePos, Vec(0, 0, 0), 0.5, 0.5)
		end
		timeTillSpawn = timeTillSpawn - GetTimeStep()
	end

	-- Debug Flip
	if not renderFog or figurePaused then
		debugFlip = true
	end
end

function draw()
	UiPush()
		if not disableMod then
			drawTimer()
			drawSpawnFX()
		end
		drawEffectsText()
		debugDraw()
	UiPop()
end
