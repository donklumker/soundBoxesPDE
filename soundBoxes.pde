import processing.sound.*;
int d = 19;

//possible bands/sqrt: 1024/16 2048/45 (good for live interaction), 4096/64, 8192/91 (better for layering)
int band = 1024;
int unit = d+3;
int count;
Module [] modA;
float[]spectrum  = new float [band];
AudioIn in;
FFT fft;
float bd = band;

int fcount, lastm;
float frate;
int fint = 3;

void setup() {

  size(1100, 1100, P3D);
  background(255, 129, 22);



  fft = new FFT(this, band);
  in = new AudioIn (this, 0);
  in.start();

  fft.input(in);


  int wideCount = 32;
  int highCount = 32;
  count = wideCount * highCount;

  modA = new Module [count];

  int index = 0;
  for (int y = 0; y < highCount; y++) {
    for (int x = 0; x < wideCount; x++) {
      modA[index++] = new Module(unit * x, unit * y, d, d, unit, y * x);
    }
  }
}

void draw() {

  background(255, 129, 22);

  //fill (255, 129, 22, 2);
  //background(255, 129, 22);
  //background (255);

  //rect (0, 0, width, height);
  //camera (70.0, 35.0, 120.0, -120.0 , 150.0, 0.0, 0.0, 1.0, 0.0);


  // Turn on the lights.
  ambientLight(228, 255, 255);
  directionalLight(128, 128, 128, 0, 0, -1);

  for (int i = 0; i < count; i++) {

    push();
    translate(width/2-125, height/2, -0);
    //rotateY (PI/4);
    rotateX (PI/3);
    rotateZ (PI/6);


    modA[i].updateDraw();
    pop();
  }
  push();
  fcount += 1;
  int m = millis();
  if (m - lastm > 1000 * fint) {
    frate = float(fcount) / fint;
    fcount = 0;
    lastm = m;
    println("fps: " + frate);
  }
  fill(0);
  push();
  noStroke();
  fill(25, 129, 22);
  rect (10, 10, 80, 10);
  
  pop();
  text("fps: " + frate, 10, 20);
  pop();
}

void keyTyped() {
  if (keyPressed == true || keyPressed == true) {
    save("3d-grid-box.tif");
  }
}

class Module {

  int xOff;
  int yOff;
  int xsz;
  int ysz;
  float zsz;
  float lrp;
  int unit; //may be need to fix
  int band; //may need to fix


  Module (int _xOff, int _yOff, int _xsz, int _ysz, int _unit, int _band) {

    xOff = _xOff;
    yOff = _yOff;
    xsz = _xsz;
    ysz = _ysz;
    unit = _unit;
    band = _band;
  }



  void updateDraw() {
    //noStroke();
    strokeWeight(.5);
    stroke (255, 129, 22);
    // stroke (255);
    ortho();


    fft.analyze(spectrum);



    zsz = map (spectrum [band], 0.000, 100.000, 0.000, 70000.000);
    lrp = lerp(0, zsz, .03);
    //println(spectrum [band]);


    fill(200 + lrp *100, 100+lrp * 125, 155 - lrp *200);
    push();
    //point (xOff, yOff, (lrp * 20) /2);
    translate(xOff + random (20), yOff, (lrp *600)/2);
    box(xsz, ysz, lrp *600);


    pop();
  }
}
