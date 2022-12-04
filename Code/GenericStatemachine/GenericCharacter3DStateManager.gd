extends Node
class_name GenericCharacter3DStateManager
##Generate and manage the state-machine for a Character3DEntity

enum DATA_SOURCE {
	FILE,
	RESOURCE
}

##Select if the data are in a file or a resource
@export var dataSource : DATA_SOURCE = DATA_SOURCE.RESOURCE

##Path to the file describing the state machine
@export var stateMachineFilePath : String = ""

##Resource describing the state machine
@export var stateMachineResource : Character3DStateMachineResource = null

##List of states that should be generated
var stateResourceList : Array[BaseCharacter3DStateResource] = []

##Hold the references to the state in the form stateName:state(object)
var stateDictionary : Dictionary = {}

##Hold the current state
var currentState : BaseCharacter3DState = null
##Hold the current state name
var currentStateName : String = ""



func Init(entity : Character3DEntity) -> void:
	#Load list from the correct source
	if dataSource == DATA_SOURCE.FILE:
		stateResourceList = _LoadStateMachine(stateMachineFilePath)
	else:
		stateResourceList = stateMachineResource.stateList
	
	#generate the node for the state machine
	for state in stateResourceList:
		var node : Node = Node.new()
		node.set_script(state.stateScript)
		(node as BaseCharacter3DState).entity = entity
		(node as BaseCharacter3DState).SetStateData(state)
		add_child(node)
		stateDictionary[state.stateName] = node
	
	#make the default state the first state of the list
	ChangeState(stateResourceList[0].stateName)




##Call the check input and process methodes of the current active state
func Process(delta : float) -> void:
	#check for update to the state
	var newStateName : String = currentState.CheckState()
	if newStateName != "":
		ChangeState(newStateName)
	
	#call the normal process of the state
	currentState.Process(delta)

##Change the state to the state corresponding to the given state name
func ChangeState(newState: String) -> void:
	#Exit the current state if it exist
	if currentState:
		currentState.Exit()
	
	#switch tracknig variable with the new state
	currentStateName = newState
	currentState = stateDictionary[newState]
	
	#call state entered fonction
	currentState.Enter()



#Generate the state list from data in a json file
func _LoadStateMachine(stateMachineFilePath : String) -> Array[BaseCharacter3DStateResource]:
	var data : Dictionary = _LoadStateMachineJson(stateMachineFilePath)
	var stateList : Array[BaseCharacter3DStateResource] = []
	for stateName in data.keys():
		var stateData : Dictionary = data[stateName]
		match stateData["stateType"]:
			"airAcceleration":
				var stateResource := Character3DStateResourceAirAcceleration.new()
				stateResource.stateName = stateName
				stateResource.FromJson(stateData)
				stateList.append(stateResource)
			"airVelocity":
				var stateResource := Character3DStateResourceAirVelocity.new()
				stateResource.stateName = stateName
				stateResource.FromJson(stateData)
				stateList.append(stateResource)
			"idle":
				var stateResource := Character3DStateResourceIdle.new()
				stateResource.stateName = stateName
				stateResource.FromJson(stateData)
				stateList.append(stateResource)
			"climb":
				var stateResource := Character3DStateResourceClimb.new()
				stateResource.stateName = stateName
				stateResource.FromJson(stateData)
				stateList.append(stateResource)
			"jumpAcceleration":
				var stateResource := Character3DStateResourceJumpAcceleration.new()
				stateResource.stateName = stateName
				stateResource.FromJson(stateData)
				stateList.append(stateResource)
			"jumpVelocity":
				var stateResource := Character3DStateResourceJumpVelocity.new()
				stateResource.stateName = stateName
				stateResource.FromJson(stateData)
				stateList.append(stateResource)
			"walkAcceleration":
				var stateResource := Character3DStateResourceWalkAcceleration.new()
				stateResource.stateName = stateName
				stateResource.FromJson(stateData)
				stateList.append(stateResource)
			"walkVelocity":
				var stateResource := Character3DStateResourceWalkVelocity.new()
				stateResource.stateName = stateName
				stateResource.FromJson(stateData)
				stateList.append(stateResource)
	return stateList

#Get json file and parse it as a dictionary
func _LoadStateMachineJson(stateMachineFilePath : String) -> Dictionary:
	var jsonDict : Dictionary = {}
	var json : JSON = JSON.new()
	if FileAccess.file_exists(stateMachineFilePath):
		var file := FileAccess.open(stateMachineFilePath, FileAccess.READ)
		if file != null:
			var jsonError := json.parse(file.get_as_text())
			if jsonError == OK:
				jsonDict = json.get_data()
	return jsonDict
