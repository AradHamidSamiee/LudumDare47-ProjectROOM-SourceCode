extends StaticBody

var heck

func _process(delta):
	if heck == 1:
		heck = 0
		$shadow_timer.start()

func _on_shadow_timer_timeout():
	hide()
