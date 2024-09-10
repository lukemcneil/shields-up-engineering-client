class_name Card
extends TextureRect

signal card_clicked(i: int)
@export var card_index: int

#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_just_pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#print(event)
		##var bounds = Rect2(rect_position, rect_size)
		##if bounds.has_point(event.position):
			##print("clicked!")

func _init() -> void:
	connect("gui_input", _on_gui_input)


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_card"):
		card_clicked.emit(card_index)
