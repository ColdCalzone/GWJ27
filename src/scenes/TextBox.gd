extends Control

onready var timer = $Timer
export(float) var wait_time: float = 0.1

onready var tween = $Tween

onready var textbox_container = $Textboxes
onready var avatar_right = $Textboxes/TextboxRight/Avatar
onready var avatar_left = $Textboxes/TextboxLeft/Avatar
onready var container_right = $Textboxes/TextboxRight
onready var container_left = $Textboxes/TextboxLeft
onready var text_right = $Textboxes/TextboxRight/Text
onready var text_left = $Textboxes/TextboxLeft/Text
export(String) var quote_right: String = "Test"
export(String) var quote_left: String = "Test"

onready var vis = $Visibility

onready var blip = $blip

onready var last_side = container_right
onready var target_side = container_right
onready var target_text = text_right
onready var target_quote = quote_right

class_name TextBox

func _ready():
	vis.visible = false
	text_right.text = quote_right
	text_left.text = quote_left
	timer.wait_time = wait_time
	tween.interpolate_property(textbox_container, "rect_position", -last_side.rect_position + Vector2(0, 332), -target_side.rect_position + Vector2(0, 332), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	timer.connect("timeout", self, "next_char", [quote_left, target_side, target_text])
	timer.start()

func next_char(quote, box, text):
	if last_side != box:
		timer.stop()
		tween.interpolate_property(textbox_container, "rect_position", -last_side.rect_position + Vector2(0, 332), -box.rect_position + Vector2(0, 332), 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()
		last_side = box
		yield(tween, "tween_all_completed")
		timer.start()
	else:
		text.visible_characters += 1
		if quote.length() >= text.visible_characters:
			blip.play()
		else:
			target_side = container_left
			target_text = text_left
			target_quote = quote_left
			yield(get_tree().create_timer(1.0), "timeout")
			# this shouldn't be necessary imo
			timer.disconnect("timeout", self, "next_char")
			timer.connect("timeout", self, "next_char", [quote_left, target_side, target_text])
