clc

% Define serial port for live transfer
serial_port_live = serialport("/dev/cu.usbmodem14201", 9600);  % Adjust serial port as needed

% Prompt the user for an angle input
angle_input = input('Enter the angle: ');

% Initialise empty arrays
sensornums = [];
distances = [];
timestamps = [];

try
    tic;  % Start timer

    while toc <= 15  % Continue reading for 15 seconds
        % Read data from live serial port
        data_live = readline(serial_port_live);  % Read data from serial port
        
        % Split the data into sensor number and distance
        data_parts = strsplit(data_live, ': ');
        sensornum_str = data_parts{1};
        distance_str = data_parts{2};
        
        % Convert sensor number and distance to numeric values
        sensornum = str2double(sensornum_str);
        distance = str2double(distance_str);
        
        % Store sensor number, distance, and timestamp data
        sensornums = [sensornums, sensornum];
        distances = [distances, distance];
        timestamps = [timestamps, datetime('now','Format','hh:mm:ss')];  % Add current timestamp
        
        % Display sensor number, distance, and timestamp
        disp(['Time: ', char(timestamps(end)), ', Angle: ', num2str(angle_input), ', Sensor: ', num2str(sensornum), ', Distance: ', num2str(distance)]);
        
        % Add a delay to prevent flooding the serial port
        pause(0.1);
    end
    
    disp('Closing serial port.');
    clear serial_port_live;  % Close serial port
    
    % Write sensor number, distances, timestamps, and angle input to a CSV file
    file_path = 'data.csv';  % Define file path
    file = fopen(file_path, 'w');  % Open file for writing
    
    % Write header
    fprintf(file, 'Timestamp,Angle,Sensor,Distance\n');
    
    % Write data
    for i = 1:length(distances)
        fprintf(file, '%s,%f,%f,%f\n', datenum(timestamps(i)), angle_input, sensornums(i), distances(i));
    end
    
    fclose(file);  % Close file
    disp(['Data written to ', file_path]);
    
catch e
    disp('Error occurred.');
end
