extends BaseCharacter3DStateResource
class_name Character3DStateResourceClimb
##State resource: Climb

##Vertical climb speed
@export var verticalClimbSpeed : float = 0
##Horizontal climb speed
@export var horizontalClimbSpeed : float = 0


func _init() -> void:
	script = load("res://Code/GenericStatemachine/States/Character3DState_Climb.gd")

func FromJson(data : Dictionary) -> void:
	super.FromJson(data)
	verticalClimbSpeed = data["verticalClimbSpeed"]
	horizontalClimbSpeed = data["horizontalClimbSpeed"]
