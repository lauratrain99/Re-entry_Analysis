function [h, isterminal, direction] = hFinal(t, x, TLE)

    h   = ~((norm(x(1:3)) - 6371) < 0.1);
    isterminal = 1;

    direction  = 0;

end