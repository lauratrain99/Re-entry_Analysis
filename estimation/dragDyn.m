function der = dragDyn(t, x, TLE)
    mu = 398600;                                % [km^3/s^2]
    Re = 6371;
    wEarth = [ 0 0 2*pi/86164];
    r = x(1:3);
    v = x(4:6);
    
    h = norm(r) - Re;
    
%     rho  = (6*1e-13)*exp( - ( h - 200000 ) / 30000 );
    [~, ~, ~, rho] = atmoscoesa2(h*1000);
%     rho  = (6*1e-14)*exp( - ( h - 18000 ) / 4000 ); 
    
    vRel = (v - cross(wEarth',r));
    nvRel = norm(vRel); 
    
    Bc = interp1(TLE.timeJulian*24*3600,TLE.Bc,t);
    
    rDot = v;
    vDot = -(mu/norm(r)^3)*r - 1/2*rho*nvRel^2/Bc*(vRel/nvRel);
%     vDot = -(mu/norm(r)^3)*r;

    der = [rDot; vDot];

end