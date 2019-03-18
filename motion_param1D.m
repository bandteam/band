%函数名称：motion_param1D
%函数功能：按一个参数dst1（能量）提取语音端点的位置
%参    数：dst1-- 用来判断的参数，此处指能量
%          T2---- 阈值1，高于T2肯定是动作
%          T1---- 阈值2,从dst1在什么时候起高于或低于T1来判断动作信号的端点
%返 回 值： voiceseg-- 存放动作端点的信息
%           vs1-- 动作段的个数
%           SF、NF--  用来判断所有帧是否为有动作帧

function [voiceseg,vs1,SF,NF] = mmotion_param1D(dst1,T1,T2)

fn = size(dst1,2);                       %取得帧数

%  初始化
maxsilence = 1;                          %一段动作结束时静止区的最小长度--帧数
minlen = 3;                              %表示动作段的最小长度
status = 0;                              %记录动作段的状态：0-静音 1-可能开始 2-动作段 3-动作结束
count = 0;                               %动作序列的长度
silence = 0;                             %无动作的长度

%  开始端点检测
xn = 1;     %对第几个动作进行计数
for n=2:fn
    switch status
        case {0,1}                       %0 = 静音，1=可能开始
            if dst1(n) > T2              %确信进入动作段
                x1(xn) = max(n-count(xn)-1,1); %记录动作段的起始点
                status = 2;
                silence(xn) = 0;
                count(xn) = count(xn) + 1;
            elseif dst1(n) > T1          %可能处于动作段  %%elseif--只要满足，之后的elseif就不再判断
                status = 1;        
                count(xn) = count(xn) + 1;
            else                         %无动作状态
                status = 0;
                count(xn) = 0;
                x1(xn) = 0;
                x2(xn) = 0;
            end
        case 2,                           %2 = 动作段
            if dst1(n) > T1               %保持在动作段
                count(xn) = count(xn)+1;
                silence(xn) = 0;
            else                             %动作将结束
                silence(xn) = silence(xn)+1;
                if silence(xn) < maxsilence  %无动作还不够长，尚未结束
                    count(xn) = count(xn)+1;
                elseif count(xn) < minlen    %动作长度太短，认为是噪声
                    status = 0;
                    silence(xn) = 0;
                    count(xn) = 0;
                else                          %动作结束
                    status = 3;
                    x2(xn) = x1(xn)+count(xn);                   
                end
            end
        case 3,                              %动作结束，为下一个动作准备
            status = 0;
            xn = xn+1;
            count(xn) = 0;
            silence(xn) = 0;
            x1(xn) = 0;
            x2(xn) = 0;
    end
end

% 对动作段的个数进行计数，获得x1的实际长度
e1 = length(x1);
if x1(e1) == 0,
    e1 = e1-1;
end

% 如果没有动作段，退出程序
if e1 == 0,
    return;
end

if x2(e1) == 0       %如果动作终点数组的最后一个值为0，对它设置为fn
    fprintf('Error:Not find endint point!\n');
    x2(e1) = fn;
end

%SF=1--表示该帧为有动作帧           SF=0--表示该帧为无动作帧
%NF=1--表示该帧为无动作帧（噪声帧）  NF=0--表示该帧为有动作帧
% 按x1和x2,对SF和NF赋值
SF = zeros(1,fn);    %生成 1×fn 的全0数组
NF = ones(1,fn);     %生成 1×fn 的全1数组
% 判断所有信号的每一帧是否为有动作帧
for i=1:e1
    SF(x1(i):x2(i))=1;  %表示SF数组中的元素从x1(i)到x2(i)都赋值为1
    NF(x1(i):x2(i))=0;  %表示NF数组中的元素从x1(i)到x2(i)都赋值为0
end

% 计算voiceseg
speechIndex = find(SF==1);           %寻找出SF中数值是1的地址
voiceseg = findSegment(speechIndex); %findSegment函数是根据SF中数值为1的地址组合出每一组有动作段的开始时间呢，结束时间，和这组有动作段动作的长度
vs1 = length(voiceseg);




    
    
    
    
    
    
    
    