#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <Wire.h>
#include <PN532_I2C.h>
#include <PN532.h>
#include <NfcAdapter.h>
#include <string.h>;
#include <ESP32Servo.h>
#include <NewPing.h>
// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

//#define LED_PIN 13
//#define BTN_PIN 12

//設定耳朵腳位
Servo servoMotor;
Servo servoMotor2;
const int servoPin = 4;

//button
int buttonright= 13;
bool numbergame = false;

//NFC reader設定

PN532_I2C pn532i2c(Wire);
PN532 nfc(pn532i2c);
bool nfcgame = false;


BLECharacteristic *pCharacteristic;
BLEServer *pServer;

int deviceConnected = false;

class MyCallbacks: public BLECharacteristicCallbacks {
   void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("device connected");
    };
 
    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("device disconnected");
    }
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string value = pCharacteristic->getValue();
      
      if (value.length() > 0) {
        //接收訊息及控制馬達
        Serial.println(value.c_str());
        if(atoi(value.c_str())==2)
        {
          Serial.println("設成高角位");
          servoMotor.attach(4);
          servoMotor2.attach(14);
          for (int angle = 0; angle <= 180; angle++) {
            servoMotor.write(angle);
            servoMotor2.write(angle);
            delay(5);  // 延遲一點時間，讓伺服馬達有足夠時間轉動
          }
          
          delay(500);  // 停留1秒
          
          // 將伺服馬達從180度轉回0度
          for (int angle = 180; angle >= 0; angle--) {
            servoMotor.write(angle);
            servoMotor2.write(angle);
            delay(5);  // 延遲一點時間，讓伺服馬達有足夠時間轉動
          }
          servoMotor.detach();
          servoMotor2.detach();
        }
        else if(atoi(value.c_str())==3)
        {
          numbergame = true;
        }
        else if(atoi(value.c_str())==4)
        {
          nfcgame = true;
        }
        else if(atoi(value.c_str())==5)
        {
          nfcgame = false;
          numbergame = false;
        }


  }
}
};

void setup() {
  Serial.begin(115200);
  //pinMode(LED_PIN,OUTPUT);
  //digitalWrite(LED_PIN,LOW);
  Serial.println("1- Download and install an BLE scanner app in your phone");
  Serial.println("2- Scan for BLE devices in the app");
  Serial.println("3- Connect to MyESP32");
  Serial.println("4- Go to CUSTOM CHARACTERISTIC in CUSTOM SERVICE and write something");
  Serial.println("5- See the magic =)");

  //耳朵  
  servoMotor.attach(4);
  servoMotor2.attach(14);
  //pinMode(servoPin,OUTPUT);
  servoMotor.write(0);
  servoMotor2.write(0);
  //delay(1000);
  servoMotor.detach();
  servoMotor2.detach();

  //button
  pinMode(buttonright, INPUT);
  
  //nfc
  nfc.begin();
   uint32_t versiondata = nfc.getFirmwareVersion();
  if (! versiondata) {
    Serial.print("Didn't find PN53x board");
    while (1); // halt
  }
  
  // Got ok data, print it out!
  Serial.print("Found chip PN5"); Serial.println((versiondata>>24) & 0xFF, HEX); 
  Serial.print("Firmware ver. "); Serial.print((versiondata>>16) & 0xFF, DEC); 
  Serial.print('.'); Serial.println((versiondata>>8) & 0xFF, DEC);
  
  // Set the max number of retry attempts to read from a card
  // This prevents us from waiting forever for a card, which is
  // the default behaviour of the PN532.
  nfc.setPassiveActivationRetries(0xFF);
  
  // configure board to read RFID tags
  nfc.SAMConfig();
    
  Serial.println("Waiting for an ISO14443A card");



  
  BLEDevice::init("BLE_DEVICE");
  pServer = BLEDevice::createServer();

  BLEService *pService = pServer->createService(SERVICE_UUID);

  pCharacteristic= pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_WRITE |
                                         BLECharacteristic::PROPERTY_NOTIFY
                                       );

  pCharacteristic->setCallbacks(new MyCallbacks());

  pCharacteristic->setValue("Hello World");
  pService->start();

  BLEAdvertising *pAdvertising = pServer->getAdvertising();
  pAdvertising->start();
}



