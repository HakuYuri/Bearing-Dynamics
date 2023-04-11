function [Spectrum, FreqAxis, AlterData] = myFFT(Data, fs)
% 对输入信号进行傅里叶变换
% Data: 输入信号
% fs: 采样频率
% Spectrum: 傅里叶变换结果
% FreqAxis: 频率向量
AlterData = Data - mean(Data);
N = length(AlterData);              % 信号长度
Spectrum = abs(fft(AlterData)/N);               % 傅里叶变换
FreqAxis = (0:N-1)*(fs/N);         % 频率向量
end