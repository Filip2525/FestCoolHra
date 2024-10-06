extends Control



func _on_music_toggled(toggled_on: bool) -> void:
	Variables.music = toggled_on
func _on_sounds_toggled(toggled_on: bool) -> void:
	Variables.sounds = toggled_on
func _on_volume_value_changed(value: float) -> void:
	Variables.volume =  value / 100
func _on_exit_to_desktop_pressed() -> void:
	get_tree().quit()
