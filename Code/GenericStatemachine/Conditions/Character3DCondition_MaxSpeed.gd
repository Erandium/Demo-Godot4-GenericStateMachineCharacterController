extends BaseCharacter3DCondition
class_name Character3DConditionMaxSpeed
##Condition : speed of the entity
##
##Return true if the speed according to given axis is smaller or equal to a given speed

##Speed limit against which the entity speed is compared to
@export var speedLimit : float = 0
##Weight of each axis in local space
@export var axeWeight : Vector3 = Vector3.ONE

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	var weightedSpeed : Vector3 = (entity.velocity * entity.transform.basis) * axeWeight
	return weightedSpeed.length() <= speedLimit


##Generate the condition based on json data
func FromJson(data : Dictionary) -> void:
	speedLimit = data["speedLimit"]
	axeWeight.x = data["axeWeight"]["x"]
	axeWeight.y = data["axeWeight"]["y"]
	axeWeight.z = data["axeWeight"]["z"]
