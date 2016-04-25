%%
% <latex> 
% \title{BE 521: Homework 8 \\{\normalsize p300 Speller} \\{\normalsize Spring 2016}}
% \author{34 points}
% \date{Due: 4/07/2016 11:59 PM}
% \maketitle \textbf{Objective:} Spell letters using neurosignals
% </latex>

%% 
% <latex> 
% \begin{center} \author{Sung Min Ha \\
%   \normalsize Collaborators: Michael Minehan \\}
% \end{center} 
% </latex>

%% 
% <latex> 
% \subsection*{P300 Speller}
% In this homework, you will work with data from a P300-based brain computer interface called BCI2000 (Schalk et al. 2004) that allows people to spell words by focusing their attention on a particular letter displayed on the screen. In each trial the user focused on a letter, and when that letter's row or column is flashed, the user's brain elicits a P300 evoked response. By analyzing whether a P300 signal was produced, across the flashes of many different rows or columns, the computer can determine the letter that the person is focusing on.
% </latex>

%% 
% <latex> 
% Figure 1 shows the letter matrix from one trial of this task.
% \begin{figure}
%  \centering
%  \includegraphics[width=0.3\textwidth]{letterMat}
%  \caption{The letter matrix for the P300 speller with the third row illuminated.
%           If the user were focusing on any of the letters in the third row (M, N, O, P, Q, or R),
%           their brain would emit a P300 response. Otherwise it would not.}
% \end{figure}
% </latex>

%% 
% <latex> 
% \subsection*{Data Organization}
% The data for this homework is stored in \verb|I521_A0008_D001| on the IEEG Portal.
% The EEG in this dataset were recorded during 85 intended letter spellings. For each letter spelling, 12 row/columns were flashed 15 times in random order ($12 \times 15 = 180$ iterations). The EEG was recorded with a sampling rate of 240 Hz on a 64-channel scalp EEG.\\
% </latex>

%% 
% <latex> 
% The annotations for this dataset are organized in two layers as follows:
% \begin{itemize}
%     \item \verb|TargetLetter| annotation layer indicates the target
%     letter (annotation.description) on which the user was focusing
%     during the recorded EEG segment
%     (annotation.start/annotation.stop). This layer is also provided
%     as TargetLetterAnnots.mat.
%     \item \verb|Stim| annotation layer indicates the row/column that
%     is being flashed (annotation.description) and whether the target
%     letter is contained in that flash (annotation.type). The
%     recorded EEG during that flash is
%     (annotation.start/annotation.stop). Note that this annotation
%     layer is provided as StimAnnots.mat. It is NOT on the portal.
% \end{itemize}
% Hints: There are many annotations in this dataset and getting them all may take ~5-10 minutes. Once you retrieve the annotations once, save them for faster loading in the future. Also, use $\verb|{ }|$ to gather variables across structs for easier manipulation (e.g. $\verb|strcmp({annotations.type},'1')|$) \\
% </latex>

%% 
% <latex> 
% \begin{figure}
%  \centering
%  \includegraphics[width=0.3\textwidth]{letterMatInds}
%  \caption{The row/column indices of the letter matrix, as encoded in the \textbf{Stim} annotation layer (annotation.description) matrix.}
% \end{figure}
% </latex>

%% 
% <latex> 
% \subsection*{Topographic EEG Maps}
% You can make topographic plots using the provided \verb|topoplotEEG| function. This function needs an ``electrode file.'' and can be called like
% \begin{lstlisting}
%  topoplotEEG(data,'eloc64.txt','gridscale',150)
% \end{lstlisting}
% where \verb|data| is the value to plot for each channel. This function plots the electrodes according to the map in Figure 3.
% \begin{figure}
%  \centering
%  \includegraphics[width=\textwidth]{scalpEEGChans}
%  \caption{The scalp EEG 64-channel layout.}
% \end{figure}
% </latex> 

%% 
% <latex> 
% \pagebreak
% \section{Exploring the data}
% In this section you will explore some basic properties of the data in \verb|I521_A0008_D001|.
% </latex> 

%% 
% <latex> 
% \begin{enumerate}
% </latex> 

%% 
% <latex> 
%  \item For channel 11 (Cz), plot the mean EEG for the target and non-target stimuli separately, (i.e. rows/columns including and not-including the desired character, respectively), on the same set of axes. Label your x-axis in milliseconds. (3 pts)
% </latex> 

%% Student-divided Section; Import Data
% Importing Data
clear all;
close all;
addpath(genpath('c:/Users/sungm/ieeg-matlab-1.13.2'));
session = IEEGSession('I521_A0008_D001', 'hasm', 'has_ieeglogin.bin');
samp_rate = session.data.sampleRate; %Hz
samp_rate_micros = samp_rate * 1.0e-6;
durationInUSec = session.data.rawChannels(1).get_tsdetails.getDuration; %microseconds
durationInSec = durationInUSec / (1e6);
nr = ceil((session.data.rawChannels(1).get_tsdetails.getEndTime)/(1e6)*session.data.sampleRate);
eeg = ones(nr, length(session.data.rawChannels)) .* (-1);
for index = 1:length(session.data.rawChannels)
    sprintf('\n%d out of %d', index, length(session.data.rawChannels))
    %commented out for now; import matlab.mat file instead while working
    %on homework; uncomment only at end for submission run
    eeg(1:nr, index) = session.data.getvalues(1:(nr), index:index);
