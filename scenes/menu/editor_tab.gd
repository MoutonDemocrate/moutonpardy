extends TabContainer
class_name EditorMenuTab

@export var not_the_editor: Control
@export var new_board_button: Button
@export var select_board_button: Button
@export var editor: BoardEditor

@export var board_management_tab: Control

func _ready() -> void:
	select_board_button.pressed.connect(board_management_tab.show)

func edit_new_board() -> void:
	var new_board := Board.new()
	new_board.board_name = "Untitled Board"
	var original_save_location: String = ("user://boards/"+new_board.board_name).to_snake_case()
	var save_location:String = original_save_location
	var i := 1
	while FileAccess.file_exists(save_location+".tres") :
		save_location = original_save_location + str(i)
		i += 1
	new_board.resource_path = save_location

	edit_board(new_board)

func edit_board(board:Board) -> void:
	editor.start_board_edition(board)
