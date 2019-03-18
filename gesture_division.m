%目的：将预处理后的数据进行手势段分割
clear all;clc;close all;

FileName1_1 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢预处理后数据\中指\picture4.txt'];
data = textread(FileName1_1,'%f');         %读取预处理后的数据

fs = 1000;                              %采样频率
x = data(40000:end);                               %准备进行手势段分割的数据
data_gesture = data(40000:end);               %用来截取手势数据段
x = x-mean(x);
x = x/max(abs(x));                      %幅度归一化到[-1，1]
N = length(x);                          %求出信号长度
time = (0:N-1)/fs;                      %计算时间刻度
wlen = 40; inc =20;                     %设置帧长和帧移
overlap = wlen-inc;                     %计算相邻两帧重叠部分=帧长-帧移
IS = 0.2;                               %设置前导无话段的时长（单位是：/s)
NIS = fix((IS*fs-wlen)/inc + 1);        %计算NIS,其中NIS是前导无动作段的帧数---计算公式
y = enframe(x,wlen,inc)';               %分帧--每一帧数据为一列，每一列的元素个数为wlen，后一列与前一列有overlap个元素重合
etemp = sum(y.^2);                      %求取每一帧的短时平均能量
etemp = etemp/max(etemp);               %能量幅值归一化
fn = size(y,2);                         %计算帧数

%设置“双门限”法的阈值
T1 = 0.04;                             
T2 = 0.001;

frameTime = frame2time(fn,wlen,inc,fs); %计算各帧对应的时间
% 端点检测
[voiceseg,vs1,SF,NF] = motion_param1D(etemp,T1,T2);   %用一个参数（能量）进行端点检测

% 手势段分割结果作图
subplot(3,1,1);plot(time,data_gesture,'b');title('原动作波形');ylabel('幅值');xlabel('时间/s');
subplot(3,1,2);plot(time,x,'b');hold on;title('归一化动作波形');ylabel('幅值');xlabel('时间/s');%axis([0 max(time) -1 1]);
for k = 1:vs1
    nx1 = voiceseg(k).begin;
    nx2 = voiceseg(k).end;
    
    frameTime(nx1);
    frameTime(nx2);
    
    fprintf('第%d个分区=  起点=%4d  终点=%4d\n',k,nx1,nx2);   %起点、终点记录的是对应帧数
    line([frameTime(nx1) frameTime(nx1)],[-1,1],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1,1],'color','k','LineStyle','--');
end
subplot(3,1,3);plot(frameTime,etemp,'k');title('动作短时能量图');ylabel('幅值');xlabel('时间/s');%axis([0 max(time) 0 1]);
line([0 max(time)],[T1 T1],'color','k','LineStyle','--');
line([0 max(time)],[T2 T2],'color','k','LineStyle','-');


% 将动作段分割出来，保存在.txt文本中
% 将动作段的起始点、终点所对应的时间坐标换算成样本中的个数坐标（对应第几个信号数据），以便分离动作段数据
motion_begin = frameTime(voiceseg(9).begin)*fs;    %将截取的动作段的时间坐标转换为个数坐标
motion_end = frameTime(voiceseg(9).end)*fs;
motion = data_gesture(motion_begin:motion_end);          %截取原始信号段数据作为动作段

picture_N = 37;
FileName1_2 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢手势段分割\中指\第4通道\',num2str(picture_N),'.txt'];
fid=fopen(FileName1_2,'w');
fprintf(fid,' %f\n',motion);             %保存预处理后的数据段的从 到 的数据
fclose(fid);

figure(2);
subplot(4,2,1);plot(motion);axis([0 1000 -300 200]);

%以一个通道的手势段为基准，分割其他通道的手势段
%第2通道
FileName2_1 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢预处理后数据\中指\picture2.txt'];
x2 = textread(FileName2_1,'%f');         %读取2通道的数据
x2 = x2(40000:end); 
motion2 = x2(motion_begin:motion_end);          %截取原始信号段数据作为动作段
FileName2_2 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢手势段分割\中指\第2通道\',num2str(picture_N),'.txt'];
fid=fopen(FileName2_2,'w');
fprintf(fid,' %f\n',motion2);             %保存预处理后的数据段的从 到 的数据
fclose(fid);
subplot(4,2,2);plot(motion2);axis([0 1000 -200 200]);

