extends Control
class_name System

@export var texture: Texture
@export var modulate_color: Color
@export var system_name: SystemName
@onready var cards: VBoxContainer = $Cards
@onready var energy_label: Label = $EnergyLabel
@onready var overloads_label: Label = $OverloadsLabel
@onready var system_card: TextureRect = %SystemCard

var overloaded := false

signal system_selected(system_name: SystemName)

enum SystemName {
	FUSION_REACTOR,
	LIFE_SUPPORT,
	SHIELD_GENERATOR,
	WEAPONS_SYSTEM
}

func _ready() -> void:
	$Cards/SystemCard.texture = texture

func update_system_state(system_state: Dictionary) -> void:
	for child in cards.get_children():
		if !child.is_in_group("system_cards"):
			child.queue_free()

	var hot_wires = system_state.hot_wires
	var i := 0
	for hot_wire in hot_wires:
		var card := Card.new()
		card.texture = load("res://assets/cards/" + hot_wire.name + ".png")
		card.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
		cards.add_child(card)
		card.z_index = -i-1
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		if system_state.overloads != 0:
			card.modulate = modulate_color
		i += 1
	
	energy_label.text = "Energy: " + str(system_state.energy)
	overloads_label.text = "Overloads: " + str(system_state.overloads)
	if system_state.overloads == 0:
		overloaded = false
		overloads_label.hide()
		system_card.modulate = Color.WHITE
	else:
		overloaded = true
		overloads_label.show()
		system_card.modulate = modulate_color


func _on_system_card_card_clicked(_i: int) -> void:
	system_selected.emit(system_name)
