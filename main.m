% Authors: Laura Train & Juan María Herrera
% Analysis of CZ5B re-entry

%%
clear;clc;close all;

addpath TLEs/
addpath convert/
addpath estimation/
addpath ground_track/

set(groot, 'defaultTextInterpreter',            'latex');
set(groot, 'defaultAxesTickLabelInterpreter',   'latex'); 
set(groot, 'defaultLegendInterpreter',          'latex');
set(groot, 'defaultLegendLocation',             'northeast');

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
init_integ1 = 4;
final_integ1 = 5;

init_integ2 = 5;
final_integ2 = 6;

TLE.Bc = 0.025;

[propagate] = propagateOrbit(init_integ1, final_integ1, TLE);
[propagate2] = propagateOrbit(init_integ2, final_integ2, TLE);

[TLE.lat, TLE.lon, TLE.alt] = ground_trajectory(TLE.r_ECI, TLE.timeUTC);

%%
% Plot ground trajectory
figure()
opts.Color = [140,21,21]/255;
opts.LineWidth = 2.5;
opts.LineStyle = '-';

ground_track(propagate.lat,propagate.lon,opts,'Earth');
hold on
plot(TLE.lon(init_integ1),TLE.lat(init_integ1),'s','MarkerSize',10,...
    'MarkerEdgeColor','blue',...
    'MarkerFaceColor',[0.3010, 0.7450, 0.9330]);
hold on
plot(TLE.lon(final_integ1),TLE.lat(final_integ1),'s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6]);
hold off
legend('Propagation','Initial TLE','Final TLE')

%% See integration results

propagate.r_norm = sqrt(propagate.r_ECI(:,1).^2 + propagate.r_ECI(:,2).^2 + propagate.r_ECI(:,3).^2);
propagate2.r_norm = sqrt(propagate2.r_ECI(:,1).^2 + propagate2.r_ECI(:,2).^2 + propagate2.r_ECI(:,3).^2);
% v_norm = sqrt(v(:,1).^2 + v(:,2).^2 + v(:,3).^2);
TLE.r_norm = sqrt(TLE.r_ECI(:,1).^2 + TLE.r_ECI(:,2).^2 + TLE.r_ECI(:,3).^2);

figure()
plot(TLE.timeUTC(init_integ1:final_integ1),TLE.r_norm(init_integ1:final_integ1),'b*')
plot(propagate.timeUTC,propagate.r_norm,'r')
title("$||r||$ vs UTC time", 'FontSize', 14)
ylabel("$||r||$ [km]",'FontSize',14)
hold on
plot(TLE.timeUTC(init_integ2:final_integ2),TLE.r_norm(init_integ2:final_integ2),'s','MarkerSize',10,...
    'MarkerEdgeColor','blue',...
    'MarkerFaceColor',[0.3010, 0.7450, 0.9330]);
hold on
plot(propagate.timeUTC,propagate.r_norm,'r')

plot(TLE.timeUTC(init_integ1:final_integ1),TLE.r_norm(init_integ1:final_integ1),'s','MarkerSize',10,...
    'MarkerEdgeColor','blue',...
    'MarkerFaceColor',[0.3010, 0.7450, 0.9330]);
hold on
plot(propagate2.timeUTC,propagate2.r_norm,'b')
legend("Propagation","TLEs",'FontSize',12)
hold off

%%
figure()
earth_sphere('km')
hold on
plot3(TLE.r_ECI(init_integ1:final_integ1,1),TLE.r_ECI(init_integ1:final_integ1,2),TLE.r_ECI(init_integ1:final_integ1,3),'r*')
hold on
plot3(propagate.r_ECI(:,1),propagate.r_ECI(:,2),propagate.r_ECI(:,3),'k')
hold off

%% Montecarlo Propagation

N = 3; %Number of tests
sigma_r = 1; %std of r
sigma_v = 1; %std of v
TLE_monte.timeJulian = TLE.timeJulian(final_integ):0.1:TLE.timeJulian(final_integ)+1000;
TLE_monte.Bc = TLE.Bc;

for i = 1:N
    rx = normrnd(TLE.r_ECI(length(TLE.r_ECI),1),sigma_r,1);
    ry = normrnd(TLE.r_ECI(length(TLE.r_ECI),2),sigma_r,1);
    rz = normrnd(TLE.r_ECI(length(TLE.r_ECI),3),sigma_r,1);
    TLE_monte.r_ECI = [rx, ry, rz];

    vx = normrnd(TLE.v_ECI(length(TLE.v_ECI),1),sigma_v,1);
    vy = normrnd(TLE.v_ECI(length(TLE.v_ECI),2),sigma_v,1);
    vz = normrnd(TLE.v_ECI(length(TLE.v_ECI),3),sigma_v,1);
    TLE_monte.v_ECI = [vx, vy, vz];
    
    % Propagate
    [propagate_monte(i)] = propagateOrbit(1, 2, TLE_monte)
    figure(i)
    ground_track(propagate_monte(i).lat,propagate_monte(i).lon,opts,'Earth');
end






