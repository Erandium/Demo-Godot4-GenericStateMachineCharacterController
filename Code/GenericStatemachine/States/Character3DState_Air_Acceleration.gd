extends BaseCharacter3DState
class_name Character3DStateAirAcceleration
##State: apply gravity and horizontal movement as acceleration

func Process(delta : float) -> void:
	var horizontalDirection : Vector2 = GetPressedDirection()
	var direction : Vector3 = (entity.transform.basis * Vector3(horizontalDirection.x, 0, horizontalDirection.y)).normalized()
	
	entity.velocity.x += direction.x * stateData.horizontalAcceleration * delta
	entity.velocity.z += direction.z * stateData.horizontalAcceleration * delta
	
	entity.velocity.x -= entity.velocity.x * stateData.friction * delta
	entity.velocity.z -= entity.velocity.z * stateData.friction * delta
	
	entity.velocity.y -= stateData.gravityAcceleration * delta
	
	if pow(entity.velocity.x, 2) + pow(entity.velocity.z, 2) > pow(stateData.horizontalMaxSpeed, 2):
		var factor : float = stateData.horizontalMaxSpeed / sqrt(pow(entity.velocity.x, 2) + pow(entity.velocity.z, 2))
		entity.velocity.x *= factor
		entity.velocity.z *= factor
	
	if entity.velocity.y < -stateData.fallMaxSpeed:
		entity.velocity.y = -stateData.fallMaxSpeed
	
	entity.move_and_slide()
	
	#Rotate entity mesh to direction if the camera mode is FREE
	if entity.MeshToRotate():
		RotateEntityMesh(horizontalDirection.normalized(), delta)
	else:
		RotateEntityMesh(Vector2(1,0), delta)
