var config;
var showPixelLocations = true;

function preload() {
  config = loadJSON('/libraries/matrix_config.json');
}

function setup() {
  // get matrix width/height ratio
  var matrixSizeRatio = (config.cols * config.crateW) / (config.rows * config.crateH);
  // setup canvas size
	createCanvas(windowWidth * matrixSizeRatio, windowHeight);

  socketSetup("ws://" + config.fcAddress + ":7890");
  initMatrix(config);

  colorMode(HSB, 100);
  background(0);
  fill(255);
  noStroke();
}

function draw() {
  rect(mouseX - 40, mouseY - 50, 100, 100);

  drawFrame();
}
