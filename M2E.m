function [E] = M2E(M,e)
    
    err = 1e-10;                            % Error tolerance
    E0 = M;                                 % Initial guess for E
    flag = 1;
    
    while(flag) 
           E =  M + e*sind(E0);             % Kepler's equation
          if ( abs(E - E0) < err)
              flag = 0;
          end
          E0 = E;
    end
end

