function [EnvCurve, EnvelopeSpectrum, EnvFreqAxis, EnvAlterData] = EnvSpec(MetaSig, FreqSam)

    EnvAlterData = MetaSig - mean(MetaSig);
    
    % 计算Hilbert变换
    hilb = hilbert(EnvAlterData);
    
    % 计算包络
    EnvCurve = abs(hilb);

    % 去直流
    envelope1 = EnvCurve - mean(EnvCurve);
    
    % 计算谱
    N = length(EnvAlterData); % 信号长度
    EnvFreqAxis = (0:N-1)*(FreqSam/N); % 构造频率轴
    EnvelopeSpectrum = abs(fft(envelope1)/N); % 计算谱
end
