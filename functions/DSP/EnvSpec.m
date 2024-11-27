% -------------------------------------------------------------------------
% Compute the envelope curve, its spectrum, and related data from a signal.
%
% This function takes a time-domain signal and performs the following:
% 1. Removes the mean to preprocess the signal.
% 2. Computes the Hilbert transform to obtain the analytic signal.
% 3. Calculates the envelope of the signal from the analytic signal.
% 4. Removes the DC component from the envelope to enhance spectral clarity.
% 5. Computes the envelope spectrum using FFT.
% 6. Constructs the frequency axis corresponding to the spectrum.
%
% Last modified: 2024.11.27
% ---------------------------------Input-----------------------------------
% MetaSig   - The input signal (vector of time-domain samples).
% FreqSam   - Sampling frequency of the input signal (in Hz).
% ---------------------------------Output----------------------------------
% EnvCurve            - Envelope of the input signal.
% EnvelopeSpectrum    - Spectrum of the envelope.
% EnvFreqAxis         - Frequency axis for the envelope spectrum.
% EnvAlterData        - Mean-centered input signal.
% -------------------------------------------------------------------------

function [EnvCurve, EnvelopeSpectrum, EnvFreqAxis, EnvAlterData] = EnvSpec(MetaSig, FreqSam)

    % Remove the mean to center the input signal
    EnvAlterData = MetaSig - mean(MetaSig);

    % Compute the Hilbert transform of the mean-centered signal
    hilb = hilbert(EnvAlterData);

    % Compute the envelope of the analytic signal
    EnvCurve = abs(hilb);

    % Remove the DC component from the envelope
    envelope1 = EnvCurve - mean(EnvCurve);

    % Determine the length of the signal
    N = length(EnvAlterData); 

    % Construct the frequency axis for the envelope spectrum
    EnvFreqAxis = (0:N-1) * (FreqSam / N);

    % Compute the spectrum of the envelope (normalized by signal length)
    EnvelopeSpectrum = abs(fft(envelope1) / N);

end
