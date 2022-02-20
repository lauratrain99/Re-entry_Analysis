clear;clc;

addpath TLEs/

file = 'CZ5B_2021.txt';


[orb_elements, timeUTC, timeJulian, ballistic_coeff] = TLE_parse(file);

[r,v] = ellipse_coords(orb_elements);

h = orb_elements(:,1) - 6378;

figure(1)
plot(timeJulian,'b*')

figure(2)
plot(timeJulian, orb_elements(:,1))

figure(3)
plot(timeJulian, orb_elements(:,2))
figure(4)
plot(timeJulian, orb_elements(:,3))
figure(5)
plot(timeJulian, orb_elements(:,4))

figure(6)
plot(timeJulian, orb_elements(:,5))


figure(7)
plot(timeJulian, orb_elements(:,6))

figure(11)
earth_sphere('km')
hold on
plot3(r(1:2,1),r(1:2,2),r(1:2,3),'r*')
hold off