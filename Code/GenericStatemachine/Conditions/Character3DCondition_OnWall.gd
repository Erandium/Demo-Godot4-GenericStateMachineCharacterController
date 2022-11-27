extends BaseCharacter3DCondition
class_name Character3DConditionOnWall
##Condition: entity against a wall

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	return entity.is_on_wall() 
