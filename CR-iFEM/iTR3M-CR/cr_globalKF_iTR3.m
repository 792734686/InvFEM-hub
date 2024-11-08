function [GK,GF] = cr_globalKF_iTR3(NXY,NXY0,ELEM,Eep,Eep2,EELM,t,Ndsp)
n=size(NXY,1);
GK = zeros(6*n,6*n);
GF = zeros(6*n,1);
n=size(ELEM,1);
NXY(:,2:4) = NXY(:,2:4)+Ndsp(:,2:4);
NXY0 = NXY0(:,2:4);
RXY = Ndsp(:,5:7);
for i=1:n
    if ismember(i,EELM)
        we = 1;
        wk = 1;
        wg = 1e-4;
        Eepi = Eep(i,:)';
    else
        we = 1e-4;
        wk = 1e-4;
        wg = 1e-4;
        Eepi = Eep2(i,:)';
    end
    NN = ELEM(i,2:end); %第i个单元的节点号向量，节点1|2|3
    ENC = [NXY(NN,2),NXY(NN,3),NXY(NN,4)];    %返回第i个单元的3个节点坐标，[xi|yi|zi]
    ENC0 = [NXY0(NN,1),NXY0(NN,2),NXY0(NN,3)];
    Rxy = [RXY(NN,1),RXY(NN,2),RXY(NN,3)]';%结点转动（全局坐标系,列）
    %Thetaxy 结点转动（单元坐标系,列）
    %NUxy 结点位移（全局坐标系，列）
    [EK,EF] = cr_elementKF_iTR3(ENC,ENC0,Eepi,we,wk,wg,t,Rxy);
    % ------------------------------------------------------------------
    n1 = NN(1);
    n2 = NN(2);
    n3 = NN(3);
    F = zeros(6*size(NXY,1),1);
    F(6*n1-5:6*n1) = EF(1:6);
    F(6*n2-5:6*n2) = EF(7:12);
    F(6*n3-5:6*n3) = EF(13:18);
    GF = GF+F;
    % ------------------------------------------------------------------
    for j=1:3   % 3 - number of node in an element
        for k=1:3   % 3 - number of node in an element
            jj = NN(j);
            kk = NN(k);
            GK(6*jj-5,6*kk-5) = GK(6*jj-5,6*kk-5) + EK(6*j-5,6*k-5);
            GK(6*jj-5,6*kk-4) = GK(6*jj-5,6*kk-4) + EK(6*j-5,6*k-4);
            GK(6*jj-5,6*kk-3) = GK(6*jj-5,6*kk-3) + EK(6*j-5,6*k-3);
            GK(6*jj-5,6*kk-2) = GK(6*jj-5,6*kk-2) + EK(6*j-5,6*k-2);
            GK(6*jj-5,6*kk-1) = GK(6*jj-5,6*kk-1) + EK(6*j-5,6*k-1);
            GK(6*jj-5,6*kk) = GK(6*jj-5,6*kk) + EK(6*j-5,6*k);
            %-------------------------------------------------------
            GK(6*jj-4,6*kk-5) = GK(6*jj-4,6*kk-5) + EK(6*j-4,6*k-5);
            GK(6*jj-4,6*kk-4) = GK(6*jj-4,6*kk-4) + EK(6*j-4,6*k-4);
            GK(6*jj-4,6*kk-3) = GK(6*jj-4,6*kk-3) + EK(6*j-4,6*k-3);
            GK(6*jj-4,6*kk-2) = GK(6*jj-4,6*kk-2) + EK(6*j-4,6*k-2);
            GK(6*jj-4,6*kk-1) = GK(6*jj-4,6*kk-1) + EK(6*j-4,6*k-1);
            GK(6*jj-4,6*kk) = GK(6*jj-4,6*kk) + EK(6*j-4,6*k);
            %-------------------------------------------------------
            GK(6*jj-3,6*kk-5) = GK(6*jj-3,6*kk-5) + EK(6*j-3,6*k-5);
            GK(6*jj-3,6*kk-4) = GK(6*jj-3,6*kk-4) + EK(6*j-3,6*k-4);
            GK(6*jj-3,6*kk-3) = GK(6*jj-3,6*kk-3) + EK(6*j-3,6*k-3);
            GK(6*jj-3,6*kk-2) = GK(6*jj-3,6*kk-2) + EK(6*j-3,6*k-2);
            GK(6*jj-3,6*kk-1) = GK(6*jj-3,6*kk-1) + EK(6*j-3,6*k-1);
            GK(6*jj-3,6*kk) = GK(6*jj-3,6*kk) + EK(6*j-3,6*k);
            %-------------------------------------------------------
            GK(6*jj-2,6*kk-5) = GK(6*jj-2,6*kk-5) + EK(6*j-2,6*k-5);
            GK(6*jj-2,6*kk-4) = GK(6*jj-2,6*kk-4) + EK(6*j-2,6*k-4);
            GK(6*jj-2,6*kk-3) = GK(6*jj-2,6*kk-3) + EK(6*j-2,6*k-3);
            GK(6*jj-2,6*kk-2) = GK(6*jj-2,6*kk-2) + EK(6*j-2,6*k-2);
            GK(6*jj-2,6*kk-1) = GK(6*jj-2,6*kk-1) + EK(6*j-2,6*k-1);
            GK(6*jj-2,6*kk) = GK(6*jj-2,6*kk) + EK(6*j-2,6*k);
            %-------------------------------------------------------
            GK(6*jj-1,6*kk-5) = GK(6*jj-1,6*kk-5) + EK(6*j-1,6*k-5);
            GK(6*jj-1,6*kk-4) = GK(6*jj-1,6*kk-4) + EK(6*j-1,6*k-4);
            GK(6*jj-1,6*kk-3) = GK(6*jj-1,6*kk-3) + EK(6*j-1,6*k-3);
            GK(6*jj-1,6*kk-2) = GK(6*jj-1,6*kk-2) + EK(6*j-1,6*k-2);
            GK(6*jj-1,6*kk-1) = GK(6*jj-1,6*kk-1) + EK(6*j-1,6*k-1);
            GK(6*jj-1,6*kk) = GK(6*jj-1,6*kk) + EK(6*j-1,6*k);
            %-------------------------------------------------------
            GK(6*jj,6*kk-5) = GK(6*jj,6*kk-5) + EK(6*j,6*k-5);
            GK(6*jj,6*kk-4) = GK(6*jj,6*kk-4) + EK(6*j,6*k-4);
            GK(6*jj,6*kk-3) = GK(6*jj,6*kk-3) + EK(6*j,6*k-3);
            GK(6*jj,6*kk-2) = GK(6*jj,6*kk-2) + EK(6*j,6*k-2);
            GK(6*jj,6*kk-1) = GK(6*jj,6*kk-1) + EK(6*j,6*k-1);
            GK(6*jj,6*kk) = GK(6*jj,6*kk) + EK(6*j,6*k);
            %-------------------------------------------------------
        end
    end
end
end