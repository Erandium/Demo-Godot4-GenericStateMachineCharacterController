extends BaseCharacter3DStateResource
class_name Character3DStateResourceJumpAcceleration
##State resource: Jump Acceleration

##jumpImpulse
@export var jumpImpulse : Vector3 = Vector3.ZERO
##jump count
@export var jumpCount : int = 1
##jump cooldown
@export var jumpCooldown : float = 0

##Reset to max jump count when the entity touch the ground
@export var resetJumpCountOnFloor : bool = true
##Reset to max jump count whent the entity touch a wall
@export var resetJumpCountOnWall : bool = false
##Add one jump toward the max count when the cooldown end
@export var resetJumpCountOnCooldown : bool = false

##Enable variable jump
@export var variableJump : bool = true
##Variable jump factor
@export var variableJumpFactor : float = 2

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
	stateScript = load("res://Code/GenericStatemachine/States/Character3DState_Jump_Acceleration.gd")

func FromJson(data : Dictionary) -> void:
	super.FromJson(data)
	jumpImpulse.x = data["jumpImpuse"]["x"]
	jumpImpulse.y = data["jumpImpuse"]["y"]
	jumpImpulse.z = data["jumpImpuse"]["z"]
	horizontalMaxSpeed = data["horizontalMaxSpeed"]
	gravityAcceleration = data["gravityAcceleration"]
	horizontalAcceleration = data["horizontalAcceleration"]
	friction = data["friction"]
	fallMaxSpeed = data["fallMaxSpeed"]
