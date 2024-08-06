# WARNING: 
# This script is critical to the functionality of the program.
# Modifying any part of this script may cause the program to malfunction or stop working entirely.
# Proceed with caution and ensure you understand the implications of any changes you make.

class_name GDVehicle extends VehicleBody3D

func _ready():
	if GDGame.IsServer():
		GDVehicleSpawner.SpawnVehicleCar( global_position, quaternion, scene_file_path )
	queue_free()
