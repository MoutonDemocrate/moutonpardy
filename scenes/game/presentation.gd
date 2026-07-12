extends TabContainer
class_name PresentationTab

@export var current_question: Question
@export var current_column: Column

@export var question_half: Control
@export var question_category_title: Label
@export var question_label: Label
@export var question_texture_rect: TextureRect
@export var question_player: AudioPlayerUI
@export var reveal_answer_button: Button

@export var answer_half: Control
@export var answer_category_title: Label
@export var answer_label: Label
@export var answer_texture_rect: TextureRect
@export var answer_player: AudioPlayerUI
@export var see_question_again_button: Button
@export var back_to_board_button: Button

func question_time(question:Question, in_column:Column) -> void:
	current_question 	= question
	current_column 		= in_column

	question_category_title.text 	= in_column.title
	answer_category_title.text 		= in_column.title

	question_texture_rect.show()
	question_player.show()

	answer_texture_rect.show()

	question_label.text = question.text
	if question.image : 	question_texture_rect.texture = question.image
	else: 					question_texture_rect.hide()
	if question.sound : 	question_player.load_stream(question.sound)
	else: 					question_player.hide()

	answer_label.text = question.answer_text
	if question.answer_image : 	answer_texture_rect.texture = question.answer_image
	else: 						answer_texture_rect.hide()
	if question.answer_sound : 	answer_player.load_stream(question.answer_sound)
	else: 						answer_player.hide()

	question_half.show()
	answer_half.hide()

	reveal_answer_button.pressed.connect(
		func () -> void:
			question_half.hide()
			answer_half.show()
	)
	see_question_again_button.pressed.connect(
		func () -> void:
			question_half.show()
			answer_half.hide()
	)

	self.show()

	await back_to_board_button.pressed

	print("Back to board.")
	return
