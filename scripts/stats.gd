class_name Stats
extends Container

@onready var damage_label: Label = %DamageLabel
@onready var shields_label: Label = %ShieldsLabel
@onready var short_circuits_label: Label = %ShortCircuitsLabel


func update_player_state(player_state: Dictionary):
		damage_label.text = "Damage: " + str(player_state.hull_damage)
		shields_label.text = "Shields: " + str(player_state.shields)
		short_circuits_label.text = "Short Circuits: " + str(player_state.short_circuits)
