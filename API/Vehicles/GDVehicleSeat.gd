# WARNING: 
# This script is critical to the functionality of the program.
# Modifying any part of this script may cause the program to malfunction or stop working entirely.
# Proceed with caution and ensure you understand the implications of any changes you make.

extends Node
class_name GDVehicleSeat

var _gd_class : String = "GDVehicleSeat"

@export var isDriverSeat : bool
@export var enterPoint : Marker3D
@export var sitPoint : Marker3D
@export var doorMesh : Node3D

@export var openRotationTarget : Vector3
