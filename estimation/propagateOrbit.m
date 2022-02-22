function [propagate] = propagateOrbit(init_integ, final_integ, TLE)

    % Initial and final integration times in seconds
    t0 = TLE.timeJulian(init_integ)*24*3600;
    tf = TLE.timeJulian(final_integ)*24*3600;

    % Initial pos and vel
    r0 = TLE.r_ECI(init_integ,:)';
    v0 = TLE.v_ECI(init_integ,:)';
    iniState = [r0 v0];

    % Propagate the orbit
    options = odeset('RelTol',1e-8,'AbsTol',1e-8); 
    
    [t,y] = ode45(@dragDyn,linspace(t0, tf,1000), iniState, options, TLE);  
    
    propagate.t = t;
    propagate.r_ECI = y(:,1:3);
    propagate.v_ECI = y(:,4:6);

    % Compute ground trajectory
    [propagate.timeUTC] = integ_t2utc(t);
    [propagate.lat, propagate.lon, propagate.alt] = ground_trajectory(propagate.r_ECI, propagate.timeUTC);
end