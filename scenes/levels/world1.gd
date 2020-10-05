extends Spatial

onready var player = $player

func _process(delta):
	var x_holder = abs(player.translation.x) - 34
	var z_holder = player.translation.z - 32
#	print('x:', x_holder)
#	print('z:', z_holder)
	
	# EXIT TELEPORTATION
	if player.translation.x < -32 and player.translation.z < -4:
		player.translation.x = 0 - x_holder
#		player.translation.y = 1.85
		player.translation.z = 28
	
	# ENTRANCE TELEPORTATION
	if player.translation.x >= 11 and player.translation.z >= 30:
		player.translation.x = -22
#		player.translation.y = 1.85
		player.translation.z = 0 + z_holder
