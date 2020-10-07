extends Spatial

onready var area_door = $Area_door
onready var door_exit_animation = $door_exit/door
onready var door_exit_audio_open = $door_exit/door_open
onready var door_exit_audio_close = $door_exit/door_close
onready var door_entrance_animation = $door_entrance/door
onready var door_entrance_audio_open = $door_entrance/door_open
onready var door_entrance_audio_close = $door_entrance/door_close

func _on_Area_door_body_entered(body):
	door_exit_animation.play("door_open")
	door_exit_audio_open.play()

func _on_Area_door_body_exited(body):
	door_exit_animation.play("door_close")
	door_exit_audio_close.play()

func _on_Area_entrance_body_entered(body):
	door_entrance_animation.play("door_open")
	door_entrance_audio_open.play()

func _on_Area_entrance_body_exited(body):
	door_entrance_animation.play("door_close")
	door_entrance_audio_close.play()
