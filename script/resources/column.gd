extends Resource
class_name Column

@export var title: String = "Geography (ex)"
@export var questions: Array[Question]

func get_question_points() -> Array[int]:
	var possible_points: Array[int] = []
	for question:Question in questions:
		possible_points.append(question.worth)
	return possible_points

func _to_string() -> String:
	return '"'+self.title+'"'
