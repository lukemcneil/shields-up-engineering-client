class_name ResolveEffects
extends VBoxContainer

@onready var remaining_effects: VBoxContainer = %RemainingEffects

signal resolve_effect(effect: String)

func update_effects(effects: Array):
	for child in remaining_effects.get_children():
		child.queue_free()
	for effect in effects:
		var effect_button := Button.new()
		effect_button.text = effect
		effect_button.pressed.connect(handle_effect_clicked.bind(effect))
		remaining_effects.add_child(effect_button)

func handle_effect_clicked(effect: String) -> void:
	resolve_effect.emit(effect)
