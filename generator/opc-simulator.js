const path = require('path');
const args = process.argv.slice(2);

const config = require(path.resolve('.', args[0]));

const crates = config.matrix.cols * config.matrix.rows;
const ledsByCrate = config.crate.rows * config.crate.cols;
const totalCols = config.matrix.cols * config.crate.cols;
const totalRows = config.matrix.rows * config.crate.rows;

const spacing = -1 / 4;
const centerX = totalCols * spacing  / 2.0;
const centerY = totalRows * spacing / 2.0;

let output = [];

for (let crateY = 0; crateY < config.matrix.rows; crateY++) {
  const posY = crateY * config.crate.rows;
  for (let crateX = 0; crateX < config.matrix.cols; crateX++) {
    const posX = crateX * config.crate.cols;
    for (let ledY = 0; ledY < config.crate.rows; ledY++) {
      for (let ledX = 0; ledX < config.crate.cols; ledX++) {
        const indexX = (ledY%2==1)?  posX + config.crate.cols-1 - ledX : posX  + ledX;
        const indexY = posY + ledY;
        const normalizedX = (indexX / totalCols) + (spacing * indexX);
        const normalizedY = (indexY / totalRows) + (spacing * indexY);
        output.push({ "point": [normalizedX-centerX, 0, normalizedY-centerY] });
      }
    }
  }
}


console.log(JSON.stringify(output));
