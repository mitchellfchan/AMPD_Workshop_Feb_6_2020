Table table;
DataViz dv1;

void setup() {
  size(1000, 1000);
  table = loadTable("AcidRain.csv", "header");
 
  dv1 = new DataViz(table, 1000, 1000);
  dv1.mapChart("Year", "Sulphur oxides (percentage change from 1990 level)");  
  dv1.setAxisLimits(1990, 2017, -100, 0);
  dv1.scalePoints(); 
  dv1.renderChart();
  dv1.extras();
  dv1.renderCurve();
  dv1.labelAxes();
  image(dv1.pgViz, 0, 0);
}
