extends Node
class_name TerrainMeshBuilder

func build_grid_mesh(img:Image, quads_x:int, quads_y:int, cell_size:float, height_scale:float) -> ArrayMesh:
    var st := SurfaceTool.new()
    st.begin(Mesh.PRIMITIVE_TRIANGLES)

    var tex_size := img.get_width()
    img.lock()
    for gy in range(quads_y):
        for gx in range(quads_x):
            _add_quad(st, img, tex_size, gx, gy, quads_x, quads_y, cell_size, height_scale)
    img.unlock()

    return st.commit()

func _add_quad(st:SurfaceTool, img:Image, tex_size:int,
               gx:int, gy:int, qx:int, qy:int, cell_size:float, height_scale:float) -> void:
    var x0 := gx * cell_size
    var z0 := gy * cell_size
    var x1 := (gx + 1) * cell_size
    var z1 := (gy + 1) * cell_size

    var u0 := float(gx) / float(qx)
    var v0 := float(gy) / float(qy)
    var u1 := float(gx + 1) / float(qx)
    var v1 := float(gy + 1) / float(qy)

    var px0 := int(round(u0 * (tex_size - 1)))
    var py0 := int(round(v0 * (tex_size - 1)))
    var px1 := int(round(u1 * (tex_size - 1)))
    var py1 := int(round(v1 * (tex_size - 1)))

    var h00 := img.get_pixel(px0, py0).r * height_scale
    var h10 := img.get_pixel(px1, py0).r * height_scale
    var h01 := img.get_pixel(px0, py1).r * height_scale
    var h11 := img.get_pixel(px1, py1).r * height_scale

    var v00 := Vector3(x0, h00, z0)
    var v10 := Vector3(x1, h10, z0)
    var v01 := Vector3(x0, h01, z1)
    var v11 := Vector3(x1, h11, z1)

    var n0 := Plane(v00, v10, v11).normal
    var n1 := Plane(v00, v11, v01).normal

    st.set_uv(Vector2(u0, v0)); st.set_normal(n0); st.add_vertex(v00)
    st.set_uv(Vector2(u1, v0)); st.set_normal(n0); st.add_vertex(v10)
    st.set_uv(Vector2(u1, v1)); st.set_normal(n0); st.add_vertex(v11)

    st.set_uv(Vector2(u0, v0)); st.set_normal(n1); st.add_vertex(v00)
    st.set_uv(Vector2(u1, v1)); st.set_normal(n1); st.add_vertex(v11)
    st.set_uv(Vector2(u0, v1)); st.set_normal(n1); st.add_vertex(v01)
