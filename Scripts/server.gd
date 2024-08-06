extends Node

@export var characters: Array[ PackedScene ]
@export var criminalSpawnPoint : Marker3D
@export var swatSpawnPoint : Marker3D

var _player_counter : int = 0

func _init():
	GDServer.SetOnPlayerSpawnedFunction( on_player_spawned )

func _ready():
	GDLogger.WriteLine("_server_version_", "Server: v1.1.0", Color.WHITE )
	GDCharacterModels.BindModels( characters )

func on_player_spawned( playerID : int ):
	_player_counter += 1
	
	if _player_counter % 2 == 0: #If its odd go to Criminal Team
		GDCharacterSpawner.SpawnPlayerCharacter( criminalSpawnPoint.global_position , Vector3.UP, playerID, 0 )
	
	if _player_counter % 2 != 0: #If its even go to SWAT Team
		GDCharacterSpawner.SpawnPlayerCharacter( swatSpawnPoint.global_position , Vector3.UP, playerID, 1 )
