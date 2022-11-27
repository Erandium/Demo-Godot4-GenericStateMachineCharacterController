extends BaseCharacter3DStateResource
class_name Character3DStateResourceWalkVelocity
##State resource: Walk velocity

##Horizontal speed
@export var speed : float = 0

func _init() -> void:
	script = load("res://Code/GenericStatemachine/States/Character3DState_Walk_Velocity.gd")

func FromJson(data : Dictionary) -> void:
	super.FromJson(data)
	speed = data["speed"]
