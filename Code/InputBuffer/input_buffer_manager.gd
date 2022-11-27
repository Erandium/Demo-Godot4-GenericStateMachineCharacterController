extends Node
class_name InputBufferManager
##Manage the input buffer
##
##This script update the input in the buffer

##Duration after which an input released input will be removed
@export var inputLifeSpan : float = 300

##Buffer
var inputBuffer : Array[BufferInputDescriptor] = []

func _process(_delta: float) -> void:
	UpdateBuffer()

##Update the input present in the buffer
func UpdateBuffer() -> void:
	for input in inputBuffer:
		#Remove expired inputs
		if !input.isPressed and input.releasedTimeStamp + inputLifeSpan < Time.get_ticks_msec():
			RemoveInput(input)
		#Check if input have been released
		elif !Input.is_action_pressed(input.action) and input.isPressed:
			input.isPressed = false
			input.releasedTimeStamp = Time.get_ticks_msec()

##Remove an input from the buffer
func RemoveInput(input : BufferInputDescriptor) -> void:
	inputBuffer.erase(input)



#debug ---------------------------------------
##Used for debug only
func PrintBuffer() -> void:
	var list = []
	for input in inputBuffer:
		list.append(input.action)
	print(list)
