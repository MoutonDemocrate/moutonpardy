extends PanelContainer
class_name BoardSetupControl

@export var number_label: Label
@export var board_name_label: Label
@export var board_path_label: Label
@export var multiplier_spinbox: SpinBox
@export var kill_button: Button

var board:Board

const SCENE := preload("res://scenes/menu/board_setup_control.tscn")

static func from_board(board_to_use:Board) -> BoardSetupControl:
	var setup_control: BoardSetupControl = SCENE.instantiate()
	setup_control.board_name_label.text = board_to_use.board_name
	setup_control.board_path_label.text = board_to_use.resource_path
	setup_control.board = board_to_use
	return setup_control

func _ready() -> void:
	multiplier_spinbox.set_value_no_signal(1)
	kill_button.pressed.connect(
		func () -> void:
			self.queue_free()
	)

func get_board() -> Board:
	return (board.duplicate_deep() as Board).apply_multiplier(roundi(multiplier_spinbox.value))
