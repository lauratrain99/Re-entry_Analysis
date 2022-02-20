clear;clc;

addpath TLEs/

file = 'CZ5B_2021.txt';

[orb_elements, time, ballistic_coeff] = TLE_parse(file);