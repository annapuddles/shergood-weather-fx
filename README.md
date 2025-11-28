# Shergood Weather FX 

Shergood Weather FX is a system that changes the environment based on the Shergood Weather 2.0 METAR data for the nearest registered airport. It modifies environment settings and uses particles and sounds to simulate different weather conditions.

# Components

## Controller

The controller is the main component of the Shergood Weather FX system. It fetches the METAR data from Shergood's servers, changes the environment settings based on them, and optionally controls the emitters and ground layers.

## Emitters

The emitters output particles and sounds, such as for rain or snow, based on the current weather conditions.

You may have multiple emitters and/or a single emitter with multiple linked prims, depending on how wide a space you need to cover.

## Ground layers

The ground layers add a texture overlay on the ground based on the current weather conditions. For example, they can display a wet texture for rain or snow on the ground for snow.

You may have multiple ground layers and/or a single ground layer with multiple linked prims, depending on how wide a space you need to cover. Ground layers always display their textures on face 0.
