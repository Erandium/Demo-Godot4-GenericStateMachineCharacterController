extends BaseCharacter3DCondition
class_name Character3DConditionInputPressed
##Condition: input pressed
##
##This condition can chack for double press and remove the input afterward

##Name of the action in the input buffer
@export var actionName : String = ""
##Does the input should be a double press
@export var doubleTap : bool = false
##Max delai between the same input to consider it a double press
@export var doubleTapTimeFrame : float
##Should the input be removed when the inpt is detected 
@export var removeInput : bool = false

##Evaluate the condition represented by the object
func Evaluate(entity : Character3DEntity) -> bool:
	var actionPressed : bool = false
	var doubleTapped : bool = false
	
	var bufferLenght : int = len(entity.inputBufferManager.inputBuffer)
	for i in range(bufferLenght):
		var input : BufferInputDescriptor = entity.inputBufferManager.inputBuffer[i]
		if input.action == actionName:
			if input.isPressed:
				actionPressed = true
				if removeInput:
					entity.inputBufferManager.RemoveInput(input)
			#check for double tap
			if i > 0:
				var previousInput : BufferInputDescriptor = entity.inputBufferManager.inputBuffer[i-1]
				if previousInput.action == actionName \
				and previousInput.pressedTimeStamp + doubleTapTimeFrame > input.pressedTimeStamp :
					doubleTapped = true
					if removeInput:
						entity.inputBufferManager.RemoveInput(previousInput)
	
	return actionPressed and (!doubleTap or doubleTapped)

##Generate the condition based on json data
func FromJson(data : Dictionary) -> void:
	actionName = data["actionName"]
	doubleTap = data["doubleTap"]
	removeInput = data["removeInput"]
	doubleTapTimeFrame = data["doubleTapTimeFrame"]
