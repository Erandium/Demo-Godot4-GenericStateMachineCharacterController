extends CharacterBody3D
class_name Character3DEntity
##Class reprenting a ChracterBody3D
##
##This class is the commun interface that represente a characterBody3D for the generic state-machine

##Reference to the state manager, only used for forced state change (not in this project)
var stateManager : GenericCharacter3DStateManager = null

##Reference to the input buffer manager, used to get the current inputs
var inputBufferManager : InputBufferManager = null

##Reference to the body mesh rotation axis
var bodyPivot : Node3D = null


func Init(stateMachineName : String) -> void:
	if stateManager != null:
		stateManager.Init(self)

func MeshToRotate() -> bool:
	return false
