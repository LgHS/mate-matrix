let config={
  listen: ["127.0.0.1", 7890],
  verbose: true,

  color: {
      gamma: 2.5,
      whitepoint: [1.0,1.0,1.0],
      linearCutoff: 0.00390625
  },
  devices:[]
};
let devices = [
  // {serial: "VBNGDLOIKOJQKIPD", type:"fadecandy", groups:8, cratesByGroup: 3, ledByCrate: 20 , colorOrder:"grb" },
  // {serial: "SGCBIMISMMDUMCTF", type:"fadecandy", groups:8, cratesByGroup: 3, ledByCrate: 20 , colorOrder:"grb" },
  { serial: "AOFQFPTBHLLYEYTD", type: "fadecandy", groups: 8, cratesByGroup: 3, ledByCrate: 20, colorOrder: "grb" },
  { serial: "JXEDMKOUXTBKISFV", type: "fadecandy", groups: 8, cratesByGroup: 3, ledByCrate: 20, colorOrder: "grb" },

];
let ledOffset = 0;

for(let i=0; i < devices.length; i++){
  let d = devices[i];
  let deviceConfig = {};
  deviceConfig["type"] = d.type;
  deviceConfig["serial"] = d.serial;
  let ledsByGroup = d.cratesByGroup * d.ledByCrate;

  deviceConfig["map"] = [];
  for(let j = 0; j < d.groups; j++){

    let group = [0, ledOffset+j*ledsByGroup, j*64, ledsByGroup, d.colorOrder];
    deviceConfig["map"].push(group);

  }
  ledOffset += ledsByGroup*d.groups;

  config.devices.push(deviceConfig);
};

console.log(JSON.stringify(config));
