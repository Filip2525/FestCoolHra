extends Node2D

@onready var SettingsPanel = get_node("Settings")

func _on_settings_pressed() -> void:
	SettingsPanel.visible = true


func _on_exit_to_desktop_pressed() -> void:
	get_tree().quit()
