%Ŀ�ģ��Բɼ��������ݽ�������Ԥ�������ֻ���8ͨ�����ݣ�
%���ã�ȥ��ʱ�����
%      ȥֱ��������
%      ȥ����Ư�ƣ�
%      ȥ��Ƶ�źţ�kaiser���˲�����
clear all;clc;close all;
fs = 1000;

for i=1:8          %ѭ������8��ͨ��������
    %����16�������ݣ����ҽ�16����ת��Ϊ10���ƣ���������datadec��
    FileName1 = ['..\data\л����\ԭʼ����\ʳָ\picture',num2str(i),'.txt'];
    datahex = textread(FileName1,'%s');           
    datadec = hex2dec(datahex);     
    
    %ȥ���ź��е�ʱ���
    i2=1;
    data_N = length(datadec);               % ����ԭʼ�źŵ����ݸ���
    data_n = data_N-ceil(data_N/11);        % data_N - ����ȡ������ʱ����ĸ��� = ȥ��ʱ��������ݵĸ���
    data = 1:data_n;                        % ����ȥʱ������ԭʼ��������data�Ŀռ�
    for i1=1:data_N                         % һ�����ݣ�1��ʱ���+10������=��11������
        c=mod(i1,11);                       % ��i1����11��������
        if c~=1                             % ��������ݲ���ʱ����������ݴ�������data,���Ҽ���i2
            data(i2)=datadec(i1);
            i2=i2+1;
        end
    end
    figure(i);
    subplot(4,1,1);plot(data);title('ԭʼ�ź�');xlabel('ʱ����');ylabel('��ֵ');
    
    %ȥֱ������
    data = data - mean(data);
    subplot(4,1,2);plot(data);title('ȥֱ���ź�');xlabel('ʱ����');ylabel('��ֵ');
    
    %ȥ����Ư��
    data_p = data(1:end);%������ת����������
    N_p = length(data_p);
    t_p = (0:N_p-1)/fs;
    a = polyfit(t_p,data_p,6); %pΪ�ݴδӸߵ��͵Ķ���ʽϵ������������s��������Ԥ��ֵ��������
    ztrend = polyval(a,t_p); %���ض�Ӧ�Ա���t�ڸ���ϵ��p�Ķ���ʽ��ֵ
    data_p = data_p-ztrend; %��ü�����0���ģ����߽����������
    subplot(4,1,3);plot(t_p,data_p);axis([10 20 -400 400]);title('ȥ����Ư��');xlabel('ʱ����');ylabel('��ֵ');
    
    % kaiser���˲�
    As = 50;Fs = 1000;Fs2 = Fs/2;               %�����С˥���Ͳ���Ƶ��
    fs1 = 53;fs2 = 56;                          %���Ƶ��
    fp1 = 49;fp2 = 60 ;                         %ͨ��Ƶ��
    df = min(fs1-fp1,fp2-fs2);                  %����ɴ���
    M = round((As-7.95)/(14.36*df/Fs))+2;       %���㿭�󴰳�
    M = M+mod(M+1,2);                           %��֤����Ϊ����
    wp1 = fp1/Fs2*pi;wp2 = fp2/Fs2*pi;          %ת���ɹ�һ��ԲƵ��
    ws1 = fs1/Fs2*pi;ws2 = fs2/Fs2*pi;
    wc1 = (wp1+ws1)/2;wc2 = (wp2+ws2)/2;        %���ֹƵ��
    beta = 0.5842*(As-21)^0.4+0.07886*(As-21);  %���󴰵���һ�������£���ֵ��Asȡֵ��Χ��ͬ����ʽ��ͬ
    fprintf('beta=%5.6f\n',beta);
    M = M-1;                                    %�״�=����-1
    b = fir1(M,[wc1 wc2]/pi,'stop',kaiser(M+1,beta)); %����FIR�˲���ϵ��
    [h,w] = freqz(b,1,4000);                    %���ֵ��Ƶ����Ӧ
    db = 20*log10(abs(h));

    N1 = length(data_p);                           %����źų���
    t1 = (0:N1-1)/fs;                            %����ʱ��
    y = conv(b,data_p);                            %FIR�����˲������Ϊy
    data_k = y(M/2+1:end-M/2);                        %����conv�������˲�������ӳٵ�Ӱ��
    subplot(4,1,4);plot(t1,data_k);axis([10 20 -200 600]);title('kaiser���˲�');xlabel('ʱ����');ylabel('��ֵ');
    
    % ��Ԥ���������ݴ����ı��ļ�
    FileName2 = ['..\data\л����\Ԥ���������\ʳָ\picture',num2str(i),'.txt'];
    fid=fopen(FileName2,'w');
    fprintf(fid,' %f\n',data_k);
    fclose(fid);
    
  
    figure(9);
    subplot(8,1,i);plot(t1,data_k);axis([10 20 -300 300]);title('kaiser���˲�');xlabel('ʱ����');ylabel('��ֵ');
    
end
