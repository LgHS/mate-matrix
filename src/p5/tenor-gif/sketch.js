/**
 * 
 * Small sketch that fetches a random gif (mp4) from tenor.com's api and
 * displays it in an html5 canvas
 * @urlparams : 
 * 	- duration : sets the refesh delay in auto mode (ideally in ms, but handles the conversion for values under 120)
 *  - apiKey : defines the tenor api key
 */
let config;
let apiKey;
let textField, btn;
let apiKeyFieldsVisible = false;

let apiUrl  = 'https://api.tenor.com/v1/search?media_filter=minimal&limit=20&key=';
let queryString='&q=';
let terms = [
	'cat', 'cats', 'crazy-cat', 'mad-hatter', 'unicorn', 'nyan-cat', 'happy', 'birthday',
	'meme', 'nerd', 'hardware', 'hackerspace', '42', 'unicorn', 'rainbow', 'pokemon',
	'club-mate', 'leds', 'matrix', 'computers','party', 'party-parrot', 'boobs', 'cake', 
];
let imgUrl;
let imgElmt;
let vid;
let auto = true;
let duration = 20000;

function preload(){
	config = loadJSON('/libraries/matrix_config.json');
}
function setup() {
	if(config){
		let matrixSizeRatio = (config.cols * config.crateW) / (config.rows * config.crateH);
		createCanvas(windowWidth*matrixSizeRatio, windowHeight);
		socketSetup("ws://"+config.fcAddress+":7890");
		initMatrix(config);
	}else{
		// DEV mode
		createCanvas(windowWidth, windowHeight);
	}

	let urlParams = getURLParams();
	print(urlParams);
	duration = urlParams.duration || 20000;
	if(duration < 120){
		duration *= 1000;
	}else if(duration < 10000){
		duration = 10000;
	}
	if(apiKey){
		apiUrl+=apiKey;
		print('got apiKey');
		fetchRandomGif('tenor');
	}else if(urlParams.apiKey){
		apiKey = urlParams.apiKey;
		fetchRandomGif('tenor');
	}else{
		// if no api key was found, display an input field to the user
		textField = createInput('');
		textField.elt.placeholder = "insert your Tenor Api Key";
		textField.position(width/2, height/2);
		btn = createButton('submit');
		btn.position(width/2, height/2+40);
		btn.mousePressed(setApiKey);
		
		print("Please insert your Api key in the url parameter giphyKey");	
	}
}

function draw() {
	if(! apiKey){
		noLoop();
		return;
	}else{
		//background(0);
		if(vid){
			// draws the video frame in the canvas
			// we might want to be more thoughtful about aspect ratio
			image(vid, 0,0, width, height);
		}
		
	}
	
}

function gotGiphyData(giphy){
	if(giphy.data.images){
		// rates limit on free tier api key is too low
		// we won't use Giphy this time
	}
}

/**
 * 
 * @param {*} tenor : request result
 * callback that gets the json result from api call
 * TODO : error management
 */
function gotTenorData(tenor){
	if(tenor.results){
		print('gotcha');
		let url = random(tenor.results).media[0].mp4.url;
		vid = createVideo(url, ()=>vid.loop());
		vid.hide();		
	}
}

function keyPressed(){
	
	if(keyCode == ' '){
		auto = false;
		fetchRandomGif('tenor');
	}else if(keyCode == 65){
		auto = true;
		print('automode ');
		fetchRandomGif('tenor');
	}
}

function fetchRandomGif(service){
	print('trying to fetch gif from '+service);
	if(service=='giphy'){
		loadJSON(apiUrl, gotData);
	}else{
		loadJSON(apiUrl+selectSearchTerm(), gotTenorData);
	}
	if(auto){
		window.setTimeout(fetchRandomGif, duration, 'tenor');
	}
}

function selectSearchTerm(){
	
	let item = random(terms);
	return queryString+item;
}

function setApiKey(){
	
	apiKey = textField.value();
	apiUrl+=apiKey;
	
	hideApiKeyFields();
	fetchRandomGif();
	loop();
}

function hideApiKeyFields(){
	btn.hide();
	textField.hide();
}

function showApiKeyFields(){
	btn.show();
	textField.show();
}