extends Control
class_name InputSensibilityMenu
##Script for the main sensibility menu

##Reference to the menu line scene
const sensibilityLine = preload("res://Code/Input/InputMenu/input_sensibility_line.tscn")

@onready var boxContainer : VBoxContainer = $ScrollContainer/VBoxContainer

##Local sensibility map
var localSensibilityMap : Dictionary

##Dictionary axis:menu_line
var axisDictionary : Dictionary


func InitialiseMenu() -> void:
	localSensibilityMap = InputMapping.sensibilityMap.duplicate(true)
	FillMenu()

##Remove previous lines and create new one
func FillMenu() -> void:
	for child in boxContainer.get_children():
		child.queue_free()
	
	for axis in localSensibilityMap:
		var line : InputSensibilityLine = sensibilityLine.instantiate()
		boxContainer.add_child(line)
		axisDictionary[axis] = line
		line.UpdateLine(axis, localSensibilityMap[axis])

##Return the new sensibility map (called when the input settings menu is saved)
func GetCurrentMapping() -> Dictionary:
	var data : Dictionary = {}
	for axis in localSensibilityMap:
		data[axis] = axisDictionary[axis].GetValue()
	return data
