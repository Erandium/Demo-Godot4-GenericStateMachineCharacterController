extends BaseCharacter3DCondition
class_name Character3DConditionInputSetPressed
##Condition : at least one input of a list pressed 

##List of action names as found in the input buffer
@export var actionList : Array[String] = []

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	for event in entity.inputBufferManager.inputBuffer:
		if event.action in actionList and event.isPressed:
			return true
	return false

##Generate the condition based on json data
func FromJson(data : Dictionary) -> void:
	actionList = data["actionList"]
