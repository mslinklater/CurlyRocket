-- Materials

function AddPhysicsMaterials()
	FCPhysics.SetMaterial( "wall", { friction = 0.5, restitution = 0.2, density = 1 } )
	FCPhysics.SetMaterial( "ice", { friction = 0.0, restitution = 0.2, density = 1 } )
	FCPhysics.SetMaterial( "gem", { friction = 0.05, restitution = 0.4, density = 1 } )
	FCPhysics.SetMaterial( "ball", { friction = 0.5, restitution = 0.3, density = 1 } )
	FCPhysics.SetMaterial( "bomb", { friction = 0.5, restitution = 0.2, density = 2 } )
end
