# BCI
Final Project for BE521 - Brain Computer Interfaces - Spring 2016

```
Prof. Brian Litt
Sung Min Ha
Archana Ramachandran
Brian Wright
```

## Progress
|    Date    | Correlation |  Filename  |
|:----------:|:-----------:| ---------- |
| 2016-04-19 |   0.0000    |   *N/A*    |
| 2016-04-20 | **0.2912**  |  af-4-20   |
| 2016-04-20 |   0.1740    |  af-4-20b  |
| 2016-04-20 |   0.2535    |  af-4-20c  |
| 2016-04-20 |   0.2903    |  af-4-20d  |
| 2016-04-20 |   0.2898    |  af-4-20e  |
| 2016-04-20 |   0.2898    |  af-4-20f  |
| 2016-04-20 | **0.2950**  |  af-4-20g  |
| 2016-04-20 | **0.2951**  |  af-4-20h  |
| 2016-04-20 | **0.3112**  |  af-4-20i  |
| 2016-04-21 |   0.2414    |  af-4-21   |
| 2016-04-21 |  -0.0017    |   random   |
| 2016-04-22 | **0.3292**  |  af-4-22   |
| 2016-04-22 |   0.3114    |  af-4-22b  |
| 2016-04-22 |   0.3118    |   lasso    |
| 2016-04-22 |   0.2894    |  af-4-22c  |
| 2016-04-22 | *> 0.3400*  |  correctR  |
| 2016-04-22 | *> 0.3500*  |   smooth   |
| 2016-04-23 | **0.4092**  |     a      |

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
Separation is performed using the **tukeywin** function (default shape).
Output shape is a **blackman** window, size 4001 ms, convolved with a delta train aligned with bins.
Signals were mean-corrected (zero mean) but *not* normalized using standard deviation.


## Project Description
Three patients had EEG array recordings collected while moving individual fingers
when cued by a monitor. The goal of the project is to create a model predicting
the flexion of a particular digit given transient EEG data. More details can be
found in a publication by K. J. Miller et al, "Prediction of Finger Flexion: 4th
Brain-Computer Interface Data Competition."

## Potential Solutions
- Difference between neurons (Does **corr(n1, n2)** predict usefulness?)
- Hysteresis in active finger
- Low-pass filter
- Shift several time units
- Non-spline fit
- Multiple steps in spline fit
- Is the target data discretized (integer) or continuous?
- More/less history in R matrix
- Nonlinear activation function (hidden layer)
- Predictive RNN for active finger waveform
- Hold-and-delay after threshold
- Remove channel 55
- New features: line length, energy, power, normalized input
- Adjust frequency bands and band sizes
- Identify most influential electrodes in the R matrix. Diff(E1, E2) as new feature.
- Tiny nudges e.g. x^1.02 or x^0.98
- Wavelet domain ?
- ???

## References
http://sccn.ucsd.edu/eeglab/

http://martinos.org/mne/stable/

http://mne-tools.github.io/mne-python-intro/

- - - - -
*University of Pennsylvania*
