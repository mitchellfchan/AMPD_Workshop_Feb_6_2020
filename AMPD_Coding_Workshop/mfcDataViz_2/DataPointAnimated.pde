public class DataPointAnimated extends DataPoint{
  
  float counter = 0;
  float v = 0;
  float a = 0.1;
  
  public DataPointAnimated(){
    super();
  }
  
  public DataPointAnimated(float _x, float _y){
    super(_x,_y);
  }
  
  public void setForces(float _v, float _a){
    v = _v;
    a = _a;
  }
  
  public void bounce(float highLimit, float lowLimit){
  
    
      if(getY() >= highLimit){
        this.setY(highLimit-10);
        v = - v;
      }
       if(getY() <= lowLimit){
         this.setY(lowLimit+10);
         v=-v;
       }
      
        v = v+a;
      this.setY(getY() + v);
      
      
      
      
  }
   
}
