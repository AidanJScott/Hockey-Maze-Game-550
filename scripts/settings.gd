extends Node

var volume = 0.5

func set_volume(value):
	volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func get_volume():
	return volume
