extends HBoxContainer
class_name SoundPicker

@export var audio_player_ui: AudioPlayerUI
@export var select_button: Button
@export var clear_button: Button
@export var file_dialog: FileDialog

signal stream_changed(stream:AudioStream)

func _ready() -> void:
	clear_button.pressed.connect(
		func () -> void:
			load_stream(null)
	)
	select_button.pressed.connect(file_dialog.show)
	file_dialog.file_selected.connect(
		func (path:String) -> void:
			print("Selected file : ", path)
			var audio_stream: AudioStream = null
			if path.get_extension() == "mp3" :
				audio_stream = AudioStreamMP3.load_from_file(path)
			elif path.get_extension() == "wav" :
				audio_stream = AudioStreamWAV.load_from_file(path)
			elif path.get_extension() == "ogg" :
				audio_stream = AudioStreamOggVorbis.load_from_file(path)
			else:
				print_debug("Cannot parse audio file ", path," !")
				return
			audio_stream.resource_name = path.get_file()
			print("Importing ", path.get_file(), " as ", audio_stream)
			if is_instance_valid(audio_stream) :
				load_stream(audio_stream.duplicate())
			else:
				print("Audio stream is invalid.")
	)

func load_stream(stream:AudioStream) -> void:
	#if stream : print("Loading stream...")
	load_stream_no_signal(stream)
	#print("Emitting signal...")
	stream_changed.emit(stream)

func load_stream_no_signal(stream:AudioStream) -> void:
	#print("Loading stream : ", stream)
	audio_player_ui.load_stream(stream)
	#print("Stream loaded : ", audio_player_ui.has_loaded_stream())
	if audio_player_ui.has_loaded_stream():
		audio_player_ui.show()
		clear_button.show()
	else:
		audio_player_ui.hide()
		clear_button.hide()

func has_stream_selected() -> bool:
	if audio_player_ui:
		if audio_player_ui.has_loaded_stream():
			return true
	return false

func get_stream() -> AudioStream :
	if audio_player_ui.has_loaded_stream():	return audio_player_ui.get_loaded_stream()
	else:									return null
