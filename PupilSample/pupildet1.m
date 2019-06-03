% ���ͫ������
% ������ 10��27��
% ����thresh����ֿվ������
% thresh=0����ּ�⵽������BUG
clc; clear; close all;
% ͼƬ�ֱ���: 480 x 640
resw = 480; resh = 640;
% �˹����ڵ�ͫ�׿��ܳ��ַ�Χ
ROIx = 100; ROIy = 120; ROIw = 350; ROIh = 240;
% �Ƚϵ���߶���С��ֵ
maxLenThresh = 10;
for x = 9
    % ��ȡͼƬRGB����
    eyeRGB = imread([num2str(x), '.jpg']);
    % �����۲�����ͷ�Ѿ���Ϊ�Ҷ�ͼ�����ֱ�ӳ�ȡһ��
    eye = eyeRGB(:,:,1);
    % ������ֵ���ͻ��ͫ�׵Ķ�ֵͼ
    eyeBin = eye < 30;
%     eyeBin = ~eyeBin; % ������,����۲�
%     figure('Name','Binary Image')
    % ͼƬ��ʾ:1��ɫ,0��ɫ
%     imshow(eyeBin);
%     rectangle('position',[ROIx,ROIy,ROIw,ROIh],'EdgeColor','red');
    
    % ��ȡROI����ͫ�׿��ܳ��ַ�Χ��
    eyeROI = eyeBin( ROIy:ROIy+ROIh,ROIx:ROIx+ROIw);
    % ��ʾ��ֵͼ
    figure('Name','ROI Binary Image');
    % ͼƬ��ʾ:true��ɫ,false��ɫ
    imshow(eyeROI);
    
    % ɨ�����������߶�λ���볤��
    % ��ʼ��[y����,x��ʼ����,����]
    statH = zeros(ROIh,3);
    for h = 1:ROIh
        % ǰһ��Ϊ0��־λ
        isFore0 = true;
        % ����ѡ�����ֵ�ıȽ���ʱ����
        tmpMaxLen = maxLenThresh;
        for w = 1:ROIw
            if eyeROI(h,w) == true && isFore0 == true
                startX = w;
                 isFore0 = false;
            elseif eyeROI(h,w) == false && isFore0 == false
%                 endX = [h,w]; % ע��˵�Ϊfalse
                isFore0 = true;
                len = w - startX;
                if len > tmpMaxLen
                    % �Ƚ����ջ�ô�����߶�
                    statH(h,:) = [h,startX,len];
                end;
            end;
        end;
    end;
    % �������߶�
    [maxLenH,indexH] = max(statH(:,3));
    rectangle('position',[statH(indexH,2),statH(indexH,1),maxLenH,0],'EdgeColor','red');
    
    % ɨ������������߶�λ���볤��
    scanStartX = statH(indexH,2);
    % ��ʼ��[x����,y��ʼ����,����]
    statW = zeros(maxLenH,3);
    for w = 1:maxLenH
        % ǰһ��Ϊ0��־λ
        isFore0 = true;
        % ����ѡ�����ֵ�ıȽ���ʱ����
        tmpMaxLen = maxLenThresh;
        for h = 1:ROIh
            if eyeROI(h,w+scanStartX) == true && isFore0 == true
                startY = h;
                 isFore0 = false;
            elseif eyeROI(h,w+scanStartX) == false && isFore0 == false
%                 endX = [h,w]; % ע��˵�Ϊfalse
                isFore0 = true;
                len = h - startY;
                if len > tmpMaxLen
                    % �Ƚ����ջ�ô�����߶�
                    statW(w,:) = [w,startY,len];
                end;
            end;
        end;
    end;
    % �������߶�
    [maxLenW,indexW] = max(statW(:,3));
    rectangle('position',[statW(indexW,1)+scanStartX,statW(indexW,2),0,maxLenW],'EdgeColor','red');
    
    % ��ú������߶��е��ۺ�����
    irisX = statH(indexH,2)+maxLenH/2;
    irisY = statW(indexW,2)+maxLenW/2;
    % ���ͫ���е�
    crossSize = 40;
    rectangle('position',[irisX-crossSize/2,irisY,crossSize,0],'EdgeColor','blue');
    rectangle('position',[irisX,irisY-crossSize/2,0,crossSize],'EdgeColor','blue');
    
end;