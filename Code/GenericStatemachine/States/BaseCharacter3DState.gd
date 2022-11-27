extends Node
class_name BaseCharacter3DState
##Base class representing a state used by a character3D state machine

##Reference to the entity 
var entity : Character3DEntity
##Data use by the state
var stateData : BaseCharacter3DStateResource

##Called when entering the state
func Enter() -> void:
	pass

##Called when exiting the state
func Exit() -> void:
	pass

##Called each frame to chack if the state should be changed
func CheckState() -> String:
	for validator in stateData.nextStateConditionList:
		var nextState = validator.Evaluate(entity)
		if nextState != "":
			return nextState
	return ""

##Called each frame only when the state is the active one
func Process(delta : float) -> void:
	pass

##Set the state data
func SetStateData(data : BaseCharacter3DStateResource) -> void:
	stateData = data

##Get the currently pressed horizontal direction
func GetPressedDirection() -> Vector2:
	var inputBuffer : Array[BufferInputDescriptor] = entity.inputBufferManager.inputBuffer
	var direction : Vector2 = Vector2.ZERO
	for input in inputBuffer:
		if input.isPressed:
			match  input.action:
				"player_movement_front":
					direction.x += 1
				"player_movement_back":
					direction.x -= 1
				"player_movement_right":
					direction.y += 1
				"player_movement_left":
					direction.y -= 1
	return direction

##Rotate the entity mesh toward a direction
func RotateEntityMesh(direction : Vector2, delta : float) -> void:
	if direction != Vector2.ZERO:
		entity.bodyPivot.rotation.y = lerp_angle( \
			entity.bodyPivot.rotation.y, \
			atan2(-direction.y, direction.x), \
			stateData.meshRotationSpeed * delta)
