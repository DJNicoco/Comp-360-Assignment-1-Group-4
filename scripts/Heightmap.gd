extends Node
class_name Heightmap

func make_fastnoise_image(size:int, p:NoiseParams) -> Image:
    var noise := FastNoiseLite.new()
    noise.seed = p.seed
    noise.noise_type = FastNoiseLite.TYPE_CELLULAR
    noise.frequency = p.frequency
    noise.cellular_distance_function = FastNoiseLite.CELLULAR_DISTANCE_EUCLIDEAN
    noise.fractal_type = FastNoiseLite.FRACTAL_FBM
    noise.fractal_octaves = p.octaves
    noise.fractal_gain = p.gain
    noise.fractal_lacunarity = p.lacunarity

    var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
    img.lock()
    for y in size:
        for x in size:
            var u := float(x) / float(size - 1)
            var v := float(y) / float(size - 1)
            var n := noise.get_noise_2d(u * p.sample_scale, v * p.sample_scale) # -1..1
            var g := clamp((n + 1.0) * 0.5, 0.0, 1.0)                            # 0..1
            img.set_pixel(x, y, Color(g, g, g, 1.0))
    img.unlock()
    return img

func to_texture(img:Image) -> ImageTexture:
    return ImageTexture.create_from_image(img)
