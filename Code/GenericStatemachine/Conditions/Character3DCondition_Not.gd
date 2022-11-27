extends BaseCharacter3DCondition
class_name Character3DConditionNot
##Condition : not logic operaton

@export var condition : BaseCharacter3DCondition = null

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	return not condition.Evaluate(entity) 

##Generate the condition based on json data
func FromJson(data : Dictionary) -> void:
	condition = CreateNewCondition(data["condition"])
