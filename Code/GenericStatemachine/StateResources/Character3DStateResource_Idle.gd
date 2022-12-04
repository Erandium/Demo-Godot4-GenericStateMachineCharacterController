extends BaseCharacter3DStateResource
class_name Character3DStateResourceIdle
##State resource: Idle

func _init() -> void:
	stateScript = load("res://Code/GenericStatemachine/States/Character3DState_Idle.gd")
