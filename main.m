clear;clc;

addpath TLEs/

file = 'CZ5B_2021.txt';


[orb_elements, timeUTC, timeJulian, ballistic_coeff] = TLE_parse(file);

r = ellipse_coords(orb_elements);

h = orb_elements(:,1) - 6378;

