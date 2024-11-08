function theta = Array_by_Quaternions(R)
a = max([trace(R),R(1,1),R(2,2),R(3,3)]);
if a == trace(R)
    Q = 0.5*(1+a)^0.5;
    q1 = 0.25*(R(3,2)-R(2,3))/Q;
    q2 = 0.25*(R(1,3)-R(3,1))/Q;
    q3 = 0.25*(R(2,1)-R(1,2))/Q;
elseif a == R(1,1)
    q1 = (0.5*a+0.25*(1-trace(R)))^0.5;
    Q = 0.25*(R(3,2)-R(2,3))/q1;
    q2 = 0.25*(R(2,1)-R(1,2))/q1;
    q3 = 0.25*(R(3,1)-R(1,3))/q1;
elseif a == R(2,2)
    q2 = (0.5*a+0.25*(1-trace(R)))^0.5;
    Q = 0.25*(R(1,3)-R(3,1))/q2;
    q3 = 0.25*(R(3,2)-R(2,3))/q2;
    q1 = 0.25*(R(1,2)-R(2,1))/q2;
else
    q3 = (0.5*a+0.25*(1-trace(R)))^0.5;
    Q = 0.25*(R(2,1)-R(1,2))/q3;
    q1 = 0.25*(R(1,3)-R(3,1))/q3;
    q2 = 0.25*(R(2,3)-R(3,2))/q3;
end
THETA = acos(Q);
if THETA == 0
    theta = 2/Q*[q1,q2,q3]';
else
    theta = 2*THETA/(Q*tan(THETA))*[q1,q2,q3]';
end
end