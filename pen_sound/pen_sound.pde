import processing.serial.*;
import cc.arduino.*;
import java.io.*;
import java.util.Random;
import org.firmata.*;
import ddf.minim.*;  //minimライブラリのインポート
Arduino arduino;

Minim minim;  //Minim型変数であるminimの宣言


AudioPlayer players[] = new AudioPlayer[3];
int input = 0;
int light = 100;
int medium = 200;
int playerNum = 0;

String text;
int writeTime;
int time;
int avPress;
int timeScore;
int pressureScore;
int amountScore;
int TotalScore;
int timeLevel;
int pressureLevel;
int amountLevel;
boolean written_point1;
boolean written_point2;
boolean written_point3;
boolean written_point4;
boolean stamp_light;
ArrayList <Integer> framePress;
String[] cmd111 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/111.png"};
String[] cmd112 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/112.png"};
String[] cmd113 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/113.png"};
String[] cmd121 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/121.png"};
String[] cmd122 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/122.png"};
String[] cmd123 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/123.png"};
String[] cmd131 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/131.png"};
String[] cmd132 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/132.png"};
String[] cmd133 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/133.png"};
String[] cmd211 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/211.png"};
String[] cmd212 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/212.png"};
String[] cmd213 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/213.png"};
String[] cmd221 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/221.png"};
String[] cmd222 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/222.png"};
String[] cmd223 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/223.png"};
String[] cmd231 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/231.png"};
String[] cmd232 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/232.png"};
String[] cmd233 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/233.png"};
String[] cmd311 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/311.png"};
String[] cmd312 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/312.png"};
String[] cmd313 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/313.png"};
String[] cmd321 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/321.png"};
String[] cmd322 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/322.png"};
String[] cmd323 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/323.png"};
String[] cmd331 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/331.png"};
String[] cmd332 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/332.png"};
String[] cmd333 = {"lpr", "/Users/Natsumi/Desktop/yojohan/pen_sound/data/333.png"};



boolean printing = true;

int omoi = 0;
int pressThreshold;
int average = 0;

//if value is over threshold, value will be put in arraylist.

int culcAverage(int value, ArrayList <Integer> list, int threshold) {
  int value2 = 1023-value;
  if (value2 >= threshold) {
    list.add(value2);
  }
  for (int i=0; i<list.size(); i++) average +=list.get(i);
  if (list.size() >= 1)average /= list.size();
  return average;
}



void setup() {
  size(300, 300);
  avPress = 0;
  //println(Arduino.list());
  arduino=new Arduino(this, "/dev/cu.usbmodem1411", 57600);
  framePress = new ArrayList<Integer>();

  pressThreshold = 5;

  arduino.pinMode(0, Arduino.INPUT);//CdS
  arduino.pinMode(1, Arduino.INPUT);//pressure
  arduino.pinMode(2, Arduino.INPUT);//pressure
  arduino.pinMode(3, Arduino.INPUT);//pressure
  arduino.pinMode(4, Arduino.INPUT);//pressure
  arduino.pinMode(11, Arduino.OUTPUT);//LED3
  arduino.pinMode(12, Arduino.OUTPUT);//LED2
  arduino.pinMode(13, Arduino.OUTPUT);//LED1


  minim = new Minim(this);
  players[0] = minim.loadFile("poyon.mp3");  
  players[1] = minim.loadFile("bag.mp3");
  players[2] = minim.loadFile("deathstarsnd.mp3");

  arduino.digitalWrite(11, Arduino.LOW); 
  arduino.digitalWrite(12, Arduino.LOW); 
  arduino.digitalWrite(13, Arduino.LOW); 

  stamp_light = false;

  frameRate(1000);
}

boolean myFlg = false;



