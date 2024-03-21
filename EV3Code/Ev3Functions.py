#!/usr/bin/env python3
import math
#import all mortors, output ports, and functions
from ev3dev2.motor import LargeMotor, OUTPUT_A, OUTPUT_B
from ev3dev2.motor import MediumMotor, OUTPUT_C, OUTPUT_D
from ev3dev2.motor import MoveTank, MoveSteering, list_motors
from ev3dev2.motor import SpeedPercent, SpeedRPS, SpeedDPS
#Import all sensors, input ports, and functions
from ev3dev2.sensor import INPUT_1, INPUT_2, INPUT_3, INPUT_4
from ev3dev2.sensor.lego import ColorSensor
from ev3dev2.sensor.lego import GyroSensor
from ev3dev2.sensor.lego import UltrasonicSensor
from ev3dev2.sensor.lego import TouchSensor
from ev3dev2.sensor.lego import InfraredSensor
#import all remaining rest
from ev3dev2.display import Display
from ev3dev2.button import Button
from ev3dev2.sound import Sound
from ev3dev2.led import Leds
import time

#constants/variables
degrees_for_1degree = (4.13) #(4.27)
degrees_for_1cm = 20.2 #(20.741475)
inches_in_1cm = 0.393701
degrees_for_1inch = degrees_for_1cm/inches_in_1cm
turn_added_distance = 0
steering_drive = MoveSteering(OUTPUT_A, OUTPUT_B)
motorA = LargeMotor(OUTPUT_A)
motorB = LargeMotor(OUTPUT_B)
motorC = MediumMotor(OUTPUT_C)
color_sensor = ColorSensor(INPUT_2)
touch_sensor = TouchSensor(INPUT_3)
gyro_sensor = GyroSensor(INPUT_4)
added_turn_degrees = 38.481

#PID Controls
    #Tweaked k-values
kp = 0.6 #1 #.7
ki = 0.008#0.008 #0.008 #0.01
kd = 0.4 #0.83 #0.3
#other variables.
steeringvalue = 0
Target = 0
Error = 0 
Integral = 0.00
Derivative = 0
ErrorLast = 0
#list to make calling values much easier.
PID_settings = [steeringvalue, Target, Error, kp, ki, Integral, kd, Derivative, ErrorLast]
# List indexs       0           1       2       3   4   5       6   7           8

#Starting location will be adjusted to proper location, but for testing purposes (0,0) is start position.
location = [0,0]
#Barcode information. Assume 0 is white and 1 is black.
barcode_1 = [0,0,0,1]
barcode_2 = [0,1,0,1]
barcode_3 = [0,0,1,1]
barcode_4 = [1,0,0,1]
barcode_all_list = [barcode_1,barcode_2,barcode_3,barcode_4]
barcode_cur_list = [0,0,0,0]

#This function can be called to read gyro on input_4. It's easier to type read_gyro() so I like it.
def read_gyro():
    return gyro_sensor.angle

#Go straight algorithm that takes error, derivative, and integral and multiplies each by a k coeficient. This generators a steering value.
#Steering drive needs to be stopped externally. This function will not stop going forward if not told to stop (i.e. steering_drive.off when it exits a loop.)
#To lessen the arguments, the 9 variables has been replaced with a list to make calling it easier.
def go_straight(PID_settings):
    PID_settings[2] = PID_settings[1] - read_gyro()
    PID_settings[5] = PID_settings[5] + PID_settings[2]
    PID_settings[7] = PID_settings[2] - PID_settings[8]
    PID_settings[0] = PID_settings[2] * PID_settings[3] + PID_settings[5] * PID_settings[4] + PID_settings[7] * PID_settings[6]
    if abs(PID_settings[0]) > 40:
        steering_drive.on(PID_settings[0],20)
    else:
        steering_drive.on(PID_settings[0],40)
    PID_settings[8] = PID_settings[2]

#This function moves forward in inches the number it is directed. It uses go_straight() to move.
#When calling, please set Target = location() since target is always updating.
def move_distance(distance_inches, target, location,pid):
    while (((motorA.degrees + motorB.degrees)/2) / (degrees_for_1inch)) < distance_inches:
        go_straight(PID_settings)
        print(pid)
    steering_drive.off()
    #Adds/subtracts value depending on target degree.
    if target / 90 % 4 == 1 or target/90 % 4 == -3:
        location[0] = location[0] + distance_inches
    elif target / 90 % 4 == -1 or target/90 % 4 == 3:
        location[0] = location[0] - distance_inches
    elif target / 90 % 4 == 0:
        location[1] = location[1] + distance_inches
    else:
        location[1] = location[1] - distance_inches
    motorAB_reset()
    return location

#Resets motor A and B at once. Easier than calling both functions.
#Keep in mind that this also shuts off the motors for a period of time, so calling the function during motion isn't a good idea.
def motorAB_reset():
    motorA.reset()
    motorB.reset()

#turns robot until specified degrees are met. Keep in mind that our robot considers CCW to be negative and CW to be positve. (idk I installed the gyro wrong-lanny)
#can take positive and negative values. Returns Target, so please make sure the funciton is called in the fashion Target = turn()
#In the future, we need to check how much distance is added to a turn (i.e. added x distance on a 90 degree turn from positve y.)
def turn(degrees, Targ):
    degrees = degrees * -1 + Targ
    if degrees < 0:
        while read_gyro() > degrees+4:
            steering_drive.on(-100,10)
    else:
        while read_gyro() < degrees-4:
            steering_drive.on(100,10)
    steering_drive.off
    Targ = degrees
    motorAB_reset()
    return Targ

#Calibrates gyro. Do we really need this? No. But it is fewer keystrokes sooooooo. 
def calibrate_gyro():
    GyroSensor(INPUT_4).calibrate()

#experiemental brain code
def scanner():
    for i in range(4):
        barcode_cur_list[i] = color_sensor.color
        if barcode_cur_list[i] != 1:
            barcode_cur_list[i] = 0
        motorC.on_for_degrees(30,120)
    for i in range(4):
        if barcode_cur_list == barcode_all_list[i]:
            return(barcode_cur_list)

## End Of functions #######################################################################################################################################

