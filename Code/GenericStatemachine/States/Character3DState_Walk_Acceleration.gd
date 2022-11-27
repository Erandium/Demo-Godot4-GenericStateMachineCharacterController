extends BaseCharacter3DState
class_name Character3DStateWalkAcceleration
##State: apply horizontal movement as acceleration

func Process(delta : float) -> void:
	var horizontalDirection : Vector2 = GetPressedDirection()
	var direction : Vector3 = (entity.transform.basis * Vector3(horizontalDirection.x, 0, horizontalDirection.y)).normalized()
	
	entity.velocity.x += direction.x * stateData.acceleration * delta
	entity.velocity.z += direction.z * stateData.acceleration * delta
	
	entity.velocity -= entity.velocity * stateData.friction * delta
	
	if entity.velocity.length_squared() > stateData.maxSpeed * stateData.maxSpeed:
		entity.velocity	 *= stateData.maxSpeed / entity.velocity.length()
	
	entity.move_and_slide()
	
	#Rotate entity mesh to direction if the camera mode is FREE
	if entity.MeshToRotate():
		RotateEntityMesh(horizontalDirection.normalized(), delta)
	else:
		RotateEntityMesh(Vector2(1,0), delta)
