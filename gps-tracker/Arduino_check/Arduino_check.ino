#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <MAX30105.h>

// Define I2C pins for sensors
#define SDA_PIN_MAX30102 21
#define SCL_PIN_MAX30102 22
#define SDA_PIN_MPU6050 25
#define SCL_PIN_MPU6050 26

// Define A9G Serial Pins (Modify if needed)
#define A9G_TX 17  // ESP32 RX (A9G TX)
#define A9G_RX 16  // ESP32 TX (A9G RX)

TwoWire I2C_MAX = TwoWire(0);  // First I2C bus for MAX30102
TwoWire I2C_MPU = TwoWire(1);  // Second I2C bus for MPU6050

MAX30105 particleSensor;
Adafruit_MPU6050 mpu6050;

// GPS Variables
String latitude = "N/A";
String longitude = "N/A";

void setup() {
  Serial.begin(115200);  // Serial Monitor
  delay(3000);
  
  Serial.println("============= SETUP STARTING =============");

  // Initialize MAX30102
  Serial.println("Initializing MAX30102 I2C bus...");
  I2C_MAX.begin(SDA_PIN_MAX30102, SCL_PIN_MAX30102);
  delay(100);
  
  Serial.println("Initializing MAX30102 sensor...");
  if (!particleSensor.begin(I2C_MAX)) {
    Serial.println("ERROR: MAX30102 NOT FOUND!");
  } else {
    Serial.println("SUCCESS: MAX30102 Detected!");
    particleSensor.setup();
  }

  // Initialize MPU6050
  Serial.println("Initializing MPU6050 I2C bus...");
  I2C_MPU.begin(SDA_PIN_MPU6050, SCL_PIN_MPU6050);
  delay(100);
  
  Serial.println("Initializing MPU6050 sensor...");
  if (!mpu6050.begin(0x68, &I2C_MPU)) {
    Serial.println("ERROR: MPU6050 NOT FOUND!");
  } else {
    Serial.println("SUCCESS: MPU6050 Found at 0x68!");
  }
  
  // MPU6050 Configuration
  mpu6050.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu6050.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu6050.setFilterBandwidth(MPU6050_BAND_21_HZ);
  
  Serial.println("MPU6050 Configuration Complete");

  // Initialize A9G GPS
  Serial2.begin(115200, SERIAL_8N1, A9G_RX, A9G_TX);
  delay(1000);
  Serial.println("A9G Module Initialized!");

  Serial.println("============= SETUP COMPLETE =============");
}

void loop() {
  static unsigned long lastPrint = 0;
  if (millis() - lastPrint > 5000) {
    Serial.println("Loop is running...");
    lastPrint = millis();
  }

  // Read MAX30102
  Serial.println("Reading MAX30102...");
  long irValue = particleSensor.getIR();
  long redValue = particleSensor.getRed();

  // Read MPU6050
  Serial.println("Reading MPU6050...");
  sensors_event_t a, g, temp;
  if (!mpu6050.getEvent(&a, &g, &temp)) {
    Serial.println("Error reading from MPU6050");
  }

  // Read GPS Data
  getGPSData();

  // Print Data
  Serial.println("-----------------------------");
  Serial.print("Heart Rate Sensor - IR: ");
  Serial.print(irValue);
  Serial.print("\tRed: ");
  Serial.println(redValue);
  
  Serial.print("Motion Sensor - Acc: (");
  Serial.print(a.acceleration.x);
  Serial.print(", ");
  Serial.print(a.acceleration.y);
  Serial.print(", ");
  Serial.print(a.acceleration.z);
  Serial.println(")");

  Serial.print("GPS Location - Latitude: ");
  Serial.print(latitude);
  Serial.print("\tLongitude: ");
  Serial.println(longitude);

  Serial.println("-----------------------------");

  delay(2000);
}

// Function to Read GPS Data
void getGPSData() {
  while (Serial2.available()) {
    String gpsData = Serial2.readStringUntil('\n');
    Serial.println("GPS Raw Data: " + gpsData); // Debugging

    if (gpsData.startsWith("+LOCATION:")) {
      int firstComma = gpsData.indexOf(',');
      int secondComma = gpsData.indexOf(',', firstComma + 1);

      if (firstComma != -1 && secondComma != -1) {
        latitude = gpsData.substring(firstComma + 1, secondComma);
        longitude = gpsData.substring(secondComma + 1);

        if (latitude.toFloat() == 0 || longitude.toFloat() == 0) {
          Serial.println("GPS ERROR: No valid fix");
        } else {
          Serial.println("GPS Data Updated: Lat = " + latitude + ", Lon = " + longitude);
        }
      } else {
        Serial.println("GPS ERROR: Malformed data");
      }
    }
  }
}


