function [r] = ellipse_coords(mu, a, e, Omega, inc, omega)
% ellipse_coords obtains the x,y and z coordinates of an ellipse in the 3D
% space
% INPUTS:
%           mu, gravitational parameter [km^3/s]
%            a, semi-major axis [km]
%            e, eccentricity
%        Omega, RAAN [rad]
%        omega, argument of the periapsis [rad]
%          inc, inclination [rad]
% OUTPUTS:
%            r, 360x3 vector of x,y and z coordinates
%
%%
    % set a vector of all possible true anomalies
    theta = linspace(0, 2*pi, 360);
    
    % preallocate position vector
    r = zeros(3,length(theta));
    
    % transform coe into position vector
    for i = 1:length(theta)
        r(:,i) = coe2rv(mu, a, e, Omega, inc, omega, theta(i));
    end
    
    
end