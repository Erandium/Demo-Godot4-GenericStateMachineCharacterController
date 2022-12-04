extends BaseCharacter3DStateResource
class_name Character3DStateResourceAirAcceleration
##State ressource: Air acceleration

##max horizontal speed 
@export var horizontalMaxSpeed : float = 0
##max fall speed
@export var fallMaxSpeed : float = 0
##horizontal acceleration
@export var horizontalAcceleration : float = 0
##vertical acceleration (positive is down)
@export var gravityAcceleration : float = 9.8
##air friction
@export var friction : float = 0


func _init() -> void:
	stateScript = load("res://Code/GenericStatemachine/States/Character3DState_Air_Acceleration.gd")

func FromJson(data : Dictionary) -> void:
	super.FromJson(data)
	horizontalMaxSpeed = data["horizontalMaxSpeed"]
	gravityAcceleration = data["gravityAcceleration"]
	horizontalAcceleration = data["horizontalAcceleration"]
	friction = data["friction"]
	fallMaxSpeed = data["fallMaxSpeed"]
