extends Node2D

func wood_grain():
	var noise = FastNoiseLite.new()
	#smooth noise base
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.05 #medium details
	noise.fractal_octaves = 3 #layered ripples
	#smooth blending
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	
	#create size of image
	var width = 400
	var height = 400
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	#Loop through each pixel and distort into ring pattern
	# Based on research + AI guidance:
	# Generate wood-like rings using distance, sine waves, and noise for natural variation
	for y in range(height):
		for x in range(width):
			var nx = float(x) / width - 0.5
			var ny = float(y) / height - 0.5
			var dist = sqrt(nx*nx + ny*ny) * 20.0       # radial distance (rings)
			var n = noise.get_noise_2d(x, y) * 0.5 + 0.5
			var value = sin(dist + n * 2.0) * 0.5 + 0.5 # sine waves + noise
			image.set_pixel(x, y, Color(value*0.6, value*0.3, 0.1)) # brownish
	
	#turn image into texture
	var texture = ImageTexture.create_from_image(image)

	#create sprite2d node and displaye texture
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.position = Vector2(300, 300)
	sprite.scale = Vector2(2, 2)   # make each pixel bigger
	add_child(sprite)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wood_grain()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
