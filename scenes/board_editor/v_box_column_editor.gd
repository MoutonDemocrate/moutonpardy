extends VBoxContainer
class_name VBoxColumnEditor

@export var associated_column:Column
@export var editor: BoardEditor

@export var category_text_edit: TextEdit
@export var add_button: Button

signal column_title_changed(new_title:String)

const SCENE := preload("res://scenes/board_editor/v_box_column_editor.tscn")

static func from_column(column:Column, editor_ref:BoardEditor) -> VBoxColumnEditor:
	print("Creating a new column from ", column.title, "...")
	var ce: VBoxColumnEditor = SCENE.instantiate()
	ce.associated_column = column
	ce.editor = editor_ref
	ce.category_text_edit.text = column.title
	for question:Question in column.questions:
		ce.add_question(question)
	return ce

func _ready() -> void:
	category_text_edit.text_changed.connect(
		func (nt:String) -> void:
			associated_column.title = nt
			column_title_changed.emit(nt)
	)
	add_button.pressed.connect(
		func () -> void:
			var new_question := Question.new()
			if self.get_child(-2) is EditorQuestionButton :
				new_question.worth = (self.get_child(-2) as EditorQuestionButton).associated_question.worth + 100
			else :
				new_question.worth = 100
			add_question(new_question)
	)

func add_question(question:Question) -> void:
	print("Adding question element for question : ", question.text)
	var question_button := EditorQuestionButton.from_question(question, editor)
	question_button.show()
	self.add_child(question_button)
	self.move_child(question_button, question_button.get_index()-1)
