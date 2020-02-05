public class Rain{
  float x, y, size;
  float speed;
  color c;
  color cHilight;
  boolean hilight = false;
  
  public Rain(){
    x = random(0, 1000);
    y = random(0,1000);
    size = random(16,80);
    speed = size/2;
    c = color(32, 66, 252);
    cHilight = color(255, 120, 106);
  }
  
  void display(PGraphics pg){
    pg.pushStyle();
    pg.beginDraw();
    pg.noStroke();
    if(!hilight) pg.fill(c);
    else pg.fill(cHilight);
    pg.rect(x,y,size/5,size);
    
    println("drawingRain!");
    pg.endDraw();
    pg.popStyle();
  }
  
  void fall(){
    if (y > 1000) y=0;
    y = y+speed;
  }
  
  void calculateHilight(ArrayList<DataPointAnimated> blobs){
    for(DataPointAnimated d : blobs){
      if (dist(x, y, d.getX(), d.getY()) < 25) {
        hilight = true;
      }
    }
  }
  
  
}
