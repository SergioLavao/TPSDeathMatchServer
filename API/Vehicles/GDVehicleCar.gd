class_name GDVehicle extends VehicleBody3D

func _ready():
	if GDGame.IsServer():
		GDVehicleSpawner.SpawnVehicleCar( global_position, quaternion, scene_file_path )
	queue_free()
