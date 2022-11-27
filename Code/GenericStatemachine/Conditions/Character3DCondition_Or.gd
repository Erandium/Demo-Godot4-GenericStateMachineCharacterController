extends BaseCharacter3DCondition
class_name Character3DConditionOr
##Condition: or logic operator


@export var firstCondition : BaseCharacter3DCondition = null
@export var secondCondition : BaseCharacter3DCondition = null

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	return firstCondition.Evaluate(entity) or secondCondition.Evaluate(entity)

##Generate the condition based on json data
func FromJson(data : Dictionary) -> void:
	firstCondition = CreateNewCondition(data["firstCondition"])
	secondCondition = CreateNewCondition(data["secondCondition"])
