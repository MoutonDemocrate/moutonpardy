extends CenterContainer
class_name ManageBoardsTab

@export var boards_vbox: VBoxContainer
@export var new_board_button: Button
@export var import_board_button: Button
@export var import_file_dialog: FileDialog

@export var delete_file_popup: ConfirmationDialog

@export var editor_tab: EditorMenuTab

func _ready() -> void:
	new_board_button.pressed.connect(
		func () -> void:
			new_board()
	)
	import_board_button.pressed.connect(import_file_dialog.show)
	import_file_dialog.files_selected.connect(import_boards)
	import_file_dialog.file_selected.connect(
		func (path:String) -> void:
			import_boards(PackedStringArray([path]))
	)
	update_boards_vbox()

func import_boards(paths:PackedStringArray) -> void:
	print("Importing files : ", paths)
	for file:String in paths:
		if ResourceLoader.exists(file, "Board") :
			var board: Board = load(file).duplicate_deep()
			var original_save_location: String = ("user://boards/"+board.board_name).to_snake_case()
			var save_location:String = original_save_location
			var i := 1
			while FileAccess.file_exists(save_location+".tres") :
				save_location = original_save_location + str(i)
				i += 1
			board.resource_path = save_location
			var error := ResourceSaver.save(board, save_location+".tres")
			if error != Error.OK:
				print("Error with "+ file +" : ", error_string(error))
		else:
			print(file," is not a board...")
	update_boards_vbox()

func delete_board(from_board_control:BoardManagementControl) -> void:
	delete_file_popup.dialog_text = "Are you sure you want to delete "+from_board_control.associated_board.board_name+" ?\nYou cannot undo this."
	delete_file_popup.show()
	Utils.disconnect_signal(delete_file_popup.canceled)
	Utils.disconnect_signal(delete_file_popup.confirmed)
	delete_file_popup.confirmed.connect(
		func () -> void:
			print("Deleting board ", from_board_control.associated_board, " at ", from_board_control.associated_board.resource_path)
			DirAccess.remove_absolute(ProjectSettings.globalize_path(from_board_control.associated_board.resource_path))
			from_board_control.queue_free()
			update_boards_vbox()
	)

func new_board() -> void:
	editor_tab.visible = true
	editor_tab.edit_new_board()

func edit_board(board:Board) -> void:
	editor_tab.visible = true
	editor_tab.edit_board(board)

func update_boards_vbox() -> void:
	Utils.free_children(boards_vbox)

	var files := DirAccess.get_files_at("user://boards")
	print("Files in board folder : ", files)
	if files.is_empty() :
		var label := Label.new()
		label.text = "No boards found..."
		boards_vbox.add_child(boards_vbox)
		return

	for file:String in files:
		file = "user://boards/" + file
		if ResourceLoader.exists(file, "Board") :
			var board: Board = load(file)
			print("Found board : ", board.board_name)
			var board_control := BoardManagementControl.from_board_resource(board)
			board_control.edit_button_pressed.connect(edit_board)
			board_control.trash_button_pressed.connect(delete_board)
			boards_vbox.add_child(board_control)
		else:
			print("File : ", file, " is not a board...")
