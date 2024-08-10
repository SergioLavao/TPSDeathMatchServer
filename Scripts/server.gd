extends Node

@export var characters: Array[ PackedScene ]
@export var criminalSpawnPoint : Marker3D
@export var swatSpawnPoint : Marker3D

@export var criminal_score_counter : int = 0
@export var swat_score_counter : int = 0

@export var criminalScoreLabel : RichTextLabel
@export var swatScoreLabel : RichTextLabel
@export var scoreSyncronizer : MultiplayerSynchronizer

var _player_counter : int = 0

func _init():
	GDLogger.RemoveAllLines()
	GDServer.SetOnPlayerSpawnedFunction( on_player_spawned )

func _ready():
	GDLogger.WriteLine("_server_version_", "Server: v1.1.0", Color.WHITE )
	GDCharacterModels.BindModels( characters )
	scoreSyncronizer.set_multiplayer_authority( 1 ) #Server sync

func _process(delta):
	swatScoreLabel.text = "[center]"+str( swat_score_counter )
	criminalScoreLabel.text = "[center]"+str( criminal_score_counter )

func on_player_spawned( playerID : int ):
	
	_player_counter += 1
	
	var character
	
	if _player_counter % 2 == 0: #If its odd go to Criminal Team
		character = spawn_character( criminalSpawnPoint.global_position, playerID, 0 )
		character.SetOnCharacterWasted( on_character_criminal_killed )
	
	if _player_counter % 2 != 0: #If its even go to SWAT Team
		character = spawn_character( swatSpawnPoint.global_position, playerID, 1 )
		character.SetOnCharacterWasted( on_character_swat_killed )

func on_character_criminal_killed( playerID : int ):
	
	swat_score_counter = swat_score_counter + 1;
	
	var timer = Timer.new()
	
	add_child(timer)
	timer.start(2.5)
	timer.connect("timeout", func(): #On timeout, respawn the character
		spawn_character( criminalSpawnPoint.global_position, playerID, 0 )
		timer.queue_free()
	)

func on_character_swat_killed( playerID : int ):
	
	criminal_score_counter = criminal_score_counter + 1
	
	var timer = Timer.new()
	add_child(timer)
	timer.start(2.5)
	timer.connect("timeout", func(): #On timeout, respawn the character
		spawn_character( swatSpawnPoint.global_position, playerID, 1 )
		timer.queue_free()
	)

func spawn_character( point : Vector3, playerID : int, modelID : int ) -> Object:
	return GDCharacterSpawner.SpawnPlayerCharacter( point , Vector3.UP, playerID, modelID )
