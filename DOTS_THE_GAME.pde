import java.lang.Math;


int dotR;
int numberOfDots;

boolean player_;
boolean highlighted;
boolean P1selected;

PVector P1;
PVector P2;
PVector hglPoint;

PVector [] lastLine;

boolean gameOver;

Dot d;
Line l;
Triangle t;

String picName;


void setup (){
  size (750, 750);
  dotR = 20;
  // Number of dots which appear (30 by default)
  numberOfDots = 30;
  
  d = new Dot (numberOfDots);
  l = new Line ();
  t = new Triangle ();
    
}



void draw(){
   
  if (gameOver){
    picName = "screenshots/" + String.valueOf(day()) + "_" + String.valueOf(month()) + "_" + String.valueOf(year()) + "__" + "Player1_" + String.valueOf(d.p1Triangles.size()) + "__" + "Player2_" + String.valueOf(d.p2Triangles.size()) + ".png";
    save(picName);
    background(200);
    stop();
  }else{
    background (255);
  }
 
  highlighted = false;
 
//HIGLIGHT WHEN PASSING OVER POINTS
  d.highlight();
  
// GET P1
  if (mousePressed && ! P1selected && highlighted){
    d.getP1();
  }
// GET P2
  if (mousePressed && P1selected){
    d.getP2();
  }
  
  d.show(player_); 
      
}
