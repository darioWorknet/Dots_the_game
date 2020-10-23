class Triangle {
  
  //color cPlay1 = color (75,185,170);
  color cPlay1 = color (0,185,150);
  //color cPlay2 = color (250,190,80);
  color cPlay2 = color (235,80,70);
  color nonValidColor = color (200,215,0);
  color defColor = color (25);
  
  color tri1 = color (cPlay1,100);
  color tri2 = color (cPlay2, 100);
  
  
  ArrayList <PVector[]> p1Triangles = new ArrayList <PVector[]> ();
  ArrayList <PVector[]> p2Triangles = new ArrayList <PVector[]> ();
  ArrayList <PVector[]> allTriangles = new ArrayList <PVector[]> ();
  
  
  void show (){

      for (PVector[] t1 : p1Triangles){
        fill(tri1);
        triangle(t1[0].x, t1[0].y, t1[1].x, t1[1].y, t1[2].x, t1[2].y);
      }
      for (PVector[] t2 : p2Triangles){
        fill(tri2);
        triangle(t2[0].x, t2[0].y, t2[1].x, t2[1].y, t2[2].x, t2[2].y);
      }

  }
    

  
  void addTriangle (PVector P1, PVector P2, PVector P3){
     PVector [] newTriangle = new PVector[3];
     newTriangle[0] = new PVector ();
     newTriangle[0] = P1;
     newTriangle[1] = new PVector ();
     newTriangle[1] = P2;
     newTriangle[2] = new PVector ();
     newTriangle[2] = P3;
     if (!player_){
       p1Triangles.add(newTriangle);
     } else {
       p2Triangles.add(newTriangle);
     }
  }
  
  
  // USED NOW. Adds new triangle, receiving a triangle as input.
  void addTriangle (PVector[] T){
     if (player_){
       p1Triangles.add(T);
     } else {
       p2Triangles.add(T);
     }
  }
  
  
  


  
  void getNewTriangles (){  //this FUNCTION IS CALLED WHEN POINT 2 IS SELECTED, SO IT IS THE INTERFACE TO ADD NEW TRIANGLES new idea upside
    for (PVector [] l1 : d.lineMatrix){
      for (PVector [] l2 : d.lineMatrix){
        if (l1 != l2 && lastLine != l1 && lastLine != l2){  // if 3 lines are different
          if (isTriangle (l1, l2)){  // if these 3 lines form a triangle
            PVector intersection = new PVector ();
            intersection = getIntersection(l1, l2);
            PVector [] newTriangle = new PVector[3];
            newTriangle = getTriangle(intersection);
            if (noPointsInside (newTriangle)){              
              if (triangleNotExist(newTriangle)){
                System.out.println("adding triangle: " + newTriangle[0] +""+ newTriangle[1] +""+ newTriangle[2]);
                addTriangle (newTriangle);
              }
            }
          }
        }
      }
    }
  }
  
  
  
  boolean noPointsInside (PVector[] T){
    // get points of rectangle that inscribes the tiangle (possible points to be inside triangle must match this simple condition at first)
    int n= 0;
    float xMin = getMin (T[0].x , T[1].x , T[2].x);
    float xMax = getMax (T[0].x , T[1].x , T[2].x);
    float yMin = getMin (T[0].y , T[1].y , T[2].y);
    float yMax = getMax (T[0].y , T[1].y , T[2].y);
    for (PVector p : d.dotMatrix){     
      if (p.x != T[0].x && p.y != T[0].y && p.x != T[1].x && p.y != T[1].y && p.x != T[2].x && p.y != T[2].y ){
        if (p.x >= xMin && p.x <= xMax && p.y >= yMin && p.y <= yMax){ // the point is inside the rectangle
          n++;
          System.out.println ("there are " + n + " points inside the rectangle");
          float areaMain = abs(areaT (T[0], T[1], T[2]));
          float areaT1 = abs(areaT (T[0], T[1], p));
          float areaT2 = abs(areaT (T[0], T[2], p));
          float areaT3 = abs(areaT (T[1], T[2], p));
          float areaSum = areaT1 + areaT2 + areaT3 ;
          System.out.println ("areaMain = " + areaMain);
          System.out.println ("areaSum = " + areaSum);
          if (areaSum == areaMain){ // the point is inside the triangle
          return false; 
          }
        }
      }
    }
    return true;    
  }
  
  float areaT (PVector p1 , PVector p2, PVector p3){
    float area;
    area =(p1.x*(p2.y - p3.y) + p2.x*(p3.y - p1.y) + p3.x*(p1.y - p2.y))/2;
    return area;
  }
  
  float getMin (float A, float B, float C){
    if (A > B){
      A = B;
    }
    if (A > C){
      A = C;
    }
    return A;
  }
  
  float getMax (float A, float B, float C){
    if (A < B){
      A = B;
    }
    if (A < C){
      A = C;
    }
    return A;
  }
  
  
  boolean isTriangle(PVector[] l1, PVector[] l2){
    boolean condition1 = (lastLine[0] == l1[0] || lastLine[0] == l1[1]) && (lastLine[1] == l2[0] || lastLine[1] == l2[1]);
    boolean condition2 = (lastLine[0] == l2[0] || lastLine[0] == l2[1]) && (lastLine[1] == l1[0] || lastLine[1] == l1[1]);
    boolean condition3 = (l1[0] == l2[0] || l1[0] == l2[1]) || (l1[1] == l2[0] || l1[1] == l2[1]);

    if (condition1 && condition3|| condition2 && condition3){
      return true;
    } else{
      return false;
    }
  }
    
    
  
  
  boolean triangleNotExist (PVector[] T){
    
    allTriangles = new ArrayList <PVector[]> ();
    
    allTriangles.addAll(p1Triangles);
    allTriangles.addAll(p2Triangles);
        
    int nTriangles = allTriangles.size();
    int nDiffTriangles = 0;
    
    
    if (nTriangles == 0 ){
      return true;
    }

    for (PVector [] t : allTriangles){
      
      // if conditions 1, 2 & 3 are True, then the triangle T match with t
      boolean condition1 = T[0] == t[0] || T[0] == t[1] || T[0] == t[2] ;
      boolean condition2 = T[1] == t[0] || T[1] == t[1] || T[1] == t[2] ;
      boolean condition3 = T[2] == t[0] || T[2] == t[1] || T[2] == t[2] ;

      if (condition1 && condition2 && condition3){
        return false;
      }
    }
    //if arrived here is because there are no marches with our trangle
    return true;
  }
    
    
    
  PVector[] getTriangle (PVector P){
     PVector [] newTriangle = new PVector[3];
     newTriangle[0] = new PVector ();
     newTriangle[0] = lastLine[0];
     newTriangle[1] = new PVector ();
     newTriangle[1] = lastLine[1];
     newTriangle[2] = new PVector ();
     newTriangle[2] = P;
     
     return newTriangle;
  }
    
     
  PVector getIntersection (PVector[] l1, PVector[] l2){
    PVector intersection = new PVector ();
    
    if (l1[0] == l2[0]){
      intersection = l1[0];
    } else if (l1[0] == l2[1]){
      intersection = l1[0];
    } else if (l1[1] == l2[0]){
      intersection = l1[1];
    } else if (l1[1] == l2[1]){
      intersection = l1[1];
    } else {
      System.out.println ("Importante arreglar un bug en getIntersecion (TRIANGLE)");
    }
    
    return intersection;
  }
  
  
  
}
