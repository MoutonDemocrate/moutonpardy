extends HBoxContainer
class_name AudioPlayerUI

@export var show_time:bool = true :
	set(new):
		show_time = new
		if time_label:
			time_label.visible = new

@export var play_button: Button
@export var progress_bar: ProgressBar
@export var time_label: Label

@export var player: AudioStreamPlayer

@export var play_string: String = "▶︎"
@export var pause_string: String = "⏸"

const SCENE := preload("res://scenes/game/audio_player_ui.tscn")

static func from_audio_stream(stream:AudioStream) -> AudioPlayerUI :
	var player_ui: AudioPlayerUI = SCENE.instantiate()
	player_ui.load_stream(stream)
	return player_ui

func load_stream(stream:AudioStream) -> void:
	player.stream = stream

func has_loaded_stream() -> bool:
	if player:
		if player.stream :
			return true
	return false

func get_loaded_stream() -> AudioStream:
	if has_loaded_stream() :	return player.stream
	else :						return null

func _ready() -> void:
	time_label.visible = show_time

	progress_bar.max_value = 0.0
	progress_bar.max_value = 1.0
	play_button.text = play_string

	play_button.pressed.connect(
		func () -> void:
			if not player.playing:
				play_button.text = pause_string
				player.play()
			else :
				play_button.text = play_string
				player.stop()
	)
	player.finished.connect(
		func () -> void:
			play_button.text = play_string
	)

func _process(_delta: float) -> void:
	if player.playing :
		progress_bar.value = player.get_playback_position() / player.stream.get_length()
		time_label.text = (
			Time.get_time_string_from_unix_time(roundi(player.get_playback_position()))
			+ " / " +
			Time.get_time_string_from_unix_time(roundi(player.stream.get_length()))
		)
