var config;
var showPixelLocations = true;

var myShader;

function preload() {
  config = loadJSON('/libraries/matrix_config.json');
  myShader = loadShader('example.vert', 'example.frag');
}

function setup() {
  // get matrix width/height ratio
  var matrixSizeRatio = (config.cols * config.crateW) / (config.rows * config.crateH);
  // setup canvas size
	createCanvas(windowWidth * matrixSizeRatio, windowHeight, WEBGL);

  socketSetup("ws://" + config.fcAddress + ":7890");
  initMatrix(config);

  colorMode(HSB, 100);
  // background(0);
  noStroke();
}

function draw() {
  shader(myShader);

  myShader.setUniform('time', frameCount);

  rect(0, 0, width, height);

  drawFrame();
}
