classdef coesa_methods
% ___________________
% 
% coesa_methods: Library of methods and constants used in ATMOSCOESA2. See ATMOSCOESA2 for more.
% ___________________

    properties (Constant)
        g0 = 9.80665;
        R = 8.31446;
        
        T_0 = 288.15;
        P_0 = 101325;
        M_0 = 28.9644e-3;
        gamma = 1.4;
        
        H = [0,11,20,32,47,51,71,86,91,104,107,109,110,120,150,200,300,500,750,1000,5000].*1e3;
        LM = [-6.5,0,1,2.8,0,-2.8,-2,0,1.645,4.935,6.5835,10.0115,12,9.396,4.7265,1.54345,...
            0.68,0.219345,6.5003e-3,1.0525e-4,0].*1e-3;
        
        H2 = [0, 79994.1, 80506.9, 81019.6, 81532.5, 82045.4, 82558.6, 83071.5,...
            83584.8, 84098.0, 84611.4, 85124.8, 86000, 120000, 150000, 450000];
        Mr = [1, 1, 0.999996, 0.999988, 0.999969, 0.999938, 0.999904, 0.999864,...
            0.999822, 0.999778, 0.999731, 0.999681, 0.999579, 0.904731, 0.772159, 0.526404];
    end
    
    methods(Static)
        function [LM] = f_LM(x)
            LM = interp1(coesa_methods.H,coesa_methods.LM,x,'previous',0);
        end
        function [Mr] = f_Mr(x)
            Mr = max(interp1(coesa_methods.H2,coesa_methods.Mr,x,'linear','extrap'),0);
        end
        function [TM] = f_TM(TM,x)
            TM = interp1(coesa_methods.H,TM,x,'previous','extrap');
        end
        function [p] = f_P(P,x)
            p = interp1(coesa_methods.H,P,x,'previous','extrap');
        end
        function [H] = f_H(x)
            H = interp1(coesa_methods.H,coesa_methods.H,x,'previous','extrap');
        end
        function [tb] = f_tb(TM,x)
            tb = interp1(coesa_methods.H,TM,x,'previous','extrap') + ...
                interp1(coesa_methods.H,coesa_methods.LM,x,'previous',0).*...
                (x-interp1(coesa_methods.H,coesa_methods.H,x,'previous','extrap'));
        end
    end
end