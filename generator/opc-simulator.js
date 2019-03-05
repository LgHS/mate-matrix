const path = require('path');
const args = process.argv.slice(2);

const config = require(path.resolve('.', args[0]));

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
