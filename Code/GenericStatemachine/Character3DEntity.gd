extends CharacterBody3D
class_name Character3DEntity
##Class reprenting a ChracterBody3D
##
##This class is the commun interface that represente a characterBody3D for the generic state-machine

##Reference to the state manager
var stateManager : GenericCharacter3DStateManager = null

##Reference to the input buffer manager, used to get the current inputs
var inputBufferManager : InputBufferManager = null

##Reference to the body mesh rotation axis
var bodyPivot : Node3D = null


func Init() -> void:
	if stateManager != null:
		stateManager.Init(self)

##Determine if the mesh should be rotated
func MeshToRotate() -> bool:
	return false
