extends BaseCharacter3DState
class_name Character3DStateJumpVelocity
##State: Jump velocity then apply gravity as acceleration 
##and horizontal movement as instantaneous speed

##Track the current available jumps
var currentJumpCharge : float = 0
##Track if the jump is on cooldown
var inCooldown : bool = false

func Enter() -> void:
	if currentJumpCharge >= 1 and !inCooldown:
		currentJumpCharge -= 1
		if stateData.jumpCooldown != 0:
			inCooldown = true
			get_tree().create_timer(stateData.jumpCooldown).timeout.connect(_cooldown_callback)
		#apply impulse
		entity.velocity += entity.transform.basis * entity.bodyPivot.transform.basis * stateData.jumpImpulse
	

func Exit() -> void:
	#Shorten the jump when exiting. This create a variable hight jump
	if stateData.variableJump and entity.velocity.y > stateData.jumpImpulse.y/stateData.variableJumpFactor:
		entity.velocity.y = stateData.jumpImpulse.y/stateData.variableJumpFactor

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


func _cooldown_callback() -> void:
	inCooldown = false

func SetStateData(data : BaseCharacter3DStateResource) -> void:
	stateData = data
	currentJumpCharge = data.jumpCount

func _physics_process(delta: float) -> void:
	if stateData != null:
		if stateData.resetJumpCountOnFloor and entity.is_on_floor():
			currentJumpCharge = stateData.jumpCount
		if stateData.resetJumpCountOnWall and entity.is_on_wall():
			currentJumpCharge = stateData.jumpCount
		if stateData.resetJumpCountOnCooldown and currentJumpCharge < stateData.jumpCount:
			currentJumpCharge += delta / stateData.jumpCooldown
			if currentJumpCharge > stateData.jumpCount:
				currentJumpCharge = stateData.jumpCount
