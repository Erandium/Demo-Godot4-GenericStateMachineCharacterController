extends Node3D
class_name CameraRig
##Camera rig script
##
##Handle camera movement. [br]
##The camera horizontal rotation is fixed to the player CharacterBody3D horizontal rotation. 
##The camera rig turn the whole player when handling horizontal. 
##If the player mesh shouldn't be rotated with the camera, 
##the body pivot is rotated to compansate for the player rotation.

##Camera mode
enum CameraMode {
	Locked,
	Free
}

##Mouse mde
enum MouseMode {
	Visible,
	Hidden
}

##Initial horizontal angle, rotate the mesh too if in locked mode 
@export var defaultHAngle : float
##Initial vertical angle
@export var defaultVAngle : float
##Initial camera mode
@export var defaultCameraMode : CameraMode = CameraMode.Locked

##Max vertical angle, in deg. [br]
##0° is horizontal
@export var maxVerticalAngle : float
##Min vertical angle, in deg. [br]
##0° is horizontal
@export var minVerticalAngle : float

##Duration of the tween used when the camera go back to locked position
@export var backAnimDuration : float = 0.5

##Referance to the vertical rotation node 
@onready var cameraVAxis : Node3D = $CameraV

##Referance to the player
var player : Player

##Track the curent camera mode
var currentCameraMode : CameraMode
##Track the current mouse mode
var currentMouseMode : MouseMode
##Track if the settings menu as been opened
var inMenu : bool = false

func _ready() -> void:
	currentCameraMode = defaultCameraMode
	ApplyCameraMode()
	RotateCamera(defaultHAngle, defaultVAngle)
	#Hide mouse on player spawn
	currentMouseMode = MouseMode.Hidden
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if inMenu:
		return
	
	#get mouse movement, other kind of input are handled in the process methode
	if event is InputEventMouseMotion and currentMouseMode == MouseMode.Hidden:
		var hSensibility : float = InputMapping.sensibilityMap["mouseHorizontal"] * InputMapping.mouseSensibilityMasterFactor
		var vSensibility : float = InputMapping.sensibilityMap["mouseVertical"] * InputMapping.mouseSensibilityMasterFactor
		var horizontal : float = -event.relative.x * hSensibility
		var vertical : float = event.relative.y * vSensibility
		RotateCamera(horizontal, vertical)

func _process(delta: float) -> void:
	if inMenu:
		return
	
	#look for toggle
	for input in player.inputBufferManager.inputBuffer:
		if input.action == "camera_toggle":
			ToggleCameraMode()
			player.inputBufferManager.RemoveInput(input)
		elif input.action == "mouse_toggle":
			ToggleMouseMode()
			player.inputBufferManager.RemoveInput(input)
	
	#rotate camera
	var hSensibility : float = -InputMapping.sensibilityMap["cameraJoysticHorizontal"] * InputMapping.joysticSensibilityMasterFactor
	var vSensibility : float = InputMapping.sensibilityMap["cameraJoysticVertical"] * InputMapping.joysticSensibilityMasterFactor
	var direction : Vector2 = GetCameraInput()
	var horizontal : float = direction.x * hSensibility * delta
	var vertical : float = direction.y * vSensibility * delta
	RotateCamera(horizontal, vertical)



##Toggle mouse related variable
func ToggleMouseMode() -> void:
	match currentMouseMode:
		MouseMode.Visible:
			currentMouseMode = MouseMode.Hidden
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		MouseMode.Hidden:
			currentMouseMode = MouseMode.Visible
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

##Toggle camera related variable
func ToggleCameraMode() -> void:
	match currentCameraMode:
		CameraMode.Locked:
			currentCameraMode = CameraMode.Free
			ApplyCameraMode()
		CameraMode.Free:
			currentCameraMode = CameraMode.Locked
			ApplyCameraMode()

##Apply the current camera mode
func ApplyCameraMode() -> void:
	match currentCameraMode:
		CameraMode.Locked:
			if player != null:
				var targetAngle : float = player.rotation.y + player.bodyPivot.rotation.y
				var tween : Tween = create_tween()
				tween.tween_property(player, "rotation", Vector3(0, targetAngle, 0), backAnimDuration)
				if player.bodyPivot != null:
					tween.parallel().tween_property(player.bodyPivot, "rotation", Vector3.ZERO, backAnimDuration)
				
		CameraMode.Free:
			pass

##Freez camera process
func OpenMenu() -> void:
	inMenu = true

##Free camera process and hide mouse
func CloseMenu() -> void:
	inMenu = false
	currentMouseMode = MouseMode.Hidden
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


##Get camera input from the input buffer
func GetCameraInput() -> Vector2:
	var direction : Vector2 = Vector2.ZERO
	var inputBuffer = player.inputBufferManager.inputBuffer
	for input in inputBuffer:
		if input.isPressed:
			match  input.action:
				"camera_movement_right":
					direction.x += 1
				"camera_movement_left":
					direction.x -= 1
				"camera_movement_up":
					direction.y += 1
				"camera_movement_down":
					direction.y -= 1
	return direction

##Rotate camera and player
func RotateCamera(horizontalAngle : float, verticalAngle : float) -> void:
	if player != null :
		match currentCameraMode:
			CameraMode.Locked:
				player.rotate_y(deg_to_rad(horizontalAngle))
				cameraVAxis.rotate_x(-deg_to_rad(verticalAngle))
				cameraVAxis.rotation.x = clamp(cameraVAxis.rotation.x, \
					-deg_to_rad(maxVerticalAngle), \
					-deg_to_rad(minVerticalAngle))
			CameraMode.Free:
				player.rotate_y(deg_to_rad(horizontalAngle))
				player.bodyPivot.rotate_y(-deg_to_rad(horizontalAngle))
				cameraVAxis.rotate_x(-deg_to_rad(verticalAngle))
				cameraVAxis.rotation.x = clamp(cameraVAxis.rotation.x, \
					-deg_to_rad(maxVerticalAngle), \
					-deg_to_rad(minVerticalAngle))




