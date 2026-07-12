extends Button
class_name QuestionButton

var associated_question: Question
var associated_column

const SCENE := preload("res://scenes/game/question_button.tscn")

static func from_question_and_column(question:Question, column:Column) -> QuestionButton:
	var question_button: QuestionButton = SCENE.instantiate()
	question_button.associated_question = question
	question_button.associated_column = column
	question_button.text = str(question.worth)
	return question_button

func _ready() -> void:
	pressed.connect(
		func () -> void:
			self.disabled = true
			Refs.main.question_time(associated_question, associated_column)
	)
