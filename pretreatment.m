%目的：对采集到的数据进行先期预处理（新手环的8通道数据）
%作用：去除时间戳；
%      去直流分量；
%      去基线漂移；
%      去工频信号（kaiser窗滤波）；
clear all;clc;close all;
fs = 1000;

for i=1:8          %循环载入8个通道的数据
    %载入16进制数据，并且将16进制转换为10进制，存入数组datadec中
    FileName1 = ['..\data\谢凌锐\原始数据\食指\picture',num2str(i),'.txt'];
    datahex = textread(FileName1,'%s');           
    datadec = hex2dec(datahex);     
    
    %去除信号中的时间戳
    i2=1;
    data_N = length(datadec);               % 计算原始信号的数据个数
    data_n = data_N-ceil(data_N/11);        % data_N - 向上取整计算时间戳的个数 = 去除时间戳后数据的个数
    data = 1:data_n;                        % 定义去时间戳后的原始数据数组data的空间
    for i1=1:data_N                         % 一组数据：1个时间戳+10个数据=共11个数据
        c=mod(i1,11);                       % 求i1除以11所得余数
        if c~=1                             % 如果该数据不是时间戳，将数据存入数组data,并且计数i2
            data(i2)=datadec(i1);
            i2=i2+1;
        end
    end
    figure(i);
    subplot(4,1,1);plot(data);title('原始信号');xlabel('时间轴');ylabel('幅值');
    
    %去直流分量
    data = data - mean(data);
    subplot(4,1,2);plot(data);title('去直流信号');xlabel('时间轴');ylabel('幅值');
    
    %去基线漂移
    data_p = data(1:end);%将数组转换成列向量
    N_p = length(data_p);
    t_p = (0:N_p-1)/fs;
    a = polyfit(t_p,data_p,6); %p为幂次从高到低的多项式系数向量，矩阵s用于生成预测值的误差估计
    ztrend = polyval(a,t_p); %返回对应自变量t在给定系数p的多项式的值
    data_p = data_p-ztrend; %获得即现在0处的，基线矫正后的数据
    subplot(4,1,3);plot(t_p,data_p);axis([10 20 -400 400]);title('去基线漂移');xlabel('时间轴');ylabel('幅值');
    
    % kaiser窗滤波
    As = 50;Fs = 1000;Fs2 = Fs/2;               %阻带最小衰减和采样频率
    fs1 = 53;fs2 = 56;                          %阻带频率
    fp1 = 49;fp2 = 60 ;                         %通带频率
    df = min(fs1-fp1,fp2-fs2);                  %求过渡带宽
    M = round((As-7.95)/(14.36*df/Fs))+2;       %计算凯泽窗长
    M = M+mod(M+1,2);                           %保证窗长为奇数
    wp1 = fp1/Fs2*pi;wp2 = fp2/Fs2*pi;          %转换成归一化圆频率
    ws1 = fs1/Fs2*pi;ws2 = fs2/Fs2*pi;
    wc1 = (wp1+ws1)/2;wc2 = (wp2+ws2)/2;        %求截止频率
    beta = 0.5842*(As-21)^0.4+0.07886*(As-21);  %求凯泽窗的另一个参数β，其值因As取值范围不同，公式不同
    fprintf('beta=%5.6f\n',beta);
    M = M-1;                                    %阶次=窗长-1
    b = fir1(M,[wc1 wc2]/pi,'stop',kaiser(M+1,beta)); %计算FIR滤波器系数
    [h,w] = freqz(b,1,4000);                    %求幅值的频率响应
    db = 20*log10(abs(h));

    N1 = length(data_p);                           %求出信号长度
    t1 = (0:N1-1)/fs;                            %设置时间
    y = conv(b,data_p);                            %FIR带陷滤波，输出为y
    data_k = y(M/2+1:end-M/2);                        %消除conv带来的滤波器输出延迟的影响
    subplot(4,1,4);plot(t1,data_k);axis([10 20 -200 600]);title('kaiser窗滤波');xlabel('时间轴');ylabel('幅值');
    
    % 将预处理后的数据存入文本文件
    FileName2 = ['..\data\谢凌锐\预处理后数据\食指\picture',num2str(i),'.txt'];
    fid=fopen(FileName2,'w');
    fprintf(fid,' %f\n',data_k);
    fclose(fid);
    
  
    figure(9);
    subplot(8,1,i);plot(t1,data_k);axis([10 20 -300 300]);title('kaiser窗滤波');xlabel('时间轴');ylabel('幅值');
    
end
