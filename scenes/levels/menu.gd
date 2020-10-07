extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	save(str($buttons/crt.pressed))

func _on_exit_pressed():
	get_tree().quit()

func _on_begin_pressed():
	get_tree().change_scene("res://scenes/levels/world1.tscn")

func _on_github_pressed():
	OS.shell_open("https://github.com/AradHamidSamiee")

func _on_instagram_pressed():
	OS.shell_open("https://www.instagram.com/metavisiongames/")
	OS.shell_open("https://www.instagram.com/aradhamidsamiee/")

func _on_linkedin_pressed():
	OS.shell_open("https://www.linkedin.com/in/aradhamidsamiee")

func _on_twitter_pressed():
	OS.shell_open("https://twitter.com/aradhamidsamiee")

func _on_CheckBox_toggled(button_pressed):
	save(str($buttons/crt.pressed))

func save(content):
	var file = File.new()
	file.open("res://config.dat", File.WRITE)
	file.store_string(content)
	file.close()
