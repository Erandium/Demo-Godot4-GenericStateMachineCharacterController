extends Character3DEntity
class_name Player

@onready var cameraRig : CameraRig = $CameraRig

func _ready() -> void:
	stateManager = $GenericStateManager
	inputBufferManager = $InputBufferManager
	bodyPivot = $BodyPivot
	cameraRig.player = self
	Init()


func _process(delta: float) -> void:
	GetNewInputs()

##Look for action that have been pressed in the last frame and fill the buffer
func GetNewInputs() -> void:
	for action in InputMapping.userMappableInputs:
		if Input.is_action_just_pressed(action):
			inputBufferManager.inputBuffer.append(BufferInputDescriptor.new(action))


func _physics_process(delta: float) -> void:
	stateManager.Process(delta)

func MeshToRotate() -> bool:
	return cameraRig.currentCameraMode == CameraRig.CameraMode.Free
