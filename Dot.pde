class Dot extends Line{
  

  
  ArrayList<PVector> dotMatrix;
  
  Dot(){}
  
  Dot (int n){
    dotMatrix = new ArrayList<PVector> ();
    int lMargin = dotR + 6;
    int uMargin = width - lMargin;

    for (int i = 0 ; i<n; i++){
      PVector newDot = new PVector ((int)random(lMargin, uMargin),(int)random(lMargin, uMargin));

        if (isValid(newDot)){
          dotMatrix.add(newDot);
        }else{
          if (n<1000){ // max interations
            n++;
          }
        }
    }
    //System.out.println (dotMatrix);
    System.out.println ("Iterations: " + n);
    System.out.println ("Number of dots: " + dotMatrix.size() + " of " + numberOfDots + " preselected");
  }
  
  
  boolean isValid (PVector dot){
    int minSeparation = dotR * 6;
    for (PVector d : dotMatrix){
      if (distance(d , dot) < minSeparation){
        return false;
      }
    }
    return true;
  }
  
  
  double distance (PVector P1 , PVector P2){
    double dis = Math.sqrt(Math.pow((P1.x-P2.x),2) + Math.pow((P1.y-P2.y),2));
    return dis;

  }
  
  
  double distance (int mX, int mY, PVector dot){
    double dis = Math.sqrt(Math.pow((mX-dot.x),2) + Math.pow((mY-dot.y),2));
    return dis;
  }
  
  
  
    void show(boolean player){
    super.show();
    //ALL POINTS IN THE BOARD
    for (PVector d : dotMatrix){
      fill(defColor);
      circle(d.x, d.y, dotR);
    }
    //GET PLAYER COLOR
    if (P1selected){
      fill (playerColor());
      circle(P1.x , P1.y , dotR);
    }

    //HIGHLIGHT THE POINT SELECTED
    if (highlighted && lineValid()&&!gameOver){ 
      fill(playerColor());
      circle (hglPoint.x, hglPoint.y, dotR * 2);
    }
    }
    
    
  void getP1(){
    System.out.println("P1 slected");
    P1selected = true;
    P1 = hglPoint;
    mousePressed = false;
    delay(250);
  }
  
  
  void getP2(){
    if (highlighted && lineValid()){
      setP2();

    }else{    //deselect point
      P1selected = false;
      System.out.println ("deleting point");
      P1 = new PVector ();
      hglPoint = new PVector();
    }
    delay(250);
  }
  
  
  void setP2(){
      System.out.println("P2 slected");
      P1selected = false;
      P2 = hglPoint;
      addLine(P1, P2);
      lastLine = new PVector[2];
      lastLine = lineMatrix.get(lineMatrix.size() - 1);
      System.out.println (lastLine[0]);
      
      getNewTriangles();
      
      System.out.println ("PLAYER_1: " + p1Triangles.size() + "    PLAYER_2: " + p2Triangles.size());
        
      P1 = new PVector ();
      P2 = new PVector ();
      player_ = !player_;
      checkState();
  }
    
  
  
  void highlight(){
    for (PVector dot : dotMatrix){
      if (distance ((int)mouseX, (int)mouseY, dot) < dotR){
        hglPoint = dot;
        if (hglPoint != P1){
          highlighted = true;
        }
      }
    }
  }
  
  void checkState(){
    if (noMoreMovs()){
      System.out.println("gameOver");
      gameOver = true;
    }
  }
      
  
}
