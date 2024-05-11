import processing.sound.*;
int d = 5;

int band = 64;
int unit = d+10;
int count;
Module [] modA;
float[]spectrum  = new float [band];
AudioIn in;
FFT fft;
float bd = band;

void setup() {
  size(800, 800, P3D);
  



  fft = new FFT(this, band);
  in = new AudioIn (this, 0);
  in.start();

  fft.input(in);


  int wideCount = 8;
  int highCount = 8;
  count = wideCount * highCount;

  modA = new Module [count];

  int index = 0;
  for (int y = 0; y < highCount; y++) {
    for (int x = 0; x < wideCount; x++) {
      modA[index++] = new Module(unit * x, unit * y, d, d, unit, x * y);
    }
  }
}

void draw() {
  background(255, 129, 22);


  // Turn on the lights.
  ambientLight(228, 255, 255);
  directionalLight(128, 128, 128, 0, 0, -1);

  for (int i = 0; i < count; i++) {
   modA[i].updateDraw();
  }

  //for (Module mod : modA) {
  //  mod.updateDraw();
  //}
}

void keyTyped() {
  if (keyPressed == true || keyPressed == true) {
    save("3d-grid-box.png");
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
    noStroke();
    ortho(-width/3, width/2, -height/2, height/2);


    fft.analyze(spectrum);

    for (int i = 0; i < spectrum.length; i++) {
      zsz = map (spectrum [i], 0, 12, 0, 50000);
      lrp = lerp(0, zsz, .5);
      
      println (spectrum [i]);


      push();
      translate(width/2, height/2, 0);
      rotateX(-PI/6);
      rotateY(PI/3);

      push();
      fill(155 + lrp, 0, 255 - lrp);
      translate(xOff, yOff, lrp / 2);
      box(xsz, ysz, lrp);
      pop();
      pop();
    }
  }
}
