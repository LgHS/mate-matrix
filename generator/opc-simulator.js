const path = require('path');
const args = process.argv.slice(2);

// const config = require(path.resolve('.', args[0]));
const config = require("../lghs-21.json");

const crates = config.matrix.cols * config.matrix.rows;
const ledsByCrate = config.crate.rows * config.crate.cols;

let output = [];

for (let mY = 0; mY < config.matrix.cols; mY++) {
  for (let mX = 0; mX < config.matrix.rows; mX++) {

  }
}

/**
 [
 {"point": [1.32, 0.00, 1.04]},
 {"point": [1.32, 0.00, 1.16]},
 {"point": [1.32, 0.00, 1.26]},
 {"point": [1.32, 0.00, 1.38]},
 {"point": [1.32, 0.00, 1.49]},
 {"point": [1.32, 0.00, 1.59]},
 {"point": [1.32, 0.00, 1.71]},
 {"point": [1.32, 0.00, 1.81]},
 {"point": [1.32, 0.00, 1.93]},
 {"point": [1.32, 0.00, 2.04]},
 {"point": [1.32, 0.00, 2.15]},
 {"point": [1.32, 0.00, 2.25]},
 {"point": [1.32, 0.00, 2.37]},
 {"point": [1.32, 0.00, 2.48]},
 {"point": [1.32, 0.00, 2.58]},
 {"point": [1.32, 0.00, 2.69]}
 ]
 */
