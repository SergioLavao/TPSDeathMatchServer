@tool
extends EditorPlugin

var executable_file_dialog : FileDialog = FileDialog.new()

var custom_play_button : Button = Button.new()
var custom_build_button : Button = Button.new()
var custom_stop_button : Button = Button.new()

func _enter_tree():
	
	# Get the editor interface
	var editor_interface = get_editor_interface()
	# Get the main control containing all the editor UI elements
	var interface = editor_interface.get_base_control()
	
	var buttons = []
	
	var button_ref_icon = interface.get_theme_icon("PlayCustom","EditorIcons")
	
	_find_button( interface, buttons)
	
	custom_play_button.set_meta("custom_editor_tps", "_play")
	custom_play_button.text = "Run Server"
	custom_play_button.pressed.connect(self.play_server_pressed)

	custom_build_button.set_meta("custom_editor_tps", "_build")
	custom_build_button.text = "Build Server"
	custom_build_button.pressed.connect( self.build_server_pressed )
	
	custom_stop_button.set_meta("custom_editor_tps", "_build")
	custom_stop_button.text = "Stop Server"
	custom_stop_button.pressed.connect( self.stop_server_pressed )
	custom_stop_button.disabled = true
	
	executable_file_dialog.set_meta("custom_editor_tps", "_file_explorer")
	
	for button : Button in buttons:
		if button.has_meta("custom_editor_tps"):
			button.queue_free()
		if button.icon == button_ref_icon:
			for b_to_hide in button.get_parent().get_children():
				b_to_hide.hide()
			
			button.get_parent().add_child( custom_play_button )
			button.get_parent().add_child( custom_build_button )
			button.get_parent().add_child( custom_stop_button )

func play_server_pressed():
	
	if executable_file_dialog not in get_children():
		add_child( executable_file_dialog )
		
	executable_file_dialog.popup()
	executable_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_ANY
	executable_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	executable_file_dialog.root_subfolder = "/"
	executable_file_dialog.ok_button_text = "Select App"
	executable_file_dialog.confirmed.connect( self.set_application_path )

func stop_server_pressed():
	custom_play_button.disabled = false
	custom_build_button.disabled = false
	custom_stop_button.disabled = true
	OS.execute("pkill", ["-9", "TPS_MP"])

func set_application_path():
	
	build_server()
	
	var cmd : String = "open"
	var args_server = [ "-n", "/" + executable_file_dialog.current_path.left(-1) , "--args", '"--local"', '"--server"', '"--headless"']
	var args_client = [ "-n", "/" + executable_file_dialog.current_path.left(-1) , "--args", '"--local"', '"--dummy_client"']
	OS.execute( cmd , args_server )
	OS.execute( cmd , args_client )
	custom_play_button.disabled = true
	custom_build_button.disabled = true
	custom_stop_button.disabled = false

func build_server_pressed():
	build_server()

func build_server():
	
	var servers = []
	var path = OS.get_data_dir() + "/TPS_MP/SERVERS/"
	
	var dir = DirAccess.open( path )
	
	if dir == null:
		var e = DirAccess.make_dir_recursive_absolute( path );
	
	var OSName = OS.get_name()
	var result = 0
	
	result = OS.execute( OS.get_executable_path() , ["--headless", "--export-pack", '"Server"', path + "localserver.pck"] )
	
	if result == 0:
		print("Server build success! at : " + path + "localserver.pck")

func _find_button(button, buttons):
	if button is Button:
		buttons.append(button)

	for child in button.get_children():
		if child is Control:
			var result = _find_button(child, buttons)
