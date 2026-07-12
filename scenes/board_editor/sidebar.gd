extends PanelContainer
class_name BoardEditorSidebar

@export var spin_box_worth: SpinBox

@export var question_text_edit: TextEdit
@export var question_image_picker: TexturePicker
@export var question_sound_picker: SoundPicker

@export var answer_text_edit: TextEdit
@export var answer_image_picker: TexturePicker
@export var answer_sound_picker: SoundPicker

@export var current_question: Question

signal question_saved(question:Question)

func _ready() -> void:
	current_question = null
	spin_box_worth.value_changed.connect(save_question_sanitised)
	question_text_edit.text_changed.connect(save_question_sanitised)
	question_image_picker.texture_changed.connect(save_question_sanitised)
	question_sound_picker.stream_changed.connect(save_question_sanitised)
	answer_text_edit.text_changed.connect(save_question_sanitised)
	answer_image_picker.texture_changed.connect(save_question_sanitised)
	answer_sound_picker.stream_changed.connect(save_question_sanitised)

func load_question(question:Question) -> void:
	current_question = question

	spin_box_worth.set_value_no_signal(question.worth)

	question_text_edit.text = question.text
	question_image_picker.load_texture_no_signal(question.image)
	question_sound_picker.load_stream_no_signal(question.sound)

	answer_text_edit.text = question.answer_text
	answer_image_picker.load_texture_no_signal(question.answer_image)
	answer_sound_picker.load_stream_no_signal(question.answer_sound)

func save_question_sanitised(...args:Array) -> void:
	print("Question : ", question_text_edit.text)
	print("Values changed : ", args)
	save_question()

func save_question() -> void:
	if current_question :
		print("Saving question ", current_question, "...")
		current_question.worth			= roundi(spin_box_worth.value)
		current_question.text			= question_text_edit.text
		current_question.image			= question_image_picker.get_texture()
		current_question.sound			= question_sound_picker.get_stream()
		current_question.answer_text	= answer_text_edit.text
		current_question.answer_image	= answer_image_picker.get_texture()
		current_question.answer_sound	= answer_sound_picker.get_stream()

		question_saved.emit(current_question)
