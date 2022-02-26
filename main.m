% Authors: Laura Train & Juan María Herrera
% Analysis of CZ5B re-entry

%% 
clear;clc;close all;

addpath TLEs/
addpath convert/
addpath estimation/
addpath ground_track/
addpath atmosphere/

set(groot, 'defaultTextInterpreter',            'latex');
set(groot, 'defaultAxesTickLabelInterpreter',   'latex'); 
set(groot, 'defaultLegendInterpreter',          'latex');
set(groot, 'defaultLegendLocation',             'northeast');

%% Parse TLEs and get orbital elements
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
plot(TLE.timeUTC, TLE.a,'b-o')
title("Semi-major axis [km]",'FontSize',14)

subplot(2,3,2)
plot(TLE.timeUTC, TLE.e,'b-o')
title("Eccentricity",'FontSize',14)

subplot(2,3,3)
plot(TLE.timeUTC, TLE.inc,'b-o')
title("Inclination [deg]",'FontSize',14)

subplot(2,3,4)
plot(TLE.timeUTC, TLE.raan,'b-o')
title("RAAN [km]",'FontSize',14)

subplot(2,3,5)
plot(TLE.timeUTC, TLE.w,'b-o')
title("Arg. of perigee [deg]",'FontSize',14)

subplot(2,3,6)
plot(TLE.timeUTC, TLE.theta,'r*')
title("True anomaly [deg]",'FontSize',14)

%% Full integration
full_integ = 1;

if full_integ == 1
    % TLE taken as initial and final conditions to propagate
    [propagate] = propagateOrbit(2, 3, TLE);
    totalPropagate.r_ECI = propagate.r_ECI;
    totalPropagate.v_ECI = propagate.v_ECI;
    totalPropagate.timeUTC = propagate.timeUTC;
    totalPropagate.alt = propagate.alt;
    % Integrate the full domain
    for i = 3:31
        [propagate] = propagateOrbit(i, i+1, TLE);
        totalPropagate.r_ECI = [totalPropagate.r_ECI; propagate.r_ECI];
        totalPropagate.v_ECI = [totalPropagate.v_ECI; propagate.v_ECI];
        totalPropagate.timeUTC = [totalPropagate.timeUTC; propagate.timeUTC];
        totalPropagate.alt = [totalPropagate.alt; propagate.alt];
    end

    % Compute radius of the propagation
    totalPropagate.r_norm = sqrt(totalPropagate.r_ECI(:,1).^2 + ... 
                            totalPropagate.r_ECI(:,2).^2 + totalPropagate.r_ECI(:,3).^2);

    % TLE radius of the orbit 
    TLE.r_norm = sqrt(TLE.r_ECI(2:end,1).^2 + TLE.r_ECI(2:end,2).^2 + TLE.r_ECI(2:end,3).^2);

    % Plot overall orbit propagation and TLEs
    figure()
    plot(totalPropagate.timeUTC,totalPropagate.r_norm,'r')
    title("$||r||$ vs UTC time", 'FontSize', 14)
    ylabel("$||r||$ [km]",'FontSize',14)
    hold on
    plot(TLE.timeUTC(2:end),TLE.r_norm,'s','MarkerSize',10,...
        'MarkerEdgeColor','blue',...
        'MarkerFaceColor',[0.3010, 0.7450, 0.9330]);
    legend("Propagation","TLEs",'FontSize',12)
    hold off
    
    % Plot Earth full orbit
    figure()
    earth_sphere('km')
    hold on
    plot3(totalPropagate.r_ECI(:,1),totalPropagate.r_ECI(:,2),totalPropagate.r_ECI(:,3),'k')
    hold on
    plot3(TLE.r_ECI(:,1),TLE.r_ECI(:,2),TLE.r_ECI(:,3),'s','MarkerSize',8,...
        'MarkerEdgeColor','red',...
        'MarkerFaceColor',[0.75, 0, 0.75]);
    legend("Propagation","TLEs",'FontSize',12)
    hold off
    
end


%% Integrate one step
partial_integ = 0;

if partial_integ == 1
    % Choose integration points
    init_integ1 = 2;
    final_integ1 = 3;

    init_integ2 = 3;
    final_integ2 = 4;

    init_integ3 = 4;
    final_integ3 = 5;

    % Integrate orbits
    [propagate1] = propagateOrbit(init_integ1, final_integ1, TLE);
    [propagate2] = propagateOrbit(init_integ2, final_integ2, TLE);
    [propagate3] = propagateOrbit(init_integ3, final_integ3, TLE);

    % Radius of the orbit
    propagate1.r_norm = sqrt(propagate1.r_ECI(:,1).^2 + propagate1.r_ECI(:,2).^2 + propagate1.r_ECI(:,3).^2);
    propagate2.r_norm = sqrt(propagate2.r_ECI(:,1).^2 + propagate2.r_ECI(:,2).^2 + propagate2.r_ECI(:,3).^2);
    propagate3.r_norm = sqrt(propagate3.r_ECI(:,1).^2 + propagate3.r_ECI(:,2).^2 + propagate3.r_ECI(:,3).^2);
    TLE.r_norm = sqrt(TLE.r_ECI(:,1).^2 + TLE.r_ECI(:,2).^2 + TLE.r_ECI(:,3).^2);


    % Radius of both orbits
    figure()
    plot(propagate1.timeUTC,propagate1.r_norm,'r','LineWidth',1)
    hold on
    plot(propagate2.timeUTC,propagate2.r_norm,'b','LineWidth',1)
    hold on
    plot(propagate3.timeUTC,propagate3.r_norm,'g','LineWidth',1)
    hold on
    plot(TLE.timeUTC(init_integ1:final_integ1),TLE.r_norm(init_integ1:final_integ1),'s','MarkerSize',10,...
        'MarkerEdgeColor','red',...
        'MarkerFaceColor',[1, 0, 0]);
    hold on
    plot(TLE.timeUTC(init_integ2:final_integ2),TLE.r_norm(init_integ2:final_integ2),'s','MarkerSize',10,...
        'MarkerEdgeColor','red',...
        'MarkerFaceColor',[1, 0, 0]);
    hold on
    plot(TLE.timeUTC(init_integ3:final_integ3),TLE.r_norm(init_integ3:final_integ3),'s','MarkerSize',10,...
        'MarkerEdgeColor','red',...
        'MarkerFaceColor',[1, 0, 0]);
    legend("Propagation 1","Propagation 2","Propagation 3","TLEs",'FontSize',12)
    ylim([6530, 6770])
    hold off
    title("$||r||$ vs UTC time", 'FontSize', 14)
    ylabel("$||r||$ [km]",'FontSize',14)
    
    % Ground track
    % Plot ground trajectory
    figure()
    opts.Color = [140,21,21]/255;
    opts.LineWidth = 2.5;
    opts.LineStyle = '-';

    % Get ground trajectory of TLEs
    [TLE.lat, TLE.lon, TLE.alt] = ground_trajectory(TLE.r_ECI, TLE.timeUTC);

    ground_track(propagate1.lat,propagate1.lon,opts,'Earth');
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
    