int prevVal = LOW;
int buttonState = HIGH;
int lastbuttonState = HIGH;

void loop() {
  //buttonState = digitalRead(buttonPin);
  //Serial.println(buttonState);
  // put your main code here, to run repeatedly:
  //int currentVal = digitalRead(BTN_PIN);
  boolean success;
  uint8_t uid[] = { 0, 0, 0, 0, 0, 0, 0 };  // Buffer to store the returned UID
  uint8_t uidLength;    
  if(touchRead(T1)>0)
  {
    servoMotor.attach(4);
    servoMotor2.attach(14);
    //first ear
    for (int angle = 0; angle <= 180; angle++) {
      servoMotor.write(angle);
      
      delay(5);  // 延遲一點時間，讓伺服馬達有足夠時間轉動
    }
    
    delay(500);  // 停留1秒
    
    // 將伺服馬達從180度轉回0度 first ear
    for (int angle = 180; angle >= 0; angle--) {
      servoMotor.write(angle);
     
      delay(5);  // 延遲一點時間，讓伺服馬達有足夠時間轉動
    }
    //second ear
    for (int angle = 0; angle <= 180; angle++) {
      
      servoMotor2.write(angle);
      delay(5);  // 延遲一點時間，讓伺服馬達有足夠時間轉動
    }
    
    delay(500);  // 停留1秒
    for (int angle = 180; angle >= 0; angle--) {
      
      servoMotor2.write(angle);
      delay(5);  // 延遲一點時間，讓伺服馬達有足夠時間轉動
    }
    servoMotor.detach();
    servoMotor2.detach();
  }
  
  // print out the state of the button:
  
  //Serial.print("numbergame:");
  //Serial.println(numbergame);
  //Serial.print("nfcgame: ");
  //Serial.println(nfcgame);
  if(numbergame == true)
  {
    buttonState = digitalRead(buttonright);
    Serial.println(buttonState);
    if(buttonState == LOW && lastbuttonState == HIGH)
    {
      int value = 1;
      Serial.println(1);
      pCharacteristic->setValue(value);
      pCharacteristic->notify();
      pServer->disconnect(pServer->getConnectedCount());
      BLEAdvertising *pAdvertising = pServer->getAdvertising();
      pAdvertising->start();
      
    }
    lastbuttonState = buttonState;
  }
  else if(nfcgame == true)//nfcgame變false之後,還是會等一陣子
  {
    success = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, &uid[0], &uidLength);//他會等一下確認有無讀到
    if (success) {
      Serial.println("Found a card!");
      Serial.print("UID Length: ");Serial.print(uidLength, DEC);Serial.println(" bytes");
      Serial.print("UID Value: ");
      for (uint8_t i=0; i < uidLength; i++) 
      {
        Serial.print(" 0x");Serial.print(uid[i], HEX); 
        pCharacteristic->setValue((uint8_t*)&uid[i], 4);
        pCharacteristic->notify();
      }
      
      pServer->disconnect(pServer->getConnectedCount());
      BLEAdvertising *pAdvertising = pServer->getAdvertising();
      pAdvertising->start();
      
      //pCharacteristic->setValue((uint8_t*)&uid[], 4);
      Serial.println("");
      // Wait 1 second before continuing
      //delay(1000);
    }
  
  }
  
                      // Length of the UID (4 or 7 bytes depending on ISO14443A card type)
  
  // Wait for an ISO14443A type cards (Mifare, etc.).  When one is found
  // 'uid' will be populated with the UID, and uidLength will indicate
  // if the uid is 4 bytes (Mifare Classic) or 7 bytes (Mifare Ultralight)
 
 
  /*
  else
  {
    // PN532 probably timed out waiting for a card
    //Serial.println("Timed out waiting for a card");
    

  }*/
  
}
