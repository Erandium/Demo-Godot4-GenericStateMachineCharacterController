extends BaseCharacter3DCondition
class_name Character3DConditionTrue
##Condition: true
##
##This is used when the entity need to exit a state just after entering it

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	return true
