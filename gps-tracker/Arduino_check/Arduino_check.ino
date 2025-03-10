#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <MAX30105.h>

// Define I2C pins
#define SDA_PIN_MAX30102 21
#define SCL_PIN_MAX30102 22
#define SDA_PIN_MPU6050 25
#define SCL_PIN_MPU6050 26

TwoWire I2C_MAX = TwoWire(0); // First I2C bus for MAX30102
TwoWire I2C_MPU = TwoWire(1); // Second I2C bus for MPU6050

MAX30105 particleSensor;
Adafruit_MPU6050 mpu6050;

// Step counter variables
long lastStepTime = 0;
int stepCount = 0;
float accThreshold = 1.2;
float prevAccMagnitude = 0;
bool stepDetected = false;

void setup() {
  Serial.begin(115200);
  delay(3000); // Give time for serial monitor to open
  Serial.println("\n\n");
  Serial.println("============= SETUP STARTING =============");
  
  // Initialize MAX30102 on first I2C bus
  Serial.println("Initializing MAX30102 I2C bus...");
  I2C_MAX.begin(SDA_PIN_MAX30102, SCL_PIN_MAX30102);
  delay(100);
  
  Serial.println("Initializing MAX30102 sensor...");
  if (!particleSensor.begin(I2C_MAX)) {
    Serial.println("ERROR: MAX30102 NOT FOUND! Check wiring.");
  } else {
    Serial.println("SUCCESS: MAX30102 Detected!");
    particleSensor.setup();
    Serial.println("MAX30102 configured");
  }
  
  // Initialize MPU6050 on second I2C bus
  Serial.println("Initializing MPU6050 I2C bus...");
  I2C_MPU.begin(SDA_PIN_MPU6050, SCL_PIN_MPU6050);
  delay(100);
  
  Serial.println("Initializing MPU6050 sensor...");
  if (!mpu6050.begin(0x68, &I2C_MPU)) {
    Serial.println("ERROR: MPU6050 NOT FOUND! Check wiring or address.");
    // Try alternative address
    Serial.println("Trying alternative address 0x69...");
    if (!mpu6050.begin(0x69, &I2C_MPU)) {
      Serial.println("ERROR: MPU6050 still not found!");
    } else {
      Serial.println("SUCCESS: MPU6050 found at address 0x69!");
    }
  } else {
    Serial.println("SUCCESS: MPU6050 found at address 0x68!");
  }
  
  // Configure MPU6050
  mpu6050.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu6050.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu6050.setFilterBandwidth(MPU6050_BAND_21_HZ);
  Serial.println("MPU6050 configuration complete");
  
  Serial.println("============= SETUP COMPLETE =============");
  Serial.println("If you don't see any output below, there might be an issue in the loop()");
}

void loop() {
  // Indicator that loop is running
  static unsigned long lastPrint = 0;
  if (millis() - lastPrint > 5000) {
    Serial.println("Loop is running...");
    lastPrint = millis();
  }
  
  // MAX30102 reading
  long irValue = 0;
  long redValue = 0;
  
  Serial.println("Reading MAX30102...");
  irValue = particleSensor.getIR();
  redValue = particleSensor.getRed();
  
  // MPU6050 reading
  Serial.println("Reading MPU6050...");
  sensors_event_t a, g, temp;
  if (!mpu6050.getEvent(&a, &g, &temp)) {
    Serial.println("Error reading from MPU6050");
  }
  
  // Calculate acceleration magnitude
  float accMagnitude = sqrt(a.acceleration.x*a.acceleration.x + 
                          a.acceleration.y*a.acceleration.y + 
                          a.acceleration.z*a.acceleration.z);
  
  // Simple step detection algorithm
  if (!stepDetected && accMagnitude > accThreshold &&
      (accMagnitude - prevAccMagnitude) > 0.3 && 
      millis() - lastStepTime > 300) {
    stepCount++;
    lastStepTime = millis();
    stepDetected = true;
  }
  
  if (stepDetected && accMagnitude < accThreshold - 0.2) {
    stepDetected = false;
  }
  
  prevAccMagnitude = accMagnitude;
  
  // Print sensor data to serial monitor
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
  Serial.print(") Magnitude: ");
  Serial.println(accMagnitude);
  
  Serial.print("Step Count: ");
  Serial.println(stepCount);
  
  delay(2000); // Increased delay for better debugging
}