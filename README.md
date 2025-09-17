# COMP360 — 3D Terrain Prototype

## Folder structure
```
World.tscn                     # main scene (Node3D + Camera3D + Light)
scripts/
  World.gd                     # orchestrates generation → mesh → material
  NoiseParams.gd               # seed, frequency, octaves, gain, lacunarity, sample_scale
  Heightmap.gd                 # builds grayscale Image via FastNoiseLite (Cellular+FBM)
  TerrainMeshBuilder.gd        # builds quad grid; UVs; samples 4 corner pixels (red)

## Roles & individual responsibilities (7 people)


---

## Contributing (team workflow)

