function [Ndsp, iterations,converged] = NR_Solver_iBEAM3CR(Nxy,NOD_ROT,ELEM,EELM,E,E2,tol,max_iter,NSTP,load_factor)
    x = zeros(6*size(Nxy,1),1);
    iterations = 0;
    Nxy0 = Nxy;
    Ndsp = zeros(size(Nxy,1),7);
    Rxy = zeros(size(Nxy,1),3)';
    bar = waitbar(0,'waiting for solving...');
    converged = true;
    E = load_factor*E;
    E2 = load_factor*E2;
    
    while iterations < max_iter
        
        [Jx,fx] = cr_globalKF_iBEAM3(Nxy,Nxy0,ELEM,E,E2,EELM,Ndsp,NOD_ROT);
        %-------------- 边界条件 -------------------
        FIX = importdata('fix.txt');
        SUP = importdata('SUP.txt');
%         BOUND = importdata('bound.txt');
%         XSYMM = importdata('xsymm.txt');
%         YSYMM = importdata('ysymm.txt');
%         ZSYMM = importdata('zsymm.txt');
%         U2 = importdata('u2.txt');
        [Jx,fx] = boundary(FIX,[1,2,3],Jx,fx);
        [Jx,fx] = boundary(SUP,[2,3],Jx,fx);
%         [Jx,fx] = boundary(BOUND,[1,2,4,5],Jx,fx);
%         [Jx,fx] = boundary(XSYMM,[1,5,6],Jx,fx);
%         [Jx,fx] = boundary(YSYMM,[2,4,6],Jx,fx);
%         [Jx,fx] = boundary(ZSYMM,[3,4,5],Jx,fx);
%         [Jx,fx] = boundary(U2,2,Jx,fx);
        %-------------------------------------------
        if rcond(Jx) <= 1e-16
            converged = false;
            break
        end
        Jx = sparse(Jx);
        delta_x =Jx \ fx;
        x = x + delta_x;
        Ndsp = [Nxy(:,1),Ulin_to_mat(x,6)];
        DRxy = Ulin_to_mat(delta_x,6)';
        DRxy = DRxy(4:6,:);% 结点转动增量（全局坐标，列）
        Rxy = RotMat_node(Rxy,DRxy); %结点转动向量（全局坐标，列）
        Ndsp(:,5:7) = Rxy';
        x = Umat_to_lin(Ndsp(:,2:7));
        
        tolerance = tol;
        
        if norm(delta_x)/norm(x) < tolerance
            waitbar(1,bar,'Solve Succeed!');
            break;
        end
        
        iterations = iterations + 1;
        waitbar(iterations/max_iter,bar,['Solving...',' Step = ',num2str(NSTP),'Interations = ',num2str(iterations)]);
    end
    
    if iterations == max_iter
        converged = false;
    elseif converged == true
        disp(['Step- ',num2str(NSTP),' Solve Succeed.iters = ',num2str(iterations),', Load Factor = ',num2str(load_factor)]);
        converged = true;
    end
    close(bar);
end
