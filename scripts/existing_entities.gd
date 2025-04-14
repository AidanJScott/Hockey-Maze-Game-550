extends Control

signal entity_selected(entity: Node2D)

@onready var item_list = $VBoxContainer/ItemList

# Stores a reference to each node associated with each item
var tracked_entities: Array = []

func add_entity(entity: Node2D):
	tracked_entities.append(entity)
	item_list.add_item(entity.name)

func remove_entity(entity: Node2D):
	var index = tracked_entities.find(entity)
	if index != -1:
		tracked_entities.remove_at(index)
		item_list.remove_item(index)

func clear_entities():
	tracked_entities.clear()
	item_list.clear()

func _ready():
	item_list.item_selected.connect(_on_item_selected)

func _on_item_selected(index: int):
	var selected_entity = tracked_entities[index]
	emit_signal("entity_selected", selected_entity)
