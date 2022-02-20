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

[orb_elements, timeUTC, timeJulian, ballistic_coeff] = TLE_parse(file);
[r,v] = ECI_coords(orb_elements);

% Extract orbital elements
a = orb_elements(:,1);
e = orb_elements(:,2);
inc = orb_elements(:,3);
raan = orb_elements(:,4);
w = orb_elements(:,5);
theta = orb_elements(:,6);

% plot orbital elements
figure()
subplot(2,3,1)
plot(timeJulian, a)
title("Semi-major axis [km]")

subplot(2,3,2)
plot(timeJulian, e)
title("Eccentricity")

subplot(2,3,3)
plot(timeJulian, inc)
title("Inclination [deg]")

subplot(2,3,4)
plot(timeJulian, raan)
title("RAAN [km]")

subplot(2,3,5)
plot(timeJulian, w)
title("Arg. of perigee [deg]")

subplot(2,3,6)
plot(timeJulian, theta)
title("True anomaly [deg]")

%% Propagate from initial state

% TLE taken as initial and final conditions to propagate
init_integ = 1;
final_integ = 2;

% Initial and final integration times in seconds
t0 = timeJulian(init_integ)*24*3600;
tf = timeJulian(final_integ)*24*3600;

% Initial pos and vel
r0 = r(init_integ,:)';
v0 = v(init_integ,:)';
iniState = [r0 v0];

% Propagate the orbit
options = odeset('RelTol',1e-8,'AbsTol',1e-8); 
Bc = 0.01;
[t,y] = ode45(@dragDyn,linspace(t0, tf,1000), iniState, options, Bc);  

r_prop = y(:,1:3);
v_prop = y(:,4:6);

% Compute ground trajectory
[utc_prop] = integ_t2utc(t);
[lat, lon, alt] = ground_trajectory(r_prop, utc_prop);

% Plot ground trajectory
figure('Position',[300,300,1000,500]);
opts_earth1.Color = [140,21,21]/255;
opts_earth1.LineWidth = 2.5;

ground_track(lat,lon,opts_earth1,'Earth');

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


