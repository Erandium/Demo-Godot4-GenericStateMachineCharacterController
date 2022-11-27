extends Resource
class_name BaseCharacter3DCondition
##Base class representing a condition for the state change logic

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	return false

##Generate the condition based on json data 
func FromJson(data : Dictionary) -> void:
	pass

##Return a new condition based on json data
static func CreateNewCondition(conditionData : Dictionary) -> BaseCharacter3DCondition:
	var condition : BaseCharacter3DCondition = null
	
	match conditionData["conditionType"]:
		"true":
			condition = Character3DConditionTrue.new()
		"and":
			condition = Character3DConditionAnd.new()
		"or":
			condition = Character3DConditionOr.new()
		"not":
			condition = Character3DConditionNot.new()
		"onFloor":
			condition = Character3DConditionOnFloor.new()
		"onWall":
			condition = Character3DConditionOnWall.new()
		"inputPressed":
			condition = Character3DConditionInputPressed.new()
		"inputSetPressed":
			condition = Character3DConditionInputSetPressed.new()
		"maxSpeed":
			condition = Character3DConditionMaxSpeed.new()
	
	if condition != null:
		condition.FromJson(conditionData)
		return condition
	return null

