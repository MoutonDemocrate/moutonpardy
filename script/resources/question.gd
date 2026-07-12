extends Resource
class_name Question

## Question text
@export var text: String = "This is a question example. You shouldn't see this."
## Question image
@export var image: Texture2D
## Question sound
@export var sound: AudioStream

## Answer text
@export var answer_text: String = "This is the anwser example, you shouldn't see this."
## Answer image
@export var answer_image: Texture2D
## Question sound
@export var answer_sound: AudioStream

## Worth of the question, in points
@export var worth: int = 100 :
	set(new):
		worth = new
		worth_changed.emit(new)
signal worth_changed(new_worth:int)

static func create(nw:int, t:String, at:String, i:Texture2D=null, ai:Texture2D=null, s:AudioStream=null, ans:AudioStream=null) -> Question:
	var question := Question.new()
	question.worth 			= nw
	question.text 			= t
	question.answer_text 	= at
	question.image 			= i
	question.answer_image	= ai
	question.sound 			= s
	question.answer_sound	= ans
	return question
