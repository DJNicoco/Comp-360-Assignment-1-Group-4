extends Node3D

@export var tex_size: int = 129
@export var quads_x: int = 1
@export var quads_y: int = 1
@export var cell_size: float = 1.0
@export var height_scale: float = 5.0
@export var show_texture_on_mesh: bool = true

@onready var heightmap := Heightmap.new()
@onready var builder := TerrainMeshBuilder.new()
@export var params: NoiseParams

func _ready() -> void:
    if params == null:
        params = NoiseParams.new()

    var img: Image = heightmap.make_fastnoise_image(tex_size, params)
    var tex: ImageTexture = heightmap.to_texture(img)

    var mesh := builder.build_grid_mesh(img, quads_x, quads_y, cell_size, height_scale)

    var mi := MeshInstance3D.new()
    mi.mesh = mesh

    if show_texture_on_mesh:
        var mat := StandardMaterial3D.new()
        mat.albedo_texture = tex
        mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
        mi.set_surface_override_material(0, mat)

    add_child(mi)
