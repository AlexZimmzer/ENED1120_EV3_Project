% Activity: Project Data Analysis
% File: Project_TEAM008_DataAnalysis.m
% Date: 07Mar2024
% By: Lanny Oakman oakmanlt
% Section: 01
% Team: 008
%
% ELECTRONIC SIGNATURE (if team assignment, include all members info)
% Lanny Oakman, Matthew Bish, Elizabeth Watson, Alex Zimmer
%
% The electronic signature above indicates the script
% submitted for evaluation is my individual work, and I
% have a general understanding of all aspects of its
% development and execution.
%
% A BRIEF DESCRIPTION OF WHAT THE SCRIPT OR FUNCTION DOES
% Import and understand the included csv files and analyze the data.
% User will input the shelving they want to access and it will return the
% expected value.

clc;
clear;
%import files into a matrix.
TurnRaw = csvread("TurnRaw.csv");
StraightRaw = csvread("GoStraightRaw.csv");

x_straight_avg_per_inch = 0;
y_straight_avg_per_inch = 0;
x_turn_avg_per_inch_pos_turn = 0;
y_turn_avg_per_inch_pos_turn = 0;
x_turn_avg_per_inch_neg_turn = 0;
y_turn_avg_per_inch_neg_turn = 0;
location = [6,-6];
angle_acum = 0;
angle_cur = 0;
x_alleys = [18,42,66,90];
shelving_targ = [3,9,15,21,27,33];



%find variance/inch for x and y using the collected matricies.
for i = 1 : 20
    x_straight_avg_per_inch = StraightRaw(i, 2) / StraightRaw(i,1) + x_straight_avg_per_inch;
    y_straight_avg_per_inch = StraightRaw(i, 3) / StraightRaw(i,1) + y_straight_avg_per_inch;
end

%average out each x and y.
x_straight_avg_per_inch = x_straight_avg_per_inch / 20;
y_straight_avg_per_inch = y_straight_avg_per_inch / 20;

%loop through the positive and negative angle values from the turn excel.
%Then calculate the average variance with the 90 degree requirment.
for j = 1 : 20
    if (j >= 1 && j < 6) || (j >= 11 && j < 16)
        x_turn_avg_per_inch_neg_turn = TurnRaw(j, 2) / TurnRaw(j,1) + x_turn_avg_per_inch_neg_turn;
        y_turn_avg_per_inch_neg_turn = TurnRaw(j, 3) / TurnRaw(j,1) + y_turn_avg_per_inch_neg_turn;
    else
        x_turn_avg_per_inch_pos_turn = TurnRaw(j, 2) / TurnRaw(j,1) + x_turn_avg_per_inch_pos_turn;
        y_turn_avg_per_inch_pos_turn = TurnRaw(j, 3) / TurnRaw(j,1) + y_turn_avg_per_inch_pos_turn;
    end
end

%Find the average
x_turn_avg_per_inch_pos_turn = x_turn_avg_per_inch_pos_turn / 10;
y_turn_avg_per_inch_pos_turn = y_turn_avg_per_inch_pos_turn / 10;
x_turn_avg_per_inch_neg_turn = x_turn_avg_per_inch_neg_turn / 10;
y_turn_avg_per_inch_neg_turn = y_turn_avg_per_inch_neg_turn / 10;

%Find variance from expected x and y for both cw and CCW
x_vary_per90_ccw = x_straight_avg_per_inch - x_turn_avg_per_inch_pos_turn;
y_vary_per90_ccw = y_straight_avg_per_inch - y_turn_avg_per_inch_pos_turn;
x_vary_per90_cw = x_straight_avg_per_inch - x_turn_avg_per_inch_neg_turn;
y_vary_per90_cw = y_straight_avg_per_inch - y_turn_avg_per_inch_neg_turn;

%user input
%while ang ~= dist
%    dist = input("Please enter the number of lengths you would like to go: ");
%    ang = input("Please enter the number of angles you would like to turn (number of angles must be equal to number of distances): ");
%end
shelving_unit = input("Please enter shelving unit(A=1,B=2,C=3,D=4): ");
shelving_number = input("Please enter shelving number(1 or 2): ");
shelving_sub = input("Please enter shelving subsection(1-12): ");

dist = 3;
ang = 2;

distance_matrix = zeros([1,dist]);
angle_matrix = zeros([1,ang]);



angle_matrix(1,1) = -90;
if shelving_sub < 7
    angle_matrix(1,2) = 90;
else
    angle_matrix(1,2) = -90;
end
if shelving_number == 1
    if shelving_sub <= 6
        if shelving_unit == 1 || shelving_unit == 2
            distance_matrix(1,1) = x_alleys(1,1)-12+6;
        end
        if shelving_unit == 3 || shelving_unit == 4
            distance_matrix(1,1) = x_alleys(1,3)-12+6;
        end
    else
        if shelving_unit == 1 || shelving_unit == 2
            distance_matrix(1,1) = x_alleys(1,1)+12+6;
        end
        if shelving_unit == 3 || shelving_unit == 4
            distance_matrix(1,1) = x_alleys(1,3)+12+6;
        end
    end
