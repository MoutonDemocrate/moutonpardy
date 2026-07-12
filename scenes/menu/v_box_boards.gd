extends VBoxContainer
class_name VBoxBoardsSetup

@export var new_board_button: Button
@export var board_container: VBoxContainer
@export var file_dialog: FileDialog

func _ready() -> void:
	new_board_button.pressed.connect(
		func () -> void:
			file_dialog.show()
			var file_picked: String = await file_dialog.file_selected
			file_dialog.hide()
			if ResourceLoader.exists(file_picked, "Board") :
				var board: Board = load(file_picked)
				var board_control := BoardSetupControl.from_board(board)
				board_container.add_child(board_control)
			else: print(file_picked, " is not recognised :/")
	)

func get_boards() -> Array[Board]:
	var boards: Array[Board] = []
	for child:Control in board_container.get_children() :
		if child is BoardSetupControl :
			boards.append(child.get_board())
	return boards