void draw() {

  background(255);                                                       //time
  if (arduino.analogRead(0)<10) {
    time++;


    //written_point
    if (arduino.analogRead(1)<=1010) {
      written_point1=true;
    }
    if (written_point1==true && arduino.analogRead(2)<=1010) {
      written_point2=true;
    }
    if (written_point2==true && arduino.analogRead(3)<=1010) {
      written_point3=true;
    }
  }

  //timeScore
  timeScore = (int)map(time, 0, 1000000, 0, 99);
  if (time>1000000) {
    timeScore =100;
  }
  //pressureScore

  pressureScore = (int)map(avPress, 0, 200, 0, 99);
  if (avPress>200) {
    pressureScore =100;
  }
  //amountScore

  if (written_point1==true) {
    amountScore =33;
  }
  if (written_point1==true && written_point2==true) {
    amountScore =66;
  }
  if (written_point1==true && written_point2==true && written_point3==true) {
    amountScore =100;
  }

  //timeScore

  TotalScore = timeScore + pressureScore + amountScore;
  omoi = TotalScore;

  //playSound


  //if (arduino.analogRead(5) >= 1000){
  //    myFlg = true;
  //  } else if (arduino.analogRead(5) < 1000 && myFlg == true){
  //    myFlg= false;
  //    println("Check POINT");
  //    if (!players[0].isPlaying()  &&  !players[1].isPlaying()  &&  !players[2].isPlaying())
  //    {
  //    playSound();
  //    reset();
  //    println("reset");
  //    }
  //  }


  if (arduino.analogRead(4) > 980) {                                 //切手置きの照度センサー
    if (TotalScore > 0 && TotalScore < 100 ) {
      arduino.digitalWrite(11, Arduino.HIGH);                       //LED11
    } else if (TotalScore >= 100 && TotalScore < 200 ) {
      arduino.digitalWrite(12, Arduino.HIGH);                      //LED12
    } else if (TotalScore >= 200 ) {
      arduino.digitalWrite(13, Arduino.HIGH);                      //LED13
    }
  } else {
    arduino.digitalWrite(11, Arduino.LOW);       
    arduino.digitalWrite(12, Arduino.LOW);       
    arduino.digitalWrite(13, Arduino.LOW);
  }



  if (arduino.analogRead(4) > 980 && stamp_light == false && TotalScore > 0) {
    stamp_light= true;

    if (timeScore <= 33) {
      timeLevel = 1;
    }
    if (timeScore >33 && timeScore <=66 ) {
      timeLevel = 2;
    }
    if (timeScore >66 && timeScore <=100) {
      timeLevel = 3;
    }
    if (pressureScore <= 33) {
      pressureLevel = 1;
    }
    if (pressureScore >33 && pressureScore <=66 ) {
      pressureLevel = 2;
    }
    if (pressureScore >66 && pressureScore <=100) {
      pressureLevel = 3;
    }
    if (amountScore <= 33) {
      amountLevel = 1;
    }
    if (amountScore >33 && amountScore <=66 ) {
      amountLevel = 2;
    }
    if (amountScore >66 && amountScore <=100) {
      amountLevel = 3;
    }
    println(timeLevel, pressureLevel, amountLevel);

    if (timeLevel == 1 && pressureLevel == 1 && amountLevel == 1) {
      printImage(cmd111);
    }
    if (timeLevel == 1 && pressureLevel == 1 && amountLevel == 2) {
      printImage(cmd112);
    }
    if (timeLevel == 1 && pressureLevel == 1 && amountLevel == 3) {
      printImage(cmd113);
    }
    if (timeLevel == 1 && pressureLevel == 2 && amountLevel == 1) {
      printImage(cmd121);
    }
    if (timeLevel == 1 && pressureLevel == 2 && amountLevel == 2) {
      printImage(cmd122);
    }
    if (timeLevel == 1 && pressureLevel == 2 && amountLevel == 3) {
      printImage(cmd123);
    }
    if (timeLevel == 1 && pressureLevel == 3 && amountLevel == 1) {
      printImage(cmd131);
    }
    if (timeLevel == 1 && pressureLevel == 3 && amountLevel == 2) {
      printImage(cmd132);
    }
    if (timeLevel == 1 && pressureLevel == 3 && amountLevel == 3) {
      printImage(cmd133);
    }
    if (timeLevel == 2 && pressureLevel == 1 && amountLevel == 1) {
      printImage(cmd211);
    }
    if (timeLevel == 2 && pressureLevel == 1 && amountLevel == 2) {
      printImage(cmd212);
    }
    if (timeLevel == 2 && pressureLevel == 1 && amountLevel == 3) {
      printImage(cmd213);
    }
    if (timeLevel == 2 && pressureLevel == 2 && amountLevel == 1) {
      printImage(cmd221);
    }
    if (timeLevel == 2 && pressureLevel == 2 && amountLevel == 2) {
      printImage(cmd222);
    }
    if (timeLevel == 2 && pressureLevel == 2 && amountLevel == 3) {
      printImage(cmd223);
    }
    if (timeLevel == 2 && pressureLevel == 3 && amountLevel == 1) {
      printImage(cmd231);
    }
    if (timeLevel == 2 && pressureLevel == 3 && amountLevel == 2) {
      printImage(cmd232);
    }
    if (timeLevel == 2 && pressureLevel == 3 && amountLevel == 3) {
      printImage(cmd233);
    }
    if (timeLevel == 3 && pressureLevel == 1 && amountLevel == 1) {
      printImage(cmd311);
    }
    if (timeLevel == 3 && pressureLevel == 1 && amountLevel == 2) {
      printImage(cmd312);
    }
    if (timeLevel == 3 && pressureLevel == 1 && amountLevel == 3) {
      printImage(cmd313);
    }
    if (timeLevel == 3 && pressureLevel == 2 && amountLevel == 1) {
      printImage(cmd321);
    }
    if (timeLevel == 3 && pressureLevel == 2 && amountLevel == 2) {
      printImage(cmd322);
    }
    if (timeLevel == 3 && pressureLevel == 2 && amountLevel == 3) {
      printImage(cmd323);
    }
    if (timeLevel == 3 && pressureLevel == 3 && amountLevel == 1) {
      printImage(cmd331);
    }
    if (timeLevel == 3 && pressureLevel == 3 && amountLevel == 2) {
      printImage(cmd332);
    }
    if (timeLevel == 3 && pressureLevel == 3 && amountLevel == 3) {
      printImage(cmd333);
    }
  }



  avPress = culcAverage(arduino.analogRead(1), framePress, pressThreshold);
  avPress = culcAverage(arduino.analogRead(2), framePress, pressThreshold);
  avPress = culcAverage(arduino.analogRead(3), framePress, pressThreshold);




  text = "time: "+str(time) +"\n"+
    "average pressure: "+str(avPress) +"\n"+
    "point1made kaitayo: "+str(written_point1) +"\n"+
    "point2made kaitayo: "+str(written_point2) +"\n"+
    "point3made kaitayo: "+str(written_point3) +"\n"+ "\n"+

    "timeScore: "+str(timeScore) +"\n"+
    "pressureScore: "+str(pressureScore) +"\n"+
    "amountScore: "+str(amountScore) +"\n"+
    "TotalScore: "+str(TotalScore) ;

  fill(0);
  text(text, width/2, height/2);

  println("0 pin: "+arduino.analogRead(0));
  println("1 pin: "+arduino.analogRead(1));
  println("2 pin: "+arduino.analogRead(2));
  println("3 pin: "+arduino.analogRead(3));
  println("4 pin: "+arduino.analogRead(4));
  println("5 pin: "+arduino.analogRead(5));
}

//end of draw


void playSound() {
  if (omoi <= light) {      
    players[0].play();
  } else if (omoi > light && omoi <= medium) {
    players[1].play();
  } else if (omoi > medium) {
    players[2].play();
  }
}


void printImage(String[] messege) {
  if (printing) {
    Process p;
    try {
      p = Runtime.getRuntime().exec(messege);
      p.waitFor();
      p.exitValue();
    } 
    catch (InterruptedException e) {
      e.printStackTrace();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
  printing = false;
}

void reset() {
  stamp_light = false;
  avPress = 0;
  timeScore =0;
  pressureScore =0;
  amountScore =0;
  TotalScore =0;
  omoi = 0;
  average = 0;
  time =0;
  written_point1 = false;
  written_point2 = false;
  written_point3 = false;
  written_point4 = false;
  framePress = new ArrayList<Integer>();
  printing = true;
  players[0].rewind();
  players[1].rewind();
  players[2].rewind();
} 

void keyPressed() {
  if (key == 's' || key == 'S') {
    if (!players[0].isPlaying()  &&  !players[1].isPlaying()  &&  !players[2].isPlaying())
    {
      playSound();
      reset();
    }
  }
}