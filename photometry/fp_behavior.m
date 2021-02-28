function [behavior] = fp_behavior(meta_in)

[acc,omi,prm] = deal(nan(max(meta_in(:,2)), max(meta_in(:,6))));

for rat = 1:max(meta_in(:,2))
    for subspec = 1:max(meta_in(:,6))
        
        cfi = meta_in(meta_in(:,2)==rat & meta_in(:,3)== 1 & meta_in(:,6)==subspec,:);
    
        
        acc(rat,subspec) = 100*sum(cfi(:,5)==1)/sum(cfi(:,5)<3);
        
        omi(rat,subspec) = 100*sum(cfi(:,5)==3)/size(cfi,1);
        
        prm(rat,subspec) = 100*sum(cfi(:,5)==4)/size(cfi,1);
    
    end
end

behavior.acc = acc;
behavior.omi = omi;
behavior.prm = prm;

end