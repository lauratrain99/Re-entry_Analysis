function [orb_elements, timeUTC, timeJulian, ballistic_coeff] = TLE_parse(file)
    
    % Open the file in read mode
    fid = fopen(file, 'rb');
    
    % Set up a counter to store all TLEs
    counter = 0;
    
    % Parse one TLE
    L1 = fscanf(fid,'%d%6d%*c%5d%*3c%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
    L2 = fscanf(fid,'%d%6d%f%f%f%f%f%f%f',[1,9]);
    
    % Orbital constant
    mu = 398600;                                % [km^3/s^2]
    
    % Initialize orbital elements matrix
    orb_elements = [0, 0, 0, 0, 0, 0];
    
    % stay in the loop while there are TLEs to read
    while (~isempty(L2))
        
        % Parse TLE elements
        epoch = L1(1,4);                        % Epoch Date and Julian Date Fraction
        Bc    = L1(1,5);                        % Ballistic Coefficient
        inc   = L2(1,3);                        % Inclination [deg]
        RAAN  = L2(1,4);                        % Right Ascension of the Ascending Node [deg]
        e     = L2(1,5)/1e7;                    % Eccentricity 
        w     = L2(1,6);                        % Argument of periapsis [deg]
        M     = L2(1,7);                        % Mean anomaly [deg]
        n     = L2(1,8);                        % Mean motion [Revs per day]

        % Compute semi-major axis
        a = (mu/(n*2*pi/(24*3600))^2)^(1/3);    % [km]  
        
        % Compute eccentric anomaly 
        [E] = M2E(M,e);
        
        % Compute true anomaly
        [theta] = E2theta(E,e);

        % Six orbital elements 
        counter = counter+1;
        
        % Store orbital elements
        orb_elements(counter,:) = [a e inc RAAN w rad2deg(theta)];
        ballistic_coeff(counter) = Bc;

        % Parse one TLE
        L1 = fscanf(fid,'%d%6d%*c%5d%*3c%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
        L2 = fscanf(fid,'%d%6d%f%f%f%f%f%f%f',[1,9]);
        
        [timeUTC(counter), timeJulian(counter)] = utc_julian(epoch);

    end
    
    % Close the file
    fclose(fid);
    
end