extends HSplitContainer
class_name BoardEditor

@export var current_board: Board
@export var main_half: EditorMainHalf
@export var sidebar: BoardEditorSidebar

var block_saving: bool = false

func _ready() -> void:
	sidebar.question_saved.connect(
		func (_q:Question) -> void: save_board()
	)

func start_board_edition(new_board:Board) -> void:
	self.show()
	block_saving = true
	current_board = new_board
	main_half.start_editing(new_board)
	block_saving = false

func save_board() -> void:
	if block_saving :
		print("Saving blocked!")
		return

	Input.set_default_cursor_shape(Input.CURSOR_WAIT)

	print()
	print(" --- Saving board ", current_board," ...")
	# We delete the old board
	var error := DirAccess.remove_absolute(ProjectSettings.globalize_path(current_board.resource_path))
	if error != Error.OK :
		print_debug("Failed to delete ", ProjectSettings.globalize_path(current_board.resource_path)," : ", error_string(error))
	else:
		print("Deleting ", ProjectSettings.globalize_path(current_board.resource_path))
	print("Remaining files : ", str(DirAccess.get_files_at("user://boards")).replace(",","\n"))
	# We save the new board to the correct path
	var original_save_location: String = ("user://boards/"+current_board.board_name).to_snake_case()
	var save_location:String = original_save_location
	var i := 1
	while FileAccess.file_exists(save_location+".tres") :
		print(save_location, " already exists, boosting...")
		save_location = original_save_location + str(i)
		main_half.board_name_edit.text = current_board.board_name + str(i)
		i += 1
	save_location += ".tres"
	print("Saving to ", save_location)
	current_board.resource_path = save_location
	var nerror := ResourceSaver.save(current_board, save_location)
	if nerror != Error.OK:
		print("Error with "+ current_board.resource_path +" : ", error_string(error))
	else :
		print("# # # Saved information # # #")
		print(current_board)
		print("# # # # # # # # # # # # # # #")
	print()

	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
