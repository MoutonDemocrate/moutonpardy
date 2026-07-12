extends Control
class_name MainMenuClass

@export var example_board: Board

@export var menu: Control
@export var main: MainClass
@export var default_tab: Control
@export var quit_dialog: ConfirmationDialog

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

	setup_files()

	default_tab.show()

func start_game(with_boards:Array[Board], with_teams:Dictionary[String, Color]) -> void:
	main.queue_free()
	var new_main: MainClass = MainClass.SCENE.instantiate()
	menu.add_sibling(new_main)
	main = new_main
	new_main.game_ended.connect(game_ended)
	new_main.start_game(with_boards, with_teams)

func game_ended() -> void:
	print("Received game ended signal, showing menu tab again...")
	main.hide()
	menu.show()
	default_tab.show()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		quit_dialog.show()

func setup_files() -> void:
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path("user://boards")) :
		DirAccess.make_dir_absolute(ProjectSettings.globalize_path("user://boards"))
	var files := DirAccess.get_files_at("user://boards")
	print("Files in board folder : ", files)
	if files.is_empty() :
		if example_board :
			print("Saving example board to user files...")
			var error: Error = ResourceSaver.save(example_board, "user://boards/example_board.tres")
			if error != Error.OK :
				print(error_string(error))
