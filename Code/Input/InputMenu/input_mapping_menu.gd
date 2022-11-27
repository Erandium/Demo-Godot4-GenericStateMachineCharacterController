extends Control
class_name InputMappingMenu
##Script for the input map menu

##Reference to the menu line scene
const inputLine = preload("res://Code/Input/InputMenu/input_mapping_line.tscn")


@onready var boxContainer : VBoxContainer = $ScrollContainer/VBoxContainer
@onready var newInputPanel : Control = $NewInputPanel
@onready var newInputPanelName : Label = $NewInputPanel/ActionName

##Local input map
var localInputMap : Dictionary

##Dictionary action:menu_line
var buttonsDictionary : Dictionary

##Data to set up new input
var waitingForInput : bool
var waitingInputAction : String
var waitingInputSlot : int


func InitialiseMenu() -> void:
	localInputMap = InputMapping.inputMap.duplicate(true)
	buttonsDictionary = {}
	waitingForInput = false
	newInputPanel.hide()
	FillMenu()

##Remove previous lines and create new one
func FillMenu() -> void:
	for child in boxContainer.get_children():
		child.queue_free()
	
	for action in localInputMap:
		var line : InputMappingMenuLine = inputLine.instantiate()
		boxContainer.add_child(line)
		buttonsDictionary[action] = line
		line.UpdateLine(action, localInputMap[action])
		line.inputSelected.connect(NewInputSelection)

##Trigger for the "waiting for input"
func NewInputSelection(action : String, slot : int) -> void:
	waitingForInput = true
	waitingInputAction = action
	waitingInputSlot = slot
	ShowNewInputPanel()

##Show the "waiting for input" panel
func ShowNewInputPanel() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	newInputPanelName.text = InputMapping.GetActionName(waitingInputAction)
	newInputPanel.show()

##Hide the "waiting for input" panel
func HideNewInputPanel() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	newInputPanel.hide()

##Get the new input (ESC cancel the action)
func _input(event: InputEvent) -> void:
	if waitingForInput:
		if event is InputEventKey:
			if event.keycode != KEY_ESCAPE:
				SetNewButtonInput("keyboard", event.keycode)
			else:
				waitingForInput = false
				HideNewInputPanel()
		elif event is InputEventMouseButton:
			if event.pressed == false:
				SetNewButtonInput("mouseButton", event.button_index)
		elif event is InputEventJoypadButton:
			SetNewButtonInput("joypadButton", event.button_index)
		elif event is InputEventJoypadMotion:
			if event.axis_value > 0.5:
				SetNewAxisInput(event.axis, 1)
			elif event.axis_value < -0.5:
				SetNewAxisInput(event.axis, -1)

##Set new button in the local input map
func SetNewButtonInput(inputType : String, keycode : int) -> void:
	var newEvent : Dictionary = {
					"inputType" : inputType,
					"inputCode" : keycode
				}
	if len(localInputMap[waitingInputAction]) > waitingInputSlot:
		localInputMap[waitingInputAction][waitingInputSlot] = newEvent
	else:
		localInputMap[waitingInputAction].append(newEvent)
	
	buttonsDictionary[waitingInputAction].UpdateLine(waitingInputAction, localInputMap[waitingInputAction])
	waitingForInput = false
	HideNewInputPanel()

##Set new axis in the local input map
func SetNewAxisInput(axis : int, direction : int) -> void:
	var newEvent : Dictionary = {
		"inputType" : "joypadAxis",
		"inputAxis" : axis,
		"inputDirection" : direction
	}
	if len(localInputMap[waitingInputAction]) > waitingInputSlot:
		localInputMap[waitingInputAction][waitingInputSlot] = newEvent
	else:
		localInputMap[waitingInputAction].append(newEvent)
		
	buttonsDictionary[waitingInputAction].UpdateLine(waitingInputAction, localInputMap[waitingInputAction])
	waitingForInput = false
	HideNewInputPanel()

##Return the current local input map (called when the input settings menu is saved)
func GetCurrentMapping() -> Dictionary:
	return localInputMap.duplicate(true)
