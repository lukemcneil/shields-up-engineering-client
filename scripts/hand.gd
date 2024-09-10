class_name Hand
extends HBoxContainer

var selected_card_index: int

signal selected_card_changed(i: int)

func update_hand(hand: Array):
	for child in self.get_children():
		child.queue_free()

	var i := 0
	for card_data in hand:
		var card := Card.new()
		card.texture = load("res://assets/cards/" + card_data.name + ".png")
		card.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		card.card_clicked.connect(_handle_card_clicked)
		card.card_index = i
		self.add_child(card)
		i += 1

func _handle_card_clicked(x: int):
	selected_card_index = x
	selected_card_changed.emit(selected_card_index)
