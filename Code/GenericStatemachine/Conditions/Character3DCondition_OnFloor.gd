extends BaseCharacter3DCondition
class_name Character3DConditionOnFloor
##Condition: entity on the ground

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	return entity.is_on_floor() 
