// fAECade processing simulator

import controlP5.*;


String IpAddr    ="192.168.123.123";
String IpAddrnew ="192.168.123.123";

static int SCALE        = 5;
static int PANEL_WIDTH  = 2 * SCALE;
static int PANEL_HEIGHT = 1 * SCALE;

FrameBuffer buffer;
Panel panels[];

ControlP5 controlP5;
Textfield myTextfield;


// Handle IP Address changes
void controlEvent(ControlEvent theEvent) {
  IpAddrnew = theEvent.controller().stringValue();
  println("ipadress change :'"+ IpAddrnew);
}


class FrameBuffer {

  private final int packageSize =    5;
  private final int nrAddresses = 1085;
  private final int offsetRed   =    2;
  private final int offsetGreen =    3;
  private final int offsetBlue  =    4;
  
  private byte[] frameBuffer    = new byte[packageSize * nrAddresses];

  FrameBuffer() {
    for (int address = 0; address < nrAddresses; address++) {
      frameBuffer[ address * packageSize + 0           ] = (byte) (address % 256);
      frameBuffer[ address * packageSize + 1           ] = (byte) (address / 256);
      frameBuffer[ address * packageSize + offsetRed   ] = 120;
      frameBuffer[ address * packageSize + offsetGreen ] = 120;
      frameBuffer[ address * packageSize + offsetBlue  ] =   0;
    }
  }

  // set all packages to the same color
  void setColor(color ColorAux) {
    for (int address = 0; address < nrAddresses; address++) {
      frameBuffer[ address * packageSize + offsetRed   ] = byte(ColorAux >> 16 & 0xFF);  //byte(red(ColorAux));
      frameBuffer[ address * packageSize + offsetGreen ] = byte(ColorAux >> 8  & 0xFF);
      frameBuffer[ address * packageSize + offsetBlue  ] = byte(ColorAux >> 0  & 0xFF);			
    }
  }

  // set package at address to color
  void setColor(int address, color ColorAux) {
    if (address >= 0 && address < nrAddresses) {
      frameBuffer[ address * packageSize + offsetRed   ] = byte(red(ColorAux));
      frameBuffer[ address * packageSize + offsetGreen ] = byte(green(ColorAux));
      frameBuffer[ address * packageSize + offsetBlue  ] = byte(blue(ColorAux));					
    }
  }


  //  send the complete UDP packet to localhost:8080 (might be necessary to change)
  void flush() {
    try {
      DatagramPacket packet = new DatagramPacket(frameBuffer, frameBuffer.length, InetAddress.getByName(IpAddr), 8080); //104
      DatagramSocket socket = new DatagramSocket();
      socket.send(packet);
    }
    catch (Exception e) {
    System.out.println("Exception when sending framebuffer: " + e.getMessage());
    }
  }
}

class Panel {

  int c, x, y;

  Panel(int _x, int _y, int _c) {
    x = _x;
    y = _y;
    c = _c;
  }

  void render() {
    noFill();
    stroke(c);
    point(x, y);
  }

}

