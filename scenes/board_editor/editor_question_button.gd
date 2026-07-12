extends Button
class_name EditorQuestionButton

@export var associated_question: Question

const SCENE := preload("res://scenes/board_editor/editor_question_button.tscn")

static func from_question(question:Question, editor_ref:BoardEditor) -> EditorQuestionButton:
	var me: EditorQuestionButton = SCENE.instantiate()
	me.associated_question = question
	me.pressed.connect(editor_ref.sidebar.load_question.bind(me.associated_question))
	question.worth_changed.connect(
		func (nw:int) -> void : me.text = str(nw)
	)
	return me
