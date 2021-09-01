import Adafruit_DHT
import sys

DHT_SENSOR = Adafruit_DHT.DHT22
DHT_PIN = 4

accumulator_temp = 0
accumulator_hum = 0
num = int(sys.argv[1])

humidity, temperature = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)

for _ in range(num):
	humidity, temperature = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)
	if humidity is not None and temperature is not None:
		accumulator_temp += temperature
		accumulator_hum += humidity
	else:
		print("Error while getting climate data from repeater shack sensor.")
		break

avg_temp = int(round((accumulator_temp / num) * 9/5.0 + 32))
avg_hum = int(round((accumulator_hum / num)))
print("Inside the repeater shack, the temperature is {0:} degrees, and the humidity is {1:} percent.".format(avg_temp, avg_hum))
