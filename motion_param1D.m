%�������ƣ�motion_param1D
%�������ܣ���һ������dst1����������ȡ�����˵��λ��
%��    ����dst1-- �����жϵĲ������˴�ָ����
%          T2---- ��ֵ1������T2�϶��Ƕ���
%          T1---- ��ֵ2,��dst1��ʲôʱ������ڻ����T1���ж϶����źŵĶ˵�
%�� �� ֵ�� voiceseg-- ��Ŷ����˵����Ϣ
%           vs1-- �����εĸ���
%           SF��NF--  �����ж�����֡�Ƿ�Ϊ�ж���֡

function [voiceseg,vs1,SF,NF] = mmotion_param1D(dst1,T1,T2)

fn = size(dst1,2);                       %ȡ��֡��

%  ��ʼ��
maxsilence = 1;                          %һ�ζ�������ʱ��ֹ������С����--֡��
minlen = 3;                              %��ʾ�����ε���С����
status = 0;                              %��¼�����ε�״̬��0-���� 1-���ܿ�ʼ 2-������ 3-��������
count = 0;                               %�������еĳ���
silence = 0;                             %�޶����ĳ���

%  ��ʼ�˵���
xn = 1;     %�Եڼ����������м���
for n=2:fn
    switch status
        case {0,1}                       %0 = ������1=���ܿ�ʼ
            if dst1(n) > T2              %ȷ�Ž��붯����
                x1(xn) = max(n-count(xn)-1,1); %��¼�����ε���ʼ��
                status = 2;
                silence(xn) = 0;
                count(xn) = count(xn) + 1;
            elseif dst1(n) > T1          %���ܴ��ڶ�����  %%elseif--ֻҪ���㣬֮���elseif�Ͳ����ж�
                status = 1;        
                count(xn) = count(xn) + 1;
            else                         %�޶���״̬
                status = 0;
                count(xn) = 0;
                x1(xn) = 0;
                x2(xn) = 0;
            end
        case 2,                           %2 = ������
            if dst1(n) > T1               %�����ڶ�����
                count(xn) = count(xn)+1;
                silence(xn) = 0;
            else                             %����������
                silence(xn) = silence(xn)+1;
                if silence(xn) < maxsilence  %�޶���������������δ����
                    count(xn) = count(xn)+1;
                elseif count(xn) < minlen    %��������̫�̣���Ϊ������
                    status = 0;
                    silence(xn) = 0;
                    count(xn) = 0;
                else                          %��������
                    status = 3;
                    x2(xn) = x1(xn)+count(xn);                   
                end
            end
        case 3,                              %����������Ϊ��һ������׼��
            status = 0;
            xn = xn+1;
            count(xn) = 0;
            silence(xn) = 0;
            x1(xn) = 0;
            x2(xn) = 0;
    end
end

% �Զ����εĸ������м��������x1��ʵ�ʳ���
e1 = length(x1);
if x1(e1) == 0,
    e1 = e1-1;
end

% ���û�ж����Σ��˳�����
if e1 == 0,
    return;
end

if x2(e1) == 0       %��������յ���������һ��ֵΪ0����������Ϊfn
    fprintf('Error:Not find endint point!\n');
    x2(e1) = fn;
end

%SF=1--��ʾ��֡Ϊ�ж���֡           SF=0--��ʾ��֡Ϊ�޶���֡
%NF=1--��ʾ��֡Ϊ�޶���֡������֡��  NF=0--��ʾ��֡Ϊ�ж���֡
% ��x1��x2,��SF��NF��ֵ
SF = zeros(1,fn);    %���� 1��fn ��ȫ0����
NF = ones(1,fn);     %���� 1��fn ��ȫ1����
% �ж������źŵ�ÿһ֡�Ƿ�Ϊ�ж���֡
for i=1:e1
    SF(x1(i):x2(i))=1;  %��ʾSF�����е�Ԫ�ش�x1(i)��x2(i)����ֵΪ1
    NF(x1(i):x2(i))=0;  %��ʾNF�����е�Ԫ�ش�x1(i)��x2(i)����ֵΪ0
end

% ����voiceseg
speechIndex = find(SF==1);           %Ѱ�ҳ�SF����ֵ��1�ĵ�ַ
voiceseg = findSegment(speechIndex); %findSegment�����Ǹ���SF����ֵΪ1�ĵ�ַ��ϳ�ÿһ���ж����εĿ�ʼʱ���أ�����ʱ�䣬�������ж����ζ����ĳ���
vs1 = length(voiceseg);




    
    
    
    
    
    
    
    