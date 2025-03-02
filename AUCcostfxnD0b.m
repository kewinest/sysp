function AUCcostout = AUCcostfxnD0b(x1, texp,yexp)

q0 = 0; % ug/hr
Dexp = 50; % ug/ml (will be * ml = ug)
kA = 5.941; % hr-1
kcL = x1(1);
V = x1(2);

[auc,t,y] = caffeinesimbc(q0, Dexp,kA,x1(1), x1(2));

        %texp = [0.5,1,2,4,8];
        %yexp = [10,18,18,12,4];

        for j=1:length(texp)
            teval = abs(t-texp(j));
            [tmin tindex] = min(teval);
            AUCcostout(j) = y(tindex) - yexp(j);
        end

end

