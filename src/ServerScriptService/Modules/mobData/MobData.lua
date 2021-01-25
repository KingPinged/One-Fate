local module = {}

module.Dummy = {
	--| Stats	
	Health = 100,
	WalkSpeed = 16,
	JumpPower = 50,
	
	--| Damage Data
	Damage = 5,
	AttackSpeed = 1,
	AttackRange = 2,
	
	--| Agression Chase Behavior;
	Agressive = true, 
	SeekRange = 30, -- In Studs,
	
	--| Animations
	Animations = {
		Idle = "rbxassetid://180435571",
		Walk = "rbxassetid://180426354",
		Attack = {"rbxassetid://6294295392","rbxassetid://6294298468"}--"rbxassetid://5153989112", "rbxassetid://5153964818", "rbxassetid://5134956506", "rbxassetid://5153991114", "rbxassetid://6289844778"},
	}, -- Feel free to add more, however, the default ones must stay
	AttackSequence = "RNG", -- RNG or LIST, RNG by Default. If RNG then random animation from list, else in order.
	
	--| Other Data
	CastShadow = false, -- Want to create shadows or not, good for optimization
	NPCHideRange = 150, -- For Optimization, you can specifiy specific hie ranges for spawners below;
	SpecifiedHideRange = {}, -- same as specified quantity
	RespawnTime = 10,
	Quantity = 2, -- Quantity Per Spawner;
	SpecifiedQuantity = {}, --[[ Specify quantity for specific spawners.
		SpecifiedQuantity = {
			[game.Workspace.Spawners.Dummy.SpawnerNearForest] = 20, -- Exaample
		}
	]]
	Data = {
		Example = "Hi!",
		StackedExampled = {
			StatsBro = 5,
			ACFrame = CFrame.new(0,0,0),
		}
	}, -- Additional Information Can Be Provided;
	ObjectifyData = true, -- If True, will create a folder with data within the npc, else refer to tables.
	
	--| Additional Customization
	--Attack = function()
		
	--end,
	--Death = function()
		
	--end,
}

return module
