extends BaseCharacter3DStateResource
class_name Character3DStateResourceWalkAcceleration
##State resource: Walk acceleration

##Horizontal max speed
@export var maxSpeed : float = 0
##Horizontal acceleration
@export var acceleration : float = 0
##Horizontal friction
@export var friction : float = 0

func _init() -> void:
	script = load("res://Code/GenericStatemachine/States/Character3DState_Walk_Acceleration.gd")

func FromJson(data : Dictionary) -> void:
	super.FromJson(data)
	maxSpeed = data["maxSpeed"]
	acceleration = data["acceleration"]
	friction = data["friction"]
