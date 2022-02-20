function [array_format] = utc_array(utc_time)
    
    string = datestr(utc_time, 'yyyy-mm-dd HH:MM:SS');
    year = str2num(string(1:4));
    month = str2num(string(6:7));
    day = str2num(string(9:10));
    
    hour = str2num(string(12:13));
    min = str2num(string(15:16));
    sec = str2num(string(18:19));
    
    array_format = [year, month, day, hour, min, sec];
    
   
end