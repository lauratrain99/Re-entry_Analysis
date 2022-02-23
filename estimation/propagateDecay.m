function [propagate] = propagateDecay(initJulian, finalJulian, TLE)

    % Initial and final integration times in seconds
    t0 = initJulian*24*3600;
    tf = finalJulian*24*3600;

    % Initial pos and vel
    r0 = TLE.r_ECI(1,:)';
    v0 = TLE.v_ECI(1,:)';
    iniState = [r0 v0];

    % Propagate the orbit
    options = odeset('RelTol',1e-8,'AbsTol',1e-8); 
    
    [t,y] = ode45(@dragDecay,linspace(t0, tf,1000), iniState, options, TLE);  
    
    propagate.t = t;
    propagate.r_ECI = y(:,1:3);
    propagate.v_ECI = y(:,4:6);

    % Compute ground trajectory
    [propagate.timeUTC] = integ_t2utc(t);
    [propagate.lat, propagate.lon, propagate.alt] = ground_trajectory(propagate.r_ECI, propagate.timeUTC);
end