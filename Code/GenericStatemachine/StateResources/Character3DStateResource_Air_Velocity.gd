extends BaseCharacter3DStateResource
class_name Character3DStateResourceAirVelocity
##State resource: Air velocity

##Horizontal speed
@export var horizontalMovementSpeed : float = 0
##Vertical acceleration (positive is down)
@export var gravityAcceleration : float = 9.8

func _init() -> void:
	stateScript = load("res://Code/GenericStatemachine/States/Character3DState_Air_Velocity.gd")

func FromJson(data : Dictionary) -> void:
	super.FromJson(data)
	horizontalMovementSpeed = data["horizontalMovementSpeed"]
	gravityAcceleration = data["gravityAcceleration"]