end

% import annotation - Only run necessary, commented out for speeding up
stim_annot = importdata('StimAnnots.mat');
target_annot = importdata('TargetLetterAnnots.mat');

%% Student-Divided Section: Problem 1 Getting 11th channel
chan11 = eeg(:, 11);

chan11_type0 = [];
chan11_type1 = [];

chan11_start_stop = zeros(length(stim_annot), 2);
chan11_start_stop_index = zeros(length(stim_annot), 2);
for index = 1:1:length(stim_annot)
    chan11_start_stop(index, 1) = stim_annot(index).start; %microsecond
    chan11_start_stop(index, 2) = stim_annot(index).stop; %microsecond
    chan11_start_stop_index(index, 1) = stim_annot(index).start * samp_rate_micros;
    chan11_start_stop_index(index, 2) = stim_annot(index).stop * samp_rate_micros;
end
chan11_start_stop_index_int = round(chan11_start_stop_index);


for index = 1:1:length(stim_annot)
%     time_start = stim_annot(index).start;
%     time_stop = stim_annot(index).stop;
    if (stim_annot(index).type == '0')
%         if (round(samp_rate_micros * time_start) < 1)
%             time_start = 1/samp_rate_micros;
%         end
        if (length(chan11_type0) == 0)
            chan11_type0 = chan11(chan11_start_stop_index_int(index, 1)+1:chan11_start_stop_index_int(index, 2))';
        else
        chan11_type0 = [chan11_type0; chan11(chan11_start_stop_index_int(index, 1)+1:chan11_start_stop_index_int(index, 2))'];
        end
    elseif (stim_annot(index).type == '1')
%         if (round(samp_rate_micros * time_start) < 1)
%             time_start = 1/samp_rate_micros;
%         end
        if (length(chan11_type1) == 0)
            chan11_type1 = chan11(chan11_start_stop_index_int(index, 1)+1:chan11_start_stop_index_int(index, 2))';
        else
        chan11_type1 = [chan11_type1; chan11(chan11_start_stop_index_int(index, 1)+1:chan11_start_stop_index_int(index, 2))'];
        end
    end
end

chan11_type0_mean = sum(chan11_type0) ./ length(chan11_type0(:, 1));

chan11_type1_mean = sum(chan11_type1) ./ length(chan11_type1(:, 1));

time_micros = linspace(chan11_start_stop(1, 1), chan11_start_stop(1, 2), length(chan11_type0_mean));
time_millis = time_micros .* 1.0e-3;

figure;
plot(time_millis, chan11_type0_mean, 'b-', time_millis, chan11_type1_mean, 'r-');
legend('non target', 'target');
xlabel('time (millisecond)');
ylabel('EEG (mV)');
title('Channel 11 (Cz) non_target and target mean EEG plots');
%% 
% <latex> 
%  \item Repeat the previous questions for channel 23 (Fpz). (1 pts)
% </latex> 

%%
chan23 = eeg(:, 23);
chan23_type0 = [];
chan23_type1 = [];

chan23_start_stop = zeros(length(stim_annot), 2);
chan23_start_stop_index = zeros(length(stim_annot), 2);
for index = 1:1:length(stim_annot)
    chan23_start_stop(index, 1) = stim_annot(index).start; %microsecond
    chan23_start_stop(index, 2) = stim_annot(index).stop; %microsecond
    chan23_start_stop_index(index, 1) = stim_annot(index).start * samp_rate_micros;
    chan23_start_stop_index(index, 2) = stim_annot(index).stop * samp_rate_micros;
end
chan23_start_stop_index_int = round(chan23_start_stop_index);


for index = 1:1:length(stim_annot)
%     time_start = stim_annot(index).start;
%     time_stop = stim_annot(index).stop;
    if (stim_annot(index).type == '0')
%         if (round(samp_rate_micros * time_start) < 1)
%             time_start = 1/samp_rate_micros;
%         end
        if (length(chan23_type0) == 0)
            chan23_type0 = chan23(chan23_start_stop_index_int(index, 1)+1:chan23_start_stop_index_int(index, 2))';
        else
        chan23_type0 = [chan23_type0; chan23(chan23_start_stop_index_int(index, 1)+1:chan23_start_stop_index_int(index, 2))'];
        end
    elseif (stim_annot(index).type == '1')
%         if (round(samp_rate_micros * time_start) < 1)
%             time_start = 1/samp_rate_micros;
%         end
        if (length(chan23_type1) == 0)
            chan23_type1 = chan23(chan23_start_stop_index_int(index, 1)+1:chan23_start_stop_index_int(index, 2))';
        else
        chan23_type1 = [chan23_type1; chan23(chan23_start_stop_index_int(index, 1)+1:chan23_start_stop_index_int(index, 2))'];
        end
    end
end

chan23_type0_mean = sum(chan23_type0) ./ length(chan23_type0(:, 1));

chan23_type1_mean = sum(chan23_type1) ./ length(chan23_type1(:, 1));

time_micros = linspace(chan23_start_stop(1, 1), chan23_start_stop(1, 2), length(chan23_type0_mean));
time_millis = time_micros .* 1.0e-3;

figure;
plot(time_millis, chan23_type0_mean, 'b-', time_millis, chan23_type1_mean, 'r-');
legend('non target', 'target');
xlabel('time (millisecond)');
ylabel('EEG (mV)');
title('Channel 23 (Fpz) non_target and target mean EEG plots');
%% 
% <latex> 
%  \item Which of the two previous channels looks best for distinguishing between target and non-target stimuli? Which time points look best? Explain in a few sentences. (2 pts)
% </latex> 

%%
% <latex>
% It seems that both channels seem to clearly have a pattern to distinguish
% the target vs non target, channel 11 would prove to be slightly more
% effective for distinguishment because the amplitude difference between
% the max of target to the baselines of the two is greater, approximately
% 3.5 to 4 mV vs 2 to 2.5 mV difference in channel 23. The time points at
% approximately 150 to 550 millisecond marks would be best for
% distinguishment because the target plot peaks up and while non target
% actually falls below its baseline. Thus, finding the whether a plot peaks
% up significantly above its baseline or falls slightly below its baseline
% will act a criteria to determine whether the stimulation is the target or
% not.
% </latex>

%% 
% <latex> 
%  \item Compute the mean difference between the target and non-target stimuli for each channel at timepoint 300 ms averaged across all row/column flashes. Visualize these values using the \verb|topoplotEEG| function. Include a colorbar. (3 pts)
% </latex> 

%%
index_300ms = 300 * 1.0e3 * samp_rate_micros;

type0 = zeros(length(stim_annot), length(eeg(1,:)));
type1 = zeros(length(stim_annot), length(eeg(1,:)));
index_table_300ms = [];
type0_300ms_count = zeros(1, length(eeg(1, :)));
type1_300ms_count = zeros(1, length(eeg(1, :)));
type_all = ones(length(stim_annot), length(eeg(1,:))) .* (-1);
for channel = 1:1:length(eeg(1, :))

    for index = 1:1:length(stim_annot)
        
        type_all(index, channel) = str2num(stim_annot(index).type);
        
        if stim_annot(index).type == '0'
            type0_300ms_count(1, channel) = type0_300ms_count(1, channel) + 1;
            type0(index, channel) = eeg(round(stim_annot(index).start * samp_rate_micros) + ...
                index_300ms, channel)';

            %             index_table_300ms = [index_table_300ms, round(stim_annot(index).start * samp_rate_micros) + index_300ms];
        elseif stim_annot(index).type == '1'
            type1_300ms_count(1, channel) = type1_300ms_count(1, channel) + 1;
            type1(index, channel) = eeg(round(stim_annot(index).start * samp_rate_micros) + ...
                index_300ms, channel)';
%             index_table_300ms = [index_table_300ms, round(stim_annot(index).start * samp_rate_micros) + index_300ms];
        end
    end
end
for index = 1:1:length(stim_annot)
    index_table_300ms = [index_table_300ms, round(stim_annot(index).start * ...
        samp_rate_micros) + index_300ms];
end

for channel = 1:1:length(eeg(1, :))
    type0_temp = type0(:, channel);
    type1_temp = type1(:, channel);
    type0_trim(1:length(type0_temp(type_all(:, channel) == 0)), channel) = type0_temp(type_all(:, channel) == 0);
    type1_trim(1:length(type1_temp(type_all(:, channel) == 1)), channel) = type1_temp(type_all(:, channel) == 1);
end

mean_diff = zeros(1, length(eeg(1, :)));
for channel = 1:1:length(eeg(1, :))
    mean_type0 = sum(type0_trim(:, channel))/length(type0_trim(:, channel));
    mean_type1 = sum(type1_trim(:, channel))/length(type1_trim(:, channel));
    mean_diff(channel) = mean_type1 - mean_type0;
end

figure;
topoplotEEG(mean_diff);
colorbar;
%% 
% <latex> 
%  \item How do the red and blue parts of this plot correspond to the plots from above? (2 pts)
% </latex> 

%%
% <latex>
% I noted that amplitude difference in channel 11 is more significant for
% differentiating target vs non target than the difference in channel 23.
% Just as I noted, channel 11, located at the center, has color closer to
% red than channel 23, located at the front of the head.
% </latex>

%% 
% <latex> 
% \end{enumerate}
% \section{Using Individual P300s in Prediction}
% Hopefully the Question 1.4 convinced you that the Cz channel is a reasonably good channel to use in separating target from non-target stimuli in the P300. For the rest of the homework, you will work exclusively with this channel. 
% \begin{enumerate}
%  \item Explain a potential advantage to using just one channel other than the obvious speed of calculation advantage. Explain one disadvantage. (3 pts)
% </latex> 

%%
% <latex>
% One advantage other than calculational expenses is that there are less
% chance of overfitting when working with a single electrode instead of all
% 64. A model that weight and determine an output based on all 64 may have
% its decision clouded by non-related factors from various electrodes that
% do not have any significance in distinguishing target vs nontarget. It is
% important to note that more complex models do not necessasrily perform
% better than simpler models because of such risk of overfitting.
% One disadvantage is that the single electrode may not be capable of
% covering all of the spatial regions of interest for detecting the target
% vs non target distinguishment. Whereas a model that takes into account
% multiple electrodes across the area may be able to weigh and distinguish
% correctly even if the signal is prominent in regions close to channel 11
% electrode, channel 11 electrode alone may not be able to distinguish
% correctly if a prominent mean difference is found in nearby electrode's
% region and not channel 11's.
% </latex>

%% 
% <latex> 
%  \item One simple way of identifying a P300 in a single trial (which we'll call the \emph{p300 score}) is to take the mean EEG from 250 to 450 ms and then subtract from it the mean EEG from 600 to 700 ms. What is the 	\emph{p300 score} for epoch (letter) 10, iteration 11 at electrode Cz? (3 pts)
% </latex>

%%
epoch_length = length(chan11) / 85;
index250 = round(250 * 1.0e3 * samp_rate_micros);
index450 = round(450 * 1.0e3 * samp_rate_micros);
index600 = round(600 * 1.0e3 * samp_rate_micros);
index700 = round(700 * 1.0e3 * samp_rate_micros);
chan11_epoch = zeros(epoch_length, 85); % each column is an epoch
index_epoch = zeros(85, 2);
for epoch = 1:1:85
    chan11_epoch(:, epoch) = chan11((epoch-1)*epoch_length+1:epoch*epoch_length);
    index_epoch(epoch, 1) = (epoch-1)*epoch_length+1;
    index_epoch(epoch, 2) = epoch * epoch_length;
end

iteration_length = length(chan11_epoch(:, 1)) / 180;
index_iteration = zeros(180 ,2);
for iteration = 1:1:180
    index_iteration(iteration, 1) = 1 + (iteration - 1) * iteration_length;
    index_iteration(iteration, 2) = iteration * iteration_length;
end

chan11_10_11_250_450 = chan11_epoch(index_iteration(11, 1) + index250-1:index_iteration(11, 1) + index450-1, 10);
chan11_10_11_600_700 = chan11_epoch(index_iteration(11, 1) + index600-1:index_iteration(11, 1) + index700-1, 10);
chan11_10_11_250_450_mean = mean(chan11_10_11_250_450);
chan11_10_11_600_700_mean = mean(chan11_10_11_600_700);
p300_10_11 = -(chan11_10_11_600_700_mean - chan11_10_11_250_450_mean);

%%
% <latex>
% p300 score for epoch 10 iteration 11 is 1.4996.
% </latex>
%% 
% <latex> 
%  \item Plot the \emph{p300 scores} for each row/column in epoch 20 at electrode Cz. (3 pts)
% </latex>

%%
chan11_20_250_450 = zeros(length(index_iteration(11, 1) + index250-1:index_iteration(11, 1) + index450)-1, 12 * 15);
chan11_20_600_700 = zeros(length(index_iteration(11, 1) + index600-1:index_iteration(11, 1) + index700)-1, 12 * 15);
chan11_20_rowcol = zeros(1, 12 * 15);

for index = 1:1:180
    chan11_20_250_450(:, index) = chan11_epoch(index_iteration(index, 1) + index250-1:index_iteration(index, 1) + index450-1, 20);
    chan11_20_600_700(:, index) = chan11_epoch(index_iteration(index, 1) + index600-1:index_iteration(index, 1) + index700-1, 20);
    chan11_20_rowcol(1, index) = str2num(stim_annot(index+epoch_length/240 * (20-1)).description);
end 
% for attempt  = 1:1:15
%     for rowcol = 1:1:12
%         chan11_20_250_450(:, rowcol + (attempt-1)*12) = chan11_epoch(index_iteration(rowcol + (attempt-1)*12, 1) + index250-1:index_iteration(rowcol + (attempt-1)*12, 1) + index450-1, 20);
%         chan11_20_600_700(:, rowcol + (attempt-1)*12) = chan11_epoch(index_iteration(rowcol + (attempt-1)*12, 1) + index600-1:index_iteration(rowcol + (attempt-1)*12, 1) + index700-1, 20);
%         chan11_20_rowcol(1, rowcol + (attempt-1)*12) = str2num(stim_annot(rowcol + (attempt-1)*12).description);
%     end
% end

chan11_20_250_450_mean = mean(chan11_20_250_450, 1);
chan11_20_600_700_mean = mean(chan11_20_600_700, 1);
p300_20_mean = -(chan11_20_600_700_mean - chan11_20_250_450_mean);

p300_20_mean_average_attempt = zeros(12, 1);
for rowcol = 1:1:length(p300_20_mean_average_attempt)
    p300_20_mean_average_attempt(rowcol) = mean(p300_20_mean(chan11_20_rowcol == rowcol));
end
% 
% p300_20_mean_temp = p300_20_mean;
% p300_20_mean_real = ones(size(p300_20_mean_temp));
% for index = 1:1:length(p300_20_mean_temp)
%     for attempt = 1:1:15
%         for rowcol = 1:1:12
%             for rowcolcheck = 1:1:12
%                 if (rowcol == chan11_20_rowcol((attempt-1)*12+rowcolcheck))
%                     p300_20_mean_real(1, (attempt-1)*12 + rowcol) = p300_20_mean_temp(1, (attempt-1)*12 + rowcolcheck);
%                 end
%             end
%         end
%     end
% end
% p300_20_mean = p300_20_mean_real;

% chan11_20_250_450_mean_per_attempt = zeros(12, 15);
% chan11_20_600_700_mean_per_attempt = zeros(12, 15);
% for attempt = 1:1:15
%     for rowcol = 1:1:12
        %         chan11_20_250_450_mean_per_attempt(rowcol, attempt) = chan11_20_250_450_mean(rowcol + (attempt-1)*12);
        %         chan11_20_600_700_mean_per_attempt(rowcol, attempt) = chan11_20_600_700_mean(rowcol + (attempt-1)*12);
%         p300_20_mean_per_attempt(rowcol, attempt) = p300_20_mean(rowcol + (attempt-1)*12);
%     end
% end
% p300_20_mean_per_attempt = -(chan11_20_600_700_mean_per_attempt - chan11_20_250_450_mean_per_attempt);
% p300_20_mean_average_attempt = mean(p300_20_mean_per_attempt, 2 );

figure;
hold on;
% plot(1:1:12, p300_20_mean_per_attempt, 'r.');
plot(1:1:12, p300_20_mean_average_attempt, 'bo');
xlabel('row or column index, from 1 to 12');
ylabel('p300 score');

title('p300 score of epoch 20 from channel 11, per row/column');
% legend('Per Attempt', 'averaged all attempts');
%% 
% <latex> 
%  \item Based on your previous answer for epoch 20, what letter do you predict the person saw? Is this prediction correct? (2 pts)
% </latex>

%%
target_annot(20).description
%%
% <latex>
% Data suggests that the row is four and the column is seven. So the letter
% predicted by p300 is D. This is in agreement with the actual letter, D.
% </latex>
%% 
% <latex> 
%  \item Using this \emph{p300 score}, predict (and print out) the letter viewed at every epoch. What was you prediction accuracy? (2 pts)
% </latex>

%%

chan11_250_450 = ones(length(index_iteration(11, 1) + index250:index_iteration(11, 1) + index450), 12 * 15, 85) .* (-1);
chan11_600_700 = ones(length(index_iteration(11, 1) + index600:index_iteration(11, 1) + index700), 12 * 15, 85) .* (-1);

chan11_rowcol = zeros(1, 12 * 15, 85);
for epoch_index = 1:1:85
    for index = 1:1:180
        chan11_250_450(:, index, epoch_index) = chan11_epoch(index_iteration(index, 1) + index250-1:index_iteration(index, 1) + index450-1, epoch_index);
        chan11_600_700(:, index, epoch_index) = chan11_epoch(index_iteration(index, 1) + index600-1:index_iteration(index, 1) + index700-1, epoch_index);
        chan11_rowcol(1, index, epoch_index) = str2num(stim_annot(index+epoch_length/240 * (epoch_index-1)).description);
    end
end

chan11_250_450_mean = mean(chan11_250_450, 1);
chan11_600_700_mean = mean(chan11_600_700, 1);
p300_mean = -(chan11_600_700_mean - chan11_250_450_mean);

p300_mean_average_attempt = zeros(12, 1, 85);
for epoch_index = 1:1:85
    for rowcol = 1:1:length(p300_mean_average_attempt(:, :, 1))
        temp_all = p300_mean(:, :, epoch_index);
        temp = temp_all(chan11_rowcol(:, :, epoch_index) == rowcol);
        p300_mean_average_attempt(rowcol, 1, epoch_index) = mean(temp);
    end
end
%
% for epoch_index = 1:1:85
%     for attempt = 1:1:15
%         for rowcol = 1:1:12
%             chan11_250_450(:, rowcol + (attempt-1)*12, epoch_index) = chan11_epoch(index_iteration(rowcol + (attempt-1)*12, 1) + index250:index_iteration(rowcol + (attempt-1)*12, 1) + index450, epoch_index);
%             chan11_600_700(:, rowcol + (attempt-1)*12, epoch_index) = chan11_epoch(index_iteration(rowcol + (attempt-1)*12, 1) + index600:index_iteration(rowcol + (attempt-1)*12, 1) + index700, epoch_index);
%         end
%     end
% end
% 
% chan11_250_450_mean = ones(1, 180, 85) .* -1;
% chan11_600_700_mean = ones(1, 180, 85) .* -1;
% p300_mean = ones(1, 180, 85) .* -1;
% for epoch_index = 1:1:85
%     %sprintf('epoch_index = %d', epoch_index)
%     for iteration_index = 1:1:180
%         chan11_250_450_mean(1, iteration_index, epoch_index) = mean(chan11_250_450(:, iteration_index, epoch_index));
%         chan11_600_700_mean(1, iteration_index, epoch_index) = mean(chan11_600_700(:, iteration_index, epoch_index));
%     end
%     p300_mean(1, :, epoch_index) = -(chan11_600_700_mean(1, :, epoch_index) - chan11_250_450_mean(1, :, epoch_index) );
% end
% 
% p300_mean_temp = p300_mean;
% for epoch_index = 1:1:85
%     for index = 1:1:length(p300_mean_temp)
%         for attempt = 1:1:15
%             for rowcol = 1:1:12
%                 for rowcolcheck = 1:1:12
%                     if (rowcolcheck == chan11_20_rowcol((attempt-1)*rowcol + 1))
%                         p300_mean(1, (attempt-1)*rowcol + 1, epoch_index) = p300_mean_temp(1, rowcolcheck, epoch_index);
%                     end
%                 end
%             end
%         end
%     end
% end
% p300_mean_per_attempt = zeros(12, 15, 85);
% p300_mean_average_attempt = zeros(12, 1, 85);
% for epoch_index = 1:1:85
%     for attempt = 1:1:15
%         for rowcol = 1:1:12
%             p300_mean_per_attempt(rowcol, attempt, epoch_index) = p300_mean(1, rowcol + (attempt-1)*12, epoch_index);
%         end
%     end
% end
% p300_mean_average_attempt = mean(p300_mean_per_attempt, 2 );
% 
% 
% chan11_250_450_mean_per_attempt = zeros(12, 15, 85);
% chan11_600_700_mean_per_attempt = zeros(12, 15, 85);
% for epoch_index = 1:1:85
%     for attempt = 1:1:15
%         for rowcol = 1:1:12
%             chan11_250_450_mean_per_attempt(rowcol, attempt, epoch_index) = chan11_250_450_mean(1, rowcol + (attempt-1)*12, epoch_index);
%             chan11_600_700_mean_per_attempt(rowcol, attempt, epoch_index) = chan11_600_700_mean(1, rowcol + (attempt-1)*12, epoch_index);
%         end
%     end
% end
% p300_mean_per_attempt = chan11_600_700_mean_per_attempt - chan11_250_450_mean_per_attempt;
% p300_mean_average_attempt = mean(p300_mean_per_attempt, 2 );

row_epoch = zeros(1, 85);
col_epoch = zeros(1, 85);

for epoch_index = 1:1:85
    index_large = 7;
    greatest = -1.0e10;
    for row = 1:1:6
        if p300_mean_average_attempt(row, 1, epoch_index) > greatest
            greatest = p300_mean_average_attempt(row, 1, epoch_index);
            index_large = row;
        end
    end
    row_epoch(1, epoch_index) = index_large;
end

for epoch_index = 1:1:85
    index_large = 13;
    greatest = -1.0e10;
    for col = 7:1:12
        if p300_mean_average_attempt(col, 1, epoch_index) > greatest
            greatest = p300_mean_average_attempt(col, 1, epoch_index);
            index_large = col;
        end
    end
    col_epoch(1, epoch_index) = index_large;
end
% 
% colorhsv = hsv(85);
% figure;
% hold on;
% for  epoch_index = 1:1:85
%     hold on;
%     plot(1:1:12, p300_mean_average_attempt(:, 1, epoch_index), 'LineStyle', 'none', 'Marker', 'o', 'Color', colorhsv(epoch_index, :));
%     hold on;
%     %legend(sprintf('%d-th epoch', epoch_index));
%     hold on;
% end
% 
% xlabel('row/column out of 12');
% ylabel('p300 score');
% title('p300 score for all 85 epoch');

ref_matrix = ['A', 'B', 'C', 'D', 'E', 'F';...
    'G', 'H', 'I', 'J', 'K', 'L';...
    'M', 'N', 'O', 'P', 'Q', 'R';...
    'S', 'T', 'U', 'V', 'W', 'X';...
    'Y', 'Z', '1', '2', '3', '4';...
    '5', '6', '7', '8', '9', '_'];
    

id_matrix = [row_epoch; col_epoch];
% letter_matrix = cell(1, length(id_matrix));
target_matrix = str2mat(strcat({target_annot.description},''));
predicted_matrix = cell(1, length(id_matrix));
for index = 1:1:length(id_matrix)
    predicted_matrix{index} = ref_matrix(id_matrix(2, index)-6, id_matrix(1, index));
end
predicted_matrix = str2mat(predicted_matrix);
matching = zeros(1, 85);
for letter = 1:1:length(predicted_matrix)
    matching(letter) = strcmp(predicted_matrix(letter), target_matrix(letter));
end
accuracy = sum(matching)/length(matching);

sprintf('The predicted letters are\t%s', predicted_matrix)
sprintf('The actual letters are\t\t%s', target_matrix)
sprintf('Accuracy was %d percent', accuracy * 100)
%% 
% <latex> 
% \end{enumerate}
% \section{Automating the Learning}
% In Section 2, you used a fairly manual method for predicting the letter. Here, you will have free rein to use put any and all learning techniques to try to improve your testing accuracy. 
% \begin{enumerate}
%  \item Play around with some ideas for improving/generalizing the prediction paradigm used in the letter prediction. Use the first 50 letter epochs as the training set and the later 35 for validation. Here, you are welcome to hard-code in whatever parameters you like/determine to be optimal. What is the optimal validation accuracy you get? Note: don't worry too much about accuracy, we are more interested in your thought process. (4 pts)
% </latex>

%%
chan10 = eeg(:, 10);
chan12 = eeg(:, 12);
chan11_matching = matching;
factor = [0.2353, 0.3412, 0.1647];
chan10_epoch = zeros(epoch_length, 85); % each column is an epoch
chan12_epoch = zeros(epoch_length, 85); % each column is an epoch
% index_epoch = zeros(85, 2);
for epoch = 1:1:85
    chan10_epoch(:, epoch) = chan10((epoch-1)*epoch_length+1:epoch*epoch_length);
    chan12_epoch(:, epoch) = chan12((epoch-1)*epoch_length+1:epoch*epoch_length);
end


chan10_250_450 = ones(length(index_iteration(11, 1) + index250:index_iteration(11, 1) + index450), 12 * 15, 85) .* (-1);
chan10_600_700 = ones(length(index_iteration(11, 1) + index600:index_iteration(11, 1) + index700), 12 * 15, 85) .* (-1);
chan12_250_450 = ones(length(index_iteration(11, 1) + index250:index_iteration(11, 1) + index450), 12 * 15, 85) .* (-1);
chan12_600_700 = ones(length(index_iteration(11, 1) + index600:index_iteration(11, 1) + index700), 12 * 15, 85) .* (-1);
chan11_250_450 = ones(length(index_iteration(11, 1) + index250:index_iteration(11, 1) + index450), 12 * 15, 85) .* (-1);
chan11_600_700 = ones(length(index_iteration(11, 1) + index600:index_iteration(11, 1) + index700), 12 * 15, 85) .* (-1);

chan10_rowcol = zeros(1, 12 * 15, 85);
chan12_rowcol = zeros(1, 12 * 15, 85);
chan11_rowcol = zeros(1, 12 * 15, 85);

for epoch_index = 1:1:85
    for index = 1:1:180
        chan10_250_450(:, index, epoch_index) = chan10_epoch(index_iteration(index, 1) + index250-1:index_iteration(index, 1) + index450-1, epoch_index);
        chan10_600_700(:, index, epoch_index) = chan10_epoch(index_iteration(index, 1) + index600-1:index_iteration(index, 1) + index700-1, epoch_index);

        chan12_250_450(:, index, epoch_index) = chan12_epoch(index_iteration(index, 1) + index250-1:index_iteration(index, 1) + index450-1, epoch_index);
        chan12_600_700(:, index, epoch_index) = chan12_epoch(index_iteration(index, 1) + index600-1:index_iteration(index, 1) + index700-1, epoch_index);

        chan11_250_450(:, index, epoch_index) = chan11_epoch(index_iteration(index, 1) + index250-1:index_iteration(index, 1) + index450-1, epoch_index);
        chan11_600_700(:, index, epoch_index) = chan11_epoch(index_iteration(index, 1) + index600-1:index_iteration(index, 1) + index700-1, epoch_index);

        chan10_rowcol(1, index, epoch_index) = str2num(stim_annot(index+epoch_length/240 * (epoch_index-1)).description);
        chan12_rowcol(1, index, epoch_index) = str2num(stim_annot(index+epoch_length/240 * (epoch_index-1)).description);
        chan11_rowcol(1, index, epoch_index) = str2num(stim_annot(index+epoch_length/240 * (epoch_index-1)).description);

    end
end

chan10_250_450_mean = mean(chan10_250_450, 1);
chan10_600_700_mean = mean(chan10_600_700, 1);
chan12_250_450_mean = mean(chan12_250_450, 1);
chan12_600_700_mean = mean(chan12_600_700, 1);
chan11_p300_mean = p300_mean;
chan10_p300_mean = -(chan10_600_700_mean - chan10_250_450_mean);
chan12_p300_mean = -(chan12_600_700_mean - chan12_250_450_mean);

chan10_p300_mean_average_attempt = zeros(12, 1, 85);
chan12_p300_mean_average_attempt = zeros(12, 1, 85);

for epoch_index = 1:1:85
    for rowcol = 1:1:length(chan10_p300_mean_average_attempt(:, :, 1))
        temp_all_10 = chan10_p300_mean(:, :, epoch_index);
        temp_all_12 = chan12_p300_mean(:, :, epoch_index);
        temp_10 = temp_all_10(chan10_rowcol(:, :, epoch_index) == rowcol);
        temp_12 = temp_all_12(chan12_rowcol(:, :, epoch_index) == rowcol);
        chan10_p300_mean_average_attempt(rowcol, 1, epoch_index) = mean(temp_10);
        chan12_p300_mean_average_attempt(rowcol, 1, epoch_index) = mean(temp_12);
    end
end
chan11_p300_mean_average_attempt = p300_mean_average_attempt;



chan10_row_epoch = zeros(1, 85);
chan10_col_epoch = zeros(1, 85);

chan12_row_epoch = zeros(1, 85);
chan12_col_epoch = zeros(1, 85);

chan11_row_epoch = row_epoch;
chan11_col_epoch = col_epoch;
net_row_epoch = zeros(size(row_epoch));
net_col_epoch = zeros(size(col_epoch));
for epoch_index = 1:1:85
    chan10_index_large = 7;
    chan10_greatest = -1.0e10;
    chan12_index_large = 7;
    chan12_greatest = -1.0e10;
    chan11_index_large = 7;
    chan11_greatest = -1.0e10;
    net_index = 7;
    for row = 1:1:6
        if chan10_p300_mean_average_attempt(row, 1, epoch_index) > chan10_greatest
            chan10_greatest = p300_mean_average_attempt(row, 1, epoch_index);
            chan10_index_large = row;
        end
    end
    for row = 1:1:6
        if chan12_p300_mean_average_attempt(row, 1, epoch_index) > chan12_greatest
            chan12_greatest = p300_mean_average_attempt(row, 1, epoch_index);
            chan12_index_large = row;
        end
    end
    chan10_row_epoch(1, epoch_index) = chan10_index_large;
    chan12_row_epoch(1, epoch_index) = chan12_index_large;
end

for epoch_index = 1:1:85
    chan10_index_large = 13;
    chan10_greatest = -1.0e10;
    chan12_index_large = 13;
    chan12_greatest = -1.0e10;
    for col = 7:1:12
        if chan10_p300_mean_average_attempt(col, 1, epoch_index) > chan10_greatest
            chan10_greatest = chan10_p300_mean_average_attempt(col, 1, epoch_index);
            chan10_index_large = col;
        end
    end
    for col = 7:1:12
        if chan12_p300_mean_average_attempt(col, 1, epoch_index) > chan12_greatest
            chan12_greatest = chan12_p300_mean_average_attempt(col, 1, epoch_index);
            chan12_index_large = col;
        end
    end
    chan10_col_epoch(1, epoch_index) = chan10_index_large;
    chan12_col_epoch(1, epoch_index) = chan12_index_large;
end
for epoch_index = 1:1:85
    row_temp10 =factor(1) * max(chan10_p300_mean_average_attempt(1:6, 1, epoch_index));
    row_temp11 =factor(2) * max(chan11_p300_mean_average_attempt(1:6, 1, epoch_index));
    row_temp12 =factor(3) * max(chan12_p300_mean_average_attempt(1:6, 1, epoch_index));
    col_temp10 =factor(1) * max(chan10_p300_mean_average_attempt(7:12, 1, epoch_index));
    col_temp11 =factor(2) * max(chan11_p300_mean_average_attempt(7:12, 1, epoch_index));
    col_temp12 =factor(3) * max(chan12_p300_mean_average_attempt(7:12, 1, epoch_index));
    if and(row_temp10> row_temp11, row_temp10 > row_temp12)
        net_row_epoch(1, epoch_index) = chan10_row_epoch(epoch_index);
    elseif and(row_temp11> row_temp10, row_temp11 > row_temp12)
        net_row_epoch(1, epoch_index) = chan11_row_epoch(epoch_index);
    elseif and(row_temp12> row_temp10, row_temp12 > row_temp11)
        net_row_epoch(1, epoch_index) = chan12_row_epoch(epoch_index);
    end
    if and(col_temp10> col_temp11, col_temp10 > col_temp12)
        net_col_epoch(1, epoch_index) = chan10_col_epoch(epoch_index);
    elseif and(col_temp11> col_temp10, col_temp11 > col_temp12)
        net_col_epoch(1, epoch_index) = chan11_col_epoch(epoch_index);
    elseif and(col_temp12> col_temp10, col_temp12 > col_temp11)
        net_col_epoch(1, epoch_index) = chan12_col_epoch(epoch_index);
    end
end

chan11_id_matrix = id_matrix;
chan11_predicted_matrix = predicted_matrix;
chan10_id_matrix = [chan10_row_epoch; chan10_col_epoch];
chan12_id_matrix = [chan12_row_epoch; chan12_col_epoch];
net_id_matrix = [net_row_epoch; net_col_epoch];
chan10_predicted_matrix = cell(1, length(chan10_id_matrix));
chan12_predicted_matrix = cell(1, length(chan12_id_matrix));
net_predicted_matrix = cell(1,  length(net_id_matrix));
for index = 1:1:length(chan10_id_matrix)
    chan10_predicted_matrix{index} = ref_matrix(chan10_id_matrix(2, index)-6, chan10_id_matrix(1, index));
    chan12_predicted_matrix{index} = ref_matrix(chan12_id_matrix(2, index)-6, chan12_id_matrix(1, index));
    net_predicted_matrix{index} = ref_matrix(net_id_matrix(2, index)-6, net_id_matrix(1, index));
end
chan10_predicted_matrix = str2mat(chan10_predicted_matrix);
chan12_predicted_matrix = str2mat(chan12_predicted_matrix);
net_predicted_matrix = str2mat(net_predicted_matrix);
% chan11_matching = matching;
matching = zeros(4, 85);
matching(2, :) = chan11_matching;
for letter = 1:1:length(predicted_matrix)
    matching(1, letter) = strcmp(chan10_predicted_matrix(letter), target_matrix(letter));
    matching(3, letter) = strcmp(chan12_predicted_matrix(letter), target_matrix(letter));
    matching(4, letter) = strcmp(net_predicted_matrix(letter), target_matrix(letter));
   
end
chan11_accuracy = accuracy;
for i  = 1:1:4
    accuracy(i) = sum(matching(i, :))/length(matching(i, :));
end

testing_accuracy = sum(matching(4, 51:85))/length(matching(4, 51:85));
% factor = accuracy;

sprintf('Validation set gives accuracy of %d percent', testing_accuracy)
%% 
% <latex> 
%  \item Describe your algorithm in detail. Also describe what you tried that didn't work. (6 pts)
% </latex>

%%
% <latex>
% The algorithm is a replica of the method presented in part2, except with
% data from 3 channels, 10, 11, and 12 instead of just 11. Since all three
% of them seemed to be a good electrode to use based on the topoplot from
% part 1 problem 4. Based on a run for the entire 85 letters using the
% three channels, channel 10, 11, and 12 had accuracy of approximately 24,
% 34, and 16 percent respectively. These were used as factors when
% weighing over the three channels. When deciding on the prominent row and
% column, the p3000 scores, which represent the difference from the
% baseline to the peak for target stimulations, were multiplied by these
% factors. Then by comparing between these factored p300 values across each
% channel, the channel with highest factored p300 value was chosen as the
% channel to use to for determining row and column. While the accuracy was
% not as satisfactory as the accuracy from part 2 problem 5, having more
% channels to predict from would likely help better adapt to outliers and
% noise than relying on single channel.
% </latex>
%% 
% <latex> 
% \end{enumerate}
% \end{document}
% </latex>
