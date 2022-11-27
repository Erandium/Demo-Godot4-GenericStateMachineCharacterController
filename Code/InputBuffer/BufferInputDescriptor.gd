extends Resource
class_name BufferInputDescriptor
##Describe an input in the input buffer

##Name of the cation associted to the input
var action : String
##Timestamp of when the input was pressed
var pressedTimeStamp : int
##Timestamp of when the input was released (0 if stil pressed)
var releasedTimeStamp : int
##Track if the input is still pressed
var isPressed : bool

func _init(_action : String, _startTimeStamp : int = Time.get_ticks_msec()) -> void:
	action = _action
	pressedTimeStamp = _startTimeStamp
	releasedTimeStamp = 0
	isPressed = true

