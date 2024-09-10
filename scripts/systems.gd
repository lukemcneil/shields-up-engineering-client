extends HBoxContainer
class_name Systems

@onready var fusion_reactor: System = $FusionReactor
@onready var life_support: System = $LifeSupport
@onready var shield_generator: System = $ShieldGenerator
@onready var weapons_system: System = $WeaponsSystem
@export var upside_down: bool = false
@onready var stats: Stats = %Stats as Stats

signal system_selected(system_name: System.SystemName)

func update_system_state(player_state: Dictionary):
	fusion_reactor.update_system_state(player_state.fusion_reactor)
	life_support.update_system_state(player_state.life_support)
	shield_generator.update_system_state(player_state.shield_generator)
	weapons_system.update_system_state(player_state.weapons_system)
	stats.update_player_state(player_state)

func _process(_delta: float) -> void:
	if upside_down:
		pivot_offset.y = size.y/2


func _on_system_selected(system_name: System.SystemName) -> void:
	system_selected.emit(system_name)
