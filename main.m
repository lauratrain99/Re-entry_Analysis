% orb_elements = TLE_parse('Tianhe.txt')
clear;clc;

file = 'CZ5B_2021.txt';

[orb_elements, time, ballistic_coeff] = TLE_parse(file);