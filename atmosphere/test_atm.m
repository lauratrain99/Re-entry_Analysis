

h = 0:1:300;

rho1 = (6*1e-13)*exp( - ( h - 120000 ) / 30500 ); 

for i = 1:length(h)
    [~, ~, ~, rho2(i)] = atmoscoesa2(h(i)*1000);
end

figure(1)
% plot(rho1,h,'r',rho2,h,'b')´´

figure(2)