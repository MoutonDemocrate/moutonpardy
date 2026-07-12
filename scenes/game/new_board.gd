extends CenterContainer
class_name NewBoardTab

@export var name_label: Label
@export var multiplier_label: Label
@export var ready_button: Button

func present_board(board:Board) -> void:
	print("Presenting board : ", board)
	self.show()

	name_label.text = "\"" + board.board_name + "\""
	# Note : This array is sorted from small to large
	var possible_points: PackedInt32Array = board.get_points_array()
	multiplier_label.text = str(possible_points[0]) + " to " + str(possible_points[-1])

	await ready_button.pressed
	return
