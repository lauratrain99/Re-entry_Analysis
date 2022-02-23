function [T, a, P, rho] = atmoscoesa2(height)
% ___________________
% 
% ATMOSCOESA2: Atmosphere model as described on 1976 US Standard Atmosphere documents.
%              https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19770009539.pdf
%     
%     INPUTS
%         height: List of heights over ground to evaluate the model at. Measured in meters.
% 
%     OUTPUTS
%         T: Temperature of surrounding air. Measured in Kelvin.
%         a: Speed of sound. Measured in m*s^-1.
%         P: Barometric pressure. Measured in Pascal.
%         rho: Density of surrounding air. Measured in kg*m^-3.
%         
%     EXAMPLE:
%         [T, a, P, rho] = atmoscoesa2(height)
%         
%         >> [T, a, P, rho] = atmoscoesa2(1337)
% 
%            T =
% 
%             279.4595
% 
%             a =
% 
%               335.1261
% 
%             P =
% 
%                8.6261e+04
% 
%             rho =
% 
%                 1.0753
% 
%     NOTES:
%         - Atmosphere parameters for over 105 km are calculated through a
%           linear interpolation of the model described in the documents.
% ___________________

    % Call helping methods.
    meth = coesa_methods;
    
    % Import variables from coesa_methods.
    R = meth.R;
    g0 = meth.g0;
    gamma = meth.gamma;
    
    TM = (meth.T_0);
    Pb = (meth.P_0);
    M_0 = meth.M_0;
    
    % Loop through atmosphere layers and calculate base pressure at the
    % beginning of the layer.
    for ii=1:length(meth.H)-1
        TM = [TM, TM(end) + meth.f_LM(meth.H(ii)).*(meth.H(ii+1)-meth.H(ii))];                                  %#ok<AGROW>
        if meth.f_LM(meth.H(ii)) == 0
            Pb = [Pb, Pb(end).*exp(-g0.*M_0.*(meth.H(ii+1)-meth.H(ii))./(R.*TM(end-1)))];                       %#ok<AGROW>
        else
            Pb = [Pb, Pb(end).*(TM(end-1)./(TM(end))).^(g0.*M_0./(R.*meth.f_LM(meth.H(ii))))];                  %#ok<AGROW>
        end
    end
    
    % Find layer base temperature of every height datapoint.
    h = (height);
    T = meth.f_tb(TM,h).*meth.f_Mr(h);
    
    % Find which datapoints are located in isothermal layers.
    zero_gradient = (meth.f_LM(h)==0);
    non_zero_gradient = (meth.f_LM(h)~=0);
    
    % Calculate pressure at every datapoint, taking into account the
    % temperature gradient of the layer they are in.
    P = zeros(size(h));
    P(zero_gradient) = meth.f_P(Pb,h(zero_gradient)).*exp(-g0.*M_0.*...
        (h(zero_gradient) - meth.f_H(h(zero_gradient)))./(R.*meth.f_TM(TM,h(zero_gradient))));
    P(non_zero_gradient) = meth.f_P(Pb,h(non_zero_gradient)).*(meth.f_TM(TM,h(non_zero_gradient))./...
        (meth.f_tb(TM,h(non_zero_gradient)))).^(g0.*M_0./(R.*meth.f_LM(h(non_zero_gradient))));
    
    % Calculate pressure and speed of sound at each height datapoint.
    rho = (P.*M_0)./(R.*meth.f_tb(TM,h));
    a = (gamma.*P./rho).^0.5;
end