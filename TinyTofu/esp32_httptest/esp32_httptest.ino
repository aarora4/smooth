//WiFiServer server(80);
#include <SPI.h>
#include <WiFi.h>
#include "HTTPClient.h"
const char* ssid = "Rajan";
const char* password =  "TinyTofu";
char server[] = "www.google.com";
WiFiClient client;
int testFunction(String command) {
  Serial.println("Received rest request");
}
 
void setup()
{
 
  Serial.begin(115200);
 
//  rest.function("test",testFunction);
 
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 Serial.println("connected");

}
 
void loop() {
 /*
  WiFiClient client = server.available();
  if (client) {
 
    while(!client.available()){
      delay(5);
    }
    rest.handle(client);
  }*/
    HTTPClient http;   
    http.begin("http://jsonplaceholder.typicode.com/posts/1");
   http.addHeader("Content-Type", "text/plain");            
 
   int httpResponseCode = http.PUT("PUT sent from ESP32");   
 
   if(httpResponseCode > 0){
 
    String response = http.getString();   
 
    Serial.println(httpResponseCode);
    Serial.println(response);          
 
   }else{
 
    Serial.print("Error on sending PUT Request: ");
    Serial.println(httpResponseCode);
 
   }
 
   http.end();
 
   delay(1000);
}
