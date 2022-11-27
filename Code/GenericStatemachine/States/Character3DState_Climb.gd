extends BaseCharacter3DState
class_name Character3DStateClimb
##State : make the entity climb a wall
##
##Forward became up and backward down


func Process(delta : float) -> void:
	var verticalDirection : Vector2 = GetPressedDirection()
	var direction : Vector3 = entity.transform.basis * entity.bodyPivot.transform.basis * Vector3(0, verticalDirection.x, verticalDirection.y)
	
	direction = direction.normalized()
	
	entity.velocity.x = direction.x * stateData.horizontalClimbSpeed
	entity.velocity.y = direction.y * stateData.verticalClimbSpeed
	entity.velocity.z = direction.z * stateData.horizontalClimbSpeed
	
	entity.move_and_slide()
	
	if entity.is_on_wall():
		var wallNormal : Vector3 = entity.get_wall_normal() * entity.transform.basis
		RotateEntityMesh(Vector2(-wallNormal.x,-wallNormal.z), delta)
