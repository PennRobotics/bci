%%
% <latex> 
% \title{BE 521: Homework 6 \\{\normalsize Spike sorting}\\{\normalsize Spring 2016}} 
% \author{59 points} 
% \date{Due: Thursday, 03/17/2016 11:59pm} 
% \maketitle \textbf{Objective:} Detect and cluster spikes
% </latex>

%% 
% <latex> 
% \begin{center} \author{Sung Min Ha \\
%   \normalsize Collaborators: COLLABORATORS HERE \\}
% \end{center} 
% </latex>

%% 
% <latex>
% \subsection*{Overview}
% In this homework, you will do some basic spike sorting using two different datasets. The first (\verb|I521_A0006_D001|) is from a crayfish neuromuscular junction, a good model for human central nervous system synapses\footnote{The sampling rate of this data is 2000 Hz, which is adequate for this homework's instructional purposes but usually inadequate for real spike sorting, which often uses sampling frequencies on the order of 20 kHz.}. Specifically, the data contains two simultaneous recordings: an extracellular recording from the third nerve (channel \verb|nerve|) of a crayfish abdominal ganglion, which contains six spontaneously active motor neurons, and an intracellular recording from the superficial flexor muscle (channel \verb|muscle|) innervated by this nerve. You will attempt to discern relationships between the classes of spike waveforms you extract from the motor nerve trace and elicited potentials seen in the muscle fiber recording. 
% Then, you will revisit a human intracranial EEG recording (\verb|I521_A0006_D002|) and use some of the techniques you've learned in class to build a more automated spike sorter. 
% Note: While spikes may have positive and negative deflections, we will only focus on positive spikes on this homework for simplicity. 
% \section{Spike Detection and Clustering (38 pts)}
% In this section, you will explore some basic filtering and spike thresholding to ultimately compare spike clusters you pick out by eye to those selected by an automated algorithm.
% \begin{enumerate}
%     \item You can assume that the nerve samples have already been low-pass filtered. Here you will high-pass filter in order to remove signals like slow local field potentials and 60 Hz power line noise. Create a 4th order \textit{elliptic filter} with 0.1 dB of ripple in the passband, a stopband 40 dB lower than the peak value in the passband, and a passband edge frequency of 300 Hz (see Matlab's \verb|ellip| function and make sure your give the edge frequency in the correct normalized form). The statement to create this filter (defined by the filter coefficients \verb|b| and \verb|a|) should look something like
%   \begin{lstlisting}
% 	[b,a]=ellip(n,Rp,Rs,Wp,'high')
%   \end{lstlisting}
%   Clearly specify the denominator and numerator coefficients obtained for your filter function. (2pts)
% </latex>

%%
clear all;
close all;
addpath(genpath('c:/Users/sungm/ieeg-matlab-1.13.2'));
session = IEEGSession('I521_A0006_D001', 'hasm', 'has_ieeglogin.bin');
samp_rate = session.data.sampleRate; %Hz
durationInUSec = session.data.rawChannels(1).get_tsdetails.getDuration; %microseconds
durationInSec = durationInUSec / (1e6);
time = 0:(1/samp_rate):durationInSec;
time = time';
nr = ceil((session.data.rawChannels(2).get_tsdetails.getEndTime)/(1e6)*session.data.sampleRate);
nerve = session.data.getvalues(1:nr, 2:2); %uV
muscle = session.data.getvalues(1:nr, 1:1); %uV
%[B,A] = ellip(N,Rp,Rs,Wp); Nth order low pass, Rp db peak-to-peak ripple,
%Rs db minimum stopband attenuation. B is numerator and A is denominator.
%Wp is passband-edge frequency between 0.0 and 1.0, where 1.0 corresponds
%to half the sample rate.
N = 4;
Rp = 0.1;
Rs = 40;
%passband edge frequency = 300Hz
%Wp = 1.0 coresponds to 1/2 * sample rate = samp_rate/2.0;
Wp = 300.0/2000.0;
[B_num, A_den] = ellip(N, Rp, Rs, Wp);

%%
% <latex>
% B num is the numerator of the coefficients, with values of approximately,
% [0.0177, -0.0170, 0.0301, -0.0170, 0.0177]. A den is the denominators of
% the coefficients, with values of approximately, [1.0000, -2.9745, 3.5579,
% -1.9871, 0.4355].
% </latex>

%% 
% <latex>
%   \item Using the \verb|filter| function and \verb|filtfilt| function, obtain two different filtered outputs of the nerve signal.
%       \begin{enumerate}
%         \item In a 2x1 subplot, plot the first 50 ms of the unfiltered nerve signal in the top subplot; in the bottom subplot, plot the \verb|filter| output in blue and the \verb|filtfilt| output in red. Use a potential range (y-axis) of -20 to 50 millivolts. (4 pts)
% </latex>

%%
filter_output = filter(B_num, A_den, nerve);
filtfilt_output = filtfilt(B_num, A_den, nerve);

fig = 1;

dur_50ms = 50.0 * 1.0e-3; %sec
ind_end_50ms = dur_50ms * samp_rate; %index of 50 ms mark;
ind_range_50ms = 1:(ind_end_50ms+1);
figure(fig);
fig = fig + 1;
title('Unfiltered and filtered nerve signal, first 50 ms');
subplot(2, 1, 1), plot(time(ind_range_50ms), nerve(ind_range_50ms), 'k-');
axis([0 50e-3 -20e3 50e3]);
xlabel('time (seconds)');
ylabel('voltage (microV)');
legend('unfiltered Nerve signal');
title('Unfiltered Nerve signal');
subplot(2, 1, 2), plot(time(ind_range_50ms), filter_output(ind_range_50ms), 'b', time(ind_range_50ms), filtfilt_output(ind_range_50ms), 'r');
axis([0 50e-3 -20e3 50e3]);
xlabel('time (seconds)');
ylabel('voltage (microV)');
legend('filter', 'filtfilt');
title('Filtered Nerve signal');
%% 
% <latex>
%         \item How is the unfiltered signal different from the filtered signal? What is different about the two filtered (red and blue) signals? (2 pts)
% </latex>

%%
% <latex>
% The unfiltered signal has sharp edges and spikes; one can observe waves
% of higher frequencies than one can in the filtered signals. The filtered
% signals, both of them, have smooth curves and no sharp peaks. One can
% observe, at least for the first 50 ms, that the filtfilt signal (Red),
% seems to be shifted to the left (towards negative x axis) when
% compared to the filter signal (Blue). Judging by the relative time point
% at which the large peak is observed in the unfiltered data (around 0.01 second), the filtfilt data
% suffers less from the delay in the peak evident in the filter
% data.
% </latex>

%% 
% <latex>
%         \item Briefly explain the mathematical difference between the two filtering methods, and why one method might be more advantageous than the other in the context of spike detection? (5 pts)
% </latex>

%%
% <latex>
% The main difference between filtfilt and filter is that filtfilt is a
% zero-phase filtering. Filtfilt processes the input data in both the
% forward and reverse directions.
% (reference: MathWorks filtfilt reference page). On
% the other hand, filter is forward filtering only. As a result, this
% filtfilt does not suffer from phase distortion as forward-filtering only
% filter does. 
% As far as advantages go, filtfilt is advantageous over filter for spike
% detection because of zero phase distortion; the lack of delay observed in
% filter filtering allows the user to better identify the time point of the
% spikes with less error and less calculations.
% </latex>

%%
% <latex>
%       \end{enumerate}
%         \item Using a spike threshold of +30 mV, calculate the index and value of the peak voltage for each spike in the \textbf{filtered} nerve signal (select the best one). Use these values to plot the first 2.5 seconds of the nerve signal with a red dot above (e.g. 10 mV above) each spike. (Hint: Plot the entire length of the nerve signal with all the spikes marked but then restrict the x-axis using \verb|xlim| to [0, 2.5] seconds) (4 pts)
% </latex>

%%
thres = 30; %mV
thres = thres * 1.0e3; %microV
[peak, index] = findpeaks(filtfilt_output, 'MinPeakHeight', thres);
filtfilt_peak = filtfilt_output(index);
filtfilt_peak_dot = filtfilt_peak + (10 * 1e3);%add by 10mV  = 10e3 microV


%%
%Plot for filtfilt
figure(fig);
fig = fig+1;
plot(time, filtfilt_output, 'k-', time(index), filtfilt_peak_dot, 'ro', 'MarkerFaceColor', 'r');
xlim([0 2.5]);
legend('filtfilt data', 'peaks', 'un', 'location', 'southeast');
xlabel('time (second)');
ylabel('voltage (microV)');
title('filtfilt data with red dots above peaks');

%% 
% <latex>
%  \item Under the assumption that different cells produce different action potentials with distinct peak amplitudes, decide how many cells you think were recorded (some number between 1 and 6). You may find it helpful to zoom in and pan on the plot you made in question 1.3. You may also find it useful to plot the sorted peak values to gain insight into where ``plateaus'' might be. (No need to include these preliminary plots in the report, though.) Use thresholds (which you well set manually/by eye) to separate the different spikes. Make a plot of the first 2.5 seconds similar to that in 1.3 except now color the spike dots of each group a different color (e.g., \verb|'r.'|,\verb|'g.'|,\verb|'k.'|,\verb|'m.'|).(6 pts)
% </latex>

%%
sort_peak = sort(peak);
figure(fig);
fig=fig+1;
plot(sort_peak, 'ro');
peak_thres = [3.00 4.10 5.80 8.00] .* 10^4;
peak_manual = zeros(length(peak_thres)-1, length(peak));
index_manual = zeros(length(peak_thres)-1, length(peak));
count = ones(length(peak_thres)-1, 1);
for i = 1:1:length(peak)
    for j = 1:1:length(peak_thres)-1
        if and(peak_thres(j) < peak(i), peak(i) < peak_thres(j+1))
            peak_manual(j, count(j)) = peak(i);
            index_manual(j, count(j)) = index(i);
            count(j) = count(j) + 1;
        end
    end
end

%% 
%plot with different coloring for thresholds
figure(fig);
fig = fig+1;
hold on;
plot(time, filtfilt_output, 'k-');
color = {'r.', 'g.', 'k.', 'm.'};
for i = 1:1:length(peak_manual(:,1))
    plot(time(index_manual(i, index_manual(i, :)~=0)), peak_manual(i, peak_manual(i, :)~=0), color{i}, 'MarkerSize', 10);
end
xlim([0 2.5]);
strin = cell(length(peak_thres)-1, 1);
for i = 1:1:length(peak_thres)-1
    strin{i} = (sprintf('peak [%d, %d] microV', peak_thres(i), peak_thres(i+1)));
end
legend('filtfilt data', strin{1}, strin{2}, strin{3}, 'location', 'southeast');
xlabel('time (second)');
ylabel('voltage (microV)');
title('filtfilt data with red dots above peaks');
hold off;

%%
% <latex>
% As shown above in the plot with different markers, by approximating with
% the eyes using a sorted plot of the peak amplitude values, and assuming
% that there are some errors in measurement that would be accounted for by
% the existence of some noise in the data, I decided that there are three
% cells present.
% </latex>

%% 
% <latex>
%  \item Use Matlab's $k$-means\footnote{Clustering, like $k$-means you are using here, is a form of unsupervised learning.} function (\verb|kmeans|) to fit $k$ clusters (where $k$ is the number of cells you think the recording is picking up) to the 1D data for each spike. 
%   \begin{enumerate}
% 	\item Using the same color order (for increasing spike amplitude) as you did for the thresholds in question 1.4, plot the spike cluster colors as little dots slightly above those you made for question 1.4. The final figure should be a new plot of the nerve voltage and two dots above each spike, the first being your manual label and the second your clustered label, which (hopefully/usually) should be the same color. (4 pts)
% </latex>

%% 
%getting idx for kmeans
rng(3);
clus = 3;
idx = kmeans(peak, clus);
%We need to sort idx in the rising order of peak values so that the actual
% coloring will match up with the manual selection done above
idx_unorganized = idx;
idx_mean = [];
for i = 1:1:clus
    idx_mean = [idx_mean, mean(peak(idx==i))];
end
[idx_mean_org, idx_index_org] = sort(idx_mean);
for i = 1:1:clus
    idx(idx_unorganized==idx_index_org(i))=i;
end

%replot the last figure with additionally the kmeans data
figure(fig);
fig = fig+1;
hold on;
plot(time, filtfilt_output, 'k-');
color = {'r.', 'g.', 'k.', 'm.'};
for i = 1:1:length(peak_manual(:,1))
    plot(time(index_manual(i, index_manual(i, :)~=0)), peak_manual(i, peak_manual(i, :)~=0), color{i}, 'MarkerSize', 10);
end
for i = 1:1:length(index)
    plot(time(index(i)), (peak(i) + 10e3), color{idx(i)}, 'MarkerSize', 10);
end
xlim([0 2.5]);
strin = cell(length(peak_thres)-1, 1);
for i = 1:1:length(peak_thres)-1
    strin{i} = (sprintf('%d-th lowest peak range', i));
end
legend('unfiltered data', strin{1}, strin{2}, strin{3}, 'location', 'southeast');
xlabel('time (second)');
ylabel('voltage (microV)');
title('filtfiltered data with red dots above peaks');
hold off;
%% 
% <latex>
% 	\item Which labeling, your manual ones or the ones learned by clustering) seem best, or do they both seem just as good? (Again, panning over the entire plot may be helpful.) (2 pts)
% </latex>

%%
% <latex>
% For the purpose of consistent output, the rng(seed) has been set to value
% of seed=3 for this final publishing. However, testing for random seeds
% mulitple times have yielded nearly equal results between the kmeans
% classification and manual classification such that without setting up a
% more detailed testing, one would conclude that both are equally good.
% </latex>

%% 
% <latex>
%   \end{enumerate}
%  \item In this question,  you will test the hypothesis that the muscle potential responses are really only due to spikes from a subset of the cells you have identified in the previous two questions. First, plot the first 2.5 seconds of the muscle fiber potential and compare it with that of the nerve. Observe the relationship between spikes and the muscle fiber response. (No need to include this plot and observation in your report.)
%      Now, calculate the maximum muscle fiber potential change\footnote{max voltage - min voltage} in the 25 ms\footnote{Note that this 25 ms window is somewhat ad hoc and is just what seems reasonable by eye for this data. It implies no underlying physiological time scale or standard.} window after each spike (with the assumption that spikes without any/much effect on the muscle fiber potential do not directly innervate it). 
%   \begin{enumerate}
%    \item Using the cell groups you either manually defined or found via $k$-means clustering (just specify which you're using) again with different colors, plot a colored point for each spike where the x-value is the spike amplitude and the y-value is the muscle potential change. (6 pts)
% </latex>

%% 
%subplot with muscle vs nerve
figure(fig);
fig = fig+1;
title('muscle vs nerve');
subplot(2,1,1), plot(time, muscle, 'b-');
title('muscle');
ylabel('voltage (microV)');
xlabel('time (seconds)');
xlim([0 2.5]);
subplot(2,1,2), plot(time, filtfilt_output, 'r-');
title('nerve');
ylabel('voltage (microV)');
xlabel('time (seconds)');
xlim([0 2.5]);

%%
% <latex>
% Because one concluded that the performance of both manual eyeballing and
% kmeans checking seemed equally effective for this dataset at least, I
% decided to use the grouping from kmeans which seemed easier to code for
% me.
% </latex>

%% 
%Calculate Muscle Peak response max change after each spike
fib_pot_change = [];
ind_inc = 25 * 1.0e-3 * samp_rate; %s * samp/s = # samples
for i = 1:1:length(index)
    t_win = index(i):1:(index(i) + (ind_inc) );
    fib_pot_change = [fib_pot_change max(muscle(t_win))-min(muscle(t_win))];
end
fib_pot_change = fib_pot_change';

%% 
%Part a plot kmeans vs muscle
sprintf('Using kmeans')
figure(fig);
fig = fig + 1;
hold on;
color = {'ro', 'go', 'ko', 'mo'};
for i = 1:1:length(index)
    plot(peak(i), fib_pot_change(i), color{idx(i)}, 'MarkerSize', 10);
end
title('nerve spikes vs muscle response');
ylabel('muscle response voltage (microV)');
xlabel('nerve spike voltage (microV)');
hold off;

%% 
% <latex>
%    \item Does this plot support the hypothesis that the muscle fiber responses are only due to a subset of the cells. Explain why or why not. (3 pts)
% </latex>

%%
% <latex>
% One can note from the plot that the hypothesis is  not supported by the
% plot. If this hypothesis was true, one must be able to observe a pattern
% between the different colors within this plot; if one cell causes a
% response while another cell does not, then one must see a consistent y
% value greater than 0 for one color while a very small y value from another color. In
% other words, one would see an observable, consitent pattern within a
% single color subset. In this plot, one does not see such consitent plot
% for a single color subset, hence the plot does not support the
% hypothesis.
% </latex>

%% 
% <latex>
%   \end{enumerate}
% \end{enumerate}
% \section{Multivariate Clustering (21 pts)}
% In this section, you will explore similar methods for spikes sorting and clustering but with a different dataset, the human intracranial data in \verb|I521_A0006_D002|, 
% which is a larger dataset of the same recording you saw in \verb|I521_A0001_D001| of Homework 1. 
%   \begin{enumerate}
%    \item Using a threshold six standard deviations above the mean of the signal, detect the spikes in the signal. In addition, extract the waveform from 1 ms before the peak to 1 ms after it with peak value in the middle. (You will end up with a matrix where each row corresponds to the number of data points in 2 ms of signal minus 1 data point. Use the closest integer number of data points for the $\pm$ 1 ms window.) 
% </latex>

%% 
%Import new data from IEEG
session2 = IEEGSession('I521_A0006_D002', 'hasm', 'has_ieeglogin.bin');
samp_rate2 = session2.data.sampleRate; %Hz
durationInUSec2 = session2.data.rawChannels(1).get_tsdetails.getDuration; %microseconds
durationInSec2 = durationInUSec2 / (1e6); %seconds
time2 = 0:(1/samp_rate2):durationInSec2;
time2 = [time2 durationInSec2];
time2 = time2';
nr2 = ceil((session2.data.rawChannels.get_tsdetails.getEndTime)/(1e6)*session2.data.sampleRate);
nerve2 = session2.data.getvalues(1:(nr2), 1:1); %uV

%% 
%finding threshold 6 stdev above mean of signal
mean2 = mean(nerve2);
std2 = std(nerve2);
thres2 = 6 * std2 + mean2;
[peak2, index2] = findpeaks(nerve2, 'MinPeakHeight', thres2);

%% 
% <latex>
% 	\begin{enumerate}
% 	  \item Plot the waveforms of all the spikes overlaid on each other in the same color. (4 pts)
% </latex>

%%
%Creating the data matrix
pm_index = round(1e-3 * samp_rate2);%1ms in index plus/minus peak indices 
data2 = zeros(length(peak2), length(-pm_index:1:+pm_index));
[row, col] = size(data2);
for c = 1:1:col
    for r = 1:1:row
        data2(r, c) = nerve2(index2(r)-(c-pm_index-1));
    end
end

%%
%Check that the 33rd column in all rows are same as the actual peak, to ensure to loop above performed correctly
for r = 1:1:row
    if (data2(r, round(col/2)) ~= peak2(r))
        sprintf('data matrix(%d, %d) = %d does not match the actual peak value %d', r, round(col/2), data2(r, round(col/2)), peak2(r))
    else
        %sprintf('data matrix(%d, %d) = %d match the actual peak value %d', r, round(col/2), data2(r, round(col/2)), peak2(r))        
    end
end
% warning messages will be output if the halfway point in each row is NOT
% equal to the actual peak value

%% 
%Plot nerve signal with the spikes identified
figure(fig);
fig=fig+1;
time_per_peak = -pm_index*samp_rate2^-1:1.0*samp_rate2^-1:pm_index*samp_rate2^-1; %in seconds
hold on;
for r = 1:1:row
    plot(time_per_peak, data2(r, :), 'k-');
end
ylabel('voltage (microV)');
xlabel('time from the peak (seconds)');
title(sprintf('human intracranial data, all %d peaks overlaid', row));
hold off;

%% 
% <latex>
% 	  \item Does it looks like there is more than one type of spike? (1 pt)
% </latex>

%%
% <latex>
% There seems to be more than one type of spikes. As you can see in the
% plot of peak values above, different peaks have different amplitudes,
% with a clear division bewteen the peaks with amplitude less than 60
% microV and the peaks with amplitude greater than 90 microV. Hence, one
% can clearly argue that there are at least two types of peaks observed in
% the data.
% </latex>

%% 
% <latex>
% 	\end{enumerate} 
%    \item For each spike, represent the waveform by its  principal components. Use the \verb|pca| command in Matlab. Intuitively, principal component analysis finds the coordinate system that most reduces the variability in your data. 
% 	\begin{enumerate}
% 	  \item Run principal component analysis on all the spike waveforms and represent your data with the top two principal components. Make a scatterplot of your data in this principal component (PC) space. (3 pts)
% </latex>

%%
[coeff, score, latent, tsquared, explained, mu] = pca(data2);
% data2 has 308 rows and 65 columns; There are 65 variables per
% observation, where there are 308 observations: 308 samples of 65
% variables; 308 observations and 65 variables
figure(fig);
fig = fig+1;
scatter(score(:,1), score(:,2));
title('scatterplot of top two principal components');
xlabel('first top principal component score');
ylabel('second top principal component score');

%% 
% <latex>
% 	  \item Each PC also has an associated eigenvalue, representing the amount of variance explained by that PC. This an output of the \verb|PCA| command. Plot the  principal component vs the total variance explained. What is the variance explained if you include the top two principal components? (3 pts)
% </latex>

%%
%latent is the eigenvalue from pca function.
figure(fig);
fig = fig+1;
prin_comp = 1:1:length(latent);
plot(prin_comp, latent, 'k-');
ylabel('eigenvalue');
xlabel('n-th principal component');
title('eigenvalue for n-th principal component');

figure(fig);
fig=fig+1;
plot(prin_comp, explained, 'k-');
ylabel('percentage of variance explained');
xlabel('n-th principal component');
title('percentage of variance explained by n-th principal component');

first_two_percent = sum(explained(1:2));
sprintf('%d percent of total variance is explained by eigenvalues of first two principal component', first_two_percent)

%%
% <latex>
% Using the 'explained' vector given from the pca function, one can
% determine that approximately 73.73 percent of total variance is explained
% by the first two principal components. One would have gotten the same
% value of 73.73 percent if they divided sum of 'latent' first two values
% by the sum of all 'latent' values.
% </latex>

%% 
% <latex>
% 	  \item Does it look like there is more than one cluster of spikes? (1 pt)
% </latex>

%%
% <latex>
% From the scatterplot of scores from pca using two top principal
% componenents, one can clearly recognize the two prominent groups of
% points with a clear separation between them. Hence, one can observe more
% than one cluster of spikes. Visually, there seems to be two clusters of
% spikes.
% </latex>

%%
% <latex>
% 	\end{enumerate} 
% </latex>


%% 
% <latex>
%    \item Use the same \verb|kmeans| function as you used before to cluster the spikes based on these two (normalized) features (the waveforms represented by the top two PCs). You will use a slight twist, though, in that you will perform $k$-medians (which uses the medians instead of the mean for the cluster centers) by using the \verb|'cityblock'| distance metric (instead of the default \verb|'sqEuclidean'| distance). Make a plot similar to that in 2.2.a but now coloring the two clusters red and green. (3 pts)
% </latex>

%%
idx2 = kmeans(score(1:end, 1:2), 2, 'Distance', 'cityblock');

figure(fig);
fig = fig+1;
score1 = score(:,1);
score2 = score(:,2);
hold on;
scatter(score1(idx2==1), score2(idx2==1), 'r', 'filled');
scatter(score1(idx2==2), score2(idx2==2), 'g', 'filled');
title('scatterplot of top two principal components');
xlabel('first top principal component score');
ylabel('second top principal component score');
hold off;

%% 
% <latex>
%   \item Make a plot similar to 2.1 but now coloring the traces red and green according to which cluster they are in. Overlay the mean of the waveforms in each cluster with a thick black line (use the parameter \verb|'LineWidth'| and value \verb|'4'|). (3 pts)
% </latex>

%%
time_per_peak = -pm_index*samp_rate2^-1:1.0*samp_rate2^-1:pm_index*samp_rate2^-1; %in seconds


%%
%Find mean of two clusters
mean_peak = zeros(2, length(data2(1,:)));
count = zeros(2, 1);
for r = 1:1:row
    if idx2(r) == 1
        mean_peak(1, :) = mean_peak(1, :) + data2(r, :);
        count(1) = count(1) + 1;
    elseif idx2(r) == 2        
        mean_peak(2, :) = mean_peak(2, :) + data2(r, :);
        count(2) = count(2) + 1;
    else
        print('error: more clusters found in current data than 2');
    end
end
for cluster = 1:1:length(count);
    mean_peak(cluster, :) = mean_peak(cluster, :) ./ count(cluster);
end

%%
%plot
figure(fig);
fig=fig+1;
hold on;
for r = 1:1:row
    if (idx2(r) == 1)
        clus1=plot(time_per_peak, data2(r, :), 'r-');
    elseif (idx2(r) == 2)
        clus2=plot(time_per_peak,data2(r, :), 'g-');
    else
        plot(time_per_peak,data2(r, :), 'k-');
    end
end
for cluster = 1:1:length(count);
    mean_clus=plot(time_per_peak, mean_peak(cluster, :), 'k-', 'LineWidth', 4);
end
%legend('cluster1', 'cluster2', 'mean of waveform');

ylabel('voltage (microV)');
xlabel('time from the peak (seconds)');
title(sprintf('human intracranial data, all %d peaks overlaid', row));

legend([clus1, clus2, mean_clus], 'cluster1', 'cluster2', 'mean of each clusters', 'Location', 'southeast');
hold off;


%% 
% <latex>
%   \item What are some dangers of using the clustering techniques in this homework? (List 3) (3 pts)
% </latex>

%%
% <latex>
% The most obvious concern with using kmeans clustering is the fact that it
% requires user input for the number of clusters, which was obvious and
% very clear to be a value of two in this case. However, as one start to
% work with real data with much greater complexity, finding the correct
% number of clusters may not be as easy. kmeans clustering would fail
% obviously if the user cannot correctly input the true number of clusters
% in the dataset.
% </latex>

%%
% <latex>
% Another obvious concern with kmeans is that it will assume that the each
% cluster will be spherical with mean value convergence at the center. In
% our case, with the scatterplot showing top two principal components
% scores, we could see that the two clusters are relatively spherical.
% However, kmeans would have failed to function properly if the shape of
% the clusters were not spherical.
% </latex>

%%
% <latex>
% Another problem may occur is if the clusters are not of the same size.
% The method relies on clusters to be similar in size such that assignment
% to nearest cluster center is reasonable. Furthermore, because of this
% method of assgining based on closest cluster center, each cluster must be
% separated for kmeans to work. Hence, in a scenario where two clusters may
% overlap partially, kmeans would find it difficult to separate the two clusters correctly. 
% </latex>

%%
% <latex>
% There are assumptions not only in kmeans method but also the experimental setup. The current setup assumes each peak are independent from the previous
% and subsequent peaks, and that a single amplitude corresponds to a unique
% neuron cell firing. But one cannot confidently make the assertion that
% each neuron has unique amplitude of spike different frmo other neurons.
% Also, various factors can affect the amplitude of
% a signal; for example, reactory period can affect the ability of a neuron
% to fire a signal as well as the amplitude of the signal that it fires. If
% a neuron fires repeatedly, the amplitude of some of these signals could
% have been affected by the refractory period of the specific neuron.
% Especially given that the peaks were found using merely 'MinPeakHeight'
% paramter of findpeaks function, refractory periods have not been
% considered when locating these peaks.
% </latex>

%%
% <latex>
% Another possible danger of using clustering technique (pca) in
% particular, is the fact that some of the components are disregarded in
% order to find the top principal components. One has oberved that about 74
% percent of the variance has been accounted for with the clustering
% techniques used. The remaining 26 percent is smaller but not
% insignificant amount. Another cluster or more could have been very well
% been missed because the current method failed to account for the
% remaining 26 percent.
% </latex>

%%
% <latex>
% Another danger of the clustering techniques is that the current method
% assumes that each neuron is independent and each spike is independent.
% Basically, the threshold value or the amplitude may change rapidly for a
% neuron based on its surrounding neruons or its own previous spikes. Clustering
% tehniques learned so far fail to characterize these rapid changes. Two
% different spikes from a single cell could very well be characterized as
% two different clusters by current clustering technique.
% </latex>

%%
% <latex>
% Another possible concern is that resolution of the electrode. It is very
% possible the electrode used to measure spikes from individual neurons
% does not have high enough resolution. So, the assumption may fail to be
% true, and the clustering technique could very well be meaningless.
% </latex>

%% 
% <latex> 
% \end{enumerate}
% \end{document}
% </latex>
