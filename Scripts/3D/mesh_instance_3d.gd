extends MeshInstance3D
func _ready() -> void:
	if noise == null:
		noise = FastNoiseLite.new()
		noise.frequency = 0.01 
	update_mesh()
	
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0.2, 0.8, 0.3)  # Green color
	set_surface_override_material(0, material)
	
const size := 256.0

#Sets the minimum and maximum resolution to 4 and 256, and set's default to 32.
@export_range(4, 256, 4) var resolution := 32:
	set(new_resolution):
		resolution = new_resolution
		update_mesh()

#creates an outputted noise variable where anytime it's changed it will be updated.
@export var noise: FastNoiseLite:
	set(new_noise):
		noise = new_noise
		update_mesh()
		if noise:
			noise.changed.connect(update_mesh)

#sets minimum and maximum heights to 4 and 128 unites.
@export_range(4.0, 128.0, 4.0) var height := 128.0:
	set(new_height):
		height = new_height
		update_mesh()

#gets the values at any vertex on the plane to get a new height value	
func get_height(x: float, y: float) -> float:
	return noise.get_noise_2d(x, y) * height

func get_normal(x: float, y: float) -> Vector3:
	var epsilon := size / resolution #distance between adjacent vertices in the plane
	var normal := Vector3(
		(get_height(x + epsilon, y) - get_height(x - epsilon, y)) / (2.0 * epsilon),
		1.0,
		(get_height(x, y + epsilon) - get_height(x, y - epsilon)) / (2.0 * epsilon),
	)
	return normal.normalized()
	#Finds the co-ordinates of the vertices "above", "below", to the right, and left of each vertex.

func update_mesh() -> void:
	var plane := PlaneMesh.new()
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	plane.size = Vector2(size, size)
	 
	var plane_arrays := plane.get_mesh_arrays()
	var vertex_array: PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_VERTEX]
	var normal_array: PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_NORMAL]
	
	for i in vertex_array.size():
		var vertex := vertex_array[i]
		var normal := Vector3.UP
		
		if noise:
			vertex.y = get_height(vertex.x, vertex.z)
			normal = get_normal(vertex.x, vertex.z)
		
		vertex_array[i] = vertex
		normal_array[i] = normal
	
	var array_mesh := ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane_arrays)
	mesh = array_mesh
