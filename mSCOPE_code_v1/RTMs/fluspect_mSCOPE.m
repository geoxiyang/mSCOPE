function [leafopt]=fluspect_mSCOPE(mly,spectral,leafbio,optipar)
        % leaf reflectance, transmittance and the excitation-fluorescence matrices calculation
        % for 60 sublayers
        indStar =[1,floor(cumsum(mly.pLAI/sum(mly.pLAI))*60)];  % index of starting for each different layer
        % XY made a change to address the issue that sometimes indStar ends
        % with 59 even when cumsum(mly.pLAI/sum(mly.pLAI)) == 1 in the last
        % element -- could be related to the precision
        if indStar(end) == 59
            indStar(end) = 60;
        end
        for i=1:mly.nly
            leafbio.Cab     =   mly.pCab(i);
            leafbio.Cw      =   mly.pCw(i);
            leafbio.Cca     =   mly.pCca(i);
            leafbio.Cdm     =   mly.pCdm(i);
            leafbio.Cs      =   mly.pCs(i);
            leafbio.N       =   mly.pN(i);
            [leafopt_ml]    =   fluspect_bcar(spectral,leafbio,optipar);
            leafopt.refl(i,:)       = leafopt_ml.refl;
            leafopt.tran(i,:)       = leafopt_ml.tran;
            leafopt.MbI(:,:,i)      = leafopt_ml.MbI;
            leafopt.MbII(:,:,i)     = leafopt_ml.MbII;
            leafopt.MfI(:,:,i)      = leafopt_ml.MfI;
            leafopt.MfII(:,:,i)     = leafopt_ml.MfII;
            leafopt.kChlrel(i,:)    = leafopt_ml.kChlrel;
            
            in1= indStar(i);
            in2= indStar(i+1);    
            rho_temp(in1:in2,:)    = repmat(leafopt.refl(i,:),in2-in1+1,1);        % [60,nwl]        leaf/needle reflection
            tau_temp(in1:in2,:)    = repmat(leafopt.tran(i,:),in2-in1+1,1);        % [60,nwl]        leaf/needle transmission
            MbI(:,:,in1:in2)       = repmat(leafopt.MbI(:,:,i),[1,1,in2-in1+1]);
            MbII(:,:,in1:in2)      = repmat(leafopt.MbII(:,:,i),[1,1,in2-in1+1]);
            MfI(:,:,in1:in2)       = repmat(leafopt.MfI(:,:,i),[1,1,in2-in1+1]);
            MfII(:,:,in1:in2)      = repmat(leafopt.MfII(:,:,i),[1,1,in2-in1+1]);
            kChlrel_temp(in1:in2,:)= repmat(leafopt.kChlrel(i,:),in2-in1+1,1);
        end
        leafopt.refl=rho_temp;
        leafopt.tran=tau_temp;
        leafopt.kChlrel = kChlrel_temp;
        leafopt.MbI=MbI;
        leafopt.MbII=MbII;
        leafopt.MfI=MfI;
        leafopt.MfII=MfII;