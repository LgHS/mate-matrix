var config;
var showPixelLocations = true;

var capture;

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

  capture = createCapture(VIDEO);
  capture.hide();

  colorMode(HSB, 100);
  background(0);
  fill(255);
  noStroke();
}

function draw() {
  translate(width,0);
  scale(-1.0,1.0);
  image(capture, 0, 0, width * capture.width / capture.height, height);

  drawFrame();
}
