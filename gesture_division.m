%Ŀ�ģ���Ԥ���������ݽ������ƶηָ�
clear all;clc;close all;

FileName1_1 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\лԤ���������\��ָ\picture4.txt'];
data = textread(FileName1_1,'%f');         %��ȡԤ����������

fs = 1000;                              %����Ƶ��
x = data(40000:end);                               %׼���������ƶηָ������
data_gesture = data(40000:end);               %������ȡ�������ݶ�
x = x-mean(x);
x = x/max(abs(x));                      %���ȹ�һ����[-1��1]
N = length(x);                          %����źų���
time = (0:N-1)/fs;                      %����ʱ��̶�
wlen = 40; inc =20;                     %����֡����֡��
overlap = wlen-inc;                     %����������֡�ص�����=֡��-֡��
IS = 0.2;                               %����ǰ���޻��ε�ʱ������λ�ǣ�/s)
NIS = fix((IS*fs-wlen)/inc + 1);        %����NIS,����NIS��ǰ���޶����ε�֡��---���㹫ʽ
y = enframe(x,wlen,inc)';               %��֡--ÿһ֡����Ϊһ�У�ÿһ�е�Ԫ�ظ���Ϊwlen����һ����ǰһ����overlap��Ԫ���غ�
etemp = sum(y.^2);                      %��ȡÿһ֡�Ķ�ʱƽ������
etemp = etemp/max(etemp);               %������ֵ��һ��
fn = size(y,2);                         %����֡��

%���á�˫���ޡ�������ֵ
T1 = 0.04;                             
T2 = 0.001;

frameTime = frame2time(fn,wlen,inc,fs); %�����֡��Ӧ��ʱ��
% �˵���
[voiceseg,vs1,SF,NF] = motion_param1D(etemp,T1,T2);   %��һ�����������������ж˵���

% ���ƶηָ�����ͼ
subplot(3,1,1);plot(time,data_gesture,'b');title('ԭ��������');ylabel('��ֵ');xlabel('ʱ��/s');
subplot(3,1,2);plot(time,x,'b');hold on;title('��һ����������');ylabel('��ֵ');xlabel('ʱ��/s');%axis([0 max(time) -1 1]);
for k = 1:vs1
    nx1 = voiceseg(k).begin;
    nx2 = voiceseg(k).end;
    
    frameTime(nx1);
    frameTime(nx2);
    
    fprintf('��%d������=  ���=%4d  �յ�=%4d\n',k,nx1,nx2);   %��㡢�յ��¼���Ƕ�Ӧ֡��
    line([frameTime(nx1) frameTime(nx1)],[-1,1],'color','r','LineStyle','-');
    line([frameTime(nx2) frameTime(nx2)],[-1,1],'color','k','LineStyle','--');
end
subplot(3,1,3);plot(frameTime,etemp,'k');title('������ʱ����ͼ');ylabel('��ֵ');xlabel('ʱ��/s');%axis([0 max(time) 0 1]);
line([0 max(time)],[T1 T1],'color','k','LineStyle','--');
line([0 max(time)],[T2 T2],'color','k','LineStyle','-');


% �������ηָ������������.txt�ı���
% �������ε���ʼ�㡢�յ�����Ӧ��ʱ�����껻��������еĸ������꣨��Ӧ�ڼ����ź����ݣ����Ա���붯��������
motion_begin = frameTime(voiceseg(9).begin)*fs;    %����ȡ�Ķ����ε�ʱ������ת��Ϊ��������
motion_end = frameTime(voiceseg(9).end)*fs;
motion = data_gesture(motion_begin:motion_end);          %��ȡԭʼ�źŶ�������Ϊ������

picture_N = 37;
FileName1_2 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\л���ƶηָ�\��ָ\��4ͨ��\',num2str(picture_N),'.txt'];
fid=fopen(FileName1_2,'w');
fprintf(fid,' %f\n',motion);             %����Ԥ���������ݶεĴ� �� ������
fclose(fid);

figure(2);
subplot(4,2,1);plot(motion);axis([0 1000 -300 200]);

%��һ��ͨ�������ƶ�Ϊ��׼���ָ�����ͨ�������ƶ�
%��2ͨ��
FileName2_1 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\лԤ���������\��ָ\picture2.txt'];
x2 = textread(FileName2_1,'%f');         %��ȡ2ͨ��������
x2 = x2(40000:end); 
motion2 = x2(motion_begin:motion_end);          %��ȡԭʼ�źŶ�������Ϊ������
FileName2_2 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\л���ƶηָ�\��ָ\��2ͨ��\',num2str(picture_N),'.txt'];
fid=fopen(FileName2_2,'w');
fprintf(fid,' %f\n',motion2);             %����Ԥ���������ݶεĴ� �� ������
fclose(fid);
subplot(4,2,2);plot(motion2);axis([0 1000 -200 200]);

