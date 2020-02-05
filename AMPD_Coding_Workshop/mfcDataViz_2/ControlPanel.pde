import controlP5.*;


public class ControlPanel{
  ControlP5 cp5;
  PGraphics pgCtrl;
  PApplet parent;
  int sliderWidth = 100;
  int sliderHeight = 20;
  
  
  public ControlPanel(PApplet _parent){
    Slider testSlider;
    parent = _parent;
    cp5 = new ControlP5(_parent);
    cp5.addSlider("GDP Growth Rate")
    .setPosition(100, 100)
    .setSize(sliderWidth,sliderHeight)
    .setRange(-12,12)
    .setValue(1.72)
    .plugTo(parent, "testSliderVal")
    ;
   
   
       }
}
