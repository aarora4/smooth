#include <ArduinoJson.h>

//Tiny Tofu Smart Blender
//HackGT 2019

#include "WiFi.h"
#include "aREST.h"
#include "HTTPClient.h"
#include <LiquidCrystal.h> // includes the LiquidCrystal Library 
LiquidCrystal lcd(22, 4, 16, 15, 2, 0); // Creates an LC object. Parameters: (rs, enable, d4, d5, d6, d7) 

// pins
int buttonPin = 12;
int lcdPowerPin = 17;
int weightPin = 34;

//Use mobile hotspot
const char* ssid = "Rajan";
const char* password =  "TinyTofu";

const char* backend_prefix = "https://DelishAppNCR.pythonanywhere.com";

//Create blender client to talk to backend
HTTPClient talker;

//Create blender server to listen to backend
aREST rest = aREST();
WiFiServer listener(80);

//variables 
volatile float current_weight = 0.0;
volatile int buttonStatus = 0;
String ingredient = "";
volatile int lcdState = LOW;
volatile int blenderStatus = 0;
volatile float total_weight = 0.0;
unsigned long start_time;

//expose variables to REST API
//rest.variable("current_weight",&current_weight);
//rest.variable("ingredient", &ingredient);

//define rest functions

//wakeUp: backend tells blender to wake up
int wakeUp(String command) {
  Serial.println("woken up by back-end");
  lcdState = HIGH;
  lcd.clear();
  lcd.print("Your app woke me up!");
  delay(1000);
  
}
int goSleep(String command) {
  Serial.println("told to sleep");
  lcdState = LOW;
}
char str3[100];
//newIngredient: backend tells blender to display new ingredient
 int newIngredient(String command) {
  Serial.println("getting new ingredient");
  sprintf(str3, "%s/active/getCurrentItem", backend_prefix);
     talker.begin(str3);
     //talker.addHeader("Content-Type", "text/plain"); 
     int httpResponseCode = talker.GET(); 

      if(httpResponseCode > 0){ //print backend's response (new ingredient)
 
       ingredient = talker.getString();    
       Serial.println(httpResponseCode);
       Serial.println(ingredient);          
 
    } else{  
      Serial.print("Error on sending PUT Request: ");
      Serial.println(httpResponseCode);
   }
   talker.end();
   delay(100);
  //Serial.print(ingredient);
 }

void setup() {
  Serial.begin(115200);
  randomSeed(analogRead(13));
  // Initializes the interface to the LCD screen
  lcd.begin(16,2); 
  
  //Set up pins
  pinMode(buttonPin, INPUT);
  pinMode(lcdPowerPin, OUTPUT);
  pinMode(weightPin, INPUT);
  attachInterrupt(digitalPinToInterrupt(buttonPin), onOff, CHANGE);

  //set up rest functions
  rest.function("wakeUp", wakeUp);
  rest.function("goSleep",goSleep);
  rest.function("newIngredient", newIngredient);
  
  //connect to wifi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  //initialize LCD
  digitalWrite(lcdPowerPin, lcdState);
  
 Serial.println("connected");
 Serial.println("WiFi connected with IP: ");
 Serial.println(WiFi.localIP());
 
  listener.begin();
}

char str[100];
char str2[100];
int weightResponseCode;


void loop() {
  
  //if button pushed, initialize backend: POST /inactive/initialize, also turn on LCD
  //print READY to LCD when alexa confirms

  if(buttonStatus) { //if button pushed
    if(lcdState==1) { //if button turned on blender
     Serial.println("turning on");
     //lcd.print("Tiny Tofu Smart Blender");
     sprintf(str, "%s/inactive/initialize/scale", backend_prefix);
     talker.begin(str);
     //talker.addHeader("Content-Type", "text/plain"); 
     int httpResponseCode = talker.POST("0"); //fix this to actual current weight
     //delay(1000); //delay to show text
      if(httpResponseCode > 0){ //print backend's response, if any
       lcd.clear();
       lcd.print("Ready to make");
       lcd.setCursor(2,1);
       lcd.print("smoothie!!");
       String response = talker.getString();    
       Serial.println(httpResponseCode);
       Serial.println(response);          
 
    } else{  
      Serial.print("Error on sending PUT Request: ");
      Serial.println(httpResponseCode);
   }
   talker.end();
   delay(1000);
}
   
   else { //if button turned off blender
       Serial.println("turning off");
       lcd.clear();
       lcd.print("turning off");
       delay(1000);
       lcdState = LOW;
    }
  buttonStatus = 0;
  }
  
  digitalWrite(lcdPowerPin,lcdState);
  delay(500);
  //if alexa calls wake_up (rest.function("wakeUp", wakeupFunction), turn on LCD and say READY
  //if alexa calls new_ingredient, print ingredient to LCD
  WiFiClient client = listener.available();
    if (client) {
    while(!client.available()){
      delay(5);
    }
    rest.handle(client);
  }
  //zero scale ^
  if(current_weight < 25 && ingredient != "service not available" && ingredient != "Nothing Yet" && millis()-start_time > 1000 ) {
    float rnumber = random(3);
    current_weight += rnumber;
    total_weight += rnumber;
  }
  //every .5 sec, POST /active/receiveWeight in json form {"weight":value}
  //current_weight = digitalRead(weightPin);
  if(lcdState) {
  sprintf(str2, "%s/active/receiveWeight", backend_prefix);
  talker.begin(str2);
  //StaticJsonBuffer<200> jsonBuffer;
  //JsonObject& root = jsonBuffer.createObject();
  //root["weight"] = current_weight;
  int weightResponseCode = talker.POST((String)total_weight);
  if(weightResponseCode > 0){ //print backend's response, if any
       lcd.clear();
       String response = talker.getString();    
       Serial.println(weightResponseCode);
       Serial.println(response);
       if(response == "done") {
        //total_weight += current_weight;
        current_weight = 0.0;
        ingredient = "";
        lcd.clear();
        lcd.setCursor(1,0);
        lcd.print("Delicious!");
        lcd.setCursor(2,1);
        delay(1000);
        lcd.print("Total mass:" + (String)total_weight + " g");
        delay(3000);
        lcdState = LOW;
       }
       if(ingredient != response) {
        //total_weight += current_weight;
        current_weight = 0.0;
        ingredient = response;
        start_time = millis();
        
       }
       lcd.print(ingredient);
       lcd.setCursor(2,1);
       lcd.print(current_weight);       
 
    } else{  
      Serial.print("Error on sending PUT Request: ");
      Serial.println(weightResponseCode);
   }
   talker.end();
  //if weight changes before first ingredient, POST something to request ingredient from alexa
  }


  
  

}

void onOff() {

  if(digitalRead(buttonPin) == 1) {
    lcdState = !lcdState;
    buttonStatus = 1;
  }
}
