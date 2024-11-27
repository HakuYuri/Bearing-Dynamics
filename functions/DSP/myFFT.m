% -------------------------------------------------------------------------
% Perform Fourier Transform on a given signal to compute its spectrum and
% corresponding frequency axis.
%
% This function processes an input signal by:
% 1. Removing the mean to center the signal.
% 2. Performing the Fourier Transform (FFT) to calculate the frequency spectrum.
% 3. Generating the corresponding frequency axis based on the sampling frequency.
%
% Last modified: 2024.11.27
% ---------------------------------Input-----------------------------------
% Data   - Input signal (vector of time-domain samples).
% fs     - Sampling frequency of the input signal (in Hz).
% ---------------------------------Output----------------------------------
% Spectrum   - Normalized magnitude of the Fourier Transform result.
% FreqAxis   - Frequency axis corresponding to the spectrum (in Hz).
% AlterData  - Mean-centered input signal.
% -------------------------------------------------------------------------

function [Spectrum, FreqAxis, AlterData] = myFFT(Data, fs)

    % Center the input signal by removing its mean
    AlterData = Data - mean(Data);

    % Calculate the length of the signal
    N = length(AlterData);

    % Compute the Fourier Transform of the mean-centered signal and normalize
    Spectrum = abs(fft(AlterData) / N);

    % Construct the frequency axis for the spectrum
    FreqAxis = (0:N-1) * (fs / N);

end
