function [utc, julian] = utc_julian(tle_time)
    
    a = char(string(tle_time));
    
    year = str2num(strcat('20',a(1:2)));
    rest = str2num(a(3:end));
    
    julian = juliandate([year,1,1,0,0,0]) + rest - 1;
    utc = datetime(julian,'convertfrom','juliandate');
    
   
end