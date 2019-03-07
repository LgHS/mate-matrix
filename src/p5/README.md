# Mate Matrix p5 sketches

## How to use

Each folder contains a sketch.

Inside the sketch folder, open `src/p5/libraries/matrix_config.json` 
in an editor and check that the
`fcAddress` key points to the right server ip.

If the ip address is correct, you should
be able to run the sketch and see it displayed on the matrix
by opening the html file in your browser.

## Develop

### With p5-manager

Using [p5-manager](https://github.com/chiunhau/p5-manager) is suggested as it 
automatically creates a server that live reloads on changes. It
also gives a nice interface that lets you switch sketches easily.

* Install with `npm install -g p5-manager` 
* From root folder, `cd src/p5`
* Copy a sketch folder (eg. `src/p5/test-rectangle`) and rename it
* Add sketch name in `src/p5/.p5rc` file (in `"projects"` array)
* Start a server with `p5 s` 
* Go to `localhost:5555` and choose your sketch in the left sidebar

See other sketches for example on how to draw on the matrix.

### Without p5-manager

* Copy a sketch folder (eg. `src/p5/test-rectangle`) and rename it
* Change code in `sketch.js` file
* open `index.html` in your browser
