%% BE521 FINAL PROJECT
%  
%  Brain Computer Interface (BCI) Competition - Spring 2016
%  University of Pennsylvania
%  
%  - Prof. Brian Litt, MD
%  - Sung Min Ha
%  - Archana Ramachandran
%  - Brian Wright
%  
%  All code, data, and history is in a private repository:
%  http://www.github.com/usfbrian/bci

clear all; clc;

disp(' '); disp('Axon, You''re FIRED!')
disp(' ')
get_raw_data_from_ieeg;
process_raw_data;
calculate_r_matrix;
generate_analog_output;
prepare_analog_output_for_peak_detection;
convert_analog_output_to_digital_output_pulses;
create_output_shapes_for_each_finger;
place_shape_at_each_pulse;
show_results;
save_to_file;
disp('----------------------')
disp('No Errors Running Code')
