local Chunk = require(script.Parent.Parent.Modules.chunker)

local RENDER_DISTANCE = 10
local CHUNKS_LOADED_PER_TICK = 4
local CAMERA = workspace.CurrentCamera

local centerPosX
local centerPosZ
local chunks = {}
local chunkCount = 0
local fastLoad = true

local function chunkWait()
	chunkCount = (chunkCount + 1) % CHUNKS_LOADED_PER_TICK
	if chunkCount == 0 and not fastLoad then
		wait()
	end
end

local function updateCenterPosFromCamera()
	local camPos = CAMERA.CFrame.Position
	
	centerPosX = math.floor(camPos.X / Chunk.WIDTH_SIZE_X)
	centerPosZ = math.floor(camPos.Z / Chunk.WIDTH_SIZE_Z)
end

local function doesChunkExist(x, z)
	for index, chunk in pairs(chunks) do
		if chunk.x == x and chunk.z == z then
			return true
		end
	end
	
	return false
end

local function isChunkOutOfRange(chunk)
	if math.abs(chunk.x - centerPosX) > RENDER_DISTANCE
		or math.abs(chunk.z - centerPosZ) > RENDER_DISTANCE then
		return true
	end
	
	return false
end

local function makeChunks()
	for x = centerPosX - RENDER_DISTANCE, centerPosX + RENDER_DISTANCE do
		for z = centerPosZ - RENDER_DISTANCE, centerPosZ + RENDER_DISTANCE do
			if not doesChunkExist(x, z) then
				table.insert(chunks, Chunk.new(x, z))
				chunkWait()
			end
		end
	end
end

local function destroyChunks()
	local n = #chunks
	
	for i = 1, n do
		local chunk = chunks[i]
		
		if isChunkOutOfRange(chunk) then
			chunk:Destroy()
			chunkWait()
			
			chunks[i] = nil
		end
	end
	
	local j = 0
	for i = 1, n do
		if chunks[i] ~= nil then
			j += 1
			chunks[j] = chunks[i]
		end
	end
	
	for i = j + 1, n do
		chunks[i] = nil
	end
end

while true do
	updateCenterPosFromCamera()
	
	destroyChunks()
	
	makeChunks()
	
	fastLoad = false
	
	wait(0.5)
end