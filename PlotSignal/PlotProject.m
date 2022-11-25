clc;
clear;

arduinoObj = serialport("COM3",115200);
configureTerminator(arduinoObj,"CR/LF");
flush(arduinoObj);
arduinoObj.UserData = struct("Data",[],"IR",[],"RED",[],"TEMP",[],"Count",1);
configureCallback(arduinoObj,"terminator",@readArduinoData);

function readArduinoData(src, ~)

% Read the ASCII data from the serialport object.
data = readline(src);
data = split(data,',');

IR = data(1);
RED = data(2);
TEMP = data(3);

disp(IR)
% Convert the string data to numeric type and save it in the UserData
% property of the serialport object.
%src.UserData.Data(end+1) = str2double(data);

src.UserData.IR(end+1) = str2double(IR);
src.UserData.RED(end+1) = str2double(RED);
src.UserData.TEMP(end+1) = str2double(TEMP);

% Update the Count value of the serialport object.
src.UserData.Count = src.UserData.Count + 1;

% If 1001 data points have been collected from the Arduino, switch off the
% callbacks and plot the data.
if src.UserData.Count > 1001
    configureCallback(src, "off");
    plot(src.UserData.IR(2:end));
    %plot(app.UIAxes_2,src.UserData.RED(2:end));

end
end