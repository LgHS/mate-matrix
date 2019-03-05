const path = require('path');
const args = process.argv.slice(2);

const config = require(path.resolve('.', args[0]));

const crates = config.matrix.cols * config.matrix.rows;
const ledsByCrate = config.crate.rows * config.crate.cols;

let ledOffset = config.fadecandy.ledOffset;
let output = {
  listen: config.opc,
  verbose: config.fadecandy.verbose,
  color: config.fadecandy.color,
  devices: []
};

const calculateGroups = (index) => {
  const maxGroupsByDevice = 8;
  const totalGroups = Math.ceil(crates / config.fadecandy.cratesByGroup);
  if ((index + 1) * maxGroupsByDevice < totalGroups) {
    return maxGroupsByDevice;
  } else {
    return crates % maxGroupsByDevice;
  }
};

for (let i = 0; i < config.fadecandy.devices.length; i++) {
  let d = config.fadecandy.devices[i];
  let deviceConfig = {};
  deviceConfig["type"] = "fadecandy";
  deviceConfig["serial"] = d;
  let ledsByGroup = config.fadecandy.cratesByGroup * ledsByCrate;

  deviceConfig["map"] = [];
  const groups = calculateGroups(i);

  for (let j = 0; j < groups; j++) {
    let group = [
      0,
      ledOffset + j * ledsByGroup,
      j * 64,
      ledsByGroup,
      config.fadecandy.colorOrder
    ];
    deviceConfig["map"].push(group);
  }

  ledOffset += ledsByGroup * groups;

  output.devices.push(deviceConfig);
}

console.log(JSON.stringify(output));
