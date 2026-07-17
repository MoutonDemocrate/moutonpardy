extends VBoxContainer
class_name VBoxColumnEditor

@export var associated_column:Column
@export var editor: BoardEditor

@export var category_text_edit: TextEdit
@export var add_button: Button
@export var delete_button: Button

signal column_title_changed(new_title:String)
signal delete_button_pressed

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
	delete_button.pressed.connect(delete_button_pressed.emit)
	category_text_edit.mouse_exited.connect(
		func () -> void:
			if category_text_edit.text != associated_column.title :
				associated_column.title = category_text_edit.text
				column_title_changed.emit(category_text_edit.text)
	)
	add_button.pressed.connect(
		func () -> void:
			var new_question := Question.new()
			associated_column.questions.append(new_question)
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
	question_button.remove_button_pressed.connect(remove_question.bind(question_button))
	self.add_child(question_button)
	self.move_child(question_button, question_button.get_index()-1)
	editor.save_board()

func remove_question(question_button:EditorQuestionButton) -> void:
	print("Removing editor question associated with column : ", question_button.associated_question)
	if question_button.associated_question in associated_column.questions:
		associated_column.questions.erase(question_button.associated_question)
	if question_button.associated_question == editor.sidebar.current_question :
		editor.sidebar.clear()
	question_button.queue_free()

func get_question_buttons() -> Array[EditorQuestionButton]:
	var buttons: Array[EditorQuestionButton] = []
	for child:Node in self.get_children() :
		if child is EditorQuestionButton :
			buttons.append(child)
	return buttons
