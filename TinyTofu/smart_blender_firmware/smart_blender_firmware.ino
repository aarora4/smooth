//Tiny Tofu Smart Blender
//HackGT 2019

#include "WiFi.h"
#include "aREST.h"
#include "HTTPClient.h"

//Use mobile hotspot
const char* ssid = "Rajan";
const char* password =  "TinyTofu";

//Create blender client to talk to backend
HTTPClient talker;

//Create blender server to listen to backend
aREST rest = aREST();
WiFiServer listener(80);

//variables 
float current_weight = 0.0;
char[] ingredient = "";

//expose variables to REST API
rest.variable("current_weight",&current_weight);
rest.variable("ingredient", &ingredient);

void setup() {
  Serial.begin(115200);

  //connect to wifi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  
 Serial.println("connected");

  
}

void loop() {
  //connect to backend
  
  

}
