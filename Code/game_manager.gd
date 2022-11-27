extends Node
##Main game manager
##
##Used as the root node to control the global game state and the scenes to load 

##reference to the settings menu
@onready var inputSettingsMenu : InputSettingMenu = $CanvasLayer/InputSettingMenu

##Reference to the player
@onready var player : Player = $Player

##Track if the menu should be visible
var showSettingMenu : bool


func _ready() -> void:
	showSettingMenu = false
	UpdateSettingsVisibility()

##Open the menu if ESC is pressed
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed and !showSettingMenu:
			showSettingMenu = true
			UpdateSettingsVisibility()

##Update if the setting menu should be visible or not
func UpdateSettingsVisibility() -> void:
	if showSettingMenu:
		inputSettingsMenu.show()
		inputSettingsMenu.InitialiseMenu()
		player.cameraRig.OpenMenu()
	else:
		inputSettingsMenu.hide()
		player.cameraRig.CloseMenu()

##Signal handler for the close menu signal
func _on_input_setting_menu_close_menu() -> void:
	showSettingMenu = false
	UpdateSettingsVisibility()
