extends BaseCharacter3DState
class_name Character3DStateAirVelocity
##State : apply gravity as acceleration 
##and horizontal movement as instantaneous speed

func Process(delta : float) -> void:
	var horizontalDirection : Vector2 = GetPressedDirection()
	var direction : Vector3 = (entity.transform.basis * Vector3(horizontalDirection.x, 0, horizontalDirection.y)).normalized()
	
	entity.velocity.x = direction.x * stateData.horizontalMovementSpeed
	entity.velocity.z = direction.z * stateData.horizontalMovementSpeed
	
	entity.velocity.y -= stateData.gravityAcceleration * delta
	
	
	entity.move_and_slide()
	
	#Rotate entity mesh to direction if the camera mode is FREE
	if entity.MeshToRotate():
		RotateEntityMesh(horizontalDirection.normalized(), delta)
	else:
		RotateEntityMesh(Vector2(1,0), delta)
