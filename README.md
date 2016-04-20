# BCI
Final Project for BE521 - Brain Computer Interfaces - Spring 2016

```
Prof. Brian Litt
Sung Min Ha
Archana Ramachandran
Brian Wright
```
*University of Pennsylvania*

## Progress
|    Date    | Correlation | Filename |
|:----------:|:-----------:| -------- |
| 2016-04-19 |   0.0000    |  *N/A*   |
| 2016-04-20 | **0.2912**  | af-4-20  |
| 2016-04-20 |   0.1740    | af-4-20b |
| 2016-04-20 |   ?.????    | af-4-20c |

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
- Wavelet domain ?
- ???
