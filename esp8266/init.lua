wifi.setmode(wifi.STATION)
wifi.sta.config({ssid = "NoPainNoGain-2G", pwd = "passwordwifi"})

MOTOR_1_PIN_1 = 1
MOTOR_1_PIN_2 = 2
MOTOR_2_PIN_1 = 5
MOTOR_2_PIN_2 = 6

gpio.mode(0,gpio.OUTPUT)
gpio.write(0,gpio.HIGH)

gpio.mode(1,gpio.OUTPUT)
gpio.mode(2,gpio.OUTPUT)
gpio.mode(5,gpio.OUTPUT)
gpio.mode(6,gpio.OUTPUT)

--
--  UTILITY FUNCTIONS
--

function handleMotorDirection(outputPin1, outputPin2, command)
    if (command == "1") then
        gpio.write(outputPin1,gpio.HIGH)
        gpio.write(outputPin2,gpio.LOW)
    elseif (command == "2") then
        gpio.write(outputPin1,gpio.LOW)
        gpio.write(outputPin2,gpio.HIGH)
    else
        gpio.write(outputPin1,gpio.LOW)
        gpio.write(outputPin2,gpio.LOW)
    end
end

function handleWifiConnected()
    print("\nConnected to NoPainNoGain-2G")
    print("\nIP: ")
    print(wifi.sta.getip())
end

function receiver(sck, data)
  if (string.len(data) == 2) then
    motor1 = string.sub(data, 1, 1)
    motor2 = string.sub(data, 2, 2)
    handleMotorDirection(MOTOR_1_PIN_1, MOTOR_1_PIN_2, motor1)
    handleMotorDirection(MOTOR_2_PIN_1, MOTOR_2_PIN_2, motor2)
  end
end

--
--  MAIN PROCEDURE
--

wifi.sta.connect(handleWifiConnected)
sv = net.createServer(net.TCP, 30)

if sv then
  sv:listen(80, function(conn)
    conn:on("receive", receiver)
    conn:send("Connected to Bot's control terminal\n")
    conn:send("Syntax to issue commands combination: [L][R]\n")
    conn:send("[L] stand for left motor, [R] fo right motor\n")
    conn:send("Acceptable commands:\n0 - stand by\n1 - clockwise\n2 - counter clockwise\n")
    conn:send("Example:\n11 - move forward\n12 - spin\n22 - move backward\n")
    conn:send("\n==============================\n")
    gpio.write(0,gpio.LOW)
  end)
end
