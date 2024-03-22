# ENED1120 Project
## Introduction
ENED1120 is the second of two first-year engineering courses at the University of Cincinnati. Throughout the course, teams of 4 were tasked with creating and developing an EV3 LEGO robot that can navigate through a scaled facility. This required our robot to do several things:
- Move in all directions
- Know position within the facility
- Pick up boxes at known locations
- Scan different barcodes on the box
- Determine dropoff location from barcode
- Return to starting position
- Detect any obstructions and/or obstacles
## Movement
A large part of this robot is its movement - if it cannot go straight, it won't be successful. With that said, simply coding the robot to go straight will not be effective enough to work. While the robot may be instructed to go straight, the path tends to vary significantly, which is why one of the first things developed was a go-straight algorithm. After a failed algorithm attempt and a couple hours of research, we decided to implement a PID system capable of steering the robot for us using accumulated gyro sensor values. The <a href="https://youtu.be/U-LdBQ-vBkg?si=k_LZRqaQVKBJXTsQ&t=172">equation</a> that we came across was as follows:
<p align="center">
  Steering_Value = K_p * Error + K_i * Integral + K_d * derivative
</p>

#### Kp, Ki, and Kd
- coefficients that will change for every system and should be found through testing. They have no real value

#### Steering Value
- LEGO's EV3 steering value ranges from -100 to 100 and controls a pair of motors where negative numbers turn the robot left while positive turn the robot right.

#### Error, Integral, Derivative
- Error = Expected Value - Real
- Integral = Accumulation of errors over time
- Derivative = Error - Previous Error

With a proper go-straight algorithm, distance and turning functions can reliably be used to navigate the facility

## Position Tracking
For the robot to move, we require the use of a created distance function to go a specific distance. Using the inputted distance and the gyroscope angle (for cardinal directions), values are incremented onto the current coordinates. The values are updated on completion rather than being updated during motion.
<p align="center">
<img src='https://github.com/LannyOakman/ENED1120_EV3_Project/assets/153784525/eaae1322-b17b-448c-a545-bf77c02fb1c5' alt='Schematic of Scaled Facility' width='500'>
</p>

## Box Pickup
--to be updated
<p align="center">
<img src='https://github.com/LannyOakman/ENED1120_EV3_Project/assets/153784525/3229df34-e0fb-41c2-aaeb-802025b46014' alt='Box Schematic' width='600'>
</p>

## Barcode Scanning
--to be updated
<p align="center">
<img src='https://github.com/LannyOakman/ENED1120_EV3_Project/assets/153784525/6751e746-10bc-45cf-8841-24c786dd9579' alt='Barcode Types' width='400'>
</p>

## Obstruction Detection
Since other robots may be using the track at the same time, we have been instructed to stop the robot if there are obstacles. We achieve this by using a proximity sensor that constantly reads the distance in front of the robot. If time allows, we would like to create an algorithm to find another path rather than just stopping.
## PID Testing
Since the PID used is relatively simple compared to the traditional electrical PIDs, previously defined tuning resources (for kp, ki, kd) do not apply to this robot. Because of this, Tuning will be done manually, rather than using calculated ratios. Our approach to tuning is to test the Kp value, then Kp with Kd, and then all three, observing the x-variance over a specified distance. The Kp with the lowest variance will be chosen and then tested with Kd. The best Kd value will be tested with Kp to find Ki. Because Ki is the coefficient for integral (which is accumulating error over the whole session), Ki is significantly smaller than the other. Kp and Kd should be in the rough range of 0.1 to 1.5 while Ki should be less than 0.1. These values are simply just recommendations. Testing may prove that values are outside of the range. I found <a href="https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=9013#:~:text=To%20tune%20your%20PID%20controller,to%20roughly%20half%20this%20value.">this webpage</a> helpful in understanding how the values effect each other. It also explains how PIDs work in their traditional application. Super cool stuff!
