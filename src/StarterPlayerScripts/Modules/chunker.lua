local X, Z = 4, 4
local WIDTH_SCALE = 15

local Chunk = {}
Chunk.__index = Chunk

Chunk.WIDTH_SIZE_X = X * WIDTH_SCALE
Chunk.WIDTH_SIZE_Z = Z * WIDTH_SCALE


local function addWater(chunk)
	local cframe = CFrame.new(
		(chunk.x + .5) * chunk.WIDTH_SIZE_X,
		-70,
		(chunk.z + .5) * chunk.WIDTH_SIZE_Z
	)

	local size = Vector3.new(
		chunk.WIDTH_SIZE_X,
		90,
		chunk.WIDTH_SIZE_Z
	)

	workspace.Terrain:FillBlock(cframe, size, Enum.Material.Water)

	chunk.waterCFrame = cframe
	chunk.waterSize = size
end


function Chunk.new(chunkPosX, chunkPosZ)
	local chunk = {
		instances = {};
		x = chunkPosX;
		z = chunkPosZ;
	}
	
	setmetatable(chunk, Chunk)
	
    addWater(chunk)
	
	return chunk
end

function Chunk:Destroy()
	for index, instance in ipairs(self.instances) do
		instance:Destroy()
	end
end

return Chunk
