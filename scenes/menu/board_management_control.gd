extends VBoxContainer
class_name BoardManagementControl

@export var board_name_label: Label
@export var board_path_label: Label

@export var edit_button: Button
@export var trash_button: Button

@export var detail_label: Label

@export var top_control:Control
@export var bottom_control: Control

var associated_board: Board

signal edit_button_pressed(board_to_edit:Board)
signal trash_button_pressed(from_board_management_control:BoardManagementControl)

const SCENE := preload("res://scenes/menu/board_management_control.tscn")

static func from_board_resource(board:Board) -> BoardManagementControl:
	var bc: BoardManagementControl = SCENE.instantiate()
	bc.associated_board = board
	bc.board_name_label.text = board.board_name
	bc.board_path_label.text = board.resource_path
	bc.set_details_text()
	return bc

func _ready() -> void:
	edit_button.pressed.connect(edit_button_pressed.emit.bind(associated_board))
	trash_button.pressed.connect(trash_button_pressed.emit.bind(self))

	bottom_control.hide()
	top_control.mouse_entered.connect(bottom_control.show)
	top_control.mouse_entered.connect(self.set_details_text)
	top_control.mouse_exited.connect(bottom_control.hide)

func set_details_text() -> void:
	if associated_board:
		detail_label.text = "Categories :"
		for column:Column in associated_board.columns:
			detail_label.text += ("\n• " + column.title + " (" +
			",".join(PackedStringArray(
				column.get_question_points().map(
					func (el:int) -> String:
						return str(el)
						))) + ")"
			)
		detail_label.text += "\n\n"
		detail_label.text += "Last modified on " + Time.get_datetime_string_from_unix_time(FileAccess.get_modified_time(ProjectSettings.globalize_path(associated_board.resource_path)))
		# I won't apologise for that line of code.
	else :
		detail_label.text = "Error! Check your logs."
