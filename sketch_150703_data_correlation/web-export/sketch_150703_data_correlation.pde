int arLength;
int period   = 15;
int stepSize = 10;
float[] ar1;
float[] ar2;
//=================================================================
void setup() {
  size(1000, 500);
  arLength = width;
  ar1 = new float[arLength];
  ar2 = new float[arLength];
  ar1[0]=height/2;
  ar2[0]=height/2;

  for (int i = 1; i < arLength; i++) {
    ar1[i]=Clamp(ar1[i-1]+random(-stepSize, stepSize), 0, height);
    ar2[i]=Clamp( ar2[i-1]+random(-stepSize, stepSize), 0, height);
  }
}
//=================================================================
float Clamp(float val, float min, float max) {
  if (val<min)return min;
  else if (val>max)return max;
  else return val;
}
//=================================================================
void draw() {
 // frame.setTitle(""+frameRate);
   float displayScale = width/ar1.length;
  float val = 0;
  float prevVal = 0;
  // draw background and grid
  background(40, 40, 40);
  strokeWeight(2);
  stroke(100);
  line(0, height/2, width, height/2);
  strokeWeight(1);
  line(0, height*0.2, width, height*0.2);
  line(0, height*0.8, width, height*0.8);		
 
  period = (int)map(mouseY, 0, height, 10, width/4);
  for (int i=1; i<ar1.length; i++) {
    // draw correlation
    if (i>=period) {
      prevVal = val;
      val = correlation(i, period);
      fill(0);
      strokeWeight(1);
      stroke(200);
      line(map(i, 0, ar1.length, 0, width), map(val, -1, 1, height, 0), 
      map(i-1, 0, ar1.length, 0, width), map(prevVal, -1, 1, height, 0));
    }
    //draw datasets
     stroke(255, 0, 0);
    strokeWeight(2);
    line(map(i, 0, ar1.length, 0, width), ar1[i],  map(i-1, 0, ar1.length, 0, width), ar1[i-1]);
  
    stroke(0, 0, 250);
    line(map(i, 0, ar1.length, 0, width), ar2[i],  map(i-1, 0, ar1.length, 0, width), ar2[i-1]);
  }
  // draw period-length
  strokeWeight(2);
  stroke(0);
  strokeWeight(1);
  fill(200, 50);
  rect(mouseX, 0, -map(period,0,ar1.length,0,width), height);
}

//=================================================================
float correlation(int i, int period) {
  float retVal=0;
  float sd1 = standardDeviation(ar1, i, period);
  float sd2 = standardDeviation(ar2, i, period);
  float mean1 = getAverage(ar1, i, period);
  float mean2 = getAverage(ar2, i, period);
  for (int j = 0; j < period; j++) {
    float tmp1 = (ar1[i-j]-mean1)/sd1; 
    float tmp2 = (ar2[i-j]-mean2)/sd2;
    retVal += (tmp1*tmp2);
  }
  return retVal/(period-1);
}

//=================================================================
float getAverage(float[] ar, int i, int period) {
  float avg=0;
  for (int p = 0; p < period; p++) {
    avg+=ar[i-p];
  }
  return avg/period;
}
//=================================================================
float standardDeviation(float[] ar, int i, int period) {
  float avg = getAverage(ar, i, period);

  float sd = 0;
  for (int j=0; j<period; j++) {
    sd+=sq(ar[i-j]-avg);
  }
  sd/=(period-1); // -1 because sample! ...right?
  sd = sqrt(sd);
  return sd;
}
//=================================================================
// new data-sets
void mousePressed() {
  ar1 = new float[arLength];
  ar2 = new float[arLength];
 ar1[0]=height/2;
  ar2[0]=height/2;

  for (int i = 1; i < arLength; i++) {


    ar1[i]=Clamp(ar1[i-1]+random(-stepSize, stepSize), 0, height);
    ar2[i]=Clamp( ar2[i-1]+random(-stepSize, stepSize), 0, height);
  }
}



