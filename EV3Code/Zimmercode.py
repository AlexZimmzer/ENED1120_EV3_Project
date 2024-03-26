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
from Ev3Functions import *
unit = int(input("Please enter shelving unit (A = 1, B = 2, C = 3, D = 4): "))
number = int(input("Please enter shelving number(1 or 2): "))
sub = int(input("Please enter shelving subsection(1-12): "))
movement_list = ZimCode(unit,number,sub)
print(movement_list)