end

%% Montecarlo Propagation

% Propagate one day from the last TLE stopping when h < 0
last_TLE_index = 32;
days_propagate = 1;
TLE_monte.timeJulian = linspace(TLE.timeJulian(last_TLE_index), TLE.timeJulian(last_TLE_index) + days_propagate);
TLE_monte.Bc = TLE.Bc(last_TLE_index);

% Plot nominal trajectory
opts.Color = [140,21,21]/255;
opts.LineWidth = 2.5;
opts.LineStyle = '-';

figure()
TLE_monte.r_ECI = TLE.r_ECI(last_TLE_index,:);
TLE_monte.v_ECI = TLE.v_ECI(last_TLE_index,:);
[propagate_nominal] = propagateDecay(TLE_monte.timeJulian(1), TLE_monte.timeJulian(end), TLE_monte);
ground_track(propagate_nominal.lat,propagate_nominal.lon,opts,'Earth');
hold on;

% Set up MC parameters
N = 1000; %Number of tests
sigma_r = 1; %std of r
sigma_v = 0.5; %std of v

for i = 1:N
    % Dispersion on position
    rx = normrnd(TLE.r_ECI(last_TLE_index,1),sigma_r,1);
    ry = normrnd(TLE.r_ECI(last_TLE_index,2),sigma_r,1);
    rz = normrnd(TLE.r_ECI(last_TLE_index,3),sigma_r,1);
    TLE_monte.r_ECI = [rx, ry, rz];
    
    % Dispersion on velocity
    vx = normrnd(TLE.v_ECI(last_TLE_index,1),sigma_v,1);
    vy = normrnd(TLE.v_ECI(last_TLE_index,2),sigma_v,1);
    vz = normrnd(TLE.v_ECI(last_TLE_index,3),sigma_v,1);
    TLE_monte.v_ECI = [vx, vy, vz];
    
    % Propagate all dispersion conditions
    [propagate_monte(i)] = propagateDecay(TLE_monte.timeJulian(1), TLE_monte.timeJulian(end), TLE_monte);
end

% Plot Landings

for j = 1:N
    plot(propagate_monte(j).lon(end),propagate_monte(j).lat(end),'s','MarkerSize',10,...
    'MarkerEdgeColor','red',...
    'MarkerFaceColor',[1 .6 .6]);
    hold on
end
hold off

% Sugerencia de LT: correr 100 montecarlos y plotear lon vs lat de los
% landing points (los landing points son siempre el último punto del vector
% de la integración ya que le he puesto una condición de corte al
% integrador cuando la altura es casi 0 (con 0 explota por cositas de la
% atmósfera pero espero que con 10 metros te valga)). Una vez tengas los 100
% puntos ploteados puede estar muy chulo sacar los autovectores para hacer
% la elipse de dispersión y trazar la de sigma, dos sigma y tres sigma. El
% centro de la elipse sería nuestro punto de caída estimado (no?) y
% comentar cosas a partir de eso

%% Plot total altitude decay

if full_integ == 1
    total_time = [totalPropagate.timeUTC; propagate_nominal.timeUTC];
    total_alt = [totalPropagate.alt; propagate_nominal.alt];
    mean1 = movmean(propagate_nominal.alt,500);
    mean1(end-60:end) = propagate_nominal.alt(end-60:end);
    
    figure()
    plot(total_time, total_alt)
    hold on
    plot(TLE.timeUTC(2:end), TLE.a(2:end) - 6378,'r')
    hold on
    plot(propagate_nominal.timeUTC, mean1,'r')
    ylabel("Altitude [km]",'FontSize',14)
    title("Orbit decay",'FontSize',14)
    legend("Altitude propagation","Mean altitude","Mean altitude","LineWidth",14)
    hold off

end

%% Plot Dispersion Ellipses

for h = 1:N
    lats(h) = propagate_monte(h).lon(end);
    lons(h) = propagate_monte(h).lat(end);
end

meanLatLon = [propagate_nominal.lat(end), propagate_nominal.lon(end)];
ellipse1 = [std(lats),std(lons)];
ellipse2 = 2*[std(lats),std(lons)];
ellipse3 = 3*[std(lats),std(lons)];


