extends Resource
class_name Character3DStateChangeValidator
##Represent a state change

##Name of the next state
@export var nextStateName : String = ""
##Condition for the state change
@export var condition : BaseCharacter3DCondition = null

##Return the next state according to the condition. 
##An empty string mean no change
func Evaluate(entity : Character3DEntity) -> String:
	if condition.Evaluate(entity):
		return nextStateName
	return ""

##Generate state change based on json data
func FromJson(data : Dictionary) -> void:
	nextStateName = data["nextState"]
	condition = BaseCharacter3DCondition.CreateNewCondition(data["condition"])