%��3ͨ��
FileName3_1 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\лԤ���������\��ָ\picture3.txt'];
x3 = textread(FileName3_1,'%f');         %��ȡ2ͨ��������
x3 = x3(40000:end); 
motion3 = x3(motion_begin:motion_end);          %��ȡԭʼ�źŶ�������Ϊ������
FileName3_2 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\л���ƶηָ�\��ָ\��3ͨ��\',num2str(picture_N),'.txt'];
fid=fopen(FileName3_2,'w');
fprintf(fid,' %f\n',motion3);             %����Ԥ���������ݶεĴ� �� ������
fclose(fid);
subplot(4,2,3);plot(motion3);axis([0 1000 -200 200]);

%��4ͨ��
FileName4_1 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\лԤ���������\��ָ\picture1.txt'];
x4 = textread(FileName4_1,'%f');         %��ȡ2ͨ��������
x4 = x4(40000:end); 
motion4 = x4(motion_begin:motion_end);          %��ȡԭʼ�źŶ�������Ϊ������
FileName4_2 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\л���ƶηָ�\��ָ\��1ͨ��\',num2str(picture_N),'.txt'];
fid=fopen(FileName4_2,'w');
fprintf(fid,' %f\n',motion4);             %����Ԥ���������ݶεĴ� �� ������
fclose(fid);
subplot(4,2,4);plot(motion4);axis([0 1000 -200 200]);

%��5ͨ��
FileName5_1 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\лԤ���������\��ָ\picture5.txt'];
x5 = textread(FileName5_1,'%f');         %��ȡ2ͨ��������
x5 = x5(40000:end); 
motion5 = x5(motion_begin:motion_end);          %��ȡԭʼ�źŶ�������Ϊ������
FileName5_2 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\л���ƶηָ�\��ָ\��5ͨ��\',num2str(picture_N),'.txt'];
fid=fopen(FileName5_2,'w');
fprintf(fid,' %f\n',motion5);             %����Ԥ���������ݶεĴ� �� ������
fclose(fid);
subplot(4,2,5);plot(motion5);axis([0 1000 -200 200]);

%��6ͨ��
FileName6_1 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\лԤ���������\��ָ\picture6.txt'];
x6 = textread(FileName6_1,'%f');         %��ȡ2ͨ��������
x6 = x6(40000:end); 
motion6 = x6(motion_begin:motion_end);          %��ȡԭʼ�źŶ�������Ϊ������
FileName6_2 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\л���ƶηָ�\��ָ\��6ͨ��\',num2str(picture_N),'.txt'];
fid=fopen(FileName6_2,'w');
fprintf(fid,' %f\n',motion6);             %����Ԥ���������ݶεĴ� �� ������
fclose(fid);
subplot(4,2,6);plot(motion6);axis([0 1000 -200 200]);

%��7ͨ��
FileName7_1 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\лԤ���������\��ָ\picture7.txt'];
x7 = textread(FileName7_1,'%f');         %��ȡ2ͨ��������
x7 = x7(40000:end); 
motion7 = x7(motion_begin:motion_end);          %��ȡԭʼ�źŶ�������Ϊ������
FileName7_2 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\л���ƶηָ�\��ָ\��7ͨ��\',num2str(picture_N),'.txt'];
fid=fopen(FileName7_2,'w');
fprintf(fid,' %f\n',motion7);             %����Ԥ���������ݶεĴ� �� ������
fclose(fid);
subplot(4,2,7);plot(motion7);axis([0 1000 -200 200]);

%��8ͨ��
FileName8_1 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\лԤ���������\��ָ\picture8.txt'];
x8 = textread(FileName8_1,'%f');         %��ȡ2ͨ��������
x8 = x8(40000:end); 
motion8 = x8(motion_begin:motion_end);          %��ȡԭʼ�źŶ�������Ϊ������
FileName8_2 = ['F:\�ֻ�С�鹤��\����\��������ദ��\19.1.2���ݲɼ�\л���ƶηָ�\��ָ\��8ͨ��\',num2str(picture_N),'.txt'];
fid=fopen(FileName8_2,'w');
fprintf(fid,' %f\n',motion8);             %����Ԥ���������ݶεĴ� �� ������
fclose(fid);
subplot(4,2,8);plot(motion8);axis([0 1000 -200 200]);

