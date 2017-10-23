
function setup() {
  var myCanvas = createCanvas(400, 400);
  myCanvas.parent('draw_canvas');
  background(200);
}

function draw() {
  // Piirra pallo
  ellipse(mouseX, mouseY, 30, 30);
}

function keyPressed() {
  background(200);
}



