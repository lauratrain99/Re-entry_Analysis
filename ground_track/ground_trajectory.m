function [lat, lon, alt] = ground_trajectory(r_ECI, timeUTC)
    
    r_ECEF = r_ECI*0;
    lla = r_ECI*0;
    for i = 1:length(timeUTC)
        [r_ECEF(i,:)] = eci2ecef(utc_array(timeUTC(i)), r_ECI(i,:)*1000);
        lla(i,:) = ecef2lla(r_ECEF(i,:), 'WGS84');
    end
    
    lat = lla(:,1);
    lon = lla(:,2);
    alt = lla(:,3)/1000;
end