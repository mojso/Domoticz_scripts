-- Blinds dimmer script using ESPEasy 
-- This script was created by mojso
-- https://github.com/mojso/Domoticz_scripts

-- 1. put the script in Events as Lua script
-- 2.in setup -> more option --> user variable put in variable name dimmer -- , variable type string and update
-- 3.Setup -> Hardware  dymmy device 
--create virtual device,  Select rgb switch,  
-- Then in Switches find the created device end click edit. -- then in switch type select blinds precentage and save

commandArray = {}
DomDevice = 'Blinds';   -- device name
IP = '192.168.1.149';
Stopsignal = '9000';
PIN = "12"; -- D6 WEMOS PIN 12

if devicechanged[DomDevice] then
   if(devicechanged[DomDevice]=='Off') then
        print ("OFF dim = "..uservariables['dimmer']);
        CalcValue = 0;  -- default 0
    else if(devicechanged[DomDevice]=='On') then
        DomValue = uservariables['dimmer'];
        print ("ON dim = "..uservariables['dimmer']);
        CalcValue = DomValue;
    else
        print("Other");
        DomValue = otherdevices_svalues[DomDevice];
        CalcValue = math.floor(DomValue / 100 * 180);
        commandArray['Variable:dimmer'] = tostring(CalcValue);
        print ("dim Level = "..uservariables['dimmer']);
    end
    end
    runcommand = "curl 'http://" .. IP .. "/control?cmd=Servo,1,"  ..PIN.. "," .. CalcValue .. "'";
    os.execute(runcommand);
    print("Servo value= "..CalcValue);
    local delay = 2
  runcommand2 =  "curl 'http://" .. IP .. "/control?cmd=Servo,1,"  ..PIN.. "," .. Stopsignal .. "'";
   os.execute('(sleep '..delay..';' ..runcommand2.. ')');
end
return commandArray
