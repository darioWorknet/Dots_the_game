class Line extends Triangle{
  

  ArrayList <PVector[]> lineMatrix  = new ArrayList <PVector[]> ();
  
  void addLine (PVector d1, PVector d2){
    PVector [] newLine = new PVector [2] ;
    newLine[0] = new PVector ();  
    newLine[0] = d1;
    newLine[1] = new PVector (); 
    newLine[1] = d2;

    lineMatrix.add (newLine);
    
    //System.out.println ("adding line " + newLine[0] + newLine[1]);
  }  
  
  color playerColor (){
    if (lineValid()){
    if (player_){
      return  cPlay1;
    }else{
      return  cPlay2;
    }
    }else{
      return nonValidColor;
    }

  }

  void show (){
    super.show();
    strokeWeight (4);
    try{
      for (PVector[] l : lineMatrix){
        stroke(defColor);
        line (l[0].x, l[0].y , l[1].x, l[1].y);
      }
    }catch(NullPointerException e){
      //System.out.println ("no lines created yet");
    }
    if (P1selected){
      stroke (playerColor());
      line (P1.x, P1.y, mouseX, mouseY);
    }
    noStroke();

  }
  
  
  
  
  boolean lineValid(){
    if ( ! P1selected || ! highlighted ){
      return true;
    }
    
    double area = d.distance (P1, hglPoint);
    double A = hglPoint.y - P1.y;
    double B = - (hglPoint.x - P1.x);
    double C = -(P1.x * (hglPoint.y - P1.y)) + (P1.y * (hglPoint.x - P1.x)); 
    
    if (notClosePoints(A, B, C, area) && notCrossing(A, B, C)  && notRepeated()){
      return true;
    }else{
      return false;
    }

  }
  
  
  
  
  boolean lineValid(PVector p1, PVector p2){
    PVector [] line = new PVector[2];
    line = getLine (p1, p2);
      
    double area = d.distance (p1, p2);
    double A = p2.y - p1.y;
    double B = - (p2.x - p1.x);
    double C = -(p1.x * (p2.y - p1.y)) + (p1.y * (p2.x - p1.x)); 
      
    if (notClosePoints(A, B, C, area, line) && notCrossing(A, B, C, line)  && notRepeated(line)){
      return true;
    }else{
      return false;
    }
  }
 
    
    
  boolean notRepeated (PVector [] L){
    for (PVector[] l : lineMatrix){
      if ((l[0] == L[0] && l[1] == L[1]) || (l[0] == L[1] && l[1] == L[0])){
        return false;
      }
    }
    return true;
  }
 
  
  
  
  boolean notRepeated (){
      for (PVector[] l : lineMatrix){
        if ( (l[0] == P1 && l[1] == hglPoint) || (l[0] == hglPoint && l[1] == P1)){
          return false;
        }
      }
      return true;
    }

  
  boolean notClosePoints(double A, double B, double C, double area){
    //System.out.println ( "A: " + A + "  B: " + B + "  C:" + C);
    for (PVector dot : d.dotMatrix){    
      if (highlighted && d.distance(P1,dot)<area && d.distance(hglPoint,dot)<area){
        if (distance (A,B,C,dot) < dotR){
          return false;
        }
      }
    }
    return true;
  }
  
    boolean notClosePoints(double A, double B, double C, double area, PVector [] L){
    //System.out.println ( "A: " + A + "  B: " + B + "  C:" + C);
    for (PVector dot : d.dotMatrix){    
      if (d.distance(L[0],dot)<area && d.distance(L[1],dot)<area){
        if (distance (A,B,C,dot) < dotR){
          return false;
        }
      }
    }
    return true;
  }
  
  
  boolean notCrossing (double A1, double B1, double C1){  
    for (PVector[] l : lineMatrix){
      double A2 = l[1].y - l[0].y;
      double B2 = - (l[1].x - l[0].x);
      double C2 = -(l[0].x * (l[1].y - l[0].y)) + (l[0].y * (l[1].x - l[0].x));
      
      PVector crossPoint = crossingPoint (A1, A2, B1, B2, C1, C2);
            
      if (highlighted && onBoard(crossPoint) && isBetween(P1, hglPoint, crossPoint, l[0], l[1])){       
        return false;
      } 
      
    }   
    return true;    
  }
  
    boolean notCrossing (double A1, double B1, double C1, PVector[] L){  
    for (PVector[] l : lineMatrix){
      double A2 = l[1].y - l[0].y;
      double B2 = - (l[1].x - l[0].x);
      double C2 = -(l[0].x * (l[1].y - l[0].y)) + (l[0].y * (l[1].x - l[0].x));
      
      PVector crossPoint = crossingPoint (A1, A2, B1, B2, C1, C2);
            
      if (onBoard(crossPoint) && isBetween(L[0], L[1], crossPoint, l[0], l[1])){       
        return false;
      } 
      
    }   
    return true;    
  }
  
  
  double distance (double A, double B, double C , PVector d){
    double dis = (A*d.x + B*d.y + C)/ Math.sqrt(Math.pow (A,2) + Math.pow (B,2));
    if (dis < 0){
      dis = -dis;
    }
    return dis; 
  }
  
  
  boolean onBoard (PVector P){
    if (P.x >= 0 && P.x <= width && P.y >= 0 && P.y <= height){
      return true;
    } else {
      return false;
    }
  }
  
  
  boolean isBetween (PVector P1, PVector P2, PVector P3, PVector P4, PVector P5){
    if (P1 == P4 || P1 == P5 || P2 == P4 || P2 == P5){
      return false;
    }
    
    double error = 5;
    
    double d1_Main = d.distance (P1, P2);
    double d1_1 = d.distance (P1, P3);
    double d1_2 = d.distance (P2, P3);
    double d1_Sum = d1_1 + d1_2 - error ;
    
    double d2_Main = d.distance (P4, P5);
    double d2_1 = d.distance (P4, P3);
    double d2_2 = d.distance (P5, P3);
    double d2_Sum = d2_1 + d2_2 - error ;
    
    boolean condition1 = d1_Main <= d1_Sum;
    boolean condition2 = d2_Main <= d2_Sum;

    if ( condition1 || condition2){
      return false;
    } else {
      return true;
    }
  }
  
  
  PVector crossingPoint (double A1, double A2, double B1, double B2, double C1, double C2){
    double m1 = A1/B1;
    double m2 = A2/B2;
    PVector cross = new PVector ();
    
    if (m1 != m2){
      cross.y = ((float)C1*(float)A2 - (float)C2*(float)A1) / ((float)B2*(float)A1 - (float)B1*(float)A2);
      cross.x = (-(float)B1*cross.y - (float)C1) / (float)A1;
      return cross;
    } else {
      return cross;
    }
  }
  
  boolean noMoreMovs (){
    int i = 0;
    for (PVector p1 : d.dotMatrix){ 
      for (PVector p2 : d.dotMatrix){ 
        if (p1 != p2 /*&& p1 != null && p2 != null*/){
          if (lineValid (p1, p2)){
            i++;
            if (i==1){
              System.out.println ("Is possible to attach points " + p1 + "" + p2); //if the last two point have the same Y component, the conditions dont work
            }
            return false;
          }
        }
      }
    }
    return true;
  }
  
  
  PVector [] getLine (PVector p1 , PVector p2){
    PVector [] newLine = new PVector[2];
    newLine[0] = p1;
    newLine[1] = p2;
    return newLine;
  }
        

}
