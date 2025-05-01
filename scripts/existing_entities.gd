extends Control

signal entity_selected(entity: Node2D)

@onready var item_list = $VBoxContainer/ScrollContainer/ItemList

# Tracks the entities tied to each UI item
var tracked_entities: Array = []
var type_counts := {}

func _ready():
	item_list.item_selected.connect(_on_item_selected)

func add_entity(entity: Node2D):
	var type = get_entity_type(entity)
	if not type_counts.has(type):
		type_counts[type] = 0
	type_counts[type] += 1
	
	var display_name = "%s_%d" % [type, type_counts[type]]
	print("Adding to UI list:", display_name)  # 👈 Debug print

	entity.name = display_name
	tracked_entities.append(entity)
	item_list.add_item(display_name)

func remove_entity(entity: Node2D):
	var index = tracked_entities.find(entity)
	if index != -1:
		tracked_entities.remove_at(index)
		item_list.remove_item(index)

func clear_entities():
	tracked_entities.clear()
	item_list.clear()
	type_counts.clear()

func _on_item_selected(index: int):
	if index >= 0 and index < tracked_entities.size():
		var selected_entity = tracked_entities[index]
		print("Entity selected from list:", selected_entity.name)
		emit_signal("entity_selected", selected_entity)

func get_entity_type(entity: Node2D) -> String:
	var path = entity.scene_file_path.to_lower()
	if "wall" in path:
		return "WALL"
	elif "goal" in path:
		return "GOAL"
	elif "enemy" in path:
		return "ENEMY"
	return "OBJECT"
