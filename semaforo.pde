//import processing.io.*;

int rectX, rectY;
int buttonX, buttonY;      // Position of square button
int circleX, circleY;  // Position of circle button
int circle2X, circle2Y;  // Position of circle button
int circle3X, circle3Y;  // Position of circle button
int buttonSize = 50;     // Diameter of rect
int rectSize = 300;     // Diameter of rect
int rectWidth = 100;     // Diameter of rect
int circleSize = 93;   // Diameter of circle
color rectColor, circleColor, circle2Color, circle3Color, baseColor;
color lowGreenColor, lowRedColor, lowYellowColor;
color rectHighlight, circleHighlight;
color currentColor;
boolean rectOver = false;
boolean circleOver = false;

boolean redActive = false;
boolean yellowActive = false;
boolean greenActive = false;

int seconds = 0;
int timer = 0;

int greenPin = 17;
int yellowPin = 18;
int redPin = 27;

void setup() {
	size(640, 360);
	rectColor = color(0);
	rectHighlight = color(51);
	circleColor = color(255,0,0);
	circle2Color = color(255,255,0);
	circle3Color = color(0, 255, 0);
	
	lowRedColor = color(130,0,0);
	lowGreenColor = color(0,130,0);
	lowYellowColor = color(130, 130, 0);
	
	greenActive = true;
	
	circleHighlight = color(204);
	baseColor = color(102);
	currentColor = baseColor;
	circleX = 100;
	circleY = height/2;
	circle2X = 200;
	circle2Y = height/2;
	circle3X = 300;
	circle3Y = height/2;
	
	rectX = 50;
	rectY = height/2-rectWidth/2;
	
	buttonX = 400;
	buttonY = height/2-rectWidth/2;
	ellipseMode(CENTER);

  GPIO.pinMode(greenPin, GPIO.OUPUT);
  GPIO.pinMode(yellowPin, GPIO.OUPUT);
  GPIO.pinMode(redPin, GPIO.OUPUT);
}

void draw() {
  update(mouseX, mouseY);
  background(currentColor);
  
  stroke(255);
  fill(rectColor);
  rect(rectX, rectY, rectSize, rectWidth);
  
  if (rectOver) {
	fill(rectHighlight);
  } else {
	fill(rectColor);
  }
  
  rect(buttonX, buttonY, buttonSize, buttonSize);
  
  if (circleOver) {
  	fill(circleHighlight);
  } else {
	fill(circleColor);
  }
  stroke(0);
  if (redActive)
	fill(circleColor);
  else
	fill(lowRedColor);
  ellipse(circleX, circleY, circleSize, circleSize);
  
  if (yellowActive)
	fill(circle2Color);
  else
	fill(lowYellowColor);
  ellipse(circle2X, circle2Y, circleSize, circleSize);
  
  if (greenActive)
	fill(circle3Color);
  else
	fill(lowGreenColor);
  ellipse(circle3X, circle3Y, circleSize, circleSize);
}

void update(int x, int y) {
  if ( overRect(buttonX, buttonY, buttonSize, buttonSize) ) {
	rectOver = true;
	circleOver = false;
  } else {
	circleOver = rectOver = false;
  }
  
  // Get seconds to change time
  if (seconds != second())
  {
	timer++;
  }
  seconds = second();  
  
  if (redActive)
  {
	greenActive = false;
	yellowActive = false;
  	GPIO.digitalWrite(redPin, GPIO.HIGH);
	
	if (timer == 10)
	{
	  redActive = false;
	  greenActive = true;
	  GPIO.digitalWrite(redPin, GPIO.LOW);
	  timer = 0;
	  delay(1000);
	}
  }
  
  else if (yellowActive)
  {
	redActive = false;
	greenActive = false;
  	GPIO.digitalWrite(yellowPin, GPIO.HIGH);
	
	if (timer == 5)
	{
	  yellowActive = false;
	  redActive = true;
	  GPIO.digitalWrite(yellowPin, GPIO.LOW);
	  timer = 0;
	}
  }
  
  else if(greenActive)
  {
	redActive = false;
	yellowActive = false;
  	GPIO.digitalWrite(greenPin, GPIO.HIGH);
	
	if (timer == 15)
	{
	  greenActive = false;
	  yellowActive = true;
	  GPIO.digitalWrite(greenPin, GPIO.LOW);
	  timer = 0;
	}
  }
  
}

void mousePressed() {
  if (rectOver) {
	if (greenActive)
	{
	  delay(1000);
	  timer = 0;
	  greenActive = false;
	  yellowActive = true;
	  GPIO.digitalWrite(greenPin, GPIO.LOW);
	}
  }
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
	  mouseY >= y && mouseY <= y+height) {
	return true;
  } else {
	return false;
  }
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
	return true;
  } else {
	return false;
  }
}