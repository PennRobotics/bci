%% SAMPLE AT EACH SAMPLING BIN
WINDOW_SIZE = 2000;   % Window size [ms]
WINDOW_TYPE = 'tukeywin';

% TODO(brwr): Is tukeywin the best window type for analog output sampling?
% TODO(brwr): Outputs need to be aligned with EEG activity
% TODO(brwr): Can width and amplitude of output be determined?
y1_delta = FnPeakSample(y1_norm, loc1, peaks1, WINDOW_SIZE, WINDOW_TYPE,    0);
y2_delta = FnPeakSample(y2_norm, loc2, peaks2, WINDOW_SIZE, WINDOW_TYPE,    0);
y3_delta = FnPeakSample(y3_norm, loc3, peaks3, WINDOW_SIZE, WINDOW_TYPE, -400);

%% MANUAL OVERRIDE OF INDIVIDUAL PEAKS   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%disp('S1');y1_delta = FnPeakSampleManual(y1_norm,loc1,WINDOW_SIZE,WINDOW_TYPE);
%disp('S2');y2_delta = FnPeakSampleManual(y2_norm,loc2,WINDOW_SIZE,WINDOW_TYPE);
%disp('S3');y3_delta = FnPeakSampleManual(y3_norm,loc3,WINDOW_SIZE,WINDOW_TYPE);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
