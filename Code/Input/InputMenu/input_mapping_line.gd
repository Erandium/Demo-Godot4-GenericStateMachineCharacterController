extends Control
class_name InputMappingMenuLine
##Script for a ligne in the input mapping menu
##
##The scrip is design to handle 2 event per action

##Notify the parent menu that a event slot as been pressed
signal inputSelected(action, index)

@onready var actionName : Label = $ActionName
@onready var slot1 : Button = $Slot1
@onready var slot2 : Button = $Slot2

##Action associted to the line
var action : String

##Update displayed names on the line
func UpdateLine(_action : String, data : Array) -> void:
	action = _action
	
	actionName.text = InputMapping.GetActionName(action)
	
	if len(data) >= 1:
		slot1.text = InputMapping.GetEventName(data[0])
	if len(data) >= 2:
		slot2.text = InputMapping.GetEventName(data[1])


func _on_slot_1_pressed() -> void:
	inputSelected.emit(action, 0)


func _on_slot_2_pressed() -> void:
	inputSelected.emit(action, 1)
