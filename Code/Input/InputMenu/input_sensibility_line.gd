extends HBoxContainer
class_name InputSensibilityLine
##Script for a ligne in the sensibility menu


@onready var label : Label = $Label
@onready var valueSelector : SpinBox = $SpinBox

##Name of the axis
var sensibilityAxis : String

##Update displayed names and values on the line
func UpdateLine(_sensibilityAxis : String, startValue : float) -> void:
	sensibilityAxis = _sensibilityAxis
	label.text = InputMapping.GetSensibilityAxisName(sensibilityAxis)
	valueSelector.value = startValue

##Used by the sensibility menu to get the seleted value
func GetValue() -> float:
	return valueSelector.value
