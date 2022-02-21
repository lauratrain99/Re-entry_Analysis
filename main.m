% Authors: Laura Train & Juan María Herrera
% Analysis of CZ5B re-entry

%%
clear;clc;close all;

addpath TLEs/
addpath convert/
addpath estimation/
addpath ground_track/

%%
file = 'CZ5B_2021.txt';

[TLE] = TLE_parse(file);
[TLE.r_ECI,TLE.v_ECI] = ECI_coords(TLE.orb_elements);

% Extract orbital elements
TLE.a = TLE.orb_elements(:,1);
TLE.e = TLE.orb_elements(:,2);
TLE.inc = TLE.orb_elements(:,3);
TLE.raan = TLE.orb_elements(:,4);
TLE.w = TLE.orb_elements(:,5);
TLE.theta = TLE.orb_elements(:,6);

% plot orbital elements
figure()
subplot(2,3,1)
plot(TLE.timeJulian, TLE.a)
title("Semi-major axis [km]")

subplot(2,3,2)
plot(TLE.timeJulian, TLE.e)
title("Eccentricity")

subplot(2,3,3)
plot(TLE.timeJulian, TLE.inc)
title("Inclination [deg]")

subplot(2,3,4)
plot(TLE.timeJulian, TLE.raan)
title("RAAN [km]")

subplot(2,3,5)
plot(TLE.timeJulian, TLE.w)
title("Arg. of perigee [deg]")

subplot(2,3,6)
plot(TLE.timeJulian, TLE.theta)
title("True anomaly [deg]")

%% Propagate from initial state

% TLE taken as initial and final conditions to propagate
init_integ = 1;
final_integ = 2;
TLE.Bc = 0.01;

[propagator] = propagateOrbit(init_integ, final_integ, TLE);

% Plot ground trajectory
figure('Position',[300,300,1000,500]);
opts_earth1.Color = [140,21,21]/255;
opts_earth1.LineWidth = 2.5;

ground_track(propagator.lat,propagator.lon,opts_earth1,'Earth');

%% See integration results

r_norm_prop = sqrt(r_prop(:,1).^2 + r_prop(:,2).^2 + r_prop(:,3).^2);
% v_norm = sqrt(v(:,1).^2 + v(:,2).^2 + v(:,3).^2);
r_norm = sqrt(r(:,1).^2 + r(:,2).^2 + r(:,3).^2);

figure()
plot(timeJulian(init_integ:final_integ)*24*3600,r_norm(init_integ:final_integ),'b*')
hold on
plot(t,r_norm_prop,'r')
hold off

figure()
earth_sphere('km')
hold on
plot3(r(init_integ:final_integ,1),r(init_integ:final_integ,2),r(init_integ:final_integ,3),'r*')
hold on
plot3(r_prop(:,1),r_prop(:,2),r_prop(:,3),'k')
hold off