void setup() {

  size(PANEL_WIDTH * 82, PANEL_HEIGHT * 30, JAVA2D);
  smooth();
  
  controlP5 = new ControlP5(this);
  myTextfield = controlP5.addTextfield("    Serva IP",500,0,100,20);
  myTextfield.setFocus(false);
  myTextfield.setText(IpAddr);
  myTextfield.setAutoClear(false); 
  
  buffer = new FrameBuffer();

  // Initialize Panels
  panels = new Panel[1085];

  int id = 0;

  // Main Building North
  for(int i = 3; id <= 119; i++) {
    if(id == 116) { 
      i++; 
    }
    panels[id++] = new Panel(PANEL_WIDTH * (11 + (i % 5)), PANEL_HEIGHT * (2 + (i / 5)), color(255, 0, 0));
  }

  // Main Building East
  for(int i = 8; id <= 349; i++) {
    if(id == 339 || id == 348) { 
      i++; 
    }
    panels[id++] = new Panel(PANEL_WIDTH * (1 + (i % 10)), PANEL_HEIGHT * (2 + (i / 10)), color(255, 255, 0));
  }

  // Main Building South
  for(int i = 0; id <= 546; i++) {
    if(id == 354 || id == 540) { 
      i += 6; 
    } 
    else if(id == 528 || id == 536) { 
      i += 2; 
    } 
    else if(id == 544) { 
      i += 7; 
    }
    panels[id++] = new Panel(PANEL_WIDTH * (26 + (i % 10)), PANEL_HEIGHT * (2 + (i / 10)), color(255, 255, 255));
  }

  // Main Building South Street Level
  for(int i = 0; id <= 632; i++) {
    if(id == 558) { 
      i += 16; 
    } 
    else if(id == 562 || id == 578 || id == 600 || id == 624) { 
      i += 3; 
    } 
    else if(id == 574) { 
      i += 8; 
    } 
    else if(id == 578) { 
      i += 3; 
    } 
    else if(id == 596) { 
      i += 2; 
    }
    panels[id++] = new Panel(PANEL_WIDTH * (25 + (i % 27)), PANEL_HEIGHT * (24 + (i / 27)), color(0, 255, 0));
  }

  // Main Building West
  for(int i = 0; id <= 841; i++) {
    if(id == 639) { 
      i += 4; 
    }
    panels[id++] = new Panel(PANEL_WIDTH * (16 + (i % 10)), PANEL_HEIGHT * (2 + (i / 10)), color(0, 255, 255));
  }

  // Futurelab North
  for(int i = 0; id <= 911; i++) {
    if(id == 848) { 
      i += 7; 
    } 
    else if(id == 855) { 
      i += 6; 
    } 
    else if(id == 857 || id == 864 || id == 901) { 
      i++; 
    } 
    else if(id == 862) { 
      i += 5; 
    } 
    else if(id == 870) { 
      i += 4; 
    } 
    else if(id == 880) { 
      i += 3; 
    } 
    else if(id == 891 || id == 894 || id == 904) { 
      i += 2; 
    }
    panels[id++] = new Panel(PANEL_WIDTH * (68 + (i % 13)), PANEL_HEIGHT * (17 + (i / 13)), color(0, 0, 255));
  }

  // Futurelab East
  for(int i = 0; id <= 957; i++) {
    panels[id++] = new Panel(PANEL_WIDTH * (63 + (i % 5)), PANEL_HEIGHT * (17 + (i / 5)), color(255, 0, 255));
  } 

  // Futurelab South
  for(int i = 0; id <= 1084; i++) {
    if(id == 966) { 
      i += 15; 
    } 
    else if(id == 975 || id == 984) { 
      i += 14; 
    } 
    else if(id == 994) { 
      i += 13; 
    } 
    else if(id == 1005) { 
      i += 12; 
    } 
    else if(id == 1017) { 
      i += 11; 
    } 
    else if(id == 1030) { 
      i += 10; 
    } 
    else if(id == 1072) { 
      i += 4; 
    }
    panels[id++ ] = new Panel(PANEL_WIDTH * (39 + (23 - (i % 23))), PANEL_HEIGHT * (17 + (i / 23)), color(255, 128, 0));
  }

}

void drawflats() {

  //zur stiege
  rect(10,10,90,130);
  //fill(13,190,50);
  rect(100,10,55,130);

  //straßenseite
  //fill(230,30,50);
  rect(155,10,100,105);

  //eingang
  //fill(230,30,150);
  rect(255,10,100,105);

  //donauseite unten
  //fill(120,130,150);
  rect(245,120,110,20);
  //donauseite unten 2
  rect(355,123,80,20);
  //donauseite unten 3
  rect(435,128,60,10);
  //donauseite unten 4
  rect(495,133,20,5);

  //future lab donauseite
  //fill(122,255,122);
  rect(400,118,35,5);
  //future lab donauseite 2
  rect(435,118,60,10);
  //future lab donauseite 3
  rect(495,80,130,60);

  //future lab hinten
  //fill(70,50,200);
  rect(625,80,50,55);

  //future lab eingang
  //fill(200,90,50);
  rect(675,80,130,50); 
}

void draw() {
  
  background(0);

  drawflats();

  // Scan panels
  loadPixels();

  // Render output
  for(int p = 0; p < panels.length; p++) {
    panels[p].render();
  }

}


void setPanel(int address, char r, char g, char b) {

  fill(255,0,0);
  stroke(255,0,0);

}
