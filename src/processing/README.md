# Mate Matrix Processing Sketches

## How to use

* Create a folder (eg. from root folder: `src/processing/MySketch`)
* copy `src/processing/template/template.pde` to the new folder and 
rename it (should have the same name as folder, eg `src/processing/MySketch/MySketch.pde`).
* copy `src/processing/template/MateMatrix.pde` and `src/processing/template/OPC.pde`
* generate config with generator: `./generator/processing.js ./lghs-21.json > src/processing/MySketch/data/matrix_config.json`
and start coding !

## What's in there

### KinectShadow

Use a kinect to display spectator's body as a shadow to
background animations.

### MatrixAnimation

Sound reactive animations for live music display.
