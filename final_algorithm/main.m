disp('Make sure to grep -Hrn "TODO" before submitting to Canvas!') % TODO(brwr)

%% BE521 FINAL PROJECT
%  
%  Brain Computer Interface (BCI) Competition - Spring 2016
%  University of Pennsylvania
%  
%  - Prof. Brian Litt
%  - Sung Min Ha
%  - Archana Ramachandran
%  - Brian Wright
%  
 
disp('Axon, You''re FIRED!')
disp(' ')

clear all; clc;


% TODO(brwr): Double check ieeg code
get_raw_data_from_ieeg;
process_raw_data;
calculate_r_matrix;
generate_analog_output;
predict_finger_for_each_trial;
convert_analog_output_to_digital_output_pulses;
create_output_shape_per_finger;
place_shape_at_each_pulse;
save_to_file;

%TODO(brwr): submission mfile

