extends Control
class_name InputSettingMenu
##Main script of the setting menu

##Signal sent when the whole setting menu is closed
signal close_menu


@onready var mappingMenu : InputMappingMenu = $InputMappingMenu
@onready var sensibilityMenu : InputSensibilityMenu = $InputSensibilityMenu


func _ready() -> void:
	InitialiseMenu()

##Show the default sub menu and initilise all sub menu
func InitialiseMenu() -> void:
	mappingMenu.show()
	sensibilityMenu.hide()
	
	mappingMenu.InitialiseMenu()
	sensibilityMenu.InitialiseMenu()
	
	#make sure the mouse is usable
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


##Switch to input mapping menu
func _on_mapping_button_pressed() -> void:
	mappingMenu.show()
	sensibilityMenu.hide()

##Switch to sensibility menu
func _on_sensibility_button_pressed() -> void:
	mappingMenu.hide()
	sensibilityMenu.show()

##Save all data and close the menu
func _on_save_button_pressed() -> void:
	InputMapping.inputMap = mappingMenu.GetCurrentMapping()
	InputMapping.sensibilityMap = sensibilityMenu.GetCurrentMapping()
	InputMapping.SetGameBinds()
	InputMapping.SaveData()
	close_menu.emit()

##Close the menu without saving data
func _on_cancel_button_pressed() -> void:
	close_menu.emit()
	pass 

