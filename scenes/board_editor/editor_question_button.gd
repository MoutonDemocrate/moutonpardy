extends Button
class_name EditorQuestionButton

@export var associated_question: Question

@export var kill_button: Button

signal remove_button_pressed

var editor: BoardEditor

const SCENE := preload("res://scenes/board_editor/editor_question_button.tscn")

func _ready() -> void:
	kill_button.pressed.connect(remove_button_pressed.emit)
	kill_button.show()

static func from_question(question:Question, editor_ref:BoardEditor) -> EditorQuestionButton:
	var me: EditorQuestionButton = SCENE.instantiate()
	me.associated_question = question
	me.pressed.connect(editor_ref.sidebar.load_question.bind(me.associated_question))
	me.text = str(question.worth)
	me.editor = editor_ref
	question.worth_changed.connect(
		func (nw:int) -> void : me.text = str(nw)
	)
	return me

func _get_drag_data(_at_position: Vector2) -> Variant:
	set_drag_preview(self.duplicate())
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is EditorQuestionButton :
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is EditorQuestionButton:
		print("Swapping question buttons ", self, " and ", data)
		var self_index: int = self.get_index()
		var other_index: int = data.get_index()
		self.get_parent_control().move_child(self, other_index)
		self.get_parent_control().move_child(data, self_index)
		Utils.swap_elements(
			(self.get_parent_control() as VBoxColumnEditor).associated_column.questions,
			self.associated_question,
			data.associated_question)
		editor.save_board()
	else:
		return
