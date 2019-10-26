#include "WiFi.h"
#include "aREST.h"
/*// ledPin refers to ESP32 GPIO 23
const int ledPin = 23;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin ledPin as an output.
  pinMode(ledPin, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(ledPin, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(1000);                  // wait for a second
  digitalWrite(ledPin, LOW);    // turn the LED off by making the voltage LOW
  delay(1000);                  // wait for a second
}*/

#include "WiFi.h"
#include "aREST.h"
 
aREST rest = aREST();
 
WiFiServer server(80);
 
const char* ssid = "Rajan";
const char* password =  "TinyTofu";
 
int testFunction(String command) {
  Serial.println("Received rest request");
}
 
void setup()
{
 
  Serial.begin(115200);
 
  rest.function("test",testFunction);
 
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 
  Serial.println("WiFi connected with IP: ");
  Serial.println(WiFi.localIP());
 
  server.begin();
 
}
 
void loop() {
 
  WiFiClient client = server.available();
  if (client) {
 
    while(!client.available()){
      delay(5);
    }
    rest.handle(client);
  }
}