%第3通道
FileName3_1 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢预处理后数据\中指\picture3.txt'];
x3 = textread(FileName3_1,'%f');         %读取2通道的数据
x3 = x3(40000:end); 
motion3 = x3(motion_begin:motion_end);          %截取原始信号段数据作为动作段
FileName3_2 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢手势段分割\中指\第3通道\',num2str(picture_N),'.txt'];
fid=fopen(FileName3_2,'w');
fprintf(fid,' %f\n',motion3);             %保存预处理后的数据段的从 到 的数据
fclose(fid);
subplot(4,2,3);plot(motion3);axis([0 1000 -200 200]);

%第4通道
FileName4_1 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢预处理后数据\中指\picture1.txt'];
x4 = textread(FileName4_1,'%f');         %读取2通道的数据
x4 = x4(40000:end); 
motion4 = x4(motion_begin:motion_end);          %截取原始信号段数据作为动作段
FileName4_2 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢手势段分割\中指\第1通道\',num2str(picture_N),'.txt'];
fid=fopen(FileName4_2,'w');
fprintf(fid,' %f\n',motion4);             %保存预处理后的数据段的从 到 的数据
fclose(fid);
subplot(4,2,4);plot(motion4);axis([0 1000 -200 200]);

%第5通道
FileName5_1 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢预处理后数据\中指\picture5.txt'];
x5 = textread(FileName5_1,'%f');         %读取2通道的数据
x5 = x5(40000:end); 
motion5 = x5(motion_begin:motion_end);          %截取原始信号段数据作为动作段
FileName5_2 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢手势段分割\中指\第5通道\',num2str(picture_N),'.txt'];
fid=fopen(FileName5_2,'w');
fprintf(fid,' %f\n',motion5);             %保存预处理后的数据段的从 到 的数据
fclose(fid);
subplot(4,2,5);plot(motion5);axis([0 1000 -200 200]);

%第6通道
FileName6_1 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢预处理后数据\中指\picture6.txt'];
x6 = textread(FileName6_1,'%f');         %读取2通道的数据
x6 = x6(40000:end); 
motion6 = x6(motion_begin:motion_end);          %截取原始信号段数据作为动作段
FileName6_2 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢手势段分割\中指\第6通道\',num2str(picture_N),'.txt'];
fid=fopen(FileName6_2,'w');
fprintf(fid,' %f\n',motion6);             %保存预处理后的数据段的从 到 的数据
fclose(fid);
subplot(4,2,6);plot(motion6);axis([0 1000 -200 200]);

%第7通道
FileName7_1 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢预处理后数据\中指\picture7.txt'];
x7 = textread(FileName7_1,'%f');         %读取2通道的数据
x7 = x7(40000:end); 
motion7 = x7(motion_begin:motion_end);          %截取原始信号段数据作为动作段
FileName7_2 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢手势段分割\中指\第7通道\',num2str(picture_N),'.txt'];
fid=fopen(FileName7_2,'w');
fprintf(fid,' %f\n',motion7);             %保存预处理后的数据段的从 到 的数据
fclose(fid);
subplot(4,2,7);plot(motion7);axis([0 1000 -200 200]);

%第8通道
FileName8_1 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢预处理后数据\中指\picture8.txt'];
x8 = textread(FileName8_1,'%f');         %读取2通道的数据
x8 = x8(40000:end); 
motion8 = x8(motion_begin:motion_end);          %截取原始信号段数据作为动作段
FileName8_2 = ['F:\手环小组工作\论文\神经网络分类处理\19.1.2数据采集\谢手势段分割\中指\第8通道\',num2str(picture_N),'.txt'];
fid=fopen(FileName8_2,'w');
fprintf(fid,' %f\n',motion8);             %保存预处理后的数据段的从 到 的数据
fclose(fid);
subplot(4,2,8);plot(motion8);axis([0 1000 -200 200]);

