import processing.sound.*;
int d = 2;

int band = 4096;
int unit = d + 10;
int count;
Module [] modA;
float[]spectrum  = new float [band];
AudioIn in;
FFT fft;
float bd = band;

void setup() {
  //background(255, 129, 22);
  size(1100, 1100, P3D);




  fft = new FFT(this, band);
  in = new AudioIn (this, 0);
  in.start();

  fft.input(in);


  int wideCount = 64;
  int highCount = 64;
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
  //fill (255, 129, 22, 2);
  
  //rect (0, 0, width, height);
  camera (70.0, 35.0, 120.0, -120.0 , 150.0, 0.0, 0.0, 1.0, 0.0);


  // Turn on the lights.
  ambientLight(228, 255, 255);
  //directionalLight(128, 128, 128, 0, 0, -1);

  for (int i = 0; i < count; i++) {

    push();
    translate(-600, -90, -400);

    modA[i].updateDraw();
    pop();
  }
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
    strokeWeight(.2);
   stroke (255, 129, 22);
    // stroke (255);
    ortho();


    fft.analyze(spectrum);

  

      zsz = map (spectrum [band], 0.000, 100.000, 0.000, 100000.000);
      lrp = lerp(0, zsz, .3);
      println(spectrum [band]);


      fill(155 + lrp *200, lrp * 125, 255 - lrp *100);
      push();
      //point (xOff, yOff, (lrp * 20) /2);
      translate(xOff+ random (50), yOff, (lrp *200)/2);
      box(xsz, ysz, lrp *200);


      pop();
    
  }
}