else
    if shelving_sub <= 6
        if shelving_unit == 1 || shelving_unit == 2
            distance_matrix(1,1) = x_alleys(1,2)-12+6;
        end
        if shelving_unit == 3 || shelving_unit == 4
            distance_matrix(1,1) = x_alleys(1,4)-12+6;
        end
    else
        if shelving_unit == 1 || shelving_unit == 2
            distance_matrix(1,1) = x_alleys(1,2)+12+6;
        end
        if shelving_unit == 3 || shelving_unit == 4
            distance_matrix(1,1) = x_alleys(1,4)+12+6;
        end
    end
end
if shelving_unit == 1 || shelving_unit == 3
    shelving_sub = mod(shelving_sub,6);
    if shelving_sub == 0
        shelving_sub = 6;
    end
    for i = 1 : 6
        if shelving_sub == i
            distance_matrix(1,2) = shelving_targ(1,i)+6;
            break;
        end
    end
elseif shelving_unit == 2 || shelving_unit == 4
    shelving_sub = mod(shelving_sub,6);
    if shelving_sub == 0
        shelving_sub = 6;
    end
    for i = 1 : 6
        if shelving_sub == i
            distance_matrix(1,2) = shelving_targ(1,i)+54;
            break;
        end
    end    
end
distance_matrix(1,3) = 6;



% fill out the matricies with user input.
%for i = 1 : dist
%    distance_matrix(1,i) = input("Please enter your distance values, pressing enter after each (positive): ");
%end
%for i = 1 : ang
%    angle_matrix(1,i) = input("Please enter your angle values, pressing enter after each (assume y positive start. multiples of 90(ccw)/-90(cw)): ");
%end

%cycle through each input and turn adjusting the coordinates as you go.
for i = 1 : dist
    if i == 1
        location(1,2) = location(1,2) + distance_matrix(1,i) + x_straight_avg_per_inch * distance_matrix(1,i);
    else
        if mod(angle_acum / 90,4) == 1 || mod(angle_acum / 90,4) == -3
            if angle_cur > 0
                location(1) = location(1) + distance_matrix(1,i) + distance_matrix(1,i) * (angle_cur/90) * x_vary_per90_ccw;
                location(2) = location(2) + distance_matrix(1,i) * (angle_cur/90) * y_vary_per90_ccw;
            else
                location(1) = location(1) + distance_matrix(1,i) + distance_matrix(1,i) * (angle_cur/90) * x_vary_per90_cw;
                location(2) = location(2) + distance_matrix(1,i) * (angle_cur/90) * y_vary_per90_cw;
            end
        elseif mod(angle_acum / 90,4) == -1 || mod(angle_acum / 90,4) == 3
            if angle_cur > 0
                location(1) = location(1) - distance_matrix(1,i) + distance_matrix(1,i) * (angle_cur/90) * x_vary_per90_ccw;
                location(2) = location(2) + distance_matrix(1,i) * (angle_cur/90) * y_vary_per90_ccw;
            else
                location(1) = location(1) + distance_matrix(1,i) + distance_matrix(1,i) * (angle_cur/90) * x_vary_per90_cw;
                location(2) = location(2) + distance_matrix(1,i) * (angle_cur/90) * y_vary_per90_cw;
            end
        elseif mod(angle_acum / 90,4) == 0
            if angle_cur > 0
                location(2) = location(2) + distance_matrix(1,i) + distance_matrix(1,i) * (angle_cur/90) * x_vary_per90_ccw;
                location(1) = location(1) + distance_matrix(1,i) * (angle_cur/90) * y_vary_per90_ccw;
            else
                location(2) = location(2) + distance_matrix(1,i) + distance_matrix(1,i) * (angle_cur/90) * x_vary_per90_cw;
                location(1) = location(1) + distance_matrix(1,i) * (angle_cur/90) * y_vary_per90_cw;
            end
        else
            if angle_cur > 0
                location(2) = location(2) - distance_matrix(1,i) + distance_matrix(1,i) * (angle_cur/90) * x_vary_per90_ccw;
                location(1) = location(1) + distance_matrix(1,i) * (angle_cur/90) * y_vary_per90_ccw;
            else
                location(2) = location(2) - distance_matrix(1,i) + distance_matrix(1,i) * (angle_cur/90) * x_vary_per90_cw;
                location(1) = location(1) + distance_matrix(1,i) * (angle_cur/90) * y_vary_per90_cw;
            end
        end
    end
    %read the angle and add to angle acum
    if i == 1
        angle_cur = angle_matrix(1,i);
        angle_acum = angle_cur + angle_acum;
    elseif i == 2
        angle_cur = angle_matrix(1,i);
        angle_acum = angle_cur + angle_acum;
    end
end
%output the results
fprintf("The expected location of the robot is (%0.3f, %0.3f]).",location(1,1),location(1,2));
