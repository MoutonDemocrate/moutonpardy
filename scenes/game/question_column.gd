extends VBoxContainer
class_name QuestionColumn

@export var label: Label
@export var sep: HSeparator

var column: Column

const SCENE := preload("res://scenes/game/question_column.tscn")

static func from_column(new_column:Column) -> QuestionColumn:
	var question_column: QuestionColumn = SCENE.instantiate()
	question_column.column = new_column

	for child:Control in question_column.get_children() :
		if child is Button : child.free()

	question_column.label.text = new_column.title

	for question:Question in new_column.questions :
		var new_button := QuestionButton.from_question_and_column(question, new_column)
		question_column.add_child(new_button)

	return question_column

func get_question_buttons() -> Array[QuestionButton]:
	var question_buttons: Array[QuestionButton] = []
	for child:Control in self.get_children():
		print("child is ", child)
		if child is QuestionButton:
			question_buttons.append(child)
	print("QuestionButtons found : ", question_buttons)
	return question_buttons

## Returns [code]true[/code] if all questions in the column have been done
func is_done() -> bool:
	print("Checking questions of ", column.title, "...")
	for button:QuestionButton in get_question_buttons():
		if not button.disabled :
			print('• ', button.associated_column, "×", button.associated_question.worth, ' is not answered ❌')
			return false
		print('• ', button.associated_column, "×", button.associated_question.worth, ' is answered ✅')
	return true
