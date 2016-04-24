# BCI Competition
Final Project for BE521 - Brain Computer Interfaces - Spring 2016

```
Prof. Brian Litt
Sung Min Ha
Archana Ramachandran
Brian Wright
```


## Progress
|    Date    |  Correlation  |  Filename  |
|:----------:|:-------------:| ---------- |
| 2016-04-19 |    0.0000     |   *N/A*    |
| 2016-04-20 |  **0.2912**   |  af-4-20   |
| 2016-04-20 |    0.1740     |  af-4-20b  |
| 2016-04-20 |    0.2535     |  af-4-20c  |
| 2016-04-20 |    0.2903     |  af-4-20d  |
| 2016-04-20 |    0.2898     |  af-4-20e  |
| 2016-04-20 |    0.2898     |  af-4-20f  |
| 2016-04-20 |  **0.2950**   |  af-4-20g  |
| 2016-04-20 |  **0.2951**   |  af-4-20h  |
| 2016-04-20 |  **0.3112**   |  af-4-20i  |
| 2016-04-21 |    0.2414     |  af-4-21   |
| 2016-04-21 |   -0.0017     |   random   |
| 2016-04-22 |  **0.3292**   |  af-4-22   |
| 2016-04-22 |    0.3114     |  af-4-22b  |
| 2016-04-22 |    0.3118     |   lasso    |
| 2016-04-22 |    0.2894     |  af-4-22c  |
| 2016-04-22 | **> 0.3400**  |  correctR  |
| 2016-04-22 | **> 0.3500**  |   smooth   |
| 2016-04-23 |  **0.4092**   |     a      |
| 2016-04-23 |  **0.4228**   |     a2     |
| 2016-04-23 |  **0.4374**   |     a3     |
| 2016-04-23 |    0.3412     |  by hand   |
| 2016-04-23 |    0.4292     |     a4     |
| 2016-04-23 |    0.4069     |     a5     |
| 2016-04-24 |  **0.4410**   | a3 sub1c21 |
| 2016-04-24 |    0.4285     | a3 sub3c12 |
| 2016-04-24 |    0.4392     | a3 sub3c17 |
| 2016-04-24 |    0.4317     | a3 sub2c08 |
| 2016-04-24 |    0.????     | a3 sub2c12 |

*When __af-4-20__ was submitted with the __floor()__ function, score dropped from 0.2912 to 0.2387.*


## Details of Highest Scoring Algorithm
### Features
- Moving Average (Tsample = 50 ms, Twindow = 250 ms)
- Frequency Domain Amplitude, Avg (5--15, 20--25, 75--115, 125--160, 160--175; Hz), 5 Hz bins
- (Glove reduced using MovingAverageAdj)

### Implementation
Trimmed N from beginning and from end
Appended N to beginning and to end
Linear Regression to solve Yhat
**PCHIP** upsampling: stretch Yhat to correct length using indexing (not **linspace**)
Signals were smoothed with a moving average---window size of 101 ms.

### Post-Processing
Noisy output signal is separated into bins with strongest signal determining the active finger.
Bins are constructed with 1275 ms offset and 4000 ms peak-to-peak distance.
Separation is performed using the **tukeywin** function (default shape) of width 2000 ms.
Output shape is a **tukeywin** window (0.75), size 5001 ms (formerly blackman, for a2).
This shape is convolved with a delta train centered on each bin.
Signals were mean-corrected (zero mean) and normalized by dividing standard deviation.
(Normalization was NOT used for a2.)

Larger bin sizes did not result in incremental improvement.

### Manual Correction
A combination of human-supervised visual classification and postprocessing on a revised dataset
(axon\_fired\_correctedR\_No55\_Lasso\_Alpha\_0\_5.mat)
resulted in several potential output changes. These changes were implemented one-by-one, and
correlation was checked after each change and tracked on a master list.


## Project Description
Three patients had EEG array recordings collected while moving individual fingers
when cued by a monitor. The goal of the project is to create a model predicting
the flexion of a particular digit given transient EEG data. More details can be
found in a publication by K. J. Miller et al, "Prediction of Finger Flexion: 4th
Brain-Computer Interface Data Competition."


## Potential Solutions
### Output Signal Generation and Clarification
- Change number/length/overlap of time-delayed features
- Difference between neurons (Does **corr(n1, n2)** predict usefulness?)
- New features: line length, energy, power, normalized input
- Identify most influential electrodes in the R matrix. Diff(E1, E2) as new feature.
- Adjust frequency bands and band sizes
- Low-pass filter
- Non-spline fit
- Nonlinear activation function (hidden layer)
- Remove channel 55
- Predictive RNN for active finger waveform
### Output Post-processing
- Manually place each peak
- Find peak centers using Matlab's peak detection routine (currently commented out)
- Swap single elements where fingers 3-4-5 are indiscernable to gauge change in correlation
- Adjust shape of output
- Identify frequency of glove output and create sinusoids for individual elements
- Weighted mean of generated signal and post-processed signal


## References
http://sccn.ucsd.edu/eeglab/

http://martinos.org/mne/stable/

http://mne-tools.github.io/mne-python-intro/

- - - - -
*University of Pennsylvania*
