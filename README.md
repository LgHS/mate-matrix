# mate-matrix

Mate Matrix is a LED display made with bottles of Club Mate.

It's based on Fadecandy and Open Pixel Control.

More info on our wiki (FR): 
https://wiki.lghs.be/projets:mate-matrix 

## How to use

Clone this repo with submodules to import fadecandy: 

`git clone --recursive git@github.com:LgHS/mate-matrix.git`

Run fadecandy with a pre-existing config:

`./fadecandy/bin/fc-server-rpi config/fc-config-[myconfig].json`

Note: server is also available for Win7+ and OSX+. See 
fadecandy/bin for README.

### Generate config

With one main config file you can generate config files for :

* Fadecandy server
* Processing client
* Open Pixel Control OpenGL simulator.

To keep things tidy, put main config in project root
and generated configs in `config/` folder with prefixes
(`fc-` for fadecandy and `opc-` for OPC simulator).

Processing config should go inside each sketch data folder.

#### Fadecandy

`node generator/fadecandy.js my-config.json > config/fc-myconfig.json`

#### OPC Simulator

Use with Open Pixel Control OpenGL viewer (Linux or OSX only).

To build and run simulator, see README in [OPC repo](https://github.com/zestyping/openpixelcontrol)

To generate config for simulator:

`node generator/opc-simulator.js my-config.json > config/opc-myconfig.json`

**Note**: looks like it doesn't work on Linux anymore :(
[More info here](https://groups.google.com/d/topic/fadecandy/aKD9_kCoYDc/discussion)

#### Processing

Generate config file used by MateMatrix.pde.

`node generator/processing.js ./my-config.json > src/processing/MyProjectSketch/data/matrix_config.json`

#### Config reference

Remove comments before use.

```json
{
  "matrix": {
    "cols": 6,
    "rows": 6,
    "zigzag": false
  },
  "opc": [
    "127.0.0.1",
    7890
  ],
  "fadecandy": {
    "verbose": true,
    "color": {
      "gamma": 2.5,
      "whitepoint": [
        1.0,
        1.0,
        1.0
      ],
      "linearCutoff": 0.00390625
    },
    "cratesByGroup": 3,
    "ledOffset": 0,
    "colorOrder": "grb",
    "devices": [
      "AOFQFPTBHLLYEYTD",
      "JXEDMKOUXTBKISFV"
    ]
  },
  "processing": {
    "spacing": 20,
    "blocks" : [
      {"position": "left", "firstLed": 0, "cols": 3, "rows": 3},
      {"position": "center", "firstLed": 40, "cols": 6, "rows": 3},
      {"position": "right", "firstLed": 140, "cols": 3, "rows": 3}
    ],
    "dmxSerialPort": "/dev/ttyUSB0"
  },
  "crate": {
    "rows": 5,
    "cols": 4
  }
}
```
