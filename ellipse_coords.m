function [r, v] = ellipse_coords(orb_elements)
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
    
    mu = 398600;                                % [km^3/s^2]
    
    % preallocate position vector
    r = zeros(length(orb_elements),3);
    
    a = orb_elements(:,1);
    e = orb_elements(:,2);
    Omega = deg2rad(orb_elements(:,4));
    inc = deg2rad(orb_elements(:,3));
    omega = deg2rad(orb_elements(:,5));
    theta = deg2rad(orb_elements(:,6));
    
    % transform coe into position vector
    for i = 1:length(orb_elements)
        [r(i,:), v(i,:)] = coe2rv(mu, a(i), e(i), Omega(i), inc(i), omega(i), theta(i));
    end
    
    
end