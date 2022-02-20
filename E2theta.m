function [theta] = E2theta(E,e)
% Author: Laura Train
% Date of the last update Feb 24 2021

% theta2E obtains the true anomaly from the eccentric anomaly
%
% INPUT:
%       E, eccentric anomaly [rad]
%       e, eccentricity
%
% OUTPUT:
%   theta, true anomaly [rad]
%
%%
    theta = acos((cos(E) - e)./(1 - e*cos(E)));
    
    if mod(E,2*pi)> pi
        theta = 2*pi - theta;
    end
        
end
