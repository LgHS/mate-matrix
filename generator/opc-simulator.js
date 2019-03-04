const path = require('path');
const args = process.argv.slice(2);

// const config = require(path.resolve('.', args[0]));
const config = require("./lghs-21.json");

const crates = config.matrix.cols * config.matrix.rows;
const ledsByCrate = config.crate.rows * config.crate.cols;


