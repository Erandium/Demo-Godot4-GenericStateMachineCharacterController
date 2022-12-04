extends BaseCharacter3DStateResource
class_name Character3DStateResourceJumpVelocity
##State resource: Jump Velocity

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

##Horizontal speed
@export var horizontalMovementSpeed : float = 0
##Vertical acceleration (positive is down)
@export var gravityAcceleration : float = 9.8

func _init() -> void:
	stateScript = load("res://Code/GenericStatemachine/States/Character3DState_Jump_Velocity.gd")

func FromJson(data : Dictionary) -> void:
	super.FromJson(data)
	jumpImpulse.x = data["jumpImpuse"]["x"]
	jumpImpulse.y = data["jumpImpuse"]["y"]
	jumpImpulse.z = data["jumpImpuse"]["z"]
	horizontalMovementSpeed = data["horizontalMovementSpeed"]
	gravityAcceleration = data["gravityAcceleration"]
