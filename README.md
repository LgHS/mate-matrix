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

#### Fadecandy

`node generator/fadecandy.js my-config.json > config/fc-myconfig.json`

#### OPC Simulator

Use with Open Pixel Control OpenGL viewer (Linux or OSX only).

`node generator/opc-simulator.js my-config.json > config/opc-myconfig.json`

#### Processing

Generate config file used by MateMatrix.pde.

_TODO_

#### Config reference

Remove comments before use.

```json
{
  "matrix": {
    "cols": 6, // number of crates horizontally
    "rows": 6, // number of crates vertically
    "reverse": true, // wiring starts at top right ?
    "zigzag": false // wiring is zig-zaging ?
  },
  "crate": {
    "rows": 5, // number of bottles per crate horizontally
    "cols": 4 // number of bottles per crate vertically
  },
  "processing": {
    "spacing": 20
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
    "devices": [ // serial numbers
      "AOFQFPTBHLLYEYTD",
      "JXEDMKOUXTBKISFV"
    ]
  }
}
```
