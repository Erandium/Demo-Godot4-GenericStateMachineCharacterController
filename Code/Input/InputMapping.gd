extends Node
##Input Mapping Singleton
##
##Used to hold input data and to load and save them from/to the drive 

##Path to the save file
const inputMapFilePath : String = "res://Data/InputMap.json"

##List of all used input (this list is master for the input system)
const userMappableInputs : Array[String] = [
	"player_movement_front",
	"player_movement_back",
	"player_movement_right",
	"player_movement_left",
	"player_movement_up",
	"player_movement_down",
	"player_movement_jump",
	"player_movement_dash",
	"camera_movement_up",
	"camera_movement_down",
	"camera_movement_right",
	"camera_movement_left",
	"camera_toggle",
	"mouse_toggle"
]


##Master sensibility coefficients,
##used to make sensibility setting within comprehensible ranges
const mouseSensibilityMasterFactor : float = 0.05
const joysticSensibilityMasterFactor : float = 70

##Dictionary of sensibility settings
var sensibilityMap : Dictionary = {}

##Dictionary of the input map action:[event]
var inputMap : Dictionary = {}


func _ready() -> void:
	AssureInputMapIntegrity()
	LoadData()
	SetGameBinds()

#InputMap interactions -----------------------------------------------------------------------------

##Make sure that the InputMap has all actions needed
func AssureInputMapIntegrity() -> void:
	var existingInput : Array[StringName] = InputMap.get_actions()
	for action in userMappableInputs:
		if not existingInput.has(action as StringName):
			InputMap.add_action(action)

##Overwrite all mappable action with the event of the inputMap dictionary  
func SetGameBinds() -> void:
	# clear previous binds
	for action in userMappableInputs:
		for event in InputMap.action_get_events(action):
			InputMap.action_erase_event(action, event)
	
	# add new binds
	for action in userMappableInputs:
		if !inputMap.has(action):
			inputMap[action] = [{},{}]
		else:
			for event in inputMap[action]:
				if event.has("inputType"):
					match event["inputType"]:
						"keyboard":
							var key = InputEventKey.new()
							key.keycode = event["inputCode"]
							InputMap.action_add_event(action, key)
						"mouseButton":
							var mouseButton = InputEventMouseButton.new()
							mouseButton.button_index = event["inputCode"]
							InputMap.action_add_event(action, mouseButton)
						"joypadButton":
							var joypadButton = InputEventJoypadButton.new()
							joypadButton.button_index = event["inputCode"]
							InputMap.action_add_event(action, joypadButton)
						"joypadAxis":
							var joypadAxis = InputEventJoypadMotion.new()
							joypadAxis.axis = event["inputAxis"]
							joypadAxis.axis_value = event["inputDirection"]
							InputMap.action_add_event(action, joypadAxis)
						_:
							print("unknown input type" + event["inputType"])

# file inteactions ---------------------------------------------------------------------------------

##Load data from drive
func LoadData() -> void:
	var json : JSON = JSON.new()
	if FileAccess.file_exists(inputMapFilePath):
		var file := FileAccess.open(inputMapFilePath, FileAccess.READ)
		if file != null:
			var jsonError := json.parse(file.get_as_text())
			if jsonError == OK:
				var data : Dictionary = json.get_data()
				sensibilityMap = data["sensibility"]
				inputMap = data["inputs"]
			else:
				print("error parsing input json")
				sensibilityMap = GenerateSensibilityMap()
				inputMap = GenerateInputMap()
		else:
			print("error opening input file")
			sensibilityMap = GenerateSensibilityMap()
			inputMap = GenerateInputMap()
	else:
		print("input file missing")
		sensibilityMap = GenerateSensibilityMap()
		inputMap = GenerateInputMap()

##Save data to drive
func SaveData() -> void:
	var data : Dictionary = {
		"sensibility" : sensibilityMap,
		"inputs" : inputMap
	}
	var file := FileAccess.open(inputMapFilePath, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))

# generate default data --------------------------------------------------------

##Generate an inputMap dictionary with 2 empty inputs per mappable action
func GenerateInputMap() -> Dictionary:
	var map : Dictionary = {}
	for action in userMappableInputs:
		map[action] = [{},{}]
	return map

##Generate a default sensibility map
func GenerateSensibilityMap() -> Dictionary:
	return {
		"mouseHorizontal" : 1,
		"mouseVertical" : 1,
		"cameraJoysticHorizontal" : 1,
		"cameraJoysticVertical" : 1,
		"movementJoysticHorizontal" : 1,
		"movementJoysticVertical": 1
	}


# name mapping -----------------------------------------------------------------

##Conversion dictionary for the displayed action names
const actionNameMapping : Dictionary = {
	"player_movement_front"	: "Move forward",
	"player_movement_back"	: "Move backward",
	"player_movement_right" : "Move right",
	"player_movement_left" 	: "Move left",
	"player_movement_up" 	: "Move up",
	"player_movement_down"	: "Move down",
	"player_movement_jump"	: "Jump",
	"player_movement_dash"	: "Dash",
	"player_attack_light"	: "Light attack",
	"player_attack_heavy"	: "Heavy attack",
	"player_attack_counter" : "Counter/Dodge",
	"camera_movement_up"	: "Camera up",
	"camera_movement_down"	: "Camera down",
	"camera_movement_right"	: "Camera right",
	"camera_movement_left"	: "Camera left",
	"camera_toggle"			: "Toggle camera",
	"mouse_toggle"			: "Toggle mouse"
}

##Conversion dictionary for the displayed sensibility names
const sensibilityNameMapping : Dictionary = {
	"mouseHorizontal" 			: "Mouse : Horizontal sensibbility",
	"mouseVertical" 			: "Mouse : Vertical sensibility",
	"cameraJoysticHorizontal" 	: "Camera joystick : Horizontal sensibility",
	"cameraJoysticVertical" 	: "Camera joystick : Vertical sensibility",
	"movementJoysticHorizontal" : "Movement joystick : Horizontal sensibility",
	"movementJoysticVertical"	: "Movement joystick : Vertical sensibility"
}

##Return the display name of a given action
func GetActionName(action : String) -> String:
	if actionNameMapping.has(action):
		return actionNameMapping[action]
	return action

##Return the formated display text for a given input
func GetEventName(eventDescriptor : Dictionary) -> String:
	if eventDescriptor.has("inputType"):
		match  eventDescriptor["inputType"]:
			"keyboard":
				return OS.get_keycode_string(eventDescriptor["inputCode"])
			"mouseButton":
				return "mouse button " + str(eventDescriptor["inputCode"])
			"joypadButton":
				return "joypad button " + str(eventDescriptor["inputCode"])
			"joypadAxis":
				if eventDescriptor["inputDirection"] > 0 :
					return "joypad axis " + str(eventDescriptor["inputAxis"]) + "+"
				elif eventDescriptor["inputDirection"] < 0 :
					return "joypad axis " + str(eventDescriptor["inputAxis"]) + "-"
		return "Error"
	return ""

##Return the display name for a given sensibility setting
func GetSensibilityAxisName(axis : String) -> String:
	if sensibilityNameMapping.has(axis):
		return sensibilityNameMapping[axis]
	return axis

