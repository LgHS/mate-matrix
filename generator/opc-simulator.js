const path = require('path');
const args = process.argv.slice(2);

// const config = require(path.resolve('.', args[0]));
const config = require("../lghs-21.json");

const crates = config.matrix.cols * config.matrix.rows;
const ledsByCrate = config.crate.rows * config.crate.cols;
const totalCols = config.matrix.cols * config.crate.cols;
const totalRows = config.matrix.rows * config.crate.rows;

const spacing = -1 / 4;

let output = [];

for (let crateY = 0; crateY < config.matrix.rows; crateY++) {
  for (let crateX = 0; crateX < config.matrix.cols; crateX++) {
    for (let ledY = 0; ledY < config.crate.rows; ledY++) {
      for (let ledX = 0; ledX < config.crate.cols; ledX++) {
        const indexX = crateX * config.crate.cols + ledX;
        const indexY = crateY * config.crate.rows + ledY;
        const normalizedX = (indexX / totalCols) + (spacing * indexX);
        const normalizedY = (indexY / totalRows) + (spacing * indexY);
        output.push({ "point": [(totalRows * spacing) - normalizedX, 0, (totalCols * spacing) - normalizedY] });
      }
    }
  }
}


console.log(JSON.stringify(output));

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
