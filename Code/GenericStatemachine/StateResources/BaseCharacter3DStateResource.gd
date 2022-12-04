extends Resource
class_name BaseCharacter3DStateResource
##Base class for the resources containing state data

##name of the state
@export var stateName : String = ""
##Rotation speed of the mesh
@export var meshRotationSpeed : float = 0
##List of possible state changes
@export var nextStateConditionList : Array[Character3DStateChangeValidator] = []

##Script to add to the node when creating the state machine
var stateScript

func _init() -> void:
	#assign the corresponding script
	stateScript = load("res://Code/GenericStatemachine/States/BaseCharacter3DState.gd")

##Load data from json
func FromJson(data : Dictionary) -> void:
	meshRotationSpeed = data["meshRotationSpeed"]
	for condition in data["conditions"]:
		var validator : Character3DStateChangeValidator = Character3DStateChangeValidator.new()
		validator.FromJson(condition)
		nextStateConditionList.append(validator) 
