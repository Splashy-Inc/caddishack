extends Marker2D

class_name ZoomPoint

var targets : Dictionary[Node2D, ZoomInfo]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for node in targets.keys():
		if is_instance_valid(node) and not node.global_transform.is_equal_approx(targets[node].zoom_transform):
			node.global_transform = node.global_transform.interpolate_with(targets[node].zoom_transform, .25)
			if node.global_transform.is_equal_approx(targets[node].zoom_transform):
				node.global_transform = targets[node].zoom_transform
				if targets[node].original_z == targets[node].zoom_z:
					node.z_index = targets[node].original_z
					node.z_as_relative = true
					targets.erase(node)
			

func zoom_node(node: Node2D):
	if not node in targets.keys():
		targets[node] = ZoomInfo.new(node.global_transform, node.z_index)
	targets[node].zoom_transform = global_transform
	targets[node].zoom_z = z_index
	node.z_as_relative = false
	node.z_index = targets[node].zoom_z + 1

func dezoom_node(node: Node2D):
	if node in targets.keys():
		node.z_index = targets[node].zoom_z
		targets[node].zoom_transform = targets[node].original_transform
		targets[node].zoom_z = targets[node].original_z
